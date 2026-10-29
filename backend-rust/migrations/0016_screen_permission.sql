ALTER TABLE contest_queue
    ADD COLUMN IF NOT EXISTS screen_permission VARCHAR(20);

ALTER TABLE contest_participants
    ADD COLUMN IF NOT EXISTS screen_permission VARCHAR(20);
