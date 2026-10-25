-- Theseus forum MVP: single wall with tags, optional anonymity,
-- two-level comments, likes/favorites, reports, moderation and in-app notifications.

CREATE TABLE IF NOT EXISTS forum_posts (
    id BIGSERIAL PRIMARY KEY,
    author_id INTEGER NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    title VARCHAR(120) NOT NULL,
    body_md TEXT NOT NULL,
    tags TEXT[] NOT NULL DEFAULT '{}'::text[],
    problem_id INTEGER REFERENCES problems(id) ON DELETE SET NULL,
    is_anonymous BOOLEAN NOT NULL DEFAULT FALSE,
    status VARCHAR(20) NOT NULL DEFAULT 'published'
        CHECK (status IN ('published', 'hidden', 'deleted')),
    hidden_reason VARCHAR(30)
        CHECK (hidden_reason IS NULL OR hidden_reason IN ('moderation', 'report_threshold')),
    hidden_by INTEGER REFERENCES users(id) ON DELETE SET NULL,
    hidden_at TIMESTAMPTZ,
    is_pinned BOOLEAN NOT NULL DEFAULT FALSE,
    pinned_at TIMESTAMPTZ,
    like_count INTEGER NOT NULL DEFAULT 0 CHECK (like_count >= 0),
    favorite_count INTEGER NOT NULL DEFAULT 0 CHECK (favorite_count >= 0),
    comment_count INTEGER NOT NULL DEFAULT 0 CHECK (comment_count >= 0),
    pending_report_count INTEGER NOT NULL DEFAULT 0 CHECK (pending_report_count >= 0),
    edited_at TIMESTAMPTZ,
    created_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CHECK (char_length(title) BETWEEN 1 AND 120),
    CHECK (char_length(body_md) BETWEEN 1 AND 20000),
    CHECK (cardinality(tags) BETWEEN 1 AND 3)
);

CREATE INDEX IF NOT EXISTS idx_forum_posts_feed
    ON forum_posts (status, is_pinned DESC, created_at DESC);
CREATE INDEX IF NOT EXISTS idx_forum_posts_author
    ON forum_posts (author_id, created_at DESC);
CREATE INDEX IF NOT EXISTS idx_forum_posts_tags
    ON forum_posts USING GIN (tags);
CREATE INDEX IF NOT EXISTS idx_forum_posts_problem
    ON forum_posts (problem_id);

CREATE TABLE IF NOT EXISTS forum_comments (
    id BIGSERIAL PRIMARY KEY,
    post_id BIGINT NOT NULL REFERENCES forum_posts(id) ON DELETE CASCADE,
    author_id INTEGER NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    parent_id BIGINT REFERENCES forum_comments(id) ON DELETE CASCADE,
    reply_to_comment_id BIGINT REFERENCES forum_comments(id) ON DELETE SET NULL,
    reply_to_user_id INTEGER REFERENCES users(id) ON DELETE SET NULL,
    body_md TEXT NOT NULL,
    is_anonymous BOOLEAN NOT NULL DEFAULT FALSE,
    status VARCHAR(20) NOT NULL DEFAULT 'published'
        CHECK (status IN ('published', 'hidden', 'deleted')),
    hidden_reason VARCHAR(30)
        CHECK (hidden_reason IS NULL OR hidden_reason IN ('moderation', 'report_threshold')),
    hidden_by INTEGER REFERENCES users(id) ON DELETE SET NULL,
    hidden_at TIMESTAMPTZ,
    pending_report_count INTEGER NOT NULL DEFAULT 0 CHECK (pending_report_count >= 0),
    edited_at TIMESTAMPTZ,
    created_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CHECK (char_length(body_md) BETWEEN 1 AND 5000)
);

CREATE INDEX IF NOT EXISTS idx_forum_comments_post
    ON forum_comments (post_id, parent_id, created_at ASC);
CREATE INDEX IF NOT EXISTS idx_forum_comments_author
    ON forum_comments (author_id, created_at DESC);

CREATE TABLE IF NOT EXISTS forum_post_likes (
    post_id BIGINT NOT NULL REFERENCES forum_posts(id) ON DELETE CASCADE,
    user_id INTEGER NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    created_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (post_id, user_id)
);

CREATE INDEX IF NOT EXISTS idx_forum_post_likes_user
    ON forum_post_likes (user_id, created_at DESC);

CREATE TABLE IF NOT EXISTS forum_post_favorites (
    post_id BIGINT NOT NULL REFERENCES forum_posts(id) ON DELETE CASCADE,
    user_id INTEGER NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    created_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (post_id, user_id)
);

CREATE INDEX IF NOT EXISTS idx_forum_post_favorites_user
    ON forum_post_favorites (user_id, created_at DESC);

CREATE TABLE IF NOT EXISTS forum_reports (
    id BIGSERIAL PRIMARY KEY,
    target_type VARCHAR(10) NOT NULL CHECK (target_type IN ('post', 'comment')),
    target_id BIGINT NOT NULL,
    reporter_id INTEGER NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    reason VARCHAR(20) NOT NULL
        CHECK (reason IN ('spam', 'abuse', 'spoiler', 'illegal', 'other')),
    detail VARCHAR(500),
    status VARCHAR(20) NOT NULL DEFAULT 'pending'
        CHECK (status IN ('pending', 'resolved', 'rejected')),
    handled_by INTEGER REFERENCES users(id) ON DELETE SET NULL,
    handled_at TIMESTAMPTZ,
    resolution_note VARCHAR(500),
    created_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    UNIQUE (target_type, target_id, reporter_id)
);

CREATE INDEX IF NOT EXISTS idx_forum_reports_queue
    ON forum_reports (status, created_at ASC);
CREATE INDEX IF NOT EXISTS idx_forum_reports_target
    ON forum_reports (target_type, target_id);

CREATE TABLE IF NOT EXISTS user_mutes (
    id BIGSERIAL PRIMARY KEY,
    user_id INTEGER NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    muted_by INTEGER REFERENCES users(id) ON DELETE SET NULL,
    reason VARCHAR(500) NOT NULL,
    starts_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    ends_at TIMESTAMPTZ,
    revoked_at TIMESTAMPTZ,
    created_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CHECK (ends_at IS NULL OR ends_at > starts_at)
);

CREATE INDEX IF NOT EXISTS idx_user_mutes_active
    ON user_mutes (user_id, ends_at)
    WHERE revoked_at IS NULL;

CREATE TABLE IF NOT EXISTS moderation_actions (
    id BIGSERIAL PRIMARY KEY,
    actor_id INTEGER REFERENCES users(id) ON DELETE SET NULL,
    action VARCHAR(40) NOT NULL,
    target_type VARCHAR(20) NOT NULL,
    target_id BIGINT,
    reason VARCHAR(500),
    metadata JSONB NOT NULL DEFAULT '{}'::jsonb,
    created_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX IF NOT EXISTS idx_moderation_actions_target
    ON moderation_actions (target_type, target_id, created_at DESC);
CREATE INDEX IF NOT EXISTS idx_moderation_actions_actor
    ON moderation_actions (actor_id, created_at DESC);

CREATE TABLE IF NOT EXISTS notifications (
    id BIGSERIAL PRIMARY KEY,
    user_id INTEGER NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    type VARCHAR(40) NOT NULL,
    actor_id INTEGER REFERENCES users(id) ON DELETE SET NULL,
    title VARCHAR(200) NOT NULL,
    body TEXT,
    link VARCHAR(500),
    related_type VARCHAR(30),
    related_id BIGINT,
    read_at TIMESTAMPTZ,
    created_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX IF NOT EXISTS idx_notifications_user
    ON notifications (user_id, read_at, created_at DESC);
