use chrono::{DateTime, Utc};
use rand::Rng;
use sqlx::{FromRow, PgPool};

use crate::{
    common::error::{AppError, is_unique_violation},
    middleware::auth::AuthUser,
    models::teaching::{
        AddClassMemberRequest, ClassDetail, ClassListResponse, ClassMemberView,
        ClassMutationResponse, ClassOwner, ClassSummary, CreateClassRequest, InviteCodeResponse,
        JoinClassRequest, UpdateClassRequest,
    },
    services::assignment_service,
};

const INVITE_ALPHABET: &[u8] = b"ABCDEFGHJKLMNPQRSTUVWXYZ23456789";
const INVITE_LENGTH: usize = 8;
const MAX_NAME_CHARS: usize = 100;
const MAX_COURSE_CHARS: usize = 100;
const MAX_TERM_CHARS: usize = 30;
const MAX_DESCRIPTION_CHARS: usize = 5_000;

#[derive(Debug, Clone, Copy, PartialEq, Eq)]
pub enum ClassView {
    Owner,
    Student,
}

#[derive(Debug, FromRow)]
struct ClassRow {
    id: i32,
    name: String,
    course_name: Option<String>,
    term: Option<String>,
    description: Option<String>,
    invite_code: String,
    owner_id: i32,
    owner_username: String,
    archived_at: Option<DateTime<Utc>>,
    created_at: DateTime<Utc>,
    member_count: i64,
    assignment_count: i64,
}

impl ClassRow {
    fn relation(&self, view: ClassView) -> &'static str {
        match view {
            ClassView::Owner => "owner",
            ClassView::Student => "student",
        }
    }

    fn owner(&self) -> ClassOwner {
        ClassOwner {
            id: self.owner_id,
            username: self.owner_username.clone(),
        }
    }

    fn summary(&self, view: ClassView) -> ClassSummary {
        ClassSummary {
            id: self.id,
            name: self.name.clone(),
            course_name: self.course_name.clone(),
            term: self.term.clone(),
            description: self.description.clone(),
            owner: self.owner(),
            relation: self.relation(view).to_owned(),
            member_count: self.member_count,
            assignment_count: self.assignment_count,
            archived_at: self.archived_at,
        }
    }
}

fn class_select() -> &'static str {
    "SELECT c.id, c.name, c.course_name, c.term, c.description, c.invite_code, \
     c.owner_id, u.username AS owner_username, c.archived_at, c.created_at, \
     (SELECT COUNT(*) FROM class_members cm WHERE cm.class_id = c.id AND cm.status = 'active') AS member_count, \
     (SELECT COUNT(*) FROM assignments a WHERE a.class_id = c.id) AS assignment_count \
     FROM classes c JOIN users u ON u.id = c.owner_id"
}

async fn fetch_class(pool: &PgPool, class_id: i32) -> Result<ClassRow, AppError> {
    let sql = format!("{} WHERE c.id = $1", class_select());
    sqlx::query_as::<_, ClassRow>(&sql)
        .bind(class_id)
        .fetch_optional(pool)
        .await
        .map_err(AppError::Database)?
        .ok_or_else(|| AppError::NotFound("班级不存在".to_owned()))
}

async fn is_active_member(pool: &PgPool, class_id: i32, user_id: i32) -> Result<bool, AppError> {
    sqlx::query_scalar::<_, bool>(
        "SELECT EXISTS(SELECT 1 FROM class_members WHERE class_id = $1 AND user_id = $2 AND status = 'active')",
    )
    .bind(class_id)
    .bind(user_id)
    .fetch_one(pool)
    .await
    .map_err(AppError::Database)
}

fn forbidden_for_admin(user: &AuthUser) -> Result<(), AppError> {
    if user.is_admin() {
        Err(AppError::Forbidden)
    } else {
        Ok(())
    }
}

fn require_teacher_role(user: &AuthUser) -> Result<(), AppError> {
    if user.is_teacher() {
        Ok(())
    } else if user.is_admin() {
        Err(AppError::Forbidden)
    } else {
        Err(AppError::ForbiddenWith(
            "只有教师账号可以执行该操作".to_owned(),
        ))
    }
}

fn require_student_role(user: &AuthUser) -> Result<(), AppError> {
    if user.is_student() {
        Ok(())
    } else if user.is_admin() {
        Err(AppError::Forbidden)
    } else {
        Err(AppError::ForbiddenWith(
            "只有学生账号可以执行该操作".to_owned(),
        ))
    }
}

async fn access_class(
    pool: &PgPool,
    user: &AuthUser,
    class_id: i32,
) -> Result<(ClassRow, ClassView), AppError> {
    forbidden_for_admin(user)?;
    let class = fetch_class(pool, class_id).await?;
    if user.is_teacher() {
        if class.owner_id == user.id {
            return Ok((class, ClassView::Owner));
        }
        return Err(AppError::NotFound("班级不存在".to_owned()));
    }
    if user.is_student() {
        if is_active_member(pool, class_id, user.id).await? {
            return Ok((class, ClassView::Student));
        }
        return Err(AppError::NotFound("班级不存在".to_owned()));
    }
    Err(AppError::Forbidden)
}

async fn access_owned_class(
    pool: &PgPool,
    user: &AuthUser,
    class_id: i32,
) -> Result<ClassRow, AppError> {
    require_teacher_role(user)?;
    let class = fetch_class(pool, class_id).await?;
    if class.owner_id != user.id {
        return Err(AppError::NotFound("班级不存在".to_owned()));
    }
    Ok(class)
}

pub async fn list_classes(pool: &PgPool, user: &AuthUser) -> Result<ClassListResponse, AppError> {
    forbidden_for_admin(user)?;
    let rows = if user.is_student() {
        let sql = format!(
            "{} JOIN class_members cm ON cm.class_id = c.id \
             WHERE cm.user_id = $1 AND cm.status = 'active' ORDER BY c.created_at DESC, c.id DESC",
            class_select()
        );
        sqlx::query_as::<_, ClassRow>(&sql)
            .bind(user.id)
            .fetch_all(pool)
            .await
    } else if user.is_teacher() {
        let sql = format!(
            "{} WHERE c.owner_id = $1 ORDER BY c.archived_at NULLS FIRST, c.created_at DESC, c.id DESC",
            class_select()
        );
        sqlx::query_as::<_, ClassRow>(&sql)
            .bind(user.id)
            .fetch_all(pool)
            .await
    } else {
        return Err(AppError::Forbidden);
    }
    .map_err(AppError::Database)?;
    let view = if user.is_teacher() {
        ClassView::Owner
    } else {
        ClassView::Student
    };
    Ok(ClassListResponse {
        classes: rows.iter().map(|row| row.summary(view)).collect(),
    })
}

pub async fn create_class(
    pool: &PgPool,
    user: &AuthUser,
    request: &CreateClassRequest,
) -> Result<ClassDetail, AppError> {
    require_teacher_role(user)?;
    let name = normalize_required(&request.name, "班级名称", MAX_NAME_CHARS)?;
    let course_name =
        normalize_optional(request.course_name.as_deref(), MAX_COURSE_CHARS, "课程名称")?;
    let term = normalize_optional(request.term.as_deref(), MAX_TERM_CHARS, "学期")?;
    let description = normalize_optional(
        request.description.as_deref(),
        MAX_DESCRIPTION_CHARS,
        "班级描述",
    )?;

    let mut class_id = None;
    for _ in 0..5 {
        let invite_code = generate_invite_code();
        let result = sqlx::query_scalar::<_, i32>(
            "INSERT INTO classes (name, course_name, term, description, invite_code, owner_id) \
             VALUES ($1, $2, $3, $4, $5, $6) RETURNING id",
        )
        .bind(&name)
        .bind(&course_name)
        .bind(&term)
        .bind(&description)
        .bind(&invite_code)
        .bind(user.id)
        .fetch_one(pool)
        .await;
        match result {
            Ok(id) => {
                class_id = Some(id);
                break;
            }
            Err(error) if is_unique_violation(&error) => continue,
            Err(error) => return Err(AppError::Database(error)),
        }
    }
    let class_id =
        class_id.ok_or_else(|| AppError::Internal("生成班级邀请码失败，请稍后重试".to_owned()))?;
    detail(pool, user, class_id).await
}

pub async fn detail(
    pool: &PgPool,
    user: &AuthUser,
    class_id: i32,
) -> Result<ClassDetail, AppError> {
    let (class, view) = access_class(pool, user, class_id).await?;
    let members = if view == ClassView::Owner {
        Some(load_members(pool, class_id).await?)
    } else {
        None
    };
    let assignments = assignment_service::list_for_class(pool, user, class_id)
        .await?
        .assignments;
    let owner = class.owner();
    let relation = class.relation(view).to_owned();
    Ok(ClassDetail {
        id: class.id,
        name: class.name,
        course_name: class.course_name,
        term: class.term,
        description: class.description,
        owner,
        relation,
        member_count: class.member_count,
        assignment_count: class.assignment_count,
        archived_at: class.archived_at,
        created_at: class.created_at,
        invite_code: (view == ClassView::Owner).then_some(class.invite_code),
        members,
        assignments,
    })
}

pub async fn update_class(
    pool: &PgPool,
    user: &AuthUser,
    class_id: i32,
    request: &UpdateClassRequest,
) -> Result<ClassDetail, AppError> {
    let class = access_owned_class(pool, user, class_id).await?;
    if class.archived_at.is_some() {
        return Err(AppError::Conflict("班级已归档".to_owned()));
    }
    let name = match request.name.as_deref() {
        Some(value) => normalize_required(value, "班级名称", MAX_NAME_CHARS)?,
        None => class.name.clone(),
    };
    let course_name = merge_optional(
        class.course_name.as_deref(),
        request.course_name.as_deref(),
        MAX_COURSE_CHARS,
        "课程名称",
    )?;
    let term = merge_optional(
        class.term.as_deref(),
        request.term.as_deref(),
        MAX_TERM_CHARS,
        "学期",
    )?;
    let description = merge_optional(
        class.description.as_deref(),
        request.description.as_deref(),
        MAX_DESCRIPTION_CHARS,
        "班级描述",
    )?;
    sqlx::query(
        "UPDATE classes SET name = $2, course_name = $3, term = $4, description = $5, updated_at = CURRENT_TIMESTAMP WHERE id = $1",
    )
    .bind(class_id)
    .bind(name)
    .bind(course_name)
    .bind(term)
    .bind(description)
    .execute(pool)
    .await
    .map_err(AppError::Database)?;
    detail(pool, user, class_id).await
}

pub async fn join_class(
    pool: &PgPool,
    user: &AuthUser,
    request: &JoinClassRequest,
) -> Result<ClassSummary, AppError> {
    require_student_role(user)?;
    let code = request.invite_code.trim().to_uppercase();
    if code.len() != INVITE_LENGTH {
        return Err(AppError::BadRequest("邀请码无效".to_owned()));
    }
    let sql = format!("{} WHERE c.invite_code = $1", class_select());
    let class = sqlx::query_as::<_, ClassRow>(&sql)
        .bind(&code)
        .fetch_optional(pool)
        .await
        .map_err(AppError::Database)?
        .ok_or_else(|| AppError::NotFound("邀请码无效".to_owned()))?;
    if class.archived_at.is_some() {
        return Err(AppError::Conflict("班级已归档".to_owned()));
    }
    sqlx::query(
        "INSERT INTO class_members (class_id, user_id, status) VALUES ($1, $2, 'active') \
         ON CONFLICT (class_id, user_id) DO UPDATE SET \
             joined_at = CASE WHEN class_members.status = 'removed' THEN CURRENT_TIMESTAMP ELSE class_members.joined_at END, \
             status = 'active', removed_at = NULL",
    )
    .bind(class.id)
    .bind(user.id)
    .execute(pool)
    .await
    .map_err(AppError::Database)?;
    let class = fetch_class(pool, class.id).await?;
    Ok(class.summary(ClassView::Student))
}

pub async fn add_member(
    pool: &PgPool,
    user: &AuthUser,
    class_id: i32,
    request: &AddClassMemberRequest,
) -> Result<ClassMemberView, AppError> {
    let class = access_owned_class(pool, user, class_id).await?;
    if class.archived_at.is_some() {
        return Err(AppError::Conflict("班级已归档".to_owned()));
    }
    let identifier = request.identifier.trim();
    if identifier.is_empty() {
        return Err(AppError::BadRequest("请输入用户名或邮箱".to_owned()));
    }
    let target: Option<(i32, String, String, String)> = sqlx::query_as(
        "SELECT id, username, email, role FROM users \
         WHERE username = $1 OR LOWER(email) = LOWER($1) \
         ORDER BY (username = $1) DESC, id ASC LIMIT 1",
    )
    .bind(identifier)
    .fetch_optional(pool)
    .await
    .map_err(AppError::Database)?;
    let (target_id, _username, _email, role) =
        target.ok_or_else(|| AppError::NotFound("用户不存在".to_owned()))?;
    if role != "student" {
        return Err(AppError::BadRequest(
            "教师/管理员账号不能加入班级".to_owned(),
        ));
    }
    sqlx::query(
        "INSERT INTO class_members (class_id, user_id, status) VALUES ($1, $2, 'active') \
         ON CONFLICT (class_id, user_id) DO UPDATE SET \
             joined_at = CASE WHEN class_members.status = 'removed' THEN CURRENT_TIMESTAMP ELSE class_members.joined_at END, \
             status = 'active', removed_at = NULL",
    )
    .bind(class_id)
    .bind(target_id)
    .execute(pool)
    .await
    .map_err(AppError::Database)?;
    let member: ClassMemberView = sqlx::query_as(
        "SELECT user_id, username, email, status, joined_at, removed_at \
         FROM class_members cm JOIN users u ON u.id = cm.user_id \
         WHERE cm.class_id = $1 AND cm.user_id = $2",
    )
    .bind(class_id)
    .bind(target_id)
    .fetch_one(pool)
    .await
    .map_err(AppError::Database)?;
    Ok(member)
}

pub async fn remove_member(
    pool: &PgPool,
    user: &AuthUser,
    class_id: i32,
    target_id: i32,
) -> Result<ClassMutationResponse, AppError> {
    let class = access_owned_class(pool, user, class_id).await?;
    if class.archived_at.is_some() {
        return Err(AppError::Conflict("班级已归档".to_owned()));
    }
    let result = sqlx::query(
        "UPDATE class_members SET status = 'removed', removed_at = CURRENT_TIMESTAMP \
         WHERE class_id = $1 AND user_id = $2 AND status = 'active'",
    )
    .bind(class_id)
    .bind(target_id)
    .execute(pool)
    .await
    .map_err(AppError::Database)?;
    if result.rows_affected() == 0 {
        return Err(AppError::NotFound("成员不存在".to_owned()));
    }
    Ok(ClassMutationResponse {
        message: "成员已移除".to_owned(),
    })
}

pub async fn leave_class(
    pool: &PgPool,
    user: &AuthUser,
    class_id: i32,
) -> Result<ClassMutationResponse, AppError> {
    require_student_role(user)?;
    let exists: bool = sqlx::query_scalar("SELECT EXISTS(SELECT 1 FROM classes WHERE id = $1)")
        .bind(class_id)
        .fetch_one(pool)
        .await
        .map_err(AppError::Database)?;
    if !exists {
        return Err(AppError::NotFound("班级不存在".to_owned()));
    }
    let result = sqlx::query(
        "UPDATE class_members SET status = 'removed', removed_at = CURRENT_TIMESTAMP \
         WHERE class_id = $1 AND user_id = $2 AND status = 'active'",
    )
    .bind(class_id)
    .bind(user.id)
    .execute(pool)
    .await
    .map_err(AppError::Database)?;
    if result.rows_affected() == 0 {
        return Err(AppError::NotFound("你不在该班级中".to_owned()));
    }
    Ok(ClassMutationResponse {
        message: "已退出班级".to_owned(),
    })
}

pub async fn rotate_invite_code(
    pool: &PgPool,
    user: &AuthUser,
    class_id: i32,
) -> Result<InviteCodeResponse, AppError> {
    let class = access_owned_class(pool, user, class_id).await?;
    if class.archived_at.is_some() {
        return Err(AppError::Conflict("班级已归档".to_owned()));
    }
    for _ in 0..5 {
        let invite_code = generate_invite_code();
        let result = sqlx::query(
            "UPDATE classes SET invite_code = $2, updated_at = CURRENT_TIMESTAMP WHERE id = $1",
        )
        .bind(class_id)
        .bind(&invite_code)
        .execute(pool)
        .await;
        match result {
            Ok(_) => return Ok(InviteCodeResponse { invite_code }),
            Err(error) if is_unique_violation(&error) => continue,
            Err(error) => return Err(AppError::Database(error)),
        }
    }
    Err(AppError::Internal(
        "生成新的邀请码失败，请稍后重试".to_owned(),
    ))
}

pub async fn archive_class(
    pool: &PgPool,
    user: &AuthUser,
    class_id: i32,
) -> Result<ClassMutationResponse, AppError> {
    let class = access_owned_class(pool, user, class_id).await?;
    if class.archived_at.is_some() {
        return Ok(ClassMutationResponse {
            message: "班级已归档".to_owned(),
        });
    }
    sqlx::query(
        "UPDATE classes SET archived_at = CURRENT_TIMESTAMP, updated_at = CURRENT_TIMESTAMP WHERE id = $1 AND archived_at IS NULL",
    )
    .bind(class_id)
    .execute(pool)
    .await
    .map_err(AppError::Database)?;
    Ok(ClassMutationResponse {
        message: "班级已归档".to_owned(),
    })
}

async fn load_members(pool: &PgPool, class_id: i32) -> Result<Vec<ClassMemberView>, AppError> {
    sqlx::query_as(
        "SELECT cm.user_id, u.username, u.email, cm.status, cm.joined_at, cm.removed_at \
         FROM class_members cm JOIN users u ON u.id = cm.user_id \
         WHERE cm.class_id = $1 ORDER BY cm.status ASC, cm.joined_at ASC, cm.user_id ASC",
    )
    .bind(class_id)
    .fetch_all(pool)
    .await
    .map_err(AppError::Database)
}

fn normalize_required(value: &str, label: &str, max_chars: usize) -> Result<String, AppError> {
    let value = value.trim();
    if value.is_empty() {
        return Err(AppError::BadRequest(format!("{label}不能为空")));
    }
    if value.chars().count() > max_chars {
        return Err(AppError::BadRequest(format!(
            "{label}不能超过 {max_chars} 个字符"
        )));
    }
    Ok(value.to_owned())
}

fn normalize_optional(
    value: Option<&str>,
    max_chars: usize,
    label: &str,
) -> Result<Option<String>, AppError> {
    let Some(value) = value else {
        return Ok(None);
    };
    let value = value.trim();
    if value.is_empty() {
        return Ok(None);
    }
    if value.chars().count() > max_chars {
        return Err(AppError::BadRequest(format!(
            "{label}不能超过 {max_chars} 个字符"
        )));
    }
    Ok(Some(value.to_owned()))
}

fn merge_optional(
    current: Option<&str>,
    next: Option<&str>,
    max_chars: usize,
    label: &str,
) -> Result<Option<String>, AppError> {
    match next {
        Some(value) => normalize_optional(Some(value), max_chars, label),
        None => Ok(current.map(str::to_owned)),
    }
}

fn generate_invite_code() -> String {
    let mut rng = rand::thread_rng();
    (0..INVITE_LENGTH)
        .map(|_| {
            let index = rng.gen_range(0..INVITE_ALPHABET.len());
            INVITE_ALPHABET[index] as char
        })
        .collect()
}

#[cfg(test)]
mod tests {
    use super::{generate_invite_code, normalize_optional, normalize_required};

    #[test]
    fn invite_codes_avoid_ambiguous_characters() {
        for _ in 0..50 {
            let code = generate_invite_code();
            assert_eq!(code.len(), 8);
            assert!(!code.contains(['0', 'O', '1', 'I']));
            assert!(
                code.chars()
                    .all(|c| c.is_ascii_uppercase() || c.is_ascii_digit())
            );
        }
    }

    #[test]
    fn class_names_are_trimmed_and_validated() {
        assert_eq!(
            normalize_required("  算法 1 班 ", "班级名称", 100).expect("valid"),
            "算法 1 班"
        );
        assert!(normalize_required("   ", "班级名称", 100).is_err());
        assert_eq!(
            normalize_optional(Some("  "), 30, "学期").expect("valid"),
            None
        );
    }
}
