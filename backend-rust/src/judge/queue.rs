use redis::{
    AsyncCommands,
    aio::ConnectionManager,
    streams::{StreamReadOptions, StreamReadReply},
};

use crate::common::error::AppError;

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
