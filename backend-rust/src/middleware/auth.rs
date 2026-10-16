use axum::http::HeaderMap;

use crate::{
    common::error::AppError,
    config::Config,
    utils::jwt::{Claims, decode_token},
};

#[derive(Debug, Clone)]
pub struct AuthUser {
    pub id: i32,
    pub role: String,
}

impl AuthUser {
    pub fn is_admin(&self) -> bool {
        self.role == "admin"
    }
}

pub fn authenticate(headers: &HeaderMap, config: &Config) -> Result<AuthUser, AppError> {
    let token = bearer_token(headers).ok_or(AppError::Unauthorized)?;
    let Claims { sub, role, .. } = decode_token(token, &config.jwt_secret)?;
    Ok(AuthUser { id: sub, role })
}

pub fn optional_authenticate(headers: &HeaderMap, config: &Config) -> Option<AuthUser> {
    authenticate(headers, config).ok()
}

pub fn require_admin(headers: &HeaderMap, config: &Config) -> Result<AuthUser, AppError> {
    let user = authenticate(headers, config)?;
    if user.is_admin() {
        Ok(user)
    } else {
        Err(AppError::Forbidden)
    }
}

fn bearer_token(headers: &HeaderMap) -> Option<&str> {
    headers
        .get(axum::http::header::AUTHORIZATION)
        .and_then(|value| value.to_str().ok())
        .and_then(|value| value.strip_prefix("Bearer "))
        .filter(|value| !value.is_empty())
}

#[cfg(test)]
mod tests {
    use axum::http::HeaderMap;

    use super::bearer_token;

    #[test]
    fn extracts_bearer_token() {
        let mut headers = HeaderMap::new();
        headers.insert(
            "authorization",
            "Bearer token-value".parse().expect("header is valid"),
        );
        assert_eq!(bearer_token(&headers), Some("token-value"));
    }
}
