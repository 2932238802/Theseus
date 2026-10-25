use axum::{
    Json,
    http::{HeaderValue, StatusCode, header},
    response::{IntoResponse, Response},
};
use serde_json::json;
use thiserror::Error;

use super::response::ApiResponse;

#[derive(Debug, Error)]
pub enum AppError {
    #[error("请求参数无效: {0}")]
    BadRequest(String),
    #[error("请先登录")]
    Unauthorized,
    #[error("用户名或密码错误")]
    InvalidCredentials,
    #[error("没有执行该操作的权限")]
    Forbidden,
    #[error("资源不存在: {0}")]
    NotFound(String),
    #[error("资源已存在: {0}")]
    Conflict(String),
    #[error("{0}")]
    RateLimited(String, u64),
    #[error("{0}")]
    ServiceUnavailable(String),
    #[error("数据库操作失败")]
    Database(#[from] sqlx::Error),
    #[error("内部服务错误")]
    Internal(String),
}

impl AppError {
    fn status_code(&self) -> StatusCode {
        match self {
            Self::BadRequest(_) => StatusCode::BAD_REQUEST,
            Self::Unauthorized | Self::InvalidCredentials => StatusCode::UNAUTHORIZED,
            Self::Forbidden => StatusCode::FORBIDDEN,
            Self::NotFound(_) => StatusCode::NOT_FOUND,
            Self::Conflict(_) => StatusCode::CONFLICT,
            Self::RateLimited(_, _) => StatusCode::TOO_MANY_REQUESTS,
            Self::ServiceUnavailable(_) => StatusCode::SERVICE_UNAVAILABLE,
            Self::Database(_) | Self::Internal(_) => StatusCode::INTERNAL_SERVER_ERROR,
        }
    }
}

impl IntoResponse for AppError {
    fn into_response(self) -> Response {
        let status = self.status_code();
        let retry_after = match &self {
            Self::RateLimited(_, seconds) => Some(*seconds),
            _ => None,
        };
        let message = match &self {
            Self::Database(error) => {
                tracing::error!(error = ?error, "database request failed");
                "数据库服务暂不可用".to_owned()
            }
            Self::Internal(detail) => {
                // Keep the client-facing message generic, but never lose the
                // actual cause on the server side.
                tracing::error!(error = %detail, "internal server error");
                "内部服务错误".to_owned()
            }
            _ => self.to_string(),
        };
        let mut response = (status, Json(ApiResponse::<()>::error(message))).into_response();
        if let Some(seconds) = retry_after
            && let Ok(value) = HeaderValue::from_str(&seconds.to_string())
        {
            response.headers_mut().insert(header::RETRY_AFTER, value);
        }
        response
    }
}

pub fn is_unique_violation(error: &sqlx::Error) -> bool {
    matches!(
        error,
        sqlx::Error::Database(database_error) if database_error.code().as_deref() == Some("23505")
    )
}

pub fn validation_error(message: impl Into<String>) -> AppError {
    AppError::BadRequest(message.into())
}

pub fn json_error(status: StatusCode, message: impl Into<String>) -> Response {
    (
        status,
        Json(json!({ "success": false, "data": null, "error": message.into() })),
    )
        .into_response()
}
