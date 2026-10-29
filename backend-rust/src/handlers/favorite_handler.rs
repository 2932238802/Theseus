use axum::{
    extract::{Path, Query, State},
    http::HeaderMap,
    response::IntoResponse,
};

use crate::{
    AppState,
    common::{error::AppError, response::ok},
    middleware::auth::authenticate,
    models::favorite::FavoriteListQuery,
    services::favorite_service,
};

pub async fn favorite_problem(
    State(state): State<AppState>,
    headers: HeaderMap,
    Path(id): Path<i32>,
) -> Result<impl IntoResponse, AppError> {
    set_problem_favorite(state, headers, id, true).await
}

pub async fn unfavorite_problem(
    State(state): State<AppState>,
    headers: HeaderMap,
    Path(id): Path<i32>,
) -> Result<impl IntoResponse, AppError> {
    set_problem_favorite(state, headers, id, false).await
}

async fn set_problem_favorite(
    state: AppState,
    headers: HeaderMap,
    id: i32,
    favorited: bool,
) -> Result<impl IntoResponse, AppError> {
    if id <= 0 {
        return Err(AppError::BadRequest("题目 ID 无效".to_owned()));
    }
    let user = authenticate(&state.pool, &headers, &state.config).await?;
    let data = favorite_service::set_problem_favorite(&state.pool, user.id, id, favorited).await?;
    Ok(ok(data))
}

pub async fn list_problem_favorites(
    State(state): State<AppState>,
    headers: HeaderMap,
    Query(query): Query<FavoriteListQuery>,
) -> Result<impl IntoResponse, AppError> {
    let user = authenticate(&state.pool, &headers, &state.config).await?;
    let data = favorite_service::list_problem_favorites(&state.pool, user.id, &query).await?;
    Ok(ok(data))
}

pub async fn favorite_comment(
    State(state): State<AppState>,
    headers: HeaderMap,
    Path(id): Path<i64>,
) -> Result<impl IntoResponse, AppError> {
    set_comment_favorite(state, headers, id, true).await
}

pub async fn unfavorite_comment(
    State(state): State<AppState>,
    headers: HeaderMap,
    Path(id): Path<i64>,
) -> Result<impl IntoResponse, AppError> {
    set_comment_favorite(state, headers, id, false).await
}

async fn set_comment_favorite(
    state: AppState,
    headers: HeaderMap,
    id: i64,
    favorited: bool,
) -> Result<impl IntoResponse, AppError> {
    let user = authenticate(&state.pool, &headers, &state.config).await?;
    let data =
        favorite_service::set_comment_favorite(&state.pool, &state.config, user.id, id, favorited)
            .await?;
    Ok(ok(data))
}

pub async fn list_comment_favorites(
    State(state): State<AppState>,
    headers: HeaderMap,
    Query(query): Query<FavoriteListQuery>,
) -> Result<impl IntoResponse, AppError> {
    let user = authenticate(&state.pool, &headers, &state.config).await?;
    let data =
        favorite_service::list_comment_favorites(&state.pool, &state.config, user.id, &query)
            .await?;
    Ok(ok(data))
}
