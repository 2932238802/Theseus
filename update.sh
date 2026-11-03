#!/usr/bin/env bash
# Theseus 服务器增量更新：更新前备份、构建镜像、先迁移数据库、再启动全部服务，
# 更新后核对新增迁移与健康状态；失败时打印回滚命令，不自动覆盖数据库。
#
# 用法：
#   ./update.sh                  # 完整更新（推荐）
#   ./update.sh --skip-build     # 不重新构建服务镜像，仅重启并应用镜像内已有迁移
#   ./update.sh --skip-runners   # 跳过判题运行镜像的检查与重建
#   ./update.sh --no-backup      # 跳过更新前备份（不推荐）
#
# 说明：
#   - 在服务器 `git pull` 之后执行；脚本不会自行拉取代码。
#   - 判题运行镜像（theseus/runner-*:dev）不在 compose 构建范围内，脚本会在
#     镜像缺失或 docker/runners/ 自上次构建后有改动时自动重建。
#   - 后端镜像内嵌 `backend-rust/migrations`，启动时由 sqlx 自动执行未应用的迁移。
#     因此脚本只启动新的 backend 来完成增量迁移，成功后再启动 Worker 与前端。
#   - 迁移失败时脚本退出并打印 `deploy/scripts/restore.sh` 回滚命令，由人工决定是否恢复。
set -euo pipefail

ROOT=$(cd "$(dirname "$0")" && pwd)
DEPLOY="$ROOT/deploy"

DO_BUILD=1
DO_BACKUP=1
DO_RUNNERS=1

say() { printf '\033[1;34m==>\033[0m %s\n' "$*"; }
warn() { printf '\033[1;33m[警告]\033[0m %s\n' "$*"; }
die() { printf '\033[1;31m[错误]\033[0m %s\n' "$*" >&2; exit 1; }

usage() {
    cat <<'EOF'
Theseus 服务器增量更新：备份 -> 运行镜像 -> 构建 -> 先迁移 -> 启动全部 -> 更新后核对。

用法：
  ./update.sh [选项]

选项：
  --skip-build     跳过服务镜像构建，使用现有镜像（镜像内没有新迁移时不会更新数据库）
  --skip-runners   跳过判题运行镜像的检查与重建
  --no-backup      跳过更新前备份（不推荐）
  -h, --help       显示帮助

流程：
  1. 记录当前迁移版本，对比仓库 migrations/ 列出待应用迁移
  2. 调用 deploy/scripts/backup.sh 备份数据库与 uploads
  3. 检查判题运行镜像，缺失或定义有变化时重新构建
  4. docker compose build
  5. 停止 backend 与两个 Worker，仅启动新 backend 应用增量迁移
  6. 迁移成功后启动其余服务
  7. 核对新增迁移、失败迁移与健康状态
EOF
}

while [[ $# -gt 0 ]]; do
    case "$1" in
        --skip-build) DO_BUILD=0 ;;
        --skip-runners) DO_RUNNERS=0 ;;
        --no-backup) DO_BACKUP=0 ;;
        -h|--help) usage; exit 0 ;;
        *) die "未知参数：$1（使用 --help 查看用法）" ;;
    esac
    shift
done

[[ -f "$DEPLOY/.env" ]] || die "缺少 deploy/.env，请先 cp deploy/.env.example deploy/.env 并填写"
[[ -f "$DEPLOY/compose.yaml" ]] || die "缺少 deploy/compose.yaml"

if docker compose version >/dev/null 2>&1; then
    COMPOSE=(docker compose)
elif command -v docker-compose >/dev/null 2>&1; then
    COMPOSE=(docker-compose)
else
    die "未找到 Docker Compose（docker compose / docker-compose）"
fi

cd "$DEPLOY"

set -a
# shellcheck disable=SC1091
source .env
set +a

PGUSER=${POSTGRES_USER:-theseus}
PGDB=${POSTGRES_DB:-theseus}
BACKUP_DIR=${BACKUP_DIR:-$DEPLOY/backups}
RUNNER_STATE="$DEPLOY/.runner-images.commit"
DB_DUMP=""
UPLOADS_TAR=""
TMP_DIR=$(mktemp -d)
trap 'rm -rf "$TMP_DIR"' EXIT

db_psql() {
    "${COMPOSE[@]}" exec -T postgres \
        psql -U "$PGUSER" -d "$PGDB" -v ON_ERROR_STOP=1 "$@"
}

migrations_table_exists() {
    [[ "$(db_psql -tAc "SELECT to_regclass('public._sqlx_migrations') IS NOT NULL" 2>/dev/null)" == "t" ]]
}

snapshot_migrations() {
    if migrations_table_exists; then
        db_psql -tA -F'|' -c \
            "SELECT version, description, success FROM _sqlx_migrations ORDER BY version"
    fi
}

ensure_dependencies() {
    if "${COMPOSE[@]}" exec -T postgres pg_isready -U "$PGUSER" -d "$PGDB" >/dev/null 2>&1; then
        return
    fi
    say "启动 PostgreSQL 与 Redis"
    "${COMPOSE[@]}" up -d postgres redis
    local tries=0
    until "${COMPOSE[@]}" exec -T postgres pg_isready -U "$PGUSER" -d "$PGDB" >/dev/null 2>&1; do
        tries=$((tries + 1))
        ((tries >= 30)) && die "PostgreSQL 未就绪，请检查：${COMPOSE[*]} logs postgres"
        sleep 2
    done
}

# 返回 0 表示 backend 已 healthy；返回 1 表示退出、失败或超时。
wait_backend() {
    local timeout=${1:-0}
    local deadline=$((SECONDS + timeout))
    local cid status
    cid=$("${COMPOSE[@]}" ps -q backend)
    [[ -n "$cid" ]] || return 1
    while ((SECONDS < deadline)); do
        status=$(docker inspect \
            -f '{{if .State.Health}}{{.State.Health.Status}}{{else}}{{.State.Status}}{{end}}' \
            "$cid" 2>/dev/null || true)
        case "$status" in
            healthy) return 0 ;;
            exited|dead) return 1 ;;
        esac
        sleep 3
    done
    return 1
}

print_rollback() {
    echo
    echo "回滚步骤（确认需要时再执行）："
    echo "  cd $(printf '%q' "$DEPLOY")"
    if [[ -n "$DB_DUMP" ]]; then
        if [[ -n "$UPLOADS_TAR" ]]; then
            echo "  ./scripts/restore.sh $(printf '%q' "$DB_DUMP") $(printf '%q' "$UPLOADS_TAR")"
        else
            echo "  ./scripts/restore.sh $(printf '%q' "$DB_DUMP")"
        fi
    else
        echo "  未创建更新前备份（--no-backup），请手动检查数据库。"
    fi
    echo "  ${COMPOSE[*]} up -d"
    echo "  注意：恢复会回到更新前备份，更新期间产生的写入会丢失。"
}

fail_update() {
    warn "$1"
    echo
    echo "最近 backend 日志："
    "${COMPOSE[@]}" logs --tail=80 backend || true
    print_rollback
    exit 1
}

# 运行镜像不在 compose 里，必须由宿主机单独构建。以下判断避免每次更新都重建，
# 同时保证 docker/runners/ 改动后不会继续使用旧镜像（例如缺 libjson-c）。
runner_image_tags() {
    printf '%s\n' \
        "${RUN_IMAGE_PYTHON:-theseus/runner-python:dev}" \
        "${RUN_IMAGE_NODE:-theseus/runner-node:dev}" \
        "${RUN_IMAGE_CPP:-theseus/runner-cpp:dev}" \
        "${RUN_IMAGE_JAVA:-theseus/runner-java:dev}"
}

runner_images_are_local() {
    [[ "${RUN_IMAGE_PYTHON:-theseus/runner-python:dev}" == "theseus/runner-python:dev" ]] &&
        [[ "${RUN_IMAGE_NODE:-theseus/runner-node:dev}" == "theseus/runner-node:dev" ]] &&
        [[ "${RUN_IMAGE_CPP:-theseus/runner-cpp:dev}" == "theseus/runner-cpp:dev" ]] &&
        [[ "${RUN_IMAGE_JAVA:-theseus/runner-java:dev}" == "theseus/runner-java:dev" ]]
}

runner_images_missing() {
    local image
    while IFS= read -r image; do
        docker image inspect "$image" >/dev/null 2>&1 || return 0
    done < <(runner_image_tags)
    return 1
}

runner_images_stale() {
    local last=""
    if [[ -f "$RUNNER_STATE" ]]; then
        last=$(tr -d '[:space:]' <"$RUNNER_STATE")
    fi
    # 工作区有未提交的运行镜像改动时也重建（本地开发场景）。
    if ! git -C "$ROOT" diff --quiet HEAD -- \
        backend-rust/docker/runners backend-rust/scripts/build_runtime_images.sh; then
        return 0
    fi
    # 没有记录过一次成功构建时，无法判断镜像是否过期，按需要重建处理。
    [[ -n "$last" ]] || return 0
    git -C "$ROOT" cat-file -e "${last}^{commit}" 2>/dev/null || return 0
    ! git -C "$ROOT" diff --quiet "$last" HEAD -- \
        backend-rust/docker/runners backend-rust/scripts/build_runtime_images.sh
}

ensure_runner_images() {
    if ((DO_RUNNERS == 0)); then
        warn "--skip-runners：跳过判题运行镜像检查"
        return
    fi
    if ! runner_images_are_local; then
        warn "RUN_IMAGE_* 指向自定义镜像，跳过本地构建；请自行确保镜像已更新"
        return
    fi
    local reason=""
    if runner_images_missing; then
        reason="有运行镜像缺失"
    elif runner_images_stale; then
        reason="运行镜像定义在上次构建后有改动"
    else
        say "判题运行镜像已是最新（$(tr -d '[:space:]' <"$RUNNER_STATE")）"
        return
    fi
    say "构建判题运行镜像（${reason}）"
    if ! bash "$ROOT/backend-rust/scripts/build_runtime_images.sh"; then
        die "判题运行镜像构建失败，服务保持原样"
    fi
    git -C "$ROOT" rev-parse HEAD >"$RUNNER_STATE"
    say "判题运行镜像构建完成（$(tr -d '[:space:]' <"$RUNNER_STATE")）"
}

# ---------- 1. 更新前检查 ----------
git_head=$(git -C "$ROOT" rev-parse --short HEAD 2>/dev/null || echo unknown)
say "更新前检查（当前提交：$git_head）"
ensure_dependencies

pre_snapshot=$(snapshot_migrations)
if [[ -n "$pre_snapshot" ]]; then
    applied_count=$(printf '%s\n' "$pre_snapshot" | grep -c . || true)
    say "数据库已应用 $applied_count 条迁移"
else
    applied_count=0
    say "数据库尚未初始化，将应用全部迁移"
fi

declare -A applied=()
while IFS='|' read -r version _rest; do
    [[ -n "$version" ]] && applied["$version"]=1
done <<<"$pre_snapshot"

pending=()
for file in "$ROOT"/backend-rust/migrations/*.sql; do
    [[ -e "$file" ]] || continue
    base=${file##*/}
    prefix=${base%%_*}
    [[ "$prefix" =~ ^[0-9]+$ ]] || continue
    version=$((10#$prefix))
    if [[ -z "${applied[$version]:-}" ]]; then
        pending+=("$base")
    fi
done

if ((${#pending[@]})); then
    say "待应用迁移 ${#pending[@]} 条："
    printf '    %s\n' "${pending[@]}"
else
    say "没有待应用的数据库迁移"
fi
if ((DO_BUILD == 0)) && ((${#pending[@]})); then
    warn "--skip-build：待应用迁移必须已编译进当前 backend 镜像，否则不会生效"
fi

# ---------- 2. 更新前备份 ----------
if ((DO_BACKUP)); then
    mkdir -p "$BACKUP_DIR"
    say "备份数据库与 uploads（更新前）"
    ./scripts/backup.sh || fail_update "更新前备份失败，已中止更新"
    DB_DUMP=$(ls -1t "$BACKUP_DIR"/db-*.dump 2>/dev/null | head -n 1 || true)
    UPLOADS_TAR=$(ls -1t "$BACKUP_DIR"/uploads-*.tar.gz 2>/dev/null | head -n 1 || true)
    [[ -n "$DB_DUMP" ]] && say "数据库备份：$DB_DUMP"
else
    warn "--no-backup：跳过更新前备份，迁移失败将无法直接回滚数据库"
fi

# ---------- 3. 构建判题运行镜像 ----------
ensure_runner_images

# ---------- 4. 构建服务镜像 ----------
if ((DO_BUILD)); then
    say "构建服务镜像"
    "${COMPOSE[@]}" build || fail_update "镜像构建失败，服务保持原样"
else
    warn "--skip-build：使用现有镜像"
fi

# ---------- 5. 应用增量迁移 ----------
say "停止 backend 与 Worker，保留 postgres/redis"
"${COMPOSE[@]}" stop backend judge-worker anticheat-worker

say "启动 backend 以应用增量迁移（最多等待 240 秒）"
"${COMPOSE[@]}" up -d --no-deps backend
if ! wait_backend 240; then
    fail_update "backend 未在 240 秒内变为 healthy，迁移可能失败"
fi

post_snapshot=$(snapshot_migrations)
if ! db_psql -tAc "SELECT count(*) FROM _sqlx_migrations WHERE success = false" 2>/dev/null | grep -qx '0'; then
    fail_update "检测到失败的数据库迁移"
fi

new_migrations=""
if [[ -n "$post_snapshot" ]]; then
    new_migrations=$(comm -13 \
        <(printf '%s\n' "$pre_snapshot" | grep . | sort) \
        <(printf '%s\n' "$post_snapshot" | grep . | sort) || true)
fi
if [[ -n "$new_migrations" ]]; then
    say "本次新增迁移："
    printf '%s\n' "$new_migrations" | sed 's/^/    /'
else
    say "本次没有新增迁移（数据库已是最新）"
fi

# ---------- 6. 启动全部服务 ----------
say "启动全部服务"
"${COMPOSE[@]}" up -d

if ! wait_backend 120; then
    fail_update "重启后 backend 未恢复 healthy"
fi

# ---------- 7. 更新后核对 ----------
say "服务状态"
"${COMPOSE[@]}" ps

port=${HTTP_PORT:-8080}
port=${port##*:}
if command -v curl >/dev/null 2>&1; then
    if curl -fsS --max-time 5 -o /dev/null "http://127.0.0.1:${port}/"; then
        say "前端响应正常：http://127.0.0.1:${port}/"
    else
        warn "前端未在 5 秒内响应，请检查：${COMPOSE[*]} logs frontend"
    fi
fi

say "更新完成（提交：$git_head）"
if [[ -n "$DB_DUMP" ]]; then
    echo "    更新前备份：$DB_DUMP"
fi
