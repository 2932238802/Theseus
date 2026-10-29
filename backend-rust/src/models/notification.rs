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
    #[serde(skip_serializing_if = "Option::is_none")]
    pub related_type: Option<String>,
    #[serde(skip_serializing_if = "Option::is_none")]
    pub related_id: Option<i64>,
    /// 仅 class_invite 通知返回：邀请当前的 pending/accepted/... 状态。
    #[serde(skip_serializing_if = "Option::is_none")]
    pub invitation_status: Option<String>,
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
    pub related_type: Option<String>,
    pub related_id: Option<i64>,
    pub invitation_status: Option<String>,
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
            related_type: self.related_type,
            related_id: self.related_id,
            invitation_status: self.invitation_status,
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

/// 自定义站内通知。受众三选一：
/// - 教师：class_id（可选 user_ids 限定本组织成员）
/// - 管理员：user_ids / role / all
#[derive(Debug, Deserialize)]
pub struct SendNotificationRequest {
    pub title: String,
    #[serde(default)]
    pub body: Option<String>,
    #[serde(default)]
    pub link: Option<String>,
    #[serde(default)]
    pub class_id: Option<i32>,
    #[serde(default)]
    pub user_ids: Option<Vec<i32>>,
    #[serde(default)]
    pub role: Option<String>,
    #[serde(default)]
    pub all: Option<bool>,
}

#[derive(Debug, Serialize)]
pub struct SendNotificationResponse {
    pub recipient_count: u64,
    pub message: String,
}

/// 通知偏好按「类别 + 渠道」保存；当前只开放邮件渠道，站内信始终接收。
#[derive(Debug, Serialize)]
pub struct NotificationPreferenceView {
    pub category: String,
    pub channel: String,
    pub enabled: bool,
}

#[derive(Debug, Serialize)]
pub struct NotificationPreferencesResponse {
    pub email: String,
    pub email_verified: bool,
    pub preferences: Vec<NotificationPreferenceView>,
}

#[derive(Debug, Deserialize)]
pub struct UpdateNotificationPreferencesRequest {
    pub preferences: Vec<NotificationPreferenceUpdate>,
}

#[derive(Debug, Deserialize)]
pub struct NotificationPreferenceUpdate {
    pub category: String,
    pub enabled: bool,
}
