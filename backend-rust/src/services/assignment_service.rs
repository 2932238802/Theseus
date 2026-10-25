use std::collections::{HashMap, HashSet};

use chrono::{DateTime, Utc};
use sqlx::{FromRow, PgPool, Postgres, Transaction};

use crate::{
    common::error::AppError,
    middleware::auth::AuthUser,
    models::{
        submission::{SubmissionListResponse, SubmissionSummary},
        teaching::{
            ASSIGNMENT_STATUS_ARCHIVED, ASSIGNMENT_STATUS_DRAFT, ASSIGNMENT_STATUS_PUBLISHED,
            AssignmentDetail, AssignmentListResponse, AssignmentMutationResponse,
            AssignmentProblemInput, AssignmentProblemView, AssignmentProblemsRequest,
            AssignmentSubmissionListQuery, AssignmentSummary, CreateAssignmentRequest,
            UpdateAssignmentRequest,
        },
    },
};

const MAX_TITLE_CHARS: usize = 200;
const MAX_DESCRIPTION_CHARS: usize = 20_000;
const MAX_PROBLEMS: usize = 50;

#[derive(Debug, FromRow)]
struct AssignmentRow {
    id: i32,
    class_id: i32,
    class_name: String,
    title: String,
    description: Option<String>,
    status: String,
    start_at: Option<DateTime<Utc>>,
    due_at: Option<DateTime<Utc>>,
    published_at: Option<DateTime<Utc>>,
    grades_published_at: Option<DateTime<Utc>>,
    class_owner_id: i32,
    class_archived_at: Option<DateTime<Utc>>,
}

#[derive(Debug, FromRow)]
struct SummaryRow {
    id: i32,
    class_id: i32,
    title: String,
    description: Option<String>,
    status: String,
    start_at: Option<DateTime<Utc>>,
    due_at: Option<DateTime<Utc>>,
    published_at: Option<DateTime<Utc>>,
    grades_published_at: Option<DateTime<Utc>>,
    problem_count: i64,
    total_points: i64,
    my_accepted_count: i64,
    my_attempted_count: i64,
    student_count: i64,
    submitted_student_count: i64,
}

impl SummaryRow {
    fn summary(self, include_teacher_stats: bool) -> AssignmentSummary {
        AssignmentSummary {
            id: self.id,
            class_id: self.class_id,
            title: self.title,
            description: self.description,
            status: self.status,
            start_at: self.start_at,
            due_at: self.due_at,
            published_at: self.published_at,
            grades_published_at: self.grades_published_at,
            problem_count: self.problem_count,
            total_points: self.total_points,
            my_accepted_count: self.my_accepted_count,
            my_attempted_count: self.my_attempted_count,
            student_count: include_teacher_stats.then_some(self.student_count),
            submitted_student_count: include_teacher_stats.then_some(self.submitted_student_count),
        }
    }
}

#[derive(Debug, FromRow)]
struct ProblemRow {
    problem_id: i32,
    title: String,
    difficulty: String,
    points: i32,
    position: i32,
    attempts: i64,
    accepted: bool,
    last_status: Option<String>,
    accepted_student_count: i64,
}

#[derive(Debug, FromRow)]
struct GradeRow {
    problem_id: i32,
    manual_score: Option<i32>,
    feedback: Option<String>,
}

fn require_teacher(user: &AuthUser) -> Result<(), AppError> {
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

fn is_visible(status: &str) -> bool {
    status != ASSIGNMENT_STATUS_DRAFT
}

async fn fetch_assignment(pool: &PgPool, id: i32) -> Result<AssignmentRow, AppError> {
    sqlx::query_as::<_, AssignmentRow>(
        "SELECT a.id, a.class_id, c.name AS class_name, a.title, a.description, a.status, \
         a.start_at, a.due_at, a.published_at, a.grades_published_at, \
         c.owner_id AS class_owner_id, c.archived_at AS class_archived_at \
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
        "SELECT EXISTS(SELECT 1 FROM class_members WHERE class_id = $1 AND user_id = $2 AND status = 'active')",
    )
    .bind(class_id)
    .bind(user_id)
    .fetch_one(pool)
    .await
    .map_err(AppError::Database)
}

async fn access_assignment(
    pool: &PgPool,
    user: &AuthUser,
    id: i32,
) -> Result<(AssignmentRow, bool), AppError> {
    if user.is_admin() {
        return Err(AppError::Forbidden);
    }
    let assignment = fetch_assignment(pool, id).await?;
    if user.is_teacher() {
        if assignment.class_owner_id == user.id {
            return Ok((assignment, true));
        }
        return Err(AppError::NotFound("作业不存在".to_owned()));
    }
    if user.is_student() {
        if !is_visible(&assignment.status)
            || !is_active_member(pool, assignment.class_id, user.id).await?
        {
            return Err(AppError::NotFound("作业不存在".to_owned()));
        }
        return Ok((assignment, false));
    }
    Err(AppError::Forbidden)
}

async fn access_owned_assignment(
    pool: &PgPool,
    user: &AuthUser,
    id: i32,
) -> Result<AssignmentRow, AppError> {
    require_teacher(user)?;
    let assignment = fetch_assignment(pool, id).await?;
    if assignment.class_owner_id != user.id {
        return Err(AppError::NotFound("作业不存在".to_owned()));
    }
    Ok(assignment)
}

async fn class_context(
    pool: &PgPool,
    user: &AuthUser,
    class_id: i32,
) -> Result<(i32, Option<DateTime<Utc>>), AppError> {
    if user.is_admin() {
        return Err(AppError::Forbidden);
    }
    let class: Option<(i32, Option<DateTime<Utc>>)> =
        sqlx::query_as("SELECT owner_id, archived_at FROM classes WHERE id = $1")
            .bind(class_id)
            .fetch_optional(pool)
            .await
            .map_err(AppError::Database)?;
    let (owner_id, archived_at) =
        class.ok_or_else(|| AppError::NotFound("班级不存在".to_owned()))?;
    if user.is_teacher() {
        if owner_id == user.id {
            return Ok((owner_id, archived_at));
        }
        return Err(AppError::NotFound("班级不存在".to_owned()));
    }
    if user.is_student() {
        if is_active_member(pool, class_id, user.id).await? {
            return Ok((owner_id, archived_at));
        }
        return Err(AppError::NotFound("班级不存在".to_owned()));
    }
    Err(AppError::Forbidden)
}

fn summary_query() -> &'static str {
    "SELECT a.id, a.class_id, a.title, a.description, a.status, a.start_at, a.due_at, \
     a.published_at, a.grades_published_at, \
     (SELECT COUNT(*) FROM assignment_problems ap WHERE ap.assignment_id = a.id) AS problem_count, \
     COALESCE((SELECT SUM(ap.points)::bigint FROM assignment_problems ap WHERE ap.assignment_id = a.id), 0) AS total_points, \
     (SELECT COUNT(*) FROM assignment_problems ap WHERE ap.assignment_id = a.id AND EXISTS ( \
         SELECT 1 FROM submissions s WHERE s.assignment_id = a.id AND s.user_id = $2 \
           AND s.problem_id = ap.problem_id AND s.status = 'accepted')) AS my_accepted_count, \
     (SELECT COUNT(DISTINCT s.problem_id) FROM submissions s WHERE s.assignment_id = a.id AND s.user_id = $2) AS my_attempted_count, \
     (SELECT COUNT(*) FROM class_members cm WHERE cm.class_id = a.class_id AND cm.status = 'active') AS student_count, \
     (SELECT COUNT(DISTINCT s.user_id) FROM submissions s WHERE s.assignment_id = a.id) AS submitted_student_count \
     FROM assignments a"
}

pub async fn list_for_class(
    pool: &PgPool,
    user: &AuthUser,
    class_id: i32,
) -> Result<AssignmentListResponse, AppError> {
    let (owner_id, _) = class_context(pool, user, class_id).await?;
    let is_owner = user.is_teacher() && owner_id == user.id;
    let sql = if is_owner {
        format!(
            "{} WHERE a.class_id = $1 ORDER BY a.created_at DESC, a.id DESC",
            summary_query()
        )
    } else {
        format!(
            "{} WHERE a.class_id = $1 AND a.status IN ('published', 'archived') \
             ORDER BY a.created_at DESC, a.id DESC",
            summary_query()
        )
    };
    let rows: Vec<SummaryRow> = sqlx::query_as(&sql)
        .bind(class_id)
        .bind(user.id)
        .fetch_all(pool)
        .await
        .map_err(AppError::Database)?;
    Ok(AssignmentListResponse {
        assignments: rows.into_iter().map(|row| row.summary(is_owner)).collect(),
    })
}

pub async fn create(
    pool: &PgPool,
    user: &AuthUser,
    class_id: i32,
    request: &CreateAssignmentRequest,
) -> Result<AssignmentDetail, AppError> {
    let (owner_id, archived_at) = class_context(pool, user, class_id).await?;
    if owner_id != user.id || !user.is_teacher() {
        return Err(AppError::NotFound("班级不存在".to_owned()));
    }
    if archived_at.is_some() {
        return Err(AppError::Conflict("班级已归档".to_owned()));
    }
    let title = normalize_title(&request.title)?;
    let description = normalize_description(request.description.as_deref())?;
    validate_times(request.start_at, request.due_at)?;
    if user.is_student() {
        return Err(AppError::ForbiddenWith(
            "只有教师账号可以创建作业".to_owned(),
        ));
    }
    let problems = validate_problem_inputs(&request.problems)?;
    ensure_problem_eligibility(pool, &problems).await?;

    let mut transaction = pool.begin().await.map_err(AppError::Database)?;
    let id: i32 = sqlx::query_scalar(
        "INSERT INTO assignments (class_id, title, description, start_at, due_at, created_by) \
         VALUES ($1, $2, $3, $4, $5, $6) RETURNING id",
    )
    .bind(class_id)
    .bind(title)
    .bind(description)
    .bind(request.start_at)
    .bind(request.due_at)
    .bind(owner_id)
    .fetch_one(&mut *transaction)
    .await
    .map_err(AppError::Database)?;
    insert_problems(&mut transaction, id, &problems).await?;
    transaction.commit().await.map_err(AppError::Database)?;
    detail(pool, user, id).await
}

pub async fn update(
    pool: &PgPool,
    user: &AuthUser,
    id: i32,
    request: &UpdateAssignmentRequest,
) -> Result<AssignmentDetail, AppError> {
    let assignment = access_owned_assignment(pool, user, id).await?;
    if assignment.status == ASSIGNMENT_STATUS_ARCHIVED {
        return Err(AppError::Conflict("已归档作业不能修改".to_owned()));
    }
    if assignment.class_archived_at.is_some() {
        return Err(AppError::Conflict("班级已归档".to_owned()));
    }
    let mut transaction = pool.begin().await.map_err(AppError::Database)?;
    let current: (String, Option<DateTime<Utc>>, Option<DateTime<Utc>>) =
        sqlx::query_as("SELECT status, start_at, due_at FROM assignments WHERE id = $1 FOR UPDATE")
            .bind(id)
            .fetch_one(&mut *transaction)
            .await
            .map_err(AppError::Database)?;
    let (status, current_start, current_due) = current;

    let title = match request.title.as_deref() {
        Some(value) => normalize_title(value)?,
        None => assignment.title.clone(),
    };
    let description = match request.description.as_deref() {
        Some(value) => normalize_description(Some(value))?,
        None => assignment.description.clone(),
    };

    if status == ASSIGNMENT_STATUS_DRAFT {
        let start_at = request.start_at.or(current_start);
        let due_at = request.due_at.or(current_due);
        validate_times(start_at, due_at)?;
        sqlx::query(
            "UPDATE assignments SET title = $2, description = $3, start_at = $4, due_at = $5, \
             updated_at = CURRENT_TIMESTAMP WHERE id = $1 AND status = 'draft'",
        )
        .bind(id)
        .bind(title)
        .bind(description)
        .bind(start_at)
        .bind(due_at)
        .execute(&mut *transaction)
        .await
        .map_err(AppError::Database)?;
        if let Some(problems) = request.problems.as_ref() {
            let problems = validate_problem_inputs(problems)?;
            ensure_problem_eligibility(&mut *transaction, &problems).await?;
            replace_problems(&mut transaction, id, &problems).await?;
        }
        transaction.commit().await.map_err(AppError::Database)?;
        return detail(pool, user, id).await;
    }

    if status != ASSIGNMENT_STATUS_PUBLISHED {
        return Err(AppError::Conflict("作业当前状态不能修改".to_owned()));
    }
    if request.problems.is_some() {
        return Err(AppError::Conflict("已发布作业不能修改题目".to_owned()));
    }
    if request.start_at.is_some() {
        return Err(AppError::Conflict("已发布作业不能修改开始时间".to_owned()));
    }
    let due_at = match request.due_at {
        Some(new_due) => {
            if current_due.is_some_and(|due| new_due <= due) {
                return Err(AppError::Conflict("已发布作业只能延长截止时间".to_owned()));
            }
            if current_start.is_some_and(|start| new_due <= start) {
                return Err(AppError::BadRequest("截止时间必须晚于开始时间".to_owned()));
            }
            Some(new_due)
        }
        None => current_due,
    };
    sqlx::query(
        "UPDATE assignments SET title = $2, description = $3, due_at = $4, updated_at = CURRENT_TIMESTAMP \
         WHERE id = $1 AND status = 'published'",
    )
    .bind(id)
    .bind(title)
    .bind(description)
    .bind(due_at)
    .execute(&mut *transaction)
    .await
    .map_err(AppError::Database)?;
    transaction.commit().await.map_err(AppError::Database)?;
    detail(pool, user, id).await
}

pub async fn update_problems(
    pool: &PgPool,
    user: &AuthUser,
    id: i32,
    request: &AssignmentProblemsRequest,
) -> Result<AssignmentDetail, AppError> {
    let assignment = access_owned_assignment(pool, user, id).await?;
    if assignment.class_archived_at.is_some() {
        return Err(AppError::Conflict("班级已归档".to_owned()));
    }
    if assignment.status != ASSIGNMENT_STATUS_DRAFT {
        return Err(AppError::Conflict("只能修改草稿作业的题目".to_owned()));
    }
    let problems = validate_problem_inputs(&request.problems)?;
    ensure_problem_eligibility(pool, &problems).await?;
    let mut transaction = pool.begin().await.map_err(AppError::Database)?;
    let locked: Option<String> =
        sqlx::query_scalar("SELECT status FROM assignments WHERE id = $1 FOR UPDATE")
            .bind(id)
            .fetch_optional(&mut *transaction)
            .await
            .map_err(AppError::Database)?;
    if locked.as_deref() != Some(ASSIGNMENT_STATUS_DRAFT) {
        return Err(AppError::Conflict("只能修改草稿作业的题目".to_owned()));
    }
    replace_problems(&mut transaction, id, &problems).await?;
    transaction.commit().await.map_err(AppError::Database)?;
    detail(pool, user, id).await
}

pub async fn publish(
    pool: &PgPool,
    user: &AuthUser,
    id: i32,
) -> Result<AssignmentDetail, AppError> {
    let assignment = access_owned_assignment(pool, user, id).await?;
    if assignment.class_archived_at.is_some() {
        return Err(AppError::Conflict("班级已归档".to_owned()));
    }
    if assignment.status != ASSIGNMENT_STATUS_DRAFT {
        return Err(AppError::Conflict("作业已发布".to_owned()));
    }
    let Some(due_at) = assignment.due_at else {
        return Err(AppError::BadRequest("发布前必须设置截止时间".to_owned()));
    };
    if assignment.start_at.is_some_and(|start| start >= due_at) {
        return Err(AppError::BadRequest("截止时间必须晚于开始时间".to_owned()));
    }
    let problem_ids: Vec<i32> = sqlx::query_scalar(
        "SELECT problem_id FROM assignment_problems WHERE assignment_id = $1 ORDER BY position, problem_id",
    )
    .bind(id)
    .fetch_all(pool)
    .await
    .map_err(AppError::Database)?;
    if problem_ids.is_empty() {
        return Err(AppError::BadRequest("发布前至少选择一道题目".to_owned()));
    }
    ensure_problem_ids_eligible(pool, &problem_ids).await?;

    let mut transaction = pool.begin().await.map_err(AppError::Database)?;
    let updated: Option<(i32, DateTime<Utc>)> = sqlx::query_as(
        "UPDATE assignments SET status = 'published', published_at = CURRENT_TIMESTAMP, \
         updated_at = CURRENT_TIMESTAMP WHERE id = $1 AND status = 'draft' \
         RETURNING id, published_at",
    )
    .bind(id)
    .fetch_optional(&mut *transaction)
    .await
    .map_err(AppError::Database)?;
    if updated.is_none() {
        return Err(AppError::Conflict("作业已发布".to_owned()));
    }
    let title = format!("新作业：{}", assignment.title);
    let link = format!("/assignments/{id}");
    sqlx::query(
        "INSERT INTO notifications (user_id, type, actor_id, title, body, link, related_type, related_id) \
         SELECT cm.user_id, 'assignment_published', $2, $3, $4, $5, 'assignment', $6 \
         FROM class_members cm WHERE cm.class_id = $1 AND cm.status = 'active'",
    )
    .bind(assignment.class_id)
    .bind(user.id)
    .bind(title)
    .bind(&assignment.class_name)
    .bind(link)
    .bind(i64::from(id))
    .execute(&mut *transaction)
    .await
    .map_err(AppError::Database)?;
    transaction.commit().await.map_err(AppError::Database)?;
    detail(pool, user, id).await
}

pub async fn archive(
    pool: &PgPool,
    user: &AuthUser,
    id: i32,
) -> Result<AssignmentDetail, AppError> {
    access_owned_assignment(pool, user, id).await?;
    let result = sqlx::query(
        "UPDATE assignments SET status = 'archived', updated_at = CURRENT_TIMESTAMP \
         WHERE id = $1 AND status = 'published'",
    )
    .bind(id)
    .execute(pool)
    .await
    .map_err(AppError::Database)?;
    if result.rows_affected() == 0 {
        return Err(AppError::Conflict("只有已发布作业可以归档".to_owned()));
    }
    detail(pool, user, id).await
}

pub async fn delete(
    pool: &PgPool,
    user: &AuthUser,
    id: i32,
) -> Result<AssignmentMutationResponse, AppError> {
    access_owned_assignment(pool, user, id).await?;
    let result = sqlx::query("DELETE FROM assignments WHERE id = $1 AND status = 'draft'")
        .bind(id)
        .execute(pool)
        .await
        .map_err(AppError::Database)?;
    if result.rows_affected() == 0 {
        return Err(AppError::Conflict(
            "已发布作业不能删除，请使用归档".to_owned(),
        ));
    }
    Ok(AssignmentMutationResponse {
        id,
        message: "草稿已删除".to_owned(),
    })
}

pub async fn detail(pool: &PgPool, user: &AuthUser, id: i32) -> Result<AssignmentDetail, AppError> {
    let (assignment, is_owner) = access_assignment(pool, user, id).await?;
    let problems: Vec<ProblemRow> = sqlx::query_as(
        "SELECT ap.problem_id, p.title, p.difficulty, ap.points, ap.position, \
         (SELECT COUNT(*) FROM submissions s WHERE s.assignment_id = $1 AND s.user_id = $2 \
             AND s.problem_id = ap.problem_id) AS attempts, \
         EXISTS(SELECT 1 FROM submissions s WHERE s.assignment_id = $1 AND s.user_id = $2 \
             AND s.problem_id = ap.problem_id AND s.status = 'accepted') AS accepted, \
         (SELECT s.status FROM submissions s WHERE s.assignment_id = $1 AND s.user_id = $2 \
             AND s.problem_id = ap.problem_id ORDER BY s.submitted_at DESC, s.id DESC LIMIT 1) AS last_status, \
         (SELECT COUNT(DISTINCT s.user_id) FROM submissions s \
             JOIN class_members cm ON cm.class_id = $3 AND cm.user_id = s.user_id AND cm.status = 'active' \
             WHERE s.assignment_id = $1 AND s.problem_id = ap.problem_id AND s.status = 'accepted') AS accepted_student_count \
         FROM assignment_problems ap JOIN problems p ON p.id = ap.problem_id \
         WHERE ap.assignment_id = $1 ORDER BY ap.position, ap.problem_id",
    )
    .bind(id)
    .bind(user.id)
    .bind(assignment.class_id)
    .fetch_all(pool)
    .await
    .map_err(AppError::Database)?;

    let grades_visible = !is_owner && assignment.grades_published_at.is_some();
    let grades: HashMap<i32, (Option<i32>, Option<String>)> = if grades_visible {
        sqlx::query_as::<_, GradeRow>(
            "SELECT problem_id, manual_score, feedback FROM assignment_problem_grades \
             WHERE assignment_id = $1 AND user_id = $2",
        )
        .bind(id)
        .bind(user.id)
        .fetch_all(pool)
        .await
        .map_err(AppError::Database)?
        .into_iter()
        .map(|row| (row.problem_id, (row.manual_score, row.feedback)))
        .collect()
    } else {
        HashMap::new()
    };
    let overall_feedback: Option<String> = if grades_visible {
        sqlx::query_scalar(
            "SELECT overall_feedback FROM assignment_results WHERE assignment_id = $1 AND user_id = $2",
        )
        .bind(id)
        .bind(user.id)
        .fetch_optional(pool)
        .await
        .map_err(AppError::Database)?
        .flatten()
    } else {
        None
    };

    let mut total_score = 0;
    let views: Vec<AssignmentProblemView> = problems
        .into_iter()
        .map(|row| {
            let auto_score = if row.accepted { row.points } else { 0 };
            let (manual_score, feedback) =
                grades.get(&row.problem_id).cloned().unwrap_or((None, None));
            let final_score = manual_score.unwrap_or(auto_score);
            total_score += final_score;
            AssignmentProblemView {
                problem_id: row.problem_id,
                title: row.title,
                difficulty: row.difficulty,
                points: row.points,
                position: row.position,
                attempts: row.attempts,
                accepted: row.accepted,
                last_status: row.last_status,
                auto_score: grades_visible.then_some(auto_score),
                manual_score: grades_visible.then_some(manual_score).flatten(),
                final_score: grades_visible.then_some(final_score),
                feedback,
                accepted_student_count: is_owner.then_some(row.accepted_student_count),
            }
        })
        .collect();

    let student_count = if is_owner {
        Some(
            sqlx::query_scalar::<_, i64>(
                "SELECT COUNT(*) FROM class_members WHERE class_id = $1 AND status = 'active'",
            )
            .bind(assignment.class_id)
            .fetch_one(pool)
            .await
            .map_err(AppError::Database)?,
        )
    } else {
        None
    };
    let submitted_student_count = if is_owner {
        Some(
            sqlx::query_scalar::<_, i64>(
                "SELECT COUNT(DISTINCT user_id) FROM submissions WHERE assignment_id = $1",
            )
            .bind(id)
            .fetch_one(pool)
            .await
            .map_err(AppError::Database)?,
        )
    } else {
        None
    };
    let now = Utc::now();
    let can_submit = !is_owner
        && user.is_student()
        && assignment.status == ASSIGNMENT_STATUS_PUBLISHED
        && assignment.class_archived_at.is_none()
        && assignment.start_at.is_none_or(|start| now >= start)
        && assignment.due_at.is_some_and(|due| now <= due);

    Ok(AssignmentDetail {
        id: assignment.id,
        class_id: assignment.class_id,
        class_name: assignment.class_name,
        title: assignment.title,
        description: assignment.description,
        status: assignment.status,
        start_at: assignment.start_at,
        due_at: assignment.due_at,
        published_at: assignment.published_at,
        grades_published_at: assignment.grades_published_at,
        grades_published: assignment.grades_published_at.is_some(),
        now,
        is_owner,
        can_submit,
        problems: views,
        total_score: grades_visible.then_some(total_score),
        overall_feedback,
        student_count,
        submitted_student_count,
    })
}

pub async fn list_submissions(
    pool: &PgPool,
    user: &AuthUser,
    id: i32,
    query: &AssignmentSubmissionListQuery,
) -> Result<SubmissionListResponse, AppError> {
    access_owned_assignment(pool, user, id).await?;
    let page = query.page.unwrap_or(1).max(1);
    let size = query.size.unwrap_or(20).clamp(1, 50);
    let offset = i64::from(page - 1) * i64::from(size);

    let total: i64 = match (query.user_id, query.problem_id) {
        (Some(user_id), Some(problem_id)) => sqlx::query_scalar(
            "SELECT COUNT(*) FROM submissions WHERE assignment_id = $1 AND user_id = $2 AND problem_id = $3",
        )
        .bind(id)
        .bind(user_id)
        .bind(problem_id)
        .fetch_one(pool)
        .await,
        (Some(user_id), None) => sqlx::query_scalar(
            "SELECT COUNT(*) FROM submissions WHERE assignment_id = $1 AND user_id = $2",
        )
        .bind(id)
        .bind(user_id)
        .fetch_one(pool)
        .await,
        (None, Some(problem_id)) => sqlx::query_scalar(
            "SELECT COUNT(*) FROM submissions WHERE assignment_id = $1 AND problem_id = $2",
        )
        .bind(id)
        .bind(problem_id)
        .fetch_one(pool)
        .await,
        (None, None) => {
            sqlx::query_scalar("SELECT COUNT(*) FROM submissions WHERE assignment_id = $1")
                .bind(id)
                .fetch_one(pool)
                .await
        }
    }
    .map_err(AppError::Database)?;

    let base = "SELECT s.id, s.problem_id, p.title AS problem_title, s.language, s.status, \
                s.test_cases_passed, s.total_test_cases, s.runtime, s.memory, s.error_message, s.submitted_at \
                FROM submissions s JOIN problems p ON p.id = s.problem_id \
                WHERE s.assignment_id = $1";
    let submissions: Vec<SubmissionSummary> = match (query.user_id, query.problem_id) {
        (Some(user_id), Some(problem_id)) => {
            let sql = format!(
                "{base} AND s.user_id = $2 AND s.problem_id = $3 ORDER BY s.submitted_at DESC, s.id DESC LIMIT $4 OFFSET $5"
            );
            sqlx::query_as(&sql)
                .bind(id)
                .bind(user_id)
                .bind(problem_id)
                .bind(size as i64)
                .bind(offset)
                .fetch_all(pool)
                .await
        }
        (Some(user_id), None) => {
            let sql = format!(
                "{base} AND s.user_id = $2 ORDER BY s.submitted_at DESC, s.id DESC LIMIT $3 OFFSET $4"
            );
            sqlx::query_as(&sql)
                .bind(id)
                .bind(user_id)
                .bind(size as i64)
                .bind(offset)
                .fetch_all(pool)
                .await
        }
        (None, Some(problem_id)) => {
            let sql = format!(
                "{base} AND s.problem_id = $2 ORDER BY s.submitted_at DESC, s.id DESC LIMIT $3 OFFSET $4"
            );
            sqlx::query_as(&sql)
                .bind(id)
                .bind(problem_id)
                .bind(size as i64)
                .bind(offset)
                .fetch_all(pool)
                .await
        }
        (None, None) => {
            let sql = format!(
                "{base} ORDER BY s.submitted_at DESC, s.id DESC LIMIT $2 OFFSET $3"
            );
            sqlx::query_as(&sql)
                .bind(id)
                .bind(size as i64)
                .bind(offset)
                .fetch_all(pool)
                .await
        }
    }
    .map_err(AppError::Database)?;

    Ok(SubmissionListResponse {
        total,
        page,
        size,
        submissions,
    })
}

fn normalize_title(value: &str) -> Result<String, AppError> {
    let value = value.trim();
    if value.is_empty() {
        return Err(AppError::BadRequest("作业标题不能为空".to_owned()));
    }
    if value.chars().count() > MAX_TITLE_CHARS {
        return Err(AppError::BadRequest(format!(
            "作业标题不能超过 {MAX_TITLE_CHARS} 个字符"
        )));
    }
    Ok(value.to_owned())
}

fn normalize_description(value: Option<&str>) -> Result<Option<String>, AppError> {
    let Some(value) = value else {
        return Ok(None);
    };
    let value = value.trim();
    if value.is_empty() {
        return Ok(None);
    }
    if value.chars().count() > MAX_DESCRIPTION_CHARS {
        return Err(AppError::BadRequest(format!(
            "作业描述不能超过 {MAX_DESCRIPTION_CHARS} 个字符"
        )));
    }
    Ok(Some(value.to_owned()))
}

fn validate_times(
    start_at: Option<DateTime<Utc>>,
    due_at: Option<DateTime<Utc>>,
) -> Result<(), AppError> {
    if let (Some(start), Some(due)) = (start_at, due_at)
        && due <= start
    {
        return Err(AppError::BadRequest("截止时间必须晚于开始时间".to_owned()));
    }
    Ok(())
}

fn validate_problem_inputs(
    problems: &[AssignmentProblemInput],
) -> Result<Vec<AssignmentProblemInput>, AppError> {
    if problems.len() > MAX_PROBLEMS {
        return Err(AppError::BadRequest(format!(
            "每份作业最多 {MAX_PROBLEMS} 道题"
        )));
    }
    let mut seen = HashSet::new();
    let mut normalized = Vec::with_capacity(problems.len());
    for problem in problems {
        if problem.problem_id <= 0 {
            return Err(AppError::BadRequest("题目 ID 无效".to_owned()));
        }
        if !(1..=1000).contains(&problem.points) {
            return Err(AppError::BadRequest(
                "每题分值必须在 1 到 1000 之间".to_owned(),
            ));
        }
        if !seen.insert(problem.problem_id) {
            return Err(AppError::BadRequest(
                "同一作业不能重复添加同一题目".to_owned(),
            ));
        }
        normalized.push(problem.clone());
    }
    Ok(normalized)
}

async fn ensure_problem_eligibility(
    executor: impl sqlx::PgExecutor<'_>,
    problems: &[AssignmentProblemInput],
) -> Result<(), AppError> {
    if problems.is_empty() {
        return Ok(());
    }
    let ids: Vec<i32> = problems.iter().map(|problem| problem.problem_id).collect();
    ensure_problem_ids_eligible(executor, &ids).await
}

async fn ensure_problem_ids_eligible(
    executor: impl sqlx::PgExecutor<'_>,
    ids: &[i32],
) -> Result<(), AppError> {
    let eligible: Vec<i32> = sqlx::query_scalar(
        "SELECT id FROM problems WHERE id = ANY($1) AND review_status = 'approved' \
         AND run_config IS NOT NULL AND judge_cases IS NOT NULL \
         AND jsonb_typeof(judge_cases) = 'array' AND jsonb_array_length(judge_cases) > 0",
    )
    .bind(ids)
    .fetch_all(executor)
    .await
    .map_err(AppError::Database)?;
    if eligible.len() != ids.len() {
        return Err(AppError::BadRequest(
            "作业只能选择已审核且配置了完整评测用例的题目".to_owned(),
        ));
    }
    Ok(())
}

async fn insert_problems(
    transaction: &mut Transaction<'_, Postgres>,
    assignment_id: i32,
    problems: &[AssignmentProblemInput],
) -> Result<(), AppError> {
    for (position, problem) in problems.iter().enumerate() {
        sqlx::query(
            "INSERT INTO assignment_problems (assignment_id, problem_id, position, points) \
             VALUES ($1, $2, $3, $4)",
        )
        .bind(assignment_id)
        .bind(problem.problem_id)
        .bind(position as i32)
        .bind(problem.points)
        .execute(&mut **transaction)
        .await
        .map_err(AppError::Database)?;
    }
    Ok(())
}

async fn replace_problems(
    transaction: &mut Transaction<'_, Postgres>,
    assignment_id: i32,
    problems: &[AssignmentProblemInput],
) -> Result<(), AppError> {
    sqlx::query("DELETE FROM assignment_problems WHERE assignment_id = $1")
        .bind(assignment_id)
        .execute(&mut **transaction)
        .await
        .map_err(AppError::Database)?;
    insert_problems(transaction, assignment_id, problems).await
}

#[cfg(test)]
mod tests {
    use super::validate_problem_inputs;
    use crate::models::teaching::AssignmentProblemInput;

    #[test]
    fn rejects_duplicate_problem_ids() {
        let problems = vec![
            AssignmentProblemInput {
                problem_id: 1,
                points: 100,
            },
            AssignmentProblemInput {
                problem_id: 1,
                points: 100,
            },
        ];
        assert!(validate_problem_inputs(&problems).is_err());
    }

    #[test]
    fn validates_points_range() {
        for points in [0, 1001] {
            let problems = vec![AssignmentProblemInput {
                problem_id: 1,
                points,
            }];
            assert!(validate_problem_inputs(&problems).is_err());
        }
    }
}
