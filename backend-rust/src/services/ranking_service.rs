use sqlx::PgPool;

use crate::{
    common::error::AppError,
    models::ranking::{RankingEntry, RankingQuery, RankingResponse},
};

const DEFAULT_PAGE: u32 = 1;
const DEFAULT_SIZE: u32 = 20;
const MAX_PAGE_SIZE: u32 = 100;

const RANKING_CTE: &str = r#"
WITH solved AS (
    SELECT ups.user_id, COUNT(*) AS solved
    FROM user_problem_status ups
    JOIN problems p ON p.id = ups.problem_id AND p.review_status = 'approved'
    WHERE ups.status = 'accepted'
    GROUP BY ups.user_id
),
subs AS (
    SELECT s.user_id,
           COUNT(*) AS submissions,
           COUNT(*) FILTER (WHERE s.status = 'accepted') AS accepted_submissions,
           MAX(COALESCE(s.finished_at, s.submitted_at)) FILTER (WHERE s.status = 'accepted') AS last_accepted_at
    FROM submissions s
    JOIN problems p ON p.id = s.problem_id AND p.review_status = 'approved'
    WHERE s.status IN (
        'accepted', 'wrong_answer', 'time_limit_exceeded',
        'memory_limit_exceeded', 'runtime_error', 'compile_error'
    )
    GROUP BY s.user_id
),
stats AS (
    SELECT u.id AS user_id,
           u.username,
           solved.solved,
           COALESCE(subs.submissions, 0) AS submissions,
           CASE
               WHEN COALESCE(subs.submissions, 0) = 0 THEN 0
               ELSE (subs.accepted_submissions::double precision / subs.submissions::double precision) * 100
           END AS acceptance_rate,
           subs.last_accepted_at
    FROM solved
    JOIN users u ON u.id = solved.user_id AND u.role = 'student'
    LEFT JOIN subs ON subs.user_id = solved.user_id
    WHERE solved.solved > 0
),
ranked AS (
    SELECT ROW_NUMBER() OVER (
               ORDER BY solved DESC,
                        acceptance_rate DESC,
                        last_accepted_at ASC NULLS LAST,
                        user_id ASC
           ) AS rank,
           user_id,
           username,
           solved,
           submissions,
           ROUND(acceptance_rate::numeric, 1)::double precision AS acceptance_rate
    FROM stats
)
"#;

pub async fn list(
    pool: &PgPool,
    query: &RankingQuery,
    me_id: Option<i32>,
) -> Result<RankingResponse, AppError> {
    let size = query.size.unwrap_or(DEFAULT_SIZE).clamp(1, MAX_PAGE_SIZE);
    let requested_page = query.page.unwrap_or(DEFAULT_PAGE).max(1);
    let count_sql = format!("{RANKING_CTE} SELECT COUNT(*) FROM ranked");
    let total = sqlx::query_scalar::<_, i64>(&count_sql)
        .fetch_one(pool)
        .await
        .map_err(AppError::Database)?;
    let page = requested_page.min(page_count(total, size));
    let offset = i64::from(page - 1) * i64::from(size);
    let page_sql = format!(
        "{RANKING_CTE} SELECT rank, user_id, username, solved, submissions, acceptance_rate FROM ranked ORDER BY rank LIMIT $1 OFFSET $2"
    );
    let entries = sqlx::query_as::<_, RankingEntry>(&page_sql)
        .bind(i64::from(size))
        .bind(offset)
        .fetch_all(pool)
        .await
        .map_err(AppError::Database)?;
    let me = match me_id {
        Some(user_id) => {
            let me_sql = format!(
                "{RANKING_CTE} SELECT rank, user_id, username, solved, submissions, acceptance_rate FROM ranked WHERE user_id = $1"
            );
            sqlx::query_as::<_, RankingEntry>(&me_sql)
                .bind(user_id)
                .fetch_optional(pool)
                .await
                .map_err(AppError::Database)?
        }
        None => None,
    };
    Ok(RankingResponse {
        total,
        page,
        size,
        entries,
        me,
    })
}

fn page_count(total: i64, size: u32) -> u32 {
    if total <= 0 {
        return 1;
    }
    let total = total as u64;
    let size = u64::from(size.max(1));
    total.div_ceil(size) as u32
}

#[cfg(test)]
mod tests {
    use super::page_count;

    #[test]
    fn clamps_page_count_for_empty_and_partial_pages() {
        assert_eq!(page_count(0, 20), 1);
        assert_eq!(page_count(1, 20), 1);
        assert_eq!(page_count(20, 20), 1);
        assert_eq!(page_count(21, 20), 2);
        assert_eq!(page_count(100, 0), 100);
    }
}
