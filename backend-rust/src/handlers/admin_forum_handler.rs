use axum::{
    Json,
    extract::{Path, Query, State},
    http::HeaderMap,
    response::IntoResponse,
};

use crate::{
    AppState,
    common::{error::AppError, response::ok},
    middleware::auth::require_admin,
    models::forum::{
        AdminActionListQuery, AdminForumPostListQuery, AdminMuteRequest, AdminPinRequest,
        AdminReportDecisionRequest, AdminReportListQuery, AdminStatusRequest,
    },
    services::forum_service,
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
    Ok(ok(data))
}

pub async fn unmute_user(
    State(state): State<AppState>,
    headers: HeaderMap,
    Path(id): Path<i32>,
) -> Result<impl IntoResponse, AppError> {
    let admin = require_admin(&state.pool, &headers, &state.config).await?;
    let data = forum_service::admin_unmute_user(&state.pool, &admin, id).await?;
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
