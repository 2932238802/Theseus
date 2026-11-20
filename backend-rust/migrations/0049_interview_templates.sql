-- HR 面模板 Wiki：管理员维护的扁平模板页，保存即生效。
-- 不做软删除；排序由 sort_order 与 id 共同决定。
CREATE TABLE IF NOT EXISTS interview_templates (
    id BIGSERIAL PRIMARY KEY,
    title VARCHAR(120) NOT NULL,
    content_md TEXT NOT NULL,
    sort_order INTEGER NOT NULL DEFAULT 0,
    created_by INTEGER REFERENCES users(id) ON DELETE SET NULL,
    updated_by INTEGER REFERENCES users(id) ON DELETE SET NULL,
    created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT now(),
    CONSTRAINT interview_templates_title_len
        CHECK (char_length(title) BETWEEN 1 AND 120),
    CONSTRAINT interview_templates_content_len
        CHECK (char_length(content_md) BETWEEN 1 AND 20000)
);

CREATE INDEX IF NOT EXISTS idx_interview_templates_order
    ON interview_templates (sort_order, id);

COMMENT ON TABLE interview_templates IS
    'HR 面模板 Wiki：标题 + Markdown 正文，按 sort_order 排序';
COMMENT ON COLUMN interview_templates.sort_order IS
    '拖拽排序后的位置，列表按 (sort_order, id) 升序';
