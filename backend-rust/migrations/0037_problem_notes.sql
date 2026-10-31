-- 题目私有笔记：每个用户、题目只保留一份，空内容保存时删除

CREATE TABLE IF NOT EXISTS problem_notes (
    user_id INTEGER NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    problem_id INTEGER NOT NULL REFERENCES problems(id) ON DELETE CASCADE,
    body_md TEXT NOT NULL,
    created_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (user_id, problem_id)
);

CREATE INDEX IF NOT EXISTS idx_problem_notes_user_updated
    ON problem_notes (user_id, updated_at DESC);
