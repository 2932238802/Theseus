#!/usr/bin/env bash
# 把 .env.example 中新增的键追加到现有 .env，不覆盖已有值。
# 用法：deploy/scripts/merge_env.sh [--dry-run] [--force]
#   --dry-run  只打印将要追加的内容
#   --force    同时追加示例值仍为占位符的键（默认跳过并提示手工填写）
set -euo pipefail

ROOT=$(cd "$(dirname "$0")/.." && pwd)
EXAMPLE=$ROOT/.env.example
TARGET=$ROOT/.env
DRY_RUN=0
FORCE=0

while [[ $# -gt 0 ]]; do
    case "$1" in
        -h | --help)
            sed -n '2,6p' "$0"
            exit 0
            ;;
        --dry-run) DRY_RUN=1 ;;
        --force) FORCE=1 ;;
        *)
            echo "未知参数：$1" >&2
            exit 2
            ;;
    esac
    shift
done

if [[ ! -f $EXAMPLE ]]; then
    echo "缺少 $EXAMPLE" >&2
    exit 1
fi
if [[ ! -f $TARGET ]]; then
    echo "缺少 $TARGET，请先 cp .env.example .env 并填写" >&2
    exit 1
fi

has_key() {
    grep -qE "^[[:space:]]*(export[[:space:]]+)?$1=" "$TARGET"
}

append_lines=()
skip_keys=()

while IFS= read -r line; do
    [[ $line =~ ^([A-Za-z_][A-Za-z0-9_]*)= ]] || continue
    key=${BASH_REMATCH[1]}
    has_key "$key" && continue
    if [[ $FORCE -eq 0 && $line =~ (replace|example\.com) ]]; then
        skip_keys+=("$key")
        continue
    fi
    append_lines+=("$line")
done <"$EXAMPLE"

if [[ ${#append_lines[@]} -eq 0 ]]; then
    echo "deploy/.env 已包含 .env.example 的全部键"
else
    echo "==> 缺少 ${#append_lines[@]} 项"
    printf '+ %s\n' "${append_lines[@]}"
    if [[ $DRY_RUN -eq 1 ]]; then
        echo "（--dry-run，未写入）"
    else
        BACKUP=$TARGET.bak-$(date +%Y%m%d-%H%M%S)
        cp "$TARGET" "$BACKUP"
        {
            printf '\n# ---- merge_env.sh 于 %s 补充的默认项 ----\n' "$(date +%F)"
            printf '%s\n' "${append_lines[@]}"
        } >>"$TARGET"
        echo
        echo "已写入 $TARGET"
        echo "备份：$BACKUP"
        echo "重启生效：cd $ROOT && docker compose up -d"
    fi
fi

if [[ ${#skip_keys[@]} -gt 0 ]]; then
    echo
    echo "==> 以下键缺失且示例值含占位符，请手工填写"
    printf '  %s\n' "${skip_keys[@]}"
fi
