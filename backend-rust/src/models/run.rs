use chrono::{DateTime, Utc};
use serde::{Deserialize, Serialize};
use serde_json::Value;
use sqlx::FromRow;

pub const RUN_STATUS_QUEUED: &str = "queued";
pub const RUN_STATUS_COMPILING: &str = "compiling";
pub const RUN_STATUS_RUNNING: &str = "running";
pub const RUN_STATUS_COMPLETED: &str = "completed";
pub const RUN_STATUS_COMPILE_ERROR: &str = "compile_error";
pub const RUN_STATUS_RUNTIME_ERROR: &str = "runtime_error";
pub const RUN_STATUS_TIME_LIMIT_EXCEEDED: &str = "time_limit_exceeded";
pub const RUN_STATUS_MEMORY_LIMIT_EXCEEDED: &str = "memory_limit_exceeded";
pub const RUN_STATUS_INTERNAL_ERROR: &str = "internal_error";

pub fn is_terminal_status(status: &str) -> bool {
    matches!(
        status,
        RUN_STATUS_COMPLETED
            | RUN_STATUS_COMPILE_ERROR
            | RUN_STATUS_RUNTIME_ERROR
            | RUN_STATUS_TIME_LIMIT_EXCEEDED
            | RUN_STATUS_MEMORY_LIMIT_EXCEEDED
            | RUN_STATUS_INTERNAL_ERROR
    )
}

#[derive(Debug, Clone, Serialize, Deserialize)]
pub struct RunParam {
    pub name: String,
    #[serde(rename = "type")]
    pub param_type: String,
}

#[derive(Debug, Clone, Serialize, Deserialize)]
pub struct CompareConfig {
    pub mode: String,
    #[serde(default)]
    pub epsilon: Option<f64>,
}

#[derive(Debug, Clone, Serialize, Deserialize)]
pub struct PublicCase {
    pub args: Vec<Value>,
    pub expected: Value,
}

#[derive(Debug, Clone, Serialize, Deserialize)]
pub struct RunConfig {
    pub version: u32,
    pub function_name: String,
    pub params: Vec<RunParam>,
    pub return_type: String,
    pub compare: CompareConfig,
    #[serde(default)]
    pub public_cases: Vec<PublicCase>,
}

#[derive(Debug, Deserialize)]
pub struct RunCreateRequest {
    pub problem_id: i32,
    pub language: String,
    pub mode: String,
    pub code: String,
    #[serde(default)]
    pub input: Option<Value>,
}

#[derive(Debug, Serialize)]
pub struct RunCreateResponse {
    pub run_id: i64,
    pub status: String,
}

#[derive(Debug, Serialize)]
pub struct RunStatusResponse {
    pub id: i64,
    pub status: String,
    pub case_passed: i32,
    pub case_total: i32,
    pub error_message: Option<String>,
    pub updated_at: DateTime<Utc>,
}

#[derive(Debug, Clone, Serialize, Deserialize, Default)]
pub struct RunCaseResult {
    pub index: i32,
    pub args: Value,
    #[serde(default, skip_serializing_if = "Option::is_none")]
    pub expected: Option<Value>,
    pub actual: Option<Value>,
    #[serde(default)]
    pub stdout: String,
    #[serde(default)]
    pub stderr: String,
    pub status: String,
    #[serde(default, skip_serializing_if = "Option::is_none")]
    pub matched: Option<bool>,
    #[serde(default, skip_serializing_if = "Option::is_none")]
    pub runtime_ms: Option<i32>,
    #[serde(default, skip_serializing_if = "Option::is_none")]
    pub memory_kb: Option<i32>,
    #[serde(default)]
    pub truncated: bool,
}

#[derive(Debug, Clone, FromRow)]
pub struct CodeRunRow {
    pub id: i64,
    pub user_id: i32,
    pub problem_id: Option<i32>,
    pub problem_title: String,
    pub language: String,
    pub mode: String,
    pub code: String,
    pub input: Option<Value>,
    pub run_config_snapshot: Value,
    pub status: String,
    pub cases: Value,
    pub case_total: i32,
    pub case_passed: i32,
    pub compile_output: Option<String>,
    pub error_message: Option<String>,
    pub runtime_ms: Option<i32>,
    pub memory_kb: Option<i32>,
    pub attempt_count: i32,
    pub created_at: DateTime<Utc>,
    pub started_at: Option<DateTime<Utc>>,
    pub finished_at: Option<DateTime<Utc>>,
}

impl CodeRunRow {
    pub fn updated_at(&self) -> DateTime<Utc> {
        self.finished_at
            .or(self.started_at)
            .unwrap_or(self.created_at)
    }

    pub fn status_response(&self) -> RunStatusResponse {
        RunStatusResponse {
            id: self.id,
            status: self.status.clone(),
            case_passed: self.case_passed,
            case_total: self.case_total,
            error_message: self.error_message.clone(),
            updated_at: self.updated_at(),
        }
    }
}

#[derive(Debug, Deserialize)]
pub struct RunListQuery {
    pub page: Option<u32>,
    pub size: Option<u32>,
    pub problem_id: Option<i32>,
}

#[derive(Debug, Serialize, FromRow)]
pub struct RunSummary {
    pub id: i64,
    pub problem_id: Option<i32>,
    pub problem_title: String,
    pub language: String,
    pub mode: String,
    pub status: String,
    pub case_passed: i32,
    pub case_total: i32,
    pub created_at: DateTime<Utc>,
}

#[derive(Debug, Serialize)]
pub struct RunListResponse {
    pub total: i64,
    pub page: u32,
    pub size: u32,
    pub runs: Vec<RunSummary>,
}

#[derive(Debug, Serialize)]
pub struct RunDetailResponse {
    pub id: i64,
    pub problem_id: Option<i32>,
    pub problem_title: String,
    pub language: String,
    pub mode: String,
    pub code: String,
    pub input: Option<Value>,
    pub status: String,
    pub case_passed: i32,
    pub case_total: i32,
    pub compile_output: Option<String>,
    pub error_message: Option<String>,
    pub runtime_ms: Option<i32>,
    pub memory_kb: Option<i32>,
    pub created_at: DateTime<Utc>,
    pub started_at: Option<DateTime<Utc>>,
    pub finished_at: Option<DateTime<Utc>>,
    pub cases: Value,
}

impl From<CodeRunRow> for RunDetailResponse {
    fn from(row: CodeRunRow) -> Self {
        Self {
            id: row.id,
            problem_id: row.problem_id,
            problem_title: row.problem_title,
            language: row.language,
            mode: row.mode,
            code: row.code,
            input: row.input,
            status: row.status,
            case_passed: row.case_passed,
            case_total: row.case_total,
            compile_output: row.compile_output,
            error_message: row.error_message,
            runtime_ms: row.runtime_ms,
            memory_kb: row.memory_kb,
            created_at: row.created_at,
            started_at: row.started_at,
            finished_at: row.finished_at,
            cases: row.cases,
        }
    }
}

#[cfg(test)]
mod tests {
    use super::{RUN_STATUS_COMPLETED, RUN_STATUS_QUEUED, RUN_STATUS_RUNNING, is_terminal_status};

    #[test]
    fn terminal_statuses_are_recognized() {
        assert!(is_terminal_status(RUN_STATUS_COMPLETED));
        assert!(!is_terminal_status(RUN_STATUS_QUEUED));
        assert!(!is_terminal_status(RUN_STATUS_RUNNING));
    }
}
