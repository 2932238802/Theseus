-- 面经并入论坛：forum_posts 增加板块与面试时间，历史面经迁入 interview 板块。
ALTER TABLE forum_posts
    ADD COLUMN IF NOT EXISTS board VARCHAR(20) NOT NULL DEFAULT 'general';

ALTER TABLE forum_posts
    ADD COLUMN IF NOT EXISTS interview_date VARCHAR(7);

ALTER TABLE forum_posts
    DROP CONSTRAINT IF EXISTS forum_posts_board_check;

ALTER TABLE forum_posts
    ADD CONSTRAINT forum_posts_board_check
    CHECK (board IN ('general', 'interview'));

ALTER TABLE forum_posts
    DROP CONSTRAINT IF EXISTS forum_posts_interview_date_check;

ALTER TABLE forum_posts
    ADD CONSTRAINT forum_posts_interview_date_check
    CHECK (
        interview_date IS NULL
        OR interview_date ~ '^[0-9]{4}-(0[1-9]|1[0-2])$'
    );

-- 综合板块仍限制 3 个标签；面经板块允许 8 个，由服务层按板块校验。
ALTER TABLE forum_posts
    DROP CONSTRAINT IF EXISTS forum_posts_tags_check;

ALTER TABLE forum_posts
    ADD CONSTRAINT forum_posts_tags_check
    CHECK (cardinality(tags) BETWEEN 1 AND 8);

CREATE INDEX IF NOT EXISTS idx_forum_posts_board_feed
    ON forum_posts (board, status, is_pinned DESC, created_at DESC);

-- 历史已通过面经迁入论坛；无作者时归到最早的管理员，没有管理员则跳过。
WITH fallback_admin AS (
    SELECT id FROM users WHERE role = 'admin' ORDER BY id LIMIT 1
)
INSERT INTO forum_posts (
    author_id,
    board,
    title,
    body_md,
    tags,
    status,
    interview_date,
    created_at,
    updated_at
)
SELECT DISTINCT ON (ka.title)
    COALESCE(ka.author_id, (SELECT id FROM fallback_admin)),
    'interview',
    ka.title,
    ka.content,
    CASE
        WHEN cardinality(ka.tags) = 0 THEN ARRAY['面经']::text[]
        ELSE ka.tags[1:8]
    END,
    'published',
    ka.interview_date,
    ka.created_at,
    ka.updated_at
FROM knowledge_articles ka
WHERE ka.status = 'approved'
  AND COALESCE(ka.author_id, (SELECT id FROM fallback_admin)) IS NOT NULL
  AND NOT EXISTS (
      SELECT 1 FROM forum_posts fp
      WHERE fp.board = 'interview' AND fp.title = ka.title
  )
ORDER BY ka.title, ka.id;
