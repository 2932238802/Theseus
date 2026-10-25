use axum::{
    Json,
    extract::{Path, Query, State},
    http::HeaderMap,
    response::IntoResponse,
};
use serde_json::json;

use crate::{
    AppState,
    common::{
        error::AppError,
        response::{accepted, ok},
    },
    middleware::auth::authenticate,
    models::run::{RunCreateRequest, RunListQuery},
};

pub async fn create(
    State(state): State<AppState>,
    headers: HeaderMap,
    Json(request): Json<RunCreateRequest>,
) -> Result<impl IntoResponse, AppError> {
    let user = authenticate(&state.pool, &headers, &state.config).await?;
    let response = state
        .run_service
        .create(&state.pool, &user, request)
        .await?;
    Ok(accepted(response))
}

pub async fn status(
    State(state): State<AppState>,
    headers: HeaderMap,
    Path(id): Path<i64>,
) -> Result<impl IntoResponse, AppError> {
    let user = authenticate(&state.pool, &headers, &state.config).await?;
    let response = state.run_service.status(&state.pool, &user, id).await?;
    Ok(ok(response))
}

pub async fn detail(
    State(state): State<AppState>,
    headers: HeaderMap,
    Path(id): Path<i64>,
) -> Result<impl IntoResponse, AppError> {
    let user = authenticate(&state.pool, &headers, &state.config).await?;
    let response = state.run_service.detail(&state.pool, &user, id).await?;
    Ok(ok(response))
}

pub async fn list(
    State(state): State<AppState>,
    headers: HeaderMap,
    Query(query): Query<RunListQuery>,
) -> Result<impl IntoResponse, AppError> {
    let user = authenticate(&state.pool, &headers, &state.config).await?;
    let response = state.run_service.list(&state.pool, &user, query).await?;
    Ok(ok(response))
}

pub async fn remove(
    State(state): State<AppState>,
    headers: HeaderMap,
    Path(id): Path<i64>,
) -> Result<impl IntoResponse, AppError> {
    let user = authenticate(&state.pool, &headers, &state.config).await?;
    state.run_service.delete(&state.pool, &user, id).await?;
    Ok(ok(json!({})))
}
