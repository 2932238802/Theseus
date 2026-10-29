-- 通知偏好：目前只记录邮件渠道，站内信始终接收
CREATE TABLE IF NOT EXISTS notification_preferences (
    user_id INTEGER NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    category VARCHAR(32) NOT NULL,
    channel VARCHAR(16) NOT NULL DEFAULT 'email',
    enabled BOOLEAN NOT NULL,
    updated_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (user_id, category, channel)
);

-- 通知邮件状态：pending 待处理、sending 处理中、queued 已进发件箱、skipped 不发送
ALTER TABLE notifications ADD COLUMN IF NOT EXISTS email_state VARCHAR(16) NOT NULL DEFAULT 'pending';
ALTER TABLE notifications ADD COLUMN IF NOT EXISTS email_state_at TIMESTAMPTZ;

-- 历史通知只保留站内信，不补发邮件
UPDATE notifications SET email_state = 'skipped' WHERE email_state = 'pending';

CREATE INDEX IF NOT EXISTS idx_notifications_email_pending
    ON notifications (id) WHERE email_state = 'pending';
