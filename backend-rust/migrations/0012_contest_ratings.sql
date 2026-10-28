-- Ranked rating for contests. New players start at 1000; matching only groups
-- players whose rating spread fits inside a fixed window (fairness over speed).
ALTER TABLE users
    ADD COLUMN IF NOT EXISTS contest_rating INTEGER NOT NULL DEFAULT 1000
        CHECK (contest_rating >= 0);

COMMENT ON COLUMN users.contest_rating IS
    '排位段位分，默认 1000，无上限，扣分最低为 0';

ALTER TABLE contest_participants
    ADD COLUMN IF NOT EXISTS rating_before INTEGER,
    ADD COLUMN IF NOT EXISTS rating_after INTEGER,
    ADD COLUMN IF NOT EXISTS rating_delta INTEGER;

COMMENT ON COLUMN contest_participants.rating_before IS
    '成局时的段位分快照；结算后 rating_after/rating_delta 记录本场变化';
