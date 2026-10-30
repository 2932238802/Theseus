use std::{
    sync::{
        Arc,
        atomic::{AtomicBool, Ordering},
    },
    time::{Duration, Instant},
};

use backend_rust::{
    config::Config,
    db::pool::create_pool,
    judge::{
        compare::values_match,
        queue::{self, ClaimedEntry},
        run_config::{normalize_for_compare, validate_input},
        runner::{SandboxConfig, SandboxOutcome, SandboxSession, SandboxStart, program_for},
    },
    models::{
        run::{
            CodeRunRow, RUN_STATUS_COMPILE_ERROR, RUN_STATUS_COMPILING, RUN_STATUS_COMPLETED,
            RUN_STATUS_INTERNAL_ERROR, RUN_STATUS_MEMORY_LIMIT_EXCEEDED, RUN_STATUS_RUNNING,
            RUN_STATUS_RUNTIME_ERROR, RUN_STATUS_TIME_LIMIT_EXCEEDED, RunCaseResult, RunConfig,
            is_terminal_status,
        },
        submission::{
            SUBMISSION_STATUS_ACCEPTED, SUBMISSION_STATUS_COMPILE_ERROR,
            SUBMISSION_STATUS_INTERNAL_ERROR, SUBMISSION_STATUS_JUDGING,
            SUBMISSION_STATUS_MEMORY_LIMIT_EXCEEDED, SUBMISSION_STATUS_RUNTIME_ERROR,
            SUBMISSION_STATUS_TIME_LIMIT_EXCEEDED, SUBMISSION_STATUS_WRONG_ANSWER, SubmissionRow,
            is_terminal_status as is_terminal_submission_status,
        },
    },
    services::{
        run_service::{
            CachedRunStatus, RunTerminalUpdate, claim_run, fetch_run_row, finish_run,
            increment_attempt, mark_internal_error, mark_running, parse_run_config,
            release_user_lock, write_status_cache,
        },
        submission_service::{
            CachedSubmissionStatus, SubmissionTerminalUpdate, claim_submission,
            fetch_submission_row, finish_submission,
            increment_attempt as increment_submission_attempt, judge_cases,
            mark_internal_error as mark_submission_internal_error, parse_snapshots,
            release_user_lock as release_submission_lock, validate_judge_set,
            write_status_cache as write_submission_status_cache,
        },
    },
};
use redis::aio::ConnectionManager;
use serde_json::{Value, json};
use sqlx::PgPool;
use tokio::sync::Semaphore;

const CASE_TIMEOUT: Duration = Duration::from_secs(2);
const RUN_TIMEOUT: Duration = Duration::from_secs(10);
const CLAIM_MIN_IDLE_MS: u64 = 120_000;
const CLAIM_COUNT: usize = 10;
const HEARTBEAT_INTERVAL: Duration = Duration::from_secs(10);
const HEARTBEAT_TTL_SECONDS: u64 = 30;
const SHUTDOWN_GRACE: Duration = Duration::from_secs(60);

type CasePlan = (Vec<Value>, Option<Value>);

#[derive(Clone)]
struct Sandboxes {
    python: SandboxConfig,
    node: SandboxConfig,
    cpp: SandboxConfig,
    java: SandboxConfig,
}

impl Sandboxes {
    fn for_language(&self, language: &str) -> Option<&SandboxConfig> {
        match language {
            "python" => Some(&self.python),
            "javascript" => Some(&self.node),
            "cpp" => Some(&self.cpp),
            "java" => Some(&self.java),
            _ => None,
        }
    }
}

#[derive(Clone)]
struct WorkerContext {
    pool: PgPool,
    sandboxes: Sandboxes,
    config: Arc<Config>,
    sandbox_permits: Arc<Semaphore>,
    stop: Arc<AtomicBool>,
}

#[tokio::main]
async fn main() -> Result<(), Box<dyn std::error::Error>> {
    dotenvy::dotenv().ok();
    tracing_subscriber::fmt()
        .with_env_filter(tracing_subscriber::EnvFilter::from_default_env())
        .init();

    let config = Config::from_env()?;
    let pool = create_pool(&config.database_url).await?;
    let mut redis = queue::connect(&config.redis_url).await?;
    queue::ensure_group(&mut redis, &config.run_stream, &config.run_consumer_group).await?;
    if config.submit_judge_enabled {
        queue::ensure_group(
            &mut redis,
            &config.submit_stream,
            &config.submit_consumer_group,
        )
        .await?;
    }
    if config.run_sandbox_runtime != "runsc" {
        tracing::warn!(
            runtime = %config.run_sandbox_runtime,
            "sandbox runtime is not runsc; only use this for local development"
        );
    }
    tracing::info!(
        worker = %config.run_worker_name,
        stream = %config.run_stream,
        group = %config.run_consumer_group,
        concurrency = config.run_worker_concurrency,
        submit_enabled = config.submit_judge_enabled,
        submit_stream = %config.submit_stream,
        "judge worker started"
    );

    let sandboxes = Sandboxes {
        python: sandbox_config(&config, &config.run_image_python, 256),
        node: sandbox_config(&config, &config.run_image_node, 256),
        cpp: sandbox_config(&config, &config.run_image_cpp, 256),
        java: sandbox_config(&config, &config.run_image_java, 512),
    };
    let stop = Arc::new(AtomicBool::new(false));
    let sandbox_permits = Arc::new(Semaphore::new(config.run_worker_concurrency));
    let context = WorkerContext {
        pool,
        sandboxes,
        config: Arc::new(config),
        sandbox_permits,
        stop: stop.clone(),
    };

    let mut tasks = tokio::task::JoinSet::new();
    for index in 0..context.config.run_worker_concurrency {
        let worker = context.clone();
        tasks.spawn(async move { consumer_loop(worker, index).await });
    }
    if context.config.submit_judge_enabled {
        for index in 0..context.config.run_worker_concurrency {
            let worker = context.clone();
            tasks.spawn(async move { submission_consumer_loop(worker, index).await });
        }
        let worker = context.clone();
        tasks.spawn(async move { submission_claimer_loop(worker).await });
    }
    {
        let worker = context.clone();
        tasks.spawn(async move { claimer_loop(worker).await });
    }
    {
        let worker = context.clone();
        tasks.spawn(async move { heartbeat_loop(worker).await });
    }

    let mut terminate = tokio::signal::unix::signal(tokio::signal::unix::SignalKind::terminate())?;
    tokio::select! {
        _ = tokio::signal::ctrl_c() => tracing::info!("judge worker received interrupt, stopping"),
        _ = terminate.recv() => tracing::info!("judge worker received SIGTERM, stopping"),
    }
    stop.store(true, Ordering::SeqCst);

    let drained = tokio::time::timeout(SHUTDOWN_GRACE, async {
        while tasks.join_next().await.is_some() {}
    })
    .await;
    if drained.is_err() {
        tracing::warn!("judge worker shutdown timeout, aborting in-flight tasks");
        tasks.abort_all();
    }
    tracing::info!("judge worker stopped");
    Ok(())
}

fn sandbox_config(config: &Config, image: &str, memory_mb: u32) -> SandboxConfig {
    SandboxConfig {
        image: image.to_owned(),
        runtime: config.run_sandbox_runtime.clone(),
        allow_runc: config.run_sandbox_allow_runc,
        memory_mb,
        compile_memory_mb: config.run_compile_memory_mb,
        compile_timeout: Duration::from_secs(config.run_compile_timeout_secs),
    }
}

async fn consumer_loop(context: WorkerContext, index: usize) {
    let consumer = format!("{}-{index}", context.config.run_worker_name);
    let mut redis = match queue::connect(&context.config.redis_url).await {
        Ok(connection) => connection,
        Err(error) => {
            tracing::error!(consumer = %consumer, error = %error, "consumer failed to connect Redis");
            return;
        }
    };
    while !context.stop.load(Ordering::SeqCst) {
        match queue::read_one(
            &mut redis,
            &context.config.run_stream,
            &context.config.run_consumer_group,
            &consumer,
            5000,
        )
        .await
        {
            Ok(Some((message_id, run_id))) => {
                if process_run(&context, &mut redis, run_id).await {
                    if let Err(error) = queue::ack(
                        &mut redis,
                        &context.config.run_stream,
                        &context.config.run_consumer_group,
                        &message_id,
                    )
                    .await
                    {
                        tracing::error!(run_id, error = %error, "failed to acknowledge run");
                    }
                } else {
                    tracing::warn!(
                        run_id,
                        "run left pending for retry after infrastructure error"
                    );
                }
            }
            Ok(None) => {}
            Err(error) => {
                tracing::error!(error = %error, "failed to read run queue");
                tokio::time::sleep(Duration::from_secs(1)).await;
            }
        }
    }
}

async fn claimer_loop(context: WorkerContext) {
    let consumer = format!("{}-claimer", context.config.run_worker_name);
    let mut redis = match queue::connect(&context.config.redis_url).await {
        Ok(connection) => connection,
        Err(error) => {
            tracing::error!(error = %error, "claimer failed to connect Redis");
            return;
        }
    };
    let interval = Duration::from_secs(context.config.run_claim_interval_secs);
    let mut cursor = "0-0".to_owned();
    while !context.stop.load(Ordering::SeqCst) {
        tokio::time::sleep(interval).await;
        if context.stop.load(Ordering::SeqCst) {
            break;
        }
        let claimed = queue::claim_stale(
            &mut redis,
            &context.config.run_stream,
            &context.config.run_consumer_group,
            &consumer,
            CLAIM_MIN_IDLE_MS,
            CLAIM_COUNT,
            &mut cursor,
        )
        .await;
        let claimed = match claimed {
            Ok(claimed) => claimed,
            Err(error) => {
                tracing::error!(error = %error, "failed to claim stale run messages");
                cursor = "0-0".to_owned();
                continue;
            }
        };
        for entry in claimed {
            handle_claimed(&context, &mut redis, entry).await;
        }
    }
}

async fn handle_claimed(
    context: &WorkerContext,
    redis: &mut ConnectionManager,
    entry: ClaimedEntry,
) {
    let row = match fetch_run_row(&context.pool, entry.run_id).await {
        Ok(row) => row,
        Err(error) => {
            tracing::warn!(run_id = entry.run_id, error = %error, "claimed run record missing");
            let _ = queue::ack(
                redis,
                &context.config.run_stream,
                &context.config.run_consumer_group,
                &entry.message_id,
            )
            .await;
            return;
        }
    };
    if is_terminal_status(&row.status) {
        tracing::info!(run_id = row.id, status = %row.status, "claimed run already terminal");
        let _ = queue::ack(
            redis,
            &context.config.run_stream,
            &context.config.run_consumer_group,
            &entry.message_id,
        )
        .await;
        return;
    }
    let attempt = match increment_attempt(&context.pool, row.id).await {
        Ok(attempt) => attempt,
        Err(error) => {
            tracing::error!(run_id = row.id, error = ?error, "failed to record retry attempt");
            return;
        }
    };
    if attempt > context.config.run_max_deliveries as i32 {
        tracing::error!(
            run_id = row.id,
            attempt,
            "run exceeded maximum deliveries, moving to dead stream"
        );
        let reason = format!(
            "任务重试超过 {} 次，已进入死信队列",
            context.config.run_max_deliveries
        );
        let _ = queue::enqueue_dead(redis, &context.config.run_dead_stream, row.id, &reason).await;
        mark_internal_error(&context.pool, row.id, &reason).await;
        cache_status(
            redis,
            &row,
            RUN_STATUS_INTERNAL_ERROR,
            0,
            row.case_total,
            Some(reason),
        )
        .await;
        release_user_lock(redis, row.user_id, row.id).await;
        let _ = queue::ack(
            redis,
            &context.config.run_stream,
            &context.config.run_consumer_group,
            &entry.message_id,
        )
        .await;
        return;
    }
    tracing::warn!(run_id = row.id, attempt, "recovered stale run message");
    if process_run(context, redis, row.id).await {
        let _ = queue::ack(
            redis,
            &context.config.run_stream,
            &context.config.run_consumer_group,
            &entry.message_id,
        )
        .await;
    } else {
        tracing::warn!(
            run_id = row.id,
            "recovered run left pending for another retry"
        );
    }
}

async fn submission_consumer_loop(context: WorkerContext, index: usize) {
    let consumer = format!("{}-submit-{index}", context.config.run_worker_name);
    let mut redis = match queue::connect(&context.config.redis_url).await {
        Ok(connection) => connection,
        Err(error) => {
            tracing::error!(consumer = %consumer, error = %error, "submission consumer failed to connect Redis");
            return;
        }
    };
    while !context.stop.load(Ordering::SeqCst) {
        match queue::read_one(
            &mut redis,
            &context.config.submit_stream,
            &context.config.submit_consumer_group,
            &consumer,
            5000,
        )
        .await
        {
            Ok(Some((message_id, raw_id))) => {
                let Some(submission_id) = i32::try_from(raw_id).ok() else {
                    tracing::warn!(raw_id, "ignoring submission message with out-of-range id");
                    let _ = queue::ack(
                        &mut redis,
                        &context.config.submit_stream,
                        &context.config.submit_consumer_group,
                        &message_id,
                    )
                    .await;
                    continue;
                };
                if process_submission(&context, &mut redis, submission_id).await {
                    if let Err(error) = queue::ack(
                        &mut redis,
                        &context.config.submit_stream,
                        &context.config.submit_consumer_group,
                        &message_id,
                    )
                    .await
                    {
                        tracing::error!(
                            submission_id,
                            error = %error,
                            "failed to acknowledge submission"
                        );
                    }
                } else {
                    tracing::warn!(
                        submission_id,
                        "submission left pending for retry after infrastructure error"
                    );
                }
            }
            Ok(None) => {}
            Err(error) => {
                tracing::error!(error = %error, "failed to read submission queue");
                tokio::time::sleep(Duration::from_secs(1)).await;
            }
        }
    }
}

async fn submission_claimer_loop(context: WorkerContext) {
    let consumer = format!("{}-submit-claimer", context.config.run_worker_name);
    let mut redis = match queue::connect(&context.config.redis_url).await {
        Ok(connection) => connection,
        Err(error) => {
            tracing::error!(error = %error, "submission claimer failed to connect Redis");
            return;
        }
    };
    let interval = Duration::from_secs(context.config.run_claim_interval_secs);
    let mut cursor = "0-0".to_owned();
    while !context.stop.load(Ordering::SeqCst) {
        tokio::time::sleep(interval).await;
        if context.stop.load(Ordering::SeqCst) {
            break;
        }
        let claimed = queue::claim_stale(
            &mut redis,
            &context.config.submit_stream,
            &context.config.submit_consumer_group,
            &consumer,
            CLAIM_MIN_IDLE_MS,
            CLAIM_COUNT,
            &mut cursor,
        )
        .await;
        let claimed = match claimed {
            Ok(claimed) => claimed,
            Err(error) => {
                tracing::error!(error = %error, "failed to claim stale submission messages");
                cursor = "0-0".to_owned();
                continue;
            }
        };
        for entry in claimed {
            handle_claimed_submission(&context, &mut redis, entry).await;
        }
    }
}

async fn handle_claimed_submission(
    context: &WorkerContext,
    redis: &mut ConnectionManager,
    entry: ClaimedEntry,
) {
    let Ok(submission_id) = i32::try_from(entry.run_id) else {
        tracing::warn!(
            raw_id = entry.run_id,
            "discarding claimed submission with out-of-range id"
        );
        let _ = queue::ack(
            redis,
            &context.config.submit_stream,
            &context.config.submit_consumer_group,
            &entry.message_id,
        )
        .await;
        return;
    };
    let row = match fetch_submission_row(&context.pool, submission_id).await {
        Ok(row) => row,
        Err(error) => {
            tracing::warn!(
                submission_id,
                error = %error,
                "claimed submission record missing"
            );
            let _ = queue::ack(
                redis,
                &context.config.submit_stream,
                &context.config.submit_consumer_group,
                &entry.message_id,
            )
            .await;
            return;
        }
    };
    if is_terminal_submission_status(&row.status) {
        tracing::info!(
            submission_id = row.id,
            status = %row.status,
            "claimed submission already terminal"
        );
        let _ = queue::ack(
            redis,
            &context.config.submit_stream,
            &context.config.submit_consumer_group,
            &entry.message_id,
        )
        .await;
        return;
    }
    let attempt = match increment_submission_attempt(&context.pool, row.id).await {
        Ok(attempt) => attempt,
        Err(error) => {
            tracing::error!(
                submission_id = row.id,
                error = ?error,
                "failed to record submission retry attempt"
            );
            return;
        }
    };
    if attempt > context.config.submit_max_deliveries as i32 {
        tracing::error!(
            submission_id = row.id,
            attempt,
            "submission exceeded maximum deliveries, moving to dead stream"
        );
        let reason = format!(
            "任务重试超过 {} 次，已进入死信队列",
            context.config.submit_max_deliveries
        );
        let _ = queue::enqueue_dead(
            redis,
            &context.config.submit_dead_stream,
            i64::from(row.id),
            &reason,
        )
        .await;
        mark_submission_internal_error(&context.pool, row.id, &reason).await;
        cache_submission_status(
            redis,
            &row,
            SUBMISSION_STATUS_INTERNAL_ERROR,
            0,
            row.total_test_cases,
            Some(reason),
        )
        .await;
        release_submission_lock(redis, row.user_id, i64::from(row.id)).await;
        let _ = queue::ack(
            redis,
            &context.config.submit_stream,
            &context.config.submit_consumer_group,
            &entry.message_id,
        )
        .await;
        return;
    }
    tracing::warn!(
        submission_id = row.id,
        attempt,
        "recovered stale submission message"
    );
    if process_submission(context, redis, row.id).await {
        let _ = queue::ack(
            redis,
            &context.config.submit_stream,
            &context.config.submit_consumer_group,
            &entry.message_id,
        )
        .await;
    } else {
        tracing::warn!(
            submission_id = row.id,
            "recovered submission left pending for another retry"
        );
    }
}

async fn heartbeat_loop(context: WorkerContext) {
    let key = queue::worker_heartbeat_key(&context.config.run_worker_name);
    let submit_key = queue::submit_worker_heartbeat_key(&context.config.run_worker_name);
    let mut redis = match queue::connect(&context.config.redis_url).await {
        Ok(connection) => connection,
        Err(error) => {
            tracing::error!(error = %error, "heartbeat failed to connect Redis");
            return;
        }
    };
    while !context.stop.load(Ordering::SeqCst) {
        queue::heartbeat(&mut redis, &key, HEARTBEAT_TTL_SECONDS).await;
        if context.config.submit_judge_enabled {
            queue::heartbeat(&mut redis, &submit_key, HEARTBEAT_TTL_SECONDS).await;
        }
        tokio::time::sleep(HEARTBEAT_INTERVAL).await;
    }
    queue::clear_heartbeat(&mut redis, &key).await;
    queue::clear_heartbeat(&mut redis, &submit_key).await;
}

/// Returns whether the queue message can be acknowledged. Infrastructure errors
/// return `false` so the message stays pending and can be recovered later.
async fn process_run(context: &WorkerContext, redis: &mut ConnectionManager, run_id: i64) -> bool {
    let row = match fetch_run_row(&context.pool, run_id).await {
        Ok(row) => row,
        Err(error) => {
            tracing::warn!(run_id, error = ?error, "run record not available");
            return false;
        }
    };
    if is_terminal_status(&row.status) {
        tracing::info!(run_id, status = %row.status, "run already terminal, skipping");
        return true;
    }
    let Some(sandbox) = context.sandboxes.for_language(&row.language) else {
        fail_run(&context.pool, redis, &row, "不支持的编程语言").await;
        return true;
    };
    if !matches!(row.mode.as_str(), "examples" | "custom") {
        fail_run(&context.pool, redis, &row, "运行模式无效").await;
        return true;
    }
    let run_config = match parse_run_config(&row) {
        Ok(config) => config,
        Err(error) => {
            fail_run(
                &context.pool,
                redis,
                &row,
                &format!("run_config 无效: {error}"),
            )
            .await;
            return true;
        }
    };
    let cases = match build_cases(&row, &run_config) {
        Ok(cases) => cases,
        Err(message) => {
            fail_run(&context.pool, redis, &row, &message).await;
            return true;
        }
    };
    let program = match program_for(&row.language, &row.code, &run_config) {
        Ok(program) => program,
        Err(error) => {
            fail_run(&context.pool, redis, &row, &error.to_string()).await;
            return true;
        }
    };
    let total = cases.len() as i32;
    match claim_run(&context.pool, run_id).await {
        Ok(true) => {}
        Ok(false) => {
            tracing::info!(run_id, "run was claimed by another worker or is terminal");
            return true;
        }
        Err(error) => {
            tracing::error!(run_id, error = ?error, "failed to claim run");
            return false;
        }
    }
    cache_status(redis, &row, RUN_STATUS_COMPILING, 0, total, None).await;

    let _permit = match context.sandbox_permits.clone().acquire_owned().await {
        Ok(permit) => permit,
        Err(_) => return false,
    };
    let mut session = match SandboxSession::start(sandbox, run_id, &program).await {
        Ok(SandboxStart::Ready(session)) => session,
        Ok(SandboxStart::CompileError { output }) => {
            finish_compile_error(&context.pool, redis, &row, total, &output).await;
            return true;
        }
        Err(error) => {
            tracing::error!(run_id, error = ?error, "failed to start sandbox, leaving run pending");
            return false;
        }
    };

    let _ = mark_running(&context.pool, run_id).await;
    cache_status(redis, &row, RUN_STATUS_RUNNING, 0, total, None).await;

    let started = Instant::now();
    let mut results = Vec::with_capacity(cases.len());
    let mut passed = 0i32;
    let mut first_error: Option<String> = None;
    for (index, (args, expected)) in cases.iter().enumerate() {
        let remaining = RUN_TIMEOUT.saturating_sub(started.elapsed());
        if remaining.is_zero() {
            if first_error.is_none() {
                first_error = Some("运行阶段超过 10 秒，剩余用例未执行".to_owned());
            }
            results.push(unrun_case(index as i32, args, expected));
            continue;
        }
        let outcome = match session.run_case(args, CASE_TIMEOUT.min(remaining)).await {
            Ok(outcome) => outcome,
            Err(error) => {
                session.shutdown().await;
                tracing::error!(
                    run_id,
                    error = ?error,
                    "sandbox execution failed, leaving run pending"
                );
                return false;
            }
        };
        let (case, matched, error) =
            build_case_result(index as i32, args, expected, &outcome, &run_config);
        if matched {
            passed += 1;
        }
        if first_error.is_none() {
            first_error = error;
        }
        results.push(case);
        cache_status(redis, &row, RUN_STATUS_RUNNING, passed, total, None).await;
    }
    session.shutdown().await;

    let status = aggregate_status(&results);
    let cases_value = json!(results);
    let runtime_ms = results
        .iter()
        .filter_map(|case| case.runtime_ms)
        .sum::<i32>();
    let memory_kb = results.iter().filter_map(|case| case.memory_kb).max();
    let error_message = if status == RUN_STATUS_COMPLETED {
        None
    } else {
        Some(match status {
            RUN_STATUS_TIME_LIMIT_EXCEEDED => {
                "单个用例执行超过 2 秒或运行阶段超过 10 秒".to_owned()
            }
            RUN_STATUS_MEMORY_LIMIT_EXCEEDED => "执行内存超过限制".to_owned(),
            _ => first_error.unwrap_or_else(|| "运行时错误".to_owned()),
        })
    };
    let updated = finish_run(
        &context.pool,
        run_id,
        RunTerminalUpdate {
            status,
            cases: &cases_value,
            case_total: total,
            case_passed: passed,
            compile_output: None,
            error_message: error_message.as_deref(),
            runtime_ms: Some(runtime_ms),
            memory_kb,
        },
    )
    .await;
    if updated.unwrap_or(false) {
        cache_status(redis, &row, status, passed, total, error_message.clone()).await;
    }
    release_user_lock(redis, row.user_id, run_id).await;
    tracing::info!(
        run_id,
        user_id = row.user_id,
        language = %row.language,
        mode = %row.mode,
        status,
        case_passed = passed,
        case_total = total,
        runtime_ms,
        "run finished"
    );
    true
}

async fn finish_compile_error(
    pool: &PgPool,
    redis: &mut ConnectionManager,
    row: &CodeRunRow,
    total: i32,
    output: &str,
) {
    let cases = json!([]);
    let updated = finish_run(
        pool,
        row.id,
        RunTerminalUpdate {
            status: RUN_STATUS_COMPILE_ERROR,
            cases: &cases,
            case_total: total,
            case_passed: 0,
            compile_output: Some(output),
            error_message: Some("编译失败"),
            runtime_ms: None,
            memory_kb: None,
        },
    )
    .await;
    if updated.unwrap_or(false) {
        cache_status(
            redis,
            row,
            RUN_STATUS_COMPILE_ERROR,
            0,
            total,
            Some("编译失败".to_owned()),
        )
        .await;
    }
    release_user_lock(redis, row.user_id, row.id).await;
    tracing::info!(run_id = row.id, "run failed to compile");
}

/// Judges a submission with the frozen run_config and hidden cases.
///
/// Returns whether the queue message can be acknowledged. Infrastructure
/// errors return `false` so the message stays pending for retry.
async fn process_submission(
    context: &WorkerContext,
    redis: &mut ConnectionManager,
    submission_id: i32,
) -> bool {
    let row = match fetch_submission_row(&context.pool, submission_id).await {
        Ok(row) => row,
        Err(error) => {
            tracing::warn!(submission_id, error = %error, "submission record not available");
            return false;
        }
    };
    if is_terminal_submission_status(&row.status) {
        tracing::info!(
            submission_id,
            status = %row.status,
            "submission already terminal, skipping"
        );
        return true;
    }
    let Some(sandbox) = context.sandboxes.for_language(&row.language) else {
        fail_submission(&context.pool, redis, &row, "不支持的编程语言").await;
        return true;
    };
    let (run_config, hidden_cases) = match parse_snapshots(&row) {
        Ok(snapshot) => snapshot,
        Err(error) => {
            fail_submission(
                &context.pool,
                redis,
                &row,
                &format!("评测快照无效: {error}"),
            )
            .await;
            return true;
        }
    };
    let cases = judge_cases(&run_config, hidden_cases);
    if cases.is_empty() {
        fail_submission(&context.pool, redis, &row, "该题未配置评测用例").await;
        return true;
    }
    if let Err(error) = validate_judge_set(&run_config, &cases) {
        fail_submission(
            &context.pool,
            redis,
            &row,
            &format!("评测用例无效: {error}"),
        )
        .await;
        return true;
    }
    let program = match program_for(&row.language, &row.code, &run_config) {
        Ok(program) => program,
        Err(error) => {
            fail_submission(&context.pool, redis, &row, &error.to_string()).await;
            return true;
        }
    };
    let total = cases.len() as i32;
    match claim_submission(&context.pool, submission_id).await {
        Ok(true) => {}
        Ok(false) => {
            tracing::info!(
                submission_id,
                "submission was claimed by another worker or is terminal"
            );
            return true;
        }
        Err(error) => {
            tracing::error!(submission_id, error = ?error, "failed to claim submission");
            return false;
        }
    }
    cache_submission_status(redis, &row, SUBMISSION_STATUS_JUDGING, 0, total, None).await;

    let _permit = match context.sandbox_permits.clone().acquire_owned().await {
        Ok(permit) => permit,
        Err(_) => return false,
    };
    let mut session = match SandboxSession::start(sandbox, i64::from(submission_id), &program).await
    {
        Ok(SandboxStart::Ready(session)) => session,
        Ok(SandboxStart::CompileError { output }) => {
            finish_submission_compile_error(
                &context.pool,
                redis,
                &context.config,
                &row,
                total,
                &output,
            )
            .await;
            return true;
        }
        Err(error) => {
            tracing::error!(
                submission_id,
                error = ?error,
                "failed to start submission sandbox, leaving it pending"
            );
            return false;
        }
    };

    let budget = Duration::from_secs(context.config.submit_run_timeout_secs);
    let started = Instant::now();
    let mut results = Vec::with_capacity(cases.len());
    let mut passed = 0i32;
    let mut verdict: Option<&'static str> = None;
    let mut error_message: Option<String> = None;
    let mut executed = 0usize;

    for (index, (args, expected)) in cases.iter().enumerate() {
        let remaining = budget.saturating_sub(started.elapsed());
        if remaining.is_zero() {
            verdict = Some(SUBMISSION_STATUS_TIME_LIMIT_EXCEEDED);
            error_message = Some(format!(
                "判题总时长超过 {} 秒，剩余用例未执行",
                context.config.submit_run_timeout_secs
            ));
            break;
        }
        let outcome = match session.run_case(args, CASE_TIMEOUT.min(remaining)).await {
            Ok(outcome) => outcome,
            Err(error) => {
                session.shutdown().await;
                tracing::error!(
                    submission_id,
                    error = ?error,
                    "sandbox execution failed, leaving submission pending"
                );
                return false;
            }
        };
        let expected = Some(expected.clone());
        let (case, matched, case_error) =
            build_case_result(index as i32, args, &expected, &outcome, &run_config);
        executed += 1;
        let case_status = case.status.clone();
        results.push(case);
        if matched {
            passed += 1;
            continue;
        }
        let case_verdict = verdict_for_case(&case_status);
        error_message = Some(match case_verdict {
            SUBMISSION_STATUS_TIME_LIMIT_EXCEEDED => {
                format!("第 {} 个用例执行超过 2 秒", index + 1)
            }
            SUBMISSION_STATUS_MEMORY_LIMIT_EXCEEDED => {
                format!("第 {} 个用例内存超过限制", index + 1)
            }
            SUBMISSION_STATUS_RUNTIME_ERROR => {
                case_error.unwrap_or_else(|| format!("第 {} 个用例运行时错误", index + 1))
            }
            _ => format!("第 {} 个用例输出与预期不一致", index + 1),
        });
        verdict = Some(case_verdict);
        break;
    }
    session.shutdown().await;

    for (index, (args, expected)) in cases.iter().enumerate().skip(executed) {
        results.push(skipped_case(index as i32, args, expected));
    }
    let status = verdict.unwrap_or(SUBMISSION_STATUS_ACCEPTED);
    let runtime_ms = results.iter().filter_map(|case| case.runtime_ms).max();
    let memory_kb = results.iter().filter_map(|case| case.memory_kb).max();
    let cases_value = json!(results);

    let updated = finish_submission(
        &context.pool,
        submission_id,
        SubmissionTerminalUpdate {
            status,
            cases: &cases_value,
            test_cases_passed: passed,
            total_test_cases: total,
            compile_output: None,
            error_message: error_message.as_deref(),
            runtime: runtime_ms,
            memory: memory_kb,
        },
    )
    .await;
    match updated {
        Ok(true) => {
            cache_submission_status(redis, &row, status, passed, total, error_message.clone())
                .await;
            release_submission_lock(redis, row.user_id, i64::from(submission_id)).await;
            tracing::info!(
                submission_id,
                user_id = row.user_id,
                language = %row.language,
                status,
                test_cases_passed = passed,
                total_test_cases = total,
                runtime_ms = ?runtime_ms,
                "submission finished"
            );
            enqueue_similarity_scan(&context.config, redis, submission_id).await;
            true
        }
        Ok(false) => {
            release_submission_lock(redis, row.user_id, i64::from(submission_id)).await;
            tracing::info!(
                submission_id,
                "submission verdict was already written by another worker"
            );
            true
        }
        Err(error) => {
            tracing::error!(
                submission_id,
                error = ?error,
                "failed to persist submission verdict, leaving it pending"
            );
            false
        }
    }
}

/// 判题落库成功后把提交投递到独立的防作弊 Stream。
/// 入队失败只记日志：相似度扫描是异步增强能力，不能影响判题结果。
async fn enqueue_similarity_scan(
    config: &Config,
    redis: &mut ConnectionManager,
    submission_id: i32,
) {
    if !config.anticheat_enabled {
        return;
    }
    if let Err(error) =
        queue::enqueue_anticheat(redis, &config.anticheat_stream, i64::from(submission_id)).await
    {
        tracing::error!(
            submission_id,
            error = %error,
            "failed to enqueue similarity scan"
        );
    }
}

fn verdict_for_case(case_status: &str) -> &'static str {
    match case_status {
        "timeout" => SUBMISSION_STATUS_TIME_LIMIT_EXCEEDED,
        "memory_limit_exceeded" => SUBMISSION_STATUS_MEMORY_LIMIT_EXCEEDED,
        "runtime_error" => SUBMISSION_STATUS_RUNTIME_ERROR,
        _ => SUBMISSION_STATUS_WRONG_ANSWER,
    }
}

async fn finish_submission_compile_error(
    pool: &PgPool,
    redis: &mut ConnectionManager,
    config: &Config,
    row: &SubmissionRow,
    total: i32,
    output: &str,
) {
    let cases = json!([]);
    let updated = finish_submission(
        pool,
        row.id,
        SubmissionTerminalUpdate {
            status: SUBMISSION_STATUS_COMPILE_ERROR,
            cases: &cases,
            test_cases_passed: 0,
            total_test_cases: total,
            compile_output: Some(output),
            error_message: Some("编译失败"),
            runtime: None,
            memory: None,
        },
    )
    .await;
    if updated.unwrap_or(false) {
        cache_submission_status(
            redis,
            row,
            SUBMISSION_STATUS_COMPILE_ERROR,
            0,
            total,
            Some("编译失败".to_owned()),
        )
        .await;
        enqueue_similarity_scan(config, redis, row.id).await;
    }
    release_submission_lock(redis, row.user_id, i64::from(row.id)).await;
    tracing::info!(submission_id = row.id, "submission failed to compile");
}

async fn fail_submission(
    pool: &PgPool,
    redis: &mut ConnectionManager,
    row: &SubmissionRow,
    message: &str,
) {
    tracing::warn!(
        submission_id = row.id,
        error = message,
        "submission failed before execution"
    );
    let cases = json!([]);
    let _ = finish_submission(
        pool,
        row.id,
        SubmissionTerminalUpdate {
            status: SUBMISSION_STATUS_INTERNAL_ERROR,
            cases: &cases,
            test_cases_passed: 0,
            total_test_cases: row.total_test_cases,
            compile_output: None,
            error_message: Some(message),
            runtime: None,
            memory: None,
        },
    )
    .await;
    cache_submission_status(
        redis,
        row,
        SUBMISSION_STATUS_INTERNAL_ERROR,
        0,
        row.total_test_cases,
        Some(message.to_owned()),
    )
    .await;
    release_submission_lock(redis, row.user_id, i64::from(row.id)).await;
}

fn skipped_case(index: i32, args: &[Value], expected: &Value) -> RunCaseResult {
    RunCaseResult {
        index,
        args: Value::Array(args.to_vec()),
        expected: Some(expected.clone()),
        actual: None,
        stdout: String::new(),
        stderr: String::new(),
        status: "skipped".to_owned(),
        matched: Some(false),
        runtime_ms: None,
        memory_kb: None,
        truncated: false,
    }
}

async fn cache_submission_status(
    redis: &mut ConnectionManager,
    row: &SubmissionRow,
    status: &str,
    passed: i32,
    total: i32,
    error_message: Option<String>,
) {
    let cached =
        CachedSubmissionStatus::new(row.user_id, row.id, status, passed, total, error_message);
    if let Err(error) = write_submission_status_cache(redis, cached).await {
        tracing::warn!(
            submission_id = row.id,
            error = ?error,
            "failed to cache submission status"
        );
    }
}

fn build_cases(row: &CodeRunRow, config: &RunConfig) -> Result<Vec<CasePlan>, String> {
    if row.mode == "examples" {
        if config.public_cases.is_empty() {
            return Err("该题未配置可运行的示例".to_owned());
        }
        return Ok(config
            .public_cases
            .iter()
            .map(|case| (case.args.clone(), Some(case.expected.clone())))
            .collect());
    }
    let input = row.input.clone().unwrap_or(Value::Null);
    let args = validate_input(config, &input).map_err(|error| format!("运行参数无效: {error}"))?;
    Ok(vec![(args, None)])
}

fn build_case_result(
    index: i32,
    args: &[Value],
    expected: &Option<Value>,
    outcome: &SandboxOutcome,
    config: &RunConfig,
) -> (RunCaseResult, bool, Option<String>) {
    let runtime_ms = outcome
        .result
        .as_ref()
        .map(|result| result.runtime_ms)
        .filter(|value| *value > 0)
        .unwrap_or(outcome.runtime_ms)
        .max(0);
    let memory_kb = (outcome.memory_kb > 0).then_some(outcome.memory_kb);
    let (case_status, error) = if outcome.timed_out {
        ("timeout", Some("单个用例执行超过 2 秒".to_owned()))
    } else if outcome.oom {
        ("memory_limit_exceeded", Some("执行内存超过限制".to_owned()))
    } else {
        match &outcome.result {
            Some(result) if result.ok => {
                let matched = expected.as_ref().is_none_or(|expected| {
                    let actual = result.actual.clone().unwrap_or(Value::Null);
                    let expected = normalize_for_compare(&config.return_type, expected);
                    let actual = normalize_for_compare(&config.return_type, &actual);
                    values_match(
                        &config.compare.mode,
                        config.compare.epsilon,
                        &expected,
                        &actual,
                    )
                });
                if matched {
                    ("passed", None)
                } else {
                    ("failed", None)
                }
            }
            Some(result) => (
                "runtime_error",
                Some(
                    result
                        .error
                        .clone()
                        .unwrap_or_else(|| "运行时错误".to_owned()),
                ),
            ),
            None => ("runtime_error", Some("运行未生成结果文件".to_owned())),
        }
    };
    let matched = expected.as_ref().map(|_| case_status == "passed");
    let case = RunCaseResult {
        index,
        args: Value::Array(args.to_vec()),
        expected: expected.clone(),
        actual: outcome
            .result
            .as_ref()
            .and_then(|result| result.actual.clone()),
        stdout: outcome.stdout.clone(),
        stderr: outcome.stderr.clone(),
        status: case_status.to_owned(),
        matched,
        runtime_ms: Some(runtime_ms),
        memory_kb,
        truncated: outcome.truncated,
    };
    (case, case_status == "passed", error)
}

fn unrun_case(index: i32, args: &[Value], expected: &Option<Value>) -> RunCaseResult {
    RunCaseResult {
        index,
        args: Value::Array(args.to_vec()),
        expected: expected.clone(),
        actual: None,
        stdout: String::new(),
        stderr: String::new(),
        status: "timeout".to_owned(),
        matched: expected.as_ref().map(|_| false),
        runtime_ms: None,
        memory_kb: None,
        truncated: false,
    }
}

fn aggregate_status(cases: &[RunCaseResult]) -> &'static str {
    if cases
        .iter()
        .any(|case| case.status == "memory_limit_exceeded")
    {
        RUN_STATUS_MEMORY_LIMIT_EXCEEDED
    } else if cases.iter().any(|case| case.status == "timeout") {
        RUN_STATUS_TIME_LIMIT_EXCEEDED
    } else if cases.iter().any(|case| case.status == "runtime_error") {
        RUN_STATUS_RUNTIME_ERROR
    } else {
        RUN_STATUS_COMPLETED
    }
}

async fn cache_status(
    redis: &mut ConnectionManager,
    row: &CodeRunRow,
    status: &str,
    passed: i32,
    total: i32,
    error_message: Option<String>,
) {
    let cached = CachedRunStatus::new(row.user_id, row.id, status, passed, total, error_message);
    if let Err(error) = write_status_cache(redis, cached).await {
        tracing::warn!(run_id = row.id, error = ?error, "failed to cache run status");
    }
}

async fn fail_run(pool: &PgPool, redis: &mut ConnectionManager, row: &CodeRunRow, message: &str) {
    tracing::warn!(
        run_id = row.id,
        error = message,
        "run failed before execution"
    );
    let event = json!([]);
    let _ = finish_run(
        pool,
        row.id,
        RunTerminalUpdate {
            status: RUN_STATUS_INTERNAL_ERROR,
            cases: &event,
            case_total: 0,
            case_passed: 0,
            compile_output: None,
            error_message: Some(message),
            runtime_ms: None,
            memory_kb: None,
        },
    )
    .await;
    cache_status(
        redis,
        row,
        RUN_STATUS_INTERNAL_ERROR,
        0,
        0,
        Some(message.to_owned()),
    )
    .await;
    release_user_lock(redis, row.user_id, row.id).await;
}

#[cfg(test)]
mod tests {
    use super::{aggregate_status, skipped_case, verdict_for_case};
    use backend_rust::models::run::{
        RUN_STATUS_COMPLETED, RUN_STATUS_MEMORY_LIMIT_EXCEEDED, RUN_STATUS_RUNTIME_ERROR,
        RUN_STATUS_TIME_LIMIT_EXCEEDED, RunCaseResult,
    };
    use backend_rust::models::submission::{
        SUBMISSION_STATUS_MEMORY_LIMIT_EXCEEDED, SUBMISSION_STATUS_RUNTIME_ERROR,
        SUBMISSION_STATUS_TIME_LIMIT_EXCEEDED, SUBMISSION_STATUS_WRONG_ANSWER,
    };
    use serde_json::{Value, json};

    fn case(status: &str) -> RunCaseResult {
        RunCaseResult {
            index: 0,
            args: Value::Array(Vec::new()),
            expected: None,
            actual: None,
            stdout: String::new(),
            stderr: String::new(),
            status: status.to_owned(),
            matched: None,
            runtime_ms: None,
            memory_kb: None,
            truncated: false,
        }
    }

    #[test]
    fn mismatched_examples_still_complete() {
        assert_eq!(
            aggregate_status(&[case("passed"), case("failed")]),
            RUN_STATUS_COMPLETED
        );
    }

    #[test]
    fn runtime_error_wins_over_completed() {
        assert_eq!(
            aggregate_status(&[case("passed"), case("runtime_error")]),
            RUN_STATUS_RUNTIME_ERROR
        );
    }

    #[test]
    fn timeout_wins_over_runtime_error_and_memory_wins_over_all() {
        assert_eq!(
            aggregate_status(&[case("runtime_error"), case("timeout")]),
            RUN_STATUS_TIME_LIMIT_EXCEEDED
        );
        assert_eq!(
            aggregate_status(&[case("timeout"), case("memory_limit_exceeded")]),
            RUN_STATUS_MEMORY_LIMIT_EXCEEDED
        );
    }

    #[test]
    fn case_statuses_map_to_submission_verdicts() {
        assert_eq!(
            verdict_for_case("timeout"),
            SUBMISSION_STATUS_TIME_LIMIT_EXCEEDED
        );
        assert_eq!(
            verdict_for_case("memory_limit_exceeded"),
            SUBMISSION_STATUS_MEMORY_LIMIT_EXCEEDED
        );
        assert_eq!(
            verdict_for_case("runtime_error"),
            SUBMISSION_STATUS_RUNTIME_ERROR
        );
        assert_eq!(verdict_for_case("failed"), SUBMISSION_STATUS_WRONG_ANSWER);
    }

    #[test]
    fn skipped_cases_are_not_reported_as_failures() {
        let skipped = skipped_case(3, &[json!([[1, 2], 3])], &json!([0, 1]));
        assert_eq!(skipped.status, "skipped");
        assert_eq!(skipped.matched, Some(false));
    }
}
