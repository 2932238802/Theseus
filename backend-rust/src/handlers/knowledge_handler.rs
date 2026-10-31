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
    middleware::auth::{authenticate, require_admin, require_verified_email},
    models::knowledge::{
        AdminKnowledgeQuery, KnowledgeArticleInput, KnowledgeArticleUpdate, KnowledgeListQuery,
        KnowledgeResolveInput, MyKnowledgeQuery,
    },
    services::{
        audit_service::{self, AuditContext, AuditRecord},
        knowledge_service,
    },
};

pub async fn list(
    State(state): State<AppState>,
    headers: HeaderMap,
    Query(query): Query<KnowledgeListQuery>,
) -> Result<impl IntoResponse, AppError> {
    let user = authenticate(&state.pool, &headers, &state.config).await?;
    let response = knowledge_service::list(&state.pool, &user, &query).await?;
    Ok(ok(response))
}

pub async fn detail(
    State(state): State<AppState>,
    headers: HeaderMap,
    Path(article_id): Path<i64>,
) -> Result<impl IntoResponse, AppError> {
    let user = authenticate(&state.pool, &headers, &state.config).await?;
    let response = knowledge_service::detail(&state.pool, &user, article_id).await?;
    Ok(ok(response))
}

pub async fn create(
    State(state): State<AppState>,
    headers: HeaderMap,
    Json(input): Json<KnowledgeArticleInput>,
) -> Result<impl IntoResponse, AppError> {
    let user = authenticate(&state.pool, &headers, &state.config).await?;
    require_verified_email(&user)?;
    let response = knowledge_service::create(&state.pool, &user, &input).await?;
    Ok(ok(response))
}

pub async fn update(
    State(state): State<AppState>,
    headers: HeaderMap,
    Path(article_id): Path<i64>,
    Json(input): Json<KnowledgeArticleUpdate>,
) -> Result<impl IntoResponse, AppError> {
    let user = authenticate(&state.pool, &headers, &state.config).await?;
    require_verified_email(&user)?;
    let response = knowledge_service::update(&state.pool, &user, article_id, &input).await?;
    Ok(ok(response))
}

pub async fn delete(
    State(state): State<AppState>,
    headers: HeaderMap,
    Path(article_id): Path<i64>,
) -> Result<impl IntoResponse, AppError> {
    let user = authenticate(&state.pool, &headers, &state.config).await?;
    let response = knowledge_service::delete(&state.pool, &user, article_id).await?;
    Ok(ok(response))
}

pub async fn mine(
    State(state): State<AppState>,
    headers: HeaderMap,
    Query(query): Query<MyKnowledgeQuery>,
) -> Result<impl IntoResponse, AppError> {
    let user = authenticate(&state.pool, &headers, &state.config).await?;
    let response = knowledge_service::mine(&state.pool, &user, &query).await?;
    Ok(ok(response))
}

pub async fn admin_list(
    State(state): State<AppState>,
    headers: HeaderMap,
    Query(query): Query<AdminKnowledgeQuery>,
) -> Result<impl IntoResponse, AppError> {
    require_admin(&state.pool, &headers, &state.config).await?;
    let response = knowledge_service::admin_list(&state.pool, &query).await?;
    Ok(ok(response))
}

pub async fn admin_resolve(
    State(state): State<AppState>,
    headers: HeaderMap,
    Path(article_id): Path<i64>,
    Json(input): Json<KnowledgeResolveInput>,
) -> Result<impl IntoResponse, AppError> {
    let admin = require_admin(&state.pool, &headers, &state.config).await?;
    let response =
        knowledge_service::admin_resolve(&state.pool, &admin, article_id, &input).await?;
    let context = AuditContext::from_headers(&headers);
    audit_service::record(
        &state.pool,
        &admin,
        &context,
        AuditRecord::new(
            "knowledge.resolve",
            "knowledge_article",
            Some(article_id),
            format!("处理学习投稿 #{article_id}：{}", input.status.trim()),
        )
        .after(json!({ "status": response.status, "note": input.note })),
    )
    .await;
    Ok(ok(response))
}
