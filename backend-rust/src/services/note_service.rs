use chrono::{DateTime, Utc};
use sqlx::{FromRow, PgPool};

use crate::{
    common::error::AppError,
    models::note::{
        NoteListItem, NoteListQuery, NoteListResponse, NoteResponse, NoteView, SaveNoteRequest,
    },
};

const DEFAULT_PAGE: u32 = 1;
const DEFAULT_SIZE: u32 = 20;
const MAX_PAGE_SIZE: u32 = 50;
const MAX_NOTE_BYTES: usize = 32 * 1024;

fn page_and_size(query: &NoteListQuery) -> (u32, u32) {
    let page = query.page.unwrap_or(DEFAULT_PAGE).max(1);
    let size = query.size.unwrap_or(DEFAULT_SIZE).clamp(1, MAX_PAGE_SIZE);
    (page, size)
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

pub async fn get_note(
    pool: &PgPool,
    user_id: i32,
    problem_id: i32,
) -> Result<NoteResponse, AppError> {
    ensure_visible_problem(pool, problem_id).await?;
    let row: Option<NoteView> = sqlx::query_as(
        "SELECT body_md, updated_at FROM problem_notes \
         WHERE user_id = $1 AND problem_id = $2",
    )
    .bind(user_id)
    .bind(problem_id)
    .fetch_optional(pool)
    .await
    .map_err(AppError::Database)?;
    Ok(NoteResponse { note: row })
}

pub async fn save_note(
    pool: &PgPool,
    user_id: i32,
    problem_id: i32,
    request: SaveNoteRequest,
) -> Result<NoteResponse, AppError> {
    ensure_visible_problem(pool, problem_id).await?;
    if request.body_md.trim().is_empty() {
        sqlx::query("DELETE FROM problem_notes WHERE user_id = $1 AND problem_id = $2")
            .bind(user_id)
            .bind(problem_id)
            .execute(pool)
            .await
            .map_err(AppError::Database)?;
        return Ok(NoteResponse { note: None });
    }
    if request.body_md.len() > MAX_NOTE_BYTES {
        return Err(AppError::BadRequest("笔记内容过长".to_owned()));
    }
    let row: NoteView = sqlx::query_as(
        "INSERT INTO problem_notes (user_id, problem_id, body_md) \
         VALUES ($1, $2, $3) \
         ON CONFLICT (user_id, problem_id) DO UPDATE \
             SET body_md = EXCLUDED.body_md, updated_at = CURRENT_TIMESTAMP \
         RETURNING body_md, updated_at",
    )
    .bind(user_id)
    .bind(problem_id)
    .bind(&request.body_md)
    .fetch_one(pool)
    .await
    .map_err(AppError::Database)?;
    Ok(NoteResponse { note: Some(row) })
}

pub async fn list_notes(
    pool: &PgPool,
    user_id: i32,
    query: &NoteListQuery,
) -> Result<NoteListResponse, AppError> {
    let (page, size) = page_and_size(query);
    let offset = i64::from(page - 1) * i64::from(size);

    let total: i64 = sqlx::query_scalar(
        "SELECT COUNT(*)::bigint FROM problem_notes n \
         JOIN problems p ON p.id = n.problem_id \
         WHERE n.user_id = $1 AND p.review_status = 'approved'",
    )
    .bind(user_id)
    .fetch_one(pool)
    .await
    .map_err(AppError::Database)?;

    #[derive(FromRow)]
    struct NoteRow {
        problem_id: i32,
        title: String,
        difficulty: String,
        excerpt: String,
        updated_at: DateTime<Utc>,
    }

    let rows: Vec<NoteRow> = sqlx::query_as(
        "SELECT n.problem_id, p.title, p.difficulty, LEFT(n.body_md, 160) AS excerpt, n.updated_at \
         FROM problem_notes n \
         JOIN problems p ON p.id = n.problem_id \
         WHERE n.user_id = $1 AND p.review_status = 'approved' \
         ORDER BY n.updated_at DESC, n.problem_id DESC \
         LIMIT $2 OFFSET $3",
    )
    .bind(user_id)
    .bind(i64::from(size))
    .bind(offset)
    .fetch_all(pool)
    .await
    .map_err(AppError::Database)?;

    Ok(NoteListResponse {
        total,
        page,
        size,
        notes: rows
            .into_iter()
            .map(|row| NoteListItem {
                problem_id: row.problem_id,
                title: row.title,
                difficulty: row.difficulty,
                excerpt: row.excerpt,
                updated_at: row.updated_at,
            })
            .collect(),
    })
}
