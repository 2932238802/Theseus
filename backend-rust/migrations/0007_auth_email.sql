-- 邮箱验证、一次性令牌与登录会话版本。
--
-- 已有账号在迁移时直接标记为已验证，避免升级后把自己锁在班级/作业/论坛之外。
-- 新注册账号的 email_verified_at 保持 NULL，直到用户点击验证链接。
ALTER TABLE users
    ADD COLUMN IF NOT EXISTS email_verified_at TIMESTAMPTZ,
    ADD COLUMN IF NOT EXISTS token_version INTEGER NOT NULL DEFAULT 0;

UPDATE users
SET email_verified_at = CURRENT_TIMESTAMP
WHERE email_verified_at IS NULL;

CREATE TABLE IF NOT EXISTS auth_tokens (
    id BIGSERIAL PRIMARY KEY,
    user_id INTEGER NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    purpose VARCHAR(20) NOT NULL CHECK (purpose IN ('email_verify', 'password_reset')),
    token_hash CHAR(64) NOT NULL UNIQUE,
    expires_at TIMESTAMPTZ NOT NULL,
    used_at TIMESTAMPTZ,
    created_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX IF NOT EXISTS idx_auth_tokens_user_purpose
    ON auth_tokens (user_id, purpose, created_at DESC);

-- 只保存 SHA-256，数据库泄漏时不能直接使用令牌。
COMMENT ON COLUMN auth_tokens.token_hash IS '令牌的 SHA-256 十六进制摘要，不保存明文';

-- 邮件 outbox：注册/找回密码在业务事务内入队，API 进程内的 dispatcher 负责投递。
CREATE TABLE IF NOT EXISTS email_outbox (
    id BIGSERIAL PRIMARY KEY,
    recipient_email VARCHAR(200) NOT NULL,
    subject VARCHAR(200) NOT NULL,
    body TEXT NOT NULL,
    status VARCHAR(20) NOT NULL DEFAULT 'queued'
        CHECK (status IN ('queued', 'sending', 'sent', 'failed')),
    attempts INTEGER NOT NULL DEFAULT 0,
    last_error TEXT,
    next_attempt_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    claimed_at TIMESTAMPTZ,
    sent_at TIMESTAMPTZ,
    created_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX IF NOT EXISTS idx_email_outbox_pending
    ON email_outbox (status, next_attempt_at, id);

COMMENT ON COLUMN email_outbox.status IS 'queued 待投递；sending 已被 dispatcher 领取；sent 已投递；failed 超过重试上限';
COMMENT ON COLUMN email_outbox.body IS '纯文本邮件正文；log 模式下只写入服务端日志';
