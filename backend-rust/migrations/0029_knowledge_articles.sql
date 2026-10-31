-- 学习专区：408 与面经文章。
-- 内容由 Plus Theseus 用户投稿，管理员审核通过后公开；正文仅 Plus 用户与管理员可读。
CREATE TABLE IF NOT EXISTS knowledge_articles (
    id BIGSERIAL PRIMARY KEY,
    author_id INTEGER REFERENCES users(id) ON DELETE SET NULL,
    category VARCHAR(16) NOT NULL,
    title VARCHAR(160) NOT NULL,
    summary VARCHAR(400) NOT NULL DEFAULT '',
    content TEXT NOT NULL,
    tags TEXT[] NOT NULL DEFAULT '{}',
    status VARCHAR(16) NOT NULL DEFAULT 'pending',
    review_note TEXT,
    reviewed_by INTEGER REFERENCES users(id) ON DELETE SET NULL,
    reviewed_at TIMESTAMPTZ,
    created_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT knowledge_articles_category_check
        CHECK (category IN ('408', 'interview')),
    CONSTRAINT knowledge_articles_status_check
        CHECK (status IN ('pending', 'approved', 'rejected'))
);

CREATE INDEX IF NOT EXISTS idx_knowledge_articles_category
    ON knowledge_articles (category, status, created_at DESC);

CREATE INDEX IF NOT EXISTS idx_knowledge_articles_author
    ON knowledge_articles (author_id, created_at DESC);

CREATE INDEX IF NOT EXISTS idx_knowledge_articles_status
    ON knowledge_articles (status, created_at DESC);

CREATE INDEX IF NOT EXISTS idx_knowledge_articles_tags
    ON knowledge_articles USING GIN (tags);
