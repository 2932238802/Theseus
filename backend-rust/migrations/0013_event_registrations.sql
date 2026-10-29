-- 限时赛事（v1 扩展）：在 official_events 上补齐首页卡片需要的字段，
-- 并新增报名记录表。赛事类型、公开范围、名额和报名方式都由后端驱动，
-- 前端不再写死赛事列表或规则文案。

ALTER TABLE official_events
    ADD COLUMN IF NOT EXISTS event_type VARCHAR(20) NOT NULL DEFAULT 'official'
        CHECK (event_type IN ('official', 'teacher', 'school'));

ALTER TABLE official_events
    ADD COLUMN IF NOT EXISTS scope VARCHAR(200);

ALTER TABLE official_events
    ADD COLUMN IF NOT EXISTS capacity INTEGER
        CHECK (capacity IS NULL OR capacity > 0);

ALTER TABLE official_events
    ADD COLUMN IF NOT EXISTS registration_mode VARCHAR(20) NOT NULL DEFAULT 'open'
        CHECK (registration_mode IN ('open', 'invite', 'external'));

ALTER TABLE official_events
    ADD COLUMN IF NOT EXISTS class_id INTEGER
        REFERENCES classes(id) ON DELETE SET NULL;

ALTER TABLE official_events
    ADD COLUMN IF NOT EXISTS rules JSONB NOT NULL DEFAULT '[]'::jsonb;

COMMENT ON COLUMN official_events.event_type IS
    '赛事类型：official 官方、teacher 老师、school 学校；只用于标签和筛选';
COMMENT ON COLUMN official_events.scope IS
    '参赛范围说明，例如「面向本校学生」「高一（3）班」';
COMMENT ON COLUMN official_events.registration_mode IS
    'open 公开报名、invite 邀请后直接加入、external 通过外部链接报名';
COMMENT ON COLUMN official_events.class_id IS
    '非空表示仅该班级的活跃学生（或班级创建者）可参加';
COMMENT ON COLUMN official_events.rules IS
    '赛事规则分组：[{"title": "...", "items": ["..."]}]，由后端驱动前端展示';

CREATE TABLE IF NOT EXISTS official_event_registrations (
    event_id INTEGER NOT NULL REFERENCES official_events(id) ON DELETE CASCADE,
    user_id INTEGER NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    status VARCHAR(20) NOT NULL DEFAULT 'registered'
        CHECK (status IN ('registered', 'joined', 'cancelled')),
    registered_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (event_id, user_id)
);

CREATE INDEX IF NOT EXISTS idx_official_event_registrations_user
    ON official_event_registrations (user_id, status);

COMMENT ON TABLE official_event_registrations IS
    '赛事报名记录：registered 公开报名、joined 邀请赛事直接加入、cancelled 已取消';
