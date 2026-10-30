use chrono::{DateTime, Utc};
use serde::{Deserialize, Serialize};
use serde_json::Value;
use sqlx::FromRow;

pub const REPORT_STATUS_OPEN: &str = "open";
pub const REPORT_STATUS_CONFIRMED: &str = "confirmed";
pub const REPORT_STATUS_DISMISSED: &str = "dismissed";
pub const REPORT_STATUS_APPEALED: &str = "appealed";
pub const REPORT_STATUS_UPHELD: &str = "upheld";
pub const REPORT_STATUS_OVERTURNED: &str = "overturned";

pub const APPEAL_STATUS_PENDING: &str = "pending";
pub const APPEAL_STATUS_UPHELD: &str = "upheld";
pub const APPEAL_STATUS_OVERTURNED: &str = "overturned";

pub const ACTION_CREATED: &str = "created";
pub const ACTION_CONFIRMED: &str = "confirmed";
pub const ACTION_DISMISSED: &str = "dismissed";
pub const ACTION_APPEALED: &str = "appealed";
pub const ACTION_UPHELD: &str = "upheld";
pub const ACTION_OVERTURNED: &str = "overturned";
pub const ACTION_PENALTY_RESTORED: &str = "penalty_restored";

#[derive(Debug, Deserialize)]
pub struct CheatReportQuery {
    pub status: Option<String>,
    pub assignment_id: Option<i32>,
    pub page: Option<u32>,
    pub size: Option<u32>,
}

#[derive(Debug, Deserialize)]
pub struct CheatReviewInput {
    pub decision: String,
    #[serde(default)]
    pub note: Option<String>,
    #[serde(default)]
    pub apply_zero: bool,
}

#[derive(Debug, Deserialize)]
pub struct AppealInput {
    pub reason: String,
}

#[derive(Debug, Deserialize)]
pub struct AppealResolveInput {
    pub decision: String,
    #[serde(default)]
    pub note: Option<String>,
}

#[derive(Debug, Serialize, Clone)]
pub struct CheatReportSummary {
    pub id: i64,
    pub status: String,
    pub severity: String,
    pub score: f64,
    pub created_at: DateTime<Utc>,
    pub decided_at: Option<DateTime<Utc>>,
    pub assignment_id: Option<i32>,
    pub assignment_title: Option<String>,
    pub class_id: Option<i32>,
    pub class_name: Option<String>,
    pub problem_id: i32,
    pub problem_title: String,
    pub target_user_id: i32,
    pub target_username: String,
    pub submission_id: i32,
    pub matched_submission_id: Option<i32>,
    pub matched_username: Option<String>,
    pub reviewer_id: Option<i32>,
    pub reviewer_username: Option<String>,
    pub appeal_status: Option<String>,
    pub penalty_applied: bool,
    pub decision_note: Option<String>,
}

#[derive(Debug, Serialize)]
pub struct CheatReportListResponse {
    pub total: i64,
    pub page: u32,
    pub size: u32,
    pub pending_count: i64,
    pub items: Vec<CheatReportSummary>,
}

#[derive(Debug, Serialize, FromRow)]
pub struct SubmissionEvidence {
    pub id: i32,
    pub user_id: i32,
    pub username: String,
    pub language: String,
    pub status: String,
    pub submitted_at: DateTime<Utc>,
    pub code: String,
}

#[derive(Debug, Serialize)]
pub struct EvidencePair {
    pub submission_id: i32,
    pub user_id: i32,
    pub username: String,
    pub language: String,
    pub submitted_at: DateTime<Utc>,
    pub score: f64,
    pub detail: Value,
    pub code: String,
}

#[derive(Debug, Serialize)]
pub struct AppealView {
    pub id: i64,
    pub reason: String,
    pub status: String,
    pub created_at: DateTime<Utc>,
    pub handled_by: Option<i32>,
    pub handled_by_username: Option<String>,
    pub handle_note: Option<String>,
    pub handled_at: Option<DateTime<Utc>>,
}

#[derive(Debug, Serialize)]
pub struct ReportActionView {
    pub action: String,
    pub actor_username: Option<String>,
    pub note: Option<String>,
    pub created_at: DateTime<Utc>,
}

#[derive(Debug, Serialize)]
pub struct CheatReportDetailResponse {
    pub report: CheatReportSummary,
    pub evidence: Evidence,
    pub appeal: Option<AppealView>,
    pub actions: Vec<ReportActionView>,
}

#[derive(Debug, Serialize)]
pub struct Evidence {
    pub algorithm: String,
    pub target_submission: SubmissionEvidence,
    pub pairs: Vec<EvidencePair>,
}

#[derive(Debug, Serialize)]
pub struct MyReportSummary {
    pub id: i64,
    pub status: String,
    pub severity: String,
    pub score: f64,
    pub created_at: DateTime<Utc>,
    pub decided_at: Option<DateTime<Utc>>,
    pub assignment_id: Option<i32>,
    pub assignment_title: Option<String>,
    pub problem_id: i32,
    pub problem_title: String,
    pub decision_note: Option<String>,
    pub penalty_applied: bool,
    pub appeal_status: Option<String>,
}

#[derive(Debug, Serialize)]
pub struct MyReportListResponse {
    pub items: Vec<MyReportSummary>,
}

#[derive(Debug, Serialize)]
pub struct MyReportDetailResponse {
    pub report: MyReportSummary,
    pub submission: SubmissionEvidence,
    pub appeal: Option<AppealView>,
    pub actions: Vec<ReportActionView>,
}

#[derive(Debug, Serialize)]
pub struct ReviewResponse {
    pub message: String,
    pub status: String,
    pub penalty_applied: bool,
}

#[derive(Debug, Serialize)]
pub struct AppealSubmitResponse {
    pub message: String,
    pub appeal_id: i64,
    pub status: String,
}

#[derive(Debug, Serialize)]
pub struct AppealQueueItem {
    pub appeal_id: i64,
    pub report_id: i64,
    pub reason: String,
    pub created_at: DateTime<Utc>,
    pub target_user_id: i32,
    pub target_username: String,
    pub assignment_id: Option<i32>,
    pub assignment_title: Option<String>,
    pub problem_id: i32,
    pub problem_title: String,
    pub score: f64,
    pub severity: String,
    pub decision_note: Option<String>,
    pub decided_at: Option<DateTime<Utc>>,
}

#[derive(Debug, Serialize)]
pub struct AppealQueueResponse {
    pub total: i64,
    pub page: u32,
    pub size: u32,
    pub items: Vec<AppealQueueItem>,
}

#[derive(Debug, Serialize)]
pub struct AppealResolveResponse {
    pub message: String,
    pub appeal_status: String,
    pub report_status: String,
    pub penalty_restored: bool,
}
