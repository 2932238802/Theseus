//! LSP WebSocket 网关：校验一次性票据，为每个连接启动一个语言服务器进程，
//! 在 WebSocket 与服务器的 stdio 之间转发 JSON-RPC 消息。
//!
//! 与 API 共用 `JWT_SECRET`，但独立部署（默认监听 3001），
//! 由前端 Nginx 把 `/api/lsp/ws` 反代到这里。

use std::{env, net::SocketAddr, path::Path, process::Stdio, sync::Arc};

use axum::{
    Json, Router,
    extract::{
        Query, State,
        ws::{Message, WebSocket, WebSocketUpgrade},
    },
    http::StatusCode,
    response::{IntoResponse, Response},
    routing::get,
};
use backend_rust::lsp;
use rand::{Rng, distributions::Alphanumeric};
use serde::Deserialize;
use serde_json::json;
use tokio::{
    io::{AsyncBufReadExt, AsyncRead, AsyncReadExt, AsyncWrite, AsyncWriteExt, BufReader},
    net::TcpListener,
    process::{Child, ChildStderr, Command},
    sync::{Semaphore, broadcast},
};
use tracing::{debug, info, warn};

/// 单条 JSON-RPC 消息上限，防止异常消息占满内存。
const MAX_MESSAGE_BYTES: usize = 16 * 1024 * 1024;

#[derive(Clone)]
struct GatewayState {
    secret: Arc<String>,
    sessions: Arc<Semaphore>,
    shutdown: broadcast::Sender<()>,
}

#[derive(Debug, Deserialize)]
struct WsQuery {
    ticket: String,
}

#[tokio::main]
async fn main() -> Result<(), Box<dyn std::error::Error>> {
    dotenvy::dotenv().ok();
    tracing_subscriber::fmt()
        .with_env_filter(
            tracing_subscriber::EnvFilter::try_from_default_env().unwrap_or_else(|_| "info".into()),
        )
        .init();

    let secret = env::var("JWT_SECRET")?;
    let bind_address: SocketAddr = env::var("LSP_BIND_ADDRESS")
        .unwrap_or_else(|_| "0.0.0.0:3001".to_owned())
        .parse()?;
    let max_sessions = env::var("LSP_MAX_SESSIONS")
        .ok()
        .and_then(|value| value.parse::<usize>().ok())
        .unwrap_or(4)
        .max(1);

    let (shutdown, _) = broadcast::channel(1);
    let state = GatewayState {
        secret: Arc::new(secret),
        sessions: Arc::new(Semaphore::new(max_sessions)),
        shutdown: shutdown.clone(),
    };
    let app = Router::new()
        .route("/healthz", get(healthz))
        .route("/readyz", get(readyz))
        .route("/api/lsp/ws", get(connect))
        .with_state(state);

    let listener = TcpListener::bind(bind_address).await?;
    info!(%bind_address, max_sessions, "Theseus LSP gateway listening");
    axum::serve(listener, app)
        .with_graceful_shutdown(shutdown_signal(shutdown))
        .await?;
    Ok(())
}

/// 收到 Ctrl+C / SIGTERM 时通知所有会话退出，让语言服务器进程随之结束。
async fn shutdown_signal(shutdown: broadcast::Sender<()>) {
    let ctrl_c = async {
        let _ = tokio::signal::ctrl_c().await;
    };
    #[cfg(unix)]
    let terminate = async {
        use tokio::signal::unix::{SignalKind, signal};
        match signal(SignalKind::terminate()) {
            Ok(mut stream) => {
                stream.recv().await;
            }
            Err(_) => std::future::pending::<()>().await,
        }
    };
    #[cfg(not(unix))]
    let terminate = std::future::pending::<()>();

    tokio::select! {
        _ = ctrl_c => {}
        _ = terminate => {}
    }
    info!("shutting down LSP gateway");
    let _ = shutdown.send(());
}

async fn healthz() -> &'static str {
    "ok"
}

async fn readyz() -> Json<serde_json::Value> {
    Json(json!({
        "cpp": command_exists(&server_program("cpp")),
        "python": command_exists(&server_program("python")),
    }))
}

fn server_program(language: &str) -> String {
    lsp::server_command(language)
        .map(|command| command.program)
        .unwrap_or_default()
}

fn command_exists(program: &str) -> bool {
    if program.is_empty() {
        return false;
    }
    if program.contains('/') {
        return Path::new(program).is_file();
    }
    env::var_os("PATH").is_some_and(|paths| {
        env::split_paths(&paths).any(|directory| directory.join(program).is_file())
    })
}

async fn connect(
    State(state): State<GatewayState>,
    Query(query): Query<WsQuery>,
    ws: WebSocketUpgrade,
) -> Response {
    let claims = match lsp::verify_ticket(&query.ticket, &state.secret) {
        Ok(claims) => claims,
        Err(_) => return (StatusCode::UNAUTHORIZED, "invalid ticket").into_response(),
    };
    // 每个连接占一个语言服务器进程名额；超出直接拒绝，避免拖垮整机。
    let permit = match state.sessions.clone().try_acquire_owned() {
        Ok(permit) => permit,
        Err(_) => {
            return (StatusCode::SERVICE_UNAVAILABLE, "language service is busy").into_response();
        }
    };
    let language = claims.lang.clone();
    let user_id = claims.sub;
    let mut shutdown = state.shutdown.subscribe();
    ws.on_upgrade(move |socket| async move {
        if let Err(error) = run_session(socket, &language, user_id, &mut shutdown).await {
            warn!(language = %language, user_id, error = %error, "LSP session ended with error");
        }
        drop(permit);
    })
}

async fn run_session(
    mut socket: WebSocket,
    language: &str,
    user_id: i32,
    shutdown: &mut broadcast::Receiver<()>,
) -> Result<(), String> {
    let command = lsp::server_command(language).ok_or_else(|| "unsupported language".to_owned())?;
    let workspace = env::temp_dir().join(format!("theseus-lsp-{user_id}-{}", random_suffix()));
    tokio::fs::create_dir_all(&workspace)
        .await
        .map_err(|error| format!("workspace create failed: {error}"))?;

    let mut child = match Command::new(&command.program)
        .args(&command.args)
        .current_dir(&workspace)
        .stdin(Stdio::piped())
        .stdout(Stdio::piped())
        .stderr(Stdio::piped())
        .kill_on_drop(true)
        .spawn()
    {
        Ok(child) => child,
        Err(error) => {
            let _ = tokio::fs::remove_dir_all(&workspace).await;
            return Err(format!("failed to start {}: {error}", command.program));
        }
    };

    let result = proxy(&mut socket, &mut child, language, &workspace, shutdown).await;

    // 关闭 stdin 让服务器自行退出，超时后强制结束，避免残留进程。
    if let Some(stdin) = child.stdin.take() {
        drop(stdin);
    }
    if let Err(error) = child.start_kill() {
        debug!(error = %error, "language server already stopped");
    }
    let _ = child.wait().await;
    let _ = tokio::fs::remove_dir_all(&workspace).await;
    result
}

async fn proxy(
    socket: &mut WebSocket,
    child: &mut Child,
    language: &str,
    workspace: &Path,
    shutdown: &mut broadcast::Receiver<()>,
) -> Result<(), String> {
    let mut stdin = child
        .stdin
        .take()
        .ok_or_else(|| "language server stdin unavailable".to_owned())?;
    let stdout = child
        .stdout
        .take()
        .ok_or_else(|| "language server stdout unavailable".to_owned())?;
    if let Some(stderr) = child.stderr.take() {
        tokio::spawn(log_stderr(stderr));
    }

    // 先把本次会话的根目录告诉前端，前端用它构造 initialize 的 rootUri
    // 与文档 URI，保证语言服务器看到的是同一个路径。
    let root_uri = format!("file://{}", workspace.display());
    let ready = json!({
        "jsonrpc": "2.0",
        "method": "theseus/ready",
        "params": { "rootUri": root_uri, "language": language },
    });
    send_text(socket, ready.to_string()).await?;

    let mut reader = BufReader::new(stdout);
    loop {
        tokio::select! {
            _ = shutdown.recv() => return Ok(()),
            incoming = socket.recv() => {
                match incoming {
                    Some(Ok(Message::Text(text))) => {
                        let body = text.as_bytes();
                        if body.is_empty() {
                            continue;
                        }
                        if body.len() > MAX_MESSAGE_BYTES {
                            warn!("dropping oversized LSP message from client");
                            continue;
                        }
                        if let Err(error) = write_frame(&mut stdin, body).await {
                            return Err(format!("write to language server failed: {error}"));
                        }
                    }
                    Some(Ok(Message::Ping(payload))) => {
                        let _ = socket.send(Message::Pong(payload)).await;
                    }
                    Some(Ok(Message::Pong(_) | Message::Binary(_))) => {}
                    Some(Ok(Message::Close(_))) | Some(Err(_)) | None => return Ok(()),
                }
            }
            frame = read_frame(&mut reader) => {
                match frame {
                    Ok(Some(body)) => {
                        let text = String::from_utf8(body)
                            .map_err(|_| "language server sent invalid UTF-8".to_owned())?;
                        send_text(socket, text).await?;
                    }
                    Ok(None) => return Ok(()),
                    Err(error) => return Err(format!("read from language server failed: {error}")),
                }
            }
        }
    }
}

async fn send_text(socket: &mut WebSocket, text: String) -> Result<(), String> {
    socket
        .send(Message::Text(text.into()))
        .await
        .map_err(|error| format!("websocket send failed: {error}"))
}

/// LSP over stdio 使用 `Content-Length` 头分帧；浏览器侧直接收发 JSON 文本。
async fn write_frame<W: AsyncWrite + Unpin>(writer: &mut W, body: &[u8]) -> std::io::Result<()> {
    writer
        .write_all(format!("Content-Length: {}\r\n\r\n", body.len()).as_bytes())
        .await?;
    writer.write_all(body).await?;
    writer.flush().await
}

async fn read_frame<R: AsyncRead + Unpin>(
    reader: &mut BufReader<R>,
) -> std::io::Result<Option<Vec<u8>>> {
    let mut content_length: Option<usize> = None;
    loop {
        let mut line = String::new();
        let read = reader.read_line(&mut line).await?;
        if read == 0 {
            return Ok(None);
        }
        let trimmed = line.trim_end_matches(|character| character == '\r' || character == '\n');
        if trimmed.is_empty() {
            break;
        }
        if let Some(value) = trimmed.strip_prefix("Content-Length:") {
            content_length = value.trim().parse::<usize>().ok();
        }
    }
    let Some(length) = content_length else {
        return Err(std::io::Error::new(
            std::io::ErrorKind::InvalidData,
            "missing Content-Length",
        ));
    };
    if length > MAX_MESSAGE_BYTES {
        return Err(std::io::Error::new(
            std::io::ErrorKind::InvalidData,
            "language server message too large",
        ));
    }
    let mut body = vec![0_u8; length];
    reader.read_exact(&mut body).await?;
    Ok(Some(body))
}

async fn log_stderr(stderr: ChildStderr) {
    let mut lines = BufReader::new(stderr).lines();
    loop {
        match lines.next_line().await {
            Ok(Some(line)) => debug!(target: "lsp_server", "{}", line),
            Ok(None) => break,
            Err(error) => {
                debug!(error = %error, "language server stderr closed");
                break;
            }
        }
    }
}

fn random_suffix() -> String {
    rand::thread_rng()
        .sample_iter(&Alphanumeric)
        .take(12)
        .map(char::from)
        .collect()
}
