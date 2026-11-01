//! 作业成绩申诉：学生提交、教师查询与处理。
//!
//! 设计见 `doc/2611015_成绩申诉与作业统计报表设计方案.md`。
//! 申诉只记录结论，不直接改分；改分仍走批改台并写 `grade.*` 审计。

use chrono::{DateTime, Utc};
use sqlx::{FromRow, PgPool, Postgres, QueryBuilder};

use crate::{
    common::error::AppError,
    middleware::auth::AuthUser,
    models::teaching::{
        ASSIGNMENT_STATUS_PUBLISHED, GradeAppealItem, GradeAppealListResponse, GradeAppealQuery,
        GradeAppealResolveResponse, GradeAppealSubmitResponse, MyGradeAppealResponse,
        ResolveGradeAppealRequest, SubmitGradeAppealRequest,
    },
    services::{
        assignment_policy::{self, ScoreVisibility},
        notification_service,
    },
};

const MAX_APPEAL_REASON_CHARS: usize = 2_000;
const MAX_HANDLE_NOTE_CHARS: usize = 500;
const STATUS_PENDING: &str = "pending";
const STATUS_ACCEPTED: &str = "accepted";
const STATUS_REJECTED: &str = "rejected";

#[derive(Debug, FromRow)]
struct AppealAssignment {
    class_id: i32,
    title: String,
    status: String,
    due_at: Option<DateTime<Utc>>,
    grades_published_at: Option<DateTime<Utc>>,
    score_visibility: String,
    class_owner_id: i32,
}

impl AppealAssignment {
    fn scores_visible(&self) -> bool {
        self.grades_published_at.is_some()
            && assignment_policy::is_score_visible(
                ScoreVisibility::parse(&self.score_visibility)
                    .unwrap_or(ScoreVisibility::AfterPublish),
                Utc::now(),
                self.due_at,
                self.grades_published_at,
            )
    }
}

async fn fetch_assignment(pool: &PgPool, id: i32) -> Result<AppealAssignment, AppError> {
    sqlx::query_as(
        "SELECT a.class_id, a.title, a.status, a.due_at, a.grades_published_at, \
         a.score_visibility, c.owner_id AS class_owner_id \
         FROM assignments a JOIN classes c ON c.id = a.class_id WHERE a.id = $1",
    )
    .bind(id)
    .fetch_optional(pool)
    .await
    .map_err(AppError::Database)?
    .ok_or_else(|| AppError::NotFound("作业不存在".to_owned()))
}

async fn is_active_member(pool: &PgPool, class_id: i32, user_id: i32) -> Result<bool, AppError> {
    sqlx::query_scalar::<_, bool>(
        "SELECT EXISTS(SELECT 1 FROM class_members \
         WHERE class_id = $1 AND user_id = $2 AND status = 'active')",
    )
    .bind(class_id)
    .bind(user_id)
    .fetch_one(pool)
    .await
    .map_err(AppError::Database)
}

async fn access_owned_assignment(
    pool: &PgPool,
    user: &AuthUser,
    id: i32,
) -> Result<AppealAssignment, AppError> {
    if !user.is_teacher() {
        return Err(AppError::ForbiddenWith(
            "只有该组织的教师可以处理成绩申诉".to_owned(),
        ));
    }
    let assignment = fetch_assignment(pool, id).await?;
    if assignment.class_owner_id != user.id {
        return Err(AppError::NotFound("作业不存在".to_owned()));
    }
    Ok(assignment)
}

pub async fn submit(
    pool: &PgPool,
    user: &AuthUser,
    assignment_id: i32,
    input: &SubmitGradeAppealRequest,
) -> Result<GradeAppealSubmitResponse, AppError> {
    if !user.is_student() {
        return Err(AppError::ForbiddenWith(
            "只有学生可以提交成绩申诉".to_owned(),
        ));
    }
    let assignment = fetch_assignment(pool, assignment_id).await?;
    if !is_active_member(pool, assignment.class_id, user.id).await? {
        return Err(AppError::NotFound("作业不存在".to_owned()));
    }
    if assignment.status != ASSIGNMENT_STATUS_PUBLISHED {
        return Err(AppError::Conflict("作业当前状态不能申诉".to_owned()));
    }
    if !assignment.scores_visible() {
        return Err(AppError::Conflict("成绩尚未发布".to_owned()));
    }

    let reason = input.reason.trim();
    if reason.is_empty() {
        return Err(AppError::BadRequest("申诉理由不能为空".to_owned()));
    }
    if reason.chars().count() > MAX_APPEAL_REASON_CHARS {
        return Err(AppError::BadRequest(format!(
            "申诉理由不能超过 {MAX_APPEAL_REASON_CHARS} 字"
        )));
    }

    let mut transaction = pool.begin().await.map_err(AppError::Database)?;
    let appeal_id: Option<i64> = sqlx::query_scalar(
        "INSERT INTO assignment_grade_appeals (assignment_id, user_id, reason) \
         VALUES ($1, $2, $3) ON CONFLICT (assignment_id, user_id) DO NOTHING RETURNING id",
    )
    .bind(assignment_id)
    .bind(user.id)
    .bind(reason)
    .fetch_optional(&mut *transaction)
    .await
    .map_err(AppError::Database)?;
    let appeal_id =
        appeal_id.ok_or_else(|| AppError::ConflictWith("该作业已提交过申诉".to_owned()))?;

    let body = format!("学生对《{}》的成绩提交了申诉，请复核", assignment.title);
    notification_service::create(
        &mut transaction,
        assignment.class_owner_id,
        "grade_appeal_created",
        Some(user.id),
        "学生提交了成绩申诉",
        Some(&body),
        Some(&format!("/assignments/{assignment_id}/grade")),
        Some("assignment"),
        Some(i64::from(assignment_id)),
    )
    .await?;
    transaction.commit().await.map_err(AppError::Database)?;

    Ok(GradeAppealSubmitResponse {
        id: appeal_id,
        status: STATUS_PENDING.to_owned(),
        message: "申诉已提交，等待处理".to_owned(),
    })
}

pub async fn list(
    pool: &PgPool,
    user: &AuthUser,
    assignment_id: i32,
    query: &GradeAppealQuery,
) -> Result<GradeAppealListResponse, AppError> {
    access_owned_assignment(pool, user, assignment_id).await?;
    let status = query
        .status
        .as_deref()
        .map(str::trim)
        .filter(|value| !value.is_empty());
    if let Some(status) = status
        && !matches!(status, STATUS_PENDING | STATUS_ACCEPTED | STATUS_REJECTED)
    {
        return Err(AppError::BadRequest("申诉状态无效".to_owned()));
    }

    let mut builder: QueryBuilder<Postgres> = QueryBuilder::new(
        "SELECT ap.id, ap.assignment_id, ap.user_id, u.username, u.email, ap.reason, \
                ap.status, ap.handle_note, ap.handled_by, hu.username AS handler_username, \
                ap.handled_at, ap.created_at \
         FROM assignment_grade_appeals ap \
         JOIN users u ON u.id = ap.user_id \
         LEFT JOIN users hu ON hu.id = ap.handled_by \
         WHERE ap.assignment_id = ",
    );
    builder.push_bind(assignment_id);
    if let Some(status) = status {
        builder.push(" AND ap.status = ").push_bind(status);
    }
    builder.push(" ORDER BY ap.created_at DESC, ap.id DESC");
    let appeals: Vec<GradeAppealItem> = builder
        .build_query_as()
        .fetch_all(pool)
        .await
        .map_err(AppError::Database)?;
    Ok(GradeAppealListResponse { appeals })
}

pub async fn mine(
    pool: &PgPool,
    user: &AuthUser,
    assignment_id: i32,
) -> Result<MyGradeAppealResponse, AppError> {
    if !user.is_student() {
        return Err(AppError::Forbidden);
    }
    let assignment = fetch_assignment(pool, assignment_id).await?;
    if !is_active_member(pool, assignment.class_id, user.id).await? {
        return Err(AppError::NotFound("作业不存在".to_owned()));
    }
    let appeal = sqlx::query_as::<_, GradeAppealItem>(
        "SELECT ap.id, ap.assignment_id, ap.user_id, u.username, u.email, ap.reason, \
                ap.status, ap.handle_note, ap.handled_by, hu.username AS handler_username, \
                ap.handled_at, ap.created_at \
         FROM assignment_grade_appeals ap \
         JOIN users u ON u.id = ap.user_id \
         LEFT JOIN users hu ON hu.id = ap.handled_by \
         WHERE ap.assignment_id = $1 AND ap.user_id = $2",
    )
    .bind(assignment_id)
    .bind(user.id)
    .fetch_optional(pool)
    .await
    .map_err(AppError::Database)?;
    Ok(MyGradeAppealResponse { appeal })
}

#[derive(Debug, FromRow)]
struct AppealResolveRow {
    user_id: i32,
    status: String,
    assignment_title: String,
}

pub async fn resolve(
    pool: &PgPool,
    user: &AuthUser,
    assignment_id: i32,
    appeal_id: i64,
    input: &ResolveGradeAppealRequest,
) -> Result<GradeAppealResolveResponse, AppError> {
    access_owned_assignment(pool, user, assignment_id).await?;
    let decision = input.decision.trim();
    if !matches!(decision, STATUS_ACCEPTED | STATUS_REJECTED) {
        return Err(AppError::BadRequest(
            "申诉结论只能是 accepted 或 rejected".to_owned(),
        ));
    }
    let note = normalize_note(input.note.as_deref())?;

    let mut transaction = pool.begin().await.map_err(AppError::Database)?;
    let appeal = sqlx::query_as::<_, AppealResolveRow>(
        "SELECT ap.user_id, ap.status, a.title AS assignment_title \
         FROM assignment_grade_appeals ap \
         JOIN assignments a ON a.id = ap.assignment_id \
         WHERE ap.id = $1 AND ap.assignment_id = $2 FOR UPDATE OF ap",
    )
    .bind(appeal_id)
    .bind(assignment_id)
    .fetch_optional(&mut *transaction)
    .await
    .map_err(AppError::Database)?
    .ok_or_else(|| AppError::NotFound("申诉不存在".to_owned()))?;
    if appeal.status != STATUS_PENDING {
        return Err(AppError::Conflict("该申诉已处理".to_owned()));
    }

    sqlx::query(
        "UPDATE assignment_grade_appeals \
         SET status = $2, handled_by = $3, handle_note = $4, handled_at = CURRENT_TIMESTAMP \
         WHERE id = $1",
    )
    .bind(appeal_id)
    .bind(decision)
    .bind(user.id)
    .bind(note.as_deref())
    .execute(&mut *transaction)
    .await
    .map_err(AppError::Database)?;

    let mut body = match decision {
        STATUS_ACCEPTED => format!(
            "老师已受理你对《{}》的成绩申诉，成绩如有调整以批改台最新结果为准",
            appeal.assignment_title
        ),
        _ => format!("老师已驳回你对《{}》的成绩申诉", appeal.assignment_title),
    };
    if let Some(note) = &note {
        body.push_str(&format!("\n说明：{note}"));
    }
    let title = if decision == STATUS_ACCEPTED {
        "成绩申诉已受理"
    } else {
        "成绩申诉已驳回"
    };
    notification_service::create(
        &mut transaction,
        appeal.user_id,
        "grade_appeal_resolved",
        Some(user.id),
        title,
        Some(&body),
        Some(&format!("/assignments/{assignment_id}")),
        Some("assignment"),
        Some(i64::from(assignment_id)),
    )
    .await?;
    transaction.commit().await.map_err(AppError::Database)?;

    let message = if decision == STATUS_ACCEPTED {
        "申诉已受理 请在批改台按需调整分数"
    } else {
        "申诉已驳回"
    };
    Ok(GradeAppealResolveResponse {
        id: appeal_id,
        status: decision.to_owned(),
        message: message.to_owned(),
    })
}

fn normalize_note(value: Option<&str>) -> Result<Option<String>, AppError> {
    let Some(value) = value else {
        return Ok(None);
    };
    let value = value.trim();
    if value.is_empty() {
        return Ok(None);
    }
    if value.chars().count() > MAX_HANDLE_NOTE_CHARS {
        return Err(AppError::BadRequest(format!(
            "处理备注不能超过 {MAX_HANDLE_NOTE_CHARS} 字"
        )));
    }
    Ok(Some(value.to_owned()))
}

#[cfg(test)]
mod tests {
    use super::normalize_note;

    #[test]
    fn note_is_trimmed_and_bounded() {
        assert_eq!(
            normalize_note(Some("  已核对 ")).expect("valid"),
            Some("已核对".to_owned())
        );
        assert_eq!(normalize_note(Some("   ")).expect("valid"), None);
        assert!(normalize_note(Some(&"备注".repeat(300))).is_err());
    }
}
