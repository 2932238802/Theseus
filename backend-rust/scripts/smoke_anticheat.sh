#!/usr/bin/env bash
#
# Theseus 防作弊闭环冒烟测试。
#
# 设计文档：doc/2610301_防作弊代码相似度设计方案.md
#
# 覆盖：
#   相似度扫描入队（Worker 在线时）/ 报告列表与详情 / 教师确认并判零 /
#   学生查看我的报告并申诉 / 非处理人越权裁定 / 申诉翻案恢复成绩。
#
# 用法：
#   ./backend-rust/scripts/smoke_anticheat.sh
#   SMOKE_API_BASE=http://127.0.0.1:3001 ./backend-rust/scripts/smoke_anticheat.sh
#
# 依赖：bash、curl、jq、psql；redis-cli 可选。
# 只使用随机哑账号和临时组织，结束后清理。脚本不会打印令牌或源码。

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
ANTICHEAT_STREAM=${ANTICHEAT_STREAM:-theseus:anticheat:scan}

SUFFIX=$RANDOM
TEACHER="cheat_t_$SUFFIX"
TEACHER2="cheat_t2_$SUFFIX"
STUDENT="cheat_s_$SUFFIX"
STUDENT2="cheat_s2_$SUFFIX"
TEACHER_EMAIL="$TEACHER@example.test"
TEACHER2_EMAIL="$TEACHER2@example.test"
STUDENT_EMAIL="$STUDENT@example.test"
STUDENT2_EMAIL="$STUDENT2@example.test"
CLASS_NAME="Anticheat Smoke $SUFFIX"

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
    psql "$DATABASE_URL" -q -c "DELETE FROM users WHERE username IN ('$TEACHER', '$TEACHER2', '$STUDENT', '$STUDENT2');" >/dev/null 2>&1 || true
}

cleanup
psql "$DATABASE_URL" -q -v ON_ERROR_STOP=1 <<SQL
INSERT INTO users (username, email, password_hash, role, email_verified_at)
VALUES ('$TEACHER', '$TEACHER_EMAIL', '$PASSWORD_HASH', 'teacher', CURRENT_TIMESTAMP),
       ('$TEACHER2', '$TEACHER2_EMAIL', '$PASSWORD_HASH', 'teacher', CURRENT_TIMESTAMP),
       ('$STUDENT', '$STUDENT_EMAIL', '$PASSWORD_HASH', 'student', CURRENT_TIMESTAMP),
       ('$STUDENT2', '$STUDENT2_EMAIL', '$PASSWORD_HASH', 'student', CURRENT_TIMESTAMP);
SQL

TEACHER_TOKEN=$(login "$TEACHER")
TEACHER2_TOKEN=$(login "$TEACHER2")
STUDENT_TOKEN=$(login "$STUDENT")
STUDENT2_TOKEN=$(login "$STUDENT2")
[[ -n "$TEACHER_TOKEN" && -n "$TEACHER2_TOKEN" && -n "$STUDENT_TOKEN" && -n "$STUDENT2_TOKEN" ]] \
    || fatal "测试账号登录失败"

PROBLEM_ID=$(psql "$DATABASE_URL" -Atc "SELECT id FROM problems ORDER BY id LIMIT 1")
[[ -n "$PROBLEM_ID" ]] || fatal "数据库中没有题目，无法创建作业"

say "创建组织、加入学生并发布作业"
api POST /classes "$TEACHER_TOKEN" "{\"name\":\"$CLASS_NAME\",\"course_name\":\"Algo\"}"
expect_code "教师创建组织" 201
CLASS_ID=$(jq -r '.data.id' <<<"$LAST_BODY")
INVITE=$(jq -r '.data.invite_code' <<<"$LAST_BODY")
api POST /classes/join "$STUDENT_TOKEN" "{\"invite_code\":\"$INVITE\"}"
expect_code "学生加入组织" 200
api POST /classes/join "$STUDENT2_TOKEN" "{\"invite_code\":\"$INVITE\"}"
expect_code "第二名同学加入组织" 200

DUE=$(date -u -d '+1 day' +%Y-%m-%dT%H:%M:%SZ)
api POST "/classes/$CLASS_ID/assignments" "$TEACHER_TOKEN" "$(jq -nc \
    --arg title "Anticheat Assignment $SUFFIX" \
    --arg due "$DUE" \
    --argjson problem "$PROBLEM_ID" \
    '{title:$title, due_at:$due, problems:[{problem_id:$problem, points:100}]}')"
expect_code "教师创建作业" 201
ASSIGNMENT_ID=$(jq -r '.data.id' <<<"$LAST_BODY")
api POST "/assignments/$ASSIGNMENT_ID/publish" "$TEACHER_TOKEN"
expect_code "发布作业" 200

TEACHER_ID=$(psql "$DATABASE_URL" -Atc "SELECT id FROM users WHERE username = '$TEACHER'")
STUDENT_ID=$(psql "$DATABASE_URL" -Atc "SELECT id FROM users WHERE username = '$STUDENT'")
STUDENT2_ID=$(psql "$DATABASE_URL" -Atc "SELECT id FROM users WHERE username = '$STUDENT2'")

say "写入两份高度相似的提交"
FIRST_CODE=$(cat <<'PY'
def solve(values, limit):
    total = 0
    count = 0
    for value in values:
        if value % 2 == 0 and value <= limit:
            total = total + value
            count = count + 1
        else:
            total = total - 1
    average = total / count if count > 0 else 0
    return total, average, count
PY
)
SECOND_CODE=$(cat <<'PY'
def calculate(items, maximum):
    result = 0
    amount = 0
    for item in items:
        if item % 2 == 0 and item <= maximum:
            result = result + item
            amount = amount + 1
        else:
            result = result - 1
    mean = result / amount if amount > 0 else 0
    return result, mean, amount
PY
)
FIRST_ID=$(psql "$DATABASE_URL" -Atc "INSERT INTO submissions
    (user_id, problem_id, assignment_id, language, code, status, total_test_cases)
    VALUES ($STUDENT_ID, $PROBLEM_ID, $ASSIGNMENT_ID, 'python', \$code\$$FIRST_CODE\$code\$, 'accepted', 5)
    RETURNING id")
SECOND_ID=$(psql "$DATABASE_URL" -Atc "INSERT INTO submissions
    (user_id, problem_id, assignment_id, language, code, status, total_test_cases)
    VALUES ($STUDENT2_ID, $PROBLEM_ID, $ASSIGNMENT_ID, 'python', \$code\$$SECOND_CODE\$code\$, 'accepted', 5)
    RETURNING id")
[[ -n "$FIRST_ID" && -n "$SECOND_ID" ]] || fatal "写入提交失败"

say "预置该题人工分，便于验证申诉翻案恢复"
psql "$DATABASE_URL" -q -c "INSERT INTO assignment_problem_grades
    (assignment_id, user_id, problem_id, manual_score, feedback, graded_by)
    VALUES ($ASSIGNMENT_ID, $STUDENT_ID, $PROBLEM_ID, 80, 'smoke baseline', $TEACHER_ID)
    ON CONFLICT (assignment_id, user_id, problem_id) DO UPDATE SET manual_score = 80;"

REPORT_ID=""
if command -v redis-cli >/dev/null 2>&1 && redis-cli ping >/dev/null 2>&1; then
    say "投递扫描任务，等待 Worker 生成报告"
    redis-cli XADD "$ANTICHEAT_STREAM" '*' submission_id "$SECOND_ID" >/dev/null
    for _ in $(seq 1 30); do
        REPORT_ID=$(psql "$DATABASE_URL" -Atc \
            "SELECT id FROM cheat_reports WHERE submission_id = $SECOND_ID LIMIT 1")
        [[ -n "$REPORT_ID" ]] && break
        sleep 0.5
    done
fi

if [[ -z "$REPORT_ID" ]]; then
    say "Worker 未在线的，直接写入比对结果以验证接口闭环"
    psql "$DATABASE_URL" -q -v ON_ERROR_STOP=1 <<SQL
INSERT INTO similarity_pairs (submission_a, submission_b, problem_id, assignment_id, algorithm, score, detail)
VALUES (LEAST($FIRST_ID, $SECOND_ID), GREATEST($FIRST_ID, $SECOND_ID), $PROBLEM_ID, $ASSIGNMENT_ID,
        'winnowing-token', 0.9600, '{"matched_grams": 40}'::jsonb)
ON CONFLICT (submission_a, submission_b, algorithm) DO UPDATE SET score = 0.9600;
INSERT INTO cheat_reports
    (target_user_id, submission_id, assignment_id, problem_id, severity, score,
     matched_submission_id, matched_user_id, evidence)
VALUES ($STUDENT2_ID, $SECOND_ID, $ASSIGNMENT_ID, $PROBLEM_ID, 'high', 0.9600,
        $FIRST_ID, $STUDENT_ID, '{"algorithm":"winnowing-token"}'::jsonb)
ON CONFLICT (submission_id) DO NOTHING;
SQL
    REPORT_ID=$(psql "$DATABASE_URL" -Atc \
        "SELECT id FROM cheat_reports WHERE submission_id = $SECOND_ID LIMIT 1")
fi
[[ -n "$REPORT_ID" ]] || fatal "未能生成作弊报告"

say "教师读取报告与比对详情"
api GET "/teacher/cheat-reports?status=open" "$TEACHER_TOKEN"
expect_code "教师读取待处理报告" 200
expect_jq "报告列表包含目标提交" ".data.items | map(.submission_id) | index($SECOND_ID) != null"
expect_jq "待处理计数大于 0" '.data.pending_count >= 1'

api GET "/teacher/cheat-reports/$REPORT_ID" "$TEACHER_TOKEN"
expect_code "教师读取报告详情" 200
expect_jq "详情包含目标代码" '.data.evidence.target_submission.code | length > 0'
expect_jq "详情包含比对提交" '.data.evidence.pairs | length >= 1'
expect_jq "相似度达到报告阈值" '.data.report.score >= 0.8'

api GET "/teacher/cheat-reports/$REPORT_ID" "$TEACHER2_TOKEN"
expect_code "非作业教师看不到报告" 404

say "确认作弊并判零"
api POST "/teacher/cheat-reports/$REPORT_ID/review" "$TEACHER_TOKEN" \
    '{"decision":"confirmed","note":"smoke confirmed","apply_zero":true}'
expect_code "教师确认作弊" 200
expect_jq "返回已判零" '.data.penalty_applied == true'
SCORE_AFTER_ZERO=$(psql "$DATABASE_URL" -Atc "SELECT manual_score FROM assignment_problem_grades
    WHERE assignment_id = $ASSIGNMENT_ID AND user_id = $STUDENT2_ID AND problem_id = $PROBLEM_ID")
[[ "$SCORE_AFTER_ZERO" == "0" ]] && pass "该题人工分已置 0" || fail "判零后人工分为 $SCORE_AFTER_ZERO"

api POST "/teacher/cheat-reports/$REPORT_ID/review" "$TEACHER_TOKEN" '{"decision":"confirmed"}'
expect_code "已处理报告不可重复复核" 409

say "学生查看记录并申诉"
api GET /cheat-reports/mine "$STUDENT2_TOKEN"
expect_code "学生读取我的作弊记录" 200
expect_jq "记录状态为已确认" '.data.items[0].status == "confirmed"'
expect_jq "记录显示已判零" '.data.items[0].penalty_applied == true'

api GET "/cheat-reports/$REPORT_ID" "$STUDENT2_TOKEN"
expect_code "学生读取报告详情" 200
expect_jq "学生只看到自己的提交" ".data.submission.user_id == $STUDENT2_ID"

api POST "/cheat-reports/$REPORT_ID/appeal" "$STUDENT_TOKEN" '{"reason":"not mine"}'
expect_code "非当事人不能申诉" 404

api POST "/cheat-reports/$REPORT_ID/appeal" "$STUDENT2_TOKEN" '{"reason":"smoke appeal"}'
expect_code "当事人提交申诉" 200
expect_jq "申诉进入待处理" '.data.status == "pending"'

api POST "/cheat-reports/$REPORT_ID/appeal" "$STUDENT2_TOKEN" '{"reason":"again"}'
expect_code "同一报告不能重复申诉" 409

say "处理人裁定申诉"
api GET /teacher/appeals "$TEACHER_TOKEN"
expect_code "处理人读取申诉队列" 200
expect_jq "队列包含申诉" '.data.items | length >= 1'
APPEAL_ID=$(jq -r '.data.items[0].appeal_id' <<<"$LAST_BODY")
[[ -n "$APPEAL_ID" && "$APPEAL_ID" != "null" ]] || fatal "未找到申诉编号"

api GET /teacher/appeals "$TEACHER2_TOKEN"
expect_code "非处理人读取申诉队列" 200
expect_jq "非处理人队列为空" '.data.items | length == 0'

api POST "/teacher/appeals/$APPEAL_ID/resolve" "$TEACHER2_TOKEN" '{"decision":"overturned"}'
expect_code "非处理人不能裁定" 403

api POST "/teacher/appeals/$APPEAL_ID/resolve" "$TEACHER_TOKEN" \
    '{"decision":"overturned","note":"smoke overturned"}'
expect_code "处理人撤销作弊结论" 200
expect_jq "申诉状态为通过" '.data.appeal_status == "overturned"'
expect_jq "报告状态为撤销" '.data.report_status == "overturned"'
expect_jq "成绩已恢复" '.data.penalty_restored == true'

RESTORED_SCORE=$(psql "$DATABASE_URL" -Atc "SELECT manual_score FROM assignment_problem_grades
    WHERE assignment_id = $ASSIGNMENT_ID AND user_id = $STUDENT2_ID AND problem_id = $PROBLEM_ID")
[[ "$RESTORED_SCORE" == "80" ]] && pass "申诉翻案后人工分恢复为 80" || fail "恢复后人工分为 $RESTORED_SCORE"

api GET "/cheat-reports/$REPORT_ID" "$STUDENT2_TOKEN"
expect_code "学生读取申诉后的详情" 200
expect_jq "学生看到报告已撤销" '.data.report.status == "overturned"'
expect_jq "学生看到申诉通过" '.data.appeal.status == "overturned"'

api GET /cheat-reports/mine "$STUDENT_TOKEN"
expect_code "未涉事学生读取我的记录" 200
expect_jq "未涉事学生列表为空" '.data.items | length == 0'

cleanup

printf '\n结果：%d 通过，%d 失败\n' "$PASSED" "$FAILED"
((FAILED == 0))
