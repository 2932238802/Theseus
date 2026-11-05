-- 高频列表查询的复合索引。
--
-- 排序方向与 SQL 中的 ORDER BY 完全一致（含 id DESC 作为稳定次序），
-- 这样 PostgreSQL 可以直接按索引顺序取前 N 行，避免在 LIMIT 之前排序。
-- 论坛板块流已由 0032 的 idx_forum_posts_board_feed 覆盖，本次不重复创建。

-- 个人提交列表：WHERE user_id = $1 ORDER BY submitted_at DESC, id DESC
CREATE INDEX IF NOT EXISTS idx_submissions_user_recent
    ON submissions (user_id, submitted_at DESC, id DESC);

-- 某人在某题的提交：WHERE user_id = $1 AND problem_id = $2
-- ORDER BY submitted_at DESC, id DESC
CREATE INDEX IF NOT EXISTS idx_submissions_user_problem_recent
    ON submissions (user_id, problem_id, submitted_at DESC, id DESC);

-- 通知列表：WHERE user_id = $1 ORDER BY created_at DESC, id DESC
-- 原 idx_notifications_user 以 read_at 为第二列，只对“仅未读”查询有序，
-- 全部通知列表仍需要额外排序；两条索引分别服务两种查询。
CREATE INDEX IF NOT EXISTS idx_notifications_user_recent
    ON notifications (user_id, created_at DESC, id DESC);

-- idx_submissions_user_time (user_id, submitted_at DESC) 已被
-- idx_submissions_user_recent 覆盖，后者多出的 id 列用于稳定排序。
DROP INDEX IF EXISTS idx_submissions_user_time;

-- idx_submissions_user_id 是 idx_submissions_user_recent 的最左前缀，
-- 保留两份不会带来额外查询能力，只增加写入与 vacuum 成本。
DROP INDEX IF EXISTS idx_submissions_user_id;
