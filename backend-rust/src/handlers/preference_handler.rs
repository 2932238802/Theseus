use axum::{
    Json,
    extract::{Path, State},
    http::HeaderMap,
    response::IntoResponse,
};

use crate::{
    AppState,
    common::{error::AppError, response::ok},
    middleware::auth::authenticate,
    models::preference::UpdatePreferencesRequest,
    services::preference_service,
};

pub async fn get(
    State(state): State<AppState>,
    headers: HeaderMap,
) -> Result<impl IntoResponse, AppError> {
    let user = authenticate(&state.pool, &headers, &state.config).await?;
    let data = preference_service::get_preferences(&state.pool, user.id).await?;
    Ok(ok(data))
}

pub async fn update(
    State(state): State<AppState>,
    headers: HeaderMap,
    Json(request): Json<UpdatePreferencesRequest>,
) -> Result<impl IntoResponse, AppError> {
    let user = authenticate(&state.pool, &headers, &state.config).await?;
    let data = preference_service::update_preferences(&state.pool, user.id, request).await?;
    Ok(ok(data))
}

pub async fn clear(
    State(state): State<AppState>,
    headers: HeaderMap,
) -> Result<impl IntoResponse, AppError> {
    let user = authenticate(&state.pool, &headers, &state.config).await?;
    let data = preference_service::clear_preferences(&state.pool, user.id).await?;
    Ok(ok(data))
}

pub async fn delete(
    State(state): State<AppState>,
    headers: HeaderMap,
    Path(key): Path<String>,
) -> Result<impl IntoResponse, AppError> {
    let user = authenticate(&state.pool, &headers, &state.config).await?;
    let data = preference_service::delete_preference(&state.pool, user.id, &key).await?;
    Ok(ok(data))
}
