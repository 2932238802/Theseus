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
    pub run_image_node: String,
    pub run_image_cpp: String,
    pub run_image_java: String,
    pub run_sandbox_runtime: String,
    pub run_sandbox_allow_runc: bool,
    pub run_dead_stream: String,
    pub run_max_deliveries: u32,
    pub run_claim_interval_secs: u64,
    pub run_compile_timeout_secs: u64,
    pub run_compile_memory_mb: u32,
    pub run_queue_timeout_secs: u64,
    pub run_stale_timeout_secs: u64,
    pub run_reaper_interval_secs: u64,
    pub submit_judge_enabled: bool,
    pub submit_stream: String,
    pub submit_consumer_group: String,
    pub submit_dead_stream: String,
    pub submit_max_deliveries: u32,
    pub submit_queue_timeout_secs: u64,
    pub submit_stale_timeout_secs: u64,
    pub submit_run_timeout_secs: u64,
    pub submit_max_cases: usize,
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
        let run_image_node =
            env::var("RUN_IMAGE_NODE").unwrap_or_else(|_| "node:22-slim".to_owned());
        let run_image_cpp =
            env::var("RUN_IMAGE_CPP").unwrap_or_else(|_| "theseus/runner-cpp:dev".to_owned());
        let run_image_java =
            env::var("RUN_IMAGE_JAVA").unwrap_or_else(|_| "theseus/runner-java:dev".to_owned());
        let run_sandbox_runtime =
            env::var("RUN_SANDBOX_RUNTIME").unwrap_or_else(|_| "runsc".to_owned());
        let run_sandbox_allow_runc = env_bool("RUN_SANDBOX_ALLOW_RUNC", false)?;
        let run_dead_stream =
            env::var("RUN_DEAD_STREAM").unwrap_or_else(|_| "theseus:judge:runs:dead".to_owned());
        let run_max_deliveries = env::var("RUN_MAX_DELIVERIES")
            .ok()
            .and_then(|value| value.parse::<u32>().ok())
            .unwrap_or(3)
            .max(1);
        let run_claim_interval_secs = env::var("RUN_CLAIM_INTERVAL_SECS")
            .ok()
            .and_then(|value| value.parse::<u64>().ok())
            .unwrap_or(30)
            .max(5);
        let run_compile_timeout_secs = env::var("RUN_COMPILE_TIMEOUT_SECS")
            .ok()
            .and_then(|value| value.parse::<u64>().ok())
            .unwrap_or(60)
            .max(10);
        let run_compile_memory_mb = env::var("RUN_COMPILE_MEMORY_MB")
            .ok()
            .and_then(|value| value.parse::<u32>().ok())
            .unwrap_or(1024)
            .max(256);
        let run_queue_timeout_secs = env::var("RUN_QUEUE_TIMEOUT_SECS")
            .ok()
            .and_then(|value| value.parse::<u64>().ok())
            .unwrap_or(90)
            .max(30);
        let run_stale_timeout_secs = env::var("RUN_STALE_TIMEOUT_SECS")
            .ok()
            .and_then(|value| value.parse::<u64>().ok())
            .unwrap_or(300)
            .max(run_queue_timeout_secs);
        let run_reaper_interval_secs = env::var("RUN_REAPER_INTERVAL_SECS")
            .ok()
            .and_then(|value| value.parse::<u64>().ok())
            .unwrap_or(30)
            .max(5);
        let submit_judge_enabled = env_bool("SUBMIT_JUDGE_ENABLED", false)?;
        let submit_stream =
            env::var("SUBMIT_STREAM").unwrap_or_else(|_| "theseus:judge:submissions".to_owned());
        let submit_consumer_group =
            env::var("SUBMIT_CONSUMER_GROUP").unwrap_or_else(|_| "judge-submit-workers".to_owned());
        let submit_dead_stream = env::var("SUBMIT_DEAD_STREAM")
            .unwrap_or_else(|_| "theseus:judge:submissions:dead".to_owned());
        let submit_max_deliveries = env::var("SUBMIT_MAX_DELIVERIES")
            .ok()
            .and_then(|value| value.parse::<u32>().ok())
            .unwrap_or(3)
            .max(1);
        let submit_queue_timeout_secs = env::var("SUBMIT_QUEUE_TIMEOUT_SECS")
            .ok()
            .and_then(|value| value.parse::<u64>().ok())
            .unwrap_or(90)
            .max(30);
        let submit_stale_timeout_secs = env::var("SUBMIT_STALE_TIMEOUT_SECS")
            .ok()
            .and_then(|value| value.parse::<u64>().ok())
            .unwrap_or(300)
            .max(submit_queue_timeout_secs);
        let submit_run_timeout_secs = env::var("SUBMIT_RUN_TIMEOUT_SECS")
            .ok()
            .and_then(|value| value.parse::<u64>().ok())
            .unwrap_or(60)
            .max(5);
        let submit_max_cases = env::var("SUBMIT_MAX_CASES")
            .ok()
            .and_then(|value| value.parse::<usize>().ok())
            .unwrap_or(50)
            .max(1);
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
            run_image_node,
            run_image_cpp,
            run_image_java,
            run_sandbox_runtime,
            run_sandbox_allow_runc,
            run_dead_stream,
            run_max_deliveries,
            run_claim_interval_secs,
            run_compile_timeout_secs,
            run_compile_memory_mb,
            run_queue_timeout_secs,
            run_stale_timeout_secs,
            run_reaper_interval_secs,
            submit_judge_enabled,
            submit_stream,
            submit_consumer_group,
            submit_dead_stream,
            submit_max_deliveries,
            submit_queue_timeout_secs,
            submit_stale_timeout_secs,
            submit_run_timeout_secs,
            submit_max_cases,
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
