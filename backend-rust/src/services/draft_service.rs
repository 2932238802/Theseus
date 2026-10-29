use chrono::{DateTime, Utc};
use sqlx::{FromRow, PgPool};

use crate::{
    common::error::AppError,
    models::draft::{DraftResponse, DraftView, SaveDraftRequest},
};

const MAX_CODE_BYTES: usize = 256 * 1024;

#[derive(Debug, FromRow)]
struct DraftRow {
    language: String,
    code: String,
    updated_at: DateTime<Utc>,
}

fn validate_language(language: &str) -> Result<(), AppError> {
    match language {
        "cpp" | "java" | "python" | "javascript" => Ok(()),
        _ => Err(AppError::BadRequest("不支持的编程语言".to_owned())),
    }
}

async fn ensure_visible_problem(pool: &PgPool, problem_id: i32) -> Result<(), AppError> {
    if problem_id <= 0 {
        return Err(AppError::BadRequest("题目 ID 无效".to_owned()));
    }
    let exists: Option<bool> = sqlx::query_scalar(
        "SELECT TRUE FROM problems WHERE id = $1 AND review_status = 'approved'",
    )
    .bind(problem_id)
    .fetch_optional(pool)
    .await
    .map_err(AppError::Database)?;
    if exists.is_none() {
        return Err(AppError::NotFound("题目不存在".to_owned()));
    }
    Ok(())
}

pub async fn get_draft(
    pool: &PgPool,
    user_id: i32,
    problem_id: i32,
    language: &str,
) -> Result<DraftResponse, AppError> {
    validate_language(language)?;
    ensure_visible_problem(pool, problem_id).await?;
    let row: Option<DraftRow> = sqlx::query_as(
        "SELECT language, code, updated_at FROM problem_drafts \
         WHERE user_id = $1 AND problem_id = $2 AND language = $3",
    )
    .bind(user_id)
    .bind(problem_id)
    .bind(language)
    .fetch_optional(pool)
    .await
    .map_err(AppError::Database)?;
    Ok(DraftResponse {
        draft: row.map(|row| DraftView {
            language: row.language,
            code: row.code,
            updated_at: row.updated_at,
        }),
    })
}

pub async fn save_draft(
    pool: &PgPool,
    user_id: i32,
    problem_id: i32,
    request: SaveDraftRequest,
) -> Result<DraftResponse, AppError> {
    validate_language(&request.language)?;
    ensure_visible_problem(pool, problem_id).await?;
    if request.code.trim().is_empty() {
        sqlx::query(
            "DELETE FROM problem_drafts WHERE user_id = $1 AND problem_id = $2 AND language = $3",
        )
        .bind(user_id)
        .bind(problem_id)
        .bind(&request.language)
        .execute(pool)
        .await
        .map_err(AppError::Database)?;
        return Ok(DraftResponse { draft: None });
    }
    if request.code.len() > MAX_CODE_BYTES {
        return Err(AppError::BadRequest("草稿内容过长".to_owned()));
    }
    let row: DraftRow = sqlx::query_as(
        "INSERT INTO problem_drafts (user_id, problem_id, language, code) \
         VALUES ($1, $2, $3, $4) \
         ON CONFLICT (user_id, problem_id, language) DO UPDATE \
             SET code = EXCLUDED.code, updated_at = CURRENT_TIMESTAMP \
         RETURNING language, code, updated_at",
    )
    .bind(user_id)
    .bind(problem_id)
    .bind(&request.language)
    .bind(&request.code)
    .fetch_one(pool)
    .await
    .map_err(AppError::Database)?;
    Ok(DraftResponse {
        draft: Some(DraftView {
            language: row.language,
            code: row.code,
            updated_at: row.updated_at,
        }),
    })
}
