#!/usr/bin/env bash
#
# 批量导入 doc/interview 下的面经 Markdown 到论坛面经板块（forum_posts.board = 'interview'）。
#
# 每个文件导入为一个面经帖子，标题取一级标题，标签取 frontmatter tags 并自动加入公司。
# 以 board = 'interview' 且标题相同作为去重键：默认跳过，--update 时覆盖正文与标签。
#
# 用法：
#   ./backend-rust/scripts/import_interview.sh --dry-run
#   ./backend-rust/scripts/import_interview.sh --author <用户名>
#   ./backend-rust/scripts/import_interview.sh --author <用户名> --update
#   ./backend-rust/scripts/import_interview.sh --author <用户名> --update --no-answers
#
# 依赖：bash >= 4.2、psql。
# 安全性：只读取本地 Markdown 与 backend-rust/.env，只写 forum_posts。
# 直接写库会跳过 API 的 Plus 权限与评论流程，仅用于管理员或本地导入。

set -euo pipefail

SCRIPT_DIR=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)
REPO_ROOT=$(cd "$SCRIPT_DIR/../.." && pwd)

INTERVIEW_DIR=${IMPORT_INTERVIEW_DIR:-"$REPO_ROOT/doc/interview"}
ENV_FILE=${IMPORT_BACKEND_ENV:-"$REPO_ROOT/backend-rust/.env"}
AUTHOR=${IMPORT_AUTHOR:-}
UPDATE=0
DRY_RUN=0
NO_ANSWERS=0

CREATED=0
UPDATED=0
SKIPPED=0
FAILED=0

TAG_LIST=()
declare -A TAG_SEEN=()

say() { printf '==> %s\n' "$*"; }
warn() { printf '[WARN] %s\n' "$*" >&2; }
fail() { printf '[FAIL] %s\n' "$*" >&2; }

usage() {
    cat <<'EOF'
批量导入 doc/interview 面经到论坛面经板块

用法：
  ./backend-rust/scripts/import_interview.sh [选项]

选项：
  --author <用户名>   指定面经作者，写库时必填
  --update            标题已存在时更新正文与标签
  --dry-run           只解析并打印结果，不连接数据库
  --no-answers        只保留题目，去掉流程、复盘、待补充与答案
  --dir <路径>        面经目录，默认 doc/interview
  -h, --help          显示帮助

说明：
  标题取文件中的一级标题，标题也是去重键
  标签取 frontmatter 的 tags，并自动加入公司
  导入的帖子直接发布在面经板块，需要 Plus 才能浏览
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
        --update)
            UPDATE=1
            shift
            ;;
        --dry-run)
            DRY_RUN=1
            shift
            ;;
        --no-answers)
            NO_ANSWERS=1
            shift
            ;;
        --dir)
            [[ $# -ge 2 ]] || fatal_preflight "--dir 缺少路径"
            INTERVIEW_DIR=$2
            shift 2
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

trim() {
    local value=$1
    value="${value#"${value%%[![:space:]]*}"}"
    value="${value%"${value##*[![:space:]]}"}"
    value=${value#\"}
    value=${value%\"}
    value=${value#\'}
    value=${value%\'}
    printf '%s' "$value"
}

read_field() {
    local file=$1 key=$2
    awk -v key="$key" '
        NR == 1 && $0 == "---" { in_fm = 1; next }
        in_fm && $0 == "---" { exit }
        in_fm && index($0, key ":") == 1 {
            print substr($0, length(key) + 2)
            exit
        }
    ' "$file"
}

read_heading() {
    local file=$1
    awk '
        NR == 1 && $0 == "---" { fm = 1; next }
        fm && $0 == "---" { fm = 0; next }
        fm { next }
        /^# / { sub(/^# +/, ""); print; exit }
    ' "$file"
}

read_content() {
    local file=$1
    awk '
        BEGIN { fm = 0; started = 0 }
        NR == 1 && $0 == "---" { fm = 1; next }
        fm == 1 && $0 == "---" { fm = 2; next }
        fm == 1 { next }
        {
            if (!started) {
                if ($0 ~ /^[ \t]*$/) next
                if ($0 ~ /^# /) { started = 1; next }
                started = 1
            }
            print
        }
    ' "$file" | awk 'NF { seen = 1 } seen { print }'
}

strip_answers() {
    awk '
        /^## 题目[[:space:]]*$/ { in_section = 1; print; next }
        !in_section { next }
        /^## / {
            if ($0 ~ /^## [0-9]+\./) { print; keep = 0; next }
            in_section = 0; next
        }
        /^### / { print; keep = 0; next }
        /^[[:space:]]*\*\*(题目|题意)\*\*[[:space:]]*$/ { print; keep = 1; next }
        /^[[:space:]]*\*\*[^*]+\*\*[[:space:]]*$/ { keep = 0; next }
        keep { print }
    '
}

round_label() {
    case "$1" in
        2) printf '二面' ;;
        3) printf '三面' ;;
        4) printf '四面' ;;
        5) printf '五面' ;;
        *) printf '%s面' "$1" ;;
    esac
}

add_tag() {
    local tag
    tag=$(trim "$1")
    [[ -z "$tag" ]] && return 0
    [[ -n "${TAG_SEEN[$tag]:-}" ]] && return 0
    if ((${#tag} > 20)); then
        warn "标签超过 20 字，已跳过：$tag"
        return 0
    fi
    if ((${#TAG_LIST[@]} >= 8)); then
        warn "标签超过 8 个，已跳过：$tag"
        return 0
    fi
    TAG_SEEN[$tag]=1
    TAG_LIST+=("$tag")
}

import_file() {
    local file=$1
    local rel=${file#"$INTERVIEW_DIR"/}
    local work=${rel#*/}
    local company_dir=${rel%%/*}
    local role_dir=${work%%/*}
    local filename stem date_from_name round_num
    filename=$(basename "$file")
    stem=${filename%.md}
    date_from_name=${stem%%-round-*}
    round_num=${stem##*-round-}

    local company role round date result
    company=$(trim "$(read_field "$file" company)")
    role=$(trim "$(read_field "$file" role)")
    round=$(trim "$(read_field "$file" round)")
    date=$(trim "$(read_field "$file" date)")
    result=$(trim "$(read_field "$file" result)")

    company=${company:-$company_dir}
    role=${role:-$role_dir}
    date=${date:-$date_from_name}
    round=${round:-$(round_label "$round_num")}

    local interview_date=""
    if [[ "$date" =~ ^[0-9]{4}-(0[1-9]|1[0-2])$ ]]; then
        interview_date=$date
    else
        warn "$rel 面试时间不是 YYYY-MM，已留空：$date"
    fi

    if ((${#company} > 40)); then
        fail "$rel 公司超过 40 字，已跳过"
        FAILED=$((FAILED + 1))
        return 0
    fi
    if ((${#role} > 40)); then
        fail "$rel 岗位超过 40 字，已跳过"
        FAILED=$((FAILED + 1))
        return 0
    fi

    local title
    title=$(read_heading "$file")
    title=$(trim "$title")
    title=${title:-"${company}${role} · ${round}（${date}）"}

    local title_len
    title_len=${#title}
    if ((title_len > 120)); then
        fail "$rel 标题超过 120 字，已跳过"
        FAILED=$((FAILED + 1))
        return 0
    fi

    local content
    content=$(read_content "$file")
    if ((NO_ANSWERS)); then
        content=$(printf '%s\n' "$content" | strip_answers)
    fi
    if [[ -z "$content" ]]; then
        fail "$rel 正文为空，已跳过"
        FAILED=$((FAILED + 1))
        return 0
    fi

    local content_len
    content_len=${#content}
    if ((content_len > 20000)); then
        fail "$rel 正文超过 20000 字（$content_len），请拆分后重试"
        FAILED=$((FAILED + 1))
        return 0
    fi

    TAG_LIST=()
    TAG_SEEN=()
    add_tag "$company"
    local tags_raw raw_tag
    local -a raw_tags=()
    tags_raw=$(trim "$(read_field "$file" tags)")
    tags_raw=${tags_raw#[}
    tags_raw=${tags_raw%]}
    if [[ -n "$tags_raw" ]]; then
        IFS=',' read -r -a raw_tags <<<"$tags_raw"
        for raw_tag in "${raw_tags[@]}"; do
            add_tag "$raw_tag"
        done
    fi

    local tags_text="" tags_display=""
    if ((${#TAG_LIST[@]} > 0)); then
        tags_text=$(printf '%s\n' "${TAG_LIST[@]}")
        tags_text=${tags_text%$'\n'}
        tags_display=$(IFS='、'; printf '%s' "${TAG_LIST[*]}")
    fi

    local action=新增
    local existing_id=""

    if ((DRY_RUN)); then
        action=预览
    else
        if ! existing_id=$(psql "$DATABASE_URL" -At -v ON_ERROR_STOP=1 -v title="$title" <<'SQL'
SELECT id FROM forum_posts
WHERE board = 'interview' AND title = :'title'
ORDER BY id
LIMIT 1;
SQL
        ); then
            fail "$rel 查询已有面经失败"
            FAILED=$((FAILED + 1))
            return 0
        fi

        if [[ -n "$existing_id" ]]; then
            if ((UPDATE)); then
                action=更新
            else
                say "[跳过] $rel"
                printf '       标题：%s\n' "$title"
                printf '       原因：标题已存在（id=%s），使用 --update 覆盖\n' "$existing_id"
                SKIPPED=$((SKIPPED + 1))
                return 0
            fi
        fi
    fi

    say "[$action] $rel"
    printf '       标题：%s\n' "$title"
    printf '       信息：%s / %s / %s / %s\n' "$company" "$role" "$round" "$date"
    printf '       面试时间：%s\n' "${interview_date:-未填写}"
    printf '       结果：%s\n' "${result:-待补充}"
    printf '       标签：%s\n' "${tags_display:-无}"
    printf '       正文：%s 字\n' "$content_len"

    if ((DRY_RUN)); then
        CREATED=$((CREATED + 1))
        return 0
    fi

    if [[ -n "$existing_id" ]]; then
        if ! psql "$DATABASE_URL" -v ON_ERROR_STOP=1 \
            -v post_id="$existing_id" \
            -v author_id="$AUTHOR_ID" \
            -v title="$title" \
            -v interview_date="$interview_date" \
            -v company="$company" \
            -v role="$role" \
            -v content="$content" \
            -v tags_text="$tags_text" >/dev/null <<'SQL'
UPDATE forum_posts
SET author_id = :'author_id'::integer,
    title = :'title',
    body_md = :'content',
    tags = CASE WHEN :'tags_text' = '' THEN ARRAY['面经']::text[]
                ELSE string_to_array(:'tags_text', E'\n') END,
    interview_date = NULLIF(:'interview_date', ''),
    company = NULLIF(:'company', ''),
    role = NULLIF(:'role', ''),
    status = 'published',
    updated_at = CURRENT_TIMESTAMP
WHERE id = :'post_id'::bigint;
SQL
        then
            fail "$rel 更新失败"
            FAILED=$((FAILED + 1))
            return 0
        fi
        UPDATED=$((UPDATED + 1))
    else
        if ! psql "$DATABASE_URL" -v ON_ERROR_STOP=1 \
            -v author_id="$AUTHOR_ID" \
            -v title="$title" \
            -v interview_date="$interview_date" \
            -v company="$company" \
            -v role="$role" \
            -v content="$content" \
            -v tags_text="$tags_text" >/dev/null <<'SQL'
INSERT INTO forum_posts (
    author_id, board, title, body_md, tags, interview_date, company, role,
    status, is_anonymous
)
VALUES (
    :'author_id'::integer,
    'interview',
    :'title',
    :'content',
    CASE WHEN :'tags_text' = '' THEN ARRAY['面经']::text[]
         ELSE string_to_array(:'tags_text', E'\n') END,
    NULLIF(:'interview_date', ''),
    NULLIF(:'company', ''),
    NULLIF(:'role', ''),
    'published',
    FALSE
);
SQL
        then
            fail "$rel 写入失败"
            FAILED=$((FAILED + 1))
            return 0
        fi
        CREATED=$((CREATED + 1))
    fi
}

AUTHOR_ID=""
if ((!DRY_RUN)); then
    [[ -n "$AUTHOR" ]] || fatal_preflight "请用 --author 指定作者（论坛帖子必须记录作者）"
    require_cmd psql
    load_env
    DATABASE_URL=${DATABASE_URL:-}
    [[ -n "$DATABASE_URL" ]] || fatal_preflight "未配置 DATABASE_URL"
    psql "$DATABASE_URL" -At -c 'SELECT 1' >/dev/null 2>&1 || fatal_db "PostgreSQL 不可达（检查 DATABASE_URL）"
    [[ "$(psql "$DATABASE_URL" -At -c "SELECT to_regclass('public.forum_posts') IS NOT NULL")" == "t" ]] ||
        fatal_db "缺少 forum_posts 表，请先启动后端或执行论坛迁移"
    [[ "$(psql "$DATABASE_URL" -At -c "SELECT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema = 'public' AND table_name = 'forum_posts' AND column_name = 'board')")" == "t" ]] ||
        fatal_db "缺少 board 字段，请先执行迁移 0032"
    [[ "$(psql "$DATABASE_URL" -At -c "SELECT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema = 'public' AND table_name = 'forum_posts' AND column_name = 'interview_date')")" == "t" ]] ||
        fatal_db "缺少 interview_date 字段，请先执行迁移 0032"

    AUTHOR_ID=$(psql "$DATABASE_URL" -At -v ON_ERROR_STOP=1 -v author="$AUTHOR" <<'SQL'
SELECT id FROM users WHERE username = :'author' LIMIT 1;
SQL
    )
    [[ -n "$AUTHOR_ID" ]] || fatal_preflight "找不到用户名：$AUTHOR"
fi

say "面经目录：$INTERVIEW_DIR"
say "导入板块：面经（interview）"
((UPDATE)) && say "已存在标题：覆盖更新"
((DRY_RUN)) && say "运行模式：预览，不写数据库"

FILE_COUNT=0
while IFS= read -r file; do
    FILE_COUNT=$((FILE_COUNT + 1))
    import_file "$file"
done < <(find "$INTERVIEW_DIR" -type f -name '*.md' ! -name 'README.md' | sort)

if ((FILE_COUNT == 0)); then
    say "没有找到面经文件"
fi

printf '\n'
say "完成：新增 $CREATED，更新 $UPDATED，跳过 $SKIPPED，失败 $FAILED"

if ((FAILED > 0)); then
    exit 1
fi
