-- 作业成绩申诉：成绩发布后，学生对整份作业的成绩提交一次申诉。
-- 教师受理或驳回并填写说明，结果写站内信。
-- 受理不会自动改分，改分仍走批改台，由现有 grade.* 审计记录留痕。

CREATE TABLE IF NOT EXISTS assignment_grade_appeals (
    id BIGSERIAL PRIMARY KEY,
    assignment_id INTEGER NOT NULL REFERENCES assignments(id) ON DELETE CASCADE,
    user_id INTEGER NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    reason TEXT NOT NULL CHECK (length(btrim(reason)) > 0),
    status VARCHAR(20) NOT NULL DEFAULT 'pending'
        CHECK (status IN ('pending', 'accepted', 'rejected')),
    handled_by INTEGER REFERENCES users(id) ON DELETE SET NULL,
    handle_note TEXT,
    handled_at TIMESTAMPTZ,
    created_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    UNIQUE (assignment_id, user_id)
);

CREATE INDEX IF NOT EXISTS idx_assignment_grade_appeals_assignment
    ON assignment_grade_appeals (assignment_id, status, created_at DESC);
CREATE INDEX IF NOT EXISTS idx_assignment_grade_appeals_user
    ON assignment_grade_appeals (user_id, created_at DESC);

COMMENT ON TABLE assignment_grade_appeals IS
    '学生对作业成绩的一次申诉；每份作业每人最多一条';
COMMENT ON COLUMN assignment_grade_appeals.status IS
    'pending→accepted/rejected；受理只记录结论，改分仍走批改台并写审计';
