use serde::{Deserialize, Serialize};

pub const AI_MAX_MESSAGES: usize = 20;
pub const AI_MAX_MESSAGE_CHARS: usize = 4_000;
pub const AI_MAX_CODE_CHARS: usize = 20_000;

#[derive(Debug, Deserialize)]
pub struct AiChatRequest {
    pub problem_id: i32,
    pub language: Option<String>,
    pub code: Option<String>,
    #[serde(default)]
    pub messages: Vec<AiChatMessage>,
}

#[derive(Debug, Clone, Deserialize, Serialize)]
pub struct AiChatMessage {
    pub role: String,
    pub content: String,
}

#[derive(Debug, Serialize)]
pub struct AiChatResponse {
    pub content: String,
    pub daily_limit: i64,
    pub used_today: i64,
}

#[derive(Debug, Serialize)]
pub struct AiStatusResponse {
    /// 服务端是否已配置并开启 AI 助手。
    pub enabled: bool,
    /// 当前账号是否满足 Plus 门槛。
    pub is_plus: bool,
    pub plus_required: bool,
    /// 比赛进行中禁止使用 AI 助手。
    pub contest_locked: bool,
    pub daily_limit: i64,
    pub used_today: i64,
}
