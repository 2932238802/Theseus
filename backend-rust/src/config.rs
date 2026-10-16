use std::{env, net::SocketAddr};

use crate::common::error::AppError;

#[derive(Debug, Clone)]
pub struct Config {
    pub database_url: String,
    pub jwt_secret: String,
    pub jwt_expiration_hours: i64,
    pub bind_address: SocketAddr,
}

impl Config {
    pub fn from_env() -> Result<Self, AppError> {
        let database_url = env::var("DATABASE_URL")
            .map_err(|_| AppError::Internal("缺少 DATABASE_URL 配置".to_owned()))?;
        let jwt_secret = env::var("JWT_SECRET")
            .map_err(|_| AppError::Internal("缺少 JWT_SECRET 配置".to_owned()))?;
        validate_jwt_secret(&jwt_secret)?;
        let jwt_expiration_hours = env::var("JWT_EXPIRATION_HOURS")
            .ok()
            .and_then(|value| value.parse::<i64>().ok())
            .unwrap_or(24);
        if jwt_expiration_hours <= 0 {
            return Err(AppError::Internal(
                "JWT_EXPIRATION_HOURS 必须大于 0".to_owned(),
            ));
        }
        let bind_address = env::var("BIND_ADDRESS")
            .unwrap_or_else(|_| "127.0.0.1:3000".to_owned())
            .parse()
            .map_err(|_| AppError::Internal("BIND_ADDRESS 格式无效".to_owned()))?;
        Ok(Self {
            database_url,
            jwt_secret,
            jwt_expiration_hours,
            bind_address,
        })
    }
}

fn validate_jwt_secret(secret: &str) -> Result<(), AppError> {
    if secret.len() < 32 {
        return Err(AppError::Internal(
            "JWT_SECRET 至少需要 32 个字符".to_owned(),
        ));
    }
    Ok(())
}

#[cfg(test)]
mod tests {
    use super::validate_jwt_secret;

    #[test]
    fn rejects_short_jwt_secret() {
        assert!(validate_jwt_secret("short").is_err());
    }

    #[test]
    fn accepts_long_jwt_secret() {
        assert!(validate_jwt_secret("a-secret-with-at-least-32-characters").is_ok());
    }
}
