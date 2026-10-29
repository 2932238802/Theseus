use axum::{
    Json,
    extract::{Path, State},
    http::HeaderMap,
    response::IntoResponse,
};

use crate::{
    AppState,
    common::{error::AppError, response::ok},
    middleware::auth::{authenticate, require_verified_email},
    models::contest::{ContestEventsRequest, MatchRequest},
    services::contest_service,
};

pub async fn start_match(
    State(state): State<AppState>,
    headers: HeaderMap,
    Json(request): Json<MatchRequest>,
) -> Result<impl IntoResponse, AppError> {
    let user = authenticate(&state.pool, &headers, &state.config).await?;
    require_verified_email(&user)?;
    let response = contest_service::match_user(&state.pool, user.id, &request).await?;
    Ok(ok(response))
}

pub async fn cancel_match(
    State(state): State<AppState>,
    headers: HeaderMap,
) -> Result<impl IntoResponse, AppError> {
    let user = authenticate(&state.pool, &headers, &state.config).await?;
    require_verified_email(&user)?;
    let response = contest_service::cancel_match(&state.pool, user.id).await?;
    Ok(ok(response))
}

pub async fn current(
    State(state): State<AppState>,
    headers: HeaderMap,
) -> Result<impl IntoResponse, AppError> {
    let user = authenticate(&state.pool, &headers, &state.config).await?;
    require_verified_email(&user)?;
    let response = contest_service::current(&state.pool, user.id).await?;
    Ok(ok(response))
}

pub async fn featured(
    State(state): State<AppState>,
    headers: HeaderMap,
) -> Result<impl IntoResponse, AppError> {
    let user = authenticate(&state.pool, &headers, &state.config).await?;
    require_verified_email(&user)?;
    let response = contest_service::featured(&state.pool, user.id).await?;
    Ok(ok(response))
}

pub async fn event_detail(
    State(state): State<AppState>,
    headers: HeaderMap,
    Path(event_id): Path<i32>,
) -> Result<impl IntoResponse, AppError> {
    let user = authenticate(&state.pool, &headers, &state.config).await?;
    require_verified_email(&user)?;
    let response = contest_service::event_detail(&state.pool, user.id, event_id).await?;
    Ok(ok(response))
}

pub async fn register_event(
    State(state): State<AppState>,
    headers: HeaderMap,
    Path(event_id): Path<i32>,
) -> Result<impl IntoResponse, AppError> {
    let user = authenticate(&state.pool, &headers, &state.config).await?;
    require_verified_email(&user)?;
    let response = contest_service::register_event(&state.pool, user.id, event_id).await?;
    Ok(ok(response))
}

pub async fn join_event(
    State(state): State<AppState>,
    headers: HeaderMap,
    Path(event_id): Path<i32>,
) -> Result<impl IntoResponse, AppError> {
    let user = authenticate(&state.pool, &headers, &state.config).await?;
    require_verified_email(&user)?;
    let response = contest_service::join_event(&state.pool, user.id, event_id).await?;
    Ok(ok(response))
}

pub async fn detail(
    State(state): State<AppState>,
    headers: HeaderMap,
    Path(contest_id): Path<i32>,
) -> Result<impl IntoResponse, AppError> {
    let user = authenticate(&state.pool, &headers, &state.config).await?;
    require_verified_email(&user)?;
    let response = contest_service::detail(&state.pool, user.id, contest_id).await?;
    Ok(ok(response))
}

pub async fn problem(
    State(state): State<AppState>,
    headers: HeaderMap,
    Path((contest_id, problem_id)): Path<(i32, i32)>,
) -> Result<impl IntoResponse, AppError> {
    let user = authenticate(&state.pool, &headers, &state.config).await?;
    require_verified_email(&user)?;
    let response =
        contest_service::problem_detail(&state.pool, user.id, contest_id, problem_id).await?;
    Ok(ok(response))
}

pub async fn finish(
    State(state): State<AppState>,
    headers: HeaderMap,
    Path(contest_id): Path<i32>,
) -> Result<impl IntoResponse, AppError> {
    let user = authenticate(&state.pool, &headers, &state.config).await?;
    require_verified_email(&user)?;
    let response = contest_service::finish(&state.pool, user.id, contest_id).await?;
    Ok(ok(response))
}

pub async fn result(
    State(state): State<AppState>,
    headers: HeaderMap,
    Path(contest_id): Path<i32>,
) -> Result<impl IntoResponse, AppError> {
    let user = authenticate(&state.pool, &headers, &state.config).await?;
    require_verified_email(&user)?;
    let response = contest_service::result(&state.pool, user.id, contest_id).await?;
    Ok(ok(response))
}

pub async fn events(
    State(state): State<AppState>,
    headers: HeaderMap,
    Path(contest_id): Path<i32>,
    Json(request): Json<ContestEventsRequest>,
) -> Result<impl IntoResponse, AppError> {
    let user = authenticate(&state.pool, &headers, &state.config).await?;
    require_verified_email(&user)?;
    let response =
        contest_service::record_events(&state.pool, user.id, contest_id, &request).await?;
    Ok(ok(response))
}
