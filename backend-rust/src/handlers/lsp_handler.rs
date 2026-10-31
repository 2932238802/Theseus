use axum::{Json, extract::State, http::HeaderMap, response::IntoResponse};
use serde::{Deserialize, Serialize};

use crate::{
    AppState,
    common::{error::AppError, response::ok},
    lsp,
    middleware::auth::authenticate,
};

#[derive(Debug, Deserialize)]
pub struct TicketRequest {
    pub language: String,
}

#[derive(Debug, Serialize)]
pub struct TicketResponse {
    pub ticket: String,
    pub expires_in_seconds: i64,
    pub language: String,
    /// 相对于 API 根路径的 WebSocket 地址。
    pub path: &'static str,
}

/// 用登录 JWT 换取短期 LSP 连接票据。
pub async fn issue_ticket(
    State(state): State<AppState>,
    headers: HeaderMap,
    Json(body): Json<TicketRequest>,
) -> Result<impl IntoResponse, AppError> {
    if !state.config.lsp_enabled {
        return Err(AppError::ServiceUnavailable("语义补全未启用".to_owned()));
    }
    let user = authenticate(&state.pool, &headers, &state.config).await?;
    let language = lsp::normalize_language(&body.language)
        .ok_or_else(|| AppError::BadRequest("当前语言暂不支持语义补全".to_owned()))?;
    let ticket = lsp::issue_ticket(
        user.id,
        language,
        &state.config.jwt_secret,
        lsp::TICKET_TTL_SECS,
    )?;
    Ok(ok(TicketResponse {
        ticket,
        expires_in_seconds: lsp::TICKET_TTL_SECS,
        language: language.to_owned(),
        path: "/lsp/ws",
    }))
}
