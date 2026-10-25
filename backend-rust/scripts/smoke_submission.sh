#!/usr/bin/env bash
#
# Theseus 提交评测冒烟测试。
#
# 设计文档：doc/2610255_冒烟测试实现.md
#
# 只操作真实运行的 API + judge_worker + PostgreSQL + Redis + Docker 沙箱，
# 不 mock 任何一层。覆盖：
#   T1 accepted / T2 wrong_answer（首错裁剪）/ T3 compile_error /
#   T4 time_limit_exceeded / T5 runtime_error / T6 权限与列表裁剪 /
#   T7 重复投递幂等 / T8 计数与做题状态
#
# 用法：
#   ./backend-rust/scripts/smoke_submission.sh
#   SMOKE_KEEP_DATA=1 ./backend-rust/scripts/smoke_submission.sh
#   SMOKE_SKIP_CPP=1 ./backend-rust/scripts/smoke_submission.sh
#   SMOKE_VERBOSE=1 ./backend-rust/scripts/smoke_submission.sh
#
# 依赖：bash >= 4.2、curl、jq、psql、redis-cli（可选 docker、shellcheck）。
# 安全性：只使用随机哑账号；不输出 token、密码、源码或隐藏用例内容。
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
TIMEOUT_SECS=${SMOKE_TIMEOUT_SECS:-240}
POLL_MS=${SMOKE_POLL_INTERVAL_MS:-500}
KEEP_DATA=${SMOKE_KEEP_DATA:-0}
RESTORE_COUNTERS=${SMOKE_RESTORE_COUNTERS:-0}
SKIP_CPP=${SMOKE_SKIP_CPP:-0}
VERBOSE=${SMOKE_VERBOSE:-0}
REPORT_DIR=${SMOKE_REPORT_DIR:-"$REPO_ROOT/.dev-logs"}
PASSWORD=${SMOKE_PASSWORD:-}

# 运行期状态
START_MS=0
START_ISO=""
PASSED=0
FAILED=0
SKIPPED=0
CHECKS_JSON=()
CHECK_ID=""
CHECK_SID=""
CHECK_FAILS=0
CHECK_START_MS=0
CHECK_NOTE=""

USER_A=""
TOKEN_A=""
USER_B=""
TOKEN_B=""
SUBMISSION_ID=""
DETAIL=""
FINAL_STATUS=""
FINAL_JSON=""
AC_SUBMISSION_ID=""
LAST_SUBMISSION_ID=""
EXECUTED=0
CPP_SKIP_REASON=""
BASE_SUBMIT=0
BASE_ACCEPT=0
BASE_RATE=0
BASELINE_CAPTURED=0
CLEANING_UP=0

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
    # 部分 coreutils 实现（如 uutils）的 %3N 会输出完整纳秒，
    # 因此统一用 %N 纳秒自行截断，并兼容不支持 %N 的平台。
    local ns
    ns=$(date +%s%N 2>/dev/null)
    if [[ "$ns" =~ ^[0-9]+$ ]]; then
        printf '%s\n' "$((ns / 1000000))"
    else
        printf '%s\n' "$(($(date +%s) * 1000))"
    fi
}

sleep_ms() {
    local ms=$1
    sleep "$(awk -v m="$ms" 'BEGIN { printf "%.3f", m / 1000 }')"
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
    REDIS_URL=${REDIS_URL:-redis://127.0.0.1:6379}
    SUBMIT_STREAM=${SUBMIT_STREAM:-theseus:judge:submissions}
    SUBMIT_CONSUMER_GROUP=${SUBMIT_CONSUMER_GROUP:-judge-submit-workers}
    RUN_IMAGE_CPP=${RUN_IMAGE_CPP:-theseus/runner-cpp:dev}
    RUN_SANDBOX_RUNTIME=${RUN_SANDBOX_RUNTIME:-runsc}

    [[ -n "$DATABASE_URL" ]] || fatal_preflight "未配置 DATABASE_URL"
    [[ -n "$REDIS_URL" ]] || fatal_preflight "未配置 REDIS_URL"
}

# ---------------------------------------------------------------------------
# 断言与检查记录
# ---------------------------------------------------------------------------

record_check() {
    local id=$1 status=$2 duration_ms=$3 sid=${4:-}
    local entry
    entry=$(jq -nc \
        --arg id "$id" \
        --arg status "$status" \
        --arg sid "$sid" \
        --argjson duration_ms "$duration_ms" \
        '{id:$id,status:$status,duration_ms:$duration_ms}
         + (if $sid == "" then {} else {submission_id:($sid | tonumber)} end)')
    CHECKS_JSON+=("$entry")
}

begin_check() {
    CHECK_ID=$1
    CHECK_SID=""
    CHECK_FAILS=0
    CHECK_NOTE=""
    CHECK_START_MS=$(now_ms)
}

end_check() {
    local duration_ms
    duration_ms=$(($(now_ms) - CHECK_START_MS))
    if ((CHECK_FAILS == 0)); then
        PASSED=$((PASSED + 1))
        printf '[PASS] %-16s %s\n' "$CHECK_ID" "$CHECK_NOTE"
        record_check "$CHECK_ID" passed "$duration_ms" "$CHECK_SID"
    else
        FAILED=$((FAILED + 1))
        printf '[FAIL] %-16s %d 项断言失败\n' "$CHECK_ID" "$CHECK_FAILS"
        record_check "$CHECK_ID" failed "$duration_ms" "$CHECK_SID"
    fi
}

skip_check() {
    local id=$1 reason=$2
    SKIPPED=$((SKIPPED + 1))
    printf '[SKIP] %-16s %s\n' "$id" "$reason"
    record_check "$id" skipped 0 "${CHECK_SID:-}"
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
    [[ "$haystack" != *"$needle"* ]] || fail_check "$desc：不应包含 [$needle]"
}

assert_contains_ci() {
    local desc=$1 haystack=$2 needle=$3
    local lower_haystack lower_needle
    lower_haystack=$(printf '%s' "$haystack" | tr '[:upper:]' '[:lower:]')
    lower_needle=$(printf '%s' "$needle" | tr '[:upper:]' '[:lower:]')
    [[ "$lower_haystack" == *"$lower_needle"* ]] || fail_check "$desc：[$haystack] 不包含 [$needle]"
}

assert_nonempty() {
    local desc=$1 value=$2
    [[ -n "$value" && "$value" != "null" ]] || fail_check "$desc：为空"
}

json_has_key() {
    jq -e --arg k "$2" 'has($k)' >/dev/null 2>&1 <<<"$1"
}

assert_json_key() {
    local desc=$1 json=$2 key=$3
    json_has_key "$json" "$key" || fail_check "$desc：缺少字段 $key"
}

assert_json_no_key() {
    local desc=$1 json=$2 key=$3
    if json_has_key "$json" "$key"; then
        fail_check "$desc：不应包含字段 $key"
    fi
}

assert_no_private_keys() {
    local desc=$1 json=$2
    local key
    for key in cases judge_cases judge_cases_snapshot; do
        assert_json_no_key "$desc" "$json" "$key"
    done
}

# ---------------------------------------------------------------------------
# HTTP / DB / Redis 辅助
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

retry_after_seconds() {
    local value
    value=$(awk -F': ' 'tolower($1) == "retry-after" { gsub("\r", "", $2); print $2 }' "$TMP_HEADERS" 2>/dev/null | tail -n 1)
    if [[ "$value" =~ ^[0-9]+$ ]]; then
        printf '%s\n' "$value"
    else
        printf '1\n'
    fi
}

db_query() {
    psql "$DATABASE_URL" -At -F '|' -v ON_ERROR_STOP=1 -c "$1" 2>/dev/null
}

db_scalar() {
    psql "$DATABASE_URL" -At -v ON_ERROR_STOP=1 -c "$1" 2>/dev/null
}

redis_cmd() {
    redis-cli -u "$REDIS_URL" --raw "$@"
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
    require_cmd redis-cli

    [[ "$PROBLEM_ID" =~ ^[0-9]+$ ]] || fatal_preflight "SMOKE_PROBLEM_ID 必须是整数"
    [[ "$TIMEOUT_SECS" =~ ^[0-9]+$ ]] || fatal_preflight "SMOKE_TIMEOUT_SECS 必须是整数"
    [[ "$POLL_MS" =~ ^[0-9]+$ ]] || fatal_preflight "SMOKE_POLL_INTERVAL_MS 必须是整数"

    psql "$DATABASE_URL" -At -c 'SELECT 1' >/dev/null 2>&1 ||
        fatal_service "PostgreSQL 不可达（检查 DATABASE_URL）"
    redis-cli -u "$REDIS_URL" ping >/dev/null 2>&1 ||
        fatal_service "Redis 不可达（检查 REDIS_URL）"

    api_request GET /api/stats "" ""
    [[ "$API_STATUS" == "200" ]] ||
        fatal_service "API 不可达或返回异常（GET /api/stats -> $API_STATUS）"

    local heartbeat
    heartbeat=$(redis-cli -u "$REDIS_URL" --scan --pattern 'theseus:submit:worker:*' 2>/dev/null | head -n 1)
    [[ -n "$heartbeat" ]] ||
        fatal_preflight "未检测到提交评测 Worker 心跳（theseus:submit:worker:*）；请确认 Worker 已启动且 SUBMIT_JUDGE_ENABLED=true"

    local seed review has_config public_cases hidden_cases
    seed=$(db_query "SELECT review_status, (run_config IS NOT NULL), COALESCE(jsonb_array_length(run_config->'public_cases'), 0), COALESCE(jsonb_array_length(judge_cases), 0) FROM problems WHERE id = $PROBLEM_ID")
    [[ -n "$seed" ]] || fatal_preflight "题目 $PROBLEM_ID 不存在；请先执行 backend-rust/scripts/seed_dev.sql"
    IFS='|' read -r review has_config public_cases hidden_cases <<<"$seed"
    [[ "$review" == "approved" ]] || fatal_preflight "题目 $PROBLEM_ID 未审核通过（review_status=$review）"
    [[ "$has_config" == "t" ]] || fatal_preflight "题目 $PROBLEM_ID 缺少 run_config"
    ((public_cases > 0)) || fatal_preflight "题目 $PROBLEM_ID 没有公开用例"
    ((hidden_cases > 0)) || fatal_preflight "题目 $PROBLEM_ID 没有隐藏用例；请执行 psql \"\$DATABASE_URL\" -f backend-rust/scripts/seed_dev.sql"

    if [[ -n "${RUN_SANDBOX_RUNTIME:-}" && "$RUN_SANDBOX_RUNTIME" != "runsc" ]]; then
        warn "沙箱运行时为 $RUN_SANDBOX_RUNTIME（仅允许本地开发）"
    fi
    if ((public_cases + hidden_cases != 6)); then
        warn "题目 $PROBLEM_ID 的判题用例为 $((public_cases + hidden_cases)) 条（文档示例为 6 条），后续断言按 6 条执行"
    fi

    if [[ "$SKIP_CPP" == "1" ]]; then
        CPP_SKIP_REASON="SMOKE_SKIP_CPP=1"
    elif command -v docker >/dev/null 2>&1; then
        if ! docker info >/dev/null 2>&1; then
            warn "无法访问 Docker，跳过 C++ 镜像预检（Worker 仍需具备 Docker 权限）"
        elif ! docker image inspect "$RUN_IMAGE_CPP" >/dev/null 2>&1; then
            CPP_SKIP_REASON="C++ 运行镜像 $RUN_IMAGE_CPP 不存在"
        fi
    else
        warn "未安装 docker CLI，跳过 C++ 镜像预检"
    fi
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

    body=$(jq -nc --arg u "$username" --arg p "$password" '{username:$u, password:$p}')
    api_request POST /api/auth/login "" "$body"
    [[ "$API_STATUS" == "200" ]] || fatal_preflight "登录失败（HTTP $API_STATUS：$(api_error)）"

    REG_USER_ID=$(jq -r '.data.user.id // empty' <<<"$API_BODY")
    REG_TOKEN=$(jq -r '.data.token // empty' <<<"$API_BODY")
    [[ -n "$REG_USER_ID" && -n "$REG_TOKEN" ]] || fatal_preflight "登录响应缺少 user.id 或 token"
}

# ---------------------------------------------------------------------------
# 提交
# ---------------------------------------------------------------------------

# create_submission CODE [LANGUAGE]
# 设置 SUBMISSION_ID；失败时保持为空并记录断言。
create_submission() {
    local code=$1 language=${2:-python}
    local body attempt=0
    SUBMISSION_ID=""
    body=$(jq -nc --argjson problem "$PROBLEM_ID" --arg language "$language" --arg code "$code" \
        '{problem_id:$problem, language:$language, code:$code}')
    while ((attempt < 5)); do
        attempt=$((attempt + 1))
        api_request POST /api/submissions "$TOKEN_A" "$body"
        case "$API_STATUS" in
            201) break ;;
            429)
                local wait
                wait=$(retry_after_seconds)
                warn "创建提交被限流，${wait}s 后重试（第 $attempt 次）"
                sleep "$wait"
                ;;
            503)
                fatal_preflight "创建提交返回 503（$(api_error)）；检查 SUBMIT_JUDGE_ENABLED 与 Worker 心跳"
                ;;
            401)
                fatal_preflight "创建提交返回 401；JWT_SECRET 是否与 API 一致？"
                ;;
            *)
                fail_check "POST /api/submissions 返回 HTTP $API_STATUS（$(api_error)）"
                return 1
                ;;
        esac
    done
    if [[ "$API_STATUS" != "201" ]]; then
        fail_check "创建提交重试 $attempt 次仍未成功"
        return 1
    fi
    SUBMISSION_ID=$(jq -r '.data.submission_id // empty' <<<"$API_BODY")
    CHECK_SID=$SUBMISSION_ID
    assert_nonempty "submission_id" "$SUBMISSION_ID"
    assert_eq "创建响应 status" "pending" "$(jq -r '.data.status // empty' <<<"$API_BODY")"
    [[ -n "$SUBMISSION_ID" ]]
}

is_terminal_verdict() {
    case "$1" in
        accepted | wrong_answer | time_limit_exceeded | memory_limit_exceeded | \
            runtime_error | compile_error | internal_error) return 0 ;;
        *) return 1 ;;
    esac
}

# wait_terminal SUBMISSION_ID
# 设置 FINAL_STATUS / FINAL_JSON（.data）
wait_terminal() {
    local sid=$1 deadline status
    FINAL_STATUS=""
    FINAL_JSON=""
    deadline=$(($(now_ms) + TIMEOUT_SECS * 1000))
    while :; do
        api_request GET "/api/submissions/$sid/status" "$TOKEN_A"
        case "$API_STATUS" in
            200) ;;
            429)
                sleep "$(retry_after_seconds)"
                continue
                ;;
            503)
                fatal_preflight "轮询状态返回 503（$(api_error)）"
                ;;
            *)
                fail_check "GET /api/submissions/$sid/status 返回 HTTP $API_STATUS（$(api_error)）"
                return 1
                ;;
        esac
        FINAL_JSON=$(jq -c '.data' <<<"$API_BODY")
        status=$(jq -r '.status // empty' <<<"$FINAL_JSON")
        if is_terminal_verdict "$status"; then
            FINAL_STATUS=$status
            return 0
        fi
        if (($(now_ms) >= deadline)); then
            FINAL_STATUS=$status
            fail_check "等待终态超时（${TIMEOUT_SECS}s），最后状态 [$status]"
            return 1
        fi
        sleep_ms "$POLL_MS"
    done
}

fetch_detail() {
    local sid=$1
    api_request GET "/api/submissions/$sid" "$TOKEN_A"
    if [[ "$API_STATUS" != "200" ]]; then
        fail_check "GET /api/submissions/$sid 返回 HTTP $API_STATUS（$(api_error)）"
        DETAIL=""
        return 1
    fi
    DETAIL=$(jq -c '.data' <<<"$API_BODY")
    assert_json_key "提交详情" "$DETAIL" id
    assert_no_private_keys "提交详情" "$DETAIL"
    return 0
}

# 创建后立即查询一次状态：校验形态与用例总数。
# Worker 很快时可能已经进入终态，因此这里接受终态，但仍要求字段形态正确。
check_initial_status() {
    local sid=$1 data status total
    api_request GET "/api/submissions/$sid/status" "$TOKEN_A"
    if [[ "$API_STATUS" != "200" ]]; then
        fail_check "创建后立即查询状态返回 HTTP $API_STATUS（$(api_error)）"
        return
    fi
    data=$(jq -c '.data' <<<"$API_BODY")
    status=$(jq -r '.status // empty' <<<"$data")
    total=$(jq -r '.total_test_cases // -1' <<<"$data")
    case "$status" in
        pending | judging | accepted | wrong_answer | time_limit_exceeded | \
            memory_limit_exceeded | runtime_error | compile_error | internal_error) ;;
        *) fail_check "创建后状态非法：[$status]" ;;
    esac
    assert_eq "创建后 total_test_cases" "6" "$total"
    assert_no_private_keys "创建后状态响应" "$data"
    assert_json_no_key "创建后状态响应" "$data" code
}

# ---------------------------------------------------------------------------
# 用例执行
# ---------------------------------------------------------------------------

PY_AC=$(cat <<'PY'
class Solution:
    def twoSum(self, nums, target):
        seen = {}
        for index, value in enumerate(nums):
            if target - value in seen:
                return [seen[target - value], index]
            seen[value] = index
        return []
PY
)

PY_WA=$(cat <<'PY'
class Solution:
    def twoSum(self, nums, target):
        return []
PY
)

PY_TLE=$(cat <<'PY'
class Solution:
    def twoSum(self, nums, target):
        while True:
            pass
PY
)

PY_RE=$(cat <<'PY'
class Solution:
    def twoSum(self, nums, target):
        raise RuntimeError("smoke boom")
PY
)

CPP_CE=$(cat <<'CPP'
class Solution {
public:
    vector<int> twoSum(vector<int>& nums, int target) {
        return {}
    }
};
CPP
)

check_common_shape() {
    local sid=$1 expected_passed=$2 expected_total=$3
    local status passed total

    status=$(jq -r '.status // empty' <<<"$FINAL_JSON")
    passed=$(jq -r '.test_cases_passed // -1' <<<"$FINAL_JSON")
    total=$(jq -r '.total_test_cases // -1' <<<"$FINAL_JSON")

    assert_eq "终态 status" "$FINAL_STATUS" "$status"
    assert_eq "通过用例数" "$expected_passed" "$passed"
    assert_eq "用例总数" "$expected_total" "$total"
    assert_no_private_keys "状态响应" "$FINAL_JSON"
    assert_json_no_key "状态响应" "$FINAL_JSON" code

    [[ -n "$DETAIL" ]] || return 0
    assert_eq "详情 status" "$FINAL_STATUS" "$(jq -r '.status // empty' <<<"$DETAIL")"
    assert_eq "详情通过用例数" "$expected_passed" "$(jq -r '.test_cases_passed // -1' <<<"$DETAIL")"
    assert_eq "详情用例总数" "$expected_total" "$(jq -r '.total_test_cases // -1' <<<"$DETAIL")"
    assert_no_private_keys "详情响应" "$DETAIL"

    local db_row db_status db_passed db_total db_run_snap db_judge_snap db_finished
    db_row=$(db_query "SELECT status, test_cases_passed, total_test_cases, (run_config_snapshot IS NOT NULL), (judge_cases_snapshot IS NOT NULL), (finished_at IS NOT NULL) FROM submissions WHERE id = $sid")
    [[ -n "$db_row" ]] || {
        fail_check "数据库中不存在提交 $sid"
        return 0
    }
    IFS='|' read -r db_status db_passed db_total db_run_snap db_judge_snap db_finished <<<"$db_row"
    assert_eq "DB status" "$FINAL_STATUS" "$db_status"
    assert_eq "DB 通过用例数" "$expected_passed" "$db_passed"
    assert_eq "DB 用例总数" "$expected_total" "$db_total"
    assert_eq "DB 快照 run_config" "t" "$db_run_snap"
    assert_eq "DB 快照 judge_cases" "t" "$db_judge_snap"
    assert_eq "DB finished_at" "t" "$db_finished"
}

check_accepted() {
    local sid=$1
    check_common_shape "$sid" 6 6
    assert_eq "failed_case" "null" "$(jq -r '.failed_case' <<<"$DETAIL")"
    assert_eq "compile_output" "" "$(jq -r '.compile_output // ""' <<<"$DETAIL")"
    local db_cases non_passed
    db_cases=$(db_query "SELECT cases::text FROM submissions WHERE id = $sid")
    assert_eq "DB cases 长度" "6" "$(jq 'length' <<<"$db_cases")"
    non_passed=$(jq '[.[] | select(.status != "passed")] | length' <<<"$db_cases")
    assert_eq "DB 非 passed 用例数" "0" "$non_passed"
    assert_eq "user_problem_status" "accepted|$sid" \
        "$(db_query "SELECT status, last_submission_id FROM user_problem_status WHERE user_id = $USER_A AND problem_id = $PROBLEM_ID")"
}

check_wrong_answer() {
    local sid=$1
    check_common_shape "$sid" 0 6
    local failed_case idx status args error_message
    failed_case=$(jq -c '.failed_case' <<<"$DETAIL")
    assert_ne "failed_case" "null" "$failed_case"
    if [[ "$failed_case" != "null" ]]; then
        idx=$(jq -r '.index // -1' <<<"$failed_case")
        status=$(jq -r '.status // empty' <<<"$failed_case")
        args=$(jq -c '.args' <<<"$failed_case")
        assert_eq "failed_case.index" "0" "$idx"
        assert_eq "failed_case.status" "failed" "$status"
        assert_eq "failed_case.args" '[[2,7,11,15],9]' "$args"
        assert_json_key "failed_case" "$failed_case" expected
        assert_eq "failed_case.expected" '[0,1]' "$(jq -c '.expected' <<<"$failed_case")"
    fi
    error_message=$(jq -r '.error_message // ""' <<<"$DETAIL")
    assert_contains "error_message" "$error_message" "第 1 个用例"
    assert_not_contains "详情不应泄露第二条隐藏用例" "$DETAIL" "0,4,3,0"
    assert_not_contains "详情不应泄露第三条隐藏用例" "$DETAIL" "-1,-2,-3,-4,-5"

    local db_cases statuses
    db_cases=$(db_query "SELECT cases::text FROM submissions WHERE id = $sid")
    assert_eq "DB cases 长度" "6" "$(jq 'length' <<<"$db_cases")"
    statuses=$(jq -r '[.[].status] | join(",")' <<<"$db_cases")
    assert_eq "DB 用例状态" "failed,skipped,skipped,skipped,skipped,skipped" "$statuses"
}

check_compile_error() {
    local sid=$1
    check_common_shape "$sid" 0 6
    local output
    output=$(jq -r '.compile_output // ""' <<<"$DETAIL")
    assert_nonempty "compile_output" "$output"
    assert_contains_ci "compile_output" "$output" "error"
    assert_eq "failed_case" "null" "$(jq -r '.failed_case' <<<"$DETAIL")"
    local db_cases
    db_cases=$(db_query "SELECT cases::text FROM submissions WHERE id = $sid")
    assert_eq "DB cases 长度" "0" "$(jq 'length' <<<"$db_cases")"
    assert_eq "user_problem_status 不被 CE 降级" "accepted" \
        "$(db_scalar "SELECT status FROM user_problem_status WHERE user_id = $USER_A AND problem_id = $PROBLEM_ID")"
}

check_time_limit() {
    local sid=$1
    check_common_shape "$sid" 0 6
    local failed_case status error_message has_expected
    failed_case=$(jq -c '.failed_case' <<<"$DETAIL")
    assert_ne "failed_case" "null" "$failed_case"
    if [[ "$failed_case" != "null" ]]; then
        status=$(jq -r '.status // empty' <<<"$failed_case")
        assert_eq "failed_case.status" "timeout" "$status"
        has_expected=$(jq -r 'has("expected")' <<<"$failed_case")
        assert_eq "failed_case 不暴露 expected" "false" "$has_expected"
    fi
    error_message=$(jq -r '.error_message // ""' <<<"$DETAIL")
    if [[ "$error_message" != *"超过 2 秒"* && "$error_message" != *"总时长"* ]]; then
        fail_check "error_message 应包含「超过 2 秒」或「总时长」，实际 [$error_message]"
    fi

    local db_cases statuses
    db_cases=$(db_query "SELECT cases::text FROM submissions WHERE id = $sid")
    assert_eq "DB cases 长度" "6" "$(jq 'length' <<<"$db_cases")"
    statuses=$(jq -r '[.[].status] | join(",")' <<<"$db_cases")
    assert_eq "DB 用例状态" "timeout,skipped,skipped,skipped,skipped,skipped" "$statuses"
}

check_runtime_error() {
    local sid=$1
    check_common_shape "$sid" 0 6
    local failed_case status error_message stderr has_expected
    error_message=""
    stderr=""
    failed_case=$(jq -c '.failed_case' <<<"$DETAIL")
    assert_ne "failed_case" "null" "$failed_case"
    if [[ "$failed_case" != "null" ]]; then
        status=$(jq -r '.status // empty' <<<"$failed_case")
        assert_eq "failed_case.status" "runtime_error" "$status"
        has_expected=$(jq -r 'has("expected")' <<<"$failed_case")
        assert_eq "failed_case 不暴露 expected" "false" "$has_expected"
        stderr=$(jq -r '.stderr // ""' <<<"$failed_case")
    fi
    error_message=$(jq -r '.error_message // ""' <<<"$DETAIL")
    assert_nonempty "error_message" "$error_message"
    if [[ "$stderr" != *"boom"* && "$error_message" != *"boom"* ]]; then
        warn "stderr 与 error_message 均未包含 boom（沙箱可能未回传 traceback）"
    fi

    local db_cases statuses
    db_cases=$(db_query "SELECT cases::text FROM submissions WHERE id = $sid")
    assert_eq "DB cases 长度" "6" "$(jq 'length' <<<"$db_cases")"
    statuses=$(jq -r '[.[].status] | join(",")' <<<"$db_cases")
    assert_eq "DB 用例状态" "runtime_error,skipped,skipped,skipped,skipped,skipped" "$statuses"
}

run_case() {
    local id=$1 language=$2 verdict=$3 code=$4
    begin_check "$id"
    CHECK_NOTE=""

    if [[ "$verdict" == "compile_error" && -n "$CPP_SKIP_REASON" ]]; then
        skip_check "$id" "$CPP_SKIP_REASON"
        return 0
    fi
    if ! create_submission "$code" "$language"; then
        end_check
        return 1
    fi
    check_initial_status "$SUBMISSION_ID"
    EXECUTED=$((EXECUTED + 1))
    LAST_SUBMISSION_ID=$SUBMISSION_ID
    [[ "$verdict" == "accepted" ]] && AC_SUBMISSION_ID=$SUBMISSION_ID

    local started
    started=$(now_ms)
    wait_terminal "$SUBMISSION_ID"
    local elapsed=$((($(now_ms) - started) / 1000))
    assert_eq "verdict" "$verdict" "$FINAL_STATUS"
    if ! fetch_detail "$SUBMISSION_ID"; then
        end_check
        return 1
    fi

    case "$verdict" in
        accepted) check_accepted "$SUBMISSION_ID" ;;
        wrong_answer) check_wrong_answer "$SUBMISSION_ID" ;;
        compile_error) check_compile_error "$SUBMISSION_ID" ;;
        time_limit_exceeded) check_time_limit "$SUBMISSION_ID" ;;
        runtime_error) check_runtime_error "$SUBMISSION_ID" ;;
        *) fail_check "未知 verdict $verdict" ;;
    esac

    CHECK_NOTE=$(printf '%s/%s  %ss' \
        "$(jq -r '.test_cases_passed // 0' <<<"$FINAL_JSON")" \
        "$(jq -r '.total_test_cases // 0' <<<"$FINAL_JSON")" \
        "$elapsed")
    end_check
}

# ---------------------------------------------------------------------------
# T6 权限与列表裁剪
# ---------------------------------------------------------------------------

check_privacy() {
    begin_check privacy
    local ac_id=$1 list_body list_entries forbidden total suffix username email

    # 隐私检查需要第二个账号 B；注册失败属于前置条件问题。
    suffix=$(random_suffix)
    username="smoke_${suffix}"
    email="smoke_${suffix}@example.test"
    register_and_login "$username" "$email" "$PASSWORD"
    USER_B=$REG_USER_ID
    TOKEN_B=$REG_TOKEN

    api_request GET "/api/submissions/$ac_id" "$TOKEN_B"
    assert_eq "他人详情 HTTP" "403" "$API_STATUS"

    api_request GET "/api/submissions/$ac_id/status" "$TOKEN_B"
    assert_eq "他人状态 HTTP" "403" "$API_STATUS"

    api_request GET "/api/submissions/2147483000" "$TOKEN_A"
    assert_eq "不存在详情 HTTP" "404" "$API_STATUS"

    api_request GET "/api/submissions/2147483000/status" "$TOKEN_A"
    assert_eq "不存在状态 HTTP" "404" "$API_STATUS"

    api_request GET "/api/submissions?page=1&size=50" "$TOKEN_A"
    assert_eq "列表 HTTP" "200" "$API_STATUS"
    list_body=$(jq -c '.data' <<<"$API_BODY")
    total=$(jq -r '.total // 0' <<<"$list_body")
    ((total >= EXECUTED)) || fail_check "列表 total=$total 小于已执行提交数 $EXECUTED"
    list_entries=$(jq -c '.submissions // []' <<<"$list_body")
    (($(jq 'length' <<<"$list_entries") > 0)) || fail_check "列表为空"
    forbidden=$(jq '[.[] | select(has("code") or has("cases") or has("judge_cases") or has("judge_cases_snapshot"))] | length' <<<"$list_entries")
    assert_eq "列表不得包含 code/cases 等字段" "0" "$forbidden"

    local list_ac_passed list_ac_total list_ac_status
    list_ac_passed=$(jq -r --argjson id "$ac_id" '.[] | select(.id == $id) | .test_cases_passed' <<<"$list_entries")
    list_ac_total=$(jq -r --argjson id "$ac_id" '.[] | select(.id == $id) | .total_test_cases' <<<"$list_entries")
    list_ac_status=$(jq -r --argjson id "$ac_id" '.[] | select(.id == $id) | .status' <<<"$list_entries")
    assert_eq "列表 AC 通过数" "6" "$list_ac_passed"
    assert_eq "列表 AC 总数" "6" "$list_ac_total"
    assert_eq "列表 AC 状态" "accepted" "$list_ac_status"

    end_check
}

# ---------------------------------------------------------------------------
# T7 重复投递幂等
# ---------------------------------------------------------------------------

check_idempotency() {
    begin_check idempotency
    local ac_id=$1 attempt_before attempt_after
    local submit_before accept_before submit_after accept_after

    attempt_before=$(db_scalar "SELECT attempt_count FROM submissions WHERE id = $ac_id")
    IFS='|' read -r submit_before accept_before <<<"$(db_query "SELECT submit_count, accept_count FROM problems WHERE id = $PROBLEM_ID")"

    local message_id
    message_id=$(redis_cmd XADD "$SUBMIT_STREAM" '*' run_id "$ac_id" 2>/dev/null)
    assert_nonempty "XADD message id" "$message_id"

    sleep 3

    attempt_after=$(db_scalar "SELECT attempt_count FROM submissions WHERE id = $ac_id")
    IFS='|' read -r submit_after accept_after <<<"$(db_query "SELECT submit_count, accept_count FROM problems WHERE id = $PROBLEM_ID")"
    assert_eq "重复投递后 attempt_count" "$attempt_before" "$attempt_after"
    assert_eq "重复投递后 status" "accepted" "$(db_scalar "SELECT status FROM submissions WHERE id = $ac_id")"
    assert_eq "重复投递后 submit_count" "$submit_before" "$submit_after"
    assert_eq "重复投递后 accept_count" "$accept_before" "$accept_after"

    end_check
}

# ---------------------------------------------------------------------------
# T8 计数与做题状态
# ---------------------------------------------------------------------------

check_counters() {
    begin_check counters
    local others after_submit after_accept after_rate
    others=$(db_scalar "SELECT COUNT(*) FROM submissions WHERE problem_id = $PROBLEM_ID AND user_id <> $USER_A AND submitted_at >= '$START_ISO'")
    if [[ "$others" != "0" ]]; then
        skip_check counters "检测到其他用户对题目 $PROBLEM_ID 的 $others 条提交，跳过计数断言"
        return 0
    fi

    IFS='|' read -r after_submit after_accept after_rate <<<"$(db_query "SELECT submit_count, accept_count, acceptance_rate FROM problems WHERE id = $PROBLEM_ID")"
    assert_eq "submit_count 增量" "$EXECUTED" "$((after_submit - BASE_SUBMIT))"
    assert_eq "accept_count 增量" "1" "$((after_accept - BASE_ACCEPT))"

    if ! awk -v a="$after_accept" -v s="$after_submit" -v r="$after_rate" \
        'BEGIN { expected = (s > 0) ? a * 100.0 / s : 0; exit (expected - r < 0.01 && r - expected < 0.01) ? 0 : 1 }'; then
        fail_check "acceptance_rate=$after_rate 与 $after_accept/$after_submit 不一致"
    fi

    assert_eq "user_problem_status" "accepted|$LAST_SUBMISSION_ID" \
        "$(db_query "SELECT status, last_submission_id FROM user_problem_status WHERE user_id = $USER_A AND problem_id = $PROBLEM_ID")"

    end_check
}

# ---------------------------------------------------------------------------
# 报告与清理
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
        --arg user_id "${USER_A:-}" \
        --arg git_commit "$(git -C "$REPO_ROOT" rev-parse --short HEAD 2>/dev/null || printf 'unknown')" \
        --argjson checks "$checks_json" \
        --argjson passed "$PASSED" \
        --argjson failed "$FAILED" \
        --argjson skipped "$SKIPPED" \
        --argjson duration_ms "$duration_ms" \
        '{started_at:$started_at, api_base:$api_base, problem_id:$problem_id,
          user_id:(if $user_id == "" then null else ($user_id | tonumber) end),
          git_commit:$git_commit, checks:$checks,
          summary:{passed:$passed, failed:$failed, skipped:$skipped, duration_ms:$duration_ms}}' \
        >"$REPORT_JSON"
}

cleanup() {
    ((CLEANING_UP)) && return 0
    CLEANING_UP=1
    local status=0

    if [[ -n "$USER_A" || -n "$USER_B" ]]; then
        if [[ "$KEEP_DATA" == "1" ]]; then
            printf '\n[INFO] SMOKE_KEEP_DATA=1，保留测试账号：A=%s B=%s\n' "${USER_A:-none}" "${USER_B:-none}"
            printf '[INFO] 清理 SQL：DELETE FROM users WHERE id IN (%s%s);\n' "${USER_A:-0}" "${USER_B:+,$USER_B}"
        else
            local ids="${USER_A:-0}"
            [[ -n "$USER_B" ]] && ids="$ids,$USER_B"
            db_scalar "DELETE FROM users WHERE id IN ($ids)" >/dev/null 2>&1 || true
            printf '\n[INFO] 已删除测试账号与级联数据\n'
        fi
    fi

    if [[ "$RESTORE_COUNTERS" == "1" && "$BASELINE_CAPTURED" == "1" ]]; then
        local others
        others=$(db_scalar "SELECT COUNT(*) FROM submissions WHERE problem_id = $PROBLEM_ID AND user_id <> ${USER_A:-0} AND submitted_at >= '${START_ISO:-1970-01-01T00:00:00Z}'")
        if [[ "$others" == "0" ]]; then
            db_scalar "UPDATE problems SET submit_count = $BASE_SUBMIT, accept_count = $BASE_ACCEPT, acceptance_rate = $BASE_RATE WHERE id = $PROBLEM_ID" >/dev/null 2>&1 || true
            printf '[INFO] 已回滚题目 %s 的计数到基线（submit=%s accept=%s）\n' "$PROBLEM_ID" "$BASE_SUBMIT" "$BASE_ACCEPT"
        else
            warn "检测到其他用户的 $others 条提交，跳过计数回滚"
        fi
    elif [[ "$RESTORE_COUNTERS" == "1" ]]; then
        warn "未获取题目计数基线（前置检查未通过），跳过计数回滚"
    else
        printf '[INFO] 未回滚题目计数；如需回滚请设置 SMOKE_RESTORE_COUNTERS=1（需无并发提交）\n'
    fi

    [[ -n "$TMP_DIR" && -d "$TMP_DIR" ]] && rm -rf "$TMP_DIR"
    return "$status"
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
# 主流程
# ---------------------------------------------------------------------------

main() {
    load_env

    mkdir -p "$REPORT_DIR" || fatal_preflight "无法创建报告目录 $REPORT_DIR"
    local stamp
    stamp=$(date -u +%Y%m%dT%H%M%SZ)
    REPORT_LOG="$REPORT_DIR/smoke-submission-$stamp.log"
    REPORT_JSON="$REPORT_DIR/smoke-submission-$stamp.json"
    exec > >(tee -a "$REPORT_LOG") 2>&1

    TMP_DIR=$(mktemp -d "${TMPDIR:-/tmp}/theseus-smoke.XXXXXX") || fatal_preflight "无法创建临时目录"
    TMP_BODY="$TMP_DIR/body.json"
    TMP_HEADERS="$TMP_DIR/headers.txt"

    START_MS=$(now_ms)
    START_ISO=$(date -u +'%Y-%m-%dT%H:%M:%SZ')

    local db_host redis_host
    db_host=$(printf '%s' "$DATABASE_URL" | sed -E 's#^[a-z]+://##; s#^[^@]*@##; s#[/?].*$##')
    redis_host=$(printf '%s' "$REDIS_URL" | sed -E 's#^[a-z]+://##; s#^[^@]*@##')
    say "smoke: $API_BASE  problem=$PROBLEM_ID  db=$db_host  redis=$redis_host"

    begin_check preflight
    preflight_env
    IFS='|' read -r BASE_SUBMIT BASE_ACCEPT BASE_RATE <<<"$(db_query "SELECT submit_count, accept_count, acceptance_rate FROM problems WHERE id = $PROBLEM_ID")"
    # 只有真正读到基线后才允许清理阶段回滚；否则前置检查失败时
    # BASE_* 仍是初始值 0，会把题目计数误写成 0。
    [[ -n "$BASE_SUBMIT" && -n "$BASE_ACCEPT" && -n "$BASE_RATE" ]] && BASELINE_CAPTURED=1
    end_check

    begin_check auth
    local suffix username email
    suffix=$(random_suffix)
    PASSWORD=${PASSWORD:-$(random_password)}
    username="smoke_${suffix}"
    email="smoke_${suffix}@example.test"
    register_and_login "$username" "$email" "$PASSWORD"
    USER_A=$REG_USER_ID
    TOKEN_A=$REG_TOKEN
    CHECK_SID=""
    assert_nonempty "user_id" "$USER_A"
    end_check

    run_case accepted python accepted "$PY_AC"
    run_case wrong_answer python wrong_answer "$PY_WA"
    run_case compile_error cpp compile_error "$CPP_CE"
    run_case time_limit_exceeded python time_limit_exceeded "$PY_TLE"
    run_case runtime_error python runtime_error "$PY_RE"

    if [[ -n "$AC_SUBMISSION_ID" ]]; then
        check_privacy "$AC_SUBMISSION_ID"
        check_idempotency "$AC_SUBMISSION_ID"
    else
        skip_check privacy "accepted 提交未成功创建"
        skip_check idempotency "accepted 提交未成功创建"
    fi
    if ((EXECUTED > 0)); then
        check_counters
    else
        skip_check counters "没有成功执行的提交"
    fi

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
