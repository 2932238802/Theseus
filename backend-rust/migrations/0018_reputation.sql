-- 信誉分与作弊复核工作流：
-- 1. 复核记录按管理员负载自动分配，管理员可滞后处理
-- 2. 确认作弊后固定扣 25 分、取消该场成绩并重新结算排名
-- 3. 信誉分每日签到恢复 0.1 分，其余只能由管理员定量恢复
-- 4. 信誉分低于 0 时封号并把邮箱加入黑名单，管理员恢复后可解除

ALTER TABLE users
    ADD COLUMN IF NOT EXISTS reputation_score NUMERIC(6, 1) NOT NULL DEFAULT 100.0;

ALTER TABLE users DROP CONSTRAINT IF EXISTS users_status_check;
ALTER TABLE users ADD CONSTRAINT users_status_check
    CHECK (status IN ('active', 'disabled', 'deleted', 'banned'));

COMMENT ON COLUMN users.reputation_score IS
    '信誉分，默认 100；确认作弊固定扣 25；每日签到加 0.1，其余只能由管理员恢复';
COMMENT ON COLUMN users.status IS
    'active 正常；disabled 管理员禁用；deleted 用户已注销；banned 信誉分低于 0 自动封禁';

CREATE TABLE IF NOT EXISTS reputation_events (
    id BIGSERIAL PRIMARY KEY,
    user_id INTEGER NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    delta NUMERIC(6, 1) NOT NULL,
    score_before NUMERIC(6, 1) NOT NULL,
    score_after NUMERIC(6, 1) NOT NULL,
    reason VARCHAR(32) NOT NULL
        CHECK (reason IN ('paste_cheating', 'daily_checkin', 'admin_restore')),
    proctor_event_id BIGINT REFERENCES contest_events(id) ON DELETE SET NULL,
    contest_id INTEGER REFERENCES contests(id) ON DELETE SET NULL,
    actor_id INTEGER REFERENCES users(id) ON DELETE SET NULL,
    note TEXT,
    created_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE UNIQUE INDEX IF NOT EXISTS idx_reputation_events_proctor
    ON reputation_events (proctor_event_id)
    WHERE proctor_event_id IS NOT NULL;
CREATE INDEX IF NOT EXISTS idx_reputation_events_user
    ON reputation_events (user_id, created_at DESC);

CREATE TABLE IF NOT EXISTS reputation_checkins (
    user_id INTEGER NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    checkin_date DATE NOT NULL,
    created_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (user_id, checkin_date)
);

CREATE TABLE IF NOT EXISTS email_blacklist (
    id BIGSERIAL PRIMARY KEY,
    email VARCHAR(100) NOT NULL,
    user_id INTEGER REFERENCES users(id) ON DELETE SET NULL,
    reason TEXT,
    created_by INTEGER REFERENCES users(id) ON DELETE SET NULL,
    created_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    exempted_at TIMESTAMPTZ,
    exempted_by INTEGER REFERENCES users(id) ON DELETE SET NULL
);

CREATE UNIQUE INDEX IF NOT EXISTS idx_email_blacklist_active
    ON email_blacklist (LOWER(email))
    WHERE exempted_at IS NULL;

CREATE TABLE IF NOT EXISTS contest_proctor_assignments (
    event_id BIGINT PRIMARY KEY REFERENCES contest_events(id) ON DELETE CASCADE,
    assigned_admin_id INTEGER NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    assigned_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX IF NOT EXISTS idx_proctor_assignments_admin
    ON contest_proctor_assignments (assigned_admin_id);

ALTER TABLE contest_event_reviews
    ADD COLUMN IF NOT EXISTS penalty_applied_at TIMESTAMPTZ;

ALTER TABLE contest_participants
    ADD COLUMN IF NOT EXISTS disqualified_at TIMESTAMPTZ,
    ADD COLUMN IF NOT EXISTS disqualified_by INTEGER REFERENCES users(id) ON DELETE SET NULL,
    ADD COLUMN IF NOT EXISTS disqualify_reason TEXT;

COMMENT ON TABLE contest_proctor_assignments IS
    '粘贴复核事件的管理员分配，按待复核数量最少优先';
COMMENT ON COLUMN contest_event_reviews.penalty_applied_at IS
    '确认作弊并实际扣分的时间，用于保证同一事件只处罚一次';
COMMENT ON COLUMN contest_participants.disqualified_at IS
    '被取消成绩的时间；重新结算时排除该参与者';
