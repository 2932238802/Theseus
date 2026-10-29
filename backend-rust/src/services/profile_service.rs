use chrono::{Datelike, Duration, NaiveDate, Utc};
use sqlx::{FromRow, PgPool};

use crate::{
    common::error::{AppError, is_unique_violation},
    config::Config,
    models::{
        profile::{
            AccountMessageResponse, AnalyticsDifficulty, AnalyticsQuery, AnalyticsResponse,
            AnalyticsSummary, AnalyticsTag, AnalyticsTrendPoint, AvatarResponse,
            DeleteAccountRequest, UpdateUsernameRequest,
        },
        user::PublicUser,
    },
    services::auth_service,
    utils::password::verify_password,
};

const ROLE_LOCK_NAMESPACE: i32 = 4;
const MIN_USERNAME_CHARS: usize = 3;
const MAX_USERNAME_CHARS: usize = 50;
const MAX_AVATAR_BYTES: usize = 2 * 1024 * 1024;
const AVATAR_SIZE: u32 = 256;
const DEFAULT_ANALYTICS_DAYS: i64 = 30;
const MIN_ANALYTICS_DAYS: i64 = 7;
const MAX_ANALYTICS_DAYS: i64 = 90;
const HEATMAP_WEEKS: i64 = 52;

pub async fn update_username(
    pool: &PgPool,
    user_id: i32,
    request: &UpdateUsernameRequest,
) -> Result<PublicUser, AppError> {
    let username = validate_username(&request.username)?;
    sqlx::query(
        "UPDATE users SET username = $1, updated_at = CURRENT_TIMESTAMP
         WHERE id = $2 AND status = 'active'",
    )
    .bind(&username)
    .bind(user_id)
    .execute(pool)
    .await
    .map_err(|error: sqlx::Error| {
        if is_unique_violation(&error) {
            AppError::Conflict("用户名已存在".to_owned())
        } else {
            AppError::Database(error)
        }
    })?;
    auth_service::current_user(pool, user_id).await
}

pub async fn delete_account(
    pool: &PgPool,
    config: &Config,
    user_id: i32,
    request: &DeleteAccountRequest,
) -> Result<AccountMessageResponse, AppError> {
    if request.password.is_empty() || request.username.trim().is_empty() {
        return Err(AppError::BadRequest("请输入当前密码和用户名".to_owned()));
    }

    let mut transaction = pool.begin().await.map_err(AppError::Database)?;
    sqlx::query("SELECT pg_advisory_xact_lock($1, 0)")
        .bind(ROLE_LOCK_NAMESPACE)
        .execute(&mut *transaction)
        .await
        .map_err(AppError::Database)?;

    #[derive(FromRow)]
    struct AccountRow {
        username: String,
        password_hash: String,
        role: String,
        status: String,
        avatar_path: Option<String>,
    }

    let account: Option<AccountRow> = sqlx::query_as(
        "SELECT username, password_hash, role, status, avatar_path
         FROM users WHERE id = $1 FOR UPDATE",
    )
    .bind(user_id)
    .fetch_optional(&mut *transaction)
    .await
    .map_err(AppError::Database)?;
    let account = account.ok_or(AppError::Unauthorized)?;
    if account.status != "active" {
        return Err(AppError::Conflict("账号当前状态不能注销".to_owned()));
    }
    if request.username.trim() != account.username {
        return Err(AppError::BadRequest("用户名确认不一致".to_owned()));
    }
    if !verify_password(&request.password, &account.password_hash) {
        return Err(AppError::Unauthorized);
    }

    if account.role == "teacher" {
        let owned: i64 = sqlx::query_scalar(
            "SELECT COUNT(*) FROM classes WHERE owner_id = $1 AND archived_at IS NULL",
        )
        .bind(user_id)
        .fetch_one(&mut *transaction)
        .await
        .map_err(AppError::Database)?;
        if owned > 0 {
            return Err(AppError::Conflict(
                "请先归档你的班级后再注销账号".to_owned(),
            ));
        }
    }
    if account.role == "admin" {
        let admins: i64 = sqlx::query_scalar(
            "SELECT COUNT(*) FROM users WHERE role = 'admin' AND status = 'active'",
        )
        .fetch_one(&mut *transaction)
        .await
        .map_err(AppError::Database)?;
        if admins <= 1 {
            return Err(AppError::Conflict("最后一个管理员不能注销".to_owned()));
        }
    }

    sqlx::query(
        "UPDATE class_members
         SET status = 'removed', removed_at = CURRENT_TIMESTAMP
         WHERE user_id = $1 AND status = 'active'",
    )
    .bind(user_id)
    .execute(&mut *transaction)
    .await
    .map_err(AppError::Database)?;

    let anonymous_username = format!("deleted_{user_id}");
    let anonymous_email = format!("deleted_{user_id}@deleted.local");
    let unusable_password = format!(
        "deleted-{user_id}-{}",
        Utc::now().timestamp_nanos_opt().unwrap_or_default()
    );
    sqlx::query(
        "UPDATE users
         SET username = $1,
             email = $2,
             password_hash = $3,
             avatar_path = NULL,
             pending_email = NULL,
             status = 'deleted',
             deleted_at = CURRENT_TIMESTAMP,
             token_version = token_version + 1,
             updated_at = CURRENT_TIMESTAMP
         WHERE id = $4",
    )
    .bind(anonymous_username)
    .bind(anonymous_email)
    .bind(unusable_password)
    .bind(user_id)
    .execute(&mut *transaction)
    .await
    .map_err(AppError::Database)?;

    sqlx::query(
        "UPDATE auth_tokens SET used_at = CURRENT_TIMESTAMP
         WHERE user_id = $1 AND used_at IS NULL",
    )
    .bind(user_id)
    .execute(&mut *transaction)
    .await
    .map_err(AppError::Database)?;

    transaction.commit().await.map_err(AppError::Database)?;
    if let Some(path) = account.avatar_path {
        remove_avatar_file(config, &path).await;
    }
    Ok(AccountMessageResponse {
        message: "账号已注销".to_owned(),
    })
}

pub async fn save_avatar(
    pool: &PgPool,
    config: &Config,
    user_id: i32,
    bytes: &[u8],
) -> Result<AvatarResponse, AppError> {
    if bytes.is_empty() {
        return Err(AppError::BadRequest("请选择头像文件".to_owned()));
    }
    if bytes.len() > MAX_AVATAR_BYTES {
        return Err(AppError::BadRequest("头像不能超过 2 MB".to_owned()));
    }
    let image = image::load_from_memory(bytes)
        .map_err(|_| AppError::BadRequest("不支持的图片格式".to_owned()))?;
    let (width, height) = (image.width(), image.height());
    if width < 64 || height < 64 {
        return Err(AppError::BadRequest("图片尺寸不能小于 64×64".to_owned()));
    }
    let side = width.min(height);
    let x = (width - side) / 2;
    let y = (height - side) / 2;
    let avatar = image.crop_imm(x, y, side, side).resize_exact(
        AVATAR_SIZE,
        AVATAR_SIZE,
        image::imageops::FilterType::Lanczos3,
    );
    let mut encoded = std::io::Cursor::new(Vec::new());
    let mut encoder = image::codecs::jpeg::JpegEncoder::new_with_quality(&mut encoded, 85);
    encoder
        .encode_image(&avatar)
        .map_err(|_| AppError::Internal("头像编码失败".to_owned()))?;
    let encoded = encoded.into_inner();

    let avatar_dir = config.upload_dir.join("avatars");
    tokio::fs::create_dir_all(&avatar_dir)
        .await
        .map_err(|error| AppError::Internal(format!("创建头像目录失败: {error}")))?;
    let filename = format!("{user_id}_{:08x}.jpg", rand::random::<u32>());
    let absolute = avatar_dir.join(&filename);
    tokio::fs::write(&absolute, &encoded)
        .await
        .map_err(|error| AppError::Internal(format!("保存头像失败: {error}")))?;
    let relative = format!("avatars/{filename}");

    let previous: Option<String> =
        sqlx::query_scalar("SELECT avatar_path FROM users WHERE id = $1 AND status = 'active'")
            .bind(user_id)
            .fetch_optional(pool)
            .await
            .map_err(AppError::Database)?
            .flatten();
    sqlx::query(
        "UPDATE users SET avatar_path = $1, updated_at = CURRENT_TIMESTAMP
         WHERE id = $2 AND status = 'active'",
    )
    .bind(&relative)
    .bind(user_id)
    .execute(pool)
    .await
    .map_err(AppError::Database)?;
    if let Some(old) = previous
        && old != relative
    {
        remove_avatar_file(config, &old).await;
    }
    Ok(AvatarResponse {
        message: "头像已更新".to_owned(),
        avatar_url: format!("/uploads/{relative}"),
    })
}

pub async fn delete_avatar(
    pool: &PgPool,
    config: &Config,
    user_id: i32,
) -> Result<PublicUser, AppError> {
    let previous: Option<String> =
        sqlx::query_scalar("SELECT avatar_path FROM users WHERE id = $1 AND status = 'active'")
            .bind(user_id)
            .fetch_optional(pool)
            .await
            .map_err(AppError::Database)?
            .flatten();
    sqlx::query(
        "UPDATE users SET avatar_path = NULL, updated_at = CURRENT_TIMESTAMP
         WHERE id = $1 AND status = 'active'",
    )
    .bind(user_id)
    .execute(pool)
    .await
    .map_err(AppError::Database)?;
    if let Some(path) = previous {
        remove_avatar_file(config, &path).await;
    }
    auth_service::current_user(pool, user_id).await
}

async fn remove_avatar_file(config: &Config, relative: &str) {
    if relative.split('/').count() != 2 {
        return;
    }
    let path = config.upload_dir.join(relative);
    let _ = tokio::fs::remove_file(path).await;
}

pub async fn analytics(
    pool: &PgPool,
    user_id: i32,
    query: &AnalyticsQuery,
) -> Result<AnalyticsResponse, AppError> {
    let days = query.days.unwrap_or(DEFAULT_ANALYTICS_DAYS);
    if !(MIN_ANALYTICS_DAYS..=MAX_ANALYTICS_DAYS).contains(&days) {
        return Err(AppError::BadRequest("days 必须在 7 到 90 之间".to_owned()));
    }
    let today = Utc::now().date_naive();
    let monday_offset = i64::from(today.weekday().num_days_from_monday());
    let heatmap_start = today - Duration::days(monday_offset) - Duration::weeks(HEATMAP_WEEKS);

    let (total_submissions, accepted_submissions): (i64, i64) = sqlx::query_as(
        "SELECT COUNT(*)::bigint,
                COUNT(*) FILTER (WHERE status = 'accepted')::bigint
         FROM submissions
         WHERE user_id = $1 AND submitted_at >= CURRENT_TIMESTAMP - make_interval(days => $2::int)",
    )
    .bind(user_id)
    .bind(days as i32)
    .fetch_one(pool)
    .await
    .map_err(AppError::Database)?;

    let (accepted_problems, attempted_problems): (i64, i64) = sqlx::query_as(
        "SELECT COUNT(DISTINCT problem_id) FILTER (WHERE status = 'accepted')::bigint,
                COUNT(DISTINCT problem_id)::bigint
         FROM submissions WHERE user_id = $1",
    )
    .bind(user_id)
    .fetch_one(pool)
    .await
    .map_err(AppError::Database)?;

    let (role,): (String,) = sqlx::query_as("SELECT role FROM users WHERE id = $1")
        .bind(user_id)
        .fetch_one(pool)
        .await
        .map_err(AppError::Database)?;
    let active_classes: i64 = match role.as_str() {
        "student" => sqlx::query_scalar(
            "SELECT COUNT(*) FROM class_members WHERE user_id = $1 AND status = 'active'",
        )
        .bind(user_id)
        .fetch_one(pool)
        .await
        .map_err(AppError::Database)?,
        "teacher" => sqlx::query_scalar(
            "SELECT COUNT(*) FROM classes WHERE owner_id = $1 AND archived_at IS NULL",
        )
        .bind(user_id)
        .fetch_one(pool)
        .await
        .map_err(AppError::Database)?,
        _ => 0,
    };

    let days_with_accepted: Vec<NaiveDate> = sqlx::query_scalar(
        "SELECT DISTINCT (submitted_at AT TIME ZONE 'UTC')::date
         FROM submissions
         WHERE user_id = $1 AND status = 'accepted'
         ORDER BY 1 DESC",
    )
    .bind(user_id)
    .fetch_all(pool)
    .await
    .map_err(AppError::Database)?;
    let streak_days = compute_streak(&days_with_accepted);

    #[derive(FromRow)]
    struct TrendRow {
        day: NaiveDate,
        submissions: i64,
        accepted: i64,
    }
    let trend_rows: Vec<TrendRow> = sqlx::query_as(
        "SELECT (submitted_at AT TIME ZONE 'UTC')::date AS day,
                COUNT(*)::bigint AS submissions,
                COUNT(*) FILTER (WHERE status = 'accepted')::bigint AS accepted
         FROM submissions
         WHERE user_id = $1 AND (submitted_at AT TIME ZONE 'UTC')::date >= $2
         GROUP BY day ORDER BY day",
    )
    .bind(user_id)
    .bind(heatmap_start)
    .fetch_all(pool)
    .await
    .map_err(AppError::Database)?;
    let mut trend_map: std::collections::HashMap<NaiveDate, (i64, i64)> = trend_rows
        .into_iter()
        .map(|row| (row.day, (row.submissions, row.accepted)))
        .collect();
    let mut heatmap = Vec::new();
    let mut day = heatmap_start;
    while day <= today {
        let (submissions, accepted) = trend_map.remove(&day).unwrap_or((0, 0));
        heatmap.push(AnalyticsTrendPoint {
            date: day.format("%Y-%m-%d").to_string(),
            submissions,
            accepted,
        });
        day += Duration::days(1);
    }
    let trend = heatmap[heatmap.len().saturating_sub(days as usize)..].to_vec();

    #[derive(FromRow)]
    struct DifficultyRow {
        difficulty: String,
        attempted: i64,
        accepted: i64,
    }
    let difficulty: Vec<AnalyticsDifficulty> = sqlx::query_as::<_, DifficultyRow>(
        "SELECT p.difficulty,
                COUNT(*)::bigint AS attempted,
                COUNT(*) FILTER (WHERE s.status = 'accepted')::bigint AS accepted
         FROM submissions s JOIN problems p ON p.id = s.problem_id
         WHERE s.user_id = $1 AND s.submitted_at >= CURRENT_TIMESTAMP - make_interval(days => $2::int)
         GROUP BY p.difficulty
         ORDER BY CASE p.difficulty WHEN 'easy' THEN 0 WHEN 'medium' THEN 1 ELSE 2 END",
    )
    .bind(user_id)
    .bind(days as i32)
    .fetch_all(pool)
    .await
    .map_err(AppError::Database)?
    .into_iter()
    .map(|row| AnalyticsDifficulty {
        difficulty: row.difficulty,
        attempted: row.attempted,
        accepted: row.accepted,
    })
    .collect();

    #[derive(FromRow)]
    struct TagRow {
        tag: String,
        attempted: i64,
        accepted: i64,
    }
    let tags: Vec<AnalyticsTag> = sqlx::query_as::<_, TagRow>(
        "SELECT tag,
                COUNT(*)::bigint AS attempted,
                COUNT(*) FILTER (WHERE s.status = 'accepted')::bigint AS accepted
         FROM submissions s
         JOIN problems p ON p.id = s.problem_id
         CROSS JOIN LATERAL unnest(p.tags) AS tag
         WHERE s.user_id = $1 AND s.submitted_at >= CURRENT_TIMESTAMP - make_interval(days => $2::int)
         GROUP BY tag
         ORDER BY attempted DESC, tag
         LIMIT 10",
    )
    .bind(user_id)
    .bind(days as i32)
    .fetch_all(pool)
    .await
    .map_err(AppError::Database)?
    .into_iter()
    .map(|row| AnalyticsTag {
        tag: row.tag,
        attempted: row.attempted,
        accepted: row.accepted,
    })
    .collect();

    let acceptance_rate = if total_submissions == 0 {
        0.0
    } else {
        round1(accepted_submissions as f64 / total_submissions as f64 * 100.0)
    };

    Ok(AnalyticsResponse {
        days,
        summary: AnalyticsSummary {
            accepted_problems,
            attempted_problems,
            total_submissions,
            accepted_submissions,
            acceptance_rate,
            active_classes,
            streak_days,
        },
        trend,
        heatmap,
        difficulty,
        tags,
    })
}

pub(crate) fn compute_streak(days: &[NaiveDate]) -> i64 {
    if days.is_empty() {
        return 0;
    }
    let today = Utc::now().date_naive();
    let yesterday = today - Duration::days(1);
    let mut expected = if days[0] == today {
        today
    } else if days[0] == yesterday {
        yesterday
    } else {
        return 0;
    };
    let mut streak = 0;
    for day in days {
        if *day == expected {
            streak += 1;
            expected -= Duration::days(1);
        } else if *day < expected {
            break;
        }
    }
    streak
}

fn round1(value: f64) -> f64 {
    (value * 10.0).round() / 10.0
}

fn validate_username(value: &str) -> Result<String, AppError> {
    let username = value.trim();
    let chars = username.chars().count();
    if !(MIN_USERNAME_CHARS..=MAX_USERNAME_CHARS).contains(&chars) {
        return Err(AppError::BadRequest(format!(
            "用户名长度必须在 {MIN_USERNAME_CHARS} 到 {MAX_USERNAME_CHARS} 个字符之间"
        )));
    }
    if username
        .chars()
        .any(|ch| ch.is_whitespace() || ch.is_control() || ch == '@')
    {
        return Err(AppError::BadRequest(
            "用户名不能包含空白、控制字符或 @".to_owned(),
        ));
    }
    Ok(username.to_owned())
}

#[cfg(test)]
mod tests {
    use super::{compute_streak, validate_username};
    use chrono::{Duration, Utc};

    #[test]
    fn validates_username_shape() {
        assert!(validate_username("ab").is_err());
        assert!(validate_username("a b").is_err());
        assert!(validate_username("a@b").is_err());
        assert!(validate_username("  alice  ").is_ok());
        assert!(validate_username(&"a".repeat(51)).is_err());
    }

    #[test]
    fn computes_streak_from_today_or_yesterday() {
        let today = Utc::now().date_naive();
        let days = vec![today, today - Duration::days(1), today - Duration::days(2)];
        assert_eq!(compute_streak(&days), 3);
        let old = vec![today - Duration::days(3)];
        assert_eq!(compute_streak(&old), 0);
    }
}
