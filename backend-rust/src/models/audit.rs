use chrono::{DateTime, Utc};
use serde::{Deserialize, Serialize};
use serde_json::Value;
use sqlx::FromRow;

/// 审计日志查询。`from`/`to` 接受 `YYYY-MM-DD` 或 RFC3339，服务层统一转为 UTC。
#[derive(Debug, Deserialize)]
pub struct AuditLogQuery {
    pub page: Option<u32>,
    pub size: Option<u32>,
    pub action: Option<String>,
    pub target_type: Option<String>,
    pub actor_id: Option<i32>,
    pub q: Option<String>,
    pub from: Option<String>,
    pub to: Option<String>,
}

#[derive(Debug, FromRow, Serialize)]
pub struct AuditLogItem {
    pub id: i64,
    pub actor_id: Option<i32>,
    pub actor_username: String,
    pub actor_role: String,
    pub action: String,
    pub target_type: String,
    pub target_id: Option<i64>,
    pub summary: String,
    pub before: Option<Value>,
    pub after: Option<Value>,
    pub ip: Option<String>,
    pub user_agent: Option<String>,
    pub created_at: DateTime<Utc>,
}

#[derive(Debug, Serialize)]
pub struct AuditLogListResponse {
    pub total: i64,
    pub page: u32,
    pub size: u32,
    pub logs: Vec<AuditLogItem>,
}

#[derive(Debug, FromRow, Serialize)]
pub struct AuditMetaCount {
    pub value: String,
    pub count: i64,
}

#[derive(Debug, Serialize)]
pub struct AuditMetaResponse {
    pub actions: Vec<AuditMetaCount>,
    pub target_types: Vec<AuditMetaCount>,
    pub total: i64,
}
