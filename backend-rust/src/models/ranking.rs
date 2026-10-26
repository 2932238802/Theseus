use serde::{Deserialize, Serialize};
use sqlx::FromRow;

#[derive(Debug, Deserialize, Default)]
pub struct RankingQuery {
    pub page: Option<u32>,
    pub size: Option<u32>,
}

#[derive(Debug, Serialize, FromRow)]
pub struct RankingEntry {
    pub rank: i64,
    pub user_id: i32,
    pub username: String,
    pub solved: i64,
    pub submissions: i64,
    pub acceptance_rate: f64,
}

#[derive(Debug, Serialize)]
pub struct RankingResponse {
    pub total: i64,
    pub page: u32,
    pub size: u32,
    pub entries: Vec<RankingEntry>,
    pub me: Option<RankingEntry>,
}
