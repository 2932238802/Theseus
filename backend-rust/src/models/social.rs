use chrono::{DateTime, Utc};
use serde::{Deserialize, Serialize};

#[derive(Debug, Serialize)]
pub struct FollowResult {
    pub following: bool,
}

#[derive(Debug, Serialize)]
pub struct FollowingUser {
    pub id: i32,
    pub username: String,
    pub grade: Option<String>,
    pub role: String,
    pub avatar_url: Option<String>,
    pub is_plus: bool,
    pub is_same_school: bool,
    pub followed_at: DateTime<Utc>,
}

#[derive(Debug, Serialize)]
pub struct FollowingListResponse {
    pub total: i64,
    pub users: Vec<FollowingUser>,
}

#[derive(Debug, Serialize)]
pub struct FeedCounts {
    pub following: i64,
    pub school: i64,
}

#[derive(Debug, Serialize)]
pub struct PrivacySettings {
    pub hide_activity_from_social: bool,
}

#[derive(Debug, Deserialize)]
pub struct UpdatePrivacyRequest {
    pub hide_activity_from_social: bool,
}
