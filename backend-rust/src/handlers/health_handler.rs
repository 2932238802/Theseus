use axum::{Json, extract::State, http::StatusCode};
use serde_json::{Value, json};

use crate::AppState;

/// Liveness: the process is up and can serve HTTP. Does not touch dependencies,
/// so a briefly unavailable database does not restart the API container.
pub async fn liveness() -> Json<Value> {
    Json(json!({ "status": "ok" }))
}

/// Readiness: dependencies needed to serve requests are reachable.
///
/// Redis is only required when judge features are enabled; otherwise it is
/// reported as `disabled` and does not fail the check.
pub async fn readiness(State(state): State<AppState>) -> (StatusCode, Json<Value>) {
    let database_ok = sqlx::query_scalar::<_, i32>("SELECT 1")
        .fetch_one(&state.pool)
        .await
        .is_ok();

    let redis_status = match state.redis.clone() {
        None => "disabled",
        Some(mut connection) => {
            match redis::cmd("PING")
                .query_async::<String>(&mut connection)
                .await
            {
                Ok(_) => "ok",
                Err(_) => "unavailable",
            }
        }
    };

    let ready = database_ok && redis_status != "unavailable";
    let status = if ready {
        StatusCode::OK
    } else {
        StatusCode::SERVICE_UNAVAILABLE
    };
    (
        status,
        Json(json!({
            "status": if ready { "ok" } else { "degraded" },
            "database": if database_ok { "ok" } else { "unavailable" },
            "redis": redis_status,
            "version": env!("CARGO_PKG_VERSION"),
        })),
    )
}
