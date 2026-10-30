//! 防作弊扫描 worker：消费 `ANTICHEAT_STREAM`，对作业提交做同题、同语言比对。
//!
//! 与判题 worker 解耦：判题结束只负责把 submission_id 投递到独立 Stream，
//! 这里按需扩展并发；数据库写入全部幂等，Redis 重投不会产生重复报告。

use std::{
    sync::{
        Arc,
        atomic::{AtomicBool, Ordering},
    },
    time::Duration,
};

use backend_rust::{
    config::Config,
    db::pool::create_pool,
    judge::queue::{self, ClaimedEntry},
    services::anticheat_service,
};
use redis::aio::ConnectionManager;
use sqlx::PgPool;
use tokio::sync::Semaphore;

const CLAIM_MIN_IDLE_MS: u64 = 120_000;
const CLAIM_COUNT: usize = 10;
const HEARTBEAT_INTERVAL: Duration = Duration::from_secs(10);
const HEARTBEAT_TTL_SECONDS: u64 = 30;
const SHUTDOWN_GRACE: Duration = Duration::from_secs(60);

#[derive(Clone)]
struct WorkerContext {
    pool: PgPool,
    config: Arc<Config>,
    scan_permits: Arc<Semaphore>,
    stop: Arc<AtomicBool>,
}

#[tokio::main]
async fn main() -> Result<(), Box<dyn std::error::Error>> {
    dotenvy::dotenv().ok();
    tracing_subscriber::fmt()
        .with_env_filter(tracing_subscriber::EnvFilter::from_default_env())
        .init();

    let config = Config::from_env()?;
    if !config.anticheat_enabled {
        tracing::info!("anticheat disabled; worker exiting");
        return Ok(());
    }
    let pool = create_pool(&config.database_url).await?;
    let mut redis = queue::connect(&config.redis_url).await?;
    queue::ensure_group(
        &mut redis,
        &config.anticheat_stream,
        &config.anticheat_consumer_group,
    )
    .await?;

    tracing::info!(
        worker = %config.anticheat_worker_name,
        stream = %config.anticheat_stream,
        group = %config.anticheat_consumer_group,
        concurrency = config.anticheat_worker_concurrency,
        "anticheat worker started"
    );

    let stop = Arc::new(AtomicBool::new(false));
    let context = WorkerContext {
        pool,
        scan_permits: Arc::new(Semaphore::new(config.anticheat_worker_concurrency)),
        config: Arc::new(config),
        stop: stop.clone(),
    };

    let mut tasks = tokio::task::JoinSet::new();
    for index in 0..context.config.anticheat_worker_concurrency {
        let worker = context.clone();
        tasks.spawn(async move { scan_consumer_loop(worker, index).await });
    }
    {
        let worker = context.clone();
        tasks.spawn(async move { scan_claimer_loop(worker).await });
    }
    {
        let worker = context.clone();
        tasks.spawn(async move { heartbeat_loop(worker).await });
    }

    let mut terminate = tokio::signal::unix::signal(tokio::signal::unix::SignalKind::terminate())?;
    tokio::select! {
        _ = tokio::signal::ctrl_c() => tracing::info!("anticheat worker received interrupt, stopping"),
        _ = terminate.recv() => tracing::info!("anticheat worker received SIGTERM, stopping"),
    }
    stop.store(true, Ordering::SeqCst);

    let drained = tokio::time::timeout(SHUTDOWN_GRACE, async {
        while tasks.join_next().await.is_some() {}
    })
    .await;
    if drained.is_err() {
        tracing::warn!("anticheat worker shutdown timeout, aborting in-flight tasks");
        tasks.abort_all();
    }
    tracing::info!("anticheat worker stopped");
    Ok(())
}

async fn scan_consumer_loop(context: WorkerContext, index: usize) {
    let consumer = format!("{}-{index}", context.config.anticheat_worker_name);
    let mut redis = match queue::connect(&context.config.redis_url).await {
        Ok(connection) => connection,
        Err(error) => {
            tracing::error!(consumer = %consumer, error = %error, "anticheat consumer failed to connect Redis");
            return;
        }
    };
    while !context.stop.load(Ordering::SeqCst) {
        match queue::read_one_anticheat(
            &mut redis,
            &context.config.anticheat_stream,
            &context.config.anticheat_consumer_group,
            &consumer,
            5000,
        )
        .await
        {
            Ok(Some((message_id, raw_id))) => {
                let Some(submission_id) = i32::try_from(raw_id).ok() else {
                    tracing::warn!(raw_id, "ignoring anticheat message with out-of-range id");
                    let _ = queue::ack(
                        &mut redis,
                        &context.config.anticheat_stream,
                        &context.config.anticheat_consumer_group,
                        &message_id,
                    )
                    .await;
                    continue;
                };
                if process_scan(&context, submission_id).await {
                    if let Err(error) = queue::ack(
                        &mut redis,
                        &context.config.anticheat_stream,
                        &context.config.anticheat_consumer_group,
                        &message_id,
                    )
                    .await
                    {
                        tracing::error!(
                            submission_id,
                            error = %error,
                            "failed to acknowledge anticheat scan"
                        );
                    }
                } else {
                    tracing::warn!(
                        submission_id,
                        "anticheat scan left pending for retry after infrastructure error"
                    );
                }
            }
            Ok(None) => {}
            Err(error) => {
                tracing::error!(error = %error, "failed to read anticheat queue");
                tokio::time::sleep(Duration::from_secs(1)).await;
            }
        }
    }
}

async fn scan_claimer_loop(context: WorkerContext) {
    let consumer = format!("{}-claimer", context.config.anticheat_worker_name);
    let mut redis = match queue::connect(&context.config.redis_url).await {
        Ok(connection) => connection,
        Err(error) => {
            tracing::error!(error = %error, "anticheat claimer failed to connect Redis");
            return;
        }
    };
    let interval = Duration::from_secs(context.config.anticheat_claim_interval_secs);
    let mut cursor = "0-0".to_owned();
    while !context.stop.load(Ordering::SeqCst) {
        tokio::time::sleep(interval).await;
        if context.stop.load(Ordering::SeqCst) {
            break;
        }
        let claimed = queue::claim_stale_anticheat(
            &mut redis,
            &context.config.anticheat_stream,
            &context.config.anticheat_consumer_group,
            &consumer,
            CLAIM_MIN_IDLE_MS,
            CLAIM_COUNT,
            &mut cursor,
        )
        .await;
        let claimed = match claimed {
            Ok(claimed) => claimed,
            Err(error) => {
                tracing::error!(error = %error, "failed to claim stale anticheat messages");
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
    let Ok(submission_id) = i32::try_from(entry.run_id) else {
        tracing::warn!(
            raw_id = entry.run_id,
            "discarding claimed anticheat message with out-of-range id"
        );
        let _ = queue::ack(
            redis,
            &context.config.anticheat_stream,
            &context.config.anticheat_consumer_group,
            &entry.message_id,
        )
        .await;
        return;
    };
    let attempt = match record_attempt(&context.pool, submission_id).await {
        Ok(attempt) => attempt,
        Err(error) => {
            tracing::error!(
                submission_id,
                error = ?error,
                "failed to record anticheat retry attempt"
            );
            return;
        }
    };
    if attempt > context.config.anticheat_max_deliveries as i64 {
        tracing::error!(
            submission_id,
            attempt,
            "anticheat scan exceeded maximum deliveries, moving to dead stream"
        );
        let reason = format!(
            "扫描重试超过 {} 次，已进入死信队列",
            context.config.anticheat_max_deliveries
        );
        let _ = queue::enqueue_dead_anticheat(
            redis,
            &context.config.anticheat_dead_stream,
            i64::from(submission_id),
            &reason,
        )
        .await;
        let _ = sqlx::query(
            "INSERT INTO submission_signals (submission_id, signal_type, value, source) \
             VALUES ($1, 'scan_completed', $2, 'server') ON CONFLICT DO NOTHING",
        )
        .bind(submission_id)
        .bind(serde_json::json!({"skipped": "dead_letter", "reason": reason}))
        .execute(&context.pool)
        .await;
        let _ = queue::ack(
            redis,
            &context.config.anticheat_stream,
            &context.config.anticheat_consumer_group,
            &entry.message_id,
        )
        .await;
        return;
    }
    tracing::warn!(submission_id, attempt, "recovered stale anticheat message");
    if process_scan(context, submission_id).await {
        let _ = queue::ack(
            redis,
            &context.config.anticheat_stream,
            &context.config.anticheat_consumer_group,
            &entry.message_id,
        )
        .await;
    }
}

async fn process_scan(context: &WorkerContext, submission_id: i32) -> bool {
    // 限制同时计算的数量，避免多消费者时 CPU 峰值叠加。
    let _permit = match context.scan_permits.clone().acquire_owned().await {
        Ok(permit) => permit,
        Err(_) => return false,
    };
    match anticheat_service::scan_submission(&context.pool, &context.config, submission_id).await {
        Ok(()) => true,
        Err(error) => {
            tracing::error!(
                submission_id,
                error = %error,
                "similarity scan failed, leaving message pending"
            );
            false
        }
    }
}

async fn record_attempt(pool: &PgPool, submission_id: i32) -> Result<i64, sqlx::Error> {
    sqlx::query(
        "INSERT INTO submission_signals (submission_id, signal_type, value, source) \
         VALUES ($1, 'scan_attempt', '{}'::jsonb, 'server')",
    )
    .bind(submission_id)
    .execute(pool)
    .await?;
    sqlx::query_scalar(
        "SELECT COUNT(*) FROM submission_signals \
         WHERE submission_id = $1 AND signal_type = 'scan_attempt'",
    )
    .bind(submission_id)
    .fetch_one(pool)
    .await
}

async fn heartbeat_loop(context: WorkerContext) {
    let key = queue::anticheat_worker_heartbeat_key(&context.config.anticheat_worker_name);
    let mut redis = match queue::connect(&context.config.redis_url).await {
        Ok(connection) => connection,
        Err(error) => {
            tracing::error!(error = %error, "anticheat heartbeat failed to connect Redis");
            return;
        }
    };
    while !context.stop.load(Ordering::SeqCst) {
        queue::heartbeat(&mut redis, &key, HEARTBEAT_TTL_SECONDS).await;
        tokio::time::sleep(HEARTBEAT_INTERVAL).await;
    }
    queue::clear_heartbeat(&mut redis, &key).await;
}
