-- Badge catalog and per-user awards.
-- Phase 1 only ships check-in milestones; the table keeps room for more categories.
CREATE TABLE badge_catalog (
    code TEXT PRIMARY KEY,
    name TEXT NOT NULL,
    description TEXT NOT NULL,
    category TEXT NOT NULL CHECK (category IN ('checkin')),
    threshold_days INTEGER NOT NULL CHECK (threshold_days > 0),
    validity_days INTEGER NOT NULL DEFAULT 30 CHECK (validity_days > 0),
    sort_order INTEGER NOT NULL DEFAULT 0
);

INSERT INTO badge_catalog (code, name, description, category, threshold_days, validity_days, sort_order)
VALUES
    ('checkin_7', '七日精进', '连续签到 7 天', 'checkin', 7, 30, 10),
    ('checkin_30', '月度坚持', '连续签到 30 天', 'checkin', 30, 30, 20),
    ('checkin_100', '百日不辍', '连续签到 100 天', 'checkin', 100, 30, 30)
ON CONFLICT (code) DO NOTHING;

CREATE TABLE user_badges (
    id BIGSERIAL PRIMARY KEY,
    user_id INTEGER NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    badge_code TEXT NOT NULL REFERENCES badge_catalog(code) ON DELETE CASCADE,
    awarded_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    expires_at TIMESTAMPTZ NOT NULL,
    hidden BOOLEAN NOT NULL DEFAULT FALSE,
    UNIQUE (user_id, badge_code)
);

CREATE INDEX user_badges_user_idx ON user_badges (user_id, expires_at);
