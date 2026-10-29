use axum::{
    Json,
    extract::{Path, Query, State},
    http::HeaderMap,
    response::IntoResponse,
};

use crate::{
    AppState,
    common::{error::AppError, response::ok},
    middleware::auth::{authenticate, require_verified_email},
    models::notification::{
        NotificationListQuery, SendNotificationRequest, UpdateNotificationPreferencesRequest,
    },
    services::notification_service,
};

pub async fn send(
    State(state): State<AppState>,
    headers: HeaderMap,
    Json(request): Json<SendNotificationRequest>,
) -> Result<impl IntoResponse, AppError> {
    let user = authenticate(&state.pool, &headers, &state.config).await?;
    if !user.is_teacher() && !user.is_admin() {
        return Err(AppError::ForbiddenWith(
            "只有教师或管理员可以发送通知".to_owned(),
        ));
    }
    require_verified_email(&user)?;
    let data = notification_service::send_custom(&state.pool, &user, &request).await?;
    Ok(ok(data))
}

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

pub async fn preferences(
    State(state): State<AppState>,
    headers: HeaderMap,
) -> Result<impl IntoResponse, AppError> {
    let user = authenticate(&state.pool, &headers, &state.config).await?;
    let data = notification_service::preferences(&state.pool, user.id).await?;
    Ok(ok(data))
}

pub async fn update_preferences(
    State(state): State<AppState>,
    headers: HeaderMap,
    Json(request): Json<UpdateNotificationPreferencesRequest>,
) -> Result<impl IntoResponse, AppError> {
    let user = authenticate(&state.pool, &headers, &state.config).await?;
    let data = notification_service::update_preferences(&state.pool, user.id, &request).await?;
    Ok(ok(data))
}
