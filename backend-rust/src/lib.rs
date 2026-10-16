pub mod common;
pub mod config;
pub mod db;
pub mod handlers;
pub mod middleware;
pub mod models;
pub mod routes;
pub mod services;
pub mod utils;

use std::sync::Arc;

use sqlx::PgPool;

use crate::{config::Config, services::judge_service::JudgeService};

#[derive(Clone)]
pub struct AppState {
    pub pool: PgPool,
    pub config: Arc<Config>,
    pub judge_service: JudgeService,
}

impl AppState {
    pub fn new(pool: PgPool, config: Config) -> Self {
        Self {
            pool,
            config: Arc::new(config),
            judge_service: JudgeService::default(),
        }
    }
}
