use chrono::{DateTime, Utc};
use serde::{Deserialize, Serialize};
use serde_json::Value;
use sqlx::FromRow;

use crate::models::run::RunCaseResult;

pub const SUBMISSION_STATUS_PENDING: &str = "pending";
pub const SUBMISSION_STATUS_JUDGING: &str = "judging";
pub const SUBMISSION_STATUS_ACCEPTED: &str = "accepted";
pub const SUBMISSION_STATUS_WRONG_ANSWER: &str = "wrong_answer";
pub const SUBMISSION_STATUS_TIME_LIMIT_EXCEEDED: &str = "time_limit_exceeded";
pub const SUBMISSION_STATUS_MEMORY_LIMIT_EXCEEDED: &str = "memory_limit_exceeded";
pub const SUBMISSION_STATUS_RUNTIME_ERROR: &str = "runtime_error";
pub const SUBMISSION_STATUS_COMPILE_ERROR: &str = "compile_error";
pub const SUBMISSION_STATUS_INTERNAL_ERROR: &str = "internal_error";

pub fn is_terminal_status(status: &str) -> bool {
    matches!(
        status,
        SUBMISSION_STATUS_ACCEPTED
            | SUBMISSION_STATUS_WRONG_ANSWER
            | SUBMISSION_STATUS_TIME_LIMIT_EXCEEDED
            | SUBMISSION_STATUS_MEMORY_LIMIT_EXCEEDED
            | SUBMISSION_STATUS_RUNTIME_ERROR
            | SUBMISSION_STATUS_COMPILE_ERROR
            | SUBMISSION_STATUS_INTERNAL_ERROR
    )
}

#[derive(Debug, Clone, FromRow)]
pub struct SubmissionRow {
    pub id: i32,
    pub user_id: i32,
    pub problem_id: i32,
    pub assignment_id: Option<i32>,
    pub problem_title: String,
    pub language: String,
    pub code: String,
    pub status: String,
    pub test_cases_passed: i32,
    pub total_test_cases: i32,
    pub runtime: Option<i32>,
    pub memory: Option<i32>,
    pub error_message: Option<String>,
    pub run_config_snapshot: Option<Value>,
    pub judge_cases_snapshot: Option<Value>,
    pub cases: Value,
    pub compile_output: Option<String>,
    pub attempt_count: i32,
    pub submitted_at: DateTime<Utc>,
    pub started_at: Option<DateTime<Utc>>,
    pub finished_at: Option<DateTime<Utc>>,
}

impl SubmissionRow {
    pub fn updated_at(&self) -> DateTime<Utc> {
        self.finished_at
            .or(self.started_at)
            .unwrap_or(self.submitted_at)
    }

    pub fn status_response(&self) -> SubmissionStatusResponse {
        SubmissionStatusResponse {
            id: self.id,
            status: self.status.clone(),
            test_cases_passed: self.test_cases_passed,
            total_test_cases: self.total_test_cases,
            error_message: self.error_message.clone(),
            updated_at: self.updated_at(),
        }
    }
}

/// A single case as exposed to the submitter. Only the first non-passing case
/// is ever returned, and `expected` is omitted unless the verdict is
/// `wrong_answer` so hidden inputs stay hidden.
#[derive(Debug, Serialize)]
pub struct SubmissionCaseView {
    pub index: i32,
    pub args: Value,
    #[serde(skip_serializing_if = "Option::is_none")]
    pub expected: Option<Value>,
    pub actual: Option<Value>,
    pub stdout: String,
    pub stderr: String,
    pub status: String,
}

fn first_failed_case(cases: &Value, status: &str) -> Option<SubmissionCaseView> {
    if !matches!(
        status,
        SUBMISSION_STATUS_WRONG_ANSWER
            | SUBMISSION_STATUS_TIME_LIMIT_EXCEEDED
            | SUBMISSION_STATUS_MEMORY_LIMIT_EXCEEDED
            | SUBMISSION_STATUS_RUNTIME_ERROR
    ) {
        return None;
    }
    let results: Vec<RunCaseResult> = serde_json::from_value(cases.clone()).ok()?;
    let failed = results
        .into_iter()
        .find(|case| case.status != "passed" && case.status != "skipped")?;
    Some(SubmissionCaseView {
        index: failed.index,
        args: failed.args,
        expected: (status == SUBMISSION_STATUS_WRONG_ANSWER)
            .then_some(failed.expected)
            .flatten(),
        actual: failed.actual,
        stdout: failed.stdout,
        stderr: failed.stderr,
        status: failed.status,
    })
}

#[derive(Debug, Serialize)]
pub struct SubmissionResponse {
    pub id: i32,
    pub problem_id: i32,
    pub assignment_id: Option<i32>,
    pub problem_title: String,
    pub language: String,
    pub code: String,
    pub status: String,
    pub test_cases_passed: i32,
    pub total_test_cases: i32,
    pub runtime: Option<i32>,
    pub memory: Option<i32>,
    pub compile_output: Option<String>,
    pub error_message: Option<String>,
    pub failed_case: Option<SubmissionCaseView>,
    pub submitted_at: DateTime<Utc>,
    pub finished_at: Option<DateTime<Utc>>,
}

impl From<SubmissionRow> for SubmissionResponse {
    fn from(row: SubmissionRow) -> Self {
        let failed_case = first_failed_case(&row.cases, &row.status);
        Self {
            id: row.id,
            problem_id: row.problem_id,
            assignment_id: row.assignment_id,
            problem_title: row.problem_title,
            language: row.language,
            code: row.code,
            status: row.status,
            test_cases_passed: row.test_cases_passed,
            total_test_cases: row.total_test_cases,
            runtime: row.runtime,
            memory: row.memory,
            compile_output: row.compile_output,
            error_message: row.error_message,
            failed_case,
            submitted_at: row.submitted_at,
            finished_at: row.finished_at,
        }
    }
}

#[derive(Debug, Deserialize)]
pub struct SubmissionRequest {
    pub problem_id: i32,
    pub language: String,
    pub code: String,
    #[serde(default)]
    pub assignment_id: Option<i32>,
}

#[derive(Debug, Serialize)]
pub struct SubmissionCreatedResponse {
    pub submission_id: i32,
    pub status: String,
    pub message: String,
}

#[derive(Debug, Serialize)]
pub struct SubmissionStatusResponse {
    pub id: i32,
    pub status: String,
    pub test_cases_passed: i32,
    pub total_test_cases: i32,
    pub error_message: Option<String>,
    pub updated_at: DateTime<Utc>,
}

#[derive(Debug, Deserialize, Default)]
pub struct SubmissionListQuery {
    pub user_id: Option<i32>,
    pub problem_id: Option<i32>,
    pub page: Option<u32>,
    pub size: Option<u32>,
}

/// List entries intentionally omit `code`: a page of submissions should not
/// carry full source files. The detail endpoint returns the code for the owner
/// or an admin.
#[derive(Debug, Serialize, FromRow)]
pub struct SubmissionSummary {
    pub id: i32,
    pub problem_id: i32,
    pub problem_title: String,
    pub language: String,
    pub status: String,
    pub test_cases_passed: i32,
    pub total_test_cases: i32,
    pub runtime: Option<i32>,
    pub memory: Option<i32>,
    pub error_message: Option<String>,
    pub submitted_at: DateTime<Utc>,
}

#[derive(Debug, Serialize)]
pub struct SubmissionListResponse {
    pub total: i64,
    pub page: u32,
    pub size: u32,
    pub submissions: Vec<SubmissionSummary>,
}

#[cfg(test)]
mod tests {
    use serde_json::json;

    use super::{SUBMISSION_STATUS_ACCEPTED, first_failed_case, is_terminal_status};

    #[test]
    fn terminal_statuses_are_recognized() {
        assert!(is_terminal_status(SUBMISSION_STATUS_ACCEPTED));
        assert!(!is_terminal_status("pending"));
        assert!(!is_terminal_status("judging"));
    }

    #[test]
    fn only_first_failed_case_is_exposed() {
        let cases = json!([
            {"index": 0, "args": [[1, 2]], "expected": [1], "actual": [1], "status": "passed"},
            {"index": 1, "args": [[9, 9]], "expected": [0], "actual": [1], "status": "failed"},
            {"index": 2, "args": [[7, 7]], "expected": [2], "actual": [3], "status": "failed"}
        ]);
        let failed = first_failed_case(&cases, "wrong_answer").expect("should expose a case");
        assert_eq!(failed.index, 1);
        assert_eq!(failed.expected, Some(json!([0])));
    }

    #[test]
    fn runtime_errors_hide_expected_output() {
        let cases = json!([
            {"index": 0, "args": [[1, 2]], "expected": [1], "status": "runtime_error", "stderr": "boom"}
        ]);
        let failed = first_failed_case(&cases, "runtime_error").expect("should expose a case");
        assert!(failed.expected.is_none());
        assert_eq!(failed.stderr, "boom");
    }

    #[test]
    fn accepted_and_compile_error_expose_nothing() {
        let cases = json!([
            {"index": 0, "args": [[1, 2]], "expected": [1], "status": "passed"}
        ]);
        assert!(first_failed_case(&cases, "accepted").is_none());
        assert!(first_failed_case(&cases, "compile_error").is_none());
    }
}
