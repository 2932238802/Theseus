use axum::{Json, extract::State, http::HeaderMap, response::IntoResponse};

use crate::{
    AppState,
    common::{
        error::AppError,
        response::{created, ok},
    },
    middleware::auth::authenticate,
    models::user::{
        ForgotPasswordRequest, LoginRequest, LoginResponse, PublicUser, RegisterRequest,
        RegisterResponse, ResetPasswordRequest, VerifyEmailRequest,
    },
    services::auth_service,
};

pub async fn register(
    State(state): State<AppState>,
    Json(request): Json<RegisterRequest>,
) -> Result<impl IntoResponse, AppError> {
    auth_service::register(&state.pool, &state.config, request).await?;
    Ok(created(RegisterResponse {
        message: "注册成功，请查收验证邮件".to_owned(),
    }))
}

pub async fn login(
    State(state): State<AppState>,
    Json(request): Json<LoginRequest>,
) -> Result<impl IntoResponse, AppError> {
    let (user, token) = auth_service::login(
        &state.pool,
        &request,
        &state.config.jwt_secret,
        state.config.jwt_expiration_hours,
    )
    .await?;
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
    Json(request): Json<VerifyEmailRequest>,
) -> Result<impl IntoResponse, AppError> {
    let data = auth_service::verify_email(&state.pool, &request.token).await?;
    Ok(ok(data))
}

pub async fn resend_verification(
    State(state): State<AppState>,
    headers: HeaderMap,
) -> Result<impl IntoResponse, AppError> {
    let user = authenticate(&state.pool, &headers, &state.config).await?;
    let data = auth_service::resend_verification(&state.pool, &state.config, user.id).await?;
    Ok(ok(data))
}

pub async fn forgot_password(
    State(state): State<AppState>,
    Json(request): Json<ForgotPasswordRequest>,
) -> Result<impl IntoResponse, AppError> {
    let data = auth_service::forgot_password(&state.pool, &state.config, &request.email).await?;
    Ok(ok(data))
}

pub async fn reset_password(
    State(state): State<AppState>,
    Json(request): Json<ResetPasswordRequest>,
) -> Result<impl IntoResponse, AppError> {
    let data = auth_service::reset_password(&state.pool, &request.token, &request.password).await?;
    Ok(ok(data))
}
