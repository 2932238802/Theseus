use redis::{
    AsyncCommands,
    aio::ConnectionManager,
    streams::{StreamAutoClaimOptions, StreamAutoClaimReply, StreamReadOptions, StreamReadReply},
};

use crate::common::error::AppError;

#[derive(Debug, Clone, PartialEq, Eq)]
pub struct ClaimedEntry {
    pub message_id: String,
    pub run_id: i64,
}

pub async fn connect(redis_url: &str) -> Result<ConnectionManager, AppError> {
    let client = redis::Client::open(redis_url)
        .map_err(|error| AppError::Internal(format!("Redis 连接配置无效: {error}")))?;
    ConnectionManager::new(client)
        .await
        .map_err(|error| AppError::Internal(format!("Redis 连接失败: {error}")))
}

pub async fn ensure_group(
    conn: &mut ConnectionManager,
    stream: &str,
    group: &str,
) -> Result<(), AppError> {
    let result: redis::RedisResult<()> = redis::cmd("XGROUP")
        .arg("CREATE")
        .arg(stream)
        .arg(group)
        .arg("0")
        .arg("MKSTREAM")
        .query_async(conn)
        .await;
    match result {
        Ok(()) => Ok(()),
        Err(error) if error.to_string().contains("BUSYGROUP") => Ok(()),
        Err(error) => Err(AppError::Internal(format!("Redis 消费组创建失败: {error}"))),
    }
}

pub async fn enqueue(
    conn: &mut ConnectionManager,
    stream: &str,
    run_id: i64,
) -> Result<(), AppError> {
    let _: String = conn
        .xadd(stream, "*", &[("run_id", run_id.to_string())])
        .await
        .map_err(|error| AppError::Internal(format!("运行任务入队失败: {error}")))?;
    Ok(())
}

pub async fn read_one(
    conn: &mut ConnectionManager,
    stream: &str,
    group: &str,
    consumer: &str,
    block_ms: usize,
) -> Result<Option<(String, i64)>, AppError> {
    let options = StreamReadOptions::default()
        .group(group, consumer)
        .count(1)
        .block(block_ms);
    let reply: Option<StreamReadReply> = conn
        .xread_options(&[stream], &[">"], &options)
        .await
        .map_err(|error| AppError::Internal(format!("Redis 读取运行任务失败: {error}")))?;
    let Some(reply) = reply else {
        return Ok(None);
    };
    for key in reply.keys {
        for entry in key.ids {
            let run_id: Option<i64> = entry.get("run_id");
            match run_id {
                Some(run_id) => return Ok(Some((entry.id, run_id))),
                None => {
                    tracing::warn!(
                        message_id = %entry.id,
                        "ignoring run queue message without numeric run_id"
                    );
                    let _: i64 = conn
                        .xack(stream, group, &[entry.id])
                        .await
                        .map_err(|error| {
                            AppError::Internal(format!("Redis 丢弃无效任务失败: {error}"))
                        })?;
                }
            }
        }
    }
    Ok(None)
}

pub async fn ack(
    conn: &mut ConnectionManager,
    stream: &str,
    group: &str,
    message_id: &str,
) -> Result<(), AppError> {
    let _: i64 = conn
        .xack(stream, group, &[message_id])
        .await
        .map_err(|error| AppError::Internal(format!("Redis 确认任务失败: {error}")))?;
    Ok(())
}

pub async fn status_key_get(conn: &mut ConnectionManager, key: &str) -> Option<String> {
    conn.get(key).await.ok().flatten()
}

pub async fn claim_stale(
    conn: &mut ConnectionManager,
    stream: &str,
    group: &str,
    consumer: &str,
    min_idle_ms: u64,
    count: usize,
    cursor: &mut String,
) -> Result<Vec<ClaimedEntry>, AppError> {
    let options = StreamAutoClaimOptions::default().count(count);
    let reply: StreamAutoClaimReply = conn
        .xautoclaim_options(
            stream,
            group,
            consumer,
            min_idle_ms,
            cursor.as_str(),
            options,
        )
        .await
        .map_err(|error| AppError::Internal(format!("Redis 回收 Pending 任务失败: {error}")))?;
    *cursor = reply.next_stream_id.clone();
    let mut claimed = Vec::new();
    for entry in reply.claimed {
        if let Some(run_id) = entry.get::<i64>("run_id") {
            claimed.push(ClaimedEntry {
                message_id: entry.id,
                run_id,
            });
        }
    }
    Ok(claimed)
}

pub async fn enqueue_dead(
    conn: &mut ConnectionManager,
    stream: &str,
    run_id: i64,
    reason: &str,
) -> Result<(), AppError> {
    let _: String = conn
        .xadd(
            stream,
            "*",
            &[
                ("run_id", run_id.to_string()),
                ("reason", reason.to_owned()),
            ],
        )
        .await
        .map_err(|error| AppError::Internal(format!("写入死信队列失败: {error}")))?;
    Ok(())
}

pub async fn heartbeat(conn: &mut ConnectionManager, key: &str, ttl_seconds: u64) {
    let _: Result<(), _> = conn.set_ex(key, 1, ttl_seconds).await;
}

pub fn worker_heartbeat_key(worker_name: &str) -> String {
    format!("theseus:run:worker:{worker_name}")
}

pub fn submit_worker_heartbeat_key(worker_name: &str) -> String {
    format!("theseus:submit:worker:{worker_name}")
}

/// Returns whether at least one judge worker has a live heartbeat key.
///
/// Workers refresh their key every 10 seconds with a 30-second TTL, so a
/// worker that just crashed can still be reported as alive for up to 30
/// seconds. That margin is acceptable for rejecting obviously unavailable
/// submissions early.
pub async fn has_live_worker(conn: &mut ConnectionManager) -> Result<bool, AppError> {
    has_live_keys(conn, "theseus:run:worker:*").await
}

/// Same heartbeat contract as [`has_live_worker`], but for the submission
/// judging workers. The two pools are independent: a worker that only consumes
/// the run stream must not make submissions look serviceable.
pub async fn has_live_submit_worker(conn: &mut ConnectionManager) -> Result<bool, AppError> {
    has_live_keys(conn, "theseus:submit:worker:*").await
}

async fn has_live_keys(conn: &mut ConnectionManager, pattern: &str) -> Result<bool, AppError> {
    let mut cursor: u64 = 0;
    loop {
        let (next_cursor, keys): (u64, Vec<String>) = redis::cmd("SCAN")
            .arg(cursor)
            .arg("MATCH")
            .arg(pattern)
            .arg("COUNT")
            .arg(100)
            .query_async(conn)
            .await
            .map_err(|error| AppError::Internal(format!("Redis 检查 Worker 心跳失败: {error}")))?;
        if !keys.is_empty() {
            return Ok(true);
        }
        if next_cursor == 0 {
            return Ok(false);
        }
        cursor = next_cursor;
    }
}

pub async fn clear_heartbeat(conn: &mut ConnectionManager, key: &str) {
    let _: Result<(), _> = conn.del(key).await;
}

pub async fn status_key_delete(conn: &mut ConnectionManager, key: &str) {
    let _: Result<(), _> = conn.del(key).await;
}

pub async fn status_key_set(
    conn: &mut ConnectionManager,
    key: &str,
    value: &str,
) -> Result<(), AppError> {
    let _: () = conn
        .set_ex(key, value, 3600)
        .await
        .map_err(|error| AppError::Internal(format!("Redis 写入运行状态失败: {error}")))?;
    Ok(())
}
