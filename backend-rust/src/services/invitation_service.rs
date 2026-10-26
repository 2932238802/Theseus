use chrono::{DateTime, TimeDelta, Utc};
use sqlx::{FromRow, PgPool};

use crate::{
    common::error::AppError,
    middleware::auth::AuthUser,
    models::teaching::{
        ClassInvitationListResponse, CreateClassInvitationsRequest, CreateClassInvitationsResponse,
        InvitationMutationResponse, InvitationSkip, InviteCandidate, InviteCandidateListResponse,
        InviteCandidateQuery, MyInvitationItem, MyInvitationListResponse, OwnerInvitationItem,
    },
    services::notification_service,
};

/// 邀请有效期；过期由读取/应答路径惰性落库。
const INVITATION_TTL_DAYS: i64 = 7;
const MAX_BATCH_INVITES: usize = 200;
const DEFAULT_SEARCH_LIMIT: u32 = 20;
const MAX_SEARCH_LIMIT: u32 = 50;
const MAX_SEARCH_QUERY_CHARS: usize = 100;

#[derive(Debug, FromRow)]
struct CandidateRow {
    user_id: i32,
    username: String,
    email: String,
    is_member: bool,
    has_pending_invitation: bool,
}

impl From<CandidateRow> for InviteCandidate {
    fn from(row: CandidateRow) -> Self {
        Self {
            user_id: row.user_id,
            username: row.username,
            email: row.email,
            is_member: row.is_member,
            has_pending_invitation: row.has_pending_invitation,
        }
    }
}

#[derive(Debug, FromRow)]
struct TargetRow {
    id: i32,
    username: String,
    role: String,
    is_member: bool,
    pending_id: Option<i64>,
}

#[derive(Debug, FromRow)]
struct InvitationRow {
    class_id: i32,
    inviter_id: i32,
    status: String,
    expires_at: DateTime<Utc>,
    class_name: String,
    archived_at: Option<DateTime<Utc>>,
}

pub async fn search_candidates(
    pool: &PgPool,
    teacher: &AuthUser,
    class_id: i32,
    query: &InviteCandidateQuery,
) -> Result<InviteCandidateListResponse, AppError> {
    ensure_class_owner(pool, teacher, class_id).await?;
    let keyword = query.q.as_deref().map(str::trim).unwrap_or_default();
    if keyword.is_empty() {
        return Err(AppError::BadRequest("请输入用户名或邮箱".to_owned()));
    }
    if keyword.chars().count() > MAX_SEARCH_QUERY_CHARS {
        return Err(AppError::BadRequest(format!(
            "搜索词不能超过 {MAX_SEARCH_QUERY_CHARS} 个字符"
        )));
    }
    let limit = query
        .limit
        .unwrap_or(DEFAULT_SEARCH_LIMIT)
        .clamp(1, MAX_SEARCH_LIMIT);
    let pattern = format!("%{}%", escape_like(keyword));
    let rows: Vec<CandidateRow> = sqlx::query_as(
        "SELECT u.id AS user_id, u.username, u.email, \
         EXISTS(SELECT 1 FROM class_members cm \
                WHERE cm.class_id = $1 AND cm.user_id = u.id AND cm.status = 'active') AS is_member, \
         EXISTS(SELECT 1 FROM class_invitations ci \
                WHERE ci.class_id = $1 AND ci.invitee_id = u.id AND ci.status = 'pending') \
             AS has_pending_invitation \
         FROM users u \
         WHERE u.role = 'student' AND u.id <> $3 \
           AND (u.username ILIKE $2 OR u.email ILIKE $2) \
         ORDER BY (u.username = $4) DESC, u.username ASC \
         LIMIT $5",
    )
    .bind(class_id)
    .bind(pattern)
    .bind(teacher.id)
    .bind(keyword)
    .bind(i64::from(limit))
    .fetch_all(pool)
    .await
    .map_err(AppError::Database)?;
    Ok(InviteCandidateListResponse {
        candidates: rows.into_iter().map(InviteCandidate::from).collect(),
    })
}

pub async fn create_invitations(
    pool: &PgPool,
    teacher: &AuthUser,
    class_id: i32,
    request: &CreateClassInvitationsRequest,
) -> Result<CreateClassInvitationsResponse, AppError> {
    if !teacher.is_teacher() {
        return Err(AppError::ForbiddenWith(
            "只有教师账号可以邀请学生".to_owned(),
        ));
    }
    let user_ids = normalize_ids(&request.user_ids);
    if user_ids.is_empty() {
        return Err(AppError::BadRequest("请选择要邀请的学生".to_owned()));
    }
    if user_ids.len() > MAX_BATCH_INVITES {
        return Err(AppError::BadRequest(format!(
            "一次最多邀请 {MAX_BATCH_INVITES} 名学生"
        )));
    }

    let mut transaction = pool.begin().await.map_err(AppError::Database)?;
    let class: Option<(String, i32, Option<DateTime<Utc>>)> =
        sqlx::query_as("SELECT name, owner_id, archived_at FROM classes WHERE id = $1 FOR UPDATE")
            .bind(class_id)
            .fetch_optional(&mut *transaction)
            .await
            .map_err(AppError::Database)?;
    let (class_name, owner_id, archived_at) =
        class.ok_or_else(|| AppError::NotFound("班级不存在".to_owned()))?;
    if owner_id != teacher.id {
        return Err(AppError::NotFound("班级不存在".to_owned()));
    }
    if archived_at.is_some() {
        return Err(AppError::Conflict("班级已归档".to_owned()));
    }

    let teacher_username: String = sqlx::query_scalar("SELECT username FROM users WHERE id = $1")
        .bind(teacher.id)
        .fetch_one(&mut *transaction)
        .await
        .map_err(AppError::Database)?;

    let targets: Vec<TargetRow> = sqlx::query_as(
        "SELECT u.id, u.username, u.role, \
         EXISTS(SELECT 1 FROM class_members cm \
                WHERE cm.class_id = $1 AND cm.user_id = u.id AND cm.status = 'active') AS is_member, \
         ci.id AS pending_id \
         FROM users u \
         LEFT JOIN class_invitations ci \
             ON ci.class_id = $1 AND ci.invitee_id = u.id AND ci.status = 'pending' \
         WHERE u.id = ANY($2)",
    )
    .bind(class_id)
    .bind(&user_ids)
    .fetch_all(&mut *transaction)
    .await
    .map_err(AppError::Database)?;
    if targets.len() != user_ids.len() {
        return Err(AppError::BadRequest("部分用户不存在".to_owned()));
    }

    let expires_at = Utc::now()
        .checked_add_signed(
            TimeDelta::try_days(INVITATION_TTL_DAYS)
                .ok_or_else(|| AppError::Internal("邀请有效期配置无效".to_owned()))?,
        )
        .ok_or_else(|| AppError::Internal("邀请有效期计算失败".to_owned()))?;
    let mut invited_count = 0usize;
    let mut skipped = Vec::new();
    for target in targets {
        if target.role != "student" {
            skipped.push(skip(target.id, target.username, "not_student"));
            continue;
        }
        if target.is_member {
            skipped.push(skip(target.id, target.username, "already_member"));
            continue;
        }
        if let Some(pending_id) = target.pending_id {
            sqlx::query(
                "UPDATE class_invitations SET expires_at = $2, updated_at = CURRENT_TIMESTAMP \
                 WHERE id = $1",
            )
            .bind(pending_id)
            .bind(expires_at)
            .execute(&mut *transaction)
            .await
            .map_err(AppError::Database)?;
            skipped.push(skip(target.id, target.username, "already_invited"));
            continue;
        }

        let invitation_id: i64 = sqlx::query_scalar(
            "INSERT INTO class_invitations (class_id, inviter_id, invitee_id, expires_at) \
             VALUES ($1, $2, $3, $4) RETURNING id",
        )
        .bind(class_id)
        .bind(teacher.id)
        .bind(target.id)
        .bind(expires_at)
        .fetch_one(&mut *transaction)
        .await
        .map_err(AppError::Database)?;

        notification_service::create(
            &mut transaction,
            target.id,
            "class_invite",
            Some(teacher.id),
            &format!("{teacher_username} 邀请你加入班级「{class_name}」"),
            Some("邀请 7 天内有效，可在通知中心或「我的班级」中接受或拒绝。"),
            Some("/classes"),
            Some("class_invitation"),
            Some(invitation_id),
        )
        .await?;
        invited_count += 1;
    }
    transaction.commit().await.map_err(AppError::Database)?;

    let message = if invited_count > 0 {
        format!("已发送 {invited_count} 份班级邀请")
    } else {
        "没有新的邀请发送".to_owned()
    };
    Ok(CreateClassInvitationsResponse {
        invited_count,
        skipped,
        message,
    })
}

pub async fn list_class_invitations(
    pool: &PgPool,
    teacher: &AuthUser,
    class_id: i32,
) -> Result<ClassInvitationListResponse, AppError> {
    ensure_class_owner(pool, teacher, class_id).await?;
    expire_stale(pool, "class_id", i64::from(class_id)).await?;
    let invitations: Vec<OwnerInvitationItem> = sqlx::query_as(
        "SELECT ci.id, ci.invitee_id, u.username AS invitee_username, u.email AS invitee_email, \
         ci.status, ci.expires_at, ci.responded_at, ci.created_at \
         FROM class_invitations ci JOIN users u ON u.id = ci.invitee_id \
         WHERE ci.class_id = $1 AND ci.status = 'pending' \
         ORDER BY ci.created_at DESC, ci.id DESC",
    )
    .bind(class_id)
    .fetch_all(pool)
    .await
    .map_err(AppError::Database)?;
    Ok(ClassInvitationListResponse { invitations })
}

pub async fn list_my_invitations(
    pool: &PgPool,
    student: &AuthUser,
) -> Result<MyInvitationListResponse, AppError> {
    if !student.is_student() {
        return Err(AppError::ForbiddenWith(
            "只有学生账号可以查看班级邀请".to_owned(),
        ));
    }
    expire_stale(pool, "invitee_id", i64::from(student.id)).await?;
    let invitations: Vec<MyInvitationItem> = sqlx::query_as(
        "SELECT ci.id, ci.class_id, c.name AS class_name, c.course_name, c.term, \
         ci.inviter_id, u.username AS inviter_username, ci.status, ci.expires_at, ci.created_at \
         FROM class_invitations ci \
         JOIN classes c ON c.id = ci.class_id \
         JOIN users u ON u.id = ci.inviter_id \
         WHERE ci.invitee_id = $1 AND ci.status = 'pending' \
         ORDER BY ci.created_at DESC, ci.id DESC",
    )
    .bind(student.id)
    .fetch_all(pool)
    .await
    .map_err(AppError::Database)?;
    Ok(MyInvitationListResponse { invitations })
}

pub async fn accept_invitation(
    pool: &PgPool,
    student: &AuthUser,
    invitation_id: i64,
) -> Result<InvitationMutationResponse, AppError> {
    let mut transaction = pool.begin().await.map_err(AppError::Database)?;
    let invitation = lock_invitation(&mut transaction, student, invitation_id).await?;
    if invitation.status != "pending" {
        return Err(AppError::ConflictWith("该邀请已被处理".to_owned()));
    }
    if invitation.expires_at <= Utc::now() {
        mark_expired(&mut transaction, invitation_id).await?;
        transaction.commit().await.map_err(AppError::Database)?;
        return Err(AppError::ConflictWith("邀请已过期".to_owned()));
    }
    if invitation.archived_at.is_some() {
        return Err(AppError::Conflict("班级已归档".to_owned()));
    }

    sqlx::query(
        "INSERT INTO class_members (class_id, user_id, status) VALUES ($1, $2, 'active') \
         ON CONFLICT (class_id, user_id) DO UPDATE SET \
             joined_at = CASE WHEN class_members.status = 'removed' THEN CURRENT_TIMESTAMP ELSE class_members.joined_at END, \
             status = 'active', removed_at = NULL",
    )
    .bind(invitation.class_id)
    .bind(student.id)
    .execute(&mut *transaction)
    .await
    .map_err(AppError::Database)?;

    respond(&mut transaction, invitation_id, "accepted").await?;
    let username: String = sqlx::query_scalar("SELECT username FROM users WHERE id = $1")
        .bind(student.id)
        .fetch_one(&mut *transaction)
        .await
        .map_err(AppError::Database)?;
    notification_service::create(
        &mut transaction,
        invitation.inviter_id,
        "class_invite_accepted",
        Some(student.id),
        &format!("{username} 接受了你发送的班级邀请"),
        Some(&format!("已加入班级「{}」", invitation.class_name)),
        Some(&format!("/classes/{}", invitation.class_id)),
        Some("class_invitation"),
        Some(invitation_id),
    )
    .await?;
    transaction.commit().await.map_err(AppError::Database)?;
    Ok(InvitationMutationResponse {
        id: invitation_id,
        class_id: invitation.class_id,
        status: "accepted".to_owned(),
        message: format!("已加入班级「{}」", invitation.class_name),
    })
}

pub async fn decline_invitation(
    pool: &PgPool,
    student: &AuthUser,
    invitation_id: i64,
) -> Result<InvitationMutationResponse, AppError> {
    let mut transaction = pool.begin().await.map_err(AppError::Database)?;
    let invitation = lock_invitation(&mut transaction, student, invitation_id).await?;
    if invitation.status != "pending" {
        return Err(AppError::ConflictWith("该邀请已被处理".to_owned()));
    }
    if invitation.expires_at <= Utc::now() {
        mark_expired(&mut transaction, invitation_id).await?;
        transaction.commit().await.map_err(AppError::Database)?;
        return Err(AppError::ConflictWith("邀请已过期".to_owned()));
    }

    respond(&mut transaction, invitation_id, "declined").await?;
    let username: String = sqlx::query_scalar("SELECT username FROM users WHERE id = $1")
        .bind(student.id)
        .fetch_one(&mut *transaction)
        .await
        .map_err(AppError::Database)?;
    notification_service::create(
        &mut transaction,
        invitation.inviter_id,
        "class_invite_declined",
        Some(student.id),
        &format!("{username} 拒绝了你发送的班级邀请"),
        Some(&format!("班级「{}」", invitation.class_name)),
        Some(&format!("/classes/{}", invitation.class_id)),
        Some("class_invitation"),
        Some(invitation_id),
    )
    .await?;
    transaction.commit().await.map_err(AppError::Database)?;
    Ok(InvitationMutationResponse {
        id: invitation_id,
        class_id: invitation.class_id,
        status: "declined".to_owned(),
        message: "已拒绝该邀请".to_owned(),
    })
}

async fn ensure_class_owner(
    pool: &PgPool,
    teacher: &AuthUser,
    class_id: i32,
) -> Result<(), AppError> {
    if !teacher.is_teacher() {
        return Err(AppError::ForbiddenWith(
            "只有教师账号可以邀请学生".to_owned(),
        ));
    }
    let owner_id: Option<i32> = sqlx::query_scalar("SELECT owner_id FROM classes WHERE id = $1")
        .bind(class_id)
        .fetch_optional(pool)
        .await
        .map_err(AppError::Database)?;
    if owner_id != Some(teacher.id) {
        return Err(AppError::NotFound("班级不存在".to_owned()));
    }
    Ok(())
}

async fn lock_invitation(
    transaction: &mut sqlx::Transaction<'_, sqlx::Postgres>,
    student: &AuthUser,
    invitation_id: i64,
) -> Result<InvitationRow, AppError> {
    sqlx::query_as(
        "SELECT i.class_id, i.inviter_id, i.status, i.expires_at, \
         c.name AS class_name, c.archived_at \
         FROM class_invitations i JOIN classes c ON c.id = i.class_id \
         WHERE i.id = $1 AND i.invitee_id = $2 FOR UPDATE OF i",
    )
    .bind(invitation_id)
    .bind(student.id)
    .fetch_optional(&mut **transaction)
    .await
    .map_err(AppError::Database)?
    .ok_or_else(|| AppError::NotFound("邀请不存在".to_owned()))
}

async fn respond(
    transaction: &mut sqlx::Transaction<'_, sqlx::Postgres>,
    invitation_id: i64,
    status: &str,
) -> Result<(), AppError> {
    sqlx::query(
        "UPDATE class_invitations \
         SET status = $2, responded_at = CURRENT_TIMESTAMP, updated_at = CURRENT_TIMESTAMP \
         WHERE id = $1",
    )
    .bind(invitation_id)
    .bind(status)
    .execute(&mut **transaction)
    .await
    .map_err(AppError::Database)?;
    // 邀请已有结论，关联提醒直接标记已读，避免未读数残留。
    sqlx::query(
        "UPDATE notifications SET read_at = COALESCE(read_at, CURRENT_TIMESTAMP) \
         WHERE type = 'class_invite' AND related_type = 'class_invitation' AND related_id = $1",
    )
    .bind(invitation_id)
    .execute(&mut **transaction)
    .await
    .map_err(AppError::Database)?;
    Ok(())
}

async fn mark_expired(
    transaction: &mut sqlx::Transaction<'_, sqlx::Postgres>,
    invitation_id: i64,
) -> Result<(), AppError> {
    sqlx::query(
        "UPDATE class_invitations SET status = 'expired', updated_at = CURRENT_TIMESTAMP \
         WHERE id = $1 AND status = 'pending'",
    )
    .bind(invitation_id)
    .execute(&mut **transaction)
    .await
    .map_err(AppError::Database)?;
    Ok(())
}

async fn expire_stale(pool: &PgPool, column: &str, value: i64) -> Result<(), AppError> {
    let sql = format!(
        "UPDATE class_invitations SET status = 'expired', updated_at = CURRENT_TIMESTAMP \
         WHERE status = 'pending' AND expires_at <= CURRENT_TIMESTAMP AND {column} = $1"
    );
    sqlx::query(&sql)
        .bind(value)
        .execute(pool)
        .await
        .map_err(AppError::Database)?;
    Ok(())
}

fn normalize_ids(ids: &[i32]) -> Vec<i32> {
    let mut seen = std::collections::HashSet::new();
    ids.iter()
        .copied()
        .filter(|id| *id > 0)
        .filter(|id| seen.insert(*id))
        .collect()
}

fn skip(user_id: i32, username: String, reason: &str) -> InvitationSkip {
    InvitationSkip {
        user_id,
        username,
        reason: reason.to_owned(),
    }
}

fn escape_like(value: &str) -> String {
    value
        .replace('\\', "\\\\")
        .replace('%', "\\%")
        .replace('_', "\\_")
}

#[cfg(test)]
mod tests {
    use super::{escape_like, normalize_ids};

    #[test]
    fn normalizes_invite_ids() {
        assert_eq!(normalize_ids(&[2, 2, 0, -1, 3]), vec![2, 3]);
        assert!(normalize_ids(&[]).is_empty());
    }

    #[test]
    fn escapes_like_wildcards() {
        assert_eq!(escape_like("a_b%c\\d"), "a\\_b\\%c\\\\d");
    }
}
