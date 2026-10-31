# Theseus 后端镜像：API、判题 Worker、防作弊 Worker 共用同一镜像，由 compose 指定 command。
FROM rust:1-slim-bookworm AS builder
# 默认单任务编译：2 GB 内存的服务器上并发编译容易 OOM，可通过 build arg 覆盖。
ARG CARGO_BUILD_JOBS=1
# 中国大陆服务器可传 https://rsproxy.cn/index/ 加速 crate 下载。
ARG CARGO_MIRROR=
ENV CARGO_BUILD_JOBS=${CARGO_BUILD_JOBS}
WORKDIR /src

RUN if [ -n "$CARGO_MIRROR" ]; then \
        mkdir -p "${CARGO_HOME:-/usr/local/cargo}" \
        && printf '[source.crates-io]\nreplace-with = "mirrored"\n[source.mirrored]\nregistry = "sparse+%s"\n' \
            "$CARGO_MIRROR" > "${CARGO_HOME:-/usr/local/cargo}/config.toml"; \
    fi

COPY Cargo.toml Cargo.lock ./
COPY migrations ./migrations
COPY src ./src

RUN cargo build --release --bins \
    && mkdir -p /out \
    && cp target/release/backend-rust \
          target/release/judge_worker \
          target/release/anticheat_worker \
          target/release/lsp_gateway \
          /out/

# judge worker 通过 docker CLI 调用宿主机 Docker（挂载 docker.sock），
# 这里直接复用官方静态 CLI，避免在运行镜像里安装完整 Docker 引擎。
FROM docker:27-cli AS dockercli

# 语义补全镜像：每个 WebSocket 连接对应一个 clangd / pyright 进程。
FROM node:22-bookworm-slim AS lsp
ARG APT_MIRROR=
RUN if [ -n "$APT_MIRROR" ]; then \
        sed -i "s|deb.debian.org|$APT_MIRROR|g; s|security.debian.org|$APT_MIRROR|g" \
            /etc/apt/sources.list /etc/apt/sources.list.d/*.sources 2>/dev/null || true; \
    fi \
    && apt-get update \
    && apt-get install -y --no-install-recommends ca-certificates tzdata g++ python3 python-is-python3 \
    && (apt-get install -y --no-install-recommends clangd \
        || apt-get install -y --no-install-recommends clangd-14) \
    && (command -v clangd >/dev/null 2>&1 \
        || ln -sf "$(command -v clangd-14)" /usr/local/bin/clangd) \
    && npm install -g pyright@1.1.414 \
    && rm -rf /var/lib/apt/lists/*

COPY --from=builder /out/lsp_gateway /app/lsp_gateway
WORKDIR /app
ENV LSP_BIND_ADDRESS=0.0.0.0:3001 \
    LSP_MAX_SESSIONS=4 \
    RUST_LOG=info
EXPOSE 3001
# 语言服务器只解析用户代码，用非 root 用户运行
USER node
CMD ["/app/lsp_gateway"]

FROM debian:bookworm-slim
# 中国大陆服务器可传 mirrors.aliyun.com。
ARG APT_MIRROR=
RUN if [ -n "$APT_MIRROR" ]; then \
        sed -i "s|deb.debian.org|$APT_MIRROR|g; s|security.debian.org|$APT_MIRROR|g" \
            /etc/apt/sources.list /etc/apt/sources.list.d/*.sources 2>/dev/null || true; \
    fi \
    && apt-get update \
    && apt-get install -y --no-install-recommends ca-certificates curl tzdata \
    && rm -rf /var/lib/apt/lists/*

COPY --from=dockercli /usr/local/bin/docker /usr/local/bin/docker
COPY --from=builder /out/ /app/

RUN mkdir -p /data/uploads/avatars
WORKDIR /app
ENV BIND_ADDRESS=0.0.0.0:3000 \
    UPLOAD_DIR=/data/uploads \
    RUST_LOG=info
EXPOSE 3000
CMD ["/app/backend-rust"]
