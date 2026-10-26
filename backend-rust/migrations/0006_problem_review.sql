-- Problem review trail and admin/teacher listing support.

ALTER TABLE problems
    ADD COLUMN IF NOT EXISTS review_note TEXT,
    ADD COLUMN IF NOT EXISTS reviewed_by INTEGER REFERENCES users(id) ON DELETE SET NULL,
    ADD COLUMN IF NOT EXISTS reviewed_at TIMESTAMPTZ;

CREATE INDEX IF NOT EXISTS idx_problems_review_queue
    ON problems (review_status, created_at DESC);

CREATE INDEX IF NOT EXISTS idx_problems_created_by
    ON problems (created_by, created_at DESC);

COMMENT ON COLUMN problems.review_note IS '管理员审核意见；通过时可为空，拒绝时应说明原因';
COMMENT ON COLUMN problems.reviewed_by IS '最近一次审核的管理员';
COMMENT ON COLUMN problems.reviewed_at IS '最近一次审核时间';
