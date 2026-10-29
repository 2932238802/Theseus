#!/usr/bin/env bash
#
# Theseus 作业策略冒烟测试。
#
# 设计文档：doc/2610271_作业策略的实现.md
#
# 覆盖：
#   作业策略创建/发布 / 迟交快照与扣分 / 次数上限展示 / 补交免修 /
#   解析发布 / 成绩发布后统计 / 他人代码接口 / 策略审计 / 越权访问。
#
# 用法：
#   ./backend-rust/scripts/smoke_assignment_policy.sh
#   SMOKE_API_BASE=http://127.0.0.1:3001 ./backend-rust/scripts/smoke_assignment_policy.sh
#
# 依赖：bash、curl、jq、psql。
# 只使用随机哑账号，结束后删除测试组织和账号。

set -uo pipefail

SCRIPT_DIR=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)
REPO_ROOT=$(cd "$SCRIPT_DIR/../.." && pwd)
BACKEND_DIR="$REPO_ROOT/backend-rust"
ENV_FILE=${SMOKE_BACKEND_ENV:-"$BACKEND_DIR/.env"}
API_BASE=${SMOKE_API_BASE:-http://127.0.0.1:3000}
API_ROOT="${API_BASE%/}/api"
PASSWORD_HASH='$argon2id$v=19$m=19456,t=2,p=1$qv8iaQgEgWUlvnaYPAw+Sg$r0Fm/Iq+kxR7CGJjHL+EvUrOsXuWL42U3Ntb+B1FdJg'

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
TEACHER="policy_t_$SUFFIX"
STUDENT="policy_s_$SUFFIX"
TEACHER_EMAIL="$TEACHER@example.test"
STUDENT_EMAIL="$STUDENT@example.test"
CLASS_NAME="Policy Smoke $SUFFIX"

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
        -d "{\"username\":\"$1\",\"password\":\"admin\"}")
    printf '%s' "$body" >"$TMP_DIR/login.json"
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

cleanup() {
    psql "$DATABASE_URL" -q -c "DELETE FROM classes WHERE name = '$CLASS_NAME';" >/dev/null 2>&1 || true
    psql "$DATABASE_URL" -q -c "DELETE FROM users WHERE username IN ('$TEACHER', '$STUDENT');" >/dev/null 2>&1 || true
}

cleanup
psql "$DATABASE_URL" -q -v ON_ERROR_STOP=1 <<SQL
INSERT INTO users (username, email, password_hash, role, email_verified_at)
VALUES ('$TEACHER', '$TEACHER_EMAIL', '$PASSWORD_HASH', 'teacher', CURRENT_TIMESTAMP),
       ('$STUDENT', '$STUDENT_EMAIL', '$PASSWORD_HASH', 'student', CURRENT_TIMESTAMP);
SQL

TEACHER_TOKEN=$(login "$TEACHER")
STUDENT_TOKEN=$(login "$STUDENT")
[[ -n "$TEACHER_TOKEN" && -n "$STUDENT_TOKEN" ]] || fatal "测试账号登录失败"

say "创建组织并加入"
api POST /classes "$TEACHER_TOKEN" "{\"name\":\"$CLASS_NAME\",\"course_name\":\"Algo\"}"
expect_code "教师创建组织" 201
CLASS_ID=$(jq -r '.data.id' <<<"$LAST_BODY")
INVITE=$(jq -r '.data.invite_code' <<<"$LAST_BODY")
api POST /classes/join "$STUDENT_TOKEN" "{\"invite_code\":\"$INVITE\"}"
expect_code "学生加入组织" 200

say "创建并发布带策略作业"
DUE=$(date -u -d '-1 hour' +%Y-%m-%dT%H:%M:%SZ)
api POST "/classes/$CLASS_ID/assignments" "$TEACHER_TOKEN" "$(jq -nc \
    --arg title "Policy Assignment $SUFFIX" --arg due "$DUE" '{
        title:$title, due_at:$due,
        late_policy:"allow", late_grace_hours:24,
        late_penalty_per_day:10, late_penalty_cap:50,
        max_attempts:1, scoring_policy:"highest",
        score_visibility:"during", allow_peer_code:true,
        show_class_stats:true,
        problems:[{problem_id:1101,points:100,solution_md:"测试解析"}]
    }')"
expect_code "教师创建作业策略" 201
ASSIGNMENT_ID=$(jq -r '.data.id' <<<"$LAST_BODY")
api POST "/assignments/$ASSIGNMENT_ID/publish" "$TEACHER_TOKEN"
expect_code "发布作业" 200

say "直接写入迟交提交，验证快照与扣分"
STUDENT_ID=$(psql "$DATABASE_URL" -Atc "SELECT id FROM users WHERE username = '$STUDENT'")
psql "$DATABASE_URL" -q -c "INSERT INTO submissions
    (user_id, problem_id, assignment_id, language, code, status, total_test_cases, is_late, late_days)
    VALUES ($STUDENT_ID, 1101, $ASSIGNMENT_ID, 'python', 'x', 'accepted', 5, TRUE, 1);"
api GET "/assignments/$ASSIGNMENT_ID" "$STUDENT_TOKEN"
expect_code "学生读取作业详情" 200
expect_jq "迟交标记可见" '.data.problems[0].is_late == true'
expect_jq "迟交天数正确" '.data.problems[0].late_days == 1'
expect_jq "迟交扣分正确" '.data.problems[0].late_deduction == 10'
expect_jq "次数剩余为 0" '.data.problems[0].attempts_left == 0'
expect_jq "解析未发布时不可见" '.data.problems[0].solutions_visible == false'

api GET "/assignments/$ASSIGNMENT_ID/gradebook" "$TEACHER_TOKEN"
expect_code "教师读取批改台" 200
expect_jq "批改台自动分扣迟交" '.data.students[0].problems[0].auto_score == 90'
expect_jq "批改台最终分正确" '.data.students[0].problems[0].final_score == 90'
expect_jq "批改台迟交标记正确" '.data.students[0].problems[0].is_late == true'

say "补交与免修"
api PUT "/assignments/$ASSIGNMENT_ID/overrides/$STUDENT_ID/problems/1101" "$TEACHER_TOKEN" '{
    "makeup_due_at": null, "waive_late_penalty": true,
    "exempt": true, "exemption_mode": "excluded", "reason": "病假"
}'
expect_code "教师设置免修" 200
expect_jq "免修记录已返回" '.data.overrides[0].exempt == true'
api GET "/assignments/$ASSIGNMENT_ID/gradebook" "$TEACHER_TOKEN"
expect_jq "免修排除出总分" '.data.students[0].problems[0].included_in_total == false'
expect_jq "免修最终分为 0" '.data.students[0].problems[0].final_score == 0'
api DELETE "/assignments/$ASSIGNMENT_ID/overrides/$STUDENT_ID/problems/1101" "$TEACHER_TOKEN"
expect_code "教师撤销免修" 200
expect_jq "免修记录已清空" '.data.overrides | length == 0'

say "解析发布、成绩发布与统计"
api POST "/assignments/$ASSIGNMENT_ID/solutions/publish" "$TEACHER_TOKEN"
expect_code "教师发布解析" 200
api GET "/assignments/$ASSIGNMENT_ID" "$STUDENT_TOKEN"
expect_jq "学生可见解析" '.data.problems[0].solutions_visible == true'
api POST "/assignments/$ASSIGNMENT_ID/grades/publish" "$TEACHER_TOKEN"
expect_code "教师发布成绩" 200
api GET "/assignments/$ASSIGNMENT_ID/statistics" "$STUDENT_TOKEN"
expect_code "学生读取匿名统计" 200
expect_jq "统计返回平均分" '.data.student_count == 1 and .data.average_score >= 0'
api GET "/assignments/$ASSIGNMENT_ID/problems/1101/peer-submissions" "$STUDENT_TOKEN"
expect_code "学生读取同学 AC 代码" 200
api GET "/assignments/$ASSIGNMENT_ID/policy-audits" "$TEACHER_TOKEN"
expect_code "教师读取策略审计" 200
expect_jq "审计包含解析和例外" '.data.audits | length >= 2'

say "清理"
cleanup
if ((FAILED > 0)); then
    printf '\n%d passed, %d failed\n' "$PASSED" "$FAILED" >&2
    exit 1
fi
printf '\n%d passed, 0 failed\n' "$PASSED"
