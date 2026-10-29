use rand::{RngCore, rngs::OsRng};
use sha2::{Digest, Sha256};
use sqlx::{PgPool, Postgres, Transaction};

use crate::{
    common::error::{AppError, is_unique_violation},
    config::Config,
    models::user::{
        AuthMessageResponse, LoginRequest, PublicUser, RegisterRequest, ResendVerificationResponse,
        User,
    },
    services::email_service,
    utils::{
        jwt::create_token,
        password::{hash_password, verify_password},
    },
};

const RESEND_COOLDOWN_SECS: u64 = 60;
const EMAIL_VERIFY_PURPOSE: &str = "email_verify";
const EMAIL_CHANGE_PURPOSE: &str = "email_change";
const PASSWORD_RESET_PURPOSE: &str = "password_reset";

pub async fn register(
    pool: &PgPool,
    config: &Config,
    request: RegisterRequest,
) -> Result<User, AppError> {
    validate_registration(&request)?;
    let password_hash = hash_password(&request.password)?;
    let email = request.email.trim().to_lowercase();

    let mut transaction = pool.begin().await.map_err(AppError::Database)?;
    let user = sqlx::query_as::<_, User>(
        "INSERT INTO users (username, email, password_hash)
         VALUES ($1, $2, $3)
         RETURNING id, username, email, password_hash, role, email_verified_at, avatar_path, pending_email, status, token_version, created_at, updated_at",
    )
    .bind(request.username.trim())
    .bind(&email)
    .bind(password_hash)
    .fetch_one(&mut *transaction)
    .await
    .map_err(|error: sqlx::Error| {
        if is_unique_violation(&error) {
            AppError::Conflict("用户名或邮箱已存在".to_owned())
        } else {
            AppError::Database(error)
        }
    })?;

    queue_verification_email(&mut transaction, config, &user).await?;
    transaction.commit().await.map_err(AppError::Database)?;
    Ok(user)
}

pub async fn login(
    pool: &PgPool,
    request: &LoginRequest,
    secret: &str,
    expiration_hours: i64,
) -> Result<(User, String), AppError> {
    validate_login(request)?;
    let user = sqlx::query_as::<_, User>(
        "SELECT id, username, email, password_hash, role, email_verified_at, avatar_path, pending_email, status, token_version, created_at, updated_at
         FROM users WHERE username = $1 OR LOWER(email) = LOWER($1)",
    )
    .bind(request.username.trim())
    .fetch_optional(pool)
    .await
    .map_err(AppError::Database)?
    .ok_or(AppError::InvalidCredentials)?;
    if user.status != "active" {
        return Err(AppError::InvalidCredentials);
    }
    if !verify_password(&request.password, &user.password_hash) {
        return Err(AppError::InvalidCredentials);
    }
    let token = create_token(
        user.id,
        &user.role,
        user.token_version,
        secret,
        expiration_hours,
    )?;
    Ok((user, token))
}

pub async fn current_user(pool: &PgPool, id: i32) -> Result<PublicUser, AppError> {
    let user = sqlx::query_as::<_, User>(
        "SELECT id, username, email, password_hash, role, email_verified_at, avatar_path, pending_email, status, token_version, created_at, updated_at
         FROM users WHERE id = $1",
    )
    .bind(id)
    .fetch_optional(pool)
    .await
    .map_err(AppError::Database)?
    .ok_or(AppError::Unauthorized)?;
    Ok(PublicUser::from(&user))
}

pub async fn verify_email(pool: &PgPool, raw_token: &str) -> Result<AuthMessageResponse, AppError> {
    let raw_token = raw_token.trim();
    if raw_token.is_empty() {
        return Err(AppError::BadRequest("验证令牌不能为空".to_owned()));
    }
    let mut transaction = pool.begin().await.map_err(AppError::Database)?;
    let token_hash = hash_token(raw_token);
    let row: Option<(i32, String)> = sqlx::query_as(
        "UPDATE auth_tokens
         SET used_at = CURRENT_TIMESTAMP
         WHERE token_hash = $1
           AND used_at IS NULL
           AND expires_at > CURRENT_TIMESTAMP
         RETURNING user_id, purpose",
    )
    .bind(token_hash)
    .fetch_optional(&mut *transaction)
    .await
    .map_err(AppError::Database)?;
    let (user_id, purpose) =
        row.ok_or_else(|| AppError::BadRequest("链接无效或已过期".to_owned()))?;

    match purpose.as_str() {
        EMAIL_VERIFY_PURPOSE => {
            sqlx::query(
                "UPDATE users
                 SET email_verified_at = COALESCE(email_verified_at, CURRENT_TIMESTAMP),
                     updated_at = CURRENT_TIMESTAMP
                 WHERE id = $1 AND status = 'active'",
            )
            .bind(user_id)
            .execute(&mut *transaction)
            .await
            .map_err(AppError::Database)?;
        }
        EMAIL_CHANGE_PURPOSE => {
            let pending: Option<String> = sqlx::query_scalar(
                "SELECT pending_email FROM users WHERE id = $1 AND status = 'active' FOR UPDATE",
            )
            .bind(user_id)
            .fetch_optional(&mut *transaction)
            .await
            .map_err(AppError::Database)?
            .flatten();
            let new_email =
                pending.ok_or_else(|| AppError::BadRequest("没有待验证的新邮箱".to_owned()))?;
            sqlx::query(
                "UPDATE users
                 SET email = $1,
                     pending_email = NULL,
                     email_verified_at = CURRENT_TIMESTAMP,
                     updated_at = CURRENT_TIMESTAMP
                 WHERE id = $2 AND status = 'active'",
            )
            .bind(&new_email)
            .bind(user_id)
            .execute(&mut *transaction)
            .await
            .map_err(|error: sqlx::Error| {
                if is_unique_violation(&error) {
                    AppError::Conflict("该邮箱已被其他账号使用".to_owned())
                } else {
                    AppError::Database(error)
                }
            })?;
        }
        _ => {
            return Err(AppError::BadRequest("链接类型无效".to_owned()));
        }
    }
    transaction.commit().await.map_err(AppError::Database)?;
    Ok(AuthMessageResponse {
        message: "邮箱验证成功".to_owned(),
    })
}

pub async fn resend_verification(
    pool: &PgPool,
    config: &Config,
    user_id: i32,
) -> Result<ResendVerificationResponse, AppError> {
    let user = sqlx::query_as::<_, User>(
        "SELECT id, username, email, password_hash, role, email_verified_at, avatar_path, pending_email, status, token_version, created_at, updated_at
         FROM users WHERE id = $1",
    )
    .bind(user_id)
    .fetch_optional(pool)
    .await
    .map_err(AppError::Database)?
    .ok_or(AppError::Unauthorized)?;

    if user.email_verified_at.is_some() {
        return Ok(ResendVerificationResponse {
            message: "邮箱已验证".to_owned(),
            email: user.email,
        });
    }

    let elapsed = sqlx::query_scalar::<_, i64>(
        "SELECT COALESCE(EXTRACT(EPOCH FROM (CURRENT_TIMESTAMP - MAX(created_at)))::bigint, 9999)
         FROM auth_tokens WHERE user_id = $1 AND purpose = $2",
    )
    .bind(user.id)
    .bind(EMAIL_VERIFY_PURPOSE)
    .fetch_one(pool)
    .await
    .map_err(AppError::Database)?;
    if elapsed < RESEND_COOLDOWN_SECS as i64 {
        let remaining = RESEND_COOLDOWN_SECS as i64 - elapsed;
        return Err(AppError::RateLimited(
            format!("请 {remaining} 秒后再发送"),
            remaining as u64,
        ));
    }

    let mut transaction = pool.begin().await.map_err(AppError::Database)?;
    queue_verification_email(&mut transaction, config, &user).await?;
    transaction.commit().await.map_err(AppError::Database)?;
    Ok(ResendVerificationResponse {
        message: "验证邮件已发送".to_owned(),
        email: user.email,
    })
}

/// Always returns success for a syntactically valid address so callers cannot
/// probe whether an account exists. The outbox only receives mail for existing
/// accounts.
pub async fn forgot_password(
    pool: &PgPool,
    config: &Config,
    email: &str,
) -> Result<AuthMessageResponse, AppError> {
    let email = email.trim().to_lowercase();
    if email.is_empty() || email.len() > 100 || !email.contains('@') {
        return Err(AppError::BadRequest("邮箱格式无效".to_owned()));
    }
    let user = sqlx::query_as::<_, User>(
        "SELECT id, username, email, password_hash, role, email_verified_at, avatar_path, pending_email, status, token_version, created_at, updated_at
         FROM users WHERE LOWER(email) = $1",
    )
    .bind(&email)
    .fetch_optional(pool)
    .await
    .map_err(AppError::Database)?;
    let Some(user) = user else {
        return Ok(AuthMessageResponse {
            message: "如果邮箱存在，重置邮件已发送".to_owned(),
        });
    };

    let elapsed = sqlx::query_scalar::<_, i64>(
        "SELECT COALESCE(EXTRACT(EPOCH FROM (CURRENT_TIMESTAMP - MAX(created_at)))::bigint, 9999)
         FROM auth_tokens WHERE user_id = $1 AND purpose = $2",
    )
    .bind(user.id)
    .bind(PASSWORD_RESET_PURPOSE)
    .fetch_one(pool)
    .await
    .map_err(AppError::Database)?;
    if elapsed >= RESEND_COOLDOWN_SECS as i64 {
        let mut transaction = pool.begin().await.map_err(AppError::Database)?;
        queue_password_reset_email(&mut transaction, config, &user).await?;
        transaction.commit().await.map_err(AppError::Database)?;
    }

    Ok(AuthMessageResponse {
        message: "如果邮箱存在，重置邮件已发送".to_owned(),
    })
}

pub async fn reset_password(
    pool: &PgPool,
    raw_token: &str,
    password: &str,
) -> Result<AuthMessageResponse, AppError> {
    let raw_token = raw_token.trim();
    if raw_token.is_empty() {
        return Err(AppError::BadRequest("重置令牌不能为空".to_owned()));
    }
    if !(8..=128).contains(&password.len()) {
        return Err(AppError::BadRequest(
            "密码长度必须在 8 到 128 个字符之间".to_owned(),
        ));
    }
    let password_hash = hash_password(password)?;

    let mut transaction = pool.begin().await.map_err(AppError::Database)?;
    let user_id = consume_token(&mut transaction, raw_token, PASSWORD_RESET_PURPOSE).await?;
    sqlx::query(
        "UPDATE users
         SET password_hash = $1,
             token_version = token_version + 1,
             email_verified_at = COALESCE(email_verified_at, CURRENT_TIMESTAMP),
             updated_at = CURRENT_TIMESTAMP
         WHERE id = $2",
    )
    .bind(password_hash)
    .bind(user_id)
    .execute(&mut *transaction)
    .await
    .map_err(AppError::Database)?;
    transaction.commit().await.map_err(AppError::Database)?;
    Ok(AuthMessageResponse {
        message: "密码已重置，请重新登录".to_owned(),
    })
}

pub async fn request_email_change(
    pool: &PgPool,
    config: &Config,
    user_id: i32,
    email: &str,
) -> Result<crate::models::profile::EmailChangeResponse, AppError> {
    let email = email.trim().to_lowercase();
    if email.is_empty() || email.len() > 100 || !email.contains('@') {
        return Err(AppError::BadRequest("邮箱格式无效".to_owned()));
    }
    let user = load_user(pool, user_id).await?;
    if user.status != "active" {
        return Err(AppError::Unauthorized);
    }
    if user.email.eq_ignore_ascii_case(&email) {
        return Err(AppError::BadRequest("新邮箱不能与当前邮箱相同".to_owned()));
    }
    let conflict: bool = sqlx::query_scalar(
        "SELECT EXISTS(
             SELECT 1 FROM users
             WHERE id <> $1 AND (LOWER(email) = $2 OR LOWER(pending_email) = $2)
         )",
    )
    .bind(user_id)
    .bind(&email)
    .fetch_one(pool)
    .await
    .map_err(AppError::Database)?;
    if conflict {
        return Err(AppError::Conflict("该邮箱已被其他账号使用".to_owned()));
    }

    let mut transaction = pool.begin().await.map_err(AppError::Database)?;
    sqlx::query(
        "UPDATE users SET pending_email = $1, updated_at = CURRENT_TIMESTAMP
         WHERE id = $2 AND status = 'active'",
    )
    .bind(&email)
    .bind(user_id)
    .execute(&mut *transaction)
    .await
    .map_err(|error: sqlx::Error| {
        if is_unique_violation(&error) {
            AppError::Conflict("该邮箱已被其他账号使用".to_owned())
        } else {
            AppError::Database(error)
        }
    })?;
    let token = issue_token(
        &mut transaction,
        user_id,
        EMAIL_CHANGE_PURPOSE,
        config.email_verify_ttl_hours * 3600,
    )
    .await?;
    let link = verification_link(&config.frontend_base_url, &token);
    let body = format!(
        "你好 {}：\n\n你正在把 Theseus 账号邮箱修改为 {}，请打开以下链接完成验证：\n{}\n\n链接 {} 小时内有效，如果这不是你的操作，请忽略这封邮件\n",
        user.username, email, link, config.email_verify_ttl_hours
    );
    email_service::enqueue(&mut transaction, &email, "确认你的 Theseus 新邮箱", &body).await?;
    let notice = format!(
        "你好 {}：\n\n你的 Theseus 账号刚刚申请将邮箱修改为 {}，如果这不是你的操作，请立即登录并修改密码\n",
        user.username, email
    );
    email_service::enqueue(
        &mut transaction,
        &user.email,
        "Theseus 邮箱变更提醒",
        &notice,
    )
    .await?;
    transaction.commit().await.map_err(AppError::Database)?;
    Ok(crate::models::profile::EmailChangeResponse {
        message: "验证邮件已发送到新邮箱".to_owned(),
        pending_email: email,
    })
}

pub async fn cancel_email_change(pool: &PgPool, user_id: i32) -> Result<PublicUser, AppError> {
    let mut transaction = pool.begin().await.map_err(AppError::Database)?;
    sqlx::query(
        "UPDATE users SET pending_email = NULL, updated_at = CURRENT_TIMESTAMP
         WHERE id = $1 AND status = 'active'",
    )
    .bind(user_id)
    .execute(&mut *transaction)
    .await
    .map_err(AppError::Database)?;
    sqlx::query(
        "UPDATE auth_tokens SET used_at = CURRENT_TIMESTAMP
         WHERE user_id = $1 AND purpose = $2 AND used_at IS NULL",
    )
    .bind(user_id)
    .bind(EMAIL_CHANGE_PURPOSE)
    .execute(&mut *transaction)
    .await
    .map_err(AppError::Database)?;
    transaction.commit().await.map_err(AppError::Database)?;
    current_user(pool, user_id).await
}

pub async fn change_password(
    pool: &PgPool,
    config: &Config,
    user_id: i32,
    current_password: &str,
    new_password: &str,
) -> Result<crate::models::profile::PasswordChangeResponse, AppError> {
    if !(8..=128).contains(&new_password.len()) {
        return Err(AppError::BadRequest(
            "新密码长度必须在 8 到 128 个字符之间".to_owned(),
        ));
    }
    if current_password == new_password {
        return Err(AppError::BadRequest("新密码不能与当前密码相同".to_owned()));
    }
    let user = load_user(pool, user_id).await?;
    if user.status != "active" {
        return Err(AppError::Unauthorized);
    }
    if !verify_password(current_password, &user.password_hash) {
        return Err(AppError::Unauthorized);
    }
    let password_hash = hash_password(new_password)?;
    let mut transaction = pool.begin().await.map_err(AppError::Database)?;
    let (token_version, role): (i32, String) = sqlx::query_as(
        "UPDATE users
         SET password_hash = $1, token_version = token_version + 1,
             updated_at = CURRENT_TIMESTAMP
         WHERE id = $2 AND status = 'active'
         RETURNING token_version, role",
    )
    .bind(password_hash)
    .bind(user_id)
    .fetch_one(&mut *transaction)
    .await
    .map_err(AppError::Database)?;
    let notice = format!(
        "你好 {}：\n\n你的 Theseus 账号密码刚刚被修改，其他设备已退出登录，如果这不是你的操作，请立即使用找回密码功能\n",
        user.username
    );
    email_service::enqueue(
        &mut transaction,
        &user.email,
        "Theseus 密码变更提醒",
        &notice,
    )
    .await?;
    transaction.commit().await.map_err(AppError::Database)?;
    let token = create_token(
        user_id,
        &role,
        token_version,
        &config.jwt_secret,
        config.jwt_expiration_hours,
    )?;
    let user = current_user(pool, user_id).await?;
    Ok(crate::models::profile::PasswordChangeResponse { token, user })
}

pub async fn logout_all(pool: &PgPool, user_id: i32) -> Result<AuthMessageResponse, AppError> {
    sqlx::query(
        "UPDATE users SET token_version = token_version + 1, updated_at = CURRENT_TIMESTAMP
         WHERE id = $1",
    )
    .bind(user_id)
    .execute(pool)
    .await
    .map_err(AppError::Database)?;
    Ok(AuthMessageResponse {
        message: "已退出所有设备".to_owned(),
    })
}

async fn load_user(pool: &PgPool, user_id: i32) -> Result<User, AppError> {
    sqlx::query_as::<_, User>(
        "SELECT id, username, email, password_hash, role, email_verified_at, avatar_path, pending_email, status, token_version, created_at, updated_at
         FROM users WHERE id = $1",
    )
    .bind(user_id)
    .fetch_optional(pool)
    .await
    .map_err(AppError::Database)?
    .ok_or(AppError::Unauthorized)
}

async fn queue_verification_email(
    transaction: &mut Transaction<'_, Postgres>,
    config: &Config,
    user: &User,
) -> Result<(), AppError> {
    let token = issue_token(
        transaction,
        user.id,
        EMAIL_VERIFY_PURPOSE,
        config.email_verify_ttl_hours * 3600,
    )
    .await?;
    let link = verification_link(&config.frontend_base_url, &token);
    let body = format!(
        "你好 {}：\n\n请打开以下链接验证邮箱：\n{}\n\n链接 {} 小时内有效，如果这不是你的操作，请忽略这封邮件\n",
        user.username, link, config.email_verify_ttl_hours
    );
    email_service::enqueue(transaction, &user.email, "验证你的 Theseus 邮箱", &body).await
}

async fn queue_password_reset_email(
    transaction: &mut Transaction<'_, Postgres>,
    config: &Config,
    user: &User,
) -> Result<(), AppError> {
    let token = issue_token(
        transaction,
        user.id,
        PASSWORD_RESET_PURPOSE,
        config.password_reset_ttl_minutes * 60,
    )
    .await?;
    let link = password_reset_link(&config.frontend_base_url, &token);
    let body = format!(
        "你好 {}：\n\n请打开以下链接重置密码：\n{}\n\n链接 {} 分钟内有效，重置后所有已登录设备需要重新登录，如果这不是你的操作，请忽略这封邮件\n",
        user.username, link, config.password_reset_ttl_minutes
    );
    email_service::enqueue(transaction, &user.email, "重置你的 Theseus 密码", &body).await
}

async fn issue_token(
    transaction: &mut Transaction<'_, Postgres>,
    user_id: i32,
    purpose: &str,
    ttl_secs: i64,
) -> Result<String, AppError> {
    sqlx::query(
        "UPDATE auth_tokens SET used_at = CURRENT_TIMESTAMP
         WHERE user_id = $1 AND purpose = $2 AND used_at IS NULL",
    )
    .bind(user_id)
    .bind(purpose)
    .execute(&mut **transaction)
    .await
    .map_err(AppError::Database)?;

    let raw_token = random_token();
    let token_hash = hash_token(&raw_token);
    let ttl_secs = ttl_secs.clamp(1, i32::MAX as i64) as i32;
    sqlx::query(
        "INSERT INTO auth_tokens (user_id, purpose, token_hash, expires_at)
         VALUES ($1, $2, $3, CURRENT_TIMESTAMP + make_interval(secs => $4::int))",
    )
    .bind(user_id)
    .bind(purpose)
    .bind(token_hash)
    .bind(ttl_secs)
    .execute(&mut **transaction)
    .await
    .map_err(AppError::Database)?;
    Ok(raw_token)
}

async fn consume_token(
    transaction: &mut Transaction<'_, Postgres>,
    raw_token: &str,
    purpose: &str,
) -> Result<i32, AppError> {
    let token_hash = hash_token(raw_token);
    sqlx::query_scalar::<_, i32>(
        "UPDATE auth_tokens
         SET used_at = CURRENT_TIMESTAMP
         WHERE token_hash = $1
           AND purpose = $2
           AND used_at IS NULL
           AND expires_at > CURRENT_TIMESTAMP
         RETURNING user_id",
    )
    .bind(token_hash)
    .bind(purpose)
    .fetch_optional(&mut **transaction)
    .await
    .map_err(AppError::Database)?
    .ok_or_else(|| AppError::BadRequest("链接无效或已过期".to_owned()))
}

fn random_token() -> String {
    let mut bytes = [0u8; 32];
    OsRng.fill_bytes(&mut bytes);
    bytes.iter().map(|byte| format!("{byte:02x}")).collect()
}

fn hash_token(raw_token: &str) -> String {
    let digest = Sha256::digest(raw_token.as_bytes());
    format!("{digest:x}")
}

fn verification_link(base_url: &str, token: &str) -> String {
    format!(
        "{}/verify-email?token={token}",
        base_url.trim_end_matches('/')
    )
}

fn password_reset_link(base_url: &str, token: &str) -> String {
    format!(
        "{}/reset-password?token={token}",
        base_url.trim_end_matches('/')
    )
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
    use super::{
        hash_token, password_reset_link, random_token, validate_login, validate_registration,
        verification_link,
    };
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

    #[test]
    fn tokens_are_random_and_hashable() {
        let first = random_token();
        let second = random_token();
        assert_eq!(first.len(), 64);
        assert_ne!(first, second);
        assert_eq!(hash_token(&first).len(), 64);
        assert_eq!(hash_token(&first), hash_token(&first));
        assert_ne!(hash_token(&first), hash_token(&second));
    }

    #[test]
    fn builds_frontend_links_without_double_slashes() {
        assert_eq!(
            verification_link("http://localhost:5173/", "abc"),
            "http://localhost:5173/verify-email?token=abc"
        );
        assert_eq!(
            password_reset_link("https://theseus.example", "def"),
            "https://theseus.example/reset-password?token=def"
        );
    }
}
