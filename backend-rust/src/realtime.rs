//! 进程内实时推送。
//!
//! 当前部署是单 API 实例，所以直接用 `tokio::sync::broadcast` 按用户广播；
//! 多实例部署时把 `publish` 换成 Redis Pub/Sub 即可，连接、票据和事件格式不变。
//! WebSocket 只是传输层：事件丢了由客户端重新拉取 REST 快照补齐。

use std::{
    collections::HashMap,
    sync::{
        Arc, Mutex,
        atomic::{AtomicU64, Ordering},
    },
    time::{Duration, Instant},
};

use chrono::{DateTime, Utc};
use rand::{Rng, distributions::Alphanumeric};
use serde::Serialize;
use serde_json::Value;
use tokio::sync::broadcast;

use crate::models::notification::NotificationItem;

/// 连接票据的有效期：只够完成一次握手。
pub const TICKET_TTL: Duration = Duration::from_secs(60);
const TICKET_LENGTH: usize = 48;
const CHANNEL_CAPACITY: usize = 64;

#[derive(Clone)]
pub struct RealtimeHub {
    inner: Arc<HubInner>,
}

struct HubInner {
    channels: Mutex<HashMap<i32, broadcast::Sender<RealtimeEvent>>>,
    tickets: Mutex<HashMap<String, Ticket>>,
    next_event_id: AtomicU64,
}

struct Ticket {
    user_id: i32,
    expires_at: Instant,
}

#[derive(Clone, Debug, Serialize)]
pub struct RealtimeEvent {
    #[serde(skip)]
    pub user_id: i32,
    /// 服务端单调递增的事件序号，客户端可用于去重。
    pub id: u64,
    #[serde(rename = "type")]
    pub event_type: String,
    pub data: Value,
    pub server_time: DateTime<Utc>,
}

impl Default for RealtimeHub {
    fn default() -> Self {
        Self::new()
    }
}

impl RealtimeHub {
    pub fn new() -> Self {
        Self {
            inner: Arc::new(HubInner {
                channels: Mutex::new(HashMap::new()),
                tickets: Mutex::new(HashMap::new()),
                next_event_id: AtomicU64::new(1),
            }),
        }
    }

    /// 签发一次性连接票据。浏览器 WebSocket 不能带 Authorization 头，
    /// 所以先用 REST 换票据，再在握手 URL 里携带。
    pub fn issue_ticket(&self, user_id: i32) -> String {
        let ticket: String = rand::thread_rng()
            .sample_iter(&Alphanumeric)
            .take(TICKET_LENGTH)
            .map(char::from)
            .collect();
        let mut tickets = self.lock_tickets();
        let now = Instant::now();
        tickets.retain(|_, entry| entry.expires_at > now);
        tickets.insert(
            ticket.clone(),
            Ticket {
                user_id,
                expires_at: now + TICKET_TTL,
            },
        );
        ticket
    }

    /// 校验并消费票据，重复使用会被拒绝。
    pub fn consume_ticket(&self, ticket: &str) -> Option<i32> {
        let mut tickets = self.lock_tickets();
        let entry = tickets.remove(ticket)?;
        (entry.expires_at > Instant::now()).then_some(entry.user_id)
    }

    pub fn subscribe(&self, user_id: i32) -> broadcast::Receiver<RealtimeEvent> {
        let mut channels = self.lock_channels();
        let sender = channels
            .entry(user_id)
            .or_insert_with(|| broadcast::channel(CHANNEL_CAPACITY).0);
        // 上一个连接可能已经断开，顺手回收空频道。
        if sender.receiver_count() == 0 {
            *sender = broadcast::channel(CHANNEL_CAPACITY).0;
        }
        sender.subscribe()
    }

    /// 连接结束时调用；没有其他接收者则移除频道，避免用户表无限增长。
    pub fn prune(&self, user_id: i32) {
        let mut channels = self.lock_channels();
        if channels
            .get(&user_id)
            .is_some_and(|sender| sender.receiver_count() == 0)
        {
            channels.remove(&user_id);
        }
    }

    /// 服务关闭时清空频道，让所有 WebSocket 连接退出，
    /// 否则 axum 的优雅关闭会一直等待长连接。
    pub fn shutdown(&self) {
        self.lock_channels().clear();
    }

    /// 给单个用户推送事件；离线用户直接丢弃，站内信仍以数据库为准。
    pub fn publish(&self, user_id: i32, event_type: &str, data: Value) {
        let event = RealtimeEvent {
            user_id,
            id: self.inner.next_event_id.fetch_add(1, Ordering::Relaxed),
            event_type: event_type.to_owned(),
            data,
            server_time: Utc::now(),
        };
        let mut channels = self.lock_channels();
        let Some(sender) = channels.get(&user_id) else {
            return;
        };
        if sender.send(event).is_err() {
            channels.remove(&user_id);
        }
    }

    pub fn publish_to(&self, user_ids: &[i32], event_type: &str, data: &Value) {
        for user_id in user_ids {
            self.publish(*user_id, event_type, data.clone());
        }
    }

    pub fn publish_notification(&self, user_id: i32, item: &NotificationItem) {
        match serde_json::to_value(item) {
            Ok(data) => self.publish(user_id, "notification.new", data),
            Err(error) => tracing::error!(error = %error, "failed to serialize notification event"),
        }
    }

    fn lock_channels(
        &self,
    ) -> std::sync::MutexGuard<'_, HashMap<i32, broadcast::Sender<RealtimeEvent>>> {
        self.inner
            .channels
            .lock()
            .unwrap_or_else(|poisoned| poisoned.into_inner())
    }

    fn lock_tickets(&self) -> std::sync::MutexGuard<'_, HashMap<String, Ticket>> {
        self.inner
            .tickets
            .lock()
            .unwrap_or_else(|poisoned| poisoned.into_inner())
    }
}

#[cfg(test)]
mod tests {
    use super::*;
    use serde_json::json;

    #[test]
    fn ticket_is_single_use() {
        let hub = RealtimeHub::new();
        let ticket = hub.issue_ticket(7);
        assert_eq!(hub.consume_ticket(&ticket), Some(7));
        assert_eq!(hub.consume_ticket(&ticket), None);
    }

    #[test]
    fn unknown_ticket_is_rejected() {
        let hub = RealtimeHub::new();
        assert_eq!(hub.consume_ticket("not-a-ticket"), None);
    }

    #[tokio::test]
    async fn publish_reaches_only_the_target_user() {
        let hub = RealtimeHub::new();
        let mut alice = hub.subscribe(1);
        let mut bob = hub.subscribe(2);

        hub.publish(1, "match.found", json!({"contest_id": 42}));

        let event = alice.recv().await.expect("alice receives the event");
        assert_eq!(event.event_type, "match.found");
        assert_eq!(event.data["contest_id"], 42);
        assert!(bob.try_recv().is_err());
    }

    #[tokio::test]
    async fn publish_to_multiple_users() {
        let hub = RealtimeHub::new();
        let mut first = hub.subscribe(1);
        let mut second = hub.subscribe(2);

        hub.publish_to(&[1, 2], "match.found", &json!({"contest_id": 9}));

        assert_eq!(first.recv().await.unwrap().data["contest_id"], 9);
        assert_eq!(second.recv().await.unwrap().data["contest_id"], 9);
    }
}
