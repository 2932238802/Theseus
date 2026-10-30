#!/usr/bin/env bash
# 从 backup.sh 生成的备份恢复。恢复期间会停止应用服务，避免写入冲突。
# 用法：deploy/scripts/restore.sh <db-YYYYmmdd-HHMMSS.dump> [uploads-YYYYmmdd-HHMMSS.tar.gz]
set -euo pipefail

ROOT=$(cd "$(dirname "$0")/.." && pwd)
cd "$ROOT"

if [[ $# -lt 1 ]]; then
    echo "用法：$0 <db dump> [uploads tar.gz]" >&2
    exit 1
fi

DB_DUMP=$1
UPLOADS_TAR=${2:-}

if [[ ! -f "$DB_DUMP" ]]; then
    echo "找不到数据库备份：$DB_DUMP" >&2
    exit 1
fi
if [[ -n "$UPLOADS_TAR" && ! -f "$UPLOADS_TAR" ]]; then
    echo "找不到 uploads 备份：$UPLOADS_TAR" >&2
    exit 1
fi

set -a
# shellcheck disable=SC1091
source .env
set +a

echo "==> 停止应用服务（保留 postgres / redis）"
docker compose stop backend judge-worker anticheat-worker frontend

echo "==> 恢复数据库"
docker compose exec -T postgres \
    pg_restore -U "${POSTGRES_USER:-theseus}" -d "${POSTGRES_DB:-theseus}" \
    --clean --if-exists --no-owner <"$DB_DUMP"

if [[ -n "$UPLOADS_TAR" ]]; then
    echo "==> 恢复 uploads 卷"
    docker run --rm \
        -v theseus_uploads:/data \
        -v "$(cd "$(dirname "$UPLOADS_TAR")" && pwd)":/backup:ro \
        alpine:3.20 \
        sh -c "rm -rf /data/* && tar xzf /backup/$(basename "$UPLOADS_TAR") -C /data"
fi

echo "==> 启动应用服务"
docker compose up -d backend judge-worker anticheat-worker frontend
echo "完成；请检查：docker compose exec -T backend curl -fsS http://127.0.0.1:3000/readyz"
