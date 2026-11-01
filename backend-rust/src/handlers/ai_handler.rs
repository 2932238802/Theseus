use axum::{Json, extract::State, http::HeaderMap, response::IntoResponse};

use crate::{
    AppState,
    common::{error::AppError, response::ok},
    middleware::auth::authenticate,
    models::ai::AiChatRequest,
    services::ai_service,
};

pub async fn status(
    State(state): State<AppState>,
    headers: HeaderMap,
) -> Result<impl IntoResponse, AppError> {
    let user = authenticate(&state.pool, &headers, &state.config).await?;
    let data = ai_service::status(&state.pool, &state.config, &user).await?;
    Ok(ok(data))
}

pub async fn chat(
    State(state): State<AppState>,
    headers: HeaderMap,
    Json(input): Json<AiChatRequest>,
) -> Result<impl IntoResponse, AppError> {
    let user = authenticate(&state.pool, &headers, &state.config).await?;
    let data = ai_service::chat(&state.pool, &state.config, &user, input).await?;
    Ok(ok(data))
}
