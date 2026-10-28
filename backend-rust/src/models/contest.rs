use chrono::{DateTime, Utc};
use serde::{Deserialize, Serialize};
use serde_json::Value;
use sqlx::FromRow;

pub const CONTEST_STATUS_MATCHING: &str = "matching";
pub const CONTEST_STATUS_RUNNING: &str = "running";
pub const CONTEST_STATUS_SETTLING: &str = "settling";
pub const CONTEST_STATUS_FINISHED: &str = "finished";
pub const CONTEST_STATUS_CANCELLED: &str = "cancelled";

pub const PARTICIPANT_STATUS_QUEUED: &str = "queued";
pub const PARTICIPANT_STATUS_ACTIVE: &str = "active";
pub const PARTICIPANT_STATUS_FINISHED: &str = "finished";

/// Only players whose rating spread fits inside this window may share a room.
/// This deliberately favors fair matches over fast matches.
pub const RATING_WINDOW: i32 = 100;
pub const DEFAULT_CONTEST_RATING: i32 = 1000;
pub const RATING_GAIN_FIRST: i32 = 30;
pub const RATING_GAIN_SECOND: i32 = 10;
pub const RATING_LOSS_FOURTH: i32 = 20;

pub const CAMERA_PERMISSIONS: [&str; 3] = ["granted", "denied", "unavailable"];
pub const CONTEST_EVENT_TYPES: [&str; 5] = [
    "camera_permission",
    "visibility_hidden",
    "visibility_visible",
    "paste",
    "camera_unavailable",
];

#[derive(Debug, Deserialize, Default)]
pub struct MatchRequest {
    #[serde(default)]
    pub camera_permission: Option<String>,
}

#[derive(Debug, Serialize, Clone)]
pub struct ContestSummary {
    pub id: i32,
    pub status: String,
    pub duration_seconds: i32,
    pub problem_count: i32,
    pub starts_at: DateTime<Utc>,
    pub ends_at: DateTime<Utc>,
    pub finished_at: Option<DateTime<Utc>>,
    pub participant_count: i64,
    pub my_status: String,
    pub server_time: DateTime<Utc>,
}

#[derive(Debug, Serialize)]
pub struct MatchResponse {
    pub state: String,
    pub queue_position: Option<i64>,
    pub contest: Option<ContestSummary>,
    pub message: String,
}

#[derive(Debug, Serialize)]
pub struct CurrentContestResponse {
    pub state: String,
    pub queue_position: Option<i64>,
    pub queued_at: Option<DateTime<Utc>>,
    pub contest: Option<ContestSummary>,
    pub my_rating: i32,
    pub rating_window: i32,
    pub server_time: DateTime<Utc>,
}

#[derive(Debug, Serialize)]
pub struct CancelMatchResponse {
    pub message: String,
}

#[derive(Debug, Serialize)]
pub struct FinishContestResponse {
    pub finished: bool,
    pub message: String,
}

#[derive(Debug, Serialize, FromRow)]
pub struct ContestProblemSummary {
    pub problem_id: i32,
    pub position: i32,
    pub title: String,
    pub difficulty: String,
    pub tags: Vec<String>,
    pub points: i32,
    pub accepted: bool,
    pub attempts: i64,
}

#[derive(Debug, Serialize)]
pub struct ContestParticipantView {
    pub user_id: i32,
    pub username: String,
    pub status: String,
    pub finished_at: Option<DateTime<Utc>>,
    pub solved_count: i32,
    pub total_score: Option<f64>,
    pub rank: Option<i32>,
}

#[derive(Debug, Serialize)]
pub struct ContestDetailResponse {
    pub id: i32,
    pub status: String,
    pub duration_seconds: i32,
    pub problem_count: i32,
    pub starts_at: DateTime<Utc>,
    pub ends_at: DateTime<Utc>,
    pub finished_at: Option<DateTime<Utc>>,
    pub server_time: DateTime<Utc>,
    pub my_status: String,
    pub my_rank: Option<i32>,
    pub my_total_score: Option<f64>,
    pub my_rating: i32,
    pub rating_window: i32,
    pub problems: Vec<ContestProblemSummary>,
    pub participants: Vec<ContestParticipantView>,
}

/// Frozen problem payload. Mirrors the public problem response so the existing
/// problem-solving page can render it without special casing.
#[derive(Debug, Serialize)]
pub struct ContestProblemDetail {
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

#[derive(Debug, FromRow)]
pub struct ContestProblemDetailRow {
    pub problem_id: i32,
    pub title: String,
    pub description: String,
    pub difficulty: String,
    pub time_limit: i32,
    pub memory_limit: i32,
    pub tags: Vec<String>,
    pub examples: Value,
    pub code_template: Value,
    pub run_config: Value,
}

impl ContestProblemDetailRow {
    pub fn into_detail(self) -> ContestProblemDetail {
        ContestProblemDetail {
            id: self.problem_id,
            title: self.title,
            description: self.description,
            difficulty: self.difficulty,
            time_limit: self.time_limit,
            memory_limit: self.memory_limit,
            tags: self.tags,
            examples: self.examples,
            code_template: self.code_template,
            run_config: Some(self.run_config),
            acceptance_rate: 0.0,
            submit_count: 0,
            accept_count: 0,
            status: None,
        }
    }
}

#[derive(Debug, Serialize, Clone)]
pub struct ContestRankingItem {
    pub rank: i32,
    pub user_id: i32,
    pub username: String,
    pub total_score: f64,
    pub solved_count: i32,
    pub speed_score: f64,
    pub coding_score: f64,
    pub finished_at: Option<DateTime<Utc>>,
    pub is_me: bool,
    pub rating_before: Option<i32>,
    pub rating_after: Option<i32>,
    pub rating_delta: Option<i32>,
}

#[derive(Debug, Serialize, Deserialize)]
pub struct ContestScoreDetail {
    pub problem_id: i32,
    pub title: String,
    pub accepted: bool,
    pub accepted_at: Option<DateTime<Utc>>,
    pub attempts: i64,
    pub wrong_answer: i64,
    pub compile_error: i64,
    pub runtime_error: i64,
    pub time_score: f64,
}

#[derive(Debug, Serialize)]
pub struct ContestResultContest {
    pub id: i32,
    pub status: String,
    pub duration_seconds: i32,
    pub problem_count: i32,
    pub starts_at: DateTime<Utc>,
    pub ends_at: DateTime<Utc>,
    pub finished_at: Option<DateTime<Utc>>,
}

#[derive(Debug, Serialize)]
pub struct ContestResultMine {
    #[serde(flatten)]
    pub ranking: ContestRankingItem,
    pub detail: Vec<ContestScoreDetail>,
}

#[derive(Debug, Serialize)]
pub struct ContestResultResponse {
    pub contest: ContestResultContest,
    pub ranking: Vec<ContestRankingItem>,
    pub mine: Option<ContestResultMine>,
}

#[derive(Debug, Deserialize)]
pub struct ContestEventsRequest {
    pub events: Vec<ContestEventInput>,
}

#[derive(Debug, Clone, Deserialize)]
pub struct ContestEventInput {
    pub event_id: String,
    pub event_type: String,
    #[serde(default)]
    pub client_time: Option<DateTime<Utc>>,
    #[serde(default)]
    pub session_id: Option<String>,
    #[serde(default)]
    pub payload: Option<Value>,
}

#[derive(Debug, Serialize)]
pub struct ContestEventsResponse {
    pub accepted: u64,
    pub duplicates: u64,
    pub message: String,
}

#[derive(Debug, FromRow)]
pub struct ContestRow {
    pub id: i32,
    pub status: String,
    pub duration_seconds: i32,
    pub problem_count: i32,
    pub starts_at: DateTime<Utc>,
    pub ends_at: DateTime<Utc>,
    pub finished_at: Option<DateTime<Utc>>,
    pub solve_weight: f64,
    pub speed_weight: f64,
    pub coding_weight: f64,
}

#[derive(Debug, FromRow)]
pub struct ContestParticipantRow {
    pub user_id: i32,
    pub username: String,
    pub status: String,
    pub finished_at: Option<DateTime<Utc>>,
    pub total_score: Option<f64>,
    pub rank: Option<i32>,
    pub solved_count: i32,
}
