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

# 预编译 harness 固定包含的头文件，避免每次提交都重新解析 bits/stdc++.h。
# 编译命令必须使用相同的 -std=c++17 -O2 -I/opt/harness，否则 GCC 会忽略这份 PCH。
RUN printf '%s\n' '#include <bits/stdc++.h>' '#include <sys/resource.h>' '#include "json.hpp"' \
        > /opt/harness/theseus_precompiled.hpp \
    && g++ -std=c++17 -O2 -I/opt/harness -x c++-header /opt/harness/theseus_precompiled.hpp \
        -o /opt/harness/theseus_precompiled.hpp.gch \
    && chmod 0644 /opt/harness/theseus_precompiled.hpp /opt/harness/theseus_precompiled.hpp.gch

WORKDIR /workspace
USER 65534:65534
