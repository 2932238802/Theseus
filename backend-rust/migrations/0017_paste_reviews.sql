-- 粘贴内容复核：前端在比赛编辑器中比对剪贴板内容与当前代码/题目上下文，
-- 疑似无关的大段粘贴记为 paste_suspicious 事件，由比赛组织者人工判定。
-- 只保存复核结论，不自动处罚；原始事件仍留在 contest_events。

CREATE TABLE IF NOT EXISTS contest_event_reviews (
    event_id BIGINT PRIMARY KEY REFERENCES contest_events(id) ON DELETE CASCADE,
    review_status VARCHAR(20) NOT NULL
        CHECK (review_status IN ('cleared', 'confirmed')),
    reviewed_by INTEGER REFERENCES users(id) ON DELETE SET NULL,
    review_note TEXT,
    reviewed_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX IF NOT EXISTS idx_contest_event_reviews_status
    ON contest_event_reviews (review_status, reviewed_at DESC);

COMMENT ON TABLE contest_event_reviews IS
    '粘贴疑似作弊事件的人工复核结论：cleared 排除，confirmed 确认；未出现在本表的事件视为待复核';
