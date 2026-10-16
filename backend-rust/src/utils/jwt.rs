use chrono::{Duration, Utc};
use jsonwebtoken::{DecodingKey, EncodingKey, Header, Validation, decode, encode};
use serde::{Deserialize, Serialize};

use crate::common::error::AppError;

#[derive(Debug, Clone, Serialize, Deserialize)]
pub struct Claims {
    pub sub: i32,
    pub role: String,
    pub exp: i64,
    pub iat: i64,
}

pub fn create_token(
    user_id: i32,
    role: &str,
    secret: &str,
    expiration_hours: i64,
) -> Result<String, AppError> {
    let now = Utc::now();
    let claims = Claims {
        sub: user_id,
        role: role.to_owned(),
        iat: now.timestamp(),
        exp: (now + Duration::hours(expiration_hours)).timestamp(),
    };
    encode(
        &Header::default(),
        &claims,
        &EncodingKey::from_secret(secret.as_bytes()),
    )
    .map_err(|error| AppError::Internal(format!("JWT 生成失败: {error}")))
}

pub fn decode_token(token: &str, secret: &str) -> Result<Claims, AppError> {
    decode::<Claims>(
        token,
        &DecodingKey::from_secret(secret.as_bytes()),
        &Validation::default(),
    )
    .map(|data| data.claims)
    .map_err(|_| AppError::Unauthorized)
}

#[cfg(test)]
mod tests {
    use super::{create_token, decode_token};

    #[test]
    fn round_trips_claims() {
        let token = create_token(7, "admin", "a sufficiently long test secret", 1)
            .expect("token should be created");
        let claims =
            decode_token(&token, "a sufficiently long test secret").expect("token should decode");
        assert_eq!(claims.sub, 7);
        assert_eq!(claims.role, "admin");
    }
}
