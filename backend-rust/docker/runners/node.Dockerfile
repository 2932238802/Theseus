FROM node:22-slim

RUN useradd --uid 65534 --no-create-home --shell /usr/sbin/nologin runner 2>/dev/null || true
WORKDIR /workspace
USER 65534:65534
