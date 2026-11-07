use axum::{
    Json,
    extract::{Path, Query, State},
    http::HeaderMap,
    response::IntoResponse,
};
use serde::Deserialize;

use crate::{
    AppState,
    common::{error::AppError, response::ok},
    middleware::auth::authenticate,
    models::solution::{CreateSolutionRequest, UpdateSolutionRequest},
    services::solution_service,
};

#[derive(Debug, Deserialize)]
pub struct SolutionListQuery {
    pub language: Option<String>,
}

pub async fn list(
    State(state): State<AppState>,
    headers: HeaderMap,
    Path(id): Path<i32>,
    Query(query): Query<SolutionListQuery>,
) -> Result<impl IntoResponse, AppError> {
    let user = authenticate(&state.pool, &headers, &state.config).await?;
    let language = query.language.as_deref().unwrap_or("cpp");
    let data = solution_service::list_solutions(&state.pool, user.id, id, language).await?;
    Ok(ok(data))
}

pub async fn create(
    State(state): State<AppState>,
    headers: HeaderMap,
    Path(id): Path<i32>,
    Json(request): Json<CreateSolutionRequest>,
) -> Result<impl IntoResponse, AppError> {
    let user = authenticate(&state.pool, &headers, &state.config).await?;
    let data = solution_service::create_solution(&state.pool, user.id, id, &request).await?;
    Ok(ok(data))
}

pub async fn update(
    State(state): State<AppState>,
    headers: HeaderMap,
    Path((id, solution_id)): Path<(i32, i32)>,
    Json(request): Json<UpdateSolutionRequest>,
) -> Result<impl IntoResponse, AppError> {
    let user = authenticate(&state.pool, &headers, &state.config).await?;
    let data =
        solution_service::update_solution(&state.pool, user.id, id, solution_id, &request).await?;
    Ok(ok(data))
}

pub async fn remove(
    State(state): State<AppState>,
    headers: HeaderMap,
    Path((id, solution_id)): Path<(i32, i32)>,
) -> Result<impl IntoResponse, AppError> {
    let user = authenticate(&state.pool, &headers, &state.config).await?;
    let data = solution_service::delete_solution(&state.pool, user.id, id, solution_id).await?;
    Ok(ok(data))
}
