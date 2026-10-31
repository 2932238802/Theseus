# Theseus 前端：Node 构建静态资源，Nginx 托管并反向代理 /api 与 /uploads。
FROM node:22-bookworm-slim AS build
WORKDIR /app

COPY package.json package-lock.json ./
# 中国大陆服务器可传 https://registry.npmmirror.com。
ARG NPM_REGISTRY=
RUN if [ -n "$NPM_REGISTRY" ]; then \
        npm ci --registry="$NPM_REGISTRY"; \
    else \
        npm ci; \
    fi

COPY . .
ARG VITE_API_BASE_URL=/api
ARG VITE_SUBMIT_JUDGE_ENABLED=false
ENV VITE_API_BASE_URL=$VITE_API_BASE_URL
ENV VITE_SUBMIT_JUDGE_ENABLED=$VITE_SUBMIT_JUDGE_ENABLED
RUN npm run build

FROM nginx:1.27-alpine
COPY nginx.conf /etc/nginx/conf.d/default.conf
COPY --from=build /app/dist /usr/share/nginx/html
EXPOSE 80
