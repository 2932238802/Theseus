use sqlx::{FromRow, PgPool};

use crate::{
    common::error::AppError,
    models::social::{
        FeedCounts, FollowResult, FollowingListResponse, FollowingUser, PrivacySettings,
    },
};

/// SQL fragment matching users who share an active class with `$1`, either as
/// classmates, as the class owner, or as members of a class owned by `$1`.
const SCHOOL_USER_IDS: &str = "\
    SELECT cm2.user_id FROM class_members cm1 \
    JOIN classes c ON c.id = cm1.class_id AND c.archived_at IS NULL \
    JOIN class_members cm2 ON cm2.class_id = cm1.class_id AND cm2.status = 'active' \
    WHERE cm1.user_id = $1 AND cm1.status = 'active' \
    UNION \
    SELECT c.owner_id FROM class_members cm1 \
    JOIN classes c ON c.id = cm1.class_id AND c.archived_at IS NULL \
    WHERE cm1.user_id = $1 AND cm1.status = 'active' \
    UNION \
    SELECT cm2.user_id FROM classes c \
    JOIN class_members cm2 ON cm2.class_id = c.id AND cm2.status = 'active' \
    WHERE c.owner_id = $1 AND c.archived_at IS NULL";

pub async fn follow(
    pool: &PgPool,
    follower_id: i32,
    following_id: i32,
) -> Result<FollowResult, AppError> {
    if follower_id == following_id {
        return Err(AppError::BadRequest("不能关注自己".to_owned()));
    }
    let target: Option<i32> =
        sqlx::query_scalar("SELECT id FROM users WHERE id = $1 AND status = 'active'")
            .bind(following_id)
            .fetch_optional(pool)
            .await
            .map_err(AppError::Database)?;
    if target.is_none() {
        return Err(AppError::NotFound("用户不存在".to_owned()));
    }
    sqlx::query(
        "INSERT INTO user_follows (follower_id, following_id) VALUES ($1, $2) \
         ON CONFLICT (follower_id, following_id) DO NOTHING",
    )
    .bind(follower_id)
    .bind(following_id)
    .execute(pool)
    .await
    .map_err(AppError::Database)?;
    Ok(FollowResult { following: true })
}

pub async fn unfollow(
    pool: &PgPool,
    follower_id: i32,
    following_id: i32,
) -> Result<FollowResult, AppError> {
    if follower_id == following_id {
        return Ok(FollowResult { following: false });
    }
    sqlx::query("DELETE FROM user_follows WHERE follower_id = $1 AND following_id = $2")
        .bind(follower_id)
        .bind(following_id)
        .execute(pool)
        .await
        .map_err(AppError::Database)?;
    Ok(FollowResult { following: false })
}

#[derive(Debug, FromRow)]
struct FollowingRow {
    id: i32,
    username: String,
    grade: Option<String>,
    role: String,
    avatar_path: Option<String>,
    is_plus: bool,
    is_same_school: bool,
    followed_at: chrono::DateTime<chrono::Utc>,
}

pub async fn list_following(
    pool: &PgPool,
    follower_id: i32,
) -> Result<FollowingListResponse, AppError> {
    let query = format!(
        "SELECT u.id, u.username, u.grade, u.role, u.avatar_path, \
         EXISTS (SELECT 1 FROM plus_memberships pm WHERE pm.user_id = u.id \
         AND pm.expires_at > CURRENT_TIMESTAMP) AS is_plus, \
         (u.id IN ({SCHOOL_USER_IDS})) AS is_same_school, \
         uf.created_at AS followed_at \
         FROM user_follows uf JOIN users u ON u.id = uf.following_id \
         WHERE uf.follower_id = $1 AND u.status = 'active' \
         ORDER BY uf.created_at DESC, u.id DESC"
    );
    let rows: Vec<FollowingRow> = sqlx::query_as(&query)
        .bind(follower_id)
        .fetch_all(pool)
        .await
        .map_err(AppError::Database)?;
    let users: Vec<FollowingUser> = rows
        .into_iter()
        .map(|row| FollowingUser {
            id: row.id,
            username: row.username,
            grade: row.grade,
            role: row.role,
            avatar_url: row.avatar_path.map(|path| format!("/uploads/{path}")),
            is_plus: row.is_plus,
            is_same_school: row.is_same_school,
            followed_at: row.followed_at,
        })
        .collect();
    Ok(FollowingListResponse {
        total: users.len() as i64,
        users,
    })
}

pub async fn feed_counts(pool: &PgPool, viewer_id: i32) -> Result<FeedCounts, AppError> {
    let following: i64 = sqlx::query_scalar(
        "SELECT COUNT(*) FROM user_follows uf JOIN users u ON u.id = uf.following_id \
         WHERE uf.follower_id = $1 AND u.status = 'active' \
         AND NOT u.hide_activity_from_social",
    )
    .bind(viewer_id)
    .fetch_one(pool)
    .await
    .map_err(AppError::Database)?;
    let school_query = format!(
        "SELECT COUNT(*) FROM users u \
         WHERE u.id <> $1 AND u.status = 'active' AND NOT u.hide_activity_from_social \
         AND u.id IN ({SCHOOL_USER_IDS})"
    );
    let school: i64 = sqlx::query_scalar(&school_query)
        .bind(viewer_id)
        .fetch_one(pool)
        .await
        .map_err(AppError::Database)?;
    Ok(FeedCounts { following, school })
}

pub async fn get_privacy(pool: &PgPool, user_id: i32) -> Result<PrivacySettings, AppError> {
    let hide_activity_from_social: bool =
        sqlx::query_scalar("SELECT hide_activity_from_social FROM users WHERE id = $1")
            .bind(user_id)
            .fetch_one(pool)
            .await
            .map_err(AppError::Database)?;
    Ok(PrivacySettings {
        hide_activity_from_social,
    })
}

pub async fn update_privacy(
    pool: &PgPool,
    user_id: i32,
    hide_activity_from_social: bool,
) -> Result<PrivacySettings, AppError> {
    sqlx::query("UPDATE users SET hide_activity_from_social = $2 WHERE id = $1")
        .bind(user_id)
        .bind(hide_activity_from_social)
        .execute(pool)
        .await
        .map_err(AppError::Database)?;
    Ok(PrivacySettings {
        hide_activity_from_social,
    })
}
