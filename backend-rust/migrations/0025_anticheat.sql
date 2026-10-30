-- 防作弊 M2：代码相似度扫描、作弊报告、教师复核与学生申诉。
--
-- 设计见 doc/2610301_防作弊代码相似度设计方案.md 与 总体设计.md §4.7。
-- 服务端只在作业范围内做同题、同语言比对；报告必须经教师人工复核，
-- 相似度本身不自动处分。确认后教师可选择把该题作业判零，申诉由处理人裁定。

CREATE TABLE IF NOT EXISTS submission_signals (
    id BIGSERIAL PRIMARY KEY,
    submission_id INTEGER NOT NULL REFERENCES submissions(id) ON DELETE CASCADE,
    signal_type VARCHAR(40) NOT NULL,
    value JSONB NOT NULL DEFAULT '{}'::jsonb,
    source VARCHAR(20) NOT NULL DEFAULT 'server'
        CHECK (source IN ('server', 'client')),
    created_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX IF NOT EXISTS idx_submission_signals_submission
    ON submission_signals (submission_id, created_at DESC);
-- 每次提交只扫描一次；worker 重投时用这个唯一约束做幂等。
CREATE UNIQUE INDEX IF NOT EXISTS idx_submission_signals_scan_once
    ON submission_signals (submission_id)
    WHERE signal_type = 'scan_completed';

COMMENT ON TABLE submission_signals IS
    '提交相关信号；source=server 由扫描器写入，source=client 预留给前端行为信号';
COMMENT ON COLUMN submission_signals.signal_type IS
    'scan_completed 表示相似度扫描已完成；后续可扩展 paste/focus 等行为信号';

CREATE TABLE IF NOT EXISTS similarity_pairs (
    id BIGSERIAL PRIMARY KEY,
    submission_a INTEGER NOT NULL REFERENCES submissions(id) ON DELETE CASCADE,
    submission_b INTEGER NOT NULL REFERENCES submissions(id) ON DELETE CASCADE,
    problem_id INTEGER NOT NULL REFERENCES problems(id) ON DELETE CASCADE,
    assignment_id INTEGER REFERENCES assignments(id) ON DELETE CASCADE,
    algorithm VARCHAR(32) NOT NULL DEFAULT 'winnowing-token',
    score NUMERIC(5, 4) NOT NULL CHECK (score >= 0 AND score <= 1),
    detail JSONB NOT NULL DEFAULT '{}'::jsonb,
    created_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CHECK (submission_a < submission_b)
);

-- 同一对提交、同一算法只保留一条，扫描重投时幂等。
CREATE UNIQUE INDEX IF NOT EXISTS idx_similarity_pairs_unique
    ON similarity_pairs (submission_a, submission_b, algorithm);
CREATE INDEX IF NOT EXISTS idx_similarity_pairs_assignment_score
    ON similarity_pairs (assignment_id, score DESC, created_at DESC);
CREATE INDEX IF NOT EXISTS idx_similarity_pairs_submission_b
    ON similarity_pairs (submission_b, score DESC);

COMMENT ON TABLE similarity_pairs IS
    '代码相似度比对结果；submission_a < submission_b 保证同一对只存一次';
COMMENT ON COLUMN similarity_pairs.detail IS
    '匹配片段、指纹数量、containment/jaccard 等可复核证据，不保存完整源码';

CREATE TABLE IF NOT EXISTS cheat_reports (
    id BIGSERIAL PRIMARY KEY,
    target_user_id INTEGER NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    submission_id INTEGER NOT NULL REFERENCES submissions(id) ON DELETE CASCADE,
    assignment_id INTEGER REFERENCES assignments(id) ON DELETE CASCADE,
    problem_id INTEGER NOT NULL REFERENCES problems(id) ON DELETE CASCADE,
    severity VARCHAR(10) NOT NULL CHECK (severity IN ('low', 'medium', 'high')),
    score NUMERIC(5, 4) NOT NULL CHECK (score >= 0 AND score <= 1),
    matched_submission_id INTEGER REFERENCES submissions(id) ON DELETE SET NULL,
    matched_user_id INTEGER REFERENCES users(id) ON DELETE SET NULL,
    status VARCHAR(20) NOT NULL DEFAULT 'open'
        CHECK (status IN (
            'open', 'reviewing', 'confirmed', 'dismissed',
            'appealed', 'upheld', 'overturned', 'auto_closed'
        )),
    evidence JSONB NOT NULL DEFAULT '{}'::jsonb,
    reviewer_id INTEGER REFERENCES users(id) ON DELETE SET NULL,
    decision_note TEXT,
    decided_at TIMESTAMPTZ,
    penalty_applied_at TIMESTAMPTZ,
    penalty_before JSONB,
    created_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    UNIQUE (submission_id)
);

CREATE INDEX IF NOT EXISTS idx_cheat_reports_assignment
    ON cheat_reports (assignment_id, status, created_at DESC);
CREATE INDEX IF NOT EXISTS idx_cheat_reports_target
    ON cheat_reports (target_user_id, created_at DESC);
CREATE INDEX IF NOT EXISTS idx_cheat_reports_reviewer
    ON cheat_reports (reviewer_id, status, created_at DESC);

COMMENT ON TABLE cheat_reports IS
    '相似度超阈值的作弊报告；一名学生的同一次提交只生成一条报告';
COMMENT ON COLUMN cheat_reports.status IS
    'open→confirmed/dismissed；确认后学生可申诉，appealed→upheld/overturned';
COMMENT ON COLUMN cheat_reports.penalty_before IS
    '确认判零前该题的人工分记录，申诉翻案时用于恢复原成绩';

CREATE TABLE IF NOT EXISTS appeals (
    id BIGSERIAL PRIMARY KEY,
    report_id BIGINT NOT NULL REFERENCES cheat_reports(id) ON DELETE CASCADE,
    user_id INTEGER NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    reason TEXT NOT NULL CHECK (length(btrim(reason)) > 0),
    status VARCHAR(20) NOT NULL DEFAULT 'pending'
        CHECK (status IN ('pending', 'upheld', 'overturned')),
    handled_by INTEGER REFERENCES users(id) ON DELETE SET NULL,
    handle_note TEXT,
    handled_at TIMESTAMPTZ,
    created_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    UNIQUE (report_id)
);

CREATE INDEX IF NOT EXISTS idx_appeals_status
    ON appeals (status, created_at DESC);
CREATE INDEX IF NOT EXISTS idx_appeals_user
    ON appeals (user_id, created_at DESC);

COMMENT ON TABLE appeals IS
    '学生对已确认作弊报告的一次申诉；由该报告的处理人（reviewer_id）裁定';

CREATE TABLE IF NOT EXISTS cheat_report_actions (
    id BIGSERIAL PRIMARY KEY,
    report_id BIGINT NOT NULL REFERENCES cheat_reports(id) ON DELETE CASCADE,
    actor_id INTEGER REFERENCES users(id) ON DELETE SET NULL,
    action VARCHAR(30) NOT NULL,
    note TEXT,
    created_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX IF NOT EXISTS idx_cheat_report_actions_report
    ON cheat_report_actions (report_id, created_at DESC);

COMMENT ON TABLE cheat_report_actions IS
    '报告审计轨迹：created/reviewed/appealed/upheld/overturned/penalty_restored';
