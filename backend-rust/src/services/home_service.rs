use chrono::{DateTime, NaiveDate, Utc};
use sqlx::{FromRow, PgPool};

use crate::{
    common::error::AppError,
    models::home::{HomeActivity, HomeContinue, HomeOverviewResponse, HomeStats},
    services::profile_service,
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

    Ok(HomeOverviewResponse {
        continue_learning,
        stats: HomeStats {
            streak_days,
            accepted_problems,
            review_problems: (attempted_problems - accepted_problems).max(0),
            week_submissions,
        },
        recent_activity,
    })
}
