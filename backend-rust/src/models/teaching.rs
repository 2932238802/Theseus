use chrono::{DateTime, Utc};
use serde::{Deserialize, Serialize};
use sqlx::FromRow;

pub const ROLE_STUDENT: &str = "student";
pub const ROLE_TEACHER: &str = "teacher";
pub const ROLE_ADMIN: &str = "admin";

pub const ASSIGNMENT_STATUS_DRAFT: &str = "draft";
pub const ASSIGNMENT_STATUS_PUBLISHED: &str = "published";
pub const ASSIGNMENT_STATUS_ARCHIVED: &str = "archived";

// ---------------------------------------------------------------------------
// Admin user management
// ---------------------------------------------------------------------------

#[derive(Debug, Deserialize, Default)]
pub struct AdminUserListQuery {
    pub q: Option<String>,
    pub role: Option<String>,
    pub page: Option<u32>,
    pub size: Option<u32>,
}

#[derive(Debug, Serialize, FromRow)]
pub struct AdminUserItem {
    pub id: i32,
    pub username: String,
    pub email: String,
    pub role: String,
    pub active_membership_count: i64,
    pub owned_active_class_count: i64,
    pub created_at: DateTime<Utc>,
    pub role_changed_at: DateTime<Utc>,
}

#[derive(Debug, Serialize)]
pub struct AdminUserListResponse {
    pub total: i64,
    pub page: u32,
    pub size: u32,
    pub users: Vec<AdminUserItem>,
}

#[derive(Debug, Deserialize)]
pub struct ChangeRoleRequest {
    pub role: String,
    #[serde(default)]
    pub archive_owned_classes: bool,
}

#[derive(Debug, Serialize)]
pub struct ChangeRoleResponse {
    pub id: i32,
    pub username: String,
    pub role: String,
    pub message: String,
    pub archived_class_count: u64,
}

// ---------------------------------------------------------------------------
// Classes
// ---------------------------------------------------------------------------

#[derive(Debug, Serialize, Clone)]
pub struct ClassOwner {
    pub id: i32,
    pub username: String,
}

#[derive(Debug, Deserialize)]
pub struct CreateClassRequest {
    pub name: String,
    #[serde(default)]
    pub course_name: Option<String>,
    #[serde(default)]
    pub term: Option<String>,
    #[serde(default)]
    pub description: Option<String>,
}

#[derive(Debug, Deserialize)]
pub struct UpdateClassRequest {
    #[serde(default)]
    pub name: Option<String>,
    #[serde(default)]
    pub course_name: Option<String>,
    #[serde(default)]
    pub term: Option<String>,
    #[serde(default)]
    pub description: Option<String>,
}

#[derive(Debug, Deserialize)]
pub struct JoinClassRequest {
    pub invite_code: String,
}

#[derive(Debug, Deserialize)]
pub struct AddClassMemberRequest {
    pub identifier: String,
}

#[derive(Debug, Serialize, Clone, FromRow)]
pub struct ClassMemberView {
    pub user_id: i32,
    pub username: String,
    pub email: String,
    pub status: String,
    pub joined_at: DateTime<Utc>,
    pub removed_at: Option<DateTime<Utc>>,
}

#[derive(Debug, Serialize)]
pub struct ClassSummary {
    pub id: i32,
    pub name: String,
    pub course_name: Option<String>,
    pub term: Option<String>,
    pub description: Option<String>,
    pub owner: ClassOwner,
    pub relation: String,
    pub member_count: i64,
    pub assignment_count: i64,
    pub archived_at: Option<DateTime<Utc>>,
}

#[derive(Debug, Serialize)]
pub struct ClassListResponse {
    pub classes: Vec<ClassSummary>,
}

#[derive(Debug, Serialize)]
pub struct ClassDetail {
    pub id: i32,
    pub name: String,
    pub course_name: Option<String>,
    pub term: Option<String>,
    pub description: Option<String>,
    pub owner: ClassOwner,
    pub relation: String,
    pub member_count: i64,
    pub assignment_count: i64,
    pub archived_at: Option<DateTime<Utc>>,
    pub created_at: DateTime<Utc>,
    #[serde(skip_serializing_if = "Option::is_none")]
    pub invite_code: Option<String>,
    #[serde(skip_serializing_if = "Option::is_none")]
    pub members: Option<Vec<ClassMemberView>>,
    pub assignments: Vec<AssignmentSummary>,
}

#[derive(Debug, Serialize)]
pub struct InviteCodeResponse {
    pub invite_code: String,
}

#[derive(Debug, Serialize)]
pub struct ClassMutationResponse {
    pub message: String,
}

// ---------------------------------------------------------------------------
// Assignments
// ---------------------------------------------------------------------------

#[derive(Debug, Deserialize, Clone)]
pub struct AssignmentProblemInput {
    pub problem_id: i32,
    pub points: i32,
}

#[derive(Debug, Deserialize)]
pub struct CreateAssignmentRequest {
    pub title: String,
    #[serde(default)]
    pub description: Option<String>,
    #[serde(default)]
    pub start_at: Option<DateTime<Utc>>,
    #[serde(default)]
    pub due_at: Option<DateTime<Utc>>,
    #[serde(default)]
    pub problems: Vec<AssignmentProblemInput>,
}

#[derive(Debug, Deserialize)]
pub struct AssignmentProblemsRequest {
    pub problems: Vec<AssignmentProblemInput>,
}

#[derive(Debug, Deserialize)]
pub struct UpdateAssignmentRequest {
    #[serde(default)]
    pub title: Option<String>,
    #[serde(default)]
    pub description: Option<String>,
    #[serde(default)]
    pub start_at: Option<DateTime<Utc>>,
    #[serde(default)]
    pub due_at: Option<DateTime<Utc>>,
    #[serde(default)]
    pub problems: Option<Vec<AssignmentProblemInput>>,
}

#[derive(Debug, Serialize, Clone)]
pub struct AssignmentSummary {
    pub id: i32,
    pub class_id: i32,
    pub title: String,
    pub description: Option<String>,
    pub status: String,
    pub start_at: Option<DateTime<Utc>>,
    pub due_at: Option<DateTime<Utc>>,
    pub published_at: Option<DateTime<Utc>>,
    pub grades_published_at: Option<DateTime<Utc>>,
    pub problem_count: i64,
    pub total_points: i64,
    pub my_accepted_count: i64,
    pub my_attempted_count: i64,
    #[serde(skip_serializing_if = "Option::is_none")]
    pub student_count: Option<i64>,
    #[serde(skip_serializing_if = "Option::is_none")]
    pub submitted_student_count: Option<i64>,
}

#[derive(Debug, Serialize)]
pub struct AssignmentListResponse {
    pub assignments: Vec<AssignmentSummary>,
}

#[derive(Debug, Serialize)]
pub struct AssignmentProblemView {
    pub problem_id: i32,
    pub title: String,
    pub difficulty: String,
    pub points: i32,
    pub position: i32,
    pub attempts: i64,
    pub accepted: bool,
    pub last_status: Option<String>,
    #[serde(skip_serializing_if = "Option::is_none")]
    pub auto_score: Option<i32>,
    #[serde(skip_serializing_if = "Option::is_none")]
    pub manual_score: Option<i32>,
    #[serde(skip_serializing_if = "Option::is_none")]
    pub final_score: Option<i32>,
    #[serde(skip_serializing_if = "Option::is_none")]
    pub feedback: Option<String>,
    #[serde(skip_serializing_if = "Option::is_none")]
    pub accepted_student_count: Option<i64>,
}

#[derive(Debug, Serialize)]
pub struct AssignmentDetail {
    pub id: i32,
    pub class_id: i32,
    pub class_name: String,
    pub title: String,
    pub description: Option<String>,
    pub status: String,
    pub start_at: Option<DateTime<Utc>>,
    pub due_at: Option<DateTime<Utc>>,
    pub published_at: Option<DateTime<Utc>>,
    pub grades_published_at: Option<DateTime<Utc>>,
    pub grades_published: bool,
    pub now: DateTime<Utc>,
    pub is_owner: bool,
    pub can_submit: bool,
    pub problems: Vec<AssignmentProblemView>,
    #[serde(skip_serializing_if = "Option::is_none")]
    pub total_score: Option<i32>,
    #[serde(skip_serializing_if = "Option::is_none")]
    pub overall_feedback: Option<String>,
    #[serde(skip_serializing_if = "Option::is_none")]
    pub student_count: Option<i64>,
    #[serde(skip_serializing_if = "Option::is_none")]
    pub submitted_student_count: Option<i64>,
}

#[derive(Debug, Deserialize, Default)]
pub struct AssignmentSubmissionListQuery {
    pub user_id: Option<i32>,
    pub problem_id: Option<i32>,
    pub page: Option<u32>,
    pub size: Option<u32>,
}

// ---------------------------------------------------------------------------
// Grading
// ---------------------------------------------------------------------------

#[derive(Debug, Deserialize, Default)]
pub struct GradebookQuery {
    #[serde(default)]
    pub include_removed: Option<u8>,
}

#[derive(Debug, Serialize)]
pub struct GradebookAssignment {
    pub id: i32,
    pub title: String,
    pub due_at: Option<DateTime<Utc>>,
    pub grades_published_at: Option<DateTime<Utc>>,
}

#[derive(Debug, Serialize)]
pub struct GradebookProblem {
    pub problem_id: i32,
    pub title: String,
    pub points: i32,
}

#[derive(Debug, Serialize)]
pub struct GradebookCell {
    pub problem_id: i32,
    pub attempts: i64,
    pub accepted: bool,
    pub auto_score: i32,
    pub manual_score: Option<i32>,
    pub final_score: i32,
    pub feedback: Option<String>,
    pub last_submission_id: Option<i32>,
    pub last_status: Option<String>,
}

#[derive(Debug, Serialize)]
pub struct GradebookStudent {
    pub user_id: i32,
    pub username: String,
    pub email: String,
    pub status: String,
    pub overall_feedback: Option<String>,
    pub total_score: i32,
    pub problems: Vec<GradebookCell>,
}

#[derive(Debug, Serialize)]
pub struct GradebookResponse {
    pub assignment: GradebookAssignment,
    pub problems: Vec<GradebookProblem>,
    pub students: Vec<GradebookStudent>,
}

#[derive(Debug, Deserialize)]
pub struct ProblemGradeRequest {
    pub manual_score: Option<i32>,
    #[serde(default)]
    pub feedback: Option<String>,
}

#[derive(Debug, Deserialize)]
pub struct OverallGradeRequest {
    #[serde(default)]
    pub overall_feedback: Option<String>,
}

#[derive(Debug, Serialize)]
pub struct GradeMutationResponse {
    pub message: String,
}

#[derive(Debug, Serialize)]
pub struct PublishGradesResponse {
    pub message: String,
    pub grades_published_at: DateTime<Utc>,
}

#[derive(Debug, Serialize)]
pub struct AssignmentMutationResponse {
    pub id: i32,
    pub message: String,
}
