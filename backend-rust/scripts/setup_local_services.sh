#!/usr/bin/env bash
# 本地开发环境初始化：安装 PostgreSQL 与 Redis，并创建 theseus 角色/数据库。
# 用法：sudo bash scripts/setup_local_services.sh [--with-docker]
#   --with-docker  同时安装 Docker，便于构建并运行 Judge Worker 沙箱镜像
set -euo pipefail

INSTALL_DOCKER=0
if [[ ${1:-} == "--with-docker" ]]; then
    INSTALL_DOCKER=1
fi

if [[ ${EUID} -ne 0 ]]; then
    echo "请以 root 运行：sudo bash $0 [--with-docker]" >&2
    exit 1
fi

echo "==> 安装 PostgreSQL 与 Redis"
export DEBIAN_FRONTEND=noninteractive
apt-get update
apt-get install -y postgresql redis-server

echo "==> 启用并启动服务"
systemctl enable --now postgresql redis-server

if [[ ${INSTALL_DOCKER} -eq 1 ]]; then
    echo "==> 安装 Docker"
    apt-get install -y docker.io
    systemctl enable --now docker
    if [[ -n ${SUDO_USER:-} ]]; then
        usermod -aG docker "${SUDO_USER}"
        echo "已将 ${SUDO_USER} 加入 docker 组，重新登录后生效"
    fi
fi

echo "==> 创建角色 theseus（幂等）"
runuser -u postgres -- psql -v ON_ERROR_STOP=1 <<'SQL'
DO $$
BEGIN
    IF NOT EXISTS (SELECT FROM pg_roles WHERE rolname = 'theseus') THEN
        CREATE ROLE theseus LOGIN PASSWORD 'theseus';
    END IF;
END
$$;
SQL

echo "==> 创建数据库 theseus（幂等）"
if ! runuser -u postgres -- psql -tAc "SELECT 1 FROM pg_database WHERE datname = 'theseus'" | grep -q 1; then
    runuser -u postgres -- createdb -O theseus theseus
fi

echo "==> 服务状态"
pg_isready
redis-cli ping
echo "完成：DATABASE_URL=postgres://theseus:theseus@localhost:5432/theseus，REDIS_URL=redis://127.0.0.1:6379"
if [[ ${INSTALL_DOCKER} -eq 1 ]]; then
    echo "构建运行镜像："
    echo "  docker build -f docker/runners/python.Dockerfile -t theseus/runner-python:dev docker/runners"
    echo "  docker build -f docker/runners/node.Dockerfile   -t theseus/runner-node:dev   docker/runners"
    echo "  docker build -f docker/runners/cpp.Dockerfile    -t theseus/runner-cpp:dev    docker/runners"
    echo "  docker build -f docker/runners/java.Dockerfile   -t theseus/runner-java:dev   docker/runners"
fi
