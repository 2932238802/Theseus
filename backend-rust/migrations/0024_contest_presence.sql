-- 比赛在线判定与断线重连：记录最后心跳时间，新增 disconnected / timed_out 状态。

ALTER TABLE contest_participants
    ADD COLUMN IF NOT EXISTS last_seen_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    ADD COLUMN IF NOT EXISTS disconnected_at TIMESTAMPTZ,
    ADD COLUMN IF NOT EXISTS timed_out_at TIMESTAMPTZ;

ALTER TABLE contest_participants
    DROP CONSTRAINT IF EXISTS contest_participants_status_check;
ALTER TABLE contest_participants
    ADD CONSTRAINT contest_participants_status_check
    CHECK (status IN ('queued', 'active', 'disconnected', 'finished', 'timed_out'));

CREATE INDEX IF NOT EXISTS idx_contest_participants_presence
    ON contest_participants (contest_id, status, last_seen_at);

COMMENT ON COLUMN contest_participants.last_seen_at IS
    '最后一次心跳时间，用于判断断线与重连宽限';
COMMENT ON COLUMN contest_participants.disconnected_at IS
    '超过 30 秒无心跳、进入重连宽限的时间';
COMMENT ON COLUMN contest_participants.timed_out_at IS
    '重连宽限耗尽、成绩冻结的时间';
