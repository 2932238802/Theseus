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
            AssignmentStatsProblem, AssignmentStatsResponse, AssignmentSubmissionListQuery,
            AssignmentSummary, CreateAssignmentRequest, OverrideItem, OverrideListResponse,
            PeerSubmissionItem, PeerSubmissionListResponse, PolicyAuditItem,
            PolicyAuditListResponse, PublishSolutionsResponse, UpdateAssignmentRequest,
            UpdateOverrideRequest,
        },
    },
    services::assignment_policy::{
        self as policy, ScoreVisibility, ScoringPolicy, StudentOverride, effective_deadline,
        is_score_visible, is_solution_visible, submission_window_end,
    },
    services::grade_service,
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
    late_policy: String,
    late_grace_hours: i32,
    late_penalty_per_day: i32,
    late_penalty_cap: i32,
    max_attempts: Option<i32>,
    scoring_policy: String,
    score_visibility: String,
    solutions_published_at: Option<DateTime<Utc>>,
    allow_peer_code: bool,
    show_class_stats: bool,
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
    max_attempts: Option<i32>,
    solution_md: Option<String>,
}

#[derive(Debug, FromRow)]
struct GradeRow {
    problem_id: i32,
    manual_score: Option<i32>,
    feedback: Option<String>,
}

#[derive(Debug, FromRow, Clone)]
struct OverrideRow {
    problem_id: i32,
    makeup_due_at: Option<DateTime<Utc>>,
    waive_late_penalty: bool,
    exempt: bool,
    exemption_mode: Option<String>,
}

impl OverrideRow {
    fn as_policy_override(&self) -> StudentOverride {
        StudentOverride {
            makeup_due_at: self.makeup_due_at,
            waive_late_penalty: self.waive_late_penalty,
            exempt: self.exempt,
            exemption_mode: self.exemption_mode.clone(),
        }
    }
}

#[derive(Debug, FromRow)]
struct AttemptRow {
    id: i32,
    problem_id: i32,
    status: String,
    submitted_at: DateTime<Utc>,
    is_late: bool,
    late_days: i32,
}

impl AttemptRow {
    fn as_scoring_submission(&self) -> policy::ScoringSubmission {
        policy::ScoringSubmission {
            id: self.id,
            status: self.status.clone(),
            submitted_at: self.submitted_at,
            is_late: self.is_late,
            late_days: self.late_days,
        }
    }
}

#[derive(Debug, Clone)]
struct PolicyValues {
    late_policy: String,
    late_grace_hours: i32,
    late_penalty_per_day: i32,
    late_penalty_cap: i32,
    max_attempts: Option<i32>,
    scoring_policy: String,
    score_visibility: String,
    allow_peer_code: bool,
    show_class_stats: bool,
}

impl PolicyValues {
    fn from_create(request: &CreateAssignmentRequest) -> Result<Self, AppError> {
        Self::validate(
            request
                .late_policy
                .clone()
                .unwrap_or_else(|| policy::LATE_POLICY_FORBID.to_owned()),
            request.late_grace_hours.unwrap_or(0),
            request.late_penalty_per_day.unwrap_or(10),
            request.late_penalty_cap.unwrap_or(50),
            request.max_attempts,
            request
                .scoring_policy
                .clone()
                .unwrap_or_else(|| policy::SCORING_HIGHEST.to_owned()),
            request
                .score_visibility
                .clone()
                .unwrap_or_else(|| policy::SCORE_VISIBILITY_AFTER_PUBLISH.to_owned()),
            request.allow_peer_code.unwrap_or(false),
            request.show_class_stats.unwrap_or(false),
        )
    }

    fn from_update(
        request: &UpdateAssignmentRequest,
        current: &AssignmentRow,
    ) -> Result<Self, AppError> {
        Self::validate(
            request
                .late_policy
                .clone()
                .unwrap_or_else(|| current.late_policy.clone()),
            request.late_grace_hours.unwrap_or(current.late_grace_hours),
            request
                .late_penalty_per_day
                .unwrap_or(current.late_penalty_per_day),
            request.late_penalty_cap.unwrap_or(current.late_penalty_cap),
            request.max_attempts.or(current.max_attempts),
            request
                .scoring_policy
                .clone()
                .unwrap_or_else(|| current.scoring_policy.clone()),
            request
                .score_visibility
                .clone()
                .unwrap_or_else(|| current.score_visibility.clone()),
            request.allow_peer_code.unwrap_or(current.allow_peer_code),
            request.show_class_stats.unwrap_or(current.show_class_stats),
        )
    }

    #[allow(clippy::too_many_arguments)]
    fn validate(
        late_policy: String,
        late_grace_hours: i32,
        late_penalty_per_day: i32,
        late_penalty_cap: i32,
        max_attempts: Option<i32>,
        scoring_policy: String,
        score_visibility: String,
        allow_peer_code: bool,
        show_class_stats: bool,
    ) -> Result<Self, AppError> {
        if !matches!(
            late_policy.as_str(),
            policy::LATE_POLICY_FORBID | policy::LATE_POLICY_ALLOW
        ) {
            return Err(AppError::BadRequest("迟交策略值非法".to_owned()));
        }
        if !(0..=720).contains(&late_grace_hours) {
            return Err(AppError::BadRequest(
                "迟交宽限小时必须在 0 到 720 之间".to_owned(),
            ));
        }
        if !(0..=100).contains(&late_penalty_per_day) {
            return Err(AppError::BadRequest(
                "每日迟交扣分必须在 0 到 100 之间".to_owned(),
            ));
        }
        if !(0..=100).contains(&late_penalty_cap) {
            return Err(AppError::BadRequest(
                "迟交扣分封顶必须在 0 到 100 之间".to_owned(),
            ));
        }
        if max_attempts.is_some_and(|value| !(1..=1000).contains(&value)) {
            return Err(AppError::BadRequest(
                "提交次数上限必须在 1 到 1000 之间".to_owned(),
            ));
        }
        if ScoringPolicy::parse(&scoring_policy).is_none() {
            return Err(AppError::BadRequest("计分策略值非法".to_owned()));
        }
        if ScoreVisibility::parse(&score_visibility).is_none() {
            return Err(AppError::BadRequest("成绩可见性值非法".to_owned()));
        }
        Ok(Self {
            late_policy,
            late_grace_hours,
            late_penalty_per_day,
            late_penalty_cap,
            max_attempts,
            scoring_policy,
            score_visibility,
            allow_peer_code,
            show_class_stats,
        })
    }
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
         a.late_policy, a.late_grace_hours, a.late_penalty_per_day, a.late_penalty_cap, \
         a.max_attempts, a.scoring_policy, a.score_visibility, a.solutions_published_at, \
         a.allow_peer_code, a.show_class_stats, \
         c.owner_id AS class_owner_id, c.archived_at AS class_archived_at \
         FROM assignments a JOIN classes c ON c.id = a.class_id WHERE a.id = $1",
    )
    .bind(id)
    .fetch_optional(pool)
    .await
    .map_err(AppError::Database)?
    .ok_or_else(|| AppError::NotFound("作业不存在".to_owned()))
}

async fn fetch_assignment_locked(
    transaction: &mut Transaction<'_, Postgres>,
    id: i32,
) -> Result<AssignmentRow, AppError> {
    sqlx::query_as::<_, AssignmentRow>(
        "SELECT a.id, a.class_id, c.name AS class_name, a.title, a.description, a.status, \
         a.start_at, a.due_at, a.published_at, a.grades_published_at, \
         a.late_policy, a.late_grace_hours, a.late_penalty_per_day, a.late_penalty_cap, \
         a.max_attempts, a.scoring_policy, a.score_visibility, a.solutions_published_at, \
         a.allow_peer_code, a.show_class_stats, \
         c.owner_id AS class_owner_id, c.archived_at AS class_archived_at \
         FROM assignments a JOIN classes c ON c.id = a.class_id WHERE a.id = $1 \
         FOR UPDATE OF a",
    )
    .bind(id)
    .fetch_optional(&mut **transaction)
    .await
    .map_err(AppError::Database)?
    .ok_or_else(|| AppError::NotFound("作业不存在".to_owned()))
}

async fn insert_audit(
    transaction: &mut Transaction<'_, Postgres>,
    assignment_id: i32,
    actor_id: i32,
    action: &str,
    before_data: Option<serde_json::Value>,
    after_data: Option<serde_json::Value>,
    reason: Option<&str>,
) -> Result<(), AppError> {
    sqlx::query(
        "INSERT INTO assignment_policy_audits \
         (assignment_id, actor_id, action, before_data, after_data, reason) \
         VALUES ($1, $2, $3, $4, $5, $6)",
    )
    .bind(assignment_id)
    .bind(actor_id)
    .bind(action)
    .bind(before_data)
    .bind(after_data)
    .bind(reason)
    .execute(&mut **transaction)
    .await
    .map_err(AppError::Database)?;
    Ok(())
}

#[allow(clippy::too_many_arguments)]
async fn notify_class_students(
    transaction: &mut Transaction<'_, Postgres>,
    class_id: i32,
    actor_id: i32,
    notification_type: &str,
    title: &str,
    body: &str,
    link: &str,
    assignment_id: i32,
) -> Result<(), AppError> {
    sqlx::query(
        "INSERT INTO notifications (user_id, type, actor_id, title, body, link, related_type, related_id) \
         SELECT cm.user_id, $2, $3, $4, $5, $6, 'assignment', $7 \
         FROM class_members cm WHERE cm.class_id = $1 AND cm.status = 'active'",
    )
    .bind(class_id)
    .bind(notification_type)
    .bind(actor_id)
    .bind(title)
    .bind(body)
    .bind(link)
    .bind(i64::from(assignment_id))
    .execute(&mut **transaction)
    .await
    .map_err(AppError::Database)?;
    Ok(())
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
    let policy = PolicyValues::from_create(request)?;

    let mut transaction = pool.begin().await.map_err(AppError::Database)?;
    let id: i32 = sqlx::query_scalar(
        "INSERT INTO assignments (class_id, title, description, start_at, due_at, created_by, \
         late_policy, late_grace_hours, late_penalty_per_day, late_penalty_cap, max_attempts, \
         scoring_policy, score_visibility, allow_peer_code, show_class_stats) \
         VALUES ($1, $2, $3, $4, $5, $6, $7, $8, $9, $10, $11, $12, $13, $14, $15) RETURNING id",
    )
    .bind(class_id)
    .bind(title)
    .bind(description)
    .bind(request.start_at)
    .bind(request.due_at)
    .bind(owner_id)
    .bind(&policy.late_policy)
    .bind(policy.late_grace_hours)
    .bind(policy.late_penalty_per_day)
    .bind(policy.late_penalty_cap)
    .bind(policy.max_attempts)
    .bind(&policy.scoring_policy)
    .bind(&policy.score_visibility)
    .bind(policy.allow_peer_code)
    .bind(policy.show_class_stats)
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
    let policy = PolicyValues::from_update(request, &assignment)?;

    let mut transaction = pool.begin().await.map_err(AppError::Database)?;
    let current = fetch_assignment_locked(&mut transaction, id).await?;
    let title = match request.title.as_deref() {
        Some(value) => normalize_title(value)?,
        None => current.title.clone(),
    };
    let description = match request.description.as_deref() {
        Some(value) => normalize_description(Some(value))?,
        None => current.description.clone(),
    };

    if current.status == ASSIGNMENT_STATUS_DRAFT {
        let start_at = request.start_at.or(current.start_at);
        let due_at = request.due_at.or(current.due_at);
        validate_times(start_at, due_at)?;
        sqlx::query(
            "UPDATE assignments SET title = $2, description = $3, start_at = $4, due_at = $5, \
             late_policy = $6, late_grace_hours = $7, late_penalty_per_day = $8, \
             late_penalty_cap = $9, max_attempts = $10, scoring_policy = $11, \
             score_visibility = $12, allow_peer_code = $13, show_class_stats = $14, \
             updated_at = CURRENT_TIMESTAMP WHERE id = $1 AND status = 'draft'",
        )
        .bind(id)
        .bind(title)
        .bind(description)
        .bind(start_at)
        .bind(due_at)
        .bind(&policy.late_policy)
        .bind(policy.late_grace_hours)
        .bind(policy.late_penalty_per_day)
        .bind(policy.late_penalty_cap)
        .bind(policy.max_attempts)
        .bind(&policy.scoring_policy)
        .bind(&policy.score_visibility)
        .bind(policy.allow_peer_code)
        .bind(policy.show_class_stats)
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

    if current.status != ASSIGNMENT_STATUS_PUBLISHED {
        return Err(AppError::Conflict("作业当前状态不能修改".to_owned()));
    }
    if request.problems.is_some() {
        return Err(AppError::Conflict("已发布作业不能修改题目".to_owned()));
    }
    if request.start_at.is_some() {
        return Err(AppError::Conflict("已发布作业不能修改开始时间".to_owned()));
    }
    if request.late_policy.is_some()
        || request.late_grace_hours.is_some()
        || request.late_penalty_per_day.is_some()
        || request.late_penalty_cap.is_some()
        || request.max_attempts.is_some()
        || request.scoring_policy.is_some()
        || request.score_visibility.is_some()
        || request.allow_peer_code.is_some()
        || request.show_class_stats.is_some()
    {
        return Err(AppError::Conflict(
            "作业已发布，计分、次数、迟交和可见性策略不可修改".to_owned(),
        ));
    }
    let due_at = match request.due_at {
        Some(new_due) => {
            if current.due_at.is_some_and(|due| new_due <= due) {
                return Err(AppError::Conflict("已发布作业只能延长截止时间".to_owned()));
            }
            if current.start_at.is_some_and(|start| new_due <= start) {
                return Err(AppError::BadRequest("截止时间必须晚于开始时间".to_owned()));
            }
            Some(new_due)
        }
        None => current.due_at,
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

    if due_at != current.due_at {
        insert_audit(
            &mut transaction,
            id,
            user.id,
            "due_extended",
            Some(serde_json::json!({ "due_at": current.due_at })),
            Some(serde_json::json!({ "due_at": due_at })),
            None,
        )
        .await?;
        let title = format!("作业截止时间已延长：{}", current.title);
        let link = format!("/assignments/{id}");
        notify_class_students(
            &mut transaction,
            current.class_id,
            user.id,
            "assignment_due_extended",
            &title,
            &current.class_name,
            &link,
            id,
        )
        .await?;
    }
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
    let now = Utc::now();
    let problems: Vec<ProblemRow> = sqlx::query_as(
        "SELECT ap.problem_id, p.title, p.difficulty, ap.points, ap.position, ap.max_attempts, \
         ap.solution_md, \
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

    let override_rows: Vec<OverrideRow> = sqlx::query_as(
        "SELECT problem_id, makeup_due_at, waive_late_penalty, exempt, exemption_mode \
         FROM assignment_student_overrides WHERE assignment_id = $1 AND user_id = $2",
    )
    .bind(id)
    .bind(user.id)
    .fetch_all(pool)
    .await
    .map_err(AppError::Database)?;
    let override_map: HashMap<i32, OverrideRow> = override_rows
        .into_iter()
        .map(|row| (row.problem_id, row))
        .collect();

    let attempt_rows: Vec<AttemptRow> = sqlx::query_as(
        "SELECT id, problem_id, status, submitted_at, is_late, late_days \
         FROM submissions WHERE assignment_id = $1 AND user_id = $2 \
         ORDER BY submitted_at, id",
    )
    .bind(id)
    .bind(user.id)
    .fetch_all(pool)
    .await
    .map_err(AppError::Database)?;
    let mut attempts_by_problem: HashMap<i32, Vec<policy::ScoringSubmission>> = HashMap::new();
    for row in attempt_rows {
        attempts_by_problem
            .entry(row.problem_id)
            .or_default()
            .push(row.as_scoring_submission());
    }

    let score_visibility = ScoreVisibility::parse(&assignment.score_visibility)
        .unwrap_or(ScoreVisibility::AfterPublish);
    let grades_visible = is_owner
        || is_score_visible(
            score_visibility,
            now,
            assignment.due_at,
            assignment.grades_published_at,
        );
    let solutions_visible =
        is_solution_visible(now, assignment.due_at, assignment.solutions_published_at);
    let scoring_policy =
        ScoringPolicy::parse(&assignment.scoring_policy).unwrap_or(ScoringPolicy::Highest);

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
    let overall_feedback: Option<String> = if assignment.grades_published_at.is_some() {
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
    let mut computed_total = 0;
    let views: Vec<AssignmentProblemView> = problems
        .into_iter()
        .map(|row| {
            let student_override = override_map.get(&row.problem_id);
            let (manual_score, feedback) =
                grades.get(&row.problem_id).cloned().unwrap_or((None, None));
            let empty: Vec<policy::ScoringSubmission> = Vec::new();
            let submissions = attempts_by_problem.get(&row.problem_id).unwrap_or(&empty);
            let grade = policy::compute_problem_grade(
                row.points,
                submissions,
                manual_score,
                student_override
                    .map(OverrideRow::as_policy_override)
                    .as_ref(),
                scoring_policy,
                assignment.late_penalty_per_day,
                assignment.late_penalty_cap,
            );
            let attempts_limit = row.max_attempts.or(assignment.max_attempts);
            let attempts_left = attempts_limit.map(|limit| (limit - row.attempts as i32).max(0));
            computed_total += if grade.included_in_total {
                grade.final_score
            } else {
                0
            };
            if grades_visible && grade.included_in_total {
                total_score += grade.final_score;
            }
            let late_deduction = if grade.is_late {
                (row.points - grade.auto_score).max(0)
            } else {
                0
            };
            AssignmentProblemView {
                problem_id: row.problem_id,
                title: row.title,
                difficulty: row.difficulty,
                points: row.points,
                position: row.position,
                attempts: row.attempts,
                attempts_limit,
                attempts_left,
                accepted: row.accepted,
                last_status: row.last_status,
                is_late: grade.is_late,
                late_days: grade.late_days,
                late_deduction,
                exempt: grade.exempt,
                exemption_mode: grade.exemption_mode,
                solutions_visible,
                solution_md: solutions_visible.then_some(row.solution_md).flatten(),
                auto_score: grades_visible.then_some(grade.auto_score),
                manual_score: grades_visible.then_some(manual_score).flatten(),
                final_score: grades_visible.then_some(grade.final_score),
                feedback: grades_visible.then_some(feedback).flatten(),
                accepted_student_count: is_owner.then_some(row.accepted_student_count),
            }
        })
        .collect();
    let _ = computed_total;

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
    let late_student_count = if is_owner {
        Some(
            sqlx::query_scalar::<_, i64>(
                "SELECT COUNT(DISTINCT user_id) FROM submissions \
                 WHERE assignment_id = $1 AND is_late = TRUE",
            )
            .bind(id)
            .fetch_one(pool)
            .await
            .map_err(AppError::Database)?,
        )
    } else {
        None
    };
    let exempt_count = if is_owner {
        Some(
            sqlx::query_scalar::<_, i64>(
                "SELECT COUNT(*) FROM assignment_student_overrides \
                 WHERE assignment_id = $1 AND exempt = TRUE",
            )
            .bind(id)
            .fetch_one(pool)
            .await
            .map_err(AppError::Database)?,
        )
    } else {
        None
    };

    let my_deadline = override_map
        .values()
        .filter_map(|row| row.makeup_due_at)
        .max()
        .and_then(|makeup| effective_deadline(assignment.due_at, Some(makeup)))
        .or(assignment.due_at);

    let window_end = submission_window_end(
        assignment.due_at,
        None,
        &assignment.late_policy,
        assignment.late_grace_hours,
    );
    let can_submit = !is_owner
        && user.is_student()
        && assignment.status == ASSIGNMENT_STATUS_PUBLISHED
        && assignment.class_archived_at.is_none()
        && assignment.start_at.is_none_or(|start| now >= start)
        && window_end.is_some_and(|end| now <= end);

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
        late_policy: assignment.late_policy,
        late_grace_hours: assignment.late_grace_hours,
        late_penalty_per_day: assignment.late_penalty_per_day,
        late_penalty_cap: assignment.late_penalty_cap,
        scoring_policy: assignment.scoring_policy,
        score_visibility: assignment.score_visibility,
        allow_peer_code: assignment.allow_peer_code,
        show_class_stats: assignment.show_class_stats,
        solutions_published: assignment.solutions_published_at.is_some(),
        solutions_published_at: assignment.solutions_published_at,
        my_deadline,
        now,
        is_owner,
        can_submit,
        problems: views,
        total_score: grades_visible.then_some(total_score),
        overall_feedback,
        student_count,
        submitted_student_count,
        late_student_count,
        exempt_count,
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

fn normalize_reason(
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
        if problem
            .max_attempts
            .is_some_and(|value| !(1..=1000).contains(&value))
        {
            return Err(AppError::BadRequest(
                "题目提交次数上限必须在 1 到 1000 之间".to_owned(),
            ));
        }
        if problem
            .solution_md
            .as_deref()
            .is_some_and(|value| value.chars().count() > 20_000)
        {
            return Err(AppError::BadRequest(
                "答案解析不能超过 20000 个字符".to_owned(),
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
        let solution = problem
            .solution_md
            .as_deref()
            .map(str::trim)
            .filter(|value| !value.is_empty());
        sqlx::query(
            "INSERT INTO assignment_problems \
             (assignment_id, problem_id, position, points, max_attempts, solution_md) \
             VALUES ($1, $2, $3, $4, $5, $6)",
        )
        .bind(assignment_id)
        .bind(problem.problem_id)
        .bind(position as i32)
        .bind(problem.points)
        .bind(problem.max_attempts)
        .bind(solution)
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

pub async fn publish_solutions(
    pool: &PgPool,
    user: &AuthUser,
    id: i32,
) -> Result<PublishSolutionsResponse, AppError> {
    let assignment = access_owned_assignment(pool, user, id).await?;
    if assignment.class_archived_at.is_some() {
        return Err(AppError::Conflict("班级已归档".to_owned()));
    }
    if assignment.status != ASSIGNMENT_STATUS_PUBLISHED {
        return Err(AppError::Conflict("作业当前状态不能发布解析".to_owned()));
    }
    if assignment.due_at.is_none_or(|due| due > Utc::now()) {
        return Err(AppError::Conflict("作业尚未截止，不能发布解析".to_owned()));
    }

    let mut transaction = pool.begin().await.map_err(AppError::Database)?;
    let published: Option<DateTime<Utc>> = sqlx::query_scalar(
        "UPDATE assignments SET solutions_published_at = CURRENT_TIMESTAMP, \
         updated_at = CURRENT_TIMESTAMP \
         WHERE id = $1 AND status = 'published' AND solutions_published_at IS NULL \
           AND due_at <= CURRENT_TIMESTAMP \
         RETURNING solutions_published_at",
    )
    .bind(id)
    .fetch_optional(&mut *transaction)
    .await
    .map_err(AppError::Database)?;

    if let Some(published_at) = published {
        insert_audit(
            &mut transaction,
            id,
            user.id,
            "solutions_published",
            None,
            Some(serde_json::json!({ "solutions_published_at": published_at })),
            None,
        )
        .await?;
        let title = format!("解析已发布：{}", assignment.title);
        let link = format!("/assignments/{id}");
        notify_class_students(
            &mut transaction,
            assignment.class_id,
            user.id,
            "assignment_solutions_published",
            &title,
            &assignment.class_name,
            &link,
            id,
        )
        .await?;
        transaction.commit().await.map_err(AppError::Database)?;
        return Ok(PublishSolutionsResponse {
            message: "解析已发布".to_owned(),
            solutions_published_at: published_at,
        });
    }

    let existing: Option<Option<DateTime<Utc>>> = sqlx::query_scalar(
        "SELECT solutions_published_at FROM assignments WHERE id = $1 AND status = 'published'",
    )
    .bind(id)
    .fetch_optional(&mut *transaction)
    .await
    .map_err(AppError::Database)?;
    match existing {
        Some(Some(timestamp)) => {
            transaction.commit().await.map_err(AppError::Database)?;
            Ok(PublishSolutionsResponse {
                message: "解析已发布".to_owned(),
                solutions_published_at: timestamp,
            })
        }
        _ => Err(AppError::Conflict("作业尚未截止，不能发布解析".to_owned())),
    }
}

pub async fn list_overrides(
    pool: &PgPool,
    user: &AuthUser,
    id: i32,
) -> Result<OverrideListResponse, AppError> {
    access_owned_assignment(pool, user, id).await?;
    let overrides: Vec<OverrideItem> = sqlx::query_as(
        "SELECT o.user_id, u.username, o.problem_id, o.makeup_due_at, \
         o.waive_late_penalty, o.exempt, o.exemption_mode, o.reason, \
         o.created_by, o.created_at, o.updated_at \
         FROM assignment_student_overrides o JOIN users u ON u.id = o.user_id \
         WHERE o.assignment_id = $1 ORDER BY u.username, o.problem_id",
    )
    .bind(id)
    .fetch_all(pool)
    .await
    .map_err(AppError::Database)?;
    Ok(OverrideListResponse { overrides })
}

pub async fn set_override(
    pool: &PgPool,
    user: &AuthUser,
    id: i32,
    student_id: i32,
    problem_id: i32,
    request: &UpdateOverrideRequest,
) -> Result<OverrideListResponse, AppError> {
    let assignment = access_owned_assignment(pool, user, id).await?;
    if assignment.class_archived_at.is_some() {
        return Err(AppError::Conflict("班级已归档".to_owned()));
    }
    if assignment.status != ASSIGNMENT_STATUS_PUBLISHED {
        return Err(AppError::Conflict("作业当前状态不能设置例外".to_owned()));
    }
    if !is_active_member(pool, assignment.class_id, student_id).await? {
        return Err(AppError::NotFound("学生不在该班级中".to_owned()));
    }
    let problem_exists: bool = sqlx::query_scalar(
        "SELECT EXISTS(SELECT 1 FROM assignment_problems WHERE assignment_id = $1 AND problem_id = $2)",
    )
    .bind(id)
    .bind(problem_id)
    .fetch_one(pool)
    .await
    .map_err(AppError::Database)?;
    if !problem_exists {
        return Err(AppError::BadRequest("题目不属于该作业".to_owned()));
    }
    if let Some(makeup) = request.makeup_due_at
        && assignment.due_at.is_some_and(|due| makeup <= due)
    {
        return Err(AppError::BadRequest(
            "补交截止时间必须晚于作业截止时间".to_owned(),
        ));
    }
    if request.exempt {
        if !matches!(
            request.exemption_mode.as_deref(),
            Some(policy::EXEMPTION_FULL_SCORE) | Some(policy::EXEMPTION_EXCLUDED)
        ) {
            return Err(AppError::BadRequest(
                "免修计分方式必须是 full_score 或 excluded".to_owned(),
            ));
        }
    } else if request.exemption_mode.is_some() {
        return Err(AppError::BadRequest(
            "非免修记录不能设置免修计分方式".to_owned(),
        ));
    }
    let reason = normalize_reason(request.reason.as_deref(), 2_000, "原因")?;

    let mut transaction = pool.begin().await.map_err(AppError::Database)?;
    let before: Option<OverrideRow> = sqlx::query_as(
        "SELECT problem_id, makeup_due_at, waive_late_penalty, exempt, exemption_mode \
         FROM assignment_student_overrides \
         WHERE assignment_id = $1 AND user_id = $2 AND problem_id = $3 FOR UPDATE",
    )
    .bind(id)
    .bind(student_id)
    .bind(problem_id)
    .fetch_optional(&mut *transaction)
    .await
    .map_err(AppError::Database)?;

    let after: OverrideRow = sqlx::query_as(
        "INSERT INTO assignment_student_overrides \
         (assignment_id, user_id, problem_id, makeup_due_at, waive_late_penalty, \
          exempt, exemption_mode, reason, created_by) \
         VALUES ($1, $2, $3, $4, $5, $6, $7, $8, $9) \
         ON CONFLICT (assignment_id, user_id, problem_id) DO UPDATE SET \
             makeup_due_at = EXCLUDED.makeup_due_at, \
             waive_late_penalty = EXCLUDED.waive_late_penalty, \
             exempt = EXCLUDED.exempt, \
             exemption_mode = EXCLUDED.exemption_mode, \
             reason = EXCLUDED.reason, \
             created_by = EXCLUDED.created_by, \
             updated_at = CURRENT_TIMESTAMP \
         RETURNING problem_id, makeup_due_at, waive_late_penalty, exempt, exemption_mode",
    )
    .bind(id)
    .bind(student_id)
    .bind(problem_id)
    .bind(request.makeup_due_at)
    .bind(request.waive_late_penalty)
    .bind(request.exempt)
    .bind(&request.exemption_mode)
    .bind(&reason)
    .bind(user.id)
    .fetch_one(&mut *transaction)
    .await
    .map_err(AppError::Database)?;

    insert_audit(
        &mut transaction,
        id,
        user.id,
        "override_set",
        before.as_ref().map(|row| {
            serde_json::json!({
                "user_id": student_id,
                "problem_id": row.problem_id,
                "makeup_due_at": row.makeup_due_at,
                "waive_late_penalty": row.waive_late_penalty,
                "exempt": row.exempt,
                "exemption_mode": row.exemption_mode,
            })
        }),
        Some(serde_json::json!({
            "user_id": student_id,
            "problem_id": after.problem_id,
            "makeup_due_at": after.makeup_due_at,
            "waive_late_penalty": after.waive_late_penalty,
            "exempt": after.exempt,
            "exemption_mode": after.exemption_mode,
        })),
        reason.as_deref(),
    )
    .await?;

    let title = format!("作业例外已更新：{}", assignment.title);
    let link = format!("/assignments/{id}");
    sqlx::query(
        "INSERT INTO notifications \
         (user_id, type, actor_id, title, body, link, related_type, related_id) \
         VALUES ($1, 'assignment_override_granted', $2, $3, $4, $5, 'assignment', $6)",
    )
    .bind(student_id)
    .bind(user.id)
    .bind(title)
    .bind(&assignment.class_name)
    .bind(link)
    .bind(i64::from(id))
    .execute(&mut *transaction)
    .await
    .map_err(AppError::Database)?;
    transaction.commit().await.map_err(AppError::Database)?;
    list_overrides(pool, user, id).await
}

pub async fn delete_override(
    pool: &PgPool,
    user: &AuthUser,
    id: i32,
    student_id: i32,
    problem_id: i32,
) -> Result<OverrideListResponse, AppError> {
    let assignment = access_owned_assignment(pool, user, id).await?;
    if assignment.class_archived_at.is_some() {
        return Err(AppError::Conflict("班级已归档".to_owned()));
    }
    let mut transaction = pool.begin().await.map_err(AppError::Database)?;
    let before: Option<OverrideRow> = sqlx::query_as(
        "DELETE FROM assignment_student_overrides \
         WHERE assignment_id = $1 AND user_id = $2 AND problem_id = $3 \
         RETURNING problem_id, makeup_due_at, waive_late_penalty, exempt, exemption_mode",
    )
    .bind(id)
    .bind(student_id)
    .bind(problem_id)
    .fetch_optional(&mut *transaction)
    .await
    .map_err(AppError::Database)?;
    let Some(before) = before else {
        return Err(AppError::NotFound("例外记录不存在".to_owned()));
    };
    insert_audit(
        &mut transaction,
        id,
        user.id,
        "override_revoked",
        Some(serde_json::json!({
            "user_id": student_id,
            "problem_id": before.problem_id,
            "makeup_due_at": before.makeup_due_at,
            "waive_late_penalty": before.waive_late_penalty,
            "exempt": before.exempt,
            "exemption_mode": before.exemption_mode,
        })),
        None,
        None,
    )
    .await?;
    let title = format!("作业例外已撤销：{}", assignment.title);
    let link = format!("/assignments/{id}");
    sqlx::query(
        "INSERT INTO notifications \
         (user_id, type, actor_id, title, body, link, related_type, related_id) \
         VALUES ($1, 'assignment_override_granted', $2, $3, $4, $5, 'assignment', $6)",
    )
    .bind(student_id)
    .bind(user.id)
    .bind(title)
    .bind(&assignment.class_name)
    .bind(link)
    .bind(i64::from(id))
    .execute(&mut *transaction)
    .await
    .map_err(AppError::Database)?;
    transaction.commit().await.map_err(AppError::Database)?;
    list_overrides(pool, user, id).await
}

pub async fn list_policy_audits(
    pool: &PgPool,
    user: &AuthUser,
    id: i32,
) -> Result<PolicyAuditListResponse, AppError> {
    access_owned_assignment(pool, user, id).await?;
    let audits: Vec<PolicyAuditItem> = sqlx::query_as(
        "SELECT pa.id, pa.actor_id, u.username AS actor_username, pa.action, \
         pa.before_data, pa.after_data, pa.reason, pa.created_at \
         FROM assignment_policy_audits pa LEFT JOIN users u ON u.id = pa.actor_id \
         WHERE pa.assignment_id = $1 ORDER BY pa.created_at DESC, pa.id DESC LIMIT 200",
    )
    .bind(id)
    .fetch_all(pool)
    .await
    .map_err(AppError::Database)?;
    Ok(PolicyAuditListResponse { audits })
}

pub async fn statistics(
    pool: &PgPool,
    user: &AuthUser,
    id: i32,
) -> Result<AssignmentStatsResponse, AppError> {
    let (assignment, is_owner) = access_assignment(pool, user, id).await?;
    if !is_owner
        && (!user.is_student()
            || !assignment.show_class_stats
            || !is_score_visible(
                ScoreVisibility::parse(&assignment.score_visibility)
                    .unwrap_or(ScoreVisibility::AfterPublish),
                Utc::now(),
                assignment.due_at,
                assignment.grades_published_at,
            ))
    {
        return Err(AppError::NotFound("作业统计不可见".to_owned()));
    }
    let gradebook = grade_service::compute_gradebook(pool, id, false).await?;
    let student_count = gradebook.students.len() as i64;
    let submitted_student_count = gradebook
        .students
        .iter()
        .filter(|student| student.problems.iter().any(|cell| cell.attempts > 0))
        .count() as i64;

    let totals: Vec<(i32, i32)> = gradebook
        .students
        .iter()
        .map(|student| (student.user_id, student.total_score))
        .collect();
    let submitted_totals: Vec<i32> = gradebook
        .students
        .iter()
        .filter(|student| student.problems.iter().any(|cell| cell.attempts > 0))
        .map(|student| student.total_score)
        .collect();
    let average_score = if submitted_totals.is_empty() {
        0.0
    } else {
        submitted_totals.iter().sum::<i32>() as f64 / submitted_totals.len() as f64
    };
    let my_total_score = (!is_owner)
        .then(|| {
            totals
                .iter()
                .find(|(student_id, _)| *student_id == user.id)
                .map(|(_, score)| *score)
        })
        .flatten();
    let my_position_bucket = my_total_score.map(|my_score| {
        let mut sorted: Vec<i32> = totals.iter().map(|(_, score)| *score).collect();
        sorted.sort_by(|a, b| b.cmp(a));
        let rank = sorted
            .iter()
            .position(|score| *score == my_score)
            .unwrap_or(0);
        let total = sorted.len().max(1);
        if rank < ((total as f64) * 0.10).ceil() as usize {
            "top10".to_owned()
        } else if rank < ((total as f64) * 0.25).ceil() as usize {
            "top25".to_owned()
        } else if rank < ((total as f64) * 0.50).ceil() as usize {
            "top50".to_owned()
        } else {
            "rest".to_owned()
        }
    });

    let problems: Vec<AssignmentStatsProblem> = gradebook
        .problems
        .iter()
        .map(|problem| {
            let mut accepted = 0;
            let mut exempt = 0;
            let mut score_sum = 0;
            let mut score_count = 0;
            for student in &gradebook.students {
                if let Some(cell) = student
                    .problems
                    .iter()
                    .find(|cell| cell.problem_id == problem.problem_id)
                {
                    if cell.accepted {
                        accepted += 1;
                    }
                    if cell.exempt {
                        exempt += 1;
                    }
                    if cell.included_in_total {
                        score_sum += cell.final_score;
                        score_count += 1;
                    }
                }
            }
            AssignmentStatsProblem {
                problem_id: problem.problem_id,
                points: problem.points,
                accepted_student_count: accepted,
                pass_rate: if student_count == 0 {
                    0.0
                } else {
                    accepted as f64 / student_count as f64
                },
                average_score: if score_count == 0 {
                    0.0
                } else {
                    score_sum as f64 / score_count as f64
                },
                exempt_count: exempt,
            }
        })
        .collect();

    Ok(AssignmentStatsResponse {
        student_count,
        submitted_student_count,
        average_score: round1(average_score),
        my_total_score,
        my_position_bucket,
        problems: problems
            .into_iter()
            .map(|problem| AssignmentStatsProblem {
                average_score: round1(problem.average_score),
                pass_rate: round1(problem.pass_rate),
                ..problem
            })
            .collect(),
    })
}

pub async fn peer_submissions(
    pool: &PgPool,
    user: &AuthUser,
    id: i32,
    problem_id: i32,
) -> Result<PeerSubmissionListResponse, AppError> {
    let (assignment, is_owner) = access_assignment(pool, user, id).await?;
    let score_visible = assignment.grades_published_at.is_some()
        && is_score_visible(
            ScoreVisibility::parse(&assignment.score_visibility)
                .unwrap_or(ScoreVisibility::AfterPublish),
            Utc::now(),
            assignment.due_at,
            assignment.grades_published_at,
        );
    if !is_owner && (!user.is_student() || !assignment.allow_peer_code || !score_visible) {
        return Err(AppError::NotFound("作业不存在".to_owned()));
    }
    let problem_exists: bool = sqlx::query_scalar(
        "SELECT EXISTS(SELECT 1 FROM assignment_problems WHERE assignment_id = $1 AND problem_id = $2)",
    )
    .bind(id)
    .bind(problem_id)
    .fetch_one(pool)
    .await
    .map_err(AppError::Database)?;
    if !problem_exists {
        return Err(AppError::NotFound("题目不属于该作业".to_owned()));
    }

    #[derive(Debug, sqlx::FromRow)]
    struct PeerRow {
        user_id: i32,
        username: String,
        id: i32,
        status: String,
        submitted_at: DateTime<Utc>,
        is_late: bool,
        late_days: i32,
        language: String,
        code: String,
    }

    let rows: Vec<PeerRow> = sqlx::query_as(
        "SELECT s.user_id, u.username, s.id, s.status, s.submitted_at, \
         s.is_late, s.late_days, s.language, s.code \
         FROM submissions s JOIN users u ON u.id = s.user_id \
         JOIN class_members cm ON cm.class_id = $3 AND cm.user_id = s.user_id \
           AND cm.status = 'active' \
         WHERE s.assignment_id = $1 AND s.problem_id = $2 \
         ORDER BY u.username, s.submitted_at, s.id",
    )
    .bind(id)
    .bind(problem_id)
    .bind(assignment.class_id)
    .fetch_all(pool)
    .await
    .map_err(AppError::Database)?;

    let mut by_user: HashMap<i32, Vec<PeerRow>> = HashMap::new();
    for row in rows {
        by_user.entry(row.user_id).or_default().push(row);
    }
    let scoring_policy =
        ScoringPolicy::parse(&assignment.scoring_policy).unwrap_or(ScoringPolicy::Highest);
    let mut submissions = Vec::new();
    for (_, user_rows) in by_user {
        let scoring_rows: Vec<policy::ScoringSubmission> = user_rows
            .iter()
            .map(|row| policy::ScoringSubmission {
                id: row.id,
                status: row.status.clone(),
                submitted_at: row.submitted_at,
                is_late: row.is_late,
                late_days: row.late_days,
            })
            .collect();
        let Some(selected) = policy::select_scoring_submission(scoring_policy, &scoring_rows)
        else {
            continue;
        };
        if selected.status != policy::SUBMISSION_STATUS_ACCEPTED {
            continue;
        }
        if let Some(row) = user_rows.iter().find(|row| row.id == selected.id) {
            submissions.push(PeerSubmissionItem {
                username: row.username.clone(),
                language: row.language.clone(),
                submitted_at: row.submitted_at,
                code: row.code.clone(),
            });
        }
    }
    submissions.sort_by(|a, b| a.username.cmp(&b.username));
    Ok(PeerSubmissionListResponse { submissions })
}

fn round1(value: f64) -> f64 {
    (value * 10.0).round() / 10.0
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
                ..Default::default()
            },
            AssignmentProblemInput {
                problem_id: 1,
                points: 100,
                ..Default::default()
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
                ..Default::default()
            }];
            assert!(validate_problem_inputs(&problems).is_err());
        }
    }
}
