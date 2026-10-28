use chrono::Utc;
use sqlx::{PgPool, Postgres, QueryBuilder, Transaction};

use crate::{
    common::error::AppError,
    models::teaching::{
        AdminUserItem, AdminUserListQuery, AdminUserListResponse, ChangeRoleRequest,
        ChangeRoleResponse, ChangeUserStatusRequest, ChangeUserStatusResponse, DeleteUserResponse,
        ROLE_ADMIN, ROLE_STUDENT, ROLE_TEACHER,
    },
};

const DEFAULT_PAGE: u32 = 1;
const DEFAULT_SIZE: u32 = 20;
const MAX_PAGE_SIZE: u32 = 50;
const ROLE_LOCK_NAMESPACE: i32 = 4;
const STATUS_ACTIVE: &str = "active";
const STATUS_DISABLED: &str = "disabled";
const STATUS_DELETED: &str = "deleted";

pub async fn list_users(
    pool: &PgPool,
    query: &AdminUserListQuery,
) -> Result<AdminUserListResponse, AppError> {
    let page = query.page.unwrap_or(DEFAULT_PAGE).max(1);
    let size = query.size.unwrap_or(DEFAULT_SIZE).clamp(1, MAX_PAGE_SIZE);
    let offset = i64::from(page - 1) * i64::from(size);
    let q = query.q.as_deref().map(str::trim).filter(|q| !q.is_empty());
    let role = query
        .role
        .as_deref()
        .map(str::trim)
        .filter(|role| !role.is_empty());
    if let Some(role) = role {
        validate_role(role)?;
    }

    let mut count_builder =
        QueryBuilder::<Postgres>::new("SELECT COUNT(*) FROM users u WHERE 1 = 1");
    push_filters(&mut count_builder, q, role);
    let total: i64 = count_builder
        .build_query_scalar()
        .fetch_one(pool)
        .await
        .map_err(AppError::Database)?;

    let mut builder = QueryBuilder::<Postgres>::new(
        "SELECT u.id, u.username, u.email, u.role, u.status, \
         (SELECT COUNT(*) FROM class_members cm WHERE cm.user_id = u.id AND cm.status = 'active') AS active_membership_count, \
         (SELECT COUNT(*) FROM classes c WHERE c.owner_id = u.id AND c.archived_at IS NULL) AS owned_active_class_count, \
         u.created_at, u.role_changed_at FROM users u WHERE 1 = 1",
    );
    push_filters(&mut builder, q, role);
    builder
        .push(" ORDER BY u.id DESC LIMIT ")
        .push_bind(i64::from(size))
        .push(" OFFSET ")
        .push_bind(offset);
    let users: Vec<AdminUserItem> = builder
        .build_query_as()
        .fetch_all(pool)
        .await
        .map_err(AppError::Database)?;
    Ok(AdminUserListResponse {
        total,
        page,
        size,
        users,
    })
}

fn push_filters(builder: &mut QueryBuilder<'_, Postgres>, q: Option<&str>, role: Option<&str>) {
    builder
        .push(" AND u.status <> ")
        .push_bind(STATUS_DELETED);
    if let Some(q) = q {
        let pattern = format!("%{}%", escape_like(q));
        builder
            .push(" AND (u.username ILIKE ")
            .push_bind(pattern.clone())
            .push(" OR u.email ILIKE ")
            .push_bind(pattern)
            .push(")");
    }
    if let Some(role) = role {
        builder.push(" AND u.role = ").push_bind(role.to_owned());
    }
}

pub async fn change_role(
    pool: &PgPool,
    actor_id: i32,
    target_id: i32,
    request: &ChangeRoleRequest,
) -> Result<ChangeRoleResponse, AppError> {
    let target_role = request.role.trim();
    validate_role(target_role)?;
    if actor_id == target_id {
        return Err(AppError::BadRequest("不能修改自己的角色".to_owned()));
    }

    let mut transaction = pool.begin().await.map_err(AppError::Database)?;
    sqlx::query("SELECT pg_advisory_xact_lock($1, 0)")
        .bind(ROLE_LOCK_NAMESPACE)
        .execute(&mut *transaction)
        .await
        .map_err(AppError::Database)?;

    let target: Option<(i32, String, String)> =
        sqlx::query_as("SELECT id, username, role FROM users WHERE id = $1 FOR UPDATE")
            .bind(target_id)
            .fetch_optional(&mut *transaction)
            .await
            .map_err(AppError::Database)?;
    let (id, username, current_role) =
        target.ok_or_else(|| AppError::NotFound("用户不存在".to_owned()))?;

    if current_role == target_role {
        transaction.commit().await.map_err(AppError::Database)?;
        return Ok(ChangeRoleResponse {
            id,
            username,
            role: current_role,
            message: "角色未变化".to_owned(),
            archived_class_count: 0,
        });
    }

    if current_role == ROLE_ADMIN && target_role != ROLE_ADMIN {
        let admin_count: i64 =
            sqlx::query_scalar("SELECT COUNT(*) FROM users WHERE role = 'admin'")
                .fetch_one(&mut *transaction)
                .await
                .map_err(AppError::Database)?;
        if admin_count <= 1 {
            return Err(AppError::ConflictWith("不能降级最后一个管理员".to_owned()));
        }
    }

    let membership_count: i64 = sqlx::query_scalar(
        "SELECT COUNT(*) FROM class_members WHERE user_id = $1 AND status = 'active'",
    )
    .bind(target_id)
    .fetch_one(&mut *transaction)
    .await
    .map_err(AppError::Database)?;
    if membership_count > 0 && target_role != ROLE_STUDENT {
        return Err(AppError::ConflictWith(
            "该用户仍在班级中，请先退出班级或被教师移除".to_owned(),
        ));
    }

    let owned_count: i64 = sqlx::query_scalar(
        "SELECT COUNT(*) FROM classes WHERE owner_id = $1 AND archived_at IS NULL",
    )
    .bind(target_id)
    .fetch_one(&mut *transaction)
    .await
    .map_err(AppError::Database)?;
    let mut archived_class_count = 0u64;
    if owned_count > 0 {
        if target_role == ROLE_TEACHER || !request.archive_owned_classes {
            return Err(AppError::ConflictWith(
                "该教师仍有未归档的班级；确认归档这些班级后才能降级".to_owned(),
            ));
        }
        archived_class_count = archive_owned_classes(&mut transaction, target_id).await?;
    }

    sqlx::query(
        "UPDATE users SET role = $2, role_changed_at = CURRENT_TIMESTAMP, updated_at = CURRENT_TIMESTAMP WHERE id = $1",
    )
    .bind(target_id)
    .bind(target_role)
    .execute(&mut *transaction)
    .await
    .map_err(AppError::Database)?;

    transaction.commit().await.map_err(AppError::Database)?;
    tracing::info!(
        actor_id,
        target_id,
        from = %current_role,
        to = %target_role,
        archived_class_count,
        "user role changed"
    );
    Ok(ChangeRoleResponse {
        id,
        username,
        role: target_role.to_owned(),
        message: "角色已更新，立即生效".to_owned(),
        archived_class_count,
    })
}

pub async fn change_status(
    pool: &PgPool,
    actor_id: i32,
    target_id: i32,
    request: &ChangeUserStatusRequest,
) -> Result<ChangeUserStatusResponse, AppError> {
    let next_status = request.status.trim();
    if !matches!(next_status, STATUS_ACTIVE | STATUS_DISABLED) {
        return Err(AppError::BadRequest(
            "状态无效，仅支持 active 或 disabled".to_owned(),
        ));
    }
    if actor_id == target_id {
        return Err(AppError::BadRequest("不能修改自己的账号状态".to_owned()));
    }

    let mut transaction = pool.begin().await.map_err(AppError::Database)?;
    let target: Option<(i32, String, String, String)> = sqlx::query_as(
        "SELECT id, username, role, status FROM users WHERE id = $1 FOR UPDATE",
    )
    .bind(target_id)
    .fetch_optional(&mut *transaction)
    .await
    .map_err(AppError::Database)?;
    let (id, username, role, current_status) =
        target.ok_or_else(|| AppError::NotFound("用户不存在".to_owned()))?;

    if current_status == STATUS_DELETED {
        return Err(AppError::ConflictWith("该账号已删除，无法修改状态".to_owned()));
    }
    if current_status == next_status {
        transaction.commit().await.map_err(AppError::Database)?;
        return Ok(ChangeUserStatusResponse {
            id,
            username,
            status: current_status,
            message: "账号状态未变化".to_owned(),
        });
    }
    if next_status == STATUS_DISABLED && role == ROLE_ADMIN {
        ensure_more_than_one_active_admin(&mut transaction, "禁用").await?;
    }

    sqlx::query(
        "UPDATE users SET status = $2, token_version = token_version + 1, \
         updated_at = CURRENT_TIMESTAMP WHERE id = $1",
    )
    .bind(id)
    .bind(next_status)
    .execute(&mut *transaction)
    .await
    .map_err(AppError::Database)?;
    transaction.commit().await.map_err(AppError::Database)?;
    tracing::info!(
        actor_id,
        target_id = id,
        from = %current_status,
        to = %next_status,
        "user status changed"
    );
    Ok(ChangeUserStatusResponse {
        id,
        username,
        status: next_status.to_owned(),
        message: if next_status == STATUS_DISABLED {
            "账号已禁用，该用户将无法登录".to_owned()
        } else {
            "账号已恢复，可以重新登录".to_owned()
        },
    })
}

pub async fn delete_user(
    pool: &PgPool,
    actor_id: i32,
    target_id: i32,
) -> Result<DeleteUserResponse, AppError> {
    if actor_id == target_id {
        return Err(AppError::BadRequest("不能删除自己的账号".to_owned()));
    }

    let mut transaction = pool.begin().await.map_err(AppError::Database)?;
    let target: Option<(i32, String, String)> =
        sqlx::query_as("SELECT id, role, status FROM users WHERE id = $1 FOR UPDATE")
            .bind(target_id)
            .fetch_optional(&mut *transaction)
            .await
            .map_err(AppError::Database)?;
    let (id, role, status) =
        target.ok_or_else(|| AppError::NotFound("用户不存在".to_owned()))?;

    if status == STATUS_DELETED {
        transaction.commit().await.map_err(AppError::Database)?;
        return Ok(DeleteUserResponse {
            id,
            message: "账号已删除".to_owned(),
        });
    }
    if role == ROLE_ADMIN && status == STATUS_ACTIVE {
        ensure_more_than_one_active_admin(&mut transaction, "删除").await?;
    }

    sqlx::query(
        "UPDATE classes SET archived_at = CURRENT_TIMESTAMP, updated_at = CURRENT_TIMESTAMP \
         WHERE owner_id = $1 AND archived_at IS NULL",
    )
    .bind(id)
    .execute(&mut *transaction)
    .await
    .map_err(AppError::Database)?;

    sqlx::query(
        "UPDATE class_members SET status = 'removed', removed_at = CURRENT_TIMESTAMP \
         WHERE user_id = $1 AND status = 'active'",
    )
    .bind(id)
    .execute(&mut *transaction)
    .await
    .map_err(AppError::Database)?;

    let anonymous_username = format!("deleted_{id}");
    let anonymous_email = format!("deleted_{id}@deleted.local");
    let unusable_password = format!(
        "deleted-{id}-{}",
        Utc::now().timestamp_nanos_opt().unwrap_or_default()
    );
    sqlx::query(
        "UPDATE users
         SET username = $1,
             email = $2,
             password_hash = $3,
             avatar_path = NULL,
             pending_email = NULL,
             status = 'deleted',
             deleted_at = CURRENT_TIMESTAMP,
             token_version = token_version + 1,
             updated_at = CURRENT_TIMESTAMP
         WHERE id = $4",
    )
    .bind(anonymous_username)
    .bind(anonymous_email)
    .bind(unusable_password)
    .bind(id)
    .execute(&mut *transaction)
    .await
    .map_err(AppError::Database)?;

    sqlx::query(
        "UPDATE auth_tokens SET used_at = CURRENT_TIMESTAMP \
         WHERE user_id = $1 AND used_at IS NULL",
    )
    .bind(id)
    .execute(&mut *transaction)
    .await
    .map_err(AppError::Database)?;

    transaction.commit().await.map_err(AppError::Database)?;
    tracing::info!(actor_id, target_id = id, "user deleted by admin");
    Ok(DeleteUserResponse {
        id,
        message: "账号已删除".to_owned(),
    })
}

async fn ensure_more_than_one_active_admin(
    transaction: &mut Transaction<'_, Postgres>,
    action: &str,
) -> Result<(), AppError> {
    let admins: i64 =
        sqlx::query_scalar("SELECT COUNT(*) FROM users WHERE role = 'admin' AND status = 'active'")
            .fetch_one(&mut **transaction)
            .await
            .map_err(AppError::Database)?;
    if admins <= 1 {
        return Err(AppError::ConflictWith(format!(
            "最后一个管理员不能{action}"
        )));
    }
    Ok(())
}

async fn archive_owned_classes(
    transaction: &mut Transaction<'_, Postgres>,
    owner_id: i32,
) -> Result<u64, AppError> {    let result = sqlx::query(
        "UPDATE classes SET archived_at = CURRENT_TIMESTAMP, updated_at = CURRENT_TIMESTAMP \
         WHERE owner_id = $1 AND archived_at IS NULL",
    )
    .bind(owner_id)
    .execute(&mut **transaction)
    .await
    .map_err(AppError::Database)?;
    Ok(result.rows_affected())
}

pub fn validate_role(role: &str) -> Result<(), AppError> {
    match role {
        ROLE_STUDENT | ROLE_TEACHER | ROLE_ADMIN => Ok(()),
        _ => Err(AppError::BadRequest("角色无效".to_owned())),
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
    use super::validate_role;

    #[test]
    fn only_mutually_exclusive_roles_are_accepted() {
        for role in ["student", "teacher", "admin"] {
            assert!(validate_role(role).is_ok(), "{role}");
        }
        assert!(validate_role("user").is_err());
        assert!(validate_role("superadmin").is_err());
    }
}
