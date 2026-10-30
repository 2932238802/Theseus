use axum::{
    Json,
    extract::{Path, Query, State},
    http::{HeaderMap, HeaderValue, header},
    response::{IntoResponse, Response},
};
use serde_json::json;

use crate::{
    AppState,
    common::{error::AppError, response::ok},
    middleware::auth::{authenticate, require_admin, require_verified_email},
    models::{
        contest::{
            AdminEventInput, ContestAppealInput, ContestAppealQuery, ContestAppealResolveInput,
            ContestEventListQuery, ContestEventsRequest, MatchRequest, ProctorReviewInput,
            RankedLeaderboardQuery,
        },
        season::AdminSeasonInput,
    },
    services::{
        audit_service::{self, AuditContext, AuditRecord},
        contest_service, season_service,
    },
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
    let response = contest_service::ranked_leaderboard(&state.pool, user.id, query).await?;
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
    let context = AuditContext::from_headers(&headers);
    audit_service::record(
        &state.pool,
        &user,
        &context,
        AuditRecord::new(
            "contest.proctor_review",
            "contest",
            Some(i64::from(contest_id)),
            format!(
                "复核竞赛 #{contest_id} 的监考事件 #{event_id}：{}",
                input.status.trim()
            ),
        )
        .after(json!({
            "event_id": event_id,
            "review_status": response.review_status,
            "disqualified": response.disqualified,
            "rating_reranked": response.rating_reranked,
            "note": input.note,
        })),
    )
    .await;
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
    let context = AuditContext::from_headers(&headers);
    audit_service::record(
        &state.pool,
        &admin,
        &context,
        AuditRecord::new(
            "contest.event_create",
            "contest_event",
            Some(i64::from(response.id)),
            format!("创建赛事《{}》", response.title),
        )
        .after(json!({
            "title": response.title,
            "type": response.event_type,
            "scope": response.scope,
        })),
    )
    .await;
    Ok(ok(response))
}

pub async fn admin_update_event(
    State(state): State<AppState>,
    headers: HeaderMap,
    Path(event_id): Path<i32>,
    Json(request): Json<AdminEventInput>,
) -> Result<impl IntoResponse, AppError> {
    let admin = require_admin(&state.pool, &headers, &state.config).await?;
    let response = contest_service::admin_update_event(&state.pool, event_id, request).await?;
    let context = AuditContext::from_headers(&headers);
    audit_service::record(
        &state.pool,
        &admin,
        &context,
        AuditRecord::new(
            "contest.event_update",
            "contest_event",
            Some(i64::from(event_id)),
            format!("更新赛事《{}》", response.title),
        )
        .after(json!({ "title": response.title, "type": response.event_type })),
    )
    .await;
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
    let context = AuditContext::from_headers(&headers);
    audit_service::record(
        &state.pool,
        &admin,
        &context,
        AuditRecord::new(
            "contest.event_forum",
            "contest_event",
            Some(i64::from(event_id)),
            format!("将赛事 #{event_id} 同步到校园墙"),
        )
        .after(json!({
            "forum_post_id": response.forum_post_id,
            "pinned": response.pinned,
        })),
    )
    .await;
    Ok(ok(response))
}

// ── 赛季 ───────────────────────────────────────────────────────────

pub async fn seasons(
    State(state): State<AppState>,
    headers: HeaderMap,
) -> Result<impl IntoResponse, AppError> {
    let user = authenticate(&state.pool, &headers, &state.config).await?;
    require_verified_email(&user)?;
    let response = season_service::list_public(&state.pool).await?;
    Ok(ok(response))
}

pub async fn admin_list_seasons(
    State(state): State<AppState>,
    headers: HeaderMap,
) -> Result<impl IntoResponse, AppError> {
    require_admin(&state.pool, &headers, &state.config).await?;
    let response = season_service::admin_list(&state.pool).await?;
    Ok(ok(response))
}

pub async fn admin_create_season(
    State(state): State<AppState>,
    headers: HeaderMap,
    Json(input): Json<AdminSeasonInput>,
) -> Result<impl IntoResponse, AppError> {
    let admin = require_admin(&state.pool, &headers, &state.config).await?;
    let response = season_service::admin_create(&state.pool, admin.id, input).await?;
    let context = AuditContext::from_headers(&headers);
    audit_service::record(
        &state.pool,
        &admin,
        &context,
        AuditRecord::new(
            "contest.season_create",
            "contest_season",
            Some(i64::from(response.id)),
            format!("创建赛季《{}》", response.name),
        )
        .after(json!({
            "name": response.name,
            "starts_at": response.starts_at,
            "ends_at": response.ends_at,
            "status": response.status,
            "soft_reset_ratio": response.soft_reset_ratio,
        })),
    )
    .await;
    Ok(ok(response))
}

pub async fn admin_update_season(
    State(state): State<AppState>,
    headers: HeaderMap,
    Path(season_id): Path<i32>,
    Json(input): Json<AdminSeasonInput>,
) -> Result<impl IntoResponse, AppError> {
    let admin = require_admin(&state.pool, &headers, &state.config).await?;
    let response = season_service::admin_update(&state.pool, season_id, input).await?;
    let context = AuditContext::from_headers(&headers);
    audit_service::record(
        &state.pool,
        &admin,
        &context,
        AuditRecord::new(
            "contest.season_update",
            "contest_season",
            Some(i64::from(season_id)),
            format!("更新赛季《{}》", response.name),
        )
        .after(json!({
            "name": response.name,
            "starts_at": response.starts_at,
            "ends_at": response.ends_at,
            "status": response.status,
            "soft_reset_ratio": response.soft_reset_ratio,
        })),
    )
    .await;
    Ok(ok(response))
}

// ── 赛事申诉 ───────────────────────────────────────────────────────

pub async fn submit_appeal(
    State(state): State<AppState>,
    headers: HeaderMap,
    Path(contest_id): Path<i32>,
    Json(input): Json<ContestAppealInput>,
) -> Result<impl IntoResponse, AppError> {
    let user = authenticate(&state.pool, &headers, &state.config).await?;
    require_verified_email(&user)?;
    let response = contest_service::submit_appeal(&state.pool, user.id, contest_id, &input).await?;
    Ok(ok(response))
}

pub async fn my_appeals(
    State(state): State<AppState>,
    headers: HeaderMap,
    Query(query): Query<ContestAppealQuery>,
) -> Result<impl IntoResponse, AppError> {
    let user = authenticate(&state.pool, &headers, &state.config).await?;
    require_verified_email(&user)?;
    let response = contest_service::list_my_appeals(&state.pool, user.id, &query).await?;
    Ok(ok(response))
}

pub async fn admin_list_appeals(
    State(state): State<AppState>,
    headers: HeaderMap,
    Query(query): Query<ContestAppealQuery>,
) -> Result<impl IntoResponse, AppError> {
    require_admin(&state.pool, &headers, &state.config).await?;
    let response = contest_service::admin_list_appeals(&state.pool, &query).await?;
    Ok(ok(response))
}

pub async fn admin_resolve_appeal(
    State(state): State<AppState>,
    headers: HeaderMap,
    Path(appeal_id): Path<i64>,
    Json(input): Json<ContestAppealResolveInput>,
) -> Result<impl IntoResponse, AppError> {
    let admin = require_admin(&state.pool, &headers, &state.config).await?;
    let response =
        contest_service::admin_resolve_appeal(&state.pool, appeal_id, admin.id, &input).await?;
    let context = AuditContext::from_headers(&headers);
    audit_service::record(
        &state.pool,
        &admin,
        &context,
        AuditRecord::new(
            "contest.appeal_resolve",
            "contest_appeal",
            Some(appeal_id),
            format!("处理竞赛申诉 #{appeal_id}：{}", input.status.trim()),
        )
        .after(json!({
            "status": response.status,
            "disqualified": response.disqualified,
            "rating_reranked": response.rating_reranked,
            "note": input.note,
        })),
    )
    .await;
    Ok(ok(response))
}

// ── 成绩导出 ───────────────────────────────────────────────────────

pub async fn export_event_results(
    State(state): State<AppState>,
    headers: HeaderMap,
    Path(event_id): Path<i32>,
) -> Result<Response, AppError> {
    let admin = require_admin(&state.pool, &headers, &state.config).await?;
    let (title, csv) = contest_service::export_event_results(&state.pool, event_id).await?;
    let context = AuditContext::from_headers(&headers);
    audit_service::record(
        &state.pool,
        &admin,
        &context,
        AuditRecord::new(
            "contest.results_export",
            "contest_event",
            Some(i64::from(event_id)),
            format!("导出赛事《{title}》成绩"),
        ),
    )
    .await;

    let filename = format!("event-{event_id}-results.csv");
    let disposition = HeaderValue::from_str(&format!("attachment; filename=\"{filename}\""))
        .map_err(|_| AppError::Internal("导出文件名无效".to_owned()))?;
    let mut response = csv.into_response();
    response.headers_mut().insert(
        header::CONTENT_TYPE,
        HeaderValue::from_static("text/csv; charset=utf-8"),
    );
    response
        .headers_mut()
        .insert(header::CONTENT_DISPOSITION, disposition);
    Ok(response)
}
