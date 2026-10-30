-- 审计中心：平台敏感操作的统一留痕。
--
-- 设计见 doc/2610303_审计中心设计方案.md 与 总体设计.md §7.6。
-- 审计日志只追加，不提供更新/删除接口；actor 被删除后保留原 actor_id 为空，
-- actor_username/actor_role 作为写入时的快照用于追溯。

CREATE TABLE IF NOT EXISTS audit_logs (
    id BIGSERIAL PRIMARY KEY,
    actor_id INTEGER REFERENCES users(id) ON DELETE SET NULL,
    actor_username VARCHAR(64) NOT NULL DEFAULT '',
    actor_role VARCHAR(20) NOT NULL DEFAULT '',
    action VARCHAR(64) NOT NULL,
    target_type VARCHAR(32) NOT NULL,
    target_id BIGINT,
    summary TEXT NOT NULL DEFAULT '',
    before JSONB,
    after JSONB,
    ip VARCHAR(64),
    user_agent TEXT,
    created_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP
);

-- 默认按时间倒序分页。
CREATE INDEX IF NOT EXISTS idx_audit_logs_created
    ON audit_logs (created_at DESC, id DESC);
CREATE INDEX IF NOT EXISTS idx_audit_logs_actor
    ON audit_logs (actor_id, created_at DESC);
CREATE INDEX IF NOT EXISTS idx_audit_logs_action
    ON audit_logs (action, created_at DESC);
CREATE INDEX IF NOT EXISTS idx_audit_logs_target
    ON audit_logs (target_type, target_id, created_at DESC);

COMMENT ON TABLE audit_logs IS
    '审计日志：只追加；记录操作者、动作、对象、前后值与请求元数据';
COMMENT ON COLUMN audit_logs.actor_username IS
    '写入时的操作者用户名快照；用户被删除后仍可追溯';
COMMENT ON COLUMN audit_logs.action IS
    '动作标识，使用 domain.verb，例如 user.role_change、problem.review';
COMMENT ON COLUMN audit_logs.before IS
    '操作前快照，仅记录可复核的关键字段，不保存完整题面或源码';
COMMENT ON COLUMN audit_logs.after IS
    '操作后快照或结果摘要，不保存完整题面或源码';
