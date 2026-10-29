use chrono::{DateTime, NaiveDate, Utc};
use sqlx::{FromRow, PgPool};

use crate::{
    common::error::AppError,
    models::home::{
        CheckinResponse, HomeActivity, HomeCheckin, HomeContinue, HomeOverviewResponse, HomeStats,
    },
    services::{badge_service, profile_service},
};

#[derive(Debug, FromRow)]
struct ContinueRow {
    problem_id: i32,
    problem_title: String,
    difficulty: String,
    language: String,
    status: String,
    submitted_at: DateTime<Utc>,
}

#[derive(Debug, FromRow)]
struct ActivityRow {
    submission_id: i32,
    problem_id: i32,
    problem_title: String,
    language: String,
    status: String,
    submitted_at: DateTime<Utc>,
}

pub async fn overview(pool: &PgPool, user_id: i32) -> Result<HomeOverviewResponse, AppError> {
    let unfinished: Option<ContinueRow> = sqlx::query_as(
        "SELECT s.problem_id, p.title AS problem_title, p.difficulty, s.language, s.status, \
                s.submitted_at \
         FROM submissions s JOIN problems p ON p.id = s.problem_id \
         WHERE s.user_id = $1 AND s.status <> 'accepted' \
           AND NOT EXISTS ( \
               SELECT 1 FROM submissions a \
               WHERE a.user_id = $1 AND a.problem_id = s.problem_id AND a.status = 'accepted' \
           ) \
         ORDER BY s.submitted_at DESC LIMIT 1",
    )
    .bind(user_id)
    .fetch_optional(pool)
    .await
    .map_err(AppError::Database)?;

    let latest: Option<ContinueRow> = if unfinished.is_some() {
        None
    } else {
        sqlx::query_as(
            "SELECT s.problem_id, p.title AS problem_title, p.difficulty, s.language, s.status, \
                    s.submitted_at \
             FROM submissions s JOIN problems p ON p.id = s.problem_id \
             WHERE s.user_id = $1 \
             ORDER BY s.submitted_at DESC LIMIT 1",
        )
        .bind(user_id)
        .fetch_optional(pool)
        .await
        .map_err(AppError::Database)?
    };

    let continue_learning = unfinished
        .map(|row| (row, "resume"))
        .or_else(|| latest.map(|row| (row, "review")))
        .map(|(row, action)| HomeContinue {
            problem_id: row.problem_id,
            problem_title: row.problem_title,
            difficulty: row.difficulty,
            language: row.language,
            status: row.status,
            last_activity_at: row.submitted_at,
            action: action.to_owned(),
        });

    let (accepted_problems, attempted_problems): (i64, i64) = sqlx::query_as(
        "SELECT COUNT(DISTINCT problem_id) FILTER (WHERE status = 'accepted')::bigint, \
                COUNT(DISTINCT problem_id)::bigint \
         FROM submissions WHERE user_id = $1",
    )
    .bind(user_id)
    .fetch_one(pool)
    .await
    .map_err(AppError::Database)?;

    let days_with_accepted: Vec<NaiveDate> = sqlx::query_scalar(
        "SELECT DISTINCT (submitted_at AT TIME ZONE 'UTC')::date \
         FROM submissions \
         WHERE user_id = $1 AND status = 'accepted' \
         ORDER BY 1 DESC",
    )
    .bind(user_id)
    .fetch_all(pool)
    .await
    .map_err(AppError::Database)?;
    let streak_days = profile_service::compute_streak(&days_with_accepted);

    let week_submissions: i64 = sqlx::query_scalar(
        "SELECT COUNT(*)::bigint FROM submissions \
         WHERE user_id = $1 AND submitted_at >= CURRENT_TIMESTAMP - INTERVAL '7 days'",
    )
    .bind(user_id)
    .fetch_one(pool)
    .await
    .map_err(AppError::Database)?;

    let recent_activity: Vec<HomeActivity> = sqlx::query_as::<_, ActivityRow>(
        "SELECT s.id AS submission_id, s.problem_id, p.title AS problem_title, s.language, \
                s.status, s.submitted_at \
         FROM submissions s JOIN problems p ON p.id = s.problem_id \
         WHERE s.user_id = $1 \
         ORDER BY s.submitted_at DESC LIMIT 5",
    )
    .bind(user_id)
    .fetch_all(pool)
    .await
    .map_err(AppError::Database)?
    .into_iter()
    .map(|row| HomeActivity {
        submission_id: row.submission_id,
        problem_id: row.problem_id,
        problem_title: row.problem_title,
        language: row.language,
        status: row.status,
        submitted_at: row.submitted_at,
    })
    .collect();

    let (reputation_score, checked_in_today): (f64, bool) = sqlx::query_as(
        "SELECT u.reputation_score::float8, \
                EXISTS (SELECT 1 FROM reputation_checkins rc \
                        WHERE rc.user_id = u.id \
                          AND rc.checkin_date = (CURRENT_TIMESTAMP AT TIME ZONE 'UTC')::date) \
         FROM users u WHERE u.id = $1",
    )
    .bind(user_id)
    .fetch_one(pool)
    .await
    .map_err(AppError::Database)?;

    Ok(HomeOverviewResponse {
        continue_learning,
        stats: HomeStats {
            streak_days,
            accepted_problems,
            review_problems: (attempted_problems - accepted_problems).max(0),
            week_submissions,
        },
        recent_activity,
        checkin: HomeCheckin {
            checked_in_today,
            reputation_score,
        },
    })
}

/// Daily check-in restores 0.1 reputation, capped at 100.
/// Only the first check-in of the UTC day counts.
pub async fn check_in(pool: &PgPool, user_id: i32) -> Result<CheckinResponse, AppError> {
    let mut transaction = pool.begin().await.map_err(AppError::Database)?;
    let inserted: Option<i32> = sqlx::query_scalar(
        "INSERT INTO reputation_checkins (user_id, checkin_date) \
         VALUES ($1, (CURRENT_TIMESTAMP AT TIME ZONE 'UTC')::date) \
         ON CONFLICT (user_id, checkin_date) DO NOTHING RETURNING user_id",
    )
    .bind(user_id)
    .fetch_optional(&mut *transaction)
    .await
    .map_err(AppError::Database)?;

    let checkin_days: Vec<NaiveDate> = sqlx::query_scalar(
        "SELECT checkin_date FROM reputation_checkins WHERE user_id = $1 \
         ORDER BY checkin_date DESC",
    )
    .bind(user_id)
    .fetch_all(&mut *transaction)
    .await
    .map_err(AppError::Database)?;
    let checkin_streak = profile_service::compute_streak(&checkin_days);

    if inserted.is_none() {
        let reputation_score: f64 =
            sqlx::query_scalar("SELECT reputation_score::float8 FROM users WHERE id = $1")
                .bind(user_id)
                .fetch_one(&mut *transaction)
                .await
                .map_err(AppError::Database)?;
        transaction.commit().await.map_err(AppError::Database)?;
        return Ok(CheckinResponse {
            checked_in: false,
            reputation_score,
            checkin_streak,
            message: "今天已经签到".to_owned(),
        });
    }

    let (score_before, status): (f64, String) = sqlx::query_as(
        "SELECT reputation_score::float8, status FROM users WHERE id = $1 FOR UPDATE",
    )
    .bind(user_id)
    .fetch_one(&mut *transaction)
    .await
    .map_err(AppError::Database)?;
    if status != "active" {
        return Err(AppError::ForbiddenWith("当前账号状态无法签到".to_owned()));
    }

    let score_after = round1((score_before + 0.1).min(100.0));
    let delta = round1(score_after - score_before);
    if delta > 0.0 {
        sqlx::query(
            "UPDATE users SET reputation_score = $2::float8::numeric(6, 1), \
             updated_at = CURRENT_TIMESTAMP WHERE id = $1",
        )
        .bind(user_id)
        .bind(score_after)
        .execute(&mut *transaction)
        .await
        .map_err(AppError::Database)?;
        sqlx::query(
            "INSERT INTO reputation_events \
             (user_id, delta, score_before, score_after, reason) \
             VALUES ($1, $2::float8::numeric(6, 1), $3::float8::numeric(6, 1), \
                     $4::float8::numeric(6, 1), 'daily_checkin')",
        )
        .bind(user_id)
        .bind(delta)
        .bind(score_before)
        .bind(score_after)
        .execute(&mut *transaction)
        .await
        .map_err(AppError::Database)?;
    }
    let new_badges =
        badge_service::sync_checkin_badges(&mut transaction, user_id, checkin_streak).await?;
    transaction.commit().await.map_err(AppError::Database)?;

    let message = if new_badges.is_empty() {
        format!("签到成功，已连续签到 {checkin_streak} 天")
    } else {
        format!(
            "签到成功，已连续签到 {checkin_streak} 天，获得徽章「{}」",
            new_badges.join("」「")
        )
    };
    Ok(CheckinResponse {
        checked_in: true,
        reputation_score: score_after,
        checkin_streak,
        message,
    })
}

fn round1(value: f64) -> f64 {
    (value * 10.0).round() / 10.0
}
