-- 限时赛事站内答题：赛事与比赛实例一对一关联，并保存赛事题目配置。
--
-- 赛事开始时（或首个参赛者进入时）按 official_event_problems 冻结题目快照，
-- 复用排位赛的答题、判题与结算链路；赛事比赛不改变段位分。

ALTER TABLE contests
    ADD COLUMN IF NOT EXISTS official_event_id INTEGER
        REFERENCES official_events(id) ON DELETE CASCADE;

CREATE UNIQUE INDEX IF NOT EXISTS idx_contests_official_event
    ON contests (official_event_id)
    WHERE official_event_id IS NOT NULL;

COMMENT ON COLUMN contests.official_event_id IS
    '非空表示该场比赛由限时赛事生成；赛事比赛不参与段位分结算';

CREATE TABLE IF NOT EXISTS official_event_problems (
    event_id INTEGER NOT NULL REFERENCES official_events(id) ON DELETE CASCADE,
    problem_id INTEGER NOT NULL REFERENCES problems(id) ON DELETE RESTRICT,
    position INTEGER NOT NULL CHECK (position > 0),
    points INTEGER NOT NULL DEFAULT 100 CHECK (points > 0),
    PRIMARY KEY (event_id, problem_id),
    UNIQUE (event_id, position)
);

CREATE INDEX IF NOT EXISTS idx_official_event_problems_problem
    ON official_event_problems (problem_id);

COMMENT ON TABLE official_event_problems IS
    '赛事题目配置；赛事开始时按顺序冻结为 contest_problems 快照';
