use std::time::Duration;

use sqlx::{PgPool, postgres::PgPoolOptions};

use crate::common::error::AppError;

/// 默认值沿用旧行为；部署时用 DB_MAX_CONNECTIONS 覆盖。
const DEFAULT_MAX_CONNECTIONS: u32 = 10;
const MAX_CONNECTIONS_LIMIT: u32 = 200;

pub async fn create_pool(database_url: &str) -> Result<PgPool, AppError> {
    PgPoolOptions::new()
        .max_connections(max_connections_from_env())
        .acquire_timeout(Duration::from_secs(10))
        .connect(database_url)
        .await
        .map_err(AppError::Database)
}

fn max_connections_from_env() -> u32 {
    parse_max_connections(std::env::var("DB_MAX_CONNECTIONS").ok().as_deref())
}

/// 非法或越界时回退默认值，避免环境变量写错把服务卡死。
fn parse_max_connections(raw: Option<&str>) -> u32 {
    raw.and_then(|value| value.trim().parse::<u32>().ok())
        .filter(|value| (1..=MAX_CONNECTIONS_LIMIT).contains(value))
        .unwrap_or(DEFAULT_MAX_CONNECTIONS)
}

#[cfg(test)]
mod tests {
    use super::{DEFAULT_MAX_CONNECTIONS, parse_max_connections};

    #[test]
    fn missing_value_uses_default() {
        assert_eq!(parse_max_connections(None), DEFAULT_MAX_CONNECTIONS);
    }

    #[test]
    fn valid_values_are_used() {
        assert_eq!(parse_max_connections(Some("1")), 1);
        assert_eq!(parse_max_connections(Some("32\n")), 32);
        assert_eq!(parse_max_connections(Some("200")), 200);
    }

    #[test]
    fn invalid_values_fall_back_to_default() {
        assert_eq!(parse_max_connections(Some("0")), DEFAULT_MAX_CONNECTIONS);
        assert_eq!(parse_max_connections(Some("201")), DEFAULT_MAX_CONNECTIONS);
        assert_eq!(parse_max_connections(Some("-4")), DEFAULT_MAX_CONNECTIONS);
        assert_eq!(parse_max_connections(Some("abc")), DEFAULT_MAX_CONNECTIONS);
    }
}
