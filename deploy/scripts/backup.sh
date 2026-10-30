#!/usr/bin/env bash
# 备份 PostgreSQL 与 uploads 卷。建议每天由 cron 执行一次。
# 用法：deploy/scripts/backup.sh
# 环境变量：BACKUP_DIR（默认 deploy/backups）、KEEP_DAYS（默认 14）
set -euo pipefail

ROOT=$(cd "$(dirname "$0")/.." && pwd)
cd "$ROOT"

if [[ ! -f .env ]]; then
    echo "缺少 deploy/.env，请先 cp .env.example .env 并填写" >&2
    exit 1
fi

set -a
# shellcheck disable=SC1091
source .env
set +a

BACKUP_DIR=${BACKUP_DIR:-$ROOT/backups}
KEEP_DAYS=${KEEP_DAYS:-14}
STAMP=$(date +%Y%m%d-%H%M%S)
mkdir -p "$BACKUP_DIR"

echo "==> 备份数据库"
docker compose exec -T postgres \
    pg_dump -U "${POSTGRES_USER:-theseus}" -d "${POSTGRES_DB:-theseus}" \
    --format=custom --no-owner >"$BACKUP_DIR/db-$STAMP.dump"

echo "==> 备份 uploads 卷"
docker run --rm \
    -v theseus_uploads:/data:ro \
    -v "$BACKUP_DIR":/backup \
    alpine:3.20 \
    tar czf "/backup/uploads-$STAMP.tar.gz" -C /data .

echo "==> 清理 ${KEEP_DAYS} 天前的备份"
find "$BACKUP_DIR" -type f \( -name 'db-*.dump' -o -name 'uploads-*.tar.gz' \) \
    -mtime +"$KEEP_DAYS" -delete

echo "完成：$BACKUP_DIR/db-$STAMP.dump, $BACKUP_DIR/uploads-$STAMP.tar.gz"
