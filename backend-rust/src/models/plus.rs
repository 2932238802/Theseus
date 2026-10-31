use chrono::{DateTime, Utc};
use serde::{Deserialize, Serialize};

pub const PLUS_STATUS_PENDING: &str = "pending";
pub const PLUS_STATUS_APPROVED: &str = "approved";
pub const PLUS_STATUS_REJECTED: &str = "rejected";

/// 一条 Plus 开通申请。`reviewed_by` 是审核员用户名，而非 id。
#[derive(Debug, Clone, Serialize)]
pub struct PlusApplicationItem {
    pub id: i64,
    pub user_id: i32,
    pub username: String,
    pub reason: String,
    pub status: String,
    pub review_note: Option<String>,
    pub reviewed_by: Option<String>,
    pub reviewed_at: Option<DateTime<Utc>>,
    pub created_at: DateTime<Utc>,
}

/// 当前用户的开通状态：最近一条申请 + 是否已开通。
#[derive(Debug, Serialize)]
pub struct MyPlusStateResponse {
    pub is_plus: bool,
    #[serde(skip_serializing_if = "Option::is_none")]
    pub application: Option<PlusApplicationItem>,
}

#[derive(Debug, Deserialize)]
pub struct PlusApplicationInput {
    #[serde(default)]
    pub reason: String,
}

#[derive(Debug, Deserialize)]
pub struct PlusApplicationResolveInput {
    pub status: String,
    #[serde(default)]
    pub note: Option<String>,
}

#[derive(Debug, Deserialize)]
pub struct PlusApplicationQuery {
    #[serde(default)]
    pub status: Option<String>,
    #[serde(default)]
    pub page: Option<u32>,
    #[serde(default)]
    pub size: Option<u32>,
}

#[derive(Debug, Serialize)]
pub struct PlusApplicationListResponse {
    pub total: i64,
    pub page: u32,
    pub size: u32,
    pub items: Vec<PlusApplicationItem>,
}

#[derive(Debug, Serialize)]
pub struct PlusApplicationResolveResponse {
    pub status: String,
    pub message: String,
}
