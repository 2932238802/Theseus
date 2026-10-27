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
    middleware::auth::{authenticate, optional_authenticate, require_verified_email},
    models::forum::{
        CreateCommentRequest, CreatePostRequest, CreateReportRequest, ForumCommentListQuery,
        ForumPostListQuery, ForumReplyListQuery, UpdateCommentRequest, UpdatePostRequest,
    },
    services::forum_service,
};

pub async fn list_posts(
    State(state): State<AppState>,
    headers: HeaderMap,
    Query(query): Query<ForumPostListQuery>,
) -> Result<impl IntoResponse, AppError> {
    let viewer = optional_authenticate(&state.pool, &headers, &state.config).await;
    let data =
        forum_service::list_posts(&state.pool, &state.config, viewer.as_ref(), &query).await?;
    Ok(ok(data))
}

pub async fn get_post(
    State(state): State<AppState>,
    headers: HeaderMap,
    Path(id): Path<i64>,
) -> Result<impl IntoResponse, AppError> {
    let viewer = optional_authenticate(&state.pool, &headers, &state.config).await;
    let data = forum_service::get_post(&state.pool, &state.config, viewer.as_ref(), id).await?;
    Ok(ok(data))
}

pub async fn create_post(
    State(state): State<AppState>,
    headers: HeaderMap,
    Json(request): Json<CreatePostRequest>,
) -> Result<impl IntoResponse, AppError> {
    let user = authenticate(&state.pool, &headers, &state.config).await?;
    require_verified_email(&user)?;
    let data = forum_service::create_post(&state.pool, &state.config, &user, &request).await?;
    Ok(created(data))
}

pub async fn update_post(
    State(state): State<AppState>,
    headers: HeaderMap,
    Path(id): Path<i64>,
    Json(request): Json<UpdatePostRequest>,
) -> Result<impl IntoResponse, AppError> {
    let user = authenticate(&state.pool, &headers, &state.config).await?;
    let data = forum_service::update_post(&state.pool, &state.config, &user, id, &request).await?;
    Ok(ok(data))
}

pub async fn delete_post(
    State(state): State<AppState>,
    headers: HeaderMap,
    Path(id): Path<i64>,
) -> Result<impl IntoResponse, AppError> {
    let user = authenticate(&state.pool, &headers, &state.config).await?;
    let data = forum_service::delete_post(&state.pool, &state.config, &user, id).await?;
    Ok(ok(data))
}

pub async fn like_post(
    State(state): State<AppState>,
    headers: HeaderMap,
    Path(id): Path<i64>,
) -> Result<impl IntoResponse, AppError> {
    let user = authenticate(&state.pool, &headers, &state.config).await?;
    let data = forum_service::like_post(&state.pool, &state.config, &user, id, true).await?;
    Ok(ok(data))
}

pub async fn unlike_post(
    State(state): State<AppState>,
    headers: HeaderMap,
    Path(id): Path<i64>,
) -> Result<impl IntoResponse, AppError> {
    let user = authenticate(&state.pool, &headers, &state.config).await?;
    let data = forum_service::like_post(&state.pool, &state.config, &user, id, false).await?;
    Ok(ok(data))
}

pub async fn favorite_post(
    State(state): State<AppState>,
    headers: HeaderMap,
    Path(id): Path<i64>,
) -> Result<impl IntoResponse, AppError> {
    let user = authenticate(&state.pool, &headers, &state.config).await?;
    let data = forum_service::favorite_post(&state.pool, &state.config, &user, id, true).await?;
    Ok(ok(data))
}

pub async fn unfavorite_post(
    State(state): State<AppState>,
    headers: HeaderMap,
    Path(id): Path<i64>,
) -> Result<impl IntoResponse, AppError> {
    let user = authenticate(&state.pool, &headers, &state.config).await?;
    let data = forum_service::favorite_post(&state.pool, &state.config, &user, id, false).await?;
    Ok(ok(data))
}

pub async fn list_comments(
    State(state): State<AppState>,
    headers: HeaderMap,
    Path(id): Path<i64>,
    Query(query): Query<ForumCommentListQuery>,
) -> Result<impl IntoResponse, AppError> {
    let viewer = optional_authenticate(&state.pool, &headers, &state.config).await;
    let data =
        forum_service::list_comments(&state.pool, &state.config, viewer.as_ref(), id, &query)
            .await?;
    Ok(ok(data))
}

pub async fn create_comment(
    State(state): State<AppState>,
    headers: HeaderMap,
    Path(id): Path<i64>,
    Json(request): Json<CreateCommentRequest>,
) -> Result<impl IntoResponse, AppError> {
    let user = authenticate(&state.pool, &headers, &state.config).await?;
    require_verified_email(&user)?;
    let data =
        forum_service::create_comment(&state.pool, &state.config, &user, id, &request).await?;
    Ok(created(data))
}

pub async fn list_replies(
    State(state): State<AppState>,
    headers: HeaderMap,
    Path(id): Path<i64>,
    Query(query): Query<ForumReplyListQuery>,
) -> Result<impl IntoResponse, AppError> {
    let viewer = optional_authenticate(&state.pool, &headers, &state.config).await;
    let data = forum_service::list_replies(&state.pool, &state.config, viewer.as_ref(), id, &query)
        .await?;
    Ok(ok(data))
}

pub async fn update_comment(
    State(state): State<AppState>,
    headers: HeaderMap,
    Path(id): Path<i64>,
    Json(request): Json<UpdateCommentRequest>,
) -> Result<impl IntoResponse, AppError> {
    let user = authenticate(&state.pool, &headers, &state.config).await?;
    let data =
        forum_service::update_comment(&state.pool, &state.config, &user, id, &request).await?;
    Ok(ok(data))
}

pub async fn delete_comment(
    State(state): State<AppState>,
    headers: HeaderMap,
    Path(id): Path<i64>,
) -> Result<impl IntoResponse, AppError> {
    let user = authenticate(&state.pool, &headers, &state.config).await?;
    let data = forum_service::delete_comment(&state.pool, &state.config, &user, id).await?;
    Ok(ok(data))
}

pub async fn create_report(
    State(state): State<AppState>,
    headers: HeaderMap,
    Json(request): Json<CreateReportRequest>,
) -> Result<impl IntoResponse, AppError> {
    let user = authenticate(&state.pool, &headers, &state.config).await?;
    let data = forum_service::create_report(&state.pool, &state.config, &user, &request).await?;
    Ok(created(data))
}

pub async fn favorites(
    State(state): State<AppState>,
    headers: HeaderMap,
    Query(query): Query<crate::models::profile::ForumFavoriteQuery>,
) -> Result<impl IntoResponse, AppError> {
    let user = authenticate(&state.pool, &headers, &state.config).await?;
    let data = forum_service::list_favorites(&state.pool, &state.config, user.id, &query).await?;
    Ok(ok(data))
}
