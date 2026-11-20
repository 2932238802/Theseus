#!/usr/bin/env bash
#
# 重建面经板块：删除 board = 'interview' 的全部帖子，再从 doc/interview 重新导入无答案版本。
#
# 安全约束：
#   - 未传 --yes 时只读统计并打印计划，不修改数据库。
#   - 传 --yes 时默认先执行 deploy/scripts/backup.sh，备份失败立即中止。
#   - 备份与删除前校验导入作者存在且 status = 'active'（显式 --author 与自动解析都要校验）；
#     不满足时 exit 2，不触发备份、不删除任何帖子。
#   - 只删除 board = 'interview' 的帖子，评论 / 点赞 / 收藏由外键级联删除。
#   - 导入成功数必须大于 0 且等于目录中的 Markdown 数，否则非零退出并打印恢复命令。
#   - 导入成功后校验面经 interview_type 无空值，否则非零退出并打印恢复命令。
#   - 不接入 update.sh，避免每次部署重复删除；需要手动执行。
#
# 用法：
#   ./backend-rust/scripts/rebuild_interview_posts.sh
#   ./backend-rust/scripts/rebuild_interview_posts.sh --yes
#   ./backend-rust/scripts/rebuild_interview_posts.sh --author <管理员> --yes
#   ./backend-rust/scripts/rebuild_interview_posts.sh --docker --yes
#   ./backend-rust/scripts/rebuild_interview_posts.sh --dir /path/to/interview --no-backup --yes
#
# 依赖：bash >= 4.2、psql；--docker 模式改用 docker compose 的 postgres 容器。
#       备份固定使用 deploy/scripts/backup.sh（依赖 docker compose）。

set -euo pipefail

SCRIPT_DIR=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)
REPO_ROOT=$(cd "$SCRIPT_DIR/../.." && pwd)

INTERVIEW_DIR=${IMPORT_INTERVIEW_DIR:-"$REPO_ROOT/doc/interview"}
ENV_FILE=${IMPORT_BACKEND_ENV:-"$REPO_ROOT/backend-rust/.env"}
COMPOSE_FILE=${IMPORT_COMPOSE_FILE:-"$REPO_ROOT/deploy/compose.yaml"}
COMPOSE_ENV=${IMPORT_COMPOSE_ENV:-"$REPO_ROOT/deploy/.env"}
IMPORT_SCRIPT=${IMPORT_INTERVIEW_SCRIPT:-"$SCRIPT_DIR/import_interview.sh"}
BACKUP_SCRIPT=${INTERVIEW_BACKUP_SCRIPT:-"$REPO_ROOT/deploy/scripts/backup.sh"}
RESTORE_SCRIPT=${INTERVIEW_RESTORE_SCRIPT:-"$REPO_ROOT/deploy/scripts/restore.sh"}

AUTHOR=${IMPORT_AUTHOR:-}
CONFIRM=0
NO_BACKUP=0
USE_DOCKER=0

DB_DUMP=""
UPLOADS_TAR=""

say() { printf '==> %s\n' "$*"; }
warn() { printf '[WARN] %s\n' "$*" >&2; }
fail() { printf '[FAIL] %s\n' "$*" >&2; }

usage() {
    cat <<'EOF'
重建面经板块：删除 board='interview' 的全部帖子，再从 Markdown 重新导入无答案版本

用法：
  ./backend-rust/scripts/rebuild_interview_posts.sh [选项]

选项：
  --author <用户名>   导入作者；缺省自动选择第一个可用管理员
  --dir <路径>        面经目录，默认 doc/interview
  --docker            通过 docker compose 的 postgres 容器读写数据库
  --yes               确认执行：备份、删除、重建、校验；不加时仅预览
  --no-backup         跳过 deploy/scripts/backup.sh（不推荐）
  -h, --help          显示帮助

说明：
  未传 --yes 只读取面经帖子数与可导入 Markdown 数，不修改数据库
  备份与删除前校验导入作者存在且为 active；失败时退出 2，不备份、不删除
  删除只限 board='interview'，评论、点赞、收藏由外键级联删除
  导入固定使用 import_interview.sh --no-answers，正文只保留题目
  导入成功数必须大于 0 且等于目录中的 Markdown 数，否则非零退出并提示 restore.sh
  导入成功后校验面经 interview_type 无空值，否则非零退出并提示 restore.sh
  本脚本不接入 update.sh，需要手动执行
EOF
}

fatal_preflight() {
    printf '[FAIL] 前置条件不满足：%s\n' "$*" >&2
    exit 2
}

fatal_db() {
    printf '[FAIL] 数据库不可用：%s\n' "$*" >&2
    exit 3
}

require_cmd() {
    command -v "$1" >/dev/null 2>&1 || fatal_preflight "缺少命令 $1"
}

while (($#)); do
    case "$1" in
        --author)
            [[ $# -ge 2 ]] || fatal_preflight "--author 缺少用户名"
            AUTHOR=$2
            shift 2
            ;;
        --dir)
            [[ $# -ge 2 ]] || fatal_preflight "--dir 缺少路径"
            INTERVIEW_DIR=$2
            shift 2
            ;;
        --docker)
            USE_DOCKER=1
            shift
            ;;
        --yes)
            CONFIRM=1
            shift
            ;;
        --no-backup)
            NO_BACKUP=1
            shift
            ;;
        -h | --help)
            usage
            exit 0
            ;;
        *)
            fatal_preflight "未知参数 $1"
            ;;
    esac
done

[[ -d "$INTERVIEW_DIR" ]] || fatal_preflight "面经目录不存在：$INTERVIEW_DIR"
[[ -x "$IMPORT_SCRIPT" ]] || fatal_preflight "导入脚本不可执行：$IMPORT_SCRIPT"

load_env() {
    [[ -f "$ENV_FILE" ]] || fatal_preflight "缺少配置文件 $ENV_FILE（请先 cp backend-rust/.env.example backend-rust/.env）"
    local line key value
    while IFS= read -r line || [[ -n "$line" ]]; do
        line=${line%$'\r'}
        [[ -z "$line" || "$line" == \#* ]] && continue
        [[ "$line" == *=* ]] || continue
        key=${line%%=*}
        value=${line#*=}
        key=${key//[[:space:]]/}
        [[ -z "$key" ]] && continue
        if [[ -z "${!key:-}" ]]; then
            export "$key=$value"
        fi
    done <"$ENV_FILE"
}

psql_db() {
    if ((USE_DOCKER)); then
        "${COMPOSE[@]}" exec -T postgres psql -U "$PGUSER" -d "$PGDB" "$@"
    else
        psql "$DATABASE_URL" "$@"
    fi
}

count_importable_files() {
    local count
    count=$(find "$INTERVIEW_DIR" -type f -name '*.md' ! -name 'README.md' | wc -l)
    printf '%s' "${count//[[:space:]]/}"
}

count_posts() {
    local board=$1
    psql_db -At -v ON_ERROR_STOP=1 -v board="$board" <<'SQL'
SELECT count(*) FROM forum_posts WHERE board = :'board';
SQL
}

resolve_author() {
    [[ -n "$AUTHOR" ]] && return 0
    AUTHOR=$(psql_db -At -v ON_ERROR_STOP=1 <<'SQL'
SELECT username FROM users
WHERE role = 'admin' AND status = 'active'
ORDER BY id
LIMIT 1;
SQL
    )
}

# 显式 --author 与自动解析都必须校验：用户存在且 status = 'active'。
# 这一步必须发生在备份与删除之前，避免 --no-backup 时删完才发现作者不可用。
validate_author() {
    [[ -n "$AUTHOR" ]] || return 0
    local found
    found=$(psql_db -At -v ON_ERROR_STOP=1 -v author="$AUTHOR" <<'SQL'
SELECT 1 FROM users WHERE username = :'author' AND status = 'active' LIMIT 1;
SQL
    )
    [[ "$found" == "1" ]] ||
        fatal_preflight "导入作者不存在或未激活：$AUTHOR（需要 users.username 匹配且 status = 'active'）"
}

count_null_interview_types() {
    psql_db -At -v ON_ERROR_STOP=1 <<'SQL'
SELECT count(*) FROM forum_posts WHERE board = 'interview' AND interview_type IS NULL;
SQL
}

extract_count() {
    local text=$1 label=$2
    printf '%s\n' "$text" | sed -n "s/.*${label} \([0-9][0-9]*\).*/\1/p" | tail -1
}

restore_hint() {
    if [[ -n "$DB_DUMP" ]]; then
        printf '恢复命令：%s %s %s\n' "$RESTORE_SCRIPT" "$DB_DUMP" "${UPLOADS_TAR:-}" >&2
    else
        printf '恢复命令：%s <deploy/backups/db-YYYYmmdd-HHMMSS.dump> [uploads-YYYYmmdd-HHMMSS.tar.gz]\n' "$RESTORE_SCRIPT" >&2
    fi
}

FILE_COUNT=$(count_importable_files)

PGUSER=${POSTGRES_USER:-theseus}
PGDB=${POSTGRES_DB:-theseus}
COMPOSE=()
if ((USE_DOCKER)); then
    require_cmd docker
    [[ -f "$COMPOSE_FILE" ]] || fatal_preflight "缺少 compose 文件：$COMPOSE_FILE"
    [[ -f "$COMPOSE_ENV" ]] || fatal_preflight "缺少配置文件：$COMPOSE_ENV"
    ENV_FILE=$COMPOSE_ENV
    load_env
    PGUSER=${POSTGRES_USER:-$PGUSER}
    PGDB=${POSTGRES_DB:-$PGDB}
    if docker compose version >/dev/null 2>&1; then
        COMPOSE=(docker compose --env-file "$COMPOSE_ENV" -f "$COMPOSE_FILE")
    elif command -v docker-compose >/dev/null 2>&1; then
        COMPOSE=(docker-compose --env-file "$COMPOSE_ENV" -f "$COMPOSE_FILE")
    else
        fatal_preflight "未找到 Docker Compose（docker compose / docker-compose）"
    fi
    psql_db -At -c 'SELECT 1' >/dev/null 2>&1 ||
        fatal_db "postgres 容器不可达（请先启动 deploy/compose.yaml）"
else
    require_cmd psql
    load_env
    DATABASE_URL=${DATABASE_URL:-}
    [[ -n "$DATABASE_URL" ]] || fatal_preflight "未配置 DATABASE_URL"
    psql_db -At -c 'SELECT 1' >/dev/null 2>&1 || fatal_db "PostgreSQL 不可达（检查 DATABASE_URL）"
fi

[[ "$(psql_db -At -c "SELECT to_regclass('public.forum_posts') IS NOT NULL")" == "t" ]] ||
    fatal_db "缺少 forum_posts 表，请先启动后端或执行论坛迁移"
[[ "$(psql_db -At -c "SELECT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema = 'public' AND table_name = 'forum_posts' AND column_name = 'board')")" == "t" ]] ||
    fatal_db "缺少 board 字段，请先执行迁移 0032"
[[ "$(psql_db -At -c "SELECT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema = 'public' AND table_name = 'forum_posts' AND column_name = 'interview_type')")" == "t" ]] ||
    fatal_db "缺少 interview_type 字段，请先执行迁移 0048"

resolve_author || true
if [[ -z "$AUTHOR" ]]; then
    if ((CONFIRM)); then
        fatal_preflight "找不到可用管理员，请用 --author 指定导入作者"
    fi
    warn "未找到可用管理员；执行时请用 --author 指定导入作者"
else
    validate_author
fi

POST_COUNT=$(count_posts interview)
GENERAL_COUNT=$(count_posts general)

say "面经目录：$INTERVIEW_DIR"
say "可导入 Markdown：$FILE_COUNT 个"
say "当前面经帖子：$POST_COUNT 条（board='interview'）"
say "综合板块帖子：$GENERAL_COUNT 条（本次不删除）"
say "导入作者：${AUTHOR:-<未找到管理员>}"

if ((FILE_COUNT == 0)); then
    warn "面经目录中没有可导入的 Markdown，已中止（未修改数据库）"
    exit 2
fi

if ((!CONFIRM)); then
    printf '\n'
    say "将执行："
    if ((NO_BACKUP)); then
        printf '  1. 跳过备份（--no-backup）\n'
    else
        printf '  1. 备份数据库与 uploads（deploy/scripts/backup.sh）\n'
    fi
    printf '  2. 删除面经帖子 %s 条（评论、点赞、收藏级联删除）\n' "$POST_COUNT"
    printf '  3. 从 %s 导入 %s 个文件（--no-answers）\n' "$INTERVIEW_DIR" "$FILE_COUNT"
    printf '  4. 校验导入成功数 = %s 且大于 0\n' "$FILE_COUNT"
    printf '\n'
    say "未传 --yes，仅预览，数据库未修改"
    printf '确认执行：%s --author %s --yes' "$0" "${AUTHOR:-<管理员>}"
    ((USE_DOCKER)) && printf ' --docker'
    ((NO_BACKUP)) && printf ' --no-backup'
    printf '\n'
    exit 0
fi

if ((!NO_BACKUP)); then
    say "执行备份：$BACKUP_SCRIPT"
    set +e
    BACKUP_OUTPUT=$("$BACKUP_SCRIPT" 2>&1)
    BACKUP_STATUS=$?
    set -e
    printf '%s\n' "$BACKUP_OUTPUT"
    if ((BACKUP_STATUS != 0)); then
        fail "备份失败（退出码 $BACKUP_STATUS），已中止，未删除任何帖子"
        exit 1
    fi
    DB_DUMP=$(printf '%s\n' "$BACKUP_OUTPUT" | sed -n 's/^完成：\([^,]*\.dump\).*/\1/p' | tail -1)
    UPLOADS_TAR=$(printf '%s\n' "$BACKUP_OUTPUT" | sed -n 's/.*, \([^,]*\.tar\.gz\).*/\1/p' | tail -1)
    [[ -n "$DB_DUMP" ]] && say "备份完成：$DB_DUMP"
fi

say "删除面经帖子（board='interview'）"
set +e
DELETED=$(psql_db -At -v ON_ERROR_STOP=1 <<'SQL'
WITH deleted AS (
    DELETE FROM forum_posts WHERE board = 'interview' RETURNING id
)
SELECT count(*) FROM deleted;
SQL
)
DELETE_STATUS=$?
set -e
if ((DELETE_STATUS != 0)); then
    fail "删除面经帖子失败（退出码 $DELETE_STATUS）"
    restore_hint
    exit 1
fi
say "已删除面经帖子：$DELETED 条"

say "重新导入：$IMPORT_SCRIPT"
import_args=(--no-answers --author "$AUTHOR" --dir "$INTERVIEW_DIR")
((USE_DOCKER)) && import_args+=(--docker)
set +e
IMPORT_OUTPUT=$("$IMPORT_SCRIPT" "${import_args[@]}" 2>&1)
IMPORT_STATUS=$?
set -e
printf '%s\n' "$IMPORT_OUTPUT"

SUMMARY=$(printf '%s\n' "$IMPORT_OUTPUT" | grep '^==> 完成：' | tail -1 || true)
CREATED=$(extract_count "$SUMMARY" '新增')
UPDATED=$(extract_count "$SUMMARY" '更新')
SKIPPED=$(extract_count "$SUMMARY" '跳过')
FAILED=$(extract_count "$SUMMARY" '失败')
CREATED=${CREATED:-0}
UPDATED=${UPDATED:-0}
SKIPPED=${SKIPPED:-0}
FAILED=${FAILED:-0}

AFTER_INTERVIEW=$(count_posts interview)
AFTER_GENERAL=$(count_posts general)

printf '\n'
say "删除数：$DELETED"
say "导入成功数：$CREATED（更新 $UPDATED，跳过 $SKIPPED，失败 $FAILED）"
say "重建后面经帖子：$AFTER_INTERVIEW 条"

if ((AFTER_GENERAL != GENERAL_COUNT)); then
    fail "综合板块帖子数发生变化：$GENERAL_COUNT -> $AFTER_GENERAL"
    restore_hint
    exit 1
fi

if ((IMPORT_STATUS != 0 || CREATED == 0 || CREATED != FILE_COUNT || AFTER_INTERVIEW != FILE_COUNT)); then
    fail "导入校验未通过：成功 $CREATED / 可导入 $FILE_COUNT / 库内 $AFTER_INTERVIEW"
    restore_hint
    exit 1
fi

NULL_TYPES=$(count_null_interview_types)
say "重建后面经类型空值：$NULL_TYPES 条"
if ((NULL_TYPES != 0)); then
    fail "面经 interview_type 存在空值 $NULL_TYPES 条；重建后必须为 0"
    restore_hint
    exit 1
fi

say "完成：删除 $DELETED 条，导入成功 $CREATED 条，失败 $FAILED 条，类型空值 $NULL_TYPES 条"
