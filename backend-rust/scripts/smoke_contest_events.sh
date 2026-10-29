#!/usr/bin/env bash
#
# Theseus 限时赛事冒烟测试。
#
# 设计文档：doc/2610291_竞赛ui的完善.md
#
# 覆盖：首页 featured 返回排位赛配置与规则、赛事三种状态（报名中/即将开始/进行中）、
#       公开报名与重复报名幂等、名额已满、邀请赛事直接加入、外部链接赛事、班级范围限制、
#       报名截止、已结束/草稿赛事不进入首页、赛事详情。
#
# 用法：
#   ./backend-rust/scripts/smoke_contest_events.sh
#   SMOKE_API_BASE=http://127.0.0.1:3001 ./backend-rust/scripts/smoke_contest_events.sh
#
# 依赖：bash、curl、jq、psql。后端需已完成迁移并运行。

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
TEACHER="events_t_$SUFFIX"
STUDENT="events_s_$SUFFIX"
OUTSIDER="events_o_$SUFFIX"
CLASS_NAME="Events Smoke $SUFFIX"
TITLE_PREFIX="Smoke Event $SUFFIX"

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
        -d "{\"username\":\"$1\",\"password\":\"$2\"}")
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
    psql "$DATABASE_URL" -q -c "DELETE FROM official_events WHERE title LIKE '$TITLE_PREFIX%';" >/dev/null 2>&1 || true
    psql "$DATABASE_URL" -q -c "DELETE FROM classes WHERE name = '$CLASS_NAME';" >/dev/null 2>&1 || true
    psql "$DATABASE_URL" -q -c "DELETE FROM users WHERE username IN ('$TEACHER', '$STUDENT', '$OUTSIDER');" >/dev/null 2>&1 || true
}

cleanup
psql "$DATABASE_URL" -q -v ON_ERROR_STOP=1 <<SQL
INSERT INTO users (username, email, password_hash, role, email_verified_at)
VALUES ('$TEACHER', '$TEACHER@example.test', '$PASSWORD_HASH', 'teacher', CURRENT_TIMESTAMP),
       ('$STUDENT', '$STUDENT@example.test', '$PASSWORD_HASH', 'student', CURRENT_TIMESTAMP),
       ('$OUTSIDER', '$OUTSIDER@example.test', '$PASSWORD_HASH', 'student', CURRENT_TIMESTAMP);
SQL

TEACHER_ID=$(psql "$DATABASE_URL" -Atc "SELECT id FROM users WHERE username = '$TEACHER'")
STUDENT_ID=$(psql "$DATABASE_URL" -Atc "SELECT id FROM users WHERE username = '$STUDENT'")
OUTSIDER_ID=$(psql "$DATABASE_URL" -Atc "SELECT id FROM users WHERE username = '$OUTSIDER'")

TOKEN=$(login "$STUDENT" admin)
[[ -n "$TOKEN" ]] || fatal "学生登录失败"
OUTSIDER_TOKEN=$(login "$OUTSIDER" admin)
[[ -n "$OUTSIDER_TOKEN" ]] || fatal "旁听学生登录失败"

CLASS_ID=$(psql "$DATABASE_URL" -Atc "SELECT id FROM classes WHERE name = '$CLASS_NAME'")
if [[ -z "$CLASS_ID" ]]; then
    CLASS_ID=$(psql "$DATABASE_URL" -Atc "INSERT INTO classes (name, owner_id, invite_code)
        VALUES ('$CLASS_NAME', $TEACHER_ID, 'SMK$SUFFIX') RETURNING id")
fi

insert_event() {
    local title=$1 type=$2 mode=$3 starts=$4 ends=$5 capacity=${6:-NULL} closes=${7:-NULL} class_id=${8:-NULL}
    psql "$DATABASE_URL" -Atc "INSERT INTO official_events
        (title, organizer, description, registration_closes_at, starts_at, ends_at,
         status, event_type, scope, capacity, registration_mode, class_id, rules, created_by)
        VALUES ('$TITLE_PREFIX $title', '课程组', '冒烟测试赛事', $closes,
                CURRENT_TIMESTAMP + INTERVAL '$starts', CURRENT_TIMESTAMP + INTERVAL '$ends',
                'published', '$type', '面向全体学生', $capacity, '$mode', $class_id,
                '[{\"title\":\"参赛说明\",\"items\":[\"按时提交，独立完成\"]}]'::jsonb, $TEACHER_ID)
        RETURNING id"
}

OPEN_ID=$(insert_event "公开报名" official open "1 hour" "3 hours" "1")
INVITE_ID=$(insert_event "邀请加入" teacher invite "2 hours" "4 hours" "NULL")
EXTERNAL_ID=$(insert_event "外部报名" school external "3 hours" "5 hours" "NULL")
CLASS_ID_EVENT=$(insert_event "班级限定" school open "4 hours" "6 hours" "NULL" "NULL" "$CLASS_ID")
CLOSED_ID=$(insert_event "报名截止" official open "5 hours" "7 hours" "NULL" "CURRENT_TIMESTAMP - INTERVAL '1 minute'")
RUNNING_ID=$(insert_event "进行中" official open "-10 minutes" "50 minutes" "NULL")
ENDED_ID=$(insert_event "已结束" official open "-3 hours" "-1 hour" "NULL")
DRAFT_TITLE="$TITLE_PREFIX 草稿"
DRAFT_ID=$(psql "$DATABASE_URL" -Atc "INSERT INTO official_events
    (title, organizer, starts_at, ends_at, status, event_type)
    VALUES ('$DRAFT_TITLE', '课程组', CURRENT_TIMESTAMP + INTERVAL '1 day',
            CURRENT_TIMESTAMP + INTERVAL '2 day', 'draft', 'official')
    RETURNING id")

say "竞赛首页"
api GET /contests/featured "$TOKEN"
expect_code "读取竞赛首页" 200
expect_jq "返回排位赛配置" '.data.ranked.mode == "ranked"'
expect_jq "排位规则由后端返回" '.data.ranked.rules | length >= 1'
expect_jq "返回服务器时间" '.data.server_time != null'
expect_jq "报名中赛事可见" ".data.events | any(.id == $OPEN_ID)"
expect_jq "进行中赛事可见" ".data.events | any(.id == $RUNNING_ID and .status == \"running\")"
expect_jq "已结束赛事不进入首页" ".data.events | any(.id == $ENDED_ID) | not"
expect_jq "草稿赛事不进入首页" ".data.events | any(.id == $DRAFT_ID) | not"
expect_jq "进行中赛事排在前面" "([.data.events[].id] | index($RUNNING_ID)) < ([.data.events[].id] | index($OPEN_ID))"

say "公开报名"
api POST "/contests/events/$OPEN_ID/register" "$TOKEN"
expect_code "报名公开赛事" 200
expect_jq "返回已报名" '.data.is_registered == true'
api POST "/contests/events/$OPEN_ID/register" "$TOKEN"
expect_code "重复报名幂等" 200
api POST "/contests/events/$OPEN_ID/register" "$OUTSIDER_TOKEN"
expect_code "名额已满时拒绝" 409
api GET "/contests/events/$OPEN_ID" "$TOKEN"
expect_code "读取赛事详情" 200
expect_jq "详情包含规则分组" '.data.rules | length >= 1'
expect_jq "详情包含主办方" '.data.organizer != null'

say "邀请赛事"
api POST "/contests/events/$INVITE_ID/join" "$TOKEN"
expect_code "邀请赛事直接加入" 200
expect_jq "加入后标记已报名" '.data.is_registered == true'
api POST "/contests/events/$INVITE_ID/register" "$TOKEN"
expect_code "邀请赛事不能走报名接口" 400

say "外部链接赛事"
api GET /contests/featured "$TOKEN"
expect_jq "外部赛事操作为查看详情" ".data.events | map(select(.id == $EXTERNAL_ID))[0].action == \"details\""
api POST "/contests/events/$EXTERNAL_ID/register" "$TOKEN"
expect_code "外部赛事不能站内报名" 400

say "报名截止"
api GET /contests/featured "$TOKEN"
expect_jq "截止赛事操作为已截止" ".data.events | map(select(.id == $CLOSED_ID))[0].action == \"closed\""
expect_jq "截止赛事显示原因" ".data.events | map(select(.id == $CLOSED_ID))[0].ineligible_reason != null"
api POST "/contests/events/$CLOSED_ID/register" "$TOKEN"
expect_code "截止赛事报名被拒绝" 409

say "班级范围"
api GET /contests/featured "$TOKEN"
expect_jq "非班级成员不可参加" ".data.events | map(select(.id == $CLASS_ID_EVENT))[0].eligible == false"
expect_jq "不可参加原因可见" ".data.events | map(select(.id == $CLASS_ID_EVENT))[0].ineligible_reason == \"仅限指定班级的学生参加\""
api POST "/contests/events/$CLASS_ID_EVENT/register" "$TOKEN"
expect_code "非班级成员报名被拒绝" 403
psql "$DATABASE_URL" -q -c "INSERT INTO class_members (class_id, user_id, status)
    VALUES ($CLASS_ID, $STUDENT_ID, 'active') ON CONFLICT (class_id, user_id)
    DO UPDATE SET status = 'active';"
api GET /contests/featured "$TOKEN"
expect_jq "班级成员可参加" ".data.events | map(select(.id == $CLASS_ID_EVENT))[0].eligible == true"
api POST "/contests/events/$CLASS_ID_EVENT/register" "$TOKEN"
expect_code "班级成员报名成功" 200

say "进行中赛事"
psql "$DATABASE_URL" -q -c "INSERT INTO official_event_registrations (event_id, user_id, status)
    VALUES ($RUNNING_ID, $STUDENT_ID, 'registered') ON CONFLICT DO NOTHING;"
api GET /contests/featured "$TOKEN"
expect_jq "已报名进行中赛事可进入" ".data.events | map(select(.id == $RUNNING_ID))[0].action == \"enter\""
api POST "/contests/events/$RUNNING_ID/register" "$TOKEN"
expect_code "已开始赛事不能报名" 409

cleanup
if ((FAILED > 0)); then
    printf '\n%d passed, %d failed\n' "$PASSED" "$FAILED" >&2
    exit 1
fi
printf '\n%d passed, 0 failed\n' "$PASSED"
