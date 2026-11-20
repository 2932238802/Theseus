use chrono::{DateTime, Utc};
use serde::{Deserialize, Serialize};
use sqlx::FromRow;

pub const MAX_TEMPLATE_TITLE_CHARS: usize = 120;
pub const MAX_TEMPLATE_CONTENT_CHARS: usize = 20_000;

/// 读者端列表项：只返回左侧栏目需要的字段，正文按需加载。
#[derive(Debug, Clone, FromRow, Serialize)]
pub struct InterviewTemplateSummary {
    pub id: i64,
    pub title: String,
    pub sort_order: i32,
    pub updated_at: DateTime<Utc>,
}

/// 详情或管理端条目：包含 Markdown 正文。
#[derive(Debug, Clone, FromRow, Serialize)]
pub struct InterviewTemplateDetail {
    pub id: i64,
    pub title: String,
    pub content_md: String,
    pub sort_order: i32,
    pub created_at: DateTime<Utc>,
    pub updated_at: DateTime<Utc>,
}

#[derive(Debug, Deserialize)]
pub struct InterviewTemplateInput {
    pub title: String,
    pub content_md: String,
}

#[derive(Debug, Deserialize)]
pub struct InterviewTemplateOrderInput {
    pub ids: Vec<i64>,
}

#[derive(Debug, Serialize)]
pub struct InterviewTemplateMutationResponse {
    pub id: i64,
    pub message: String,
}

#[derive(Debug, Serialize)]
pub struct InterviewTemplateOrderResponse {
    pub message: String,
}
