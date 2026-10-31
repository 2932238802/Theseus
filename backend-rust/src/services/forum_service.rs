use std::collections::HashMap;

use chrono::{DateTime, TimeDelta, Utc};
use serde_json::{Value, json};
use sqlx::{FromRow, PgPool, Postgres, QueryBuilder, Transaction};

use crate::{
    common::error::{AppError, is_unique_violation},
    config::Config,
    middleware::auth::AuthUser,
    models::forum::{
        AdminActionActor, AdminActionListQuery, AdminActionListResponse, AdminActionRow,
        AdminAuthor, AdminForumCommentRow, AdminForumPostDetail, AdminForumPostListQuery,
        AdminForumPostListResponse, AdminForumPostRow, AdminMuteRequest, AdminPinRequest,
        AdminReportDecisionRequest, AdminReportListQuery, AdminReportListResponse, AdminReportRow,
        AdminReportTargetPreview, AdminStatusRequest, BOARD_GENERAL, BOARD_INTERVIEW,
        CreateCommentRequest, CreatePostRequest, CreateReportRequest, FavoriteResponse,
        ForumCommentCreated, ForumCommentListQuery, ForumCommentRow, ForumCommentsResponse,
        ForumInterviewFacets, ForumMutationResponse, ForumPostCreated, ForumPostDetail,
        ForumPostListQuery, ForumPostListResponse, ForumPostRow, ForumRepliesResponse,
        ForumReplyListQuery, ForumReplyView, ForumReportResponse, LikeResponse,
        MAX_COMMENT_BODY_CHARS, MAX_EMBEDDED_REPLIES, MAX_INTERVIEW_DATE_CHARS,
        MAX_INTERVIEW_META_CHARS, MAX_INTERVIEW_TAG_CHARS, MAX_INTERVIEW_TAGS, MAX_POST_BODY_CHARS,
        MAX_REASON_CHARS, MAX_REPORT_DETAIL_CHARS, MAX_SEARCH_CHARS, MAX_TITLE_CHARS, MuteResponse,
        PinResponse, PublicAuthor, ReplyTo, ReportDecisionResponse, UpdateCommentRequest,
        UpdatePostRequest, is_known_board, is_known_report_reason, is_known_tag,
    },
    services::{notification_service, plus_service},
};

const DEFAULT_PAGE: u32 = 1;
const DEFAULT_SIZE: u32 = 20;
const MAX_PUBLIC_PAGE_SIZE: u32 = 50;
const MAX_ADMIN_PAGE_SIZE: u32 = 100;
const MAX_MUTE_HOURS: i64 = 8_760;
const REPUTATION_FORUM_MINIMUM: f64 = 40.0;

pub fn ensure_enabled(config: &Config) -> Result<(), AppError> {
    if config.forum_enabled {
        Ok(())
    } else {
        Err(AppError::ServiceUnavailable("论坛功能暂未开放".to_owned()))
    }
}

fn page_and_size(page: Option<u32>, size: Option<u32>, max_size: u32) -> (u32, u32) {
    (
        page.unwrap_or(DEFAULT_PAGE).max(1),
        size.unwrap_or(DEFAULT_SIZE).clamp(1, max_size),
    )
}

fn escape_like(value: &str) -> String {
    value
        .replace('\\', "\\\\")
        .replace('%', "\\%")
        .replace('_', "\\_")
}

fn like_pattern(value: &str) -> String {
    format!("%{}%", escape_like(value))
}

fn mute_ends_at(
    now: DateTime<Utc>,
    duration_hours: Option<i64>,
) -> Result<Option<DateTime<Utc>>, AppError> {
    let Some(hours) = duration_hours else {
        return Ok(None);
    };
    if hours <= 0 {
        return Err(AppError::BadRequest("禁言时长必须为正整数".to_owned()));
    }
    let max_duration = TimeDelta::try_hours(MAX_MUTE_HOURS)
        .ok_or_else(|| AppError::BadRequest("禁言时长上限配置无效".to_owned()))?;
    let duration = TimeDelta::try_hours(hours)
        .filter(|value| *value <= max_duration)
        .ok_or_else(|| AppError::BadRequest("禁言时长无效".to_owned()))?;
    let ends_at = now
        .checked_add_signed(duration)
        .ok_or_else(|| AppError::BadRequest("禁言时长无效".to_owned()))?;
    Ok(Some(ends_at))
}

async fn acquire_user_lock(
    tx: &mut Transaction<'_, Postgres>,
    namespace: i32,
    user_id: i32,
) -> Result<(), AppError> {
    sqlx::query("SELECT pg_advisory_xact_lock($1, $2)")
        .bind(namespace)
        .bind(user_id)
        .execute(&mut **tx)
        .await
        .map_err(AppError::Database)?;
    Ok(())
}

pub fn make_excerpt(body: &str, max_chars: usize) -> String {
    let mut pieces = Vec::new();
    for line in body.lines() {
        let trimmed = line.trim();
        if trimmed.is_empty() || trimmed.starts_with("```") {
            continue;
        }
        let cleaned = trimmed
            .trim_start_matches('#')
            .trim_start_matches(['>', '-', '*', '+'])
            .trim();
        if !cleaned.is_empty() {
            pieces.push(cleaned);
        }
        if pieces.join(" ").chars().count() >= max_chars {
            break;
        }
    }
    let collapsed = pieces.join(" ");
    if collapsed.chars().count() > max_chars {
        let mut excerpt: String = collapsed
            .chars()
            .take(max_chars.saturating_sub(1))
            .collect();
        excerpt.push('…');
        excerpt
    } else {
        collapsed
    }
}

fn char_count(value: &str) -> usize {
    value.chars().count()
}

fn normalize_tags(tags: &[String], is_admin: bool, board: &str) -> Result<Vec<String>, AppError> {
    let mut normalized: Vec<String> = Vec::new();
    for tag in tags {
        let tag = tag.trim();
        if tag.is_empty() {
            return Err(AppError::BadRequest("标签不能为空".to_owned()));
        }
        if board == BOARD_INTERVIEW {
            if char_count(tag) > MAX_INTERVIEW_TAG_CHARS {
                return Err(AppError::BadRequest(format!(
                    "单个标签不能超过 {MAX_INTERVIEW_TAG_CHARS} 字"
                )));
            }
        } else {
            if !is_known_tag(tag) {
                return Err(AppError::BadRequest(format!("未知的标签：{tag}")));
            }
            if tag == "announcement" && !is_admin {
                return Err(AppError::BadRequest("只有管理员可以发布公告".to_owned()));
            }
        }
        if !normalized.iter().any(|value| value.as_str() == tag) {
            normalized.push(tag.to_owned());
        }
    }
    if normalized.is_empty() {
        return Err(AppError::BadRequest("请至少选择一个标签".to_owned()));
    }
    let max_tags = if board == BOARD_INTERVIEW {
        MAX_INTERVIEW_TAGS
    } else {
        3
    };
    if normalized.len() > max_tags {
        return Err(AppError::BadRequest(format!(
            "每帖最多选择 {max_tags} 个标签"
        )));
    }
    Ok(normalized)
}

fn normalize_board(value: Option<&str>) -> Result<&'static str, AppError> {
    let board = value
        .map(str::trim)
        .filter(|value| !value.is_empty())
        .unwrap_or(BOARD_GENERAL);
    if !is_known_board(board) {
        return Err(AppError::BadRequest("未知的板块".to_owned()));
    }
    if board == BOARD_INTERVIEW {
        Ok(BOARD_INTERVIEW)
    } else {
        Ok(BOARD_GENERAL)
    }
}

fn normalize_interview_meta(value: Option<&str>, label: &str) -> Result<Option<String>, AppError> {
    let value = value.map(str::trim).unwrap_or_default();
    if value.is_empty() {
        return Ok(None);
    }
    if char_count(value) > MAX_INTERVIEW_META_CHARS {
        return Err(AppError::BadRequest(format!(
            "{label}不能超过 {MAX_INTERVIEW_META_CHARS} 个字符"
        )));
    }
    Ok(Some(value.to_owned()))
}

fn normalize_interview_date(value: Option<&str>) -> Result<Option<String>, AppError> {
    let value = value.map(str::trim).unwrap_or_default();
    if value.is_empty() {
        return Ok(None);
    }
    let bytes = value.as_bytes();
    let valid = bytes.len() == MAX_INTERVIEW_DATE_CHARS
        && bytes[4] == b'-'
        && bytes[..4].iter().all(|byte| byte.is_ascii_digit())
        && bytes[5..].iter().all(|byte| byte.is_ascii_digit())
        && {
            let month = (bytes[5] - b'0') * 10 + (bytes[6] - b'0');
            (1..=12).contains(&month)
        };
    if !valid {
        return Err(AppError::BadRequest("面试时间格式应为 YYYY-MM".to_owned()));
    }
    Ok(Some(value.to_owned()))
}

async fn ensure_board_access(
    pool: &PgPool,
    user: Option<&AuthUser>,
    board: &str,
    author_id: Option<i32>,
) -> Result<(), AppError> {
    if board != BOARD_INTERVIEW {
        return Ok(());
    }
    let Some(user) = user else {
        return Err(AppError::Unauthorized);
    };
    if user.is_admin() || author_id == Some(user.id) {
        return Ok(());
    }
    if plus_service::is_plus(pool, user.id).await? {
        return Ok(());
    }
    Err(AppError::ForbiddenWith(
        "需要开通 Plus Theseus 才能查看面经".to_owned(),
    ))
}

fn normalized_post(
    title: &str,
    body: &str,
    tags: &[String],
    is_admin: bool,
    board: &str,
) -> Result<(String, String, Vec<String>), AppError> {
    let title = title.trim();
    let body = body.trim();
    if title.is_empty() {
        return Err(AppError::BadRequest("标题不能为空".to_owned()));
    }
    if char_count(title) > MAX_TITLE_CHARS {
        return Err(AppError::BadRequest(format!(
            "标题不能超过 {MAX_TITLE_CHARS} 个字符"
        )));
    }
    if body.is_empty() {
        return Err(AppError::BadRequest("正文不能为空".to_owned()));
    }
    if char_count(body) > MAX_POST_BODY_CHARS {
        return Err(AppError::BadRequest(format!(
            "正文不能超过 {MAX_POST_BODY_CHARS} 个字符"
        )));
    }
    Ok((
        title.to_owned(),
        body.to_owned(),
        normalize_tags(tags, is_admin, board)?,
    ))
}

fn normalized_comment_body(body: &str) -> Result<String, AppError> {
    let body = body.trim();
    if body.is_empty() {
        return Err(AppError::BadRequest("评论内容不能为空".to_owned()));
    }
    if char_count(body) > MAX_COMMENT_BODY_CHARS {
        return Err(AppError::BadRequest(format!(
            "评论不能超过 {MAX_COMMENT_BODY_CHARS} 个字符"
        )));
    }
    Ok(body.to_owned())
}

async fn validate_problem_reference(
    pool: &PgPool,
    problem_id: Option<i32>,
) -> Result<(), AppError> {
    let Some(problem_id) = problem_id else {
        return Ok(());
    };
    if problem_id <= 0 {
        return Err(AppError::BadRequest("题目 ID 无效".to_owned()));
    }
    let exists: Option<(i32,)> =
        sqlx::query_as("SELECT id FROM problems WHERE id = $1 AND review_status = 'approved'")
            .bind(problem_id)
            .fetch_optional(pool)
            .await
            .map_err(AppError::Database)?;
    if exists.is_none() {
        return Err(AppError::BadRequest(
            "关联题目不存在或未通过审核".to_owned(),
        ));
    }
    Ok(())
}

async fn username_of(pool: &PgPool, user_id: i32) -> Result<String, AppError> {
    sqlx::query_scalar::<_, String>("SELECT username FROM users WHERE id = $1")
        .bind(user_id)
        .fetch_optional(pool)
        .await
        .map_err(AppError::Database)?
        .ok_or(AppError::Unauthorized)
}

async fn ensure_not_muted(
    tx: &mut Transaction<'_, Postgres>,
    user_id: i32,
) -> Result<(), AppError> {
    let reputation_score: f64 =
        sqlx::query_scalar("SELECT reputation_score::float8 FROM users WHERE id = $1")
            .bind(user_id)
            .fetch_one(&mut **tx)
            .await
            .map_err(AppError::Database)?;
    if reputation_score < REPUTATION_FORUM_MINIMUM {
        return Err(AppError::ForbiddenWith(
            "信誉分低于 40 暂不能在论坛发言".to_owned(),
        ));
    }
    let muted: bool = sqlx::query_scalar(
        "SELECT EXISTS (SELECT 1 FROM user_mutes WHERE user_id = $1 AND revoked_at IS NULL \
         AND starts_at <= CURRENT_TIMESTAMP AND (ends_at IS NULL OR ends_at > CURRENT_TIMESTAMP))",
    )
    .bind(user_id)
    .fetch_one(&mut **tx)
    .await
    .map_err(AppError::Database)?;
    if muted {
        return Err(AppError::ForbiddenWith(
            "你已被禁言，解除后可继续发言".to_owned(),
        ));
    }
    Ok(())
}

async fn ensure_post_limits(
    tx: &mut Transaction<'_, Postgres>,
    config: &Config,
    user_id: i32,
) -> Result<(), AppError> {
    if config.forum_post_cooldown_secs > 0 {
        let last: Option<DateTime<Utc>> = sqlx::query_scalar(
            "SELECT created_at FROM forum_posts WHERE author_id = $1 \
             ORDER BY created_at DESC LIMIT 1",
        )
        .bind(user_id)
        .fetch_optional(&mut **tx)
        .await
        .map_err(AppError::Database)?;
        if let Some(last) = last {
            let elapsed = Utc::now().signed_duration_since(last).num_seconds();
            let cooldown = config.forum_post_cooldown_secs as i64;
            if elapsed < cooldown {
                return Err(AppError::RateLimited(
                    "发帖过于频繁，请稍后再试".to_owned(),
                    (cooldown - elapsed).max(1) as u64,
                ));
            }
        }
    }
    let today: i64 = sqlx::query_scalar(
        "SELECT COUNT(*) FROM forum_posts WHERE author_id = $1 AND created_at >= CURRENT_DATE",
    )
    .bind(user_id)
    .fetch_one(&mut **tx)
    .await
    .map_err(AppError::Database)?;
    if today >= config.forum_post_daily_limit as i64 {
        return Err(AppError::RateLimited(
            "今日发帖次数已达上限".to_owned(),
            86_400,
        ));
    }
    Ok(())
}

async fn ensure_comment_limits(
    tx: &mut Transaction<'_, Postgres>,
    config: &Config,
    user_id: i32,
) -> Result<(), AppError> {
    if config.forum_comment_cooldown_secs > 0 {
        let last: Option<DateTime<Utc>> = sqlx::query_scalar(
            "SELECT created_at FROM forum_comments WHERE author_id = $1 \
             ORDER BY created_at DESC LIMIT 1",
        )
        .bind(user_id)
        .fetch_optional(&mut **tx)
        .await
        .map_err(AppError::Database)?;
        if let Some(last) = last {
            let elapsed = Utc::now().signed_duration_since(last).num_seconds();
            let cooldown = config.forum_comment_cooldown_secs as i64;
            if elapsed < cooldown {
                return Err(AppError::RateLimited(
                    "评论过于频繁，请稍后再试".to_owned(),
                    (cooldown - elapsed).max(1) as u64,
                ));
            }
        }
    }
    let today: i64 = sqlx::query_scalar(
        "SELECT COUNT(*) FROM forum_comments WHERE author_id = $1 AND created_at >= CURRENT_DATE",
    )
    .bind(user_id)
    .fetch_one(&mut **tx)
    .await
    .map_err(AppError::Database)?;
    if today >= config.forum_comment_daily_limit as i64 {
        return Err(AppError::RateLimited(
            "今日评论次数已达上限".to_owned(),
            86_400,
        ));
    }
    Ok(())
}

async fn ensure_report_limit(
    tx: &mut Transaction<'_, Postgres>,
    config: &Config,
    user_id: i32,
) -> Result<(), AppError> {
    let today: i64 = sqlx::query_scalar(
        "SELECT COUNT(*) FROM forum_reports WHERE reporter_id = $1 AND created_at >= CURRENT_DATE",
    )
    .bind(user_id)
    .fetch_one(&mut **tx)
    .await
    .map_err(AppError::Database)?;
    if today >= config.forum_report_daily_limit as i64 {
        return Err(AppError::RateLimited(
            "今日举报次数已达上限".to_owned(),
            86_400,
        ));
    }
    Ok(())
}

/// Shared SELECT for public post projections. Callers must bind `viewer_id`
/// twice (for `liked` and `favorited`) before appending `FROM ...`.
fn push_public_post_select(builder: &mut QueryBuilder<'_, Postgres>, viewer_id: Option<i32>) {
    builder.push(
        "SELECT fp.id, fp.author_id, u.username AS author_username, \
         EXISTS (SELECT 1 FROM plus_memberships pm WHERE pm.user_id = fp.author_id \
         AND pm.expires_at > CURRENT_TIMESTAMP) AS author_is_plus, fp.board, fp.title, \
         fp.body_md, fp.tags, fp.interview_date, fp.company, fp.role, fp.view_count, \
         fp.problem_id, p.title AS problem_title, \
         p.difficulty AS problem_difficulty, \
         fp.is_anonymous, fp.status, fp.hidden_reason, fp.is_pinned, fp.like_count, \
         fp.favorite_count, fp.comment_count, fp.created_at, fp.updated_at, fp.edited_at, \
         EXISTS (SELECT 1 FROM forum_post_likes l WHERE l.post_id = fp.id AND l.user_id = ",
    );
    builder.push_bind(viewer_id);
    builder.push(
        ") AS liked, EXISTS (SELECT 1 FROM forum_post_favorites f \
         WHERE f.post_id = fp.id AND f.user_id = ",
    );
    builder.push_bind(viewer_id);
    builder.push(
        ") AS favorited, COUNT(*) OVER() AS total \
         FROM forum_posts fp \
         JOIN users u ON u.id = fp.author_id \
         LEFT JOIN problems p ON p.id = fp.problem_id AND p.review_status = 'approved'",
    );
}

pub async fn list_posts(
    pool: &PgPool,
    config: &Config,
    viewer: Option<&AuthUser>,
    query: &ForumPostListQuery,
) -> Result<ForumPostListResponse, AppError> {
    ensure_enabled(config)?;
    let viewer_id = viewer.map(|user| user.id);
    let (page, size) = page_and_size(query.page, query.size, MAX_PUBLIC_PAGE_SIZE);
    let sort = query.sort.as_deref().unwrap_or("latest");
    if !matches!(sort, "latest" | "hot") {
        return Err(AppError::BadRequest("不支持的排序方式".to_owned()));
    }
    let mine_user = if query.mine.unwrap_or(false) {
        Some(viewer_id.ok_or(AppError::Unauthorized)?)
    } else {
        None
    };
    let board = normalize_board(query.board.as_deref())?;
    if board == BOARD_INTERVIEW {
        let Some(user) = viewer else {
            return Err(AppError::Unauthorized);
        };
        if !user.is_admin()
            && mine_user != Some(user.id)
            && !plus_service::is_plus(pool, user.id).await?
        {
            return Err(AppError::ForbiddenWith(
                "需要开通 Plus Theseus 才能查看面经".to_owned(),
            ));
        }
    }
    let tag = query
        .tag
        .as_deref()
        .map(str::trim)
        .filter(|value| !value.is_empty());
    if let Some(tag) = tag {
        if board == BOARD_INTERVIEW {
            if char_count(tag) > MAX_INTERVIEW_TAG_CHARS {
                return Err(AppError::BadRequest(format!(
                    "标签不能超过 {MAX_INTERVIEW_TAG_CHARS} 字"
                )));
            }
        } else if !is_known_tag(tag) {
            return Err(AppError::BadRequest(format!("未知的标签：{tag}")));
        }
    }
    let company = normalize_interview_meta(query.company.as_deref(), "公司")?;
    let role = normalize_interview_meta(query.role.as_deref(), "岗位")?;
    let search = query
        .q
        .as_deref()
        .map(str::trim)
        .filter(|value| !value.is_empty());
    if let Some(search) = search
        && char_count(search) > MAX_SEARCH_CHARS
    {
        return Err(AppError::BadRequest(format!(
            "搜索词不能超过 {MAX_SEARCH_CHARS} 个字符"
        )));
    }

    let mut builder = QueryBuilder::<Postgres>::new("");
    push_public_post_select(&mut builder, viewer_id);
    builder.push(" WHERE fp.board = ").push_bind(board);
    if let Some(user_id) = mine_user {
        builder
            .push(" AND fp.author_id = ")
            .push_bind(user_id)
            .push(" AND fp.status <> 'deleted'");
    } else {
        builder.push(" AND fp.status = 'published'");
    }
    if let Some(tag) = tag {
        builder.push(" AND ").push_bind(tag.to_owned());
        builder.push(" = ANY(fp.tags)");
    }
    if let Some(company) = &company {
        builder
            .push(" AND fp.company = ")
            .push_bind(company.clone());
    }
    if let Some(role) = &role {
        builder.push(" AND fp.role = ").push_bind(role.clone());
    }
    if let Some(search) = search {
        let pattern = like_pattern(search);
        builder
            .push(" AND (fp.title ILIKE ")
            .push_bind(pattern.clone())
            .push(" ESCAPE '\\' OR fp.body_md ILIKE ")
            .push_bind(pattern)
            .push(" ESCAPE '\\')");
    }
    if sort == "hot" {
        builder.push(
            " ORDER BY fp.is_pinned DESC, \
             ((fp.like_count * 3 + fp.favorite_count * 2 + fp.comment_count * 4 + 1)::double precision \
              / POWER(EXTRACT(EPOCH FROM (NOW() - fp.created_at)) / 3600.0 + 2, 0.7)) DESC, \
             fp.id DESC",
        );
    } else {
        builder.push(" ORDER BY fp.is_pinned DESC, fp.created_at DESC, fp.id DESC");
    }
    builder
        .push(" LIMIT ")
        .push_bind(i64::from(size))
        .push(" OFFSET ")
        .push_bind(i64::from(page.saturating_sub(1)) * i64::from(size));
    let rows: Vec<ForumPostRow> = builder
        .build_query_as()
        .fetch_all(pool)
        .await
        .map_err(AppError::Database)?;
    let mut count_builder =
        QueryBuilder::<Postgres>::new("SELECT COUNT(*) FROM forum_posts fp WHERE fp.board = ");
    count_builder.push_bind(board);
    if let Some(user_id) = mine_user {
        count_builder
            .push(" AND fp.author_id = ")
            .push_bind(user_id)
            .push(" AND fp.status <> 'deleted'");
    } else {
        count_builder.push(" AND fp.status = 'published'");
    }
    if let Some(tag) = tag {
        count_builder.push(" AND ").push_bind(tag.to_owned());
        count_builder.push(" = ANY(fp.tags)");
    }
    if let Some(company) = &company {
        count_builder
            .push(" AND fp.company = ")
            .push_bind(company.clone());
    }
    if let Some(role) = &role {
        count_builder
            .push(" AND fp.role = ")
            .push_bind(role.clone());
    }
    if let Some(search) = search {
        let pattern = like_pattern(search);
        count_builder
            .push(" AND (fp.title ILIKE ")
            .push_bind(pattern.clone())
            .push(" ESCAPE '\\' OR fp.body_md ILIKE ")
            .push_bind(pattern)
            .push(" ESCAPE '\\')");
    }
    let total: i64 = count_builder
        .build_query_scalar()
        .fetch_one(pool)
        .await
        .map_err(AppError::Database)?;
    Ok(ForumPostListResponse {
        total,
        page,
        size,
        posts: rows
            .into_iter()
            .map(|row| row.into_summary(viewer_id))
            .collect(),
    })
}

pub async fn get_post(
    pool: &PgPool,
    config: &Config,
    viewer: Option<&AuthUser>,
    post_id: i64,
) -> Result<ForumPostDetail, AppError> {
    ensure_enabled(config)?;
    if post_id <= 0 {
        return Err(AppError::BadRequest("帖子 ID 无效".to_owned()));
    }
    let viewer_id = viewer.map(|user| user.id);
    let is_admin = viewer.is_some_and(AuthUser::is_admin);
    let mut builder = QueryBuilder::<Postgres>::new("");
    push_public_post_select(&mut builder, viewer_id);
    builder.push(" WHERE fp.id = ").push_bind(post_id);
    let row: Option<ForumPostRow> = builder
        .build_query_as()
        .fetch_optional(pool)
        .await
        .map_err(AppError::Database)?;
    let mut row = row.ok_or_else(|| AppError::NotFound("帖子不存在或已被删除".to_owned()))?;
    if row.status == "deleted" {
        return Err(AppError::NotFound("帖子不存在或已被删除".to_owned()));
    }
    ensure_board_access(pool, viewer, &row.board, Some(row.author_id)).await?;
    let is_author = viewer_id == Some(row.author_id);
    if row.status == "hidden" && !is_author {
        return Err(AppError::NotFound("帖子不存在或已被删除".to_owned()));
    }
    let published = row.status == "published";
    if published {
        sqlx::query("UPDATE forum_posts SET view_count = view_count + 1 WHERE id = $1")
            .bind(post_id)
            .execute(pool)
            .await
            .map_err(AppError::Database)?;
        row.view_count = row.view_count.saturating_add(1);
    }
    let body_md = row.body_md.clone();
    let hidden_reason = row.hidden_reason.clone();
    Ok(ForumPostDetail {
        summary: row.into_summary(viewer_id),
        body_md,
        can_edit: is_author && published,
        can_delete: is_author || is_admin,
        can_moderate: is_admin,
        hidden_reason,
    })
}

pub async fn interview_facets(
    pool: &PgPool,
    config: &Config,
    viewer: Option<&AuthUser>,
) -> Result<ForumInterviewFacets, AppError> {
    ensure_enabled(config)?;
    let Some(user) = viewer else {
        return Err(AppError::Unauthorized);
    };
    if !user.is_admin() && !plus_service::is_plus(pool, user.id).await? {
        return Err(AppError::ForbiddenWith(
            "需要开通 Plus Theseus 才能查看面经".to_owned(),
        ));
    }
    let companies: Vec<String> = sqlx::query_scalar(
        "SELECT DISTINCT company FROM forum_posts \
         WHERE board = 'interview' AND status = 'published' AND company IS NOT NULL \
         ORDER BY company",
    )
    .fetch_all(pool)
    .await
    .map_err(AppError::Database)?;
    let roles: Vec<String> = sqlx::query_scalar(
        "SELECT DISTINCT role FROM forum_posts \
         WHERE board = 'interview' AND status = 'published' AND role IS NOT NULL \
         ORDER BY role",
    )
    .fetch_all(pool)
    .await
    .map_err(AppError::Database)?;
    Ok(ForumInterviewFacets { companies, roles })
}

pub async fn create_post(
    pool: &PgPool,
    config: &Config,
    user: &AuthUser,
    request: &CreatePostRequest,
) -> Result<ForumPostCreated, AppError> {
    ensure_enabled(config)?;
    let board = normalize_board(request.board.as_deref())?;
    ensure_board_access(pool, Some(user), board, None).await?;
    let (title, body, tags) = normalized_post(
        &request.title,
        &request.body_md,
        &request.tags,
        user.is_admin(),
        board,
    )?;
    let (interview_date, company, role) = if board == BOARD_INTERVIEW {
        (
            normalize_interview_date(request.interview_date.as_deref())?,
            normalize_interview_meta(request.company.as_deref(), "公司")?,
            normalize_interview_meta(request.role.as_deref(), "岗位")?,
        )
    } else {
        (None, None, None)
    };
    validate_problem_reference(pool, request.problem_id).await?;
    let username = username_of(pool, user.id).await?;
    let actor_display = if request.is_anonymous {
        "匿名同学".to_owned()
    } else {
        username
    };

    let mut tx = pool.begin().await.map_err(AppError::Database)?;
    acquire_user_lock(&mut tx, 1, user.id).await?;
    ensure_not_muted(&mut tx, user.id).await?;
    ensure_post_limits(&mut tx, config, user.id).await?;
    let (post_id, status): (i64, String) = sqlx::query_as(
        "INSERT INTO forum_posts \
         (author_id, board, title, body_md, tags, interview_date, company, role, \
          problem_id, is_anonymous) \
         VALUES ($1, $2, $3, $4, $5, $6, $7, $8, $9, $10) RETURNING id, status",
    )
    .bind(user.id)
    .bind(board)
    .bind(&title)
    .bind(&body)
    .bind(&tags)
    .bind(&interview_date)
    .bind(&company)
    .bind(&role)
    .bind(request.problem_id)
    .bind(request.is_anonymous)
    .fetch_one(&mut *tx)
    .await
    .map_err(AppError::Database)?;

    let mention_text = format!("{title}\n{body}");
    let mentions = notification_service::resolve_mentions(&mut tx, &mention_text, user.id).await?;
    let excerpt = make_excerpt(&body, 120);
    let link = format!("/forum/{post_id}");
    for (mention_id, _) in mentions {
        notification_service::create(
            &mut tx,
            mention_id,
            "forum_mention",
            Some(user.id),
            &format!("{actor_display} 在帖子中提到了你"),
            Some(&excerpt),
            Some(&link),
            Some("forum_post"),
            Some(post_id),
        )
        .await?;
    }
    tx.commit().await.map_err(AppError::Database)?;
    Ok(ForumPostCreated {
        id: post_id,
        status,
    })
}

pub async fn update_post(
    pool: &PgPool,
    config: &Config,
    user: &AuthUser,
    post_id: i64,
    request: &UpdatePostRequest,
) -> Result<ForumMutationResponse, AppError> {
    ensure_enabled(config)?;
    let owned: Option<(i32, String)> =
        sqlx::query_as("SELECT author_id, board FROM forum_posts WHERE id = $1")
            .bind(post_id)
            .fetch_optional(pool)
            .await
            .map_err(AppError::Database)?;
    let (author_id, board) =
        owned.ok_or_else(|| AppError::NotFound("帖子不存在或已被删除".to_owned()))?;
    let board = normalize_board(Some(&board))?;
    ensure_board_access(pool, Some(user), board, Some(author_id)).await?;
    let (title, body, tags) = normalized_post(
        &request.title,
        &request.body_md,
        &request.tags,
        user.is_admin(),
        board,
    )?;
    let (interview_date, company, role) = if board == BOARD_INTERVIEW {
        (
            normalize_interview_date(request.interview_date.as_deref())?,
            normalize_interview_meta(request.company.as_deref(), "公司")?,
            normalize_interview_meta(request.role.as_deref(), "岗位")?,
        )
    } else {
        (None, None, None)
    };
    validate_problem_reference(pool, request.problem_id).await?;

    let mut tx = pool.begin().await.map_err(AppError::Database)?;
    ensure_not_muted(&mut tx, user.id).await?;
    let row: Option<(i32, String)> =
        sqlx::query_as("SELECT author_id, status FROM forum_posts WHERE id = $1 FOR UPDATE")
            .bind(post_id)
            .fetch_optional(&mut *tx)
            .await
            .map_err(AppError::Database)?;
    let (author_id, status) =
        row.ok_or_else(|| AppError::NotFound("帖子不存在或已被删除".to_owned()))?;
    if status == "deleted" {
        return Err(AppError::NotFound("帖子不存在或已被删除".to_owned()));
    }
    if author_id != user.id {
        return Err(AppError::Forbidden);
    }
    if status == "hidden" {
        return Err(AppError::ForbiddenWith("帖子已被隐藏，无法编辑".to_owned()));
    }
    sqlx::query(
        "UPDATE forum_posts SET title = $2, body_md = $3, tags = $4, interview_date = $5, \
         company = $6, role = $7, problem_id = $8, edited_at = CURRENT_TIMESTAMP, \
         updated_at = CURRENT_TIMESTAMP WHERE id = $1",
    )
    .bind(post_id)
    .bind(&title)
    .bind(&body)
    .bind(&tags)
    .bind(&interview_date)
    .bind(&company)
    .bind(&role)
    .bind(request.problem_id)
    .execute(&mut *tx)
    .await
    .map_err(AppError::Database)?;
    tx.commit().await.map_err(AppError::Database)?;
    Ok(ForumMutationResponse {
        id: post_id,
        message: "帖子已更新".to_owned(),
    })
}

pub async fn delete_post(
    pool: &PgPool,
    config: &Config,
    user: &AuthUser,
    post_id: i64,
) -> Result<ForumMutationResponse, AppError> {
    ensure_enabled(config)?;
    let mut tx = pool.begin().await.map_err(AppError::Database)?;
    let row: Option<(i32, String, String)> =
        sqlx::query_as("SELECT author_id, status, title FROM forum_posts WHERE id = $1 FOR UPDATE")
            .bind(post_id)
            .fetch_optional(&mut *tx)
            .await
            .map_err(AppError::Database)?;
    let (author_id, status, title) =
        row.ok_or_else(|| AppError::NotFound("帖子不存在或已被删除".to_owned()))?;
    if status == "deleted" {
        return Err(AppError::NotFound("帖子不存在或已被删除".to_owned()));
    }
    if author_id != user.id && !user.is_admin() {
        return Err(AppError::Forbidden);
    }
    sqlx::query(
        "UPDATE forum_posts SET status = 'deleted', hidden_reason = NULL, \
         hidden_by = $2, hidden_at = CURRENT_TIMESTAMP, is_pinned = FALSE, \
         updated_at = CURRENT_TIMESTAMP WHERE id = $1",
    )
    .bind(post_id)
    .bind(user.id)
    .execute(&mut *tx)
    .await
    .map_err(AppError::Database)?;
    resolve_pending_reports(&mut tx, "post", post_id, "resolved", user.id).await?;
    clear_pending_count(&mut tx, "post", post_id).await?;
    write_action(
        &mut tx,
        Some(user.id),
        "delete_post",
        "post",
        Some(post_id),
        None,
        json!({ "before_status": status }),
    )
    .await?;
    if author_id != user.id {
        notification_service::create(
            &mut tx,
            author_id,
            "forum_moderation",
            Some(user.id),
            "你的帖子已被删除",
            Some(&make_excerpt(&title, 120)),
            None,
            Some("forum_post"),
            Some(post_id),
        )
        .await?;
    }
    tx.commit().await.map_err(AppError::Database)?;
    Ok(ForumMutationResponse {
        id: post_id,
        message: "帖子已删除".to_owned(),
    })
}

pub async fn like_post(
    pool: &PgPool,
    config: &Config,
    user: &AuthUser,
    post_id: i64,
    liked: bool,
) -> Result<LikeResponse, AppError> {
    ensure_enabled(config)?;
    let mut tx = pool.begin().await.map_err(AppError::Database)?;
    let row: Option<(String, String, i32)> =
        sqlx::query_as("SELECT status, board, author_id FROM forum_posts WHERE id = $1 FOR UPDATE")
            .bind(post_id)
            .fetch_optional(&mut *tx)
            .await
            .map_err(AppError::Database)?;
    let Some((status, board, author_id)) = row else {
        return Err(AppError::NotFound("帖子不存在或已被删除".to_owned()));
    };
    if status != "published" {
        return Err(AppError::NotFound("帖子不存在或已被删除".to_owned()));
    }
    ensure_board_access(pool, Some(user), &board, Some(author_id)).await?;
    let changed = if liked {
        sqlx::query(
            "INSERT INTO forum_post_likes (post_id, user_id) VALUES ($1, $2) \
             ON CONFLICT DO NOTHING",
        )
        .bind(post_id)
        .bind(user.id)
        .execute(&mut *tx)
        .await
        .map_err(AppError::Database)?
        .rows_affected()
            > 0
    } else {
        sqlx::query("DELETE FROM forum_post_likes WHERE post_id = $1 AND user_id = $2")
            .bind(post_id)
            .bind(user.id)
            .execute(&mut *tx)
            .await
            .map_err(AppError::Database)?
            .rows_affected()
            > 0
    };
    let like_count: i32 = if changed {
        let sql = if liked {
            "UPDATE forum_posts SET like_count = like_count + 1, updated_at = CURRENT_TIMESTAMP \
             WHERE id = $1 RETURNING like_count"
        } else {
            "UPDATE forum_posts SET like_count = GREATEST(like_count - 1, 0), \
             updated_at = CURRENT_TIMESTAMP WHERE id = $1 RETURNING like_count"
        };
        sqlx::query_scalar(sql)
            .bind(post_id)
            .fetch_one(&mut *tx)
            .await
            .map_err(AppError::Database)?
    } else {
        sqlx::query_scalar("SELECT like_count FROM forum_posts WHERE id = $1")
            .bind(post_id)
            .fetch_one(&mut *tx)
            .await
            .map_err(AppError::Database)?
    };
    tx.commit().await.map_err(AppError::Database)?;
    Ok(LikeResponse { liked, like_count })
}

pub async fn favorite_post(
    pool: &PgPool,
    config: &Config,
    user: &AuthUser,
    post_id: i64,
    favorited: bool,
) -> Result<FavoriteResponse, AppError> {
    ensure_enabled(config)?;
    let mut tx = pool.begin().await.map_err(AppError::Database)?;
    let row: Option<(String, String, i32)> =
        sqlx::query_as("SELECT status, board, author_id FROM forum_posts WHERE id = $1 FOR UPDATE")
            .bind(post_id)
            .fetch_optional(&mut *tx)
            .await
            .map_err(AppError::Database)?;
    let Some((status, board, author_id)) = row else {
        return Err(AppError::NotFound("帖子不存在或已被删除".to_owned()));
    };
    if status != "published" {
        return Err(AppError::NotFound("帖子不存在或已被删除".to_owned()));
    }
    ensure_board_access(pool, Some(user), &board, Some(author_id)).await?;
    let changed = if favorited {
        sqlx::query(
            "INSERT INTO forum_post_favorites (post_id, user_id) VALUES ($1, $2) \
             ON CONFLICT DO NOTHING",
        )
        .bind(post_id)
        .bind(user.id)
        .execute(&mut *tx)
        .await
        .map_err(AppError::Database)?
        .rows_affected()
            > 0
    } else {
        sqlx::query("DELETE FROM forum_post_favorites WHERE post_id = $1 AND user_id = $2")
            .bind(post_id)
            .bind(user.id)
            .execute(&mut *tx)
            .await
            .map_err(AppError::Database)?
            .rows_affected()
            > 0
    };
    let favorite_count: i32 = if changed {
        let sql = if favorited {
            "UPDATE forum_posts SET favorite_count = favorite_count + 1, \
             updated_at = CURRENT_TIMESTAMP WHERE id = $1 RETURNING favorite_count"
        } else {
            "UPDATE forum_posts SET favorite_count = GREATEST(favorite_count - 1, 0), \
             updated_at = CURRENT_TIMESTAMP WHERE id = $1 RETURNING favorite_count"
        };
        sqlx::query_scalar(sql)
            .bind(post_id)
            .fetch_one(&mut *tx)
            .await
            .map_err(AppError::Database)?
    } else {
        sqlx::query_scalar("SELECT favorite_count FROM forum_posts WHERE id = $1")
            .bind(post_id)
            .fetch_one(&mut *tx)
            .await
            .map_err(AppError::Database)?
    };
    tx.commit().await.map_err(AppError::Database)?;
    Ok(FavoriteResponse {
        favorited,
        favorite_count,
    })
}

struct VisiblePost {
    #[allow(dead_code)]
    author_id: i32,
    #[allow(dead_code)]
    status: String,
    board: String,
}

async fn load_visible_post(
    pool: &PgPool,
    post_id: i64,
    viewer_id: Option<i32>,
) -> Result<VisiblePost, AppError> {
    let row: Option<(i32, String, String)> =
        sqlx::query_as("SELECT author_id, status, board FROM forum_posts WHERE id = $1")
            .bind(post_id)
            .fetch_optional(pool)
            .await
            .map_err(AppError::Database)?;
    let (author_id, status, board) =
        row.ok_or_else(|| AppError::NotFound("帖子不存在或已被删除".to_owned()))?;
    if status == "deleted" || (status == "hidden" && viewer_id != Some(author_id)) {
        return Err(AppError::NotFound("帖子不存在或已被删除".to_owned()));
    }
    Ok(VisiblePost {
        author_id,
        status,
        board,
    })
}

fn push_public_comment_select(builder: &mut QueryBuilder<'_, Postgres>, viewer_id: Option<i32>) {
    builder.push(
        "SELECT c.id, c.post_id, c.author_id, u.username AS author_username, \
         EXISTS (SELECT 1 FROM plus_memberships pm WHERE pm.user_id = c.author_id \
         AND pm.expires_at > CURRENT_TIMESTAMP) AS author_is_plus, c.parent_id, \
         c.reply_to_comment_id, ru.username AS reply_to_username, \
         rc.is_anonymous AS reply_to_is_anonymous, rc.status AS reply_to_status, \
         c.body_md, c.is_anonymous, c.status, \
         c.created_at, c.edited_at, COUNT(*) OVER() AS reply_total, \
         COUNT(*) OVER() AS total, 0::bigint AS reply_rank, \
         EXISTS (SELECT 1 FROM forum_comment_favorites cf \
         WHERE cf.comment_id = c.id AND cf.user_id = ",
    );
    builder.push_bind(viewer_id);
    builder.push(
        ") AS favorited \
         FROM forum_comments c \
         JOIN users u ON u.id = c.author_id \
         LEFT JOIN forum_comments rc ON rc.id = c.reply_to_comment_id \
         LEFT JOIN users ru ON ru.id = rc.author_id",
    );
}

pub async fn list_comments(
    pool: &PgPool,
    config: &Config,
    viewer: Option<&AuthUser>,
    post_id: i64,
    query: &ForumCommentListQuery,
) -> Result<ForumCommentsResponse, AppError> {
    ensure_enabled(config)?;
    let viewer_id = viewer.map(|user| user.id);
    let is_admin = viewer.is_some_and(AuthUser::is_admin);
    let (page, size) = page_and_size(query.page, query.size, MAX_PUBLIC_PAGE_SIZE);
    let post = load_visible_post(pool, post_id, viewer_id).await?;
    ensure_board_access(pool, viewer, &post.board, Some(post.author_id)).await?;

    let mut builder = QueryBuilder::<Postgres>::new(
        "SELECT c.id, c.post_id, c.author_id, u.username AS author_username, \
         EXISTS (SELECT 1 FROM plus_memberships pm WHERE pm.user_id = c.author_id \
         AND pm.expires_at > CURRENT_TIMESTAMP) AS author_is_plus, c.parent_id, \
         c.reply_to_comment_id, ru.username AS reply_to_username, \
         rc.is_anonymous AS reply_to_is_anonymous, rc.status AS reply_to_status, \
         c.body_md, c.is_anonymous, c.status, \
         c.created_at, c.edited_at, 0::bigint AS reply_total, COUNT(*) OVER() AS total, \
         0::bigint AS reply_rank, EXISTS (SELECT 1 FROM forum_comment_favorites cf \
         WHERE cf.comment_id = c.id AND cf.user_id = ",
    );
    builder.push_bind(viewer_id);
    builder.push(
        ") AS favorited \
         FROM forum_comments c \
         JOIN users u ON u.id = c.author_id \
         LEFT JOIN forum_comments rc ON rc.id = c.reply_to_comment_id \
         LEFT JOIN users ru ON ru.id = rc.author_id \
         WHERE c.post_id = ",
    );
    builder.push_bind(post_id);
    builder.push(
        " AND c.parent_id IS NULL AND (c.status = 'published' OR EXISTS \
         (SELECT 1 FROM forum_comments r WHERE r.parent_id = c.id AND r.status = 'published')) \
         ORDER BY c.created_at ASC, c.id ASC LIMIT ",
    );
    builder
        .push_bind(i64::from(size))
        .push(" OFFSET ")
        .push_bind(i64::from(page.saturating_sub(1)) * i64::from(size));
    let roots: Vec<ForumCommentRow> = builder
        .build_query_as()
        .fetch_all(pool)
        .await
        .map_err(AppError::Database)?;
    let total: i64 = sqlx::query_scalar(
        "SELECT COUNT(*) FROM forum_comments c WHERE c.post_id = $1 AND c.parent_id IS NULL \
         AND (c.status = 'published' OR EXISTS \
         (SELECT 1 FROM forum_comments r WHERE r.parent_id = c.id AND r.status = 'published'))",
    )
    .bind(post_id)
    .fetch_one(pool)
    .await
    .map_err(AppError::Database)?;

    let root_ids: Vec<i64> = roots.iter().map(|root| root.id).collect();
    let mut replies_by_root: HashMap<i64, Vec<ForumCommentRow>> = HashMap::new();
    if !root_ids.is_empty() {
        let mut reply_builder = QueryBuilder::<Postgres>::new(
            "SELECT id, post_id, author_id, author_username, author_is_plus, parent_id, \
             reply_to_comment_id, reply_to_username, reply_to_is_anonymous, reply_to_status, \
             body_md, is_anonymous, status, created_at, edited_at, reply_total, total, \
             reply_rank, favorited \
             FROM ( \
             SELECT c.id, c.post_id, c.author_id, u.username AS author_username, \
         EXISTS (SELECT 1 FROM plus_memberships pm WHERE pm.user_id = c.author_id \
         AND pm.expires_at > CURRENT_TIMESTAMP) AS author_is_plus, c.parent_id, \
             c.reply_to_comment_id, ru.username AS reply_to_username, \
             rc.is_anonymous AS reply_to_is_anonymous, rc.status AS reply_to_status, \
             c.body_md, c.is_anonymous, c.status, c.created_at, c.edited_at, \
             COUNT(*) OVER (PARTITION BY c.parent_id) AS reply_total, \
             0::bigint AS total, \
             ROW_NUMBER() OVER (PARTITION BY c.parent_id ORDER BY c.created_at ASC, c.id ASC) \
             AS reply_rank, EXISTS (SELECT 1 FROM forum_comment_favorites cf \
             WHERE cf.comment_id = c.id AND cf.user_id = ",
        );
        reply_builder
            .push_bind(viewer_id)
            .push(
                ") AS favorited \
             FROM forum_comments c \
             JOIN users u ON u.id = c.author_id \
             LEFT JOIN forum_comments rc ON rc.id = c.reply_to_comment_id \
             LEFT JOIN users ru ON ru.id = rc.author_id \
             WHERE c.parent_id = ANY(",
            )
            .push_bind(&root_ids)
            .push(") AND c.status = 'published') ranked WHERE ranked.reply_rank <= ")
            .push_bind(MAX_EMBEDDED_REPLIES)
            .push(" ORDER BY ranked.parent_id ASC, ranked.created_at ASC, ranked.id ASC");
        let reply_rows: Vec<ForumCommentRow> = reply_builder
            .build_query_as()
            .fetch_all(pool)
            .await
            .map_err(AppError::Database)?;
        for reply in reply_rows {
            if let Some(parent_id) = reply.parent_id {
                replies_by_root.entry(parent_id).or_default().push(reply);
            }
        }
    }

    let mut comments = Vec::with_capacity(roots.len());
    for root in roots {
        let reply_rows = replies_by_root.remove(&root.id).unwrap_or_default();
        let reply_total = reply_rows.first().map(|row| row.reply_total).unwrap_or(0);
        let replies: Vec<ForumReplyView> = reply_rows
            .into_iter()
            .map(|row| row.into_reply_view(viewer_id, is_admin))
            .collect();
        comments.push(root.into_comment_view(viewer_id, is_admin, replies, reply_total));
    }
    Ok(ForumCommentsResponse {
        total,
        page,
        size,
        comments,
    })
}

pub async fn list_replies(
    pool: &PgPool,
    config: &Config,
    viewer: Option<&AuthUser>,
    root_id: i64,
    query: &ForumReplyListQuery,
) -> Result<ForumRepliesResponse, AppError> {
    ensure_enabled(config)?;
    let viewer_id = viewer.map(|user| user.id);
    let is_admin = viewer.is_some_and(AuthUser::is_admin);
    let (page, size) = page_and_size(query.page, query.size, MAX_PUBLIC_PAGE_SIZE);
    let root: Option<(i64, Option<i64>)> =
        sqlx::query_as("SELECT post_id, parent_id FROM forum_comments WHERE id = $1")
            .bind(root_id)
            .fetch_optional(pool)
            .await
            .map_err(AppError::Database)?;
    let Some((post_id, parent_id)) = root else {
        return Err(AppError::NotFound("评论不存在或已被删除".to_owned()));
    };
    if parent_id.is_some() {
        return Err(AppError::NotFound("评论不存在或已被删除".to_owned()));
    }
    let post = load_visible_post(pool, post_id, viewer_id).await?;
    ensure_board_access(pool, viewer, &post.board, Some(post.author_id)).await?;

    let mut builder = QueryBuilder::<Postgres>::new("");
    push_public_comment_select(&mut builder, viewer_id);
    builder
        .push(" WHERE c.parent_id = ")
        .push_bind(root_id)
        .push(" AND c.status = 'published' ORDER BY c.created_at ASC, c.id ASC LIMIT ")
        .push_bind(i64::from(size))
        .push(" OFFSET ")
        .push_bind(i64::from(page.saturating_sub(1)) * i64::from(size));
    let rows: Vec<ForumCommentRow> = builder
        .build_query_as()
        .fetch_all(pool)
        .await
        .map_err(AppError::Database)?;
    let total: i64 = sqlx::query_scalar(
        "SELECT COUNT(*) FROM forum_comments WHERE parent_id = $1 AND status = 'published'",
    )
    .bind(root_id)
    .fetch_one(pool)
    .await
    .map_err(AppError::Database)?;
    Ok(ForumRepliesResponse {
        total,
        page,
        size,
        replies: rows
            .into_iter()
            .map(|row| row.into_reply_view(viewer_id, is_admin))
            .collect(),
    })
}

struct ReplyTarget {
    id: i64,
    author_id: i32,
    username: String,
    is_anonymous: bool,
    parent_id: Option<i64>,
}

pub async fn create_comment(
    pool: &PgPool,
    config: &Config,
    user: &AuthUser,
    post_id: i64,
    request: &CreateCommentRequest,
) -> Result<ForumCommentCreated, AppError> {
    ensure_enabled(config)?;
    let body = normalized_comment_body(&request.body_md)?;
    let username = username_of(pool, user.id).await?;
    let is_plus = plus_service::is_plus(pool, user.id).await?;
    let actor_display = if request.is_anonymous {
        "匿名同学".to_owned()
    } else {
        username.clone()
    };

    let mut tx = pool.begin().await.map_err(AppError::Database)?;
    acquire_user_lock(&mut tx, 2, user.id).await?;
    ensure_not_muted(&mut tx, user.id).await?;
    ensure_comment_limits(&mut tx, config, user.id).await?;
    let post: Option<(i32, String, String)> =
        sqlx::query_as("SELECT author_id, status, board FROM forum_posts WHERE id = $1 FOR UPDATE")
            .bind(post_id)
            .fetch_optional(&mut *tx)
            .await
            .map_err(AppError::Database)?;
    let Some((post_author, post_status, post_board)) = post else {
        return Err(AppError::NotFound("帖子不存在或已被删除".to_owned()));
    };
    if post_status != "published" {
        return Err(AppError::NotFound("帖子不存在或已被删除".to_owned()));
    }
    ensure_board_access(pool, Some(user), &post_board, Some(post_author)).await?;

    let target = if let Some(target_id) = request.reply_to_comment_id {
        let row: Option<ReplyTarget> = sqlx::query_as::<_, (i64, i32, String, bool, Option<i64>, i64, String)>(
            "SELECT c.id, c.author_id, u.username, c.is_anonymous, c.parent_id, c.post_id, c.status \
             FROM forum_comments c JOIN users u ON u.id = c.author_id WHERE c.id = $1",
        )
        .bind(target_id)
        .fetch_optional(&mut *tx)
        .await
        .map_err(AppError::Database)?
        .and_then(|(id, author_id, username, is_anonymous, parent_id, target_post_id, status)| {
            (target_post_id == post_id && status == "published").then_some(ReplyTarget {
                id,
                author_id,
                username,
                is_anonymous,
                parent_id,
            })
        });
        let target = row.ok_or_else(|| AppError::NotFound("评论不存在或不可见".to_owned()))?;
        let root_id = target.parent_id.unwrap_or(target.id);
        if let Some(parent_id) = request.parent_id
            && parent_id != root_id
        {
            return Err(AppError::BadRequest("回复目标与父评论不一致".to_owned()));
        }
        Some((target, root_id))
    } else {
        if request.parent_id.is_some() {
            return Err(AppError::BadRequest(
                "回复顶层评论时必须提供 reply_to_comment_id".to_owned(),
            ));
        }
        None
    };

    let (comment_id, created_at): (i64, DateTime<Utc>) = sqlx::query_as(
        "INSERT INTO forum_comments \
         (post_id, author_id, parent_id, reply_to_comment_id, reply_to_user_id, body_md, is_anonymous) \
         VALUES ($1, $2, $3, $4, $5, $6, $7) RETURNING id, created_at",
    )
    .bind(post_id)
    .bind(user.id)
    .bind(target.as_ref().map(|(_, root_id)| *root_id))
    .bind(target.as_ref().map(|(target, _)| target.id))
    .bind(target.as_ref().map(|(target, _)| target.author_id))
    .bind(&body)
    .bind(request.is_anonymous)
    .fetch_one(&mut *tx)
    .await
    .map_err(AppError::Database)?;
    recompute_comment_count(&mut tx, post_id).await?;

    let link = format!("/forum/{post_id}#comment-{comment_id}");
    let excerpt = make_excerpt(&body, 120);
    let mut notifications: HashMap<i32, (&'static str, String)> = HashMap::new();
    if let Some((target, _)) = &target
        && target.author_id != user.id
    {
        notifications.insert(
            target.author_id,
            ("forum_reply", format!("{actor_display} 回复了你的评论")),
        );
    }
    if post_author != user.id && !notifications.contains_key(&post_author) {
        notifications.insert(
            post_author,
            ("forum_comment", format!("{actor_display} 评论了你的帖子")),
        );
    }
    let mentions = notification_service::resolve_mentions(&mut tx, &body, user.id).await?;
    for (mention_id, _) in mentions {
        notifications
            .entry(mention_id)
            .or_insert(("forum_mention", format!("{actor_display} 在评论中提到了你")));
    }
    for (user_id, (notification_type, title)) in notifications {
        notification_service::create(
            &mut tx,
            user_id,
            notification_type,
            Some(user.id),
            &title,
            Some(&excerpt),
            Some(&link),
            Some("forum_comment"),
            Some(comment_id),
        )
        .await?;
    }
    tx.commit().await.map_err(AppError::Database)?;

    let reply_to = target.as_ref().map(|(target, _)| ReplyTo {
        comment_id: target.id,
        display_name: if target.is_anonymous {
            "匿名同学".to_owned()
        } else {
            target.username.clone()
        },
    });
    Ok(ForumCommentCreated {
        id: comment_id,
        post_id,
        parent_id: target.as_ref().map(|(_, root_id)| *root_id),
        reply_to,
        body_md: body,
        author: PublicAuthor::new(
            user.id,
            &username,
            request.is_anonymous,
            is_plus,
            Some(user.id),
        ),
        created_at,
    })
}

pub async fn update_comment(
    pool: &PgPool,
    config: &Config,
    user: &AuthUser,
    comment_id: i64,
    request: &UpdateCommentRequest,
) -> Result<ForumMutationResponse, AppError> {
    ensure_enabled(config)?;
    let body = normalized_comment_body(&request.body_md)?;
    let mut tx = pool.begin().await.map_err(AppError::Database)?;
    ensure_not_muted(&mut tx, user.id).await?;
    let row: Option<(i32, String, i64)> = sqlx::query_as(
        "SELECT author_id, status, post_id FROM forum_comments WHERE id = $1 FOR UPDATE",
    )
    .bind(comment_id)
    .fetch_optional(&mut *tx)
    .await
    .map_err(AppError::Database)?;
    let (author_id, status, post_id) =
        row.ok_or_else(|| AppError::NotFound("评论不存在或已被删除".to_owned()))?;
    if status == "deleted" {
        return Err(AppError::NotFound("评论不存在或已被删除".to_owned()));
    }
    if author_id != user.id {
        return Err(AppError::Forbidden);
    }
    if status != "published" {
        return Err(AppError::ForbiddenWith("评论已被隐藏，无法编辑".to_owned()));
    }
    let post: Option<(i32, String)> =
        sqlx::query_as("SELECT author_id, board FROM forum_posts WHERE id = $1")
            .bind(post_id)
            .fetch_optional(&mut *tx)
            .await
            .map_err(AppError::Database)?;
    let Some((post_author, post_board)) = post else {
        return Err(AppError::NotFound("帖子不存在或已被删除".to_owned()));
    };
    ensure_board_access(pool, Some(user), &post_board, Some(post_author)).await?;
    let updated = sqlx::query(
        "UPDATE forum_comments SET body_md = $2, edited_at = CURRENT_TIMESTAMP, \
         updated_at = CURRENT_TIMESTAMP WHERE id = $1 AND status = 'published'",
    )
    .bind(comment_id)
    .bind(&body)
    .execute(&mut *tx)
    .await
    .map_err(AppError::Database)?;
    if updated.rows_affected() == 0 {
        return Err(AppError::ForbiddenWith(
            "评论状态已变化，无法编辑".to_owned(),
        ));
    }
    tx.commit().await.map_err(AppError::Database)?;
    Ok(ForumMutationResponse {
        id: comment_id,
        message: "评论已更新".to_owned(),
    })
}

pub async fn delete_comment(
    pool: &PgPool,
    config: &Config,
    user: &AuthUser,
    comment_id: i64,
) -> Result<ForumMutationResponse, AppError> {
    ensure_enabled(config)?;
    let mut tx = pool.begin().await.map_err(AppError::Database)?;
    let post_id: Option<i64> =
        sqlx::query_scalar("SELECT post_id FROM forum_comments WHERE id = $1")
            .bind(comment_id)
            .fetch_optional(&mut *tx)
            .await
            .map_err(AppError::Database)?;
    let post_id = post_id.ok_or_else(|| AppError::NotFound("评论不存在或已被删除".to_owned()))?;
    let post: Option<(i32, String)> =
        sqlx::query_as("SELECT author_id, board FROM forum_posts WHERE id = $1 FOR UPDATE")
            .bind(post_id)
            .fetch_optional(&mut *tx)
            .await
            .map_err(AppError::Database)?;
    let Some((post_author, post_board)) = post else {
        return Err(AppError::NotFound("帖子不存在或已被删除".to_owned()));
    };
    ensure_board_access(pool, Some(user), &post_board, Some(post_author)).await?;
    let row: Option<(i32, i64, String, String)> = sqlx::query_as(
        "SELECT author_id, post_id, status, body_md FROM forum_comments \
         WHERE id = $1 FOR UPDATE",
    )
    .bind(comment_id)
    .fetch_optional(&mut *tx)
    .await
    .map_err(AppError::Database)?;
    let (author_id, post_id, status, body) =
        row.ok_or_else(|| AppError::NotFound("评论不存在或已被删除".to_owned()))?;
    if status == "deleted" {
        return Err(AppError::NotFound("评论不存在或已被删除".to_owned()));
    }
    if author_id != user.id && !user.is_admin() {
        return Err(AppError::Forbidden);
    }
    sqlx::query(
        "UPDATE forum_comments SET status = 'deleted', hidden_reason = NULL, \
         hidden_by = $2, hidden_at = CURRENT_TIMESTAMP, updated_at = CURRENT_TIMESTAMP \
         WHERE id = $1",
    )
    .bind(comment_id)
    .bind(user.id)
    .execute(&mut *tx)
    .await
    .map_err(AppError::Database)?;
    recompute_comment_count(&mut tx, post_id).await?;
    resolve_pending_reports(&mut tx, "comment", comment_id, "resolved", user.id).await?;
    clear_pending_count(&mut tx, "comment", comment_id).await?;
    write_action(
        &mut tx,
        Some(user.id),
        "delete_comment",
        "comment",
        Some(comment_id),
        None,
        json!({ "before_status": status, "post_id": post_id }),
    )
    .await?;
    if author_id != user.id {
        notification_service::create(
            &mut tx,
            author_id,
            "forum_moderation",
            Some(user.id),
            "你的评论已被删除",
            Some(&make_excerpt(&body, 120)),
            Some(&format!("/forum/{post_id}#comment-{comment_id}")),
            Some("forum_comment"),
            Some(comment_id),
        )
        .await?;
    }
    tx.commit().await.map_err(AppError::Database)?;
    Ok(ForumMutationResponse {
        id: comment_id,
        message: "评论已删除".to_owned(),
    })
}

struct LockedContent {
    author_id: i32,
    status: String,
    hidden_reason: Option<String>,
    excerpt: String,
    link: String,
    post_author_id: i32,
    board: String,
}

async fn lock_content(
    tx: &mut Transaction<'_, Postgres>,
    target_type: &str,
    target_id: i64,
) -> Result<Option<LockedContent>, AppError> {
    match target_type {
        "post" => {
            let row: Option<(i32, String, Option<String>, String, String)> = sqlx::query_as(
                "SELECT author_id, status, hidden_reason, body_md, board FROM forum_posts \
                 WHERE id = $1 FOR UPDATE",
            )
            .bind(target_id)
            .fetch_optional(&mut **tx)
            .await
            .map_err(AppError::Database)?;
            Ok(row.map(
                |(author_id, status, hidden_reason, body_md, board)| LockedContent {
                    author_id,
                    status,
                    hidden_reason,
                    excerpt: make_excerpt(&body_md, 120),
                    link: format!("/forum/{target_id}"),
                    post_author_id: author_id,
                    board,
                },
            ))
        }
        "comment" => {
            let post_id: Option<i64> =
                sqlx::query_scalar("SELECT post_id FROM forum_comments WHERE id = $1")
                    .bind(target_id)
                    .fetch_optional(&mut **tx)
                    .await
                    .map_err(AppError::Database)?;
            let Some(post_id) = post_id else {
                return Ok(None);
            };
            sqlx::query("SELECT id FROM forum_posts WHERE id = $1 FOR UPDATE")
                .bind(post_id)
                .fetch_optional(&mut **tx)
                .await
                .map_err(AppError::Database)?;
            type CommentLock = (i32, String, Option<String>, String, i64, i32, String);
            let row: Option<CommentLock> = sqlx::query_as(
                "SELECT c.author_id, c.status, c.hidden_reason, c.body_md, c.post_id, \
                        p.author_id, p.board \
                 FROM forum_comments c JOIN forum_posts p ON p.id = c.post_id \
                 WHERE c.id = $1 FOR UPDATE OF c",
            )
            .bind(target_id)
            .fetch_optional(&mut **tx)
            .await
            .map_err(AppError::Database)?;
            Ok(row.map(
                |(author_id, status, hidden_reason, body_md, post_id, post_author_id, board)| {
                    LockedContent {
                        author_id,
                        status,
                        hidden_reason,
                        excerpt: make_excerpt(&body_md, 120),
                        link: format!("/forum/{post_id}#comment-{target_id}"),
                        post_author_id,
                        board,
                    }
                },
            ))
        }
        _ => Err(AppError::BadRequest("举报目标类型无效".to_owned())),
    }
}

pub async fn create_report(
    pool: &PgPool,
    config: &Config,
    user: &AuthUser,
    request: &CreateReportRequest,
) -> Result<ForumReportResponse, AppError> {
    ensure_enabled(config)?;
    let target_type = request.target_type.trim();
    if !matches!(target_type, "post" | "comment") {
        return Err(AppError::BadRequest("举报目标类型无效".to_owned()));
    }
    if request.target_id <= 0 {
        return Err(AppError::BadRequest("举报目标 ID 无效".to_owned()));
    }
    let reason = request.reason.trim();
    if !is_known_report_reason(reason) {
        return Err(AppError::BadRequest("举报原因无效".to_owned()));
    }
    let detail = request
        .detail
        .as_deref()
        .map(str::trim)
        .filter(|value| !value.is_empty());
    if let Some(detail) = detail
        && char_count(detail) > MAX_REPORT_DETAIL_CHARS
    {
        return Err(AppError::BadRequest(format!(
            "补充说明不能超过 {MAX_REPORT_DETAIL_CHARS} 个字符"
        )));
    }
    let mut tx = pool.begin().await.map_err(AppError::Database)?;
    acquire_user_lock(&mut tx, 3, user.id).await?;
    ensure_report_limit(&mut tx, config, user.id).await?;
    let target = lock_content(&mut tx, target_type, request.target_id)
        .await?
        .ok_or_else(|| AppError::NotFound("举报目标不存在".to_owned()))?;
    if target.author_id == user.id {
        return Err(AppError::ForbiddenWith("不能举报自己的内容".to_owned()));
    }
    if target.status != "published" {
        return Err(AppError::ConflictWith("该内容已被隐藏或删除".to_owned()));
    }
    ensure_board_access(pool, Some(user), &target.board, Some(target.post_author_id)).await?;
    let insert: Result<i64, sqlx::Error> = sqlx::query_scalar(
        "INSERT INTO forum_reports (target_type, target_id, reporter_id, reason, detail) \
         VALUES ($1, $2, $3, $4, $5) RETURNING id",
    )
    .bind(target_type)
    .bind(request.target_id)
    .bind(user.id)
    .bind(reason)
    .bind(detail)
    .fetch_one(&mut *tx)
    .await;
    let report_id: i64 = match insert {
        Ok(id) => id,
        Err(error) if is_unique_violation(&error) => {
            return Err(AppError::ConflictWith("你已举报过该内容".to_owned()));
        }
        Err(error) => return Err(AppError::Database(error)),
    };

    let pending_count: i32 = match target_type {
        "post" => sqlx::query_scalar(
            "UPDATE forum_posts SET pending_report_count = pending_report_count + 1, \
             updated_at = CURRENT_TIMESTAMP WHERE id = $1 RETURNING pending_report_count",
        )
        .bind(request.target_id)
        .fetch_one(&mut *tx)
        .await
        .map_err(AppError::Database)?,
        _ => sqlx::query_scalar(
            "UPDATE forum_comments SET pending_report_count = pending_report_count + 1, \
             updated_at = CURRENT_TIMESTAMP WHERE id = $1 RETURNING pending_report_count",
        )
        .bind(request.target_id)
        .fetch_one(&mut *tx)
        .await
        .map_err(AppError::Database)?,
    };

    let mut hidden = false;
    if pending_count >= config.forum_report_hide_threshold && target.status == "published" {
        hidden = true;
        match target_type {
            "post" => {
                sqlx::query(
                    "UPDATE forum_posts SET status = 'hidden', hidden_reason = 'report_threshold', \
                     hidden_by = NULL, hidden_at = CURRENT_TIMESTAMP, is_pinned = FALSE, \
                     updated_at = CURRENT_TIMESTAMP WHERE id = $1",
                )
                .bind(request.target_id)
                .execute(&mut *tx)
                .await
                .map_err(AppError::Database)?;
            }
            _ => {
                sqlx::query(
                    "UPDATE forum_comments SET status = 'hidden', \
                     hidden_reason = 'report_threshold', hidden_by = NULL, \
                     hidden_at = CURRENT_TIMESTAMP, updated_at = CURRENT_TIMESTAMP WHERE id = $1",
                )
                .bind(request.target_id)
                .execute(&mut *tx)
                .await
                .map_err(AppError::Database)?;
                let post_id: i64 =
                    sqlx::query_scalar("SELECT post_id FROM forum_comments WHERE id = $1")
                        .bind(request.target_id)
                        .fetch_one(&mut *tx)
                        .await
                        .map_err(AppError::Database)?;
                recompute_comment_count(&mut tx, post_id).await?;
            }
        }
        let action = if target_type == "post" {
            "auto_hide_post"
        } else {
            "auto_hide_comment"
        };
        write_action(
            &mut tx,
            None,
            action,
            target_type,
            Some(request.target_id),
            None,
            json!({
                "report_id": report_id,
                "before_status": "published",
                "after_status": "hidden",
                "pending_report_count": pending_count,
            }),
        )
        .await?;
        let title = if target_type == "post" {
            "你的帖子因多次举报被自动隐藏"
        } else {
            "你的评论因多次举报被自动隐藏"
        };
        notification_service::create(
            &mut tx,
            target.author_id,
            "forum_moderation",
            None,
            title,
            Some(&target.excerpt),
            Some(&target.link),
            Some(if target_type == "post" {
                "forum_post"
            } else {
                "forum_comment"
            }),
            Some(request.target_id),
        )
        .await?;
    }
    tx.commit().await.map_err(AppError::Database)?;
    Ok(ForumReportResponse {
        report_id,
        hidden,
        message: "举报已提交".to_owned(),
    })
}

fn push_admin_post_select(builder: &mut QueryBuilder<'_, Postgres>) {
    builder.push(
        "SELECT fp.id, fp.author_id, u.username AS author_username, u.email AS author_email, \
         u.role AS author_role, fp.board, fp.title, fp.body_md, fp.tags, fp.interview_date, \
         fp.company, fp.role, fp.view_count, fp.problem_id, \
         p.title AS problem_title, p.difficulty AS problem_difficulty, fp.is_anonymous, \
         fp.status, fp.hidden_reason, fp.hidden_by, fp.hidden_at, fp.is_pinned, fp.like_count, \
         fp.favorite_count, fp.comment_count, fp.pending_report_count, fp.created_at, \
         fp.updated_at, fp.edited_at, COUNT(*) OVER() AS total \
         FROM forum_posts fp \
         JOIN users u ON u.id = fp.author_id \
         LEFT JOIN problems p ON p.id = fp.problem_id AND p.review_status = 'approved'",
    );
}

pub async fn admin_list_posts(
    pool: &PgPool,
    query: &AdminForumPostListQuery,
) -> Result<AdminForumPostListResponse, AppError> {
    let (page, size) = page_and_size(query.page, query.size, MAX_ADMIN_PAGE_SIZE);
    let status = match query.status.as_deref() {
        None | Some("") | Some("all") => None,
        Some("published") => Some("published"),
        Some("hidden") => Some("hidden"),
        Some("deleted") => Some("deleted"),
        Some(_) => {
            return Err(AppError::BadRequest("内容状态筛选值无效".to_owned()));
        }
    };
    let search = query
        .q
        .as_deref()
        .map(str::trim)
        .filter(|value| !value.is_empty());
    if let Some(search) = search
        && char_count(search) > MAX_SEARCH_CHARS
    {
        return Err(AppError::BadRequest(format!(
            "搜索词不能超过 {MAX_SEARCH_CHARS} 个字符"
        )));
    }
    let author = query
        .author
        .as_deref()
        .map(str::trim)
        .filter(|value| !value.is_empty());
    let board = query
        .board
        .as_deref()
        .map(str::trim)
        .filter(|value| !value.is_empty());
    if let Some(board) = board
        && !is_known_board(board)
    {
        return Err(AppError::BadRequest("未知的板块".to_owned()));
    }

    let mut builder = QueryBuilder::<Postgres>::new("");
    push_admin_post_select(&mut builder);
    builder.push(" WHERE TRUE");
    if let Some(status) = status {
        builder.push(" AND fp.status = ").push_bind(status);
    }
    if let Some(board) = board {
        builder.push(" AND fp.board = ").push_bind(board.to_owned());
    }
    if let Some(search) = search {
        let pattern = like_pattern(search);
        builder
            .push(" AND (fp.title ILIKE ")
            .push_bind(pattern.clone())
            .push(" ESCAPE '\\' OR fp.body_md ILIKE ")
            .push_bind(pattern)
            .push(" ESCAPE '\\')");
    }
    if let Some(author) = author {
        builder
            .push(" AND u.username ILIKE ")
            .push_bind(like_pattern(author))
            .push(" ESCAPE '\\'");
    }
    builder
        .push(" ORDER BY fp.created_at DESC, fp.id DESC LIMIT ")
        .push_bind(i64::from(size))
        .push(" OFFSET ")
        .push_bind(i64::from(page.saturating_sub(1)) * i64::from(size));
    let rows: Vec<AdminForumPostRow> = builder
        .build_query_as()
        .fetch_all(pool)
        .await
        .map_err(AppError::Database)?;
    let mut count_builder = QueryBuilder::<Postgres>::new(
        "SELECT COUNT(*) FROM forum_posts fp JOIN users u ON u.id = fp.author_id WHERE TRUE",
    );
    if let Some(status) = status {
        count_builder.push(" AND fp.status = ").push_bind(status);
    }
    if let Some(board) = board {
        count_builder
            .push(" AND fp.board = ")
            .push_bind(board.to_owned());
    }
    if let Some(search) = search {
        let pattern = like_pattern(search);
        count_builder
            .push(" AND (fp.title ILIKE ")
            .push_bind(pattern.clone())
            .push(" ESCAPE '\\' OR fp.body_md ILIKE ")
            .push_bind(pattern)
            .push(" ESCAPE '\\')");
    }
    if let Some(author) = author {
        count_builder
            .push(" AND u.username ILIKE ")
            .push_bind(like_pattern(author))
            .push(" ESCAPE '\\'");
    }
    let total: i64 = count_builder
        .build_query_scalar()
        .fetch_one(pool)
        .await
        .map_err(AppError::Database)?;
    Ok(AdminForumPostListResponse {
        total,
        page,
        size,
        posts: rows
            .into_iter()
            .map(AdminForumPostRow::into_summary)
            .collect(),
    })
}

pub async fn admin_get_post(pool: &PgPool, post_id: i64) -> Result<AdminForumPostDetail, AppError> {
    let mut builder = QueryBuilder::<Postgres>::new("");
    push_admin_post_select(&mut builder);
    builder.push(" WHERE fp.id = ").push_bind(post_id);
    let row: Option<AdminForumPostRow> = builder
        .build_query_as()
        .fetch_optional(pool)
        .await
        .map_err(AppError::Database)?;
    let row = row.ok_or_else(|| AppError::NotFound("帖子不存在".to_owned()))?;
    let body_md = row.body_md.clone();
    let hidden_by = row.hidden_by;
    let summary = row.into_summary();
    let comments: Vec<AdminForumCommentRow> = sqlx::query_as(
        "SELECT c.id, c.post_id, c.parent_id, c.reply_to_comment_id, c.body_md, \
         c.author_id, u.username AS author_username, u.email AS author_email, \
         u.role AS author_role, c.is_anonymous, c.status, c.hidden_reason, \
         c.pending_report_count, c.created_at, c.edited_at \
         FROM forum_comments c JOIN users u ON u.id = c.author_id \
         WHERE c.post_id = $1 ORDER BY c.parent_id NULLS FIRST, c.created_at ASC, c.id ASC",
    )
    .bind(post_id)
    .fetch_all(pool)
    .await
    .map_err(AppError::Database)?;
    Ok(AdminForumPostDetail {
        post: summary,
        body_md,
        hidden_by,
        comments: comments
            .into_iter()
            .map(AdminForumCommentRow::into_view)
            .collect(),
    })
}

fn validate_admin_status(value: &str) -> Result<&str, AppError> {
    match value {
        "published" | "hidden" | "deleted" => Ok(value),
        _ => Err(AppError::BadRequest("内容状态无效".to_owned())),
    }
}

pub async fn admin_change_post_status(
    pool: &PgPool,
    admin: &AuthUser,
    post_id: i64,
    request: &AdminStatusRequest,
) -> Result<ForumMutationResponse, AppError> {
    let next = validate_admin_status(request.status.trim())?;
    let reason = request
        .reason
        .as_deref()
        .map(str::trim)
        .filter(|value| !value.is_empty());
    if next == "hidden" && reason.is_none() {
        return Err(AppError::BadRequest("隐藏内容时必须填写原因".to_owned()));
    }
    if let Some(reason) = reason
        && char_count(reason) > MAX_REASON_CHARS
    {
        return Err(AppError::BadRequest(format!(
            "原因不能超过 {MAX_REASON_CHARS} 个字符"
        )));
    }

    let mut tx = pool.begin().await.map_err(AppError::Database)?;
    let row: Option<(i32, String, String)> =
        sqlx::query_as("SELECT author_id, status, title FROM forum_posts WHERE id = $1 FOR UPDATE")
            .bind(post_id)
            .fetch_optional(&mut *tx)
            .await
            .map_err(AppError::Database)?;
    let (author_id, before, title) =
        row.ok_or_else(|| AppError::NotFound("帖子不存在".to_owned()))?;
    if before == "deleted" {
        return Err(AppError::ConflictWith(
            "已删除的帖子不能恢复或修改".to_owned(),
        ));
    }
    if next == "published" && before != "hidden" {
        return Err(AppError::BadRequest("只有已隐藏的帖子可以恢复".to_owned()));
    }
    match next {
        "hidden" => {
            sqlx::query(
                "UPDATE forum_posts SET status = 'hidden', hidden_reason = 'moderation', \
                 hidden_by = $2, hidden_at = CURRENT_TIMESTAMP, is_pinned = FALSE, \
                 updated_at = CURRENT_TIMESTAMP WHERE id = $1",
            )
            .bind(post_id)
            .bind(admin.id)
            .execute(&mut *tx)
            .await
            .map_err(AppError::Database)?;
        }
        "published" => {
            sqlx::query(
                "UPDATE forum_posts SET status = 'published', hidden_reason = NULL, \
                 hidden_by = NULL, hidden_at = NULL, updated_at = CURRENT_TIMESTAMP \
                 WHERE id = $1",
            )
            .bind(post_id)
            .execute(&mut *tx)
            .await
            .map_err(AppError::Database)?;
        }
        _ => {
            sqlx::query(
                "UPDATE forum_posts SET status = 'deleted', hidden_reason = NULL, \
                 hidden_by = $2, hidden_at = CURRENT_TIMESTAMP, is_pinned = FALSE, \
                 updated_at = CURRENT_TIMESTAMP WHERE id = $1",
            )
            .bind(post_id)
            .bind(admin.id)
            .execute(&mut *tx)
            .await
            .map_err(AppError::Database)?;
        }
    }
    let report_resolution = if next == "published" {
        "rejected"
    } else {
        "resolved"
    };
    resolve_pending_reports(&mut tx, "post", post_id, report_resolution, admin.id).await?;
    clear_pending_count(&mut tx, "post", post_id).await?;
    let action = match next {
        "hidden" => "hide_post",
        "published" => "restore_post",
        _ => "delete_post",
    };
    write_action(
        &mut tx,
        Some(admin.id),
        action,
        "post",
        Some(post_id),
        reason,
        json!({ "before_status": before, "after_status": next }),
    )
    .await?;
    if author_id != admin.id {
        let (title_text, link) = match next {
            "hidden" => ("你的帖子已被隐藏", Some(format!("/forum/{post_id}"))),
            "published" => ("你的帖子已恢复显示", Some(format!("/forum/{post_id}"))),
            _ => ("你的帖子已被删除", None),
        };
        notification_service::create(
            &mut tx,
            author_id,
            "forum_moderation",
            Some(admin.id),
            title_text,
            Some(&make_excerpt(&title, 120)),
            link.as_deref(),
            Some("forum_post"),
            Some(post_id),
        )
        .await?;
    }
    tx.commit().await.map_err(AppError::Database)?;
    Ok(ForumMutationResponse {
        id: post_id,
        message: "帖子状态已更新".to_owned(),
    })
}

pub async fn admin_change_comment_status(
    pool: &PgPool,
    admin: &AuthUser,
    comment_id: i64,
    request: &AdminStatusRequest,
) -> Result<ForumMutationResponse, AppError> {
    let next = validate_admin_status(request.status.trim())?;
    let reason = request
        .reason
        .as_deref()
        .map(str::trim)
        .filter(|value| !value.is_empty());
    if next == "hidden" && reason.is_none() {
        return Err(AppError::BadRequest("隐藏内容时必须填写原因".to_owned()));
    }
    if let Some(reason) = reason
        && char_count(reason) > MAX_REASON_CHARS
    {
        return Err(AppError::BadRequest(format!(
            "原因不能超过 {MAX_REASON_CHARS} 个字符"
        )));
    }

    let mut tx = pool.begin().await.map_err(AppError::Database)?;
    let post_id: Option<i64> =
        sqlx::query_scalar("SELECT post_id FROM forum_comments WHERE id = $1")
            .bind(comment_id)
            .fetch_optional(&mut *tx)
            .await
            .map_err(AppError::Database)?;
    let post_id = post_id.ok_or_else(|| AppError::NotFound("评论不存在".to_owned()))?;
    sqlx::query("SELECT id FROM forum_posts WHERE id = $1 FOR UPDATE")
        .bind(post_id)
        .fetch_optional(&mut *tx)
        .await
        .map_err(AppError::Database)?;
    let row: Option<(i32, i64, String, String)> = sqlx::query_as(
        "SELECT author_id, post_id, status, body_md FROM forum_comments \
         WHERE id = $1 FOR UPDATE",
    )
    .bind(comment_id)
    .fetch_optional(&mut *tx)
    .await
    .map_err(AppError::Database)?;
    let (author_id, post_id, before, body) =
        row.ok_or_else(|| AppError::NotFound("评论不存在".to_owned()))?;
    if before == "deleted" {
        return Err(AppError::ConflictWith(
            "已删除的评论不能恢复或修改".to_owned(),
        ));
    }
    if next == "published" && before != "hidden" {
        return Err(AppError::BadRequest("只有已隐藏的评论可以恢复".to_owned()));
    }
    match next {
        "hidden" => {
            sqlx::query(
                "UPDATE forum_comments SET status = 'hidden', hidden_reason = 'moderation', \
                 hidden_by = $2, hidden_at = CURRENT_TIMESTAMP, updated_at = CURRENT_TIMESTAMP \
                 WHERE id = $1",
            )
            .bind(comment_id)
            .bind(admin.id)
            .execute(&mut *tx)
            .await
            .map_err(AppError::Database)?;
        }
        "published" => {
            sqlx::query(
                "UPDATE forum_comments SET status = 'published', hidden_reason = NULL, \
                 hidden_by = NULL, hidden_at = NULL, updated_at = CURRENT_TIMESTAMP \
                 WHERE id = $1",
            )
            .bind(comment_id)
            .execute(&mut *tx)
            .await
            .map_err(AppError::Database)?;
        }
        _ => {
            sqlx::query(
                "UPDATE forum_comments SET status = 'deleted', hidden_reason = NULL, \
                 hidden_by = $2, hidden_at = CURRENT_TIMESTAMP, updated_at = CURRENT_TIMESTAMP \
                 WHERE id = $1",
            )
            .bind(comment_id)
            .bind(admin.id)
            .execute(&mut *tx)
            .await
            .map_err(AppError::Database)?;
        }
    }
    let report_resolution = if next == "published" {
        "rejected"
    } else {
        "resolved"
    };
    resolve_pending_reports(&mut tx, "comment", comment_id, report_resolution, admin.id).await?;
    clear_pending_count(&mut tx, "comment", comment_id).await?;
    recompute_comment_count(&mut tx, post_id).await?;
    let action = match next {
        "hidden" => "hide_comment",
        "published" => "restore_comment",
        _ => "delete_comment",
    };
    write_action(
        &mut tx,
        Some(admin.id),
        action,
        "comment",
        Some(comment_id),
        reason,
        json!({ "before_status": before, "after_status": next, "post_id": post_id }),
    )
    .await?;
    if author_id != admin.id {
        let (title_text, link) = match next {
            "hidden" => (
                "你的评论已被隐藏",
                Some(format!("/forum/{post_id}#comment-{comment_id}")),
            ),
            "published" => (
                "你的评论已恢复显示",
                Some(format!("/forum/{post_id}#comment-{comment_id}")),
            ),
            _ => (
                "你的评论已被删除",
                Some(format!("/forum/{post_id}#comment-{comment_id}")),
            ),
        };
        notification_service::create(
            &mut tx,
            author_id,
            "forum_moderation",
            Some(admin.id),
            title_text,
            Some(&make_excerpt(&body, 120)),
            link.as_deref(),
            Some("forum_comment"),
            Some(comment_id),
        )
        .await?;
    }
    tx.commit().await.map_err(AppError::Database)?;
    Ok(ForumMutationResponse {
        id: comment_id,
        message: "评论状态已更新".to_owned(),
    })
}

pub async fn admin_pin_post(
    pool: &PgPool,
    config: &Config,
    admin: &AuthUser,
    post_id: i64,
    request: &AdminPinRequest,
) -> Result<PinResponse, AppError> {
    let mut tx = pool.begin().await.map_err(AppError::Database)?;
    let row: Option<(String, bool)> =
        sqlx::query_as("SELECT status, is_pinned FROM forum_posts WHERE id = $1 FOR UPDATE")
            .bind(post_id)
            .fetch_optional(&mut *tx)
            .await
            .map_err(AppError::Database)?;
    let (status, currently_pinned) =
        row.ok_or_else(|| AppError::NotFound("帖子不存在".to_owned()))?;
    if status != "published" {
        return Err(AppError::BadRequest("只能置顶已发布的帖子".to_owned()));
    }
    if currently_pinned == request.is_pinned {
        tx.commit().await.map_err(AppError::Database)?;
        return Ok(PinResponse {
            id: post_id,
            is_pinned: request.is_pinned,
            message: if request.is_pinned {
                "帖子已置顶".to_owned()
            } else {
                "已取消置顶".to_owned()
            },
        });
    }
    if request.is_pinned {
        let pinned_count: i64 = sqlx::query_scalar(
            "SELECT COUNT(*) FROM forum_posts WHERE status = 'published' AND is_pinned = TRUE",
        )
        .fetch_one(&mut *tx)
        .await
        .map_err(AppError::Database)?;
        if pinned_count >= config.forum_max_pinned {
            return Err(AppError::ConflictWith(format!(
                "置顶数量最多为 {} 条",
                config.forum_max_pinned
            )));
        }
    }
    if request.is_pinned {
        sqlx::query(
            "UPDATE forum_posts SET is_pinned = TRUE, pinned_at = CURRENT_TIMESTAMP, \
             updated_at = CURRENT_TIMESTAMP WHERE id = $1",
        )
        .bind(post_id)
        .execute(&mut *tx)
        .await
        .map_err(AppError::Database)?;
    } else {
        sqlx::query(
            "UPDATE forum_posts SET is_pinned = FALSE, pinned_at = NULL, \
             updated_at = CURRENT_TIMESTAMP WHERE id = $1",
        )
        .bind(post_id)
        .execute(&mut *tx)
        .await
        .map_err(AppError::Database)?;
    }
    write_action(
        &mut tx,
        Some(admin.id),
        if request.is_pinned {
            "pin_post"
        } else {
            "unpin_post"
        },
        "post",
        Some(post_id),
        None,
        json!({ "is_pinned": request.is_pinned }),
    )
    .await?;
    tx.commit().await.map_err(AppError::Database)?;
    Ok(PinResponse {
        id: post_id,
        is_pinned: request.is_pinned,
        message: if request.is_pinned {
            "帖子已置顶".to_owned()
        } else {
            "已取消置顶".to_owned()
        },
    })
}

#[derive(Debug, FromRow)]
struct AdminReportQueryRow {
    id: i64,
    target_type: String,
    target_id: i64,
    reporter_id: i32,
    reporter_username: String,
    reason: String,
    detail: Option<String>,
    status: String,
    resolution_note: Option<String>,
    handled_at: Option<DateTime<Utc>>,
    created_at: DateTime<Utc>,
    post_title: Option<String>,
    post_body: Option<String>,
    post_status: Option<String>,
    post_author_id: Option<i32>,
    post_author_username: Option<String>,
    post_author_email: Option<String>,
    post_author_role: Option<String>,
    comment_body: Option<String>,
    comment_status: Option<String>,
    comment_post_title: Option<String>,
    comment_author_id: Option<i32>,
    comment_author_username: Option<String>,
    comment_author_email: Option<String>,
    comment_author_role: Option<String>,
    post_id: Option<i64>,
}

fn admin_author(
    id: Option<i32>,
    username: Option<String>,
    email: Option<String>,
    role: Option<String>,
) -> Option<AdminAuthor> {
    match (id, username, email, role) {
        (Some(id), Some(username), Some(email), Some(role)) => {
            Some(AdminAuthor::new(id, username, email, role))
        }
        _ => None,
    }
}

impl AdminReportQueryRow {
    fn into_report(self) -> AdminReportRow {
        let (title, excerpt, status, author) = if self.target_type == "post" {
            (
                self.post_title,
                make_excerpt(self.post_body.as_deref().unwrap_or_default(), 120),
                self.post_status.unwrap_or_else(|| "deleted".to_owned()),
                admin_author(
                    self.post_author_id,
                    self.post_author_username,
                    self.post_author_email,
                    self.post_author_role,
                ),
            )
        } else {
            (
                self.comment_post_title,
                make_excerpt(self.comment_body.as_deref().unwrap_or_default(), 120),
                self.comment_status.unwrap_or_else(|| "deleted".to_owned()),
                admin_author(
                    self.comment_author_id,
                    self.comment_author_username,
                    self.comment_author_email,
                    self.comment_author_role,
                ),
            )
        };
        AdminReportRow {
            id: self.id,
            target_type: self.target_type,
            target_id: self.target_id,
            target_preview: AdminReportTargetPreview {
                post_id: self.post_id,
                title,
                excerpt,
                status,
                author,
            },
            reporter: crate::models::forum::Reporter {
                id: self.reporter_id,
                username: self.reporter_username,
            },
            reason: self.reason,
            detail: self.detail,
            status: self.status,
            resolution_note: self.resolution_note,
            handled_at: self.handled_at,
            created_at: self.created_at,
        }
    }
}

pub async fn admin_list_reports(
    pool: &PgPool,
    query: &AdminReportListQuery,
) -> Result<AdminReportListResponse, AppError> {
    let (page, size) = page_and_size(query.page, query.size, MAX_ADMIN_PAGE_SIZE);
    let status = query.status.as_deref().unwrap_or("pending");
    let status = match status {
        "all" => None,
        "pending" | "resolved" | "rejected" => Some(status),
        _ => return Err(AppError::BadRequest("举报状态筛选值无效".to_owned())),
    };
    let mut builder = QueryBuilder::<Postgres>::new(
        "SELECT r.id, r.target_type, r.target_id, r.reporter_id, \
         reporter.username AS reporter_username, r.reason, r.detail, r.status, \
         r.resolution_note, r.handled_at, r.created_at, \
         fp.title AS post_title, fp.body_md AS post_body, fp.status AS post_status, \
         pa.id AS post_author_id, pa.username AS post_author_username, \
         pa.email AS post_author_email, pa.role AS post_author_role, \
         fc.body_md AS comment_body, fc.status AS comment_status, \
         cp.title AS comment_post_title, ca.id AS comment_author_id, \
         ca.username AS comment_author_username, ca.email AS comment_author_email, \
         ca.role AS comment_author_role, COALESCE(fp.id, cp.id) AS post_id \
         FROM forum_reports r \
         JOIN users reporter ON reporter.id = r.reporter_id \
         LEFT JOIN forum_posts fp ON r.target_type = 'post' AND fp.id = r.target_id \
         LEFT JOIN users pa ON pa.id = fp.author_id \
         LEFT JOIN forum_comments fc ON r.target_type = 'comment' AND fc.id = r.target_id \
         LEFT JOIN forum_posts cp ON cp.id = fc.post_id \
         LEFT JOIN users ca ON ca.id = fc.author_id \
         WHERE TRUE",
    );
    if let Some(status) = status {
        builder.push(" AND r.status = ").push_bind(status);
    }
    builder
        .push(" ORDER BY r.created_at ASC, r.id ASC LIMIT ")
        .push_bind(i64::from(size))
        .push(" OFFSET ")
        .push_bind(i64::from(page.saturating_sub(1)) * i64::from(size));
    let rows: Vec<AdminReportQueryRow> = builder
        .build_query_as()
        .fetch_all(pool)
        .await
        .map_err(AppError::Database)?;
    let mut count_builder =
        QueryBuilder::<Postgres>::new("SELECT COUNT(*) FROM forum_reports r WHERE TRUE");
    if let Some(status) = status {
        count_builder.push(" AND r.status = ").push_bind(status);
    }
    let total: i64 = count_builder
        .build_query_scalar()
        .fetch_one(pool)
        .await
        .map_err(AppError::Database)?;
    let pending_total: i64 =
        sqlx::query_scalar("SELECT COUNT(*) FROM forum_reports WHERE status = 'pending'")
            .fetch_one(pool)
            .await
            .map_err(AppError::Database)?;
    Ok(AdminReportListResponse {
        pending_total,
        total,
        page,
        size,
        reports: rows
            .into_iter()
            .map(AdminReportQueryRow::into_report)
            .collect(),
    })
}

pub async fn admin_decide_report(
    pool: &PgPool,
    config: &Config,
    admin: &AuthUser,
    report_id: i64,
    request: &AdminReportDecisionRequest,
) -> Result<ReportDecisionResponse, AppError> {
    let decision = request.decision.trim();
    if !matches!(decision, "hide" | "keep") {
        return Err(AppError::BadRequest("处理决定无效".to_owned()));
    }
    let note = request
        .note
        .as_deref()
        .map(str::trim)
        .filter(|value| !value.is_empty());
    if let Some(note) = note
        && char_count(note) > MAX_REASON_CHARS
    {
        return Err(AppError::BadRequest(format!(
            "备注不能超过 {MAX_REASON_CHARS} 个字符"
        )));
    }

    let mut tx = pool.begin().await.map_err(AppError::Database)?;
    let report: Option<(String, i64)> =
        sqlx::query_as("SELECT target_type, target_id FROM forum_reports WHERE id = $1")
            .bind(report_id)
            .fetch_optional(&mut *tx)
            .await
            .map_err(AppError::Database)?;
    let (target_type, target_id) =
        report.ok_or_else(|| AppError::NotFound("举报不存在".to_owned()))?;
    let content = lock_content(&mut tx, &target_type, target_id).await?;
    let report_status: String =
        sqlx::query_scalar("SELECT status FROM forum_reports WHERE id = $1 FOR UPDATE")
            .bind(report_id)
            .fetch_one(&mut *tx)
            .await
            .map_err(AppError::Database)?;
    if report_status != "pending" {
        return Err(AppError::ConflictWith("该举报已处理".to_owned()));
    }
    let mut restored = false;

    if decision == "hide" {
        sqlx::query(
            "UPDATE forum_reports SET status = 'resolved', handled_by = $2, \
             handled_at = CURRENT_TIMESTAMP, resolution_note = $3 WHERE id = $1",
        )
        .bind(report_id)
        .bind(admin.id)
        .bind(note)
        .execute(&mut *tx)
        .await
        .map_err(AppError::Database)?;
        if let Some(content) = &content
            && content.status != "deleted"
        {
            apply_hidden(
                &mut tx,
                &target_type,
                target_id,
                Some(admin.id),
                "moderation",
            )
            .await?;
            sqlx::query(
                "UPDATE forum_reports SET status = 'resolved', handled_by = $4, \
                     handled_at = CURRENT_TIMESTAMP WHERE target_type = $1 AND target_id = $2 \
                     AND id <> $3 AND status = 'pending'",
            )
            .bind(&target_type)
            .bind(target_id)
            .bind(report_id)
            .bind(admin.id)
            .execute(&mut *tx)
            .await
            .map_err(AppError::Database)?;
            clear_pending_count(&mut tx, &target_type, target_id).await?;
            write_action(
                &mut tx,
                Some(admin.id),
                "resolve_report",
                &target_type,
                Some(target_id),
                note,
                json!({
                    "report_id": report_id,
                    "before_status": content.status,
                    "after_status": "hidden",
                }),
            )
            .await?;
            if content.author_id != admin.id {
                notification_service::create(
                    &mut tx,
                    content.author_id,
                    "forum_moderation",
                    Some(admin.id),
                    if target_type == "post" {
                        "你的帖子已被隐藏"
                    } else {
                        "你的评论已被隐藏"
                    },
                    Some(&content.excerpt),
                    Some(&content.link),
                    Some(if target_type == "post" {
                        "forum_post"
                    } else {
                        "forum_comment"
                    }),
                    Some(target_id),
                )
                .await?;
            }
        }
    } else {
        sqlx::query(
            "UPDATE forum_reports SET status = 'rejected', handled_by = $2, \
             handled_at = CURRENT_TIMESTAMP, resolution_note = $3 WHERE id = $1",
        )
        .bind(report_id)
        .bind(admin.id)
        .bind(note)
        .execute(&mut *tx)
        .await
        .map_err(AppError::Database)?;
        if let Some(content) = &content {
            let pending_count: i32 = match target_type.as_str() {
                "post" => sqlx::query_scalar(
                    "UPDATE forum_posts SET pending_report_count = \
                     GREATEST(pending_report_count - 1, 0), updated_at = CURRENT_TIMESTAMP \
                     WHERE id = $1 RETURNING pending_report_count",
                )
                .bind(target_id)
                .fetch_one(&mut *tx)
                .await
                .map_err(AppError::Database)?,
                _ => sqlx::query_scalar(
                    "UPDATE forum_comments SET pending_report_count = \
                     GREATEST(pending_report_count - 1, 0), updated_at = CURRENT_TIMESTAMP \
                     WHERE id = $1 RETURNING pending_report_count",
                )
                .bind(target_id)
                .fetch_one(&mut *tx)
                .await
                .map_err(AppError::Database)?,
            };
            if content.status == "hidden"
                && content.hidden_reason.as_deref() == Some("report_threshold")
                && pending_count < config.forum_report_hide_threshold
            {
                restored = true;
                match target_type.as_str() {
                    "post" => {
                        sqlx::query(
                            "UPDATE forum_posts SET status = 'published', hidden_reason = NULL, \
                             hidden_by = NULL, hidden_at = NULL, updated_at = CURRENT_TIMESTAMP \
                             WHERE id = $1",
                        )
                        .bind(target_id)
                        .execute(&mut *tx)
                        .await
                        .map_err(AppError::Database)?;
                    }
                    _ => {
                        sqlx::query(
                            "UPDATE forum_comments SET status = 'published', \
                             hidden_reason = NULL, hidden_by = NULL, hidden_at = NULL, \
                             updated_at = CURRENT_TIMESTAMP WHERE id = $1",
                        )
                        .bind(target_id)
                        .execute(&mut *tx)
                        .await
                        .map_err(AppError::Database)?;
                        let post_id = content_post_id(target_id, &mut tx).await?;
                        recompute_comment_count(&mut tx, post_id).await?;
                    }
                }
                write_action(
                    &mut tx,
                    Some(admin.id),
                    if target_type == "post" {
                        "restore_post"
                    } else {
                        "restore_comment"
                    },
                    &target_type,
                    Some(target_id),
                    note,
                    json!({ "report_id": report_id, "reason": "report_kept" }),
                )
                .await?;
                if content.author_id != admin.id {
                    notification_service::create(
                        &mut tx,
                        content.author_id,
                        "forum_moderation",
                        Some(admin.id),
                        if target_type == "post" {
                            "你的帖子已恢复显示"
                        } else {
                            "你的评论已恢复显示"
                        },
                        Some(&content.excerpt),
                        Some(&content.link),
                        Some(if target_type == "post" {
                            "forum_post"
                        } else {
                            "forum_comment"
                        }),
                        Some(target_id),
                    )
                    .await?;
                }
            }
            write_action(
                &mut tx,
                Some(admin.id),
                "reject_report",
                &target_type,
                Some(target_id),
                note,
                json!({
                    "report_id": report_id,
                    "remaining_pending": pending_count,
                    "restored": restored,
                }),
            )
            .await?;
        }
    }
    let target_status: String = if let Some(content) = &content {
        if restored {
            "published".to_owned()
        } else if decision == "hide" && content.status != "deleted" {
            "hidden".to_owned()
        } else {
            content.status.clone()
        }
    } else {
        "deleted".to_owned()
    };
    tx.commit().await.map_err(AppError::Database)?;
    Ok(ReportDecisionResponse {
        id: report_id,
        status: if decision == "hide" {
            "resolved".to_owned()
        } else {
            "rejected".to_owned()
        },
        target_status,
        restored,
        message: if decision == "hide" {
            "举报已处理，内容已隐藏".to_owned()
        } else {
            "举报已驳回".to_owned()
        },
    })
}

async fn content_post_id(
    target_id: i64,
    tx: &mut Transaction<'_, Postgres>,
) -> Result<i64, AppError> {
    sqlx::query_scalar("SELECT post_id FROM forum_comments WHERE id = $1")
        .bind(target_id)
        .fetch_one(&mut **tx)
        .await
        .map_err(AppError::Database)
}

async fn apply_hidden(
    tx: &mut Transaction<'_, Postgres>,
    target_type: &str,
    target_id: i64,
    hidden_by: Option<i32>,
    hidden_reason: &str,
) -> Result<(), AppError> {
    match target_type {
        "post" => {
            sqlx::query(
                "UPDATE forum_posts SET status = 'hidden', hidden_reason = $3, \
                 hidden_by = $2, hidden_at = CURRENT_TIMESTAMP, is_pinned = FALSE, \
                 pending_report_count = 0, updated_at = CURRENT_TIMESTAMP WHERE id = $1",
            )
            .bind(target_id)
            .bind(hidden_by)
            .bind(hidden_reason)
            .execute(&mut **tx)
            .await
            .map_err(AppError::Database)?;
        }
        _ => {
            sqlx::query(
                "UPDATE forum_comments SET status = 'hidden', hidden_reason = $3, \
                 hidden_by = $2, hidden_at = CURRENT_TIMESTAMP, pending_report_count = 0, \
                 updated_at = CURRENT_TIMESTAMP WHERE id = $1",
            )
            .bind(target_id)
            .bind(hidden_by)
            .bind(hidden_reason)
            .execute(&mut **tx)
            .await
            .map_err(AppError::Database)?;
            let post_id: i64 =
                sqlx::query_scalar("SELECT post_id FROM forum_comments WHERE id = $1")
                    .bind(target_id)
                    .fetch_one(&mut **tx)
                    .await
                    .map_err(AppError::Database)?;
            recompute_comment_count(tx, post_id).await?;
        }
    }
    Ok(())
}

async fn clear_pending_count(
    tx: &mut Transaction<'_, Postgres>,
    target_type: &str,
    target_id: i64,
) -> Result<(), AppError> {
    let sql = if target_type == "post" {
        "UPDATE forum_posts SET pending_report_count = 0 WHERE id = $1"
    } else {
        "UPDATE forum_comments SET pending_report_count = 0 WHERE id = $1"
    };
    sqlx::query(sql)
        .bind(target_id)
        .execute(&mut **tx)
        .await
        .map_err(AppError::Database)?;
    Ok(())
}

pub async fn admin_mute_user(
    pool: &PgPool,
    admin: &AuthUser,
    user_id: i32,
    request: &AdminMuteRequest,
) -> Result<MuteResponse, AppError> {
    if user_id == admin.id {
        return Err(AppError::BadRequest("不能禁言自己".to_owned()));
    }
    let reason = request.reason.trim();
    if reason.is_empty() {
        return Err(AppError::BadRequest("禁言原因不能为空".to_owned()));
    }
    if char_count(reason) > MAX_REASON_CHARS {
        return Err(AppError::BadRequest(format!(
            "禁言原因不能超过 {MAX_REASON_CHARS} 个字符"
        )));
    }
    let target_username: Option<String> =
        sqlx::query_scalar("SELECT username FROM users WHERE id = $1")
            .bind(user_id)
            .fetch_optional(pool)
            .await
            .map_err(AppError::Database)?;
    let target_username =
        target_username.ok_or_else(|| AppError::NotFound("用户不存在".to_owned()))?;
    let ends_at = mute_ends_at(Utc::now(), request.duration_hours)?;

    let mut tx = pool.begin().await.map_err(AppError::Database)?;
    let (mute_id, stored_ends_at): (i64, Option<DateTime<Utc>>) = sqlx::query_as(
        "INSERT INTO user_mutes (user_id, muted_by, reason, ends_at) \
         VALUES ($1, $2, $3, $4) RETURNING id, ends_at",
    )
    .bind(user_id)
    .bind(admin.id)
    .bind(reason)
    .bind(ends_at)
    .fetch_one(&mut *tx)
    .await
    .map_err(AppError::Database)?;
    write_action(
        &mut tx,
        Some(admin.id),
        "mute_user",
        "user",
        Some(i64::from(user_id)),
        Some(reason),
        json!({ "duration_hours": request.duration_hours, "mute_id": mute_id }),
    )
    .await?;
    let duration_text = request
        .duration_hours
        .map(|hours| format!("{hours} 小时"))
        .unwrap_or_else(|| "永久".to_owned());
    notification_service::create(
        &mut tx,
        user_id,
        "forum_mute",
        Some(admin.id),
        "你已被禁言",
        Some(&format!("原因：{reason}；时长：{duration_text}")),
        None,
        Some("user"),
        Some(i64::from(user_id)),
    )
    .await?;
    tx.commit().await.map_err(AppError::Database)?;
    Ok(MuteResponse {
        mute_id: Some(mute_id),
        user_id,
        ends_at: stored_ends_at,
        message: format!("已禁言用户 {target_username}"),
    })
}

pub async fn admin_unmute_user(
    pool: &PgPool,
    admin: &AuthUser,
    user_id: i32,
) -> Result<MuteResponse, AppError> {
    if user_id == admin.id {
        return Err(AppError::BadRequest("不能解除自己的禁言".to_owned()));
    }
    let target_username: Option<String> =
        sqlx::query_scalar("SELECT username FROM users WHERE id = $1")
            .bind(user_id)
            .fetch_optional(pool)
            .await
            .map_err(AppError::Database)?;
    let target_username =
        target_username.ok_or_else(|| AppError::NotFound("用户不存在".to_owned()))?;

    let mut tx = pool.begin().await.map_err(AppError::Database)?;
    let updated = sqlx::query(
        "UPDATE user_mutes SET revoked_at = CURRENT_TIMESTAMP \
         WHERE user_id = $1 AND revoked_at IS NULL AND starts_at <= CURRENT_TIMESTAMP \
         AND (ends_at IS NULL OR ends_at > CURRENT_TIMESTAMP)",
    )
    .bind(user_id)
    .execute(&mut *tx)
    .await
    .map_err(AppError::Database)?;
    if updated.rows_affected() == 0 {
        return Err(AppError::ConflictWith("该用户当前未被禁言".to_owned()));
    }
    write_action(
        &mut tx,
        Some(admin.id),
        "unmute_user",
        "user",
        Some(i64::from(user_id)),
        None,
        json!({ "revoked": updated.rows_affected() }),
    )
    .await?;
    notification_service::create(
        &mut tx,
        user_id,
        "forum_mute",
        Some(admin.id),
        "你的禁言已解除",
        Some("你现在可以继续发帖和评论了"),
        None,
        Some("user"),
        Some(i64::from(user_id)),
    )
    .await?;
    tx.commit().await.map_err(AppError::Database)?;
    Ok(MuteResponse {
        mute_id: None,
        user_id,
        ends_at: None,
        message: format!("已解除用户 {target_username} 的禁言"),
    })
}

#[derive(Debug, FromRow)]
struct AdminActionQueryRow {
    id: i64,
    actor_id: Option<i32>,
    actor_username: Option<String>,
    action: String,
    target_type: String,
    target_id: Option<i64>,
    reason: Option<String>,
    metadata: Value,
    created_at: DateTime<Utc>,
}

pub async fn admin_list_actions(
    pool: &PgPool,
    query: &AdminActionListQuery,
) -> Result<AdminActionListResponse, AppError> {
    let (page, size) = page_and_size(query.page, query.size, MAX_ADMIN_PAGE_SIZE);
    let mut builder = QueryBuilder::<Postgres>::new(
        "SELECT a.id, a.actor_id, actor.username AS actor_username, a.action, \
         a.target_type, a.target_id, a.reason, a.metadata, a.created_at \
         FROM moderation_actions a LEFT JOIN users actor ON actor.id = a.actor_id \
         WHERE TRUE",
    );
    if let Some(target_type) = query
        .target_type
        .as_deref()
        .map(str::trim)
        .filter(|value| !value.is_empty())
    {
        builder
            .push(" AND a.target_type = ")
            .push_bind(target_type.to_owned());
    }
    if let Some(target_id) = query.target_id {
        builder.push(" AND a.target_id = ").push_bind(target_id);
    }
    builder
        .push(" ORDER BY a.created_at DESC, a.id DESC LIMIT ")
        .push_bind(i64::from(size))
        .push(" OFFSET ")
        .push_bind(i64::from(page.saturating_sub(1)) * i64::from(size));
    let rows: Vec<AdminActionQueryRow> = builder
        .build_query_as()
        .fetch_all(pool)
        .await
        .map_err(AppError::Database)?;
    let mut count_builder =
        QueryBuilder::<Postgres>::new("SELECT COUNT(*) FROM moderation_actions a WHERE TRUE");
    if let Some(target_type) = query
        .target_type
        .as_deref()
        .map(str::trim)
        .filter(|value| !value.is_empty())
    {
        count_builder
            .push(" AND a.target_type = ")
            .push_bind(target_type.to_owned());
    }
    if let Some(target_id) = query.target_id {
        count_builder
            .push(" AND a.target_id = ")
            .push_bind(target_id);
    }
    let total: i64 = count_builder
        .build_query_scalar()
        .fetch_one(pool)
        .await
        .map_err(AppError::Database)?;
    Ok(AdminActionListResponse {
        total,
        page,
        size,
        actions: rows
            .into_iter()
            .map(|row| AdminActionRow {
                id: row.id,
                actor: match (row.actor_id, row.actor_username) {
                    (Some(id), Some(username)) => Some(AdminActionActor { id, username }),
                    _ => None,
                },
                action: row.action,
                target_type: row.target_type,
                target_id: row.target_id,
                reason: row.reason,
                metadata: row.metadata,
                created_at: row.created_at,
            })
            .collect(),
    })
}

async fn recompute_comment_count(
    tx: &mut Transaction<'_, Postgres>,
    post_id: i64,
) -> Result<(), AppError> {
    sqlx::query(
        "UPDATE forum_posts SET comment_count = \
         (SELECT COUNT(*) FROM forum_comments WHERE post_id = $1 AND status = 'published'), \
         updated_at = CURRENT_TIMESTAMP WHERE id = $1",
    )
    .bind(post_id)
    .execute(&mut **tx)
    .await
    .map_err(AppError::Database)?;
    Ok(())
}

async fn resolve_pending_reports(
    tx: &mut Transaction<'_, Postgres>,
    target_type: &str,
    target_id: i64,
    status: &str,
    handled_by: i32,
) -> Result<(), AppError> {
    sqlx::query(
        "UPDATE forum_reports SET status = $3, handled_by = $4, \
         handled_at = CURRENT_TIMESTAMP WHERE target_type = $1 AND target_id = $2 \
         AND status = 'pending'",
    )
    .bind(target_type)
    .bind(target_id)
    .bind(status)
    .bind(handled_by)
    .execute(&mut **tx)
    .await
    .map_err(AppError::Database)?;
    Ok(())
}

async fn write_action(
    tx: &mut Transaction<'_, Postgres>,
    actor_id: Option<i32>,
    action: &str,
    target_type: &str,
    target_id: Option<i64>,
    reason: Option<&str>,
    metadata: Value,
) -> Result<(), AppError> {
    sqlx::query(
        "INSERT INTO moderation_actions \
         (actor_id, action, target_type, target_id, reason, metadata) \
         VALUES ($1, $2, $3, $4, $5, $6)",
    )
    .bind(actor_id)
    .bind(action)
    .bind(target_type)
    .bind(target_id)
    .bind(reason.map(|value| value.chars().take(MAX_REASON_CHARS).collect::<String>()))
    .bind(metadata)
    .execute(&mut **tx)
    .await
    .map_err(AppError::Database)?;
    Ok(())
}

pub async fn list_favorites(
    pool: &PgPool,
    config: &Config,
    user_id: i32,
    query: &crate::models::profile::ForumFavoriteQuery,
) -> Result<crate::models::profile::ForumFavoriteListResponse, AppError> {
    ensure_enabled(config)?;
    let (page, size) = page_and_size(query.page, query.size, MAX_PUBLIC_PAGE_SIZE);
    let offset = i64::from(page - 1) * i64::from(size);

    let total: i64 = sqlx::query_scalar(
        "SELECT COUNT(*)::bigint FROM forum_post_favorites f \
         JOIN forum_posts fp ON fp.id = f.post_id \
         WHERE f.user_id = $1 AND (fp.board = 'general' \
           OR fp.author_id = $1 \
           OR EXISTS (SELECT 1 FROM plus_memberships pm \
                      WHERE pm.user_id = $1 AND pm.expires_at > CURRENT_TIMESTAMP) \
           OR EXISTS (SELECT 1 FROM users u WHERE u.id = $1 AND u.role = 'admin'))",
    )
    .bind(user_id)
    .fetch_one(pool)
    .await
    .map_err(AppError::Database)?;

    #[derive(FromRow)]
    struct FavoriteRow {
        post_id: i64,
        title: String,
        status: String,
        favorite_count: i32,
        comment_count: i32,
        favorited_at: DateTime<Utc>,
        author_id: i32,
        author_username: String,
    }

    let rows: Vec<FavoriteRow> = sqlx::query_as(
        "SELECT fp.id AS post_id, fp.title, fp.status, fp.favorite_count, fp.comment_count,
                f.created_at AS favorited_at, u.id AS author_id, u.username AS author_username
         FROM forum_post_favorites f
         JOIN forum_posts fp ON fp.id = f.post_id
         JOIN users u ON u.id = fp.author_id
         WHERE f.user_id = $1 AND (fp.board = 'general'
           OR fp.author_id = $1
           OR EXISTS (SELECT 1 FROM plus_memberships pm
                      WHERE pm.user_id = $1 AND pm.expires_at > CURRENT_TIMESTAMP)
           OR EXISTS (SELECT 1 FROM users u2 WHERE u2.id = $1 AND u2.role = 'admin'))
         ORDER BY f.created_at DESC, fp.id DESC
         LIMIT $2 OFFSET $3",
    )
    .bind(user_id)
    .bind(i64::from(size))
    .bind(offset)
    .fetch_all(pool)
    .await
    .map_err(AppError::Database)?;

    Ok(crate::models::profile::ForumFavoriteListResponse {
        total,
        page,
        size,
        favorites: rows
            .into_iter()
            .map(|row| crate::models::profile::ForumFavoriteItem {
                post_id: row.post_id,
                title: row.title,
                status: row.status,
                favorite_count: row.favorite_count,
                comment_count: row.comment_count,
                favorited_at: row.favorited_at,
                author: crate::models::profile::ForumFavoriteAuthor {
                    id: row.author_id,
                    username: row.author_username,
                },
            })
            .collect(),
    })
}

#[cfg(test)]
mod tests {
    use chrono::{TimeDelta, Utc};

    use super::{
        BOARD_GENERAL, BOARD_INTERVIEW, escape_like, make_excerpt, mute_ends_at, normalize_board,
        normalize_interview_date, normalize_interview_meta, normalize_tags,
    };

    #[test]
    fn escapes_like_wildcards() {
        assert_eq!(escape_like("100%_a\\b"), "100\\%\\_a\\\\b");
        assert_eq!(escape_like("普通搜索"), "普通搜索");
    }

    #[test]
    fn validates_mute_duration_bounds() {
        let now = Utc::now();
        assert!(mute_ends_at(now, None).unwrap().is_none());
        assert!(mute_ends_at(now, Some(0)).is_err());
        assert!(mute_ends_at(now, Some(-1)).is_err());
        assert!(mute_ends_at(now, Some(i64::MAX)).is_err());
        assert!(mute_ends_at(now, Some(5_000_000_000)).is_err());
        let ends_at = mute_ends_at(now, Some(8_760)).unwrap().unwrap();
        assert_eq!(
            ends_at.signed_duration_since(now),
            TimeDelta::try_hours(8_760).unwrap()
        );
    }

    #[test]
    fn normalizes_and_deduplicates_tags() {
        let tags = vec![" help ".to_owned(), "help".to_owned(), "general".to_owned()];
        assert_eq!(
            normalize_tags(&tags, false, BOARD_GENERAL).unwrap(),
            vec!["help", "general"]
        );
    }

    #[test]
    fn interview_tags_are_free_form() {
        let tags = vec!["后端".to_owned(), "场景题".to_owned()];
        assert_eq!(
            normalize_tags(&tags, false, BOARD_INTERVIEW).unwrap(),
            vec!["后端", "场景题"]
        );
        assert!(normalize_tags(&["超".repeat(21)], false, BOARD_INTERVIEW).is_err());
        let too_many: Vec<String> = (0..9).map(|index| format!("标签{index}")).collect();
        assert!(normalize_tags(&too_many, false, BOARD_INTERVIEW).is_err());
    }

    #[test]
    fn rejects_announcement_for_normal_users() {
        assert!(normalize_tags(&["announcement".to_owned()], false, BOARD_GENERAL).is_err());
        assert!(normalize_tags(&["announcement".to_owned()], true, BOARD_GENERAL).is_ok());
    }

    #[test]
    fn rejects_invalid_tag_counts() {
        assert!(normalize_tags(&[], false, BOARD_GENERAL).is_err());
        assert!(
            normalize_tags(
                &[
                    "general".to_owned(),
                    "help".to_owned(),
                    "solution".to_owned(),
                    "discussion".to_owned(),
                ],
                false,
                BOARD_GENERAL
            )
            .is_err()
        );
    }

    #[test]
    fn validates_boards_and_interview_dates() {
        assert_eq!(normalize_board(None).unwrap(), BOARD_GENERAL);
        assert_eq!(normalize_board(Some("")).unwrap(), BOARD_GENERAL);
        assert_eq!(normalize_board(Some("interview")).unwrap(), BOARD_INTERVIEW);
        assert!(normalize_board(Some("unknown")).is_err());

        assert_eq!(normalize_interview_date(None).unwrap(), None);
        assert_eq!(
            normalize_interview_date(Some(" 2026-10 ")).unwrap(),
            Some("2026-10".to_owned())
        );
        for value in [
            "2026-1", "2026-13", "2026-00", "26-10", "2026/10", "abcd-ef",
        ] {
            assert!(normalize_interview_date(Some(value)).is_err(), "{value}");
        }
    }

    #[test]
    fn normalizes_interview_company_and_role() {
        assert_eq!(normalize_interview_meta(None, "公司").unwrap(), None);
        assert_eq!(normalize_interview_meta(Some("   "), "公司").unwrap(), None);
        assert_eq!(
            normalize_interview_meta(Some(" 百度 "), "公司").unwrap(),
            Some("百度".to_owned())
        );
        assert!(normalize_interview_meta(Some(&"字".repeat(41)), "岗位").is_err());
    }

    #[test]
    fn excerpt_removes_markdown_markers_and_truncates() {
        let excerpt = make_excerpt("## 标题\n\n```python\nprint(1)\n```\n正文", 20);
        assert!(excerpt.contains("标题"));
        assert!(excerpt.contains("正文"));
        assert!(!excerpt.contains("```"));
        assert!(make_excerpt(&"字".repeat(100), 10).chars().count() <= 10);
    }
}
