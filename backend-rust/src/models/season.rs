use chrono::{DateTime, Utc};
use serde::{Deserialize, Serialize};

/// 对外展示的赛季信息。`state` 由时间计算，不落库，避免后台任务缺席时状态过期。
#[derive(Debug, Clone, Serialize)]
pub struct SeasonSummary {
    pub id: i32,
    pub name: String,
    pub starts_at: DateTime<Utc>,
    pub ends_at: DateTime<Utc>,
    pub status: String,
    pub soft_reset_ratio: f64,
    pub activated: bool,
    /// `upcoming` / `active` / `finished` / `cancelled`
    pub state: String,
}

#[derive(Debug, Serialize)]
pub struct SeasonListResponse {
    pub current: Option<SeasonSummary>,
    pub items: Vec<SeasonSummary>,
    pub server_time: DateTime<Utc>,
}

#[derive(Debug, Deserialize)]
pub struct AdminSeasonInput {
    pub name: String,
    pub starts_at: DateTime<Utc>,
    pub ends_at: DateTime<Utc>,
    #[serde(default)]
    pub soft_reset_ratio: Option<f64>,
    #[serde(default)]
    pub status: Option<String>,
}

#[derive(Debug, Serialize)]
pub struct AdminSeasonListResponse {
    pub items: Vec<SeasonSummary>,
}

pub const SEASON_STATUS_DRAFT: &str = "draft";
pub const SEASON_STATUS_PUBLISHED: &str = "published";
pub const SEASON_STATUS_CANCELLED: &str = "cancelled";

pub const SEASON_STATE_UPCOMING: &str = "upcoming";
pub const SEASON_STATE_ACTIVE: &str = "active";
pub const SEASON_STATE_FINISHED: &str = "finished";
pub const SEASON_STATE_CANCELLED: &str = "cancelled";
