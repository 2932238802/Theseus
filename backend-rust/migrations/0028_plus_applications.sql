-- Plus Theseus 开通申请：学生/教师提交，管理员审核。
-- 权益尚未定义，本期只记录申请与审核状态，不写入用户会员字段。
CREATE TABLE IF NOT EXISTS plus_applications (
    id BIGSERIAL PRIMARY KEY,
    user_id INTEGER NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    reason TEXT NOT NULL,
    status VARCHAR(16) NOT NULL DEFAULT 'pending',
    review_note TEXT,
    reviewed_by INTEGER REFERENCES users(id) ON DELETE SET NULL,
    reviewed_at TIMESTAMPTZ,
    created_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT plus_applications_status_check
        CHECK (status IN ('pending', 'approved', 'rejected'))
);

CREATE INDEX IF NOT EXISTS idx_plus_applications_user
    ON plus_applications (user_id, created_at DESC);

CREATE INDEX IF NOT EXISTS idx_plus_applications_status
    ON plus_applications (status, created_at DESC);

-- 同一用户同时只能有一条待审核申请；被驳回后可再次提交。
CREATE UNIQUE INDEX IF NOT EXISTS idx_plus_applications_pending_user
    ON plus_applications (user_id) WHERE status = 'pending';
