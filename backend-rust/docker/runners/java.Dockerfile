FROM eclipse-temurin:21-jdk

ARG GSON_VERSION=2.11.0
# 中国大陆服务器可传 mirrors.aliyun.com；GSON_URL 可指向阿里云 Maven 镜像。
ARG APT_MIRROR=
ARG GSON_URL=

RUN if [ -n "$APT_MIRROR" ]; then \
        sed -i "s|archive.ubuntu.com|$APT_MIRROR|g; s|security.ubuntu.com|$APT_MIRROR|g" \
            /etc/apt/sources.list /etc/apt/sources.list.d/*.sources 2>/dev/null || true; \
    fi \
    && mkdir -p /opt/harness \
    && apt-get update \
    && apt-get install -y --no-install-recommends ca-certificates curl \
    && url="${GSON_URL:-https://repo1.maven.org/maven2/com/google/code/gson/gson/${GSON_VERSION}/gson-${GSON_VERSION}.jar}" \
    && curl -fsSL -o /opt/harness/gson.jar "$url" \
    && test -s /opt/harness/gson.jar \
    && chmod 0644 /opt/harness/gson.jar \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /workspace
USER 65534:65534
