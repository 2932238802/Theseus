//! 排位赛季与软重置。
//!
//! 赛季激活是惰性的：第一次读取当前赛季或匹配时执行一次软重置，
//! 用 `seasons.activated_at` 和事务行锁保证并发下只执行一次。这样
//! 不需要额外的定时任务，也不会因为 API 重启而重复扣分。

use chrono::{DateTime, Utc};
use sqlx::{FromRow, PgPool, Postgres, Transaction};

use crate::{
    common::error::AppError,
    models::season::{
        AdminSeasonInput, AdminSeasonListResponse, SEASON_STATE_ACTIVE, SEASON_STATE_CANCELLED,
        SEASON_STATE_FINISHED, SEASON_STATE_UPCOMING, SEASON_STATUS_CANCELLED, SEASON_STATUS_DRAFT,
        SEASON_STATUS_PUBLISHED, SeasonListResponse, SeasonSummary,
    },
};

const DEFAULT_SOFT_RESET_RATIO: f64 = 0.5;
const DEFAULT_SEASON_RATING: f64 = 1000.0;
const MAX_SEASON_NAME_CHARS: usize = 100;

#[derive(Debug, FromRow, Clone)]
struct SeasonRow {
    id: i32,
    name: String,
    starts_at: DateTime<Utc>,
    ends_at: DateTime<Utc>,
    status: String,
    soft_reset_ratio: f64,
    activated_at: Option<DateTime<Utc>>,
}

impl SeasonRow {
    fn into_summary(self, now: DateTime<Utc>) -> SeasonSummary {
        let state = if self.status == SEASON_STATUS_CANCELLED {
            SEASON_STATE_CANCELLED
        } else if now < self.starts_at {
            SEASON_STATE_UPCOMING
        } else if now >= self.ends_at {
            SEASON_STATE_FINISHED
        } else {
            SEASON_STATE_ACTIVE
        };
        SeasonSummary {
            id: self.id,
            name: self.name,
            starts_at: self.starts_at,
            ends_at: self.ends_at,
            status: self.status,
            soft_reset_ratio: self.soft_reset_ratio,
            activated: self.activated_at.is_some(),
            state: state.to_owned(),
        }
    }
}

const SEASON_SELECT: &str = "SELECT id, name, starts_at, ends_at, status, \
        soft_reset_ratio::float8 AS soft_reset_ratio, activated_at \
     FROM seasons";

/// Returns the published season covering `now`; activates it first if needed.
pub async fn ensure_active_season(pool: &PgPool) -> Result<Option<SeasonSummary>, AppError> {
    let row: Option<SeasonRow> = sqlx::query_as(&format!(
        "{SEASON_SELECT} WHERE status = 'published' \
         AND starts_at <= CURRENT_TIMESTAMP AND ends_at > CURRENT_TIMESTAMP \
         ORDER BY starts_at DESC, id DESC LIMIT 1"
    ))
    .fetch_optional(pool)
    .await
    .map_err(AppError::Database)?;
    let Some(row) = row else {
        return Ok(None);
    };
    if row.activated_at.is_none() {
        activate_season(pool, row.id).await?;
        return season_summary(pool, row.id).await;
    }
    Ok(Some(row.into_summary(Utc::now())))
}

/// Current season id for contest creation and settlement checks.
pub async fn current_season_id(pool: &PgPool) -> Result<Option<i32>, AppError> {
    sqlx::query_scalar(
        "SELECT id FROM seasons WHERE status = 'published' \
         AND starts_at <= CURRENT_TIMESTAMP AND ends_at > CURRENT_TIMESTAMP \
         ORDER BY starts_at DESC, id DESC LIMIT 1",
    )
    .fetch_optional(pool)
    .await
    .map_err(AppError::Database)
}

pub async fn current_season_id_tx(
    transaction: &mut Transaction<'_, Postgres>,
) -> Result<Option<i32>, AppError> {
    sqlx::query_scalar(
        "SELECT id FROM seasons WHERE status = 'published' \
         AND starts_at <= CURRENT_TIMESTAMP AND ends_at > CURRENT_TIMESTAMP \
         ORDER BY starts_at DESC, id DESC LIMIT 1",
    )
    .fetch_optional(&mut **transaction)
    .await
    .map_err(AppError::Database)
}

async fn activate_season(pool: &PgPool, season_id: i32) -> Result<(), AppError> {
    let mut transaction = pool.begin().await.map_err(AppError::Database)?;
    let row: Option<SeasonRow> =
        sqlx::query_as(&format!("{SEASON_SELECT} WHERE id = $1 FOR UPDATE"))
            .bind(season_id)
            .fetch_optional(&mut *transaction)
            .await
            .map_err(AppError::Database)?;
    let Some(row) = row else {
        return Err(AppError::NotFound("赛季不存在".to_owned()));
    };
    if row.activated_at.is_some() || row.status != SEASON_STATUS_PUBLISHED {
        transaction.commit().await.map_err(AppError::Database)?;
        return Ok(());
    }

    // 所有活跃学生先写入赛季起始分，再把 users.contest_rating 切到赛季分。
    // `ON CONFLICT DO NOTHING` 让重复激活/并发请求保持幂等。
    sqlx::query(
        "INSERT INTO season_ratings (season_id, user_id, rating, rating_start) \
         SELECT $1, u.id, \
                GREATEST(0, ROUND($3::numeric + (u.contest_rating - $3::numeric) * $2::numeric))::int, \
                GREATEST(0, ROUND($3::numeric + (u.contest_rating - $3::numeric) * $2::numeric))::int \
         FROM users u WHERE u.role = 'student' AND u.status = 'active' \
         ON CONFLICT (season_id, user_id) DO NOTHING",
    )
    .bind(season_id)
    .bind(row.soft_reset_ratio)
    .bind(DEFAULT_SEASON_RATING)
    .execute(&mut *transaction)
    .await
    .map_err(AppError::Database)?;

    sqlx::query(
        "UPDATE users u SET contest_rating = sr.rating, updated_at = CURRENT_TIMESTAMP \
         FROM season_ratings sr \
         WHERE sr.season_id = $1 AND sr.user_id = u.id \
           AND u.role = 'student' AND u.status = 'active'",
    )
    .bind(season_id)
    .execute(&mut *transaction)
    .await
    .map_err(AppError::Database)?;

    sqlx::query("UPDATE seasons SET activated_at = CURRENT_TIMESTAMP, updated_at = CURRENT_TIMESTAMP WHERE id = $1")
        .bind(season_id)
        .execute(&mut *transaction)
        .await
        .map_err(AppError::Database)?;

    transaction.commit().await.map_err(AppError::Database)?;
    tracing::info!(
        season_id,
        ratio = row.soft_reset_ratio,
        "season activated and ratings soft reset"
    );
    Ok(())
}

pub async fn season_summary(
    pool: &PgPool,
    season_id: i32,
) -> Result<Option<SeasonSummary>, AppError> {
    let row: Option<SeasonRow> = sqlx::query_as(&format!("{SEASON_SELECT} WHERE id = $1"))
        .bind(season_id)
        .fetch_optional(pool)
        .await
        .map_err(AppError::Database)?;
    Ok(row.map(|row| row.into_summary(Utc::now())))
}

pub async fn list_public(pool: &PgPool) -> Result<SeasonListResponse, AppError> {
    let current = ensure_active_season(pool).await?;
    let rows: Vec<SeasonRow> = sqlx::query_as(&format!(
        "{SEASON_SELECT} WHERE status IN ('published', 'cancelled') \
         ORDER BY starts_at DESC, id DESC LIMIT 50"
    ))
    .fetch_all(pool)
    .await
    .map_err(AppError::Database)?;
    let now = Utc::now();
    Ok(SeasonListResponse {
        current,
        items: rows.into_iter().map(|row| row.into_summary(now)).collect(),
        server_time: now,
    })
}

pub async fn admin_list(pool: &PgPool) -> Result<AdminSeasonListResponse, AppError> {
    let rows: Vec<SeasonRow> = sqlx::query_as(&format!(
        "{SEASON_SELECT} ORDER BY starts_at DESC, id DESC LIMIT 100"
    ))
    .fetch_all(pool)
    .await
    .map_err(AppError::Database)?;
    let now = Utc::now();
    Ok(AdminSeasonListResponse {
        items: rows.into_iter().map(|row| row.into_summary(now)).collect(),
    })
}

struct NormalizedSeasonInput {
    name: String,
    starts_at: DateTime<Utc>,
    ends_at: DateTime<Utc>,
    soft_reset_ratio: f64,
    status: String,
}

fn normalize_input(input: AdminSeasonInput) -> Result<NormalizedSeasonInput, AppError> {
    let name = input.name.trim().to_owned();
    if name.is_empty() || name.chars().count() > MAX_SEASON_NAME_CHARS {
        return Err(AppError::BadRequest(format!(
            "赛季名称不能为空且不超过 {MAX_SEASON_NAME_CHARS} 个字符"
        )));
    }
    if input.ends_at <= input.starts_at {
        return Err(AppError::BadRequest(
            "赛季结束时间必须晚于开始时间".to_owned(),
        ));
    }
    let ratio = input.soft_reset_ratio.unwrap_or(DEFAULT_SOFT_RESET_RATIO);
    if !ratio.is_finite() || !(0.0..=1.0).contains(&ratio) {
        return Err(AppError::BadRequest(
            "软重置系数必须在 0 到 1 之间".to_owned(),
        ));
    }
    let status = input
        .status
        .as_deref()
        .map(str::trim)
        .filter(|value| !value.is_empty())
        .unwrap_or(SEASON_STATUS_DRAFT)
        .to_owned();
    if ![
        SEASON_STATUS_DRAFT,
        SEASON_STATUS_PUBLISHED,
        SEASON_STATUS_CANCELLED,
    ]
    .contains(&status.as_str())
    {
        return Err(AppError::BadRequest("赛季状态无效".to_owned()));
    }
    Ok(NormalizedSeasonInput {
        name,
        starts_at: input.starts_at,
        ends_at: input.ends_at,
        soft_reset_ratio: ratio,
        status,
    })
}

async fn ensure_no_published_overlap(
    transaction: &mut Transaction<'_, Postgres>,
    exclude_id: Option<i32>,
    input: &NormalizedSeasonInput,
) -> Result<(), AppError> {
    if input.status != SEASON_STATUS_PUBLISHED {
        return Ok(());
    }
    let overlap: bool = sqlx::query_scalar(
        "SELECT EXISTS (SELECT 1 FROM seasons \
         WHERE status = 'published' AND ($1::int IS NULL OR id <> $1) \
           AND starts_at < $3 AND ends_at > $2)",
    )
    .bind(exclude_id)
    .bind(input.starts_at)
    .bind(input.ends_at)
    .fetch_one(&mut **transaction)
    .await
    .map_err(AppError::Database)?;
    if overlap {
        return Err(AppError::ConflictWith(
            "该时间段与已发布赛季重叠".to_owned(),
        ));
    }
    Ok(())
}

pub async fn admin_create(
    pool: &PgPool,
    admin_id: i32,
    input: AdminSeasonInput,
) -> Result<SeasonSummary, AppError> {
    let input = normalize_input(input)?;
    let mut transaction = pool.begin().await.map_err(AppError::Database)?;
    ensure_no_published_overlap(&mut transaction, None, &input).await?;
    let id: i32 = sqlx::query_scalar(
        "INSERT INTO seasons (name, starts_at, ends_at, status, soft_reset_ratio, created_by) \
         VALUES ($1, $2, $3, $4, $5, $6) RETURNING id",
    )
    .bind(&input.name)
    .bind(input.starts_at)
    .bind(input.ends_at)
    .bind(&input.status)
    .bind(input.soft_reset_ratio)
    .bind(admin_id)
    .fetch_one(&mut *transaction)
    .await
    .map_err(AppError::Database)?;
    transaction.commit().await.map_err(AppError::Database)?;
    season_summary(pool, id)
        .await?
        .ok_or_else(|| AppError::Internal("赛季创建后读取失败".to_owned()))
}

pub async fn admin_update(
    pool: &PgPool,
    season_id: i32,
    input: AdminSeasonInput,
) -> Result<SeasonSummary, AppError> {
    let input = normalize_input(input)?;
    let mut transaction = pool.begin().await.map_err(AppError::Database)?;
    let existing: Option<SeasonRow> =
        sqlx::query_as(&format!("{SEASON_SELECT} WHERE id = $1 FOR UPDATE"))
            .bind(season_id)
            .fetch_optional(&mut *transaction)
            .await
            .map_err(AppError::Database)?;
    let Some(existing) = existing else {
        return Err(AppError::NotFound("赛季不存在".to_owned()));
    };
    if existing.activated_at.is_some() {
        let times_changed =
            existing.starts_at != input.starts_at || existing.ends_at != input.ends_at;
        let ratio_changed =
            (existing.soft_reset_ratio - input.soft_reset_ratio).abs() > f64::EPSILON;
        if times_changed || ratio_changed {
            return Err(AppError::ConflictWith(
                "赛季已激活，不能修改时间或软重置系数".to_owned(),
            ));
        }
        if input.status != SEASON_STATUS_CANCELLED
            && input.status != SEASON_STATUS_PUBLISHED
            && input.status != existing.status
        {
            return Err(AppError::ConflictWith(
                "赛季已激活，只能保持发布或取消".to_owned(),
            ));
        }
    }
    ensure_no_published_overlap(&mut transaction, Some(season_id), &input).await?;
    sqlx::query(
        "UPDATE seasons SET name = $2, starts_at = $3, ends_at = $4, status = $5, \
         soft_reset_ratio = $6, updated_at = CURRENT_TIMESTAMP WHERE id = $1",
    )
    .bind(season_id)
    .bind(&input.name)
    .bind(input.starts_at)
    .bind(input.ends_at)
    .bind(&input.status)
    .bind(input.soft_reset_ratio)
    .execute(&mut *transaction)
    .await
    .map_err(AppError::Database)?;
    transaction.commit().await.map_err(AppError::Database)?;
    season_summary(pool, season_id)
        .await?
        .ok_or_else(|| AppError::Internal("赛季更新后读取失败".to_owned()))
}

/// Called after a ranked contest settles. `rating_after` is the absolute
/// season rating; `played`/`wins` are incremented exactly once per settlement.
pub async fn record_settlement(
    transaction: &mut Transaction<'_, Postgres>,
    season_id: i32,
    user_id: i32,
    rating_start: i32,
    rating_after: i32,
    rank: i32,
) -> Result<(), AppError> {
    let wins = i32::from(rank == 1);
    sqlx::query(
        "INSERT INTO season_ratings (season_id, user_id, rating, rating_start, played, wins) \
         VALUES ($1, $2, $3, $4, 1, $5) \
         ON CONFLICT (season_id, user_id) DO UPDATE SET \
           rating = EXCLUDED.rating, \
           played = season_ratings.played + 1, \
           wins = season_ratings.wins + EXCLUDED.wins, \
           updated_at = CURRENT_TIMESTAMP",
    )
    .bind(season_id)
    .bind(user_id)
    .bind(rating_after)
    .bind(rating_start)
    .bind(wins)
    .execute(&mut **transaction)
    .await
    .map_err(AppError::Database)?;
    Ok(())
}

/// Called after a disqualification rerank. Only the rating diff is applied so
/// later contests are not overwritten (多还少补).
pub async fn record_rerank(
    transaction: &mut Transaction<'_, Postgres>,
    season_id: i32,
    user_id: i32,
    rating_diff: i32,
    current_rating: i32,
    rank: Option<i32>,
) -> Result<(), AppError> {
    sqlx::query(
        "INSERT INTO season_ratings (season_id, user_id, rating, rating_start, played, wins) \
         VALUES ($1, $2, GREATEST(0, $4), GREATEST(0, $4), 0, 0) \
         ON CONFLICT (season_id, user_id) DO UPDATE SET \
           rating = GREATEST(0, season_ratings.rating + $3), \
           updated_at = CURRENT_TIMESTAMP",
    )
    .bind(season_id)
    .bind(user_id)
    .bind(rating_diff)
    .bind(current_rating)
    .execute(&mut **transaction)
    .await
    .map_err(AppError::Database)?;

    // wins 只由已结束且未取消资格的该赛季比赛决定，避免增量维护出错。
    if rank.is_some() {
        sqlx::query(
            "UPDATE season_ratings SET wins = ( \
                 SELECT COUNT(*)::int FROM contest_participants cp \
                 JOIN contests c ON c.id = cp.contest_id \
                 WHERE cp.user_id = $2 AND c.season_id = $1 AND c.status = 'finished' \
                   AND cp.rank = 1 AND cp.disqualified_at IS NULL \
             ), updated_at = CURRENT_TIMESTAMP \
             WHERE season_id = $1 AND user_id = $2",
        )
        .bind(season_id)
        .bind(user_id)
        .execute(&mut **transaction)
        .await
        .map_err(AppError::Database)?;
    }
    Ok(())
}
