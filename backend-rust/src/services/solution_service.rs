use chrono::{DateTime, Utc};
use sqlx::{FromRow, PgPool};

use crate::{
    common::error::AppError,
    models::solution::{
        CreateSolutionRequest, MAX_SOLUTION_NAME_CHARS, MAX_SOLUTIONS, SolutionListResponse,
        SolutionSubmissionView, SolutionView, UpdateSolutionRequest,
    },
};

const MAX_CODE_BYTES: usize = 256 * 1024;

#[derive(Debug, Clone, FromRow)]
struct SolutionRow {
    id: i32,
    slot: i16,
    name: String,
    language: String,
    code: String,
    created_at: DateTime<Utc>,
    updated_at: DateTime<Utc>,
    last_submission_id: Option<i32>,
    last_submission_status: Option<String>,
    last_test_cases_passed: Option<i32>,
    last_total_test_cases: Option<i32>,
    last_runtime: Option<i32>,
    last_memory: Option<i32>,
    last_submitted_at: Option<DateTime<Utc>>,
}

impl SolutionRow {
    fn into_view(self) -> SolutionView {
        let last_submission = match (
            self.last_submission_id,
            self.last_submission_status,
            self.last_submitted_at,
        ) {
            (Some(id), Some(status), Some(submitted_at)) => Some(SolutionSubmissionView {
                id,
                status,
                test_cases_passed: self.last_test_cases_passed.unwrap_or(0),
                total_test_cases: self.last_total_test_cases.unwrap_or(0),
                runtime: self.last_runtime,
                memory: self.last_memory,
                submitted_at,
            }),
            _ => None,
        };
        SolutionView {
            id: self.id,
            slot: self.slot,
            name: self.name,
            language: self.language,
            code: self.code,
            created_at: self.created_at,
            updated_at: self.updated_at,
            last_submission,
        }
    }
}

fn validate_language(language: &str) -> Result<(), AppError> {
    match language {
        "cpp" | "java" | "python" | "javascript" => Ok(()),
        _ => Err(AppError::BadRequest("不支持的编程语言".to_owned())),
    }
}

fn validate_code(code: &str) -> Result<(), AppError> {
    if code.len() > MAX_CODE_BYTES {
        return Err(AppError::BadRequest("解法内容过长".to_owned()));
    }
    Ok(())
}

fn validate_name(name: &str) -> Result<String, AppError> {
    let name = name.trim();
    let chars = name.chars().count();
    if chars == 0 {
        return Err(AppError::BadRequest("解法名称不能为空".to_owned()));
    }
    if chars > MAX_SOLUTION_NAME_CHARS {
        return Err(AppError::BadRequest(format!(
            "解法名称不能超过 {MAX_SOLUTION_NAME_CHARS} 个字符"
        )));
    }
    if name.chars().any(char::is_control) {
        return Err(AppError::BadRequest("解法名称不能包含控制字符".to_owned()));
    }
    Ok(name.to_owned())
}

async fn ensure_visible_problem(pool: &PgPool, problem_id: i32) -> Result<(), AppError> {
    if problem_id <= 0 {
        return Err(AppError::BadRequest("题目 ID 无效".to_owned()));
    }
    let exists: Option<bool> = sqlx::query_scalar(
        "SELECT TRUE FROM problems WHERE id = $1 AND review_status = 'approved'",
    )
    .bind(problem_id)
    .fetch_optional(pool)
    .await
    .map_err(AppError::Database)?;
    if exists.is_none() {
        return Err(AppError::NotFound("题目不存在".to_owned()));
    }
    Ok(())
}

const VIEW_SELECT: &str = "SELECT s.id, s.slot, s.name, s.language, s.code, \
     s.created_at, s.updated_at, \
     sub.id AS last_submission_id, \
     sub.status AS last_submission_status, \
     sub.test_cases_passed AS last_test_cases_passed, \
     sub.total_test_cases AS last_total_test_cases, \
     sub.runtime AS last_runtime, \
     sub.memory AS last_memory, \
     sub.submitted_at AS last_submitted_at \
     FROM problem_solutions s \
     LEFT JOIN LATERAL ( \
         SELECT sub.id, sub.status, sub.test_cases_passed, sub.total_test_cases, \
                sub.runtime, sub.memory, sub.submitted_at \
         FROM submissions sub \
         WHERE sub.solution_id = s.id \
         ORDER BY (sub.status = 'accepted') DESC, sub.submitted_at DESC, sub.id DESC \
         LIMIT 1 \
     ) sub ON TRUE";

async fn fetch_solutions(
    pool: &PgPool,
    user_id: i32,
    problem_id: i32,
) -> Result<Vec<SolutionRow>, AppError> {
    sqlx::query_as::<_, SolutionRow>(&format!(
        "{VIEW_SELECT} WHERE s.user_id = $1 AND s.problem_id = $2 ORDER BY s.slot"
    ))
    .bind(user_id)
    .bind(problem_id)
    .fetch_all(pool)
    .await
    .map_err(AppError::Database)
}

async fn fetch_solution(
    pool: &PgPool,
    user_id: i32,
    problem_id: i32,
    solution_id: i32,
) -> Result<SolutionRow, AppError> {
    sqlx::query_as::<_, SolutionRow>(&format!(
        "{VIEW_SELECT} WHERE s.user_id = $1 AND s.problem_id = $2 AND s.id = $3"
    ))
    .bind(user_id)
    .bind(problem_id)
    .bind(solution_id)
    .fetch_optional(pool)
    .await
    .map_err(AppError::Database)?
    .ok_or_else(|| AppError::NotFound("解法不存在".to_owned()))
}

async fn try_insert_solution(
    pool: &PgPool,
    user_id: i32,
    problem_id: i32,
    slot: i16,
    name: &str,
    language: &str,
    code: &str,
) -> Result<Option<i32>, AppError> {
    sqlx::query_scalar::<_, i32>(
        "INSERT INTO problem_solutions (user_id, problem_id, slot, name, language, code) \
         VALUES ($1, $2, $3, $4, $5, $6) \
         ON CONFLICT (user_id, problem_id, slot) DO NOTHING \
         RETURNING id",
    )
    .bind(user_id)
    .bind(problem_id)
    .bind(slot)
    .bind(name)
    .bind(language)
    .bind(code)
    .fetch_optional(pool)
    .await
    .map_err(AppError::Database)
}

async fn create_default_solution(
    pool: &PgPool,
    user_id: i32,
    problem_id: i32,
    language: &str,
    code: &str,
    reuse_existing: bool,
) -> Result<SolutionRow, AppError> {
    for slot in 1..=MAX_SOLUTIONS {
        let slot = slot as i16;
        let name = format!("解法 {slot}");
        if let Some(id) =
            try_insert_solution(pool, user_id, problem_id, slot, &name, language, code).await?
        {
            return fetch_solution(pool, user_id, problem_id, id).await;
        }
        // 首次写入时若并发请求已经建好解法，直接复用而不是占用下一个 slot
        if slot == 1
            && reuse_existing
            && let Some(existing) = sqlx::query_scalar::<_, i32>(
                "SELECT id FROM problem_solutions \
                 WHERE user_id = $1 AND problem_id = $2 ORDER BY slot LIMIT 1",
            )
            .bind(user_id)
            .bind(problem_id)
            .fetch_optional(pool)
            .await
            .map_err(AppError::Database)?
        {
            return fetch_solution(pool, user_id, problem_id, existing).await;
        }
    }
    Err(AppError::Conflict("最多保存 5 个解法".to_owned()))
}

pub async fn list_solutions(
    pool: &PgPool,
    user_id: i32,
    problem_id: i32,
    language: &str,
) -> Result<SolutionListResponse, AppError> {
    validate_language(language)?;
    ensure_visible_problem(pool, problem_id).await?;
    let mut rows = fetch_solutions(pool, user_id, problem_id).await?;
    if rows.is_empty() {
        // 首次进入题目时自动创建一个空解法，前端无需区分“未初始化”状态
        match create_default_solution(pool, user_id, problem_id, language, "", true).await {
            Ok(row) => rows.push(row),
            // 并发请求可能已经创建成功，重新读取即可
            Err(AppError::Conflict(_)) => {}
            Err(error) => return Err(error),
        }
        if rows.is_empty() {
            rows = fetch_solutions(pool, user_id, problem_id).await?;
        }
    }
    Ok(SolutionListResponse {
        max: MAX_SOLUTIONS,
        solutions: rows.into_iter().map(SolutionRow::into_view).collect(),
    })
}

pub async fn create_solution(
    pool: &PgPool,
    user_id: i32,
    problem_id: i32,
    request: &CreateSolutionRequest,
) -> Result<SolutionView, AppError> {
    validate_language(&request.language)?;
    let code = request.code.as_deref().unwrap_or("");
    validate_code(code)?;
    ensure_visible_problem(pool, problem_id).await?;
    let requested_name = request.name.as_deref().map(validate_name).transpose()?;
    for slot in 1..=MAX_SOLUTIONS {
        let slot = slot as i16;
        let name = requested_name
            .clone()
            .unwrap_or_else(|| format!("解法 {slot}"));
        if let Some(id) = try_insert_solution(
            pool,
            user_id,
            problem_id,
            slot,
            &name,
            &request.language,
            code,
        )
        .await?
        {
            return fetch_solution(pool, user_id, problem_id, id)
                .await
                .map(SolutionRow::into_view);
        }
    }
    Err(AppError::Conflict("最多保存 5 个解法".to_owned()))
}

pub async fn update_solution(
    pool: &PgPool,
    user_id: i32,
    problem_id: i32,
    solution_id: i32,
    request: &UpdateSolutionRequest,
) -> Result<SolutionView, AppError> {
    if solution_id <= 0 {
        return Err(AppError::BadRequest("解法 ID 无效".to_owned()));
    }
    if let Some(language) = request.language.as_deref() {
        validate_language(language)?;
    }
    if let Some(code) = request.code.as_deref() {
        validate_code(code)?;
    }
    let name = request.name.as_deref().map(validate_name).transpose()?;
    let updated: Option<i32> = sqlx::query_scalar(
        "UPDATE problem_solutions \
         SET name = COALESCE($4, name), \
             language = COALESCE($5, language), \
             code = COALESCE($6, code), \
             updated_at = CURRENT_TIMESTAMP \
         WHERE id = $1 AND user_id = $2 AND problem_id = $3 \
         RETURNING id",
    )
    .bind(solution_id)
    .bind(user_id)
    .bind(problem_id)
    .bind(name)
    .bind(request.language.as_deref())
    .bind(request.code.as_deref())
    .fetch_optional(pool)
    .await
    .map_err(AppError::Database)?;
    if updated.is_none() {
        return Err(AppError::NotFound("解法不存在".to_owned()));
    }
    fetch_solution(pool, user_id, problem_id, solution_id)
        .await
        .map(SolutionRow::into_view)
}

pub async fn delete_solution(
    pool: &PgPool,
    user_id: i32,
    problem_id: i32,
    solution_id: i32,
) -> Result<SolutionListResponse, AppError> {
    if solution_id <= 0 {
        return Err(AppError::BadRequest("解法 ID 无效".to_owned()));
    }
    let mut transaction = pool.begin().await.map_err(AppError::Database)?;
    let rows: Vec<(i32, i16)> = sqlx::query_as(
        "SELECT id, slot FROM problem_solutions \
         WHERE user_id = $1 AND problem_id = $2 ORDER BY slot FOR UPDATE",
    )
    .bind(user_id)
    .bind(problem_id)
    .fetch_all(&mut *transaction)
    .await
    .map_err(AppError::Database)?;
    if !rows.iter().any(|(id, _)| *id == solution_id) {
        return Err(AppError::NotFound("解法不存在".to_owned()));
    }
    if rows.len() <= 1 {
        return Err(AppError::Conflict("至少保留一个解法".to_owned()));
    }
    sqlx::query("DELETE FROM problem_solutions WHERE id = $1")
        .bind(solution_id)
        .execute(&mut *transaction)
        .await
        .map_err(AppError::Database)?;
    transaction.commit().await.map_err(AppError::Database)?;
    let rows = fetch_solutions(pool, user_id, problem_id).await?;
    Ok(SolutionListResponse {
        max: MAX_SOLUTIONS,
        solutions: rows.into_iter().map(SolutionRow::into_view).collect(),
    })
}

/// 兼容旧的按语言草稿接口：返回该语言最近一次有内容的解法
pub async fn get_draft_solution(
    pool: &PgPool,
    user_id: i32,
    problem_id: i32,
    language: &str,
) -> Result<Option<SolutionView>, AppError> {
    validate_language(language)?;
    ensure_visible_problem(pool, problem_id).await?;
    let row: Option<SolutionRow> = sqlx::query_as(&format!(
        "{VIEW_SELECT} \
         WHERE s.user_id = $1 AND s.problem_id = $2 AND s.language = $3 AND s.code <> '' \
         ORDER BY s.updated_at DESC, s.slot DESC LIMIT 1"
    ))
    .bind(user_id)
    .bind(problem_id)
    .bind(language)
    .fetch_optional(pool)
    .await
    .map_err(AppError::Database)?;
    Ok(row.map(SolutionRow::into_view))
}

/// 兼容旧的按语言草稿接口：写回该语言最近使用的解法，没有则新建
pub async fn save_legacy_draft(
    pool: &PgPool,
    user_id: i32,
    problem_id: i32,
    language: &str,
    code: &str,
) -> Result<Option<SolutionView>, AppError> {
    validate_language(language)?;
    validate_code(code)?;
    ensure_visible_problem(pool, problem_id).await?;
    let code = if code.trim().is_empty() { "" } else { code };
    let existing: Option<i32> = sqlx::query_scalar(
        "SELECT id FROM problem_solutions \
         WHERE user_id = $1 AND problem_id = $2 AND language = $3 \
         ORDER BY updated_at DESC, slot DESC LIMIT 1",
    )
    .bind(user_id)
    .bind(problem_id)
    .bind(language)
    .fetch_optional(pool)
    .await
    .map_err(AppError::Database)?;
    let id = match existing {
        Some(id) => {
            sqlx::query(
                "UPDATE problem_solutions SET code = $2, updated_at = CURRENT_TIMESTAMP \
                 WHERE id = $1",
            )
            .bind(id)
            .bind(code)
            .execute(pool)
            .await
            .map_err(AppError::Database)?;
            id
        }
        None if code.is_empty() => return Ok(None),
        None => {
            create_default_solution(pool, user_id, problem_id, language, code, false)
                .await?
                .id
        }
    };
    if code.is_empty() {
        return Ok(None);
    }
    fetch_solution(pool, user_id, problem_id, id)
        .await
        .map(SolutionRow::into_view)
        .map(Some)
}
