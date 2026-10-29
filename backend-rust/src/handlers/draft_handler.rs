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
    models::draft::SaveDraftRequest,
    services::draft_service,
};

#[derive(Debug, Deserialize)]
pub struct DraftQuery {
    pub language: String,
}

pub async fn get(
    State(state): State<AppState>,
    headers: HeaderMap,
    Path(id): Path<i32>,
    Query(query): Query<DraftQuery>,
) -> Result<impl IntoResponse, AppError> {
    let user = authenticate(&state.pool, &headers, &state.config).await?;
    let data = draft_service::get_draft(&state.pool, user.id, id, &query.language).await?;
    Ok(ok(data))
}

pub async fn save(
    State(state): State<AppState>,
    headers: HeaderMap,
    Path(id): Path<i32>,
    Json(request): Json<SaveDraftRequest>,
) -> Result<impl IntoResponse, AppError> {
    let user = authenticate(&state.pool, &headers, &state.config).await?;
    let data = draft_service::save_draft(&state.pool, user.id, id, request).await?;
    Ok(ok(data))
}
