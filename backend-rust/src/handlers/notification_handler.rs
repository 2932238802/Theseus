use axum::{
    extract::{Path, Query, State},
    http::HeaderMap,
    response::IntoResponse,
};

use crate::{
    AppState,
    common::{error::AppError, response::ok},
    middleware::auth::authenticate,
    models::notification::NotificationListQuery,
    services::notification_service,
};

pub async fn list(
    State(state): State<AppState>,
    headers: HeaderMap,
    Query(query): Query<NotificationListQuery>,
) -> Result<impl IntoResponse, AppError> {
    let user = authenticate(&state.pool, &headers, &state.config).await?;
    let data = notification_service::list(&state.pool, user.id, &query).await?;
    Ok(ok(data))
}

pub async fn unread_count(
    State(state): State<AppState>,
    headers: HeaderMap,
) -> Result<impl IntoResponse, AppError> {
    let user = authenticate(&state.pool, &headers, &state.config).await?;
    let data = notification_service::unread(&state.pool, user.id).await?;
    Ok(ok(data))
}

pub async fn mark_read(
    State(state): State<AppState>,
    headers: HeaderMap,
    Path(id): Path<i64>,
) -> Result<impl IntoResponse, AppError> {
    let user = authenticate(&state.pool, &headers, &state.config).await?;
    let data = notification_service::mark_read(&state.pool, user.id, id).await?;
    Ok(ok(data))
}

pub async fn mark_all_read(
    State(state): State<AppState>,
    headers: HeaderMap,
) -> Result<impl IntoResponse, AppError> {
    let user = authenticate(&state.pool, &headers, &state.config).await?;
    let data = notification_service::mark_all_read(&state.pool, user.id).await?;
    Ok(ok(data))
}
