CREATE TABLE IF NOT EXISTS ai_usage (
    user_id INTEGER NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    usage_day DATE NOT NULL DEFAULT CURRENT_DATE,
    message_count INTEGER NOT NULL DEFAULT 0 CHECK (message_count >= 0),
    PRIMARY KEY (user_id, usage_day)
);

CREATE INDEX IF NOT EXISTS idx_ai_usage_day ON ai_usage(usage_day);
