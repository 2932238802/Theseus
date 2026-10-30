-- 竞赛收尾：赛季与软重置、用户年级、赛事范围、赛事申诉。
--
-- 设计见 doc/2610304_竞赛收尾设计方案.md。赛季只影响排位赛；限时赛事
-- 的成绩仍然只影响赛事排行榜，不改变段位分。软重置在赛季首次被读取或
-- 匹配时惰性执行一次，保证并发下也只重置一次。

CREATE TABLE IF NOT EXISTS seasons (
    id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL CHECK (length(btrim(name)) > 0),
    starts_at TIMESTAMPTZ NOT NULL,
    ends_at TIMESTAMPTZ NOT NULL,
    status VARCHAR(20) NOT NULL DEFAULT 'draft'
        CHECK (status IN ('draft', 'published', 'cancelled')),
    soft_reset_ratio NUMERIC(4, 3) NOT NULL DEFAULT 0.500
        CHECK (soft_reset_ratio >= 0 AND soft_reset_ratio <= 1),
    activated_at TIMESTAMPTZ,
    created_by INTEGER REFERENCES users(id) ON DELETE SET NULL,
    created_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CHECK (ends_at > starts_at)
);

CREATE INDEX IF NOT EXISTS idx_seasons_status_time
    ON seasons (status, starts_at, ends_at);

COMMENT ON TABLE seasons IS
    '排位赛季；同一时间只允许一个 published 赛季，激活时对所有活跃学生执行一次软重置';
COMMENT ON COLUMN seasons.soft_reset_ratio IS
    '软重置系数 r：新段位 = 1000 + (旧段位 - 1000) * r，默认 0.5';

ALTER TABLE contests
    ADD COLUMN IF NOT EXISTS season_id INTEGER
        REFERENCES seasons(id) ON DELETE SET NULL;

CREATE INDEX IF NOT EXISTS idx_contests_season
    ON contests (season_id, status)
    WHERE season_id IS NOT NULL;

COMMENT ON COLUMN contests.season_id IS
    '比赛创建时所属赛季快照；为空表示赛前历史数据或未开启赛季';

CREATE TABLE IF NOT EXISTS season_ratings (
    season_id INTEGER NOT NULL REFERENCES seasons(id) ON DELETE CASCADE,
    user_id INTEGER NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    rating INTEGER NOT NULL CHECK (rating >= 0),
    rating_start INTEGER NOT NULL CHECK (rating_start >= 0),
    played INTEGER NOT NULL DEFAULT 0 CHECK (played >= 0),
    wins INTEGER NOT NULL DEFAULT 0 CHECK (wins >= 0),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (season_id, user_id)
);

CREATE INDEX IF NOT EXISTS idx_season_ratings_rank
    ON season_ratings (season_id, rating DESC, wins DESC, played DESC);

COMMENT ON TABLE season_ratings IS
    '赛季段位快照：rating_start 为软重置后的起始分，rating 为该赛季当前分';

ALTER TABLE users
    ADD COLUMN IF NOT EXISTS grade VARCHAR(20);

COMMENT ON COLUMN users.grade IS
    '学生年级，例如「大一」「高一」「2024级」；为空表示未设置';

ALTER TABLE official_events
    ADD COLUMN IF NOT EXISTS grade_scope TEXT[] NOT NULL DEFAULT '{}';

COMMENT ON COLUMN official_events.grade_scope IS
    '允许参加的年级列表；为空表示不限年级，非空时与 users.grade 精确匹配';

CREATE TABLE IF NOT EXISTS contest_appeals (
    id BIGSERIAL PRIMARY KEY,
    contest_id INTEGER NOT NULL REFERENCES contests(id) ON DELETE CASCADE,
    user_id INTEGER NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    proctor_event_id BIGINT REFERENCES contest_events(id) ON DELETE SET NULL,
    reason TEXT NOT NULL CHECK (length(btrim(reason)) > 0),
    status VARCHAR(20) NOT NULL DEFAULT 'pending'
        CHECK (status IN ('pending', 'accepted', 'rejected')),
    handled_by INTEGER REFERENCES users(id) ON DELETE SET NULL,
    handle_note TEXT,
    handled_at TIMESTAMPTZ,
    created_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    UNIQUE (contest_id, user_id)
);

CREATE INDEX IF NOT EXISTS idx_contest_appeals_status
    ON contest_appeals (status, created_at DESC);
CREATE INDEX IF NOT EXISTS idx_contest_appeals_user
    ON contest_appeals (user_id, created_at DESC);

COMMENT ON TABLE contest_appeals IS
    '赛事成绩申诉：每名学生每场比赛只能提交一次，由管理员裁定';
COMMENT ON COLUMN contest_appeals.proctor_event_id IS
    '因粘贴作弊被取消成绩时关联的监考事件；申诉成立时用于恢复信誉分和排名';
