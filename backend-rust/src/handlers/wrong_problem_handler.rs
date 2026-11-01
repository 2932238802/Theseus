use axum::{
    extract::{Path, Query, State},
    http::HeaderMap,
    response::IntoResponse,
};

use crate::{
    AppState,
    common::{error::AppError, response::ok},
    middleware::auth::authenticate,
    models::wrong_problem::WrongProblemListQuery,
    services::wrong_problem_service,
};

pub async fn list(
    State(state): State<AppState>,
    headers: HeaderMap,
    Query(query): Query<WrongProblemListQuery>,
) -> Result<impl IntoResponse, AppError> {
    let user = authenticate(&state.pool, &headers, &state.config).await?;
    let data = wrong_problem_service::list(&state.pool, user.id, &query).await?;
    Ok(ok(data))
}

pub async fn dismiss(
    State(state): State<AppState>,
    headers: HeaderMap,
    Path(problem_id): Path<i32>,
) -> Result<impl IntoResponse, AppError> {
    set_dismissed(state, headers, problem_id, true).await
}

pub async fn restore(
    State(state): State<AppState>,
    headers: HeaderMap,
    Path(problem_id): Path<i32>,
) -> Result<impl IntoResponse, AppError> {
    set_dismissed(state, headers, problem_id, false).await
}

async fn set_dismissed(
    state: AppState,
    headers: HeaderMap,
    problem_id: i32,
    dismissed: bool,
) -> Result<impl IntoResponse, AppError> {
    if problem_id <= 0 {
        return Err(AppError::BadRequest("题目 ID 无效".to_owned()));
    }
    let user = authenticate(&state.pool, &headers, &state.config).await?;
    let data = if dismissed {
        wrong_problem_service::dismiss(&state.pool, user.id, problem_id).await?
    } else {
        wrong_problem_service::restore(&state.pool, user.id, problem_id).await?
    };
    Ok(ok(data))
}
