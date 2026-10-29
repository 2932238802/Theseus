#!/usr/bin/env bash
#
# Theseus 组织 / 作业 / 批改冒烟测试。
#
# 设计文档：doc/2610259_班级与作业设计方案.md
#
# 只操作真实运行的 API + PostgreSQL，不 mock 任何一层。覆盖：
#   管理员改角色 / 角色立即生效 / 自助改角色拒绝 / 学生有组织时不能升教师 /
#   教师组织与邀请码 / 学生加入 / 教师不能加入 / 学生不能创建组织 /
#   管理员不能访问教学数据 / 非 owner 教师 404 / 作业草稿与发布 /
#   发布通知 / 学生作业提交 / 教师不能提交作业 / 教师查看提交代码 /
#   自动评分与手动改分 / 学生成绩可见性 / 截止前不能发布成绩 / 截止后拒绝提交 /
#   成绩发布通知 / 教师有组织时降级 409 / 归档确认后降级 / 清理。
#
# 用法：
#   ./backend-rust/scripts/smoke_teaching.sh
#   SMOKE_KEEP_DATA=1 ./backend-rust/scripts/smoke_teaching.sh
#   SMOKE_VERBOSE=1 ./backend-rust/scripts/smoke_teaching.sh
#
# 依赖：bash >= 4.2、curl、jq、psql。
# 安全性：只使用随机哑账号；报告不写入 token、密码、数据库连接串或提交代码。
# 只连接本地/测试数据库；会把一次性测试教师提升/降级，不触碰真实账号。
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
PROBLEM_ID=${SMOKE_PROBLEM_ID:-1101}
JUDGE_TIMEOUT=${SMOKE_JUDGE_TIMEOUT:-90}
POLL_MS=${SMOKE_POLL_MS:-500}
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

ADMIN_USER=""
ADMIN_ID=""
ADMIN_TOKEN=""
TEACHER_USER=""
TEACHER_ID=""
TEACHER_TOKEN=""
STUDENT_USER=""
STUDENT_ID=""
STUDENT_TOKEN=""
OTHER_USER=""
OTHER_ID=""
OTHER_TOKEN=""
USER_IDS=()

CLASS_ID=""
INVITE_CODE=""
ASSIGNMENT_ID=""
SUBMISSION_ID=""
ARCHIVED_CLASS_COUNT=""
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

sleep_ms() {
    sleep "$(awk -v m="$1" 'BEGIN { printf "%.3f", m / 1000 }')"
}

# ---------------------------------------------------------------------------
# 环境加载（已有环境变量优先；不 source）
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
}

# ---------------------------------------------------------------------------
# 断言
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
        printf '[PASS] %-26s %s\n' "$CHECK_ID" "$CHECK_NOTE"
        record_check "$CHECK_ID" passed "$duration_ms"
    else
        FAILED=$((FAILED + 1))
        printf '[FAIL] %-26s %d 项断言失败\n' "$CHECK_ID" "$CHECK_FAILS"
        record_check "$CHECK_ID" failed "$duration_ms"
    fi
}

skip_check() {
    local id=$1 reason=$2
    SKIPPED=$((SKIPPED + 1))
    printf '[SKIP] %-26s %s\n' "$id" "$reason"
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

assert_nonempty() {
    local desc=$1 value=$2
    [[ -n "$value" && "$value" != "null" ]] || fail_check "$desc：为空"
}

assert_status() {
    local desc=$1 expected=$2
    [[ "$API_STATUS" == "$expected" ]] || fail_check "$desc：期望 HTTP $expected，实际 $API_STATUS（$(api_error)）"
}

assert_json_absent() {
    local desc=$1 json=$2 key=$3
    local present
    present=$(jq -r --arg key "$key" 'has($key)' <<<"$json" 2>/dev/null || printf 'true')
    [[ "$present" == "false" ]] || fail_check "$desc：不应包含 $key"
}

# ---------------------------------------------------------------------------
# HTTP / DB
# ---------------------------------------------------------------------------

api_request() {
    # api_request METHOD PATH TOKEN [BODY]
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
    [[ "$JUDGE_TIMEOUT" =~ ^[0-9]+$ ]] || fatal_preflight "SMOKE_JUDGE_TIMEOUT 必须是整数"
    [[ "$POLL_MS" =~ ^[0-9]+$ ]] || fatal_preflight "SMOKE_POLL_MS 必须是整数"

    psql "$DATABASE_URL" -At -c 'SELECT 1' >/dev/null 2>&1 ||
        fatal_service "PostgreSQL 不可达（检查 DATABASE_URL）"

    api_request GET /api/stats "" ""
    [[ "$API_STATUS" == "200" ]] ||
        fatal_service "API 不可达或返回异常（GET /api/stats -> $API_STATUS）"

    local has_roles has_assignments
    has_roles=$(db_scalar "SELECT EXISTS(SELECT 1 FROM information_schema.columns WHERE table_name = 'users' AND column_name = 'role')")
    has_assignments=$(db_scalar "SELECT EXISTS(SELECT 1 FROM information_schema.tables WHERE table_name = 'assignments')")
    assert_eq "角色迁移已应用" "t" "$has_roles"
    assert_eq "教学迁移已应用" "t" "$has_assignments"
    if ((CHECK_FAILS > 0)); then
        fatal_preflight "数据库缺少 0005_teaching.sql 迁移"
    fi

    local eligible
    eligible=$(db_scalar "SELECT COALESCE((
        SELECT review_status = 'approved' AND run_config IS NOT NULL
               AND judge_cases IS NOT NULL AND jsonb_typeof(judge_cases) = 'array'
               AND jsonb_array_length(judge_cases) > 0
        FROM problems WHERE id = $PROBLEM_ID), false)")
    [[ "$eligible" == "t" ]] ||
        fatal_preflight "题目 $PROBLEM_ID 不可评测；请先执行 backend-rust/scripts/seed_problems_15.sql"
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

login_only() {
    local username=$1 password=$2 body
    body=$(jq -nc --arg u "$username" --arg p "$password" '{username:$u, password:$p}')
    api_request POST /api/auth/login "" "$body"
    [[ "$API_STATUS" == "200" ]] || fatal_preflight "登录失败（HTTP $API_STATUS：$(api_error)）"
    REG_USER_ID=$(jq -r '.data.user.id // empty' <<<"$API_BODY")
    REG_TOKEN=$(jq -r '.data.token // empty' <<<"$API_BODY")
    [[ -n "$REG_USER_ID" && -n "$REG_TOKEN" ]] || fatal_preflight "登录响应缺少 user.id 或 token"
}

register_and_login() {
    local username=$1 email=$2 password=$3 body
    body=$(jq -nc --arg u "$username" --arg e "$email" --arg p "$password" \
        '{username:$u, email:$e, password:$p}')
    api_request POST /api/auth/register "" "$body"
    [[ "$API_STATUS" == "201" ]] || fatal_preflight "注册失败（HTTP $API_STATUS：$(api_error)）"
    login_only "$username" "$password"
    # 教学写入要求邮箱已验证；本冒烟不测邮箱链路，直接标记测试账号。
    db_scalar "UPDATE users SET email_verified_at = CURRENT_TIMESTAMP WHERE id = $REG_USER_ID" >/dev/null ||
        fatal_preflight "无法标记测试账号邮箱已验证"
}

me_role() {
    api_request GET /api/auth/me "$1" ""
    jq -r '.data.role // empty' <<<"$API_BODY"
}

# ---------------------------------------------------------------------------
# 作业 / 判题辅助
# ---------------------------------------------------------------------------

future_iso() {
    date -u -d "+$1 seconds" +%Y-%m-%dT%H:%M:%SZ
}

is_terminal_verdict() {
    case "$1" in
        accepted | wrong_answer | time_limit_exceeded | memory_limit_exceeded | \
            runtime_error | compile_error | internal_error) return 0 ;;
        *) return 1 ;;
    esac
}

submit_assignment() {
    local token=$1 code=$2 body
    body=$(jq -nc \
        --argjson problem "$PROBLEM_ID" \
        --argjson assignment "$ASSIGNMENT_ID" \
        --arg language "python" \
        --arg code "$code" \
        '{problem_id:$problem, assignment_id:$assignment, language:$language, code:$code}')
    api_request POST /api/submissions "$token" "$body"
}

wait_accepted() {
    local sid=$1 deadline status
    deadline=$(($(now_ms) + JUDGE_TIMEOUT * 1000))
    while :; do
        api_request GET "/api/submissions/$sid/status" "$STUDENT_TOKEN" ""
        if [[ "$API_STATUS" != "200" ]]; then
            fail_check "轮询提交状态失败（HTTP $API_STATUS：$(api_error)）"
            return 1
        fi
        status=$(jq -r '.data.status // empty' <<<"$API_BODY")
        if [[ "$status" == "accepted" ]]; then
            return 0
        fi
        if is_terminal_verdict "$status"; then
            fail_check "提交未通过：$status"
            return 1
        fi
        if (($(now_ms) >= deadline)); then
            fail_check "等待判题超时（${JUDGE_TIMEOUT}s），最后状态 [$status]"
            return 1
        fi
        sleep_ms "$POLL_MS"
    done
}

notification_count() {
    local token=$1 type=$2
    api_request GET '/api/notifications?size=50' "$token" ""
    if [[ "$API_STATUS" != "200" ]]; then
        printf 'error\n'
        return 0
    fi
    jq -r --arg type "$type" '[.data.notifications[] | select(.type == $type)] | length' <<<"$API_BODY"
}

# ---------------------------------------------------------------------------
# 清理
# ---------------------------------------------------------------------------

build_cleanup_sql() {
    local ids
    ids=$(IFS=,; printf '%s' "${USER_IDS[*]}")
    CLEANUP_SQL="DELETE FROM assignments WHERE class_id IN (SELECT id FROM classes WHERE owner_id IN ($ids)); \
DELETE FROM classes WHERE owner_id IN ($ids); \
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
    printf '\n[INFO] 已删除测试账号与教学数据\n'
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
        --arg class_id "${CLASS_ID:-}" \
        --arg assignment_id "${ASSIGNMENT_ID:-}" \
        --arg submission_id "${SUBMISSION_ID:-}" \
        --arg cleaned "$CLEANED" \
        --arg git_commit "$(git -C "$REPO_ROOT" rev-parse --short HEAD 2>/dev/null || printf 'unknown')" \
        --argjson checks "$checks_json" \
        --argjson passed "$PASSED" \
        --argjson failed "$FAILED" \
        --argjson skipped "$SKIPPED" \
        --argjson duration_ms "$duration_ms" \
        '{started_at:$started_at, api_base:$api_base, problem_id:$problem_id,
          class_id:(if $class_id == "" then null else ($class_id | tonumber) end),
          assignment_id:(if $assignment_id == "" then null else ($assignment_id | tonumber) end),
          submission_id:(if $submission_id == "" then null else ($submission_id | tonumber) end),
          cleaned:($cleaned == "1"), git_commit:$git_commit, checks:$checks,
          summary:{passed:$passed, failed:$failed, skipped:$skipped, duration_ms:$duration_ms}}' \
        >"$REPORT_JSON"
}

# ---------------------------------------------------------------------------
# 主流程
# ---------------------------------------------------------------------------

PY_AC=$(cat <<'PY'
class Solution:
    def isPalindrome(self, x: int) -> bool:
        if x < 0:
            return False
        text = str(x)
        return text == text[::-1]
PY
)

main() {
    load_env

    mkdir -p "$REPORT_DIR" || fatal_preflight "无法创建报告目录 $REPORT_DIR"
    local stamp
    stamp=$(date -u +%Y%m%dT%H%M%SZ)
    REPORT_LOG="$REPORT_DIR/smoke-teaching-$stamp.log"
    REPORT_JSON="$REPORT_DIR/smoke-teaching-$stamp.json"
    exec > >(tee -a "$REPORT_LOG") 2>&1

    TMP_DIR=$(mktemp -d "${TMPDIR:-/tmp}/theseus-teaching-smoke.XXXXXX") || fatal_preflight "无法创建临时目录"
    TMP_BODY="$TMP_DIR/body.json"
    TMP_HEADERS="$TMP_DIR/headers.txt"

    START_MS=$(now_ms)
    START_ISO=$(date -u +'%Y-%m-%dT%H:%M:%SZ')

    local db_host
    db_host=$(printf '%s' "$DATABASE_URL" | sed -E 's#^[a-z]+://##; s#^[^@]*@##; s#[/?].*$##')
    say "smoke: $API_BASE  problem=$PROBLEM_ID  db=$db_host"

    begin_check preflight
    preflight_env
    CHECK_NOTE="problem=$PROBLEM_ID"
    end_check

    # ------------------------------------------------------------------
    # 账号与角色
    # ------------------------------------------------------------------
    begin_check accounts
    local suffix password body
    suffix=$(random_suffix)
    password=${PASSWORD:-$(random_password)}
    ADMIN_USER="tsmoke_admin_${suffix}"
    TEACHER_USER="tsmoke_teacher_${suffix}"
    STUDENT_USER="tsmoke_student_${suffix}"
    OTHER_USER="tsmoke_other_${suffix}"

    register_and_login "$ADMIN_USER" "${ADMIN_USER}@example.test" "$password"
    ADMIN_ID=$REG_USER_ID
    USER_IDS+=("$ADMIN_ID")
    register_and_login "$TEACHER_USER" "${TEACHER_USER}@example.test" "$password"
    TEACHER_ID=$REG_USER_ID
    USER_IDS+=("$TEACHER_ID")
    register_and_login "$STUDENT_USER" "${STUDENT_USER}@example.test" "$password"
    STUDENT_ID=$REG_USER_ID
    STUDENT_TOKEN=$REG_TOKEN
    USER_IDS+=("$STUDENT_ID")
    register_and_login "$OTHER_USER" "${OTHER_USER}@example.test" "$password"
    OTHER_ID=$REG_USER_ID
    USER_IDS+=("$OTHER_ID")

    # 只提升一次性测试账号；不修改任何真实管理员。
    db_scalar "UPDATE users SET role = 'admin' WHERE id = $ADMIN_ID" >/dev/null ||
        fatal_preflight "无法将测试账号提升为管理员"
    login_only "$ADMIN_USER" "$password"
    ADMIN_TOKEN=$REG_TOKEN
    assert_eq "管理员 /me 角色" "admin" "$(me_role "$ADMIN_TOKEN")"

    api_request GET "/api/admin/users?q=$(jq -rn --arg q "$TEACHER_USER" '$q|@uri')&size=20" "$ADMIN_TOKEN" ""
    assert_status "管理员搜索用户" "200"
    assert_eq "教师候选人角色" "student" \
        "$(jq -r --argjson id "$TEACHER_ID" '.data.users[] | select(.id == $id) | .role' <<<"$API_BODY")"

    body=$(jq -nc '{role:"teacher"}')
    api_request PUT "/api/admin/users/$TEACHER_ID/role" "$ADMIN_TOKEN" "$body"
    assert_status "提升教师" "200"
    assert_eq "提升响应角色" "teacher" "$(jq -r '.data.role // empty' <<<"$API_BODY")"
    assert_contains "提升响应文案" "$(jq -r '.data.message // empty' <<<"$API_BODY")" "立即生效"

    login_only "$TEACHER_USER" "$password"
    TEACHER_TOKEN=$REG_TOKEN
    assert_eq "教师 /me 角色" "teacher" "$(me_role "$TEACHER_TOKEN")"

    api_request PUT "/api/admin/users/$ADMIN_ID/role" "$ADMIN_TOKEN" '{"role":"student"}'
    assert_status "管理员修改自己" "400"

    api_request GET '/api/admin/users?size=1' "$TEACHER_TOKEN" ""
    assert_status "教师访问用户管理" "403"

    # 另一位教师用于非 owner 边界；无组织，可直接提升。
    body=$(jq -nc '{role:"teacher"}')
    api_request PUT "/api/admin/users/$OTHER_ID/role" "$ADMIN_TOKEN" "$body"
    assert_status "提升第二位教师" "200"
    login_only "$OTHER_USER" "$password"
    OTHER_TOKEN=$REG_TOKEN
    CHECK_NOTE="admin/teacher/student/other"
    end_check

    # ------------------------------------------------------------------
    # 组织创建、加入与边界
    # ------------------------------------------------------------------
    begin_check class_create_join
    body=$(jq -nc --arg name "冒烟组织 ${suffix}" \
        '{name:$name, course_name:"算法", term:"2026 秋", description:"teaching smoke"}')
    api_request POST /api/classes "$TEACHER_TOKEN" "$body"
    assert_status "教师创建组织" "201"
    CLASS_ID=$(jq -r '.data.id // empty' <<<"$API_BODY")
    INVITE_CODE=$(jq -r '.data.invite_code // empty' <<<"$API_BODY")
    assert_nonempty "class_id" "$CLASS_ID"
    assert_nonempty "invite_code" "$INVITE_CODE"
    assert_eq "邀请码长度" "8" "${#INVITE_CODE}"
    assert_eq "创建者关系" "owner" "$(jq -r '.data.relation // empty' <<<"$API_BODY")"

    body=$(jq -nc --arg code "$INVITE_CODE" '{invite_code:$code}')
    api_request POST /api/classes/join "$TEACHER_TOKEN" "$body"
    assert_status "教师加入组织" "403"

    api_request POST /api/classes "$STUDENT_TOKEN" '{"name":"学生组织"}'
    assert_status "学生创建组织" "403"

    api_request GET '/api/classes' "$STUDENT_TOKEN" ""
    assert_status "学生初始组织列表" "200"
    assert_eq "学生初始组织数" "0" "$(jq -r '.data.classes | length' <<<"$API_BODY")"

    api_request POST /api/classes/join "$STUDENT_TOKEN" "$body"
    assert_status "学生邀请码加入" "200"
    assert_eq "学生关系" "student" "$(jq -r '.data.relation // empty' <<<"$API_BODY")"

    api_request GET "/api/classes/$CLASS_ID" "$STUDENT_TOKEN" ""
    assert_status "学生查看组织" "200"
    assert_json_absent "学生组织详情" "$(jq -c '.data' <<<"$API_BODY")" "invite_code"
    assert_json_absent "学生组织详情" "$(jq -c '.data' <<<"$API_BODY")" "members"

    api_request GET "/api/classes/$CLASS_ID" "$TEACHER_TOKEN" ""
    assert_status "教师查看组织" "200"
    assert_eq "教师可见邀请码" "$INVITE_CODE" "$(jq -r '.data.invite_code // empty' <<<"$API_BODY")"
    assert_eq "教师可见成员邮箱" "1" \
        "$(jq -r --arg email "${STUDENT_USER}@example.test" '[.data.members[] | select(.email == $email)] | length' <<<"$API_BODY")"

    api_request GET '/api/classes' "$ADMIN_TOKEN" ""
    assert_status "管理员组织列表" "403"
    api_request GET "/api/classes/$CLASS_ID" "$ADMIN_TOKEN" ""
    assert_status "管理员组织详情" "403"
    api_request GET "/api/classes/$CLASS_ID" "$OTHER_TOKEN" ""
    assert_status "非 owner 教师组织详情" "404"
    api_request GET "/api/classes/$CLASS_ID/assignments" "$OTHER_TOKEN" ""
    assert_status "非 owner 教师作业列表" "404"

    body=$(jq -nc '{role:"teacher"}')
    api_request PUT "/api/admin/users/$STUDENT_ID/role" "$ADMIN_TOKEN" "$body"
    assert_status "学生有组织时升教师" "409"
    assert_contains "升教师错误文案" "$(api_error)" "请先退出组织"

    CHECK_NOTE="class=$CLASS_ID"
    end_check

    # ------------------------------------------------------------------
    # 作业创建与发布
    # ------------------------------------------------------------------
    begin_check assignment_publish
    local due_at
    due_at=$(future_iso 300)
    body=$(jq -nc \
        --arg title "冒烟作业 ${suffix}" \
        --arg description "完成回文数。" \
        --arg due "$due_at" \
        --argjson problem "$PROBLEM_ID" \
        '{title:$title, description:$description, due_at:$due,
          problems:[{problem_id:$problem, points:100}]}')
    api_request POST "/api/classes/$CLASS_ID/assignments" "$TEACHER_TOKEN" "$body"
    assert_status "教师创建作业" "201"
    ASSIGNMENT_ID=$(jq -r '.data.id // empty' <<<"$API_BODY")
    assert_nonempty "assignment_id" "$ASSIGNMENT_ID"
    assert_eq "草稿状态" "draft" "$(jq -r '.data.status // empty' <<<"$API_BODY")"
    assert_eq "题目分值" "100" "$(jq -r '.data.problems[0].points // -1' <<<"$API_BODY")"

    api_request GET "/api/assignments/$ASSIGNMENT_ID" "$STUDENT_TOKEN" ""
    assert_status "学生查看草稿" "404"

    api_request POST "/api/assignments/$ASSIGNMENT_ID/publish" "$TEACHER_TOKEN" ""
    assert_status "发布作业" "200"
    assert_eq "发布状态" "published" "$(jq -r '.data.status // empty' <<<"$API_BODY")"

    assert_eq "学生作业通知" "1" "$(notification_count "$STUDENT_TOKEN" assignment_published)"

    api_request GET "/api/assignments/$ASSIGNMENT_ID" "$STUDENT_TOKEN" ""
    assert_status "学生查看作业" "200"
    assert_eq "作业可提交" "true" "$(jq -r '.data.can_submit' <<<"$API_BODY")"
    assert_eq "成绩未发布" "false" "$(jq -r '.data.grades_published' <<<"$API_BODY")"
    assert_json_absent "未发布成绩详情" "$(jq -c '.data' <<<"$API_BODY")" "total_score"
    assert_eq "题目无最终分" "false" \
        "$(jq -r '.data.problems[0] | has("final_score")' <<<"$API_BODY")"

    api_request GET "/api/assignments/$ASSIGNMENT_ID" "$ADMIN_TOKEN" ""
    assert_status "管理员查看作业" "403"
    CHECK_NOTE="assignment=$ASSIGNMENT_ID"
    end_check

    # ------------------------------------------------------------------
    # 提交与判题
    # ------------------------------------------------------------------
    begin_check assignment_submission
    submit_assignment "$TEACHER_TOKEN" "$PY_AC"
    assert_status "教师提交作业" "403"

    submit_assignment "$ADMIN_TOKEN" "$PY_AC"
    assert_status "管理员提交作业" "403"

    submit_assignment "$STUDENT_TOKEN" "$PY_AC"
    assert_status "学生提交作业" "201"
    SUBMISSION_ID=$(jq -r '.data.submission_id // empty' <<<"$API_BODY")
    assert_nonempty "submission_id" "$SUBMISSION_ID"
    assert_eq "作业提交落库" "$ASSIGNMENT_ID" \
        "$(db_scalar "SELECT assignment_id FROM submissions WHERE id = $SUBMISSION_ID")"
    wait_accepted "$SUBMISSION_ID" || true

    api_request GET "/api/assignments/$ASSIGNMENT_ID/submissions?user_id=$STUDENT_ID&problem_id=$PROBLEM_ID" "$TEACHER_TOKEN" ""
    assert_status "教师查看作业提交" "200"
    assert_eq "教师看到提交数" "1" "$(jq -r '.data.total // -1' <<<"$API_BODY")"
    assert_eq "提交状态 accepted" "accepted" "$(jq -r '.data.submissions[0].status // empty' <<<"$API_BODY")"

    api_request GET "/api/submissions/$SUBMISSION_ID" "$TEACHER_TOKEN" ""
    assert_status "教师查看提交代码" "200"
    assert_nonempty "提交代码" "$(jq -r '.data.code // empty' <<<"$API_BODY")"

    api_request GET "/api/assignments/$ASSIGNMENT_ID/submissions" "$OTHER_TOKEN" ""
    assert_status "非 owner 教师查看提交" "404"
    api_request GET "/api/assignments/$ASSIGNMENT_ID/submissions" "$ADMIN_TOKEN" ""
    assert_status "管理员查看提交" "403"

    CHECK_NOTE="submission=$SUBMISSION_ID"
    end_check

    # ------------------------------------------------------------------
    # 批改与成绩可见性
    # ------------------------------------------------------------------
    begin_check grading_visibility
    api_request GET "/api/assignments/$ASSIGNMENT_ID/gradebook" "$STUDENT_TOKEN" ""
    assert_status "学生访问批改台" "403"

    api_request GET "/api/assignments/$ASSIGNMENT_ID/gradebook" "$TEACHER_TOKEN" ""
    assert_status "教师批改台" "200"
    assert_eq "自动分" "100" \
        "$(jq -r --argjson uid "$STUDENT_ID" --argjson pid "$PROBLEM_ID" \
            '.data.students[] | select(.user_id == $uid) | .problems[] | select(.problem_id == $pid) | .auto_score' <<<"$API_BODY")"
    assert_eq "自动总分" "100" \
        "$(jq -r --argjson uid "$STUDENT_ID" '.data.students[] | select(.user_id == $uid) | .total_score' <<<"$API_BODY")"

    body=$(jq -nc '{manual_score:95, feedback:"smoke 单题评语"}')
    api_request PUT "/api/assignments/$ASSIGNMENT_ID/grades/$STUDENT_ID/problems/$PROBLEM_ID" "$TEACHER_TOKEN" "$body"
    assert_status "教师改单题分" "200"

    body=$(jq -nc '{overall_feedback:"smoke 整体评语"}')
    api_request PUT "/api/assignments/$ASSIGNMENT_ID/grades/$STUDENT_ID" "$TEACHER_TOKEN" "$body"
    assert_status "教师写整体评语" "200"

    api_request GET "/api/assignments/$ASSIGNMENT_ID/gradebook" "$TEACHER_TOKEN" ""
    assert_eq "批改台手动分" "95" \
        "$(jq -r --argjson uid "$STUDENT_ID" --argjson pid "$PROBLEM_ID" \
            '.data.students[] | select(.user_id == $uid) | .problems[] | select(.problem_id == $pid) | .manual_score' <<<"$API_BODY")"
    assert_eq "批改台总分" "95" \
        "$(jq -r --argjson uid "$STUDENT_ID" '.data.students[] | select(.user_id == $uid) | .total_score' <<<"$API_BODY")"

    api_request GET "/api/assignments/$ASSIGNMENT_ID" "$STUDENT_TOKEN" ""
    assert_status "学生发布前查看作业" "200"
    assert_json_absent "发布前成绩" "$(jq -c '.data' <<<"$API_BODY")" "total_score"
    assert_eq "发布前单题无最终分" "false" \
        "$(jq -r '.data.problems[0] | has("final_score")' <<<"$API_BODY")"

    api_request GET "/api/assignments/$ASSIGNMENT_ID/gradebook" "$ADMIN_TOKEN" ""
    assert_status "管理员访问批改台" "403"

    api_request POST "/api/assignments/$ASSIGNMENT_ID/grades/publish" "$TEACHER_TOKEN" ""
    assert_status "截止前发布成绩" "409"
    assert_contains "截止前发布文案" "$(api_error)" "尚未截止"

    # 把一次性作业的截止时间移到过去，验证真实截止判断。
    db_scalar "UPDATE assignments SET due_at = CURRENT_TIMESTAMP - INTERVAL '1 minute' WHERE id = $ASSIGNMENT_ID" >/dev/null ||
        fail_check "无法将测试作业截止时间置为过去"

    submit_assignment "$STUDENT_TOKEN" "$PY_AC"
    assert_status "截止后提交" "409"
    assert_contains "截止后提交文案" "$(api_error)" "已截止"

    api_request POST "/api/assignments/$ASSIGNMENT_ID/grades/publish" "$TEACHER_TOKEN" ""
    assert_status "发布成绩" "200"
    assert_nonempty "成绩发布时间" "$(jq -r '.data.grades_published_at // empty' <<<"$API_BODY")"
    api_request POST "/api/assignments/$ASSIGNMENT_ID/grades/publish" "$TEACHER_TOKEN" ""
    assert_status "重复发布成绩" "200"
    assert_eq "重复发布消息" "成绩已发布" "$(jq -r '.data.message // empty' <<<"$API_BODY")"

    assert_eq "学生成绩通知" "1" "$(notification_count "$STUDENT_TOKEN" assignment_grades_published)"

    api_request GET "/api/assignments/$ASSIGNMENT_ID" "$STUDENT_TOKEN" ""
    assert_status "学生查看已发布成绩" "200"
    assert_eq "成绩已发布" "true" "$(jq -r '.data.grades_published' <<<"$API_BODY")"
    assert_eq "学生总分" "95" "$(jq -r '.data.total_score // -1' <<<"$API_BODY")"
    assert_eq "学生单题最终分" "95" "$(jq -r '.data.problems[0].final_score // -1' <<<"$API_BODY")"
    assert_eq "学生单题评语" "smoke 单题评语" \
        "$(jq -r '.data.problems[0].feedback // empty' <<<"$API_BODY")"
    assert_eq "学生整体评语" "smoke 整体评语" \
        "$(jq -r '.data.overall_feedback // empty' <<<"$API_BODY")"
    end_check

    # ------------------------------------------------------------------
    # 教师降级与归档
    # ------------------------------------------------------------------
    begin_check teacher_demotion
    body=$(jq -nc '{role:"student"}')
    api_request PUT "/api/admin/users/$TEACHER_ID/role" "$ADMIN_TOKEN" "$body"
    assert_status "教师有组织时降级" "409"
    assert_contains "降级错误文案" "$(api_error)" "未归档"
    assert_eq "降级失败后角色仍为教师" "teacher" \
        "$(db_scalar "SELECT role FROM users WHERE id = $TEACHER_ID")"

    body=$(jq -nc '{role:"student", archive_owned_classes:true}')
    api_request PUT "/api/admin/users/$TEACHER_ID/role" "$ADMIN_TOKEN" "$body"
    assert_status "确认归档后降级" "200"
    assert_eq "降级响应角色" "student" "$(jq -r '.data.role // empty' <<<"$API_BODY")"
    ARCHIVED_CLASS_COUNT=$(jq -r '.data.archived_class_count // 0' <<<"$API_BODY")
    [[ "${ARCHIVED_CLASS_COUNT:-0}" -ge 1 ]] || fail_check "归档组织数应 >= 1，实际 [$ARCHIVED_CLASS_COUNT]"
    assert_eq "组织已归档" "t" \
        "$(db_scalar "SELECT archived_at IS NOT NULL FROM classes WHERE id = $CLASS_ID")"

    login_only "$TEACHER_USER" "$password"
    TEACHER_TOKEN=$REG_TOKEN
    api_request GET "/api/classes/$CLASS_ID" "$TEACHER_TOKEN" ""
    assert_status "降级后原教师查看组织" "404"
    CHECK_NOTE="archived=$ARCHIVED_CLASS_COUNT"
    end_check

    # ------------------------------------------------------------------
    # 清理
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
