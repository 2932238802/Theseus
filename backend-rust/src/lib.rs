pub mod common;
pub mod config;
pub mod db;
pub mod handlers;
pub mod judge;
pub mod middleware;
pub mod models;
pub mod routes;
pub mod services;
pub mod utils;

use std::sync::Arc;

use redis::aio::ConnectionManager;
use sqlx::PgPool;

use crate::{
    config::Config,
    services::{judge_service::JudgeService, run_service::RunService},
};

#[derive(Clone)]
pub struct AppState {
    pub pool: PgPool,
    pub config: Arc<Config>,
    pub judge_service: JudgeService,
    pub run_service: RunService,
}

impl AppState {
    pub fn new(pool: PgPool, config: Config, redis: Option<ConnectionManager>) -> Self {
        let config = Arc::new(config);
        Self {
            pool,
            judge_service: JudgeService,
            run_service: RunService::new(config.clone(), redis),
            config,
        }
    }
}
