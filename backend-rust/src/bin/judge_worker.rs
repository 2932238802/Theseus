use std::time::{Duration, Instant};

use backend_rust::{
    config::Config,
    db::pool::create_pool,
    judge::{
        compare::values_match,
        queue,
        run_config::validate_input,
        runner::{SandboxConfig, SandboxOutcome, execute_javascript, execute_python},
    },
    models::run::{
        CodeRunRow, RUN_STATUS_COMPILING, RUN_STATUS_COMPLETED, RUN_STATUS_INTERNAL_ERROR,
        RUN_STATUS_MEMORY_LIMIT_EXCEEDED, RUN_STATUS_RUNNING, RUN_STATUS_RUNTIME_ERROR,
        RUN_STATUS_TIME_LIMIT_EXCEEDED, RunCaseResult, RunConfig, is_terminal_status,
    },
    services::run_service::{
        CachedRunStatus, RunTerminalUpdate, claim_run, fetch_run_row, finish_run, mark_running,
        parse_run_config, release_user_lock, write_status_cache,
    },
};
use redis::aio::ConnectionManager;
use serde_json::{Value, json};
use sqlx::PgPool;

const CASE_TIMEOUT: Duration = Duration::from_secs(2);
const RUN_TIMEOUT: Duration = Duration::from_secs(10);

type CasePlan = (Vec<Value>, Option<Value>);

struct Sandboxes {
    python: SandboxConfig,
    node: SandboxConfig,
}

impl Sandboxes {
    fn for_language(&self, language: &str) -> Option<&SandboxConfig> {
        match language {
            "python" => Some(&self.python),
            "javascript" => Some(&self.node),
            _ => None,
        }
    }
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
        "judge worker started"
    );

    let sandboxes = Sandboxes {
        python: SandboxConfig {
            image: config.run_image_python.clone(),
            runtime: config.run_sandbox_runtime.clone(),
            allow_runc: config.run_sandbox_allow_runc,
        },
        node: SandboxConfig {
            image: config.run_image_node.clone(),
            runtime: config.run_sandbox_runtime.clone(),
            allow_runc: config.run_sandbox_allow_runc,
        },
    };
    let mut terminate = tokio::signal::unix::signal(tokio::signal::unix::SignalKind::terminate())?;

    loop {
        tokio::select! {
            _ = tokio::signal::ctrl_c() => {
                tracing::info!("judge worker received interrupt, stopping");
                break;
            }
            _ = terminate.recv() => {
                tracing::info!("judge worker received SIGTERM, stopping");
                break;
            }
            message = queue::read_one(
                &mut redis,
                &config.run_stream,
                &config.run_consumer_group,
                &config.run_worker_name,
                5000,
            ) => {
                match message {
                    Ok(Some((message_id, run_id))) => {
                        process_run(&pool, &sandboxes, &mut redis, run_id).await;
                        if let Err(error) = queue::ack(
                            &mut redis,
                            &config.run_stream,
                            &config.run_consumer_group,
                            &message_id,
                        ).await {
                            tracing::error!(run_id, error = %error, "failed to acknowledge run");
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
    }
    Ok(())
}

async fn process_run(
    pool: &PgPool,
    sandboxes: &Sandboxes,
    redis: &mut ConnectionManager,
    run_id: i64,
) {
    let row = match fetch_run_row(pool, run_id).await {
        Ok(row) => row,
        Err(error) => {
            tracing::warn!(run_id, error = %error, "run record not available");
            return;
        }
    };
    if is_terminal_status(&row.status) {
        tracing::info!(run_id, status = %row.status, "run already terminal, skipping");
        return;
    }
    let Some(sandbox) = sandboxes.for_language(&row.language) else {
        fail_run(pool, redis, &row, "当前仅支持 Python 和 JavaScript 运行").await;
        return;
    };
    if !matches!(row.mode.as_str(), "examples" | "custom") {
        fail_run(pool, redis, &row, "运行模式无效").await;
        return;
    }
    let run_config = match parse_run_config(&row) {
        Ok(config) => config,
        Err(error) => {
            fail_run(pool, redis, &row, &format!("run_config 无效: {error}")).await;
            return;
        }
    };
    let cases = match build_cases(&row, &run_config) {
        Ok(cases) => cases,
        Err(message) => {
            fail_run(pool, redis, &row, &message).await;
            return;
        }
    };
    let total = cases.len() as i32;
    if !claim_run(pool, run_id).await.unwrap_or(false) {
        tracing::info!(run_id, "run was claimed by another worker or is terminal");
        return;
    }
    cache_status(redis, &row, RUN_STATUS_COMPILING, 0, total, None).await;

    let _ = mark_running(pool, run_id).await;
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
        let outcome = match row.language.as_str() {
            "javascript" => {
                execute_javascript(
                    sandbox,
                    run_id,
                    &row.code,
                    args,
                    &run_config.function_name,
                    CASE_TIMEOUT.min(remaining),
                )
                .await
            }
            _ => {
                execute_python(
                    sandbox,
                    run_id,
                    &row.code,
                    args,
                    &run_config.function_name,
                    CASE_TIMEOUT.min(remaining),
                )
                .await
            }
        };
        let outcome = match outcome {
            Ok(outcome) => outcome,
            Err(error) => {
                fail_run(pool, redis, &row, &format!("沙箱执行失败: {error}")).await;
                return;
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
            RUN_STATUS_MEMORY_LIMIT_EXCEEDED => "执行内存超过 256 MB".to_owned(),
            _ => first_error.unwrap_or_else(|| "运行时错误".to_owned()),
        })
    };
    let updated = finish_run(
        pool,
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
        status,
        case_passed = passed,
        case_total = total,
        runtime_ms,
        "run finished"
    );
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
        (
            "memory_limit_exceeded",
            Some("执行内存超过 256 MB".to_owned()),
        )
    } else {
        match &outcome.result {
            Some(result) if result.ok => {
                let matched = expected.as_ref().is_none_or(|expected| {
                    let actual = result.actual.clone().unwrap_or(Value::Null);
                    values_match(
                        &config.compare.mode,
                        config.compare.epsilon,
                        expected,
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
        tracing::warn!(run_id = row.id, error = %error, "failed to cache run status");
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
    use super::aggregate_status;
    use backend_rust::models::run::{
        RUN_STATUS_COMPLETED, RUN_STATUS_MEMORY_LIMIT_EXCEEDED, RUN_STATUS_RUNTIME_ERROR,
        RUN_STATUS_TIME_LIMIT_EXCEEDED, RunCaseResult,
    };
    use serde_json::Value;

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
}
