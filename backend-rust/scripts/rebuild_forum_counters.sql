-- Theseus forum counter maintenance.
--
-- Rebuilds denormalized counters from the source tables. Run during a low-peak
-- window, or stop forum writes first. The script does not block the API, but
-- concurrent writes during the rebuild can be overwritten by the snapshot it
-- computed, so counter updates that land inside this window may be lost. Run it
-- after manual database intervention or if a counter is suspected to have
-- drifted:
--
--   psql "$DATABASE_URL" -f backend-rust/scripts/rebuild_forum_counters.sql
--
-- Note: forum_posts.comment_count counts only published comments, matching
-- the application rule. pending_report_count counts pending reports only.

BEGIN;

UPDATE forum_posts fp
SET like_count = (
        SELECT COUNT(*) FROM forum_post_likes l WHERE l.post_id = fp.id
    ),
    favorite_count = (
        SELECT COUNT(*) FROM forum_post_favorites f WHERE f.post_id = fp.id
    ),
    comment_count = (
        SELECT COUNT(*) FROM forum_comments c
        WHERE c.post_id = fp.id AND c.status = 'published'
    ),
    pending_report_count = (
        SELECT COUNT(*) FROM forum_reports r
        WHERE r.target_type = 'post' AND r.target_id = fp.id AND r.status = 'pending'
    );

UPDATE forum_comments fc
SET pending_report_count = (
    SELECT COUNT(*) FROM forum_reports r
    WHERE r.target_type = 'comment' AND r.target_id = fc.id AND r.status = 'pending'
);

COMMIT;
