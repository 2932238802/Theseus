-- 面经增加面试类型：技术面 / HR 面 / 算法面 / 主管面。
-- 仅面经板块允许写入；综合板块保持 NULL。
ALTER TABLE forum_posts
    ADD COLUMN IF NOT EXISTS interview_type VARCHAR(20);

ALTER TABLE forum_posts
    DROP CONSTRAINT IF EXISTS forum_posts_interview_type_check;

ALTER TABLE forum_posts
    ADD CONSTRAINT forum_posts_interview_type_check
    CHECK (
        interview_type IS NULL
        OR (
            board = 'interview'
            AND interview_type IN ('technical', 'hr', 'algorithm', 'manager')
        )
    );

CREATE INDEX IF NOT EXISTS idx_forum_posts_interview_type
    ON forum_posts (interview_type)
    WHERE board = 'interview';

COMMENT ON COLUMN forum_posts.interview_type IS
    '面试类型：technical / hr / algorithm / manager；仅 board = interview 时有值';
