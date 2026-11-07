use axum::{
    Json,
    extract::{Path, State},
    http::HeaderMap,
    response::IntoResponse,
};

use crate::{
    AppState,
    common::{error::AppError, response::ok},
    middleware::auth::{authenticate, require_verified_email},
    models::social::UpdatePrivacyRequest,
    services::social_service,
};

pub async fn follow(
    State(state): State<AppState>,
    headers: HeaderMap,
    Path(id): Path<i32>,
) -> Result<impl IntoResponse, AppError> {
    let user = authenticate(&state.pool, &headers, &state.config).await?;
    require_verified_email(&user)?;
    let data = social_service::follow(&state.pool, user.id, id).await?;
    Ok(ok(data))
}

pub async fn unfollow(
    State(state): State<AppState>,
    headers: HeaderMap,
    Path(id): Path<i32>,
) -> Result<impl IntoResponse, AppError> {
    let user = authenticate(&state.pool, &headers, &state.config).await?;
    let data = social_service::unfollow(&state.pool, user.id, id).await?;
    Ok(ok(data))
}

pub async fn following(
    State(state): State<AppState>,
    headers: HeaderMap,
) -> Result<impl IntoResponse, AppError> {
    let user = authenticate(&state.pool, &headers, &state.config).await?;
    let data = social_service::list_following(&state.pool, user.id).await?;
    Ok(ok(data))
}

pub async fn feed_counts(
    State(state): State<AppState>,
    headers: HeaderMap,
) -> Result<impl IntoResponse, AppError> {
    let user = authenticate(&state.pool, &headers, &state.config).await?;
    let data = social_service::feed_counts(&state.pool, user.id).await?;
    Ok(ok(data))
}

pub async fn privacy(
    State(state): State<AppState>,
    headers: HeaderMap,
) -> Result<impl IntoResponse, AppError> {
    let user = authenticate(&state.pool, &headers, &state.config).await?;
    let data = social_service::get_privacy(&state.pool, user.id).await?;
    Ok(ok(data))
}

pub async fn update_privacy(
    State(state): State<AppState>,
    headers: HeaderMap,
    Json(request): Json<UpdatePrivacyRequest>,
) -> Result<impl IntoResponse, AppError> {
    let user = authenticate(&state.pool, &headers, &state.config).await?;
    let data =
        social_service::update_privacy(&state.pool, user.id, request.hide_activity_from_social)
            .await?;
    Ok(ok(data))
}
