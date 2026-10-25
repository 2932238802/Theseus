use std::sync::Arc;

use chrono::{DateTime, Utc};
use redis::{aio::ConnectionManager, cmd};
use serde::{Deserialize, Serialize};
use sqlx::PgPool;

use crate::{
    common::error::AppError,
    config::Config,
    judge::{
        queue,
        run_config::{MAX_CODE_BYTES, validate_input, validate_run_config},
    },
    middleware::auth::AuthUser,
    models::run::{
        CodeRunRow, RUN_STATUS_QUEUED, RunConfig, RunCreateRequest, RunCreateResponse,
        RunDetailResponse, RunStatusResponse,
    },
};

const RUNS_PER_MINUTE: i64 = 10;
const CONCURRENCY_TTL_SECONDS: u64 = 600;

#[derive(Clone)]
pub struct RunService {
    config: Arc<Config>,
    redis: Option<ConnectionManager>,
}

#[derive(Debug, Serialize, Deserialize)]
pub struct CachedRunStatus {
    user_id: i32,
    id: i64,
    status: String,
    case_passed: i32,
    case_total: i32,
    #[serde(default)]
    error_message: Option<String>,
    updated_at: DateTime<Utc>,
}

impl CachedRunStatus {
    pub fn new(
        user_id: i32,
        run_id: i64,
        status: &str,
        case_passed: i32,
        case_total: i32,
        error_message: Option<String>,
    ) -> Self {
        Self {
            user_id,
            id: run_id,
            status: status.to_owned(),
            case_passed,
            case_total,
            error_message,
            updated_at: Utc::now(),
        }
    }

    fn response(&self) -> RunStatusResponse {
        RunStatusResponse {
            id: self.id,
            status: self.status.clone(),
            case_passed: self.case_passed,
            case_total: self.case_total,
            error_message: self.error_message.clone(),
            updated_at: self.updated_at,
        }
    }
}

impl RunService {
    pub fn new(config: Arc<Config>, redis: Option<ConnectionManager>) -> Self {
        Self { config, redis }
    }

    pub fn enabled(&self) -> bool {
        self.config.run_code_enabled
    }

    pub async fn create(
        &self,
        pool: &PgPool,
        user: &AuthUser,
        request: RunCreateRequest,
    ) -> Result<RunCreateResponse, AppError> {
        if !self.config.run_code_enabled {
            return Err(AppError::ServiceUnavailable("运行功能暂未开放".to_owned()));
        }
        if request.problem_id <= 0 {
            return Err(AppError::BadRequest("题目 ID 无效".to_owned()));
        }
        validate_language(&request.language)?;
        validate_mode(&request.mode)?;
        if request.code.trim().is_empty() {
            return Err(AppError::BadRequest("代码不能为空".to_owned()));
        }
        if request.code.len() > MAX_CODE_BYTES {
            return Err(AppError::BadRequest("代码不能超过 64 KB".to_owned()));
        }

        let problem = sqlx::query_as::<_, (String, Option<serde_json::Value>)>(
            "SELECT title, run_config FROM problems WHERE id = $1 AND review_status = 'approved'",
        )
        .bind(request.problem_id)
        .fetch_optional(pool)
        .await
        .map_err(AppError::Database)?
        .ok_or_else(|| AppError::NotFound("题目不存在".to_owned()))?;
        let (problem_title, run_config_value) = problem;
        let Some(run_config_value) = run_config_value else {
            return Err(AppError::BadRequest("该题暂未配置运行".to_owned()));
        };
        let run_config = validate_run_config(&run_config_value)?;
        let (input, case_total) = if request.mode == "examples" {
            if run_config.public_cases.is_empty() {
                return Err(AppError::BadRequest("该题未配置可运行的示例".to_owned()));
            }
            (None, run_config.public_cases.len() as i32)
        } else {
            let input = request
                .input
                .ok_or_else(|| AppError::BadRequest("自定义输入不能为空".to_owned()))?;
            validate_input(&run_config, &input)?;
            (Some(input), 1)
        };

        let mut redis = self.redis()?;
        self.enforce_rate(&mut redis, user.id).await?;
        let rate_key = rate_key(user.id);
        let lock_key = concurrency_key(user.id);
        let token = random_token();
        let acquired: Option<String> = cmd("SET")
            .arg(&lock_key)
            .arg(&token)
            .arg("NX")
            .arg("EX")
            .arg(CONCURRENCY_TTL_SECONDS)
            .query_async(&mut redis)
            .await
            .map_err(|_| AppError::ServiceUnavailable("运行队列暂不可用".to_owned()))?;
        if acquired.is_none() {
            release_rate(&mut redis, &rate_key).await;
            return Err(AppError::RateLimited(
                "已有运行任务正在进行，请等待其结束".to_owned(),
                5,
            ));
        }

        let run_id = match sqlx::query_scalar::<_, i64>(
            "INSERT INTO code_runs (user_id, problem_id, problem_title, language, mode, code, input, run_config_snapshot, status, case_total) VALUES ($1, $2, $3, $4, $5, $6, $7, $8, $9, $10) RETURNING id",
        )
        .bind(user.id)
        .bind(request.problem_id)
        .bind(&problem_title)
        .bind(&request.language)
        .bind(&request.mode)
        .bind(&request.code)
        .bind(&input)
        .bind(&run_config_value)
        .bind(RUN_STATUS_QUEUED)
        .bind(case_total)
        .fetch_one(pool)
        .await
        {
            Ok(run_id) => run_id,
            Err(error) => {
                release_lock(&mut redis, &lock_key, &token).await;
                release_rate(&mut redis, &rate_key).await;
                return Err(AppError::Database(error));
            }
        };

        if !swap_lock(&mut redis, &lock_key, &token, run_id).await {
            release_lock(&mut redis, &lock_key, &token).await;
            release_rate(&mut redis, &rate_key).await;
            mark_internal_error(pool, run_id, "运行并发锁失效").await;
            return Err(AppError::ServiceUnavailable("运行队列暂不可用".to_owned()));
        }

        if let Err(error) = queue::enqueue(&mut redis, &self.config.run_stream, run_id).await {
            tracing::error!(run_id, error = %error, "failed to enqueue run");
            mark_internal_error(pool, run_id, "运行队列暂不可用").await;
            release_lock(&mut redis, &lock_key, &run_id.to_string()).await;
            release_rate(&mut redis, &rate_key).await;
            return Err(AppError::ServiceUnavailable("运行队列暂不可用".to_owned()));
        }

        let queued = CachedRunStatus::new(user.id, run_id, RUN_STATUS_QUEUED, 0, case_total, None);
        if let Err(error) = write_status_cache(&mut redis, queued).await {
            tracing::warn!(run_id, error = %error, "failed to cache queued run status");
        }

        Ok(RunCreateResponse {
            run_id,
            status: RUN_STATUS_QUEUED.to_owned(),
        })
    }

    pub async fn status(
        &self,
        pool: &PgPool,
        user: &AuthUser,
        run_id: i64,
    ) -> Result<RunStatusResponse, AppError> {
        if run_id <= 0 {
            return Err(AppError::BadRequest("运行 ID 无效".to_owned()));
        }
        if let Some(mut redis) = self.redis.clone() {
            let key = status_key(run_id);
            if let Some(raw) = queue::status_key_get(&mut redis, &key).await
                && let Ok(cached) = serde_json::from_str::<CachedRunStatus>(&raw)
            {
                if cached.user_id != user.id && !user.is_admin() {
                    return Err(AppError::Forbidden);
                }
                return Ok(cached.response());
            }
        }
        let row = fetch_run_row(pool, run_id).await?;
        check_owner(&row, user)?;
        Ok(row.status_response())
    }

    pub async fn detail(
        &self,
        pool: &PgPool,
        user: &AuthUser,
        run_id: i64,
    ) -> Result<RunDetailResponse, AppError> {
        if run_id <= 0 {
            return Err(AppError::BadRequest("运行 ID 无效".to_owned()));
        }
        let row = fetch_run_row(pool, run_id).await?;
        check_owner(&row, user)?;
        Ok(RunDetailResponse::from(row))
    }

    fn redis(&self) -> Result<ConnectionManager, AppError> {
        self.redis
            .clone()
            .ok_or_else(|| AppError::ServiceUnavailable("运行队列暂不可用".to_owned()))
    }

    async fn enforce_rate(
        &self,
        redis: &mut ConnectionManager,
        user_id: i32,
    ) -> Result<(), AppError> {
        let key = rate_key(user_id);
        let count: i64 = cmd("INCR")
            .arg(&key)
            .query_async(redis)
            .await
            .map_err(|_| AppError::ServiceUnavailable("运行限流服务暂不可用".to_owned()))?;
        if count == 1 {
            let _: Result<i64, _> = cmd("EXPIRE").arg(&key).arg(120).query_async(redis).await;
        }
        if count > RUNS_PER_MINUTE {
            let now = Utc::now().timestamp();
            let retry_after = (60 - now.rem_euclid(60)).max(1) as u64;
            return Err(AppError::RateLimited(
                "每分钟最多运行 10 次，请稍后再试".to_owned(),
                retry_after,
            ));
        }
        Ok(())
    }
}

pub async fn fetch_run_row(pool: &PgPool, run_id: i64) -> Result<CodeRunRow, AppError> {
    sqlx::query_as::<_, CodeRunRow>(
        "SELECT id, user_id, problem_id, problem_title, language, mode, code, input, run_config_snapshot, status, cases, case_total, case_passed, compile_output, error_message, runtime_ms, memory_kb, created_at, started_at, finished_at FROM code_runs WHERE id = $1",
    )
    .bind(run_id)
    .fetch_optional(pool)
    .await
    .map_err(AppError::Database)?
    .ok_or_else(|| AppError::NotFound("运行记录不存在".to_owned()))
}

fn check_owner(row: &CodeRunRow, user: &AuthUser) -> Result<(), AppError> {
    if row.user_id != user.id && !user.is_admin() {
        return Err(AppError::Forbidden);
    }
    Ok(())
}

pub fn parse_run_config(row: &CodeRunRow) -> Result<RunConfig, AppError> {
    validate_run_config(&row.run_config_snapshot)
}

pub async fn claim_run(pool: &PgPool, run_id: i64) -> Result<bool, AppError> {
    let result = sqlx::query(
        "UPDATE code_runs SET status = 'compiling', started_at = CURRENT_TIMESTAMP WHERE id = $1 AND status = 'queued'",
    )
    .bind(run_id)
    .execute(pool)
    .await
    .map_err(AppError::Database)?;
    Ok(result.rows_affected() > 0)
}

pub async fn mark_running(pool: &PgPool, run_id: i64) -> Result<(), AppError> {
    sqlx::query("UPDATE code_runs SET status = 'running' WHERE id = $1 AND status = 'compiling'")
        .bind(run_id)
        .execute(pool)
        .await
        .map_err(AppError::Database)?;
    Ok(())
}

pub struct RunTerminalUpdate<'a> {
    pub status: &'a str,
    pub cases: &'a serde_json::Value,
    pub case_total: i32,
    pub case_passed: i32,
    pub compile_output: Option<&'a str>,
    pub error_message: Option<&'a str>,
    pub runtime_ms: Option<i32>,
    pub memory_kb: Option<i32>,
}

pub async fn finish_run(
    pool: &PgPool,
    run_id: i64,
    update: RunTerminalUpdate<'_>,
) -> Result<bool, AppError> {
    let result = sqlx::query(
        "UPDATE code_runs SET status = $2, cases = $3, case_total = $4, case_passed = $5, compile_output = $6, error_message = $7, runtime_ms = $8, memory_kb = $9, finished_at = CURRENT_TIMESTAMP WHERE id = $1 AND status NOT IN ('completed', 'compile_error', 'runtime_error', 'time_limit_exceeded', 'memory_limit_exceeded', 'internal_error')",
    )
    .bind(run_id)
    .bind(update.status)
    .bind(update.cases)
    .bind(update.case_total)
    .bind(update.case_passed)
    .bind(update.compile_output)
    .bind(update.error_message)
    .bind(update.runtime_ms)
    .bind(update.memory_kb)
    .execute(pool)
    .await
    .map_err(AppError::Database)?;
    Ok(result.rows_affected() > 0)
}

pub async fn mark_internal_error(pool: &PgPool, run_id: i64, message: &str) {
    let _ = sqlx::query(
        "UPDATE code_runs SET status = 'internal_error', error_message = $2, finished_at = CURRENT_TIMESTAMP WHERE id = $1 AND status NOT IN ('completed', 'compile_error', 'runtime_error', 'time_limit_exceeded', 'memory_limit_exceeded', 'internal_error')",
    )
    .bind(run_id)
    .bind(message)
    .execute(pool)
    .await;
}

pub async fn write_status_cache(
    redis: &mut ConnectionManager,
    cached: CachedRunStatus,
) -> Result<(), AppError> {
    let key = status_key(cached.id);
    let raw = serde_json::to_string(&cached)
        .map_err(|error| AppError::Internal(format!("运行状态序列化失败: {error}")))?;
    queue::status_key_set(redis, &key, &raw).await
}

pub async fn release_user_lock(redis: &mut ConnectionManager, user_id: i32, run_id: i64) {
    release_lock(redis, &concurrency_key(user_id), &run_id.to_string()).await;
}

async fn release_lock(redis: &mut ConnectionManager, key: &str, expected: &str) {
    let script = "if redis.call('GET', KEYS[1]) == ARGV[1] then return redis.call('DEL', KEYS[1]) else return 0 end";
    let _: Result<i64, _> = cmd("EVAL")
        .arg(script)
        .arg(1)
        .arg(key)
        .arg(expected)
        .query_async(redis)
        .await;
}

async fn swap_lock(redis: &mut ConnectionManager, key: &str, token: &str, run_id: i64) -> bool {
    let script = "if redis.call('GET', KEYS[1]) == ARGV[1] then redis.call('SET', KEYS[1], ARGV[2], 'EX', ARGV[3]); return 1 else return 0 end";
    cmd("EVAL")
        .arg(script)
        .arg(1)
        .arg(key)
        .arg(token)
        .arg(run_id.to_string())
        .arg(CONCURRENCY_TTL_SECONDS)
        .query_async::<i64>(redis)
        .await
        .map(|value| value == 1)
        .unwrap_or(false)
}

async fn release_rate(redis: &mut ConnectionManager, key: &str) {
    let _: Result<i64, _> = cmd("DECR").arg(key).query_async(redis).await;
}

fn rate_key(user_id: i32) -> String {
    let minute = Utc::now().timestamp().div_euclid(60);
    format!("theseus:run:rate:{user_id}:{minute}")
}

fn concurrency_key(user_id: i32) -> String {
    format!("theseus:run:concurrency:{user_id}")
}

fn status_key(run_id: i64) -> String {
    format!("theseus:run:status:{run_id}")
}

fn random_token() -> String {
    format!(
        "{:016x}{:016x}",
        rand::random::<u64>(),
        rand::random::<u64>()
    )
}

fn validate_language(language: &str) -> Result<(), AppError> {
    match language {
        "python" | "javascript" => Ok(()),
        "cpp" | "java" => Err(AppError::BadRequest(
            "当前仅支持 Python 和 JavaScript 运行".to_owned(),
        )),
        _ => Err(AppError::BadRequest("不支持的编程语言".to_owned())),
    }
}

fn validate_mode(mode: &str) -> Result<(), AppError> {
    match mode {
        "examples" | "custom" => Ok(()),
        _ => Err(AppError::BadRequest("运行模式无效".to_owned())),
    }
}

#[cfg(test)]
mod tests {
    use super::{concurrency_key, rate_key, validate_language, validate_mode};

    #[test]
    fn python_and_javascript_are_supported() {
        assert!(validate_language("python").is_ok());
        assert!(validate_language("javascript").is_ok());
        assert!(validate_language("cpp").is_err());
        assert!(validate_language("java").is_err());
        assert!(validate_language("ruby").is_err());
    }

    #[test]
    fn both_examples_and_custom_modes_are_supported() {
        assert!(validate_mode("examples").is_ok());
        assert!(validate_mode("custom").is_ok());
        assert!(validate_mode("batch").is_err());
    }

    #[test]
    fn redis_keys_are_stable() {
        assert_eq!(concurrency_key(7), "theseus:run:concurrency:7");
        assert!(rate_key(7).starts_with("theseus:run:rate:7:"));
    }
}
