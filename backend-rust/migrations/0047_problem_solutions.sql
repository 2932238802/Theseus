-- 一题多解：同一用户同一道题最多保留 5 份解法
-- 每份解法独立保存名称、语言与代码；slot 只用于稳定排序与并发占位

CREATE TABLE IF NOT EXISTS problem_solutions (
    id SERIAL PRIMARY KEY,
    user_id INTEGER NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    problem_id INTEGER NOT NULL REFERENCES problems(id) ON DELETE CASCADE,
    slot SMALLINT NOT NULL CHECK (slot BETWEEN 1 AND 5),
    name VARCHAR(60) NOT NULL,
    language VARCHAR(20) NOT NULL CHECK (language IN ('cpp', 'java', 'python', 'javascript')),
    code TEXT NOT NULL DEFAULT '',
    created_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    UNIQUE (user_id, problem_id, slot)
);

CREATE INDEX IF NOT EXISTS idx_problem_solutions_user_problem
    ON problem_solutions (user_id, problem_id, updated_at DESC);

-- 旧的按语言草稿按更新时间折叠为解法，最多保留 5 份
INSERT INTO problem_solutions (user_id, problem_id, slot, name, language, code, created_at, updated_at)
SELECT user_id,
       problem_id,
       ranked.slot::smallint,
       '解法 ' || ranked.slot,
       language,
       code,
       updated_at,
       updated_at
FROM (
    SELECT d.user_id,
           d.problem_id,
           d.language,
           d.code,
           d.updated_at,
           ROW_NUMBER() OVER (
               PARTITION BY d.user_id, d.problem_id
               ORDER BY d.updated_at DESC, d.language
           ) AS slot
    FROM problem_drafts d
    WHERE d.language IN ('cpp', 'java', 'python', 'javascript')
) ranked
WHERE ranked.slot <= 5
ON CONFLICT (user_id, problem_id, slot) DO NOTHING;

-- 提交可关联到某一解法；删除解法时保留提交历史
ALTER TABLE submissions
    ADD COLUMN IF NOT EXISTS solution_id INTEGER REFERENCES problem_solutions(id) ON DELETE SET NULL;

CREATE INDEX IF NOT EXISTS idx_submissions_solution
    ON submissions (solution_id, submitted_at DESC)
    WHERE solution_id IS NOT NULL;

COMMENT ON TABLE problem_solutions IS '一题多解：每个用户每道题最多 5 份解法草稿';
COMMENT ON TABLE problem_drafts IS '已废弃：跨设备草稿迁移至 problem_solutions';
