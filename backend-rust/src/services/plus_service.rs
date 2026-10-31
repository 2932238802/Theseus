use chrono::{DateTime, Utc};
use sqlx::{FromRow, PgPool};

use crate::{
    common::error::{AppError, is_unique_violation},
    middleware::auth::AuthUser,
    models::plus::{
        MyPlusStateResponse, PLUS_STATUS_APPROVED, PLUS_STATUS_PENDING, PLUS_STATUS_REJECTED,
        PlusApplicationInput, PlusApplicationItem, PlusApplicationListResponse,
        PlusApplicationQuery, PlusApplicationResolveInput, PlusApplicationResolveResponse,
    },
    services::notification_service,
};

const DEFAULT_PAGE: u32 = 1;
const DEFAULT_SIZE: u32 = 20;
const MAX_PAGE_SIZE: u32 = 100;
const MAX_REASON_CHARS: usize = 500;
const MAX_NOTE_CHARS: usize = 500;

#[derive(FromRow)]
struct ApplicationRow {
    id: i64,
    user_id: i32,
    username: String,
    reason: String,
    status: String,
    review_note: Option<String>,
    reviewed_by: Option<String>,
    reviewed_at: Option<DateTime<Utc>>,
    created_at: DateTime<Utc>,
}

impl From<ApplicationRow> for PlusApplicationItem {
    fn from(row: ApplicationRow) -> Self {
        Self {
            id: row.id,
            user_id: row.user_id,
            username: row.username,
            reason: row.reason,
            status: row.status,
            review_note: row.review_note,
            reviewed_by: row.reviewed_by,
            reviewed_at: row.reviewed_at,
            created_at: row.created_at,
        }
    }
}

pub async fn is_plus(pool: &PgPool, user_id: i32) -> Result<bool, AppError> {
    sqlx::query_scalar(
        "SELECT EXISTS(SELECT 1 FROM plus_applications \
         WHERE user_id = $1 AND status = 'approved')",
    )
    .bind(user_id)
    .fetch_one(pool)
    .await
    .map_err(AppError::Database)
}

pub async fn my_state(pool: &PgPool, user_id: i32) -> Result<MyPlusStateResponse, AppError> {
    let is_plus = is_plus(pool, user_id).await?;

    let row: Option<ApplicationRow> = sqlx::query_as(
        "SELECT a.id, a.user_id, u.username, a.reason, a.status, \
         a.review_note, r.username AS reviewed_by, a.reviewed_at, a.created_at \
         FROM plus_applications a \
         JOIN users u ON u.id = a.user_id \
         LEFT JOIN users r ON r.id = a.reviewed_by \
         WHERE a.user_id = $1 ORDER BY a.created_at DESC, a.id DESC LIMIT 1",
    )
    .bind(user_id)
    .fetch_optional(pool)
    .await
    .map_err(AppError::Database)?;

    Ok(MyPlusStateResponse {
        is_plus,
        application: row.map(PlusApplicationItem::from),
    })
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

    let existing: Option<String> = sqlx::query_scalar(
        "SELECT status FROM plus_applications \
         WHERE user_id = $1 AND status IN ('pending', 'approved') \
         ORDER BY CASE status WHEN 'approved' THEN 0 ELSE 1 END LIMIT 1",
    )
    .bind(user.id)
    .fetch_optional(pool)
    .await
    .map_err(AppError::Database)?;
    match existing.as_deref() {
        Some(PLUS_STATUS_APPROVED) => {
            return Err(AppError::ConflictWith(
                "你已经开通了 Plus Theseus".to_owned(),
            ));
        }
        Some(_) => {
            return Err(AppError::ConflictWith(
                "已有一条申请正在审核，请等待处理".to_owned(),
            ));
        }
        None => {}
    }

    let inserted = sqlx::query("INSERT INTO plus_applications (user_id, reason) VALUES ($1, $2)")
        .bind(user.id)
        .bind(reason)
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
        "SELECT a.id, a.user_id, u.username, a.reason, a.status, \
         a.review_note, r.username AS reviewed_by, a.reviewed_at, a.created_at \
         FROM plus_applications a \
         JOIN users u ON u.id = a.user_id \
         LEFT JOIN users r ON r.id = a.reviewed_by \
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

    let mut transaction = pool.begin().await.map_err(AppError::Database)?;
    let current: Option<(i32, String)> =
        sqlx::query_as("SELECT user_id, status FROM plus_applications WHERE id = $1 FOR UPDATE")
            .bind(application_id)
            .fetch_optional(&mut *transaction)
            .await
            .map_err(AppError::Database)?;
    let Some((user_id, current_status)) = current else {
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

    let approved = status == PLUS_STATUS_APPROVED;
    let title = if approved {
        "Plus Theseus 申请已通过"
    } else {
        "Plus Theseus 申请未通过"
    };
    let body = note.map(str::to_owned).unwrap_or_else(|| {
        if approved {
            "你的开通申请已通过".to_owned()
        } else {
            "你的开通申请未通过".to_owned()
        }
    });
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
        message: if approved {
            "已通过申请".to_owned()
        } else {
            "已驳回申请".to_owned()
        },
    })
}
