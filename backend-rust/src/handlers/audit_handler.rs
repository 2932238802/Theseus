use axum::{
    extract::{Query, State},
    http::{HeaderMap, HeaderValue, header},
    response::{IntoResponse, Response},
};

use crate::{
    AppState,
    common::{error::AppError, response::ok},
    middleware::auth::require_admin,
    models::audit::AuditLogQuery,
    services::audit_service::{self, AuditContext, AuditRecord},
};

pub async fn list(
    State(state): State<AppState>,
    headers: HeaderMap,
    Query(query): Query<AuditLogQuery>,
) -> Result<impl IntoResponse, AppError> {
    require_admin(&state.pool, &headers, &state.config).await?;
    let data = audit_service::list(&state.pool, &query).await?;
    Ok(ok(data))
}

pub async fn meta(
    State(state): State<AppState>,
    headers: HeaderMap,
) -> Result<impl IntoResponse, AppError> {
    require_admin(&state.pool, &headers, &state.config).await?;
    let data = audit_service::meta(&state.pool).await?;
    Ok(ok(data))
}

pub async fn export(
    State(state): State<AppState>,
    headers: HeaderMap,
    Query(query): Query<AuditLogQuery>,
) -> Result<Response, AppError> {
    let admin = require_admin(&state.pool, &headers, &state.config).await?;
    let csv = audit_service::export_csv(&state.pool, &query).await?;
    let context = AuditContext::from_headers(&headers);
    let mut parts = Vec::new();
    if let Some(action) = query.action.as_deref().filter(|value| !value.is_empty()) {
        parts.push(format!("动作={action}"));
    }
    if let Some(target_type) = query
        .target_type
        .as_deref()
        .filter(|value| !value.is_empty())
    {
        parts.push(format!("对象={target_type}"));
    }
    if let Some(q) = query.q.as_deref().filter(|value| !value.is_empty()) {
        parts.push(format!("关键词={q}"));
    }
    let summary = if parts.is_empty() {
        "导出审计日志".to_owned()
    } else {
        format!("导出审计日志（{}）", parts.join("，"))
    };
    audit_service::record(
        &state.pool,
        &admin,
        &context,
        AuditRecord::new("audit.export", "audit_log", None, summary),
    )
    .await;

    let disposition = HeaderValue::from_static("attachment; filename=\"audit-logs.csv\"");
    let mut response = csv.into_response();
    response.headers_mut().insert(
        header::CONTENT_TYPE,
        HeaderValue::from_static("text/csv; charset=utf-8"),
    );
    response
        .headers_mut()
        .insert(header::CONTENT_DISPOSITION, disposition);
    Ok(response)
}
