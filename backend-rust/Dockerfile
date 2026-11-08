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

# 先用空入口编译依赖，把「依赖层」与「源码层」分开：
# Cargo.toml / Cargo.lock 不变时这一层直接命中缓存，
# 日常源码与迁移修改只重新编译本包，CI 的 GHA 层缓存也依赖这个分界。
# registry 与 Git 依赖写进本层，命中缓存时无需重新联网下载或校验。
# 新增 bin 时同步这里的空入口与下面的产物复制列表。
RUN mkdir -p src/bin \
    && printf 'fn main() {}\n' > src/main.rs \
    && : > src/lib.rs \
    && printf 'fn main() {}\n' > src/bin/judge_worker.rs \
    && printf 'fn main() {}\n' > src/bin/anticheat_worker.rs \
    && printf 'fn main() {}\n' > src/bin/lsp_gateway.rs \
    && cargo build --release --locked --bins \
    && rm -rf src

# 迁移由 sqlx::migrate! 在编译本包时读取，不参与依赖层，避免新增迁移触发全量重编。
COPY migrations ./migrations
COPY src ./src

# 复用上一层的依赖产物，只编译本包并复制最终二进制。
RUN cargo build --release --locked --bins \
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
# clangd 依赖 g++ 提供的标准库与系统头文件；pyright 只需要 Node，不安装 Python。
# 语言服务器与 pyright 分成两层，调整其中一侧不会重装另一侧。
RUN if [ -n "$APT_MIRROR" ]; then \
        sed -i "s|deb.debian.org|$APT_MIRROR|g; s|security.debian.org|$APT_MIRROR|g" \
            /etc/apt/sources.list /etc/apt/sources.list.d/*.sources 2>/dev/null || true; \
    fi \
    && apt-get update \
    && apt-get install -y --no-install-recommends ca-certificates tzdata g++ \
    && (apt-get install -y --no-install-recommends clangd \
        || apt-get install -y --no-install-recommends clangd-14) \
    && (command -v clangd >/dev/null 2>&1 \
        || ln -sf "$(command -v clangd-14)" /usr/local/bin/clangd) \
    && rm -rf /var/lib/apt/lists/*

RUN npm install -g pyright@1.1.414 && npm cache clean --force

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
