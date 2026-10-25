-- Teaching module: mutually exclusive student/teacher/admin roles, classes,
-- assignments, submissions linked to assignments, and grading.

ALTER TABLE users DROP CONSTRAINT IF EXISTS users_role_check;
UPDATE users SET role = 'student' WHERE role = 'user';
ALTER TABLE users ALTER COLUMN role SET DEFAULT 'student';
ALTER TABLE users ADD CONSTRAINT users_role_check
    CHECK (role IN ('student', 'teacher', 'admin'));

ALTER TABLE users
    ADD COLUMN IF NOT EXISTS role_changed_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP;
CREATE INDEX IF NOT EXISTS idx_users_role ON users (role);

CREATE TABLE IF NOT EXISTS classes (
    id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    course_name VARCHAR(100),
    term VARCHAR(30),
    description TEXT,
    invite_code VARCHAR(12) NOT NULL UNIQUE,
    owner_id INTEGER NOT NULL REFERENCES users(id) ON DELETE RESTRICT,
    archived_at TIMESTAMPTZ,
    created_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CHECK (length(btrim(name)) > 0)
);

CREATE INDEX IF NOT EXISTS idx_classes_owner
    ON classes (owner_id, archived_at);

CREATE TABLE IF NOT EXISTS class_members (
    id SERIAL PRIMARY KEY,
    class_id INTEGER NOT NULL REFERENCES classes(id) ON DELETE CASCADE,
    user_id INTEGER NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    status VARCHAR(20) NOT NULL DEFAULT 'active'
        CHECK (status IN ('active', 'removed')),
    joined_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    removed_at TIMESTAMPTZ,
    UNIQUE (class_id, user_id)
);

CREATE INDEX IF NOT EXISTS idx_class_members_user
    ON class_members (user_id, status);
CREATE INDEX IF NOT EXISTS idx_class_members_class
    ON class_members (class_id, status);

COMMENT ON COLUMN classes.owner_id IS 'active 班级必须是 users.role = teacher；归档班级允许保留历史 owner';
COMMENT ON TABLE class_members IS '只包含 users.role = student，角色由服务层校验';

CREATE TABLE IF NOT EXISTS assignments (
    id SERIAL PRIMARY KEY,
    class_id INTEGER NOT NULL REFERENCES classes(id) ON DELETE CASCADE,
    title VARCHAR(200) NOT NULL,
    description TEXT,
    status VARCHAR(20) NOT NULL DEFAULT 'draft'
        CHECK (status IN ('draft', 'published', 'archived')),
    start_at TIMESTAMPTZ,
    due_at TIMESTAMPTZ,
    created_by INTEGER NOT NULL REFERENCES users(id) ON DELETE RESTRICT,
    published_at TIMESTAMPTZ,
    grades_published_at TIMESTAMPTZ,
    created_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CHECK (length(btrim(title)) > 0),
    CHECK (start_at IS NULL OR due_at IS NULL OR due_at > start_at)
);

CREATE INDEX IF NOT EXISTS idx_assignments_class
    ON assignments (class_id, status, due_at);

COMMENT ON COLUMN assignments.created_by IS '创建时等于 classes.owner_id，必须是 teacher';

CREATE TABLE IF NOT EXISTS assignment_problems (
    assignment_id INTEGER NOT NULL
        REFERENCES assignments(id) ON DELETE CASCADE,
    problem_id INTEGER NOT NULL
        REFERENCES problems(id) ON DELETE RESTRICT,
    position INTEGER NOT NULL DEFAULT 0,
    points INTEGER NOT NULL DEFAULT 100
        CHECK (points > 0 AND points <= 1000),
    PRIMARY KEY (assignment_id, problem_id)
);

CREATE INDEX IF NOT EXISTS idx_assignment_problems_order
    ON assignment_problems (assignment_id, position, problem_id);
CREATE INDEX IF NOT EXISTS idx_assignment_problems_problem
    ON assignment_problems (problem_id);

CREATE TABLE IF NOT EXISTS assignment_problem_grades (
    assignment_id INTEGER NOT NULL,
    user_id INTEGER NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    problem_id INTEGER NOT NULL,
    manual_score INTEGER
        CHECK (manual_score IS NULL OR (manual_score >= 0 AND manual_score <= 1000)),
    feedback TEXT,
    graded_by INTEGER REFERENCES users(id) ON DELETE SET NULL,
    graded_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (assignment_id, user_id, problem_id),
    FOREIGN KEY (assignment_id, problem_id)
        REFERENCES assignment_problems (assignment_id, problem_id)
        ON DELETE CASCADE
);

CREATE INDEX IF NOT EXISTS idx_assignment_problem_grades_user
    ON assignment_problem_grades (user_id, assignment_id);

CREATE TABLE IF NOT EXISTS assignment_results (
    assignment_id INTEGER NOT NULL
        REFERENCES assignments(id) ON DELETE CASCADE,
    user_id INTEGER NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    overall_feedback TEXT,
    graded_by INTEGER REFERENCES users(id) ON DELETE SET NULL,
    graded_at TIMESTAMPTZ,
    PRIMARY KEY (assignment_id, user_id)
);

CREATE INDEX IF NOT EXISTS idx_assignment_results_user
    ON assignment_results (user_id, assignment_id);

ALTER TABLE submissions
    ADD COLUMN IF NOT EXISTS assignment_id INTEGER
    REFERENCES assignments(id) ON DELETE SET NULL;

CREATE INDEX IF NOT EXISTS idx_submissions_assignment
    ON submissions (assignment_id, user_id, problem_id, status)
    WHERE assignment_id IS NOT NULL;
