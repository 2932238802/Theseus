use axum::{
    Json,
    extract::{Path, Query, State},
    http::HeaderMap,
    response::IntoResponse,
};

use crate::{
    AppState,
    common::{
        error::AppError,
        response::{created, ok},
    },
    middleware::auth::authenticate,
    models::submission::{SubmissionListQuery, SubmissionRequest},
};

pub async fn create(
    State(state): State<AppState>,
    headers: HeaderMap,
    Json(request): Json<SubmissionRequest>,
) -> Result<impl IntoResponse, AppError> {
    let user = authenticate(&state.pool, &headers, &state.config).await?;
    let response = state
        .submission_service
        .create(&state.pool, &user, request)
        .await?;
    Ok(created(response))
}

pub async fn status(
    State(state): State<AppState>,
    headers: HeaderMap,
    Path(id): Path<i32>,
) -> Result<impl IntoResponse, AppError> {
    let user = authenticate(&state.pool, &headers, &state.config).await?;
    let response = state
        .submission_service
        .status(&state.pool, &user, id)
        .await?;
    Ok(ok(response))
}

pub async fn get(
    State(state): State<AppState>,
    headers: HeaderMap,
    Path(id): Path<i32>,
) -> Result<impl IntoResponse, AppError> {
    let user = authenticate(&state.pool, &headers, &state.config).await?;
    let response = state
        .submission_service
        .detail(&state.pool, &user, id)
        .await?;
    Ok(ok(response))
}

pub async fn list(
    State(state): State<AppState>,
    headers: HeaderMap,
    Query(query): Query<SubmissionListQuery>,
) -> Result<impl IntoResponse, AppError> {
    let user = authenticate(&state.pool, &headers, &state.config).await?;
    let response = state
        .submission_service
        .list(&state.pool, &user, query)
        .await?;
    Ok(ok(response))
}
