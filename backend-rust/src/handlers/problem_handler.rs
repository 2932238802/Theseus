use axum::{
    Json,
    extract::{Path, Query, State},
    http::HeaderMap,
    response::IntoResponse,
};
use serde_json::Value;
use sqlx::{FromRow, PgPool, Postgres, QueryBuilder};

use crate::{
    AppState,
    common::{
        error::AppError,
        response::{created, ok},
    },
    middleware::auth::{optional_authenticate, require_admin},
    models::problem::{
        PendingProblemResponse, ProblemListQuery, ProblemListResponse, ProblemMutationResponse,
        ProblemRequest, ProblemResponse, ProblemReviewRequest, ProblemRow,
    },
};

const DEFAULT_PAGE: u32 = 1;
const DEFAULT_SIZE: u32 = 20;
const MAX_PAGE_SIZE: u32 = 100;

#[derive(Debug, FromRow)]
struct ProblemWithStatusRow {
    id: i32,
    title: String,
    description: String,
    difficulty: String,
    time_limit: i32,
    memory_limit: i32,
    tags: Vec<String>,
    examples: Option<Value>,
    test_cases: Option<Value>,
    code_template: Option<Value>,
    acceptance_rate: f64,
    submit_count: i32,
    accept_count: i32,
    status: Option<String>,
}

impl ProblemWithStatusRow {
    fn response(self) -> ProblemResponse {
        ProblemRow {
            id: self.id,
            title: self.title,
            description: self.description,
            difficulty: self.difficulty,
            time_limit: self.time_limit,
            memory_limit: self.memory_limit,
            tags: self.tags,
            examples: self.examples,
            test_cases: self.test_cases,
            code_template: self.code_template,
            acceptance_rate: self.acceptance_rate,
            submit_count: self.submit_count,
            accept_count: self.accept_count,
        }
        .response(self.status)
    }
}

pub async fn list(
    State(state): State<AppState>,
    headers: HeaderMap,
    Query(query): Query<ProblemListQuery>,
) -> Result<impl IntoResponse, AppError> {
    let page = query.page.unwrap_or(DEFAULT_PAGE).max(1);
    let size = query.size.unwrap_or(DEFAULT_SIZE).clamp(1, MAX_PAGE_SIZE);
    let user_id = optional_authenticate(&headers, &state.config).map(|user| user.id);
    validate_status_filter(query.status.as_deref(), user_id)?;
    let (total, problems) = fetch_problem_page(&state.pool, &query, page, size, user_id).await?;
    Ok(ok(ProblemListResponse {
        total,
        page,
        size,
        problems: problems
            .into_iter()
            .map(ProblemWithStatusRow::response)
            .collect(),
    }))
}

pub async fn get(
    State(state): State<AppState>,
    headers: HeaderMap,
    Path(id): Path<i32>,
) -> Result<impl IntoResponse, AppError> {
    if id <= 0 {
        return Err(AppError::BadRequest("题目 ID 无效".to_owned()));
    }
    let user_id = optional_authenticate(&headers, &state.config).map(|user| user.id);
    let row = sqlx::query_as::<_, ProblemWithStatusRow>(
        "SELECT p.id, p.title, p.description, p.difficulty, p.time_limit, p.memory_limit, p.tags, p.examples, p.test_cases, p.code_template, p.acceptance_rate, p.submit_count, p.accept_count, ups.status FROM problems p LEFT JOIN user_problem_status ups ON ups.problem_id = p.id AND ups.user_id = $2 WHERE p.id = $1 AND p.review_status = 'approved'",
    )
    .bind(id)
    .bind(user_id)
    .fetch_optional(&state.pool)
    .await
    .map_err(AppError::Database)?
    .ok_or_else(|| AppError::NotFound("题目不存在".to_owned()))?;
    Ok(ok(row.response()))
}

pub async fn create(
    State(state): State<AppState>,
    headers: HeaderMap,
    Json(request): Json<ProblemRequest>,
) -> Result<impl IntoResponse, AppError> {
    let admin = require_admin(&headers, &state.config)?;
    validate_problem(&request)?;
    let id = insert_problem(&state.pool, &request, Some(admin.id), "approved").await?;
    Ok(created(ProblemMutationResponse {
        id,
        message: "题目创建成功".to_owned(),
    }))
}

pub async fn submit_custom(
    State(state): State<AppState>,
    headers: HeaderMap,
    Json(request): Json<ProblemRequest>,
) -> Result<impl IntoResponse, AppError> {
    let user = crate::middleware::auth::authenticate(&headers, &state.config)?;
    validate_problem(&request)?;
    let id = insert_problem(&state.pool, &request, Some(user.id), "pending").await?;
    Ok(created(ProblemMutationResponse {
        id,
        message: "题目已提交，等待管理员审核".to_owned(),
    }))
}

pub async fn pending(
    State(state): State<AppState>,
    headers: HeaderMap,
) -> Result<impl IntoResponse, AppError> {
    require_admin(&headers, &state.config)?;
    let rows = sqlx::query_as::<_, PendingProblemResponse>(
        "SELECT id, title, difficulty, created_by, review_status, created_at FROM problems WHERE review_status = 'pending' ORDER BY created_at ASC LIMIT 100",
    )
    .fetch_all(&state.pool)
    .await
    .map_err(AppError::Database)?;
    Ok(ok(rows))
}

pub async fn review(
    State(state): State<AppState>,
    headers: HeaderMap,
    Path(id): Path<i32>,
    Json(request): Json<ProblemReviewRequest>,
) -> Result<impl IntoResponse, AppError> {
    require_admin(&headers, &state.config)?;
    if id <= 0 || !matches!(request.status.as_str(), "approved" | "rejected") {
        return Err(AppError::BadRequest("题目 ID 或审核状态无效".to_owned()));
    }
    let result = sqlx::query(
        "UPDATE problems SET review_status = $1, updated_at = CURRENT_TIMESTAMP WHERE id = $2 AND review_status = 'pending'",
    )
    .bind(&request.status)
    .bind(id)
    .execute(&state.pool)
    .await
    .map_err(AppError::Database)?;
    if result.rows_affected() == 0 {
        return Err(AppError::NotFound("待审核题目不存在".to_owned()));
    }
    Ok(ok(ProblemMutationResponse {
        id,
        message: if request.status == "approved" {
            "题目审核通过".to_owned()
        } else {
            "题目已拒绝".to_owned()
        },
    }))
}

pub async fn update(
    State(state): State<AppState>,
    headers: HeaderMap,
    Path(id): Path<i32>,
    Json(request): Json<ProblemRequest>,
) -> Result<impl IntoResponse, AppError> {
    require_admin(&headers, &state.config)?;
    if id <= 0 {
        return Err(AppError::BadRequest("题目 ID 无效".to_owned()));
    }
    validate_problem(&request)?;
    let result = sqlx::query(
        "UPDATE problems SET title = $1, description = $2, difficulty = $3, time_limit = $4, memory_limit = $5, tags = $6, examples = $7, test_cases = $8, code_template = $9, updated_at = CURRENT_TIMESTAMP WHERE id = $10",
    )
    .bind(request.title.trim())
    .bind(request.description.trim())
    .bind(&request.difficulty)
    .bind(request.time_limit.unwrap_or(1000))
    .bind(request.memory_limit.unwrap_or(256))
    .bind(request.tags.unwrap_or_default())
    .bind(request.examples.unwrap_or_else(|| Value::Array(Vec::new())))
    .bind(request.test_cases.unwrap_or_else(|| Value::Array(Vec::new())))
    .bind(request.code_template.unwrap_or_else(|| Value::Object(Default::default())))
    .bind(id)
    .execute(&state.pool)
    .await
    .map_err(AppError::Database)?;
    if result.rows_affected() == 0 {
        return Err(AppError::NotFound("题目不存在".to_owned()));
    }
    Ok(ok(ProblemMutationResponse {
        id,
        message: "题目更新成功".to_owned(),
    }))
}

pub async fn delete(
    State(state): State<AppState>,
    headers: HeaderMap,
    Path(id): Path<i32>,
) -> Result<impl IntoResponse, AppError> {
    require_admin(&headers, &state.config)?;
    if id <= 0 {
        return Err(AppError::BadRequest("题目 ID 无效".to_owned()));
    }
    let result = sqlx::query("DELETE FROM problems WHERE id = $1")
        .bind(id)
        .execute(&state.pool)
        .await
        .map_err(AppError::Database)?;
    if result.rows_affected() == 0 {
        return Err(AppError::NotFound("题目不存在".to_owned()));
    }
    Ok(ok(ProblemMutationResponse {
        id,
        message: "题目删除成功".to_owned(),
    }))
}

async fn fetch_problem_page(
    pool: &PgPool,
    query: &ProblemListQuery,
    page: u32,
    size: u32,
    user_id: Option<i32>,
) -> Result<(i64, Vec<ProblemWithStatusRow>), AppError> {
    let mut count_builder = QueryBuilder::<Postgres>::new(
        "SELECT COUNT(*) FROM problems p WHERE p.review_status = 'approved'",
    );
    append_filters(&mut count_builder, query, user_id);
    let total = count_builder
        .build_query_scalar::<i64>()
        .fetch_one(pool)
        .await
        .map_err(AppError::Database)?;

    let offset = (page.saturating_sub(1) as i64) * i64::from(size);
    let mut builder = QueryBuilder::<Postgres>::new(
        "SELECT p.id, p.title, p.description, p.difficulty, p.time_limit, p.memory_limit, p.tags, p.examples, p.test_cases, p.code_template, p.acceptance_rate, p.submit_count, p.accept_count, ups.status FROM problems p LEFT JOIN user_problem_status ups ON ups.problem_id = p.id AND ups.user_id = ",
    );
    builder.push_bind(user_id);
    builder.push(" WHERE p.review_status = 'approved'");
    append_filters(&mut builder, query, user_id);
    builder.push(" ORDER BY p.id ASC LIMIT ");
    builder.push_bind(i64::from(size));
    builder.push(" OFFSET ");
    builder.push_bind(offset);
    let rows = builder
        .build_query_as::<ProblemWithStatusRow>()
        .fetch_all(pool)
        .await
        .map_err(AppError::Database)?;
    Ok((total, rows))
}

fn append_filters<'a>(
    builder: &mut QueryBuilder<'a, Postgres>,
    query: &ProblemListQuery,
    user_id: Option<i32>,
) {
    if let Some(difficulty) = query
        .difficulty
        .as_deref()
        .filter(|value| !value.is_empty())
    {
        builder
            .push(" AND p.difficulty = ")
            .push_bind(difficulty.to_owned());
    }
    if let Some(tag) = query.tag.as_deref().filter(|value| !value.is_empty()) {
        builder
            .push(" AND ")
            .push_bind(tag.to_owned())
            .push(" = ANY(p.tags)");
    }
    if let Some(search) = query
        .search
        .as_deref()
        .map(str::trim)
        .filter(|value| !value.is_empty())
    {
        builder
            .push(" AND (p.title ILIKE ")
            .push_bind(format!("%{search}%"));
        builder
            .push(" OR p.description ILIKE ")
            .push_bind(format!("%{search}%"));
        builder.push(")");
    }
    if let (Some(user_id), Some(status)) = (
        user_id,
        query.status.as_deref().filter(|value| !value.is_empty()),
    ) {
        if status == "not_started" {
            builder
                .push(" AND NOT EXISTS (SELECT 1 FROM user_problem_status filter_status WHERE filter_status.problem_id = p.id AND filter_status.user_id = ")
                .push_bind(user_id)
                .push(")");
        } else {
            builder
                .push(" AND EXISTS (SELECT 1 FROM user_problem_status filter_status WHERE filter_status.problem_id = p.id AND filter_status.user_id = ")
                .push_bind(user_id)
                .push(" AND filter_status.status = ")
                .push_bind(status.to_owned())
                .push(")");
        }
    }
}

async fn insert_problem(
    pool: &PgPool,
    request: &ProblemRequest,
    created_by: Option<i32>,
    review_status: &str,
) -> Result<i32, AppError> {
    sqlx::query_scalar(
        "INSERT INTO problems (title, description, difficulty, time_limit, memory_limit, tags, examples, test_cases, code_template, created_by, review_status) VALUES ($1, $2, $3, $4, $5, $6, $7, $8, $9, $10, $11) RETURNING id",
    )
    .bind(request.title.trim())
    .bind(request.description.trim())
    .bind(&request.difficulty)
    .bind(request.time_limit.unwrap_or(1000))
    .bind(request.memory_limit.unwrap_or(256))
    .bind(request.tags.clone().unwrap_or_default())
    .bind(request.examples.clone().unwrap_or_else(|| Value::Array(Vec::new())))
    .bind(request.test_cases.clone().unwrap_or_else(|| Value::Array(Vec::new())))
    .bind(request.code_template.clone().unwrap_or_else(|| Value::Object(Default::default())))
    .bind(created_by)
    .bind(review_status)
    .fetch_one(pool)
    .await
    .map_err(AppError::Database)
}

fn validate_status_filter(status: Option<&str>, user_id: Option<i32>) -> Result<(), AppError> {
    let Some(status) = status.filter(|value| !value.is_empty()) else {
        return Ok(());
    };
    if user_id.is_none() {
        return Err(AppError::Unauthorized);
    }
    if !matches!(status, "not_started" | "attempted" | "accepted") {
        return Err(AppError::BadRequest("题目状态无效".to_owned()));
    }
    Ok(())
}

fn validate_problem(request: &ProblemRequest) -> Result<(), AppError> {
    if request.title.trim().is_empty() || request.title.len() > 200 {
        return Err(AppError::BadRequest(
            "题目标题不能为空且不能超过 200 个字符".to_owned(),
        ));
    }
    if request.description.trim().is_empty() {
        return Err(AppError::BadRequest("题目描述不能为空".to_owned()));
    }
    if !matches!(request.difficulty.as_str(), "easy" | "medium" | "hard") {
        return Err(AppError::BadRequest(
            "难度必须是 easy、medium 或 hard".to_owned(),
        ));
    }
    if request
        .examples
        .as_ref()
        .is_some_and(|value| !value.is_array())
        || request
            .test_cases
            .as_ref()
            .is_some_and(|value| !value.is_array())
    {
        return Err(AppError::BadRequest(
            "examples 和 test_cases 必须是 JSON 数组".to_owned(),
        ));
    }
    if request.time_limit.unwrap_or(1000) <= 0 || request.memory_limit.unwrap_or(256) <= 0 {
        return Err(AppError::BadRequest("时间和内存限制必须大于 0".to_owned()));
    }
    Ok(())
}

#[cfg(test)]
mod tests {
    use super::{append_filters, validate_problem};
    use crate::models::problem::ProblemRequest;
    use sqlx::{Postgres, QueryBuilder};

    #[test]
    fn validates_problem_fields() {
        let request = ProblemRequest {
            title: String::new(),
            description: String::new(),
            difficulty: "unknown".to_owned(),
            time_limit: None,
            memory_limit: None,
            tags: None,
            examples: None,
            test_cases: None,
            code_template: None,
        };
        assert!(validate_problem(&request).is_err());
    }

    #[test]
    fn accepts_empty_filter_query() {
        let query = crate::models::problem::ProblemListQuery::default();
        let mut builder = QueryBuilder::<Postgres>::new("SELECT * FROM problems p WHERE 1 = 1");
        append_filters(&mut builder, &query, Some(42));
        assert!(builder.sql().contains("WHERE 1 = 1"));
    }
}
