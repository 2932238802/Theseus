ALTER TABLE contest_queue
    ADD COLUMN IF NOT EXISTS last_seen_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP;

COMMENT ON COLUMN contest_queue.last_seen_at IS
    '排队客户端最近一次心跳；后台 matcher 会清理超时未刷新的队列行';

CREATE INDEX IF NOT EXISTS idx_contest_queue_last_seen
    ON contest_queue (last_seen_at);
