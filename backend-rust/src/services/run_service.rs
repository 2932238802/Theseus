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
        CodeRunRow, RUN_STATUS_INTERNAL_ERROR, RUN_STATUS_QUEUED, RunConfig, RunCreateRequest,
        RunCreateResponse, RunDetailResponse, RunListQuery, RunListResponse, RunStatusResponse,
        RunSummary, is_terminal_status,
    },
};

const RUNS_PER_MINUTE: i64 = 10;
/// Run phase budget, mirrors the worker's `RUN_TIMEOUT`.
const RUN_TIMEOUT_SECONDS: u64 = 10;
/// Per-case budget, mirrors the worker's `CASE_TIMEOUT`.
const CASE_TIMEOUT_SECONDS: u64 = 2;
/// Extra slack so the concurrency lock outlives the slowest legitimate run.
const LOCK_TTL_BUFFER_SECONDS: u64 = 30;
const QUEUED_TIMEOUT_MESSAGE: &str = "排队超时：评测服务不可用";
const STALE_TIMEOUT_MESSAGE: &str = "执行超时：Worker 可能已离线";

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
        let worker_alive = queue::has_live_worker(&mut redis).await.map_err(|error| {
            tracing::error!(error = ?error, "failed to check judge worker heartbeat");
            AppError::ServiceUnavailable("运行队列暂不可用".to_owned())
        })?;
        if !worker_alive {
            tracing::warn!(
                user_id = user.id,
                "rejecting run because no judge worker is alive"
            );
            return Err(AppError::ServiceUnavailable(
                "评测服务暂不可用，请稍后再试".to_owned(),
            ));
        }
        self.enforce_rate(&mut redis, user.id).await?;
        let rate_key = rate_key(user.id);
        let lock_key = concurrency_key(user.id);
        let token = random_token();
        let lock_ttl = concurrency_ttl(
            self.config.run_queue_timeout_secs,
            self.config.run_compile_timeout_secs,
            case_total,
        );
        let acquired: Option<String> = cmd("SET")
            .arg(&lock_key)
            .arg(&token)
            .arg("NX")
            .arg("EX")
            .arg(lock_ttl)
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

        if !swap_lock(&mut redis, &lock_key, &token, run_id, lock_ttl).await {
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

    pub async fn list(
        &self,
        pool: &PgPool,
        user: &AuthUser,
        query: RunListQuery,
    ) -> Result<RunListResponse, AppError> {
        let (page, size) = normalize_page(query.page, query.size);
        let offset = i64::from(page - 1) * i64::from(size);
        let limit = i64::from(size);
        let (total, runs) = match query.problem_id {
            Some(problem_id) if problem_id > 0 => {
                let total: i64 = sqlx::query_scalar(
                    "SELECT COUNT(*) FROM code_runs WHERE user_id = $1 AND problem_id = $2",
                )
                .bind(user.id)
                .bind(problem_id)
                .fetch_one(pool)
                .await
                .map_err(AppError::Database)?;
                let runs = sqlx::query_as::<_, RunSummary>(
                    "SELECT id, problem_id, problem_title, language, mode, status, case_passed, case_total, created_at FROM code_runs WHERE user_id = $1 AND problem_id = $2 ORDER BY created_at DESC, id DESC LIMIT $3 OFFSET $4",
                )
                .bind(user.id)
                .bind(problem_id)
                .bind(limit)
                .bind(offset)
                .fetch_all(pool)
                .await
                .map_err(AppError::Database)?;
                (total, runs)
            }
            _ => {
                let total: i64 =
                    sqlx::query_scalar("SELECT COUNT(*) FROM code_runs WHERE user_id = $1")
                        .bind(user.id)
                        .fetch_one(pool)
                        .await
                        .map_err(AppError::Database)?;
                let runs = sqlx::query_as::<_, RunSummary>(
                    "SELECT id, problem_id, problem_title, language, mode, status, case_passed, case_total, created_at FROM code_runs WHERE user_id = $1 ORDER BY created_at DESC, id DESC LIMIT $2 OFFSET $3",
                )
                .bind(user.id)
                .bind(limit)
                .bind(offset)
                .fetch_all(pool)
                .await
                .map_err(AppError::Database)?;
                (total, runs)
            }
        };
        Ok(RunListResponse {
            total,
            page,
            size,
            runs,
        })
    }

    pub async fn delete(
        &self,
        pool: &PgPool,
        user: &AuthUser,
        run_id: i64,
    ) -> Result<(), AppError> {
        if run_id <= 0 {
            return Err(AppError::BadRequest("运行 ID 无效".to_owned()));
        }
        let row = fetch_run_row(pool, run_id).await?;
        check_owner(&row, user)?;
        if !is_terminal_status(&row.status) {
            return Err(AppError::Conflict("运行尚未结束，无法删除".to_owned()));
        }
        sqlx::query("DELETE FROM code_runs WHERE id = $1 AND user_id = $2")
            .bind(run_id)
            .bind(user.id)
            .execute(pool)
            .await
            .map_err(AppError::Database)?;
        if let Some(mut redis) = self.redis.clone() {
            queue::status_key_delete(&mut redis, &status_key(run_id)).await;
        }
        Ok(())
    }

    /// Fails runs that stayed non-terminal for too long and releases their
    /// concurrency locks. This is the safety net for the case where no judge
    /// worker consumes the queue at all: without it a `queued` run would hold
    /// its user's lock until the lock TTL expires.
    ///
    /// The updates are conditional on the previous status so they never
    /// overwrite a result the worker wrote concurrently.
    pub async fn expire_stale_runs(&self, pool: &PgPool) -> Result<usize, AppError> {
        if !self.config.run_code_enabled {
            return Ok(0);
        }
        let Some(mut redis) = self.redis.clone() else {
            return Ok(0);
        };

        let queued = sqlx::query_as::<_, (i64, i32, i32, i32)>(
            "UPDATE code_runs \
             SET status = 'internal_error', error_message = $1, finished_at = CURRENT_TIMESTAMP \
             WHERE status = 'queued' \
               AND created_at < CURRENT_TIMESTAMP - make_interval(secs => $2::double precision) \
             RETURNING id, user_id, case_passed, case_total",
        )
        .bind(QUEUED_TIMEOUT_MESSAGE)
        .bind(self.config.run_queue_timeout_secs as f64)
        .fetch_all(pool)
        .await
        .map_err(AppError::Database)?;

        let stale = sqlx::query_as::<_, (i64, i32, i32, i32)>(
            "UPDATE code_runs \
             SET status = 'internal_error', error_message = $1, finished_at = CURRENT_TIMESTAMP \
             WHERE status IN ('compiling', 'running') \
               AND COALESCE(started_at, created_at) < CURRENT_TIMESTAMP - make_interval(secs => $2::double precision) \
             RETURNING id, user_id, case_passed, case_total",
        )
        .bind(STALE_TIMEOUT_MESSAGE)
        .bind(self.config.run_stale_timeout_secs as f64)
        .fetch_all(pool)
        .await
        .map_err(AppError::Database)?;

        let mut expired = 0usize;
        let entries = queued
            .into_iter()
            .map(|row| (row, QUEUED_TIMEOUT_MESSAGE))
            .chain(stale.into_iter().map(|row| (row, STALE_TIMEOUT_MESSAGE)));
        for ((run_id, user_id, case_passed, case_total), message) in entries {
            tracing::warn!(
                run_id,
                user_id,
                error = message,
                "expired stale run and released its concurrency lock"
            );
            let cached = CachedRunStatus::new(
                user_id,
                run_id,
                RUN_STATUS_INTERNAL_ERROR,
                case_passed,
                case_total,
                Some(message.to_owned()),
            );
            if let Err(error) = write_status_cache(&mut redis, cached).await {
                tracing::warn!(run_id, error = ?error, "failed to cache expired run status");
            }
            release_user_lock(&mut redis, user_id, run_id).await;
            expired += 1;
        }
        Ok(expired)
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
        "SELECT id, user_id, problem_id, problem_title, language, mode, code, input, run_config_snapshot, status, cases, case_total, case_passed, compile_output, error_message, runtime_ms, memory_kb, attempt_count, created_at, started_at, finished_at FROM code_runs WHERE id = $1",
    )
    .bind(run_id)
    .fetch_optional(pool)
    .await
    .map_err(AppError::Database)?
    .ok_or_else(|| AppError::NotFound("运行记录不存在".to_owned()))
}

pub async fn increment_attempt(pool: &PgPool, run_id: i64) -> Result<i32, AppError> {
    sqlx::query_scalar(
        "UPDATE code_runs SET attempt_count = attempt_count + 1 WHERE id = $1 RETURNING attempt_count",
    )
    .bind(run_id)
    .fetch_optional(pool)
    .await
    .map_err(AppError::Database)?
    .ok_or_else(|| AppError::NotFound("运行记录不存在".to_owned()))
}

pub fn normalize_page(page: Option<u32>, size: Option<u32>) -> (u32, u32) {
    (page.unwrap_or(1).max(1), size.unwrap_or(20).clamp(1, 50))
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
        "UPDATE code_runs SET status = 'compiling', started_at = CURRENT_TIMESTAMP WHERE id = $1 AND status IN ('queued', 'compiling', 'running')",
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

async fn swap_lock(
    redis: &mut ConnectionManager,
    key: &str,
    token: &str,
    run_id: i64,
    ttl_seconds: u64,
) -> bool {
    let script = "if redis.call('GET', KEYS[1]) == ARGV[1] then redis.call('SET', KEYS[1], ARGV[2], 'EX', ARGV[3]); return 1 else return 0 end";
    cmd("EVAL")
        .arg(script)
        .arg(1)
        .arg(key)
        .arg(token)
        .arg(run_id.to_string())
        .arg(ttl_seconds)
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

/// Lock TTL is derived from the task itself instead of a fixed 10 minutes:
/// waiting in queue + one compile + one full run + every case's own budget +
/// slack.
fn concurrency_ttl(queue_timeout_secs: u64, compile_timeout_secs: u64, case_total: i32) -> u64 {
    let cases = case_total.max(1) as u64;
    queue_timeout_secs
        + compile_timeout_secs
        + RUN_TIMEOUT_SECONDS
        + cases * CASE_TIMEOUT_SECONDS
        + LOCK_TTL_BUFFER_SECONDS
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
        "python" | "javascript" | "cpp" | "java" => Ok(()),
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
    use super::{
        concurrency_key, concurrency_ttl, normalize_page, rate_key, validate_language,
        validate_mode,
    };

    #[test]
    fn all_supported_languages_pass() {
        for language in ["python", "javascript", "cpp", "java"] {
            assert!(
                validate_language(language).is_ok(),
                "{language} should pass"
            );
        }
        assert!(validate_language("ruby").is_err());
    }

    #[test]
    fn pagination_is_clamped() {
        assert_eq!(normalize_page(None, None), (1, 20));
        assert_eq!(normalize_page(Some(0), Some(0)), (1, 1));
        assert_eq!(normalize_page(Some(3), Some(500)), (3, 50));
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

    #[test]
    fn lock_ttl_covers_queue_compile_and_case_budget() {
        assert_eq!(concurrency_ttl(90, 60, 0), 90 + 60 + 10 + 2 + 30);
        assert_eq!(concurrency_ttl(90, 60, 5), 90 + 60 + 10 + 10 + 30);
        assert!(concurrency_ttl(30, 60, 10) > concurrency_ttl(30, 60, 1));
    }
}
