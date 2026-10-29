-- 统一个人收藏：题目复用旧表 favorites，评论新增收藏表

CREATE TABLE IF NOT EXISTS forum_comment_favorites (
    comment_id BIGINT NOT NULL REFERENCES forum_comments(id) ON DELETE CASCADE,
    user_id INTEGER NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    created_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (comment_id, user_id)
);

CREATE INDEX IF NOT EXISTS idx_forum_comment_favorites_user
    ON forum_comment_favorites (user_id, created_at DESC);

CREATE INDEX IF NOT EXISTS idx_favorites_user_created
    ON favorites (user_id, created_at DESC);
