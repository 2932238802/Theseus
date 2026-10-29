#!/usr/bin/env bash
#
# Theseus WebSocket 实时推送冒烟测试。
#
# 设计文档：doc/2610295_实时推送设计方案.md
#
# 覆盖：票据接口鉴权、票据换取、hello/ready 握手、站内信写入后推送
#       notification.new、事件信封字段。
#
# 用法：
#   ./backend-rust/scripts/smoke_realtime.sh
#   SMOKE_API_BASE=http://127.0.0.1:3001 ./backend-rust/scripts/smoke_realtime.sh
#
# 依赖：bash、curl、psql、node >= 21（内置 WebSocket；同时用于解析 JSON）。

set -uo pipefail

SCRIPT_DIR=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)
REPO_ROOT=$(cd "$SCRIPT_DIR/../.." && pwd)
BACKEND_DIR="$REPO_ROOT/backend-rust"
ENV_FILE=${SMOKE_BACKEND_ENV:-"$BACKEND_DIR/.env"}
API_BASE=${SMOKE_API_BASE:-http://127.0.0.1:3000}
API_ROOT="${API_BASE%/}/api"
WS_BASE=${API_BASE/http:/ws:}
WS_BASE=${WS_BASE/https:/wss:}
PASSWORD_HASH='$argon2id$v=19$m=19456,t=2,p=1$qv8iaQgEgWUlvnaYPAw+Sg$r0Fm/Iq+kxR7CGJjHL+EvUrOsXuWL42U3Ntb+B1FdJg'
WAIT_SECS=${SMOKE_REALTIME_WAIT_SECS:-15}

PASSED=0
FAILED=0
TMP_DIR=$(mktemp -d)
trap 'rm -rf "$TMP_DIR"' EXIT

say() { printf '==> %s\n' "$*"; }
pass() { PASSED=$((PASSED + 1)); printf '[PASS] %s\n' "$1"; }
fail() { FAILED=$((FAILED + 1)); printf '[FAIL] %s\n' "$1" >&2; }
fatal() { printf '[FAIL] %s\n' "$*" >&2; exit 2; }
require_cmd() { command -v "$1" >/dev/null 2>&1 || fatal "缺少命令 $1"; }

require_cmd curl
require_cmd psql
require_cmd node
node -e 'process.exit(typeof WebSocket === "function" ? 0 : 1)' >/dev/null 2>&1 \
    || fatal "需要 Node.js 21 或更高版本（内置 WebSocket）"

# 从 stdin 读取 JSON 并按点分路径取值；缺失时输出空串。
json_get() {
    node -e '
let input = "";
process.stdin.on("data", (chunk) => { input += chunk; });
process.stdin.on("end", () => {
  try {
    let value = JSON.parse(input);
    for (const key of process.argv[1].split(".")) value = value?.[key];
    if (value !== undefined && value !== null) process.stdout.write(String(value));
  } catch {}
});
' "$1"
}

[[ -f "$ENV_FILE" ]] || fatal "缺少 $ENV_FILE"
while IFS= read -r line || [[ -n "$line" ]]; do
    line=${line%$'\r'}
    [[ -z "$line" || "$line" == \#* || "$line" != *=* ]] && continue
    key=${line%%=*}
    value=${line#*=}
    [[ -z "${!key:-}" ]] && export "$key=$value"
done <"$ENV_FILE"
DATABASE_URL=${DATABASE_URL:-}
[[ -n "$DATABASE_URL" ]] || fatal "未配置 DATABASE_URL"

SUFFIX=$RANDOM
STUDENT="realtime_s_$SUFFIX"
STUDENT_EMAIL="$STUDENT@example.test"

cleanup() {
    psql "$DATABASE_URL" -q -c "DELETE FROM notifications WHERE user_id IN (SELECT id FROM users WHERE username = '$STUDENT');" >/dev/null 2>&1 || true
    psql "$DATABASE_URL" -q -c "DELETE FROM users WHERE username = '$STUDENT';" >/dev/null 2>&1 || true
}
cleanup
psql "$DATABASE_URL" -q -v ON_ERROR_STOP=1 <<SQL
INSERT INTO users (username, email, password_hash, role, email_verified_at)
VALUES ('$STUDENT', '$STUDENT_EMAIL', '$PASSWORD_HASH', 'student', CURRENT_TIMESTAMP);
SQL

login() {
    curl -sS -m 10 -X POST "$API_ROOT/auth/login" -H 'Content-Type: application/json' \
        -d "{\"username\":\"$1\",\"password\":\"admin\"}" | json_get data.token
}

TOKEN=$(login "$STUDENT")
[[ -n "$TOKEN" ]] || fatal "学生登录失败"
STUDENT_ID=$(psql "$DATABASE_URL" -Atc "SELECT id FROM users WHERE username = '$STUDENT'")

say "票据接口要求登录"
LAST_CODE=$(curl -sS -o "$TMP_DIR/body" -w '%{http_code}' -X POST "$API_ROOT/ws/ticket")
[[ "$LAST_CODE" == "401" ]] && pass "未登录换取票据返回 401" || fail "未登录换取票据返回 $LAST_CODE"

say "登录后换取一次性票据"
LAST_CODE=$(curl -sS -o "$TMP_DIR/body" -w '%{http_code}' \
    -X POST "$API_ROOT/ws/ticket" -H "Authorization: Bearer $TOKEN")
TICKET=$(json_get data.ticket <"$TMP_DIR/body")
TTL=$(json_get data.expires_in_seconds <"$TMP_DIR/body")
[[ "$LAST_CODE" == "200" && ${#TICKET} -ge 32 ]] && pass "票据已签发" || fail "票据签发失败（$LAST_CODE）"
[[ "$TTL" == "60" ]] && pass "票据有效期为 60 秒" || fail "票据有效期异常：$TTL"

say "建立 WebSocket 并等待通知推送"
WS_URL="$WS_BASE/api/ws?ticket=$TICKET" WS_TIMEOUT="$WAIT_SECS" node --input-type=module -e '
const url = process.env.WS_URL;
const timeoutMs = Number(process.env.WS_TIMEOUT || 15) * 1000;
const ws = new WebSocket(url);
let ready = false;
const timer = setTimeout(() => {
  console.error("timeout waiting for events");
  process.exit(1);
}, timeoutMs);
ws.addEventListener("open", () => {
  ws.send(JSON.stringify({ type: "hello" }));
});
ws.addEventListener("message", (event) => {
  let message;
  try { message = JSON.parse(String(event.data)); } catch { return; }
  if (message.type === "ping") {
    ws.send(JSON.stringify({ type: "pong" }));
    return;
  }
  if (message.type === "ready") {
    if (typeof message.data?.server_time !== "string") {
      console.error("ready event is missing server_time");
      process.exit(1);
    }
    ready = true;
    console.log("READY");
    return;
  }
  if (message.type === "notification.new") {
    if (!ready) {
      console.error("notification arrived before ready");
      process.exit(1);
    }
    if (typeof message.id !== "number" || !message.data?.title) {
      console.error("notification event is missing id or title");
      process.exit(1);
    }
    console.log("NOTIFICATION " + message.data.title);
    clearTimeout(timer);
    ws.close();
    process.exit(0);
  }
});
ws.addEventListener("error", () => {
  console.error("websocket error");
  process.exit(1);
});
' >"$TMP_DIR/ws.log" 2>&1 &
WS_PID=$!

sleep 2
psql "$DATABASE_URL" -q -v ON_ERROR_STOP=1 -c \
    "INSERT INTO notifications (user_id, type, title, body, link)
     VALUES ($STUDENT_ID, 'system_notice', 'SMOKE-REALTIME-$SUFFIX', '实时推送冒烟', '/notifications');"

wait "$WS_PID"
WS_STATUS=$?
if [[ $WS_STATUS -eq 0 ]] && grep -q '^READY$' "$TMP_DIR/ws.log"; then
    pass "收到 ready 与服务器时间"
else
    fail "未收到 ready（$(tr '\n' ' ' <"$TMP_DIR/ws.log")）"
fi
if [[ $WS_STATUS -eq 0 ]] && grep -q "NOTIFICATION SMOKE-REALTIME-$SUFFIX" "$TMP_DIR/ws.log"; then
    pass "站内信触发 notification.new"
else
    fail "未收到 notification.new（$(tr '\n' ' ' <"$TMP_DIR/ws.log")）"
fi

cleanup
say "完成：$PASSED 通过，$FAILED 失败"
[[ $FAILED -eq 0 ]]
