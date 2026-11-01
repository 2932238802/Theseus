use chrono::{DateTime, Utc};
use serde::{Deserialize, Serialize};
use sqlx::FromRow;

#[derive(Debug, Serialize)]
pub struct OAuthProviderItem {
    pub provider: String,
    pub enabled: bool,
}

#[derive(Debug, Serialize)]
pub struct OAuthProvidersResponse {
    pub providers: Vec<OAuthProviderItem>,
}

#[derive(Debug, Default, Deserialize)]
pub struct OAuthStartRequest {
    /// login：未登录时快捷登录；bind：登录后绑定到当前账号
    #[serde(default)]
    pub mode: Option<String>,
    /// 登录成功后的前端路径，只接受同源绝对路径
    #[serde(default)]
    pub redirect: Option<String>,
}

#[derive(Debug, Serialize)]
pub struct OAuthStartResponse {
    pub authorize_url: String,
}

#[derive(Debug, Default, Deserialize)]
pub struct OAuthCallbackQuery {
    #[serde(default)]
    pub code: Option<String>,
    #[serde(default)]
    pub state: Option<String>,
    #[serde(default)]
    pub error: Option<String>,
}

#[derive(Debug, Deserialize)]
pub struct OAuthExchangeRequest {
    pub code: String,
}

#[derive(Debug, Serialize, FromRow)]
pub struct OAuthBindingItem {
    pub provider: String,
    pub login_name: String,
    pub display_name: Option<String>,
    pub email: Option<String>,
    pub created_at: DateTime<Utc>,
    pub last_login_at: Option<DateTime<Utc>>,
}

#[derive(Debug, Serialize)]
pub struct OAuthBindingsResponse {
    pub bindings: Vec<OAuthBindingItem>,
}

#[derive(Debug, Deserialize)]
pub struct OAuthUnbindRequest {
    pub password: String,
}

#[derive(Debug, Serialize)]
pub struct OAuthUnbindResponse {
    pub message: String,
}
