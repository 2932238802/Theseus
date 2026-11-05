#!/bin/sh
# 根据是否配置了收件人/Webhook 生成 Alertmanager 配置，再启动进程。
# SMTP 复用后端已有的 EMAIL_* 变量，配置写入临时文件后由 Alertmanager 展开环境变量。
set -eu

CONFIG=/tmp/alertmanager.yml

{
    echo "global:"
    echo "  resolve_timeout: 5m"
    if [ -n "${ALERT_EMAIL_TO:-}" ]; then
        echo "  smtp_smarthost: '${SMTP_SMARTHOST}'"
        echo "  smtp_from: '${SMTP_FROM}'"
        if [ -n "${SMTP_USERNAME:-}" ]; then
            echo "  smtp_auth_username: '${SMTP_USERNAME}'"
            echo "  smtp_auth_password: '${SMTP_PASSWORD}'"
        fi
        echo "  smtp_require_tls: ${SMTP_REQUIRE_TLS:-true}"
    fi
    cat <<'EOF'
route:
  receiver: default
  group_by: ['alertname', 'severity']
  group_wait: 30s
  group_interval: 5m
  repeat_interval: 4h
inhibit_rules:
  - source_matchers: ['severity="critical"']
    target_matchers: ['severity="warning"']
    equal: ['alertname']
receivers:
  - name: default
EOF
    if [ -n "${ALERT_EMAIL_TO:-}" ]; then
        cat <<'EOF'
    email_configs:
      - to: '${ALERT_EMAIL_TO}'
        send_resolved: true
        headers:
          Subject: '[Theseus] {{ .Status | toUpper }} {{ .CommonLabels.alertname }}'
EOF
    fi
    if [ -n "${ALERT_WEBHOOK_URL:-}" ]; then
        cat <<'EOF'
    webhook_configs:
      - url: '${ALERT_WEBHOOK_URL}'
        send_resolved: true
EOF
    fi
} > "$CONFIG"

# 没有配置任何渠道时仍启动，告警可在 Alertmanager UI 中查看。
exec /bin/alertmanager \
    --config.file="$CONFIG" \
    --config.expand-env \
    --storage.path=/alertmanager \
    "$@"
