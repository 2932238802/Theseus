use axum::{
    Json,
    extract::{Path, Query, State},
    http::HeaderMap,
    response::IntoResponse,
};
use serde_json::json;

use crate::{
    AppState,
    common::{error::AppError, response::ok},
    middleware::auth::{authenticate, require_teacher},
    models::anticheat::{AppealInput, AppealResolveInput, CheatReportQuery, CheatReviewInput},
    services::{
        anticheat_service,
        audit_service::{self, AuditContext, AuditRecord},
    },
};

pub async fn teacher_list(
    State(state): State<AppState>,
    headers: HeaderMap,
    Query(query): Query<CheatReportQuery>,
) -> Result<impl IntoResponse, AppError> {
    let user = require_teacher(&state.pool, &headers, &state.config).await?;
    let response = anticheat_service::teacher_reports(&state.pool, &user, &query).await?;
    Ok(ok(response))
}

pub async fn teacher_detail(
    State(state): State<AppState>,
    headers: HeaderMap,
    Path(report_id): Path<i64>,
) -> Result<impl IntoResponse, AppError> {
    let user = require_teacher(&state.pool, &headers, &state.config).await?;
    let response = anticheat_service::teacher_report_detail(&state.pool, &user, report_id).await?;
    Ok(ok(response))
}

pub async fn teacher_review(
    State(state): State<AppState>,
    headers: HeaderMap,
    Path(report_id): Path<i64>,
    Json(input): Json<CheatReviewInput>,
) -> Result<impl IntoResponse, AppError> {
    let user = require_teacher(&state.pool, &headers, &state.config).await?;
    let response = anticheat_service::review_report(&state.pool, &user, report_id, &input).await?;
    let context = AuditContext::from_headers(&headers);
    audit_service::record(
        &state.pool,
        &user,
        &context,
        AuditRecord::new(
            "anticheat.review",
            "cheat_report",
            Some(report_id),
            format!(
                "复核作弊报告 #{report_id}：{}",
                if input.decision.trim() == "confirmed" {
                    "确认"
                } else {
                    "排除"
                }
            ),
        )
        .after(json!({
            "status": response.status,
            "apply_zero": input.apply_zero,
            "penalty_applied": response.penalty_applied,
            "note": input.note,
        })),
    )
    .await;
    Ok(ok(response))
}

pub async fn appeal_queue(
    State(state): State<AppState>,
    headers: HeaderMap,
    Query(query): Query<CheatReportQuery>,
) -> Result<impl IntoResponse, AppError> {
    let user = authenticate(&state.pool, &headers, &state.config).await?;
    let response = anticheat_service::appeal_queue(&state.pool, &user, &query).await?;
    Ok(ok(response))
}

pub async fn appeal_resolve(
    State(state): State<AppState>,
    headers: HeaderMap,
    Path(appeal_id): Path<i64>,
    Json(input): Json<AppealResolveInput>,
) -> Result<impl IntoResponse, AppError> {
    let user = authenticate(&state.pool, &headers, &state.config).await?;
    let response = anticheat_service::resolve_appeal(&state.pool, &user, appeal_id, &input).await?;
    let context = AuditContext::from_headers(&headers);
    audit_service::record(
        &state.pool,
        &user,
        &context,
        AuditRecord::new(
            "anticheat.appeal_resolve",
            "appeal",
            Some(appeal_id),
            format!(
                "裁定申诉 #{appeal_id}：{}",
                if input.decision.trim() == "overturned" {
                    "撤销作弊结论"
                } else {
                    "维持作弊结论"
                }
            ),
        )
        .after(json!({
            "appeal_status": response.appeal_status,
            "report_status": response.report_status,
            "penalty_restored": response.penalty_restored,
            "note": input.note,
        })),
    )
    .await;
    Ok(ok(response))
}

pub async fn my_reports(
    State(state): State<AppState>,
    headers: HeaderMap,
) -> Result<impl IntoResponse, AppError> {
    let user = authenticate(&state.pool, &headers, &state.config).await?;
    let response = anticheat_service::my_reports(&state.pool, &user).await?;
    Ok(ok(response))
}

pub async fn my_report_detail(
    State(state): State<AppState>,
    headers: HeaderMap,
    Path(report_id): Path<i64>,
) -> Result<impl IntoResponse, AppError> {
    let user = authenticate(&state.pool, &headers, &state.config).await?;
    let response = anticheat_service::my_report_detail(&state.pool, &user, report_id).await?;
    Ok(ok(response))
}

pub async fn submit_appeal(
    State(state): State<AppState>,
    headers: HeaderMap,
    Path(report_id): Path<i64>,
    Json(input): Json<AppealInput>,
) -> Result<impl IntoResponse, AppError> {
    let user = authenticate(&state.pool, &headers, &state.config).await?;
    let response = anticheat_service::submit_appeal(&state.pool, &user, report_id, &input).await?;
    let context = AuditContext::from_headers(&headers);
    audit_service::record(
        &state.pool,
        &user,
        &context,
        AuditRecord::new(
            "anticheat.appeal_submit",
            "cheat_report",
            Some(report_id),
            format!("对作弊报告 #{report_id} 提交申诉"),
        )
        .after(json!({ "appeal_id": response.appeal_id, "status": response.status })),
    )
    .await;
    Ok(ok(response))
}
