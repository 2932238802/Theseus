use std::cmp::Ordering;
use std::collections::HashMap;

use chrono::{DateTime, Utc};
use serde_json::{Value, json};
use sqlx::{FromRow, PgPool};

use crate::{
    common::error::AppError,
    config::Config,
    middleware::auth::AuthUser,
    models::contest::{
        AdminEventInput, AdminEventListResponse, AdminEventView, CAMERA_PERMISSIONS,
        CONTEST_EVENT_TYPES, CONTEST_STATUS_CANCELLED, CONTEST_STATUS_FINISHED,
        CONTEST_STATUS_RUNNING, CONTEST_STATUS_SETTLING, CancelMatchResponse, ContestAppealInput,
        ContestAppealItem, ContestAppealListResponse, ContestAppealQuery,
        ContestAppealResolveInput, ContestAppealResolveResponse, ContestDetailResponse,
        ContestEventCard, ContestEventDetailResponse, ContestEventInput, ContestEventListQuery,
        ContestEventListResponse, ContestEventsRequest, ContestEventsResponse,
        ContestHeartbeatResponse, ContestParticipantRow, ContestParticipantView,
        ContestProblemDetail, ContestProblemDetailRow, ContestProblemSummary, ContestRankingItem,
        ContestResultContest, ContestResultMine, ContestResultResponse, ContestRow,
        ContestScoreDetail, ContestSummary, CurrentContestResponse, DEFAULT_CONTEST_RATING,
        EVENT_ACTION_CLOSED, EVENT_ACTION_DETAILS, EVENT_ACTION_ENTER, EVENT_ACTION_FULL,
        EVENT_ACTION_JOIN, EVENT_ACTION_REGISTER, EVENT_STATUS_FINISHED, EVENT_STATUS_FULL,
        EVENT_STATUS_REGISTRATION, EVENT_STATUS_RUNNING, EVENT_STATUS_UPCOMING, EnterEventResponse,
        EventForumSyncResponse, EventLeaderboardEntry, EventLeaderboardResponse, EventRuleGroup,
        FeaturedContestsResponse, FinishContestResponse, FollowEventResponse, MatchRequest,
        MatchResponse, PARTICIPANT_STATUS_ACTIVE, PARTICIPANT_STATUS_DISCONNECTED,
        PARTICIPANT_STATUS_FINISHED, PARTICIPANT_STATUS_TIMED_OUT, ProctorContestInfo,
        ProctorEventItem, ProctorEventListResponse, ProctorReviewInput, ProctorReviewResponse,
        RATING_GAIN_FIRST, RATING_GAIN_SECOND, RATING_LOSS_FOURTH, RATING_WINDOW, RankedConfig,
        RankedLeaderboardEntry, RankedLeaderboardQuery, RankedLeaderboardResponse,
        SCREEN_PERMISSIONS,
    },
    models::forum::{AdminPinRequest, CreatePostRequest, MAX_TITLE_CHARS},
    models::season::SeasonSummary,
    services::{forum_service, notification_service, season_service},
};

const CONTEST_LOCK_NAMESPACE: i32 = 5;
const DURATION_SECONDS: i32 = 60 * 60;
const PROBLEMS_PER_CONTEST: i64 = 4;
const SOLVE_WEIGHT: f64 = 0.60;
const SPEED_WEIGHT: f64 = 0.25;
const CODING_WEIGHT: f64 = 0.15;
const MAX_EVENTS_PER_REQUEST: usize = 100;
const MAX_EVENT_ID_CHARS: usize = 64;
const SETTLE_GRACE_SECONDS: i64 = 20;
/// A player with no heartbeat for this long is treated as disconnected.
const DISCONNECT_AFTER_SECONDS: i64 = 30;
/// A disconnected player may still reconnect and resume until this long after
/// the last heartbeat, at which point the score is frozen.
const RECONNECT_GRACE_SECONDS: i64 = 120;
const MATCH_FALLBACK_THREE_SECONDS: i64 = 180;
const MATCH_FALLBACK_TWO_SECONDS: i64 = 300;
const FALLBACK_RATING_WINDOW: i32 = 150;
const REPUTATION_PENALTY: f64 = 25.0;
const REPUTATION_RESTRICT_BELOW: f64 = 40.0;
const FEATURED_EVENT_LIMIT: usize = 3;
const EVENT_PAGE_SIZE_DEFAULT: i64 = 12;
const EVENT_PAGE_SIZE_MAX: i64 = 50;
const EVENT_TYPE_FILTERS: [&str; 3] = ["official", "teacher", "school"];
const EVENT_STATUS_FILTERS: [&str; 5] = [
    EVENT_STATUS_REGISTRATION,
    EVENT_STATUS_UPCOMING,
    EVENT_STATUS_RUNNING,
    EVENT_STATUS_FULL,
    EVENT_STATUS_FINISHED,
];

#[derive(Debug, FromRow)]
struct SummaryRow {
    id: i32,
    official_event_id: Option<i32>,
    status: String,
    duration_seconds: i32,
    problem_count: i32,
    starts_at: DateTime<Utc>,
    ends_at: DateTime<Utc>,
    finished_at: Option<DateTime<Utc>>,
    participant_count: i64,
    my_status: String,
}

#[derive(Debug, FromRow)]
struct ProblemSnapshotRow {
    id: i32,
    title: String,
    description: String,
    difficulty: String,
    time_limit: i32,
    memory_limit: i32,
    tags: Vec<String>,
    examples: Option<Value>,
    code_template: Option<Value>,
    run_config: Option<Value>,
    judge_cases: Option<Value>,
}

#[derive(Debug, FromRow, Clone)]
struct QueueRow {
    user_id: i32,
    camera_permission: Option<String>,
    screen_permission: Option<String>,
    rating: i32,
    joined_at: DateTime<Utc>,
}

#[derive(Debug, FromRow)]
struct ContestSubmissionRow {
    problem_id: i32,
    status: String,
    submitted_at: DateTime<Utc>,
}

pub struct ContestSubmissionContext {
    pub run_config: Value,
    pub judge_cases: Option<Value>,
}

#[derive(Debug, Default, Clone)]
struct ProblemAggregate {
    attempts: i64,
    wrong_answer: i64,
    compile_error: i64,
    runtime_error: i64,
    accepted_at: Option<DateTime<Utc>>,
}

pub async fn match_user(
    pool: &PgPool,
    user_id: i32,
    request: &MatchRequest,
) -> Result<MatchResponse, AppError> {
    let camera = normalize_camera(request.camera_permission.as_deref())?;
    let screen = normalize_screen(request.screen_permission.as_deref())?;

    if let Some(contest_id) = active_contest_id(pool, user_id).await? {
        let summary = fetch_summary(pool, contest_id, user_id).await?;
        return Ok(MatchResponse {
            state: "matched".to_owned(),
            queue_position: None,
            contest: Some(summary),
            message: "你已在一场比赛中".to_owned(),
        });
    }

    ensure_reputation_for_ranked(pool, user_id).await?;
    // 赛季激活必须发生在入队前，否则本场会按旧段位匹配。
    season_service::ensure_active_season(pool).await?;

    if camera.as_deref() != Some("granted") {
        return Err(AppError::BadRequest(
            "需要开启摄像头权限后才能开始排位赛".to_owned(),
        ));
    }
    if screen.as_deref() != Some("granted") {
        return Err(AppError::BadRequest(
            "需要共享屏幕后才能开始排位赛".to_owned(),
        ));
    }

    if let Some(position) = queue_position(pool, user_id).await? {
        return Ok(MatchResponse {
            state: "queued".to_owned(),
            queue_position: Some(position),
            contest: None,
            message: "正在等待段位分相近的对手".to_owned(),
        });
    }

    sqlx::query(
        "INSERT INTO contest_queue (user_id, camera_permission, screen_permission) VALUES ($1, $2, $3) \
         ON CONFLICT (user_id) DO UPDATE SET camera_permission = EXCLUDED.camera_permission, \
             screen_permission = EXCLUDED.screen_permission",
    )
    .bind(user_id)
    .bind(camera.as_deref())
    .bind(screen.as_deref())
    .execute(pool)
    .await
    .map_err(AppError::Database)?;

    if let Some(contest_id) = try_match(pool).await? {
        let summary = fetch_summary(pool, contest_id, user_id).await?;
        return Ok(MatchResponse {
            state: "matched".to_owned(),
            queue_position: None,
            contest: Some(summary),
            message: "匹配成功，比赛开始".to_owned(),
        });
    }

    let position = queue_position(pool, user_id).await?.unwrap_or(1);
    Ok(MatchResponse {
        state: "queued".to_owned(),
        queue_position: Some(position),
        contest: None,
        message: "已加入匹配队列，正在等待段位分相近的对手".to_owned(),
    })
}

/// 比赛内的选手 ID，用于匹配成功后向所有参赛者推送实时事件。
pub async fn participant_user_ids(pool: &PgPool, contest_id: i32) -> Result<Vec<i32>, AppError> {
    let rows: Vec<(i32,)> = sqlx::query_as(
        "SELECT user_id FROM contest_participants WHERE contest_id = $1 ORDER BY user_id",
    )
    .bind(contest_id)
    .fetch_all(pool)
    .await
    .map_err(AppError::Database)?;
    Ok(rows.into_iter().map(|(user_id,)| user_id).collect())
}

pub async fn cancel_match(pool: &PgPool, user_id: i32) -> Result<CancelMatchResponse, AppError> {
    if let Some(contest_id) = active_contest_id(pool, user_id).await? {
        let status: String = sqlx::query_scalar("SELECT status FROM contests WHERE id = $1")
            .bind(contest_id)
            .fetch_one(pool)
            .await
            .map_err(AppError::Database)?;
        if status == CONTEST_STATUS_RUNNING || status == CONTEST_STATUS_SETTLING {
            return Err(AppError::ConflictWith(
                "比赛已经成局，无法取消匹配".to_owned(),
            ));
        }
    }
    let removed = sqlx::query("DELETE FROM contest_queue WHERE user_id = $1")
        .bind(user_id)
        .execute(pool)
        .await
        .map_err(AppError::Database)?
        .rows_affected();
    Ok(CancelMatchResponse {
        message: if removed > 0 {
            "已取消匹配".to_owned()
        } else {
            "当前不在匹配队列中".to_owned()
        },
    })
}

pub async fn current(pool: &PgPool, user_id: i32) -> Result<CurrentContestResponse, AppError> {
    let my_rating = user_rating(pool, user_id).await?;
    if let Some(contest_id) = active_contest_id(pool, user_id).await? {
        let summary = fetch_summary(pool, contest_id, user_id).await?;
        return Ok(CurrentContestResponse {
            state: "contest".to_owned(),
            queue_position: None,
            queued_at: None,
            contest: Some(summary),
            my_rating,
            rating_window: RATING_WINDOW,
            server_time: Utc::now(),
        });
    }

    let queued: Option<(DateTime<Utc>,)> =
        sqlx::query_as("SELECT joined_at FROM contest_queue WHERE user_id = $1")
            .bind(user_id)
            .fetch_optional(pool)
            .await
            .map_err(AppError::Database)?;
    if let Some((joined_at,)) = queued {
        let position = queue_position(pool, user_id).await?.unwrap_or(1);
        return Ok(CurrentContestResponse {
            state: "queued".to_owned(),
            queue_position: Some(position),
            queued_at: Some(joined_at),
            contest: None,
            my_rating,
            rating_window: RATING_WINDOW,
            server_time: Utc::now(),
        });
    }

    Ok(CurrentContestResponse {
        state: "idle".to_owned(),
        queue_position: None,
        queued_at: None,
        contest: None,
        my_rating,
        rating_window: RATING_WINDOW,
        server_time: Utc::now(),
    })
}

pub async fn detail(
    pool: &PgPool,
    user_id: i32,
    contest_id: i32,
) -> Result<ContestDetailResponse, AppError> {
    let my_status = participant_status(pool, contest_id, user_id)
        .await?
        .ok_or_else(|| AppError::NotFound("比赛不存在".to_owned()))?;
    let my_rating = user_rating(pool, user_id).await?;
    let contest = fetch_contest_row(pool, contest_id).await?;

    let problems = sqlx::query_as::<_, ContestProblemSummary>(
        "SELECT cp.problem_id, cp.position, cp.title, cp.difficulty, cp.tags, cp.points, \
         EXISTS(SELECT 1 FROM submissions s \
                WHERE s.contest_id = cp.contest_id AND s.user_id = $2 \
                  AND s.problem_id = cp.problem_id AND s.status = 'accepted') AS accepted, \
         (SELECT COUNT(*) FROM submissions s \
          WHERE s.contest_id = cp.contest_id AND s.user_id = $2 \
            AND s.problem_id = cp.problem_id) AS attempts \
         FROM contest_problems cp WHERE cp.contest_id = $1 ORDER BY cp.position",
    )
    .bind(contest_id)
    .bind(user_id)
    .fetch_all(pool)
    .await
    .map_err(AppError::Database)?;

    let participants = sqlx::query_as::<_, ContestParticipantRow>(
        "SELECT p.user_id, u.username, p.status, p.finished_at, p.total_score, p.rank, \
         (SELECT COUNT(DISTINCT s.problem_id)::int FROM submissions s \
          WHERE s.contest_id = p.contest_id AND s.user_id = p.user_id \
            AND s.status = 'accepted') AS solved_count \
         FROM contest_participants p JOIN users u ON u.id = p.user_id \
         WHERE p.contest_id = $1 ORDER BY p.joined_at, p.user_id",
    )
    .bind(contest_id)
    .fetch_all(pool)
    .await
    .map_err(AppError::Database)?;

    let settled = contest.status == CONTEST_STATUS_FINISHED;
    let me = participants.iter().find(|row| row.user_id == user_id);
    Ok(ContestDetailResponse {
        id: contest.id,
        event_id: contest.official_event_id,
        status: contest.status.clone(),
        duration_seconds: contest.duration_seconds,
        problem_count: contest.problem_count,
        starts_at: contest.starts_at,
        ends_at: contest.ends_at,
        finished_at: contest.finished_at,
        server_time: Utc::now(),
        my_status,
        my_rank: me.and_then(|row| settled.then_some(row.rank)).flatten(),
        my_total_score: me
            .and_then(|row| settled.then_some(row.total_score))
            .flatten(),
        my_rating,
        rating_window: RATING_WINDOW,
        problems,
        participants: participants
            .into_iter()
            .map(|row| ContestParticipantView {
                user_id: row.user_id,
                username: row.username,
                status: row.status,
                finished_at: row.finished_at,
                solved_count: row.solved_count,
                total_score: if settled { row.total_score } else { None },
                rank: if settled { row.rank } else { None },
            })
            .collect(),
    })
}

pub async fn problem_detail(
    pool: &PgPool,
    user_id: i32,
    contest_id: i32,
    problem_id: i32,
) -> Result<ContestProblemDetail, AppError> {
    if participant_status(pool, contest_id, user_id)
        .await?
        .is_none()
    {
        return Err(AppError::NotFound("比赛不存在".to_owned()));
    }
    let row = sqlx::query_as::<_, ContestProblemDetailRow>(
        "SELECT problem_id, title, description, difficulty, time_limit, memory_limit, tags, \
         examples, code_template, run_config \
         FROM contest_problems WHERE contest_id = $1 AND problem_id = $2",
    )
    .bind(contest_id)
    .bind(problem_id)
    .fetch_optional(pool)
    .await
    .map_err(AppError::Database)?
    .ok_or_else(|| AppError::NotFound("题目不属于该场比赛".to_owned()))?;
    Ok(row.into_detail())
}

pub async fn finish(
    pool: &PgPool,
    user_id: i32,
    contest_id: i32,
) -> Result<FinishContestResponse, AppError> {
    let contest_status: String = sqlx::query_scalar("SELECT status FROM contests WHERE id = $1")
        .bind(contest_id)
        .fetch_optional(pool)
        .await
        .map_err(AppError::Database)?
        .ok_or_else(|| AppError::NotFound("比赛不存在".to_owned()))?;
    if contest_status != CONTEST_STATUS_RUNNING {
        return Err(AppError::ConflictWith("比赛已结束".to_owned()));
    }

    let updated = sqlx::query(
        "UPDATE contest_participants SET status = 'finished', \
         finished_at = COALESCE(finished_at, CURRENT_TIMESTAMP) \
         WHERE contest_id = $1 AND user_id = $2 AND status = 'active'",
    )
    .bind(contest_id)
    .bind(user_id)
    .execute(pool)
    .await
    .map_err(AppError::Database)?
    .rows_affected();

    if updated == 0 {
        let status = participant_status(pool, contest_id, user_id)
            .await?
            .ok_or_else(|| AppError::NotFound("比赛不存在".to_owned()))?;
        if status == PARTICIPANT_STATUS_FINISHED {
            return Ok(FinishContestResponse {
                finished: true,
                message: "你已离场".to_owned(),
            });
        }
        return Err(AppError::ConflictWith("当前状态无法离场".to_owned()));
    }

    let remaining: i64 = sqlx::query_scalar(
        "SELECT COUNT(*) FROM contest_participants WHERE contest_id = $1 \
         AND status IN ('active', 'disconnected')",
    )
    .bind(contest_id)
    .fetch_one(pool)
    .await
    .map_err(AppError::Database)?;

    // Event contests keep their fixed end time even when every current
    // participant leaves, so late entrants can still join before the deadline.
    let is_event_contest: bool =
        sqlx::query_scalar("SELECT official_event_id IS NOT NULL FROM contests WHERE id = $1")
            .bind(contest_id)
            .fetch_one(pool)
            .await
            .map_err(AppError::Database)?;

    if remaining == 0 && !is_event_contest {
        settle_contest(pool, contest_id).await?;
        Ok(FinishContestResponse {
            finished: true,
            message: "全部参赛者已离场，比赛进入结算".to_owned(),
        })
    } else {
        Ok(FinishContestResponse {
            finished: true,
            message: if is_event_contest {
                "已标记完成并离场，赛事结束后统一结算".to_owned()
            } else {
                "已标记完成并离场，其他参赛者继续作答".to_owned()
            },
        })
    }
}

/// Records that the player is still on the contest page. A heartbeat from a
/// `disconnected` player restores `active`; other statuses are returned
/// read-only so the client can show the right message.
pub async fn heartbeat(
    pool: &PgPool,
    user_id: i32,
    contest_id: i32,
) -> Result<ContestHeartbeatResponse, AppError> {
    #[derive(FromRow)]
    struct HeartbeatRow {
        contest_status: String,
        ends_at: DateTime<Utc>,
        my_status: String,
        disconnected_at: Option<DateTime<Utc>>,
        disqualified_at: Option<DateTime<Utc>>,
    }

    let row = sqlx::query_as::<_, HeartbeatRow>(
        "SELECT c.status AS contest_status, c.ends_at, p.status AS my_status, \
                p.disconnected_at, p.disqualified_at \
         FROM contests c JOIN contest_participants p ON p.contest_id = c.id AND p.user_id = $2 \
         WHERE c.id = $1",
    )
    .bind(contest_id)
    .bind(user_id)
    .fetch_optional(pool)
    .await
    .map_err(AppError::Database)?
    .ok_or_else(|| AppError::NotFound("比赛不存在".to_owned()))?;

    if row.contest_status != CONTEST_STATUS_RUNNING {
        return Err(AppError::ConflictWith("比赛已结束".to_owned()));
    }

    let mut my_status = row.my_status;
    let mut disconnected_at = row.disconnected_at;
    let can_report = row.disqualified_at.is_none()
        && (my_status == PARTICIPANT_STATUS_ACTIVE || my_status == PARTICIPANT_STATUS_DISCONNECTED);

    if can_report {
        let updated: Option<(String, Option<DateTime<Utc>>)> = sqlx::query_as(
            "UPDATE contest_participants SET last_seen_at = CURRENT_TIMESTAMP, \
             status = CASE WHEN status = 'disconnected' THEN 'active' ELSE status END, \
             disconnected_at = CASE WHEN status = 'disconnected' THEN NULL \
                                    ELSE disconnected_at END \
             WHERE contest_id = $1 AND user_id = $2 \
               AND status IN ('active', 'disconnected') \
             RETURNING status, disconnected_at",
        )
        .bind(contest_id)
        .bind(user_id)
        .fetch_optional(pool)
        .await
        .map_err(AppError::Database)?;

        match updated {
            Some((status, disconnected)) => {
                my_status = status;
                disconnected_at = disconnected;
            }
            // The presence sweep froze the score between our read and update.
            None => {
                my_status = participant_status(pool, contest_id, user_id)
                    .await?
                    .unwrap_or(my_status);
                if my_status == PARTICIPANT_STATUS_TIMED_OUT {
                    disconnected_at = None;
                }
            }
        }
    }

    Ok(ContestHeartbeatResponse {
        contest_id,
        status: row.contest_status,
        my_status,
        ends_at: row.ends_at,
        disconnected_at,
        reconnect_grace_seconds: RECONNECT_GRACE_SECONDS,
        server_time: Utc::now(),
    })
}

pub async fn result(
    pool: &PgPool,
    user_id: i32,
    contest_id: i32,
) -> Result<ContestResultResponse, AppError> {
    if participant_status(pool, contest_id, user_id)
        .await?
        .is_none()
    {
        return Err(AppError::NotFound("比赛不存在".to_owned()));
    }
    let contest = fetch_contest_row(pool, contest_id).await?;
    if contest.status != CONTEST_STATUS_FINISHED {
        return Err(AppError::ConflictWith("比赛尚未结束".to_owned()));
    }

    #[derive(FromRow)]
    struct ResultRow {
        user_id: i32,
        username: String,
        total_score: Option<f64>,
        solved_count: i32,
        speed_score: f64,
        coding_score: f64,
        finished_at: Option<DateTime<Utc>>,
        rank: Option<i32>,
        detail: Option<Value>,
        disqualified: bool,
        rating_before: Option<i32>,
        rating_after: Option<i32>,
        rating_delta: Option<i32>,
    }

    let rows = sqlx::query_as::<_, ResultRow>(
        "SELECT p.user_id, u.username, p.total_score, p.solved_count, p.speed_score, \
         p.coding_score, p.finished_at, p.rank, p.detail, \
         (p.disqualified_at IS NOT NULL) AS disqualified, \
         p.rating_before, p.rating_after, p.rating_delta \
         FROM contest_participants p JOIN users u ON u.id = p.user_id \
         WHERE p.contest_id = $1 AND p.status IN ('active', 'disconnected', 'timed_out', 'finished') \
         ORDER BY p.rank NULLS LAST, p.total_score DESC NULLS LAST, p.user_id",
    )
    .bind(contest_id)
    .fetch_all(pool)
    .await
    .map_err(AppError::Database)?;

    let mut ranking = Vec::with_capacity(rows.len());
    let mut mine = None;
    for row in rows {
        let item = ContestRankingItem {
            rank: row.rank.unwrap_or(0),
            user_id: row.user_id,
            username: row.username,
            total_score: round2(row.total_score.unwrap_or(0.0)),
            solved_count: row.solved_count,
            speed_score: round2(row.speed_score),
            coding_score: round2(row.coding_score),
            finished_at: row.finished_at,
            is_me: row.user_id == user_id,
            disqualified: row.disqualified,
            rating_before: row.rating_before,
            rating_after: row.rating_after,
            rating_delta: row.rating_delta,
        };
        if item.is_me {
            let detail = row
                .detail
                .and_then(|value| serde_json::from_value::<Vec<ContestScoreDetail>>(value).ok())
                .unwrap_or_default();
            mine = Some(ContestResultMine {
                ranking: item.clone(),
                detail,
            });
        }
        ranking.push(item);
    }

    Ok(ContestResultResponse {
        contest: ContestResultContest {
            id: contest.id,
            event_id: contest.official_event_id,
            status: contest.status,
            duration_seconds: contest.duration_seconds,
            problem_count: contest.problem_count,
            starts_at: contest.starts_at,
            ends_at: contest.ends_at,
            finished_at: contest.finished_at,
        },
        ranking,
        mine,
    })
}

pub async fn record_events(
    pool: &PgPool,
    user_id: i32,
    contest_id: i32,
    request: &ContestEventsRequest,
) -> Result<ContestEventsResponse, AppError> {
    if request.events.is_empty() {
        return Err(AppError::BadRequest("事件列表不能为空".to_owned()));
    }
    if request.events.len() > MAX_EVENTS_PER_REQUEST {
        return Err(AppError::BadRequest(format!(
            "单次最多上传 {MAX_EVENTS_PER_REQUEST} 条事件"
        )));
    }
    if participant_status(pool, contest_id, user_id)
        .await?
        .is_none()
    {
        return Err(AppError::NotFound("比赛不存在".to_owned()));
    }

    let mut transaction = pool.begin().await.map_err(AppError::Database)?;
    let mut accepted = 0u64;
    for event in &request.events {
        validate_event(event)?;
        let payload = event.payload.clone().unwrap_or_else(|| json!({}));
        let inserted: Option<i64> = sqlx::query_scalar(
            "INSERT INTO contest_events \
             (contest_id, user_id, event_id, event_type, payload, client_time, session_id) \
             VALUES ($1, $2, $3, $4, $5, $6, $7) ON CONFLICT DO NOTHING RETURNING id",
        )
        .bind(contest_id)
        .bind(user_id)
        .bind(event.event_id.trim())
        .bind(event.event_type.trim())
        .bind(payload)
        .bind(event.client_time)
        .bind(event.session_id.as_deref().map(str::trim))
        .fetch_optional(&mut *transaction)
        .await
        .map_err(AppError::Database)?;
        if let Some(event_row_id) = inserted {
            accepted += 1;
            if event.event_type.trim() == "paste_suspicious" {
                assign_proctor_event(&mut transaction, event_row_id).await?;
            }
        }
    }
    transaction.commit().await.map_err(AppError::Database)?;

    Ok(ContestEventsResponse {
        accepted,
        duplicates: request.events.len() as u64 - accepted,
        message: "事件已记录".to_owned(),
    })
}

/// Assigns a paste review to the active admin with the fewest pending reviews.
/// When there is no active admin the event stays unassigned and any admin can take it.
async fn assign_proctor_event(
    transaction: &mut sqlx::Transaction<'_, sqlx::Postgres>,
    event_id: i64,
) -> Result<(), AppError> {
    sqlx::query(
        "INSERT INTO contest_proctor_assignments (event_id, assigned_admin_id) \
         SELECT $1, u.id FROM users u \
         WHERE u.role = 'admin' AND u.status = 'active' \
         ORDER BY ( \
             SELECT COUNT(*) FROM contest_proctor_assignments a \
             LEFT JOIN contest_event_reviews r ON r.event_id = a.event_id \
             WHERE a.assigned_admin_id = u.id AND r.event_id IS NULL \
         ) ASC, u.id \
         LIMIT 1 \
         ON CONFLICT (event_id) DO NOTHING",
    )
    .bind(event_id)
    .execute(&mut **transaction)
    .await
    .map_err(AppError::Database)?;
    Ok(())
}

#[derive(FromRow)]
struct ProctorContestRow {
    id: i32,
    official_event_id: Option<i32>,
    status: String,
    starts_at: DateTime<Utc>,
    ends_at: DateTime<Utc>,
    event_title: Option<String>,
}

#[derive(FromRow)]
struct ProctorEventRow {
    id: i64,
    user_id: i32,
    username: String,
    event_type: String,
    payload: Value,
    client_time: Option<DateTime<Utc>>,
    received_at: DateTime<Utc>,
    review_status: String,
    review_note: Option<String>,
    reviewed_by: Option<String>,
    reviewed_at: Option<DateTime<Utc>>,
    assigned_admin: Option<String>,
    assigned_to_me: bool,
}

pub async fn proctor_events(
    pool: &PgPool,
    admin_id: i32,
    contest_id: i32,
) -> Result<ProctorEventListResponse, AppError> {
    let contest = sqlx::query_as::<_, ProctorContestRow>(
        "SELECT c.id, c.official_event_id, c.status, c.starts_at, c.ends_at, oe.title AS event_title \
         FROM contests c LEFT JOIN official_events oe ON oe.id = c.official_event_id \
         WHERE c.id = $1",
    )
    .bind(contest_id)
    .fetch_optional(pool)
    .await
    .map_err(AppError::Database)?
    .ok_or_else(|| AppError::NotFound("比赛不存在".to_owned()))?;

    let rows = sqlx::query_as::<_, ProctorEventRow>(
        "SELECT e.id, e.user_id, u.username, e.event_type, e.payload, e.client_time, e.received_at, \
         COALESCE(r.review_status, 'pending') AS review_status, r.review_note, \
         ru.username AS reviewed_by, r.reviewed_at, aa.username AS assigned_admin, \
         (a.assigned_admin_id IS NULL OR a.assigned_admin_id = $2 \
          OR aa.status IS DISTINCT FROM 'active') AS assigned_to_me \
         FROM contest_events e \
         JOIN users u ON u.id = e.user_id \
         LEFT JOIN contest_event_reviews r ON r.event_id = e.id \
         LEFT JOIN users ru ON ru.id = r.reviewed_by \
         LEFT JOIN contest_proctor_assignments a ON a.event_id = e.id \
         LEFT JOIN users aa ON aa.id = a.assigned_admin_id \
         WHERE e.contest_id = $1 AND e.event_type = 'paste_suspicious' \
         ORDER BY (r.event_id IS NOT NULL), e.received_at DESC",
    )
    .bind(contest_id)
    .bind(admin_id)
    .fetch_all(pool)
    .await
    .map_err(AppError::Database)?;

    let pending_count = rows
        .iter()
        .filter(|row| row.review_status == "pending")
        .count() as i64;
    let items = rows
        .into_iter()
        .map(|row| ProctorEventItem {
            id: row.id,
            user_id: row.user_id,
            username: row.username,
            event_type: row.event_type,
            payload: row.payload,
            client_time: row.client_time,
            received_at: row.received_at,
            review_status: row.review_status,
            review_note: row.review_note,
            reviewed_by: row.reviewed_by,
            reviewed_at: row.reviewed_at,
            assigned_admin: row.assigned_admin,
            assigned_to_me: row.assigned_to_me,
        })
        .collect();

    Ok(ProctorEventListResponse {
        contest: ProctorContestInfo {
            id: contest.id,
            event_id: contest.official_event_id,
            event_title: contest.event_title,
            status: contest.status,
            starts_at: contest.starts_at,
            ends_at: contest.ends_at,
        },
        items,
        pending_count,
    })
}

#[derive(FromRow)]
struct ReviewEventRow {
    user_id: i32,
    contest_status: String,
    official_event_id: Option<i32>,
    assigned_admin_id: Option<i32>,
    assigned_admin_status: Option<String>,
}

pub async fn review_proctor_event(
    pool: &PgPool,
    contest_id: i32,
    event_id: i64,
    reviewer_id: i32,
    input: &ProctorReviewInput,
) -> Result<ProctorReviewResponse, AppError> {
    let status = input.status.trim();
    if !matches!(status, "cleared" | "confirmed") {
        return Err(AppError::BadRequest(
            "复核结论只能是 cleared 或 confirmed".to_owned(),
        ));
    }
    let note = input
        .note
        .as_deref()
        .map(str::trim)
        .filter(|value| !value.is_empty());
    if let Some(note) = note
        && note.chars().count() > 500
    {
        return Err(AppError::BadRequest("复核备注不能超过 500 字".to_owned()));
    }

    let mut transaction = pool.begin().await.map_err(AppError::Database)?;
    let event = sqlx::query_as::<_, ReviewEventRow>(
        "SELECT e.user_id, c.status AS contest_status, \
                c.official_event_id, a.assigned_admin_id, aa.status AS assigned_admin_status \
         FROM contest_events e \
         JOIN contests c ON c.id = e.contest_id \
         LEFT JOIN contest_proctor_assignments a ON a.event_id = e.id \
         LEFT JOIN users aa ON aa.id = a.assigned_admin_id \
         WHERE e.id = $1 AND e.contest_id = $2 AND e.event_type = 'paste_suspicious' \
         FOR UPDATE OF e, c",
    )
    .bind(event_id)
    .bind(contest_id)
    .fetch_optional(&mut *transaction)
    .await
    .map_err(AppError::Database)?
    .ok_or_else(|| AppError::NotFound("复核事件不存在".to_owned()))?;

    if let Some(assigned_admin_id) = event.assigned_admin_id
        && assigned_admin_id != reviewer_id
        && event.assigned_admin_status.as_deref() == Some("active")
    {
        return Err(AppError::ForbiddenWith(
            "该记录已分配给其他管理员".to_owned(),
        ));
    }

    let existing: Option<(String, Option<DateTime<Utc>>)> = sqlx::query_as(
        "SELECT review_status, penalty_applied_at FROM contest_event_reviews \
         WHERE event_id = $1 FOR UPDATE",
    )
    .bind(event_id)
    .fetch_optional(&mut *transaction)
    .await
    .map_err(AppError::Database)?;

    if status == "cleared" {
        if existing
            .as_ref()
            .is_some_and(|(review_status, _)| review_status == "confirmed")
        {
            return Err(AppError::ConflictWith(
                "已确认作弊的记录不能改为排除".to_owned(),
            ));
        }
        sqlx::query(
            "INSERT INTO contest_event_reviews \
             (event_id, review_status, reviewed_by, review_note, reviewed_at) \
             VALUES ($1, 'cleared', $2, $3, CURRENT_TIMESTAMP) \
             ON CONFLICT (event_id) DO UPDATE SET \
               review_status = EXCLUDED.review_status, \
               reviewed_by = EXCLUDED.reviewed_by, \
               review_note = EXCLUDED.review_note, \
               reviewed_at = EXCLUDED.reviewed_at",
        )
        .bind(event_id)
        .bind(reviewer_id)
        .bind(note)
        .execute(&mut *transaction)
        .await
        .map_err(AppError::Database)?;
        sqlx::query(
            "INSERT INTO contest_proctor_assignments (event_id, assigned_admin_id) \
             VALUES ($1, $2) ON CONFLICT (event_id) DO UPDATE \
             SET assigned_admin_id = EXCLUDED.assigned_admin_id, assigned_at = CURRENT_TIMESTAMP",
        )
        .bind(event_id)
        .bind(reviewer_id)
        .execute(&mut *transaction)
        .await
        .map_err(AppError::Database)?;
        let reputation_score: f64 =
            sqlx::query_scalar("SELECT reputation_score::float8 FROM users WHERE id = $1")
                .bind(event.user_id)
                .fetch_one(&mut *transaction)
                .await
                .map_err(AppError::Database)?;
        transaction.commit().await.map_err(AppError::Database)?;
        return Ok(ProctorReviewResponse {
            message: "已排除该粘贴记录".to_owned(),
            review_status: status.to_owned(),
            reputation_score: Some(reputation_score),
            disqualified: false,
            rating_reranked: false,
        });
    }

    // Confirmed, but the penalty was already applied. Keep it idempotent.
    if existing
        .as_ref()
        .is_some_and(|(review_status, penalty)| review_status == "confirmed" && penalty.is_some())
    {
        sqlx::query(
            "UPDATE contest_event_reviews SET reviewed_by = $2, review_note = $3, \
             reviewed_at = CURRENT_TIMESTAMP WHERE event_id = $1",
        )
        .bind(event_id)
        .bind(reviewer_id)
        .bind(note)
        .execute(&mut *transaction)
        .await
        .map_err(AppError::Database)?;
        let reputation_score: f64 =
            sqlx::query_scalar("SELECT reputation_score::float8 FROM users WHERE id = $1")
                .bind(event.user_id)
                .fetch_one(&mut *transaction)
                .await
                .map_err(AppError::Database)?;
        let disqualified: bool = sqlx::query_scalar(
            "SELECT EXISTS (SELECT 1 FROM contest_participants \
                            WHERE contest_id = $1 AND user_id = $2 AND disqualified_at IS NOT NULL)",
        )
        .bind(contest_id)
        .bind(event.user_id)
        .fetch_one(&mut *transaction)
        .await
        .map_err(AppError::Database)?;
        transaction.commit().await.map_err(AppError::Database)?;
        return Ok(ProctorReviewResponse {
            message: "该记录已确认，扣分与排名不会重复计算".to_owned(),
            review_status: status.to_owned(),
            reputation_score: Some(reputation_score),
            disqualified,
            rating_reranked: false,
        });
    }

    // Lock the user before changing reputation so concurrent confirmations serialize.
    let (score_before, email, user_status): (f64, String, String) = sqlx::query_as(
        "SELECT reputation_score::float8, email, status FROM users WHERE id = $1 FOR UPDATE",
    )
    .bind(event.user_id)
    .fetch_optional(&mut *transaction)
    .await
    .map_err(AppError::Database)?
    .ok_or_else(|| AppError::NotFound("用户不存在".to_owned()))?;
    let score_after = round1(score_before - REPUTATION_PENALTY);
    let banned = score_after < 0.0;

    sqlx::query(
        "UPDATE users SET reputation_score = $2::float8::numeric(6, 1), \
         status = CASE WHEN $3 THEN 'banned' ELSE status END, \
         token_version = token_version + CASE WHEN $3 THEN 1 ELSE 0 END, \
         updated_at = CURRENT_TIMESTAMP WHERE id = $1",
    )
    .bind(event.user_id)
    .bind(score_after)
    .bind(banned)
    .execute(&mut *transaction)
    .await
    .map_err(AppError::Database)?;

    if score_after < REPUTATION_RESTRICT_BELOW {
        sqlx::query("DELETE FROM contest_queue WHERE user_id = $1")
            .bind(event.user_id)
            .execute(&mut *transaction)
            .await
            .map_err(AppError::Database)?;
    }

    sqlx::query(
        "INSERT INTO reputation_events \
         (user_id, delta, score_before, score_after, reason, proctor_event_id, contest_id, actor_id, note) \
         VALUES ($1, $2::float8::numeric(6, 1), $3::float8::numeric(6, 1), \
                 $4::float8::numeric(6, 1), 'paste_cheating', $5, $6, $7, $8)",
    )
    .bind(event.user_id)
    .bind(round1(-REPUTATION_PENALTY))
    .bind(score_before)
    .bind(score_after)
    .bind(event_id)
    .bind(contest_id)
    .bind(reviewer_id)
    .bind(note)
    .execute(&mut *transaction)
    .await
    .map_err(AppError::Database)?;

    let notification = if banned {
        sqlx::query(
            "INSERT INTO email_blacklist (email, user_id, reason, created_by) \
             VALUES (LOWER($1), $2, '信誉分低于 0，自动封禁', $3) \
             ON CONFLICT DO NOTHING",
        )
        .bind(&email)
        .bind(event.user_id)
        .bind(reviewer_id)
        .execute(&mut *transaction)
        .await
        .map_err(AppError::Database)?;
        (
            "账号已封禁",
            format!(
                "比赛粘贴作弊复核成立，信誉分 {:.1} → {:.1}。账号与邮箱已加入黑名单，如需申诉请联系管理员",
                score_before, score_after
            ),
        )
    } else if score_after < REPUTATION_RESTRICT_BELOW {
        (
            "账号权限受限",
            format!(
                "比赛粘贴作弊复核成立，信誉分 {:.1} → {:.1}。信誉分低于 40，暂不能参与排位赛与论坛发言",
                score_before, score_after
            ),
        )
    } else {
        (
            "信誉分扣除",
            format!(
                "比赛粘贴作弊复核成立，信誉分 {:.1} → {:.1}。请遵守比赛规范",
                score_before, score_after
            ),
        )
    };
    notification_service::create(
        &mut transaction,
        event.user_id,
        "reputation_notice",
        None,
        notification.0,
        Some(&notification.1),
        Some(&format!("/contests/{contest_id}/result")),
        Some("contest"),
        Some(i64::from(contest_id)),
    )
    .await?;

    let disqualified_rows = sqlx::query(
        "UPDATE contest_participants SET disqualified_at = COALESCE(disqualified_at, CURRENT_TIMESTAMP), \
         disqualified_by = $3, disqualify_reason = 'paste_cheating' \
         WHERE contest_id = $1 AND user_id = $2",
    )
    .bind(contest_id)
    .bind(event.user_id)
    .bind(reviewer_id)
    .execute(&mut *transaction)
    .await
    .map_err(AppError::Database)?
    .rows_affected();

    let mut rating_reranked = false;
    if event.contest_status == CONTEST_STATUS_FINISHED {
        rating_reranked = rerank_contest(
            &mut transaction,
            contest_id,
            event.official_event_id.is_some(),
        )
        .await?;
    }

    sqlx::query(
        "INSERT INTO contest_event_reviews \
         (event_id, review_status, reviewed_by, review_note, reviewed_at, penalty_applied_at) \
         VALUES ($1, 'confirmed', $2, $3, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP) \
         ON CONFLICT (event_id) DO UPDATE SET \
           review_status = 'confirmed', \
           reviewed_by = EXCLUDED.reviewed_by, \
           review_note = EXCLUDED.review_note, \
           reviewed_at = EXCLUDED.reviewed_at, \
           penalty_applied_at = EXCLUDED.penalty_applied_at",
    )
    .bind(event_id)
    .bind(reviewer_id)
    .bind(note)
    .execute(&mut *transaction)
    .await
    .map_err(AppError::Database)?;

    sqlx::query(
        "INSERT INTO contest_proctor_assignments (event_id, assigned_admin_id) \
         VALUES ($1, $2) ON CONFLICT (event_id) DO UPDATE \
         SET assigned_admin_id = EXCLUDED.assigned_admin_id, assigned_at = CURRENT_TIMESTAMP",
    )
    .bind(event_id)
    .bind(reviewer_id)
    .execute(&mut *transaction)
    .await
    .map_err(AppError::Database)?;

    transaction.commit().await.map_err(AppError::Database)?;
    tracing::info!(
        contest_id,
        event_id,
        reviewer_id,
        user_id = event.user_id,
        user_status = %user_status,
        score_before,
        score_after,
        banned,
        "proctor event confirmed"
    );

    Ok(ProctorReviewResponse {
        message: if rating_reranked {
            "已确认作弊，信誉分已扣除，比赛排名已重新结算".to_owned()
        } else {
            "已确认作弊，信誉分已扣除".to_owned()
        },
        review_status: status.to_owned(),
        reputation_score: Some(score_after),
        disqualified: disqualified_rows > 0,
        rating_reranked,
    })
}

/// Recomputes ranks after a participant is disqualified. `contest_rating` is
/// adjusted by the difference between the old and the new result, so later
/// contests are not overwritten (多还少补).
async fn rerank_contest(
    transaction: &mut sqlx::Transaction<'_, sqlx::Postgres>,
    contest_id: i32,
    is_event_contest: bool,
) -> Result<bool, AppError> {
    let season_id: Option<i32> = sqlx::query_scalar("SELECT season_id FROM contests WHERE id = $1")
        .bind(contest_id)
        .fetch_one(&mut **transaction)
        .await
        .map_err(AppError::Database)?;
    let current_season_id = season_service::current_season_id_tx(transaction).await?;
    let sync_live_rating = season_id.is_none() || season_id == current_season_id;
    #[derive(FromRow)]
    struct RerankRow {
        user_id: i32,
        total_score: Option<f64>,
        solved_count: i32,
        last_accepted_at: Option<DateTime<Utc>>,
        finished_at: Option<DateTime<Utc>>,
        rating_before: i32,
        rating_after: Option<i32>,
        rank: Option<i32>,
        disqualified_at: Option<DateTime<Utc>>,
    }

    let rows: Vec<RerankRow> = sqlx::query_as(
        "SELECT p.user_id, p.total_score, p.solved_count, p.last_accepted_at, p.finished_at, \
                COALESCE(p.rating_before, u.contest_rating) AS rating_before, \
                p.rating_after, p.rank, p.disqualified_at \
         FROM contest_participants p JOIN users u ON u.id = p.user_id \
         WHERE p.contest_id = $1 AND p.status IN ('active', 'disconnected', 'timed_out', 'finished')",
    )
    .bind(contest_id)
    .fetch_all(&mut **transaction)
    .await
    .map_err(AppError::Database)?;

    let (mut active, disqualified): (Vec<RerankRow>, Vec<RerankRow>) = rows
        .into_iter()
        .partition(|row| row.disqualified_at.is_none());
    active.sort_by(|left, right| {
        right
            .total_score
            .unwrap_or(0.0)
            .partial_cmp(&left.total_score.unwrap_or(0.0))
            .unwrap_or(Ordering::Equal)
            .then_with(|| right.solved_count.cmp(&left.solved_count))
            .then_with(|| match (left.last_accepted_at, right.last_accepted_at) {
                (Some(a), Some(b)) => a.cmp(&b),
                (Some(_), None) => Ordering::Less,
                (None, Some(_)) => Ordering::Greater,
                (None, None) => Ordering::Equal,
            })
            .then_with(|| match (left.finished_at, right.finished_at) {
                (Some(a), Some(b)) => a.cmp(&b),
                (Some(_), None) => Ordering::Less,
                (None, Some(_)) => Ordering::Greater,
                (None, None) => Ordering::Equal,
            })
            .then_with(|| left.user_id.cmp(&right.user_id))
    });

    let mut changed = false;
    for (index, participant) in active.iter().enumerate() {
        let rank = (index + 1) as i32;
        let expected_delta = if is_event_contest {
            0
        } else {
            rating_delta_for_rank(rank, active.len())
        };
        let rating_after = (participant.rating_before + expected_delta).max(0);
        let old_after = participant
            .rating_after
            .unwrap_or(participant.rating_before);
        let diff = rating_after - old_after;
        let rank_changed = participant.rank != Some(rank);

        sqlx::query(
            "UPDATE contest_participants SET rank = $3, rating_after = $4, \
             rating_delta = $5 WHERE contest_id = $1 AND user_id = $2",
        )
        .bind(contest_id)
        .bind(participant.user_id)
        .bind(rank)
        .bind(rating_after)
        .bind(rating_after - participant.rating_before)
        .execute(&mut **transaction)
        .await
        .map_err(AppError::Database)?;

        if !is_event_contest && sync_live_rating && diff != 0 {
            sqlx::query(
                "UPDATE users SET contest_rating = GREATEST(0, contest_rating + $2), \
                 updated_at = CURRENT_TIMESTAMP WHERE id = $1",
            )
            .bind(participant.user_id)
            .bind(diff)
            .execute(&mut **transaction)
            .await
            .map_err(AppError::Database)?;
        }
        if !is_event_contest && let Some(season_id) = season_id {
            let current_rating: Option<i32> = sqlx::query_scalar(
                "SELECT rating FROM season_ratings WHERE season_id = $1 AND user_id = $2",
            )
            .bind(season_id)
            .bind(participant.user_id)
            .fetch_optional(&mut **transaction)
            .await
            .map_err(AppError::Database)?;
            season_service::record_rerank(
                transaction,
                season_id,
                participant.user_id,
                diff,
                current_rating.unwrap_or(participant.rating_before + diff),
                Some(rank),
            )
            .await?;
        }

        if rank_changed || diff != 0 {
            changed = true;
            let (title, body, link) = if is_event_contest {
                (
                    format!("赛事排名更新：第 {rank} 名"),
                    "有选手因作弊被取消成绩，你的排名已重新结算".to_owned(),
                    format!("/contests/{contest_id}/result"),
                )
            } else {
                (
                    format!("排位赛重新结算：第 {rank} 名"),
                    format!(
                        "有选手因作弊被取消成绩，段位分 {} → {} ({:+})",
                        old_after, rating_after, diff
                    ),
                    format!("/contests/{contest_id}/result"),
                )
            };
            notification_service::create(
                transaction,
                participant.user_id,
                "contest_result",
                None,
                &title,
                Some(&body),
                Some(&link),
                Some("contest"),
                Some(i64::from(contest_id)),
            )
            .await?;
        }
    }

    for participant in &disqualified {
        let old_after = participant
            .rating_after
            .unwrap_or(participant.rating_before);
        let diff = participant.rating_before - old_after;
        if participant.rank.is_some() || diff != 0 {
            changed = true;
        }
        sqlx::query(
            "UPDATE contest_participants SET rank = NULL, rating_after = $3, rating_delta = 0 \
             WHERE contest_id = $1 AND user_id = $2",
        )
        .bind(contest_id)
        .bind(participant.user_id)
        .bind(participant.rating_before)
        .execute(&mut **transaction)
        .await
        .map_err(AppError::Database)?;
        if !is_event_contest && sync_live_rating && diff != 0 {
            sqlx::query(
                "UPDATE users SET contest_rating = GREATEST(0, contest_rating + $2), \
                 updated_at = CURRENT_TIMESTAMP WHERE id = $1",
            )
            .bind(participant.user_id)
            .bind(diff)
            .execute(&mut **transaction)
            .await
            .map_err(AppError::Database)?;
        }
        if !is_event_contest && let Some(season_id) = season_id {
            let current_rating: Option<i32> = sqlx::query_scalar(
                "SELECT rating FROM season_ratings WHERE season_id = $1 AND user_id = $2",
            )
            .bind(season_id)
            .bind(participant.user_id)
            .fetch_optional(&mut **transaction)
            .await
            .map_err(AppError::Database)?;
            season_service::record_rerank(
                transaction,
                season_id,
                participant.user_id,
                diff,
                current_rating.unwrap_or(participant.rating_before),
                None,
            )
            .await?;
        }
    }

    // 取消资格会移除已有的胜场，必须对所有参赛者重算，而不只是名次变化的人。
    if let Some(season_id) = season_id {
        sqlx::query(
            "UPDATE season_ratings sr SET wins = ( \
                 SELECT COUNT(*)::int FROM contest_participants cp \
                 JOIN contests c ON c.id = cp.contest_id \
                 WHERE cp.user_id = sr.user_id AND c.season_id = $1 AND c.status = 'finished' \
                   AND cp.rank = 1 AND cp.disqualified_at IS NULL \
             ), updated_at = CURRENT_TIMESTAMP \
             WHERE sr.season_id = $1 AND sr.user_id IN ( \
                 SELECT cp.user_id FROM contest_participants cp WHERE cp.contest_id = $2 \
             )",
        )
        .bind(season_id)
        .bind(contest_id)
        .execute(&mut **transaction)
        .await
        .map_err(AppError::Database)?;
    }

    Ok(changed)
}

/// Validates that a submission belongs to a running contest and returns the
/// frozen test configuration captured when the contest was created.
pub async fn precheck_submission(
    pool: &PgPool,
    user_id: i32,
    contest_id: i32,
    problem_id: i32,
) -> Result<ContestSubmissionContext, AppError> {
    #[derive(FromRow)]
    struct ContestProblemContext {
        status: String,
        ends_at: DateTime<Utc>,
        participant_status: String,
        disqualified_at: Option<DateTime<Utc>>,
        run_config: Value,
        judge_cases: Option<Value>,
    }

    let row = sqlx::query_as::<_, ContestProblemContext>(
        "SELECT c.status, c.ends_at, p.status AS participant_status, p.disqualified_at, \
                cp.run_config, cp.judge_cases \
         FROM contests c \
         JOIN contest_participants p ON p.contest_id = c.id AND p.user_id = $2 \
         JOIN contest_problems cp ON cp.contest_id = c.id AND cp.problem_id = $3 \
         WHERE c.id = $1",
    )
    .bind(contest_id)
    .bind(user_id)
    .bind(problem_id)
    .fetch_optional(pool)
    .await
    .map_err(AppError::Database)?
    .ok_or_else(|| AppError::BadRequest("题目不属于该场比赛".to_owned()))?;

    if row.status != CONTEST_STATUS_RUNNING {
        return Err(AppError::ConflictWith("比赛已结束".to_owned()));
    }
    if row.participant_status != PARTICIPANT_STATUS_ACTIVE {
        let message = match row.participant_status.as_str() {
            PARTICIPANT_STATUS_DISCONNECTED => "网络中断，正在重连，请稍后再试",
            PARTICIPANT_STATUS_TIMED_OUT => "断线超时，成绩已冻结，无法继续提交",
            _ => "你已离场，无法继续提交",
        };
        return Err(AppError::ConflictWith(message.to_owned()));
    }
    if row.disqualified_at.is_some() {
        return Err(AppError::ConflictWith(
            "本场成绩已取消，无法继续提交".to_owned(),
        ));
    }
    if row.ends_at <= Utc::now() {
        return Err(AppError::ConflictWith("比赛已结束".to_owned()));
    }
    Ok(ContestSubmissionContext {
        run_config: row.run_config,
        judge_cases: row.judge_cases,
    })
}

/// Advances participant presence for running contests. Called from the same
/// scheduler as settlement, so it runs every 5 seconds in the API process.
///
/// 1. `active` -> `disconnected` after 30 seconds without a heartbeat;
/// 2. `disconnected` -> `timed_out` once the 120-second grace period from the
///    last heartbeat expires, with a notification explaining the frozen score;
/// 3. ranked contests where everyone timed out are cancelled instead of being
///    settled, so no rating is awarded for an empty room;
/// 4. ranked contests with nobody active or reconnecting are settled as soon
///    as at least one player finished, instead of waiting for `ends_at + 20s`.
pub async fn sweep_contest_presence(pool: &PgPool) -> Result<usize, AppError> {
    let disconnected = sqlx::query(
        "UPDATE contest_participants p SET status = 'disconnected', \
             disconnected_at = CURRENT_TIMESTAMP \
         FROM contests c \
         WHERE c.id = p.contest_id AND c.status = 'running' \
           AND p.status = 'active' AND p.disqualified_at IS NULL \
           AND p.last_seen_at <= CURRENT_TIMESTAMP - make_interval(secs => $1::double precision)",
    )
    .bind(DISCONNECT_AFTER_SECONDS as f64)
    .execute(pool)
    .await
    .map_err(AppError::Database)?
    .rows_affected() as usize;

    let timed_out = timeout_silent_participants(pool).await?;
    let cancelled = cancel_abandoned_ranked_contests(pool).await?;
    let settled = settle_abandoned_ranked_contests(pool).await?;
    Ok(disconnected + timed_out + cancelled + settled)
}

/// Freezes the score of players whose reconnect grace expired and tells them
/// why further submissions are rejected.
async fn timeout_silent_participants(pool: &PgPool) -> Result<usize, AppError> {
    let rows: Vec<(i32, i32)> = sqlx::query_as(
        "SELECT p.contest_id, p.user_id \
         FROM contest_participants p JOIN contests c ON c.id = p.contest_id \
         WHERE c.status = 'running' AND p.status = 'disconnected' \
           AND p.disqualified_at IS NULL \
           AND p.last_seen_at <= CURRENT_TIMESTAMP - make_interval(secs => $1::double precision) \
         ORDER BY p.last_seen_at LIMIT 200",
    )
    .bind(RECONNECT_GRACE_SECONDS as f64)
    .fetch_all(pool)
    .await
    .map_err(AppError::Database)?;

    let mut count = 0;
    for (contest_id, user_id) in rows {
        let mut transaction = pool.begin().await.map_err(AppError::Database)?;
        let updated = sqlx::query(
            "UPDATE contest_participants SET status = 'timed_out', \
                 timed_out_at = CURRENT_TIMESTAMP \
             WHERE contest_id = $1 AND user_id = $2 AND status = 'disconnected'",
        )
        .bind(contest_id)
        .bind(user_id)
        .execute(&mut *transaction)
        .await
        .map_err(AppError::Database)?
        .rows_affected();
        if updated == 1 {
            notification_service::create(
                &mut transaction,
                user_id,
                "contest_disconnected",
                None,
                "比赛断线超时",
                Some("你已超过 120 秒未重连，成绩按断线前已提交的内容结算。"),
                Some(&format!("/contests/{contest_id}")),
                Some("contest"),
                Some(i64::from(contest_id)),
            )
            .await?;
            count += 1;
        }
        transaction.commit().await.map_err(AppError::Database)?;
    }
    Ok(count)
}

/// Ranked contests where every participant timed out are cancelled: no rank,
/// no rating change, no rating history. Event contests keep their fixed end
/// time and are never cancelled by this sweep.
async fn cancel_abandoned_ranked_contests(pool: &PgPool) -> Result<usize, AppError> {
    let ids: Vec<i32> = sqlx::query_scalar(
        "SELECT c.id FROM contests c \
         WHERE c.status = 'running' AND c.official_event_id IS NULL \
           AND EXISTS (SELECT 1 FROM contest_participants p WHERE p.contest_id = c.id) \
           AND NOT EXISTS (SELECT 1 FROM contest_participants p \
                           WHERE p.contest_id = c.id AND p.status <> 'timed_out') \
         ORDER BY c.ends_at LIMIT 20",
    )
    .fetch_all(pool)
    .await
    .map_err(AppError::Database)?;

    let mut count = 0;
    for contest_id in ids {
        let mut transaction = pool.begin().await.map_err(AppError::Database)?;
        let updated = sqlx::query(
            "UPDATE contests SET status = 'cancelled', finished_at = CURRENT_TIMESTAMP, \
                 updated_at = CURRENT_TIMESTAMP \
             WHERE id = $1 AND status = 'running' AND official_event_id IS NULL",
        )
        .bind(contest_id)
        .execute(&mut *transaction)
        .await
        .map_err(AppError::Database)?
        .rows_affected();
        if updated == 0 {
            transaction.commit().await.map_err(AppError::Database)?;
            continue;
        }
        let user_ids: Vec<i32> =
            sqlx::query_scalar("SELECT user_id FROM contest_participants WHERE contest_id = $1")
                .bind(contest_id)
                .fetch_all(&mut *transaction)
                .await
                .map_err(AppError::Database)?;
        for user_id in user_ids {
            notification_service::create(
                &mut transaction,
                user_id,
                "contest_cancelled",
                None,
                "比赛已取消",
                Some("全员断线超过宽限时间，本场排位赛已取消，段位分不变。"),
                Some(&format!("/contests/{contest_id}")),
                Some("contest"),
                Some(i64::from(contest_id)),
            )
            .await?;
        }
        transaction.commit().await.map_err(AppError::Database)?;
        tracing::info!(contest_id, "contest cancelled after everyone timed out");
        count += 1;
    }
    Ok(count)
}

/// Settles ranked contests where nobody can still submit: no `active` player
/// and no one inside the reconnect window, but at least one player finished.
async fn settle_abandoned_ranked_contests(pool: &PgPool) -> Result<usize, AppError> {
    let ids: Vec<i32> = sqlx::query_scalar(
        "SELECT c.id FROM contests c \
         WHERE c.status = 'running' AND c.official_event_id IS NULL \
           AND NOT EXISTS (SELECT 1 FROM contest_participants p \
                           WHERE p.contest_id = c.id \
                             AND p.status IN ('active', 'disconnected')) \
           AND EXISTS (SELECT 1 FROM contest_participants p \
                       WHERE p.contest_id = c.id AND p.status = 'finished') \
         ORDER BY c.ends_at LIMIT 20",
    )
    .fetch_all(pool)
    .await
    .map_err(AppError::Database)?;

    let mut count = 0;
    for contest_id in ids {
        if settle_contest(pool, contest_id).await? {
            count += 1;
        }
    }
    Ok(count)
}

pub async fn settle_due_contests(pool: &PgPool) -> Result<usize, AppError> {
    let ids: Vec<i32> = sqlx::query_scalar(
        "SELECT id FROM contests \
         WHERE (status = 'running' AND ends_at + make_interval(secs => $1::double precision) <= CURRENT_TIMESTAMP) \
            OR (status = 'settling' AND updated_at <= CURRENT_TIMESTAMP - INTERVAL '2 minutes') \
         ORDER BY ends_at LIMIT 20",
    )
    .bind(SETTLE_GRACE_SECONDS as f64)
    .fetch_all(pool)
    .await
    .map_err(AppError::Database)?;
    let mut settled = 0;
    for id in ids {
        if settle_contest(pool, id).await? {
            settled += 1;
        }
    }
    Ok(settled)
}

/// Idempotent settlement. Returns true only for the transaction that actually
/// moved the contest into `finished`.
pub async fn settle_contest(pool: &PgPool, contest_id: i32) -> Result<bool, AppError> {
    let mut transaction = pool.begin().await.map_err(AppError::Database)?;
    let contest = sqlx::query_as::<_, ContestRow>(
        "SELECT id, official_event_id, season_id, status, duration_seconds, problem_count, starts_at, \
         ends_at, finished_at, solve_weight, speed_weight, coding_weight \
         FROM contests WHERE id = $1 FOR UPDATE",
    )
    .bind(contest_id)
    .fetch_optional(&mut *transaction)
    .await
    .map_err(AppError::Database)?;
    let Some(contest) = contest else {
        transaction.commit().await.map_err(AppError::Database)?;
        return Ok(false);
    };
    if contest.status == CONTEST_STATUS_FINISHED || contest.status == CONTEST_STATUS_CANCELLED {
        transaction.commit().await.map_err(AppError::Database)?;
        return Ok(false);
    }
    let current_season_id = season_service::current_season_id_tx(&mut transaction).await?;

    sqlx::query(
        "UPDATE contests SET status = 'settling', updated_at = CURRENT_TIMESTAMP WHERE id = $1",
    )
    .bind(contest_id)
    .execute(&mut *transaction)
    .await
    .map_err(AppError::Database)?;

    let problem_rows: Vec<(i32, String)> = sqlx::query_as(
        "SELECT problem_id, title FROM contest_problems WHERE contest_id = $1 ORDER BY position",
    )
    .bind(contest_id)
    .fetch_all(&mut *transaction)
    .await
    .map_err(AppError::Database)?;
    let problem_ids: Vec<i32> = problem_rows.iter().map(|(id, _)| *id).collect();

    let participants: Vec<(i32, Option<DateTime<Utc>>, i32)> = sqlx::query_as(
        "SELECT p.user_id, p.finished_at, COALESCE(p.rating_before, u.contest_rating) \
         FROM contest_participants p JOIN users u ON u.id = p.user_id \
         WHERE p.contest_id = $1 AND p.status IN ('active', 'disconnected', 'timed_out', 'finished') \
           AND p.disqualified_at IS NULL",
    )
    .bind(contest_id)
    .fetch_all(&mut *transaction)
    .await
    .map_err(AppError::Database)?;

    #[derive(Debug)]
    struct ScoredParticipant {
        user_id: i32,
        total_score: f64,
        solved_count: i32,
        speed_score: f64,
        coding_score: f64,
        last_accepted_at: Option<DateTime<Utc>>,
        finished_at: Option<DateTime<Utc>>,
        rating_before: i32,
        detail: Vec<ContestScoreDetail>,
    }

    let mut scored = Vec::with_capacity(participants.len());
    for (user_id, finished_at, rating_before) in participants {
        let submissions = sqlx::query_as::<_, ContestSubmissionRow>(
            "SELECT problem_id, status, submitted_at FROM submissions \
             WHERE contest_id = $1 AND user_id = $2 \
               AND submitted_at BETWEEN $3 AND $4 \
             ORDER BY submitted_at, id",
        )
        .bind(contest_id)
        .bind(user_id)
        .bind(contest.starts_at)
        .bind(contest.ends_at)
        .fetch_all(&mut *transaction)
        .await
        .map_err(AppError::Database)?;

        let mut aggregates: HashMap<i32, ProblemAggregate> = problem_ids
            .iter()
            .map(|problem_id| (*problem_id, ProblemAggregate::default()))
            .collect();
        for submission in submissions {
            let aggregate = aggregates.entry(submission.problem_id).or_default();
            aggregate.attempts += 1;
            match submission.status.as_str() {
                "accepted" => {
                    aggregate.accepted_at.get_or_insert(submission.submitted_at);
                }
                "wrong_answer" => aggregate.wrong_answer += 1,
                "compile_error" => aggregate.compile_error += 1,
                "runtime_error" => aggregate.runtime_error += 1,
                _ => {}
            }
        }

        let mut solved_count = 0i32;
        let mut time_score_sum = 0.0f64;
        let mut coding_score = 100.0f64;
        let mut last_accepted_at: Option<DateTime<Utc>> = None;
        let mut detail = Vec::with_capacity(problem_ids.len());
        for (problem_id, title) in &problem_rows {
            let aggregate = aggregates.get(problem_id).cloned().unwrap_or_default();
            let time_score = aggregate.accepted_at.map_or(0.0, |accepted_at| {
                let elapsed = (accepted_at - contest.starts_at).num_seconds().max(0) as f64;
                let ratio = elapsed / f64::from(contest.duration_seconds.max(1));
                (100.0 * (1.0 - ratio)).clamp(0.0, 100.0)
            });
            if let Some(accepted_at) = aggregate.accepted_at {
                solved_count += 1;
                time_score_sum += time_score;
                last_accepted_at = Some(match last_accepted_at {
                    Some(current) if current > accepted_at => current,
                    _ => accepted_at,
                });
            }
            coding_score -= aggregate.wrong_answer as f64 * 1.0
                + aggregate.compile_error as f64 * 2.0
                + aggregate.runtime_error as f64 * 3.0;
            detail.push(ContestScoreDetail {
                problem_id: *problem_id,
                title: title.clone(),
                accepted: aggregate.accepted_at.is_some(),
                accepted_at: aggregate.accepted_at,
                attempts: aggregate.attempts,
                wrong_answer: aggregate.wrong_answer,
                compile_error: aggregate.compile_error,
                runtime_error: aggregate.runtime_error,
                time_score: round2(time_score),
            });
        }
        coding_score = coding_score.clamp(0.0, 100.0);
        let speed_score = if solved_count > 0 {
            time_score_sum / f64::from(solved_count)
        } else {
            0.0
        };
        let solved_score =
            f64::from(solved_count) / f64::from(contest.problem_count.max(1)) * 100.0;
        let total_score = round2(
            contest.solve_weight * solved_score
                + contest.speed_weight * speed_score
                + contest.coding_weight * coding_score,
        );
        scored.push(ScoredParticipant {
            user_id,
            total_score,
            solved_count,
            speed_score: round2(speed_score),
            coding_score: round2(coding_score),
            last_accepted_at,
            finished_at,
            rating_before,
            detail,
        });
    }

    scored.sort_by(|left, right| {
        right
            .total_score
            .partial_cmp(&left.total_score)
            .unwrap_or(Ordering::Equal)
            .then_with(|| right.solved_count.cmp(&left.solved_count))
            .then_with(|| match (left.last_accepted_at, right.last_accepted_at) {
                (Some(a), Some(b)) => a.cmp(&b),
                (Some(_), None) => Ordering::Less,
                (None, Some(_)) => Ordering::Greater,
                (None, None) => Ordering::Equal,
            })
            .then_with(|| match (left.finished_at, right.finished_at) {
                (Some(a), Some(b)) => a.cmp(&b),
                (Some(_), None) => Ordering::Less,
                (None, Some(_)) => Ordering::Greater,
                (None, None) => Ordering::Equal,
            })
            .then_with(|| left.user_id.cmp(&right.user_id))
    });

    for (index, participant) in scored.iter().enumerate() {
        let rank = (index + 1) as i32;
        let expected_delta = if contest.official_event_id.is_some() {
            0
        } else {
            rating_delta_for_rank(rank, scored.len())
        };
        let rating_after = (participant.rating_before + expected_delta).max(0);
        let rating_delta = rating_after - participant.rating_before;
        sqlx::query(
            "UPDATE contest_participants SET total_score = $3, rank = $4, solved_count = $5, \
             speed_score = $6, coding_score = $7, last_accepted_at = $8, detail = $9, \
             rating_before = $10, rating_after = $11, rating_delta = $12 \
             WHERE contest_id = $1 AND user_id = $2",
        )
        .bind(contest_id)
        .bind(participant.user_id)
        .bind(participant.total_score)
        .bind(rank)
        .bind(participant.solved_count)
        .bind(participant.speed_score)
        .bind(participant.coding_score)
        .bind(participant.last_accepted_at)
        .bind(json!(participant.detail))
        .bind(participant.rating_before)
        .bind(rating_after)
        .bind(rating_delta)
        .execute(&mut *transaction)
        .await
        .map_err(AppError::Database)?;

        // Event contests are scored but never change the ranked rating.
        if contest.official_event_id.is_none() {
            // 旧赛季的比赛晚于新赛季结算时，只能写回旧赛季快照，
            // 不能覆盖用户当前赛季的段位分。
            let is_current_season =
                contest.season_id.is_none() || contest.season_id == current_season_id;
            if is_current_season {
                sqlx::query(
                    "UPDATE users SET contest_rating = $2, updated_at = CURRENT_TIMESTAMP WHERE id = $1",
                )
                .bind(participant.user_id)
                .bind(rating_after)
                .execute(&mut *transaction)
                .await
                .map_err(AppError::Database)?;
            }
            if let Some(season_id) = contest.season_id {
                season_service::record_settlement(
                    &mut transaction,
                    season_id,
                    participant.user_id,
                    participant.rating_before,
                    rating_after,
                    rank,
                )
                .await?;
            }
        }

        let (title, body, link) = match contest.official_event_id {
            Some(event_id) => (
                format!("赛事结束：第 {rank} 名"),
                format!(
                    "总分 {:.2} · 通过 {}/{} · 速度 {:.1} · 书写 {:.1}",
                    participant.total_score,
                    participant.solved_count,
                    contest.problem_count,
                    participant.speed_score,
                    participant.coding_score,
                ),
                format!("/contests/events/{event_id}"),
            ),
            None => (
                format!("排位赛结束：第 {rank} 名"),
                format!(
                    "总分 {:.2} · 通过 {}/{} · 速度 {:.1} · 书写 {:.1} · 段位分 {} → {} ({:+})",
                    participant.total_score,
                    participant.solved_count,
                    contest.problem_count,
                    participant.speed_score,
                    participant.coding_score,
                    participant.rating_before,
                    rating_after,
                    rating_delta,
                ),
                format!("/contests/{contest_id}/result"),
            ),
        };
        notification_service::create(
            &mut transaction,
            participant.user_id,
            "contest_result",
            None,
            &title,
            Some(&body),
            Some(&link),
            Some("contest"),
            Some(i64::from(contest_id)),
        )
        .await?;
    }

    sqlx::query(
        "UPDATE contests SET status = 'finished', finished_at = CURRENT_TIMESTAMP, \
         updated_at = CURRENT_TIMESTAMP WHERE id = $1",
    )
    .bind(contest_id)
    .execute(&mut *transaction)
    .await
    .map_err(AppError::Database)?;

    transaction.commit().await.map_err(AppError::Database)?;
    tracing::info!(contest_id, participants = scored.len(), "contest settled");
    Ok(true)
}

async fn active_contest_id(pool: &PgPool, user_id: i32) -> Result<Option<i32>, AppError> {
    sqlx::query_scalar(
        "SELECT c.id FROM contest_participants p JOIN contests c ON c.id = p.contest_id \
         WHERE p.user_id = $1 AND c.status IN ('running', 'settling') \
           AND p.status IN ('active', 'disconnected', 'timed_out', 'finished') \
         ORDER BY c.starts_at DESC LIMIT 1",
    )
    .bind(user_id)
    .fetch_optional(pool)
    .await
    .map_err(AppError::Database)
}

async fn ensure_reputation_for_ranked(pool: &PgPool, user_id: i32) -> Result<(), AppError> {
    let score: Option<f64> =
        sqlx::query_scalar("SELECT reputation_score::float8 FROM users WHERE id = $1")
            .bind(user_id)
            .fetch_optional(pool)
            .await
            .map_err(AppError::Database)?;
    if score.unwrap_or(100.0) < REPUTATION_RESTRICT_BELOW {
        return Err(AppError::ForbiddenWith(
            "信誉分低于 40 暂不能参与排位赛".to_owned(),
        ));
    }
    Ok(())
}

async fn ensure_reputation_for_events(pool: &PgPool, user_id: i32) -> Result<(), AppError> {
    let score: Option<f64> =
        sqlx::query_scalar("SELECT reputation_score::float8 FROM users WHERE id = $1")
            .bind(user_id)
            .fetch_optional(pool)
            .await
            .map_err(AppError::Database)?;
    if score.unwrap_or(100.0) < REPUTATION_RESTRICT_BELOW {
        return Err(AppError::ForbiddenWith(
            "信誉分低于 40 暂不能报名或参加赛事".to_owned(),
        ));
    }
    Ok(())
}

async fn queue_position(pool: &PgPool, user_id: i32) -> Result<Option<i64>, AppError> {
    sqlx::query_scalar(
        "SELECT position FROM ( \
             SELECT q.user_id, ROW_NUMBER() OVER (ORDER BY q.joined_at, q.user_id) AS position \
             FROM contest_queue q JOIN users u ON u.id = q.user_id AND u.status = 'active' \
         ) ranked WHERE ranked.user_id = $1",
    )
    .bind(user_id)
    .fetch_optional(pool)
    .await
    .map_err(AppError::Database)
}

async fn participant_status(
    pool: &PgPool,
    contest_id: i32,
    user_id: i32,
) -> Result<Option<String>, AppError> {
    sqlx::query_scalar(
        "SELECT status FROM contest_participants WHERE contest_id = $1 AND user_id = $2",
    )
    .bind(contest_id)
    .bind(user_id)
    .fetch_optional(pool)
    .await
    .map_err(AppError::Database)
}

async fn fetch_contest_row(pool: &PgPool, contest_id: i32) -> Result<ContestRow, AppError> {
    sqlx::query_as::<_, ContestRow>(
        "SELECT id, official_event_id, season_id, status, duration_seconds, problem_count, starts_at, \
         ends_at, finished_at, solve_weight, speed_weight, coding_weight \
         FROM contests WHERE id = $1",
    )
    .bind(contest_id)
    .fetch_optional(pool)
    .await
    .map_err(AppError::Database)?
    .ok_or_else(|| AppError::NotFound("比赛不存在".to_owned()))
}

async fn fetch_summary(
    pool: &PgPool,
    contest_id: i32,
    user_id: i32,
) -> Result<ContestSummary, AppError> {
    let row = sqlx::query_as::<_, SummaryRow>(
        "SELECT c.id, c.official_event_id, c.status, c.duration_seconds, c.problem_count, \
         c.starts_at, c.ends_at, \
         c.finished_at, \
         (SELECT COUNT(*) FROM contest_participants cp WHERE cp.contest_id = c.id) AS participant_count, \
         p.status AS my_status \
         FROM contests c JOIN contest_participants p ON p.contest_id = c.id AND p.user_id = $2 \
         WHERE c.id = $1",
    )
    .bind(contest_id)
    .bind(user_id)
    .fetch_optional(pool)
    .await
    .map_err(AppError::Database)?
    .ok_or_else(|| AppError::NotFound("比赛不存在".to_owned()))?;
    Ok(ContestSummary {
        id: row.id,
        event_id: row.official_event_id,
        status: row.status,
        duration_seconds: row.duration_seconds,
        problem_count: row.problem_count,
        starts_at: row.starts_at,
        ends_at: row.ends_at,
        finished_at: row.finished_at,
        participant_count: row.participant_count,
        my_status: row.my_status,
        server_time: Utc::now(),
    })
}

async fn try_match(pool: &PgPool) -> Result<Option<i32>, AppError> {
    let mut transaction = pool.begin().await.map_err(AppError::Database)?;
    sqlx::query("SELECT pg_advisory_xact_lock($1, 0)")
        .bind(CONTEST_LOCK_NAMESPACE)
        .execute(&mut *transaction)
        .await
        .map_err(AppError::Database)?;

    let queued: Vec<QueueRow> = sqlx::query_as(
        "SELECT q.user_id, q.camera_permission, q.screen_permission, \
                u.contest_rating AS rating, q.joined_at \
         FROM contest_queue q \
         JOIN users u ON u.id = q.user_id AND u.status = 'active' \
         WHERE u.reputation_score >= 40 \
         ORDER BY q.joined_at, q.user_id LIMIT 400 FOR UPDATE OF q",
    )
    .fetch_all(&mut *transaction)
    .await
    .map_err(AppError::Database)?;
    let Some(group) = select_fair_group(&queued, Utc::now()) else {
        transaction.commit().await.map_err(AppError::Database)?;
        return Ok(None);
    };
    let user_ids: Vec<i32> = group.iter().map(|row| row.user_id).collect();

    let problems = sqlx::query_as::<_, ProblemSnapshotRow>(
        "SELECT id, title, description, difficulty, time_limit, memory_limit, tags, examples, \
         code_template, run_config, judge_cases FROM problems \
         WHERE review_status = 'approved' AND run_config IS NOT NULL \
           AND judge_cases IS NOT NULL AND jsonb_typeof(judge_cases) = 'array' \
           AND jsonb_array_length(judge_cases) > 0 \
         ORDER BY random() LIMIT $1",
    )
    .bind(PROBLEMS_PER_CONTEST)
    .fetch_all(&mut *transaction)
    .await
    .map_err(AppError::Database)?;
    if problems.len() < PROBLEMS_PER_CONTEST as usize {
        transaction.commit().await.map_err(AppError::Database)?;
        return Ok(None);
    }

    let season_id = season_service::current_season_id_tx(&mut transaction).await?;
    let contest_id: i32 = sqlx::query_scalar(
        "INSERT INTO contests \
         (status, duration_seconds, problem_count, solve_weight, speed_weight, coding_weight, \
          starts_at, ends_at, season_id) \
         VALUES ('running', $1, $2, $3, $4, $5, CURRENT_TIMESTAMP, \
                 CURRENT_TIMESTAMP + make_interval(secs => $6::double precision), $7) \
         RETURNING id",
    )
    .bind(DURATION_SECONDS)
    .bind(PROBLEMS_PER_CONTEST as i32)
    .bind(SOLVE_WEIGHT)
    .bind(SPEED_WEIGHT)
    .bind(CODING_WEIGHT)
    .bind(f64::from(DURATION_SECONDS))
    .bind(season_id)
    .fetch_one(&mut *transaction)
    .await
    .map_err(AppError::Database)?;

    for (index, problem) in problems.iter().enumerate() {
        let run_config = problem
            .run_config
            .clone()
            .ok_or_else(|| AppError::Internal("比赛题目缺少 run_config".to_owned()))?;
        sqlx::query(
            "INSERT INTO contest_problems \
             (contest_id, problem_id, position, points, title, difficulty, description, \
              time_limit, memory_limit, tags, examples, code_template, run_config, judge_cases) \
             VALUES ($1, $2, $3, 100, $4, $5, $6, $7, $8, $9, $10, $11, $12, $13)",
        )
        .bind(contest_id)
        .bind(problem.id)
        .bind((index + 1) as i32)
        .bind(&problem.title)
        .bind(&problem.difficulty)
        .bind(&problem.description)
        .bind(problem.time_limit)
        .bind(problem.memory_limit)
        .bind(&problem.tags)
        .bind(
            problem
                .examples
                .clone()
                .unwrap_or_else(|| Value::Array(Vec::new())),
        )
        .bind(
            problem
                .code_template
                .clone()
                .unwrap_or_else(|| Value::Object(Default::default())),
        )
        .bind(run_config)
        .bind(problem.judge_cases.clone())
        .execute(&mut *transaction)
        .await
        .map_err(AppError::Database)?;
    }

    for row in &group {
        sqlx::query(
            "INSERT INTO contest_participants \
             (contest_id, user_id, status, camera_permission, screen_permission, rating_before) \
             VALUES ($1, $2, 'active', $3, $4, $5)",
        )
        .bind(contest_id)
        .bind(row.user_id)
        .bind(row.camera_permission.as_deref())
        .bind(row.screen_permission.as_deref())
        .bind(row.rating)
        .execute(&mut *transaction)
        .await
        .map_err(AppError::Database)?;

        if let Some(permission) = row.camera_permission.as_deref() {
            sqlx::query(
                "INSERT INTO contest_events \
                 (contest_id, user_id, event_id, event_type, payload) \
                 VALUES ($1, $2, 'camera-permission', 'camera_permission', $3) \
                 ON CONFLICT DO NOTHING",
            )
            .bind(contest_id)
            .bind(row.user_id)
            .bind(json!({ "permission": permission }))
            .execute(&mut *transaction)
            .await
            .map_err(AppError::Database)?;
        }

        if let Some(permission) = row.screen_permission.as_deref() {
            sqlx::query(
                "INSERT INTO contest_events \
                 (contest_id, user_id, event_id, event_type, payload) \
                 VALUES ($1, $2, 'screen-permission', 'screen_permission', $3) \
                 ON CONFLICT DO NOTHING",
            )
            .bind(contest_id)
            .bind(row.user_id)
            .bind(json!({ "permission": permission }))
            .execute(&mut *transaction)
            .await
            .map_err(AppError::Database)?;
        }
    }

    sqlx::query("DELETE FROM contest_queue WHERE user_id = ANY($1)")
        .bind(&user_ids)
        .execute(&mut *transaction)
        .await
        .map_err(AppError::Database)?;

    transaction.commit().await.map_err(AppError::Database)?;
    tracing::info!(
        contest_id,
        participants = user_ids.len(),
        "contest matched and started"
    );
    Ok(Some(contest_id))
}

/// Picks a queued group whose highest and lowest ratings differ by at most the
/// rating window. Four-player rooms are preferred; when the queue is too thin,
/// players who have waited long enough fall back to a 3- or 2-player room so a
/// small server does not leave everyone waiting forever.
fn select_fair_group(rows: &[QueueRow], now: DateTime<Utc>) -> Option<Vec<QueueRow>> {
    if let Some(group) = best_rating_group(rows, 4, RATING_WINDOW, 0, now) {
        return Some(group);
    }
    if let Some(group) = best_rating_group(
        rows,
        3,
        FALLBACK_RATING_WINDOW,
        MATCH_FALLBACK_THREE_SECONDS,
        now,
    ) {
        return Some(group);
    }
    best_rating_group(
        rows,
        2,
        FALLBACK_RATING_WINDOW,
        MATCH_FALLBACK_TWO_SECONDS,
        now,
    )
}

fn best_rating_group(
    rows: &[QueueRow],
    group_size: usize,
    rating_window: i32,
    min_wait_seconds: i64,
    now: DateTime<Utc>,
) -> Option<Vec<QueueRow>> {
    if rows.len() < group_size {
        return None;
    }
    let mut sorted = rows.to_vec();
    sorted.sort_by(|left, right| {
        left.rating
            .cmp(&right.rating)
            .then_with(|| left.joined_at.cmp(&right.joined_at))
            .then_with(|| left.user_id.cmp(&right.user_id))
    });
    let mut best: Option<(DateTime<Utc>, Vec<QueueRow>)> = None;
    for window in sorted.windows(group_size) {
        if window[group_size - 1].rating - window[0].rating > rating_window {
            continue;
        }
        let ready_at = window.iter().map(|row| row.joined_at).max().unwrap_or(now);
        if (now - ready_at).num_seconds() < min_wait_seconds {
            continue;
        }
        if best.as_ref().is_none_or(|(current, _)| ready_at < *current) {
            best = Some((ready_at, window.to_vec()));
        }
    }
    best.map(|(_, group)| group)
}

async fn user_rating(pool: &PgPool, user_id: i32) -> Result<i32, AppError> {
    Ok(
        sqlx::query_scalar("SELECT contest_rating FROM users WHERE id = $1")
            .bind(user_id)
            .fetch_optional(pool)
            .await
            .map_err(AppError::Database)?
            .unwrap_or(DEFAULT_CONTEST_RATING),
    )
}

fn normalize_camera(value: Option<&str>) -> Result<Option<String>, AppError> {
    match value.map(str::trim).filter(|value| !value.is_empty()) {
        None => Ok(None),
        Some(value) if CAMERA_PERMISSIONS.contains(&value) => Ok(Some(value.to_owned())),
        Some(_) => Err(AppError::BadRequest("摄像头授权状态无效".to_owned())),
    }
}

fn normalize_screen(value: Option<&str>) -> Result<Option<String>, AppError> {
    match value.map(str::trim).filter(|value| !value.is_empty()) {
        None => Ok(None),
        Some(value) if SCREEN_PERMISSIONS.contains(&value) => Ok(Some(value.to_owned())),
        Some(_) => Err(AppError::BadRequest("屏幕共享状态无效".to_owned())),
    }
}

fn validate_event(event: &ContestEventInput) -> Result<(), AppError> {
    let event_id = event.event_id.trim();
    if event_id.is_empty() || event_id.chars().count() > MAX_EVENT_ID_CHARS {
        return Err(AppError::BadRequest("事件 ID 无效".to_owned()));
    }
    if !CONTEST_EVENT_TYPES.contains(&event.event_type.trim()) {
        return Err(AppError::BadRequest(format!(
            "未知事件类型: {}",
            event.event_type
        )));
    }
    if let Some(session_id) = event.session_id.as_deref()
        && session_id.trim().chars().count() > 64
    {
        return Err(AppError::BadRequest("会话 ID 过长".to_owned()));
    }
    if let Some(payload) = event.payload.as_ref()
        && !payload.is_object()
    {
        return Err(AppError::BadRequest("事件 payload 必须是对象".to_owned()));
    }
    Ok(())
}

fn round1(value: f64) -> f64 {
    (value * 10.0).round() / 10.0
}

fn round2(value: f64) -> f64 {
    (value * 100.0).round() / 100.0
}

fn rating_delta_for_rank(rank: i32, player_count: usize) -> i32 {
    match player_count {
        // Small rooms still need a zero-sum-ish spread; otherwise second place
        // would gain rating in a two-player match.
        2 => {
            if rank == 1 {
                15
            } else {
                -15
            }
        }
        3 => match rank {
            1 => 20,
            2 => 0,
            _ => -15,
        },
        _ => match rank {
            1 => RATING_GAIN_FIRST,
            2 => RATING_GAIN_SECOND,
            3 => 0,
            _ => -RATING_LOSS_FOURTH,
        },
    }
}

// ── 限时赛事（official_events） ─────────────────────────────────────

const MAX_GRADE_CHARS: usize = 20;
const MAX_GRADE_SCOPE_ITEMS: usize = 20;

#[derive(Debug, FromRow, Clone)]
struct EventRow {
    id: i32,
    title: String,
    organizer: String,
    event_type: String,
    description: Option<String>,
    registration_url: Option<String>,
    registration_opens_at: Option<DateTime<Utc>>,
    registration_deadline: Option<DateTime<Utc>>,
    starts_at: DateTime<Utc>,
    ends_at: DateTime<Utc>,
    scope: Option<String>,
    grade_scope: Vec<String>,
    capacity: Option<i32>,
    registration_mode: String,
    rules: Value,
    registered_count: i64,
    is_registered: bool,
    is_followed: bool,
    in_class: bool,
    my_grade: Option<String>,
}

#[derive(Debug, FromRow)]
struct LockedEventRow {
    status: String,
    registration_mode: String,
    registration_opens_at: Option<DateTime<Utc>>,
    registration_deadline: Option<DateTime<Utc>>,
    starts_at: DateTime<Utc>,
    ends_at: DateTime<Utc>,
    capacity: Option<i32>,
    class_id: Option<i32>,
    grade_scope: Vec<String>,
}

/// Homepage list: ranked configuration plus every published event that has not
/// ended. Only `published` events are visible; draft and cancelled events stay
/// hidden until an administrator publishes them.
pub async fn featured(pool: &PgPool, user_id: i32) -> Result<FeaturedContestsResponse, AppError> {
    let my_rating = user_rating(pool, user_id).await?;
    let season = season_service::ensure_active_season(pool).await?;
    let rows = fetch_event_rows(pool, user_id, None, true).await?;
    let now = Utc::now();
    let events_total = rows.len() as i64;
    let events = rows
        .into_iter()
        .take(FEATURED_EVENT_LIMIT)
        .map(|row| build_event_card(row, now))
        .collect();
    Ok(FeaturedContestsResponse {
        ranked: ranked_config(my_rating, season),
        events,
        events_total,
        server_time: now,
    })
}

/// Paginated event list for the standalone "all events" page. Events are
/// filtered and sorted in memory because status is derived from the clock;
/// the published-event set for one school is small enough for this to stay
/// simple and consistent with the homepage cards.
pub async fn list_events(
    pool: &PgPool,
    user_id: i32,
    query: ContestEventListQuery,
) -> Result<ContestEventListResponse, AppError> {
    let event_type = normalize_event_type(query.event_type.as_deref())?;
    let status = normalize_event_status(query.status.as_deref())?;
    let page = query.page.unwrap_or(1).max(1);
    let page_size = query
        .page_size
        .unwrap_or(EVENT_PAGE_SIZE_DEFAULT)
        .clamp(1, EVENT_PAGE_SIZE_MAX);

    let rows = fetch_event_rows(pool, user_id, None, false).await?;
    let now = Utc::now();
    let mut events: Vec<ContestEventCard> = rows
        .into_iter()
        .map(|row| build_event_card(row, now))
        .collect();
    if let Some(event_type) = event_type {
        events.retain(|event| event.event_type == event_type);
    }
    if let Some(status) = status {
        events.retain(|event| event.status == status);
    }
    if query.following.unwrap_or(false) {
        events.retain(|event| event.is_followed);
    }
    events.sort_by(event_list_order);

    let total = events.len() as i64;
    let offset = (page - 1).saturating_mul(page_size);
    let page_events = events
        .into_iter()
        .skip(usize::try_from(offset).unwrap_or(usize::MAX))
        .take(usize::try_from(page_size).unwrap_or(0))
        .collect();
    Ok(ContestEventListResponse {
        events: page_events,
        total,
        page,
        page_size,
        server_time: now,
    })
}

pub async fn follow_event(
    pool: &PgPool,
    user_id: i32,
    event_id: i32,
    follow: bool,
) -> Result<FollowEventResponse, AppError> {
    let status: Option<String> =
        sqlx::query_scalar("SELECT status FROM official_events WHERE id = $1")
            .bind(event_id)
            .fetch_optional(pool)
            .await
            .map_err(AppError::Database)?;
    match status.as_deref() {
        Some("published") => {}
        _ => return Err(AppError::NotFound("赛事不存在".to_owned())),
    }

    if follow {
        sqlx::query(
            "INSERT INTO official_event_followers (event_id, user_id) VALUES ($1, $2) \
             ON CONFLICT (event_id, user_id) DO NOTHING",
        )
        .bind(event_id)
        .bind(user_id)
        .execute(pool)
        .await
        .map_err(AppError::Database)?;
    } else {
        sqlx::query("DELETE FROM official_event_followers WHERE event_id = $1 AND user_id = $2")
            .bind(event_id)
            .bind(user_id)
            .execute(pool)
            .await
            .map_err(AppError::Database)?;
    }
    Ok(FollowEventResponse {
        is_followed: follow,
    })
}

pub async fn event_detail(
    pool: &PgPool,
    user_id: i32,
    event_id: i32,
) -> Result<ContestEventDetailResponse, AppError> {
    let row = fetch_event_rows(pool, user_id, Some(event_id), false)
        .await?
        .into_iter()
        .next()
        .ok_or_else(|| AppError::NotFound("赛事不存在".to_owned()))?;
    let rules = parse_rules(&row.rules);
    let description = row.description.clone();
    let registration_url = row.registration_url.clone();
    let card = build_event_card(row, Utc::now());
    Ok(ContestEventDetailResponse {
        card,
        description,
        registration_url,
        rules,
    })
}

/// Public registration. `invite` events use [`join_event`] instead; both share
/// the same validation so capacity and eligibility rules stay in one place.
pub async fn register_event(
    pool: &PgPool,
    user_id: i32,
    event_id: i32,
) -> Result<ContestEventCard, AppError> {
    register_event_inner(pool, user_id, event_id, false).await
}

pub async fn join_event(
    pool: &PgPool,
    user_id: i32,
    event_id: i32,
) -> Result<ContestEventCard, AppError> {
    register_event_inner(pool, user_id, event_id, true).await
}

async fn register_event_inner(
    pool: &PgPool,
    user_id: i32,
    event_id: i32,
    invite_flow: bool,
) -> Result<ContestEventCard, AppError> {
    ensure_reputation_for_events(pool, user_id).await?;
    let mut transaction = pool.begin().await.map_err(AppError::Database)?;
    let event = sqlx::query_as::<_, LockedEventRow>(
        "SELECT status, registration_mode, registration_opens_at, registration_closes_at, \
                starts_at, ends_at, capacity, class_id, grade_scope \
         FROM official_events WHERE id = $1 FOR UPDATE",
    )
    .bind(event_id)
    .fetch_optional(&mut *transaction)
    .await
    .map_err(AppError::Database)?
    .ok_or_else(|| AppError::NotFound("赛事不存在".to_owned()))?;

    if event.status != "published" {
        return Err(AppError::NotFound("赛事不存在".to_owned()));
    }

    let now = Utc::now();
    if now >= event.ends_at {
        return Err(AppError::ConflictWith("赛事已结束".to_owned()));
    }
    if now >= event.starts_at {
        return Err(AppError::ConflictWith("赛事已开始，无法报名".to_owned()));
    }
    if event.registration_mode == "external" {
        return Err(AppError::BadRequest("该赛事需通过外部链接报名".to_owned()));
    }
    if invite_flow && event.registration_mode != "invite" {
        return Err(AppError::BadRequest("该赛事需要先报名".to_owned()));
    }
    if !invite_flow && event.registration_mode != "open" {
        return Err(AppError::BadRequest(
            "该赛事为邀请赛事，请直接加入".to_owned(),
        ));
    }
    if let Some(opens_at) = event.registration_opens_at
        && now < opens_at
    {
        return Err(AppError::ConflictWith("报名尚未开始".to_owned()));
    }
    if let Some(deadline) = event.registration_deadline
        && now >= deadline
    {
        return Err(AppError::ConflictWith("报名已截止".to_owned()));
    }
    if let Some(class_id) = event.class_id {
        let allowed: bool = sqlx::query_scalar(
            "SELECT EXISTS (SELECT 1 FROM class_members \
                            WHERE class_id = $1 AND user_id = $2 AND status = 'active') \
                 OR EXISTS (SELECT 1 FROM classes WHERE id = $1 AND owner_id = $2)",
        )
        .bind(class_id)
        .bind(user_id)
        .fetch_one(&mut *transaction)
        .await
        .map_err(AppError::Database)?;
        if !allowed {
            return Err(AppError::ForbiddenWith("仅限指定组织的学生参加".to_owned()));
        }
    }
    if !event.grade_scope.is_empty() {
        let my_grade: Option<String> = sqlx::query_scalar("SELECT grade FROM users WHERE id = $1")
            .bind(user_id)
            .fetch_one(&mut *transaction)
            .await
            .map_err(AppError::Database)?;
        if !grade_allowed(&event.grade_scope, my_grade.as_deref()) {
            return Err(AppError::ForbiddenWith(grade_scope_reason(
                &event.grade_scope,
            )));
        }
    }

    let already_registered: bool = sqlx::query_scalar(
        "SELECT EXISTS (SELECT 1 FROM official_event_registrations \
                        WHERE event_id = $1 AND user_id = $2 \
                          AND status IN ('registered', 'joined'))",
    )
    .bind(event_id)
    .bind(user_id)
    .fetch_one(&mut *transaction)
    .await
    .map_err(AppError::Database)?;

    if !already_registered {
        let registered_count: i64 = sqlx::query_scalar(
            "SELECT COUNT(*) FROM official_event_registrations \
             WHERE event_id = $1 AND status IN ('registered', 'joined')",
        )
        .bind(event_id)
        .fetch_one(&mut *transaction)
        .await
        .map_err(AppError::Database)?;
        if let Some(capacity) = event.capacity
            && registered_count >= i64::from(capacity)
        {
            return Err(AppError::ConflictWith("名额已满".to_owned()));
        }
    }

    let status = if invite_flow { "joined" } else { "registered" };
    sqlx::query(
        "INSERT INTO official_event_registrations (event_id, user_id, status) \
         VALUES ($1, $2, $3) \
         ON CONFLICT (event_id, user_id) DO UPDATE \
            SET status = EXCLUDED.status, registered_at = CURRENT_TIMESTAMP",
    )
    .bind(event_id)
    .bind(user_id)
    .bind(status)
    .execute(&mut *transaction)
    .await
    .map_err(AppError::Database)?;

    transaction.commit().await.map_err(AppError::Database)?;
    fetch_event_card(pool, user_id, event_id).await
}

async fn fetch_event_card(
    pool: &PgPool,
    user_id: i32,
    event_id: i32,
) -> Result<ContestEventCard, AppError> {
    let row = fetch_event_rows(pool, user_id, Some(event_id), false)
        .await?
        .into_iter()
        .next()
        .ok_or_else(|| AppError::NotFound("赛事不存在".to_owned()))?;
    Ok(build_event_card(row, Utc::now()))
}

async fn fetch_event_rows(
    pool: &PgPool,
    user_id: i32,
    event_id: Option<i32>,
    only_active: bool,
) -> Result<Vec<EventRow>, AppError> {
    // `only_active` hides ended events from the homepage while still allowing
    // a card that was just registered for to be read back.
    let sql = if only_active {
        EVENT_SELECT_SQL.to_owned() + " AND e.ends_at > CURRENT_TIMESTAMP"
    } else {
        EVENT_SELECT_SQL.to_owned()
    };
    let sql = sql
        + " ORDER BY CASE WHEN e.starts_at <= CURRENT_TIMESTAMP THEN 0 ELSE 1 END, \
             CASE WHEN e.starts_at <= CURRENT_TIMESTAMP THEN e.ends_at ELSE e.starts_at END ASC, \
             e.id ASC";
    sqlx::query_as::<_, EventRow>(&sql)
        .bind(user_id)
        .bind(event_id)
        .fetch_all(pool)
        .await
        .map_err(AppError::Database)
}

const EVENT_SELECT_SQL: &str = "SELECT e.id, e.title, e.organizer, e.event_type, e.description, \
        e.registration_url, e.registration_opens_at, \
        e.registration_closes_at AS registration_deadline, \
        e.starts_at, e.ends_at, e.scope, e.grade_scope, e.capacity, e.registration_mode, \
        COALESCE(e.rules, '[]'::jsonb) AS rules, \
        (SELECT COUNT(*) FROM official_event_registrations r \
          WHERE r.event_id = e.id AND r.status IN ('registered', 'joined')) AS registered_count, \
        EXISTS (SELECT 1 FROM official_event_registrations r \
          WHERE r.event_id = e.id AND r.user_id = $1 \
            AND r.status IN ('registered', 'joined')) AS is_registered, \
        EXISTS (SELECT 1 FROM official_event_followers f \
          WHERE f.event_id = e.id AND f.user_id = $1) AS is_followed, \
        CASE WHEN e.class_id IS NULL THEN TRUE ELSE ( \
            EXISTS (SELECT 1 FROM class_members m \
              WHERE m.class_id = e.class_id AND m.user_id = $1 AND m.status = 'active') \
            OR EXISTS (SELECT 1 FROM classes c \
              WHERE c.id = e.class_id AND c.owner_id = $1)) END AS in_class, \
        (SELECT u.grade FROM users u WHERE u.id = $1) AS my_grade \
     FROM official_events e \
     WHERE e.status = 'published' AND ($2::int IS NULL OR e.id = $2::int)";

fn build_event_card(row: EventRow, now: DateTime<Utc>) -> ContestEventCard {
    let ended = now >= row.ends_at;
    let started = now >= row.starts_at && !ended;
    let full = row
        .capacity
        .is_some_and(|capacity| row.registered_count >= i64::from(capacity));
    let registration_open = registration_open(&row, now);
    let grade_ok = grade_allowed(&row.grade_scope, row.my_grade.as_deref());
    let eligible = row.in_class && grade_ok;

    let status = if ended {
        EVENT_STATUS_FINISHED
    } else if started {
        EVENT_STATUS_RUNNING
    } else if full && !row.is_registered {
        EVENT_STATUS_FULL
    } else if registration_open {
        EVENT_STATUS_REGISTRATION
    } else {
        EVENT_STATUS_UPCOMING
    };

    let action = if ended {
        EVENT_ACTION_CLOSED
    } else if started {
        if row.is_registered {
            EVENT_ACTION_ENTER
        } else {
            EVENT_ACTION_DETAILS
        }
    } else if row.is_registered {
        EVENT_ACTION_DETAILS
    } else if full {
        EVENT_ACTION_FULL
    } else if row.registration_mode == "external" {
        EVENT_ACTION_DETAILS
    } else if registration_open {
        if row.registration_mode == "invite" {
            EVENT_ACTION_JOIN
        } else {
            EVENT_ACTION_REGISTER
        }
    } else {
        EVENT_ACTION_CLOSED
    };

    let mut ineligible_reason = if !row.in_class {
        Some("仅限指定组织的学生参加".to_owned())
    } else if !grade_ok {
        Some(grade_scope_reason(&row.grade_scope))
    } else {
        None
    };
    if ineligible_reason.is_none() && full && !row.is_registered {
        ineligible_reason = Some("名额已满".to_owned());
    }
    if ineligible_reason.is_none() && action == EVENT_ACTION_CLOSED && !ended {
        ineligible_reason = Some(closed_reason(&row, now));
    }

    let rules = parse_rules(&row.rules);
    let rules_summary = rules
        .iter()
        .find_map(|group| group.items.first().cloned())
        .or_else(|| rules.first().map(|group| group.title.clone()));

    ContestEventCard {
        id: row.id,
        title: row.title,
        organizer: row.organizer,
        event_type: row.event_type,
        status: status.to_owned(),
        starts_at: row.starts_at,
        ends_at: row.ends_at,
        registration_opens_at: row.registration_opens_at,
        registration_deadline: row.registration_deadline,
        scope: row.scope,
        grade_scope: row.grade_scope,
        capacity: row.capacity,
        registered_count: row.registered_count,
        is_registered: row.is_registered,
        is_followed: row.is_followed,
        eligible,
        ineligible_reason,
        action: action.to_owned(),
        rules_summary,
    }
}

fn registration_open(row: &EventRow, now: DateTime<Utc>) -> bool {
    if row.registration_mode == "external" {
        return false;
    }
    if now >= row.starts_at || now >= row.ends_at {
        return false;
    }
    if row
        .registration_opens_at
        .is_some_and(|opens_at| now < opens_at)
    {
        return false;
    }
    if row
        .registration_deadline
        .is_some_and(|deadline| now >= deadline)
    {
        return false;
    }
    true
}

fn closed_reason(row: &EventRow, now: DateTime<Utc>) -> String {
    if row
        .registration_deadline
        .is_some_and(|deadline| now >= deadline)
    {
        "报名已截止".to_owned()
    } else if row
        .registration_opens_at
        .is_some_and(|opens_at| now < opens_at)
    {
        "报名尚未开始".to_owned()
    } else {
        "当前不可报名".to_owned()
    }
}

/// 年级范围为空表示不限制；否则要求用户年级精确命中其中一项。
fn grade_allowed(grade_scope: &[String], grade: Option<&str>) -> bool {
    if grade_scope.is_empty() {
        return true;
    }
    grade.is_some_and(|grade| grade_scope.iter().any(|item| item == grade))
}

fn grade_scope_reason(grade_scope: &[String]) -> String {
    format!("仅限 {} 学生参加", grade_scope.join("、"))
}

fn parse_rules(value: &Value) -> Vec<EventRuleGroup> {
    let mut groups: Vec<EventRuleGroup> = serde_json::from_value(value.clone()).unwrap_or_default();
    // 规则是列表项，末尾不需要句号；这里统一去掉，兼容已录入的历史数据。
    for group in &mut groups {
        group.title = group.title.trim_end_matches('。').trim_end().to_owned();
        for item in &mut group.items {
            *item = item.trim_end_matches('。').trim_end().to_owned();
        }
    }
    groups
}

fn normalize_event_type(value: Option<&str>) -> Result<Option<String>, AppError> {
    let Some(value) = value.map(str::trim).filter(|value| !value.is_empty()) else {
        return Ok(None);
    };
    if value == "all" {
        return Ok(None);
    }
    if !EVENT_TYPE_FILTERS.contains(&value) {
        return Err(AppError::BadRequest("赛事类型无效".to_owned()));
    }
    Ok(Some(value.to_owned()))
}

fn normalize_event_status(value: Option<&str>) -> Result<Option<String>, AppError> {
    let Some(value) = value.map(str::trim).filter(|value| !value.is_empty()) else {
        return Ok(None);
    };
    if value == "all" {
        return Ok(None);
    }
    if !EVENT_STATUS_FILTERS.contains(&value) {
        return Err(AppError::BadRequest("赛事状态无效".to_owned()));
    }
    Ok(Some(value.to_owned()))
}

/// Running events first, then registration/upcoming by start time, then
/// finished events newest first.
fn event_list_order(left: &ContestEventCard, right: &ContestEventCard) -> Ordering {
    fn rank(status: &str) -> i32 {
        match status {
            EVENT_STATUS_RUNNING => 0,
            EVENT_STATUS_FINISHED => 2,
            _ => 1,
        }
    }
    rank(&left.status)
        .cmp(&rank(&right.status))
        .then_with(|| {
            if rank(&left.status) == 2 {
                right.ends_at.cmp(&left.ends_at)
            } else {
                left.starts_at.cmp(&right.starts_at)
            }
        })
        .then_with(|| left.id.cmp(&right.id))
}

fn ranked_config(my_rating: i32, season: Option<SeasonSummary>) -> RankedConfig {
    RankedConfig {
        mode: "ranked".to_owned(),
        title: "4 人排位赛".to_owned(),
        participants: 4,
        duration_minutes: DURATION_SECONDS / 60,
        problem_count: PROBLEMS_PER_CONTEST as i32,
        rating_window: RATING_WINDOW,
        my_rating,
        season,
        rules: vec![
            EventRuleGroup {
                title: "比赛流程".to_owned(),
                items: vec![
                    "匹配 4 名选手后自动开始比赛，完成题目并提交，比赛结束后统一结算".to_owned(),
                    "比赛开始后不能取消，可以提前「完成并离场」，成绩保留并等待结算".to_owned(),
                ],
            },
            EventRuleGroup {
                title: "计分与排名".to_owned(),
                items: vec![
                    format!(
                        "总分由通过题数 {:.0}%、完成速度 {:.0}%、代码书写 {:.0}% 加权计算",
                        SOLVE_WEIGHT * 100.0,
                        SPEED_WEIGHT * 100.0,
                        CODING_WEIGHT * 100.0
                    ),
                    "每道题只按首次通过时间计入速度分，未通过的题目不计分".to_owned(),
                ],
            },
            EventRuleGroup {
                title: "匹配限制".to_owned(),
                items: vec!["同一时间只能参加一场比赛或排队一次".to_owned()],
            },
            EventRuleGroup {
                title: "设备与行为记录".to_owned(),
                items: vec![
                    "开始排位赛必须开启摄像头；系统只记录授权状态，不录制或上传视频".to_owned(),
                    "比赛期间会记录切屏和粘贴行为，仅用于赛后审计，不会自动扣分".to_owned(),
                ],
            },
            EventRuleGroup {
                title: "成绩与通知".to_owned(),
                items: vec![
                    "比赛结束后统一结算，结果通过站内通知发送".to_owned(),
                    "比赛结果页可以查看排名、总分和每题得分明细".to_owned(),
                ],
            },
        ],
    }
}

// ── 赛事内答题、赛事排行榜与后台维护 ───────────────────────────────

#[derive(Debug, FromRow)]
struct EventContestRow {
    status: String,
    starts_at: DateTime<Utc>,
    ends_at: DateTime<Utc>,
    title: String,
}

#[derive(Debug, FromRow)]
struct EventProblemRow {
    id: i32,
    title: String,
    description: String,
    difficulty: String,
    time_limit: i32,
    memory_limit: i32,
    tags: Vec<String>,
    examples: Option<Value>,
    code_template: Option<Value>,
    run_config: Option<Value>,
    judge_cases: Option<Value>,
    points: i32,
}

/// Creates the single contest instance for an event if it does not exist yet.
/// All registrants are inserted up front so rankings include players who have
/// not opened the contest page.
async fn ensure_event_contest(pool: &PgPool, event_id: i32) -> Result<i32, AppError> {
    if let Some(contest_id) =
        sqlx::query_scalar("SELECT id FROM contests WHERE official_event_id = $1")
            .bind(event_id)
            .fetch_optional(pool)
            .await
            .map_err(AppError::Database)?
    {
        return Ok(contest_id);
    }

    let mut transaction = pool.begin().await.map_err(AppError::Database)?;
    let event = sqlx::query_as::<_, EventContestRow>(
        "SELECT status, starts_at, ends_at, title FROM official_events \
         WHERE id = $1 FOR UPDATE",
    )
    .bind(event_id)
    .fetch_optional(&mut *transaction)
    .await
    .map_err(AppError::Database)?
    .ok_or_else(|| AppError::NotFound("赛事不存在".to_owned()))?;
    if event.status != "published" {
        return Err(AppError::NotFound("赛事不存在".to_owned()));
    }

    let now = Utc::now();
    if now < event.starts_at {
        return Err(AppError::ConflictWith("赛事尚未开始".to_owned()));
    }
    if now >= event.ends_at {
        return Err(AppError::ConflictWith("赛事已结束".to_owned()));
    }

    if let Some(contest_id) =
        sqlx::query_scalar("SELECT id FROM contests WHERE official_event_id = $1")
            .bind(event_id)
            .fetch_optional(&mut *transaction)
            .await
            .map_err(AppError::Database)?
    {
        transaction.commit().await.map_err(AppError::Database)?;
        return Ok(contest_id);
    }

    let problems = sqlx::query_as::<_, EventProblemRow>(
        "SELECT p.id, p.title, p.description, p.difficulty, p.time_limit, p.memory_limit, \
                p.tags, p.examples, p.code_template, p.run_config, p.judge_cases, op.points \
         FROM official_event_problems op JOIN problems p ON p.id = op.problem_id \
         WHERE op.event_id = $1 ORDER BY op.position",
    )
    .bind(event_id)
    .fetch_all(&mut *transaction)
    .await
    .map_err(AppError::Database)?;
    if problems.is_empty() {
        return Err(AppError::BadRequest(
            "赛事暂未配置题目，请联系管理员".to_owned(),
        ));
    }

    let duration_seconds = (event.ends_at - event.starts_at)
        .num_seconds()
        .clamp(1, i64::from(i32::MAX)) as i32;
    let contest_id: i32 = sqlx::query_scalar(
        "INSERT INTO contests \
         (status, duration_seconds, problem_count, solve_weight, speed_weight, coding_weight, \
          starts_at, ends_at, official_event_id) \
         VALUES ('running', $1, $2, $3, $4, $5, $6, $7, $8) RETURNING id",
    )
    .bind(duration_seconds)
    .bind(problems.len() as i32)
    .bind(SOLVE_WEIGHT)
    .bind(SPEED_WEIGHT)
    .bind(CODING_WEIGHT)
    .bind(event.starts_at)
    .bind(event.ends_at)
    .bind(event_id)
    .fetch_one(&mut *transaction)
    .await
    .map_err(AppError::Database)?;

    for (index, problem) in problems.iter().enumerate() {
        let run_config = problem.run_config.clone().ok_or_else(|| {
            AppError::BadRequest(format!("赛事题目「{}」缺少运行配置", problem.title))
        })?;
        let judge_cases = problem.judge_cases.clone().ok_or_else(|| {
            AppError::BadRequest(format!("赛事题目「{}」缺少判题用例", problem.title))
        })?;
        if !judge_cases.is_array() || judge_cases.as_array().is_some_and(Vec::is_empty) {
            return Err(AppError::BadRequest(format!(
                "赛事题目「{}」缺少判题用例",
                problem.title
            )));
        }
        sqlx::query(
            "INSERT INTO contest_problems \
             (contest_id, problem_id, position, points, title, difficulty, description, \
              time_limit, memory_limit, tags, examples, code_template, run_config, judge_cases) \
             VALUES ($1, $2, $3, $4, $5, $6, $7, $8, $9, $10, $11, $12, $13, $14)",
        )
        .bind(contest_id)
        .bind(problem.id)
        .bind((index + 1) as i32)
        .bind(problem.points)
        .bind(&problem.title)
        .bind(&problem.difficulty)
        .bind(&problem.description)
        .bind(problem.time_limit)
        .bind(problem.memory_limit)
        .bind(&problem.tags)
        .bind(
            problem
                .examples
                .clone()
                .unwrap_or_else(|| Value::Array(Vec::new())),
        )
        .bind(
            problem
                .code_template
                .clone()
                .unwrap_or_else(|| Value::Object(Default::default())),
        )
        .bind(run_config)
        .bind(judge_cases)
        .execute(&mut *transaction)
        .await
        .map_err(AppError::Database)?;
    }

    sqlx::query(
        "INSERT INTO contest_participants (contest_id, user_id, status, rating_before) \
         SELECT $1, r.user_id, 'queued', u.contest_rating \
         FROM official_event_registrations r JOIN users u ON u.id = r.user_id \
         WHERE r.event_id = $2 AND r.status IN ('registered', 'joined') \
         ON CONFLICT (contest_id, user_id) DO NOTHING",
    )
    .bind(contest_id)
    .bind(event_id)
    .execute(&mut *transaction)
    .await
    .map_err(AppError::Database)?;

    transaction.commit().await.map_err(AppError::Database)?;
    tracing::info!(
        contest_id,
        event_id,
        title = %event.title,
        "event contest created"
    );
    Ok(contest_id)
}

pub async fn enter_event(
    pool: &PgPool,
    user_id: i32,
    event_id: i32,
) -> Result<EnterEventResponse, AppError> {
    ensure_reputation_for_events(pool, user_id).await?;
    #[derive(FromRow)]
    struct EnterEventRow {
        status: String,
        starts_at: DateTime<Utc>,
        ends_at: DateTime<Utc>,
        grade_scope: Vec<String>,
    }
    let event: Option<EnterEventRow> = sqlx::query_as(
        "SELECT status, starts_at, ends_at, grade_scope FROM official_events WHERE id = $1",
    )
    .bind(event_id)
    .fetch_optional(pool)
    .await
    .map_err(AppError::Database)?;
    let Some(EnterEventRow {
        status,
        starts_at,
        ends_at,
        grade_scope,
    }) = event
    else {
        return Err(AppError::NotFound("赛事不存在".to_owned()));
    };
    if status != "published" {
        return Err(AppError::NotFound("赛事不存在".to_owned()));
    }
    if !grade_scope.is_empty() {
        let my_grade: Option<String> = sqlx::query_scalar("SELECT grade FROM users WHERE id = $1")
            .bind(user_id)
            .fetch_one(pool)
            .await
            .map_err(AppError::Database)?;
        if !grade_allowed(&grade_scope, my_grade.as_deref()) {
            return Err(AppError::ForbiddenWith(grade_scope_reason(&grade_scope)));
        }
    }
    let now = Utc::now();
    if now < starts_at {
        return Err(AppError::ConflictWith("赛事尚未开始".to_owned()));
    }
    if now >= ends_at {
        return Err(AppError::ConflictWith("赛事已结束".to_owned()));
    }

    let registered: bool = sqlx::query_scalar(
        "SELECT EXISTS (SELECT 1 FROM official_event_registrations \
                        WHERE event_id = $1 AND user_id = $2 \
                          AND status IN ('registered', 'joined'))",
    )
    .bind(event_id)
    .bind(user_id)
    .fetch_one(pool)
    .await
    .map_err(AppError::Database)?;
    if !registered {
        return Err(AppError::ForbiddenWith("请先报名赛事".to_owned()));
    }

    let contest_id = ensure_event_contest(pool, event_id).await?;
    sqlx::query(
        "INSERT INTO contest_participants (contest_id, user_id, status, rating_before) \
         VALUES ($1, $2, 'active', (SELECT contest_rating FROM users WHERE id = $2)) \
         ON CONFLICT (contest_id, user_id) DO UPDATE \
             SET status = 'active', finished_at = NULL, \
                 last_seen_at = CURRENT_TIMESTAMP, disconnected_at = NULL \
             WHERE contest_participants.status <> 'timed_out'",
    )
    .bind(contest_id)
    .bind(user_id)
    .execute(pool)
    .await
    .map_err(AppError::Database)?;
    Ok(EnterEventResponse {
        event_id,
        contest_id,
    })
}

#[derive(Debug, FromRow)]
struct EventLeaderboardRow {
    user_id: i32,
    username: String,
    rank: Option<i32>,
    total_score: Option<f64>,
    solved_count: i32,
}

pub async fn event_leaderboard(
    pool: &PgPool,
    user_id: i32,
    event_id: i32,
) -> Result<EventLeaderboardResponse, AppError> {
    let status: Option<String> =
        sqlx::query_scalar("SELECT status FROM official_events WHERE id = $1")
            .bind(event_id)
            .fetch_optional(pool)
            .await
            .map_err(AppError::Database)?;
    if status.as_deref() != Some("published") {
        return Err(AppError::NotFound("赛事不存在".to_owned()));
    }

    let contest: Option<(i32, String)> =
        sqlx::query_as("SELECT id, status FROM contests WHERE official_event_id = $1")
            .bind(event_id)
            .fetch_optional(pool)
            .await
            .map_err(AppError::Database)?;

    if let Some((contest_id, contest_status)) = contest {
        let rows = sqlx::query_as::<_, EventLeaderboardRow>(
            "SELECT p.user_id, u.username, p.rank, p.total_score, \
                    (SELECT COUNT(DISTINCT s.problem_id)::int FROM submissions s \
                     WHERE s.contest_id = p.contest_id AND s.user_id = p.user_id \
                       AND s.status = 'accepted') AS solved_count \
             FROM contest_participants p JOIN users u ON u.id = p.user_id \
             WHERE p.contest_id = $1 AND p.status IN ('active', 'disconnected', 'timed_out', 'finished') \
             ORDER BY p.rank NULLS LAST, solved_count DESC, p.joined_at, p.user_id",
        )
        .bind(contest_id)
        .fetch_all(pool)
        .await
        .map_err(AppError::Database)?;
        return Ok(EventLeaderboardResponse {
            event_id,
            state: contest_status,
            contest_id: Some(contest_id),
            entries: rows
                .into_iter()
                .map(|row| EventLeaderboardEntry {
                    rank: row.rank,
                    user_id: row.user_id,
                    username: row.username,
                    solved_count: row.solved_count,
                    total_score: row.total_score.map(round2),
                    is_me: row.user_id == user_id,
                })
                .collect(),
            server_time: Utc::now(),
        });
    }

    let rows: Vec<(i32, String)> = sqlx::query_as(
        "SELECT r.user_id, u.username FROM official_event_registrations r \
         JOIN users u ON u.id = r.user_id \
         WHERE r.event_id = $1 AND r.status IN ('registered', 'joined') \
         ORDER BY r.registered_at, r.user_id",
    )
    .bind(event_id)
    .fetch_all(pool)
    .await
    .map_err(AppError::Database)?;
    Ok(EventLeaderboardResponse {
        event_id,
        state: "pending".to_owned(),
        contest_id: None,
        entries: rows
            .into_iter()
            .map(|(uid, username)| EventLeaderboardEntry {
                rank: None,
                user_id: uid,
                username,
                solved_count: 0,
                total_score: None,
                is_me: uid == user_id,
            })
            .collect(),
        server_time: Utc::now(),
    })
}

pub async fn ranked_leaderboard(
    pool: &PgPool,
    user_id: i32,
    query: RankedLeaderboardQuery,
) -> Result<RankedLeaderboardResponse, AppError> {
    let limit = query.limit.unwrap_or(20).clamp(1, 100);
    let season_list = season_service::list_public(pool).await?;
    let current = season_list.current.clone();
    let selected = match query.season_id {
        Some(season_id) => season_service::season_summary(pool, season_id).await?,
        None => current.clone(),
    };

    #[derive(Debug, FromRow)]
    struct RankRow {
        user_id: i32,
        username: String,
        rating: i32,
        played: i64,
        wins: i64,
    }

    // 有赛季时排行榜只统计该赛季的记录；没有配置赛季的旧部署继续按全局段位统计。
    let Some(season) = selected else {
        let rows = sqlx::query_as::<_, RankRow>(
            "SELECT u.id AS user_id, u.username, u.contest_rating AS rating, \
                    (SELECT COUNT(*) FROM contest_participants cp \
                     JOIN contests c ON c.id = cp.contest_id \
                     WHERE cp.user_id = u.id AND c.official_event_id IS NULL \
                       AND c.status = 'finished') AS played, \
                    (SELECT COUNT(*) FROM contest_participants cp \
                     JOIN contests c ON c.id = cp.contest_id \
                     WHERE cp.user_id = u.id AND c.official_event_id IS NULL \
                       AND c.status = 'finished' AND cp.rank = 1) AS wins \
             FROM users u WHERE u.role = 'student' AND u.status = 'active' \
             ORDER BY u.contest_rating DESC, played DESC, u.username ASC, u.id ASC LIMIT $1",
        )
        .bind(limit)
        .fetch_all(pool)
        .await
        .map_err(AppError::Database)?;

        let my_rank: Option<i64> = sqlx::query_scalar(
            "SELECT ranked.position FROM ( \
                 SELECT u.id, ROW_NUMBER() OVER ( \
                     ORDER BY u.contest_rating DESC, u.username ASC, u.id ASC) AS position \
                 FROM users u WHERE u.role = 'student' AND u.status = 'active' \
             ) ranked WHERE ranked.id = $1",
        )
        .bind(user_id)
        .fetch_optional(pool)
        .await
        .map_err(AppError::Database)?;
        let total: i64 = sqlx::query_scalar(
            "SELECT COUNT(*) FROM users WHERE role = 'student' AND status = 'active'",
        )
        .fetch_one(pool)
        .await
        .map_err(AppError::Database)?;

        return Ok(RankedLeaderboardResponse {
            entries: rows
                .into_iter()
                .enumerate()
                .map(|(index, row)| RankedLeaderboardEntry {
                    rank: index as i64 + 1,
                    user_id: row.user_id,
                    username: row.username,
                    rating: row.rating,
                    played: row.played,
                    wins: row.wins,
                    is_me: row.user_id == user_id,
                })
                .collect(),
            my_rank,
            my_rating: user_rating(pool, user_id).await?,
            total,
            season: None,
            seasons: season_list.items,
            server_time: Utc::now(),
        });
    };

    let season_id = season.id;
    let rows = sqlx::query_as::<_, RankRow>(
        "SELECT u.id AS user_id, u.username, sr.rating, sr.played, sr.wins \
         FROM season_ratings sr JOIN users u ON u.id = sr.user_id \
         WHERE sr.season_id = $2 AND u.role = 'student' AND u.status = 'active' \
         ORDER BY sr.rating DESC, sr.played DESC, u.username ASC, u.id ASC LIMIT $1",
    )
    .bind(limit)
    .bind(season_id)
    .fetch_all(pool)
    .await
    .map_err(AppError::Database)?;

    let my_rank: Option<i64> = sqlx::query_scalar(
        "SELECT ranked.position FROM ( \
             SELECT sr.user_id, ROW_NUMBER() OVER ( \
                 ORDER BY sr.rating DESC, u.username ASC, sr.user_id ASC) AS position \
             FROM season_ratings sr JOIN users u ON u.id = sr.user_id \
             WHERE sr.season_id = $2 AND u.role = 'student' AND u.status = 'active' \
         ) ranked WHERE ranked.user_id = $1",
    )
    .bind(user_id)
    .bind(season_id)
    .fetch_optional(pool)
    .await
    .map_err(AppError::Database)?;
    let total: i64 = sqlx::query_scalar(
        "SELECT COUNT(*) FROM season_ratings sr JOIN users u ON u.id = sr.user_id \
         WHERE sr.season_id = $1 AND u.role = 'student' AND u.status = 'active'",
    )
    .bind(season_id)
    .fetch_one(pool)
    .await
    .map_err(AppError::Database)?;
    let season_rating: Option<i32> = sqlx::query_scalar(
        "SELECT rating FROM season_ratings WHERE season_id = $1 AND user_id = $2",
    )
    .bind(season_id)
    .bind(user_id)
    .fetch_optional(pool)
    .await
    .map_err(AppError::Database)?;
    let is_current = current.as_ref().is_some_and(|item| item.id == season_id);
    let my_rating = match season_rating {
        Some(rating) => rating,
        None if is_current => user_rating(pool, user_id).await?,
        None => DEFAULT_CONTEST_RATING,
    };

    Ok(RankedLeaderboardResponse {
        entries: rows
            .into_iter()
            .enumerate()
            .map(|(index, row)| RankedLeaderboardEntry {
                rank: index as i64 + 1,
                user_id: row.user_id,
                username: row.username,
                rating: row.rating,
                played: row.played,
                wins: row.wins,
                is_me: row.user_id == user_id,
            })
            .collect(),
        my_rank,
        my_rating,
        total,
        season: Some(season),
        seasons: season_list.items,
        server_time: Utc::now(),
    })
}

// ── 管理员赛事维护 ─────────────────────────────────────────────────

struct NormalizedEventInput {
    title: String,
    organizer: String,
    description: Option<String>,
    event_type: String,
    scope: Option<String>,
    grade_scope: Vec<String>,
    capacity: Option<i32>,
    registration_mode: String,
    class_id: Option<i32>,
    registration_url: Option<String>,
    registration_opens_at: Option<DateTime<Utc>>,
    registration_closes_at: Option<DateTime<Utc>>,
    starts_at: DateTime<Utc>,
    ends_at: DateTime<Utc>,
    status: String,
    rules: Value,
    problem_ids: Vec<i32>,
}

fn trim_option(value: Option<String>) -> Option<String> {
    value
        .map(|value| value.trim().to_owned())
        .filter(|value| !value.is_empty())
}

fn normalize_admin_event(mut input: AdminEventInput) -> Result<NormalizedEventInput, AppError> {
    let title = input.title.trim().to_owned();
    if title.is_empty() || title.chars().count() > 200 {
        return Err(AppError::BadRequest(
            "赛事标题不能为空且不超过 200 个字符".to_owned(),
        ));
    }
    let organizer = input.organizer.trim().to_owned();
    if organizer.is_empty() || organizer.chars().count() > 100 {
        return Err(AppError::BadRequest(
            "主办方不能为空且不超过 100 个字符".to_owned(),
        ));
    }
    let event_type = input.event_type.trim().to_owned();
    if !EVENT_TYPE_FILTERS.contains(&event_type.as_str()) {
        return Err(AppError::BadRequest("赛事类型无效".to_owned()));
    }
    let status = input
        .status
        .as_deref()
        .map(str::trim)
        .filter(|value| !value.is_empty())
        .unwrap_or("draft")
        .to_owned();
    if !["draft", "published", "cancelled"].contains(&status.as_str()) {
        return Err(AppError::BadRequest("赛事状态无效".to_owned()));
    }
    let registration_mode = input
        .registration_mode
        .as_deref()
        .map(str::trim)
        .filter(|value| !value.is_empty())
        .unwrap_or("open")
        .to_owned();
    if !["open", "invite", "external"].contains(&registration_mode.as_str()) {
        return Err(AppError::BadRequest("报名方式无效".to_owned()));
    }
    if input.ends_at <= input.starts_at {
        return Err(AppError::BadRequest("结束时间必须晚于开始时间".to_owned()));
    }
    if let Some(deadline) = input.registration_closes_at
        && deadline > input.starts_at
    {
        return Err(AppError::BadRequest(
            "报名截止时间不能晚于开始时间".to_owned(),
        ));
    }
    if let (Some(opens_at), Some(deadline)) =
        (input.registration_opens_at, input.registration_closes_at)
        && deadline <= opens_at
    {
        return Err(AppError::BadRequest(
            "报名截止时间必须晚于报名开始时间".to_owned(),
        ));
    }
    if input
        .capacity
        .is_some_and(|capacity| !(1..=100_000).contains(&capacity))
    {
        return Err(AppError::BadRequest(
            "名额上限必须在 1 到 100000 之间".to_owned(),
        ));
    }

    let description = trim_option(input.description);
    if description
        .as_deref()
        .is_some_and(|text| text.chars().count() > 5000)
    {
        return Err(AppError::BadRequest(
            "赛事说明不能超过 5000 个字符".to_owned(),
        ));
    }
    let scope = trim_option(input.scope);
    if scope
        .as_deref()
        .is_some_and(|text| text.chars().count() > 200)
    {
        return Err(AppError::BadRequest(
            "参赛范围说明不能超过 200 个字符".to_owned(),
        ));
    }
    let mut grade_scope: Vec<String> = Vec::new();
    for grade in input.grade_scope {
        let grade = grade.trim().to_owned();
        if grade.is_empty() {
            continue;
        }
        if grade.chars().count() > MAX_GRADE_CHARS {
            return Err(AppError::BadRequest(format!(
                "年级范围单项不能超过 {MAX_GRADE_CHARS} 个字符"
            )));
        }
        if !grade_scope.contains(&grade) {
            grade_scope.push(grade);
        }
    }
    if grade_scope.len() > MAX_GRADE_SCOPE_ITEMS {
        return Err(AppError::BadRequest(format!(
            "年级范围最多 {MAX_GRADE_SCOPE_ITEMS} 项"
        )));
    }
    let registration_url = trim_option(input.registration_url);
    if let Some(url) = registration_url.as_deref()
        && (!url.starts_with("http://") && !url.starts_with("https://")
            || url.chars().count() > 500)
    {
        return Err(AppError::BadRequest(
            "外部报名链接必须是以 http:// 或 https:// 开头的地址".to_owned(),
        ));
    }

    let mut rules = Vec::with_capacity(input.rules.len());
    if input.rules.len() > 20 {
        return Err(AppError::BadRequest("赛事规则最多 20 组".to_owned()));
    }
    for group in input.rules {
        let group_title = group.title.trim().trim_end_matches('。').trim().to_owned();
        if group_title.is_empty() || group_title.chars().count() > 100 {
            return Err(AppError::BadRequest(
                "规则分组标题不能为空且不超过 100 个字符".to_owned(),
            ));
        }
        if group.items.len() > 50 {
            return Err(AppError::BadRequest("每组规则最多 50 条".to_owned()));
        }
        let mut items = Vec::with_capacity(group.items.len());
        for item in group.items {
            let item = item.trim().trim_end_matches('。').trim().to_owned();
            if item.is_empty() || item.chars().count() > 500 {
                return Err(AppError::BadRequest(
                    "规则内容不能为空且不超过 500 个字符".to_owned(),
                ));
            }
            items.push(item);
        }
        rules.push(EventRuleGroup {
            title: group_title,
            items,
        });
    }

    let mut problem_ids = Vec::new();
    for problem_id in input.problem_ids {
        if problem_id <= 0 || problem_ids.contains(&problem_id) {
            return Err(AppError::BadRequest("题目编号无效或重复".to_owned()));
        }
        problem_ids.push(problem_id);
    }
    if problem_ids.len() > 50 {
        return Err(AppError::BadRequest("赛事最多配置 50 道题".to_owned()));
    }

    input.title = title;
    Ok(NormalizedEventInput {
        title: input.title,
        organizer,
        description,
        event_type,
        scope,
        grade_scope,
        capacity: input.capacity,
        registration_mode,
        class_id: input.class_id,
        registration_url,
        registration_opens_at: input.registration_opens_at,
        registration_closes_at: input.registration_closes_at,
        starts_at: input.starts_at,
        ends_at: input.ends_at,
        status,
        rules: json!(rules),
        problem_ids,
    })
}

async fn ensure_problems_exist(
    transaction: &mut sqlx::Transaction<'_, sqlx::Postgres>,
    problem_ids: &[i32],
) -> Result<(), AppError> {
    if problem_ids.is_empty() {
        return Ok(());
    }
    let existing: i64 = sqlx::query_scalar("SELECT COUNT(*) FROM problems WHERE id = ANY($1)")
        .bind(problem_ids)
        .fetch_one(&mut **transaction)
        .await
        .map_err(AppError::Database)?;
    if existing != problem_ids.len() as i64 {
        return Err(AppError::BadRequest("存在无效的题目编号".to_owned()));
    }
    Ok(())
}

async fn replace_event_problems(
    transaction: &mut sqlx::Transaction<'_, sqlx::Postgres>,
    event_id: i32,
    problem_ids: &[i32],
) -> Result<(), AppError> {
    sqlx::query("DELETE FROM official_event_problems WHERE event_id = $1")
        .bind(event_id)
        .execute(&mut **transaction)
        .await
        .map_err(AppError::Database)?;
    for (index, problem_id) in problem_ids.iter().enumerate() {
        sqlx::query(
            "INSERT INTO official_event_problems (event_id, problem_id, position, points) \
             VALUES ($1, $2, $3, 100)",
        )
        .bind(event_id)
        .bind(problem_id)
        .bind((index + 1) as i32)
        .execute(&mut **transaction)
        .await
        .map_err(AppError::Database)?;
    }
    Ok(())
}

#[derive(Debug, FromRow)]
struct AdminEventRow {
    id: i32,
    title: String,
    organizer: String,
    event_type: String,
    description: Option<String>,
    scope: Option<String>,
    grade_scope: Vec<String>,
    capacity: Option<i32>,
    registration_mode: String,
    class_id: Option<i32>,
    registration_url: Option<String>,
    registration_opens_at: Option<DateTime<Utc>>,
    registration_deadline: Option<DateTime<Utc>>,
    starts_at: DateTime<Utc>,
    ends_at: DateTime<Utc>,
    status: String,
    rules: Value,
    created_at: DateTime<Utc>,
    registered_count: i64,
    contest_id: Option<i32>,
    forum_post_id: Option<i64>,
}

async fn admin_event_views(
    pool: &PgPool,
    event_id: Option<i32>,
) -> Result<Vec<AdminEventView>, AppError> {
    let rows = sqlx::query_as::<_, AdminEventRow>(
        "SELECT e.id, e.title, e.organizer, e.event_type, e.description, e.scope, e.grade_scope, \
                e.capacity, \
                e.registration_mode, e.class_id, e.registration_url, e.registration_opens_at, \
                e.registration_closes_at AS registration_deadline, e.starts_at, e.ends_at, \
                e.status, e.rules, e.created_at, \
                (SELECT COUNT(*) FROM official_event_registrations r \
                 WHERE r.event_id = e.id AND r.status IN ('registered', 'joined')) AS registered_count, \
                (SELECT c.id FROM contests c WHERE c.official_event_id = e.id) AS contest_id,                 e.forum_post_id \
         FROM official_events e \
         WHERE ($1::int IS NULL OR e.id = $1::int) \
         ORDER BY e.starts_at DESC, e.id DESC",
    )
    .bind(event_id)
    .fetch_all(pool)
    .await
    .map_err(AppError::Database)?;

    let problem_rows: Vec<(i32, i32)> = sqlx::query_as(
        "SELECT event_id, problem_id FROM official_event_problems \
         WHERE ($1::int IS NULL OR event_id = $1::int) ORDER BY event_id, position",
    )
    .bind(event_id)
    .fetch_all(pool)
    .await
    .map_err(AppError::Database)?;
    let mut problems: HashMap<i32, Vec<i32>> = HashMap::new();
    for (event_id, problem_id) in problem_rows {
        problems.entry(event_id).or_default().push(problem_id);
    }

    Ok(rows
        .into_iter()
        .map(|row| AdminEventView {
            id: row.id,
            title: row.title,
            organizer: row.organizer,
            event_type: row.event_type,
            description: row.description,
            scope: row.scope,
            grade_scope: row.grade_scope,
            capacity: row.capacity,
            registration_mode: row.registration_mode,
            class_id: row.class_id,
            registration_url: row.registration_url,
            registration_opens_at: row.registration_opens_at,
            registration_deadline: row.registration_deadline,
            starts_at: row.starts_at,
            ends_at: row.ends_at,
            status: row.status,
            rules: parse_rules(&row.rules),
            problem_ids: problems.get(&row.id).cloned().unwrap_or_default(),
            registered_count: row.registered_count,
            contest_id: row.contest_id,
            forum_post_id: row.forum_post_id,
            created_at: row.created_at,
        })
        .collect())
}

pub async fn admin_list_events(pool: &PgPool) -> Result<AdminEventListResponse, AppError> {
    Ok(AdminEventListResponse {
        events: admin_event_views(pool, None).await?,
    })
}

pub async fn admin_get_event(pool: &PgPool, event_id: i32) -> Result<AdminEventView, AppError> {
    admin_event_views(pool, Some(event_id))
        .await?
        .into_iter()
        .next()
        .ok_or_else(|| AppError::NotFound("赛事不存在".to_owned()))
}

pub async fn admin_create_event(
    pool: &PgPool,
    admin_id: i32,
    input: AdminEventInput,
) -> Result<AdminEventView, AppError> {
    let input = normalize_admin_event(input)?;
    let mut transaction = pool.begin().await.map_err(AppError::Database)?;
    if let Some(class_id) = input.class_id {
        let class_exists: bool =
            sqlx::query_scalar("SELECT EXISTS (SELECT 1 FROM classes WHERE id = $1)")
                .bind(class_id)
                .fetch_one(&mut *transaction)
                .await
                .map_err(AppError::Database)?;
        if !class_exists {
            return Err(AppError::BadRequest("组织不存在".to_owned()));
        }
    }
    ensure_problems_exist(&mut transaction, &input.problem_ids).await?;

    let event_id: i32 = sqlx::query_scalar(
        "INSERT INTO official_events \
         (title, organizer, description, registration_url, registration_opens_at, \
          registration_closes_at, starts_at, ends_at, status, event_type, scope, grade_scope, capacity, \
          registration_mode, class_id, rules, created_by) \
         VALUES ($1, $2, $3, $4, $5, $6, $7, $8, $9, $10, $11, $12, $13, $14, $15, $16, $17) \
         RETURNING id",
    )
    .bind(&input.title)
    .bind(&input.organizer)
    .bind(input.description.as_deref())
    .bind(input.registration_url.as_deref())
    .bind(input.registration_opens_at)
    .bind(input.registration_closes_at)
    .bind(input.starts_at)
    .bind(input.ends_at)
    .bind(&input.status)
    .bind(&input.event_type)
    .bind(input.scope.as_deref())
    .bind(&input.grade_scope)
    .bind(input.capacity)
    .bind(&input.registration_mode)
    .bind(input.class_id)
    .bind(&input.rules)
    .bind(admin_id)
    .fetch_one(&mut *transaction)
    .await
    .map_err(AppError::Database)?;

    replace_event_problems(&mut transaction, event_id, &input.problem_ids).await?;
    transaction.commit().await.map_err(AppError::Database)?;
    admin_get_event(pool, event_id).await
}

pub async fn admin_update_event(
    pool: &PgPool,
    event_id: i32,
    input: AdminEventInput,
) -> Result<AdminEventView, AppError> {
    let input = normalize_admin_event(input)?;
    let mut transaction = pool.begin().await.map_err(AppError::Database)?;
    let existing: Option<(DateTime<Utc>, DateTime<Utc>, Option<i32>)> = sqlx::query_as(
        "SELECT starts_at, ends_at, (SELECT c.id FROM contests c WHERE c.official_event_id = e.id) \
         FROM official_events e WHERE id = $1 FOR UPDATE",
    )
    .bind(event_id)
    .fetch_optional(&mut *transaction)
    .await
    .map_err(AppError::Database)?;
    let Some((starts_at, ends_at, contest_id)) = existing else {
        return Err(AppError::NotFound("赛事不存在".to_owned()));
    };

    if contest_id.is_some() {
        // 前端 datetime-local 精确到分钟，允许 60 秒以内的往返误差
        let starts_changed = (starts_at - input.starts_at).num_seconds().abs() >= 60;
        let ends_changed = (ends_at - input.ends_at).num_seconds().abs() >= 60;
        if starts_changed || ends_changed {
            return Err(AppError::ConflictWith(
                "赛事已生成比赛，不能修改开始或结束时间".to_owned(),
            ));
        }
        let current_problems: Vec<i32> = sqlx::query_scalar(
            "SELECT problem_id FROM official_event_problems WHERE event_id = $1 ORDER BY position",
        )
        .bind(event_id)
        .fetch_all(&mut *transaction)
        .await
        .map_err(AppError::Database)?;
        if current_problems != input.problem_ids {
            return Err(AppError::ConflictWith(
                "赛事已生成比赛，不能修改题目".to_owned(),
            ));
        }
    }
    if let Some(class_id) = input.class_id {
        let class_exists: bool =
            sqlx::query_scalar("SELECT EXISTS (SELECT 1 FROM classes WHERE id = $1)")
                .bind(class_id)
                .fetch_one(&mut *transaction)
                .await
                .map_err(AppError::Database)?;
        if !class_exists {
            return Err(AppError::BadRequest("组织不存在".to_owned()));
        }
    }
    ensure_problems_exist(&mut transaction, &input.problem_ids).await?;

    // 已生成比赛时保留原有时间，避免前端分钟精度把秒截断
    let saved_starts_at = if contest_id.is_some() {
        starts_at
    } else {
        input.starts_at
    };
    let saved_ends_at = if contest_id.is_some() {
        ends_at
    } else {
        input.ends_at
    };

    sqlx::query(
        "UPDATE official_events SET title = $2, organizer = $3, description = $4, \
                registration_url = $5, registration_opens_at = $6, registration_closes_at = $7, \
                starts_at = $8, ends_at = $9, status = $10, event_type = $11, scope = $12, \
                grade_scope = $13, capacity = $14, registration_mode = $15, class_id = $16, \
                rules = $17, updated_at = CURRENT_TIMESTAMP \
         WHERE id = $1",
    )
    .bind(event_id)
    .bind(&input.title)
    .bind(&input.organizer)
    .bind(input.description.as_deref())
    .bind(input.registration_url.as_deref())
    .bind(input.registration_opens_at)
    .bind(input.registration_closes_at)
    .bind(saved_starts_at)
    .bind(saved_ends_at)
    .bind(&input.status)
    .bind(&input.event_type)
    .bind(input.scope.as_deref())
    .bind(&input.grade_scope)
    .bind(input.capacity)
    .bind(&input.registration_mode)
    .bind(input.class_id)
    .bind(&input.rules)
    .execute(&mut *transaction)
    .await
    .map_err(AppError::Database)?;

    if input.status == "cancelled" && contest_id.is_some() {
        sqlx::query(
            "UPDATE contests SET status = 'cancelled', updated_at = CURRENT_TIMESTAMP              WHERE official_event_id = $1 AND status IN ('running', 'settling')",
        )
        .bind(event_id)
        .execute(&mut *transaction)
        .await
        .map_err(AppError::Database)?;
    }
    if contest_id.is_none() {
        replace_event_problems(&mut transaction, event_id, &input.problem_ids).await?;
    }
    transaction.commit().await.map_err(AppError::Database)?;
    admin_get_event(pool, event_id).await
}

/// Creates a forum announcement for a published event and pins it until the
/// event ends. A pin-limit conflict leaves the post published but unpinned so
/// the sync itself still succeeds.
pub async fn sync_event_forum(
    pool: &PgPool,
    config: &Config,
    admin: &AuthUser,
    event_id: i32,
) -> Result<EventForumSyncResponse, AppError> {
    type EventForumRow = (
        String,
        Option<String>,
        DateTime<Utc>,
        DateTime<Utc>,
        Option<i64>,
    );
    let row: Option<EventForumRow> = sqlx::query_as(
        "SELECT status, description, starts_at, ends_at, forum_post_id \
             FROM official_events WHERE id = $1",
    )
    .bind(event_id)
    .fetch_optional(pool)
    .await
    .map_err(AppError::Database)?;
    let Some((status, description, starts_at, ends_at, forum_post_id)) = row else {
        return Err(AppError::NotFound("赛事不存在".to_owned()));
    };
    if status != "published" {
        return Err(AppError::ConflictWith(
            "请先发布赛事再同步到校园墙".to_owned(),
        ));
    }
    if let Some(post_id) = forum_post_id {
        return Ok(EventForumSyncResponse {
            event_id,
            forum_post_id: post_id,
            pinned: false,
            message: "赛事已同步过校园墙".to_owned(),
        });
    }

    let title: String = sqlx::query_scalar("SELECT title FROM official_events WHERE id = $1")
        .bind(event_id)
        .fetch_one(pool)
        .await
        .map_err(AppError::Database)?;
    // Forum titles are shorter than event titles; keep the beginning readable.
    let title: String = title.chars().take(MAX_TITLE_CHARS).collect();
    let body = format!(
        "{}\n\n- 开始时间：{}\n- 结束时间：{}\n- [查看赛事详情](/contests/events/{})",
        description
            .as_deref()
            .map(str::trim)
            .filter(|value| !value.is_empty())
            .unwrap_or("赛事已发布，欢迎报名参加"),
        starts_at.to_rfc3339(),
        ends_at.to_rfc3339(),
        event_id,
    );
    let post = forum_service::create_post(
        pool,
        config,
        admin,
        &CreatePostRequest {
            title,
            body_md: body,
            tags: vec!["赛事".to_owned()],
            problem_id: None,
            is_anonymous: false,
        },
    )
    .await?;

    let pinned = match forum_service::admin_pin_post(
        pool,
        config,
        admin,
        post.id,
        &AdminPinRequest { is_pinned: true },
    )
    .await
    {
        Ok(_) => true,
        Err(AppError::ConflictWith(_)) => false,
        Err(error) => return Err(error),
    };

    sqlx::query(
        "UPDATE official_events SET forum_post_id = $2, pinned_until = $3, \
         updated_at = CURRENT_TIMESTAMP WHERE id = $1",
    )
    .bind(event_id)
    .bind(post.id)
    .bind(pinned.then_some(ends_at))
    .execute(pool)
    .await
    .map_err(AppError::Database)?;

    Ok(EventForumSyncResponse {
        event_id,
        forum_post_id: post.id,
        pinned,
        message: if pinned {
            "已同步到校园墙并置顶".to_owned()
        } else {
            "已同步到校园墙，置顶数量已达上限".to_owned()
        },
    })
}

/// Clears event pins after the event ends or is cancelled. Called by the API
/// process scheduler next to contest settlement.
pub async fn expire_event_forum_pins(pool: &PgPool) -> Result<usize, AppError> {
    let rows: Vec<(i64,)> = sqlx::query_as(
        "SELECT forum_post_id FROM official_events \
         WHERE forum_post_id IS NOT NULL AND pinned_until IS NOT NULL \
           AND (pinned_until <= CURRENT_TIMESTAMP OR status = 'cancelled') \
         FOR UPDATE SKIP LOCKED",
    )
    .fetch_all(pool)
    .await
    .map_err(AppError::Database)?;
    let mut count = 0;
    for (post_id,) in rows {
        sqlx::query(
            "UPDATE forum_posts SET is_pinned = FALSE, pinned_at = NULL, \
             updated_at = CURRENT_TIMESTAMP WHERE id = $1 AND is_pinned = TRUE",
        )
        .bind(post_id)
        .execute(pool)
        .await
        .map_err(AppError::Database)?;
        count += 1;
    }
    if count > 0 {
        sqlx::query(
            "UPDATE official_events SET pinned_until = NULL \
             WHERE forum_post_id IS NOT NULL AND pinned_until IS NOT NULL \
               AND (pinned_until <= CURRENT_TIMESTAMP OR status = 'cancelled')",
        )
        .execute(pool)
        .await
        .map_err(AppError::Database)?;
    }
    Ok(count)
}

// ── 赛事申诉 ───────────────────────────────────────────────────────

const MAX_APPEAL_REASON_CHARS: usize = 1000;
const MAX_APPEAL_NOTE_CHARS: usize = 500;
const MAX_REPUTATION_SCORE: f64 = 100.0;

#[derive(Debug, FromRow)]
struct AppealRow {
    id: i64,
    contest_id: i32,
    event_id: Option<i32>,
    event_title: Option<String>,
    user_id: i32,
    username: String,
    reason: String,
    status: String,
    handle_note: Option<String>,
    handled_by: Option<String>,
    disqualified: bool,
    created_at: DateTime<Utc>,
    handled_at: Option<DateTime<Utc>>,
}

impl AppealRow {
    fn into_item(self) -> ContestAppealItem {
        ContestAppealItem {
            id: self.id,
            contest_id: self.contest_id,
            event_id: self.event_id,
            event_title: self.event_title,
            user_id: self.user_id,
            username: self.username,
            reason: self.reason,
            status: self.status,
            handle_note: self.handle_note,
            handled_by: self.handled_by,
            disqualified: self.disqualified,
            created_at: self.created_at,
            handled_at: self.handled_at,
        }
    }
}

const APPEAL_SELECT: &str = "SELECT a.id, a.contest_id, c.official_event_id AS event_id, \
        oe.title AS event_title, a.user_id, u.username, a.reason, a.status, \
        a.handle_note, handler.username AS handled_by, \
        COALESCE(p.disqualified_at IS NOT NULL, FALSE) AS disqualified, \
        a.created_at, a.handled_at \
     FROM contest_appeals a \
     JOIN contests c ON c.id = a.contest_id \
     LEFT JOIN official_events oe ON oe.id = c.official_event_id \
     JOIN users u ON u.id = a.user_id \
     LEFT JOIN users handler ON handler.id = a.handled_by \
     LEFT JOIN contest_participants p ON p.contest_id = a.contest_id AND p.user_id = a.user_id";

async fn fetch_appeal(pool: &PgPool, appeal_id: i64) -> Result<ContestAppealItem, AppError> {
    let row: AppealRow = sqlx::query_as(&format!("{APPEAL_SELECT} WHERE a.id = $1"))
        .bind(appeal_id)
        .fetch_optional(pool)
        .await
        .map_err(AppError::Database)?
        .ok_or_else(|| AppError::NotFound("申诉不存在".to_owned()))?;
    Ok(row.into_item())
}

fn normalize_appeal_status(value: Option<&str>) -> Result<Option<String>, AppError> {
    let Some(status) = value.map(str::trim).filter(|value| !value.is_empty()) else {
        return Ok(None);
    };
    if !["pending", "accepted", "rejected"].contains(&status) {
        return Err(AppError::BadRequest("申诉状态无效".to_owned()));
    }
    Ok(Some(status.to_owned()))
}

pub async fn submit_appeal(
    pool: &PgPool,
    user_id: i32,
    contest_id: i32,
    input: &ContestAppealInput,
) -> Result<ContestAppealItem, AppError> {
    let reason = input.reason.trim();
    if reason.is_empty() || reason.chars().count() > MAX_APPEAL_REASON_CHARS {
        return Err(AppError::BadRequest(format!(
            "申诉理由不能为空且不超过 {MAX_APPEAL_REASON_CHARS} 个字符"
        )));
    }
    let mut transaction = pool.begin().await.map_err(AppError::Database)?;
    let contest: Option<(String, DateTime<Utc>)> =
        sqlx::query_as("SELECT status, ends_at FROM contests WHERE id = $1")
            .bind(contest_id)
            .fetch_optional(&mut *transaction)
            .await
            .map_err(AppError::Database)?;
    let Some((status, ends_at)) = contest else {
        return Err(AppError::NotFound("比赛不存在".to_owned()));
    };
    let is_participant: bool = sqlx::query_scalar(
        "SELECT EXISTS (SELECT 1 FROM contest_participants WHERE contest_id = $1 AND user_id = $2)",
    )
    .bind(contest_id)
    .bind(user_id)
    .fetch_one(&mut *transaction)
    .await
    .map_err(AppError::Database)?;
    if !is_participant {
        return Err(AppError::ForbiddenWith(
            "只能申诉自己参加过的比赛".to_owned(),
        ));
    }
    if status != CONTEST_STATUS_FINISHED && Utc::now() < ends_at {
        return Err(AppError::ConflictWith("比赛结束后才能提交申诉".to_owned()));
    }
    let existing: bool = sqlx::query_scalar(
        "SELECT EXISTS (SELECT 1 FROM contest_appeals WHERE contest_id = $1 AND user_id = $2)",
    )
    .bind(contest_id)
    .bind(user_id)
    .fetch_one(&mut *transaction)
    .await
    .map_err(AppError::Database)?;
    if existing {
        return Err(AppError::ConflictWith("你已提交过该比赛的申诉".to_owned()));
    }
    let proctor_event_id: Option<i64> = sqlx::query_scalar(
        "SELECT id FROM contest_events WHERE contest_id = $1 AND user_id = $2 \
         AND event_type = 'paste_suspicious' ORDER BY id DESC LIMIT 1",
    )
    .bind(contest_id)
    .bind(user_id)
    .fetch_optional(&mut *transaction)
    .await
    .map_err(AppError::Database)?;

    let appeal_id: i64 = sqlx::query_scalar(
        "INSERT INTO contest_appeals (contest_id, user_id, proctor_event_id, reason) \
         VALUES ($1, $2, $3, $4) RETURNING id",
    )
    .bind(contest_id)
    .bind(user_id)
    .bind(proctor_event_id)
    .bind(reason)
    .fetch_one(&mut *transaction)
    .await
    .map_err(AppError::Database)?;

    notification_service::create(
        &mut transaction,
        user_id,
        "contest_notice",
        None,
        "申诉已提交",
        Some("管理员会在复核后给出处理结果，请留意站内通知"),
        Some(&format!("/contests/{contest_id}/result")),
        Some("contest"),
        Some(i64::from(contest_id)),
    )
    .await?;
    transaction.commit().await.map_err(AppError::Database)?;
    fetch_appeal(pool, appeal_id).await
}

pub async fn list_my_appeals(
    pool: &PgPool,
    user_id: i32,
    query: &ContestAppealQuery,
) -> Result<ContestAppealListResponse, AppError> {
    let status = normalize_appeal_status(query.status.as_deref())?;
    let sql = format!(
        "{APPEAL_SELECT} WHERE a.user_id = $1 AND ($2::text IS NULL OR a.status = $2) \
         ORDER BY a.created_at DESC, a.id DESC"
    );
    let rows: Vec<AppealRow> = sqlx::query_as(&sql)
        .bind(user_id)
        .bind(status.as_deref())
        .fetch_all(pool)
        .await
        .map_err(AppError::Database)?;
    let total = rows.len() as i64;
    Ok(ContestAppealListResponse {
        items: rows.into_iter().map(AppealRow::into_item).collect(),
        total,
        server_time: Utc::now(),
    })
}

pub async fn admin_list_appeals(
    pool: &PgPool,
    query: &ContestAppealQuery,
) -> Result<ContestAppealListResponse, AppError> {
    let status = normalize_appeal_status(query.status.as_deref())?;
    let sql = format!(
        "{APPEAL_SELECT} WHERE ($1::text IS NULL OR a.status = $1) \
         ORDER BY CASE WHEN a.status = 'pending' THEN 0 ELSE 1 END, \
                  a.created_at DESC, a.id DESC LIMIT 200"
    );
    let rows: Vec<AppealRow> = sqlx::query_as(&sql)
        .bind(status.as_deref())
        .fetch_all(pool)
        .await
        .map_err(AppError::Database)?;
    let total = rows.len() as i64;
    Ok(ContestAppealListResponse {
        items: rows.into_iter().map(AppealRow::into_item).collect(),
        total,
        server_time: Utc::now(),
    })
}

/// Reverses the cheating penalty recorded for this contest so an accepted
/// appeal actually restores reputation, disqualification and rating.
async fn restore_appeal_penalty(
    transaction: &mut sqlx::Transaction<'_, sqlx::Postgres>,
    contest_id: i32,
    user_id: i32,
    admin_id: i32,
    note: Option<&str>,
) -> Result<bool, AppError> {
    let disqualified: bool = sqlx::query_scalar(
        "SELECT EXISTS (SELECT 1 FROM contest_participants \
                        WHERE contest_id = $1 AND user_id = $2 AND disqualified_at IS NOT NULL)",
    )
    .bind(contest_id)
    .bind(user_id)
    .fetch_one(&mut **transaction)
    .await
    .map_err(AppError::Database)?;

    let restore: f64 = sqlx::query_scalar(
        "SELECT COALESCE(SUM(-delta), 0)::float8 FROM reputation_events \
         WHERE user_id = $1 AND contest_id = $2 AND reason = 'paste_cheating' AND delta < 0",
    )
    .bind(user_id)
    .bind(contest_id)
    .fetch_one(&mut **transaction)
    .await
    .map_err(AppError::Database)?;

    if restore > 0.0 {
        let (score_before, status): (f64, String) = sqlx::query_as(
            "SELECT reputation_score::float8, status FROM users WHERE id = $1 FOR UPDATE",
        )
        .bind(user_id)
        .fetch_optional(&mut **transaction)
        .await
        .map_err(AppError::Database)?
        .ok_or_else(|| AppError::NotFound("用户不存在".to_owned()))?;
        let score_after = round1((score_before + restore).min(MAX_REPUTATION_SCORE));
        sqlx::query(
            "UPDATE users SET reputation_score = $2::float8::numeric(6, 1), \
             status = CASE WHEN status = 'banned' AND $3 THEN 'active' ELSE status END, \
             token_version = token_version + CASE WHEN status = 'banned' AND $3 THEN 1 ELSE 0 END, \
             updated_at = CURRENT_TIMESTAMP WHERE id = $1",
        )
        .bind(user_id)
        .bind(score_after)
        .bind(score_after >= 0.0)
        .execute(&mut **transaction)
        .await
        .map_err(AppError::Database)?;
        sqlx::query(
            "INSERT INTO reputation_events \
             (user_id, delta, score_before, score_after, reason, contest_id, actor_id, note) \
             VALUES ($1, $2::float8::numeric(6, 1), $3::float8::numeric(6, 1), \
                     $4::float8::numeric(6, 1), 'appeal_restored', $5, $6, $7)",
        )
        .bind(user_id)
        .bind(restore)
        .bind(score_before)
        .bind(score_after)
        .bind(contest_id)
        .bind(admin_id)
        .bind(note)
        .execute(&mut **transaction)
        .await
        .map_err(AppError::Database)?;
        if status == "banned" && score_after >= 0.0 {
            sqlx::query(
                "DELETE FROM email_blacklist WHERE user_id = $1 AND reason = '信誉分低于 0，自动封禁'",
            )
            .bind(user_id)
            .execute(&mut **transaction)
            .await
            .map_err(AppError::Database)?;
        }
    }

    if disqualified {
        sqlx::query(
            "UPDATE contest_participants SET disqualified_at = NULL, disqualified_by = NULL, \
             disqualify_reason = NULL WHERE contest_id = $1 AND user_id = $2",
        )
        .bind(contest_id)
        .bind(user_id)
        .execute(&mut **transaction)
        .await
        .map_err(AppError::Database)?;
        sqlx::query(
            "UPDATE contest_event_reviews r SET review_status = 'cleared', reviewed_by = $3, \
             review_note = $4, reviewed_at = CURRENT_TIMESTAMP \
             FROM contest_events e \
             WHERE e.id = r.event_id AND e.contest_id = $1 AND e.user_id = $2 \
               AND r.review_status = 'confirmed'",
        )
        .bind(contest_id)
        .bind(user_id)
        .bind(admin_id)
        .bind(note)
        .execute(&mut **transaction)
        .await
        .map_err(AppError::Database)?;
    }

    Ok(disqualified)
}

pub async fn admin_resolve_appeal(
    pool: &PgPool,
    appeal_id: i64,
    admin_id: i32,
    input: &ContestAppealResolveInput,
) -> Result<ContestAppealResolveResponse, AppError> {
    let status = input.status.trim();
    if !matches!(status, "accepted" | "rejected") {
        return Err(AppError::BadRequest(
            "处理结果只能是 accepted 或 rejected".to_owned(),
        ));
    }
    let note = input
        .note
        .as_deref()
        .map(str::trim)
        .filter(|value| !value.is_empty());
    if let Some(note) = note
        && note.chars().count() > MAX_APPEAL_NOTE_CHARS
    {
        return Err(AppError::BadRequest(format!(
            "处理说明不能超过 {MAX_APPEAL_NOTE_CHARS} 个字符"
        )));
    }

    let mut transaction = pool.begin().await.map_err(AppError::Database)?;
    let appeal: Option<(i32, i32, String)> = sqlx::query_as(
        "SELECT contest_id, user_id, status FROM contest_appeals WHERE id = $1 FOR UPDATE",
    )
    .bind(appeal_id)
    .fetch_optional(&mut *transaction)
    .await
    .map_err(AppError::Database)?;
    let Some((contest_id, user_id, current_status)) = appeal else {
        return Err(AppError::NotFound("申诉不存在".to_owned()));
    };
    if current_status != "pending" {
        return Err(AppError::ConflictWith("该申诉已处理".to_owned()));
    }

    sqlx::query(
        "UPDATE contest_appeals SET status = $2, handled_by = $3, handle_note = $4, \
         handled_at = CURRENT_TIMESTAMP WHERE id = $1",
    )
    .bind(appeal_id)
    .bind(status)
    .bind(admin_id)
    .bind(note)
    .execute(&mut *transaction)
    .await
    .map_err(AppError::Database)?;

    let mut disqualified = false;
    let mut rating_reranked = false;
    if status == "accepted" {
        disqualified =
            restore_appeal_penalty(&mut transaction, contest_id, user_id, admin_id, note).await?;
        let contest_finished: bool =
            sqlx::query_scalar("SELECT status = 'finished' FROM contests WHERE id = $1")
                .bind(contest_id)
                .fetch_one(&mut *transaction)
                .await
                .map_err(AppError::Database)?;
        if disqualified && contest_finished {
            let is_event_contest: bool = sqlx::query_scalar(
                "SELECT official_event_id IS NOT NULL FROM contests WHERE id = $1",
            )
            .bind(contest_id)
            .fetch_one(&mut *transaction)
            .await
            .map_err(AppError::Database)?;
            rating_reranked =
                rerank_contest(&mut transaction, contest_id, is_event_contest).await?;
        }
    }

    let (title, body) = if status == "accepted" {
        (
            "申诉已通过",
            match note {
                Some(note) => format!("你的比赛申诉已通过，成绩与信誉已恢复。处理说明：{note}"),
                None => "你的比赛申诉已通过，成绩与信誉已恢复".to_owned(),
            },
        )
    } else {
        (
            "申诉未通过",
            match note {
                Some(note) => format!("你的比赛申诉未通过。处理说明：{note}"),
                None => "你的比赛申诉未通过".to_owned(),
            },
        )
    };
    notification_service::create(
        &mut transaction,
        user_id,
        "contest_notice",
        None,
        title,
        Some(&body),
        Some(&format!("/contests/{contest_id}/result")),
        Some("contest"),
        Some(i64::from(contest_id)),
    )
    .await?;

    transaction.commit().await.map_err(AppError::Database)?;
    Ok(ContestAppealResolveResponse {
        message: if status == "accepted" {
            "申诉已通过".to_owned()
        } else {
            "申诉已驳回".to_owned()
        },
        status: status.to_owned(),
        disqualified,
        rating_reranked,
    })
}

// ── 成绩导出 ───────────────────────────────────────────────────────

fn escape_csv(value: &str) -> String {
    if value.contains(['"', ',', '\n', '\r']) {
        format!("\"{}\"", value.replace('"', "\"\""))
    } else {
        value.to_owned()
    }
}

/// CSV for one official event's results. Returns the event title alongside the
/// content so the handler can build a descriptive filename.
pub async fn export_event_results(
    pool: &PgPool,
    event_id: i32,
) -> Result<(String, String), AppError> {
    let title: String = sqlx::query_scalar("SELECT title FROM official_events WHERE id = $1")
        .bind(event_id)
        .fetch_optional(pool)
        .await
        .map_err(AppError::Database)?
        .ok_or_else(|| AppError::NotFound("赛事不存在".to_owned()))?;
    let contest_id: i32 =
        sqlx::query_scalar("SELECT id FROM contests WHERE official_event_id = $1")
            .bind(event_id)
            .fetch_optional(pool)
            .await
            .map_err(AppError::Database)?
            .ok_or_else(|| AppError::NotFound("赛事尚未生成比赛".to_owned()))?;

    #[derive(FromRow)]
    struct ExportRow {
        rank: Option<i32>,
        username: String,
        total_score: Option<f64>,
        solved_count: i32,
        finished_at: Option<DateTime<Utc>>,
        disqualified: bool,
    }
    let rows: Vec<ExportRow> = sqlx::query_as(
        "SELECT p.rank, u.username, p.total_score, p.solved_count, p.finished_at, \
                (p.disqualified_at IS NOT NULL) AS disqualified \
         FROM contest_participants p JOIN users u ON u.id = p.user_id \
         WHERE p.contest_id = $1 AND p.status IN ('active', 'disconnected', 'timed_out', 'finished') \
         ORDER BY p.rank NULLS LAST, p.total_score DESC NULLS LAST, u.username ASC",
    )
    .bind(contest_id)
    .fetch_all(pool)
    .await
    .map_err(AppError::Database)?;

    let mut out = String::from("\u{feff}");
    out.push_str("排名,用户名,总分,通过题数,完成时间,是否取消资格\r\n");
    for row in rows {
        let columns = [
            row.rank.map(|rank| rank.to_string()).unwrap_or_default(),
            row.username,
            row.total_score
                .map(|score| format!("{score:.2}"))
                .unwrap_or_default(),
            row.solved_count.to_string(),
            row.finished_at
                .map(|value| value.format("%Y-%m-%d %H:%M:%S UTC").to_string())
                .unwrap_or_default(),
            if row.disqualified { "是" } else { "否" }.to_owned(),
        ];
        out.push_str(
            &columns
                .iter()
                .map(|value| escape_csv(value))
                .collect::<Vec<_>>()
                .join(","),
        );
        out.push_str("\r\n");
    }
    Ok((title, out))
}
