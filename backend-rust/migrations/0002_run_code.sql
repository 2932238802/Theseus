ALTER TABLE problems ADD COLUMN IF NOT EXISTS run_config JSONB;

CREATE TABLE IF NOT EXISTS code_runs (
    id BIGSERIAL PRIMARY KEY,
    user_id INTEGER NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    problem_id INTEGER REFERENCES problems(id) ON DELETE SET NULL,
    problem_title VARCHAR(200) NOT NULL,
    language VARCHAR(20) NOT NULL CHECK (language IN ('cpp', 'java', 'python', 'javascript')),
    mode VARCHAR(20) NOT NULL CHECK (mode IN ('examples', 'custom')),
    code TEXT NOT NULL,
    input JSONB,
    run_config_snapshot JSONB NOT NULL,
    status VARCHAR(30) NOT NULL CHECK (status IN (
        'queued', 'compiling', 'running', 'completed',
        'compile_error', 'runtime_error', 'time_limit_exceeded',
        'memory_limit_exceeded', 'internal_error'
    )),
    cases JSONB NOT NULL DEFAULT '[]'::jsonb,
    case_total INTEGER NOT NULL DEFAULT 0,
    case_passed INTEGER NOT NULL DEFAULT 0,
    compile_output TEXT,
    error_message TEXT,
    runtime_ms INTEGER,
    memory_kb INTEGER,
    attempt_count INTEGER NOT NULL DEFAULT 0,
    created_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    started_at TIMESTAMPTZ,
    finished_at TIMESTAMPTZ
);

CREATE INDEX IF NOT EXISTS idx_code_runs_user_created ON code_runs(user_id, created_at DESC);
CREATE INDEX IF NOT EXISTS idx_code_runs_problem ON code_runs(problem_id);
CREATE INDEX IF NOT EXISTS idx_code_runs_status ON code_runs(status);
