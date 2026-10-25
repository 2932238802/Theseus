use std::collections::HashSet;
use std::sync::OnceLock;

use regex::Regex;
use sqlx::{Postgres, QueryBuilder, Transaction};

use crate::{
    common::error::AppError,
    models::notification::{
        NotificationItem, NotificationListQuery, NotificationListResponse,
        NotificationReadResponse, NotificationRow, UnreadCountResponse,
    },
};

const DEFAULT_PAGE: u32 = 1;
const DEFAULT_SIZE: u32 = 20;
const MAX_PAGE_SIZE: u32 = 50;
const MAX_MENTIONS: usize = 10;

#[allow(clippy::too_many_arguments)]
pub async fn create(
    tx: &mut Transaction<'_, Postgres>,
    user_id: i32,
    notification_type: &str,
    actor_id: Option<i32>,
    title: &str,
    body: Option<&str>,
    link: Option<&str>,
    related_type: Option<&str>,
    related_id: Option<i64>,
) -> Result<(), AppError> {
    if actor_id == Some(user_id) {
        return Ok(());
    }
    sqlx::query(
        "INSERT INTO notifications (user_id, type, actor_id, title, body, link, related_type, related_id) VALUES ($1, $2, $3, $4, $5, $6, $7, $8)",
    )
    .bind(user_id)
    .bind(notification_type)
    .bind(actor_id)
    .bind(truncate_chars(title, 200))
    .bind(body.map(|value| truncate_chars(value, 500)))
    .bind(link.map(|value| truncate_chars(value, 500)))
    .bind(related_type)
    .bind(related_id)
    .execute(&mut **tx)
    .await
    .map_err(AppError::Database)?;
    Ok(())
}

/// Resolve `@username` mentions to real users inside an existing transaction.
/// Unknown names, the actor and duplicates are skipped; this function never
/// fails because a mention is malformed.
pub async fn resolve_mentions(
    tx: &mut Transaction<'_, Postgres>,
    text: &str,
    actor_id: i32,
) -> Result<Vec<(i32, String)>, AppError> {
    let names = extract_mentions(text);
    if names.is_empty() {
        return Ok(Vec::new());
    }
    let rows: Vec<(i32, String)> =
        sqlx::query_as("SELECT id, username FROM users WHERE username = ANY($1)")
            .bind(&names)
            .fetch_all(&mut **tx)
            .await
            .map_err(AppError::Database)?;
    Ok(rows.into_iter().filter(|(id, _)| *id != actor_id).collect())
}

pub fn extract_mentions(text: &str) -> Vec<String> {
    static MENTION_RE: OnceLock<Regex> = OnceLock::new();
    let regex = MENTION_RE.get_or_init(|| {
        Regex::new(r"(?:^|\s)@([^\s@,.:;!?，。：；！？、)】]{3,50})")
            .expect("mention regex is valid")
    });
    let mut seen = HashSet::new();
    let mut mentions = Vec::new();
    for capture in regex.captures_iter(text) {
        let Some(raw) = capture.get(1) else {
            continue;
        };
        let name = raw
            .as_str()
            .trim_end_matches([
                ',', '.', ':', ';', '!', '?', '，', '。', '：', '；', '！', '？', '、', ')', '】',
            ])
            .trim();
        if name.chars().count() < 3 || name.chars().count() > 50 {
            continue;
        }
        if seen.insert(name.to_owned()) {
            mentions.push(name.to_owned());
            if mentions.len() >= MAX_MENTIONS {
                break;
            }
        }
    }
    mentions
}

pub async fn list(
    pool: &sqlx::PgPool,
    user_id: i32,
    query: &NotificationListQuery,
) -> Result<NotificationListResponse, AppError> {
    let page = query.page.unwrap_or(DEFAULT_PAGE).max(1);
    let size = query.size.unwrap_or(DEFAULT_SIZE).clamp(1, MAX_PAGE_SIZE);
    let unread_only = query.unread_only.unwrap_or(false);
    let offset = i64::from(page.saturating_sub(1)) * i64::from(size);

    let mut builder = QueryBuilder::<Postgres>::new(
        "SELECT id, type AS notification_type, title, body, link, \
         (read_at IS NOT NULL) AS read, created_at, COUNT(*) OVER() AS total \
         FROM notifications WHERE user_id = ",
    );
    builder.push_bind(user_id);
    if unread_only {
        builder.push(" AND read_at IS NULL");
    }
    builder
        .push(" ORDER BY created_at DESC, id DESC LIMIT ")
        .push_bind(i64::from(size))
        .push(" OFFSET ")
        .push_bind(offset);
    let rows: Vec<NotificationRow> = builder
        .build_query_as()
        .fetch_all(pool)
        .await
        .map_err(AppError::Database)?;
    let total: i64 = if unread_only {
        sqlx::query_scalar(
            "SELECT COUNT(*) FROM notifications WHERE user_id = $1 AND read_at IS NULL",
        )
        .bind(user_id)
        .fetch_one(pool)
        .await
        .map_err(AppError::Database)?
    } else {
        sqlx::query_scalar("SELECT COUNT(*) FROM notifications WHERE user_id = $1")
            .bind(user_id)
            .fetch_one(pool)
            .await
            .map_err(AppError::Database)?
    };
    let notifications: Vec<NotificationItem> =
        rows.into_iter().map(NotificationRow::into_item).collect();
    let unread = unread_count(pool, user_id).await?;
    Ok(NotificationListResponse {
        total,
        unread,
        page,
        size,
        notifications,
    })
}

pub async fn unread_count(pool: &sqlx::PgPool, user_id: i32) -> Result<i64, AppError> {
    sqlx::query_scalar::<_, i64>(
        "SELECT COUNT(*) FROM notifications WHERE user_id = $1 AND read_at IS NULL",
    )
    .bind(user_id)
    .fetch_one(pool)
    .await
    .map_err(AppError::Database)
}

pub async fn unread(pool: &sqlx::PgPool, user_id: i32) -> Result<UnreadCountResponse, AppError> {
    Ok(UnreadCountResponse {
        unread: unread_count(pool, user_id).await?,
    })
}

pub async fn mark_read(
    pool: &sqlx::PgPool,
    user_id: i32,
    notification_id: i64,
) -> Result<NotificationReadResponse, AppError> {
    let updated: Option<(i64,)> = sqlx::query_as(
        "UPDATE notifications SET read_at = COALESCE(read_at, CURRENT_TIMESTAMP) \
         WHERE id = $1 AND user_id = $2 RETURNING id",
    )
    .bind(notification_id)
    .bind(user_id)
    .fetch_optional(pool)
    .await
    .map_err(AppError::Database)?;
    updated
        .map(|(id,)| NotificationReadResponse {
            id: Some(id),
            message: "通知已标记为已读".to_owned(),
        })
        .ok_or_else(|| AppError::NotFound("通知不存在".to_owned()))
}

pub async fn mark_all_read(
    pool: &sqlx::PgPool,
    user_id: i32,
) -> Result<NotificationReadResponse, AppError> {
    let updated = sqlx::query(
        "UPDATE notifications SET read_at = CURRENT_TIMESTAMP \
         WHERE user_id = $1 AND read_at IS NULL",
    )
    .bind(user_id)
    .execute(pool)
    .await
    .map_err(AppError::Database)?;
    Ok(NotificationReadResponse {
        id: None,
        message: format!("已将 {} 条通知标记为已读", updated.rows_affected()),
    })
}

fn truncate_chars(value: &str, max: usize) -> String {
    value.chars().take(max).collect()
}

#[cfg(test)]
mod tests {
    use super::extract_mentions;

    #[test]
    fn extracts_mentions_and_strips_punctuation() {
        assert_eq!(
            extract_mentions("你好 @alice，还有 @bob."),
            vec!["alice".to_owned(), "bob".to_owned()]
        );
        assert_eq!(
            extract_mentions("@alice @alice @bob"),
            vec!["alice".to_owned(), "bob".to_owned()]
        );
    }

    #[test]
    fn skips_short_and_invalid_mentions() {
        assert!(extract_mentions("@ab").is_empty());
        assert!(extract_mentions("mail@example.com").is_empty());
        assert!(extract_mentions("hello@alice").is_empty());
    }

    #[test]
    fn caps_mentions_at_ten() {
        let text = (0..15)
            .map(|index| format!("@user{index:02}"))
            .collect::<Vec<_>>()
            .join(" ");
        assert_eq!(extract_mentions(&text).len(), 10);
    }
}
