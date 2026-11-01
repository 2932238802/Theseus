-- 错题本移除记录：题目通过后自动从错题本消失；
-- 移出后若又出现新的失败提交（晚于 dismissed_at），会重新出现在错题本里。

CREATE TABLE IF NOT EXISTS wrong_problem_dismissals (
    user_id INTEGER NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    problem_id INTEGER NOT NULL REFERENCES problems(id) ON DELETE CASCADE,
    dismissed_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (user_id, problem_id)
);
