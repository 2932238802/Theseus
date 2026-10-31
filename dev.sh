#!/usr/bin/env bash
# Theseus 本地开发一键启动：API + Judge Worker + 语义补全网关 + 前端 dev server
#
# 用法：
#   ./dev.sh
#   Ctrl+C 停止全部
#
# 说明：
#   - API 与 Worker 是 backend-rust 的两个 binary，共享 PostgreSQL / Redis。
#   - Worker 需要访问 /var/run/docker.sock；当前 shell 没有 docker 组权限时，
#     脚本会尝试用 sudo 启动（必要时提示输入密码）。
#   - 语义补全需要系统安装 clangd 与 pyright（npm install -g pyright）。
#   - 各服务日志同时输出到终端（带 [api]/[worker]/[lsp]/[frontend] 前缀）并写入 .dev-logs/。
set -euo pipefail

ROOT=$(cd "$(dirname "$0")" && pwd)
BACKEND="$ROOT/backend-rust"
FRONTEND="$ROOT/frontend-vue"
LOGDIR="$ROOT/.dev-logs"
API_BIN="$BACKEND/target/debug/backend-rust"
WORKER_BIN="$BACKEND/target/debug/judge_worker"
ANTICHEAT_BIN="$BACKEND/target/debug/anticheat_worker"
LSP_BIN="$BACKEND/target/debug/lsp_gateway"

mkdir -p "$LOGDIR"
: >"$LOGDIR/api.log"
: >"$LOGDIR/worker.log"
: >"$LOGDIR/anticheat.log"
: >"$LOGDIR/lsp.log"
: >"$LOGDIR/frontend.log"

pids=()
started=()

say() { printf '\033[1;34m==>\033[0m %s\n' "$*"; }
warn() { printf '\033[1;33m[警告]\033[0m %s\n' "$*"; }

cleanup() {
    trap - INT TERM EXIT
    if ((${#pids[@]})); then
        echo
        say "停止服务：${started[*]}"
        for pid in "${pids[@]}"; do
            kill -TERM "$pid" 2>/dev/null || true
        done
        for _ in 1 2 3 4 5; do
            local alive=0
            for pid in "${pids[@]}"; do
                if kill -0 "$pid" 2>/dev/null; then
                    alive=1
                fi
            done
            if ((alive == 0)); then
                break
            fi
            sleep 1
        done
        for pid in "${pids[@]}"; do
            kill -KILL "$pid" 2>/dev/null || true
        done
    fi
    wait 2>/dev/null || true
}
trap cleanup INT TERM EXIT

port_in_use() {
    ss -ltn "sport = :$1" 2>/dev/null | grep -q LISTEN
}

worker_running() {
    pgrep -f "target/debug/judge_worker" >/dev/null 2>&1
}

anticheat_running() {
    pgrep -f "target/debug/anticheat_worker" >/dev/null 2>&1
}

# 等待旧进程退出（Ctrl+C 之后 Worker 可能还在优雅退出，最长 60s）。
# 直接 pgrep 会把「正在退出」误判成「已经在跑」，从而跳过启动。
wait_process_gone() {
    local timeout=$1
    local deadline=$((SECONDS + timeout))
    while worker_running; do
        if ((SECONDS >= deadline)); then
            return 1
        fi
        sleep 0.5
    done
    return 0
}

wait_port_free() {
    local port=$1 timeout=$2
    local deadline=$((SECONDS + timeout))
    while port_in_use "$port"; do
        if ((SECONDS >= deadline)); then
            return 1
        fi
        sleep 0.5
    done
    return 0
}

# start_service <name> <workdir> <cmd...>
start_service() {
    local name=$1 dir=$2
    shift 2
    local log="$LOGDIR/$name.log"
    ( cd "$dir" && exec "$@" ) > >(sed -u "s/^/[$name] /" | tee -a "$log") 2>&1 &
    pids+=("$!")
    started+=("$name")
}

# ---------- 前置检查 ----------
command -v cargo >/dev/null 2>&1 || { warn "未找到 cargo，请先安装 Rust"; exit 1; }
[[ -f "$BACKEND/.env" ]] || { warn "缺少 backend-rust/.env，请先执行：cp backend-rust/.env.example backend-rust/.env"; exit 1; }
[[ -x "$FRONTEND/node_modules/.bin/vite" ]] || { warn "缺少前端依赖，请先执行：cd frontend-vue && npm install"; exit 1; }
pg_isready >/dev/null 2>&1 || warn "PostgreSQL 未就绪，请执行：sudo systemctl start postgresql"
redis-cli ping >/dev/null 2>&1 || warn "Redis 未就绪，请执行：sudo systemctl start redis-server"
command -v "${LSP_CPP_COMMAND:-clangd}" >/dev/null 2>&1 || warn "未找到 clangd，C++ 语义补全不可用"
command -v "${LSP_PYTHON_COMMAND:-pyright-langserver}" >/dev/null 2>&1 || warn "未找到 pyright-langserver，Python 语义补全不可用；可执行 npm install -g pyright"
command -v python >/dev/null 2>&1 || warn "未找到 python，pyright 可能无法解析标准库；可安装 python-is-python3"

# ---------- 编译后端 ----------
need_api=1
need_worker=1
need_lsp=1
if port_in_use 3000; then
    # 旧 API 可能刚收到 SIGTERM，给它几秒退出时间
    if ! wait_port_free 3000 5; then
        need_api=0
    fi
fi
if port_in_use 3001; then
    if ! wait_port_free 3001 5; then
        need_lsp=0
    fi
fi
if worker_running; then
    # 旧 Worker（尤其是 sudo 启动的）退得慢，先等它退出再决定
    say "检测到已有的 judge_worker，等待旧进程退出（最多 20s）…"
    if ! wait_process_gone 20; then
        need_worker=0
    fi
fi

if ((need_api || need_worker || need_lsp)); then
    say "编译 backend-rust（backend-rust / judge_worker / anticheat_worker / lsp_gateway）"
    ( cd "$BACKEND" && cargo build --bin backend-rust --bin judge_worker --bin anticheat_worker --bin lsp_gateway )
fi

# ---------- API ----------
if ((need_api)); then
    start_service api "$BACKEND" "$API_BIN"
else
    warn ":3000 已被占用，跳过 API（若是旧进程请先停止，否则会连到旧实例）"
fi

# ---------- Judge Worker ----------
if ((need_worker)); then
    if docker info >/dev/null 2>&1; then
        start_service worker "$BACKEND" "$WORKER_BIN"
    elif sudo -n true 2>/dev/null; then
        start_service worker "$BACKEND" sudo -n "$WORKER_BIN"
    elif [[ -t 0 ]]; then
        say "Judge Worker 需要 docker 权限，请输入 sudo 密码"
        if sudo -v; then
            start_service worker "$BACKEND" sudo -n "$WORKER_BIN"
        else
            warn "sudo 验证失败，跳过 Worker；之后可手动执行：cd backend-rust && sudo ./target/debug/judge_worker"
        fi
    else
        warn "无法交互输入 sudo 密码，跳过 Worker；之后可手动执行：cd backend-rust && sudo ./target/debug/judge_worker"
    fi
else
    warn "已有 judge_worker 进程在运行，跳过 Worker"
fi

# ---------- Anti-cheat Worker ----------
# 相似度扫描不需要 docker，和判题 Worker 分开启动。
if anticheat_running; then
    warn "已有 anticheat_worker 进程在运行，跳过防作弊扫描"
else
    start_service anticheat "$BACKEND" "$ANTICHEAT_BIN"
fi

# ---------- 语义补全网关 ----------
if ((need_lsp)); then
    start_service lsp "$BACKEND" "$LSP_BIN"
else
    warn ":3001 已被占用，跳过语义补全网关（若是旧进程请先停止）"
fi

# ---------- 前端 ----------
if port_in_use 5173; then
    warn ":5173 已被占用，跳过前端（若是旧进程请先停止）"
else
    start_service frontend "$FRONTEND" "$FRONTEND/node_modules/.bin/vite"
fi

# ---------- Worker 心跳确认 ----------
# API 会拒绝对没有心跳的评测请求（503），这里提前把问题暴露出来
if [[ " ${started[*]} " == *" worker "* ]]; then
    heartbeat_ok=0
    for _ in 1 2 3 4 5 6 7 8 9 10; do
        if [[ -n "$(redis-cli --scan --pattern 'theseus:run:worker:*' 2>/dev/null | head -n 1)" ]]; then
            heartbeat_ok=1
            break
        fi
        sleep 0.5
    done
    if ((heartbeat_ok == 0)); then
        warn "Worker 已启动但未写出心跳，运行功能会返回 503；请查看 .dev-logs/worker.log"
    fi
fi

if [[ " ${started[*]} " == *" anticheat "* ]]; then
    heartbeat_ok=0
    for _ in 1 2 3 4 5 6 7 8 9 10; do
        if [[ -n "$(redis-cli --scan --pattern 'theseus:anticheat:worker:*' 2>/dev/null | head -n 1)" ]]; then
            heartbeat_ok=1
            break
        fi
        sleep 0.5
    done
    if ((heartbeat_ok == 0)); then
        warn "防作弊 Worker 已启动但未写出心跳；请查看 .dev-logs/anticheat.log"
    fi
fi

if ((${#started[@]})); then
    say "启动完成：${started[*]}"
    echo "    API        http://127.0.0.1:3000"
    echo "    语义补全   ws://127.0.0.1:3001/api/lsp/ws"
    echo "    前端       http://127.0.0.1:5173"
    echo "    日志       .dev-logs/{api,worker,anticheat,lsp,frontend}.log"
    echo "    Ctrl+C 停止全部"
else
    warn "没有启动任何服务"
fi

wait
