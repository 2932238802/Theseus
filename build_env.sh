#!/usr/bin/env bash
# Theseus 基础环境搭建：二选一，不会同时安装开发与运行环境。
#
# 用法：
#   ./build_env.sh dev        # 本机开发：Rust、Node、PostgreSQL、Redis、Docker、依赖与判题镜像
#   ./build_env.sh runtime    # 服务器运行：Docker + Compose、判题镜像、deploy/.env
#   ./build_env.sh            # 交互式选择
#
# 可选参数：
#   --skip-images   不构建 judge runner 镜像
#   --skip-build    仅 dev 模式：不编译后端
#   -h, --help      显示帮助
#
# 说明：
#   - 推荐用普通用户运行，脚本按需调用 sudo；root 仅允许 runtime 模式。
#   - 仅支持 Ubuntu / Debian（使用 apt 与 systemd）。
#   - dev 模式不会安装 Docker Compose；runtime 模式不会安装 Rust / Node / PostgreSQL / Redis。
#   - runtime 模式在内存较小的机器上（< 8 GB）会自动创建 4 GB swap，避免构建时 OOM。
set -euo pipefail

ROOT=$(cd "$(dirname "$0")" && pwd)
BACKEND="$ROOT/backend-rust"
FRONTEND="$ROOT/frontend-vue"
DEPLOY="$ROOT/deploy"

MODE=""
SKIP_IMAGES=0
SKIP_BUILD=0

say() { printf '\033[1;34m==>\033[0m %s\n' "$*"; }
warn() { printf '\033[1;33m[警告]\033[0m %s\n' "$*"; }
die() { printf '\033[1;31m[错误]\033[0m %s\n' "$*" >&2; exit 1; }

usage() {
    cat <<'EOF'
Theseus 基础环境搭建：二选一，不会同时安装开发与运行环境。

用法：
  ./build_env.sh dev        # 本机开发：Rust、Node、PostgreSQL、Redis、Docker、依赖与判题镜像
  ./build_env.sh runtime    # 服务器运行：Docker + Compose、判题镜像、deploy/.env
  ./build_env.sh            # 交互式选择

可选参数：
  --skip-images   不构建 judge runner 镜像
  --skip-build    仅 dev 模式：不编译后端
  -h, --help      显示帮助

说明：
  - 推荐用普通用户运行，脚本按需调用 sudo；root 仅允许 runtime 模式。
  - 仅支持 Ubuntu / Debian（使用 apt 与 systemd）。
  - dev 模式不会安装 Docker Compose；runtime 模式不会安装 Rust / Node / PostgreSQL / Redis。
  - runtime 模式在内存较小的机器上（< 8 GB）会自动创建 4 GB swap。
EOF
}

while [[ $# -gt 0 ]]; do
    case "$1" in
        dev|development|1) MODE=dev ;;
        runtime|run|prod|production|2) MODE=runtime ;;
        --skip-images) SKIP_IMAGES=1 ;;
        --skip-build) SKIP_BUILD=1 ;;
        -h|--help) usage; exit 0 ;;
        *) die "未知参数：$1（使用 --help 查看用法）" ;;
    esac
    shift
done

if [[ -z "$MODE" ]]; then
    if [[ ! -t 0 ]]; then
        usage
        exit 2
    fi
    cat <<'EOF'
请选择要搭建的环境（只安装其中一种）：
  1) 开发环境   Rust、Node、PostgreSQL、Redis、Docker、本地依赖与判题镜像
  2) 运行环境   Docker + Compose、判题镜像、deploy/.env（不安装开发工具链）
EOF
    read -rp "输入 1 或 2: " choice
    case "$choice" in
        1|dev) MODE=dev ;;
        2|runtime) MODE=runtime ;;
        *) die "无效选择：$choice" ;;
    esac
fi

if [[ $EUID -eq 0 ]]; then
    if [[ "$MODE" != "runtime" ]]; then
        die "开发环境请用普通用户运行；root 仅支持 runtime 模式"
    fi
    SUDO=""
    warn "以 root 运行 runtime 模式，将不调用 sudo"
else
    SUDO="sudo"
fi

if ! command -v apt-get >/dev/null 2>&1; then
    die "仅支持 Ubuntu / Debian（未找到 apt-get）"
fi

DOCKER=(docker)

version_ge() {
    # version_ge <当前版本> <最低版本>
    [[ "$(printf '%s\n%s\n' "$2" "$1" | sort -V | head -n 1)" == "$2" ]]
}

apt_update() {
    say "更新 apt 软件源"
    $SUDO env DEBIAN_FRONTEND=noninteractive apt-get update
}

apt_install() {
    [[ $# -gt 0 ]] || return 0
    say "安装：$*"
    $SUDO env DEBIAN_FRONTEND=noninteractive apt-get install -y "$@"
}

start_service() {
    local service
    for service in "$@"; do
        if [[ -d /run/systemd/system ]]; then
            $SUDO systemctl enable --now "$service" 2>/dev/null || warn "无法启动 $service"
        else
            $SUDO service "$service" start 2>/dev/null || warn "无法启动 $service"
        fi
    done
}

ensure_docker() {
    if ! command -v docker >/dev/null 2>&1; then
        apt_install docker.io
    fi

    if ! docker info >/dev/null 2>&1; then
        start_service docker
    fi

    if docker info >/dev/null 2>&1; then
        DOCKER=(docker)
    else
        DOCKER=()
        [[ -n "$SUDO" ]] && DOCKER=("$SUDO")
        DOCKER+=(docker)
        if ! "${DOCKER[@]}" info >/dev/null 2>&1; then
            die "Docker 守护进程不可用，请检查：sudo systemctl status docker"
        fi
        if ! id -nG "$USER" | tr ' ' '\n' | grep -qx docker; then
            $SUDO usermod -aG docker "$USER"
            warn "已将 $USER 加入 docker 组，重新登录后可直接使用 docker"
        fi
    fi
}

ensure_swap() {
    if swapon --show 2>/dev/null | grep -q .; then
        say "已启用 swap（$(free -h | awk '/^Swap:/ {print $2}')），跳过"
        return
    fi

    local mem_mb
    mem_mb=$(awk '/MemTotal/ {printf "%d", $2 / 1024}' /proc/meminfo)
    if (( mem_mb >= 8192 )); then
        say "内存 ${mem_mb} MB，无需 swap"
        return
    fi

    say "内存 ${mem_mb} MB，创建 4 GB swap（/swapfile）"
    $SUDO fallocate -l 4G /swapfile 2>/dev/null \
        || $SUDO dd if=/dev/zero of=/swapfile bs=1M count=4096 status=none
    $SUDO chmod 600 /swapfile
    $SUDO mkswap /swapfile >/dev/null
    $SUDO swapon /swapfile
    if ! grep -q '^/swapfile ' /etc/fstab; then
        echo '/swapfile none swap sw 0 0' | $SUDO tee -a /etc/fstab >/dev/null
    fi
    $SUDO sysctl -w vm.swappiness=10 >/dev/null 2>&1 || true
    say "swap 已启用：$(free -h | awk '/^Swap:/ {print $2}')"
}

ensure_rust() {
    if ! command -v cargo >/dev/null 2>&1; then
        say "安装 Rust（rustup）"
        curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs \
            | sh -s -- -y --profile minimal
        # shellcheck disable=SC1091
        . "$HOME/.cargo/env"
    fi

    local version
    version=$(rustc --version | awk '{print $2}')
    if ! version_ge "$version" "1.85.0"; then
        if command -v rustup >/dev/null 2>&1; then
            say "Rust $version 过旧，更新 stable"
            rustup update stable
            version=$(rustc --version | awk '{print $2}')
        fi
    fi
    version_ge "$version" "1.85.0" \
        || die "需要 Rust >= 1.85（当前 $version），请手动执行 rustup update stable"
    say "Rust $version"
}

ensure_node() {
    local version=""
    if command -v node >/dev/null 2>&1; then
        version=$(node -p 'process.versions.node')
    fi

    if [[ -z "$version" ]] || ! version_ge "$version" "22.0.0"; then
        if [[ -s "$HOME/.nvm/nvm.sh" ]]; then
            say "通过 nvm 安装 Node 22"
            # shellcheck disable=SC1091
            . "$HOME/.nvm/nvm.sh"
            nvm install 22
            nvm use 22 >/dev/null
        else
            say "通过 NodeSource 安装 Node 22"
            curl -fsSL https://deb.nodesource.com/setup_22.x | $SUDO -E bash -
            apt_install nodejs
        fi
        version=$(node -p 'process.versions.node')
    fi
    version_ge "$version" "22.0.0" \
        || die "需要 Node >= 22（当前 $version）"
    say "Node $version"
}

setup_database() {
    start_service postgresql redis-server

    local tries=0
    until pg_isready >/dev/null 2>&1; do
        tries=$((tries + 1))
        ((tries >= 20)) && die "PostgreSQL 未就绪，请检查：sudo systemctl status postgresql"
        sleep 1
    done
    until redis-cli ping >/dev/null 2>&1; do
        tries=$((tries + 1))
        ((tries >= 20)) && die "Redis 未就绪，请检查：sudo systemctl status redis-server"
        sleep 1
    done

    say "创建数据库角色与数据库（幂等）"
    $SUDO -u postgres psql -v ON_ERROR_STOP=1 <<'SQL'
DO $$
BEGIN
    IF NOT EXISTS (SELECT FROM pg_roles WHERE rolname = 'theseus') THEN
        CREATE ROLE theseus LOGIN PASSWORD 'theseus';
    END IF;
END
$$;
SQL
    if ! $SUDO -u postgres psql -tAc \
        "SELECT 1 FROM pg_database WHERE datname = 'theseus'" | grep -qx 1; then
        $SUDO -u postgres createdb -O theseus theseus
    fi
    say "PostgreSQL / Redis 已就绪（开发环境默认账号 theseus/theseus）"
}

ensure_env_files() {
    if [[ ! -f "$BACKEND/.env" ]]; then
        cp "$BACKEND/.env.example" "$BACKEND/.env"
        say "已创建 backend-rust/.env"
    fi
    if [[ ! -f "$FRONTEND/.env" ]]; then
        cp "$FRONTEND/.env.example" "$FRONTEND/.env"
        say "已创建 frontend-vue/.env"
    fi
}

build_runner_images() {
    if ((SKIP_IMAGES)); then
        warn "跳过 judge runner 镜像（--skip-images）"
        return
    fi

    local missing=0
    local image
    for image in python node cpp java; do
        if ! "${DOCKER[@]}" image inspect "theseus/runner-$image:dev" >/dev/null 2>&1; then
            missing=1
            break
        fi
    done
    if ((missing == 0)); then
        say "judge runner 镜像已存在，跳过构建"
        return
    fi

    say "构建 judge runner 镜像（需要 sudo）"
    $SUDO bash "$BACKEND/scripts/build_runtime_images.sh"
}

setup_dev() {
    say "==== 开发环境 ===="
    apt_update
    apt_install build-essential pkg-config ca-certificates curl git \
        postgresql redis-server
    if ! command -v docker >/dev/null 2>&1; then
        apt_install docker.io
    fi

    ensure_rust
    ensure_node
    ensure_docker
    setup_database
    ensure_env_files

    say "安装前端依赖"
    if ! (cd "$FRONTEND" && npm ci); then
        warn "npm ci 失败，改用 npm install"
        (cd "$FRONTEND" && npm install)
    fi

    if ((SKIP_BUILD)); then
        warn "跳过后端编译（--skip-build）"
    else
        say "编译后端（API / judge_worker / anticheat_worker）"
        (cd "$BACKEND" && cargo build \
            --bin backend-rust --bin judge_worker --bin anticheat_worker)
    fi

    build_runner_images

    cat <<EOF

开发环境已就绪。
  启动：./dev.sh
  前端：http://127.0.0.1:5173
  API： http://127.0.0.1:3000
  上传文件目录：backend-rust/uploads（由 backend-rust/.env 的 UPLOAD_DIR 决定）
EOF
}

setup_runtime() {
    say "==== 运行环境 ===="
    apt_update
    apt_install ca-certificates curl git
    if ! command -v docker >/dev/null 2>&1; then
        apt_install docker.io
    fi

    ensure_docker
    ensure_swap

    if ! "${DOCKER[@]}" compose version >/dev/null 2>&1; then
        if apt-cache show docker-compose-v2 >/dev/null 2>&1; then
            apt_install docker-compose-v2
        elif apt-cache show docker-compose-plugin >/dev/null 2>&1; then
            apt_install docker-compose-plugin
        else
            warn "未找到 Compose 包，请按 Docker 官方文档安装 compose 插件"
        fi
    fi

    "${DOCKER[@]}" compose version >/dev/null 2>&1 \
        || die "docker compose 不可用，请安装 Compose v2 后重试"

    local runtimes
    runtimes=$("${DOCKER[@]}" info --format '{{json .Runtimes}}' 2>/dev/null || true)
    if [[ "$runtimes" != *'"runsc"'* ]]; then
        warn "Docker 尚未注册 runsc（gVisor）。生产判题需要先安装，见 doc/2610305_服务器部署方案.md"
    else
        say "runsc 已注册"
    fi

    build_runner_images

    if [[ ! -f "$DEPLOY/.env" ]]; then
        cp "$DEPLOY/.env.example" "$DEPLOY/.env"
        local db_password jwt_secret
        db_password=$(openssl rand -hex 24 2>/dev/null \
            || head -c 24 /dev/urandom | od -An -tx1 | tr -d ' \n')
        jwt_secret=$(openssl rand -base64 48 2>/dev/null | tr -d '\n' \
            || head -c 48 /dev/urandom | base64 | tr -d '\n')
        sed -i "s|^POSTGRES_PASSWORD=.*|POSTGRES_PASSWORD=$db_password|" "$DEPLOY/.env"
        sed -i "s|^JWT_SECRET=.*|JWT_SECRET=$jwt_secret|" "$DEPLOY/.env"
        chmod 600 "$DEPLOY/.env"
        say "已生成 deploy/.env（随机数据库密码与 JWT 密钥，权限 600）"
    else
        say "deploy/.env 已存在，保留原文件"
    fi

    cat <<EOF

运行环境已就绪（尚未启动服务）。
  1. 编辑 deploy/.env：FRONTEND_BASE_URL、EMAIL_*、HTTP_PORT
  2. 启动：cd deploy && docker compose build && docker compose up -d
  3. 健康检查：docker compose exec -T backend curl -fsS http://127.0.0.1:3000/readyz
  4. 首次注册账号后提升管理员：cd deploy && ./scripts/promote-admin.sh <用户名>

完整说明见 doc/2610305_服务器部署方案.md
EOF
}

case "$MODE" in
    dev) setup_dev ;;
    runtime) setup_runtime ;;
    *) die "未知模式：$MODE" ;;
esac
