use axum::{
    extract::State,
    http::header,
    response::{IntoResponse, Response},
};
use redis::{aio::ConnectionManager, streams::StreamInfoGroupsReply};

use crate::{
    AppState,
    judge::queue,
    utils::metrics::{append_gauge, append_header, http_metrics},
};

/// `GET /metrics`：Prometheus 文本格式。
///
/// HTTP 指标来自进程内计数；队列、连接池与 Worker 心跳是抓取时现读的，
/// 依赖不可用时对应的样本不输出，抓取本身仍然成功。
pub async fn render(State(state): State<AppState>) -> Response {
    let mut body = http_metrics().render();

    append_header(
        &mut body,
        "theseus_build_info",
        "gauge",
        "Build information, always 1.",
    );
    append_gauge(
        &mut body,
        "theseus_build_info",
        &[("version", env!("CARGO_PKG_VERSION"))],
        1.0,
    );

    let pool = &state.pool;
    append_header(
        &mut body,
        "theseus_db_pool_connections",
        "gauge",
        "Database pool connections by state.",
    );
    append_gauge(
        &mut body,
        "theseus_db_pool_connections",
        &[("state", "size")],
        pool.size() as f64,
    );
    append_gauge(
        &mut body,
        "theseus_db_pool_connections",
        &[("state", "idle")],
        pool.num_idle() as f64,
    );
    append_gauge(
        &mut body,
        "theseus_db_pool_connections",
        &[("state", "max")],
        pool.options().get_max_connections() as f64,
    );

    append_queue_metrics(&mut body, &state).await;

    (
        [(
            header::CONTENT_TYPE,
            "text/plain; version=0.0.4; charset=utf-8",
        )],
        body,
    )
        .into_response()
}

async fn append_queue_metrics(body: &mut String, state: &AppState) {
    let config = state.config.as_ref();
    let queues = [
        (
            "run",
            config.run_stream.as_str(),
            config.run_dead_stream.as_str(),
            config.run_code_enabled,
        ),
        (
            "submit",
            config.submit_stream.as_str(),
            config.submit_dead_stream.as_str(),
            config.submit_judge_enabled,
        ),
        (
            "anticheat",
            config.anticheat_stream.as_str(),
            config.anticheat_dead_stream.as_str(),
            config.anticheat_enabled,
        ),
    ];

    let Some(mut conn) = state.redis.clone() else {
        append_header(
            body,
            "theseus_judge_enabled",
            "gauge",
            "Whether the judge queue is configured.",
        );
        append_gauge(body, "theseus_judge_enabled", &[], 0.0);
        return;
    };

    append_header(
        body,
        "theseus_judge_enabled",
        "gauge",
        "Whether the judge queue is configured.",
    );
    append_gauge(body, "theseus_judge_enabled", &[], 1.0);

    append_header(
        body,
        "theseus_judge_stream_length",
        "gauge",
        "Entries in the judge stream, including pending ones.",
    );
    append_header(
        body,
        "theseus_judge_stream_pending",
        "gauge",
        "Delivered but unacknowledged entries in the judge stream.",
    );
    append_header(
        body,
        "theseus_judge_dead_letters",
        "gauge",
        "Entries in the judge dead letter stream.",
    );
    append_header(
        body,
        "theseus_judge_worker_up",
        "gauge",
        "Whether at least one worker holds a live heartbeat, by kind.",
    );

    for (kind, stream, dead_stream, enabled) in queues {
        if !enabled {
            continue;
        }
        let labels = [("queue", kind)];
        if let Some(length) = stream_len(&mut conn, stream).await {
            append_gauge(body, "theseus_judge_stream_length", &labels, length as f64);
        }
        if let Some(pending) = stream_pending(&mut conn, stream).await {
            append_gauge(
                body,
                "theseus_judge_stream_pending",
                &labels,
                pending as f64,
            );
        }
        if let Some(dead) = stream_len(&mut conn, dead_stream).await {
            append_gauge(body, "theseus_judge_dead_letters", &labels, dead as f64);
        }
        let up = match kind {
            "run" => queue::has_live_worker(&mut conn).await,
            "submit" => queue::has_live_submit_worker(&mut conn).await,
            _ => queue::has_live_anticheat_worker(&mut conn).await,
        };
        if let Ok(up) = up {
            append_gauge(
                body,
                "theseus_judge_worker_up",
                &[("kind", kind)],
                if up { 1.0 } else { 0.0 },
            );
        }
    }
}

async fn stream_len(conn: &mut ConnectionManager, stream: &str) -> Option<usize> {
    let result: Result<usize, _> = redis::cmd("XLEN").arg(stream).query_async(conn).await;
    match result {
        Ok(length) => Some(length),
        Err(error) => {
            tracing::debug!(stream, %error, "读取队列长度失败");
            None
        }
    }
}

async fn stream_pending(conn: &mut ConnectionManager, stream: &str) -> Option<usize> {
    let result: Result<StreamInfoGroupsReply, _> = redis::cmd("XINFO")
        .arg("GROUPS")
        .arg(stream)
        .query_async(conn)
        .await;
    match result {
        Ok(reply) => Some(reply.groups.iter().map(|group| group.pending).sum()),
        Err(error) => {
            tracing::debug!(stream, %error, "读取队列消费组失败");
            None
        }
    }
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn metrics_text_helpers_are_valid() {
        let mut body = String::new();
        append_header(&mut body, "theseus_test", "gauge", "Help text.");
        append_gauge(&mut body, "theseus_test", &[("queue", "run")], 3.0);
        assert!(body.starts_with("# HELP theseus_test Help text.\n# TYPE theseus_test gauge\n"));
        assert!(body.ends_with("theseus_test{queue=\"run\"} 3\n"));
        assert!(
            http_metrics()
                .render()
                .contains("# TYPE theseus_http_requests_total counter")
        );
    }
}
