use axum::{
    Json,
    extract::{Path, Query, State},
    http::HeaderMap,
    response::IntoResponse,
};
use serde_json::json;

use crate::{
    AppState,
    common::{error::AppError, response::ok},
    middleware::auth::{authenticate, require_admin, require_verified_email},
    models::plus::{PlusApplicationInput, PlusApplicationQuery, PlusApplicationResolveInput},
    services::{
        audit_service::{self, AuditContext, AuditRecord},
        plus_service,
    },
};

pub async fn my_state(
    State(state): State<AppState>,
    headers: HeaderMap,
) -> Result<impl IntoResponse, AppError> {
    let user = authenticate(&state.pool, &headers, &state.config).await?;
    let response = plus_service::my_state(&state.pool, user.id).await?;
    Ok(ok(response))
}

pub async fn submit(
    State(state): State<AppState>,
    headers: HeaderMap,
    Json(input): Json<PlusApplicationInput>,
) -> Result<impl IntoResponse, AppError> {
    let user = authenticate(&state.pool, &headers, &state.config).await?;
    require_verified_email(&user)?;
    let response = plus_service::submit(&state.pool, &user, &input).await?;
    Ok(ok(response))
}

pub async fn admin_list(
    State(state): State<AppState>,
    headers: HeaderMap,
    Query(query): Query<PlusApplicationQuery>,
) -> Result<impl IntoResponse, AppError> {
    require_admin(&state.pool, &headers, &state.config).await?;
    let response = plus_service::admin_list(&state.pool, &query).await?;
    Ok(ok(response))
}

pub async fn admin_resolve(
    State(state): State<AppState>,
    headers: HeaderMap,
    Path(application_id): Path<i64>,
    Json(input): Json<PlusApplicationResolveInput>,
) -> Result<impl IntoResponse, AppError> {
    let admin = require_admin(&state.pool, &headers, &state.config).await?;
    let response = plus_service::admin_resolve(&state.pool, application_id, &admin, &input).await?;
    let context = AuditContext::from_headers(&headers);
    audit_service::record(
        &state.pool,
        &admin,
        &context,
        AuditRecord::new(
            "plus.application_resolve",
            "plus_application",
            Some(application_id),
            format!(
                "处理 Plus Theseus 申请 #{application_id}：{}",
                input.status.trim()
            ),
        )
        .after(json!({
            "status": response.status,
            "note": input.note,
            "days": input.days,
        })),
    )
    .await;
    Ok(ok(response))
}
