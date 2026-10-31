-- Plus Theseus 会员有效期：审核通过时写入，到期后权限自动失效。
-- 一个用户只保留当前一段会员记录，续期在原记录上顺延。
CREATE TABLE IF NOT EXISTS plus_memberships (
    user_id INTEGER PRIMARY KEY REFERENCES users(id) ON DELETE CASCADE,
    application_id BIGINT REFERENCES plus_applications(id) ON DELETE SET NULL,
    started_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    expires_at TIMESTAMPTZ NOT NULL,
    updated_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX IF NOT EXISTS idx_plus_memberships_expires
    ON plus_memberships (expires_at);

-- 历史已通过申请没有有效期，从迁移时刻起补 30 天，避免升级后立即失效。
INSERT INTO plus_memberships (user_id, application_id, started_at, expires_at)
SELECT DISTINCT ON (user_id)
    user_id,
    id,
    CURRENT_TIMESTAMP,
    CURRENT_TIMESTAMP + INTERVAL '30 days'
FROM plus_applications
WHERE status = 'approved'
ORDER BY user_id, reviewed_at DESC NULLS LAST, id DESC
ON CONFLICT (user_id) DO NOTHING;
