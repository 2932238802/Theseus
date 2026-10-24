use std::{env, net::SocketAddr};

use crate::common::error::AppError;

#[derive(Debug, Clone)]
pub struct Config {
    pub database_url: String,
    pub jwt_secret: String,
    pub jwt_expiration_hours: i64,
    pub bind_address: SocketAddr,
    pub redis_url: String,
    pub run_code_enabled: bool,
    pub run_stream: String,
    pub run_consumer_group: String,
    pub run_worker_name: String,
    pub run_worker_concurrency: usize,
    pub run_image_python: String,
    pub run_sandbox_runtime: String,
    pub run_sandbox_allow_runc: bool,
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
        let redis_url =
            env::var("REDIS_URL").unwrap_or_else(|_| "redis://127.0.0.1:6379".to_owned());
        let run_code_enabled = env_bool("RUN_CODE_ENABLED", false)?;
        let run_stream = env::var("RUN_STREAM").unwrap_or_else(|_| "theseus:judge:runs".to_owned());
        let run_consumer_group =
            env::var("RUN_CONSUMER_GROUP").unwrap_or_else(|_| "judge-workers".to_owned());
        let run_worker_name = env::var("RUN_WORKER_NAME").unwrap_or_else(|_| "worker-1".to_owned());
        let run_worker_concurrency = env::var("RUN_WORKER_CONCURRENCY")
            .ok()
            .and_then(|value| value.parse::<usize>().ok())
            .unwrap_or(2)
            .max(1);
        let run_image_python =
            env::var("RUN_IMAGE_PYTHON").unwrap_or_else(|_| "python:3.12-slim".to_owned());
        let run_sandbox_runtime =
            env::var("RUN_SANDBOX_RUNTIME").unwrap_or_else(|_| "runsc".to_owned());
        let run_sandbox_allow_runc = env_bool("RUN_SANDBOX_ALLOW_RUNC", false)?;
        if run_sandbox_runtime != "runsc" && !run_sandbox_allow_runc {
            return Err(AppError::Internal(
                "RUN_SANDBOX_RUNTIME 必须为 runsc；本地开发需显式设置 RUN_SANDBOX_ALLOW_RUNC=true"
                    .to_owned(),
            ));
        }
        Ok(Self {
            database_url,
            jwt_secret,
            jwt_expiration_hours,
            bind_address,
            redis_url,
            run_code_enabled,
            run_stream,
            run_consumer_group,
            run_worker_name,
            run_worker_concurrency,
            run_image_python,
            run_sandbox_runtime,
            run_sandbox_allow_runc,
        })
    }
}

fn env_bool(key: &str, default: bool) -> Result<bool, AppError> {
    match env::var(key) {
        Ok(value) => match value.trim().to_ascii_lowercase().as_str() {
            "1" | "true" | "yes" | "on" => Ok(true),
            "0" | "false" | "no" | "off" => Ok(false),
            _ => Err(AppError::Internal(format!("{key} 必须是布尔值"))),
        },
        Err(_) => Ok(default),
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
