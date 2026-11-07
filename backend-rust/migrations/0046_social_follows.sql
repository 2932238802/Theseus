CREATE TABLE IF NOT EXISTS user_follows (
    follower_id INTEGER NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    following_id INTEGER NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    created_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (follower_id, following_id),
    CHECK (follower_id <> following_id)
);

CREATE INDEX IF NOT EXISTS idx_user_follows_following
    ON user_follows (following_id, created_at DESC);

COMMENT ON TABLE user_follows IS '用户关注关系，用于论坛动态筛选';

ALTER TABLE users
    ADD COLUMN IF NOT EXISTS hide_activity_from_social BOOLEAN NOT NULL DEFAULT FALSE;

COMMENT ON COLUMN users.hide_activity_from_social IS
    '开启后，该用户的帖子不再出现在关注者与同组织的动态流中';
