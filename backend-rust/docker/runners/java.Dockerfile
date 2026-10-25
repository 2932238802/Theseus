FROM eclipse-temurin:21-jdk

ARG GSON_VERSION=2.11.0

RUN mkdir -p /opt/harness \
    && apt-get update \
    && apt-get install -y --no-install-recommends ca-certificates curl \
    && curl -fsSL -o /opt/harness/gson.jar \
        "https://repo1.maven.org/maven2/com/google/code/gson/gson/${GSON_VERSION}/gson-${GSON_VERSION}.jar" \
    && test -s /opt/harness/gson.jar \
    && chmod 0644 /opt/harness/gson.jar \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /workspace
USER 65534:65534
