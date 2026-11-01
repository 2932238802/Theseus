ALTER TABLE assignments
    ADD COLUMN IF NOT EXISTS ai_assistant_enabled BOOLEAN NOT NULL DEFAULT TRUE;

COMMENT ON COLUMN assignments.ai_assistant_enabled IS
    '是否允许学生在作业提交窗口内使用 AI 助手；仅对 Plus 学生生效';
