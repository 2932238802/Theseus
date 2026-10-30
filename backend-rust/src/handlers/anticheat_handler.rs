use axum::{
    Json,
    extract::{Path, Query, State},
    http::HeaderMap,
    response::IntoResponse,
};

use crate::{
    AppState,
    common::{error::AppError, response::ok},
    middleware::auth::{authenticate, require_teacher},
    models::anticheat::{AppealInput, AppealResolveInput, CheatReportQuery, CheatReviewInput},
    services::anticheat_service,
};

pub async fn teacher_list(
    State(state): State<AppState>,
    headers: HeaderMap,
    Query(query): Query<CheatReportQuery>,
) -> Result<impl IntoResponse, AppError> {
    let user = require_teacher(&state.pool, &headers, &state.config).await?;
    let response = anticheat_service::teacher_reports(&state.pool, &user, &query).await?;
    Ok(ok(response))
}

pub async fn teacher_detail(
    State(state): State<AppState>,
    headers: HeaderMap,
    Path(report_id): Path<i64>,
) -> Result<impl IntoResponse, AppError> {
    let user = require_teacher(&state.pool, &headers, &state.config).await?;
    let response = anticheat_service::teacher_report_detail(&state.pool, &user, report_id).await?;
    Ok(ok(response))
}

pub async fn teacher_review(
    State(state): State<AppState>,
    headers: HeaderMap,
    Path(report_id): Path<i64>,
    Json(input): Json<CheatReviewInput>,
) -> Result<impl IntoResponse, AppError> {
    let user = require_teacher(&state.pool, &headers, &state.config).await?;
    let response = anticheat_service::review_report(&state.pool, &user, report_id, &input).await?;
    Ok(ok(response))
}

pub async fn appeal_queue(
    State(state): State<AppState>,
    headers: HeaderMap,
    Query(query): Query<CheatReportQuery>,
) -> Result<impl IntoResponse, AppError> {
    let user = authenticate(&state.pool, &headers, &state.config).await?;
    let response = anticheat_service::appeal_queue(&state.pool, &user, &query).await?;
    Ok(ok(response))
}

pub async fn appeal_resolve(
    State(state): State<AppState>,
    headers: HeaderMap,
    Path(appeal_id): Path<i64>,
    Json(input): Json<AppealResolveInput>,
) -> Result<impl IntoResponse, AppError> {
    let user = authenticate(&state.pool, &headers, &state.config).await?;
    let response = anticheat_service::resolve_appeal(&state.pool, &user, appeal_id, &input).await?;
    Ok(ok(response))
}

pub async fn my_reports(
    State(state): State<AppState>,
    headers: HeaderMap,
) -> Result<impl IntoResponse, AppError> {
    let user = authenticate(&state.pool, &headers, &state.config).await?;
    let response = anticheat_service::my_reports(&state.pool, &user).await?;
    Ok(ok(response))
}

pub async fn my_report_detail(
    State(state): State<AppState>,
    headers: HeaderMap,
    Path(report_id): Path<i64>,
) -> Result<impl IntoResponse, AppError> {
    let user = authenticate(&state.pool, &headers, &state.config).await?;
    let response = anticheat_service::my_report_detail(&state.pool, &user, report_id).await?;
    Ok(ok(response))
}

pub async fn submit_appeal(
    State(state): State<AppState>,
    headers: HeaderMap,
    Path(report_id): Path<i64>,
    Json(input): Json<AppealInput>,
) -> Result<impl IntoResponse, AppError> {
    let user = authenticate(&state.pool, &headers, &state.config).await?;
    let response = anticheat_service::submit_appeal(&state.pool, &user, report_id, &input).await?;
    Ok(ok(response))
}
