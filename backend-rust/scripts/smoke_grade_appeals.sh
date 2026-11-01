#!/usr/bin/env bash
#
# Theseus 成绩申诉与统计报表冒烟测试。
#
# 覆盖：
#   学生提交申诉与重复提交、教师按状态列表、受理/驳回与重复处理、
#   学生查询本人申诉、越权访问、统计 CSV 导出（BOM、逐题与未提交名单）。
#
# 用法：
#   ./backend-rust/scripts/smoke_grade_appeals.sh
#   SMOKE_API_BASE=http://127.0.0.1:3001 ./backend-rust/scripts/smoke_grade_appeals.sh
#
# 依赖：bash、curl、jq、psql、od。
# 只使用随机哑账号和临时组织，结束后清理。脚本不会打印令牌或连接串。

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
require_cmd od

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
TEACHER="appeal_t_$SUFFIX"
TEACHER2="appeal_t2_$SUFFIX"
STUDENT1="appeal_s1_$SUFFIX"
STUDENT2="appeal_s2_$SUFFIX"
TEACHER_EMAIL="$TEACHER@example.test"
TEACHER2_EMAIL="$TEACHER2@example.test"
STUDENT1_EMAIL="$STUDENT1@example.test"
STUDENT2_EMAIL="$STUDENT2@example.test"
CLASS_NAME="Appeal Smoke $SUFFIX"

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
    psql "$DATABASE_URL" -q -c "DELETE FROM users WHERE username IN ('$TEACHER', '$TEACHER2', '$STUDENT1', '$STUDENT2');" >/dev/null 2>&1 || true
}

cleanup
psql "$DATABASE_URL" -q -v ON_ERROR_STOP=1 <<SQL
INSERT INTO users (username, email, password_hash, role, email_verified_at)
VALUES ('$TEACHER', '$TEACHER_EMAIL', '$PASSWORD_HASH', 'teacher', CURRENT_TIMESTAMP),
       ('$TEACHER2', '$TEACHER2_EMAIL', '$PASSWORD_HASH', 'teacher', CURRENT_TIMESTAMP),
       ('$STUDENT1', '$STUDENT1_EMAIL', '$PASSWORD_HASH', 'student', CURRENT_TIMESTAMP),
       ('$STUDENT2', '$STUDENT2_EMAIL', '$PASSWORD_HASH', 'student', CURRENT_TIMESTAMP);
SQL

TEACHER_TOKEN=$(login "$TEACHER")
TEACHER2_TOKEN=$(login "$TEACHER2")
STUDENT1_TOKEN=$(login "$STUDENT1")
STUDENT2_TOKEN=$(login "$STUDENT2")
[[ -n "$TEACHER_TOKEN" && -n "$TEACHER2_TOKEN" && -n "$STUDENT1_TOKEN" && -n "$STUDENT2_TOKEN" ]] ||
    fatal "测试账号登录失败"

PROBLEM_ID=$(psql "$DATABASE_URL" -Atc "SELECT id FROM problems ORDER BY id LIMIT 1")
[[ -n "$PROBLEM_ID" ]] || fatal "数据库中没有题目，无法创建作业"

say "准备组织与已发布成绩的作业"
api POST /classes "$TEACHER_TOKEN" "{\"name\":\"$CLASS_NAME\",\"course_name\":\"Algo\"}"
expect_code "教师创建组织" 201
CLASS_ID=$(jq -r '.data.id' <<<"$LAST_BODY")
api POST "/classes/$CLASS_ID/members" "$TEACHER_TOKEN" "{\"identifier\":\"$STUDENT1\"}"
expect_code "添加第一名学生" 201
api POST "/classes/$CLASS_ID/members" "$TEACHER_TOKEN" "{\"identifier\":\"$STUDENT2\"}"
expect_code "添加第二名学生" 201

DUE=$(date -u -d '+1 day' +%Y-%m-%dT%H:%M:%SZ)
api POST "/classes/$CLASS_ID/assignments" "$TEACHER_TOKEN" "$(jq -nc \
    --arg title "Appeal $SUFFIX" \
    --arg due "$DUE" \
    --argjson problem "$PROBLEM_ID" \
    '{title:$title, due_at:$due, show_class_stats:true, problems:[{problem_id:$problem, points:100}]}')"
expect_code "教师创建作业" 201
ASSIGNMENT_ID=$(jq -r '.data.id' <<<"$LAST_BODY")
api POST "/assignments/$ASSIGNMENT_ID/publish" "$TEACHER_TOKEN"
expect_code "发布作业" 200

STUDENT1_ID=$(psql "$DATABASE_URL" -Atc "SELECT id FROM users WHERE username = '$STUDENT1'")
api PUT "/assignments/$ASSIGNMENT_ID/grades/$STUDENT1_ID/problems/$PROBLEM_ID" "$TEACHER_TOKEN" \
    '{"manual_score":88,"feedback":"申诉测试"}'
expect_code "保存人工分" 200

psql "$DATABASE_URL" -q -c \
    "UPDATE assignments SET due_at = CURRENT_TIMESTAMP - INTERVAL '1 minute' WHERE id = $ASSIGNMENT_ID;" >/dev/null ||
    fatal "无法把作业截止时间移到过去"
api POST "/assignments/$ASSIGNMENT_ID/grades/publish" "$TEACHER_TOKEN"
expect_code "发布成绩" 200
expect_jq "返回成绩发布时间" '.data.grades_published_at != null'

say "学生提交申诉"
api POST "/assignments/$ASSIGNMENT_ID/grade-appeals" "$STUDENT1_TOKEN" \
    '{"reason":"第二题判题结果疑似有误 请复核"}'
expect_code "学生提交申诉" 201
APPEAL1_ID=$(jq -r '.data.id' <<<"$LAST_BODY")
expect_jq "新申诉为待处理" '.data.status == "pending"'

api POST "/assignments/$ASSIGNMENT_ID/grade-appeals" "$STUDENT1_TOKEN" '{"reason":"再次提交"}'
expect_code "重复提交被拒绝" 409

api POST "/assignments/$ASSIGNMENT_ID/grade-appeals" "$STUDENT1_TOKEN" '{"reason":"   "}'
expect_code "空理由被拒绝" 400

api POST "/assignments/$ASSIGNMENT_ID/grade-appeals" "$STUDENT2_TOKEN" \
    '{"reason":"总分与预期不符"}'
expect_code "第二名学生提交申诉" 201
APPEAL2_ID=$(jq -r '.data.id' <<<"$LAST_BODY")

api GET "/assignments/$ASSIGNMENT_ID/grade-appeals/mine" "$STUDENT1_TOKEN"
expect_code "学生查询本人申诉" 200
expect_jq "本人申诉为待处理" '.data.appeal.status == "pending"'

say "教师查看与处理申诉"
api GET "/assignments/$ASSIGNMENT_ID/grade-appeals" "$STUDENT1_TOKEN"
expect_code "学生不能查看申诉列表" 403
api GET "/assignments/$ASSIGNMENT_ID/grade-appeals" "$TEACHER2_TOKEN"
expect_code "非组织教师不能查看申诉列表" 404
api GET "/assignments/$ASSIGNMENT_ID/grade-appeals" "$TEACHER_TOKEN"
expect_code "组织教师查看申诉列表" 200
expect_jq "列表包含两条待处理申诉" '.data.appeals | map(select(.status == "pending")) | length == 2'

api GET "/assignments/$ASSIGNMENT_ID/grade-appeals?status=bogus" "$TEACHER_TOKEN"
expect_code "非法状态筛选被拒绝" 400
api GET "/assignments/$ASSIGNMENT_ID/grade-appeals?status=accepted" "$TEACHER_TOKEN"
expect_code "按状态筛选" 200
expect_jq "筛选结果为空" '.data.appeals | length == 0'

api POST "/assignments/$ASSIGNMENT_ID/grade-appeals/$APPEAL1_ID/resolve" "$TEACHER_TOKEN" \
    '{"decision":"maybe"}'
expect_code "非法处理结论被拒绝" 400
api POST "/assignments/$ASSIGNMENT_ID/grade-appeals/$APPEAL1_ID/resolve" "$TEACHER2_TOKEN" \
    '{"decision":"accepted"}'
expect_code "非组织教师不能处理申诉" 404

api POST "/assignments/$ASSIGNMENT_ID/grade-appeals/$APPEAL1_ID/resolve" "$TEACHER_TOKEN" \
    '{"decision":"accepted","note":"已复核 分数将按批改台调整"}'
expect_code "教师受理申诉" 200
expect_jq "申诉状态为已受理" '.data.status == "accepted"'

api POST "/assignments/$ASSIGNMENT_ID/grade-appeals/$APPEAL1_ID/resolve" "$TEACHER_TOKEN" \
    '{"decision":"rejected"}'
expect_code "重复处理被拒绝" 409

api GET "/assignments/$ASSIGNMENT_ID/grade-appeals/mine" "$STUDENT1_TOKEN"
expect_code "学生看到处理结果" 200
expect_jq "结果与说明已返回" '.data.appeal.status == "accepted" and (.data.appeal.handle_note | length > 0)'

api GET "/assignments/$ASSIGNMENT_ID/grade-appeals/mine" "$STUDENT2_TOKEN"
expect_jq "另一名学生的申诉仍待处理" '.data.appeal.status == "pending"'

say "统计与导出"
api GET "/assignments/$ASSIGNMENT_ID/statistics" "$TEACHER_TOKEN"
expect_code "教师查看统计" 200
expect_jq "逐题返回未提交人数" '.data.problems[0].not_submitted_count == 2'

api GET "/assignments/$ASSIGNMENT_ID/statistics" "$STUDENT1_TOKEN"
expect_code "学生查看匿名统计" 200
expect_jq "学生同样只能拿到计数" '.data.problems[0].not_submitted_count == 2'

EXPORT_CODE=$(curl -sS -D "$TMP_DIR/headers" -o "$TMP_DIR/stats.csv" -w '%{http_code}' \
    "$API_ROOT/assignments/$ASSIGNMENT_ID/statistics/export" \
    -H "Authorization: Bearer $TEACHER_TOKEN")
[[ "$EXPORT_CODE" == "200" ]] && pass "教师导出统计" || fail "导出统计返回 HTTP $EXPORT_CODE"
grep -qi 'content-type: text/csv' "$TMP_DIR/headers" && pass "导出类型为 CSV" || fail "Content-Type 不是 CSV"
BOM=$(od -An -tx1 -N3 "$TMP_DIR/stats.csv" | tr -d ' \n')
[[ "$BOM" == "efbbbf" ]] && pass "CSV 带 UTF-8 BOM" || fail "CSV 缺少 UTF-8 BOM（$BOM）"
grep -q '未提交学生数,2' "$TMP_DIR/stats.csv" && pass "CSV 统计未提交人数" || fail "CSV 未提交人数不正确"
grep -q '未提交名单' "$TMP_DIR/stats.csv" && pass "CSV 包含未提交名单" || fail "CSV 缺少未提交名单"
grep -q "$STUDENT2,$STUDENT2_EMAIL" "$TMP_DIR/stats.csv" && pass "名单包含未提交学生" || fail "名单缺少学生行"

STUDENT_EXPORT=$(curl -sS -o /dev/null -w '%{http_code}' \
    "$API_ROOT/assignments/$ASSIGNMENT_ID/statistics/export" -H "Authorization: Bearer $STUDENT1_TOKEN")
[[ "$STUDENT_EXPORT" == "403" ]] && pass "学生不能导出统计" || fail "学生导出返回 $STUDENT_EXPORT"
OTHER_EXPORT=$(curl -sS -o /dev/null -w '%{http_code}' \
    "$API_ROOT/assignments/$ASSIGNMENT_ID/statistics/export" -H "Authorization: Bearer $TEACHER2_TOKEN")
[[ "$OTHER_EXPORT" == "404" ]] && pass "非组织教师不能导出统计" || fail "非组织教师导出返回 $OTHER_EXPORT"

STUDENT2_ID=$(psql "$DATABASE_URL" -Atc "SELECT id FROM users WHERE username = '$STUDENT2'")
RESOLVED=$(psql "$DATABASE_URL" -Atc \
    "SELECT status FROM assignment_grade_appeals WHERE assignment_id = $ASSIGNMENT_ID AND user_id = $STUDENT1_ID")
[[ "$RESOLVED" == "accepted" ]] && pass "数据库记录申诉结论" || fail "数据库申诉状态为 $RESOLVED"
SUBMITTED2=$(psql "$DATABASE_URL" -Atc \
    "SELECT handle_note IS NULL FROM assignment_grade_appeals WHERE assignment_id = $ASSIGNMENT_ID AND user_id = $STUDENT2_ID")
[[ "$SUBMITTED2" == "t" ]] && pass "未处理申诉没有处理说明" || fail "未处理申诉出现处理说明"

cleanup

printf '\n结果：%d 通过，%d 失败\n' "$PASSED" "$FAILED"
((FAILED == 0))
