-- Assignment policies: late submission, attempts, scoring, visibility,
-- student overrides, solutions, statistics, peer code, and audit trail.

-- 1. Assignment policy fields
ALTER TABLE assignments
    ADD COLUMN IF NOT EXISTS late_policy VARCHAR(20) NOT NULL DEFAULT 'forbid',
    ADD COLUMN IF NOT EXISTS late_grace_hours INTEGER NOT NULL DEFAULT 0,
    ADD COLUMN IF NOT EXISTS late_penalty_per_day INTEGER NOT NULL DEFAULT 10,
    ADD COLUMN IF NOT EXISTS late_penalty_cap INTEGER NOT NULL DEFAULT 50,
    ADD COLUMN IF NOT EXISTS max_attempts INTEGER,
    ADD COLUMN IF NOT EXISTS scoring_policy VARCHAR(20) NOT NULL DEFAULT 'highest',
    ADD COLUMN IF NOT EXISTS score_visibility VARCHAR(20) NOT NULL DEFAULT 'after_publish',
    ADD COLUMN IF NOT EXISTS solutions_published_at TIMESTAMPTZ,
    ADD COLUMN IF NOT EXISTS allow_peer_code BOOLEAN NOT NULL DEFAULT FALSE,
    ADD COLUMN IF NOT EXISTS show_class_stats BOOLEAN NOT NULL DEFAULT FALSE;

ALTER TABLE assignments
    ADD CONSTRAINT assignments_late_policy_check
        CHECK (late_policy IN ('forbid', 'allow')),
    ADD CONSTRAINT assignments_late_grace_hours_check
        CHECK (late_grace_hours >= 0 AND late_grace_hours <= 720),
    ADD CONSTRAINT assignments_late_penalty_per_day_check
        CHECK (late_penalty_per_day >= 0 AND late_penalty_per_day <= 100),
    ADD CONSTRAINT assignments_late_penalty_cap_check
        CHECK (late_penalty_cap >= 0 AND late_penalty_cap <= 100),
    ADD CONSTRAINT assignments_max_attempts_check
        CHECK (max_attempts IS NULL OR (max_attempts > 0 AND max_attempts <= 1000)),
    ADD CONSTRAINT assignments_scoring_policy_check
        CHECK (scoring_policy IN ('highest', 'last', 'first_ac')),
    ADD CONSTRAINT assignments_score_visibility_check
        CHECK (score_visibility IN ('after_publish', 'after_due', 'during'));

-- 2. Per-problem solution and attempt override
ALTER TABLE assignment_problems
    ADD COLUMN IF NOT EXISTS solution_md TEXT,
    ADD COLUMN IF NOT EXISTS max_attempts INTEGER;

ALTER TABLE assignment_problems
    ADD CONSTRAINT assignment_problems_max_attempts_check
        CHECK (max_attempts IS NULL OR (max_attempts > 0 AND max_attempts <= 1000));

-- 3. Late submission snapshot on submissions
ALTER TABLE submissions
    ADD COLUMN IF NOT EXISTS is_late BOOLEAN NOT NULL DEFAULT FALSE,
    ADD COLUMN IF NOT EXISTS late_days INTEGER NOT NULL DEFAULT 0;

ALTER TABLE submissions
    ADD CONSTRAINT submissions_late_days_check
        CHECK (late_days >= 0);

-- 4. Student exceptions: makeup deadline and exemption
CREATE TABLE IF NOT EXISTS assignment_student_overrides (
    id SERIAL PRIMARY KEY,
    assignment_id INTEGER NOT NULL REFERENCES assignments(id) ON DELETE CASCADE,
    user_id INTEGER NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    problem_id INTEGER NOT NULL,
    makeup_due_at TIMESTAMPTZ,
    waive_late_penalty BOOLEAN NOT NULL DEFAULT TRUE,
    exempt BOOLEAN NOT NULL DEFAULT FALSE,
    exemption_mode VARCHAR(20),
    reason TEXT,
    created_by INTEGER REFERENCES users(id) ON DELETE SET NULL,
    created_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    UNIQUE (assignment_id, user_id, problem_id),
    FOREIGN KEY (assignment_id, problem_id)
        REFERENCES assignment_problems (assignment_id, problem_id)
        ON DELETE CASCADE,
    CHECK (exempt OR makeup_due_at IS NOT NULL),
    CHECK (
        (exempt = FALSE AND exemption_mode IS NULL)
        OR (exempt = TRUE AND exemption_mode IN ('full_score', 'excluded'))
    ),
    CHECK (reason IS NULL OR length(reason) <= 2000)
);

CREATE INDEX IF NOT EXISTS idx_assignment_overrides_assignment
    ON assignment_student_overrides (assignment_id, user_id);

COMMENT ON TABLE assignment_student_overrides IS
    '按学生+题目设置补交或免修；user_id 必须是学生，由服务层校验';

-- 5. Policy audit trail
CREATE TABLE IF NOT EXISTS assignment_policy_audits (
    id SERIAL PRIMARY KEY,
    assignment_id INTEGER NOT NULL REFERENCES assignments(id) ON DELETE CASCADE,
    actor_id INTEGER REFERENCES users(id) ON DELETE SET NULL,
    action VARCHAR(40) NOT NULL,
    before_data JSONB,
    after_data JSONB,
    reason TEXT,
    created_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CHECK (action IN (
        'policy_update',
        'due_extended',
        'override_set',
        'override_revoked',
        'solutions_published'
    )),
    CHECK (reason IS NULL OR length(reason) <= 2000)
);

CREATE INDEX IF NOT EXISTS idx_assignment_policy_audits_assignment
    ON assignment_policy_audits (assignment_id, created_at DESC);

-- 6. Attempt counting index
CREATE INDEX IF NOT EXISTS idx_submissions_assignment_attempts
    ON submissions (assignment_id, user_id, problem_id, submitted_at)
    WHERE assignment_id IS NOT NULL;
