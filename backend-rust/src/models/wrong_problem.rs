use chrono::{DateTime, Utc};
use serde::{Deserialize, Serialize};

#[derive(Debug, Deserialize)]
pub struct WrongProblemListQuery {
    pub page: Option<u32>,
    pub size: Option<u32>,
    pub difficulty: Option<String>,
    pub tag: Option<String>,
    pub sort: Option<String>,
}

#[derive(Debug, Serialize)]
pub struct WrongProblemItem {
    pub problem_id: i32,
    pub title: String,
    pub difficulty: String,
    pub tags: Vec<String>,
    pub acceptance_rate: f64,
    pub attempt_count: i64,
    pub last_failed_at: DateTime<Utc>,
    pub last_status: String,
    pub last_language: String,
    pub last_test_cases_passed: i32,
    pub last_total_test_cases: i32,
}

#[derive(Debug, Serialize)]
pub struct WrongProblemListResponse {
    pub total: i64,
    pub page: u32,
    pub size: u32,
    pub problems: Vec<WrongProblemItem>,
}

#[derive(Debug, Serialize)]
pub struct WrongProblemDismissResponse {
    pub dismissed: bool,
}
