use chrono::{DateTime, Utc};
use serde::{Deserialize, Serialize};
use sqlx::FromRow;

#[derive(Debug, Clone, FromRow)]
pub struct SubmissionRow {
    pub id: i32,
    pub user_id: i32,
    pub problem_id: i32,
    pub problem_title: String,
    pub language: String,
    pub code: String,
    pub status: String,
    pub test_cases_passed: i32,
    pub total_test_cases: i32,
    pub runtime: Option<i32>,
    pub memory: Option<i32>,
    pub error_message: Option<String>,
    pub submitted_at: DateTime<Utc>,
}

#[derive(Debug, Serialize)]
pub struct SubmissionResponse {
    pub id: i32,
    pub problem_id: i32,
    pub problem_title: String,
    pub language: String,
    pub code: String,
    pub status: String,
    pub test_cases_passed: i32,
    pub total_test_cases: i32,
    pub runtime: Option<i32>,
    pub memory: Option<i32>,
    pub error_message: Option<String>,
    pub submitted_at: DateTime<Utc>,
}

impl From<SubmissionRow> for SubmissionResponse {
    fn from(row: SubmissionRow) -> Self {
        Self {
            id: row.id,
            problem_id: row.problem_id,
            problem_title: row.problem_title,
            language: row.language,
            code: row.code,
            status: row.status,
            test_cases_passed: row.test_cases_passed,
            total_test_cases: row.total_test_cases,
            runtime: row.runtime,
            memory: row.memory,
            error_message: row.error_message,
            submitted_at: row.submitted_at,
        }
    }
}

#[derive(Debug, Deserialize)]
pub struct SubmissionRequest {
    pub problem_id: i32,
    pub language: String,
    pub code: String,
}

#[derive(Debug, Serialize)]
pub struct SubmissionCreatedResponse {
    pub submission_id: i32,
    pub status: String,
    pub message: String,
}

#[derive(Debug, Deserialize, Default)]
pub struct SubmissionListQuery {
    pub user_id: Option<i32>,
    pub problem_id: Option<i32>,
    pub page: Option<u32>,
    pub size: Option<u32>,
}

#[derive(Debug, Serialize)]
pub struct SubmissionListResponse {
    pub total: i64,
    pub page: u32,
    pub size: u32,
    pub submissions: Vec<SubmissionResponse>,
}
