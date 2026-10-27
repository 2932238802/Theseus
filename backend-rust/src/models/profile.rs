use chrono::DateTime;
use chrono::Utc;
use serde::{Deserialize, Serialize};

use crate::models::user::PublicUser;

#[derive(Debug, Deserialize)]
pub struct UpdateUsernameRequest {
    pub username: String,
}

#[derive(Debug, Deserialize)]
pub struct UpdateEmailRequest {
    pub email: String,
}

#[derive(Debug, Deserialize)]
pub struct UpdatePasswordRequest {
    pub current_password: String,
    pub new_password: String,
}

#[derive(Debug, Deserialize)]
pub struct DeleteAccountRequest {
    pub password: String,
    pub username: String,
}

#[derive(Debug, Serialize)]
pub struct EmailChangeResponse {
    pub message: String,
    pub pending_email: String,
}

#[derive(Debug, Serialize)]
pub struct PasswordChangeResponse {
    pub token: String,
    pub user: PublicUser,
}

#[derive(Debug, Serialize)]
pub struct AvatarResponse {
    pub message: String,
    pub avatar_url: String,
}

#[derive(Debug, Serialize)]
pub struct AccountMessageResponse {
    pub message: String,
}

#[derive(Debug, Deserialize, Default)]
pub struct AnalyticsQuery {
    pub days: Option<i64>,
}

#[derive(Debug, Serialize)]
pub struct AnalyticsSummary {
    pub accepted_problems: i64,
    pub attempted_problems: i64,
    pub total_submissions: i64,
    pub accepted_submissions: i64,
    pub acceptance_rate: f64,
    pub active_classes: i64,
    pub streak_days: i64,
}

#[derive(Debug, Serialize)]
pub struct AnalyticsTrendPoint {
    pub date: String,
    pub submissions: i64,
    pub accepted: i64,
}

#[derive(Debug, Serialize)]
pub struct AnalyticsDifficulty {
    pub difficulty: String,
    pub attempted: i64,
    pub accepted: i64,
}

#[derive(Debug, Serialize)]
pub struct AnalyticsTag {
    pub tag: String,
    pub attempted: i64,
    pub accepted: i64,
}

#[derive(Debug, Serialize)]
pub struct AnalyticsResponse {
    pub days: i64,
    pub summary: AnalyticsSummary,
    pub trend: Vec<AnalyticsTrendPoint>,
    pub difficulty: Vec<AnalyticsDifficulty>,
    pub tags: Vec<AnalyticsTag>,
}

#[derive(Debug, Deserialize, Default)]
pub struct ForumFavoriteQuery {
    pub page: Option<u32>,
    pub size: Option<u32>,
}

#[derive(Debug, Clone, serde::Serialize)]
pub struct ForumFavoriteAuthor {
    pub id: i32,
    pub username: String,
}

#[derive(Debug, Clone, serde::Serialize)]
pub struct ForumFavoriteItem {
    pub post_id: i64,
    pub title: String,
    pub status: String,
    pub favorite_count: i32,
    pub comment_count: i32,
    pub favorited_at: DateTime<Utc>,
    pub author: ForumFavoriteAuthor,
}

#[derive(Debug, Serialize)]
pub struct ForumFavoriteListResponse {
    pub total: i64,
    pub page: u32,
    pub size: u32,
    pub favorites: Vec<ForumFavoriteItem>,
}
