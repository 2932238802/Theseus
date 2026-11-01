use chrono::{DateTime, Utc};
use sqlx::{FromRow, PgPool};

use crate::{
    common::error::AppError,
    models::wrong_problem::{
        WrongProblemDismissResponse, WrongProblemItem, WrongProblemListQuery,
        WrongProblemListResponse,
    },
};

const DEFAULT_PAGE: u32 = 1;
const DEFAULT_SIZE: u32 = 20;
const MAX_PAGE_SIZE: u32 = 50;
/// 首页「待复习」与错题本使用同一套判定：有失败提交、尚无通过提交，且未被移除。
const HIDDEN_DISMISSALS: &str = "(SELECT COUNT(*) FROM wrong_problem_dismissals d \
     WHERE d.user_id = $1 \
       AND NOT EXISTS (SELECT 1 FROM submissions a \
                       WHERE a.user_id = $1 AND a.problem_id = d.problem_id \
                         AND a.status = 'accepted') \
       AND NOT EXISTS (SELECT 1 FROM submissions f \
                       WHERE f.user_id = $1 AND f.problem_id = d.problem_id \
                         AND f.status <> 'accepted' AND f.submitted_at > d.dismissed_at))";

/// 错题 = 已判定的失败提交（排除排队/评测中）且尚无通过提交。
/// 按题目聚合失败次数，并取最近一次失败提交的状态。
const WRONG_CTE: &str = "WITH failed AS ( \
        SELECT s.problem_id, COUNT(*)::bigint AS attempt_count, \
               MAX(s.submitted_at) AS last_failed_at \
        FROM submissions s \
        WHERE s.user_id = $1 \
          AND s.status NOT IN ('accepted', 'pending', 'judging') \
        GROUP BY s.problem_id \
    ), last_failed AS ( \
        SELECT DISTINCT ON (s.problem_id) s.problem_id, s.status, s.language, \
               s.test_cases_passed, s.total_test_cases \
        FROM submissions s \
        WHERE s.user_id = $1 \
          AND s.status NOT IN ('accepted', 'pending', 'judging') \
        ORDER BY s.problem_id, s.submitted_at DESC \
    ), wrong AS ( \
        SELECT f.problem_id, f.attempt_count, f.last_failed_at, l.status, l.language, \
               l.test_cases_passed, l.total_test_cases \
        FROM failed f JOIN last_failed l ON l.problem_id = f.problem_id \
        WHERE NOT EXISTS ( \
            SELECT 1 FROM submissions a \
            WHERE a.user_id = $1 AND a.problem_id = f.problem_id AND a.status = 'accepted' \
        ) AND NOT EXISTS ( \
            SELECT 1 FROM wrong_problem_dismissals d \
            WHERE d.user_id = $1 AND d.problem_id = f.problem_id \
              AND d.dismissed_at >= f.last_failed_at \
        ) \
    ) ";

fn clean(value: Option<&str>) -> Option<String> {
    value
        .map(str::trim)
        .filter(|value| !value.is_empty())
        .map(str::to_owned)
}

#[derive(Debug, FromRow)]
struct WrongProblemRow {
    problem_id: i32,
    title: String,
    difficulty: String,
    tags: Vec<String>,
    acceptance_rate: f64,
    attempt_count: i64,
    last_failed_at: DateTime<Utc>,
    status: String,
    language: String,
    test_cases_passed: i32,
    total_test_cases: i32,
}

pub async fn list(
    pool: &PgPool,
    user_id: i32,
    query: &WrongProblemListQuery,
) -> Result<WrongProblemListResponse, AppError> {
    let page = query.page.unwrap_or(DEFAULT_PAGE).max(1);
    let size = query.size.unwrap_or(DEFAULT_SIZE).clamp(1, MAX_PAGE_SIZE);
    let offset = i64::from(page - 1) * i64::from(size);
    let difficulty = clean(query.difficulty.as_deref());
    let tag = clean(query.tag.as_deref());
    let order = if query.sort.as_deref() == Some("attempts") {
        " ORDER BY w.attempt_count DESC, w.last_failed_at DESC, p.id DESC"
    } else {
        " ORDER BY w.last_failed_at DESC, p.id DESC"
    };
    // 过滤条件用可空参数表达，避免拼接动态 SQL
    let filter = " AND ($2::text IS NULL OR p.difficulty = $2) \
                  AND ($3::text IS NULL OR $3 = ANY(p.tags))";

    let total: i64 = sqlx::query_scalar(&format!(
        "{WRONG_CTE}SELECT COUNT(*)::bigint \
         FROM wrong w JOIN problems p ON p.id = w.problem_id \
         WHERE p.review_status = 'approved'{filter}"
    ))
    .bind(user_id)
    .bind(&difficulty)
    .bind(&tag)
    .fetch_one(pool)
    .await
    .map_err(AppError::Database)?;

    let rows: Vec<WrongProblemRow> = sqlx::query_as(&format!(
        "{WRONG_CTE}SELECT p.id AS problem_id, p.title, p.difficulty, p.tags, \
                p.acceptance_rate, w.attempt_count, w.last_failed_at, w.status, \
                w.language, w.test_cases_passed, w.total_test_cases \
         FROM wrong w JOIN problems p ON p.id = w.problem_id \
         WHERE p.review_status = 'approved'{filter}{order} LIMIT $4 OFFSET $5"
    ))
    .bind(user_id)
    .bind(&difficulty)
    .bind(&tag)
    .bind(i64::from(size))
    .bind(offset)
    .fetch_all(pool)
    .await
    .map_err(AppError::Database)?;

    Ok(WrongProblemListResponse {
        total,
        page,
        size,
        problems: rows
            .into_iter()
            .map(|row| WrongProblemItem {
                problem_id: row.problem_id,
                title: row.title,
                difficulty: row.difficulty,
                tags: row.tags,
                acceptance_rate: row.acceptance_rate,
                attempt_count: row.attempt_count,
                last_failed_at: row.last_failed_at,
                last_status: row.status,
                last_language: row.language,
                last_test_cases_passed: row.test_cases_passed,
                last_total_test_cases: row.total_test_cases,
            })
            .collect(),
    })
}

/// 把题目移出错题本。只有确实处于错题本中的题目才允许移除。
pub async fn dismiss(
    pool: &PgPool,
    user_id: i32,
    problem_id: i32,
) -> Result<WrongProblemDismissResponse, AppError> {
    let in_book: bool = sqlx::query_scalar(
        "SELECT EXISTS ( \
             SELECT 1 FROM submissions s JOIN problems p ON p.id = s.problem_id \
             WHERE s.user_id = $1 AND s.problem_id = $2 \
               AND s.status NOT IN ('accepted', 'pending', 'judging') \
               AND p.review_status = 'approved' \
         ) AND NOT EXISTS ( \
             SELECT 1 FROM submissions a \
             WHERE a.user_id = $1 AND a.problem_id = $2 AND a.status = 'accepted' \
         )",
    )
    .bind(user_id)
    .bind(problem_id)
    .fetch_one(pool)
    .await
    .map_err(AppError::Database)?;
    if !in_book {
        return Err(AppError::NotFound("该题目不在错题本中".to_owned()));
    }
    sqlx::query(
        "INSERT INTO wrong_problem_dismissals (user_id, problem_id) VALUES ($1, $2) \
         ON CONFLICT (user_id, problem_id) DO UPDATE SET dismissed_at = CURRENT_TIMESTAMP",
    )
    .bind(user_id)
    .bind(problem_id)
    .execute(pool)
    .await
    .map_err(AppError::Database)?;
    Ok(WrongProblemDismissResponse { dismissed: true })
}

/// 撤销移出，题目重新出现在错题本里。未移除过时按成功处理，便于前端重试。
pub async fn restore(
    pool: &PgPool,
    user_id: i32,
    problem_id: i32,
) -> Result<WrongProblemDismissResponse, AppError> {
    sqlx::query("DELETE FROM wrong_problem_dismissals WHERE user_id = $1 AND problem_id = $2")
        .bind(user_id)
        .bind(problem_id)
        .execute(pool)
        .await
        .map_err(AppError::Database)?;
    Ok(WrongProblemDismissResponse { dismissed: false })
}

/// 首页「待复习」使用：已移出且期间没有新的失败提交的题目数。
pub async fn hidden_count(pool: &PgPool, user_id: i32) -> Result<i64, AppError> {
    sqlx::query_scalar(&format!("SELECT {HIDDEN_DISMISSALS}::bigint"))
        .bind(user_id)
        .fetch_one(pool)
        .await
        .map_err(AppError::Database)
}
