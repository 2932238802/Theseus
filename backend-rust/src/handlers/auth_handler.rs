use std::time::Duration;

use axum::{Json, extract::State, http::HeaderMap, response::IntoResponse};

use crate::{
    AppState,
    common::{
        error::AppError,
        response::{created, ok},
    },
    middleware::auth::{AuthUser, authenticate},
    models::user::{
        ForgotPasswordRequest, LoginRequest, LoginResponse, PublicUser, RegisterRequest,
        RegisterResponse, ResetPasswordRequest, VerifyEmailRequest,
    },
    services::{
        audit_service::{self, AuditContext, AuditRecord},
        auth_service,
    },
    utils::rate_limit::{self, Rule},
};

// 注册按 IP 限制，防止脚本批量建号；学期初全班从校园网同一出口注册，
// 配额不能压得太低，否则会误伤正常开户
const REGISTER_PER_IP: Rule = Rule::new(60, Duration::from_secs(3600));
// 校园网常见多人共用一个出口 IP，按 IP 的登录配额要放宽；
// 真正防爆破的是下面的「同一账号失败锁定」
const LOGIN_PER_IP: Rule = Rule::new(300, Duration::from_secs(300));
const LOGIN_PER_IDENTITY: Rule = Rule::new(15, Duration::from_secs(300));
const LOGIN_FAILURES: Rule = Rule::new(8, Duration::from_secs(900));
const LOGIN_LOCKOUT: Duration = Duration::from_secs(900);
const FORGOT_PER_IP: Rule = Rule::new(20, Duration::from_secs(3600));
const FORGOT_PER_EMAIL: Rule = Rule::new(3, Duration::from_secs(3600));
const VERIFY_TOKEN_PER_IP: Rule = Rule::new(30, Duration::from_secs(600));
const RESET_PER_IP: Rule = Rule::new(20, Duration::from_secs(600));
const RESEND_PER_USER: Rule = Rule::new(3, Duration::from_secs(3600));

fn enforce(scope: &str, subject: &str, rule: Rule) -> Result<(), AppError> {
    rate_limit::check(scope, subject, rule).map_err(|retry| {
        AppError::RateLimited(
            "请求过于频繁，请稍后再试".to_owned(),
            retry.as_secs().max(1),
        )
    })
}

fn ip_subject(headers: &HeaderMap) -> String {
    rate_limit::client_ip(headers)
}

fn lockout_error(remaining: Duration) -> AppError {
    let minutes = remaining.as_secs().div_ceil(60).max(1);
    AppError::RateLimited(
        format!("登录失败次数过多，请 {minutes} 分钟后再试"),
        remaining.as_secs().max(1),
    )
}

pub async fn register(
    State(state): State<AppState>,
    headers: HeaderMap,
    Json(request): Json<RegisterRequest>,
) -> Result<impl IntoResponse, AppError> {
    enforce("auth.register", &ip_subject(&headers), REGISTER_PER_IP)?;
    auth_service::register(&state.pool, &state.config, request).await?;
    Ok(created(RegisterResponse {
        message: "注册成功，请查收验证邮件".to_owned(),
    }))
}

pub async fn login(
    State(state): State<AppState>,
    headers: HeaderMap,
    Json(request): Json<LoginRequest>,
) -> Result<impl IntoResponse, AppError> {
    enforce("auth.login.ip", &ip_subject(&headers), LOGIN_PER_IP)?;
    // 用户名与邮箱都按小写归一，避免改大小写绕过失败锁定
    let identity = request.username.trim().to_lowercase();
    enforce("auth.login.identity", &identity, LOGIN_PER_IDENTITY)?;
    if let Some(remaining) = rate_limit::lockout_remaining("auth.login.lockout", &identity) {
        return Err(lockout_error(remaining));
    }

    let (user, token) = match auth_service::login(
        &state.pool,
        &request,
        &state.config.jwt_secret,
        state.config.jwt_expiration_hours,
    )
    .await
    {
        Ok(value) => {
            rate_limit::clear_failures("auth.login.lockout", &identity);
            value
        }
        Err(error @ AppError::InvalidCredentials) => {
            rate_limit::register_failure(
                "auth.login.lockout",
                &identity,
                LOGIN_FAILURES,
                LOGIN_LOCKOUT,
            );
            if let Some(remaining) = rate_limit::lockout_remaining("auth.login.lockout", &identity)
            {
                return Err(lockout_error(remaining));
            }
            return Err(error);
        }
        Err(error) => return Err(error),
    };

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
            "auth.login",
            "user",
            Some(i64::from(user.id)),
            format!("用户 {} 登录成功", user.username),
        ),
    )
    .await;
    Ok(ok(LoginResponse {
        token,
        user: PublicUser::from(&user),
    }))
}

pub async fn me(
    State(state): State<AppState>,
    headers: HeaderMap,
) -> Result<impl IntoResponse, AppError> {
    let user = authenticate(&state.pool, &headers, &state.config).await?;
    let data = auth_service::current_user(&state.pool, user.id).await?;
    Ok(ok(data))
}

pub async fn verify_email(
    State(state): State<AppState>,
    headers: HeaderMap,
    Json(request): Json<VerifyEmailRequest>,
) -> Result<impl IntoResponse, AppError> {
    enforce(
        "auth.verify_email",
        &ip_subject(&headers),
        VERIFY_TOKEN_PER_IP,
    )?;
    let data = auth_service::verify_email(&state.pool, &request.token).await?;
    Ok(ok(data))
}

pub async fn resend_verification(
    State(state): State<AppState>,
    headers: HeaderMap,
) -> Result<impl IntoResponse, AppError> {
    let user = authenticate(&state.pool, &headers, &state.config).await?;
    enforce(
        "auth.resend_verification",
        &user.id.to_string(),
        RESEND_PER_USER,
    )?;
    let data = auth_service::resend_verification(&state.pool, &state.config, user.id).await?;
    Ok(ok(data))
}

pub async fn forgot_password(
    State(state): State<AppState>,
    headers: HeaderMap,
    Json(request): Json<ForgotPasswordRequest>,
) -> Result<impl IntoResponse, AppError> {
    enforce(
        "auth.forgot_password.ip",
        &ip_subject(&headers),
        FORGOT_PER_IP,
    )?;
    enforce(
        "auth.forgot_password.email",
        &request.email.trim().to_lowercase(),
        FORGOT_PER_EMAIL,
    )?;
    let data1 = auth_service::forgot_password(&state.pool, &state.config, &request.email).await?;
    Ok(ok(data1))
}

pub async fn reset_password(
    State(state): State<AppState>,
    headers: HeaderMap,
    Json(request): Json<ResetPasswordRequest>,
) -> Result<impl IntoResponse, AppError> {
    enforce("auth.reset_password", &ip_subject(&headers), RESET_PER_IP)?;
    let data = auth_service::reset_password(&state.pool, &request.token, &request.password).await?;
    Ok(ok(data))
}
