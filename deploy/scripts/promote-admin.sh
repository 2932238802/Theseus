#!/usr/bin/env bash
# 把已注册用户提升为管理员（生产环境没有默认管理员账号）。
# 用法：deploy/scripts/promote-admin.sh <username>
set -euo pipefail

ROOT=$(cd "$(dirname "$0")/.." && pwd)
cd "$ROOT"

if [[ $# -ne 1 ]]; then
    echo "用法：$0 <username>" >&2
    exit 1
fi

set -a
# shellcheck disable=SC1091
source .env
set +a

docker compose exec -T postgres \
    psql -U "${POSTGRES_USER:-theseus}" -d "${POSTGRES_DB:-theseus}" \
    -v ON_ERROR_STOP=1 -v username="$1" <<'SQL'
UPDATE users
   SET role = 'admin',
       email_verified_at = COALESCE(email_verified_at, CURRENT_TIMESTAMP),
       updated_at = CURRENT_TIMESTAMP
 WHERE username = :'username' AND status = 'active';
SQL

echo "若上面的 UPDATE 影响 0 行，请先在页面注册该用户并完成邮箱验证。"
