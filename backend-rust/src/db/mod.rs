pub mod pool;

use sqlx::{PgPool, migrate::Migrator};

use crate::common::error::AppError;

static MIGRATOR: Migrator = sqlx::migrate!("./migrations");

pub async fn migrate(pool: &PgPool) -> Result<(), AppError> {
    MIGRATOR.run(pool).await.map_err(|error| {
        tracing::error!(error = ?error, "database migration failed");
        AppError::Internal("数据库迁移失败".to_owned())
    })
}
