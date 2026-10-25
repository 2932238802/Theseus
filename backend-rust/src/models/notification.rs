use chrono::{DateTime, Utc};
use serde::{Deserialize, Serialize};
use sqlx::FromRow;

#[derive(Debug, Deserialize)]
pub struct NotificationListQuery {
    pub page: Option<u32>,
    pub size: Option<u32>,
    pub unread_only: Option<bool>,
}

#[derive(Debug, Clone, Serialize)]
pub struct NotificationItem {
    pub id: i64,
    #[serde(rename = "type")]
    pub notification_type: String,
    pub title: String,
    pub body: Option<String>,
    pub link: Option<String>,
    pub read: bool,
    pub created_at: DateTime<Utc>,
}

#[derive(Debug, FromRow)]
pub struct NotificationRow {
    pub id: i64,
    pub notification_type: String,
    pub title: String,
    pub body: Option<String>,
    pub link: Option<String>,
    pub read: bool,
    pub created_at: DateTime<Utc>,
    pub total: i64,
}

impl NotificationRow {
    pub fn into_item(self) -> NotificationItem {
        NotificationItem {
            id: self.id,
            notification_type: self.notification_type,
            title: self.title,
            body: self.body,
            link: self.link,
            read: self.read,
            created_at: self.created_at,
        }
    }
}

#[derive(Debug, Serialize)]
pub struct NotificationListResponse {
    pub total: i64,
    pub unread: i64,
    pub page: u32,
    pub size: u32,
    pub notifications: Vec<NotificationItem>,
}

#[derive(Debug, Serialize)]
pub struct UnreadCountResponse {
    pub unread: i64,
}

#[derive(Debug, Serialize)]
pub struct NotificationReadResponse {
    pub id: Option<i64>,
    pub message: String,
}
