#!/usr/bin/env bash
#
# Theseus 个人出题 / 管理员审核冒烟测试。
#
# 只操作真实运行的 API + PostgreSQL，不 mock 任何一层。覆盖：
#   教师创建题目进入待审核 / 学生投稿同样进入待审核 / 教师不能自审 / 待审核题目不公开 /
#   教师不能修改未退回题目 / 管理员列表与详情 / 退回必须填写原因 /
#   退回后教师收到通知并可编辑重提 / 重提清空审核意见 / 通过后公开 /
#   审核通过前必须配置可评测用例 / 重复审核拒绝 / 清理。
#
# 用法：
#   ./backend-rust/scripts/smoke_problem_review.sh
#   SMOKE_KEEP_DATA=1 ./backend-rust/scripts/smoke_problem_review.sh
#   SMOKE_VERBOSE=1 ./backend-rust/scripts/smoke_problem_review.sh
#
# 依赖：bash >= 4.2、curl、jq、psql。
# 安全性：只使用随机哑账号；报告不写入 token、密码、数据库连接串或题目答案。
# 只连接本地/测试数据库；只删除本次创建的账号与题目。

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

ADMIN_USER=""
ADMIN_ID=""
ADMIN_TOKEN=""
TEACHER_USER=""
TEACHER_ID=""
TEACHER_TOKEN=""
OTHER_USER=""
OTHER_ID=""
OTHER_TOKEN=""
STUDENT_USER=""
STUDENT_ID=""
STUDENT_TOKEN=""
USER_IDS=()

PROBLEM_ID=""
EMPTY_PROBLEM_ID=""
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

    local has_review_note has_reviewed_by
    has_review_note=$(db_scalar "SELECT EXISTS(SELECT 1 FROM information_schema.columns WHERE table_name = 'problems' AND column_name = 'review_note')")
    has_reviewed_by=$(db_scalar "SELECT EXISTS(SELECT 1 FROM information_schema.columns WHERE table_name = 'problems' AND column_name = 'reviewed_by')")
    assert_eq "题目审核迁移已应用（review_note）" "t" "$has_review_note"
    assert_eq "题目审核迁移已应用（reviewed_by）" "t" "$has_reviewed_by"
    if ((CHECK_FAILS > 0)); then
        fatal_preflight "数据库缺少 0006_problem_review.sql 迁移"
    fi
}

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
}

problem_body() {
    # problem_body TITLE [PUBLIC_CASES_JSON] [JUDGE_CASES_JSON]
    local title=$1
    local public_cases=${2:-'[]'}
    local judge_cases=${3:-'null'}
    jq -nc \
        --arg title "$title" \
        --arg description "冒烟测试题目：返回两数之和。" \
        --argjson public "$public_cases" \
        --argjson hidden "$judge_cases" \
        '{
            title: $title,
            description: $description,
            difficulty: "easy",
            time_limit: 1000,
            memory_limit: 256,
            tags: ["smoke"],
            examples: [{input: "1 2", output: "3", explanation: "1 + 2 = 3"}],
            test_cases: [],
            code_template: {python: "def solve(a, b):\n    return a + b\n"},
            run_config: {
                version: 1,
                function_name: "solve",
                params: [{name: "a", type: "int"}, {name: "b", type: "int"}],
                return_type: "int",
                compare: {mode: "exact"},
                public_cases: $public
            },
            judge_cases: $hidden
        }'
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

build_cleanup_sql() {
    local ids
    ids=$(IFS=,; printf '%s' "${USER_IDS[*]}")
    CLEANUP_SQL="DELETE FROM problems WHERE created_by IN ($ids); \
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
    printf '\n[INFO] 已删除测试账号与题目\n'
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
        --arg problem_id "$PROBLEM_ID" \
        --arg empty_problem_id "$EMPTY_PROBLEM_ID" \
        --arg cleaned "$CLEANED" \
        --arg git_commit "$(git -C "$REPO_ROOT" rev-parse --short HEAD 2>/dev/null || printf 'unknown')" \
        --argjson checks "$checks_json" \
        --argjson passed "$PASSED" \
        --argjson failed "$FAILED" \
        --argjson skipped "$SKIPPED" \
        --argjson duration_ms "$duration_ms" \
        '{started_at:$started_at, api_base:$api_base,
          problem_id:(if $problem_id == "" then null else ($problem_id | tonumber) end),
          empty_problem_id:(if $empty_problem_id == "" then null else ($empty_problem_id | tonumber) end),
          cleaned:($cleaned == "1"), git_commit:$git_commit, checks:$checks,
          summary:{passed:$passed, failed:$failed, skipped:$skipped, duration_ms:$duration_ms}}' \
        >"$REPORT_JSON"
}

main() {
    load_env

    mkdir -p "$REPORT_DIR" || fatal_preflight "无法创建报告目录 $REPORT_DIR"
    local stamp
    stamp=$(date -u +%Y%m%dT%H%M%SZ)
    REPORT_LOG="$REPORT_DIR/smoke-problem-review-$stamp.log"
    REPORT_JSON="$REPORT_DIR/smoke-problem-review-$stamp.json"
    exec > >(tee -a "$REPORT_LOG") 2>&1

    TMP_DIR=$(mktemp -d "${TMPDIR:-/tmp}/theseus-problem-smoke.XXXXXX") || fatal_preflight "无法创建临时目录"
    TMP_BODY="$TMP_DIR/body.json"

    START_MS=$(now_ms)
    START_ISO=$(date -u +'%Y-%m-%dT%H:%M:%SZ')

    local db_host
    db_host=$(printf '%s' "$DATABASE_URL" | sed -E 's#^[a-z]+://##; s#^[^@]*@##; s#[/?].*$##')
    say "smoke: $API_BASE  db=$db_host"

    begin_check preflight
    preflight_env
    CHECK_NOTE="problem review migration"
    end_check

    # ------------------------------------------------------------------
    # 账号
    # ------------------------------------------------------------------
    begin_check accounts
    local suffix password body
    suffix=$(random_suffix)
    password=${PASSWORD:-$(random_password)}
    ADMIN_USER="psmoke_admin_${suffix}"
    TEACHER_USER="psmoke_teacher_${suffix}"
    OTHER_USER="psmoke_other_${suffix}"
    STUDENT_USER="psmoke_student_${suffix}"

    register_and_login "$ADMIN_USER" "${ADMIN_USER}@example.test" "$password"
    ADMIN_ID=$REG_USER_ID
    USER_IDS+=("$ADMIN_ID")
    register_and_login "$TEACHER_USER" "${TEACHER_USER}@example.test" "$password"
    TEACHER_ID=$REG_USER_ID
    USER_IDS+=("$TEACHER_ID")
    register_and_login "$OTHER_USER" "${OTHER_USER}@example.test" "$password"
    OTHER_ID=$REG_USER_ID
    USER_IDS+=("$OTHER_ID")
    register_and_login "$STUDENT_USER" "${STUDENT_USER}@example.test" "$password"
    STUDENT_ID=$REG_USER_ID
    USER_IDS+=("$STUDENT_ID")

    db_scalar "UPDATE users SET role = 'admin' WHERE id = $ADMIN_ID" >/dev/null ||
        fatal_preflight "无法将测试账号提升为管理员"
    db_scalar "UPDATE users SET role = 'teacher' WHERE id = $TEACHER_ID" >/dev/null ||
        fatal_preflight "无法将测试账号提升为教师"
    db_scalar "UPDATE users SET role = 'teacher' WHERE id = $OTHER_ID" >/dev/null ||
        fatal_preflight "无法将测试账号提升为教师"

    login_only "$ADMIN_USER" "$password"
    ADMIN_TOKEN=$REG_TOKEN
    login_only "$TEACHER_USER" "$password"
    TEACHER_TOKEN=$REG_TOKEN
    login_only "$OTHER_USER" "$password"
    OTHER_TOKEN=$REG_TOKEN
    login_only "$STUDENT_USER" "$password"
    STUDENT_TOKEN=$REG_TOKEN
    CHECK_NOTE="admin/teacher/other/student"
    end_check

    # ------------------------------------------------------------------
    # 教师提交题目
    # ------------------------------------------------------------------
    begin_check teacher_submit
    body=$(problem_body "冒烟审核题目 ${suffix}" \
        '[{"args": [1, 2], "expected": 3}]' \
        '[{"args": [10, 20], "expected": 30}]')
    api_request POST /api/problems/custom "$TEACHER_TOKEN" "$body"
    assert_status "教师提交题目" "201"
    PROBLEM_ID=$(jq -r '.data.id // empty' <<<"$API_BODY")
    assert_nonempty "problem_id" "$PROBLEM_ID"
    assert_contains "提交文案" "$(jq -r '.data.message // empty' <<<"$API_BODY")" "等待管理员审核"
    assert_eq "落库状态" "pending" "$(db_scalar "SELECT review_status FROM problems WHERE id = $PROBLEM_ID")"
    assert_eq "落库创建者" "$TEACHER_ID" "$(db_scalar "SELECT created_by FROM problems WHERE id = $PROBLEM_ID")"

    api_request GET '/api/problems/mine?status=pending&size=20' "$TEACHER_TOKEN" ""
    assert_status "教师待审核列表" "200"
    assert_eq "列表包含新题" "1" \
        "$(jq -r --argjson id "$PROBLEM_ID" '[.data.problems[] | select(.id == $id)] | length' <<<"$API_BODY")"

    api_request GET '/api/problems/mine?status=draft' "$TEACHER_TOKEN" ""
    assert_status "非法状态筛选" "400"

    api_request GET "/api/problems/mine/$PROBLEM_ID" "$OTHER_TOKEN" ""
    assert_status "其他教师查看题目" "404"

    api_request GET "/api/problems/$PROBLEM_ID" "" ""
    assert_status "待审核题目公开详情" "404"
    CHECK_NOTE="problem=$PROBLEM_ID"
    end_check

    # ------------------------------------------------------------------
    # 学生个人出题：提交后同样进入管理员审核
    # ------------------------------------------------------------------
    begin_check student_submit
    body=$(problem_body "学生投稿题目 ${suffix}" \
        '[{"args": [2, 3], "expected": 5}]' \
        '[{"args": [20, 30], "expected": 50}]')
    api_request POST /api/problems/custom "$STUDENT_TOKEN" "$body"
    assert_status "学生提交题目" "201"
    STUDENT_PROBLEM_ID=$(jq -r '.data.id // empty' <<<"$API_BODY")
    assert_nonempty "student_problem_id" "$STUDENT_PROBLEM_ID"
    assert_eq "学生题目落库状态" "pending" \
        "$(db_scalar "SELECT review_status FROM problems WHERE id = $STUDENT_PROBLEM_ID")"
    assert_eq "学生题目创建者" "$STUDENT_ID" \
        "$(db_scalar "SELECT created_by FROM problems WHERE id = $STUDENT_PROBLEM_ID")"

    api_request GET '/api/problems/mine?status=pending&size=20' "$STUDENT_TOKEN" ""
    assert_status "学生待审核列表" "200"
    assert_eq "学生列表包含投稿" "1" \
        "$(jq -r --argjson id "$STUDENT_PROBLEM_ID" '[.data.problems[] | select(.id == $id)] | length' <<<"$API_BODY")"

    api_request GET "/api/problems/$STUDENT_PROBLEM_ID" "" ""
    assert_status "学生待审核题目不公开" "404"

    api_request GET "/api/problems/mine/$STUDENT_PROBLEM_ID" "$OTHER_TOKEN" ""
    assert_status "他人查看学生题目" "404"
    CHECK_NOTE="student_problem=$STUDENT_PROBLEM_ID"
    end_check

    # ------------------------------------------------------------------
    # 审核边界
    # ------------------------------------------------------------------
    begin_check review_guard
    api_request PUT "/api/admin/problems/$PROBLEM_ID/review" "$TEACHER_TOKEN" '{"status":"approved"}'
    assert_status "教师自审" "403"

    api_request GET '/api/admin/problems?status=pending&size=50' "$ADMIN_TOKEN" ""
    assert_status "管理员待审核列表" "200"
    assert_eq "管理员列表包含新题" "1" \
        "$(jq -r --argjson id "$PROBLEM_ID" '[.data.problems[] | select(.id == $id)] | length' <<<"$API_BODY")"
    assert_eq "列表显示创建者" "$TEACHER_USER" \
        "$(jq -r --argjson id "$PROBLEM_ID" '.data.problems[] | select(.id == $id) | .created_by_username' <<<"$API_BODY")"

    api_request GET "/api/admin/problems/$PROBLEM_ID" "$ADMIN_TOKEN" ""
    assert_status "管理员题目详情" "200"
    assert_eq "详情状态" "pending" "$(jq -r '.data.review_status' <<<"$API_BODY")"
    assert_eq "详情隐藏用例数" "1" "$(jq -r '.data.judge_cases | length' <<<"$API_BODY")"
    assert_eq "详情审核意见为空" "null" "$(jq -r '.data.review_note' <<<"$API_BODY")"

    body=$(jq -nc --arg title "冒烟审核题目（教师改名）${suffix}" \
        --arg description "冒烟测试题目：返回两数之和。" \
        --argjson hidden '[{"args": [10, 20], "expected": 30}]' \
        '{
            title:$title, description:$description, difficulty:"easy",
            time_limit:1000, memory_limit:256, tags:["smoke"],
            examples:[{input:"1 2", output:"3", explanation:"1 + 2 = 3"}],
            test_cases:[],
            code_template:{python:"def solve(a, b):\n    return a + b\n"},
            run_config:{version:1, function_name:"solve",
                params:[{name:"a",type:"int"},{name:"b",type:"int"}],
                return_type:"int", compare:{mode:"exact"},
                public_cases:[{args:[1,2], expected:3}]},
            judge_cases:$hidden
        }')
    api_request PUT "/api/problems/mine/$PROBLEM_ID" "$TEACHER_TOKEN" "$body"
    assert_status "修改待审核题目" "409"

    api_request PUT "/api/admin/problems/$PROBLEM_ID/review" "$ADMIN_TOKEN" '{"status":"rejected"}'
    assert_status "退回但不填原因" "400"
    assert_contains "退回原因文案" "$(api_error)" "退回原因"

    api_request PUT "/api/admin/problems/$PROBLEM_ID/review" "$ADMIN_TOKEN" \
        '{"status":"approved","note":"忽略"}'
    assert_status "正常通过" "200"
    assert_eq "通过后状态" "approved" "$(db_scalar "SELECT review_status FROM problems WHERE id = $PROBLEM_ID")"
    assert_eq "通过后审核人" "$ADMIN_ID" "$(db_scalar "SELECT reviewed_by FROM problems WHERE id = $PROBLEM_ID")"

    api_request GET "/api/problems/$PROBLEM_ID" "" ""
    assert_status "通过后公开详情" "200"
    assert_json_absent "公开详情" "$(jq -c '.data' <<<"$API_BODY")" "judge_cases"
    # run_config 按设计公开返回（public_cases 本就公开），隐藏用例单独存放在 judge_cases。

    api_request PUT "/api/admin/problems/$PROBLEM_ID/review" "$ADMIN_TOKEN" '{"status":"rejected","note":"重复审核"}'
    assert_status "重复审核" "409"
    CHECK_NOTE="problem=$PROBLEM_ID"
    end_check

    # ------------------------------------------------------------------
    # 退回与重新提交
    # ------------------------------------------------------------------
    begin_check reject_resubmit
    body=$(problem_body "冒烟退回题目 ${suffix}" \
        '[{"args": [1, 2], "expected": 3}]' \
        '[{"args": [10, 20], "expected": 30}]')
    api_request POST /api/problems/custom "$TEACHER_TOKEN" "$body"
    assert_status "教师提交第二题" "201"
    local second_id
    second_id=$(jq -r '.data.id // empty' <<<"$API_BODY")
    assert_nonempty "second_problem_id" "$second_id"

    api_request PUT "/api/admin/problems/$second_id/review" "$ADMIN_TOKEN" \
        '{"status":"rejected","note":"示例不足，请补充边界用例"}'
    assert_status "管理员退回" "200"
    assert_eq "退回后状态" "rejected" "$(db_scalar "SELECT review_status FROM problems WHERE id = $second_id")"
    assert_eq "退回后意见" "示例不足，请补充边界用例" \
        "$(db_scalar "SELECT review_note FROM problems WHERE id = $second_id")"

    api_request GET '/api/problems/mine?status=rejected&size=20' "$TEACHER_TOKEN" ""
    assert_status "教师退回列表" "200"
    assert_eq "退回列表包含题目" "1" \
        "$(jq -r --argjson id "$second_id" '[.data.problems[] | select(.id == $id)] | length' <<<"$API_BODY")"
    assert_eq "列表显示审核意见" "示例不足，请补充边界用例" \
        "$(jq -r --argjson id "$second_id" '.data.problems[] | select(.id == $id) | .review_note' <<<"$API_BODY")"

    api_request GET "/api/problems/mine/$second_id" "$TEACHER_TOKEN" ""
    assert_status "教师查看退回详情" "200"
    assert_eq "详情审核意见" "示例不足，请补充边界用例" "$(jq -r '.data.review_note' <<<"$API_BODY")"

    body=$(problem_body "冒烟退回题目（已补充）${suffix}" \
        '[{"args": [1, 2], "expected": 3}, {"args": [0, 0], "expected": 0}]' \
        '[{"args": [10, 20], "expected": 30}, {"args": [-1, 1], "expected": 0}]')
    api_request PUT "/api/problems/mine/$second_id" "$TEACHER_TOKEN" "$body"
    assert_status "教师重新提交" "200"
    assert_contains "重提文案" "$(jq -r '.data.message // empty' <<<"$API_BODY")" "重新提交"
    assert_eq "重提后状态" "pending" "$(db_scalar "SELECT review_status FROM problems WHERE id = $second_id")"
    assert_eq "重提清空意见" "" "$(db_scalar "SELECT COALESCE(review_note, '') FROM problems WHERE id = $second_id")"
    assert_eq "重提清空审核人" "" "$(db_scalar "SELECT COALESCE(reviewed_by::text, '') FROM problems WHERE id = $second_id")"
    assert_eq "重提更新标题" "冒烟退回题目（已补充）${suffix}" \
        "$(db_scalar "SELECT title FROM problems WHERE id = $second_id")"

    api_request PUT "/api/admin/problems/$second_id/review" "$ADMIN_TOKEN" '{"status":"approved"}'
    assert_status "重提后通过" "200"
    # 第一题通过 1 条 + 第二题退回 1 条 + 重提后通过 1 条。
    assert_eq "审核通知数" "3" "$(notification_count "$TEACHER_TOKEN" problem_review)"
    CHECK_NOTE="problem=$second_id"
    end_check

    # ------------------------------------------------------------------
    # 通过前必须可评测
    # ------------------------------------------------------------------
    begin_check approval_requires_cases
    body=$(problem_body "冒烟空用例题目 ${suffix}" '[]' 'null')
    api_request POST /api/problems/custom "$TEACHER_TOKEN" "$body"
    assert_status "教师提交空用例题目" "201"
    EMPTY_PROBLEM_ID=$(jq -r '.data.id // empty' <<<"$API_BODY")
    assert_nonempty "empty_problem_id" "$EMPTY_PROBLEM_ID"

    api_request PUT "/api/admin/problems/$EMPTY_PROBLEM_ID/review" "$ADMIN_TOKEN" '{"status":"approved"}'
    assert_status "无用例题目通过" "400"
    assert_contains "无用例文案" "$(api_error)" "评测用例"
    assert_eq "失败后仍待审核" "pending" \
        "$(db_scalar "SELECT review_status FROM problems WHERE id = $EMPTY_PROBLEM_ID")"

    api_request PUT "/api/admin/problems/$EMPTY_PROBLEM_ID/review" "$ADMIN_TOKEN" \
        '{"status":"rejected","note":"请先配置评测用例"}'
    assert_status "无用例题目退回" "200"
    CHECK_NOTE="problem=$EMPTY_PROBLEM_ID"
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
