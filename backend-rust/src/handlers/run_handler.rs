use axum::{
    Json,
    extract::{Path, State},
    http::HeaderMap,
    response::IntoResponse,
};

use crate::{
    AppState,
    common::{
        error::AppError,
        response::{accepted, ok},
    },
    middleware::auth::authenticate,
    models::run::RunCreateRequest,
};

pub async fn create(
    State(state): State<AppState>,
    headers: HeaderMap,
    Json(request): Json<RunCreateRequest>,
) -> Result<impl IntoResponse, AppError> {
    let user = authenticate(&headers, &state.config)?;
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
    let user = authenticate(&headers, &state.config)?;
    let response = state.run_service.status(&state.pool, &user, id).await?;
    Ok(ok(response))
}

pub async fn detail(
    State(state): State<AppState>,
    headers: HeaderMap,
    Path(id): Path<i64>,
) -> Result<impl IntoResponse, AppError> {
    let user = authenticate(&headers, &state.config)?;
    let response = state.run_service.detail(&state.pool, &user, id).await?;
    Ok(ok(response))
}
