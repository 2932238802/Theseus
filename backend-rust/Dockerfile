# Theseus 后端镜像：API、判题 Worker、防作弊 Worker 共用同一镜像，由 compose 指定 command。
FROM rust:1-slim-bookworm AS builder
# 默认单任务编译：2 GB 内存的服务器上并发编译容易 OOM，可通过 build arg 覆盖。
ARG CARGO_BUILD_JOBS=1
ENV CARGO_BUILD_JOBS=${CARGO_BUILD_JOBS}
WORKDIR /src

COPY Cargo.toml Cargo.lock ./
COPY migrations ./migrations
COPY src ./src

RUN cargo build --release --bins \
    && mkdir -p /out \
    && cp target/release/backend-rust \
          target/release/judge_worker \
          target/release/anticheat_worker \
          /out/

# judge worker 通过 docker CLI 调用宿主机 Docker（挂载 docker.sock），
# 这里直接复用官方静态 CLI，避免在运行镜像里安装完整 Docker 引擎。
FROM docker:27-cli AS dockercli

FROM debian:bookworm-slim
RUN apt-get update \
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
