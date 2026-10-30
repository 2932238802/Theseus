use std::collections::HashMap;

use chrono::{DateTime, Utc};
use sqlx::{FromRow, PgPool};

use crate::{
    common::error::AppError,
    middleware::auth::AuthUser,
    models::teaching::{
        ASSIGNMENT_STATUS_PUBLISHED, GradeMutationResponse, GradebookAssignment, GradebookCell,
        GradebookProblem, GradebookQuery, GradebookResponse, GradebookStudent, OverallGradeRequest,
        ProblemGradeRequest, PublishGradesResponse,
    },
    services::assignment_policy::{self as policy, ScoringPolicy, StudentOverride},
};

const MAX_PROBLEM_FEEDBACK_CHARS: usize = 2_000;
const MAX_OVERALL_FEEDBACK_CHARS: usize = 5_000;

#[derive(Debug, FromRow)]
struct GradingContext {
    id: i32,
    class_id: i32,
    class_name: String,
    title: String,
    status: String,
    due_at: Option<DateTime<Utc>>,
    grades_published_at: Option<DateTime<Utc>>,
    late_policy: String,
    late_penalty_per_day: i32,
    late_penalty_cap: i32,
    max_attempts: Option<i32>,
    scoring_policy: String,
    class_owner_id: i32,
    class_archived_at: Option<DateTime<Utc>>,
}

#[derive(Debug, FromRow)]
struct StudentRow {
    user_id: i32,
    username: String,
    email: String,
    status: String,
}

#[derive(Debug, FromRow)]
struct ProblemRow {
    problem_id: i32,
    title: String,
    points: i32,
    max_attempts: Option<i32>,
}

#[derive(Debug, FromRow)]
struct SubmissionRow {
    user_id: i32,
    problem_id: i32,
    id: i32,
    status: String,
    submitted_at: DateTime<Utc>,
    is_late: bool,
    late_days: i32,
}

impl SubmissionRow {
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

#[derive(Debug, FromRow)]
struct OverrideRow {
    user_id: i32,
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
struct ManualGradeRow {
    user_id: i32,
    problem_id: i32,
    manual_score: Option<i32>,
    feedback: Option<String>,
}

#[derive(Debug, FromRow)]
struct ResultRow {
    user_id: i32,
    overall_feedback: Option<String>,
}

async fn grading_context(pool: &PgPool, id: i32) -> Result<GradingContext, AppError> {
    sqlx::query_as(
        "SELECT a.id, a.class_id, c.name AS class_name, a.title, a.status, a.due_at, \
         a.grades_published_at, a.late_policy, a.late_penalty_per_day, a.late_penalty_cap, \
         a.max_attempts, a.scoring_policy, \
         c.owner_id AS class_owner_id, c.archived_at AS class_archived_at \
         FROM assignments a JOIN classes c ON c.id = a.class_id WHERE a.id = $1",
    )
    .bind(id)
    .fetch_optional(pool)
    .await
    .map_err(AppError::Database)?
    .ok_or_else(|| AppError::NotFound("作业不存在".to_owned()))
}

async fn access_grading(
    pool: &PgPool,
    user: &AuthUser,
    id: i32,
) -> Result<GradingContext, AppError> {
    if user.is_admin() {
        return Err(AppError::Forbidden);
    }
    if !user.is_teacher() {
        return Err(AppError::ForbiddenWith(
            "只有该组织的教师可以批改作业".to_owned(),
        ));
    }
    let context = grading_context(pool, id).await?;
    if context.class_owner_id != user.id {
        return Err(AppError::NotFound("作业不存在".to_owned()));
    }
    Ok(context)
}

pub async fn gradebook(
    pool: &PgPool,
    user: &AuthUser,
    id: i32,
    query: &GradebookQuery,
) -> Result<GradebookResponse, AppError> {
    let context = access_grading(pool, user, id).await?;
    let include_removed = query.include_removed.unwrap_or(0) != 0;
    compute_gradebook_with_context(pool, &context, include_removed).await
}

/// 导出批改台为 CSV（UTF-8 BOM，Excel 可直接打开）。
pub async fn export_gradebook(
    pool: &PgPool,
    user: &AuthUser,
    id: i32,
    query: &GradebookQuery,
) -> Result<String, AppError> {
    let gradebook = gradebook(pool, user, id, query).await?;
    Ok(gradebook_csv(&gradebook))
}

fn gradebook_csv(gradebook: &GradebookResponse) -> String {
    let mut lines = Vec::with_capacity(gradebook.students.len() + 1);
    let mut header = vec![
        "用户名".to_owned(),
        "邮箱".to_owned(),
        "成员状态".to_owned(),
    ];
    header.extend(
        gradebook
            .problems
            .iter()
            .map(|problem| format!("{}（{} 分）", problem.title, problem.points)),
    );
    header.push("总分".to_owned());
    header.push("整体评语".to_owned());
    lines.push(
        header
            .iter()
            .map(|value| csv_field(value))
            .collect::<Vec<_>>()
            .join(","),
    );

    for student in &gradebook.students {
        let mut row = vec![
            student.username.clone(),
            student.email.clone(),
            if student.status == "removed" {
                "已移除".to_owned()
            } else {
                "正常".to_owned()
            },
        ];
        for problem in &gradebook.problems {
            let score = student
                .problems
                .iter()
                .find(|cell| cell.problem_id == problem.problem_id)
                .map_or(0, |cell| cell.final_score);
            row.push(score.to_string());
        }
        row.push(student.total_score.to_string());
        row.push(student.overall_feedback.clone().unwrap_or_default());
        lines.push(
            row.iter()
                .map(|value| csv_field(value))
                .collect::<Vec<_>>()
                .join(","),
        );
    }

    format!("\u{feff}{}\n", lines.join("\n"))
}

fn csv_field(value: &str) -> String {
    if value.contains(',') || value.contains('"') || value.contains('\n') || value.contains('\r') {
        format!("\"{}\"", value.replace('"', "\"\""))
    } else {
        value.to_owned()
    }
}

pub async fn compute_gradebook(
    pool: &PgPool,
    id: i32,
    include_removed: bool,
) -> Result<GradebookResponse, AppError> {
    let context = grading_context(pool, id).await?;
    compute_gradebook_with_context(pool, &context, include_removed).await
}

async fn compute_gradebook_with_context(
    pool: &PgPool,
    context: &GradingContext,
    include_removed: bool,
) -> Result<GradebookResponse, AppError> {
    let id = context.id;
    let students: Vec<StudentRow> = sqlx::query_as(
        "SELECT u.id AS user_id, u.username, u.email, cm.status \
         FROM class_members cm JOIN users u ON u.id = cm.user_id \
         WHERE cm.class_id = $1 AND (cm.status = 'active' OR ($2 AND cm.status = 'removed' AND ( \
             EXISTS(SELECT 1 FROM submissions s WHERE s.assignment_id = $3 AND s.user_id = cm.user_id) \
             OR EXISTS(SELECT 1 FROM assignment_problem_grades g WHERE g.assignment_id = $3 AND g.user_id = cm.user_id) \
             OR EXISTS(SELECT 1 FROM assignment_results r WHERE r.assignment_id = $3 AND r.user_id = cm.user_id) \
         ))) \
         ORDER BY CASE WHEN cm.status = 'active' THEN 0 ELSE 1 END, u.username, u.id",
    )
    .bind(context.class_id)
    .bind(include_removed)
    .bind(id)
    .fetch_all(pool)
    .await
    .map_err(AppError::Database)?;

    let problems: Vec<ProblemRow> = sqlx::query_as(
        "SELECT ap.problem_id, p.title, ap.points, ap.max_attempts \
         FROM assignment_problems ap JOIN problems p ON p.id = ap.problem_id \
         WHERE ap.assignment_id = $1 ORDER BY ap.position, ap.problem_id",
    )
    .bind(id)
    .fetch_all(pool)
    .await
    .map_err(AppError::Database)?;

    let submission_rows: Vec<SubmissionRow> = sqlx::query_as(
        "SELECT user_id, problem_id, id, status, submitted_at, is_late, late_days \
         FROM submissions WHERE assignment_id = $1 ORDER BY submitted_at, id",
    )
    .bind(id)
    .fetch_all(pool)
    .await
    .map_err(AppError::Database)?;
    let mut submissions_by_cell: HashMap<(i32, i32), Vec<policy::ScoringSubmission>> =
        HashMap::new();
    let mut last_by_cell: HashMap<(i32, i32), (i32, String)> = HashMap::new();
    for row in submission_rows {
        submissions_by_cell
            .entry((row.user_id, row.problem_id))
            .or_default()
            .push(row.as_scoring_submission());
        last_by_cell.insert((row.user_id, row.problem_id), (row.id, row.status.clone()));
    }

    let override_rows: Vec<OverrideRow> = sqlx::query_as(
        "SELECT user_id, problem_id, makeup_due_at, waive_late_penalty, exempt, exemption_mode \
         FROM assignment_student_overrides WHERE assignment_id = $1",
    )
    .bind(id)
    .fetch_all(pool)
    .await
    .map_err(AppError::Database)?;
    let override_map: HashMap<(i32, i32), OverrideRow> = override_rows
        .into_iter()
        .map(|row| ((row.user_id, row.problem_id), row))
        .collect();

    let manual: Vec<ManualGradeRow> = sqlx::query_as(
        "SELECT user_id, problem_id, manual_score, feedback FROM assignment_problem_grades \
         WHERE assignment_id = $1",
    )
    .bind(id)
    .fetch_all(pool)
    .await
    .map_err(AppError::Database)?;
    let manual_map: HashMap<(i32, i32), (Option<i32>, Option<String>)> = manual
        .into_iter()
        .map(|row| {
            (
                (row.user_id, row.problem_id),
                (row.manual_score, row.feedback),
            )
        })
        .collect();

    let results: Vec<ResultRow> = sqlx::query_as(
        "SELECT user_id, overall_feedback FROM assignment_results WHERE assignment_id = $1",
    )
    .bind(id)
    .fetch_all(pool)
    .await
    .map_err(AppError::Database)?;
    let result_map: HashMap<i32, Option<String>> = results
        .into_iter()
        .map(|row| (row.user_id, row.overall_feedback))
        .collect();

    let scoring_policy =
        ScoringPolicy::parse(&context.scoring_policy).unwrap_or(ScoringPolicy::Highest);
    let students = students
        .into_iter()
        .map(|student| {
            let mut total_score = 0;
            let cells = problems
                .iter()
                .map(|problem| {
                    let key = (student.user_id, problem.problem_id);
                    let empty: Vec<policy::ScoringSubmission> = Vec::new();
                    let submissions = submissions_by_cell.get(&key).unwrap_or(&empty);
                    let last = last_by_cell.get(&key);
                    let (manual_score, feedback) =
                        manual_map.get(&key).cloned().unwrap_or((None, None));
                    let override_row = override_map.get(&key);
                    let grade = policy::compute_problem_grade(
                        problem.points,
                        submissions,
                        manual_score,
                        override_row.map(OverrideRow::as_policy_override).as_ref(),
                        scoring_policy,
                        context.late_penalty_per_day,
                        context.late_penalty_cap,
                    );
                    let attempts_limit = problem.max_attempts.or(context.max_attempts);
                    let attempts = submissions
                        .iter()
                        .filter(|row| row.status != policy::SUBMISSION_STATUS_INTERNAL_ERROR)
                        .count() as i64;
                    let accepted = submissions.iter().any(|row| row.is_accepted());
                    if grade.included_in_total {
                        total_score += grade.final_score;
                    }
                    let late_deduction = if grade.is_late {
                        (problem.points - grade.auto_score).max(0)
                    } else {
                        0
                    };
                    GradebookCell {
                        problem_id: problem.problem_id,
                        attempts,
                        attempts_limit,
                        accepted,
                        is_late: grade.is_late,
                        late_days: grade.late_days,
                        late_deduction,
                        exempt: grade.exempt,
                        exemption_mode: grade.exemption_mode,
                        included_in_total: grade.included_in_total,
                        auto_score: grade.auto_score,
                        manual_score,
                        final_score: grade.final_score,
                        feedback,
                        last_submission_id: last.map(|(id, _)| *id),
                        last_status: last.map(|(_, status)| status.clone()),
                    }
                })
                .collect();
            GradebookStudent {
                user_id: student.user_id,
                username: student.username,
                email: student.email,
                status: student.status,
                overall_feedback: result_map.get(&student.user_id).cloned().flatten(),
                total_score,
                problems: cells,
            }
        })
        .collect();

    Ok(GradebookResponse {
        assignment: GradebookAssignment {
            id: context.id,
            title: context.title.clone(),
            due_at: context.due_at,
            grades_published_at: context.grades_published_at,
            late_policy: context.late_policy.clone(),
            scoring_policy: context.scoring_policy.clone(),
        },
        problems: problems
            .into_iter()
            .map(|problem| GradebookProblem {
                problem_id: problem.problem_id,
                title: problem.title,
                points: problem.points,
            })
            .collect(),
        students,
    })
}

pub async fn update_problem_grade(
    pool: &PgPool,
    user: &AuthUser,
    id: i32,
    student_id: i32,
    problem_id: i32,
    request: &ProblemGradeRequest,
) -> Result<GradeMutationResponse, AppError> {
    let context = access_grading(pool, user, id).await?;
    if context.status != ASSIGNMENT_STATUS_PUBLISHED {
        return Err(AppError::Conflict("作业当前状态不能改分".to_owned()));
    }
    if !is_active_member(pool, context.class_id, student_id).await? {
        return Err(AppError::NotFound("学生不在该组织中".to_owned()));
    }
    let points: Option<i32> = sqlx::query_scalar(
        "SELECT points FROM assignment_problems WHERE assignment_id = $1 AND problem_id = $2",
    )
    .bind(id)
    .bind(problem_id)
    .fetch_optional(pool)
    .await
    .map_err(AppError::Database)?;
    let points = points.ok_or_else(|| AppError::BadRequest("题目不属于该作业".to_owned()))?;
    if let Some(score) = request.manual_score
        && !(0..=points).contains(&score)
    {
        return Err(AppError::BadRequest(format!(
            "手动分必须在 0 到 {points} 之间"
        )));
    }
    let feedback = normalize_feedback(
        request.feedback.as_deref(),
        MAX_PROBLEM_FEEDBACK_CHARS,
        "评语",
    )?;
    if request.manual_score.is_none() && feedback.is_none() {
        sqlx::query(
            "DELETE FROM assignment_problem_grades WHERE assignment_id = $1 AND user_id = $2 AND problem_id = $3",
        )
        .bind(id)
        .bind(student_id)
        .bind(problem_id)
        .execute(pool)
        .await
        .map_err(AppError::Database)?;
    } else {
        sqlx::query(
            "INSERT INTO assignment_problem_grades \
             (assignment_id, user_id, problem_id, manual_score, feedback, graded_by) \
             VALUES ($1, $2, $3, $4, $5, $6) \
             ON CONFLICT (assignment_id, user_id, problem_id) DO UPDATE SET \
                 manual_score = EXCLUDED.manual_score, feedback = EXCLUDED.feedback, \
                 graded_by = EXCLUDED.graded_by, graded_at = CURRENT_TIMESTAMP",
        )
        .bind(id)
        .bind(student_id)
        .bind(problem_id)
        .bind(request.manual_score)
        .bind(feedback)
        .bind(user.id)
        .execute(pool)
        .await
        .map_err(AppError::Database)?;
    }
    Ok(GradeMutationResponse {
        message: "分数已保存".to_owned(),
    })
}

pub async fn update_overall_grade(
    pool: &PgPool,
    user: &AuthUser,
    id: i32,
    student_id: i32,
    request: &OverallGradeRequest,
) -> Result<GradeMutationResponse, AppError> {
    let context = access_grading(pool, user, id).await?;
    if context.status != ASSIGNMENT_STATUS_PUBLISHED {
        return Err(AppError::Conflict("作业当前状态不能写评语".to_owned()));
    }
    if !is_active_member(pool, context.class_id, student_id).await? {
        return Err(AppError::NotFound("学生不在该组织中".to_owned()));
    }
    let feedback = normalize_feedback(
        request.overall_feedback.as_deref(),
        MAX_OVERALL_FEEDBACK_CHARS,
        "整体评语",
    )?;
    if feedback.is_none() {
        sqlx::query("DELETE FROM assignment_results WHERE assignment_id = $1 AND user_id = $2")
            .bind(id)
            .bind(student_id)
            .execute(pool)
            .await
            .map_err(AppError::Database)?;
    } else {
        sqlx::query(
            "INSERT INTO assignment_results (assignment_id, user_id, overall_feedback, graded_by, graded_at) \
             VALUES ($1, $2, $3, $4, CURRENT_TIMESTAMP) \
             ON CONFLICT (assignment_id, user_id) DO UPDATE SET \
                 overall_feedback = EXCLUDED.overall_feedback, graded_by = EXCLUDED.graded_by, \
                 graded_at = CURRENT_TIMESTAMP",
        )
        .bind(id)
        .bind(student_id)
        .bind(feedback)
        .bind(user.id)
        .execute(pool)
        .await
        .map_err(AppError::Database)?;
    }
    Ok(GradeMutationResponse {
        message: "整体评语已保存".to_owned(),
    })
}

pub async fn publish_grades(
    pool: &PgPool,
    user: &AuthUser,
    id: i32,
) -> Result<PublishGradesResponse, AppError> {
    let context = access_grading(pool, user, id).await?;
    if context.status != ASSIGNMENT_STATUS_PUBLISHED {
        return Err(AppError::Conflict("作业当前状态不能发布成绩".to_owned()));
    }
    if context.due_at.is_none() {
        return Err(AppError::Conflict("作业尚未设置截止时间".to_owned()));
    }
    let closed: bool = sqlx::query_scalar(
        "SELECT due_at IS NOT NULL AND due_at <= CURRENT_TIMESTAMP FROM assignments WHERE id = $1",
    )
    .bind(id)
    .fetch_one(pool)
    .await
    .map_err(AppError::Database)?;
    if !closed {
        return Err(AppError::Conflict("作业尚未截止，不能发布成绩".to_owned()));
    }
    if context.class_archived_at.is_some() {
        return Err(AppError::Conflict("组织已归档".to_owned()));
    }

    let mut transaction = pool.begin().await.map_err(AppError::Database)?;
    let published: Option<DateTime<Utc>> = sqlx::query_scalar(
        "UPDATE assignments SET grades_published_at = CURRENT_TIMESTAMP, updated_at = CURRENT_TIMESTAMP \
         WHERE id = $1 AND status = 'published' AND grades_published_at IS NULL \
         RETURNING grades_published_at",
    )
    .bind(id)
    .fetch_optional(&mut *transaction)
    .await
    .map_err(AppError::Database)?;

    let Some(published_at) = published else {
        let existing: Option<Option<DateTime<Utc>>> = sqlx::query_scalar(
            "SELECT grades_published_at FROM assignments WHERE id = $1 AND status = 'published'",
        )
        .bind(id)
        .fetch_optional(&mut *transaction)
        .await
        .map_err(AppError::Database)?;
        match existing {
            Some(Some(timestamp)) => {
                transaction.commit().await.map_err(AppError::Database)?;
                return Ok(PublishGradesResponse {
                    message: "成绩已发布".to_owned(),
                    grades_published_at: timestamp,
                });
            }
            _ => return Err(AppError::Conflict("作业当前状态不能发布成绩".to_owned())),
        }
    };

    let title = format!("成绩已发布：{}", context.title);
    let link = format!("/assignments/{id}");
    sqlx::query(
        "INSERT INTO notifications (user_id, type, actor_id, title, body, link, related_type, related_id) \
         SELECT cm.user_id, 'assignment_grades_published', $2, $3, $4, $5, 'assignment', $6 \
         FROM class_members cm WHERE cm.class_id = $1 AND cm.status = 'active'",
    )
    .bind(context.class_id)
    .bind(user.id)
    .bind(title)
    .bind(&context.class_name)
    .bind(link)
    .bind(i64::from(id))
    .execute(&mut *transaction)
    .await
    .map_err(AppError::Database)?;
    transaction.commit().await.map_err(AppError::Database)?;
    Ok(PublishGradesResponse {
        message: "成绩已发布".to_owned(),
        grades_published_at: published_at,
    })
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

fn normalize_feedback(
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

#[cfg(test)]
mod tests {
    use super::{csv_field, gradebook_csv, normalize_feedback};
    use crate::models::teaching::{
        GradebookAssignment, GradebookCell, GradebookProblem, GradebookResponse, GradebookStudent,
    };

    #[test]
    fn feedback_is_trimmed_and_bounded() {
        assert_eq!(
            normalize_feedback(Some("  很好 "), 10, "评语").expect("valid"),
            Some("很好".to_owned())
        );
        assert_eq!(
            normalize_feedback(Some("   "), 10, "评语").expect("valid"),
            None
        );
        assert!(normalize_feedback(Some("12345678901"), 10, "评语").is_err());
    }

    #[test]
    fn csv_fields_are_quoted_when_needed() {
        assert_eq!(csv_field("alice"), "alice");
        assert_eq!(csv_field("a,b"), "\"a,b\"");
        assert_eq!(csv_field("say \"hi\""), "\"say \"\"hi\"\"\"");
        assert_eq!(csv_field("line1\nline2"), "\"line1\nline2\"");
    }

    #[test]
    fn gradebook_csv_has_bom_header_and_scores() {
        let gradebook = GradebookResponse {
            assignment: GradebookAssignment {
                id: 1,
                title: "作业 1".to_owned(),
                due_at: None,
                grades_published_at: None,
                late_policy: "none".to_owned(),
                scoring_policy: "highest".to_owned(),
            },
            problems: vec![GradebookProblem {
                problem_id: 7,
                title: "两数之和".to_owned(),
                points: 100,
            }],
            students: vec![GradebookStudent {
                user_id: 2,
                username: "alice".to_owned(),
                email: "alice@example.test".to_owned(),
                status: "active".to_owned(),
                overall_feedback: Some("不错，,继续".to_owned()),
                total_score: 80,
                problems: vec![GradebookCell {
                    problem_id: 7,
                    attempts: 2,
                    attempts_limit: None,
                    accepted: true,
                    is_late: false,
                    late_days: 0,
                    late_deduction: 0,
                    exempt: false,
                    exemption_mode: None,
                    included_in_total: true,
                    auto_score: 80,
                    manual_score: None,
                    final_score: 80,
                    feedback: None,
                    last_submission_id: Some(3),
                    last_status: Some("accepted".to_owned()),
                }],
            }],
        };
        let csv = gradebook_csv(&gradebook);
        assert!(csv.starts_with('\u{feff}'));
        let lines: Vec<&str> = csv.trim_start_matches('\u{feff}').lines().collect();
        assert_eq!(
            lines[0],
            "用户名,邮箱,成员状态,两数之和（100 分）,总分,整体评语"
        );
        assert_eq!(
            lines[1],
            "alice,alice@example.test,正常,80,80,\"不错，,继续\""
        );
    }
}
