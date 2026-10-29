use std::cmp::Ordering;
use std::collections::HashMap;

use chrono::{DateTime, Utc};
use serde_json::{Value, json};
use sqlx::{FromRow, PgPool};

use crate::{
    common::error::AppError,
    models::contest::{
        CAMERA_PERMISSIONS, CONTEST_EVENT_TYPES, CONTEST_STATUS_CANCELLED, CONTEST_STATUS_FINISHED,
        CONTEST_STATUS_RUNNING, CONTEST_STATUS_SETTLING, CancelMatchResponse,
        ContestDetailResponse, ContestEventCard, ContestEventDetailResponse, ContestEventInput,
        ContestEventsRequest, ContestEventsResponse, ContestParticipantRow, ContestParticipantView,
        ContestProblemDetail, ContestProblemDetailRow, ContestProblemSummary, ContestRankingItem,
        ContestResultContest, ContestResultMine, ContestResultResponse, ContestRow,
        ContestScoreDetail, ContestSummary, CurrentContestResponse, DEFAULT_CONTEST_RATING,
        EVENT_ACTION_CLOSED, EVENT_ACTION_DETAILS, EVENT_ACTION_ENTER, EVENT_ACTION_FULL,
        EVENT_ACTION_JOIN, EVENT_ACTION_REGISTER, EVENT_STATUS_FINISHED, EVENT_STATUS_FULL,
        EVENT_STATUS_REGISTRATION, EVENT_STATUS_RUNNING, EVENT_STATUS_UPCOMING, EventRuleGroup,
        FeaturedContestsResponse, FinishContestResponse, MatchRequest, MatchResponse,
        PARTICIPANT_STATUS_ACTIVE, PARTICIPANT_STATUS_FINISHED, RATING_GAIN_FIRST,
        RATING_GAIN_SECOND, RATING_LOSS_FOURTH, RATING_WINDOW, RankedConfig,
    },
    services::notification_service,
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

#[derive(Debug, FromRow)]
struct SummaryRow {
    id: i32,
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

    if let Some(contest_id) = active_contest_id(pool, user_id).await? {
        let summary = fetch_summary(pool, contest_id, user_id).await?;
        return Ok(MatchResponse {
            state: "matched".to_owned(),
            queue_position: None,
            contest: Some(summary),
            message: "你已在一场比赛中".to_owned(),
        });
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
        "INSERT INTO contest_queue (user_id, camera_permission) VALUES ($1, $2) \
         ON CONFLICT (user_id) DO UPDATE SET camera_permission = EXCLUDED.camera_permission",
    )
    .bind(user_id)
    .bind(camera.as_deref())
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
        "SELECT COUNT(*) FROM contest_participants WHERE contest_id = $1 AND status = 'active'",
    )
    .bind(contest_id)
    .fetch_one(pool)
    .await
    .map_err(AppError::Database)?;

    if remaining == 0 {
        settle_contest(pool, contest_id).await?;
        Ok(FinishContestResponse {
            finished: true,
            message: "全部参赛者已离场，比赛进入结算".to_owned(),
        })
    } else {
        Ok(FinishContestResponse {
            finished: true,
            message: "已标记完成并离场，其他参赛者继续作答".to_owned(),
        })
    }
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
        rating_before: Option<i32>,
        rating_after: Option<i32>,
        rating_delta: Option<i32>,
    }

    let rows = sqlx::query_as::<_, ResultRow>(
        "SELECT p.user_id, u.username, p.total_score, p.solved_count, p.speed_score, \
         p.coding_score, p.finished_at, p.rank, p.detail, p.rating_before, p.rating_after, \
         p.rating_delta \
         FROM contest_participants p JOIN users u ON u.id = p.user_id \
         WHERE p.contest_id = $1 \
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
        let inserted = sqlx::query(
            "INSERT INTO contest_events \
             (contest_id, user_id, event_id, event_type, payload, client_time, session_id) \
             VALUES ($1, $2, $3, $4, $5, $6, $7) ON CONFLICT DO NOTHING",
        )
        .bind(contest_id)
        .bind(user_id)
        .bind(event.event_id.trim())
        .bind(event.event_type.trim())
        .bind(payload)
        .bind(event.client_time)
        .bind(event.session_id.as_deref().map(str::trim))
        .execute(&mut *transaction)
        .await
        .map_err(AppError::Database)?
        .rows_affected();
        accepted += inserted;
    }
    transaction.commit().await.map_err(AppError::Database)?;

    Ok(ContestEventsResponse {
        accepted,
        duplicates: request.events.len() as u64 - accepted,
        message: "事件已记录".to_owned(),
    })
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
        run_config: Value,
        judge_cases: Option<Value>,
    }

    let row = sqlx::query_as::<_, ContestProblemContext>(
        "SELECT c.status, c.ends_at, p.status AS participant_status, cp.run_config, cp.judge_cases \
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
        return Err(AppError::ConflictWith("你已离场，无法继续提交".to_owned()));
    }
    if row.ends_at <= Utc::now() {
        return Err(AppError::ConflictWith("比赛已结束".to_owned()));
    }
    Ok(ContestSubmissionContext {
        run_config: row.run_config,
        judge_cases: row.judge_cases,
    })
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
        "SELECT id, status, duration_seconds, problem_count, starts_at, ends_at, finished_at, \
         solve_weight, speed_weight, coding_weight \
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
         WHERE p.contest_id = $1",
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
        let expected_delta = rating_delta_for_rank(rank);
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

        sqlx::query(
            "UPDATE users SET contest_rating = $2, updated_at = CURRENT_TIMESTAMP WHERE id = $1",
        )
        .bind(participant.user_id)
        .bind(rating_after)
        .execute(&mut *transaction)
        .await
        .map_err(AppError::Database)?;

        let title = format!("排位赛结束：第 {rank} 名");
        let body = format!(
            "总分 {:.2} · 通过 {}/{} · 速度 {:.1} · 书写 {:.1} · 段位分 {} → {} ({:+})",
            participant.total_score,
            participant.solved_count,
            contest.problem_count,
            participant.speed_score,
            participant.coding_score,
            participant.rating_before,
            rating_after,
            rating_delta,
        );
        let link = format!("/contests/{contest_id}/result");
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
           AND p.status IN ('active', 'finished') \
         ORDER BY c.starts_at DESC LIMIT 1",
    )
    .bind(user_id)
    .fetch_optional(pool)
    .await
    .map_err(AppError::Database)
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
        "SELECT id, status, duration_seconds, problem_count, starts_at, ends_at, finished_at, \
         solve_weight, speed_weight, coding_weight FROM contests WHERE id = $1",
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
        "SELECT c.id, c.status, c.duration_seconds, c.problem_count, c.starts_at, c.ends_at, \
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
        "SELECT q.user_id, q.camera_permission, u.contest_rating AS rating, q.joined_at \
         FROM contest_queue q \
         JOIN users u ON u.id = q.user_id AND u.status = 'active' \
         ORDER BY q.joined_at, q.user_id LIMIT 400 FOR UPDATE OF q",
    )
    .fetch_all(&mut *transaction)
    .await
    .map_err(AppError::Database)?;
    let Some(group) = select_fair_group(&queued) else {
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

    let contest_id: i32 = sqlx::query_scalar(
        "INSERT INTO contests \
         (status, duration_seconds, problem_count, solve_weight, speed_weight, coding_weight, \
          starts_at, ends_at) \
         VALUES ('running', $1, $2, $3, $4, $5, CURRENT_TIMESTAMP, \
                 CURRENT_TIMESTAMP + make_interval(secs => $6::double precision)) \
         RETURNING id",
    )
    .bind(DURATION_SECONDS)
    .bind(PROBLEMS_PER_CONTEST as i32)
    .bind(SOLVE_WEIGHT)
    .bind(SPEED_WEIGHT)
    .bind(CODING_WEIGHT)
    .bind(f64::from(DURATION_SECONDS))
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
             (contest_id, user_id, status, camera_permission, rating_before) \
             VALUES ($1, $2, 'active', $3, $4)",
        )
        .bind(contest_id)
        .bind(row.user_id)
        .bind(row.camera_permission.as_deref())
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

/// Picks four queued players whose highest and lowest ratings differ by at
/// most `RATING_WINDOW`. Among all valid groups it prefers the one that has
/// been waiting the longest, so no player is skipped indefinitely.
fn select_fair_group(rows: &[QueueRow]) -> Option<Vec<QueueRow>> {
    let group_size = PROBLEMS_PER_CONTEST as usize;
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
        if window[group_size - 1].rating - window[0].rating > RATING_WINDOW {
            continue;
        }
        let ready_at = window
            .iter()
            .map(|row| row.joined_at)
            .max()
            .unwrap_or_else(Utc::now);
        if best
            .as_ref()
            .map_or(true, |(current, _)| ready_at < *current)
        {
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

fn round2(value: f64) -> f64 {
    (value * 100.0).round() / 100.0
}

fn rating_delta_for_rank(rank: i32) -> i32 {
    match rank {
        1 => RATING_GAIN_FIRST,
        2 => RATING_GAIN_SECOND,
        3 => 0,
        _ => -RATING_LOSS_FOURTH,
    }
}

// ── 限时赛事（official_events） ─────────────────────────────────────

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
    capacity: Option<i32>,
    registration_mode: String,
    rules: Value,
    registered_count: i64,
    is_registered: bool,
    in_class: bool,
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
}

/// Homepage list: ranked configuration plus every published event that has not
/// ended. Only `published` events are visible; draft and cancelled events stay
/// hidden until an administrator publishes them.
pub async fn featured(pool: &PgPool, user_id: i32) -> Result<FeaturedContestsResponse, AppError> {
    let my_rating = user_rating(pool, user_id).await?;
    let rows = fetch_event_rows(pool, user_id, None, true).await?;
    let now = Utc::now();
    let events = rows
        .into_iter()
        .map(|row| build_event_card(row, now))
        .collect();
    Ok(FeaturedContestsResponse {
        ranked: ranked_config(my_rating),
        events,
        server_time: now,
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
    let mut transaction = pool.begin().await.map_err(AppError::Database)?;
    let event = sqlx::query_as::<_, LockedEventRow>(
        "SELECT status, registration_mode, registration_opens_at, registration_closes_at, \
                starts_at, ends_at, capacity, class_id \
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
            return Err(AppError::ForbiddenWith("仅限指定班级的学生参加".to_owned()));
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
    let row = fetch_event_rows(pool, user_id, Some(event_id), true)
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
        e.starts_at, e.ends_at, e.scope, e.capacity, e.registration_mode, \
        COALESCE(e.rules, '[]'::jsonb) AS rules, \
        (SELECT COUNT(*) FROM official_event_registrations r \
          WHERE r.event_id = e.id AND r.status IN ('registered', 'joined')) AS registered_count, \
        EXISTS (SELECT 1 FROM official_event_registrations r \
          WHERE r.event_id = e.id AND r.user_id = $1 \
            AND r.status IN ('registered', 'joined')) AS is_registered, \
        CASE WHEN e.class_id IS NULL THEN TRUE ELSE ( \
            EXISTS (SELECT 1 FROM class_members m \
              WHERE m.class_id = e.class_id AND m.user_id = $1 AND m.status = 'active') \
            OR EXISTS (SELECT 1 FROM classes c \
              WHERE c.id = e.class_id AND c.owner_id = $1)) END AS in_class \
     FROM official_events e \
     WHERE e.status = 'published' AND ($2::int IS NULL OR e.id = $2::int)";

fn build_event_card(row: EventRow, now: DateTime<Utc>) -> ContestEventCard {
    let ended = now >= row.ends_at;
    let started = now >= row.starts_at && !ended;
    let full = row
        .capacity
        .is_some_and(|capacity| row.registered_count >= i64::from(capacity));
    let registration_open = registration_open(&row, now);
    let eligible = row.in_class;

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

    let mut ineligible_reason = if eligible {
        None
    } else {
        Some("仅限指定班级的学生参加".to_owned())
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
        capacity: row.capacity,
        registered_count: row.registered_count,
        is_registered: row.is_registered,
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

fn ranked_config(my_rating: i32) -> RankedConfig {
    RankedConfig {
        mode: "ranked".to_owned(),
        title: "4 人排位赛".to_owned(),
        participants: 4,
        duration_minutes: DURATION_SECONDS / 60,
        problem_count: PROBLEMS_PER_CONTEST as i32,
        rating_window: RATING_WINDOW,
        my_rating,
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
