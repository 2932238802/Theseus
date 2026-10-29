use axum::{extract::State, http::HeaderMap, response::IntoResponse};
use serde_json::json;

use crate::{
    AppState,
    common::{error::AppError, response::ok},
    middleware::auth::authenticate,
    services::home_service,
};

pub async fn overview(
    State(state): State<AppState>,
    headers: HeaderMap,
) -> Result<impl IntoResponse, AppError> {
    let user = authenticate(&state.pool, &headers, &state.config).await?;
    let response = home_service::overview(&state.pool, user.id).await?;
    Ok(ok(response))
}

pub async fn random_problem(State(state): State<AppState>) -> Result<impl IntoResponse, AppError> {
    let problem_id: Option<i32> = sqlx::query_scalar(
        "SELECT id FROM problems WHERE review_status = 'approved' ORDER BY random() LIMIT 1",
    )
    .fetch_optional(&state.pool)
    .await
    .map_err(AppError::Database)?;
    match problem_id {
        Some(id) => Ok(ok(json!({ "problem_id": id }))),
        None => Err(AppError::NotFound("题库暂时没有题目".to_owned())),
    }
}
