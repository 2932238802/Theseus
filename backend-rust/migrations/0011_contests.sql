-- Multiplayer ranked contests (v1): FIFO matchmaking, frozen problem sets,
-- per-participant scoring, proctoring events, and official events.

CREATE TABLE IF NOT EXISTS contests (
    id SERIAL PRIMARY KEY,
    status VARCHAR(20) NOT NULL DEFAULT 'running'
        CHECK (status IN ('matching', 'running', 'settling', 'finished', 'cancelled')),
    duration_seconds INTEGER NOT NULL CHECK (duration_seconds > 0),
    problem_count INTEGER NOT NULL CHECK (problem_count > 0),
    solve_weight DOUBLE PRECISION NOT NULL DEFAULT 0.60,
    speed_weight DOUBLE PRECISION NOT NULL DEFAULT 0.25,
    coding_weight DOUBLE PRECISION NOT NULL DEFAULT 0.15,
    starts_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    ends_at TIMESTAMPTZ NOT NULL,
    finished_at TIMESTAMPTZ,
    created_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CHECK (ends_at > starts_at)
);

CREATE INDEX IF NOT EXISTS idx_contests_status_end
    ON contests (status, ends_at);

COMMENT ON COLUMN contests.status IS
    'matching 组队中（v1 同步成局，一般不落库）；running 进行中；settling 结算中；finished/cancelled 终态';
COMMENT ON COLUMN contests.solve_weight IS '通过题数权重，默认 0.60';
COMMENT ON COLUMN contests.speed_weight IS '完成速度权重，默认 0.25';
COMMENT ON COLUMN contests.coding_weight IS '代码书写权重，默认 0.15';

CREATE TABLE IF NOT EXISTS contest_problems (
    contest_id INTEGER NOT NULL REFERENCES contests(id) ON DELETE CASCADE,
    problem_id INTEGER NOT NULL REFERENCES problems(id) ON DELETE RESTRICT,
    position INTEGER NOT NULL,
    points INTEGER NOT NULL DEFAULT 100 CHECK (points > 0),
    title VARCHAR(200) NOT NULL,
    difficulty VARCHAR(20) NOT NULL,
    description TEXT NOT NULL,
    time_limit INTEGER NOT NULL,
    memory_limit INTEGER NOT NULL,
    tags TEXT[] NOT NULL DEFAULT '{}',
    examples JSONB NOT NULL DEFAULT '[]'::jsonb,
    code_template JSONB NOT NULL DEFAULT '{}'::jsonb,
    run_config JSONB NOT NULL,
    judge_cases JSONB,
    PRIMARY KEY (contest_id, problem_id),
    UNIQUE (contest_id, position)
);

CREATE INDEX IF NOT EXISTS idx_contest_problems_problem
    ON contest_problems (problem_id);

COMMENT ON TABLE contest_problems IS
    '比赛创建时的题目快照；比赛期间题目被编辑不影响本场判题';

CREATE TABLE IF NOT EXISTS contest_participants (
    contest_id INTEGER NOT NULL REFERENCES contests(id) ON DELETE CASCADE,
    user_id INTEGER NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    status VARCHAR(20) NOT NULL DEFAULT 'active'
        CHECK (status IN ('queued', 'active', 'finished')),
    camera_permission VARCHAR(20),
    joined_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    finished_at TIMESTAMPTZ,
    total_score DOUBLE PRECISION,
    rank INTEGER,
    solved_count INTEGER NOT NULL DEFAULT 0,
    speed_score DOUBLE PRECISION NOT NULL DEFAULT 0,
    coding_score DOUBLE PRECISION NOT NULL DEFAULT 100,
    last_accepted_at TIMESTAMPTZ,
    detail JSONB,
    PRIMARY KEY (contest_id, user_id)
);

CREATE INDEX IF NOT EXISTS idx_contest_participants_user
    ON contest_participants (user_id, contest_id);

CREATE TABLE IF NOT EXISTS contest_queue (
    user_id INTEGER PRIMARY KEY REFERENCES users(id) ON DELETE CASCADE,
    joined_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    camera_permission VARCHAR(20)
);

CREATE INDEX IF NOT EXISTS idx_contest_queue_joined
    ON contest_queue (joined_at, user_id);

CREATE TABLE IF NOT EXISTS contest_events (
    id BIGSERIAL PRIMARY KEY,
    contest_id INTEGER NOT NULL REFERENCES contests(id) ON DELETE CASCADE,
    user_id INTEGER NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    event_id VARCHAR(64) NOT NULL,
    event_type VARCHAR(40) NOT NULL,
    payload JSONB NOT NULL DEFAULT '{}'::jsonb,
    client_time TIMESTAMPTZ,
    received_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    session_id VARCHAR(64),
    UNIQUE (contest_id, user_id, event_id)
);

CREATE INDEX IF NOT EXISTS idx_contest_events_lookup
    ON contest_events (contest_id, user_id, received_at DESC);

COMMENT ON TABLE contest_events IS
    '防作弊行为审计：只记录，不自动处罚。event_id 由客户端生成，保证重试幂等';

ALTER TABLE submissions
    ADD COLUMN IF NOT EXISTS contest_id INTEGER
        REFERENCES contests(id) ON DELETE SET NULL;

CREATE INDEX IF NOT EXISTS idx_submissions_contest
    ON submissions (contest_id, user_id, problem_id, status)
    WHERE contest_id IS NOT NULL;

COMMENT ON COLUMN submissions.contest_id IS
    '非空表示该提交属于一场比赛，结算时只统计比赛时间窗内的提交';

-- 官方赛事（v1）：独立于排位匹配，可同步为论坛公告帖并置顶。
CREATE TABLE IF NOT EXISTS official_events (
    id SERIAL PRIMARY KEY,
    title VARCHAR(200) NOT NULL,
    organizer VARCHAR(100) NOT NULL,
    description TEXT,
    registration_url VARCHAR(500),
    registration_opens_at TIMESTAMPTZ,
    registration_closes_at TIMESTAMPTZ,
    starts_at TIMESTAMPTZ NOT NULL,
    ends_at TIMESTAMPTZ NOT NULL,
    status VARCHAR(20) NOT NULL DEFAULT 'draft'
        CHECK (status IN ('draft', 'published', 'cancelled')),
    forum_post_id BIGINT REFERENCES forum_posts(id) ON DELETE SET NULL,
    pinned_until TIMESTAMPTZ,
    created_by INTEGER REFERENCES users(id) ON DELETE SET NULL,
    created_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CHECK (ends_at > starts_at),
    CHECK (length(btrim(title)) > 0)
);

CREATE INDEX IF NOT EXISTS idx_official_events_active
    ON official_events (status, starts_at, ends_at);
