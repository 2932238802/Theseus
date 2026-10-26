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
    middleware::auth::{require_student, require_teacher, require_verified_email},
    models::teaching::{CreateClassInvitationsRequest, InviteCandidateQuery},
    services::invitation_service,
};

pub async fn search_candidates(
    State(state): State<AppState>,
    headers: HeaderMap,
    Path(class_id): Path<i32>,
    Query(query): Query<InviteCandidateQuery>,
) -> Result<impl IntoResponse, AppError> {
    let user = require_teacher(&state.pool, &headers, &state.config).await?;
    require_verified_email(&user)?;
    let data = invitation_service::search_candidates(&state.pool, &user, class_id, &query).await?;
    Ok(ok(data))
}

pub async fn create(
    State(state): State<AppState>,
    headers: HeaderMap,
    Path(class_id): Path<i32>,
    Json(request): Json<CreateClassInvitationsRequest>,
) -> Result<impl IntoResponse, AppError> {
    let user = require_teacher(&state.pool, &headers, &state.config).await?;
    require_verified_email(&user)?;
    let data =
        invitation_service::create_invitations(&state.pool, &user, class_id, &request).await?;
    Ok(created(data))
}

pub async fn list_for_class(
    State(state): State<AppState>,
    headers: HeaderMap,
    Path(class_id): Path<i32>,
) -> Result<impl IntoResponse, AppError> {
    let user = require_teacher(&state.pool, &headers, &state.config).await?;
    let data = invitation_service::list_class_invitations(&state.pool, &user, class_id).await?;
    Ok(ok(data))
}

pub async fn mine(
    State(state): State<AppState>,
    headers: HeaderMap,
) -> Result<impl IntoResponse, AppError> {
    let user = require_student(&state.pool, &headers, &state.config).await?;
    let data = invitation_service::list_my_invitations(&state.pool, &user).await?;
    Ok(ok(data))
}

pub async fn accept(
    State(state): State<AppState>,
    headers: HeaderMap,
    Path(invitation_id): Path<i64>,
) -> Result<impl IntoResponse, AppError> {
    let user = require_student(&state.pool, &headers, &state.config).await?;
    require_verified_email(&user)?;
    let data = invitation_service::accept_invitation(&state.pool, &user, invitation_id).await?;
    Ok(ok(data))
}

pub async fn decline(
    State(state): State<AppState>,
    headers: HeaderMap,
    Path(invitation_id): Path<i64>,
) -> Result<impl IntoResponse, AppError> {
    let user = require_student(&state.pool, &headers, &state.config).await?;
    require_verified_email(&user)?;
    let data = invitation_service::decline_invitation(&state.pool, &user, invitation_id).await?;
    Ok(ok(data))
}
