use sqlx::{PgPool, postgres::PgPoolOptions};

use crate::common::error::AppError;

pub async fn create_pool(database_url: &str) -> Result<PgPool, AppError> {
    PgPoolOptions::new()
        .max_connections(10)
        .acquire_timeout(std::time::Duration::from_secs(10))
        .connect(database_url)
        .await
        .map_err(AppError::Database)
}
