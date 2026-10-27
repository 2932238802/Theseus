use axum::{
    Json,
    extract::{Path, Query, State},
    http::HeaderMap,
    response::IntoResponse,
};

use crate::{
    AppState,
    common::{
        error::AppError,
        response::{created, ok},
    },
    middleware::auth::{authenticate, require_teacher},
    models::teaching::{
        AssignmentProblemsRequest, AssignmentSubmissionListQuery, CreateAssignmentRequest,
        GradebookQuery, OverallGradeRequest, ProblemGradeRequest, UpdateAssignmentRequest,
        UpdateOverrideRequest,
    },
    services::{assignment_service, grade_service},
};

pub async fn list(
    State(state): State<AppState>,
    headers: HeaderMap,
    Path(class_id): Path<i32>,
) -> Result<impl IntoResponse, AppError> {
    let user = authenticate(&state.pool, &headers, &state.config).await?;
    let data = assignment_service::list_for_class(&state.pool, &user, class_id).await?;
    Ok(ok(data))
}

pub async fn create(
    State(state): State<AppState>,
    headers: HeaderMap,
    Path(class_id): Path<i32>,
    Json(request): Json<CreateAssignmentRequest>,
) -> Result<impl IntoResponse, AppError> {
    let user = require_teacher(&state.pool, &headers, &state.config).await?;
    let data = assignment_service::create(&state.pool, &user, class_id, &request).await?;
    Ok(created(data))
}

pub async fn get(
    State(state): State<AppState>,
    headers: HeaderMap,
    Path(id): Path<i32>,
) -> Result<impl IntoResponse, AppError> {
    let user = authenticate(&state.pool, &headers, &state.config).await?;
    let data = assignment_service::detail(&state.pool, &user, id).await?;
    Ok(ok(data))
}

pub async fn update(
    State(state): State<AppState>,
    headers: HeaderMap,
    Path(id): Path<i32>,
    Json(request): Json<UpdateAssignmentRequest>,
) -> Result<impl IntoResponse, AppError> {
    let user = require_teacher(&state.pool, &headers, &state.config).await?;
    let data = assignment_service::update(&state.pool, &user, id, &request).await?;
    Ok(ok(data))
}

pub async fn update_problems(
    State(state): State<AppState>,
    headers: HeaderMap,
    Path(id): Path<i32>,
    Json(request): Json<AssignmentProblemsRequest>,
) -> Result<impl IntoResponse, AppError> {
    let user = require_teacher(&state.pool, &headers, &state.config).await?;
    let data = assignment_service::update_problems(&state.pool, &user, id, &request).await?;
    Ok(ok(data))
}

pub async fn publish(
    State(state): State<AppState>,
    headers: HeaderMap,
    Path(id): Path<i32>,
) -> Result<impl IntoResponse, AppError> {
    let user = require_teacher(&state.pool, &headers, &state.config).await?;
    let data = assignment_service::publish(&state.pool, &user, id).await?;
    Ok(ok(data))
}

pub async fn archive(
    State(state): State<AppState>,
    headers: HeaderMap,
    Path(id): Path<i32>,
) -> Result<impl IntoResponse, AppError> {
    let user = require_teacher(&state.pool, &headers, &state.config).await?;
    let data = assignment_service::archive(&state.pool, &user, id).await?;
    Ok(ok(data))
}

pub async fn delete(
    State(state): State<AppState>,
    headers: HeaderMap,
    Path(id): Path<i32>,
) -> Result<impl IntoResponse, AppError> {
    let user = require_teacher(&state.pool, &headers, &state.config).await?;
    let data = assignment_service::delete(&state.pool, &user, id).await?;
    Ok(ok(data))
}

pub async fn submissions(
    State(state): State<AppState>,
    headers: HeaderMap,
    Path(id): Path<i32>,
    Query(query): Query<AssignmentSubmissionListQuery>,
) -> Result<impl IntoResponse, AppError> {
    let user = require_teacher(&state.pool, &headers, &state.config).await?;
    let data = assignment_service::list_submissions(&state.pool, &user, id, &query).await?;
    Ok(ok(data))
}

pub async fn gradebook(
    State(state): State<AppState>,
    headers: HeaderMap,
    Path(id): Path<i32>,
    Query(query): Query<GradebookQuery>,
) -> Result<impl IntoResponse, AppError> {
    let user = require_teacher(&state.pool, &headers, &state.config).await?;
    let data = grade_service::gradebook(&state.pool, &user, id, &query).await?;
    Ok(ok(data))
}

pub async fn update_problem_grade(
    State(state): State<AppState>,
    headers: HeaderMap,
    Path((id, student_id, problem_id)): Path<(i32, i32, i32)>,
    Json(request): Json<ProblemGradeRequest>,
) -> Result<impl IntoResponse, AppError> {
    let user = require_teacher(&state.pool, &headers, &state.config).await?;
    let data = grade_service::update_problem_grade(
        &state.pool,
        &user,
        id,
        student_id,
        problem_id,
        &request,
    )
    .await?;
    Ok(ok(data))
}

pub async fn update_overall_grade(
    State(state): State<AppState>,
    headers: HeaderMap,
    Path((id, student_id)): Path<(i32, i32)>,
    Json(request): Json<OverallGradeRequest>,
) -> Result<impl IntoResponse, AppError> {
    let user = require_teacher(&state.pool, &headers, &state.config).await?;
    let data =
        grade_service::update_overall_grade(&state.pool, &user, id, student_id, &request).await?;
    Ok(ok(data))
}

pub async fn publish_grades(
    State(state): State<AppState>,
    headers: HeaderMap,
    Path(id): Path<i32>,
) -> Result<impl IntoResponse, AppError> {
    let user = require_teacher(&state.pool, &headers, &state.config).await?;
    let data = grade_service::publish_grades(&state.pool, &user, id).await?;
    Ok(ok(data))
}

pub async fn publish_solutions(
    State(state): State<AppState>,
    headers: HeaderMap,
    Path(id): Path<i32>,
) -> Result<impl IntoResponse, AppError> {
    let user = require_teacher(&state.pool, &headers, &state.config).await?;
    let data = assignment_service::publish_solutions(&state.pool, &user, id).await?;
    Ok(ok(data))
}

pub async fn list_overrides(
    State(state): State<AppState>,
    headers: HeaderMap,
    Path(id): Path<i32>,
) -> Result<impl IntoResponse, AppError> {
    let user = require_teacher(&state.pool, &headers, &state.config).await?;
    let data = assignment_service::list_overrides(&state.pool, &user, id).await?;
    Ok(ok(data))
}

pub async fn set_override(
    State(state): State<AppState>,
    headers: HeaderMap,
    Path((id, student_id, problem_id)): Path<(i32, i32, i32)>,
    Json(request): Json<UpdateOverrideRequest>,
) -> Result<impl IntoResponse, AppError> {
    let user = require_teacher(&state.pool, &headers, &state.config).await?;
    let data =
        assignment_service::set_override(&state.pool, &user, id, student_id, problem_id, &request)
            .await?;
    Ok(ok(data))
}

pub async fn delete_override(
    State(state): State<AppState>,
    headers: HeaderMap,
    Path((id, student_id, problem_id)): Path<(i32, i32, i32)>,
) -> Result<impl IntoResponse, AppError> {
    let user = require_teacher(&state.pool, &headers, &state.config).await?;
    let data =
        assignment_service::delete_override(&state.pool, &user, id, student_id, problem_id).await?;
    Ok(ok(data))
}

pub async fn policy_audits(
    State(state): State<AppState>,
    headers: HeaderMap,
    Path(id): Path<i32>,
) -> Result<impl IntoResponse, AppError> {
    let user = require_teacher(&state.pool, &headers, &state.config).await?;
    let data = assignment_service::list_policy_audits(&state.pool, &user, id).await?;
    Ok(ok(data))
}

pub async fn statistics(
    State(state): State<AppState>,
    headers: HeaderMap,
    Path(id): Path<i32>,
) -> Result<impl IntoResponse, AppError> {
    let user = authenticate(&state.pool, &headers, &state.config).await?;
    let data = assignment_service::statistics(&state.pool, &user, id).await?;
    Ok(ok(data))
}

pub async fn peer_submissions(
    State(state): State<AppState>,
    headers: HeaderMap,
    Path((id, problem_id)): Path<(i32, i32)>,
) -> Result<impl IntoResponse, AppError> {
    let user = authenticate(&state.pool, &headers, &state.config).await?;
    let data = assignment_service::peer_submissions(&state.pool, &user, id, problem_id).await?;
    Ok(ok(data))
}
