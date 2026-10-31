-- 面经增加面试时间（YYYY-MM），用于列表与详情展示。
ALTER TABLE knowledge_articles
    ADD COLUMN IF NOT EXISTS interview_date VARCHAR(7);

ALTER TABLE knowledge_articles
    DROP CONSTRAINT IF EXISTS knowledge_articles_interview_date_check;

ALTER TABLE knowledge_articles
    ADD CONSTRAINT knowledge_articles_interview_date_check
    CHECK (
        interview_date IS NULL
        OR interview_date ~ '^[0-9]{4}-(0[1-9]|1[0-2])$'
    );
