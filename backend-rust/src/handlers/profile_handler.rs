use axum::{
    Json,
    extract::{Multipart, Query, State},
    http::HeaderMap,
    response::IntoResponse,
};

use crate::{
    AppState,
    common::{error::AppError, response::ok},
    middleware::auth::authenticate,
    models::profile::{
        AnalyticsQuery, DeleteAccountRequest, UpdateEmailRequest, UpdateGradeRequest,
        UpdatePasswordRequest, UpdateUsernameRequest,
    },
    services::{auth_service, profile_service},
};

pub async fn update_username(
    State(state): State<AppState>,
    headers: HeaderMap,
    Json(request): Json<UpdateUsernameRequest>,
) -> Result<impl IntoResponse, AppError> {
    let user = authenticate(&state.pool, &headers, &state.config).await?;
    let data = profile_service::update_username(&state.pool, user.id, &request).await?;
    Ok(ok(data))
}

pub async fn update_grade(
    State(state): State<AppState>,
    headers: HeaderMap,
    Json(request): Json<UpdateGradeRequest>,
) -> Result<impl IntoResponse, AppError> {
    let user = authenticate(&state.pool, &headers, &state.config).await?;
    let data = profile_service::update_grade(&state.pool, user.id, &request).await?;
    Ok(ok(data))
}

pub async fn request_email_change(
    State(state): State<AppState>,
    headers: HeaderMap,
    Json(request): Json<UpdateEmailRequest>,
) -> Result<impl IntoResponse, AppError> {
    let user = authenticate(&state.pool, &headers, &state.config).await?;
    let data =
        auth_service::request_email_change(&state.pool, &state.config, user.id, &request.email)
            .await?;
    Ok(ok(data))
}

pub async fn cancel_email_change(
    State(state): State<AppState>,
    headers: HeaderMap,
) -> Result<impl IntoResponse, AppError> {
    let user = authenticate(&state.pool, &headers, &state.config).await?;
    let data = auth_service::cancel_email_change(&state.pool, user.id).await?;
    Ok(ok(data))
}

pub async fn change_password(
    State(state): State<AppState>,
    headers: HeaderMap,
    Json(request): Json<UpdatePasswordRequest>,
) -> Result<impl IntoResponse, AppError> {
    let user = authenticate(&state.pool, &headers, &state.config).await?;
    let data = auth_service::change_password(
        &state.pool,
        &state.config,
        user.id,
        &request.current_password,
        &request.new_password,
    )
    .await?;
    Ok(ok(data))
}

pub async fn logout_all(
    State(state): State<AppState>,
    headers: HeaderMap,
) -> Result<impl IntoResponse, AppError> {
    let user = authenticate(&state.pool, &headers, &state.config).await?;
    let data = auth_service::logout_all(&state.pool, user.id).await?;
    Ok(ok(data))
}

pub async fn delete_account(
    State(state): State<AppState>,
    headers: HeaderMap,
    Json(request): Json<DeleteAccountRequest>,
) -> Result<impl IntoResponse, AppError> {
    let user = authenticate(&state.pool, &headers, &state.config).await?;
    let data =
        profile_service::delete_account(&state.pool, &state.config, user.id, &request).await?;
    Ok(ok(data))
}

pub async fn upload_avatar(
    State(state): State<AppState>,
    headers: HeaderMap,
    mut multipart: Multipart,
) -> Result<impl IntoResponse, AppError> {
    let user = authenticate(&state.pool, &headers, &state.config).await?;
    let mut bytes: Option<axum::body::Bytes> = None;
    while let Some(field) = multipart
        .next_field()
        .await
        .map_err(|_| AppError::BadRequest("上传请求无效".to_owned()))?
    {
        if field.name() == Some("file") {
            bytes = Some(
                field
                    .bytes()
                    .await
                    .map_err(|_| AppError::BadRequest("读取头像文件失败".to_owned()))?,
            );
            break;
        }
    }
    let bytes = bytes.ok_or_else(|| AppError::BadRequest("缺少头像文件".to_owned()))?;
    let data = profile_service::save_avatar(&state.pool, &state.config, user.id, &bytes).await?;
    Ok(ok(data))
}

pub async fn delete_avatar(
    State(state): State<AppState>,
    headers: HeaderMap,
) -> Result<impl IntoResponse, AppError> {
    let user = authenticate(&state.pool, &headers, &state.config).await?;
    let data = profile_service::delete_avatar(&state.pool, &state.config, user.id).await?;
    Ok(ok(data))
}

pub async fn analytics(
    State(state): State<AppState>,
    headers: HeaderMap,
    Query(query): Query<AnalyticsQuery>,
) -> Result<impl IntoResponse, AppError> {
    let user = authenticate(&state.pool, &headers, &state.config).await?;
    let data = profile_service::analytics(&state.pool, user.id, &query).await?;
    Ok(ok(data))
}
