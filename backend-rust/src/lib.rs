pub mod common;
pub mod config;
pub mod db;
pub mod handlers;
pub mod judge;
pub mod middleware;
pub mod models;
pub mod realtime;
pub mod routes;
pub mod services;
pub mod utils;

use std::sync::Arc;

use redis::aio::ConnectionManager;
use sqlx::PgPool;

use crate::{
    config::Config,
    realtime::RealtimeHub,
    services::{run_service::RunService, submission_service::SubmissionService},
};

#[derive(Clone)]
pub struct AppState {
    pub pool: PgPool,
    pub config: Arc<Config>,
    pub submission_service: SubmissionService,
    pub run_service: RunService,
    pub realtime: RealtimeHub,
}

impl AppState {
    pub fn new(pool: PgPool, config: Config, redis: Option<ConnectionManager>) -> Self {
        let config = Arc::new(config);
        Self {
            pool,
            submission_service: SubmissionService::new(config.clone(), redis.clone()),
            run_service: RunService::new(config.clone(), redis),
            config,
            realtime: RealtimeHub::new(),
        }
    }
}
