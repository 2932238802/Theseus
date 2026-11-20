#!/usr/bin/env bash
#
# Theseus 面经类型与 HR 面模板冒烟测试。
#
# 设计文档：doc/archive/20261119/4-面经板块改版-开发文档.md（CR-002 / CR-003）
#
# 只操作真实运行的 API + PostgreSQL，不 mock 任何一层。覆盖：
#   未登录 401 / 非 Plus 403 / Plus 列表 200 /
#   类型筛选 total 与标签一致 / 非法类型 400 /
#   发面经缺类型、未知类型、综合板块带类型 400 /
#   管理端改类型 200 与审计、非管理员 403 /
#   模板管理端 403 / 创建 201 / 长度 400 / 读者端读取 /
#   更新 / 排序成功与重复缺项 400 / 删除 404 与成功 / 审计 / 清理。
#
# 用法：
#   ./backend-rust/scripts/smoke_interview_templates.sh
#   SMOKE_KEEP_DATA=1 ./backend-rust/scripts/smoke_interview_templates.sh
#   SMOKE_VERBOSE=1 ./backend-rust/scripts/smoke_interview_templates.sh
#
# 依赖：bash >= 4.2、curl、jq、psql。
# 安全性：只使用随机哑账号；不输出 token、密码或数据库连接串。
# 前置：后端已启动并执行迁移 0048 / 0049（启动 API 时自动执行）。
#
# 退出码：0 全部通过；1 存在断言失败；2 前置条件不满足；3 服务不可达。

set -uo pipefail

SCRIPT_DIR=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)
REPO_ROOT=$(cd "$SCRIPT_DIR/../.." && pwd)
BACKEND_DIR="$REPO_ROOT/backend-rust"

ENV_FILE=${SMOKE_BACKEND_ENV:-"$BACKEND_DIR/.env"}
API_BASE=${SMOKE_API_BASE:-http://127.0.0.1:3000}
KEEP_DATA=${SMOKE_KEEP_DATA:-0}
VERBOSE=${SMOKE_VERBOSE:-0}

TMP_DIR=$(mktemp -d "${TMPDIR:-/tmp}/theseus-interview-smoke.XXXXXX") || {
    printf '[FAIL] 无法创建临时目录\n' >&2
    exit 2
}
trap 'rm -rf "$TMP_DIR"' EXIT

PASSED=0
FAILED=0

ADMIN_USER=""
ADMIN_ID=""
ADMIN_TOKEN=""
PLUS_USER=""
PLUS_ID=""
PLUS_TOKEN=""
PLAIN_USER=""
PLAIN_ID=""
PLAIN_TOKEN=""
SUFFIX=""
PASSWORD=""
HR_POST_ID=""
TECH_POST_ID=""
T1_ID=""
T2_ID=""
ORIG_IDS_JSON=""
ORDER_RESTORED=0
TEMPLATES_DELETED=0

say() { printf '==> %s\n' "$*"; }
info() { ((VERBOSE)) && printf '[debug] %s\n' "$*"; return 0; }
pass() { PASSED=$((PASSED + 1)); printf '[PASS] %s\n' "$1"; }
fail() { FAILED=$((FAILED + 1)); printf '[FAIL] %s\n' "$1" >&2; }
fatal() { printf '[FAIL] %s\n' "$*" >&2; exit 2; }
fatal_service() { printf '[FAIL] 服务不可达：%s\n' "$*" >&2; exit 3; }

require_cmd() { command -v "$1" >/dev/null 2>&1 || fatal "缺少命令 $1"; }

load_env() {
    [[ -f "$ENV_FILE" ]] || fatal "缺少配置文件 $ENV_FILE（请先 cp backend-rust/.env.example backend-rust/.env）"
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
    [[ -n "${DATABASE_URL:-}" ]] || fatal "未配置 DATABASE_URL"
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
    info "$method $path -> $API_STATUS"
}

api_error() {
    if [[ -n "${API_BODY:-}" ]] && jq -e . >/dev/null 2>&1 <<<"$API_BODY"; then
        jq -r '.error // "unknown error"' <<<"$API_BODY"
    else
        printf 'non-JSON response'
    fi
}

expect() {
    local desc=$1 expected=$2 actual=$3
    if [[ "$expected" == "$actual" ]]; then
        pass "$desc"
    else
        fail "$desc：期望 [$expected]，实际 [$actual]"
    fi
}

expect_status() {
    local desc=$1 expected=$2
    if [[ "$API_STATUS" == "$expected" ]]; then
        pass "$desc"
    else
        fail "$desc：期望 HTTP $expected，实际 $API_STATUS（$(api_error)）"
    fi
}

expect_contains() {
    local desc=$1 haystack=$2 needle=$3
    if [[ "$haystack" == *"$needle"* ]]; then
        pass "$desc"
    else
        fail "$desc：[$haystack] 不包含 [$needle]"
    fi
}

expect_jq() {
    local desc=$1 expr=$2
    if jq -e "$expr" >/dev/null 2>&1 <<<"$API_BODY"; then
        pass "$desc"
    else
        fail "$desc：响应不满足 $expr"
    fi
}

url_encode() { jq -rn --arg value "$1" '$value|@uri'; }

random_suffix() { printf '%s_%s' "$(date +%s)" "$RANDOM"; }
random_password() { tr -dc 'A-Za-z0-9' </dev/urandom | head -c 20; }

register_account() {
    # register_account USERNAME EMAIL
    local username=$1 email=$2
    api POST /api/auth/register "" \
        "$(jq -nc --arg u "$username" --arg e "$email" --arg p "$PASSWORD" \
            '{username:$u,email:$e,password:$p}')"
    [[ "$API_STATUS" == "201" ]] || fatal "注册 $username 失败（HTTP $API_STATUS：$(api_error)）"
}

login_account() {
    # login_account USERNAME；设置 API_TOKEN / API_USER_ID
    local username=$1
    api POST /api/auth/login "" \
        "$(jq -nc --arg u "$username" --arg p "$PASSWORD" '{username:$u,password:$p}')"
    [[ "$API_STATUS" == "200" ]] || fatal "登录 $username 失败（HTTP $API_STATUS：$(api_error)）"
    API_TOKEN=$(jq -r '.data.token // empty' <<<"$API_BODY")
    API_USER_ID=$(jq -r '.data.user.id // empty' <<<"$API_BODY")
    [[ -n "$API_TOKEN" && -n "$API_USER_ID" ]] || fatal "登录响应缺少 token 或 user.id"
}

restore_template_order() {
    ((ORDER_RESTORED)) && return 0
    ((TEMPLATES_DELETED)) && return 0
    [[ -n "$ORIG_IDS_JSON" && -n "$ADMIN_TOKEN" ]] || return 0
    curl -sS -o /dev/null -X PUT -H 'Content-Type: application/json' \
        -H "Authorization: Bearer $ADMIN_TOKEN" \
        --data-binary "{\"ids\":$ORIG_IDS_JSON}" \
        "$API_BASE/api/admin/interview/templates/order" >/dev/null 2>&1 || true
    ORDER_RESTORED=1
}

cleanup() {
    restore_template_order
    if [[ "$KEEP_DATA" == "1" ]]; then
        printf '\n[INFO] SMOKE_KEEP_DATA=1，保留测试账号与模板\n'
        return 0
    fi
    [[ -n "${DATABASE_URL:-}" ]] || return 0
    psql "$DATABASE_URL" -At -v ON_ERROR_STOP=1 >/dev/null 2>&1 <<'SQL' || true
DELETE FROM audit_logs WHERE actor_username LIKE 'itsmoke_%' OR summary LIKE '%itsmoke_%';
DELETE FROM interview_templates WHERE created_by IN (SELECT id FROM users WHERE username LIKE 'itsmoke_%');
DELETE FROM forum_posts WHERE author_id IN (SELECT id FROM users WHERE username LIKE 'itsmoke_%');
DELETE FROM users WHERE username LIKE 'itsmoke_%';
SQL
}
trap cleanup EXIT

preflight() {
    ((BASH_VERSINFO[0] > 4 || (BASH_VERSINFO[0] == 4 && BASH_VERSINFO[1] >= 2))) ||
        fatal "需要 bash >= 4.2（当前 ${BASH_VERSION}）"
    require_cmd curl
    require_cmd jq
    require_cmd psql

    load_env
    psql "$DATABASE_URL" -At -c 'SELECT 1' >/dev/null 2>&1 ||
        fatal_service "PostgreSQL 不可达（检查 DATABASE_URL）"

    expect "forum_posts 表存在" "t" \
        "$(db_scalar "SELECT to_regclass('public.forum_posts') IS NOT NULL")"
    expect "interview_templates 表存在" "t" \
        "$(db_scalar "SELECT to_regclass('public.interview_templates') IS NOT NULL")"
    expect "forum_posts.interview_type 字段存在" "t" \
        "$(db_scalar "SELECT EXISTS (SELECT 1 FROM information_schema.columns \
             WHERE table_schema = 'public' AND table_name = 'forum_posts' \
             AND column_name = 'interview_type')")"

    api GET /api/stats "" ""
    [[ "$API_STATUS" == "200" ]] || fatal_service "API 不可达或返回异常（GET /api/stats -> $API_STATUS）"

    api GET '/api/forum/posts?size=1' "" ""
    [[ "$API_STATUS" == "503" ]] && fatal "论坛功能已关闭（FORUM_ENABLED=false）"
    [[ "$API_STATUS" == "200" ]] || fatal_service "论坛列表不可用（GET /api/forum/posts -> $API_STATUS）"

    [[ "$FAILED" == "0" ]] || fatal "数据库迁移缺失（需要 0048 / 0049）"
    printf '\n'
}

main() {
    preflight

    # ------------------------------------------------------------------
    # 账号：管理员、Plus 用户、普通用户
    # ------------------------------------------------------------------
    say "准备测试账号"
    SUFFIX=$(random_suffix)
    PASSWORD=$(random_password)
    ADMIN_USER="itsmoke_admin_${SUFFIX}"
    PLUS_USER="itsmoke_plus_${SUFFIX}"
    PLAIN_USER="itsmoke_plain_${SUFFIX}"

    register_account "$ADMIN_USER" "${ADMIN_USER}@example.test"
    register_account "$PLUS_USER" "${PLUS_USER}@example.test"
    register_account "$PLAIN_USER" "${PLAIN_USER}@example.test"

    # 论坛写入要求邮箱已验证；不测邮箱链路，直接标记测试账号。
    db_scalar "UPDATE users SET email_verified_at = CURRENT_TIMESTAMP \
        WHERE username LIKE 'itsmoke_%_${SUFFIX}'" >/dev/null ||
        fatal "无法标记测试账号邮箱已验证"

    login_account "$PLAIN_USER"
    PLAIN_ID=$API_USER_ID
    PLAIN_TOKEN=$API_TOKEN

    login_account "$PLUS_USER"
    PLUS_ID=$API_USER_ID
    PLUS_TOKEN=$API_TOKEN
    db_scalar "INSERT INTO plus_memberships (user_id, started_at, expires_at) \
        VALUES ($PLUS_ID, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP + INTERVAL '30 days') \
        ON CONFLICT (user_id) DO UPDATE SET expires_at = EXCLUDED.expires_at" >/dev/null ||
        fatal "无法为测试账号开通 Plus"

    login_account "$ADMIN_USER"
    ADMIN_ID=$API_USER_ID
    db_scalar "UPDATE users SET role = 'admin' WHERE id = $ADMIN_ID" >/dev/null ||
        fatal "无法提升测试管理员"
    login_account "$ADMIN_USER"
    ADMIN_TOKEN=$API_TOKEN
    expect "测试管理员角色" "admin" "$(jq -r '.data.user.role // empty' <<<"$API_BODY")"

    # ------------------------------------------------------------------
    # 1. 未登录 / 非 Plus 权限
    # ------------------------------------------------------------------
    say "1. 未登录与非 Plus 权限"
    api GET "/api/forum/posts?board=interview" "" ""
    expect_status "未登录面经列表 401" "401"
    api GET /api/forum/interview/templates "" ""
    expect_status "未登录模板列表 401" "401"
    api GET /api/forum/interview/templates/1 "" ""
    expect_status "未登录模板详情 401" "401"

    api GET "/api/forum/posts?board=interview" "$PLAIN_TOKEN" ""
    expect_status "非 Plus 面经列表 403" "403"
    api GET /api/forum/interview/templates "$PLAIN_TOKEN" ""
    expect_status "非 Plus 模板列表 403" "403"
    api GET /api/forum/interview/templates/1 "$PLAIN_TOKEN" ""
    expect_status "非 Plus 模板详情 403" "403"

    api GET "/api/forum/posts?board=interview&size=50" "$PLUS_TOKEN" ""
    expect_status "Plus 面经列表 200" "200"

    # ------------------------------------------------------------------
    # 2. 发面经校验与类型筛选
    # ------------------------------------------------------------------
    say "2. 发面经校验与类型筛选"
    api POST /api/forum/posts "$PLUS_TOKEN" "$(jq -nc --arg title "itsmoke_${SUFFIX} 缺类型" \
        '{title:$title, body_md:"## 题目", tags:["algorithm"], board:"interview"}')"
    expect_status "面经缺类型 400" "400"
    expect_contains "缺类型错误文案" "$(api_error)" "必须选择面试类型"

    api POST /api/forum/posts "$PLUS_TOKEN" "$(jq -nc --arg title "itsmoke_${SUFFIX} 未知类型" \
        '{title:$title, body_md:"## 题目", tags:["algorithm"], board:"interview", interview_type:"coding"}')"
    expect_status "面经未知类型 400" "400"
    expect_contains "未知类型错误文案" "$(api_error)" "未知的面试类型"

    api POST /api/forum/posts "$PLUS_TOKEN" "$(jq -nc --arg title "itsmoke_${SUFFIX} 综合带类型" \
        '{title:$title, body_md:"正文", tags:["general"], board:"general", interview_type:"hr"}')"
    expect_status "综合板块带类型 400" "400"
    expect_contains "综合带类型错误文案" "$(api_error)" "只有面经板块支持面试类型"

    api POST /api/forum/posts "$PLUS_TOKEN" "$(jq -nc --arg title "itsmoke_${SUFFIX} HR 面经" \
        '{title:$title, body_md:"## 题目\n\nsmoke HR", tags:["algorithm"], board:"interview", interview_type:"hr"}')"
    expect_status "Plus 发布 HR 面经 201" "201"
    HR_POST_ID=$(jq -r '.data.id // empty' <<<"$API_BODY")
    [[ -n "$HR_POST_ID" ]] || fail "HR 面经缺少 id"

    api POST /api/forum/posts "$ADMIN_TOKEN" "$(jq -nc --arg title "itsmoke_${SUFFIX} 技术面经" \
        '{title:$title, body_md:"## 题目\n\nsmoke technical", tags:["algorithm"], board:"interview", interview_type:"technical"}')"
    expect_status "管理员发布技术面经 201" "201"
    TECH_POST_ID=$(jq -r '.data.id // empty' <<<"$API_BODY")
    [[ -n "$TECH_POST_ID" ]] || fail "技术面经缺少 id"

    local search
    search=$(url_encode "itsmoke_${SUFFIX}")
    api GET "/api/forum/posts?board=interview&interview_type=hr&q=${search}&size=50" "$PLUS_TOKEN" ""
    expect_status "Plus HR 筛选 200" "200"
    expect_jq "HR 筛选 total=1" '.data.total == 1'
    expect_jq "HR 筛选结果类型一致" '[.data.posts[].interview_type] | unique == ["hr"]'

    api GET "/api/forum/posts?board=interview&interview_type=technical&q=${search}&size=50" "$PLUS_TOKEN" ""
    expect_status "Plus 技术面筛选 200" "200"
    expect_jq "技术面筛选 total=1" '.data.total == 1'
    expect_jq "技术面筛选结果类型一致" '[.data.posts[].interview_type] | unique == ["technical"]'

    api GET "/api/forum/posts?board=interview&interview_type=coding" "$PLUS_TOKEN" ""
    expect_status "列表非法类型 400" "400"
    expect_contains "列表非法类型错误文案" "$(api_error)" "未知的面试类型"

    # ------------------------------------------------------------------
    # 3. 管理端改类型与审计
    # ------------------------------------------------------------------
    say "3. 管理端改类型与审计"
    api PUT "/api/admin/forum/posts/$HR_POST_ID/interview-type" "$ADMIN_TOKEN" \
        '{"interview_type":"manager"}'
    expect_status "管理员改类型 200" "200"
    expect_jq "改类型响应" '.data.interview_type == "manager"'

    api GET "/api/forum/posts/$HR_POST_ID" "$PLUS_TOKEN" ""
    expect_status "读者端详情 200" "200"
    expect_jq "详情类型已更新" '.data.interview_type == "manager"'

    api PUT "/api/admin/forum/posts/$HR_POST_ID/interview-type" "$PLUS_TOKEN" \
        '{"interview_type":"hr"}'
    expect_status "非管理员改类型 403" "403"

    expect "类型修改审计数量" "1" \
        "$(db_scalar "SELECT count(*) FROM audit_logs \
             WHERE action = 'forum.interview_type_update' AND target_id = $HR_POST_ID")"
    expect "类型修改审计前后值" "hr|manager" \
        "$(db_scalar "SELECT (\"before\"->>'interview_type') || '|' || (\"after\"->>'interview_type') \
             FROM audit_logs WHERE action = 'forum.interview_type_update' \
             AND target_id = $HR_POST_ID ORDER BY id DESC LIMIT 1")"

    # ------------------------------------------------------------------
    # 4. 模板管理端权限与 CRUD
    # ------------------------------------------------------------------
    say "4. 模板管理端权限与 CRUD"
    api GET /api/admin/interview/templates "$PLUS_TOKEN" ""
    expect_status "非管理员模板列表 403" "403"
    api POST /api/admin/interview/templates "$PLUS_TOKEN" \
        '{"title":"itsmoke 越权","content_md":"x"}'
    expect_status "非管理员新建模板 403" "403"

    api POST /api/admin/interview/templates "$ADMIN_TOKEN" \
        "$(jq -nc --arg title "itsmoke_${SUFFIX} 模板一" \
            '{title:$title, content_md:"## 模板一\n\n- 自我介绍"}')"
    expect_status "新建模板一 201" "201"
    T1_ID=$(jq -r '.data.id // empty' <<<"$API_BODY")
    [[ -n "$T1_ID" ]] || fail "模板一缺少 id"

    api POST /api/admin/interview/templates "$ADMIN_TOKEN" \
        "$(jq -nc --arg title "itsmoke_${SUFFIX} 模板二" \
            '{title:$title, content_md:"## 模板二\n\n- 项目经历"}')"
    expect_status "新建模板二 201" "201"
    T2_ID=$(jq -r '.data.id // empty' <<<"$API_BODY")
    [[ -n "$T2_ID" ]] || fail "模板二缺少 id"

    local long_title long_content
    long_title=$(jq -rn '"a" * 121')
    long_content=$(jq -rn '"a" * 20001')
    api POST /api/admin/interview/templates "$ADMIN_TOKEN" \
        "$(jq -nc --arg title "$long_title" '{title:$title, content_md:"正文"}')"
    expect_status "标题 121 字 400" "400"
    api POST /api/admin/interview/templates "$ADMIN_TOKEN" \
        "$(jq -nc --arg content "$long_content" '{title:"itsmoke 超长正文", content_md:$content}')"
    expect_status "正文 20001 字 400" "400"

    api GET /api/forum/interview/templates "$PLUS_TOKEN" ""
    expect_status "Plus 读取模板列表 200" "200"
    expect_jq "读者列表包含新建模板" \
        "([.data[].id] | index($T1_ID) != null) and ([.data[].id] | index($T2_ID) != null)"

    api GET "/api/forum/interview/templates/$T1_ID" "$PLUS_TOKEN" ""
    expect_status "Plus 读取模板详情 200" "200"
    expect_contains "模板详情正文" "$(jq -r '.data.content_md // empty' <<<"$API_BODY")" "模板一"

    api PUT "/api/admin/interview/templates/$T1_ID" "$ADMIN_TOKEN" \
        "$(jq -nc --arg title "itsmoke_${SUFFIX} 模板一（更新）" \
            '{title:$title, content_md:"## 更新\n\n- 更新后正文"}')"
    expect_status "更新模板 200" "200"
    api GET "/api/forum/interview/templates/$T1_ID" "$PLUS_TOKEN" ""
    expect_status "读者端读取更新后模板 200" "200"
    expect_contains "读者端正文已更新" "$(jq -r '.data.content_md // empty' <<<"$API_BODY")" "更新后正文"

    # ------------------------------------------------------------------
    # 5. 排序：成功、重复、缺项；结束后恢复原顺序
    # ------------------------------------------------------------------
    say "5. 模板排序"
    api GET /api/admin/interview/templates "$ADMIN_TOKEN" ""
    expect_status "管理员模板列表 200" "200"
    ORIG_IDS_JSON=$(jq -c '[.data[].id]' <<<"$API_BODY")
    local rev_ids
    rev_ids=$(jq -c 'reverse' <<<"$ORIG_IDS_JSON")
    expect_jq "模板 id 列表非空" '(.data | length) >= 2'

    api PUT /api/admin/interview/templates/order "$ADMIN_TOKEN" "{\"ids\":$rev_ids}"
    expect_status "重排模板 200" "200"

    api GET /api/admin/interview/templates "$ADMIN_TOKEN" ""
    expect "重排后顺序" "$rev_ids" "$(jq -c '[.data[].id]' <<<"$API_BODY")"

    api PUT /api/admin/interview/templates/order "$ADMIN_TOKEN" \
        "$(jq -nc --argjson ids "$rev_ids" '{ids: ($ids + [$ids[0]])}')"
    expect_status "排序重复 ID 400" "400"
    api PUT /api/admin/interview/templates/order "$ADMIN_TOKEN" \
        "$(jq -nc --argjson ids "$rev_ids" '{ids: $ids[0:-1]}')"
    expect_status "排序缺项 400" "400"

    api PUT /api/admin/interview/templates/order "$ADMIN_TOKEN" "{\"ids\":$ORIG_IDS_JSON}"
    expect_status "恢复原顺序 200" "200"
    ORDER_RESTORED=1

    # ------------------------------------------------------------------
    # 6. 删除与审计
    # ------------------------------------------------------------------
    say "6. 删除模板与审计"
    api DELETE "/api/admin/interview/templates/$T2_ID" "$ADMIN_TOKEN" ""
    expect_status "删除模板二 200" "200"
    api GET "/api/forum/interview/templates/$T2_ID" "$PLUS_TOKEN" ""
    expect_status "已删除模板详情 404" "404"
    api DELETE "/api/admin/interview/templates/$T2_ID" "$ADMIN_TOKEN" ""
    expect_status "重复删除模板 404" "404"

    api DELETE "/api/admin/interview/templates/$T1_ID" "$ADMIN_TOKEN" ""
    expect_status "删除模板一 200" "200"
    TEMPLATES_DELETED=1

    expect "模板创建审计" "t" \
        "$(db_scalar "SELECT count(*) >= 1 FROM audit_logs \
             WHERE action = 'interview_template.create' AND actor_username = '$ADMIN_USER'")"
    expect "模板更新审计" "t" \
        "$(db_scalar "SELECT count(*) >= 1 FROM audit_logs \
             WHERE action = 'interview_template.update' AND actor_username = '$ADMIN_USER'")"
    expect "模板排序审计" "t" \
        "$(db_scalar "SELECT count(*) >= 1 FROM audit_logs \
             WHERE action = 'interview_template.reorder' AND actor_username = '$ADMIN_USER'")"
    expect "模板删除审计" "t" \
        "$(db_scalar "SELECT count(*) >= 1 FROM audit_logs \
             WHERE action = 'interview_template.delete' AND actor_username = '$ADMIN_USER'")"

    printf '\n结果：%d 通过，%d 失败\n' "$PASSED" "$FAILED"
    ((FAILED == 0))
}

main "$@"
