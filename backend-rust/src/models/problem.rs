use serde::{Deserialize, Serialize};
use serde_json::Value;
use sqlx::FromRow;

#[derive(Debug, Clone, FromRow)]
pub struct ProblemRow {
    pub id: i32,
    pub title: String,
    pub description: String,
    pub difficulty: String,
    pub time_limit: i32,
    pub memory_limit: i32,
    pub tags: Vec<String>,
    pub examples: Option<Value>,
    pub test_cases: Option<Value>,
    pub code_template: Option<Value>,
    pub run_config: Option<Value>,
    pub acceptance_rate: f64,
    pub submit_count: i32,
    pub accept_count: i32,
}

#[derive(Debug, Clone, Serialize)]
pub struct ProblemResponse {
    pub id: i32,
    pub title: String,
    pub description: String,
    pub difficulty: String,
    pub time_limit: i32,
    pub memory_limit: i32,
    pub tags: Vec<String>,
    pub examples: Value,
    pub code_template: Value,
    pub run_config: Option<Value>,
    pub acceptance_rate: f64,
    pub submit_count: i32,
    pub accept_count: i32,
    pub status: Option<String>,
}

impl ProblemRow {
    pub fn response(self, status: Option<String>) -> ProblemResponse {
        ProblemResponse {
            id: self.id,
            title: self.title,
            description: self.description,
            difficulty: self.difficulty,
            time_limit: self.time_limit,
            memory_limit: self.memory_limit,
            tags: self.tags,
            examples: self.examples.unwrap_or_else(|| Value::Array(Vec::new())),
            code_template: self
                .code_template
                .unwrap_or_else(|| Value::Object(Default::default())),
            run_config: self.run_config,
            acceptance_rate: self.acceptance_rate,
            submit_count: self.submit_count,
            accept_count: self.accept_count,
            status,
        }
    }
}

#[derive(Debug, Deserialize)]
pub struct ProblemRequest {
    pub title: String,
    pub description: String,
    pub difficulty: String,
    pub time_limit: Option<i32>,
    pub memory_limit: Option<i32>,
    pub tags: Option<Vec<String>>,
    pub examples: Option<Value>,
    pub test_cases: Option<Value>,
    pub code_template: Option<Value>,
    pub run_config: Option<Value>,
    /// Hidden cases used only for submission judging. Never returned by the
    /// public problem endpoints.
    pub judge_cases: Option<Value>,
}

/// Full problem payload for the admin editor. The public detail endpoint
/// intentionally omits `test_cases` and `judge_cases`.
#[derive(Debug, Serialize, FromRow)]
pub struct AdminProblemResponse {
    pub id: i32,
    pub title: String,
    pub description: String,
    pub difficulty: String,
    pub time_limit: i32,
    pub memory_limit: i32,
    pub tags: Vec<String>,
    pub examples: Option<Value>,
    pub test_cases: Option<Value>,
    pub code_template: Option<Value>,
    pub run_config: Option<Value>,
    pub judge_cases: Option<Value>,
    pub acceptance_rate: f64,
    pub submit_count: i32,
    pub accept_count: i32,
    pub review_status: String,
    pub review_note: Option<String>,
    pub created_by: Option<i32>,
    pub created_by_username: Option<String>,
    pub reviewed_by: Option<i32>,
    pub reviewed_at: Option<chrono::DateTime<chrono::Utc>>,
    pub created_at: chrono::DateTime<chrono::Utc>,
    pub updated_at: chrono::DateTime<chrono::Utc>,
}

#[derive(Debug, Deserialize, Default)]
pub struct AdminProblemListQuery {
    pub page: Option<u32>,
    pub size: Option<u32>,
    pub status: Option<String>,
    pub q: Option<String>,
}

#[derive(Debug, Serialize, FromRow)]
pub struct AdminProblemListItem {
    pub id: i32,
    pub title: String,
    pub difficulty: String,
    pub created_by: Option<i32>,
    pub created_by_username: Option<String>,
    pub review_status: String,
    pub review_note: Option<String>,
    pub reviewed_at: Option<chrono::DateTime<chrono::Utc>>,
    pub created_at: chrono::DateTime<chrono::Utc>,
    pub updated_at: chrono::DateTime<chrono::Utc>,
}

#[derive(Debug, Serialize)]
pub struct AdminProblemListResponse {
    pub total: i64,
    pub page: u32,
    pub size: u32,
    pub problems: Vec<AdminProblemListItem>,
}

#[derive(Debug, Deserialize, Default)]
pub struct MyProblemListQuery {
    pub page: Option<u32>,
    pub size: Option<u32>,
    pub status: Option<String>,
}

#[derive(Debug, Serialize, FromRow)]
pub struct MyProblemListItem {
    pub id: i32,
    pub title: String,
    pub difficulty: String,
    pub review_status: String,
    pub review_note: Option<String>,
    pub reviewed_at: Option<chrono::DateTime<chrono::Utc>>,
    pub created_at: chrono::DateTime<chrono::Utc>,
    pub updated_at: chrono::DateTime<chrono::Utc>,
}

#[derive(Debug, Serialize)]
pub struct MyProblemListResponse {
    pub total: i64,
    pub page: u32,
    pub size: u32,
    pub problems: Vec<MyProblemListItem>,
}

#[derive(Debug, Deserialize, Default)]
pub struct ProblemListQuery {
    pub page: Option<u32>,
    pub size: Option<u32>,
    pub difficulty: Option<String>,
    pub tag: Option<String>,
    pub status: Option<String>,
    pub search: Option<String>,
    pub sort: Option<String>,
    pub order: Option<String>,
}

#[derive(Debug, Serialize, sqlx::FromRow)]
pub struct StatsResponse {
    pub total_problems: i64,
    pub total_submissions: i64,
    pub accepted_submissions: i64,
}

#[derive(Debug, Serialize)]
pub struct ProblemListResponse {
    pub total: i64,
    pub page: u32,
    pub size: u32,
    pub problems: Vec<ProblemResponse>,
}

#[derive(Debug, Serialize)]
pub struct ProblemMutationResponse {
    pub id: i32,
    pub message: String,
}

#[derive(Debug, Deserialize)]
pub struct ProblemReviewRequest {
    pub status: String,
    pub note: Option<String>,
}

#[derive(Debug, Serialize, sqlx::FromRow)]
pub struct PendingProblemResponse {
    pub id: i32,
    pub title: String,
    pub difficulty: String,
    pub created_by: Option<i32>,
    pub review_status: String,
    pub created_at: chrono::DateTime<chrono::Utc>,
}
