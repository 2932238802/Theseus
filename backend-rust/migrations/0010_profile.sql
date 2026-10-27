-- Profile completion: avatar, pending email change, account status,
-- email-change tokens, and analytics/favorites indexes.

ALTER TABLE users
    ADD COLUMN IF NOT EXISTS avatar_path VARCHAR(255),
    ADD COLUMN IF NOT EXISTS pending_email VARCHAR(100),
    ADD COLUMN IF NOT EXISTS status VARCHAR(20) NOT NULL DEFAULT 'active',
    ADD COLUMN IF NOT EXISTS deleted_at TIMESTAMPTZ;

ALTER TABLE users
    ADD CONSTRAINT users_status_check
        CHECK (status IN ('active', 'disabled', 'deleted'));

CREATE UNIQUE INDEX IF NOT EXISTS idx_users_pending_email
    ON users (LOWER(pending_email))
    WHERE pending_email IS NOT NULL;

ALTER TABLE auth_tokens DROP CONSTRAINT IF EXISTS auth_tokens_purpose_check;
ALTER TABLE auth_tokens ADD CONSTRAINT auth_tokens_purpose_check
    CHECK (purpose IN ('email_verify', 'email_change', 'password_reset'));

CREATE INDEX IF NOT EXISTS idx_submissions_user_time
    ON submissions (user_id, submitted_at DESC);

COMMENT ON COLUMN users.avatar_path IS '相对 UPLOAD_DIR 的头像路径，例如 avatars/7_ab12.jpg';
COMMENT ON COLUMN users.pending_email IS '待验证的新邮箱；验证成功后替换 users.email';
COMMENT ON COLUMN users.status IS 'active 正常；disabled 管理员禁用；deleted 用户已注销';
