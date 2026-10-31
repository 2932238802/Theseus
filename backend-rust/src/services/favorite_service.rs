use chrono::{DateTime, Utc};
use sqlx::{FromRow, PgPool};

use crate::{
    common::error::AppError,
    config::Config,
    models::favorite::{
        CommentFavoriteItem, CommentFavoriteListResponse, FavoriteListQuery,
        FavoriteToggleResponse, ProblemFavoriteItem, ProblemFavoriteListResponse,
    },
    models::forum::PublicAuthor,
    services::forum_service,
};

const DEFAULT_PAGE: u32 = 1;
const DEFAULT_SIZE: u32 = 20;
const MAX_PAGE_SIZE: u32 = 50;

fn page_and_size(query: &FavoriteListQuery) -> (u32, u32) {
    let page = query.page.unwrap_or(DEFAULT_PAGE).max(1);
    let size = query.size.unwrap_or(DEFAULT_SIZE).clamp(1, MAX_PAGE_SIZE);
    (page, size)
}

pub async fn set_problem_favorite(
    pool: &PgPool,
    user_id: i32,
    problem_id: i32,
    favorited: bool,
) -> Result<FavoriteToggleResponse, AppError> {
    let visible: Option<bool> = sqlx::query_scalar(
        "SELECT TRUE FROM problems WHERE id = $1 AND review_status = 'approved'",
    )
    .bind(problem_id)
    .fetch_optional(pool)
    .await
    .map_err(AppError::Database)?;
    if visible.is_none() {
        return Err(AppError::NotFound("题目不存在".to_owned()));
    }
    if favorited {
        sqlx::query(
            "INSERT INTO favorites (user_id, problem_id) VALUES ($1, $2) ON CONFLICT DO NOTHING",
        )
        .bind(user_id)
        .bind(problem_id)
        .execute(pool)
        .await
        .map_err(AppError::Database)?;
    } else {
        sqlx::query("DELETE FROM favorites WHERE user_id = $1 AND problem_id = $2")
            .bind(user_id)
            .bind(problem_id)
            .execute(pool)
            .await
            .map_err(AppError::Database)?;
    }
    Ok(FavoriteToggleResponse { favorited })
}

pub async fn list_problem_favorites(
    pool: &PgPool,
    user_id: i32,
    query: &FavoriteListQuery,
) -> Result<ProblemFavoriteListResponse, AppError> {
    let (page, size) = page_and_size(query);
    let offset = i64::from(page - 1) * i64::from(size);

    let total: i64 = sqlx::query_scalar(
        "SELECT COUNT(*)::bigint FROM favorites f \
         JOIN problems p ON p.id = f.problem_id \
         WHERE f.user_id = $1 AND p.review_status = 'approved'",
    )
    .bind(user_id)
    .fetch_one(pool)
    .await
    .map_err(AppError::Database)?;

    #[derive(FromRow)]
    struct FavoriteRow {
        problem_id: i32,
        title: String,
        difficulty: String,
        acceptance_rate: f64,
        favorited_at: DateTime<Utc>,
    }

    let rows: Vec<FavoriteRow> = sqlx::query_as(
        "SELECT p.id AS problem_id, p.title, p.difficulty, p.acceptance_rate, f.created_at AS favorited_at \
         FROM favorites f \
         JOIN problems p ON p.id = f.problem_id \
         WHERE f.user_id = $1 AND p.review_status = 'approved' \
         ORDER BY f.created_at DESC, p.id DESC \
         LIMIT $2 OFFSET $3",
    )
    .bind(user_id)
    .bind(i64::from(size))
    .bind(offset)
    .fetch_all(pool)
    .await
    .map_err(AppError::Database)?;

    Ok(ProblemFavoriteListResponse {
        total,
        page,
        size,
        favorites: rows
            .into_iter()
            .map(|row| ProblemFavoriteItem {
                problem_id: row.problem_id,
                title: row.title,
                difficulty: row.difficulty,
                acceptance_rate: row.acceptance_rate,
                favorited_at: row.favorited_at,
            })
            .collect(),
    })
}

pub async fn set_comment_favorite(
    pool: &PgPool,
    config: &Config,
    user_id: i32,
    comment_id: i64,
    favorited: bool,
) -> Result<FavoriteToggleResponse, AppError> {
    forum_service::ensure_enabled(config)?;
    let visible: Option<(String, String)> = sqlx::query_as(
        "SELECT c.status, fp.status FROM forum_comments c \
         JOIN forum_posts fp ON fp.id = c.post_id WHERE c.id = $1",
    )
    .bind(comment_id)
    .fetch_optional(pool)
    .await
    .map_err(AppError::Database)?;
    match visible {
        Some((comment_status, post_status))
            if comment_status == "published" && post_status == "published" => {}
        _ => return Err(AppError::NotFound("评论不存在或已被删除".to_owned())),
    }
    if favorited {
        sqlx::query(
            "INSERT INTO forum_comment_favorites (comment_id, user_id) VALUES ($1, $2) \
             ON CONFLICT DO NOTHING",
        )
        .bind(comment_id)
        .bind(user_id)
        .execute(pool)
        .await
        .map_err(AppError::Database)?;
    } else {
        sqlx::query("DELETE FROM forum_comment_favorites WHERE comment_id = $1 AND user_id = $2")
            .bind(comment_id)
            .bind(user_id)
            .execute(pool)
            .await
            .map_err(AppError::Database)?;
    }
    Ok(FavoriteToggleResponse { favorited })
}

pub async fn list_comment_favorites(
    pool: &PgPool,
    config: &Config,
    user_id: i32,
    query: &FavoriteListQuery,
) -> Result<CommentFavoriteListResponse, AppError> {
    forum_service::ensure_enabled(config)?;
    let (page, size) = page_and_size(query);
    let offset = i64::from(page - 1) * i64::from(size);

    let total: i64 = sqlx::query_scalar(
        "SELECT COUNT(*)::bigint FROM forum_comment_favorites f \
         JOIN forum_comments c ON c.id = f.comment_id \
         JOIN forum_posts fp ON fp.id = c.post_id \
         WHERE f.user_id = $1 AND c.status = 'published' AND fp.status = 'published'",
    )
    .bind(user_id)
    .fetch_one(pool)
    .await
    .map_err(AppError::Database)?;

    #[derive(FromRow)]
    struct FavoriteRow {
        comment_id: i64,
        post_id: i64,
        post_title: String,
        parent_id: Option<i64>,
        body_md: String,
        author_id: i32,
        author_username: String,
        author_is_plus: bool,
        is_anonymous: bool,
        created_at: DateTime<Utc>,
        favorited_at: DateTime<Utc>,
    }

    let rows: Vec<FavoriteRow> = sqlx::query_as(
        "SELECT c.id AS comment_id, c.post_id, fp.title AS post_title, c.parent_id, c.body_md, \
         c.author_id, u.username AS author_username, \
         EXISTS (SELECT 1 FROM plus_memberships pm WHERE pm.user_id = c.author_id \
         AND pm.expires_at > CURRENT_TIMESTAMP) AS author_is_plus, \
         c.is_anonymous, c.created_at, \
         f.created_at AS favorited_at \
         FROM forum_comment_favorites f \
         JOIN forum_comments c ON c.id = f.comment_id \
         JOIN forum_posts fp ON fp.id = c.post_id \
         JOIN users u ON u.id = c.author_id \
         WHERE f.user_id = $1 AND c.status = 'published' AND fp.status = 'published' \
         ORDER BY f.created_at DESC, c.id DESC \
         LIMIT $2 OFFSET $3",
    )
    .bind(user_id)
    .bind(i64::from(size))
    .bind(offset)
    .fetch_all(pool)
    .await
    .map_err(AppError::Database)?;

    Ok(CommentFavoriteListResponse {
        total,
        page,
        size,
        favorites: rows
            .into_iter()
            .map(|row| CommentFavoriteItem {
                comment_id: row.comment_id,
                post_id: row.post_id,
                post_title: row.post_title,
                parent_id: row.parent_id,
                body_md: row.body_md,
                author: PublicAuthor::new(
                    row.author_id,
                    &row.author_username,
                    row.is_anonymous,
                    row.author_is_plus,
                    Some(user_id),
                ),
                created_at: row.created_at,
                favorited_at: row.favorited_at,
            })
            .collect(),
    })
}
