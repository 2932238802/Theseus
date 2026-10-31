-- 学习专区统一为面经：历史 408 内容并入面经。
UPDATE knowledge_articles
SET category = 'interview',
    updated_at = CURRENT_TIMESTAMP
WHERE category = '408';

ALTER TABLE knowledge_articles
    DROP CONSTRAINT IF EXISTS knowledge_articles_category_check;

ALTER TABLE knowledge_articles
    ADD CONSTRAINT knowledge_articles_category_check CHECK (category = 'interview');

ALTER TABLE knowledge_articles
    ALTER COLUMN category SET DEFAULT 'interview';
