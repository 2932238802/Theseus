#!/usr/bin/env bash
#
# Theseus 邮箱验证 / 密码找回冒烟测试。
#
# 只操作真实运行的 API + PostgreSQL，不 mock 任何一层。覆盖：
#   注册后未验证 / 未验证仍可登录 / 教学与发帖拦截 / 重发冷却 /
#   邮箱验证与令牌一次性 / 已验证重发 / 找回密码通用响应 /
#   重置密码 / 旧 JWT 失效 / 旧密码失效 / 新密码登录 / 清理。
#
# 用法：
#   ./backend-rust/scripts/smoke_auth_email.sh
#   SMOKE_KEEP_DATA=1 ./backend-rust/scripts/smoke_auth_email.sh
#   SMOKE_VERBOSE=1 ./backend-rust/scripts/smoke_auth_email.sh
#
# 依赖：bash >= 4.2、curl、jq、psql。
# 安全性：只使用随机哑账号；不打印令牌、密码、邮件正文或数据库连接串。
# 需要 EMAIL_MODE=log，或 SMTP 不投递也不影响 outbox；脚本只读取 outbox。
# 只连接本地/测试数据库。

set -uo pipefail

SCRIPT_DIR=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)
REPO_ROOT=$(cd "$SCRIPT_DIR/../.." && pwd)
BACKEND_DIR="$REPO_ROOT/backend-rust"

ENV_FILE=${SMOKE_BACKEND_ENV:-"$BACKEND_DIR/.env"}
API_BASE=${SMOKE_API_BASE:-http://127.0.0.1:3000}
KEEP_DATA=${SMOKE_KEEP_DATA:-0}
VERBOSE=${SMOKE_VERBOSE:-0}
REPORT_DIR=${SMOKE_REPORT_DIR:-"$REPO_ROOT/.dev-logs"}
PASSWORD=${SMOKE_PASSWORD:-}

START_MS=0
START_ISO=""
PASSED=0
FAILED=0
SKIPPED=0
CHECKS_JSON=()
CHECK_ID=""
CHECK_FAILS=0
CHECK_START_MS=0
CHECK_NOTE=""

USER_NAME=""
USER_EMAIL=""
USER_ID=""
USER_TOKEN=""
USER_IDS=()
CLEANED=0
CLEANING_UP=0
CLEANUP_SQL=""

API_STATUS=""
API_BODY=""
REG_USER_ID=""
REG_TOKEN=""
TMP_DIR=""
TMP_BODY=""
REPORT_LOG=""
REPORT_JSON=""

say() { printf '==> %s\n' "$*"; }
info() { ((VERBOSE)) && printf '[debug] %s\n' "$*"; return 0; }

fatal_preflight() {
    printf '[FAIL] 前置条件不满足：%s\n' "$*" >&2
    exit 2
}

fatal_service() {
    printf '[FAIL] 服务不可达：%s\n' "$*" >&2
    exit 3
}

require_cmd() {
    command -v "$1" >/dev/null 2>&1 || fatal_preflight "缺少命令 $1"
}

now_ms() {
    local ns
    ns=$(date +%s%N 2>/dev/null)
    if [[ "$ns" =~ ^[0-9]+$ ]]; then
        printf '%s\n' "$((ns / 1000000))"
    else
        printf '%s\n' "$(($(date +%s) * 1000))"
    fi
}

load_env() {
    [[ -f "$ENV_FILE" ]] || fatal_preflight "缺少配置文件 $ENV_FILE（请先 cp backend-rust/.env.example backend-rust/.env）"
    local line key value
    while IFS= read -r line || [[ -n "$line" ]]; do
        line=${line%$'\r'}
        [[ -z "$line" || "$line" == \#* ]] && continue
        [[ "$line" == *=* ]] || continue
        key=${line%%=*}
        value=${line#*=}
        key=${key//[[:space:]]/}
        [[ -z "$key" ]] && continue
        if [[ -z "${!key:-}" ]]; then
            export "$key=$value"
        fi
    done <"$ENV_FILE"

    DATABASE_URL=${DATABASE_URL:-}
    [[ -n "$DATABASE_URL" ]] || fatal_preflight "未配置 DATABASE_URL"
}

record_check() {
    local id=$1 status=$2 duration_ms=$3
    local entry
    entry=$(jq -nc --arg id "$id" --arg status "$status" --argjson duration_ms "$duration_ms" \
        '{id:$id,status:$status,duration_ms:$duration_ms}')
    CHECKS_JSON+=("$entry")
}

begin_check() {
    CHECK_ID=$1
    CHECK_FAILS=0
    CHECK_NOTE=""
    CHECK_START_MS=$(now_ms)
}

end_check() {
    local duration_ms
    duration_ms=$(($(now_ms) - CHECK_START_MS))
    if ((CHECK_FAILS == 0)); then
        PASSED=$((PASSED + 1))
        printf '[PASS] %-26s %s\n' "$CHECK_ID" "$CHECK_NOTE"
        record_check "$CHECK_ID" passed "$duration_ms"
    else
        FAILED=$((FAILED + 1))
        printf '[FAIL] %-26s %d 项断言失败\n' "$CHECK_ID" "$CHECK_FAILS"
        record_check "$CHECK_ID" failed "$duration_ms"
    fi
}

fail_check() {
    CHECK_FAILS=$((CHECK_FAILS + 1))
    printf '       - %s\n' "$*" >&2
}

assert_eq() {
    local desc=$1 expected=$2 actual=$3
    [[ "$expected" == "$actual" ]] || fail_check "$desc：期望 [$expected]，实际 [$actual]"
}

assert_contains() {
    local desc=$1 haystack=$2 needle=$3
    [[ "$haystack" == *"$needle"* ]] || fail_check "$desc：[$haystack] 不包含 [$needle]"
}

assert_nonempty() {
    local desc=$1 value=$2
    [[ -n "$value" && "$value" != "null" ]] || fail_check "$desc：为空"
}

assert_status() {
    local desc=$1 expected=$2
    [[ "$API_STATUS" == "$expected" ]] || fail_check "$desc：期望 HTTP $expected，实际 $API_STATUS（$(api_error)）"
}

api_request() {
    # api_request METHOD PATH TOKEN [BODY]
    local method=$1 path=$2 token=${3:-} body=${4:-}
    : >"$TMP_BODY"
    local -a args=(-sS -X "$method" -H 'Content-Type: application/json'
        -o "$TMP_BODY" -w '%{http_code}')
    [[ -n "$token" ]] && args+=(-H "Authorization: Bearer $token")
    [[ -n "$body" ]] && args+=(--data-binary "$body")
    API_STATUS=$(curl "${args[@]}" "$API_BASE$path" 2>/dev/null) || API_STATUS=000
    API_BODY=$(cat "$TMP_BODY" 2>/dev/null || true)
    info "$method $path -> $API_STATUS"
}

api_error() {
    if [[ -n "${API_BODY:-}" ]] && jq -e . >/dev/null 2>&1 <<<"$API_BODY"; then
        jq -r '.error // "unknown error"' <<<"$API_BODY"
    else
        printf 'non-JSON response'
    fi
}

db_scalar() {
    psql "$DATABASE_URL" -At -v ON_ERROR_STOP=1 -c "$1" 2>/dev/null
}

preflight_env() {
    ((BASH_VERSINFO[0] > 4 || (BASH_VERSINFO[0] == 4 && BASH_VERSINFO[1] >= 2))) ||
        fatal_preflight "需要 bash >= 4.2（当前 ${BASH_VERSION}）"
    require_cmd curl
    require_cmd jq
    require_cmd psql

    psql "$DATABASE_URL" -At -c 'SELECT 1' >/dev/null 2>&1 ||
        fatal_service "PostgreSQL 不可达（检查 DATABASE_URL）"

    api_request GET /api/stats "" ""
    [[ "$API_STATUS" == "200" ]] ||
        fatal_service "API 不可达或返回异常（GET /api/stats -> $API_STATUS）"

    local has_verified has_tokens has_outbox
    has_verified=$(db_scalar "SELECT EXISTS(SELECT 1 FROM information_schema.columns WHERE table_name = 'users' AND column_name = 'email_verified_at')")
    has_tokens=$(db_scalar "SELECT EXISTS(SELECT 1 FROM information_schema.tables WHERE table_name = 'auth_tokens')")
    has_outbox=$(db_scalar "SELECT EXISTS(SELECT 1 FROM information_schema.tables WHERE table_name = 'email_outbox')")
    assert_eq "邮箱验证迁移已应用（users）" "t" "$has_verified"
    assert_eq "邮箱验证迁移已应用（auth_tokens）" "t" "$has_tokens"
    assert_eq "邮箱验证迁移已应用（email_outbox）" "t" "$has_outbox"
    if ((CHECK_FAILS > 0)); then
        fatal_preflight "数据库缺少 0007_auth_email.sql 迁移"
    fi
}

random_suffix() {
    printf '%s_%s' "$(date +%s)" "$RANDOM"
}

random_password() {
    tr -dc 'A-Za-z0-9' </dev/urandom | head -c 20
}

latest_token_from_outbox() {
    # latest_token_from_outbox EMAIL SUBJECT_PREFIX
    local email=$1 subject=$2
    db_scalar "SELECT btrim(split_part(split_part(body, 'token=', 2), E'\n', 1))
               FROM email_outbox
               WHERE recipient_email = '$email' AND subject LIKE '$subject%'
               ORDER BY id DESC LIMIT 1"
}

build_cleanup_sql() {
    local ids
    ids=$(IFS=,; printf '%s' "${USER_IDS[*]}")
    CLEANUP_SQL="DELETE FROM email_outbox WHERE recipient_email IN (SELECT email FROM users WHERE id IN ($ids)); \
DELETE FROM users WHERE id IN ($ids);"
}

cleanup_test_data() {
    local ids count
    ids=$(IFS=,; printf '%s' "${USER_IDS[*]}")
    [[ -n "$ids" ]] || return 0
    build_cleanup_sql
    if [[ "$KEEP_DATA" == "1" ]]; then
        printf '\n[INFO] SMOKE_KEEP_DATA=1，保留测试账号：%s\n' "$ids"
        return 0
    fi
    psql "$DATABASE_URL" -v ON_ERROR_STOP=1 -c "$CLEANUP_SQL" >/dev/null 2>&1 ||
        fail_check "执行清理 SQL 失败"
    count=$(db_scalar "SELECT COUNT(*) FROM users WHERE id IN ($ids)")
    assert_eq "清理后剩余测试账号" "0" "$count"
    CLEANED=1
    printf '\n[INFO] 已删除测试账号与邮件队列\n'
}

cleanup() {
    ((CLEANING_UP)) && return 0
    CLEANING_UP=1
    if ((CLEANED == 0)) && [[ "$KEEP_DATA" != "1" && ${#USER_IDS[@]} -gt 0 ]]; then
        [[ -n "$CLEANUP_SQL" ]] || build_cleanup_sql
        psql "$DATABASE_URL" -v ON_ERROR_STOP=1 -c "$CLEANUP_SQL" >/dev/null 2>&1 || true
    fi
    [[ -n "$TMP_DIR" && -d "$TMP_DIR" ]] && rm -rf "$TMP_DIR"
    return 0
}

on_exit() {
    local rc=$?
    trap - EXIT INT TERM
    cleanup
    exit "$rc"
}

trap on_exit EXIT
trap 'exit 130' INT
trap 'exit 143' TERM

write_report() {
    local duration_ms checks_json
    duration_ms=$(($(now_ms) - START_MS))
    if ((${#CHECKS_JSON[@]})); then
        checks_json=$(printf '%s\n' "${CHECKS_JSON[@]}" | jq -s '.')
    else
        checks_json='[]'
    fi
    jq -n \
        --arg started_at "$START_ISO" \
        --arg api_base "$API_BASE" \
        --argjson user_id "${USER_ID:-0}" \
        --arg cleaned "$CLEANED" \
        --arg git_commit "$(git -C "$REPO_ROOT" rev-parse --short HEAD 2>/dev/null || printf 'unknown')" \
        --argjson checks "$checks_json" \
        --argjson passed "$PASSED" \
        --argjson failed "$FAILED" \
        --argjson skipped "$SKIPPED" \
        --argjson duration_ms "$duration_ms" \
        '{started_at:$started_at, api_base:$api_base, user_id:$user_id,
          cleaned:($cleaned == "1"), git_commit:$git_commit, checks:$checks,
          summary:{passed:$passed, failed:$failed, skipped:$skipped, duration_ms:$duration_ms}}' \
        >"$REPORT_JSON"
}

main() {
    load_env

    mkdir -p "$REPORT_DIR" || fatal_preflight "无法创建报告目录 $REPORT_DIR"
    local stamp
    stamp=$(date -u +%Y%m%dT%H%M%SZ)
    REPORT_LOG="$REPORT_DIR/smoke-auth-email-$stamp.log"
    REPORT_JSON="$REPORT_DIR/smoke-auth-email-$stamp.json"
    exec > >(tee -a "$REPORT_LOG") 2>&1

    TMP_DIR=$(mktemp -d "${TMPDIR:-/tmp}/theseus-auth-smoke.XXXXXX") || fatal_preflight "无法创建临时目录"
    TMP_BODY="$TMP_DIR/body.json"

    START_MS=$(now_ms)
    START_ISO=$(date -u +'%Y-%m-%dT%H:%M:%SZ')

    local db_host
    db_host=$(printf '%s' "$DATABASE_URL" | sed -E 's#^[a-z]+://##; s#^[^@]*@##; s#[/?].*$##')
    say "smoke: $API_BASE  db=$db_host"

    begin_check preflight
    preflight_env
    CHECK_NOTE="auth email migration"
    end_check

    # ------------------------------------------------------------------
    # 注册与未验证限制
    # ------------------------------------------------------------------
    begin_check register_unverified
    local suffix password body login_body
    suffix=$(random_suffix)
    password=${PASSWORD:-$(random_password)}
    USER_NAME="asmoke_user_${suffix}"
    USER_EMAIL="${USER_NAME}@example.test"

    body=$(jq -nc --arg u "$USER_NAME" --arg e "$USER_EMAIL" --arg p "$password" \
        '{username:$u, email:$e, password:$p}')
    api_request POST /api/auth/register "" "$body"
    assert_status "注册" "201"
    USER_ID=$(db_scalar "SELECT id FROM users WHERE username = '$USER_NAME'")
    assert_nonempty "user_id" "$USER_ID"
    USER_IDS+=("$USER_ID")
    assert_eq "注册后未验证" "t" "$(db_scalar "SELECT email_verified_at IS NULL FROM users WHERE id = $USER_ID")"

    login_body=$(jq -nc --arg u "$USER_NAME" --arg p "$password" '{username:$u, password:$p}')
    api_request POST /api/auth/login "" "$login_body"
    assert_status "未验证仍可登录" "200"
    USER_TOKEN=$(jq -r '.data.token // empty' <<<"$API_BODY")
    assert_nonempty "login token" "$USER_TOKEN"
    assert_eq "登录返回未验证" "false" "$(jq -r '.data.user.email_verified' <<<"$API_BODY")"

    api_request GET /api/auth/me "$USER_TOKEN" ""
    assert_status "未验证 /me" "200"
    assert_eq "/me 邮箱状态" "false" "$(jq -r '.data.email_verified' <<<"$API_BODY")"

    api_request POST /api/classes/join "$USER_TOKEN" '{"invite_code":"XXXXXXXX"}'
    assert_status "未验证加入组织" "403"
    assert_contains "加入组织拦截文案" "$(api_error)" "验证邮箱"

    body=$(jq -nc '{title:"未验证发帖", body_md:"hello", tags:["general"], problem_id:null}')
    api_request POST /api/forum/posts "$USER_TOKEN" "$body"
    assert_status "未验证发帖" "403"
    assert_contains "发帖拦截文案" "$(api_error)" "验证邮箱"

    body=$(jq -nc '{problem_id:1, language:"python", code:"print(1)", assignment_id:1}')
    api_request POST /api/submissions "$USER_TOKEN" "$body"
    assert_status "未验证交作业" "403"
    assert_contains "交作业拦截文案" "$(api_error)" "验证邮箱"

    api_request POST /api/auth/verify-email/resend "$USER_TOKEN" ""
    assert_status "重发冷却" "429"
    CHECK_NOTE="user=$USER_ID"
    end_check

    # ------------------------------------------------------------------
    # 邮箱验证
    # ------------------------------------------------------------------
    begin_check verify_email
    local verify_token verify_hash
    verify_token=$(latest_token_from_outbox "$USER_EMAIL" "验证你的")
    assert_nonempty "verification token" "$verify_token"
    assert_eq "验证令牌长度" "64" "${#verify_token}"
    verify_hash=$(db_scalar "SELECT token_hash FROM auth_tokens WHERE user_id = $USER_ID AND purpose = 'email_verify' ORDER BY id DESC LIMIT 1")
    [[ "$verify_hash" != "$verify_token" ]] || fail_check "数据库不应保存明文令牌"
    assert_eq "令牌已哈希" "64" "${#verify_hash}"

    body=$(jq -nc --arg t "$verify_token" '{token:$t}')
    api_request POST /api/auth/verify-email "" "$body"
    assert_status "验证邮箱" "200"
    assert_eq "验证后状态" "t" "$(db_scalar "SELECT email_verified_at IS NOT NULL FROM users WHERE id = $USER_ID")"
    assert_eq "令牌已使用" "t" "$(db_scalar "SELECT used_at IS NOT NULL FROM auth_tokens WHERE user_id = $USER_ID AND purpose = 'email_verify'")"

    api_request POST /api/auth/verify-email "" "$body"
    assert_status "重复验证" "400"

    api_request GET /api/auth/me "$USER_TOKEN" ""
    assert_status "验证后旧 JWT 仍可用" "200"
    assert_eq "验证后 /me 状态" "true" "$(jq -r '.data.email_verified' <<<"$API_BODY")"

    api_request POST /api/auth/verify-email/resend "$USER_TOKEN" ""
    assert_status "已验证重发" "200"
    assert_contains "已验证重发文案" "$(jq -r '.data.message // empty' <<<"$API_BODY")" "已验证"
    end_check

    # ------------------------------------------------------------------
    # 找回与重置密码
    # ------------------------------------------------------------------
    begin_check password_reset
    api_request POST /api/auth/forgot-password "" '{"email":"nobody@example.test"}'
    assert_status "未知邮箱找回" "200"
    assert_contains "未知邮箱通用文案" "$(jq -r '.data.message // empty' <<<"$API_BODY")" "如果邮箱存在"

    body=$(jq -nc --arg e "$USER_EMAIL" '{email:$e}')
    api_request POST /api/auth/forgot-password "" "$body"
    assert_status "已知邮箱找回" "200"

    local reset_token new_password
    reset_token=$(latest_token_from_outbox "$USER_EMAIL" "重置你的")
    assert_nonempty "reset token" "$reset_token"
    assert_eq "重置令牌长度" "64" "${#reset_token}"

    new_password=$(random_password)
    body=$(jq -nc --arg t "$reset_token" --arg p "$new_password" '{token:$t, password:$p}')
    api_request POST /api/auth/reset-password "" "$body"
    assert_status "重置密码" "200"
    assert_eq "会话版本递增" "1" "$(db_scalar "SELECT token_version FROM users WHERE id = $USER_ID")"

    api_request GET /api/auth/me "$USER_TOKEN" ""
    assert_status "旧 JWT 失效" "401"

    api_request POST /api/auth/reset-password "" "$body"
    assert_status "重置令牌一次性" "400"

    login_body=$(jq -nc --arg u "$USER_NAME" --arg p "$password" '{username:$u, password:$p}')
    api_request POST /api/auth/login "" "$login_body"
    assert_status "旧密码失效" "401"

    login_body=$(jq -nc --arg u "$USER_NAME" --arg p "$new_password" '{username:$u, password:$p}')
    api_request POST /api/auth/login "" "$login_body"
    assert_status "新密码登录" "200"
    assert_eq "新会话已验证" "true" "$(jq -r '.data.user.email_verified' <<<"$API_BODY")"
    CHECK_NOTE="user=$USER_ID"
    end_check

    begin_check cleanup
    if [[ "$KEEP_DATA" == "1" ]]; then
        cleanup_test_data
        CHECK_NOTE="SMOKE_KEEP_DATA=1，已跳过删除"
    else
        cleanup_test_data
        CHECK_NOTE="测试数据已清理"
    fi
    end_check

    write_report

    local duration_ms
    duration_ms=$(($(now_ms) - START_MS))
    printf -- '----------------------------------------\n'
    printf 'SUMMARY: %d passed, %d failed, %d skipped, %.1fs\n' \
        "$PASSED" "$FAILED" "$SKIPPED" "$(awk -v m="$duration_ms" 'BEGIN { printf "%.1f", m / 1000 }')"
    printf 'REPORT:  %s\n' "$REPORT_JSON"
    printf 'LOG:     %s\n' "$REPORT_LOG"

    ((FAILED == 0))
}

main "$@"
