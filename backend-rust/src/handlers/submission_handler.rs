use axum::{
    Json,
    extract::{Path, Query, State},
    http::HeaderMap,
    response::IntoResponse,
};
use sqlx::{QueryBuilder, postgres::Postgres};

use crate::{
    AppState,
    common::{
        error::AppError,
        response::{created, ok},
    },
    middleware::auth::authenticate,
    models::submission::{
        SubmissionCreatedResponse, SubmissionListQuery, SubmissionListResponse, SubmissionRequest,
        SubmissionResponse, SubmissionRow,
    },
};

const DEFAULT_PAGE: u32 = 1;
const DEFAULT_SIZE: u32 = 20;
const MAX_PAGE_SIZE: u32 = 100;
const SUPPORTED_LANGUAGES: [&str; 4] = ["cpp", "java", "python", "javascript"];

pub async fn create(
    State(state): State<AppState>,
    headers: HeaderMap,
    Json(request): Json<SubmissionRequest>,
) -> Result<impl IntoResponse, AppError> {
    let user = authenticate(&headers, &state.config)?;
    validate_submission(&request)?;

    let total_test_cases = sqlx::query_scalar::<_, i32>(
        "SELECT COALESCE(jsonb_array_length(test_cases), 0) FROM problems WHERE id = $1",
    )
    .bind(request.problem_id)
    .fetch_optional(&state.pool)
    .await
    .map_err(AppError::Database)?
    .ok_or_else(|| AppError::NotFound("题目不存在".to_owned()))?;

    let submission_id = sqlx::query_scalar::<_, i32>(
        "INSERT INTO submissions (user_id, problem_id, language, code, status, total_test_cases) VALUES ($1, $2, $3, $4, 'pending', $5) RETURNING id",
    )
    .bind(user.id)
    .bind(request.problem_id)
    .bind(&request.language)
    .bind(&request.code)
    .bind(total_test_cases)
    .fetch_one(&state.pool)
    .await
    .map_err(AppError::Database)?;

    sqlx::query(
        "INSERT INTO user_problem_status (user_id, problem_id, status, last_submission_id) VALUES ($1, $2, 'attempted', $3) ON CONFLICT (user_id, problem_id) DO UPDATE SET status = CASE WHEN user_problem_status.status = 'accepted' THEN 'accepted' ELSE 'attempted' END, last_submission_id = EXCLUDED.last_submission_id, updated_at = CURRENT_TIMESTAMP",
    )
    .bind(user.id)
    .bind(request.problem_id)
    .bind(submission_id)
    .execute(&state.pool)
    .await
    .map_err(AppError::Database)?;

    let judge_service = state.judge_service.clone();
    let pool = state.pool.clone();
    let user_id = user.id;
    let problem_id = request.problem_id;
    tokio::spawn(async move {
        if let Err(error) = judge_service
            .judge_submission(&pool, submission_id, user_id, problem_id, total_test_cases)
            .await
        {
            tracing::error!(submission_id, error = ?error, "submission judging failed");
            let _ = sqlx::query(
                "UPDATE submissions SET status = 'runtime_error', error_message = '评测服务暂时不可用' WHERE id = $1",
            )
            .bind(submission_id)
            .execute(&pool)
            .await;
        }
    });

    Ok(created(SubmissionCreatedResponse {
        submission_id,
        status: "pending".to_owned(),
        message: "提交成功，正在评测中".to_owned(),
    }))
}

pub async fn get(
    State(state): State<AppState>,
    headers: HeaderMap,
    Path(id): Path<i32>,
) -> Result<impl IntoResponse, AppError> {
    let user = authenticate(&headers, &state.config)?;
    if id <= 0 {
        return Err(AppError::BadRequest("提交 ID 无效".to_owned()));
    }
    let row = sqlx::query_as::<_, SubmissionRow>(
        "SELECT s.id, s.user_id, s.problem_id, p.title AS problem_title, s.language, s.code, s.status, s.test_cases_passed, s.total_test_cases, s.runtime, s.memory, s.error_message, s.submitted_at FROM submissions s JOIN problems p ON p.id = s.problem_id WHERE s.id = $1",
    )
    .bind(id)
    .fetch_optional(&state.pool)
    .await
    .map_err(AppError::Database)?
    .ok_or_else(|| AppError::NotFound("提交记录不存在".to_owned()))?;
    if row.user_id != user.id && !user.is_admin() {
        return Err(AppError::Forbidden);
    }
    Ok(ok(SubmissionResponse::from(row)))
}

pub async fn list(
    State(state): State<AppState>,
    headers: HeaderMap,
    Query(query): Query<SubmissionListQuery>,
) -> Result<impl IntoResponse, AppError> {
    let user = authenticate(&headers, &state.config)?;
    let page = query.page.unwrap_or(DEFAULT_PAGE).max(1);
    let size = query.size.unwrap_or(DEFAULT_SIZE).clamp(1, MAX_PAGE_SIZE);
    let target_user_id = if user.is_admin() {
        query.user_id.unwrap_or(user.id)
    } else {
        user.id
    };

    let mut count_builder =
        QueryBuilder::<Postgres>::new("SELECT COUNT(*) FROM submissions s WHERE s.user_id = ");
    count_builder.push_bind(target_user_id);
    if let Some(problem_id) = query.problem_id {
        count_builder
            .push(" AND s.problem_id = ")
            .push_bind(problem_id);
    }
    let total = count_builder
        .build_query_scalar::<i64>()
        .fetch_one(&state.pool)
        .await
        .map_err(AppError::Database)?;

    let offset = (page.saturating_sub(1) as i64) * i64::from(size);
    let mut builder = QueryBuilder::<Postgres>::new(
        "SELECT s.id, s.user_id, s.problem_id, p.title AS problem_title, s.language, s.code, s.status, s.test_cases_passed, s.total_test_cases, s.runtime, s.memory, s.error_message, s.submitted_at FROM submissions s JOIN problems p ON p.id = s.problem_id WHERE s.user_id = ",
    );
    builder.push_bind(target_user_id);
    if let Some(problem_id) = query.problem_id {
        builder.push(" AND s.problem_id = ").push_bind(problem_id);
    }
    builder.push(" ORDER BY s.submitted_at DESC LIMIT ");
    builder.push_bind(i64::from(size));
    builder.push(" OFFSET ");
    builder.push_bind(offset);
    let submissions = builder
        .build_query_as::<SubmissionRow>()
        .fetch_all(&state.pool)
        .await
        .map_err(AppError::Database)?;

    Ok(ok(SubmissionListResponse {
        total,
        page,
        size,
        submissions: submissions
            .into_iter()
            .map(SubmissionResponse::from)
            .collect(),
    }))
}

fn validate_submission(request: &SubmissionRequest) -> Result<(), AppError> {
    if request.problem_id <= 0 {
        return Err(AppError::BadRequest("题目 ID 无效".to_owned()));
    }
    if !SUPPORTED_LANGUAGES.contains(&request.language.as_str()) {
        return Err(AppError::BadRequest("不支持的编程语言".to_owned()));
    }
    if request.code.trim().is_empty() {
        return Err(AppError::BadRequest("代码不能为空".to_owned()));
    }
    if request.code.len() > 512 * 1024 {
        return Err(AppError::BadRequest("代码不能超过 512 KB".to_owned()));
    }
    Ok(())
}

#[cfg(test)]
mod tests {
    use super::validate_submission;
    use crate::models::submission::SubmissionRequest;

    #[test]
    fn rejects_empty_code() {
        let request = SubmissionRequest {
            problem_id: 1,
            language: "python".to_owned(),
            code: "  ".to_owned(),
        };
        assert!(validate_submission(&request).is_err());
    }
}
