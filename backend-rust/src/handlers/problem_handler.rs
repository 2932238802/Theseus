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
    judge::run_config::{
        cpp_template, java_template, javascript_template, python_template, validate_judge_cases,
        validate_run_config,
    },
    middleware::auth::{optional_authenticate, require_admin, require_teacher},
    models::problem::{
        AdminProblemListItem, AdminProblemListQuery, AdminProblemListResponse,
        AdminProblemResponse, MyProblemListItem, MyProblemListQuery, MyProblemListResponse,
        PendingProblemResponse, ProblemListQuery, ProblemListResponse, ProblemMutationResponse,
        ProblemRequest, ProblemResponse, ProblemReviewRequest, ProblemRow, StatsResponse,
    },
    services::notification_service,
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
    run_config: Option<Value>,
    acceptance_rate: f64,
    submit_count: i32,
    accept_count: i32,
    status: Option<String>,
}

#[derive(Clone, Debug, FromRow)]
struct ReviewProblemRow {
    title: String,
    created_by: Option<i32>,
    review_status: String,
    run_config: Option<Value>,
    judge_cases: Option<Value>,
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
            run_config: self.run_config,
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
    let user_id = optional_authenticate(&state.pool, &headers, &state.config)
        .await
        .map(|user| user.id);
    validate_status_filter(query.status.as_deref(), user_id)?;
    let (sort_expression, sort_direction) =
        parse_sort(query.sort.as_deref(), query.order.as_deref())?;
    let (total, problems) = fetch_problem_page(
        &state.pool,
        &query,
        page,
        size,
        user_id,
        sort_expression,
        sort_direction,
    )
    .await?;
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

pub async fn tags(State(state): State<AppState>) -> Result<impl IntoResponse, AppError> {
    let tags = sqlx::query_scalar::<_, String>(
        "SELECT DISTINCT unnest(tags) AS tag FROM problems WHERE review_status = 'approved' ORDER BY tag ASC",
    )
    .fetch_all(&state.pool)
    .await
    .map_err(AppError::Database)?;
    Ok(ok(tags))
}

pub async fn stats(State(state): State<AppState>) -> Result<impl IntoResponse, AppError> {
    let stats = sqlx::query_as::<_, StatsResponse>(
        "SELECT (SELECT COUNT(*) FROM problems WHERE review_status = 'approved') AS total_problems, (SELECT COUNT(*) FROM submissions) AS total_submissions, (SELECT COUNT(*) FROM submissions WHERE status = 'accepted') AS accepted_submissions",
    )
    .fetch_one(&state.pool)
    .await
    .map_err(AppError::Database)?;
    Ok(ok(stats))
}

pub async fn get(
    State(state): State<AppState>,
    headers: HeaderMap,
    Path(id): Path<i32>,
) -> Result<impl IntoResponse, AppError> {
    if id <= 0 {
        return Err(AppError::BadRequest("题目 ID 无效".to_owned()));
    }
    let user_id = optional_authenticate(&state.pool, &headers, &state.config)
        .await
        .map(|user| user.id);
    let row = sqlx::query_as::<_, ProblemWithStatusRow>(
        "SELECT p.id, p.title, p.description, p.difficulty, p.time_limit, p.memory_limit, p.tags, p.examples, p.test_cases, p.code_template, p.run_config, p.acceptance_rate, p.submit_count, p.accept_count, ups.status FROM problems p LEFT JOIN user_problem_status ups ON ups.problem_id = p.id AND ups.user_id = $2 WHERE p.id = $1 AND p.review_status = 'approved'",
    )
    .bind(id)
    .bind(user_id)
    .fetch_optional(&state.pool)
    .await
    .map_err(AppError::Database)?
    .ok_or_else(|| AppError::NotFound("题目不存在".to_owned()))?;
    Ok(ok(row.response()))
}

pub async fn mine(
    State(state): State<AppState>,
    headers: HeaderMap,
    Query(query): Query<MyProblemListQuery>,
) -> Result<impl IntoResponse, AppError> {
    let user = require_teacher(&state.pool, &headers, &state.config).await?;
    let page = query.page.unwrap_or(DEFAULT_PAGE).max(1);
    let size = query.size.unwrap_or(DEFAULT_SIZE).clamp(1, MAX_PAGE_SIZE);
    let status = validate_review_status(query.status.as_deref())?;
    let offset = i64::from(page.saturating_sub(1)) * i64::from(size);

    let mut count_builder =
        QueryBuilder::<Postgres>::new("SELECT COUNT(*) FROM problems p WHERE p.created_by = ");
    count_builder.push_bind(user.id);
    if let Some(status) = status {
        count_builder
            .push(" AND p.review_status = ")
            .push_bind(status.to_owned());
    }
    let total = count_builder
        .build_query_scalar::<i64>()
        .fetch_one(&state.pool)
        .await
        .map_err(AppError::Database)?;

    let mut builder = QueryBuilder::<Postgres>::new(
        "SELECT p.id, p.title, p.difficulty, p.review_status, p.review_note, p.reviewed_at, p.created_at, p.updated_at FROM problems p WHERE p.created_by = ",
    );
    builder.push_bind(user.id);
    if let Some(status) = status {
        builder
            .push(" AND p.review_status = ")
            .push_bind(status.to_owned());
    }
    builder
        .push(" ORDER BY p.created_at DESC, p.id DESC LIMIT ")
        .push_bind(i64::from(size))
        .push(" OFFSET ")
        .push_bind(offset);
    let problems = builder
        .build_query_as::<MyProblemListItem>()
        .fetch_all(&state.pool)
        .await
        .map_err(AppError::Database)?;

    Ok(ok(MyProblemListResponse {
        total,
        page,
        size,
        problems,
    }))
}

pub async fn admin_list(
    State(state): State<AppState>,
    headers: HeaderMap,
    Query(query): Query<AdminProblemListQuery>,
) -> Result<impl IntoResponse, AppError> {
    require_admin(&state.pool, &headers, &state.config).await?;
    let page = query.page.unwrap_or(DEFAULT_PAGE).max(1);
    let size = query.size.unwrap_or(DEFAULT_SIZE).clamp(1, MAX_PAGE_SIZE);
    let status = validate_review_status(query.status.as_deref())?;
    let search = query
        .q
        .as_deref()
        .map(str::trim)
        .filter(|value| !value.is_empty())
        .map(|value| value.chars().take(100).collect::<String>());
    let offset = i64::from(page.saturating_sub(1)) * i64::from(size);

    let mut count_builder =
        QueryBuilder::<Postgres>::new("SELECT COUNT(*) FROM problems p WHERE 1 = 1");
    append_review_filters(&mut count_builder, status, search.as_deref());
    let total = count_builder
        .build_query_scalar::<i64>()
        .fetch_one(&state.pool)
        .await
        .map_err(AppError::Database)?;

    let mut builder = QueryBuilder::<Postgres>::new(
        "SELECT p.id, p.title, p.difficulty, p.created_by, u.username AS created_by_username, p.review_status, p.review_note, p.reviewed_at, p.created_at, p.updated_at FROM problems p LEFT JOIN users u ON u.id = p.created_by WHERE 1 = 1",
    );
    append_review_filters(&mut builder, status, search.as_deref());
    builder
        .push(" ORDER BY p.created_at DESC, p.id DESC LIMIT ")
        .push_bind(i64::from(size))
        .push(" OFFSET ")
        .push_bind(offset);
    let problems = builder
        .build_query_as::<AdminProblemListItem>()
        .fetch_all(&state.pool)
        .await
        .map_err(AppError::Database)?;

    Ok(ok(AdminProblemListResponse {
        total,
        page,
        size,
        problems,
    }))
}

pub async fn create(
    State(state): State<AppState>,
    headers: HeaderMap,
    Json(request): Json<ProblemRequest>,
) -> Result<impl IntoResponse, AppError> {
    let admin = require_admin(&state.pool, &headers, &state.config).await?;
    validate_problem(&request)?;
    let (run_config, code_template, judge_cases) = prepare_problem_judging(&request)?;
    let id = insert_problem(
        &state.pool,
        &request,
        run_config,
        code_template,
        judge_cases,
        Some(admin.id),
        "approved",
    )
    .await?;
    sqlx::query(
        "UPDATE problems SET reviewed_by = $1, reviewed_at = CURRENT_TIMESTAMP WHERE id = $2",
    )
    .bind(admin.id)
    .bind(id)
    .execute(&state.pool)
    .await
    .map_err(AppError::Database)?;
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
    let user = require_teacher(&state.pool, &headers, &state.config).await?;
    validate_problem(&request)?;
    let (run_config, code_template, judge_cases) = prepare_problem_judging(&request)?;
    let id = insert_problem(
        &state.pool,
        &request,
        run_config,
        code_template,
        judge_cases,
        Some(user.id),
        "pending",
    )
    .await?;
    Ok(created(ProblemMutationResponse {
        id,
        message: "题目已提交，等待管理员审核".to_owned(),
    }))
}

pub async fn mine_get(
    State(state): State<AppState>,
    headers: HeaderMap,
    Path(id): Path<i32>,
) -> Result<impl IntoResponse, AppError> {
    let user = require_teacher(&state.pool, &headers, &state.config).await?;
    if id <= 0 {
        return Err(AppError::BadRequest("题目 ID 无效".to_owned()));
    }
    let row = fetch_problem_detail(&state.pool, id, Some(user.id)).await?;
    Ok(ok(row))
}

pub async fn update_mine(
    State(state): State<AppState>,
    headers: HeaderMap,
    Path(id): Path<i32>,
    Json(request): Json<ProblemRequest>,
) -> Result<impl IntoResponse, AppError> {
    let user = require_teacher(&state.pool, &headers, &state.config).await?;
    if id <= 0 {
        return Err(AppError::BadRequest("题目 ID 无效".to_owned()));
    }
    validate_problem(&request)?;
    let current_status = sqlx::query_scalar::<_, String>(
        "SELECT review_status FROM problems WHERE id = $1 AND created_by = $2",
    )
    .bind(id)
    .bind(user.id)
    .fetch_optional(&state.pool)
    .await
    .map_err(AppError::Database)?
    .ok_or_else(|| AppError::NotFound("题目不存在".to_owned()))?;
    if current_status != "rejected" {
        return Err(AppError::ConflictWith(
            "只有已退回的题目可以修改并重新提交".to_owned(),
        ));
    }
    let (run_config, code_template, judge_cases) = prepare_problem_judging(&request)?;
    let judge_cases_bind = if run_config.is_some() {
        judge_cases
    } else {
        Some(Value::Null)
    };
    let result = sqlx::query(
        "UPDATE problems SET title = $1, description = $2, difficulty = $3, time_limit = $4, memory_limit = $5, tags = $6, examples = $7, test_cases = $8, code_template = $9, run_config = $10, judge_cases = $11, review_status = 'pending', review_note = NULL, reviewed_by = NULL, reviewed_at = NULL, updated_at = CURRENT_TIMESTAMP WHERE id = $12 AND created_by = $13 AND review_status = 'rejected'",
    )
    .bind(request.title.trim())
    .bind(request.description.trim())
    .bind(&request.difficulty)
    .bind(request.time_limit.unwrap_or(1000))
    .bind(request.memory_limit.unwrap_or(256))
    .bind(request.tags.clone().unwrap_or_default())
    .bind(
        request
            .examples
            .clone()
            .unwrap_or_else(|| Value::Array(Vec::new())),
    )
    .bind(
        request
            .test_cases
            .clone()
            .unwrap_or_else(|| Value::Array(Vec::new())),
    )
    .bind(code_template.unwrap_or_else(|| Value::Object(Default::default())))
    .bind(run_config)
    .bind(judge_cases_bind)
    .bind(id)
    .bind(user.id)
    .execute(&state.pool)
    .await
    .map_err(AppError::Database)?;
    if result.rows_affected() == 0 {
        return Err(AppError::ConflictWith(
            "只有已退回的题目可以修改并重新提交".to_owned(),
        ));
    }
    Ok(ok(ProblemMutationResponse {
        id,
        message: "题目已重新提交，等待管理员审核".to_owned(),
    }))
}

pub async fn admin_get(
    State(state): State<AppState>,
    headers: HeaderMap,
    Path(id): Path<i32>,
) -> Result<impl IntoResponse, AppError> {
    require_admin(&state.pool, &headers, &state.config).await?;
    if id <= 0 {
        return Err(AppError::BadRequest("题目 ID 无效".to_owned()));
    }
    let row = fetch_problem_detail(&state.pool, id, None).await?;
    Ok(ok(row))
}

pub async fn pending(
    State(state): State<AppState>,
    headers: HeaderMap,
) -> Result<impl IntoResponse, AppError> {
    require_admin(&state.pool, &headers, &state.config).await?;
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
    let admin = require_admin(&state.pool, &headers, &state.config).await?;
    if id <= 0 {
        return Err(AppError::BadRequest("题目 ID 无效".to_owned()));
    }
    let status = request.status.trim();
    if !matches!(status, "approved" | "rejected") {
        return Err(AppError::BadRequest("审核状态无效".to_owned()));
    }
    let note = request
        .note
        .as_deref()
        .map(str::trim)
        .filter(|value| !value.is_empty());
    if note.is_some_and(|value| value.chars().count() > 1000) {
        return Err(AppError::BadRequest(
            "审核意见不能超过 1000 个字符".to_owned(),
        ));
    }
    if status == "rejected" && note.is_none() {
        return Err(AppError::BadRequest(
            "拒绝题目时必须填写退回原因".to_owned(),
        ));
    }

    let mut transaction = state.pool.begin().await.map_err(AppError::Database)?;
    let problem = sqlx::query_as::<_, ReviewProblemRow>(
        "SELECT title, created_by, review_status, run_config, judge_cases FROM problems WHERE id = $1 FOR UPDATE",
    )
    .bind(id)
    .fetch_optional(&mut *transaction)
    .await
    .map_err(AppError::Database)?
    .ok_or_else(|| AppError::NotFound("待审核题目不存在".to_owned()))?;
    if problem.review_status != "pending" {
        return Err(AppError::ConflictWith("题目已审核".to_owned()));
    }
    if status == "approved" {
        ensure_problem_reviewable(&problem)?;
    }

    let result = sqlx::query(
        "UPDATE problems SET review_status = $1, review_note = $2, reviewed_by = $3, reviewed_at = CURRENT_TIMESTAMP, updated_at = CURRENT_TIMESTAMP WHERE id = $4 AND review_status = 'pending'",
    )
    .bind(status)
    .bind(note)
    .bind(admin.id)
    .bind(id)
    .execute(&mut *transaction)
    .await
    .map_err(AppError::Database)?;
    if result.rows_affected() == 0 {
        return Err(AppError::ConflictWith("题目已审核".to_owned()));
    }

    if let Some(creator_id) = problem.created_by {
        let approved = status == "approved";
        let title = if approved {
            format!("题目审核通过：{}", problem.title)
        } else {
            format!("题目未通过：{}", problem.title)
        };
        let body = match note {
            Some(note) => note.to_owned(),
            None if approved => "题目已通过审核，可以用于练习和作业".to_owned(),
            None => String::new(),
        };
        notification_service::create(
            &mut transaction,
            creator_id,
            "problem_review",
            Some(admin.id),
            &title,
            (!body.is_empty()).then_some(body.as_str()),
            Some("/teacher/problems"),
            Some("problem"),
            Some(i64::from(id)),
        )
        .await?;
    }

    transaction.commit().await.map_err(AppError::Database)?;
    Ok(ok(ProblemMutationResponse {
        id,
        message: if status == "approved" {
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
    require_admin(&state.pool, &headers, &state.config).await?;
    if id <= 0 {
        return Err(AppError::BadRequest("题目 ID 无效".to_owned()));
    }
    validate_problem(&request)?;
    let (run_config, code_template, judge_cases) = prepare_problem_judging(&request)?;
    // Removing run_config also removes hidden cases: they cannot be judged
    // without a function signature. When run_config is kept and judge_cases is
    // omitted, COALESCE below preserves the stored cases.
    let judge_cases_bind = if run_config.is_some() {
        judge_cases
    } else {
        Some(Value::Null)
    };
    let result = sqlx::query(
        "UPDATE problems SET title = $1, description = $2, difficulty = $3, time_limit = $4, memory_limit = $5, tags = $6, examples = $7, test_cases = $8, code_template = $9, run_config = $10, judge_cases = COALESCE($11, judge_cases), updated_at = CURRENT_TIMESTAMP WHERE id = $12",
    )
    .bind(request.title.trim())
    .bind(request.description.trim())
    .bind(&request.difficulty)
    .bind(request.time_limit.unwrap_or(1000))
    .bind(request.memory_limit.unwrap_or(256))
    .bind(request.tags.unwrap_or_default())
    .bind(request.examples.unwrap_or_else(|| Value::Array(Vec::new())))
    .bind(request.test_cases.unwrap_or_else(|| Value::Array(Vec::new())))
    .bind(code_template.unwrap_or_else(|| Value::Object(Default::default())))
    .bind(run_config)
    .bind(judge_cases_bind)
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
    require_admin(&state.pool, &headers, &state.config).await?;
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

async fn fetch_problem_detail(
    pool: &PgPool,
    id: i32,
    owner_id: Option<i32>,
) -> Result<AdminProblemResponse, AppError> {
    let sql = if owner_id.is_some() {
        "SELECT p.id, p.title, p.description, p.difficulty, p.time_limit, p.memory_limit, p.tags, p.examples, p.test_cases, p.code_template, p.run_config, p.judge_cases, p.acceptance_rate, p.submit_count, p.accept_count, p.review_status, p.review_note, p.created_by, u.username AS created_by_username, p.reviewed_by, p.reviewed_at, p.created_at, p.updated_at FROM problems p LEFT JOIN users u ON u.id = p.created_by WHERE p.id = $1 AND p.created_by = $2"
    } else {
        "SELECT p.id, p.title, p.description, p.difficulty, p.time_limit, p.memory_limit, p.tags, p.examples, p.test_cases, p.code_template, p.run_config, p.judge_cases, p.acceptance_rate, p.submit_count, p.accept_count, p.review_status, p.review_note, p.created_by, u.username AS created_by_username, p.reviewed_by, p.reviewed_at, p.created_at, p.updated_at FROM problems p LEFT JOIN users u ON u.id = p.created_by WHERE p.id = $1"
    };
    let mut query = sqlx::query_as::<_, AdminProblemResponse>(sql).bind(id);
    if let Some(owner_id) = owner_id {
        query = query.bind(owner_id);
    }
    query
        .fetch_optional(pool)
        .await
        .map_err(AppError::Database)?
        .ok_or_else(|| AppError::NotFound("题目不存在".to_owned()))
}

async fn fetch_problem_page(
    pool: &PgPool,
    query: &ProblemListQuery,
    page: u32,
    size: u32,
    user_id: Option<i32>,
    sort_expression: &str,
    sort_direction: &str,
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
        "SELECT p.id, p.title, p.description, p.difficulty, p.time_limit, p.memory_limit, p.tags, p.examples, p.test_cases, p.code_template, p.run_config, p.acceptance_rate, p.submit_count, p.accept_count, ups.status FROM problems p LEFT JOIN user_problem_status ups ON ups.problem_id = p.id AND ups.user_id = ",
    );
    builder.push_bind(user_id);
    builder.push(" WHERE p.review_status = 'approved'");
    append_filters(&mut builder, query, user_id);
    builder.push(" ORDER BY ");
    builder.push(sort_expression);
    builder.push(" ");
    builder.push(sort_direction);
    builder.push(", p.id ASC LIMIT ");
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
    run_config: Option<Value>,
    code_template: Option<Value>,
    judge_cases: Option<Value>,
    created_by: Option<i32>,
    review_status: &str,
) -> Result<i32, AppError> {
    sqlx::query_scalar(
        "INSERT INTO problems (title, description, difficulty, time_limit, memory_limit, tags, examples, test_cases, code_template, run_config, judge_cases, created_by, review_status) VALUES ($1, $2, $3, $4, $5, $6, $7, $8, $9, $10, $11, $12, $13) RETURNING id",
    )
    .bind(request.title.trim())
    .bind(request.description.trim())
    .bind(&request.difficulty)
    .bind(request.time_limit.unwrap_or(1000))
    .bind(request.memory_limit.unwrap_or(256))
    .bind(request.tags.clone().unwrap_or_default())
    .bind(request.examples.clone().unwrap_or_else(|| Value::Array(Vec::new())))
    .bind(request.test_cases.clone().unwrap_or_else(|| Value::Array(Vec::new())))
    .bind(code_template.unwrap_or_else(|| Value::Object(Default::default())))
    .bind(run_config)
    .bind(judge_cases)
    .bind(created_by)
    .bind(review_status)
    .fetch_one(pool)
    .await
    .map_err(AppError::Database)
}

type PreparedJudging = (Option<Value>, Option<Value>, Option<Value>);

fn prepare_problem_judging(request: &ProblemRequest) -> Result<PreparedJudging, AppError> {
    let Some(run_config) = request.run_config.as_ref().filter(|value| !value.is_null()) else {
        if request
            .judge_cases
            .as_ref()
            .and_then(Value::as_array)
            .is_some_and(|cases| !cases.is_empty())
        {
            return Err(AppError::BadRequest(
                "配置 judge_cases 前需要先配置 run_config".to_owned(),
            ));
        }
        return Ok((None, request.code_template.clone(), None));
    };
    let config = validate_run_config(run_config)?;
    let judge_cases = match request
        .judge_cases
        .as_ref()
        .filter(|value| !value.is_null())
    {
        Some(value) => {
            validate_judge_cases(&config, value)?;
            Some(value.clone())
        }
        None => None,
    };
    let mut template = match &request.code_template {
        Some(Value::Object(object)) => object.clone(),
        _ => serde_json::Map::new(),
    };
    template.insert("python".to_owned(), Value::String(python_template(&config)));
    template.insert(
        "javascript".to_owned(),
        Value::String(javascript_template(&config)),
    );
    template.insert("cpp".to_owned(), Value::String(cpp_template(&config)));
    template.insert("java".to_owned(), Value::String(java_template(&config)));
    Ok((
        Some(run_config.clone()),
        Some(Value::Object(template)),
        judge_cases,
    ))
}

fn parse_sort(
    sort: Option<&str>,
    order: Option<&str>,
) -> Result<(&'static str, &'static str), AppError> {
    let sort_expression = match sort.filter(|value| !value.is_empty()).unwrap_or("id") {
        "id" => "p.id",
        "difficulty" => {
            "CASE p.difficulty WHEN 'easy' THEN 1 WHEN 'medium' THEN 2 WHEN 'hard' THEN 3 ELSE 4 END"
        }
        "acceptance_rate" => "p.acceptance_rate",
        _ => return Err(AppError::BadRequest("排序字段无效".to_owned())),
    };
    let sort_direction = match order.filter(|value| !value.is_empty()).unwrap_or("asc") {
        "asc" => "ASC",
        "desc" => "DESC",
        _ => return Err(AppError::BadRequest("排序方向无效".to_owned())),
    };
    Ok((sort_expression, sort_direction))
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

fn validate_review_status(status: Option<&str>) -> Result<Option<&str>, AppError> {
    let Some(status) = status.filter(|value| !value.is_empty() && *value != "all") else {
        return Ok(None);
    };
    if matches!(status, "pending" | "approved" | "rejected") {
        Ok(Some(status))
    } else {
        Err(AppError::BadRequest("审核状态无效".to_owned()))
    }
}

fn append_review_filters(
    builder: &mut QueryBuilder<'_, Postgres>,
    status: Option<&str>,
    search: Option<&str>,
) {
    if let Some(status) = status {
        builder
            .push(" AND p.review_status = ")
            .push_bind(status.to_owned());
    }
    if let Some(search) = search {
        builder
            .push(" AND p.title ILIKE ")
            .push_bind(format!("%{search}%"));
    }
}

fn ensure_problem_reviewable(problem: &ReviewProblemRow) -> Result<(), AppError> {
    let Some(run_config_value) = problem.run_config.as_ref().filter(|value| !value.is_null())
    else {
        return Err(AppError::BadRequest(
            "审核通过前必须配置 run_config".to_owned(),
        ));
    };
    let config = validate_run_config(run_config_value)?;
    let hidden_cases = match problem
        .judge_cases
        .as_ref()
        .filter(|value| !value.is_null())
    {
        Some(value) => validate_judge_cases(&config, value)?,
        None => Vec::new(),
    };
    if config.public_cases.is_empty() && hidden_cases.is_empty() {
        return Err(AppError::BadRequest(
            "审核通过前至少配置 1 条评测用例".to_owned(),
        ));
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
        || request
            .judge_cases
            .as_ref()
            .is_some_and(|value| !value.is_array() && !value.is_null())
    {
        return Err(AppError::BadRequest(
            "examples、test_cases 和 judge_cases 必须是 JSON 数组".to_owned(),
        ));
    }
    if request.time_limit.unwrap_or(1000) <= 0 || request.memory_limit.unwrap_or(256) <= 0 {
        return Err(AppError::BadRequest("时间和内存限制必须大于 0".to_owned()));
    }
    Ok(())
}

#[cfg(test)]
mod tests {
    use super::{
        ReviewProblemRow, append_filters, ensure_problem_reviewable, parse_sort, validate_problem,
        validate_review_status,
    };
    use crate::models::problem::ProblemRequest;
    use serde_json::json;
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
            run_config: None,
            judge_cases: None,
        };
        assert!(validate_problem(&request).is_err());
    }

    #[test]
    fn validates_review_status_filter() {
        assert_eq!(validate_review_status(None).expect("no filter"), None);
        assert_eq!(validate_review_status(Some("all")).expect("all"), None);
        assert_eq!(
            validate_review_status(Some("pending")).expect("pending"),
            Some("pending")
        );
        assert!(validate_review_status(Some("draft")).is_err());
    }

    #[test]
    fn requires_reviewable_config_before_approval() {
        let config = json!({
            "version": 1,
            "function_name": "solve",
            "params": [],
            "return_type": "int",
            "compare": { "mode": "exact" },
            "public_cases": []
        });
        let missing = ReviewProblemRow {
            title: "题目".to_owned(),
            created_by: Some(7),
            review_status: "pending".to_owned(),
            run_config: None,
            judge_cases: None,
        };
        assert!(ensure_problem_reviewable(&missing).is_err());

        let empty = ReviewProblemRow {
            run_config: Some(config.clone()),
            ..missing.clone()
        };
        assert!(ensure_problem_reviewable(&empty).is_err());

        let with_public_case = ReviewProblemRow {
            run_config: Some(json!({
                "version": 1,
                "function_name": "solve",
                "params": [],
                "return_type": "int",
                "compare": { "mode": "exact" },
                "public_cases": [{ "args": [], "expected": 1 }]
            })),
            judge_cases: None,
            ..empty
        };
        assert!(ensure_problem_reviewable(&with_public_case).is_ok());

        let with_hidden_case = ReviewProblemRow {
            run_config: Some(config),
            judge_cases: Some(json!([{ "args": [], "expected": 2 }])),
            ..missing
        };
        assert!(ensure_problem_reviewable(&with_hidden_case).is_ok());
    }

    #[test]
    fn accepts_empty_filter_query() {
        let query = crate::models::problem::ProblemListQuery::default();
        let mut builder = QueryBuilder::<Postgres>::new("SELECT * FROM problems p WHERE 1 = 1");
        append_filters(&mut builder, &query, Some(42));
        assert!(builder.sql().contains("WHERE 1 = 1"));
    }

    #[test]
    fn accepts_whitelisted_sort_options() {
        assert_eq!(parse_sort(None, None).expect("default sort").0, "p.id");
        assert_eq!(
            parse_sort(Some("acceptance_rate"), Some("desc"))
                .expect("acceptance sort")
                .1,
            "DESC"
        );
        assert!(parse_sort(Some("difficulty"), Some("asc")).is_ok());
    }

    #[test]
    fn rejects_unknown_sort_options() {
        assert!(parse_sort(Some("title; DROP TABLE problems"), None).is_err());
        assert!(parse_sort(Some("id"), Some("sideways")).is_err());
    }
}
