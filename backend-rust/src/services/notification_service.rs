use std::collections::HashSet;
use std::sync::OnceLock;

use chrono::{DateTime, Utc};
use regex::Regex;
use sqlx::{PgPool, Postgres, QueryBuilder, Transaction};

use crate::{
    common::error::AppError,
    middleware::auth::AuthUser,
    models::notification::{
        NotificationItem, NotificationListQuery, NotificationListResponse,
        NotificationReadResponse, NotificationRow, SendNotificationRequest,
        SendNotificationResponse, UnreadCountResponse,
    },
};

const DEFAULT_PAGE: u32 = 1;
const DEFAULT_SIZE: u32 = 20;
const MAX_PAGE_SIZE: u32 = 50;
const MAX_MENTIONS: usize = 10;
const CUSTOM_NOTIFICATION_TYPE: &str = "system_notice";
const MAX_CUSTOM_TITLE_CHARS: usize = 100;
const MAX_CUSTOM_BODY_CHARS: usize = 5_000;
const MAX_CUSTOM_LINK_CHARS: usize = 500;
const MAX_DIRECT_RECIPIENTS: usize = 500;

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
        "SELECT n.id, n.type AS notification_type, n.title, n.body, n.link, \
         n.related_type, n.related_id, \
         CASE WHEN n.type = 'class_invite' THEN \
             (SELECT ci.status FROM class_invitations ci WHERE ci.id = n.related_id) \
         END AS invitation_status, \
         (n.read_at IS NOT NULL) AS read, n.created_at, COUNT(*) OVER() AS total \
         FROM notifications n WHERE n.user_id = ",
    );
    builder.push_bind(user_id);
    if unread_only {
        builder.push(" AND n.read_at IS NULL");
    }
    builder
        .push(" ORDER BY n.created_at DESC, n.id DESC LIMIT ")
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

/// 发送自定义站内通知。教师只能发给名下班级的在读学生；管理员可以发
/// 给指定用户、某个角色或全站。返回实际写入的通知条数。
pub async fn send_custom(
    pool: &PgPool,
    actor: &AuthUser,
    request: &SendNotificationRequest,
) -> Result<SendNotificationResponse, AppError> {
    if !actor.is_teacher() && !actor.is_admin() {
        return Err(AppError::ForbiddenWith(
            "只有教师或管理员可以发送通知".to_owned(),
        ));
    }
    let title = validate_custom_title(&request.title)?;
    let body = validate_custom_body(request.body.as_deref())?;
    let link = validate_custom_link(request.link.as_deref())?;
    let role = request
        .role
        .as_deref()
        .map(str::trim)
        .filter(|value| !value.is_empty());
    let all = request.all.unwrap_or(false);
    let user_ids = normalize_user_ids(request.user_ids.as_deref())?;

    if actor.is_teacher() {
        if role.is_some() || all {
            return Err(AppError::ForbiddenWith(
                "教师只能给本班学生发送通知".to_owned(),
            ));
        }
        let class_id = request
            .class_id
            .ok_or_else(|| AppError::BadRequest("请选择要发送通知的班级".to_owned()))?;
        return send_to_class(
            pool,
            actor.id,
            class_id,
            user_ids,
            &title,
            body.as_deref(),
            link.as_deref(),
        )
        .await;
    }

    if request.class_id.is_some() {
        return Err(AppError::BadRequest(
            "管理员请选择指定用户、角色或全站作为接收范围".to_owned(),
        ));
    }
    let audiences =
        usize::from(user_ids.is_some()) + usize::from(role.is_some()) + usize::from(all);
    if audiences != 1 {
        return Err(AppError::BadRequest("请且仅选择一种接收范围".to_owned()));
    }

    let mut transaction = pool.begin().await.map_err(AppError::Database)?;
    let count = if let Some(ids) = user_ids {
        validate_admin_targets(&mut transaction, &ids).await?;
        let mut count = 0u64;
        for user_id in ids {
            if user_id == actor.id {
                continue;
            }
            insert_custom(
                &mut transaction,
                user_id,
                actor.id,
                &title,
                body.as_deref(),
                link.as_deref(),
            )
            .await?;
            count += 1;
        }
        count
    } else if let Some(role) = role {
        validate_audience_role(role)?;
        let result = sqlx::query(
            "INSERT INTO notifications (user_id, type, actor_id, title, body, link) \
             SELECT id, $1, $2, $3, $4, $5 FROM users WHERE role = $6 AND id <> $2",
        )
        .bind(CUSTOM_NOTIFICATION_TYPE)
        .bind(actor.id)
        .bind(&title)
        .bind(body.as_deref())
        .bind(link.as_deref())
        .bind(role)
        .execute(&mut *transaction)
        .await
        .map_err(AppError::Database)?;
        result.rows_affected()
    } else {
        let result = sqlx::query(
            "INSERT INTO notifications (user_id, type, actor_id, title, body, link) \
             SELECT id, $1, $2, $3, $4, $5 FROM users WHERE id <> $2",
        )
        .bind(CUSTOM_NOTIFICATION_TYPE)
        .bind(actor.id)
        .bind(&title)
        .bind(body.as_deref())
        .bind(link.as_deref())
        .execute(&mut *transaction)
        .await
        .map_err(AppError::Database)?;
        result.rows_affected()
    };
    transaction.commit().await.map_err(AppError::Database)?;
    Ok(SendNotificationResponse {
        recipient_count: count,
        message: format!("已发送给 {count} 位用户"),
    })
}

async fn send_to_class(
    pool: &PgPool,
    actor_id: i32,
    class_id: i32,
    user_ids: Option<Vec<i32>>,
    title: &str,
    body: Option<&str>,
    link: Option<&str>,
) -> Result<SendNotificationResponse, AppError> {
    let mut transaction = pool.begin().await.map_err(AppError::Database)?;
    let class: Option<(i32, Option<DateTime<Utc>>)> =
        sqlx::query_as("SELECT owner_id, archived_at FROM classes WHERE id = $1")
            .bind(class_id)
            .fetch_optional(&mut *transaction)
            .await
            .map_err(AppError::Database)?;
    let (owner_id, archived_at) =
        class.ok_or_else(|| AppError::NotFound("班级不存在".to_owned()))?;
    if owner_id != actor_id {
        return Err(AppError::NotFound("班级不存在".to_owned()));
    }
    if archived_at.is_some() {
        return Err(AppError::Conflict("班级已归档".to_owned()));
    }

    let recipients: Vec<i32> = match user_ids {
        Some(ids) => {
            let found: Vec<i32> = sqlx::query_scalar(
                "SELECT u.id FROM users u \
                 JOIN class_members cm ON cm.user_id = u.id AND cm.class_id = $1 AND cm.status = 'active' \
                 WHERE u.id = ANY($2) AND u.role = 'student'",
            )
            .bind(class_id)
            .bind(&ids)
            .fetch_all(&mut *transaction)
            .await
            .map_err(AppError::Database)?;
            if found.len() != ids.len() {
                return Err(AppError::BadRequest(
                    "接收人必须都是本班在读学生".to_owned(),
                ));
            }
            found
        }
        None => sqlx::query_scalar(
            "SELECT user_id FROM class_members WHERE class_id = $1 AND status = 'active'",
        )
        .bind(class_id)
        .fetch_all(&mut *transaction)
        .await
        .map_err(AppError::Database)?,
    };

    for user_id in &recipients {
        if *user_id == actor_id {
            continue;
        }
        insert_custom(&mut transaction, *user_id, actor_id, title, body, link).await?;
    }
    transaction.commit().await.map_err(AppError::Database)?;
    Ok(SendNotificationResponse {
        recipient_count: recipients.len() as u64,
        message: format!("已发送给 {} 位学生", recipients.len()),
    })
}

async fn validate_admin_targets(
    transaction: &mut Transaction<'_, Postgres>,
    user_ids: &[i32],
) -> Result<(), AppError> {
    let rows: Vec<(i32, String)> = sqlx::query_as("SELECT id, role FROM users WHERE id = ANY($1)")
        .bind(user_ids)
        .fetch_all(&mut **transaction)
        .await
        .map_err(AppError::Database)?;
    if rows.len() != user_ids.len() {
        return Err(AppError::BadRequest("部分接收用户不存在".to_owned()));
    }
    if rows
        .iter()
        .any(|(_, role)| role != "student" && role != "teacher")
    {
        return Err(AppError::BadRequest("只能给教师或学生发送通知".to_owned()));
    }
    Ok(())
}

async fn insert_custom(
    transaction: &mut Transaction<'_, Postgres>,
    user_id: i32,
    actor_id: i32,
    title: &str,
    body: Option<&str>,
    link: Option<&str>,
) -> Result<(), AppError> {
    sqlx::query(
        "INSERT INTO notifications (user_id, type, actor_id, title, body, link) \
         VALUES ($1, $2, $3, $4, $5, $6)",
    )
    .bind(user_id)
    .bind(CUSTOM_NOTIFICATION_TYPE)
    .bind(actor_id)
    .bind(title)
    .bind(body)
    .bind(link)
    .execute(&mut **transaction)
    .await
    .map_err(AppError::Database)?;
    Ok(())
}

fn validate_custom_title(raw: &str) -> Result<String, AppError> {
    let title = raw.trim();
    let length = title.chars().count();
    if length == 0 {
        return Err(AppError::BadRequest("通知标题不能为空".to_owned()));
    }
    if length > MAX_CUSTOM_TITLE_CHARS {
        return Err(AppError::BadRequest(format!(
            "通知标题不能超过 {MAX_CUSTOM_TITLE_CHARS} 个字符"
        )));
    }
    Ok(title.to_owned())
}

fn validate_custom_body(raw: Option<&str>) -> Result<Option<String>, AppError> {
    let Some(body) = raw.map(str::trim).filter(|value| !value.is_empty()) else {
        return Ok(None);
    };
    if body.chars().count() > MAX_CUSTOM_BODY_CHARS {
        return Err(AppError::BadRequest(format!(
            "通知正文不能超过 {MAX_CUSTOM_BODY_CHARS} 个字符"
        )));
    }
    Ok(Some(body.to_owned()))
}

fn validate_custom_link(raw: Option<&str>) -> Result<Option<String>, AppError> {
    let Some(link) = raw.map(str::trim).filter(|value| !value.is_empty()) else {
        return Ok(None);
    };
    if !link.starts_with('/')
        || link.starts_with("//")
        || link.contains('\\')
        || link.contains("://")
    {
        return Err(AppError::BadRequest(
            "跳转链接必须是站内路径，例如 /classes/1".to_owned(),
        ));
    }
    if link.chars().count() > MAX_CUSTOM_LINK_CHARS {
        return Err(AppError::BadRequest(format!(
            "跳转链接不能超过 {MAX_CUSTOM_LINK_CHARS} 个字符"
        )));
    }
    Ok(Some(link.to_owned()))
}

fn normalize_user_ids(ids: Option<&[i32]>) -> Result<Option<Vec<i32>>, AppError> {
    let Some(ids) = ids else {
        return Ok(None);
    };
    let mut seen = HashSet::new();
    let unique: Vec<i32> = ids
        .iter()
        .copied()
        .filter(|id| *id > 0)
        .filter(|id| seen.insert(*id))
        .collect();
    if unique.is_empty() {
        return Err(AppError::BadRequest("请选择接收人".to_owned()));
    }
    if unique.len() > MAX_DIRECT_RECIPIENTS {
        return Err(AppError::BadRequest(format!(
            "一次最多选择 {MAX_DIRECT_RECIPIENTS} 位接收人"
        )));
    }
    Ok(Some(unique))
}

fn validate_audience_role(role: &str) -> Result<(), AppError> {
    if role == "student" || role == "teacher" {
        Ok(())
    } else {
        Err(AppError::BadRequest(
            "接收角色只能是 student 或 teacher".to_owned(),
        ))
    }
}

fn truncate_chars(value: &str, max: usize) -> String {
    value.chars().take(max).collect()
}

#[cfg(test)]
mod tests {
    use super::{
        MAX_CUSTOM_BODY_CHARS, extract_mentions, normalize_user_ids, validate_audience_role,
        validate_custom_body, validate_custom_link, validate_custom_title,
    };

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

    #[test]
    fn validates_custom_title_and_body_lengths() {
        assert!(validate_custom_title("   ").is_err());
        assert_eq!(validate_custom_title("  公告  ").unwrap(), "公告");
        assert!(validate_custom_title(&"标".repeat(101)).is_err());
        assert_eq!(validate_custom_body(Some("  ")).unwrap(), None);
        assert_eq!(
            validate_custom_body(Some(" hi ")).unwrap().as_deref(),
            Some("hi")
        );
        assert!(validate_custom_body(Some(&"正".repeat(MAX_CUSTOM_BODY_CHARS + 1))).is_err());
    }

    #[test]
    fn only_accepts_internal_links() {
        assert_eq!(
            validate_custom_link(Some("/classes/1")).unwrap().as_deref(),
            Some("/classes/1")
        );
        assert_eq!(validate_custom_link(None).unwrap(), None);
        for link in [
            "https://example.com",
            "//evil.example",
            "/\\evil",
            "classes/1",
        ] {
            assert!(validate_custom_link(Some(link)).is_err(), "{link}");
        }
    }

    #[test]
    fn deduplicates_and_limits_direct_recipients() {
        assert_eq!(
            normalize_user_ids(Some(&[3, 1, 3, 2, -1])).unwrap(),
            Some(vec![3, 1, 2])
        );
        assert!(normalize_user_ids(Some(&[])).is_err());
        let too_many: Vec<i32> = (1..=501).collect();
        assert!(normalize_user_ids(Some(&too_many)).is_err());
        assert_eq!(normalize_user_ids(None).unwrap(), None);
    }

    #[test]
    fn audience_role_is_limited_to_students_and_teachers() {
        assert!(validate_audience_role("student").is_ok());
        assert!(validate_audience_role("teacher").is_ok());
        assert!(validate_audience_role("admin").is_err());
        assert!(validate_audience_role("all").is_err());
    }
}
