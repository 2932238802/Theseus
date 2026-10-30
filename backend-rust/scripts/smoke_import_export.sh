#!/usr/bin/env bash
#
# Theseus 教学数据导入导出冒烟测试。
#
# 覆盖：
#   CSV 批量导入学生（新增/已存在/重复/非学生/不存在）、导入权限、
#   作业成绩 CSV 导出（BOM、表头、分数、权限）。
#
# 用法：
#   ./backend-rust/scripts/smoke_import_export.sh
#   SMOKE_API_BASE=http://127.0.0.1:3001 ./backend-rust/scripts/smoke_import_export.sh
#
# 依赖：bash、curl、jq、psql。
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
TEACHER="import_t_$SUFFIX"
TEACHER2="import_t2_$SUFFIX"
STUDENT1="import_s1_$SUFFIX"
STUDENT2="import_s2_$SUFFIX"
STUDENT3="import_s3_$SUFFIX"
GHOST="import_ghost_$SUFFIX"
TEACHER_EMAIL="$TEACHER@example.test"
TEACHER2_EMAIL="$TEACHER2@example.test"
STUDENT1_EMAIL="$STUDENT1@example.test"
STUDENT2_EMAIL="$STUDENT2@example.test"
STUDENT3_EMAIL="$STUDENT3@example.test"
CLASS_NAME="Import Smoke $SUFFIX"

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
    psql "$DATABASE_URL" -q -c "DELETE FROM users WHERE username IN ('$TEACHER', '$TEACHER2', '$STUDENT1', '$STUDENT2', '$STUDENT3');" >/dev/null 2>&1 || true
}

cleanup
psql "$DATABASE_URL" -q -v ON_ERROR_STOP=1 <<SQL
INSERT INTO users (username, email, password_hash, role, email_verified_at)
VALUES ('$TEACHER', '$TEACHER_EMAIL', '$PASSWORD_HASH', 'teacher', CURRENT_TIMESTAMP),
       ('$TEACHER2', '$TEACHER2_EMAIL', '$PASSWORD_HASH', 'teacher', CURRENT_TIMESTAMP),
       ('$STUDENT1', '$STUDENT1_EMAIL', '$PASSWORD_HASH', 'student', CURRENT_TIMESTAMP),
       ('$STUDENT2', '$STUDENT2_EMAIL', '$PASSWORD_HASH', 'student', CURRENT_TIMESTAMP),
       ('$STUDENT3', '$STUDENT3_EMAIL', '$PASSWORD_HASH', 'student', CURRENT_TIMESTAMP);
SQL

TEACHER_TOKEN=$(login "$TEACHER")
TEACHER2_TOKEN=$(login "$TEACHER2")
STUDENT1_TOKEN=$(login "$STUDENT1")
[[ -n "$TEACHER_TOKEN" && -n "$TEACHER2_TOKEN" && -n "$STUDENT1_TOKEN" ]] || fatal "测试账号登录失败"

PROBLEM_ID=$(psql "$DATABASE_URL" -Atc "SELECT id FROM problems ORDER BY id LIMIT 1")
[[ -n "$PROBLEM_ID" ]] || fatal "数据库中没有题目，无法创建作业"

say "创建组织并预置一名成员"
api POST /classes "$TEACHER_TOKEN" "{\"name\":\"$CLASS_NAME\",\"course_name\":\"Algo\"}"
expect_code "教师创建组织" 201
CLASS_ID=$(jq -r '.data.id' <<<"$LAST_BODY")
api POST "/classes/$CLASS_ID/members" "$TEACHER_TOKEN" "{\"identifier\":\"$STUDENT1\"}"
expect_code "添加第一名学生" 201

say "CSV 批量导入"
CSV=$(printf 'username,email\n%s,%s\n%s,%s\n%s,%s\n%s,%s\n%s\n%s,%s\n' \
    "$STUDENT1" "$STUDENT1_EMAIL" \
    "$STUDENT2" "$STUDENT2_EMAIL" \
    "$STUDENT3" "$STUDENT3_EMAIL" \
    "$STUDENT2" "$STUDENT2_EMAIL" \
    "$GHOST" \
    "$TEACHER" "$TEACHER_EMAIL")
api POST "/classes/$CLASS_ID/import" "$TEACHER_TOKEN" "$(jq -nc --arg csv "$CSV" '{csv:$csv}')"
expect_code "教师导入 CSV" 200
expect_jq "新增 2 名学生" '.data.added_count == 2'
expect_jq "跳过 4 行" '.data.skipped_count == 4'
expect_jq "识别已存在的成员" '.data.rows | map(select(.status == "already_member")) | length == 1'
expect_jq "识别 CSV 内重复" '.data.rows | map(select(.status == "duplicate")) | length == 1'
expect_jq "识别教师账号" '.data.rows | map(select(.status == "not_student")) | length == 1'
expect_jq "识别不存在的账号" '.data.rows | map(select(.status == "not_found")) | length == 1'

ACTIVE_MEMBERS=$(psql "$DATABASE_URL" -Atc "SELECT COUNT(*) FROM class_members cm
    JOIN classes c ON c.id = cm.class_id
    WHERE c.name = '$CLASS_NAME' AND cm.status = 'active'")
[[ "$ACTIVE_MEMBERS" == "3" ]] && pass "组织内共有 3 名有效成员" || fail "组织内有效成员为 $ACTIVE_MEMBERS"

api POST "/classes/$CLASS_ID/import" "$STUDENT1_TOKEN" "$(jq -nc --arg csv 'alice' '{csv:$csv}')"
expect_code "学生不能导入成员" 403
api POST "/classes/$CLASS_ID/import" "$TEACHER2_TOKEN" "$(jq -nc --arg csv 'alice' '{csv:$csv}')"
expect_code "非组织教师不能导入" 404
api POST "/classes/$CLASS_ID/import" "$TEACHER_TOKEN" '{"csv":"\"unclosed\n"}'
expect_code "引号未闭合的 CSV 被拒绝" 400

say "导出作业成绩"
DUE=$(date -u -d '+1 day' +%Y-%m-%dT%H:%M:%SZ)
api POST "/classes/$CLASS_ID/assignments" "$TEACHER_TOKEN" "$(jq -nc \
    --arg title "Import Export $SUFFIX" \
    --arg due "$DUE" \
    --argjson problem "$PROBLEM_ID" \
    '{title:$title, due_at:$due, problems:[{problem_id:$problem, points:100}]}')"
expect_code "教师创建作业" 201
ASSIGNMENT_ID=$(jq -r '.data.id' <<<"$LAST_BODY")
api POST "/assignments/$ASSIGNMENT_ID/publish" "$TEACHER_TOKEN"
expect_code "发布作业" 200
STUDENT1_ID=$(psql "$DATABASE_URL" -Atc "SELECT id FROM users WHERE username = '$STUDENT1'")
api PUT "/assignments/$ASSIGNMENT_ID/grades/$STUDENT1_ID/problems/$PROBLEM_ID" "$TEACHER_TOKEN" \
    '{"manual_score":88,"feedback":"导出测试"}'
expect_code "保存人工分" 200

EXPORT_CODE=$(curl -sS -D "$TMP_DIR/headers" -o "$TMP_DIR/grades.csv" -w '%{http_code}' \
    "$API_ROOT/assignments/$ASSIGNMENT_ID/gradebook/export?include_removed=1" \
    -H "Authorization: Bearer $TEACHER_TOKEN")
[[ "$EXPORT_CODE" == "200" ]] && pass "教师导出成绩" || fail "导出成绩返回 HTTP $EXPORT_CODE"
grep -qi 'content-type: text/csv' "$TMP_DIR/headers" && pass "导出类型为 CSV" || fail "Content-Type 不是 CSV"
BOM=$(od -An -tx1 -N3 "$TMP_DIR/grades.csv" | tr -d ' \n')
[[ "$BOM" == "efbbbf" ]] && pass "CSV 带 UTF-8 BOM" || fail "CSV 缺少 UTF-8 BOM（$BOM）"
head -n 1 "$TMP_DIR/grades.csv" | grep -q '用户名,邮箱,成员状态' && pass "CSV 表头正确" || fail "CSV 表头不正确"
grep -q "$STUDENT1,$STUDENT1_EMAIL" "$TMP_DIR/grades.csv" && pass "导出包含学生" || fail "导出缺少学生行"
grep -q ',88,88,' "$TMP_DIR/grades.csv" && pass "导出包含人工分" || fail "导出缺少人工分"
[[ "$(grep -c '@example.test' "$TMP_DIR/grades.csv")" -ge 3 ]] && pass "导出包含全部成员" || fail "导出成员不全"

STUDENT_EXPORT=$(curl -sS -o /dev/null -w '%{http_code}' \
    "$API_ROOT/assignments/$ASSIGNMENT_ID/gradebook/export" -H "Authorization: Bearer $STUDENT1_TOKEN")
[[ "$STUDENT_EXPORT" == "403" ]] && pass "学生不能导出成绩" || fail "学生导出返回 $STUDENT_EXPORT"
OTHER_EXPORT=$(curl -sS -o /dev/null -w '%{http_code}' \
    "$API_ROOT/assignments/$ASSIGNMENT_ID/gradebook/export" -H "Authorization: Bearer $TEACHER2_TOKEN")
[[ "$OTHER_EXPORT" == "404" ]] && pass "非组织教师不能导出成绩" || fail "非组织教师导出返回 $OTHER_EXPORT"

cleanup

printf '\n结果：%d 通过，%d 失败\n' "$PASSED" "$FAILED"
((FAILED == 0))
