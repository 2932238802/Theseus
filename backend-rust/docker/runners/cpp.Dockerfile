FROM debian:bookworm-slim

ARG APT_MIRROR=
# 中国大陆服务器可传 mirrors.aliyun.com。
RUN if [ -n "$APT_MIRROR" ]; then \
        sed -i "s|deb.debian.org|$APT_MIRROR|g; s|security.debian.org|$APT_MIRROR|g" \
            /etc/apt/sources.list /etc/apt/sources.list.d/*.sources 2>/dev/null || true; \
    fi \
    && apt-get update \
    && apt-get install -y --no-install-recommends \
        g++ \
        libjson-c-dev \
        libstdc++6 \
    && rm -rf /var/lib/apt/lists/* \
    && mkdir -p /opt/harness

# 预编译 harness 固定包含的头文件，避免每次提交都重新解析 bits/stdc++.h。
# json-c 是 C 库，模板实例化开销远低于 nlohmann/json：同一个 harness
# 的编译时间从约 2.4s 降到约 0.4s。
# 编译命令必须使用相同的 -std=c++17 -O2 -I/opt/harness，否则 GCC 会忽略这份 PCH。
RUN printf '%s\n' '#include <bits/stdc++.h>' '#include <sys/resource.h>' '#include <json-c/json.h>' \
        > /opt/harness/theseus_precompiled.hpp \
    && g++ -std=c++17 -O2 -I/opt/harness -x c++-header /opt/harness/theseus_precompiled.hpp \
        -o /opt/harness/theseus_precompiled.hpp.gch \
    && chmod 0644 /opt/harness/theseus_precompiled.hpp /opt/harness/theseus_precompiled.hpp.gch

WORKDIR /workspace
USER 65534:65534
