use chrono::{DateTime, Utc};
use serde::Serialize;

#[derive(Debug, Serialize)]
pub struct HomeContinue {
    pub problem_id: i32,
    pub problem_title: String,
    pub difficulty: String,
    pub language: String,
    pub status: String,
    pub last_activity_at: DateTime<Utc>,
    /// `resume` for an unfinished problem, `review` for a recently accepted one.
    pub action: String,
}

#[derive(Debug, Serialize)]
pub struct HomeStats {
    pub streak_days: i64,
    pub accepted_problems: i64,
    pub review_problems: i64,
    pub week_submissions: i64,
}

#[derive(Debug, Serialize)]
pub struct HomeActivity {
    pub submission_id: i32,
    pub problem_id: i32,
    pub problem_title: String,
    pub language: String,
    pub status: String,
    pub submitted_at: DateTime<Utc>,
}

#[derive(Debug, Serialize)]
pub struct HomeOverviewResponse {
    pub continue_learning: Option<HomeContinue>,
    pub stats: HomeStats,
    pub recent_activity: Vec<HomeActivity>,
}
