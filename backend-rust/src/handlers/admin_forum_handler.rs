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
    middleware::auth::require_admin,
    models::forum::{
        AdminActionListQuery, AdminForumPostListQuery, AdminMuteRequest, AdminPinRequest,
        AdminReportDecisionRequest, AdminReportListQuery, AdminStatusRequest,
    },
    services::{
        audit_service::{self, AuditContext, AuditRecord},
        forum_service,
    },
};

pub async fn list_posts(
    State(state): State<AppState>,
    headers: HeaderMap,
    Query(query): Query<AdminForumPostListQuery>,
) -> Result<impl IntoResponse, AppError> {
    require_admin(&state.pool, &headers, &state.config).await?;
    let data = forum_service::admin_list_posts(&state.pool, &query).await?;
    Ok(ok(data))
}

pub async fn get_post(
    State(state): State<AppState>,
    headers: HeaderMap,
    Path(id): Path<i64>,
) -> Result<impl IntoResponse, AppError> {
    require_admin(&state.pool, &headers, &state.config).await?;
    let data = forum_service::admin_get_post(&state.pool, id).await?;
    Ok(ok(data))
}

pub async fn change_post_status(
    State(state): State<AppState>,
    headers: HeaderMap,
    Path(id): Path<i64>,
    Json(request): Json<AdminStatusRequest>,
) -> Result<impl IntoResponse, AppError> {
    let admin = require_admin(&state.pool, &headers, &state.config).await?;
    let data = forum_service::admin_change_post_status(&state.pool, &admin, id, &request).await?;
    let context = AuditContext::from_headers(&headers);
    audit_service::record(
        &state.pool,
        &admin,
        &context,
        AuditRecord::new(
            "forum.post_status",
            "forum_post",
            Some(id),
            format!("将帖子 #{id} 状态改为 {}", request.status.trim()),
        )
        .after(json!({ "status": request.status.trim(), "reason": request.reason })),
    )
    .await;
    Ok(ok(data))
}

pub async fn change_comment_status(
    State(state): State<AppState>,
    headers: HeaderMap,
    Path(id): Path<i64>,
    Json(request): Json<AdminStatusRequest>,
) -> Result<impl IntoResponse, AppError> {
    let admin = require_admin(&state.pool, &headers, &state.config).await?;
    let data =
        forum_service::admin_change_comment_status(&state.pool, &admin, id, &request).await?;
    let context = AuditContext::from_headers(&headers);
    audit_service::record(
        &state.pool,
        &admin,
        &context,
        AuditRecord::new(
            "forum.comment_status",
            "forum_comment",
            Some(id),
            format!("将评论 #{id} 状态改为 {}", request.status.trim()),
        )
        .after(json!({ "status": request.status.trim(), "reason": request.reason })),
    )
    .await;
    Ok(ok(data))
}

pub async fn pin_post(
    State(state): State<AppState>,
    headers: HeaderMap,
    Path(id): Path<i64>,
    Json(request): Json<AdminPinRequest>,
) -> Result<impl IntoResponse, AppError> {
    let admin = require_admin(&state.pool, &headers, &state.config).await?;
    let data =
        forum_service::admin_pin_post(&state.pool, &state.config, &admin, id, &request).await?;
    let context = AuditContext::from_headers(&headers);
    audit_service::record(
        &state.pool,
        &admin,
        &context,
        AuditRecord::new(
            "forum.pin",
            "forum_post",
            Some(id),
            format!(
                "{}帖子 #{id}",
                if request.is_pinned {
                    "置顶"
                } else {
                    "取消置顶"
                }
            ),
        )
        .after(json!({ "is_pinned": request.is_pinned })),
    )
    .await;
    Ok(ok(data))
}

pub async fn list_reports(
    State(state): State<AppState>,
    headers: HeaderMap,
    Query(query): Query<AdminReportListQuery>,
) -> Result<impl IntoResponse, AppError> {
    require_admin(&state.pool, &headers, &state.config).await?;
    let data = forum_service::admin_list_reports(&state.pool, &query).await?;
    Ok(ok(data))
}

pub async fn decide_report(
    State(state): State<AppState>,
    headers: HeaderMap,
    Path(id): Path<i64>,
    Json(request): Json<AdminReportDecisionRequest>,
) -> Result<impl IntoResponse, AppError> {
    let admin = require_admin(&state.pool, &headers, &state.config).await?;
    let data = forum_service::admin_decide_report(&state.pool, &state.config, &admin, id, &request)
        .await?;
    let context = AuditContext::from_headers(&headers);
    audit_service::record(
        &state.pool,
        &admin,
        &context,
        AuditRecord::new(
            "forum.report_decide",
            "forum_report",
            Some(id),
            format!(
                "处理举报 #{id}：{}",
                if request.decision.trim() == "hide" {
                    "隐藏内容"
                } else {
                    "保留内容"
                }
            ),
        )
        .after(json!({
            "decision": request.decision.trim(),
            "status": data.status,
            "target_status": data.target_status,
            "note": request.note,
        })),
    )
    .await;
    Ok(ok(data))
}

pub async fn mute_user(
    State(state): State<AppState>,
    headers: HeaderMap,
    Path(id): Path<i32>,
    Json(request): Json<AdminMuteRequest>,
) -> Result<impl IntoResponse, AppError> {
    let admin = require_admin(&state.pool, &headers, &state.config).await?;
    let data = forum_service::admin_mute_user(&state.pool, &admin, id, &request).await?;
    let context = AuditContext::from_headers(&headers);
    audit_service::record(
        &state.pool,
        &admin,
        &context,
        AuditRecord::new(
            "forum.mute",
            "user",
            Some(i64::from(id)),
            format!("禁言用户 #{id}：{}", request.reason.trim()),
        )
        .after(json!({
            "duration_hours": request.duration_hours,
            "ends_at": data.ends_at,
        })),
    )
    .await;
    Ok(ok(data))
}

pub async fn unmute_user(
    State(state): State<AppState>,
    headers: HeaderMap,
    Path(id): Path<i32>,
) -> Result<impl IntoResponse, AppError> {
    let admin = require_admin(&state.pool, &headers, &state.config).await?;
    let data = forum_service::admin_unmute_user(&state.pool, &admin, id).await?;
    let context = AuditContext::from_headers(&headers);
    audit_service::record(
        &state.pool,
        &admin,
        &context,
        AuditRecord::new(
            "forum.unmute",
            "user",
            Some(i64::from(id)),
            format!("解除用户 #{id} 的禁言"),
        ),
    )
    .await;
    Ok(ok(data))
}

pub async fn list_actions(
    State(state): State<AppState>,
    headers: HeaderMap,
    Query(query): Query<AdminActionListQuery>,
) -> Result<impl IntoResponse, AppError> {
    require_admin(&state.pool, &headers, &state.config).await?;
    let data = forum_service::admin_list_actions(&state.pool, &query).await?;
    Ok(ok(data))
}
