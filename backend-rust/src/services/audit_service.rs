//! 审计中心：敏感操作的统一留痕与管理员查询。
//!
//! 设计见 `doc/2610303_审计中心设计方案.md`。审计写入是尽力而为的：
//! 主操作成功后即使审计落库失败，也只记录服务端告警，不影响业务结果。
//! 需要和业务操作同事务提交的场景使用 [`record_tx`]。

use axum::http::{HeaderMap, header};
use chrono::{DateTime, NaiveDate, TimeZone, Utc};
use serde_json::Value;
use sqlx::{PgPool, Postgres, QueryBuilder, Transaction};

use crate::{
    common::error::AppError,
    middleware::auth::AuthUser,
    models::audit::{
        AuditLogItem, AuditLogListResponse, AuditLogQuery, AuditMetaCount, AuditMetaResponse,
    },
};

const DEFAULT_PAGE: u32 = 1;
const DEFAULT_SIZE: u32 = 20;
const MAX_PAGE_SIZE: u32 = 100;
const MAX_EXPORT_ROWS: i64 = 10_000;
const MAX_SUMMARY_CHARS: usize = 2_000;
const MAX_USER_AGENT_CHARS: usize = 512;
const MAX_IP_CHARS: usize = 64;

/// 请求级审计元数据。登录、管理端写操作等入口从请求头提取一次后向下传递。
#[derive(Debug, Clone, Default)]
pub struct AuditContext {
    pub ip: Option<String>,
    pub user_agent: Option<String>,
}

impl AuditContext {
    pub fn from_headers(headers: &HeaderMap) -> Self {
        let ip = headers
            .get("x-forwarded-for")
            .and_then(|value| value.to_str().ok())
            .and_then(|value| value.split(',').next())
            .map(str::trim)
            .filter(|value| !value.is_empty())
            .or_else(|| {
                headers
                    .get("x-real-ip")
                    .and_then(|value| value.to_str().ok())
                    .map(str::trim)
                    .filter(|value| !value.is_empty())
            })
            .map(|value| truncate_chars(value, MAX_IP_CHARS));
        let user_agent = headers
            .get(header::USER_AGENT)
            .and_then(|value| value.to_str().ok())
            .map(|value| truncate_chars(value, MAX_USER_AGENT_CHARS))
            .filter(|value| !value.is_empty());
        Self { ip, user_agent }
    }
}

/// 一条待写入的审计记录。
pub struct AuditRecord<'a> {
    pub action: &'a str,
    pub target_type: &'a str,
    pub target_id: Option<i64>,
    pub summary: String,
    pub before: Option<Value>,
    pub after: Option<Value>,
}

impl<'a> AuditRecord<'a> {
    pub fn new(
        action: &'a str,
        target_type: &'a str,
        target_id: Option<i64>,
        summary: impl Into<String>,
    ) -> Self {
        Self {
            action,
            target_type,
            target_id,
            summary: summary.into(),
            before: None,
            after: None,
        }
    }

    pub fn before(mut self, value: Value) -> Self {
        self.before = Some(value);
        self
    }

    pub fn after(mut self, value: Value) -> Self {
        self.after = Some(value);
        self
    }
}

/// 尽力写入审计；失败只记录服务端告警。
pub async fn record(
    pool: &PgPool,
    actor: &AuthUser,
    context: &AuditContext,
    entry: AuditRecord<'_>,
) {
    if let Err(error) = insert(pool, actor, context, &entry).await {
        tracing::warn!(
            error = ?error,
            action = entry.action,
            actor_id = actor.id,
            "failed to write audit log"
        );
    }
}

/// 在与业务操作相同的事务内写入审计；失败会让整个事务回滚。
pub async fn record_tx(
    transaction: &mut Transaction<'_, Postgres>,
    actor: &AuthUser,
    context: &AuditContext,
    entry: AuditRecord<'_>,
) -> Result<(), AppError> {
    insert_tx(transaction, actor, context, &entry).await
}

async fn insert(
    pool: &PgPool,
    actor: &AuthUser,
    context: &AuditContext,
    entry: &AuditRecord<'_>,
) -> Result<(), sqlx::Error> {
    sqlx::query(
        "INSERT INTO audit_logs \
         (actor_id, actor_username, actor_role, action, target_type, target_id, \
          summary, before, after, ip, user_agent) \
         VALUES ($1, $2, $3, $4, $5, $6, $7, $8, $9, $10, $11)",
    )
    .bind(actor.id)
    .bind(&actor.username)
    .bind(&actor.role)
    .bind(entry.action)
    .bind(entry.target_type)
    .bind(entry.target_id)
    .bind(truncate_chars(&entry.summary, MAX_SUMMARY_CHARS))
    .bind(entry.before.as_ref())
    .bind(entry.after.as_ref())
    .bind(context.ip.as_deref())
    .bind(context.user_agent.as_deref())
    .execute(pool)
    .await?;
    Ok(())
}

async fn insert_tx(
    transaction: &mut Transaction<'_, Postgres>,
    actor: &AuthUser,
    context: &AuditContext,
    entry: &AuditRecord<'_>,
) -> Result<(), AppError> {
    sqlx::query(
        "INSERT INTO audit_logs \
         (actor_id, actor_username, actor_role, action, target_type, target_id, \
          summary, before, after, ip, user_agent) \
         VALUES ($1, $2, $3, $4, $5, $6, $7, $8, $9, $10, $11)",
    )
    .bind(actor.id)
    .bind(&actor.username)
    .bind(&actor.role)
    .bind(entry.action)
    .bind(entry.target_type)
    .bind(entry.target_id)
    .bind(truncate_chars(&entry.summary, MAX_SUMMARY_CHARS))
    .bind(entry.before.as_ref())
    .bind(entry.after.as_ref())
    .bind(context.ip.as_deref())
    .bind(context.user_agent.as_deref())
    .execute(&mut **transaction)
    .await
    .map_err(AppError::Database)?;
    Ok(())
}

pub async fn list(pool: &PgPool, query: &AuditLogQuery) -> Result<AuditLogListResponse, AppError> {
    let page = query.page.unwrap_or(DEFAULT_PAGE).max(1);
    let size = query.size.unwrap_or(DEFAULT_SIZE).clamp(1, MAX_PAGE_SIZE);
    let offset = i64::from(page - 1) * i64::from(size);
    let filters = Filters::from_query(query)?;

    let mut count_builder =
        QueryBuilder::<Postgres>::new("SELECT COUNT(*) FROM audit_logs a WHERE 1 = 1");
    filters.push(&mut count_builder);
    let total: i64 = count_builder
        .build_query_scalar()
        .fetch_one(pool)
        .await
        .map_err(AppError::Database)?;

    let mut builder = QueryBuilder::<Postgres>::new(
        "SELECT a.id, a.actor_id, a.actor_username, a.actor_role, a.action, a.target_type, \
         a.target_id, a.summary, a.before, a.after, a.ip, a.user_agent, a.created_at \
         FROM audit_logs a WHERE 1 = 1",
    );
    filters.push(&mut builder);
    builder
        .push(" ORDER BY a.created_at DESC, a.id DESC LIMIT ")
        .push_bind(i64::from(size))
        .push(" OFFSET ")
        .push_bind(offset);
    let logs: Vec<AuditLogItem> = builder
        .build_query_as()
        .fetch_all(pool)
        .await
        .map_err(AppError::Database)?;

    Ok(AuditLogListResponse {
        total,
        page,
        size,
        logs,
    })
}

pub async fn meta(pool: &PgPool) -> Result<AuditMetaResponse, AppError> {
    let actions: Vec<AuditMetaCount> = sqlx::query_as(
        "SELECT action AS value, COUNT(*) AS count FROM audit_logs \
         GROUP BY action ORDER BY count DESC, action ASC",
    )
    .fetch_all(pool)
    .await
    .map_err(AppError::Database)?;
    let target_types: Vec<AuditMetaCount> = sqlx::query_as(
        "SELECT target_type AS value, COUNT(*) AS count FROM audit_logs \
         GROUP BY target_type ORDER BY count DESC, target_type ASC",
    )
    .fetch_all(pool)
    .await
    .map_err(AppError::Database)?;
    let total: i64 = sqlx::query_scalar("SELECT COUNT(*) FROM audit_logs")
        .fetch_one(pool)
        .await
        .map_err(AppError::Database)?;
    Ok(AuditMetaResponse {
        actions,
        target_types,
        total,
    })
}

/// 导出当前筛选条件下的审计日志 CSV，最多 `MAX_EXPORT_ROWS` 行。
pub async fn export_csv(pool: &PgPool, query: &AuditLogQuery) -> Result<String, AppError> {
    let filters = Filters::from_query(query)?;
    let mut builder = QueryBuilder::<Postgres>::new(
        "SELECT a.id, a.actor_id, a.actor_username, a.actor_role, a.action, a.target_type, \
         a.target_id, a.summary, a.before, a.after, a.ip, a.user_agent, a.created_at \
         FROM audit_logs a WHERE 1 = 1",
    );
    filters.push(&mut builder);
    builder
        .push(" ORDER BY a.created_at DESC, a.id DESC LIMIT ")
        .push_bind(MAX_EXPORT_ROWS);
    let logs: Vec<AuditLogItem> = builder
        .build_query_as()
        .fetch_all(pool)
        .await
        .map_err(AppError::Database)?;

    let mut out = String::from("\u{feff}");
    out.push_str("时间,操作者,角色,动作,对象类型,对象ID,摘要,变更前,变更后,IP,User-Agent\r\n");
    for log in logs {
        let columns = [
            log.created_at.format("%Y-%m-%d %H:%M:%S UTC").to_string(),
            log.actor_username.clone(),
            log.actor_role.clone(),
            log.action.clone(),
            log.target_type.clone(),
            log.target_id.map(|id| id.to_string()).unwrap_or_default(),
            log.summary.clone(),
            json_text(log.before.as_ref()),
            json_text(log.after.as_ref()),
            log.ip.clone().unwrap_or_default(),
            log.user_agent.clone().unwrap_or_default(),
        ];
        out.push_str(
            &columns
                .iter()
                .map(|value| escape_csv(value))
                .collect::<Vec<_>>()
                .join(","),
        );
        out.push_str("\r\n");
    }
    Ok(out)
}

struct Filters {
    action: Option<String>,
    target_type: Option<String>,
    actor_id: Option<i32>,
    q: Option<String>,
    from: Option<DateTime<Utc>>,
    to: Option<DateTime<Utc>>,
}

impl Filters {
    fn from_query(query: &AuditLogQuery) -> Result<Self, AppError> {
        let clean = |value: &Option<String>| {
            value
                .as_deref()
                .map(str::trim)
                .filter(|value| !value.is_empty())
                .map(str::to_owned)
        };
        let from = parse_bound(query.from.as_deref(), false)?;
        let to = parse_bound(query.to.as_deref(), true)?;
        if let (Some(from), Some(to)) = (&from, &to)
            && from > to
        {
            return Err(AppError::BadRequest("开始时间不能晚于结束时间".to_owned()));
        }
        Ok(Self {
            action: clean(&query.action),
            target_type: clean(&query.target_type),
            actor_id: query.actor_id.filter(|id| *id > 0),
            q: clean(&query.q),
            from,
            to,
        })
    }

    fn push(&self, builder: &mut QueryBuilder<'_, Postgres>) {
        if let Some(action) = &self.action {
            builder.push(" AND a.action = ").push_bind(action.clone());
        }
        if let Some(target_type) = &self.target_type {
            builder
                .push(" AND a.target_type = ")
                .push_bind(target_type.clone());
        }
        if let Some(actor_id) = self.actor_id {
            builder.push(" AND a.actor_id = ").push_bind(actor_id);
        }
        if let Some(q) = &self.q {
            let pattern = format!("%{}%", escape_like(q));
            builder
                .push(" AND (a.actor_username ILIKE ")
                .push_bind(pattern.clone())
                .push(" OR a.action ILIKE ")
                .push_bind(pattern.clone())
                .push(" OR a.summary ILIKE ")
                .push_bind(pattern.clone())
                .push(" OR a.ip ILIKE ")
                .push_bind(pattern)
                .push(")");
        }
        if let Some(from) = self.from {
            builder.push(" AND a.created_at >= ").push_bind(from);
        }
        if let Some(to) = self.to {
            builder.push(" AND a.created_at <= ").push_bind(to);
        }
    }
}

/// `YYYY-MM-DD` 按整天处理；带时区的时间按 RFC3339 解析后统一转 UTC。
fn parse_bound(value: Option<&str>, end_of_day: bool) -> Result<Option<DateTime<Utc>>, AppError> {
    let Some(value) = value.map(str::trim).filter(|value| !value.is_empty()) else {
        return Ok(None);
    };
    if let Ok(date) = NaiveDate::parse_from_str(value, "%Y-%m-%d") {
        let datetime = if end_of_day {
            date.and_hms_opt(23, 59, 59)
        } else {
            date.and_hms_opt(0, 0, 0)
        }
        .ok_or_else(|| AppError::BadRequest("时间范围无效".to_owned()))?;
        return Ok(Some(Utc.from_utc_datetime(&datetime)));
    }
    DateTime::parse_from_rfc3339(value)
        .map(|value| Some(value.with_timezone(&Utc)))
        .map_err(|_| AppError::BadRequest("时间格式无效，请使用 YYYY-MM-DD 或 RFC3339".to_owned()))
}

fn truncate_chars(value: &str, max: usize) -> String {
    if value.chars().count() <= max {
        return value.to_owned();
    }
    value.chars().take(max).collect()
}

fn escape_like(value: &str) -> String {
    value
        .replace('\\', "\\\\")
        .replace('%', "\\%")
        .replace('_', "\\_")
}

fn json_text(value: Option<&Value>) -> String {
    value
        .map(|value| serde_json::to_string(value).unwrap_or_default())
        .unwrap_or_default()
}

fn escape_csv(value: &str) -> String {
    if value.contains(['"', ',', '\n', '\r']) {
        format!("\"{}\"", value.replace('"', "\"\""))
    } else {
        value.to_owned()
    }
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn parses_date_bounds() {
        let from = parse_bound(Some("2026-10-01"), false).unwrap().unwrap();
        assert_eq!(from.to_rfc3339(), "2026-10-01T00:00:00+00:00");
        let to = parse_bound(Some("2026-10-01"), true).unwrap().unwrap();
        assert_eq!(to.to_rfc3339(), "2026-10-01T23:59:59+00:00");
    }

    #[test]
    fn rejects_invalid_bound() {
        assert!(matches!(
            parse_bound(Some("yesterday"), false),
            Err(AppError::BadRequest(_))
        ));
    }

    #[test]
    fn escapes_csv_fields() {
        assert_eq!(escape_csv("plain"), "plain");
        assert_eq!(escape_csv("a,b"), "\"a,b\"");
        assert_eq!(escape_csv("say \"hi\""), "\"say \"\"hi\"\"\"");
    }

    #[test]
    fn escapes_like_wildcards() {
        assert_eq!(escape_like("50%_off"), "50\\%\\_off");
    }
}
