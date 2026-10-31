use axum::{
    Json,
    extract::{Path, Query, State},
    http::HeaderMap,
    response::IntoResponse,
};

use crate::{
    AppState,
    common::{error::AppError, response::ok},
    middleware::auth::authenticate,
    models::note::{NoteListQuery, SaveNoteRequest},
    services::note_service,
};

pub async fn get(
    State(state): State<AppState>,
    headers: HeaderMap,
    Path(id): Path<i32>,
) -> Result<impl IntoResponse, AppError> {
    let user = authenticate(&state.pool, &headers, &state.config).await?;
    let data = note_service::get_note(&state.pool, user.id, id).await?;
    Ok(ok(data))
}

pub async fn save(
    State(state): State<AppState>,
    headers: HeaderMap,
    Path(id): Path<i32>,
    Json(request): Json<SaveNoteRequest>,
) -> Result<impl IntoResponse, AppError> {
    let user = authenticate(&state.pool, &headers, &state.config).await?;
    let data = note_service::save_note(&state.pool, user.id, id, request).await?;
    Ok(ok(data))
}

pub async fn list(
    State(state): State<AppState>,
    headers: HeaderMap,
    Query(query): Query<NoteListQuery>,
) -> Result<impl IntoResponse, AppError> {
    let user = authenticate(&state.pool, &headers, &state.config).await?;
    let data = note_service::list_notes(&state.pool, user.id, &query).await?;
    Ok(ok(data))
}
