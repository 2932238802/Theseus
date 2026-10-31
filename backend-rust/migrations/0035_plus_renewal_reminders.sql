ALTER TABLE plus_applications
    ADD COLUMN IF NOT EXISTS kind VARCHAR(20) NOT NULL DEFAULT 'new';

ALTER TABLE plus_applications
    ADD CONSTRAINT plus_applications_kind_check CHECK (kind IN ('new', 'renewal'));

CREATE TABLE IF NOT EXISTS plus_expiry_notices (
    user_id INTEGER NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    expires_at TIMESTAMPTZ NOT NULL,
    days_left INTEGER NOT NULL CHECK (days_left IN (1, 3, 7)),
    sent_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (user_id, expires_at, days_left)
);
