-- 第三方账号关联：仅支持把 GitHub 账号绑定到已有的 Theseus 账号。
-- 登录只对已绑定的账号生效，不通过第三方邮箱自动建号。
-- subject 保存提供方返回的稳定用户 ID，登录名与邮箱仅用于展示。

CREATE TABLE IF NOT EXISTS oauth_identities (
    id BIGSERIAL PRIMARY KEY,
    user_id INTEGER NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    provider VARCHAR(20) NOT NULL CHECK (length(btrim(provider)) > 0),
    subject VARCHAR(100) NOT NULL CHECK (length(btrim(subject)) > 0),
    login_name VARCHAR(255) NOT NULL,
    display_name VARCHAR(255),
    email VARCHAR(255),
    created_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    last_login_at TIMESTAMPTZ,
    UNIQUE (provider, subject),
    UNIQUE (user_id, provider)
);

CREATE INDEX IF NOT EXISTS idx_oauth_identities_user
    ON oauth_identities (user_id);

COMMENT ON TABLE oauth_identities IS
    '第三方账号绑定；每个用户每个平台最多一条，每个第三方 subject 只能绑定一个用户';
COMMENT ON COLUMN oauth_identities.subject IS
    '第三方平台返回的稳定用户 ID，不随用户名或邮箱变化';

-- 第三方登录成功后的一次性票据复用 auth_tokens，需要扩展用途白名单。
ALTER TABLE auth_tokens DROP CONSTRAINT IF EXISTS auth_tokens_purpose_check;
ALTER TABLE auth_tokens ADD CONSTRAINT auth_tokens_purpose_check
    CHECK (purpose IN ('email_verify', 'email_change', 'password_reset', 'oauth_login'));
