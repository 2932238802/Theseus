use chrono::{DateTime, Utc};
use serde::{Deserialize, Serialize};

use crate::models::forum::PublicAuthor;

#[derive(Debug, Deserialize, Default)]
pub struct FavoriteListQuery {
    pub page: Option<u32>,
    pub size: Option<u32>,
}

#[derive(Debug, Serialize)]
pub struct FavoriteToggleResponse {
    pub favorited: bool,
}

#[derive(Debug, Serialize)]
pub struct ProblemFavoriteItem {
    pub problem_id: i32,
    pub title: String,
    pub difficulty: String,
    pub acceptance_rate: f64,
    pub favorited_at: DateTime<Utc>,
}

#[derive(Debug, Serialize)]
pub struct ProblemFavoriteListResponse {
    pub total: i64,
    pub page: u32,
    pub size: u32,
    pub favorites: Vec<ProblemFavoriteItem>,
}

#[derive(Debug, Serialize)]
pub struct CommentFavoriteItem {
    pub comment_id: i64,
    pub post_id: i64,
    pub post_title: String,
    pub parent_id: Option<i64>,
    pub body_md: String,
    pub author: PublicAuthor,
    pub created_at: DateTime<Utc>,
    pub favorited_at: DateTime<Utc>,
}

#[derive(Debug, Serialize)]
pub struct CommentFavoriteListResponse {
    pub total: i64,
    pub page: u32,
    pub size: u32,
    pub favorites: Vec<CommentFavoriteItem>,
}
