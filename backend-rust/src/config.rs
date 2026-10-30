use std::{env, net::SocketAddr, path::PathBuf};

use crate::common::error::AppError;

#[derive(Debug, Clone)]
pub struct Config {
    pub database_url: String,
    pub jwt_secret: String,
    pub jwt_expiration_hours: i64,
    pub frontend_base_url: String,
    pub email_mode: String,
    pub email_from: String,
    pub email_smtp_host: String,
    pub email_smtp_port: u16,
    pub email_smtp_username: Option<String>,
    pub email_smtp_password: Option<String>,
    pub email_smtp_tls: bool,
    pub email_verify_ttl_hours: i64,
    pub password_reset_ttl_minutes: i64,
    pub email_dispatch_interval_secs: u64,
    pub upload_dir: PathBuf,
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
    pub anticheat_enabled: bool,
    pub anticheat_stream: String,
    pub anticheat_consumer_group: String,
    pub anticheat_dead_stream: String,
    pub anticheat_worker_name: String,
    pub anticheat_worker_concurrency: usize,
    pub anticheat_max_deliveries: u32,
    pub anticheat_claim_interval_secs: u64,
    pub anticheat_window_days: i64,
    pub anticheat_max_candidates: i64,
    pub anticheat_record_threshold: f64,
    pub anticheat_report_threshold: f64,
    pub anticheat_high_threshold: f64,
    pub anticheat_min_tokens: usize,
    pub forum_enabled: bool,
    pub forum_post_cooldown_secs: u64,
    pub forum_post_daily_limit: u64,
    pub forum_comment_cooldown_secs: u64,
    pub forum_comment_daily_limit: u64,
    pub forum_report_daily_limit: u64,
    pub forum_report_hide_threshold: i32,
    pub forum_max_pinned: i64,
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
        let frontend_base_url = env::var("FRONTEND_BASE_URL")
            .unwrap_or_else(|_| "http://localhost:5173".to_owned())
            .trim_end_matches('/')
            .to_owned();
        if frontend_base_url.is_empty() {
            return Err(AppError::Internal("FRONTEND_BASE_URL 不能为空".to_owned()));
        }
        let email_mode = env::var("EMAIL_MODE")
            .unwrap_or_else(|_| "log".to_owned())
            .trim()
            .to_ascii_lowercase();
        if !matches!(email_mode.as_str(), "log" | "smtp") {
            return Err(AppError::Internal(
                "EMAIL_MODE 必须是 log 或 smtp".to_owned(),
            ));
        }
        let email_from = env::var("EMAIL_FROM")
            .unwrap_or_else(|_| "Theseus <no-reply@theseus.local>".to_owned());
        let email_smtp_host =
            env::var("EMAIL_SMTP_HOST").unwrap_or_else(|_| "127.0.0.1".to_owned());
        let email_smtp_port = env::var("EMAIL_SMTP_PORT")
            .ok()
            .and_then(|value| value.parse::<u16>().ok())
            .unwrap_or(1025);
        if email_smtp_port == 0 {
            return Err(AppError::Internal("EMAIL_SMTP_PORT 必须大于 0".to_owned()));
        }
        let email_smtp_username = env::var("EMAIL_SMTP_USERNAME")
            .ok()
            .map(|value| value.trim().to_owned())
            .filter(|value| !value.is_empty());
        let email_smtp_password = env::var("EMAIL_SMTP_PASSWORD")
            .ok()
            .filter(|value| !value.is_empty());
        let email_smtp_tls = env_bool("EMAIL_SMTP_TLS", false)?;
        let email_verify_ttl_hours = env::var("EMAIL_VERIFY_TTL_HOURS")
            .ok()
            .and_then(|value| value.parse::<i64>().ok())
            .unwrap_or(24);
        if email_verify_ttl_hours <= 0 {
            return Err(AppError::Internal(
                "EMAIL_VERIFY_TTL_HOURS 必须大于 0".to_owned(),
            ));
        }
        let password_reset_ttl_minutes = env::var("PASSWORD_RESET_TTL_MINUTES")
            .ok()
            .and_then(|value| value.parse::<i64>().ok())
            .unwrap_or(30);
        if password_reset_ttl_minutes <= 0 {
            return Err(AppError::Internal(
                "PASSWORD_RESET_TTL_MINUTES 必须大于 0".to_owned(),
            ));
        }
        let email_dispatch_interval_secs = env::var("EMAIL_DISPATCH_INTERVAL_SECS")
            .ok()
            .and_then(|value| value.parse::<u64>().ok())
            .unwrap_or(5)
            .max(1);
        let upload_dir = env::var("UPLOAD_DIR")
            .unwrap_or_else(|_| "./uploads".to_owned())
            .trim()
            .to_owned();
        if upload_dir.is_empty() {
            return Err(AppError::Internal("UPLOAD_DIR 不能为空".to_owned()));
        }
        let upload_dir = PathBuf::from(upload_dir);
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
        let anticheat_enabled = env_bool("ANTICHEAT_ENABLED", true)?;
        let anticheat_stream =
            env::var("ANTICHEAT_STREAM").unwrap_or_else(|_| "theseus:anticheat:scan".to_owned());
        let anticheat_consumer_group =
            env::var("ANTICHEAT_CONSUMER_GROUP").unwrap_or_else(|_| "anticheat-workers".to_owned());
        let anticheat_dead_stream = env::var("ANTICHEAT_DEAD_STREAM")
            .unwrap_or_else(|_| "theseus:anticheat:scan:dead".to_owned());
        let anticheat_worker_name =
            env::var("ANTICHEAT_WORKER_NAME").unwrap_or_else(|_| "anticheat-1".to_owned());
        let anticheat_worker_concurrency = env::var("ANTICHEAT_WORKER_CONCURRENCY")
            .ok()
            .and_then(|value| value.parse::<usize>().ok())
            .unwrap_or(1)
            .max(1);
        let anticheat_max_deliveries = env::var("ANTICHEAT_MAX_DELIVERIES")
            .ok()
            .and_then(|value| value.parse::<u32>().ok())
            .unwrap_or(3)
            .max(1);
        let anticheat_claim_interval_secs = env::var("ANTICHEAT_CLAIM_INTERVAL_SECS")
            .ok()
            .and_then(|value| value.parse::<u64>().ok())
            .unwrap_or(30)
            .max(5);
        let anticheat_window_days = env::var("ANTICHEAT_WINDOW_DAYS")
            .ok()
            .and_then(|value| value.parse::<i64>().ok())
            .unwrap_or(30)
            .max(1);
        let anticheat_max_candidates = env::var("ANTICHEAT_MAX_CANDIDATES")
            .ok()
            .and_then(|value| value.parse::<i64>().ok())
            .unwrap_or(200)
            .max(1);
        let anticheat_record_threshold = env_ratio("ANTICHEAT_RECORD_THRESHOLD", 0.60)?;
        let anticheat_report_threshold = env_ratio("ANTICHEAT_REPORT_THRESHOLD", 0.80)?;
        let anticheat_high_threshold = env_ratio("ANTICHEAT_HIGH_THRESHOLD", 0.92)?;
        if anticheat_record_threshold > anticheat_report_threshold
            || anticheat_report_threshold > anticheat_high_threshold
        {
            return Err(AppError::Internal(
                "相似度阈值必须满足 RECORD <= REPORT <= HIGH".to_owned(),
            ));
        }
        let anticheat_min_tokens = env::var("ANTICHEAT_MIN_TOKENS")
            .ok()
            .and_then(|value| value.parse::<usize>().ok())
            .unwrap_or(40)
            .max(1);
        let forum_enabled = env_bool("FORUM_ENABLED", true)?;
        let forum_post_cooldown_secs = env::var("FORUM_POST_COOLDOWN_SECS")
            .ok()
            .and_then(|value| value.parse::<u64>().ok())
            .unwrap_or(60);
        let forum_post_daily_limit = env::var("FORUM_POST_DAILY_LIMIT")
            .ok()
            .and_then(|value| value.parse::<u64>().ok())
            .unwrap_or(20)
            .max(1);
        let forum_comment_cooldown_secs = env::var("FORUM_COMMENT_COOLDOWN_SECS")
            .ok()
            .and_then(|value| value.parse::<u64>().ok())
            .unwrap_or(10);
        let forum_comment_daily_limit = env::var("FORUM_COMMENT_DAILY_LIMIT")
            .ok()
            .and_then(|value| value.parse::<u64>().ok())
            .unwrap_or(200)
            .max(1);
        let forum_report_daily_limit = env::var("FORUM_REPORT_DAILY_LIMIT")
            .ok()
            .and_then(|value| value.parse::<u64>().ok())
            .unwrap_or(20)
            .max(1);
        let forum_report_hide_threshold = env::var("FORUM_REPORT_HIDE_THRESHOLD")
            .ok()
            .and_then(|value| value.parse::<i32>().ok())
            .unwrap_or(3)
            .max(1);
        let forum_max_pinned = env::var("FORUM_MAX_PINNED")
            .ok()
            .and_then(|value| value.parse::<i64>().ok())
            .unwrap_or(5)
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
            frontend_base_url,
            email_mode,
            email_from,
            email_smtp_host,
            email_smtp_port,
            email_smtp_username,
            email_smtp_password,
            email_smtp_tls,
            email_verify_ttl_hours,
            password_reset_ttl_minutes,
            email_dispatch_interval_secs,
            upload_dir,
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
            anticheat_enabled,
            anticheat_stream,
            anticheat_consumer_group,
            anticheat_dead_stream,
            anticheat_worker_name,
            anticheat_worker_concurrency,
            anticheat_max_deliveries,
            anticheat_claim_interval_secs,
            anticheat_window_days,
            anticheat_max_candidates,
            anticheat_record_threshold,
            anticheat_report_threshold,
            anticheat_high_threshold,
            anticheat_min_tokens,
            forum_enabled,
            forum_post_cooldown_secs,
            forum_post_daily_limit,
            forum_comment_cooldown_secs,
            forum_comment_daily_limit,
            forum_report_daily_limit,
            forum_report_hide_threshold,
            forum_max_pinned,
        })
    }
}

fn env_ratio(key: &str, default: f64) -> Result<f64, AppError> {
    let value = match env::var(key) {
        Ok(value) => value
            .trim()
            .parse::<f64>()
            .map_err(|_| AppError::Internal(format!("{key} 必须是 0 到 1 之间的小数")))?,
        Err(_) => default,
    };
    if !(0.0..=1.0).contains(&value) {
        return Err(AppError::Internal(format!(
            "{key} 必须是 0 到 1 之间的小数"
        )));
    }
    Ok(value)
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
