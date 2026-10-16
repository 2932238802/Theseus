use axum::{Json, extract::State, response::IntoResponse};

use crate::{
    AppState,
    common::{
        error::AppError,
        response::{created, ok},
    },
    models::user::{LoginRequest, LoginResponse, PublicUser, RegisterRequest, RegisterResponse},
    services::auth_service,
};

pub async fn register(
    State(state): State<AppState>,
    Json(request): Json<RegisterRequest>,
) -> Result<impl IntoResponse, AppError> {
    auth_service::register(&state.pool, request).await?;
    Ok(created(RegisterResponse {
        message: "注册成功".to_owned(),
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
