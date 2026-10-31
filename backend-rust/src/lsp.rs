//! LSP（语言服务）票据与启动参数。
//!
//! 浏览器先带登录 JWT 换取一张短期票据，再用票据连接 `lsp_gateway`。
//! 票据是一个独立签名的 JWT，网关无需访问数据库即可校验。

use std::env;

use chrono::{Duration, Utc};
use jsonwebtoken::{DecodingKey, EncodingKey, Header, Validation, decode, encode};
use serde::{Deserialize, Serialize};

use crate::common::error::AppError;

/// 连接票据有效期：只够完成一次 WebSocket 握手。
pub const TICKET_TTL_SECS: i64 = 60;

/// 当前只开放 C++ 与 Python；其它语言在前端直接置灰。
pub const SUPPORTED_LANGUAGES: [&str; 2] = ["cpp", "python"];

#[derive(Debug, Clone, Serialize, Deserialize)]
pub struct TicketClaims {
    pub sub: i32,
    pub purpose: String,
    pub lang: String,
    pub iat: i64,
    pub exp: i64,
}

/// 统一语言标识，避免前端传 `C++`、`c++` 等写法。
pub fn normalize_language(value: &str) -> Option<&'static str> {
    match value.trim().to_ascii_lowercase().as_str() {
        "cpp" | "c++" => Some("cpp"),
        "python" | "python3" => Some("python"),
        _ => None,
    }
}

pub fn is_supported(language: &str) -> bool {
    SUPPORTED_LANGUAGES.contains(&language)
}

pub fn issue_ticket(
    user_id: i32,
    language: &str,
    secret: &str,
    ttl_secs: i64,
) -> Result<String, AppError> {
    let now = Utc::now();
    let claims = TicketClaims {
        sub: user_id,
        purpose: "lsp".to_owned(),
        lang: language.to_owned(),
        iat: now.timestamp(),
        exp: (now + Duration::seconds(ttl_secs)).timestamp(),
    };
    encode(
        &Header::default(),
        &claims,
        &EncodingKey::from_secret(secret.as_bytes()),
    )
    .map_err(|error| AppError::Internal(format!("LSP 票据生成失败: {error}")))
}

pub fn verify_ticket(token: &str, secret: &str) -> Result<TicketClaims, AppError> {
    let claims = decode::<TicketClaims>(
        token,
        &DecodingKey::from_secret(secret.as_bytes()),
        &Validation::default(),
    )
    .map_err(|_| AppError::Unauthorized)?
    .claims;
    if claims.purpose != "lsp" || !is_supported(&claims.lang) {
        return Err(AppError::Unauthorized);
    }
    Ok(claims)
}

/// 语言服务器命令。本地开发可直接用系统安装的 clangd / pyright-langserver，
/// 生产环境由 lsp 容器提供。
#[derive(Debug, Clone)]
pub struct ServerCommand {
    pub program: String,
    pub args: Vec<String>,
}

pub fn server_command(language: &str) -> Option<ServerCommand> {
    match language {
        "cpp" => Some(ServerCommand {
            program: env::var("LSP_CPP_COMMAND").unwrap_or_else(|_| "clangd".to_owned()),
            args: env_args(
                "LSP_CPP_ARGS",
                &["--background-index=false", "--clang-tidy=false"],
            ),
        }),
        "python" => Some(ServerCommand {
            program: env::var("LSP_PYTHON_COMMAND")
                .unwrap_or_else(|_| "pyright-langserver".to_owned()),
            args: env_args("LSP_PYTHON_ARGS", &["--stdio"]),
        }),
        _ => None,
    }
}

fn env_args(key: &str, default: &[&str]) -> Vec<String> {
    let value = env::var(key).unwrap_or_else(|_| default.join(" "));
    value
        .split_whitespace()
        .map(str::to_owned)
        .collect::<Vec<_>>()
}

#[cfg(test)]
mod tests {
    use super::{issue_ticket, normalize_language, verify_ticket};

    #[test]
    fn normalizes_language_aliases() {
        assert_eq!(normalize_language("C++"), Some("cpp"));
        assert_eq!(normalize_language("python3"), Some("python"));
        assert_eq!(normalize_language("java"), None);
    }

    #[test]
    fn round_trips_ticket() {
        let secret = "a sufficiently long test secret";
        let token = issue_ticket(7, "cpp", secret, 60).expect("ticket");
        let claims = verify_ticket(&token, secret).expect("claims");
        assert_eq!(claims.sub, 7);
        assert_eq!(claims.lang, "cpp");
    }

    #[test]
    fn rejects_non_lsp_purpose() {
        let secret = "a sufficiently long test secret";
        let token = issue_ticket(7, "java", secret, 60).expect("ticket");
        assert!(verify_ticket(&token, secret).is_err());
    }
}
