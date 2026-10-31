use chrono::{DateTime, Utc};
use serde::{Deserialize, Serialize};

pub const CATEGORY_408: &str = "408";
pub const CATEGORY_INTERVIEW: &str = "interview";

pub const KNOWLEDGE_STATUS_PENDING: &str = "pending";
pub const KNOWLEDGE_STATUS_APPROVED: &str = "approved";
pub const KNOWLEDGE_STATUS_REJECTED: &str = "rejected";

pub const MAX_TITLE_CHARS: usize = 120;
pub const MAX_SUMMARY_CHARS: usize = 300;
pub const MAX_CONTENT_CHARS: usize = 20_000;
pub const MAX_TAGS: usize = 8;
pub const MAX_TAG_CHARS: usize = 20;
pub const MAX_NOTE_CHARS: usize = 500;

pub fn is_known_category(value: &str) -> bool {
    matches!(value, CATEGORY_408 | CATEGORY_INTERVIEW)
}

pub fn category_label(value: &str) -> &str {
    match value {
        CATEGORY_408 => "408",
        CATEGORY_INTERVIEW => "面经",
        _ => "学习",
    }
}

/// 列表中的文章信息，不包含正文。
#[derive(Debug, Clone, Serialize)]
pub struct KnowledgeArticleSummary {
    pub id: i64,
    pub category: String,
    pub title: String,
    pub summary: String,
    pub tags: Vec<String>,
    pub author: Option<String>,
    pub status: String,
    pub created_at: DateTime<Utc>,
    pub updated_at: DateTime<Utc>,
}

/// 文章详情。非 Plus 用户查看已通过文章时 `locked = true`，`content` 为 `null`。
#[derive(Debug, Serialize)]
pub struct KnowledgeArticleDetail {
    pub id: i64,
    pub category: String,
    pub title: String,
    pub summary: String,
    pub tags: Vec<String>,
    pub author: Option<String>,
    pub status: String,
    pub created_at: DateTime<Utc>,
    pub updated_at: DateTime<Utc>,
    pub content: Option<String>,
    pub locked: bool,
    pub is_mine: bool,
    pub can_edit: bool,
    pub review_note: Option<String>,
    pub reviewed_by: Option<String>,
    pub reviewed_at: Option<DateTime<Utc>>,
}

#[derive(Debug, Deserialize)]
pub struct KnowledgeArticleInput {
    pub category: String,
    #[serde(default)]
    pub title: String,
    #[serde(default)]
    pub summary: Option<String>,
    #[serde(default)]
    pub content: String,
    #[serde(default)]
    pub tags: Vec<String>,
}

#[derive(Debug, Deserialize)]
pub struct KnowledgeArticleUpdate {
    #[serde(default)]
    pub title: String,
    #[serde(default)]
    pub summary: Option<String>,
    #[serde(default)]
    pub content: String,
    #[serde(default)]
    pub tags: Vec<String>,
}

#[derive(Debug, Deserialize)]
pub struct KnowledgeListQuery {
    #[serde(default)]
    pub category: Option<String>,
    #[serde(default)]
    pub tag: Option<String>,
    #[serde(default)]
    pub q: Option<String>,
    #[serde(default)]
    pub page: Option<u32>,
    #[serde(default)]
    pub size: Option<u32>,
}

#[derive(Debug, Deserialize)]
pub struct MyKnowledgeQuery {
    #[serde(default)]
    pub category: Option<String>,
    #[serde(default)]
    pub status: Option<String>,
    #[serde(default)]
    pub page: Option<u32>,
    #[serde(default)]
    pub size: Option<u32>,
}

#[derive(Debug, Deserialize)]
pub struct AdminKnowledgeQuery {
    #[serde(default)]
    pub category: Option<String>,
    #[serde(default)]
    pub status: Option<String>,
    #[serde(default)]
    pub q: Option<String>,
    #[serde(default)]
    pub page: Option<u32>,
    #[serde(default)]
    pub size: Option<u32>,
}

#[derive(Debug, Deserialize)]
pub struct KnowledgeResolveInput {
    pub status: String,
    #[serde(default)]
    pub note: Option<String>,
}

#[derive(Debug, Serialize)]
pub struct KnowledgeListResponse {
    pub total: i64,
    pub page: u32,
    pub size: u32,
    pub items: Vec<KnowledgeArticleSummary>,
    pub is_plus: bool,
    pub can_submit: bool,
}

#[derive(Debug, Serialize)]
pub struct KnowledgeResolveResponse {
    pub status: String,
    pub message: String,
}

#[derive(Debug, Serialize)]
pub struct KnowledgeMutationResponse {
    pub message: String,
}
