use chrono::{DateTime, Utc};
use sqlx::{FromRow, PgPool};

use crate::{
    common::error::{AppError, is_unique_violation},
    middleware::auth::AuthUser,
    models::plus::{
        MyPlusStateResponse, PLUS_KIND_NEW, PLUS_KIND_RENEWAL, PLUS_STATUS_APPROVED,
        PLUS_STATUS_PENDING, PLUS_STATUS_REJECTED, PlusApplicationInput, PlusApplicationItem,
        PlusApplicationListResponse, PlusApplicationQuery, PlusApplicationResolveInput,
        PlusApplicationResolveResponse, PlusMembership,
    },
    services::notification_service,
};

const DEFAULT_PAGE: u32 = 1;
const DEFAULT_SIZE: u32 = 20;
const MAX_PAGE_SIZE: u32 = 100;
const MAX_REASON_CHARS: usize = 500;
const MAX_NOTE_CHARS: usize = 500;
const MIN_PLUS_DAYS: i64 = 1;
const MAX_PLUS_DAYS: i64 = 3650;

#[derive(FromRow)]
struct ApplicationRow {
    id: i64,
    user_id: i32,
    username: String,
    reason: String,
    kind: String,
    status: String,
    review_note: Option<String>,
    reviewed_by: Option<String>,
    reviewed_at: Option<DateTime<Utc>>,
    membership_expires_at: Option<DateTime<Utc>>,
    created_at: DateTime<Utc>,
}

impl From<ApplicationRow> for PlusApplicationItem {
    fn from(row: ApplicationRow) -> Self {
        Self {
            id: row.id,
            user_id: row.user_id,
            username: row.username,
            reason: row.reason,
            kind: row.kind,
            status: row.status,
            review_note: row.review_note,
            reviewed_by: row.reviewed_by,
            reviewed_at: row.reviewed_at,
            membership_expires_at: row.membership_expires_at,
            created_at: row.created_at,
        }
    }
}

fn days_left_until(expires_at: DateTime<Utc>, now: DateTime<Utc>) -> i64 {
    if expires_at <= now {
        return 0;
    }
    let seconds = (expires_at - now).num_seconds();
    (seconds + 86_399) / 86_400
}

pub async fn is_plus(pool: &PgPool, user_id: i32) -> Result<bool, AppError> {
    sqlx::query_scalar(
        "SELECT EXISTS(SELECT 1 FROM plus_memberships \
         WHERE user_id = $1 AND expires_at > CURRENT_TIMESTAMP)",
    )
    .bind(user_id)
    .fetch_one(pool)
    .await
    .map_err(AppError::Database)
}

pub async fn my_state(pool: &PgPool, user_id: i32) -> Result<MyPlusStateResponse, AppError> {
    let is_plus = is_plus(pool, user_id).await?;

    let membership_row: Option<(DateTime<Utc>, DateTime<Utc>)> =
        sqlx::query_as("SELECT started_at, expires_at FROM plus_memberships WHERE user_id = $1")
            .bind(user_id)
            .fetch_optional(pool)
            .await
            .map_err(AppError::Database)?;
    let membership = membership_row.map(|(started_at, expires_at)| {
        let now = Utc::now();
        let days_left = days_left_until(expires_at, now);
        PlusMembership {
            started_at,
            expires_at,
            days_left,
        }
    });

    let row: Option<ApplicationRow> = sqlx::query_as(
        "SELECT a.id, a.user_id, u.username, a.reason, a.kind, a.status, \
         a.review_note, r.username AS reviewed_by, a.reviewed_at, \
         m.expires_at AS membership_expires_at, a.created_at \
         FROM plus_applications a \
         JOIN users u ON u.id = a.user_id \
         LEFT JOIN users r ON r.id = a.reviewed_by \
         LEFT JOIN plus_memberships m ON m.user_id = a.user_id \
         WHERE a.user_id = $1 ORDER BY a.created_at DESC, a.id DESC LIMIT 1",
    )
    .bind(user_id)
    .fetch_optional(pool)
    .await
    .map_err(AppError::Database)?;

    Ok(MyPlusStateResponse {
        is_plus,
        membership,
        application: row.map(PlusApplicationItem::from),
    })
}

/// 在到期前 7/3/1 天各提醒一次，靠 `plus_expiry_notices` 去重。
/// 续费改变 `expires_at` 后会重新计算提醒节点。
pub async fn remind_expiring(pool: &PgPool) -> Result<usize, AppError> {
    let rows: Vec<(i32, DateTime<Utc>)> = sqlx::query_as(
        "SELECT user_id, expires_at FROM plus_memberships \
         WHERE expires_at > CURRENT_TIMESTAMP \
           AND expires_at <= CURRENT_TIMESTAMP + INTERVAL '7 days'",
    )
    .fetch_all(pool)
    .await
    .map_err(AppError::Database)?;

    let now = Utc::now();
    let mut sent = 0usize;
    for (user_id, expires_at) in rows {
        let days_left = days_left_until(expires_at, now);
        if !matches!(days_left, 1 | 3 | 7) {
            continue;
        }
        let mut transaction = pool.begin().await.map_err(AppError::Database)?;
        let inserted: Option<i32> = sqlx::query_scalar(
            "INSERT INTO plus_expiry_notices (user_id, expires_at, days_left) \
             VALUES ($1, $2, $3) \
             ON CONFLICT (user_id, expires_at, days_left) DO NOTHING \
             RETURNING user_id",
        )
        .bind(user_id)
        .bind(expires_at)
        .bind(days_left as i32)
        .fetch_optional(&mut *transaction)
        .await
        .map_err(AppError::Database)?;
        if inserted.is_none() {
            continue;
        }
        let title = if days_left == 1 {
            "Plus Theseus 明天到期".to_owned()
        } else {
            format!("Plus Theseus 还有 {days_left} 天到期")
        };
        let body = format!(
            "有效期至 {}\n到期前可以在商店提前续费",
            expires_at.format("%Y-%m-%d")
        );
        notification_service::create(
            &mut transaction,
            user_id,
            "plus_expiry",
            None,
            &title,
            Some(&body),
            Some("/shop"),
            Some("plus_membership"),
            None,
        )
        .await?;
        transaction.commit().await.map_err(AppError::Database)?;
        sent += 1;
    }
    Ok(sent)
}

pub async fn submit(
    pool: &PgPool,
    user: &AuthUser,
    input: &PlusApplicationInput,
) -> Result<MyPlusStateResponse, AppError> {
    if user.is_admin() {
        return Err(AppError::ForbiddenWith(
            "管理员无需申请 Plus Theseus".to_owned(),
        ));
    }
    let reason = input.reason.trim();
    if reason.is_empty() {
        return Err(AppError::BadRequest("请填写申请说明".to_owned()));
    }
    if reason.chars().count() > MAX_REASON_CHARS {
        return Err(AppError::BadRequest(format!(
            "申请说明不能超过 {MAX_REASON_CHARS} 字"
        )));
    }

    let kind = if is_plus(pool, user.id).await? {
        PLUS_KIND_RENEWAL
    } else {
        PLUS_KIND_NEW
    };

    let existing: Option<String> = sqlx::query_scalar(
        "SELECT status FROM plus_applications \
         WHERE user_id = $1 AND status = 'pending' LIMIT 1",
    )
    .bind(user.id)
    .fetch_optional(pool)
    .await
    .map_err(AppError::Database)?;
    if existing.is_some() {
        return Err(AppError::ConflictWith(
            "已有一条申请正在审核，请等待处理".to_owned(),
        ));
    }

    let inserted =
        sqlx::query("INSERT INTO plus_applications (user_id, reason, kind) VALUES ($1, $2, $3)")
            .bind(user.id)
            .bind(reason)
            .bind(kind)
            .execute(pool)
            .await;
    if let Err(error) = inserted {
        if is_unique_violation(&error) {
            return Err(AppError::ConflictWith(
                "已有一条申请正在审核，请等待处理".to_owned(),
            ));
        }
        return Err(AppError::Database(error));
    }

    my_state(pool, user.id).await
}

pub async fn admin_list(
    pool: &PgPool,
    query: &PlusApplicationQuery,
) -> Result<PlusApplicationListResponse, AppError> {
    let page = query.page.unwrap_or(DEFAULT_PAGE).max(1);
    let size = query.size.unwrap_or(DEFAULT_SIZE).clamp(1, MAX_PAGE_SIZE);
    let offset = i64::from(page - 1) * i64::from(size);
    let status = query
        .status
        .as_deref()
        .map(str::trim)
        .filter(|value| !value.is_empty());
    if let Some(status) = status
        && ![
            PLUS_STATUS_PENDING,
            PLUS_STATUS_APPROVED,
            PLUS_STATUS_REJECTED,
        ]
        .contains(&status)
    {
        return Err(AppError::BadRequest("状态筛选无效".to_owned()));
    }

    let total: i64 = sqlx::query_scalar(
        "SELECT COUNT(*)::bigint FROM plus_applications a \
         WHERE $1::text IS NULL OR a.status = $1",
    )
    .bind(status)
    .fetch_one(pool)
    .await
    .map_err(AppError::Database)?;

    let rows: Vec<ApplicationRow> = sqlx::query_as(
        "SELECT a.id, a.user_id, u.username, a.reason, a.kind, a.status, \
         a.review_note, r.username AS reviewed_by, a.reviewed_at, \
         m.expires_at AS membership_expires_at, a.created_at \
         FROM plus_applications a \
         JOIN users u ON u.id = a.user_id \
         LEFT JOIN users r ON r.id = a.reviewed_by \
         LEFT JOIN plus_memberships m ON m.user_id = a.user_id \
         WHERE $1::text IS NULL OR a.status = $1 \
         ORDER BY a.created_at DESC, a.id DESC LIMIT $2 OFFSET $3",
    )
    .bind(status)
    .bind(i64::from(size))
    .bind(offset)
    .fetch_all(pool)
    .await
    .map_err(AppError::Database)?;

    Ok(PlusApplicationListResponse {
        total,
        page,
        size,
        items: rows.into_iter().map(PlusApplicationItem::from).collect(),
    })
}

pub async fn admin_resolve(
    pool: &PgPool,
    application_id: i64,
    admin: &AuthUser,
    input: &PlusApplicationResolveInput,
) -> Result<PlusApplicationResolveResponse, AppError> {
    let status = input.status.trim();
    if ![PLUS_STATUS_APPROVED, PLUS_STATUS_REJECTED].contains(&status) {
        return Err(AppError::BadRequest(
            "处理结果只能是 approved 或 rejected".to_owned(),
        ));
    }
    let note = input
        .note
        .as_deref()
        .map(str::trim)
        .filter(|value| !value.is_empty());
    if note.is_some_and(|value| value.chars().count() > MAX_NOTE_CHARS) {
        return Err(AppError::BadRequest(format!(
            "处理说明不能超过 {MAX_NOTE_CHARS} 字"
        )));
    }
    let approved = status == PLUS_STATUS_APPROVED;
    let days = input.days.unwrap_or(0);
    if approved && !(MIN_PLUS_DAYS..=MAX_PLUS_DAYS).contains(&days) {
        return Err(AppError::BadRequest(format!(
            "开通天数需在 {MIN_PLUS_DAYS} 到 {MAX_PLUS_DAYS} 天之间"
        )));
    }

    let mut transaction = pool.begin().await.map_err(AppError::Database)?;
    let current: Option<(i32, String, String)> = sqlx::query_as(
        "SELECT user_id, status, kind FROM plus_applications WHERE id = $1 FOR UPDATE",
    )
    .bind(application_id)
    .fetch_optional(&mut *transaction)
    .await
    .map_err(AppError::Database)?;
    let Some((user_id, current_status, kind)) = current else {
        return Err(AppError::NotFound("申请不存在".to_owned()));
    };
    if current_status != PLUS_STATUS_PENDING {
        return Err(AppError::ConflictWith("该申请已处理".to_owned()));
    }

    sqlx::query(
        "UPDATE plus_applications \
         SET status = $2, review_note = $3, reviewed_by = $4, reviewed_at = CURRENT_TIMESTAMP \
         WHERE id = $1",
    )
    .bind(application_id)
    .bind(status)
    .bind(note)
    .bind(admin.id)
    .execute(&mut *transaction)
    .await
    .map_err(AppError::Database)?;

    let expires_at = if approved {
        Some(
            sqlx::query_scalar::<_, DateTime<Utc>>(
                "INSERT INTO plus_memberships (user_id, application_id, started_at, expires_at) \
                 VALUES ($1, $2, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP + make_interval(days => $3)) \
                 ON CONFLICT (user_id) DO UPDATE SET \
                   application_id = EXCLUDED.application_id, \
                   started_at = CASE \
                     WHEN plus_memberships.expires_at > CURRENT_TIMESTAMP \
                     THEN plus_memberships.started_at ELSE CURRENT_TIMESTAMP END, \
                   expires_at = GREATEST(plus_memberships.expires_at, CURRENT_TIMESTAMP) \
                     + make_interval(days => $3), \
                   updated_at = CURRENT_TIMESTAMP \
                 RETURNING expires_at",
            )
            .bind(user_id)
            .bind(application_id)
            .bind(days as i32)
            .fetch_one(&mut *transaction)
            .await
            .map_err(AppError::Database)?,
        )
    } else {
        None
    };

    let renewal = kind == PLUS_KIND_RENEWAL;
    let title = match (approved, renewal) {
        (true, true) => "Plus Theseus 续费已通过",
        (true, false) => "Plus Theseus 申请已通过",
        (false, _) => "Plus Theseus 申请未通过",
    };
    let success_body = if renewal {
        "已续费 Plus Theseus"
    } else {
        "已开通 Plus Theseus"
    };
    let body = match (approved, note, expires_at) {
        (true, Some(note), Some(expires_at)) => {
            format!("{note}\n有效期至 {}", expires_at.format("%Y-%m-%d"))
        }
        (true, None, Some(expires_at)) => {
            format!("{success_body}\n有效期至 {}", expires_at.format("%Y-%m-%d"))
        }
        (false, Some(note), _) => note.to_owned(),
        _ => "你的开通申请未通过".to_owned(),
    };
    notification_service::create(
        &mut transaction,
        user_id,
        "plus_application",
        Some(admin.id),
        title,
        Some(&body),
        Some("/shop"),
        Some("plus_application"),
        Some(application_id),
    )
    .await?;

    transaction.commit().await.map_err(AppError::Database)?;

    Ok(PlusApplicationResolveResponse {
        status: status.to_owned(),
        message: match (approved, renewal) {
            (true, true) => "已通过续费申请".to_owned(),
            (true, false) => "已通过申请".to_owned(),
            (false, _) => "已驳回申请".to_owned(),
        },
        expires_at,
    })
}

#[cfg(test)]
mod tests {
    use super::days_left_until;
    use chrono::{TimeDelta, Utc};

    #[test]
    fn days_left_rounds_up_partial_days() {
        let now = Utc::now();
        assert_eq!(days_left_until(now + TimeDelta::seconds(1), now), 1);
        assert_eq!(days_left_until(now + TimeDelta::days(1), now), 1);
        assert_eq!(
            days_left_until(now + TimeDelta::days(1) + TimeDelta::seconds(1), now),
            2
        );
    }

    #[test]
    fn expired_membership_has_no_days_left() {
        let now = Utc::now();
        assert_eq!(days_left_until(now, now), 0);
        assert_eq!(days_left_until(now - TimeDelta::seconds(1), now), 0);
    }
}
