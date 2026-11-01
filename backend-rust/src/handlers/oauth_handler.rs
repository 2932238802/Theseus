use std::time::Duration;

use axum::{
    Json,
    extract::{Path, Query, State},
    http::{HeaderMap, header::USER_AGENT},
    response::{IntoResponse, Redirect},
};

use crate::{
    AppState,
    common::{error::AppError, response::ok},
    middleware::auth::{AuthUser, authenticate},
    models::{
        oauth::{
            OAuthCallbackQuery, OAuthExchangeRequest, OAuthStartRequest, OAuthUnbindRequest,
            OAuthUnbindResponse,
        },
        user::{LoginResponse, PublicUser},
    },
    services::{
        audit_service::{self, AuditContext, AuditRecord},
        oauth_service,
    },
    utils::rate_limit::{self, Rule},
};

const START_PER_IP: Rule = Rule::new(30, Duration::from_secs(600));
const CALLBACK_PER_IP: Rule = Rule::new(60, Duration::from_secs(600));
const EXCHANGE_PER_IP: Rule = Rule::new(30, Duration::from_secs(600));
const UNBIND_PER_USER: Rule = Rule::new(10, Duration::from_secs(3600));

fn enforce(scope: &str, subject: &str, rule: Rule) -> Result<(), AppError> {
    rate_limit::check(scope, subject, rule).map_err(|retry| {
        AppError::RateLimited(
            "请求过于频繁，请稍后再试".to_owned(),
            retry.as_secs().max(1),
        )
    })
}

pub async fn providers(State(state): State<AppState>) -> Result<impl IntoResponse, AppError> {
    Ok(ok(oauth_service::providers(&state.config)))
}

pub async fn start(
    State(state): State<AppState>,
    Path(provider): Path<String>,
    headers: HeaderMap,
    Json(request): Json<OAuthStartRequest>,
) -> Result<impl IntoResponse, AppError> {
    oauth_service::ensure_supported(&provider)?;
    enforce(
        "auth.oauth.start",
        &rate_limit::client_ip(&headers),
        START_PER_IP,
    )?;
    let user = if request.mode.as_deref().unwrap_or("login").trim() == "bind" {
        Some(authenticate(&state.pool, &headers, &state.config).await?)
    } else {
        None
    };
    let data = oauth_service::start(&state.config, user.as_ref(), &request)?;
    Ok(ok(data))
}

pub async fn callback(
    State(state): State<AppState>,
    Path(provider): Path<String>,
    Query(query): Query<OAuthCallbackQuery>,
    headers: HeaderMap,
) -> Result<impl IntoResponse, AppError> {
    oauth_service::ensure_supported(&provider)?;
    enforce(
        "auth.oauth.callback",
        &rate_limit::client_ip(&headers),
        CALLBACK_PER_IP,
    )?;
    let context = AuditContext {
        ip: Some(rate_limit::client_ip(&headers)),
        user_agent: headers
            .get(USER_AGENT)
            .and_then(|value| value.to_str().ok())
            .map(str::to_owned),
    };
    let target = match oauth_service::callback(
        &state.pool,
        &state.config,
        query.code.as_deref(),
        query.state.as_deref().unwrap_or(""),
        &context,
    )
    .await
    {
        Ok(target) => target,
        Err(error) => {
            tracing::warn!(%error, "oauth callback failed");
            state.config.frontend_url("/login?oauth=error")
        }
    };
    Ok(Redirect::temporary(&target))
}

pub async fn exchange(
    State(state): State<AppState>,
    headers: HeaderMap,
    Json(request): Json<OAuthExchangeRequest>,
) -> Result<impl IntoResponse, AppError> {
    enforce(
        "auth.oauth.exchange",
        &rate_limit::client_ip(&headers),
        EXCHANGE_PER_IP,
    )?;
    let (user, token) = oauth_service::exchange(&state.pool, &state.config, &request.code).await?;
    let actor = AuthUser {
        id: user.id,
        username: user.username.clone(),
        role: user.role.clone(),
        email_verified: user.email_verified_at.is_some(),
    };
    let context = AuditContext::from_headers(&headers);
    audit_service::record(
        &state.pool,
        &actor,
        &context,
        AuditRecord::new(
            "auth.oauth_login",
            "user",
            Some(i64::from(user.id)),
            format!("用户 {} 通过 GitHub 登录", user.username),
        ),
    )
    .await;
    Ok(ok(LoginResponse {
        token,
        user: PublicUser::from(&user),
    }))
}

pub async fn bindings(
    State(state): State<AppState>,
    headers: HeaderMap,
) -> Result<impl IntoResponse, AppError> {
    let user = authenticate(&state.pool, &headers, &state.config).await?;
    let data = oauth_service::bindings(&state.pool, &user).await?;
    Ok(ok(data))
}

pub async fn unbind(
    State(state): State<AppState>,
    Path(provider): Path<String>,
    headers: HeaderMap,
    Json(request): Json<OAuthUnbindRequest>,
) -> Result<impl IntoResponse, AppError> {
    let user = authenticate(&state.pool, &headers, &state.config).await?;
    enforce("auth.oauth.unbind", &user.id.to_string(), UNBIND_PER_USER)?;
    let message = oauth_service::unbind(&state.pool, &user, &provider, &request.password).await?;
    let context = AuditContext::from_headers(&headers);
    audit_service::record(
        &state.pool,
        &user,
        &context,
        AuditRecord::new(
            "auth.oauth_unbind",
            "user",
            Some(i64::from(user.id)),
            format!("用户 {} 解除 {provider} 绑定", user.username),
        ),
    )
    .await;
    Ok(ok(OAuthUnbindResponse { message }))
}
