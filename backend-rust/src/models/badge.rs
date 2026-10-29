use chrono::{DateTime, Utc};
use serde::{Deserialize, Serialize};

#[derive(Debug, Serialize)]
pub struct BadgeItem {
    pub code: String,
    pub name: String,
    pub description: String,
    pub category: String,
    pub threshold_days: i32,
    pub earned: bool,
    pub awarded_at: Option<DateTime<Utc>>,
    pub expires_at: Option<DateTime<Utc>>,
    pub hidden: bool,
}

#[derive(Debug, Serialize)]
pub struct BadgeListResponse {
    pub badges: Vec<BadgeItem>,
}

#[derive(Debug, Deserialize)]
pub struct UpdateBadgeVisibilityRequest {
    pub hidden: bool,
}

#[derive(Debug, Serialize)]
pub struct UpdateBadgeVisibilityResponse {
    pub code: String,
    pub hidden: bool,
    pub message: String,
}
