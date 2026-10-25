-- Submission judging: hidden judge cases and per-submission judging state.
ALTER TABLE problems ADD COLUMN IF NOT EXISTS judge_cases JSONB;

ALTER TABLE submissions
    ADD COLUMN IF NOT EXISTS run_config_snapshot JSONB,
    ADD COLUMN IF NOT EXISTS judge_cases_snapshot JSONB,
    ADD COLUMN IF NOT EXISTS cases JSONB NOT NULL DEFAULT '[]'::jsonb,
    ADD COLUMN IF NOT EXISTS compile_output TEXT,
    ADD COLUMN IF NOT EXISTS attempt_count INTEGER NOT NULL DEFAULT 0,
    ADD COLUMN IF NOT EXISTS started_at TIMESTAMPTZ,
    ADD COLUMN IF NOT EXISTS finished_at TIMESTAMPTZ;

-- The original CHECK did not include internal_error, which the judge worker
-- uses for infrastructure failures.
ALTER TABLE submissions DROP CONSTRAINT IF EXISTS submissions_status_check;
ALTER TABLE submissions ADD CONSTRAINT submissions_status_check
    CHECK (status IN (
        'pending', 'judging', 'accepted', 'wrong_answer',
        'time_limit_exceeded', 'memory_limit_exceeded',
        'runtime_error', 'compile_error', 'internal_error'
    ));
