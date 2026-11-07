use chrono::{DateTime, Utc};
use serde::{Deserialize, Serialize};

pub const MAX_SOLUTIONS: i64 = 5;
pub const MAX_SOLUTION_NAME_CHARS: usize = 60;

#[derive(Debug, Deserialize)]
pub struct CreateSolutionRequest {
    #[serde(default)]
    pub name: Option<String>,
    pub language: String,
    #[serde(default)]
    pub code: Option<String>,
}

#[derive(Debug, Deserialize)]
pub struct UpdateSolutionRequest {
    #[serde(default)]
    pub name: Option<String>,
    #[serde(default)]
    pub language: Option<String>,
    #[serde(default)]
    pub code: Option<String>,
}

/// 解法最近一次提交的摘要，用于在解法列表里显示状态与测试通过数
#[derive(Debug, Clone, Serialize)]
pub struct SolutionSubmissionView {
    pub id: i32,
    pub status: String,
    pub test_cases_passed: i32,
    pub total_test_cases: i32,
    pub runtime: Option<i32>,
    pub memory: Option<i32>,
    pub submitted_at: DateTime<Utc>,
}

#[derive(Debug, Clone, Serialize)]
pub struct SolutionView {
    pub id: i32,
    pub slot: i16,
    pub name: String,
    pub language: String,
    pub code: String,
    pub created_at: DateTime<Utc>,
    pub updated_at: DateTime<Utc>,
    pub last_submission: Option<SolutionSubmissionView>,
}

#[derive(Debug, Serialize)]
pub struct SolutionListResponse {
    pub max: i64,
    pub solutions: Vec<SolutionView>,
}
