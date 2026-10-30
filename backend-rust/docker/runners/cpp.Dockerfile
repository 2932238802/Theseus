FROM debian:bookworm-slim

ARG JSON_VERSION=3.11.3
ARG TARGETARCH
# 中国大陆服务器可传 mirrors.aliyun.com；JSON_URL 可指向 jsDelivr 等镜像。
ARG APT_MIRROR=
ARG JSON_URL=

RUN if [ -n "$APT_MIRROR" ]; then \
        sed -i "s|deb.debian.org|$APT_MIRROR|g; s|security.debian.org|$APT_MIRROR|g" \
            /etc/apt/sources.list /etc/apt/sources.list.d/*.sources 2>/dev/null || true; \
    fi \
    && apt-get update \
    && apt-get install -y --no-install-recommends \
        ca-certificates \
        curl \
        g++ \
        libstdc++6 \
    && rm -rf /var/lib/apt/lists/* \
    && mkdir -p /opt/harness \
    && url="${JSON_URL:-https://github.com/nlohmann/json/releases/download/v${JSON_VERSION}/json.hpp}" \
    && curl -fsSL -o /opt/harness/json.hpp "$url" \
    && test -s /opt/harness/json.hpp \
    && chmod 0644 /opt/harness/json.hpp

WORKDIR /workspace
USER 65534:65534
