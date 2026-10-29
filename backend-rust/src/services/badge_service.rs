use std::collections::HashMap;

use chrono::{DateTime, Utc};
use sqlx::{FromRow, PgPool, Postgres, Transaction};

use crate::{
    common::error::AppError,
    models::badge::{BadgeItem, BadgeListResponse, UpdateBadgeVisibilityResponse},
};

#[derive(FromRow)]
struct BadgeCatalogRow {
    code: String,
    name: String,
    validity_days: i32,
}

#[derive(FromRow)]
struct ExistingBadgeRow {
    badge_code: String,
    is_active: bool,
}

#[derive(FromRow)]
struct BadgeRow {
    code: String,
    name: String,
    description: String,
    category: String,
    threshold_days: i32,
    awarded_at: Option<DateTime<Utc>>,
    expires_at: Option<DateTime<Utc>>,
    hidden: Option<bool>,
}

/// Grants or refreshes every check-in badge the current streak qualifies for.
/// Returns the names of badges that were not active before this call.
pub async fn sync_checkin_badges(
    transaction: &mut Transaction<'_, Postgres>,
    user_id: i32,
    streak_days: i64,
) -> Result<Vec<String>, AppError> {
    let streak = i32::try_from(streak_days).unwrap_or(i32::MAX);
    let catalog: Vec<BadgeCatalogRow> = sqlx::query_as(
        "SELECT code, name, validity_days FROM badge_catalog \
         WHERE category = 'checkin' AND threshold_days <= $1 \
         ORDER BY threshold_days, sort_order",
    )
    .bind(streak)
    .fetch_all(&mut **transaction)
    .await
    .map_err(AppError::Database)?;
    if catalog.is_empty() {
        return Ok(Vec::new());
    }

    let existing: Vec<ExistingBadgeRow> = sqlx::query_as(
        "SELECT badge_code, (expires_at > CURRENT_TIMESTAMP) AS is_active \
         FROM user_badges WHERE user_id = $1",
    )
    .bind(user_id)
    .fetch_all(&mut **transaction)
    .await
    .map_err(AppError::Database)?;
    let active: HashMap<String, bool> = existing
        .into_iter()
        .map(|row| (row.badge_code, row.is_active))
        .collect();

    let mut newly_active = Vec::new();
    for badge in catalog {
        if !active.get(&badge.code).copied().unwrap_or(false) {
            newly_active.push(badge.name.clone());
        }
        sqlx::query(
            "INSERT INTO user_badges (user_id, badge_code, awarded_at, expires_at) \
             VALUES ($1, $2, CURRENT_TIMESTAMP, \
                     CURRENT_TIMESTAMP + make_interval(days => $3)) \
             ON CONFLICT (user_id, badge_code) DO UPDATE SET \
                 awarded_at = CASE WHEN user_badges.expires_at <= CURRENT_TIMESTAMP \
                                   THEN CURRENT_TIMESTAMP ELSE user_badges.awarded_at END, \
                 expires_at = CURRENT_TIMESTAMP + make_interval(days => $3)",
        )
        .bind(user_id)
        .bind(&badge.code)
        .bind(badge.validity_days)
        .execute(&mut **transaction)
        .await
        .map_err(AppError::Database)?;
    }
    Ok(newly_active)
}

pub async fn list_own_badges(pool: &PgPool, user_id: i32) -> Result<BadgeListResponse, AppError> {
    let rows: Vec<BadgeRow> = sqlx::query_as(
        "SELECT b.code, b.name, b.description, b.category, b.threshold_days, \
                ub.awarded_at, ub.expires_at, ub.hidden \
         FROM badge_catalog b \
         LEFT JOIN user_badges ub \
           ON ub.badge_code = b.code AND ub.user_id = $1 \
          AND ub.expires_at > CURRENT_TIMESTAMP \
         ORDER BY b.sort_order, b.threshold_days",
    )
    .bind(user_id)
    .fetch_all(pool)
    .await
    .map_err(AppError::Database)?;
    Ok(BadgeListResponse {
        badges: rows
            .into_iter()
            .map(|row| BadgeItem {
                code: row.code,
                name: row.name,
                description: row.description,
                category: row.category,
                threshold_days: row.threshold_days,
                earned: row.expires_at.is_some(),
                awarded_at: row.awarded_at,
                expires_at: row.expires_at,
                hidden: row.hidden.unwrap_or(false),
            })
            .collect(),
    })
}

pub async fn set_badge_hidden(
    pool: &PgPool,
    user_id: i32,
    code: &str,
    hidden: bool,
) -> Result<UpdateBadgeVisibilityResponse, AppError> {
    let result = sqlx::query(
        "UPDATE user_badges SET hidden = $3 \
         WHERE user_id = $1 AND badge_code = $2 AND expires_at > CURRENT_TIMESTAMP",
    )
    .bind(user_id)
    .bind(code)
    .bind(hidden)
    .execute(pool)
    .await
    .map_err(AppError::Database)?;
    if result.rows_affected() == 0 {
        return Err(AppError::NotFound("徽章不存在或已失效".to_owned()));
    }
    Ok(UpdateBadgeVisibilityResponse {
        code: code.to_owned(),
        hidden,
        message: if hidden {
            "徽章已隐藏".to_owned()
        } else {
            "徽章已展示".to_owned()
        },
    })
}
