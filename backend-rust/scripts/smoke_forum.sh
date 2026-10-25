#!/usr/bin/env bash
#
# Theseus 论坛 / 校园墙冒烟测试。
#
# 设计文档：doc/2610257_论坛功能设计方案.md
#
# 只操作真实运行的 API + PostgreSQL，不 mock 任何一层。覆盖：
#   发帖 / 匿名隐私 / 评论通知 / 回复通知 / 回复归一化 / 点赞收藏幂等 /
#   首次举报 / 阈值自动隐藏 / 管理员真实作者 / keep 自动恢复 /
#   管理员隐藏恢复 / 禁言 / 编辑 / 删除 / 匿名通知文案 /
#   搜索通配符转义 / 越界分页总数 / 禁言时长上限 / 并发限流 / 清理。
#
# 用法：
#   ./backend-rust/scripts/smoke_forum.sh
#   SMOKE_KEEP_DATA=1 ./backend-rust/scripts/smoke_forum.sh
#   SMOKE_VERBOSE=1 ./backend-rust/scripts/smoke_forum.sh
#
# 依赖：bash >= 4.2、curl、jq、psql。
# 安全性：只使用随机哑账号；报告不写入 token、密码、数据库连接串或正文。
# 只连接本地/测试数据库；不修改真实管理员密码。
#
# 退出码：0 全部通过或仅 SKIP；1 存在断言失败；2 前置条件不满足；3 服务不可达。

set -uo pipefail

# ---------------------------------------------------------------------------
# 路径与配置
# ---------------------------------------------------------------------------

SCRIPT_DIR=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)
REPO_ROOT=$(cd "$SCRIPT_DIR/../.." && pwd)
BACKEND_DIR="$REPO_ROOT/backend-rust"

ENV_FILE=${SMOKE_BACKEND_ENV:-"$BACKEND_DIR/.env"}
API_BASE=${SMOKE_API_BASE:-http://127.0.0.1:3000}
PROBLEM_ID=${SMOKE_PROBLEM_ID:-1001}
KEEP_DATA=${SMOKE_KEEP_DATA:-0}
VERBOSE=${SMOKE_VERBOSE:-0}
REPORT_DIR=${SMOKE_REPORT_DIR:-"$REPO_ROOT/.dev-logs"}
PASSWORD=${SMOKE_PASSWORD:-}
HIDE_THRESHOLD=${FORUM_REPORT_HIDE_THRESHOLD:-3}
COMMENT_COOLDOWN=${FORUM_COMMENT_COOLDOWN_SECS:-10}

# 运行期状态
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

USER_A=""
TOKEN_A=""
USER_B=""
TOKEN_B=""
USER_C=""
TOKEN_C=""
USER_D=""
TOKEN_D=""
USER_IDS=()
REPORTER_TOKENS=()
REPORTER_IDS=()
POST_ID=""
ROOT_COMMENT_ID=""
A_REPLY_ID=""
B_REPLY_ID=""
B_REPLY2_ID=""
POST_REPORT_ID=""
CLEANED=0
CLEANING_UP=0
CLEANUP_SQL=""

API_STATUS=""
API_BODY=""
REG_USER_ID=""
REG_TOKEN=""
TMP_DIR=""
TMP_BODY=""
TMP_HEADERS=""
REPORT_LOG=""
REPORT_JSON=""

# ---------------------------------------------------------------------------
# 基础输出与退出
# ---------------------------------------------------------------------------

say() { printf '==> %s\n' "$*"; }
warn() { printf '[WARN] %s\n' "$*"; }
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

# ---------------------------------------------------------------------------
# 环境加载（已有环境变量优先；不 source，避免执行文件内容）
# ---------------------------------------------------------------------------

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
    HIDE_THRESHOLD=${FORUM_REPORT_HIDE_THRESHOLD:-$HIDE_THRESHOLD}
    COMMENT_COOLDOWN=${FORUM_COMMENT_COOLDOWN_SECS:-$COMMENT_COOLDOWN}
}

# ---------------------------------------------------------------------------
# 断言与检查记录
# ---------------------------------------------------------------------------

record_check() {
    local id=$1 status=$2 duration_ms=$3
    local entry
    entry=$(jq -nc \
        --arg id "$id" \
        --arg status "$status" \
        --argjson duration_ms "$duration_ms" \
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
        printf '[PASS] %-24s %s\n' "$CHECK_ID" "$CHECK_NOTE"
        record_check "$CHECK_ID" passed "$duration_ms"
    else
        FAILED=$((FAILED + 1))
        printf '[FAIL] %-24s %d 项断言失败\n' "$CHECK_ID" "$CHECK_FAILS"
        record_check "$CHECK_ID" failed "$duration_ms"
    fi
}

skip_check() {
    local id=$1 reason=$2
    SKIPPED=$((SKIPPED + 1))
    printf '[SKIP] %-24s %s\n' "$id" "$reason"
    record_check "$id" skipped 0
}

fail_check() {
    CHECK_FAILS=$((CHECK_FAILS + 1))
    printf '       - %s\n' "$*" >&2
}

assert_eq() {
    local desc=$1 expected=$2 actual=$3
    [[ "$expected" == "$actual" ]] || fail_check "$desc：期望 [$expected]，实际 [$actual]"
}

assert_ne() {
    local desc=$1 unexpected=$2 actual=$3
    [[ "$unexpected" != "$actual" ]] || fail_check "$desc：不应等于 [$unexpected]"
}

assert_contains() {
    local desc=$1 haystack=$2 needle=$3
    [[ "$haystack" == *"$needle"* ]] || fail_check "$desc：[$haystack] 不包含 [$needle]"
}

assert_not_contains() {
    local desc=$1 haystack=$2 needle=$3
    [[ "$haystack" != *"$needle"* ]] || fail_check "$desc：[$haystack] 不应包含 [$needle]"
}

assert_nonempty() {
    local desc=$1 value=$2
    [[ -n "$value" && "$value" != "null" ]] || fail_check "$desc：为空"
}

assert_status() {
    local desc=$1 expected=$2
    [[ "$API_STATUS" == "$expected" ]] || fail_check "$desc：期望 HTTP $expected，实际 $API_STATUS（$(api_error)）"
}

assert_json_no_private_author() {
    local desc=$1 json=$2
    local leaked
    leaked=$(jq -r '[.. | objects | select(has("author_id") or has("username") or has("email"))] | length' <<<"$json" 2>/dev/null || printf '0')
    [[ "$leaked" == "0" ]] || fail_check "$desc：公开响应泄露了 author_id/username/email（$leaked 处）"
}

# ---------------------------------------------------------------------------
# HTTP / DB 辅助
# ---------------------------------------------------------------------------

api_request() {
    # api_request METHOD PATH TOKEN [BODY]
    # 结果写入 API_STATUS / API_BODY
    local method=$1 path=$2 token=${3:-} body=${4:-}
    : >"$TMP_BODY"
    : >"$TMP_HEADERS"
    local -a args=(-sS -X "$method" -H 'Content-Type: application/json'
        -o "$TMP_BODY" -D "$TMP_HEADERS" -w '%{http_code}')
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

db_query() {
    psql "$DATABASE_URL" -At -F '|' -v ON_ERROR_STOP=1 -c "$1" 2>/dev/null
}

db_scalar() {
    psql "$DATABASE_URL" -At -v ON_ERROR_STOP=1 -c "$1" 2>/dev/null
}

# ---------------------------------------------------------------------------
# 前置检查
# ---------------------------------------------------------------------------

preflight_env() {
    ((BASH_VERSINFO[0] > 4 || (BASH_VERSINFO[0] == 4 && BASH_VERSINFO[1] >= 2))) ||
        fatal_preflight "需要 bash >= 4.2（当前 ${BASH_VERSION}）"
    require_cmd curl
    require_cmd jq
    require_cmd psql

    [[ "$PROBLEM_ID" =~ ^[0-9]+$ ]] || fatal_preflight "SMOKE_PROBLEM_ID 必须是整数"
    [[ "$HIDE_THRESHOLD" =~ ^[0-9]+$ ]] || fatal_preflight "FORUM_REPORT_HIDE_THRESHOLD 必须是整数"
    ((HIDE_THRESHOLD >= 2 && HIDE_THRESHOLD <= 10)) ||
        fatal_preflight "FORUM_REPORT_HIDE_THRESHOLD 需要在 2–10 之间（当前 $HIDE_THRESHOLD；作者不能举报自己）"
    [[ "$COMMENT_COOLDOWN" =~ ^[0-9]+$ ]] || COMMENT_COOLDOWN=10

    psql "$DATABASE_URL" -At -c 'SELECT 1' >/dev/null 2>&1 ||
        fatal_service "PostgreSQL 不可达（检查 DATABASE_URL）"

    api_request GET /api/stats "" ""
    [[ "$API_STATUS" == "200" ]] ||
        fatal_service "API 不可达或返回异常（GET /api/stats -> $API_STATUS）"

    api_request GET '/api/forum/posts?size=1' "" ""
    [[ "$API_STATUS" == "503" ]] && fatal_preflight "论坛功能已关闭（FORUM_ENABLED=false）"
    [[ "$API_STATUS" == "200" ]] || fatal_service "论坛列表不可用（GET /api/forum/posts -> $API_STATUS）"

    local seed
    seed=$(db_scalar "SELECT review_status FROM problems WHERE id = $PROBLEM_ID")
    [[ -n "$seed" ]] || fatal_preflight "题目 $PROBLEM_ID 不存在；请先执行 backend-rust/scripts/seed_dev.sql"
    [[ "$seed" == "approved" ]] || fatal_preflight "题目 $PROBLEM_ID 未审核通过（review_status=$seed）"

    warn "举报自动隐藏阈值：$HIDE_THRESHOLD；评论冷却：${COMMENT_COOLDOWN}s"
}

# ---------------------------------------------------------------------------
# 账号
# ---------------------------------------------------------------------------

random_suffix() {
    printf '%s_%s' "$(date +%s)" "$RANDOM"
}

random_password() {
    tr -dc 'A-Za-z0-9' </dev/urandom | head -c 20
}

# register_and_login USERNAME EMAIL PASSWORD
# 设置 REG_USER_ID / REG_TOKEN
register_and_login() {
    local username=$1 email=$2 password=$3 body
    body=$(jq -nc --arg u "$username" --arg e "$email" --arg p "$password" \
        '{username:$u, email:$e, password:$p}')
    api_request POST /api/auth/register "" "$body"
    [[ "$API_STATUS" == "201" ]] || fatal_preflight "注册失败（HTTP $API_STATUS：$(api_error)）"

    login_only "$username" "$password"
}

login_only() {
    local username=$1 password=$2 body
    body=$(jq -nc --arg u "$username" --arg p "$password" '{username:$u, password:$p}')
    api_request POST /api/auth/login "" "$body"
    [[ "$API_STATUS" == "200" ]] || fatal_preflight "登录失败（HTTP $API_STATUS：$(api_error)）"
    REG_USER_ID=$(jq -r '.data.user.id // empty' <<<"$API_BODY")
    REG_TOKEN=$(jq -r '.data.token // empty' <<<"$API_BODY")
    [[ -n "$REG_USER_ID" && -n "$REG_TOKEN" ]] || fatal_preflight "登录响应缺少 user.id 或 token"
}

register_extra_reporter() {
    local index=$1 username email
    username="fsmoke_r${index}_${SUFFIX}"
    email="fsmoke_r${index}_${SUFFIX}@example.test"
    register_and_login "$username" "$email" "$PASSWORD"
    USER_IDS+=("$REG_USER_ID")
    REPORTER_IDS+=("$REG_USER_ID")
    REPORTER_TOKENS+=("$REG_TOKEN")
}

# ---------------------------------------------------------------------------
# 清理
# ---------------------------------------------------------------------------

build_cleanup_sql() {
    local ids
    ids=$(IFS=,; printf '%s' "${USER_IDS[*]}")
    CLEANUP_SQL="DELETE FROM moderation_actions WHERE actor_id IN ($ids) \
OR (target_type = 'post' AND target_id IN (SELECT id FROM forum_posts WHERE author_id IN ($ids))) \
OR (target_type = 'comment' AND target_id IN (SELECT id FROM forum_comments WHERE author_id IN ($ids) OR post_id IN (SELECT id FROM forum_posts WHERE author_id IN ($ids)))); \
DELETE FROM users WHERE id IN ($ids);"
}

cleanup_test_data() {
    local ids count
    ids=$(IFS=,; printf '%s' "${USER_IDS[*]}")
    [[ -n "$ids" ]] || return 0
    build_cleanup_sql
    if [[ "$KEEP_DATA" == "1" ]]; then
        printf '\n[INFO] SMOKE_KEEP_DATA=1，保留测试账号：%s\n' "$ids"
        printf '[INFO] 清理 SQL：%s\n' "$CLEANUP_SQL"
        return 0
    fi
    psql "$DATABASE_URL" -v ON_ERROR_STOP=1 -c "$CLEANUP_SQL" >/dev/null 2>&1 ||
        fail_check "执行清理 SQL 失败"
    count=$(db_scalar "SELECT COUNT(*) FROM users WHERE id IN ($ids)")
    assert_eq "清理后剩余测试账号" "0" "$count"
    CLEANED=1
    printf '\n[INFO] 已删除测试账号与级联数据\n'
}

# ---------------------------------------------------------------------------
# 报告
# ---------------------------------------------------------------------------

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
        --argjson problem_id "$PROBLEM_ID" \
        --argjson hide_threshold "$HIDE_THRESHOLD" \
        --arg post_id "${POST_ID:-}" \
        --arg cleaned "$CLEANED" \
        --arg git_commit "$(git -C "$REPO_ROOT" rev-parse --short HEAD 2>/dev/null || printf 'unknown')" \
        --argjson checks "$checks_json" \
        --argjson passed "$PASSED" \
        --argjson failed "$FAILED" \
        --argjson skipped "$SKIPPED" \
        --argjson duration_ms "$duration_ms" \
        '{started_at:$started_at, api_base:$api_base, problem_id:$problem_id,
          hide_threshold:$hide_threshold,
          post_id:(if $post_id == "" then null else ($post_id | tonumber) end),
          cleaned:($cleaned == "1"), git_commit:$git_commit, checks:$checks,
          summary:{passed:$passed, failed:$failed, skipped:$skipped, duration_ms:$duration_ms}}' \
        >"$REPORT_JSON"
}

cleanup() {
    ((CLEANING_UP)) && return 0
    CLEANING_UP=1
    if ((CLEANED == 0)) && [[ "$KEEP_DATA" != "1" && ${#USER_IDS[@]} -gt 0 ]]; then
        local ids
        ids=$(IFS=,; printf '%s' "${USER_IDS[*]}")
        psql "$DATABASE_URL" -v ON_ERROR_STOP=1 -c "$CLEANUP_SQL" >/dev/null 2>&1 || true
        if [[ -z "$CLEANUP_SQL" ]]; then
            psql "$DATABASE_URL" -v ON_ERROR_STOP=1 -c "DELETE FROM users WHERE id IN ($ids)" >/dev/null 2>&1 || true
        fi
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

# ---------------------------------------------------------------------------
# 主流程辅助
# ---------------------------------------------------------------------------

wait_comment_cooldown() {
    if ((COMMENT_COOLDOWN > 0)); then
        sleep "$((COMMENT_COOLDOWN + 1))"
    fi
}

get_post_detail() {
    local token=${1:-}
    api_request GET "/api/forum/posts/$POST_ID" "$token" ""
}

get_guest_comments() {
    api_request GET "/api/forum/posts/$POST_ID/comments" "" ""
}

# ---------------------------------------------------------------------------
# 主流程
# ---------------------------------------------------------------------------

main() {
    load_env

    mkdir -p "$REPORT_DIR" || fatal_preflight "无法创建报告目录 $REPORT_DIR"
    local stamp
    stamp=$(date -u +%Y%m%dT%H%M%SZ)
    REPORT_LOG="$REPORT_DIR/smoke-forum-$stamp.log"
    REPORT_JSON="$REPORT_DIR/smoke-forum-$stamp.json"
    exec > >(tee -a "$REPORT_LOG") 2>&1

    TMP_DIR=$(mktemp -d "${TMPDIR:-/tmp}/theseus-forum-smoke.XXXXXX") || fatal_preflight "无法创建临时目录"
    TMP_BODY="$TMP_DIR/body.json"
    TMP_HEADERS="$TMP_DIR/headers.txt"

    START_MS=$(now_ms)
    START_ISO=$(date -u +'%Y-%m-%dT%H:%M:%SZ')

    local db_host
    db_host=$(printf '%s' "$DATABASE_URL" | sed -E 's#^[a-z]+://##; s#^[^@]*@##; s#[/?].*$##')
    say "smoke: $API_BASE  problem=$PROBLEM_ID  db=$db_host  threshold=$HIDE_THRESHOLD"

    begin_check preflight
    preflight_env
    end_check

    # ------------------------------------------------------------------
    # 账号：A 作者、B 评论者/举报者、C 管理员/举报者，按阈值补足举报人
    # ------------------------------------------------------------------
    begin_check accounts
    SUFFIX=$(random_suffix)
    PASSWORD=${PASSWORD:-$(random_password)}

    A_USER="fsmoke_a_${SUFFIX}"
    B_USER="fsmoke_b_${SUFFIX}"
    C_USER="fsmoke_c_${SUFFIX}"

    register_and_login "$A_USER" "fsmoke_a_${SUFFIX}@example.test" "$PASSWORD"
    USER_A=$REG_USER_ID
    TOKEN_A=$REG_TOKEN
    USER_IDS+=("$USER_A")

    register_and_login "$B_USER" "fsmoke_b_${SUFFIX}@example.test" "$PASSWORD"
    USER_B=$REG_USER_ID
    TOKEN_B=$REG_TOKEN
    USER_IDS+=("$USER_B")

    register_and_login "$C_USER" "fsmoke_c_${SUFFIX}@example.test" "$PASSWORD"
    USER_C=$REG_USER_ID
    TOKEN_C=$REG_TOKEN
    USER_IDS+=("$USER_C")

    # 只把 C 这个一次性测试账号提升为管理员；不触碰任何真实管理员。
    db_scalar "UPDATE users SET role = 'admin' WHERE id = $USER_C" >/dev/null ||
        fatal_preflight "无法将测试账号 C 提升为管理员"
    login_only "$C_USER" "$PASSWORD"
    TOKEN_C=$REG_TOKEN
    assert_eq "C 登录角色" "admin" "$(jq -r '.data.user.role // empty' <<<"$API_BODY")"

    # D 只用于并发评论限流回归，不参与举报。
    local D_USER="fsmoke_d_${SUFFIX}"
    register_and_login "$D_USER" "fsmoke_d_${SUFFIX}@example.test" "$PASSWORD"
    USER_D=$REG_USER_ID
    TOKEN_D=$REG_TOKEN
    USER_IDS+=("$USER_D")

    # 第 1 个举报人使用 B，第 2 个使用管理员 C；阈值大于 2 时继续注册哑账号。
    REPORTER_IDS=("$USER_B" "$USER_C")
    REPORTER_TOKENS=("$TOKEN_B" "$TOKEN_C")
    local index=1
    while ((${#REPORTER_IDS[@]} < HIDE_THRESHOLD)); do
        index=$((index + 1))
        register_extra_reporter "$index"
    done
    CHECK_NOTE="A/B/C/D + $(( ${#REPORTER_IDS[@]} - 2 )) 个举报辅助账号"
    end_check

    # ------------------------------------------------------------------
    # 1. 发帖
    # ------------------------------------------------------------------
    begin_check create_post
    local title body create_json
    title="冒烟测试帖子 ${SUFFIX}"
    body=$'## 冒烟测试\n\n这是一条自动生成的匿名帖子，用于验证论坛链路。\n\n```txt\nsmoke\n```'
    create_json=$(jq -nc \
        --arg title "$title" \
        --arg body "$body" \
        --argjson problem "$PROBLEM_ID" \
        '{title:$title, body_md:$body, tags:["help"], problem_id:$problem, is_anonymous:true}')
    api_request POST /api/forum/posts "$TOKEN_A" "$create_json"
    assert_status "发帖" "201"
    POST_ID=$(jq -r '.data.id // empty' <<<"$API_BODY")
    assert_nonempty "post_id" "$POST_ID"
    assert_eq "新帖状态" "published" "$(jq -r '.data.status // empty' <<<"$API_BODY")"
    CHECK_NOTE="post=$POST_ID"
    end_check

    # ------------------------------------------------------------------
    # 1b. 搜索通配符必须按字面量处理（P2-5）
    # ------------------------------------------------------------------
    begin_check search_literal
    local pct_title plain_title pct_json plain_json pct_post plain_post
    pct_title="literal%marker_${SUFFIX}"
    plain_title="literalXmarkerX${SUFFIX}"
    pct_json=$(jq -nc --arg title "$pct_title" '{title:$title, body_md:"搜索通配符回归。", tags:["general"]}')
    plain_json=$(jq -nc --arg title "$plain_title" '{title:$title, body_md:"搜索通配符回归。", tags:["general"]}')

    api_request POST /api/forum/posts "$TOKEN_B" "$pct_json"
    assert_status "含 % 的帖子" "201"
    pct_post=$(jq -r '.data.id // empty' <<<"$API_BODY")
    assert_nonempty "pct_post_id" "$pct_post"

    api_request POST /api/forum/posts "$TOKEN_C" "$plain_json"
    assert_status "普通帖子" "201"
    plain_post=$(jq -r '.data.id // empty' <<<"$API_BODY")
    assert_nonempty "plain_post_id" "$plain_post"

    local pct_pattern plain_pattern pct_hits plain_hits
    pct_pattern="%marker_${SUFFIX}"
    api_request GET "/api/forum/posts?q=$(jq -rn --arg q "$pct_pattern" '$q|@uri')&size=50" "" ""
    assert_status "含 %% 搜索" "200"
    pct_hits=$(jq -r --argjson id "$pct_post" '[.data.posts[] | select(.id == $id)] | length' <<<"$API_BODY")
    plain_hits=$(jq -r --argjson id "$plain_post" '[.data.posts[] | select(.id == $id)] | length' <<<"$API_BODY")
    assert_eq "%% 只匹配字面量" "1" "$pct_hits"
    assert_eq "%% 不匹配普通帖子" "0" "$plain_hits"

    plain_pattern="marker_${SUFFIX}"
    api_request GET "/api/forum/posts?q=$(jq -rn --arg q "$plain_pattern" '$q|@uri')&size=50" "" ""
    assert_status "含下划线搜索" "200"
    pct_hits=$(jq -r --argjson id "$pct_post" '[.data.posts[] | select(.id == $id)] | length' <<<"$API_BODY")
    plain_hits=$(jq -r --argjson id "$plain_post" '[.data.posts[] | select(.id == $id)] | length' <<<"$API_BODY")
    assert_eq "下划线只匹配字面量" "1" "$pct_hits"
    assert_eq "下划线不匹配普通帖子" "0" "$plain_hits"
    end_check

    # ------------------------------------------------------------------
    # 2. 匿名公开可见且不泄露身份
    # ------------------------------------------------------------------
    begin_check anonymous_public
    local list_json detail_json
    api_request GET "/api/forum/posts?q=$(jq -rn --arg q "$title" '$q|@uri')&size=20" "" ""
    assert_status "游客列表" "200"
    list_json=$(jq -c '.data' <<<"$API_BODY")
    assert_json_no_private_author "游客列表" "$list_json"
    local listed
    listed=$(jq -r --argjson id "$POST_ID" '.posts[] | select(.id == $id) | .author.display_name + "|" + (.author.is_anonymous|tostring) + "|" + (.author.is_self|tostring)' <<<"$list_json")
    assert_eq "列表匿名作者" "匿名同学|true|false" "$listed"

    get_post_detail ""
    assert_status "游客详情" "200"
    detail_json=$(jq -c '.data' <<<"$API_BODY")
    assert_json_no_private_author "游客详情" "$detail_json"
    assert_eq "详情匿名作者" "匿名同学|true|false" \
        "$(jq -r '.author.display_name + "|" + (.author.is_anonymous|tostring) + "|" + (.author.is_self|tostring)' <<<"$detail_json")"

    get_post_detail "$TOKEN_A"
    assert_status "作者详情" "200"
    assert_eq "作者 is_self" "true" "$(jq -r '.data.author.is_self' <<<"$API_BODY")"
    assert_eq "作者可见题目引用" "$PROBLEM_ID" "$(jq -r '.data.problem.id // empty' <<<"$API_BODY")"
    end_check

    # ------------------------------------------------------------------
    # 3. B 评论 → A 收到 forum_comment
    # ------------------------------------------------------------------
    begin_check comment_notification
    local comment_json
    comment_json=$(jq -nc --arg body "空数组要单独判断。smoke" '{body_md:$body, is_anonymous:false}')
    api_request POST "/api/forum/posts/$POST_ID/comments" "$TOKEN_B" "$comment_json"
    assert_status "B 评论" "201"
    ROOT_COMMENT_ID=$(jq -r '.data.id // empty' <<<"$API_BODY")
    assert_nonempty "root_comment_id" "$ROOT_COMMENT_ID"
    assert_eq "顶层 parent_id" "null" "$(jq -r '.data.parent_id' <<<"$API_BODY")"

    api_request GET '/api/notifications?size=50' "$TOKEN_A" ""
    assert_status "A 通知列表" "200"
    local comment_notification
    comment_notification=$(jq -r --arg user "$B_USER" '.data.notifications[] | select(.type == "forum_comment" and (.title | contains($user))) | .title' <<<"$API_BODY" | head -n 1)
    assert_contains "评论通知标题" "$comment_notification" "$B_USER"
    end_check

    # ------------------------------------------------------------------
    # 4. A 匿名回复 B → B 收到 forum_reply 且文案匿名
    # ------------------------------------------------------------------
    begin_check reply_notification
    comment_json=$(jq -nc \
        --arg body "明白了，谢谢！smoke" \
        --argjson parent "$ROOT_COMMENT_ID" \
        --argjson target "$ROOT_COMMENT_ID" \
        '{body_md:$body, parent_id:$parent, reply_to_comment_id:$target, is_anonymous:true}')
    api_request POST "/api/forum/posts/$POST_ID/comments" "$TOKEN_A" "$comment_json"
    assert_status "A 回复" "201"
    A_REPLY_ID=$(jq -r '.data.id // empty' <<<"$API_BODY")
    assert_nonempty "A reply id" "$A_REPLY_ID"
    assert_eq "A 回复 parent_id" "$ROOT_COMMENT_ID" "$(jq -r '.data.parent_id' <<<"$API_BODY")"

    api_request GET '/api/notifications?size=50' "$TOKEN_B" ""
    assert_status "B 通知列表" "200"
    local reply_notification
    reply_notification=$(jq -r '.data.notifications[] | select(.type == "forum_reply") | .title' <<<"$API_BODY" | head -n 1)
    assert_contains "回复通知标题" "$reply_notification" "匿名同学"
    assert_not_contains "回复通知不泄露 A" "$reply_notification" "$A_USER"
    end_check

    # ------------------------------------------------------------------
    # 5. B 回复 A 的回复，再回复自己的回复：parent_id 始终归一为根评论
    # ------------------------------------------------------------------
    begin_check reply_normalization
    wait_comment_cooldown
    comment_json=$(jq -nc \
        --arg body "我也遇到过这个问题。smoke" \
        --argjson parent "$ROOT_COMMENT_ID" \
        --argjson target "$A_REPLY_ID" \
        '{body_md:$body, parent_id:$parent, reply_to_comment_id:$target, is_anonymous:false}')
    api_request POST "/api/forum/posts/$POST_ID/comments" "$TOKEN_B" "$comment_json"
    assert_status "B 回复 A" "201"
    B_REPLY_ID=$(jq -r '.data.id // empty' <<<"$API_BODY")
    assert_nonempty "B reply id" "$B_REPLY_ID"
    assert_eq "B 回复 A 的 parent_id" "$ROOT_COMMENT_ID" "$(jq -r '.data.parent_id' <<<"$API_BODY")"
    assert_eq "B 回复 A 的 reply_to" "$A_REPLY_ID" "$(jq -r '.data.reply_to.comment_id' <<<"$API_BODY")"

    wait_comment_cooldown
    comment_json=$(jq -nc \
        --arg body "补充一条：回复自己的回复。smoke" \
        --argjson parent "$ROOT_COMMENT_ID" \
        --argjson target "$B_REPLY_ID" \
        '{body_md:$body, parent_id:$parent, reply_to_comment_id:$target, is_anonymous:false}')
    api_request POST "/api/forum/posts/$POST_ID/comments" "$TOKEN_B" "$comment_json"
    assert_status "B 回复自己的回复" "201"
    B_REPLY2_ID=$(jq -r '.data.id // empty' <<<"$API_BODY")
    assert_nonempty "B reply2 id" "$B_REPLY2_ID"
    assert_eq "B 回复自己的回复的 parent_id" "$ROOT_COMMENT_ID" "$(jq -r '.data.parent_id' <<<"$API_BODY")"
    assert_eq "B 回复自己的回复的 reply_to" "$B_REPLY_ID" "$(jq -r '.data.reply_to.comment_id' <<<"$API_BODY")"

    local db_parent reply_to_user
    db_parent=$(db_scalar "SELECT parent_id FROM forum_comments WHERE id = $B_REPLY2_ID")
    assert_eq "DB parent_id" "$ROOT_COMMENT_ID" "$db_parent"
    reply_to_user=$(db_scalar "SELECT reply_to_user_id FROM forum_comments WHERE id = $B_REPLY2_ID")
    assert_eq "DB reply_to_user_id" "$USER_B" "$reply_to_user"

    get_guest_comments
    assert_status "游客评论列表" "200"
    local root_reply_total
    root_reply_total=$(jq -r --argjson id "$ROOT_COMMENT_ID" '.data.comments[] | select(.id == $id) | .reply_total' <<<"$API_BODY")
    assert_eq "根评论 reply_total" "3" "$root_reply_total"
    end_check

    # ------------------------------------------------------------------
    # 5b. 越界分页仍返回真实 total（P1-3）
    # ------------------------------------------------------------------
    begin_check pagination_bounds
    local out_total out_len

    api_request GET '/api/forum/posts?page=9999&size=20' "" ""
    assert_status "帖子越界分页" "200"
    out_total=$(jq -r '.data.total' <<<"$API_BODY")
    out_len=$(jq -r '.data.posts | length' <<<"$API_BODY")
    [[ "${out_total:-0}" -ge 1 ]] || fail_check "帖子越界 total 应 >= 1，实际 [$out_total]"
    assert_eq "帖子越界返回空页" "0" "$out_len"

    api_request GET "/api/forum/posts/$POST_ID/comments?page=9999&size=20" "" ""
    assert_status "评论越界分页" "200"
    out_total=$(jq -r '.data.total' <<<"$API_BODY")
    out_len=$(jq -r '.data.comments | length' <<<"$API_BODY")
    [[ "${out_total:-0}" -ge 1 ]] || fail_check "评论越界 total 应 >= 1，实际 [$out_total]"
    assert_eq "评论越界返回空页" "0" "$out_len"

    api_request GET "/api/forum/comments/$ROOT_COMMENT_ID/replies?page=9999&size=20" "" ""
    assert_status "回复越界分页" "200"
    out_total=$(jq -r '.data.total' <<<"$API_BODY")
    out_len=$(jq -r '.data.replies | length' <<<"$API_BODY")
    assert_eq "回复越界 total" "3" "$out_total"
    assert_eq "回复越界返回空页" "0" "$out_len"

    api_request GET '/api/notifications?page=9999&size=20' "$TOKEN_A" ""
    assert_status "通知越界分页" "200"
    out_total=$(jq -r '.data.total' <<<"$API_BODY")
    out_len=$(jq -r '.data.notifications | length' <<<"$API_BODY")
    [[ "${out_total:-0}" -ge 1 ]] || fail_check "通知越界 total 应 >= 1，实际 [$out_total]"
    assert_eq "通知越界返回空页" "0" "$out_len"
    end_check

    # ------------------------------------------------------------------
    # 5c. 管理员隐藏/恢复评论（与帖子状态共用治理流程）
    # ------------------------------------------------------------------
    begin_check admin_comment_status
    api_request PUT "/api/admin/forum/comments/$ROOT_COMMENT_ID/status" "$TOKEN_C" \
        '{"status":"hidden","reason":"smoke 隐藏评论"}'
    assert_status "管理员隐藏评论" "200"
    assert_eq "评论隐藏落库" "hidden" \
        "$(db_scalar "SELECT status FROM forum_comments WHERE id = $ROOT_COMMENT_ID")"

    api_request PUT "/api/admin/forum/comments/$ROOT_COMMENT_ID/status" "$TOKEN_C" \
        '{"status":"published","reason":"smoke 恢复评论"}'
    assert_status "管理员恢复评论" "200"
    assert_eq "评论恢复落库" "published" \
        "$(db_scalar "SELECT status FROM forum_comments WHERE id = $ROOT_COMMENT_ID")"
    end_check

    # ------------------------------------------------------------------
    # 6. 点赞/收藏幂等
    # ------------------------------------------------------------------
    begin_check reactions_idempotent
    api_request POST "/api/forum/posts/$POST_ID/like" "$TOKEN_B" ""
    assert_status "首次点赞" "200"
    assert_eq "首次点赞状态" "true" "$(jq -r '.data.liked' <<<"$API_BODY")"
    local like_after_first
    like_after_first=$(jq -r '.data.like_count' <<<"$API_BODY")
    api_request POST "/api/forum/posts/$POST_ID/like" "$TOKEN_B" ""
    assert_status "重复点赞" "200"
    assert_eq "重复点赞计数" "$like_after_first" "$(jq -r '.data.like_count' <<<"$API_BODY")"
    api_request DELETE "/api/forum/posts/$POST_ID/like" "$TOKEN_B" ""
    assert_status "取消点赞" "200"
    assert_eq "取消点赞状态" "false" "$(jq -r '.data.liked' <<<"$API_BODY")"
    local like_after_unlike
    like_after_unlike=$(jq -r '.data.like_count' <<<"$API_BODY")
    api_request DELETE "/api/forum/posts/$POST_ID/like" "$TOKEN_B" ""
    assert_status "重复取消点赞" "200"
    assert_eq "重复取消点赞计数" "$like_after_unlike" "$(jq -r '.data.like_count' <<<"$API_BODY")"

    api_request POST "/api/forum/posts/$POST_ID/favorite" "$TOKEN_B" ""
    assert_status "首次收藏" "200"
    assert_eq "首次收藏状态" "true" "$(jq -r '.data.favorited' <<<"$API_BODY")"
    local fav_after_first
    fav_after_first=$(jq -r '.data.favorite_count' <<<"$API_BODY")
    api_request POST "/api/forum/posts/$POST_ID/favorite" "$TOKEN_B" ""
    assert_status "重复收藏" "200"
    assert_eq "重复收藏计数" "$fav_after_first" "$(jq -r '.data.favorite_count' <<<"$API_BODY")"
    api_request DELETE "/api/forum/posts/$POST_ID/favorite" "$TOKEN_B" ""
    assert_status "取消收藏" "200"
    assert_eq "取消收藏状态" "false" "$(jq -r '.data.favorited' <<<"$API_BODY")"
    api_request DELETE "/api/forum/posts/$POST_ID/favorite" "$TOKEN_B" ""
    assert_status "重复取消收藏" "200"

    get_post_detail ""
    assert_eq "最终 like_count" "0" "$(jq -r '.data.like_count' <<<"$API_BODY")"
    assert_eq "最终 favorite_count" "0" "$(jq -r '.data.favorite_count' <<<"$API_BODY")"
    end_check

    # ------------------------------------------------------------------
    # 7/8. 举报：首次不隐藏，达到阈值自动隐藏
    # ------------------------------------------------------------------
    begin_check report_first
    local report_json
    report_json=$(jq -nc --argjson target "$POST_ID" \
        '{target_type:"post", target_id:$target, reason:"spam", detail:"smoke 自动举报"}')
    api_request POST /api/forum/reports "$TOKEN_B" "$report_json"
    assert_status "B 首次举报" "201"
    POST_REPORT_ID=$(jq -r '.data.report_id // empty' <<<"$API_BODY")
    assert_nonempty "report_id" "$POST_REPORT_ID"
    if ((HIDE_THRESHOLD > 1)); then
        assert_eq "首次举报 hidden" "false" "$(jq -r '.data.hidden' <<<"$API_BODY")"
    fi

    api_request POST /api/forum/reports "$TOKEN_B" "$report_json"
    assert_status "B 重复举报" "409"
    assert_contains "重复举报文案" "$(api_error)" "已举报过"
    end_check

    begin_check report_threshold
    local i reporter_hidden
    for ((i = 1; i < HIDE_THRESHOLD; i++)); do
        api_request POST /api/forum/reports "${REPORTER_TOKENS[$i]}" "$report_json"
        assert_status "第 $((i + 1)) 位举报人" "201"
        reporter_hidden=$(jq -r '.data.hidden' <<<"$API_BODY")
        if ((i + 1 >= HIDE_THRESHOLD)); then
            assert_eq "达到阈值 hidden" "true" "$reporter_hidden"
        else
            assert_eq "未达阈值 hidden" "false" "$reporter_hidden"
        fi
    done

    get_post_detail ""
    assert_status "隐藏后游客详情" "404"
    get_post_detail "$TOKEN_A"
    assert_status "隐藏后作者详情" "200"
    assert_eq "作者看到 hidden_reason" "report_threshold" "$(jq -r '.data.hidden_reason' <<<"$API_BODY")"
    assert_eq "作者 hidden 帖不可编辑" "false" "$(jq -r '.data.can_edit' <<<"$API_BODY")"
    assert_eq "作者 hidden 帖可删除" "true" "$(jq -r '.data.can_delete' <<<"$API_BODY")"
    end_check

    # ------------------------------------------------------------------
    # 8b. 管理端越界分页与独立 pending_total（P1-3 / P3-1）
    # ------------------------------------------------------------------
    begin_check admin_report_totals
    local pending_total all_total reports_len
    api_request GET '/api/admin/forum/reports?status=rejected&page=9999&size=20' "$TOKEN_C" ""
    assert_status "管理端越界分页" "200"
    reports_len=$(jq -r '.data.reports | length' <<<"$API_BODY")
    all_total=$(jq -r '.data.total' <<<"$API_BODY")
    pending_total=$(jq -r '.data.pending_total' <<<"$API_BODY")
    [[ "${all_total:-x}" =~ ^[0-9]+$ ]] || fail_check "已驳回筛选 total 不是整数：[$all_total]"
    assert_eq "越界返回空页" "0" "$reports_len"
    [[ "${pending_total:-0}" -ge 1 ]] ||
        fail_check "待处理总数应 >= 1（与筛选/页码无关），实际 [$pending_total]"

    api_request GET '/api/admin/forum/reports?status=all&page=9999&size=20' "$TOKEN_C" ""
    assert_status "管理端全部越界分页" "200"
    all_total=$(jq -r '.data.total' <<<"$API_BODY")
    pending_total=$(jq -r '.data.pending_total' <<<"$API_BODY")
    [[ "${all_total:-0}" -ge 1 ]] || fail_check "全部举报 total 应 >= 1，实际 [$all_total]"
    [[ "${pending_total:-0}" -ge 1 ]] || fail_check "待处理 total 应 >= 1，实际 [$pending_total]"
    end_check

    # ------------------------------------------------------------------
    # 9. 管理端可见真实作者
    # ------------------------------------------------------------------
    begin_check admin_author_visibility
    api_request GET "/api/admin/forum/posts?q=$(jq -rn --arg q "$title" '$q|@uri')&status=hidden&size=50" "$TOKEN_C" ""
    assert_status "管理员内容列表" "200"
    local admin_author
    admin_author=$(jq -r --argjson id "$POST_ID" '.data.posts[] | select(.id == $id) | .author.username + "|" + .status' <<<"$API_BODY")
    assert_eq "管理员列表真实作者" "$A_USER|hidden" "$admin_author"

    api_request GET "/api/admin/forum/posts/$POST_ID" "$TOKEN_C" ""
    assert_status "管理员帖子详情" "200"
    assert_eq "管理员详情真实作者" "$A_USER" "$(jq -r '.data.post.author.username' <<<"$API_BODY")"
    assert_eq "管理员详情匿名标记" "true" "$(jq -r '.data.post.is_anonymous' <<<"$API_BODY")"

    api_request GET '/api/forum/posts?size=1' "" ""
    assert_json_no_private_author "公开列表（管理员请求前）" "$(jq -c '.data' <<<"$API_BODY")"
    api_request GET "/api/forum/posts/$POST_ID" "$TOKEN_C" ""
    assert_status "管理员走公开详情仍不可见" "404"
    end_check

    # ------------------------------------------------------------------
    # 10. keep 自动恢复
    # ------------------------------------------------------------------
    begin_check admin_keep_restore
    local decision_json
    decision_json=$(jq -nc '{decision:"keep", note:"smoke 保留"}')
    api_request PUT "/api/admin/forum/reports/$POST_REPORT_ID" "$TOKEN_C" "$decision_json"
    assert_status "keep 举报" "200"
    assert_eq "keep 后 report 状态" "rejected" "$(jq -r '.data.status' <<<"$API_BODY")"
    assert_eq "keep 后 target 状态" "published" "$(jq -r '.data.target_status' <<<"$API_BODY")"
    assert_eq "keep 后自动恢复" "true" "$(jq -r '.data.restored' <<<"$API_BODY")"

    get_post_detail ""
    assert_status "恢复后游客详情" "200"
    api_request PUT "/api/admin/forum/reports/$POST_REPORT_ID" "$TOKEN_C" "$decision_json"
    assert_status "重复处理举报" "409"
    end_check

    # ------------------------------------------------------------------
    # 11. 管理员手动隐藏/恢复
    # ------------------------------------------------------------------
    begin_check admin_manual_status
    local status_json
    status_json=$(jq -nc '{status:"hidden", reason:"smoke 手动隐藏"}')
    api_request PUT "/api/admin/forum/posts/$POST_ID/status" "$TOKEN_C" "$status_json"
    assert_status "管理员隐藏" "200"
    get_post_detail ""
    assert_status "手动隐藏后游客 404" "404"
    status_json=$(jq -nc '{status:"published", reason:"smoke 恢复"}')
    api_request PUT "/api/admin/forum/posts/$POST_ID/status" "$TOKEN_C" "$status_json"
    assert_status "管理员恢复" "200"
    get_post_detail ""
    assert_status "手动恢复后游客 200" "200"
    end_check

    # ------------------------------------------------------------------
    # 12. 禁言只阻止发内容，解除后恢复
    # ------------------------------------------------------------------
    begin_check mute_enforcement
    local mute_json

    # P1-4：超大/非法时长必须返回 400，而不是 panic 或 500。
    mute_json='{"duration_hours":9223372036854775807,"reason":"smoke overflow"}'
    api_request POST "/api/admin/forum/users/$USER_B/mute" "$TOKEN_C" "$mute_json"
    assert_status "超大禁言时长" "400"
    mute_json=$(jq -nc '{duration_hours:-1, reason:"smoke negative"}')
    api_request POST "/api/admin/forum/users/$USER_B/mute" "$TOKEN_C" "$mute_json"
    assert_status "负数禁言时长" "400"

    mute_json=$(jq -nc '{duration_hours:1, reason:"smoke 禁言"}')
    api_request POST "/api/admin/forum/users/$USER_B/mute" "$TOKEN_C" "$mute_json"
    assert_status "管理员禁言" "200"
    assert_eq "禁言用户" "$USER_B" "$(jq -r '.data.user_id' <<<"$API_BODY")"

    comment_json=$(jq -nc --arg body "禁言期间不应写入。smoke" '{body_md:$body}')
    api_request POST "/api/forum/posts/$POST_ID/comments" "$TOKEN_B" "$comment_json"
    assert_status "禁言期间评论" "403"
    assert_contains "禁言文案" "$(api_error)" "已被禁言"

    api_request POST "/api/forum/posts/$POST_ID/like" "$TOKEN_B" ""
    assert_status "禁言期间仍可点赞" "200"
    api_request DELETE "/api/forum/posts/$POST_ID/like" "$TOKEN_B" ""

    api_request DELETE "/api/admin/forum/users/$USER_B/mute" "$TOKEN_C" ""
    assert_status "解除禁言" "200"
    wait_comment_cooldown
    api_request POST "/api/forum/posts/$POST_ID/comments" "$TOKEN_B" "$comment_json"
    assert_status "解除后评论" "201"
    end_check

    # ------------------------------------------------------------------
    # 13. 编辑帖子
    # ------------------------------------------------------------------
    begin_check post_edit
    local edit_json
    edit_json=$(jq -nc \
        --arg title "$title（已编辑）" \
        --arg body "$body" \
        --argjson problem "$PROBLEM_ID" \
        '{title:$title, body_md:$body, tags:["help","discussion"], problem_id:$problem}')
    api_request PUT "/api/forum/posts/$POST_ID" "$TOKEN_A" "$edit_json"
    assert_status "A 编辑帖子" "200"
    get_post_detail ""
    assert_status "编辑后详情" "200"
    assert_eq "edited_at 非空" "true" "$(jq -r '.data.edited_at != null' <<<"$API_BODY")"
    assert_eq "编辑后标签数" "2" "$(jq -r '.data.tags | length' <<<"$API_BODY")"
    end_check

    # ------------------------------------------------------------------
    # 13b. 并发评论只能有一条穿过冷却（P1-2 advisory lock）
    # ------------------------------------------------------------------
    if ((COMMENT_COOLDOWN > 0)); then
        begin_check cooldown_concurrency
        local cbody1 cbody2 code1 code2 pid1 pid2 sorted_codes d_comments
        cbody1=$(jq -nc --arg b "并发评论一号 ${SUFFIX}" '{body_md:$b}')
        cbody2=$(jq -nc --arg b "并发评论二号 ${SUFFIX}" '{body_md:$b}')

        curl -sS -o "$TMP_DIR/conc1.json" -w '%{http_code}' \
            -X POST -H 'Content-Type: application/json' \
            -H "Authorization: Bearer $TOKEN_D" --data-binary "$cbody1" \
            "$API_BASE/api/forum/posts/$POST_ID/comments" \
            >"$TMP_DIR/conc1.code" 2>"$TMP_DIR/conc1.err" &
        pid1=$!
        curl -sS -o "$TMP_DIR/conc2.json" -w '%{http_code}' \
            -X POST -H 'Content-Type: application/json' \
            -H "Authorization: Bearer $TOKEN_D" --data-binary "$cbody2" \
            "$API_BASE/api/forum/posts/$POST_ID/comments" \
            >"$TMP_DIR/conc2.code" 2>"$TMP_DIR/conc2.err" &
        pid2=$!
        wait "$pid1" "$pid2"

        code1=$(cat "$TMP_DIR/conc1.code" 2>/dev/null)
        code2=$(cat "$TMP_DIR/conc2.code" 2>/dev/null)
        sorted_codes=$(printf '%s\n%s\n' "$code1" "$code2" | sort | tr '\n' ' ' | sed 's/ *$//')
        assert_eq "并发评论状态" "201 429" "$sorted_codes"

        d_comments=$(db_scalar "SELECT COUNT(*) FROM forum_comments WHERE author_id = $USER_D AND post_id = $POST_ID AND status = 'published'")
        assert_eq "并发后仅一条评论落库" "1" "$d_comments"
        end_check
    else
        skip_check cooldown_concurrency "评论冷却为 0，无法验证并发限流"
    fi

    # ------------------------------------------------------------------
    # 14. 删除帖子
    # ------------------------------------------------------------------
    begin_check post_delete
    api_request DELETE "/api/forum/posts/$POST_ID" "$TOKEN_A" ""
    assert_status "A 删除帖子" "200"
    get_post_detail ""
    assert_status "游客删除后 404" "404"
    get_post_detail "$TOKEN_A"
    assert_status "作者删除后 404" "404"
    get_guest_comments
    assert_status "删除后评论 404" "404"
    end_check

    # ------------------------------------------------------------------
    # 15. 匿名通知文案
    # ------------------------------------------------------------------
    begin_check anonymous_notifications
    local leaked
    leaked=$(db_scalar "SELECT COUNT(*) FROM notifications WHERE actor_id = $USER_A AND (title LIKE '%' || '$A_USER' || '%' OR COALESCE(body, '') LIKE '%' || '$A_USER' || '%')")
    assert_eq "A 匿名行为产生的通知泄露用户名" "0" "$leaked"
    local anonymous_count
    anonymous_count=$(db_scalar "SELECT COUNT(*) FROM notifications WHERE actor_id = $USER_A AND title LIKE '%匿名同学%'")
    [[ "${anonymous_count:-0}" -ge 1 ]] || fail_check "未找到匿名同学通知文案"
    end_check

    # ------------------------------------------------------------------
    # 16. 清理
    # ------------------------------------------------------------------
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
