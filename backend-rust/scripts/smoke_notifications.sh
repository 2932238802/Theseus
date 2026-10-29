#!/usr/bin/env bash
#
# Theseus 通知偏好与通知邮件冒烟测试。
#
# 设计文档：doc/总体设计.md 4.9 通知与邮件
#
# 覆盖：通知偏好默认值、批量更新、非法类别校验、已验证邮箱按类别生成邮件、
#       关闭类别后不再生成邮件。
#
# 用法：
#   ./backend-rust/scripts/smoke_notifications.sh
#   SMOKE_API_BASE=http://127.0.0.1:3001 ./backend-rust/scripts/smoke_notifications.sh
#
# 依赖：bash、curl、jq、psql。

set -uo pipefail

SCRIPT_DIR=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)
REPO_ROOT=$(cd "$SCRIPT_DIR/../.." && pwd)
BACKEND_DIR="$REPO_ROOT/backend-rust"
ENV_FILE=${SMOKE_BACKEND_ENV:-"$BACKEND_DIR/.env"}
API_BASE=${SMOKE_API_BASE:-http://127.0.0.1:3000}
API_ROOT="${API_BASE%/}/api"
PASSWORD_HASH='$argon2id$v=19$m=19456,t=2,p=1$qv8iaQgEgWUlvnaYPAw+Sg$r0Fm/Iq+kxR7CGJjHL+EvUrOsXuWL42U3Ntb+B1FdJg'
WAIT_SECS=${SMOKE_EMAIL_WAIT_SECS:-20}

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
require_cmd jq
require_cmd psql

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
STUDENT="notify_s_$SUFFIX"
STUDENT_EMAIL="$STUDENT@example.test"

api() {
    local method=$1 path=$2 token=${3:-} body=${4:-}
    local out="$TMP_DIR/body" code
    if [[ -n "$body" ]]; then
        code=$(curl -sS -X "$method" "$API_ROOT$path" \
            -H "Authorization: Bearer $token" -H 'Content-Type: application/json' \
            -d "$body" -o "$out" -w '%{http_code}')
    else
        code=$(curl -sS -X "$method" "$API_ROOT$path" \
            -H "Authorization: Bearer $token" -o "$out" -w '%{http_code}')
    fi
    LAST_CODE=$code
    LAST_BODY=$(cat "$out")
}

login() {
    local body
    body=$(curl -sS -m 10 -X POST "$API_ROOT/auth/login" -H 'Content-Type: application/json' \
        -d "{\"username\":\"$1\",\"password\":\"$2\"}")
    jq -r '.data.token // empty' <<<"$body"
}

expect_code() {
    local desc=$1 expected=$2
    if [[ "$LAST_CODE" == "$expected" ]]; then
        pass "$desc"
    else
        fail "$desc：期望 HTTP $expected，实际 $LAST_CODE（$(jq -r '.error // empty' <<<"$LAST_BODY")）"
    fi
}

expect_jq() {
    local desc=$1 expr=$2
    if jq -e "$expr" >/dev/null 2>&1 <<<"$LAST_BODY"; then
        pass "$desc"
    else
        fail "$desc：响应不满足 $expr"
    fi
}

outbox_count() {
    psql "$DATABASE_URL" -Atc \
        "SELECT COUNT(*) FROM email_outbox WHERE recipient_email = '$STUDENT_EMAIL' AND subject LIKE '%$1%'"
}

wait_for_outbox() {
    local pattern=$1 deadline=$((SECONDS + WAIT_SECS))
    while (( SECONDS < deadline )); do
        [[ "$(outbox_count "$pattern")" -gt 0 ]] && return 0
        sleep 1
    done
    return 1
}

enqueue_notification() {
    local type=$1 title=$2
    psql "$DATABASE_URL" -q -v ON_ERROR_STOP=1 -c \
        "INSERT INTO notifications (user_id, type, title, body, link)
         VALUES ($STUDENT_ID, '$type', '$title', '冒烟测试通知', '/problems');"
}

cleanup() {
    psql "$DATABASE_URL" -q -c "DELETE FROM email_outbox WHERE recipient_email = '$STUDENT_EMAIL';" >/dev/null 2>&1 || true
    psql "$DATABASE_URL" -q -c "DELETE FROM users WHERE username = '$STUDENT';" >/dev/null 2>&1 || true
}

cleanup
psql "$DATABASE_URL" -q -v ON_ERROR_STOP=1 <<SQL
INSERT INTO users (username, email, password_hash, role, email_verified_at)
VALUES ('$STUDENT', '$STUDENT_EMAIL', '$PASSWORD_HASH', 'student', CURRENT_TIMESTAMP);
SQL

TOKEN=$(login "$STUDENT" admin)
[[ -n "$TOKEN" ]] || fatal "学生登录失败"
STUDENT_ID=$(psql "$DATABASE_URL" -Atc "SELECT id FROM users WHERE username = '$STUDENT'")

say "通知偏好默认值"
api GET /profile/notification-preferences "$TOKEN"
expect_code "读取通知偏好" 200
expect_jq "返回六类偏好" '.data.preferences | length == 6'
expect_jq "邮箱已验证" '.data.email_verified == true'
expect_jq "作业默认开启邮件" '[.data.preferences[] | select(.category == "assignment")][0].enabled == true'
expect_jq "论坛默认关闭邮件" '[.data.preferences[] | select(.category == "forum")][0].enabled == false'

say "更新通知偏好"
api PUT /profile/notification-preferences "$TOKEN" '{"preferences":[{"category":"forum","enabled":true},{"category":"class","enabled":false}]}'
expect_code "批量更新偏好" 200
expect_jq "论坛已开启" '[.data.preferences[] | select(.category == "forum")][0].enabled == true'
expect_jq "组织已关闭" '[.data.preferences[] | select(.category == "class")][0].enabled == false'
api PUT /profile/notification-preferences "$TOKEN" '{"preferences":[{"category":"marketing","enabled":true}]}'
expect_code "非法类别被拒绝" 400

say "默认开启的类别生成邮件"
enqueue_notification assignment_published "SMOKE-ASSIGN-$SUFFIX"
if wait_for_outbox "SMOKE-ASSIGN-$SUFFIX"; then
    pass "作业通知进入发件箱"
else
    fail "作业通知未在 ${WAIT_SECS}s 内进入发件箱"
fi

say "默认关闭的类别不生成邮件"
enqueue_notification system_notice "SMOKE-ANNOUNCE-$SUFFIX"
sleep "$WAIT_SECS"
if [[ "$(outbox_count "SMOKE-ANNOUNCE-$SUFFIX")" -eq 0 ]]; then
    pass "系统公告默认不发邮件"
else
    fail "系统公告不应进入发件箱"
fi

say "关闭类别后不再生成邮件"
api PUT /profile/notification-preferences "$TOKEN" '{"preferences":[{"category":"assignment","enabled":false}]}'
expect_code "关闭作业邮件" 200
enqueue_notification assignment_published "SMOKE-OFF-$SUFFIX"
sleep "$WAIT_SECS"
if [[ "$(outbox_count "SMOKE-OFF-$SUFFIX")" -eq 0 ]]; then
    pass "关闭后作业通知不再发邮件"
else
    fail "关闭后仍生成了作业邮件"
fi

cleanup
say "通过 $PASSED 项，失败 $FAILED 项"
(( FAILED == 0 )) || exit 1
