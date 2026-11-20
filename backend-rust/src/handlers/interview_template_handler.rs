use axum::{
    Json,
    extract::{Path, State},
    http::HeaderMap,
    response::IntoResponse,
};
use serde_json::json;

use crate::{
    AppState,
    common::{
        error::AppError,
        response::{created, ok},
    },
    middleware::auth::{optional_authenticate, require_admin},
    models::interview_template::{InterviewTemplateInput, InterviewTemplateOrderInput},
    services::{
        audit_service::{self, AuditContext, AuditRecord},
        interview_template_service,
    },
};

pub async fn list(
    State(state): State<AppState>,
    headers: HeaderMap,
) -> Result<impl IntoResponse, AppError> {
    let viewer = optional_authenticate(&state.pool, &headers, &state.config).await;
    let data = interview_template_service::list_reader(&state.pool, &state.config, viewer.as_ref())
        .await?;
    Ok(ok(data))
}

pub async fn get(
    State(state): State<AppState>,
    headers: HeaderMap,
    Path(id): Path<i64>,
) -> Result<impl IntoResponse, AppError> {
    let viewer = optional_authenticate(&state.pool, &headers, &state.config).await;
    let data =
        interview_template_service::get_reader(&state.pool, &state.config, viewer.as_ref(), id)
            .await?;
    Ok(ok(data))
}

pub async fn admin_list(
    State(state): State<AppState>,
    headers: HeaderMap,
) -> Result<impl IntoResponse, AppError> {
    require_admin(&state.pool, &headers, &state.config).await?;
    let data = interview_template_service::list_admin(&state.pool).await?;
    Ok(ok(data))
}

pub async fn create(
    State(state): State<AppState>,
    headers: HeaderMap,
    Json(request): Json<InterviewTemplateInput>,
) -> Result<impl IntoResponse, AppError> {
    let admin = require_admin(&state.pool, &headers, &state.config).await?;
    let data = interview_template_service::create(&state.pool, &admin, &request).await?;
    let context = AuditContext::from_headers(&headers);
    audit_service::record(
        &state.pool,
        &admin,
        &context,
        AuditRecord::new(
            "interview_template.create",
            "interview_template",
            Some(data.id),
            format!("新建 HR 面模板「{}」", data.title),
        )
        .after(json!({ "title": data.title.clone(), "sort_order": data.sort_order })),
    )
    .await;
    Ok(created(data))
}

pub async fn update(
    State(state): State<AppState>,
    headers: HeaderMap,
    Path(id): Path<i64>,
    Json(request): Json<InterviewTemplateInput>,
) -> Result<impl IntoResponse, AppError> {
    let admin = require_admin(&state.pool, &headers, &state.config).await?;
    let data = interview_template_service::update(&state.pool, &admin, id, &request).await?;
    let context = AuditContext::from_headers(&headers);
    audit_service::record(
        &state.pool,
        &admin,
        &context,
        AuditRecord::new(
            "interview_template.update",
            "interview_template",
            Some(id),
            format!("更新 HR 面模板「{}」", data.title),
        )
        .after(json!({ "title": data.title.clone(), "sort_order": data.sort_order })),
    )
    .await;
    Ok(ok(data))
}

pub async fn delete(
    State(state): State<AppState>,
    headers: HeaderMap,
    Path(id): Path<i64>,
) -> Result<impl IntoResponse, AppError> {
    let admin = require_admin(&state.pool, &headers, &state.config).await?;
    let (data, title) = interview_template_service::delete(&state.pool, id).await?;
    let context = AuditContext::from_headers(&headers);
    audit_service::record(
        &state.pool,
        &admin,
        &context,
        AuditRecord::new(
            "interview_template.delete",
            "interview_template",
            Some(id),
            format!("删除 HR 面模板「{title}」"),
        )
        .before(json!({ "title": title })),
    )
    .await;
    Ok(ok(data))
}

pub async fn reorder(
    State(state): State<AppState>,
    headers: HeaderMap,
    Json(request): Json<InterviewTemplateOrderInput>,
) -> Result<impl IntoResponse, AppError> {
    let admin = require_admin(&state.pool, &headers, &state.config).await?;
    let data = interview_template_service::reorder(&state.pool, &request).await?;
    let context = AuditContext::from_headers(&headers);
    audit_service::record(
        &state.pool,
        &admin,
        &context,
        AuditRecord::new(
            "interview_template.reorder",
            "interview_template",
            None,
            "调整 HR 面模板顺序",
        )
        .after(json!({ "ids": request.ids })),
    )
    .await;
    Ok(ok(data))
}
