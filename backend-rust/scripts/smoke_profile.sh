#!/usr/bin/env bash
#
# Theseus 个人中心冒烟测试。
#
# 设计文档：doc/2610272_个人界面的完善.md
#
# 覆盖：登录资料、用户名修改与冲突、邮箱变更验证、密码修改与 token 失效、
#       退出所有设备、头像上传/访问/删除、学习分析、论坛收藏、注销匿名化、
#       教师有未归档组织时注销被拒绝。
#
# 用法：
#   ./backend-rust/scripts/smoke_profile.sh
#   SMOKE_API_BASE=http://127.0.0.1:3001 ./backend-rust/scripts/smoke_profile.sh
#
# 依赖：bash、curl、jq、psql、python3。

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
require_cmd python3

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
STUDENT="profile_s_$SUFFIX"
TEACHER="profile_t_$SUFFIX"
STUDENT_EMAIL="$STUDENT@example.test"
TEACHER_EMAIL="$TEACHER@example.test"
NEW_EMAIL="$STUDENT-new@example.test"
CLASS_NAME="Profile Smoke $SUFFIX"
RAW_TOKEN="raw-profile-token-$SUFFIX"

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
    psql "$DATABASE_URL" -q -c "DELETE FROM classes WHERE name = '$CLASS_NAME';" >/dev/null 2>&1 || true
    psql "$DATABASE_URL" -q -c "DELETE FROM users WHERE username IN ('$STUDENT', '$TEACHER') OR username LIKE 'deleted_%' AND email LIKE 'deleted_%@deleted.local';" >/dev/null 2>&1 || true
}

cleanup
psql "$DATABASE_URL" -q -v ON_ERROR_STOP=1 <<SQL
INSERT INTO users (username, email, password_hash, role, email_verified_at)
VALUES ('$STUDENT', '$STUDENT_EMAIL', '$PASSWORD_HASH', 'student', CURRENT_TIMESTAMP),
       ('$TEACHER', '$TEACHER_EMAIL', '$PASSWORD_HASH', 'teacher', CURRENT_TIMESTAMP);
SQL

TOKEN=$(login "$STUDENT" admin)
[[ -n "$TOKEN" ]] || fatal "学生登录失败"
STUDENT_ID=$(psql "$DATABASE_URL" -Atc "SELECT id FROM users WHERE username = '$STUDENT'")

say "当前资料"
api GET /auth/me "$TOKEN"
expect_code "读取当前用户" 200
expect_jq "返回头像字段" '.data | has("avatar_url")'
expect_jq "返回注册时间" '.data | has("created_at")'

say "修改用户名"
api PUT /profile/username "$TOKEN" "{\"username\":\"${STUDENT}_new\"}"
expect_code "修改用户名" 200
expect_jq "用户名已更新" ".data.username == \"${STUDENT}_new\""
api PUT /profile/username "$TOKEN" '{"username":"admin"}'
expect_code "重复用户名被拒绝" 409

say "邮箱变更"
api POST /profile/email "$TOKEN" "{\"email\":\"$NEW_EMAIL\"}"
expect_code "请求修改邮箱" 200
expect_jq "返回待验证邮箱" ".data.pending_email == \"$NEW_EMAIL\""
TOKEN_HASH=$(printf '%s' "$RAW_TOKEN" | sha256sum | cut -d' ' -f1)
psql "$DATABASE_URL" -q -c "UPDATE auth_tokens SET used_at = CURRENT_TIMESTAMP
    WHERE user_id = $STUDENT_ID AND purpose = 'email_change';
    INSERT INTO auth_tokens (user_id, purpose, token_hash, expires_at)
    VALUES ($STUDENT_ID, 'email_change', '$TOKEN_HASH', CURRENT_TIMESTAMP + INTERVAL '1 hour');"
api POST /auth/verify-email "" "{\"token\":\"$RAW_TOKEN\"}"
expect_code "验证新邮箱" 200
api GET /auth/me "$TOKEN"
expect_jq "邮箱已切换" ".data.email == \"$NEW_EMAIL\""
expect_jq "待验证邮箱已清空" '.data.pending_email == null'

say "修改密码与退出所有设备"
api PUT /profile/password "$TOKEN" '{"current_password":"admin","new_password":"newpass12345"}'
expect_code "修改密码" 200
NEW_TOKEN=$(jq -r '.data.token' <<<"$LAST_BODY")
api GET /auth/me "$TOKEN"
expect_code "旧 token 已失效" 401
api GET /auth/me "$NEW_TOKEN"
expect_code "新 token 可用" 200
api POST /auth/logout-all "$NEW_TOKEN"
expect_code "退出所有设备" 200
api GET /auth/me "$NEW_TOKEN"
expect_code "退出所有设备后 token 失效" 401

say "头像"
TOKEN=$(login "${STUDENT}_new" newpass12345)
python3 - "$TMP_DIR/avatar.png" <<'PY'
import struct, sys, zlib
path = sys.argv[1]
w = h = 120
raw = b''.join(b'\x00' + bytes([30, 120, 200, 255]) * w for _ in range(h))
def chunk(t, d):
    c = t + d
    return struct.pack('>I', len(d)) + c + struct.pack('>I', zlib.crc32(c) & 0xffffffff)
png = b'\x89PNG\r\n\x1a\n' + chunk(b'IHDR', struct.pack('>IIBBBBB', w, h, 8, 6, 0, 0, 0)) + chunk(b'IDAT', zlib.compress(raw)) + chunk(b'IEND', b'')
open(path, 'wb').write(png)
PY
UPLOAD=$(curl -sS -w '\n%{http_code}' -X POST "$API_ROOT/profile/avatar" \
    -H "Authorization: Bearer $TOKEN" -F "file=@$TMP_DIR/avatar.png;type=image/png")
LAST_CODE=$(tail -n 1 <<<"$UPLOAD")
LAST_BODY=$(head -n -1 <<<"$UPLOAD")
expect_code "上传头像" 200
AVATAR_URL=$(jq -r '.data.avatar_url' <<<"$LAST_BODY")
FETCH_CODE=$(curl -sS -o /dev/null -w '%{http_code}' "${API_BASE%/}$AVATAR_URL")
[[ "$FETCH_CODE" == "200" ]] && pass "头像可访问" || fail "头像不可访问：HTTP $FETCH_CODE"
api DELETE /profile/avatar "$TOKEN"
expect_code "删除头像" 200

say "学习分析"
psql "$DATABASE_URL" -q -c "INSERT INTO submissions
    (user_id, problem_id, language, code, status, total_test_cases, submitted_at)
    VALUES ($STUDENT_ID, 1101, 'python', 'x', 'accepted', 5, CURRENT_TIMESTAMP - INTERVAL '1 day'),
           ($STUDENT_ID, 1102, 'python', 'x', 'wrong_answer', 5, CURRENT_TIMESTAMP);"
api GET '/profile/analytics?days=30' "$TOKEN"
expect_code "读取学习分析" 200
expect_jq "汇总包含通过题目" '.data.summary.accepted_problems >= 1'
expect_jq "趋势返回 30 天" '.data.trend | length == 30'
expect_jq "包含难度分布" '.data.difficulty | length >= 1'

say "论坛收藏"
POST_ID=$(psql "$DATABASE_URL" -Atc "SELECT id FROM forum_posts WHERE status = 'published' LIMIT 1")
psql "$DATABASE_URL" -q -c "INSERT INTO forum_post_favorites (post_id, user_id)
    VALUES ($POST_ID, $STUDENT_ID) ON CONFLICT DO NOTHING;"
api GET '/forum/favorites?page=1&size=20' "$TOKEN"
expect_code "读取收藏列表" 200
expect_jq "收藏总数为 1" '.data.total == 1'
api DELETE "/forum/posts/$POST_ID/favorite" "$TOKEN"
expect_code "取消收藏" 200

say "教师注销保护"
TEACHER_TOKEN=$(login "$TEACHER" admin)
api POST /classes "$TEACHER_TOKEN" "{\"name\":\"$CLASS_NAME\"}"
expect_code "教师创建组织" 201
api DELETE /profile "$TEACHER_TOKEN" "{\"password\":\"admin\",\"username\":\"$TEACHER\"}"
expect_code "教师有未归档组织时注销被拒绝" 409

say "注销账号"
api DELETE /profile "$TOKEN" "{\"password\":\"newpass12345\",\"username\":\"${STUDENT}_new\"}"
expect_code "注销账号" 200
AFTER=$(login "${STUDENT}_new" newpass12345)
[[ -z "$AFTER" ]] && pass "注销后不能登录" || fail "注销后仍可登录"
STATUS=$(psql "$DATABASE_URL" -Atc "SELECT status FROM users WHERE id = $STUDENT_ID")
[[ "$STATUS" == "deleted" ]] && pass "账号状态为 deleted" || fail "账号状态为 $STATUS"
ANON=$(psql "$DATABASE_URL" -Atc "SELECT username || '|' || email FROM users WHERE id = $STUDENT_ID")
[[ "$ANON" == deleted_* ]] && pass "用户名和邮箱已匿名化" || fail "匿名化结果异常：$ANON"

cleanup
if ((FAILED > 0)); then
    printf '\n%d passed, %d failed\n' "$PASSED" "$FAILED" >&2
    exit 1
fi
printf '\n%d passed, 0 failed\n' "$PASSED"
