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
        response::{created, ok},
    },
    middleware::auth::{authenticate, require_student, require_teacher, require_verified_email},
    models::teaching::{
        AddClassMemberRequest, CreateClassRequest, ImportClassMembersRequest, JoinClassRequest,
        UpdateClassRequest,
    },
    services::class_service,
};

pub async fn list(
    State(state): State<AppState>,
    headers: HeaderMap,
) -> Result<impl IntoResponse, AppError> {
    let user = authenticate(&state.pool, &headers, &state.config).await?;
    let data = class_service::list_classes(&state.pool, &user).await?;
    Ok(ok(data))
}

pub async fn create(
    State(state): State<AppState>,
    headers: HeaderMap,
    Json(request): Json<CreateClassRequest>,
) -> Result<impl IntoResponse, AppError> {
    let user = require_teacher(&state.pool, &headers, &state.config).await?;
    let data = class_service::create_class(&state.pool, &user, &request).await?;
    Ok(created(data))
}

pub async fn get(
    State(state): State<AppState>,
    headers: HeaderMap,
    Path(id): Path<i32>,
) -> Result<impl IntoResponse, AppError> {
    let user = authenticate(&state.pool, &headers, &state.config).await?;
    let data = class_service::detail(&state.pool, &user, id).await?;
    Ok(ok(data))
}

pub async fn update(
    State(state): State<AppState>,
    headers: HeaderMap,
    Path(id): Path<i32>,
    Json(request): Json<UpdateClassRequest>,
) -> Result<impl IntoResponse, AppError> {
    let user = require_teacher(&state.pool, &headers, &state.config).await?;
    let data = class_service::update_class(&state.pool, &user, id, &request).await?;
    Ok(ok(data))
}

pub async fn join(
    State(state): State<AppState>,
    headers: HeaderMap,
    Json(request): Json<JoinClassRequest>,
) -> Result<impl IntoResponse, AppError> {
    let user = require_student(&state.pool, &headers, &state.config).await?;
    require_verified_email(&user)?;
    let data = class_service::join_class(&state.pool, &user, &request).await?;
    Ok(ok(data))
}

pub async fn add_member(
    State(state): State<AppState>,
    headers: HeaderMap,
    Path(id): Path<i32>,
    Json(request): Json<AddClassMemberRequest>,
) -> Result<impl IntoResponse, AppError> {
    let user = require_teacher(&state.pool, &headers, &state.config).await?;
    let data = class_service::add_member(&state.pool, &user, id, &request).await?;
    Ok(created(data))
}

pub async fn import_members(
    State(state): State<AppState>,
    headers: HeaderMap,
    Path(id): Path<i32>,
    Json(request): Json<ImportClassMembersRequest>,
) -> Result<impl IntoResponse, AppError> {
    let user = require_teacher(&state.pool, &headers, &state.config).await?;
    let data = class_service::import_members(&state.pool, &user, id, &request).await?;
    Ok(ok(data))
}

pub async fn remove_member(
    State(state): State<AppState>,
    headers: HeaderMap,
    Path((id, user_id)): Path<(i32, i32)>,
) -> Result<impl IntoResponse, AppError> {
    let user = require_teacher(&state.pool, &headers, &state.config).await?;
    let data = class_service::remove_member(&state.pool, &user, id, user_id).await?;
    Ok(ok(data))
}

pub async fn leave(
    State(state): State<AppState>,
    headers: HeaderMap,
    Path(id): Path<i32>,
) -> Result<impl IntoResponse, AppError> {
    let user = require_student(&state.pool, &headers, &state.config).await?;
    let data = class_service::leave_class(&state.pool, &user, id).await?;
    Ok(ok(data))
}

pub async fn rotate_invite_code(
    State(state): State<AppState>,
    headers: HeaderMap,
    Path(id): Path<i32>,
) -> Result<impl IntoResponse, AppError> {
    let user = require_teacher(&state.pool, &headers, &state.config).await?;
    let data = class_service::rotate_invite_code(&state.pool, &user, id).await?;
    Ok(ok(data))
}

pub async fn archive(
    State(state): State<AppState>,
    headers: HeaderMap,
    Path(id): Path<i32>,
) -> Result<impl IntoResponse, AppError> {
    let user = require_teacher(&state.pool, &headers, &state.config).await?;
    let data = class_service::archive_class(&state.pool, &user, id).await?;
    Ok(ok(data))
}
