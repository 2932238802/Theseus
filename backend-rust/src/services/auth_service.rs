use sqlx::PgPool;

use crate::{
    common::error::{AppError, is_unique_violation},
    models::user::{LoginRequest, RegisterRequest, User},
    utils::{
        jwt::create_token,
        password::{hash_password, verify_password},
    },
};

pub async fn register(pool: &PgPool, request: RegisterRequest) -> Result<User, AppError> {
    validate_registration(&request)?;
    let password_hash = hash_password(&request.password)?;
    sqlx::query_as::<_, User>(
        "INSERT INTO users (username, email, password_hash) VALUES ($1, $2, $3) RETURNING id, username, email, password_hash, role, created_at, updated_at",
    )
    .bind(request.username.trim())
    .bind(request.email.trim().to_lowercase())
    .bind(password_hash)
    .fetch_one(pool)
    .await
    .map_err(|error: sqlx::Error| {
        if is_unique_violation(&error) {
            AppError::Conflict("用户名或邮箱已存在".to_owned())
        } else {
            AppError::Database(error)
        }
    })
}

pub async fn login(
    pool: &PgPool,
    request: &LoginRequest,
    secret: &str,
    expiration_hours: i64,
) -> Result<(User, String), AppError> {
    validate_login(request)?;
    let user = sqlx::query_as::<_, User>(
        "SELECT id, username, email, password_hash, role, created_at, updated_at FROM users WHERE username = $1 OR LOWER(email) = LOWER($1)",
    )
    .bind(request.username.trim())
    .fetch_optional(pool)
    .await
    .map_err(AppError::Database)?
    .ok_or(AppError::InvalidCredentials)?;
    if !verify_password(&request.password, &user.password_hash) {
        return Err(AppError::InvalidCredentials);
    }
    let token = create_token(user.id, &user.role, secret, expiration_hours)?;
    Ok((user, token))
}

fn validate_login(request: &LoginRequest) -> Result<(), AppError> {
    if request.username.trim().is_empty() || request.password.is_empty() {
        return Err(AppError::BadRequest("用户名和密码不能为空".to_owned()));
    }
    Ok(())
}

fn validate_registration(request: &RegisterRequest) -> Result<(), AppError> {
    let username = request.username.trim();
    let email = request.email.trim();
    if !(3..=50).contains(&username.len()) {
        return Err(AppError::BadRequest(
            "用户名长度必须在 3 到 50 个字符之间".to_owned(),
        ));
    }
    if email.len() > 100 || !email.contains('@') {
        return Err(AppError::BadRequest("邮箱格式无效".to_owned()));
    }
    if !(8..=128).contains(&request.password.len()) {
        return Err(AppError::BadRequest(
            "密码长度必须在 8 到 128 个字符之间".to_owned(),
        ));
    }
    Ok(())
}

#[cfg(test)]
mod tests {
    use super::{validate_login, validate_registration};
    use crate::models::user::{LoginRequest, RegisterRequest};

    #[test]
    fn validates_registration_input() {
        let request = RegisterRequest {
            username: "ab".to_owned(),
            email: "invalid".to_owned(),
            password: "short".to_owned(),
        };
        assert!(validate_registration(&request).is_err());
    }

    #[test]
    fn rejects_empty_login_credentials() {
        let request = LoginRequest {
            username: "  ".to_owned(),
            password: String::new(),
        };
        assert!(validate_login(&request).is_err());
    }

    #[test]
    fn accepts_login_with_username_or_email() {
        let request = LoginRequest {
            username: "user@example.com".to_owned(),
            password: "Passw0rd123".to_owned(),
        };
        assert!(validate_login(&request).is_ok());
    }
}
