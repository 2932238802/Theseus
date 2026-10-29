-- 跨设备草稿：每个用户、题目、语言只保留最新一份

CREATE TABLE IF NOT EXISTS problem_drafts (
    user_id INTEGER NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    problem_id INTEGER NOT NULL REFERENCES problems(id) ON DELETE CASCADE,
    language VARCHAR(20) NOT NULL,
    code TEXT NOT NULL,
    updated_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (user_id, problem_id, language)
);

CREATE INDEX IF NOT EXISTS idx_problem_drafts_user_updated
    ON problem_drafts (user_id, updated_at DESC);
