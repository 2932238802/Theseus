use axum::{
    Json,
    extract::{Path, Query, State},
    http::HeaderMap,
    response::IntoResponse,
};

use crate::{
    AppState,
    common::{error::AppError, response::ok},
    middleware::auth::{authenticate, require_admin, require_verified_email},
    models::contest::{
        AdminEventInput, ContestEventListQuery, ContestEventsRequest, MatchRequest,
        ProctorReviewInput, RankedLeaderboardQuery,
    },
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
    if response.state == "matched"
        && let Some(contest) = &response.contest
    {
        // 匹配只发生在调用者的请求里，其余选手没有同步返回路径，
        // 因此在这里向房间内所有人推送 match.found；客户端收到后自行拉取详情。
        match contest_service::participant_user_ids(&state.pool, contest.id).await {
            Ok(participants) => {
                let payload = serde_json::json!({
                    "contest_id": contest.id,
                    "starts_at": contest.starts_at,
                    "ends_at": contest.ends_at,
                    "participant_count": contest.participant_count,
                });
                state
                    .realtime
                    .publish_to(&participants, "match.found", &payload);
            }
            Err(error) => {
                tracing::warn!(error = %error, contest_id = contest.id, "failed to load match participants for realtime push");
            }
        }
    }
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

pub async fn event_list(
    State(state): State<AppState>,
    headers: HeaderMap,
    Query(query): Query<ContestEventListQuery>,
) -> Result<impl IntoResponse, AppError> {
    let user = authenticate(&state.pool, &headers, &state.config).await?;
    require_verified_email(&user)?;
    let response = contest_service::list_events(&state.pool, user.id, query).await?;
    Ok(ok(response))
}

pub async fn follow_event(
    State(state): State<AppState>,
    headers: HeaderMap,
    Path(event_id): Path<i32>,
) -> Result<impl IntoResponse, AppError> {
    let user = authenticate(&state.pool, &headers, &state.config).await?;
    require_verified_email(&user)?;
    let response = contest_service::follow_event(&state.pool, user.id, event_id, true).await?;
    Ok(ok(response))
}

pub async fn unfollow_event(
    State(state): State<AppState>,
    headers: HeaderMap,
    Path(event_id): Path<i32>,
) -> Result<impl IntoResponse, AppError> {
    let user = authenticate(&state.pool, &headers, &state.config).await?;
    require_verified_email(&user)?;
    let response = contest_service::follow_event(&state.pool, user.id, event_id, false).await?;
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

pub async fn heartbeat(
    State(state): State<AppState>,
    headers: HeaderMap,
    Path(contest_id): Path<i32>,
) -> Result<impl IntoResponse, AppError> {
    let user = authenticate(&state.pool, &headers, &state.config).await?;
    require_verified_email(&user)?;
    let response = contest_service::heartbeat(&state.pool, user.id, contest_id).await?;
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

pub async fn enter_event(
    State(state): State<AppState>,
    headers: HeaderMap,
    Path(event_id): Path<i32>,
) -> Result<impl IntoResponse, AppError> {
    let user = authenticate(&state.pool, &headers, &state.config).await?;
    require_verified_email(&user)?;
    let response = contest_service::enter_event(&state.pool, user.id, event_id).await?;
    Ok(ok(response))
}

pub async fn event_leaderboard(
    State(state): State<AppState>,
    headers: HeaderMap,
    Path(event_id): Path<i32>,
) -> Result<impl IntoResponse, AppError> {
    let user = authenticate(&state.pool, &headers, &state.config).await?;
    require_verified_email(&user)?;
    let response = contest_service::event_leaderboard(&state.pool, user.id, event_id).await?;
    Ok(ok(response))
}

pub async fn ranked_leaderboard(
    State(state): State<AppState>,
    headers: HeaderMap,
    Query(query): Query<RankedLeaderboardQuery>,
) -> Result<impl IntoResponse, AppError> {
    let user = authenticate(&state.pool, &headers, &state.config).await?;
    require_verified_email(&user)?;
    let response = contest_service::ranked_leaderboard(&state.pool, user.id, query.limit).await?;
    Ok(ok(response))
}

pub async fn admin_list_events(
    State(state): State<AppState>,
    headers: HeaderMap,
) -> Result<impl IntoResponse, AppError> {
    require_admin(&state.pool, &headers, &state.config).await?;
    let response = contest_service::admin_list_events(&state.pool).await?;
    Ok(ok(response))
}

pub async fn admin_proctor_events(
    State(state): State<AppState>,
    headers: HeaderMap,
    Path(contest_id): Path<i32>,
) -> Result<impl IntoResponse, AppError> {
    let admin = require_admin(&state.pool, &headers, &state.config).await?;
    let response = contest_service::proctor_events(&state.pool, admin.id, contest_id).await?;
    Ok(ok(response))
}

pub async fn admin_review_proctor_event(
    State(state): State<AppState>,
    headers: HeaderMap,
    Path((contest_id, event_id)): Path<(i32, i64)>,
    Json(input): Json<ProctorReviewInput>,
) -> Result<impl IntoResponse, AppError> {
    let user = require_admin(&state.pool, &headers, &state.config).await?;
    let response =
        contest_service::review_proctor_event(&state.pool, contest_id, event_id, user.id, &input)
            .await?;
    Ok(ok(response))
}

pub async fn admin_get_event(
    State(state): State<AppState>,
    headers: HeaderMap,
    Path(event_id): Path<i32>,
) -> Result<impl IntoResponse, AppError> {
    require_admin(&state.pool, &headers, &state.config).await?;
    let response = contest_service::admin_get_event(&state.pool, event_id).await?;
    Ok(ok(response))
}

pub async fn admin_create_event(
    State(state): State<AppState>,
    headers: HeaderMap,
    Json(request): Json<AdminEventInput>,
) -> Result<impl IntoResponse, AppError> {
    let admin = require_admin(&state.pool, &headers, &state.config).await?;
    let response = contest_service::admin_create_event(&state.pool, admin.id, request).await?;
    Ok(ok(response))
}

pub async fn admin_update_event(
    State(state): State<AppState>,
    headers: HeaderMap,
    Path(event_id): Path<i32>,
    Json(request): Json<AdminEventInput>,
) -> Result<impl IntoResponse, AppError> {
    require_admin(&state.pool, &headers, &state.config).await?;
    let response = contest_service::admin_update_event(&state.pool, event_id, request).await?;
    Ok(ok(response))
}

pub async fn sync_event_forum(
    State(state): State<AppState>,
    headers: HeaderMap,
    Path(event_id): Path<i32>,
) -> Result<impl IntoResponse, AppError> {
    let admin = require_admin(&state.pool, &headers, &state.config).await?;
    let response =
        contest_service::sync_event_forum(&state.pool, &state.config, &admin, event_id).await?;
    Ok(ok(response))
}
