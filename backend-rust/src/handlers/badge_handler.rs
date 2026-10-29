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
    models::badge::UpdateBadgeVisibilityRequest,
    services::badge_service,
};

pub async fn list(
    State(state): State<AppState>,
    headers: HeaderMap,
) -> Result<impl IntoResponse, AppError> {
    let user = authenticate(&state.pool, &headers, &state.config).await?;
    let data = badge_service::list_own_badges(&state.pool, user.id).await?;
    Ok(ok(data))
}

pub async fn update_visibility(
    State(state): State<AppState>,
    headers: HeaderMap,
    Path(code): Path<String>,
    Json(request): Json<UpdateBadgeVisibilityRequest>,
) -> Result<impl IntoResponse, AppError> {
    let user = authenticate(&state.pool, &headers, &state.config).await?;
    let data = badge_service::set_badge_hidden(&state.pool, user.id, &code, request.hidden).await?;
    Ok(ok(data))
}
