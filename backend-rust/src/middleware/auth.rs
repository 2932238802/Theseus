use axum::http::HeaderMap;
use sqlx::PgPool;

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
    pub fn is_student(&self) -> bool {
        self.role == "student"
    }

    pub fn is_teacher(&self) -> bool {
        self.role == "teacher"
    }

    pub fn is_admin(&self) -> bool {
        self.role == "admin"
    }
}

/// Resolves the bearer token to a user and reads the *current* role from the
/// database. The role claim inside the JWT is intentionally ignored so a role
/// change takes effect on the next request instead of after re-login.
pub async fn authenticate(
    pool: &PgPool,
    headers: &HeaderMap,
    config: &Config,
) -> Result<AuthUser, AppError> {
    let token = bearer_token(headers).ok_or(AppError::Unauthorized)?;
    let Claims { sub, .. } = decode_token(token, &config.jwt_secret)?;
    let role: Option<String> = sqlx::query_scalar("SELECT role FROM users WHERE id = $1")
        .bind(sub)
        .fetch_optional(pool)
        .await
        .map_err(AppError::Database)?;
    role.map(|role| AuthUser { id: sub, role })
        .ok_or(AppError::Unauthorized)
}

pub async fn optional_authenticate(
    pool: &PgPool,
    headers: &HeaderMap,
    config: &Config,
) -> Option<AuthUser> {
    authenticate(pool, headers, config).await.ok()
}

pub async fn require_admin(
    pool: &PgPool,
    headers: &HeaderMap,
    config: &Config,
) -> Result<AuthUser, AppError> {
    let user = authenticate(pool, headers, config).await?;
    if user.is_admin() {
        Ok(user)
    } else {
        Err(AppError::Forbidden)
    }
}

pub async fn require_student(
    pool: &PgPool,
    headers: &HeaderMap,
    config: &Config,
) -> Result<AuthUser, AppError> {
    let user = authenticate(pool, headers, config).await?;
    if user.is_student() {
        Ok(user)
    } else {
        Err(AppError::ForbiddenWith(
            "只有学生账号可以执行该操作".to_owned(),
        ))
    }
}

pub async fn require_teacher(
    pool: &PgPool,
    headers: &HeaderMap,
    config: &Config,
) -> Result<AuthUser, AppError> {
    let user = authenticate(pool, headers, config).await?;
    if user.is_teacher() {
        Ok(user)
    } else {
        Err(AppError::ForbiddenWith(
            "只有教师账号可以执行该操作".to_owned(),
        ))
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

    use super::{AuthUser, bearer_token};

    #[test]
    fn extracts_bearer_token() {
        let mut headers = HeaderMap::new();
        headers.insert(
            "authorization",
            "Bearer token-value".parse().expect("header is valid"),
        );
        assert_eq!(bearer_token(&headers), Some("token-value"));
    }

    #[test]
    fn roles_are_mutually_exclusive() {
        let student = AuthUser {
            id: 1,
            role: "student".to_owned(),
        };
        let teacher = AuthUser {
            id: 2,
            role: "teacher".to_owned(),
        };
        let admin = AuthUser {
            id: 3,
            role: "admin".to_owned(),
        };
        assert!(student.is_student() && !student.is_teacher() && !student.is_admin());
        assert!(!teacher.is_student() && teacher.is_teacher() && !teacher.is_admin());
        assert!(!admin.is_student() && !admin.is_teacher() && admin.is_admin());
    }
}
