#!/usr/bin/env bash
#
# Theseus 审计中心冒烟测试。
#
# 覆盖：登录写审计 / 管理员变更用户状态写审计 / 管理员列表与筛选 /
# 动作元数据 / CSV 导出 / 非管理员访问返回 403 / 时间范围筛选 / 清理。
#
# 用法：
#   ./backend-rust/scripts/smoke_audit.sh
#   SMOKE_KEEP_DATA=1 ./backend-rust/scripts/smoke_audit.sh
#
# 依赖：bash >= 4.2、curl、jq、psql。
# 安全性：只使用随机哑账号；不输出 token、密码或数据库连接串。
# 需要先应用 migration 0026_audit_logs.sql（启动 API 时自动执行）。

set -uo pipefail

SCRIPT_DIR=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)
REPO_ROOT=$(cd "$SCRIPT_DIR/../.." && pwd)
BACKEND_DIR="$REPO_ROOT/backend-rust"

ENV_FILE=${SMOKE_BACKEND_ENV:-"$BACKEND_DIR/.env"}
API_BASE=${SMOKE_API_BASE:-http://127.0.0.1:3000}
KEEP_DATA=${SMOKE_KEEP_DATA:-0}
TMP_DIR=$(mktemp -d)
trap 'rm -rf "$TMP_DIR"' EXIT

PASSED=0
FAILED=0
ADMIN_USER=""
ADMIN_ID=""
ADMIN_TOKEN=""
TARGET_USER=""
TARGET_ID=""
TARGET_TOKEN=""

say() { printf '==> %s\n' "$*"; }
fail() { printf '[FAIL] %s\n' "$*" >&2; FAILED=$((FAILED + 1)); }
pass() { printf '[PASS] %s\n' "$*"; PASSED=$((PASSED + 1)); }
expect() {
    local desc=$1 expected=$2 actual=$3
    if [[ "$expected" == "$actual" ]]; then pass "$desc"; else fail "$desc：期望 [$expected]，实际 [$actual]"; fi
}
contains() {
    local desc=$1 haystack=$2 needle=$3
    if [[ "$haystack" == *"$needle"* ]]; then pass "$desc"; else fail "$desc：未找到 [$needle]"; fi
}

require_cmd() { command -v "$1" >/dev/null 2>&1 || { printf '[FAIL] 缺少命令 %s\n' "$1" >&2; exit 2; }; }

load_env() {
    [[ -f "$ENV_FILE" ]] || { printf '[FAIL] 缺少 %s\n' "$ENV_FILE" >&2; exit 2; }
    local line key value
    while IFS= read -r line || [[ -n "$line" ]]; do
        line=${line%$'\r'}
        [[ -z "$line" || "$line" == \#* || "$line" != *=* ]] && continue
        key=${line%%=*}
        value=${line#*=}
        key=${key//[[:space:]]/}
        [[ -z "$key" ]] && continue
        [[ -z "${!key:-}" ]] && export "$key=$value"
    done <"$ENV_FILE"
    [[ -n "${DATABASE_URL:-}" ]] || { printf '[FAIL] 未配置 DATABASE_URL\n' >&2; exit 2; }
}

db_scalar() { psql "$DATABASE_URL" -At -v ON_ERROR_STOP=1 -c "$1" 2>/dev/null; }

api() {
    # api METHOD PATH TOKEN [BODY]
    local method=$1 path=$2 token=${3:-} body=${4:-}
    local -a args=(-sS -X "$method" -H 'Content-Type: application/json'
        -o "$TMP_DIR/body" -w '%{http_code}')
    [[ -n "$token" ]] && args+=(-H "Authorization: Bearer $token")
    [[ -n "$body" ]] && args+=(--data-binary "$body")
    API_STATUS=$(curl "${args[@]}" "$API_BASE$path" 2>/dev/null) || API_STATUS=000
    API_BODY=$(cat "$TMP_DIR/body" 2>/dev/null || true)
}

random_suffix() { printf '%s_%s' "$(date +%s)" "$RANDOM"; }
random_password() { tr -dc 'A-Za-z0-9' </dev/urandom | head -c 20; }

register() {
    local username=$1 email=$2 password=$3
    api POST /api/auth/register "" \
        "$(jq -nc --arg u "$username" --arg e "$email" --arg p "$password" '{username:$u,email:$e,password:$p}')"
    [[ "$API_STATUS" == "201" ]] || { printf '[FAIL] 注册失败 HTTP %s: %s\n' "$API_STATUS" "$API_BODY" >&2; exit 2; }
}

login() {
    local username=$1 password=$2
    api POST /api/auth/login "" \
        "$(jq -nc --arg u "$username" --arg p "$password" '{username:$u,password:$p}')"
    [[ "$API_STATUS" == "200" ]] || { printf '[FAIL] 登录失败 HTTP %s: %s\n' "$API_STATUS" "$API_BODY" >&2; exit 2; }
    API_TOKEN=$(jq -r '.data.token // empty' <<<"$API_BODY")
    API_USER_ID=$(jq -r '.data.user.id // empty' <<<"$API_BODY")
    [[ -n "$API_TOKEN" && -n "$API_USER_ID" ]] || { printf '[FAIL] 登录响应缺少 token 或 user.id\n' >&2; exit 2; }
}

cleanup() {
    ((KEEP_DATA)) && { say "保留测试数据（SMOKE_KEEP_DATA=1）"; return; }
    psql "$DATABASE_URL" -At -v ON_ERROR_STOP=1 >/dev/null 2>&1 <<SQL
DELETE FROM audit_logs WHERE actor_username LIKE 'audsmoke_%' OR summary LIKE '%audsmoke_%';
DELETE FROM auth_tokens WHERE user_id IN (SELECT id FROM users WHERE username LIKE 'audsmoke_%');
DELETE FROM notifications WHERE user_id IN (SELECT id FROM users WHERE username LIKE 'audsmoke_%')
                             OR actor_id IN (SELECT id FROM users WHERE username LIKE 'audsmoke_%');
DELETE FROM notification_preferences WHERE user_id IN (SELECT id FROM users WHERE username LIKE 'audsmoke_%');
DELETE FROM reputation_events WHERE user_id IN (SELECT id FROM users WHERE username LIKE 'audsmoke_%')
                                 OR actor_id IN (SELECT id FROM users WHERE username LIKE 'audsmoke_%');
DELETE FROM users WHERE username LIKE 'audsmoke_%';
SQL
    say "测试数据已清理"
}

main() {
    require_cmd curl
    require_cmd jq
    require_cmd psql
    load_env
    db_scalar "SELECT 1" >/dev/null || { printf '[FAIL] PostgreSQL 不可达\n' >&2; exit 2; }
    expect "审计表迁移已应用" "t" \
        "$(db_scalar "SELECT to_regclass('public.audit_logs') IS NOT NULL")"
    api GET /api/stats "" ""
    [[ "$API_STATUS" == "200" ]] || { printf '[FAIL] API 不可达（HTTP %s）\n' "$API_STATUS" >&2; exit 2; }

    local suffix password
    suffix=$(random_suffix)
    password=$(random_password)
    ADMIN_USER="audsmoke_admin_${suffix}"
    TARGET_USER="audsmoke_target_${suffix}"
    register "$ADMIN_USER" "${ADMIN_USER}@example.test" "$password"
    register "$TARGET_USER" "${TARGET_USER}@example.test" "$password"
    TARGET_ID=$(db_scalar "SELECT id FROM users WHERE username = '$TARGET_USER'")
    db_scalar "UPDATE users SET role = 'admin' WHERE username = '$ADMIN_USER'" >/dev/null
    login "$ADMIN_USER" "$password"
    ADMIN_TOKEN=$API_TOKEN
    ADMIN_ID=$API_USER_ID
    login "$TARGET_USER" "$password"
    TARGET_TOKEN=$API_TOKEN
    TARGET_ID=$API_USER_ID

    say "1. 非管理员访问被拒绝"
    api GET /api/admin/audit-logs "" "$TARGET_TOKEN" ""
    expect "普通用户访问审计返回 403" "403" "$API_STATUS"

    say "2. 登录与状态变更写审计"
    api PUT "/api/admin/users/${TARGET_ID}/status" "$ADMIN_TOKEN" '{"status":"disabled"}'
    expect "变更用户状态返回 200" "200" "$API_STATUS"

    api GET "/api/admin/audit-logs?action=user.status_change&q=${TARGET_USER}" "$ADMIN_TOKEN" ""
    expect "审计列表返回 200" "200" "$API_STATUS"
    local total actor action target
    total=$(jq -r '.data.total // 0' <<<"$API_BODY")
    [[ "$total" -ge 1 ]] && pass "筛选到状态变更审计（$total 条）" || fail "未筛选到状态变更审计"
    actor=$(jq -r '.data.logs[0].actor_username // empty' <<<"$API_BODY")
    action=$(jq -r '.data.logs[0].action // empty' <<<"$API_BODY")
    target=$(jq -r '.data.logs[0].target_id // empty' <<<"$API_BODY")
    expect "审计记录操作者" "$ADMIN_USER" "$actor"
    expect "审计记录动作" "user.status_change" "$action"
    expect "审计记录对象" "$TARGET_ID" "$target"
    expect "审计记录包含 IP 字段" "true" \
        "$(jq -r '.data.logs[0] | has("ip")' <<<"$API_BODY")"

    say "3. 动作元数据"
    api GET /api/admin/audit-logs/meta "$ADMIN_TOKEN" ""
    expect "元数据返回 200" "200" "$API_STATUS"
    contains "元数据包含 user.status_change" "$API_BODY" "user.status_change"

    say "4. 时间范围筛选"
    api GET "/api/admin/audit-logs?action=user.status_change&from=2999-01-01" "$ADMIN_TOKEN" ""
    expect "未来时间筛选返回 200" "200" "$API_STATUS"
    expect "未来时间筛选无记录" "0" "$(jq -r '.data.total' <<<"$API_BODY")"

    say "5. CSV 导出"
    local csv_status
    csv_status=$(curl -sS -o "$TMP_DIR/audit.csv" -w '%{http_code}' \
        -H "Authorization: Bearer $ADMIN_TOKEN" \
        "$API_BASE/api/admin/audit-logs/export?action=user.status_change" 2>/dev/null) || csv_status=000
    expect "导出返回 200" "200" "$csv_status"
    local bom
    bom=$(head -c 3 "$TMP_DIR/audit.csv" | od -An -tx1 | tr -d ' \n')
    expect "CSV 带 UTF-8 BOM" "efbbbf" "$bom"
    contains "CSV 含表头" "$(head -n 1 "$TMP_DIR/audit.csv")" "时间,操作者,角色,动作"

    say "结果：$PASSED 通过，$FAILED 失败"
    ((FAILED == 0))
}

main
cleanup
