#!/usr/bin/env bash
# 查看 PostgreSQL 慢查询（pg_stat_statements）。
#
# 用法：
#   deploy/scripts/pg_stats.sh                  # 按累计耗时列出前 15 条
#   deploy/scripts/pg_stats.sh --limit 30       # 列出前 30 条
#   deploy/scripts/pg_stats.sh enable           # 一次性启用扩展
#   deploy/scripts/pg_stats.sh reset --yes      # 清空统计，重新开始采样
#
# 依赖：deploy/.env、运行中的 postgres 容器。
# 说明：compose.yaml 已为 postgres 预加载 pg_stat_statements；
#       旧部署需要先重新创建 postgres 容器，再执行 enable。
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

PGUSER=${POSTGRES_USER:-theseus}
PGDB=${POSTGRES_DB:-theseus}

if docker compose version >/dev/null 2>&1; then
    COMPOSE=(docker compose)
elif command -v docker-compose >/dev/null 2>&1; then
    COMPOSE=(docker-compose)
else
    echo "未找到 Docker Compose（docker compose / docker-compose）" >&2
    exit 1
fi

say() { printf '\033[1;34m==>\033[0m %s\n' "$*"; }
die() { printf '\033[1;31m[错误]\033[0m %s\n' "$*" >&2; exit 1; }

db_psql() {
    "${COMPOSE[@]}" exec -T postgres \
        psql -U "$PGUSER" -d "$PGDB" -v ON_ERROR_STOP=1 "$@"
}

usage() {
    cat <<'EOF'
查看 PostgreSQL 慢查询（pg_stat_statements）。

用法：
  deploy/scripts/pg_stats.sh                  # 按累计耗时列出前 15 条
  deploy/scripts/pg_stats.sh --limit 30       # 列出前 30 条
  deploy/scripts/pg_stats.sh enable           # 一次性启用扩展
  deploy/scripts/pg_stats.sh reset --yes      # 清空统计，重新开始采样
EOF
}

MODE=top
LIMIT=15
while [[ $# -gt 0 ]]; do
    case "$1" in
        top)
            MODE=top
            ;;
        enable)
            MODE=enable
            ;;
        reset)
            MODE=reset
            ;;
        --limit)
            [[ $# -ge 2 && "$2" =~ ^[0-9]+$ ]] || die "--limit 需要一个正整数"
            LIMIT=$2
            ((LIMIT > 0)) || die "--limit 需要大于 0"
            shift
            ;;
        --yes)
            YES=1
            ;;
        -h|--help)
            usage
            exit 0
            ;;
        *)
            die "未知参数：$1（使用 --help 查看用法）"
            ;;
    esac
    shift
done

ensure_extension() {
    if ! db_psql -tAc "SELECT 1 FROM pg_extension WHERE extname = 'pg_stat_statements'" | grep -qx 1; then
        die "pg_stat_statements 尚未启用，请先执行：$(basename "$0") enable"
    fi
}

case "$MODE" in
    enable)
        preload=$(db_psql -tAc "SELECT current_setting('shared_preload_libraries')" | tr -d '[:space:]')
        if [[ ",${preload}," != *",pg_stat_statements,"* ]]; then
            die "PostgreSQL 未预加载 pg_stat_statements（当前：${preload:-空}）。
请确认 deploy/compose.yaml 已包含 shared_preload_libraries 配置，然后重新创建容器：
    docker compose up -d --force-recreate postgres
等待 pg_isready 通过后重新执行：$(basename "$0") enable"
        fi
        db_psql -tAc "CREATE EXTENSION IF NOT EXISTS pg_stat_statements" >/dev/null
        say "pg_stat_statements 已启用；统计从下一次查询开始累积"
        ;;
    reset)
        if [[ "${YES:-0}" != "1" ]]; then
            die "reset 会清空所有累计统计，确认后加 --yes 重新执行"
        fi
        ensure_extension
        db_psql -tAc "SELECT pg_stat_statements_reset()" >/dev/null
        say "统计已清空"
        ;;
    top)
        ensure_extension
        say "按累计执行时间排序（limit=${LIMIT}）"
        db_psql -P pager=off -c "
            SELECT
                round(total_exec_time::numeric, 1) AS total_ms,
                round(mean_exec_time::numeric, 2) AS mean_ms,
                calls,
                rows,
                round((100 * shared_blks_hit
                    / NULLIF(shared_blks_hit + shared_blks_read, 0))::numeric, 1) AS cache_hit_pct,
                left(regexp_replace(query, '\s+', ' ', 'g'), 150) AS query
            FROM pg_stat_statements
            ORDER BY total_exec_time DESC
            LIMIT ${LIMIT}"
        ;;
esac
