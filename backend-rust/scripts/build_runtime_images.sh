#!/usr/bin/env bash
# 构建 Judge Worker 的四种语言运行镜像。
# 用法：sudo bash scripts/build_runtime_images.sh [--set-mirror]
#   --set-mirror  若 /etc/docker/daemon.json 不存在，写入国内可用的 registry mirror 并重启 Docker
set -euo pipefail

cd "$(dirname "$0")/.."

if [[ ${EUID} -ne 0 ]]; then
    echo "需要 root：sudo bash $0 [--set-mirror]" >&2
    exit 1
fi

if [[ ${1:-} == "--set-mirror" ]]; then
    mkdir -p /etc/docker
    if [[ -f /etc/docker/daemon.json ]]; then
        echo "==> /etc/docker/daemon.json 已存在，跳过 mirror 配置"
        echo "    如需加速，请手动添加 registry-mirrors 后执行 systemctl restart docker"
    else
        echo "==> 配置 Docker registry mirror"
        cat >/etc/docker/daemon.json <<'JSON'
{
  "registry-mirrors": [
    "https://docker.1panel.live",
    "https://docker.m.daocloud.io",
    "https://docker.1ms.run"
  ]
}
JSON
        systemctl restart docker
        sleep 2
    fi
fi

if ! docker info >/dev/null 2>&1; then
    echo "Docker 守护进程不可用，请先启动：systemctl start docker" >&2
    exit 1
fi

# 可选镜像加速（留空则使用官方源）：
#   APT_MIRROR=mirrors.aliyun.com
#   JSON_URL=https://cdn.jsdelivr.net/gh/nlohmann/json@v3.11.3/single_include/nlohmann/json.hpp
#   GSON_URL=https://maven.aliyun.com/repository/public/com/google/code/gson/gson/2.11.0/gson-2.11.0.jar
APT_MIRROR=${APT_MIRROR:-}
JSON_URL=${JSON_URL:-}
GSON_URL=${GSON_URL:-}

# 基础镜像。部分网络环境下 dockerd 的 mirror 回退会卡在 registry-1.docker.io，
# 因此优先用镜像代理的完整仓库名显式拉取，再打回标准 tag。
BASE_IMAGES=(
    "python:3.12-slim"
    "node:22-slim"
    "debian:bookworm-slim"
    "eclipse-temurin:21-jdk"
)
# docker.1panel.live 实测 blob 下载约 16 MB/s；daocloud/1ms 在当前网络下只有几十 KB/s，
# 放到后面仅作兜底。PULL_TIMEOUT 可按网络情况覆盖。
MIRRORS=("docker.1panel.live" "docker.m.daocloud.io" "docker.1ms.run")
PULL_TIMEOUT=${PULL_TIMEOUT:-300}

ensure_image() {
    local image=$1
    if docker image inspect "${image}" >/dev/null 2>&1; then
        echo "    已存在 ${image}"
        return 0
    fi
    local mirror
    for mirror in "${MIRRORS[@]}"; do
        echo "    尝试从 ${mirror} 拉取 ${image}（超时 ${PULL_TIMEOUT}s）"
        if timeout "${PULL_TIMEOUT}" docker pull "${mirror}/library/${image}"; then
            docker tag "${mirror}/library/${image}" "${image}"
            return 0
        fi
        echo "    ${mirror} 失败或超时，尝试下一个"
    done
    echo "    所有镜像代理均失败；Docker Hub 直连不可用，不再回退（避免无限挂起）" >&2
    return 1
}

echo "==> 准备基础镜像"
for image in "${BASE_IMAGES[@]}"; do
    ensure_image "${image}"
done

for runtime in python node cpp java; do
    echo "==> 构建 theseus/runner-${runtime}:dev"
    docker build \
        --build-arg APT_MIRROR="${APT_MIRROR}" \
        --build-arg JSON_URL="${JSON_URL}" \
        --build-arg GSON_URL="${GSON_URL}" \
        -f "docker/runners/${runtime}.Dockerfile" \
        -t "theseus/runner-${runtime}:dev" \
        docker/runners
done

echo "==> 构建完成"
docker images --format '{{.Repository}}:{{.Tag}}\t{{.Size}}' | grep '^theseus/runner-' || true
