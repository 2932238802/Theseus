use std::time::{Duration, Instant};

use axum::{
    extract::{
        Query, State,
        ws::{Message, WebSocket, WebSocketUpgrade},
    },
    http::HeaderMap,
    response::{IntoResponse, Response},
};
use chrono::Utc;
use serde::Deserialize;
use serde_json::{Value, json};
use tokio::sync::broadcast;

use crate::{
    AppState,
    common::{error::AppError, response::ok},
    middleware::auth::authenticate,
    realtime::{RealtimeEvent, RealtimeHub, TICKET_TTL},
};

/// 客户端 30 秒没有消息就判定连接已死；期间服务端每 30 秒发一次应用层 ping。
const IDLE_TIMEOUT: Duration = Duration::from_secs(90);
const PING_INTERVAL: Duration = Duration::from_secs(30);

#[derive(Debug, Deserialize)]
pub struct TicketQuery {
    pub ticket: String,
}

#[derive(Debug, serde::Serialize)]
pub struct TicketResponse {
    pub ticket: String,
    pub expires_in_seconds: u64,
}

pub async fn issue_ticket(
    State(state): State<AppState>,
    headers: HeaderMap,
) -> Result<impl IntoResponse, AppError> {
    // 通知铃铛对未验证邮箱的用户同样可用，因此这里只校验登录态。
    let user = authenticate(&state.pool, &headers, &state.config).await?;
    let ticket = state.realtime.issue_ticket(user.id);
    Ok(ok(TicketResponse {
        ticket,
        expires_in_seconds: TICKET_TTL.as_secs(),
    }))
}

pub async fn connect(
    State(state): State<AppState>,
    Query(query): Query<TicketQuery>,
    ws: WebSocketUpgrade,
) -> Result<Response, AppError> {
    let Some(user_id) = state.realtime.consume_ticket(&query.ticket) else {
        return Err(AppError::Unauthorized);
    };
    let hub = state.realtime.clone();
    Ok(ws.on_upgrade(move |socket| handle_socket(socket, hub, user_id)))
}

async fn handle_socket(mut socket: WebSocket, hub: RealtimeHub, user_id: i32) {
    let mut receiver = hub.subscribe(user_id);
    let mut ticker = tokio::time::interval(PING_INTERVAL);
    ticker.set_missed_tick_behavior(tokio::time::MissedTickBehavior::Delay);
    let mut last_message = Instant::now();

    loop {
        tokio::select! {
            incoming = socket.recv() => {
                match incoming {
                    Some(Ok(Message::Text(text))) => {
                        last_message = Instant::now();
                        if let Some(reply) = handle_client_message(text.as_str(), user_id)
                            && send_json(&mut socket, &reply).await.is_err()
                        {
                            break;
                        }
                    }
                    Some(Ok(Message::Binary(_))) => {
                        last_message = Instant::now();
                    }
                    Some(Ok(Message::Ping(_) | Message::Pong(_))) => {
                        last_message = Instant::now();
                    }
                    Some(Ok(Message::Close(_))) | Some(Err(_)) | None => break,
                }
            }
            event = receiver.recv() => {
                match event {
                    Ok(event) => {
                        if send_event(&mut socket, &event).await.is_err() {
                            break;
                        }
                    }
                    Err(broadcast::error::RecvError::Lagged(_)) => {
                        // 事件积压时丢弃中间事件，让客户端重新拉取快照。
                        if send_json(&mut socket, &json!({"type": "resync", "data": {}}))
                            .await
                            .is_err()
                        {
                            break;
                        }
                    }
                    Err(broadcast::error::RecvError::Closed) => break,
                }
            }
            _ = ticker.tick() => {
                if last_message.elapsed() > IDLE_TIMEOUT {
                    break;
                }
                if send_json(&mut socket, &json!({"type": "ping", "data": {}}))
                    .await
                    .is_err()
                {
                    break;
                }
            }
        }
    }

    hub.prune(user_id);
}

/// 当前协议只有 `hello` 需要应答；`pong`、未知类型只用于刷新连接活跃时间。
fn handle_client_message(text: &str, user_id: i32) -> Option<Value> {
    let message: Value = serde_json::from_str(text).ok()?;
    match message.get("type").and_then(Value::as_str) {
        Some("hello") => Some(json!({
            "type": "ready",
            "data": {
                "user_id": user_id,
                "server_time": Utc::now(),
            },
            "server_time": Utc::now(),
        })),
        _ => None,
    }
}

async fn send_event(socket: &mut WebSocket, event: &RealtimeEvent) -> Result<(), axum::Error> {
    let payload = serde_json::to_string(event).unwrap_or_else(|_| "{}".to_owned());
    socket.send(Message::Text(payload.into())).await
}

async fn send_json(socket: &mut WebSocket, payload: &Value) -> Result<(), axum::Error> {
    socket.send(Message::Text(payload.to_string().into())).await
}
