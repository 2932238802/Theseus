use std::sync::Arc;

use chrono::{DateTime, Utc};
use redis::{aio::ConnectionManager, cmd};
use serde::{Deserialize, Serialize};
use serde_json::Value;
use sqlx::PgPool;

use crate::{
    common::error::AppError,
    config::Config,
    judge::{
        queue,
        run_config::{MAX_CODE_BYTES, validate_input, validate_judge_cases, validate_run_config},
    },
    middleware::auth::AuthUser,
    models::{
        run::{PublicCase, RunConfig},
        submission::{
            SUBMISSION_STATUS_ACCEPTED, SUBMISSION_STATUS_INTERNAL_ERROR,
            SUBMISSION_STATUS_PENDING, SubmissionCreatedResponse, SubmissionListQuery,
            SubmissionListResponse, SubmissionRequest, SubmissionResponse, SubmissionRow,
            SubmissionStatusResponse, SubmissionSummary, is_terminal_status,
        },
    },
    services::{
        assignment_policy::{self as policy},
        contest_service,
    },
};

const SUBMISSIONS_PER_MINUTE: i64 = 10;
/// Extra slack so the concurrency lock outlives the slowest legitimate
/// submission (queue + compile + judge + reaper margin).
const LOCK_TTL_BUFFER_SECONDS: u64 = 30;
const PENDING_TIMEOUT_MESSAGE: &str = "排队超时：评测服务不可用";
const STALE_TIMEOUT_MESSAGE: &str = "评测超时：Worker 可能已离线";

#[derive(Debug, Clone, Copy)]
struct AssignmentContext {
    assignment_id: i32,
    class_id: i32,
}

#[derive(Clone)]
pub struct SubmissionService {
    config: Arc<Config>,
    redis: Option<ConnectionManager>,
}

#[derive(Debug, Serialize, Deserialize)]
pub struct CachedSubmissionStatus {
    user_id: i32,
    id: i32,
    status: String,
    test_cases_passed: i32,
    total_test_cases: i32,
    #[serde(default)]
    error_message: Option<String>,
    updated_at: DateTime<Utc>,
}

impl CachedSubmissionStatus {
    pub fn new(
        user_id: i32,
        submission_id: i32,
        status: &str,
        test_cases_passed: i32,
        total_test_cases: i32,
        error_message: Option<String>,
    ) -> Self {
        Self {
            user_id,
            id: submission_id,
            status: status.to_owned(),
            test_cases_passed,
            total_test_cases,
            error_message,
            updated_at: Utc::now(),
        }
    }

    fn response(&self) -> SubmissionStatusResponse {
        SubmissionStatusResponse {
            id: self.id,
            status: self.status.clone(),
            test_cases_passed: self.test_cases_passed,
            total_test_cases: self.total_test_cases,
            error_message: self.error_message.clone(),
            updated_at: self.updated_at,
        }
    }
}

impl SubmissionService {
    pub fn new(config: Arc<Config>, redis: Option<ConnectionManager>) -> Self {
        Self { config, redis }
    }

    pub fn enabled(&self) -> bool {
        self.config.submit_judge_enabled
    }

    pub async fn create(
        &self,
        pool: &PgPool,
        user: &AuthUser,
        request: SubmissionRequest,
    ) -> Result<SubmissionCreatedResponse, AppError> {
        if !self.config.submit_judge_enabled {
            return Err(AppError::ServiceUnavailable("评测服务暂不可用".to_owned()));
        }
        if request.problem_id <= 0 {
            return Err(AppError::BadRequest("题目 ID 无效".to_owned()));
        }
        validate_language(&request.language)?;
        if request.code.trim().is_empty() {
            return Err(AppError::BadRequest("代码不能为空".to_owned()));
        }
        if request.code.len() > MAX_CODE_BYTES {
            return Err(AppError::BadRequest("代码不能超过 64 KB".to_owned()));
        }

        if request.assignment_id.is_some() && request.contest_id.is_some() {
            return Err(AppError::BadRequest("比赛提交不能同时关联作业".to_owned()));
        }
        let contest_context = match request.contest_id {
            Some(contest_id) => Some(
                contest_service::precheck_submission(pool, user.id, contest_id, request.problem_id)
                    .await?,
            ),
            None => None,
        };
        // Contest submissions use the frozen snapshot captured when the
        // contest started, so later edits to the problem cannot change judging.
        let (run_config_value, judge_cases_value) = if let Some(context) = &contest_context {
            if context.run_config.is_null() {
                return Err(AppError::BadRequest("该题暂不支持提交评测".to_owned()));
            }
            (context.run_config.clone(), context.judge_cases.clone())
        } else {
            let problem = sqlx::query_as::<_, (String, Option<Value>, Option<Value>)>(
                "SELECT title, run_config, judge_cases FROM problems WHERE id = $1 AND review_status = 'approved'",
            )
            .bind(request.problem_id)
            .fetch_optional(pool)
            .await
            .map_err(AppError::Database)?
            .ok_or_else(|| AppError::NotFound("题目不存在".to_owned()))?;
            let (_problem_title, run_config_value, judge_cases_value) = problem;
            let Some(run_config_value) = run_config_value else {
                return Err(AppError::BadRequest("该题暂不支持提交评测".to_owned()));
            };
            (run_config_value, judge_cases_value)
        };
        let run_config = validate_run_config(&run_config_value)?;
        // The API never inspects hidden case contents: it only checks that the
        // column is a JSON array so it can size the judging set. Full
        // validation happens inside the worker against the frozen snapshot.
        let hidden_count = match judge_cases_value.as_ref().filter(|value| !value.is_null()) {
            Some(value) => value
                .as_array()
                .ok_or_else(|| AppError::BadRequest("题目隐藏用例配置无效".to_owned()))?
                .len(),
            None => 0,
        };
        let case_total = run_config.public_cases.len() + hidden_count;
        if case_total == 0 {
            return Err(AppError::BadRequest("该题暂未配置评测用例".to_owned()));
        }
        if case_total > self.config.submit_max_cases {
            return Err(AppError::BadRequest("该题评测用例过多".to_owned()));
        }
        let assignment_context = match request.assignment_id {
            Some(assignment_id) => {
                Some(precheck_assignment(pool, user, assignment_id, request.problem_id).await?)
            }
            None => None,
        };

        let mut redis = self.redis()?;
        let worker_alive = queue::has_live_submit_worker(&mut redis)
            .await
            .map_err(|error| {
                tracing::error!(error = ?error, "failed to check submit worker heartbeat");
                AppError::ServiceUnavailable("评测队列暂不可用".to_owned())
            })?;
        if !worker_alive {
            tracing::warn!(
                user_id = user.id,
                "rejecting submission because no submit worker is alive"
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
            self.config.submit_queue_timeout_secs,
            self.config.run_compile_timeout_secs,
            self.config.submit_run_timeout_secs,
        );
        let acquired: Option<String> = cmd("SET")
            .arg(&lock_key)
            .arg(&token)
            .arg("NX")
            .arg("EX")
            .arg(lock_ttl)
            .query_async(&mut redis)
            .await
            .map_err(|_| AppError::ServiceUnavailable("评测队列暂不可用".to_owned()))?;
        if acquired.is_none() {
            release_rate(&mut redis, &rate_key).await;
            return Err(AppError::RateLimited(
                "有提交正在评测中，请等待其结束".to_owned(),
                5,
            ));
        }

        let submission_id = match persist_submission(
            pool,
            user,
            &request,
            case_total as i32,
            &run_config_value,
            &judge_cases_value,
            assignment_context.as_ref(),
            request.contest_id,
        )
        .await
        {
            Ok(submission_id) => submission_id,
            Err(error) => {
                release_lock(&mut redis, &lock_key, &token).await;
                release_rate(&mut redis, &rate_key).await;
                return Err(error);
            }
        };

        if !swap_lock(
            &mut redis,
            &lock_key,
            &token,
            i64::from(submission_id),
            lock_ttl,
        )
        .await
        {
            release_lock(&mut redis, &lock_key, &token).await;
            release_rate(&mut redis, &rate_key).await;
            mark_internal_error(pool, submission_id, "提交并发锁失效").await;
            return Err(AppError::ServiceUnavailable("评测队列暂不可用".to_owned()));
        }

        if let Err(error) = queue::enqueue(
            &mut redis,
            &self.config.submit_stream,
            i64::from(submission_id),
        )
        .await
        {
            tracing::error!(submission_id, error = %error, "failed to enqueue submission");
            mark_internal_error(pool, submission_id, "评测队列暂不可用").await;
            release_lock(&mut redis, &lock_key, &submission_id.to_string()).await;
            release_rate(&mut redis, &rate_key).await;
            return Err(AppError::ServiceUnavailable("评测队列暂不可用".to_owned()));
        }

        // The initial user_problem_status row is written in the same request
        // so the problem list reflects the attempt immediately. The worker
        // upgrades it to `accepted` on an accepted verdict.
        let _ = sqlx::query(
            "INSERT INTO user_problem_status (user_id, problem_id, status, last_submission_id) VALUES ($1, $2, 'attempted', $3) ON CONFLICT (user_id, problem_id) DO UPDATE SET last_submission_id = EXCLUDED.last_submission_id, updated_at = CURRENT_TIMESTAMP",
        )
        .bind(user.id)
        .bind(request.problem_id)
        .bind(submission_id)
        .execute(pool)
        .await;

        let queued = CachedSubmissionStatus::new(
            user.id,
            submission_id,
            SUBMISSION_STATUS_PENDING,
            0,
            case_total as i32,
            None,
        );
        if let Err(error) = write_status_cache(&mut redis, queued).await {
            tracing::warn!(submission_id, error = %error, "failed to cache queued submission");
        }

        Ok(SubmissionCreatedResponse {
            submission_id,
            status: SUBMISSION_STATUS_PENDING.to_owned(),
            message: "提交成功，正在评测中".to_owned(),
        })
    }

    pub async fn status(
        &self,
        pool: &PgPool,
        user: &AuthUser,
        submission_id: i32,
    ) -> Result<SubmissionStatusResponse, AppError> {
        if submission_id <= 0 {
            return Err(AppError::BadRequest("提交 ID 无效".to_owned()));
        }
        if let Some(mut redis) = self.redis.clone() {
            let key = status_key(submission_id);
            if let Some(raw) = queue::status_key_get(&mut redis, &key).await
                && let Ok(cached) = serde_json::from_str::<CachedSubmissionStatus>(&raw)
            {
                // Only the submitter may satisfy the request from the cache.
                // Teachers who own the assignment fall through to the database
                // so their access can be checked against the assignment owner.
                if cached.user_id == user.id {
                    // A non-terminal cache entry can go stale if the worker
                    // dies between claiming and writing its verdict; fall back
                    // to the database after a short grace period.
                    let fresh = Utc::now()
                        .signed_duration_since(cached.updated_at)
                        .num_seconds()
                        < 10;
                    if is_terminal_status(&cached.status) || fresh {
                        return Ok(cached.response());
                    }
                }
            }
        }
        let row = fetch_submission_row(pool, submission_id).await?;
        check_access(pool, &row, user).await?;
        let response = row.status_response();
        if let Some(mut redis) = self.redis.clone() {
            let cached = CachedSubmissionStatus::new(
                row.user_id,
                row.id,
                &row.status,
                row.test_cases_passed,
                row.total_test_cases,
                row.error_message.clone(),
            );
            if let Err(error) = write_status_cache(&mut redis, cached).await {
                tracing::warn!(submission_id, error = ?error, "failed to refresh submission cache");
            }
        }
        Ok(response)
    }

    pub async fn detail(
        &self,
        pool: &PgPool,
        user: &AuthUser,
        submission_id: i32,
    ) -> Result<SubmissionResponse, AppError> {
        if submission_id <= 0 {
            return Err(AppError::BadRequest("提交 ID 无效".to_owned()));
        }
        let row = fetch_submission_row(pool, submission_id).await?;
        check_access(pool, &row, user).await?;
        Ok(row.into())
    }

    pub async fn list(
        &self,
        pool: &PgPool,
        user: &AuthUser,
        query: SubmissionListQuery,
    ) -> Result<SubmissionListResponse, AppError> {
        let page = query.page.unwrap_or(1).max(1);
        let size = query.size.unwrap_or(20).clamp(1, 50);
        if query.user_id.is_some_and(|target| target != user.id) {
            return Err(AppError::Forbidden);
        }
        let target_user_id = user.id;
        let offset = i64::from(page - 1) * i64::from(size);
        let limit = i64::from(size);
        let (total, submissions) = match query.problem_id.filter(|id| *id > 0) {
            Some(problem_id) => {
                let total: i64 = sqlx::query_scalar(
                    "SELECT COUNT(*) FROM submissions s WHERE s.user_id = $1 AND s.problem_id = $2",
                )
                .bind(target_user_id)
                .bind(problem_id)
                .fetch_one(pool)
                .await
                .map_err(AppError::Database)?;
                let submissions = sqlx::query_as::<_, SubmissionSummary>(
                    "SELECT s.id, s.problem_id, p.title AS problem_title, s.language, s.status, s.test_cases_passed, s.total_test_cases, s.runtime, s.memory, s.error_message, s.submitted_at FROM submissions s JOIN problems p ON p.id = s.problem_id WHERE s.user_id = $1 AND s.problem_id = $2 ORDER BY s.submitted_at DESC, s.id DESC LIMIT $3 OFFSET $4",
                )
                .bind(target_user_id)
                .bind(problem_id)
                .bind(limit)
                .bind(offset)
                .fetch_all(pool)
                .await
                .map_err(AppError::Database)?;
                (total, submissions)
            }
            None => {
                let total: i64 =
                    sqlx::query_scalar("SELECT COUNT(*) FROM submissions s WHERE s.user_id = $1")
                        .bind(target_user_id)
                        .fetch_one(pool)
                        .await
                        .map_err(AppError::Database)?;
                let submissions = sqlx::query_as::<_, SubmissionSummary>(
                    "SELECT s.id, s.problem_id, p.title AS problem_title, s.language, s.status, s.test_cases_passed, s.total_test_cases, s.runtime, s.memory, s.error_message, s.submitted_at FROM submissions s JOIN problems p ON p.id = s.problem_id WHERE s.user_id = $1 ORDER BY s.submitted_at DESC, s.id DESC LIMIT $2 OFFSET $3",
                )
                .bind(target_user_id)
                .bind(limit)
                .bind(offset)
                .fetch_all(pool)
                .await
                .map_err(AppError::Database)?;
                (total, submissions)
            }
        };
        Ok(SubmissionListResponse {
            total,
            page,
            size,
            submissions,
        })
    }

    /// Fails submissions that waited too long or whose worker disappeared, and
    /// releases their concurrency locks. Conditional updates never overwrite a
    /// verdict written by a worker.
    pub async fn expire_stale_submissions(&self, pool: &PgPool) -> Result<usize, AppError> {
        if !self.config.submit_judge_enabled {
            return Ok(0);
        }
        let Some(mut redis) = self.redis.clone() else {
            return Ok(0);
        };

        let pending = sqlx::query_as::<_, (i32, i32, i32, i32)>(
            "UPDATE submissions \
             SET status = 'internal_error', error_message = $1, finished_at = CURRENT_TIMESTAMP \
             WHERE status = 'pending' \
               AND submitted_at < CURRENT_TIMESTAMP - make_interval(secs => $2::double precision) \
             RETURNING id, user_id, test_cases_passed, total_test_cases",
        )
        .bind(PENDING_TIMEOUT_MESSAGE)
        .bind(self.config.submit_queue_timeout_secs as f64)
        .fetch_all(pool)
        .await
        .map_err(AppError::Database)?;

        let stale = sqlx::query_as::<_, (i32, i32, i32, i32)>(
            "UPDATE submissions \
             SET status = 'internal_error', error_message = $1, finished_at = CURRENT_TIMESTAMP \
             WHERE status = 'judging' \
               AND COALESCE(started_at, submitted_at) < CURRENT_TIMESTAMP - make_interval(secs => $2::double precision) \
             RETURNING id, user_id, test_cases_passed, total_test_cases",
        )
        .bind(STALE_TIMEOUT_MESSAGE)
        .bind(self.config.submit_stale_timeout_secs as f64)
        .fetch_all(pool)
        .await
        .map_err(AppError::Database)?;

        let mut expired = 0usize;
        let entries = pending
            .into_iter()
            .map(|row| (row, PENDING_TIMEOUT_MESSAGE))
            .chain(stale.into_iter().map(|row| (row, STALE_TIMEOUT_MESSAGE)));
        for ((submission_id, user_id, passed, total), message) in entries {
            tracing::warn!(
                submission_id,
                user_id,
                error = message,
                "expired stale submission and released its concurrency lock"
            );
            let cached = CachedSubmissionStatus::new(
                user_id,
                submission_id,
                SUBMISSION_STATUS_INTERNAL_ERROR,
                passed,
                total,
                Some(message.to_owned()),
            );
            if let Err(error) = write_status_cache(&mut redis, cached).await {
                tracing::warn!(submission_id, error = ?error, "failed to cache expired submission");
            }
            release_user_lock(&mut redis, user_id, i64::from(submission_id)).await;
            expired += 1;
        }
        Ok(expired)
    }

    fn redis(&self) -> Result<ConnectionManager, AppError> {
        self.redis
            .clone()
            .ok_or_else(|| AppError::ServiceUnavailable("评测队列暂不可用".to_owned()))
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
            .map_err(|_| AppError::ServiceUnavailable("评测限流服务暂不可用".to_owned()))?;
        if count == 1 {
            let _: Result<i64, _> = cmd("EXPIRE").arg(&key).arg(120).query_async(redis).await;
        }
        if count > SUBMISSIONS_PER_MINUTE {
            let now = Utc::now().timestamp();
            let retry_after = (60 - now.rem_euclid(60)).max(1) as u64;
            return Err(AppError::RateLimited(
                "每分钟最多提交 10 次，请稍后再试".to_owned(),
                retry_after,
            ));
        }
        Ok(())
    }
}

pub async fn fetch_submission_row(pool: &PgPool, id: i32) -> Result<SubmissionRow, AppError> {
    sqlx::query_as::<_, SubmissionRow>(
        "SELECT s.id, s.user_id, s.problem_id, s.assignment_id, p.title AS problem_title, s.language, s.code, s.status, s.test_cases_passed, s.total_test_cases, s.runtime, s.memory, s.error_message, s.run_config_snapshot, s.judge_cases_snapshot, s.cases, s.compile_output, s.attempt_count, s.submitted_at, s.started_at, s.finished_at FROM submissions s JOIN problems p ON p.id = s.problem_id WHERE s.id = $1",
    )
    .bind(id)
    .fetch_optional(pool)
    .await
    .map_err(AppError::Database)?
    .ok_or_else(|| AppError::NotFound("提交记录不存在".to_owned()))
}

pub async fn increment_attempt(pool: &PgPool, id: i32) -> Result<i32, AppError> {
    sqlx::query_scalar(
        "UPDATE submissions SET attempt_count = attempt_count + 1 WHERE id = $1 RETURNING attempt_count",
    )
    .bind(id)
    .fetch_optional(pool)
    .await
    .map_err(AppError::Database)?
    .ok_or_else(|| AppError::NotFound("提交记录不存在".to_owned()))
}

pub fn parse_snapshots(row: &SubmissionRow) -> Result<(RunConfig, Vec<PublicCase>), AppError> {
    let snapshot = row
        .run_config_snapshot
        .as_ref()
        .ok_or_else(|| AppError::BadRequest("提交缺少 run_config 快照".to_owned()))?;
    let config = validate_run_config(snapshot)?;
    let hidden = match row
        .judge_cases_snapshot
        .as_ref()
        .filter(|value| !value.is_null())
    {
        Some(value) => validate_judge_cases(&config, value)?,
        None => Vec::new(),
    };
    Ok((config, hidden))
}

/// Builds the ordered judging set: public cases first, then hidden cases.
pub fn judge_cases(config: &RunConfig, hidden: Vec<PublicCase>) -> Vec<(Vec<Value>, Value)> {
    let mut cases = Vec::with_capacity(config.public_cases.len() + hidden.len());
    for case in &config.public_cases {
        cases.push((case.args.clone(), case.expected.clone()));
    }
    for case in hidden {
        cases.push((case.args, case.expected));
    }
    cases
}

/// Validates every judging case against the frozen run_config. Returns the
/// first invalid case index so the worker can fail with a precise message.
pub fn validate_judge_set(
    config: &RunConfig,
    cases: &[(Vec<Value>, Value)],
) -> Result<(), AppError> {
    for (index, (args, expected)) in cases.iter().enumerate() {
        let input = Value::Array(args.clone());
        validate_input(config, &input).map_err(|error| {
            AppError::BadRequest(format!("第 {} 条用例参数无效: {error}", index + 1))
        })?;
        if !crate::judge::run_config::value_matches_type(&config.return_type, expected) {
            return Err(AppError::BadRequest(format!(
                "第 {} 条用例 expected 与 return_type 不匹配",
                index + 1
            )));
        }
    }
    Ok(())
}

pub async fn claim_submission(pool: &PgPool, id: i32) -> Result<bool, AppError> {
    let result = sqlx::query(
        "UPDATE submissions SET status = 'judging', started_at = COALESCE(started_at, CURRENT_TIMESTAMP) WHERE id = $1 AND status IN ('pending', 'judging')",
    )
    .bind(id)
    .execute(pool)
    .await
    .map_err(AppError::Database)?;
    Ok(result.rows_affected() > 0)
}

pub struct SubmissionTerminalUpdate<'a> {
    pub status: &'a str,
    pub cases: &'a Value,
    pub test_cases_passed: i32,
    pub total_test_cases: i32,
    pub compile_output: Option<&'a str>,
    pub error_message: Option<&'a str>,
    pub runtime: Option<i32>,
    pub memory: Option<i32>,
}

/// Writes the verdict and, when the verdict is a user-facing one, updates the
/// problem counters and the user's problem status in the same transaction.
/// Returns `false` when the submission was already terminal.
pub async fn finish_submission(
    pool: &PgPool,
    id: i32,
    update: SubmissionTerminalUpdate<'_>,
) -> Result<bool, AppError> {
    let mut transaction = pool.begin().await.map_err(AppError::Database)?;
    let result = sqlx::query(
        "UPDATE submissions SET status = $2, cases = $3, test_cases_passed = $4, total_test_cases = $5, compile_output = $6, error_message = $7, runtime = $8, memory = $9, finished_at = CURRENT_TIMESTAMP WHERE id = $1 AND status IN ('pending', 'judging')",
    )
    .bind(id)
    .bind(update.status)
    .bind(update.cases)
    .bind(update.test_cases_passed)
    .bind(update.total_test_cases)
    .bind(update.compile_output)
    .bind(update.error_message)
    .bind(update.runtime)
    .bind(update.memory)
    .execute(&mut *transaction)
    .await
    .map_err(AppError::Database)?;
    if result.rows_affected() == 0 {
        transaction.commit().await.map_err(AppError::Database)?;
        return Ok(false);
    }

    if update.status != SUBMISSION_STATUS_INTERNAL_ERROR {
        let (user_id, problem_id): (i32, i32) =
            sqlx::query_as("SELECT user_id, problem_id FROM submissions WHERE id = $1")
                .bind(id)
                .fetch_one(&mut *transaction)
                .await
                .map_err(AppError::Database)?;
        let accepted = update.status == SUBMISSION_STATUS_ACCEPTED;
        if accepted {
            sqlx::query(
                "UPDATE problems SET submit_count = submit_count + 1, accept_count = accept_count + 1, acceptance_rate = ((accept_count + 1)::double precision / (submit_count + 1)::double precision) * 100 WHERE id = $1",
            )
            .bind(problem_id)
            .execute(&mut *transaction)
            .await
            .map_err(AppError::Database)?;
        } else {
            sqlx::query(
                "UPDATE problems SET submit_count = submit_count + 1, acceptance_rate = (accept_count::double precision / (submit_count + 1)::double precision) * 100 WHERE id = $1",
            )
            .bind(problem_id)
            .execute(&mut *transaction)
            .await
            .map_err(AppError::Database)?;
        }
        let problem_status = if accepted { "accepted" } else { "attempted" };
        sqlx::query(
            "INSERT INTO user_problem_status (user_id, problem_id, status, last_submission_id) VALUES ($1, $2, $3, $4) ON CONFLICT (user_id, problem_id) DO UPDATE SET status = CASE WHEN user_problem_status.status = 'accepted' THEN 'accepted' ELSE EXCLUDED.status END, last_submission_id = EXCLUDED.last_submission_id, updated_at = CURRENT_TIMESTAMP",
        )
        .bind(user_id)
        .bind(problem_id)
        .bind(problem_status)
        .bind(id)
        .execute(&mut *transaction)
        .await
        .map_err(AppError::Database)?;
    }

    transaction.commit().await.map_err(AppError::Database)?;
    Ok(true)
}

pub async fn mark_internal_error(pool: &PgPool, id: i32, message: &str) {
    let _ = sqlx::query(
        "UPDATE submissions SET status = 'internal_error', error_message = $2, finished_at = CURRENT_TIMESTAMP WHERE id = $1 AND status IN ('pending', 'judging')",
    )
    .bind(id)
    .bind(message)
    .execute(pool)
    .await;
}

pub async fn write_status_cache(
    redis: &mut ConnectionManager,
    cached: CachedSubmissionStatus,
) -> Result<(), AppError> {
    let key = status_key(cached.id);
    let raw = serde_json::to_string(&cached)
        .map_err(|error| AppError::Internal(format!("提交状态序列化失败: {error}")))?;
    queue::status_key_set(redis, &key, &raw).await
}

pub async fn release_user_lock(redis: &mut ConnectionManager, user_id: i32, submission_id: i64) {
    release_lock(redis, &concurrency_key(user_id), &submission_id.to_string()).await;
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
    submission_id: i64,
    ttl_seconds: u64,
) -> bool {
    let script = "if redis.call('GET', KEYS[1]) == ARGV[1] then redis.call('SET', KEYS[1], ARGV[2], 'EX', ARGV[3]); return 1 else return 0 end";
    cmd("EVAL")
        .arg(script)
        .arg(1)
        .arg(key)
        .arg(token)
        .arg(submission_id.to_string())
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
    format!("theseus:submit:rate:{user_id}:{minute}")
}

fn concurrency_key(user_id: i32) -> String {
    format!("theseus:submit:concurrency:{user_id}")
}

fn concurrency_ttl(
    queue_timeout_secs: u64,
    compile_timeout_secs: u64,
    run_timeout_secs: u64,
) -> u64 {
    queue_timeout_secs + compile_timeout_secs + run_timeout_secs + LOCK_TTL_BUFFER_SECONDS
}

fn status_key(submission_id: i32) -> String {
    format!("theseus:submission:status:{submission_id}")
}

fn random_token() -> String {
    format!(
        "{:016x}{:016x}",
        rand::random::<u64>(),
        rand::random::<u64>()
    )
}

async fn check_access(pool: &PgPool, row: &SubmissionRow, user: &AuthUser) -> Result<(), AppError> {
    if row.user_id == user.id {
        return Ok(());
    }
    if user.is_admin() {
        return Err(AppError::Forbidden);
    }
    if let Some(assignment_id) = row.assignment_id {
        let is_owner: Option<bool> = sqlx::query_scalar(
            "SELECT c.owner_id = $2 FROM assignments a JOIN classes c ON c.id = a.class_id WHERE a.id = $1",
        )
        .bind(assignment_id)
        .bind(user.id)
        .fetch_optional(pool)
        .await
        .map_err(AppError::Database)?;
        if user.is_teacher() && is_owner == Some(true) {
            return Ok(());
        }
    }
    Err(AppError::NotFound("提交记录不存在".to_owned()))
}

async fn precheck_assignment(
    pool: &PgPool,
    user: &AuthUser,
    assignment_id: i32,
    problem_id: i32,
) -> Result<AssignmentContext, AppError> {
    #[derive(sqlx::FromRow)]
    struct AssignmentPrecheck {
        class_id: i32,
        status: String,
        class_archived_at: Option<DateTime<Utc>>,
        started: bool,
        due_at: Option<DateTime<Utc>>,
        late_policy: String,
        late_grace_hours: i32,
        max_attempts: Option<i32>,
    }

    #[derive(sqlx::FromRow)]
    struct OverridePrecheck {
        makeup_due_at: Option<DateTime<Utc>>,
        exempt: bool,
    }

    if !user.is_student() {
        return Err(AppError::ForbiddenWith(
            "教师/管理员不能提交班级作业".to_owned(),
        ));
    }
    if assignment_id <= 0 {
        return Err(AppError::BadRequest("作业 ID 无效".to_owned()));
    }
    let assignment: Option<AssignmentPrecheck> = sqlx::query_as(
        "SELECT a.class_id, a.status, c.archived_at AS class_archived_at, \
         (a.start_at IS NULL OR a.start_at <= CURRENT_TIMESTAMP) AS started, \
         a.due_at, a.late_policy, a.late_grace_hours, a.max_attempts \
         FROM assignments a JOIN classes c ON c.id = a.class_id WHERE a.id = $1",
    )
    .bind(assignment_id)
    .fetch_optional(pool)
    .await
    .map_err(AppError::Database)?;
    let assignment = assignment.ok_or_else(|| AppError::NotFound("作业不存在".to_owned()))?;
    let member: bool = sqlx::query_scalar(
        "SELECT EXISTS(SELECT 1 FROM class_members WHERE class_id = $1 AND user_id = $2 AND status = 'active')",
    )
    .bind(assignment.class_id)
    .bind(user.id)
    .fetch_one(pool)
    .await
    .map_err(AppError::Database)?;
    if !member {
        return Err(AppError::NotFound("作业不存在".to_owned()));
    }
    if assignment.status == "draft" {
        return Err(AppError::NotFound("作业不存在".to_owned()));
    }
    if assignment.status == "archived" {
        return Err(AppError::Conflict("作业已归档".to_owned()));
    }
    if assignment.class_archived_at.is_some() {
        return Err(AppError::Conflict("班级已归档".to_owned()));
    }
    if !assignment.started {
        return Err(AppError::Conflict("作业尚未开始".to_owned()));
    }
    let problem_limit: Option<Option<i32>> = sqlx::query_scalar(
        "SELECT max_attempts FROM assignment_problems WHERE assignment_id = $1 AND problem_id = $2",
    )
    .bind(assignment_id)
    .bind(problem_id)
    .fetch_optional(pool)
    .await
    .map_err(AppError::Database)?;
    let Some(problem_limit) = problem_limit else {
        return Err(AppError::BadRequest("题目不属于该作业".to_owned()));
    };

    let override_row: Option<OverridePrecheck> = sqlx::query_as(
        "SELECT makeup_due_at, exempt \
         FROM assignment_student_overrides \
         WHERE assignment_id = $1 AND user_id = $2 AND problem_id = $3",
    )
    .bind(assignment_id)
    .bind(user.id)
    .bind(problem_id)
    .fetch_optional(pool)
    .await
    .map_err(AppError::Database)?;
    if override_row.as_ref().is_some_and(|row| row.exempt) {
        return Err(AppError::Conflict("该题已免修".to_owned()));
    }

    let now = Utc::now();
    let window_end = policy::submission_window_end(
        assignment.due_at,
        override_row.as_ref().and_then(|row| row.makeup_due_at),
        &assignment.late_policy,
        assignment.late_grace_hours,
    )
    .ok_or_else(|| AppError::Conflict("作业已截止".to_owned()))?;
    if now > window_end {
        return Err(AppError::Conflict("作业已截止".to_owned()));
    }

    let used: i64 = sqlx::query_scalar(
        "SELECT COUNT(*) FROM submissions WHERE assignment_id = $1 AND user_id = $2 \
         AND problem_id = $3 AND status <> 'internal_error'",
    )
    .bind(assignment_id)
    .bind(user.id)
    .bind(problem_id)
    .fetch_one(pool)
    .await
    .map_err(AppError::Database)?;
    let limit = problem_limit.or(assignment.max_attempts);
    if policy::attempts_exhausted(used, limit) {
        return Err(AppError::Conflict("该题提交次数已用完".to_owned()));
    }

    Ok(AssignmentContext {
        assignment_id,
        class_id: assignment.class_id,
    })
}

#[allow(clippy::too_many_arguments)]
async fn persist_submission(
    pool: &PgPool,
    user: &AuthUser,
    request: &SubmissionRequest,
    case_total: i32,
    run_config_value: &Value,
    judge_cases_value: &Option<Value>,
    assignment: Option<&AssignmentContext>,
    contest_id: Option<i32>,
) -> Result<i32, AppError> {
    let Some(context) = assignment else {
        return sqlx::query_scalar::<_, i32>(
            "INSERT INTO submissions (user_id, problem_id, language, code, status, total_test_cases, run_config_snapshot, judge_cases_snapshot, contest_id) VALUES ($1, $2, $3, $4, $5, $6, $7, $8, $9) RETURNING id",
        )
        .bind(user.id)
        .bind(request.problem_id)
        .bind(&request.language)
        .bind(&request.code)
        .bind(SUBMISSION_STATUS_PENDING)
        .bind(case_total)
        .bind(run_config_value)
        .bind(judge_cases_value)
        .bind(contest_id)
        .fetch_one(pool)
        .await
        .map_err(AppError::Database);
    };

    let mut transaction = pool.begin().await.map_err(AppError::Database)?;
    let class: Option<(i32, Option<DateTime<Utc>>)> =
        sqlx::query_as("SELECT id, archived_at FROM classes WHERE id = $1 FOR SHARE")
            .bind(context.class_id)
            .fetch_optional(&mut *transaction)
            .await
            .map_err(AppError::Database)?;
    let (_, class_archived_at) =
        class.ok_or_else(|| AppError::NotFound("作业不存在".to_owned()))?;
    if class_archived_at.is_some() {
        return Err(AppError::Conflict("班级已归档".to_owned()));
    }

    #[derive(sqlx::FromRow)]
    struct LockedAssignment {
        class_id: i32,
        status: String,
        started: bool,
        due_at: Option<DateTime<Utc>>,
        late_policy: String,
        late_grace_hours: i32,
        max_attempts: Option<i32>,
    }

    #[derive(sqlx::FromRow)]
    struct OverrideCheck {
        makeup_due_at: Option<DateTime<Utc>>,
        exempt: bool,
    }

    let assignment_row: Option<LockedAssignment> = sqlx::query_as(
        "SELECT class_id, status, \
         (start_at IS NULL OR start_at <= CURRENT_TIMESTAMP) AS started, \
         due_at, late_policy, late_grace_hours, max_attempts \
         FROM assignments WHERE id = $1 FOR SHARE",
    )
    .bind(context.assignment_id)
    .fetch_optional(&mut *transaction)
    .await
    .map_err(AppError::Database)?;
    let assignment_row =
        assignment_row.ok_or_else(|| AppError::NotFound("作业不存在".to_owned()))?;
    if assignment_row.class_id != context.class_id {
        return Err(AppError::NotFound("作业不存在".to_owned()));
    }
    if assignment_row.status == "archived" {
        return Err(AppError::Conflict("作业已归档".to_owned()));
    }
    if assignment_row.status == "draft" {
        return Err(AppError::NotFound("作业不存在".to_owned()));
    }
    let membership: Option<String> = sqlx::query_scalar(
        "SELECT status FROM class_members WHERE class_id = $1 AND user_id = $2 FOR SHARE",
    )
    .bind(context.class_id)
    .bind(user.id)
    .fetch_optional(&mut *transaction)
    .await
    .map_err(AppError::Database)?;
    if membership.as_deref() != Some("active") {
        return Err(AppError::NotFound("作业不存在".to_owned()));
    }
    if !assignment_row.started {
        return Err(AppError::Conflict("作业尚未开始".to_owned()));
    }
    let problem_limit: Option<Option<i32>> = sqlx::query_scalar(
        "SELECT max_attempts FROM assignment_problems \
         WHERE assignment_id = $1 AND problem_id = $2",
    )
    .bind(context.assignment_id)
    .bind(request.problem_id)
    .fetch_optional(&mut *transaction)
    .await
    .map_err(AppError::Database)?;
    let Some(problem_limit) = problem_limit else {
        return Err(AppError::BadRequest("题目不属于该作业".to_owned()));
    };

    let override_row: Option<OverrideCheck> = sqlx::query_as(
        "SELECT makeup_due_at, exempt \
         FROM assignment_student_overrides \
         WHERE assignment_id = $1 AND user_id = $2 AND problem_id = $3 \
         FOR SHARE",
    )
    .bind(context.assignment_id)
    .bind(user.id)
    .bind(request.problem_id)
    .fetch_optional(&mut *transaction)
    .await
    .map_err(AppError::Database)?;
    if override_row.as_ref().is_some_and(|row| row.exempt) {
        return Err(AppError::Conflict("该题已免修".to_owned()));
    }

    let now: DateTime<Utc> = sqlx::query_scalar("SELECT CURRENT_TIMESTAMP")
        .fetch_one(&mut *transaction)
        .await
        .map_err(AppError::Database)?;
    let window_end = policy::submission_window_end(
        assignment_row.due_at,
        override_row.as_ref().and_then(|row| row.makeup_due_at),
        &assignment_row.late_policy,
        assignment_row.late_grace_hours,
    )
    .ok_or_else(|| AppError::Conflict("作业已截止".to_owned()))?;
    if now > window_end {
        return Err(AppError::Conflict("作业已截止".to_owned()));
    }

    let used: i64 = sqlx::query_scalar(
        "SELECT COUNT(*) FROM submissions \
         WHERE assignment_id = $1 AND user_id = $2 AND problem_id = $3 \
           AND status <> 'internal_error'",
    )
    .bind(context.assignment_id)
    .bind(user.id)
    .bind(request.problem_id)
    .fetch_one(&mut *transaction)
    .await
    .map_err(AppError::Database)?;
    let limit = problem_limit.or(assignment_row.max_attempts);
    if policy::attempts_exhausted(used, limit) {
        return Err(AppError::Conflict("该题提交次数已用完".to_owned()));
    }

    let raw_late_days = policy::raw_late_days(now, assignment_row.due_at);
    let is_late = raw_late_days > 0;
    let submission_id: i32 = sqlx::query_scalar(
        "INSERT INTO submissions \
         (user_id, problem_id, assignment_id, language, code, status, total_test_cases, \
          run_config_snapshot, judge_cases_snapshot, is_late, late_days) \
         VALUES ($1, $2, $3, $4, $5, $6, $7, $8, $9, $10, $11) RETURNING id",
    )
    .bind(user.id)
    .bind(request.problem_id)
    .bind(context.assignment_id)
    .bind(&request.language)
    .bind(&request.code)
    .bind(SUBMISSION_STATUS_PENDING)
    .bind(case_total)
    .bind(run_config_value)
    .bind(judge_cases_value)
    .bind(is_late)
    .bind(raw_late_days)
    .fetch_one(&mut *transaction)
    .await
    .map_err(AppError::Database)?;
    transaction.commit().await.map_err(AppError::Database)?;
    Ok(submission_id)
}

fn validate_language(language: &str) -> Result<(), AppError> {
    match language {
        "python" | "javascript" | "cpp" | "java" => Ok(()),
        _ => Err(AppError::BadRequest("不支持的编程语言".to_owned())),
    }
}

#[cfg(test)]
mod tests {
    use serde_json::json;

    use super::{
        concurrency_key, concurrency_ttl, judge_cases, parse_snapshots, rate_key,
        validate_judge_set, validate_language,
    };
    use crate::{judge::run_config::validate_run_config, models::submission::SubmissionRow};
    use chrono::Utc;

    fn config() -> crate::models::run::RunConfig {
        validate_run_config(&json!({
            "version": 1,
            "function_name": "twoSum",
            "params": [
                { "name": "nums", "type": "int[]" },
                { "name": "target", "type": "int" }
            ],
            "return_type": "int[]",
            "compare": { "mode": "exact" },
            "public_cases": [
                { "args": [[2, 7, 11, 15], 9], "expected": [0, 1] }
            ]
        }))
        .expect("config should be valid")
    }

    #[test]
    fn redis_keys_are_stable() {
        assert_eq!(concurrency_key(7), "theseus:submit:concurrency:7");
        assert!(rate_key(7).starts_with("theseus:submit:rate:7:"));
    }

    #[test]
    fn lock_ttl_covers_queue_compile_and_judge() {
        assert_eq!(concurrency_ttl(90, 60, 60), 90 + 60 + 60 + 30);
    }

    #[test]
    fn supported_languages_pass() {
        for language in ["python", "javascript", "cpp", "java"] {
            assert!(validate_language(language).is_ok(), "{language}");
        }
        assert!(validate_language("ruby").is_err());
    }

    #[test]
    fn judgment_set_puts_public_cases_first() {
        let config = config();
        let hidden = vec![crate::models::run::PublicCase {
            args: vec![json!([3, 2, 4]), json!(6)],
            expected: json!([1, 2]),
        }];
        let cases = judge_cases(&config, hidden);
        assert_eq!(cases.len(), 2);
        assert_eq!(cases[0].0[0], json!([2, 7, 11, 15]));
        assert_eq!(cases[1].0[0], json!([3, 2, 4]));
    }

    #[test]
    fn judge_set_rejects_invalid_arguments() {
        let config = config();
        let cases = vec![(vec![json!([[1, 2]]), json!(9)], json!([0, 1]))];
        assert!(validate_judge_set(&config, &cases).is_err());
    }

    #[test]
    fn snapshots_must_contain_run_config() {
        let row = SubmissionRow {
            id: 1,
            user_id: 1,
            problem_id: 1,
            assignment_id: None,
            problem_title: "t".to_owned(),
            language: "python".to_owned(),
            code: "pass".to_owned(),
            status: "pending".to_owned(),
            test_cases_passed: 0,
            total_test_cases: 0,
            runtime: None,
            memory: None,
            error_message: None,
            run_config_snapshot: None,
            judge_cases_snapshot: None,
            cases: json!([]),
            compile_output: None,
            attempt_count: 0,
            submitted_at: Utc::now(),
            started_at: None,
            finished_at: None,
        };
        assert!(parse_snapshots(&row).is_err());
    }
}
