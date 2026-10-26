-- 班级邀请：教师搜索学生后发送邀请，学生确认后才入班。
-- pending 邀请同一班级同一学生只允许一条；历史记录保留以便审计。
CREATE TABLE IF NOT EXISTS class_invitations (
    id BIGSERIAL PRIMARY KEY,
    class_id INTEGER NOT NULL REFERENCES classes(id) ON DELETE CASCADE,
    inviter_id INTEGER NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    invitee_id INTEGER NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    status VARCHAR(20) NOT NULL DEFAULT 'pending'
        CHECK (status IN ('pending', 'accepted', 'declined', 'cancelled', 'expired')),
    expires_at TIMESTAMPTZ NOT NULL,
    responded_at TIMESTAMPTZ,
    created_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE UNIQUE INDEX IF NOT EXISTS uq_class_invitations_pending
    ON class_invitations (class_id, invitee_id)
    WHERE status = 'pending';
CREATE INDEX IF NOT EXISTS idx_class_invitations_invitee
    ON class_invitations (invitee_id, status, created_at DESC);
CREATE INDEX IF NOT EXISTS idx_class_invitations_class
    ON class_invitations (class_id, status, created_at DESC);

COMMENT ON TABLE class_invitations IS '教师发起的班级邀请；accepted 时写入 class_members';
COMMENT ON COLUMN class_invitations.expires_at IS '过期后由读取/应答路径惰性标记为 expired';
