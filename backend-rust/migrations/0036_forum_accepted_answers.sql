ALTER TABLE forum_posts
    ADD COLUMN IF NOT EXISTS accepted_comment_id BIGINT;

ALTER TABLE forum_posts
    ADD CONSTRAINT forum_posts_accepted_comment_fk
        FOREIGN KEY (accepted_comment_id) REFERENCES forum_comments(id) ON DELETE SET NULL;

CREATE INDEX IF NOT EXISTS idx_forum_posts_accepted_comment
    ON forum_posts (accepted_comment_id)
    WHERE accepted_comment_id IS NOT NULL;
