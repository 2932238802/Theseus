ALTER TABLE forum_posts
    ADD COLUMN IF NOT EXISTS company VARCHAR(40),
    ADD COLUMN IF NOT EXISTS role VARCHAR(40),
    ADD COLUMN IF NOT EXISTS view_count INTEGER NOT NULL DEFAULT 0;

ALTER TABLE forum_posts
    ADD CONSTRAINT forum_posts_company_len
        CHECK (company IS NULL OR char_length(company) BETWEEN 1 AND 40),
    ADD CONSTRAINT forum_posts_role_len
        CHECK (role IS NULL OR char_length(role) BETWEEN 1 AND 40);

CREATE INDEX IF NOT EXISTS idx_forum_posts_interview_company
    ON forum_posts (company)
    WHERE board = 'interview';

CREATE INDEX IF NOT EXISTS idx_forum_posts_interview_role
    ON forum_posts (role)
    WHERE board = 'interview';
