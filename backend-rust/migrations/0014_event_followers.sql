-- 赛事关注：用于全部赛事页的「我的关注」筛选，后续可接入开赛提醒。
CREATE TABLE IF NOT EXISTS official_event_followers (
    event_id INTEGER NOT NULL REFERENCES official_events(id) ON DELETE CASCADE,
    user_id INTEGER NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    created_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (event_id, user_id)
);

CREATE INDEX IF NOT EXISTS idx_official_event_followers_user
    ON official_event_followers (user_id, created_at DESC);

COMMENT ON TABLE official_event_followers IS
    '用户关注的赛事；只影响列表筛选与后续提醒，不影响报名资格';
