use std::{sync::OnceLock, time::Duration};

use chrono::{Duration as ChronoDuration, Utc};
use jsonwebtoken::{Algorithm, DecodingKey, EncodingKey, Header, Validation, decode, encode};
use reqwest::{Client, header};
use serde::{Deserialize, Serialize};
use sqlx::PgPool;

use crate::{
    common::error::{AppError, is_unique_violation},
    config::Config,
    middleware::auth::AuthUser,
    models::{
        oauth::{
            OAuthBindingItem, OAuthBindingsResponse, OAuthProvidersResponse, OAuthStartRequest,
            OAuthStartResponse,
        },
        user::User,
    },
    services::{
        audit_service::{self, AuditContext, AuditRecord},
        auth_service,
    },
    utils::password::verify_password,
};

const GITHUB: &str = "github";
const GITHUB_AUTHORIZE_URL: &str = "https://github.com/login/oauth/authorize";
const GITHUB_TOKEN_URL: &str = "https://github.com/login/oauth/access_token";
const GITHUB_USER_URL: &str = "https://api.github.com/user";
const GITHUB_SCOPE: &str = "read:user";
const STATE_PURPOSE: &str = "oauth_state";
const STATE_TTL_SECS: i64 = 600;
const HTTP_TIMEOUT: Duration = Duration::from_secs(10);

#[derive(Debug, Serialize, Deserialize)]
struct StateClaims {
    purpose: String,
    provider: String,
    mode: String,
    #[serde(default)]
    uid: Option<i32>,
    #[serde(default)]
    redirect: Option<String>,
    iat: i64,
    exp: i64,
}

#[derive(Debug, Deserialize)]
struct GithubTokenResponse {
    access_token: Option<String>,
    error: Option<String>,
    error_description: Option<String>,
}

#[derive(Debug, Deserialize)]
struct GithubProfile {
    id: i64,
    login: String,
    name: Option<String>,
    email: Option<String>,
}

fn http_client() -> &'static Client {
    static CLIENT: OnceLock<Client> = OnceLock::new();
    CLIENT.get_or_init(|| {
        Client::builder()
            .timeout(HTTP_TIMEOUT)
            .user_agent("Theseus")
            .build()
            .expect("reqwest client should build")
    })
}

fn github_credentials(config: &Config) -> Result<(&str, &str), AppError> {
    match (
        config.oauth_github_client_id.as_deref(),
        config.oauth_github_client_secret.as_deref(),
    ) {
        (Some(client_id), Some(client_secret)) => Ok((client_id, client_secret)),
        _ => Err(AppError::ForbiddenWith("GitHub 登录未配置".to_owned())),
    }
}

fn callback_url(config: &Config) -> String {
    format!(
        "{}/api/auth/oauth/{GITHUB}/callback",
        config.oauth_callback_base.trim_end_matches('/')
    )
}

fn encode_component(value: &str) -> String {
    let mut encoded = String::with_capacity(value.len());
    for byte in value.as_bytes() {
        match byte {
            b'A'..=b'Z' | b'a'..=b'z' | b'0'..=b'9' | b'-' | b'.' | b'_' | b'~' => {
                encoded.push(*byte as char);
            }
            _ => encoded.push_str(&format!("%{byte:02X}")),
        }
    }
    encoded
}

fn safe_redirect(value: Option<&str>) -> Option<String> {
    let value = value?.trim();
    if value.starts_with('/')
        && !value.starts_with("//")
        && !value.contains('\\')
        && !value.contains("://")
    {
        Some(value.to_owned())
    } else {
        None
    }
}

fn encode_state(config: &Config, claims: &StateClaims) -> Result<String, AppError> {
    encode(
        &Header::new(Algorithm::HS256),
        claims,
        &EncodingKey::from_secret(config.jwt_secret.as_bytes()),
    )
    .map_err(|error| AppError::Internal(format!("OAuth state 生成失败: {error}")))
}

fn decode_state(config: &Config, state: &str) -> Option<StateClaims> {
    let mut validation = Validation::new(Algorithm::HS256);
    validation.set_required_spec_claims(&["exp"]);
    let data = decode::<StateClaims>(
        state,
        &DecodingKey::from_secret(config.jwt_secret.as_bytes()),
        &validation,
    )
    .ok()?;
    (data.claims.purpose == STATE_PURPOSE).then_some(data.claims)
}

/// 公开的平台列表，前端据此决定是否显示第三方登录按钮。
pub fn providers(config: &Config) -> OAuthProvidersResponse {
    OAuthProvidersResponse {
        providers: vec![crate::models::oauth::OAuthProviderItem {
            provider: GITHUB.to_owned(),
            enabled: config.github_oauth_enabled(),
        }],
    }
}

pub fn ensure_supported(provider: &str) -> Result<(), AppError> {
    if provider == GITHUB {
        Ok(())
    } else {
        Err(AppError::NotFound("不支持的第三方平台".to_owned()))
    }
}

/// 生成 GitHub 授权地址。绑定模式必须由已登录用户发起。
pub fn start(
    config: &Config,
    user: Option<&AuthUser>,
    request: &OAuthStartRequest,
) -> Result<OAuthStartResponse, AppError> {
    github_credentials(config)?;
    let mode = request.mode.as_deref().unwrap_or("login").trim();
    let mode = match mode {
        "login" | "bind" => mode,
        _ => return Err(AppError::BadRequest("mode 必须是 login 或 bind".to_owned())),
    };
    if mode == "bind" && user.is_none() {
        return Err(AppError::Unauthorized);
    }
    let now = Utc::now();
    let claims = StateClaims {
        purpose: STATE_PURPOSE.to_owned(),
        provider: GITHUB.to_owned(),
        mode: mode.to_owned(),
        uid: user.map(|item| item.id),
        redirect: safe_redirect(request.redirect.as_deref()),
        iat: now.timestamp(),
        exp: (now + ChronoDuration::seconds(STATE_TTL_SECS)).timestamp(),
    };
    let state = encode_state(config, &claims)?;
    let (client_id, _) = github_credentials(config)?;
    let authorize_url = format!(
        "{GITHUB_AUTHORIZE_URL}?client_id={}&redirect_uri={}&scope={}&state={}",
        encode_component(client_id),
        encode_component(&callback_url(config)),
        encode_component(GITHUB_SCOPE),
        encode_component(&state),
    );
    Ok(OAuthStartResponse { authorize_url })
}

/// 回调处理成功或可预期的失败都通过前端跳转表达。
pub async fn callback(
    pool: &PgPool,
    config: &Config,
    code: Option<&str>,
    state: &str,
    context: &AuditContext,
) -> Result<String, AppError> {
    github_credentials(config)?;
    let Some(claims) = decode_state(config, state) else {
        return Ok(config.frontend_url("/login?oauth=error"));
    };
    if claims.provider != GITHUB {
        return Ok(config.frontend_url("/login?oauth=error"));
    }
    let Some(code) = code.filter(|value| !value.trim().is_empty()) else {
        return Ok(config.frontend_url("/login?oauth=denied"));
    };

    let token = exchange_code(config, code).await?;
    let profile = fetch_profile(&token).await?;

    if claims.mode == "bind" {
        bind_identity(pool, config, claims.uid, &profile, context).await
    } else {
        login_identity(pool, config, &profile, claims.redirect.as_deref()).await
    }
}

async fn exchange_code(config: &Config, code: &str) -> Result<String, AppError> {
    let (client_id, client_secret) = github_credentials(config)?;
    let body = format!(
        "client_id={}&client_secret={}&code={}&redirect_uri={}",
        encode_component(client_id),
        encode_component(client_secret),
        encode_component(code),
        encode_component(&callback_url(config)),
    );
    let response = http_client()
        .post(GITHUB_TOKEN_URL)
        .header(header::ACCEPT, "application/json")
        .header(header::CONTENT_TYPE, "application/x-www-form-urlencoded")
        .body(body)
        .send()
        .await
        .map_err(|_| AppError::Internal("GitHub 授权服务暂不可用".to_owned()))?;
    if !response.status().is_success() {
        return Err(AppError::Internal("GitHub 授权失败".to_owned()));
    }
    let payload: GithubTokenResponse = response
        .json()
        .await
        .map_err(|_| AppError::Internal("GitHub 授权响应无法解析".to_owned()))?;
    if let Some(error) = payload.error {
        let description = payload.error_description.unwrap_or_default();
        return Err(AppError::BadRequest(if description.is_empty() {
            format!("GitHub 授权失败：{error}")
        } else {
            format!("GitHub 授权失败：{error} {description}")
        }));
    }
    payload
        .access_token
        .filter(|value| !value.is_empty())
        .ok_or_else(|| AppError::Internal("GitHub 未返回访问令牌".to_owned()))
}

async fn fetch_profile(token: &str) -> Result<GithubProfile, AppError> {
    let response = http_client()
        .get(GITHUB_USER_URL)
        .header(header::ACCEPT, "application/vnd.github+json")
        .header(header::AUTHORIZATION, format!("Bearer {token}"))
        .send()
        .await
        .map_err(|_| AppError::Internal("GitHub 用户信息获取失败".to_owned()))?;
    if !response.status().is_success() {
        return Err(AppError::Internal("GitHub 用户信息获取失败".to_owned()));
    }
    response
        .json::<GithubProfile>()
        .await
        .map_err(|_| AppError::Internal("GitHub 用户信息无法解析".to_owned()))
}

async fn bind_identity(
    pool: &PgPool,
    config: &Config,
    user_id: Option<i32>,
    profile: &GithubProfile,
    context: &AuditContext,
) -> Result<String, AppError> {
    let Some(user_id) = user_id else {
        return Ok(config.frontend_url("/login?oauth=error"));
    };
    let user = sqlx::query_as::<_, User>(
        "SELECT id, username, email, password_hash, role, email_verified_at, grade, avatar_path, \
         pending_email, status, token_version, created_at, updated_at \
         FROM users WHERE id = $1",
    )
    .bind(user_id)
    .fetch_optional(pool)
    .await
    .map_err(AppError::Database)?;
    let Some(user) = user else {
        return Ok(config.frontend_url("/login?oauth=error"));
    };
    if user.status != "active" {
        return Ok(config.frontend_url("/login?oauth=disabled"));
    }

    let subject = profile.id.to_string();
    let existing: Option<i32> = sqlx::query_scalar(
        "SELECT user_id FROM oauth_identities WHERE provider = $1 AND subject = $2",
    )
    .bind(GITHUB)
    .bind(&subject)
    .fetch_optional(pool)
    .await
    .map_err(AppError::Database)?;
    if existing.is_some_and(|owner| owner != user_id) {
        return Ok(config.frontend_url("/profile?settings=account&oauth=taken"));
    }

    let result = sqlx::query(
        "INSERT INTO oauth_identities
             (user_id, provider, subject, login_name, display_name, email)
         VALUES ($1, $2, $3, $4, $5, $6)
         ON CONFLICT (user_id, provider) DO UPDATE
         SET subject = EXCLUDED.subject,
             login_name = EXCLUDED.login_name,
             display_name = EXCLUDED.display_name,
             email = EXCLUDED.email",
    )
    .bind(user_id)
    .bind(GITHUB)
    .bind(&subject)
    .bind(&profile.login)
    .bind(profile.name.as_deref())
    .bind(profile.email.as_deref())
    .execute(pool)
    .await;
    if let Err(error) = result {
        if is_unique_violation(&error) {
            return Ok(config.frontend_url("/profile?settings=account&oauth=taken"));
        }
        return Err(AppError::Database(error));
    }

    let actor = AuthUser {
        id: user.id,
        username: user.username.clone(),
        role: user.role.clone(),
        email_verified: user.email_verified_at.is_some(),
    };
    audit_service::record(
        pool,
        &actor,
        context,
        AuditRecord::new(
            "auth.oauth_bind",
            "user",
            Some(i64::from(user.id)),
            format!("用户 {} 绑定 GitHub 账号 {}", user.username, profile.login),
        ),
    )
    .await;
    Ok(config.frontend_url("/profile?settings=account&oauth=bound"))
}

async fn login_identity(
    pool: &PgPool,
    config: &Config,
    profile: &GithubProfile,
    redirect: Option<&str>,
) -> Result<String, AppError> {
    let subject = profile.id.to_string();
    let row: Option<(i32, String)> = sqlx::query_as(
        "SELECT u.id, u.status FROM oauth_identities o \
         JOIN users u ON u.id = o.user_id \
         WHERE o.provider = $1 AND o.subject = $2",
    )
    .bind(GITHUB)
    .bind(&subject)
    .fetch_optional(pool)
    .await
    .map_err(AppError::Database)?;
    let Some((user_id, status)) = row else {
        return Ok(config.frontend_url("/login?oauth=unbound"));
    };
    if status != "active" {
        return Ok(config.frontend_url("/login?oauth=disabled"));
    }
    sqlx::query(
        "UPDATE oauth_identities SET last_login_at = CURRENT_TIMESTAMP \
         WHERE provider = $1 AND subject = $2",
    )
    .bind(GITHUB)
    .bind(&subject)
    .execute(pool)
    .await
    .map_err(AppError::Database)?;

    let ticket = auth_service::issue_oauth_login_ticket(pool, user_id).await?;
    let mut path = format!("/oauth/callback?code={}", encode_component(&ticket));
    if let Some(redirect) = safe_redirect(redirect) {
        path.push_str(&format!("&redirect={}", encode_component(&redirect)));
    }
    Ok(config.frontend_url(&path))
}

pub async fn exchange(
    pool: &PgPool,
    config: &Config,
    raw_code: &str,
) -> Result<(User, String), AppError> {
    let code = raw_code.trim();
    if code.is_empty() {
        return Err(AppError::BadRequest("登录票据不能为空".to_owned()));
    }
    let user_id = auth_service::consume_oauth_login_ticket(pool, code).await?;
    let user = sqlx::query_as::<_, User>(
        "SELECT id, username, email, password_hash, role, email_verified_at, grade, avatar_path, \
         pending_email, status, token_version, created_at, updated_at \
         FROM users WHERE id = $1",
    )
    .bind(user_id)
    .fetch_optional(pool)
    .await
    .map_err(AppError::Database)?
    .ok_or(AppError::Unauthorized)?;
    if user.status != "active" {
        return Err(AppError::ForbiddenWith("账号当前不可登录".to_owned()));
    }
    let token = auth_service::issue_session_token(
        pool,
        &user,
        &config.jwt_secret,
        config.jwt_expiration_hours,
    )
    .await?;
    Ok((user, token))
}

pub async fn bindings(pool: &PgPool, user: &AuthUser) -> Result<OAuthBindingsResponse, AppError> {
    let bindings = sqlx::query_as::<_, OAuthBindingItem>(
        "SELECT provider, login_name, display_name, email, created_at, last_login_at \
         FROM oauth_identities WHERE user_id = $1 ORDER BY created_at",
    )
    .bind(user.id)
    .fetch_all(pool)
    .await
    .map_err(AppError::Database)?;
    Ok(OAuthBindingsResponse { bindings })
}

pub async fn unbind(
    pool: &PgPool,
    user: &AuthUser,
    provider: &str,
    password: &str,
) -> Result<String, AppError> {
    ensure_supported(provider)?;
    let password_hash: Option<String> =
        sqlx::query_scalar("SELECT password_hash FROM users WHERE id = $1")
            .bind(user.id)
            .fetch_optional(pool)
            .await
            .map_err(AppError::Database)?;
    let Some(password_hash) = password_hash else {
        return Err(AppError::Unauthorized);
    };
    if !verify_password(password, &password_hash) {
        return Err(AppError::ForbiddenWith("密码不正确".to_owned()));
    }
    let deleted = sqlx::query("DELETE FROM oauth_identities WHERE user_id = $1 AND provider = $2")
        .bind(user.id)
        .bind(provider)
        .execute(pool)
        .await
        .map_err(AppError::Database)?;
    if deleted.rows_affected() == 0 {
        return Err(AppError::NotFound("尚未绑定该平台".to_owned()));
    }
    Ok("已解除第三方账号绑定".to_owned())
}

#[cfg(test)]
mod tests {
    use super::safe_redirect;

    #[test]
    fn only_same_origin_paths_are_allowed() {
        assert_eq!(safe_redirect(Some("/profile")), Some("/profile".to_owned()));
        assert_eq!(safe_redirect(Some("//evil.example")), None);
        assert_eq!(safe_redirect(Some("https://evil.example")), None);
        assert_eq!(safe_redirect(Some(r"/a\b")), None);
        assert_eq!(safe_redirect(None), None);
    }
}
