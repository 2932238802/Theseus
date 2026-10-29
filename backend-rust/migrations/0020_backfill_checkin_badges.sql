-- Backfill check-in badges for streaks that already existed when 0019 was applied.
-- Only the most recent streak per user counts; a streak ending yesterday is still
-- valid until today's check-in window closes.
WITH ordered AS (
    SELECT user_id,
           checkin_date,
           checkin_date
               - (ROW_NUMBER() OVER (PARTITION BY user_id ORDER BY checkin_date))::int AS grp
    FROM reputation_checkins
),
streaks AS (
    SELECT user_id, grp, COUNT(*) AS streak_days, MAX(checkin_date) AS last_day
    FROM ordered
    GROUP BY user_id, grp
),
latest AS (
    SELECT DISTINCT ON (user_id) user_id, streak_days, last_day
    FROM streaks
    ORDER BY user_id, last_day DESC
)
INSERT INTO user_badges (user_id, badge_code, awarded_at, expires_at)
SELECT latest.user_id,
       catalog.code,
       CURRENT_TIMESTAMP,
       CURRENT_TIMESTAMP + make_interval(days => catalog.validity_days)
FROM latest
JOIN badge_catalog catalog
  ON catalog.category = 'checkin'
 AND catalog.threshold_days <= latest.streak_days
WHERE latest.last_day >= (CURRENT_TIMESTAMP AT TIME ZONE 'UTC')::date - 1
ON CONFLICT (user_id, badge_code) DO NOTHING;
