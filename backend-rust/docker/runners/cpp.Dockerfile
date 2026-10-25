FROM debian:bookworm-slim

ARG JSON_VERSION=3.11.3
ARG TARGETARCH

RUN apt-get update \
    && apt-get install -y --no-install-recommends \
        ca-certificates \
        curl \
        g++ \
        libstdc++6 \
    && rm -rf /var/lib/apt/lists/*

RUN mkdir -p /opt/harness \
    && curl -fsSL -o /opt/harness/json.hpp \
        "https://github.com/nlohmann/json/releases/download/v${JSON_VERSION}/json.hpp" \
    && test -s /opt/harness/json.hpp \
    && chmod 0644 /opt/harness/json.hpp

WORKDIR /workspace
USER 65534:65534
