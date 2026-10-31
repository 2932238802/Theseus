use chrono::{DateTime, Utc};
use sqlx::{FromRow, PgPool, Postgres, Transaction};

use crate::{
    common::error::AppError,
    middleware::auth::AuthUser,
    models::knowledge::{
        AdminKnowledgeQuery, KNOWLEDGE_STATUS_APPROVED, KNOWLEDGE_STATUS_PENDING,
        KNOWLEDGE_STATUS_REJECTED, KnowledgeArticleDetail, KnowledgeArticleInput,
        KnowledgeArticleSummary, KnowledgeArticleUpdate, KnowledgeListQuery, KnowledgeListResponse,
        KnowledgeMutationResponse, KnowledgeResolveInput, KnowledgeResolveResponse,
        MAX_CONTENT_CHARS, MAX_NOTE_CHARS, MAX_SUMMARY_CHARS, MAX_TAG_CHARS, MAX_TAGS,
        MAX_TITLE_CHARS, MyKnowledgeQuery, category_label, is_known_category,
    },
    services::{forum_service, notification_service, plus_service},
};

const DEFAULT_PAGE: u32 = 1;
const DEFAULT_SIZE: u32 = 12;
const MAX_PAGE_SIZE: u32 = 50;
const MAX_ADMIN_PAGE_SIZE: u32 = 100;
const MAX_SEARCH_CHARS: usize = 100;

#[derive(FromRow)]
struct ArticleRow {
    id: i64,
    author_id: Option<i32>,
    category: String,
    title: String,
    summary: String,
    content: String,
    tags: Vec<String>,
    status: String,
    review_note: Option<String>,
    reviewed_by: Option<String>,
    reviewed_at: Option<DateTime<Utc>>,
    created_at: DateTime<Utc>,
    updated_at: DateTime<Utc>,
    author: Option<String>,
}

impl ArticleRow {
    fn summary(&self) -> KnowledgeArticleSummary {
        KnowledgeArticleSummary {
            id: self.id,
            category: self.category.clone(),
            title: self.title.clone(),
            summary: self.summary.clone(),
            tags: self.tags.clone(),
            author: self.author.clone(),
            status: self.status.clone(),
            created_at: self.created_at,
            updated_at: self.updated_at,
        }
    }
}

struct NormalizedArticle {
    title: String,
    summary: String,
    content: String,
    tags: Vec<String>,
}

const ARTICLE_SELECT: &str = "SELECT a.id, a.author_id, a.category, a.title, a.summary, \
     a.content, a.tags, a.status, a.review_note, r.username AS reviewed_by, \
     a.reviewed_at, a.created_at, a.updated_at, u.username AS author \
     FROM knowledge_articles a \
     LEFT JOIN users u ON u.id = a.author_id \
     LEFT JOIN users r ON r.id = a.reviewed_by";

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

fn clean_filter(value: Option<&str>) -> Option<&str> {
    value.map(str::trim).filter(|value| !value.is_empty())
}

fn clean_query(query: Option<&str>) -> Result<Option<String>, AppError> {
    let Some(value) = clean_filter(query) else {
        return Ok(None);
    };
    if value.chars().count() > MAX_SEARCH_CHARS {
        return Err(AppError::BadRequest(format!(
            "搜索关键词不能超过 {MAX_SEARCH_CHARS} 字"
        )));
    }
    Ok(Some(like_pattern(value)))
}

fn validate_category(category: Option<&str>) -> Result<Option<&str>, AppError> {
    let Some(category) = clean_filter(category) else {
        return Ok(None);
    };
    if !is_known_category(category) {
        return Err(AppError::BadRequest(
            "栏目只能是 408 或 interview".to_owned(),
        ));
    }
    Ok(Some(category))
}

fn validate_status(status: Option<&str>) -> Result<Option<&str>, AppError> {
    let Some(status) = clean_filter(status) else {
        return Ok(None);
    };
    if ![
        KNOWLEDGE_STATUS_PENDING,
        KNOWLEDGE_STATUS_APPROVED,
        KNOWLEDGE_STATUS_REJECTED,
    ]
    .contains(&status)
    {
        return Err(AppError::BadRequest("状态筛选无效".to_owned()));
    }
    Ok(Some(status))
}

fn normalize_tags(tags: &[String]) -> Result<Vec<String>, AppError> {
    let mut normalized: Vec<String> = Vec::new();
    for tag in tags {
        let tag = tag.trim();
        if tag.is_empty() {
            continue;
        }
        if tag.chars().count() > MAX_TAG_CHARS {
            return Err(AppError::BadRequest(format!(
                "单个标签不能超过 {MAX_TAG_CHARS} 字"
            )));
        }
        if !normalized.iter().any(|existing| existing == tag) {
            normalized.push(tag.to_owned());
        }
    }
    if normalized.len() > MAX_TAGS {
        return Err(AppError::BadRequest(format!("标签不能超过 {MAX_TAGS} 个")));
    }
    Ok(normalized)
}

fn normalize_article(
    title: &str,
    summary: Option<&str>,
    content: &str,
    tags: &[String],
) -> Result<NormalizedArticle, AppError> {
    let title = title.trim();
    if title.is_empty() {
        return Err(AppError::BadRequest("请填写标题".to_owned()));
    }
    if title.chars().count() > MAX_TITLE_CHARS {
        return Err(AppError::BadRequest(format!(
            "标题不能超过 {MAX_TITLE_CHARS} 字"
        )));
    }

    let content = content.trim();
    if content.is_empty() {
        return Err(AppError::BadRequest("请填写正文".to_owned()));
    }
    if content.chars().count() > MAX_CONTENT_CHARS {
        return Err(AppError::BadRequest(format!(
            "正文不能超过 {MAX_CONTENT_CHARS} 字"
        )));
    }

    let summary = summary.map(str::trim).unwrap_or_default();
    let summary = if summary.is_empty() {
        let derived = forum_service::make_excerpt(content, 160);
        if derived.is_empty() {
            content.chars().take(160).collect()
        } else {
            derived
        }
    } else {
        summary.to_owned()
    };
    if summary.chars().count() > MAX_SUMMARY_CHARS {
        return Err(AppError::BadRequest(format!(
            "摘要不能超过 {MAX_SUMMARY_CHARS} 字"
        )));
    }

    Ok(NormalizedArticle {
        title: title.to_owned(),
        summary,
        content: content.to_owned(),
        tags: normalize_tags(tags)?,
    })
}

async fn fetch_row(pool: &PgPool, article_id: i64) -> Result<Option<ArticleRow>, AppError> {
    sqlx::query_as::<_, ArticleRow>(&format!("{ARTICLE_SELECT} WHERE a.id = $1"))
        .bind(article_id)
        .fetch_optional(pool)
        .await
        .map_err(AppError::Database)
}

async fn detail_response(
    pool: &PgPool,
    user: &AuthUser,
    article_id: i64,
) -> Result<KnowledgeArticleDetail, AppError> {
    let row = fetch_row(pool, article_id)
        .await?
        .ok_or_else(|| AppError::NotFound("文章不存在".to_owned()))?;
    let is_admin = user.is_admin();
    let is_mine = row.author_id == Some(user.id);
    if row.status != KNOWLEDGE_STATUS_APPROVED && !is_mine && !is_admin {
        return Err(AppError::NotFound("文章不存在".to_owned()));
    }
    let is_plus = plus_service::is_plus(pool, user.id).await?;
    let locked = !(is_admin || is_plus || is_mine);
    Ok(KnowledgeArticleDetail {
        id: row.id,
        category: row.category,
        title: row.title,
        summary: row.summary,
        tags: row.tags,
        author: row.author,
        status: row.status.clone(),
        created_at: row.created_at,
        updated_at: row.updated_at,
        content: if locked { None } else { Some(row.content) },
        locked,
        is_mine,
        can_edit: is_mine && row.status != KNOWLEDGE_STATUS_APPROVED,
        review_note: row.review_note,
        reviewed_by: row.reviewed_by,
        reviewed_at: row.reviewed_at,
    })
}

pub async fn list(
    pool: &PgPool,
    user: &AuthUser,
    query: &KnowledgeListQuery,
) -> Result<KnowledgeListResponse, AppError> {
    let category = validate_category(query.category.as_deref())?;
    let tag = clean_filter(query.tag.as_deref());
    if tag.is_some_and(|value| value.chars().count() > MAX_TAG_CHARS) {
        return Err(AppError::BadRequest(format!(
            "标签不能超过 {MAX_TAG_CHARS} 字"
        )));
    }
    let pattern = clean_query(query.q.as_deref())?;
    let (page, size) = page_and_size(query.page, query.size, MAX_PAGE_SIZE);
    let offset = i64::from(page - 1) * i64::from(size);

    let total: i64 = sqlx::query_scalar(
        "SELECT COUNT(*)::bigint FROM knowledge_articles a \
         WHERE a.status = 'approved' \
           AND ($1::text IS NULL OR a.category = $1) \
           AND ($2::text IS NULL OR $2 = ANY(a.tags)) \
           AND ($3::text IS NULL OR a.title ILIKE $3 OR a.summary ILIKE $3)",
    )
    .bind(category)
    .bind(tag)
    .bind(pattern.as_deref())
    .fetch_one(pool)
    .await
    .map_err(AppError::Database)?;

    let rows: Vec<ArticleRow> = sqlx::query_as(&format!(
        "{ARTICLE_SELECT} \
         WHERE a.status = 'approved' \
           AND ($1::text IS NULL OR a.category = $1) \
           AND ($2::text IS NULL OR $2 = ANY(a.tags)) \
           AND ($3::text IS NULL OR a.title ILIKE $3 OR a.summary ILIKE $3) \
         ORDER BY a.created_at DESC, a.id DESC LIMIT $4 OFFSET $5"
    ))
    .bind(category)
    .bind(tag)
    .bind(pattern.as_deref())
    .bind(i64::from(size))
    .bind(offset)
    .fetch_all(pool)
    .await
    .map_err(AppError::Database)?;

    let is_plus = plus_service::is_plus(pool, user.id).await?;
    Ok(KnowledgeListResponse {
        total,
        page,
        size,
        items: rows.into_iter().map(|row| row.summary()).collect(),
        is_plus,
        can_submit: is_plus,
    })
}

pub async fn mine(
    pool: &PgPool,
    user: &AuthUser,
    query: &MyKnowledgeQuery,
) -> Result<KnowledgeListResponse, AppError> {
    let category = validate_category(query.category.as_deref())?;
    let status = validate_status(query.status.as_deref())?;
    let (page, size) = page_and_size(query.page, query.size, MAX_PAGE_SIZE);
    let offset = i64::from(page - 1) * i64::from(size);

    let total: i64 = sqlx::query_scalar(
        "SELECT COUNT(*)::bigint FROM knowledge_articles a \
         WHERE a.author_id = $1 \
           AND ($2::text IS NULL OR a.category = $2) \
           AND ($3::text IS NULL OR a.status = $3)",
    )
    .bind(user.id)
    .bind(category)
    .bind(status)
    .fetch_one(pool)
    .await
    .map_err(AppError::Database)?;

    let rows: Vec<ArticleRow> = sqlx::query_as(&format!(
        "{ARTICLE_SELECT} \
         WHERE a.author_id = $1 \
           AND ($2::text IS NULL OR a.category = $2) \
           AND ($3::text IS NULL OR a.status = $3) \
         ORDER BY a.created_at DESC, a.id DESC LIMIT $4 OFFSET $5"
    ))
    .bind(user.id)
    .bind(category)
    .bind(status)
    .bind(i64::from(size))
    .bind(offset)
    .fetch_all(pool)
    .await
    .map_err(AppError::Database)?;

    let is_plus = plus_service::is_plus(pool, user.id).await?;
    Ok(KnowledgeListResponse {
        total,
        page,
        size,
        items: rows.into_iter().map(|row| row.summary()).collect(),
        is_plus,
        can_submit: is_plus,
    })
}

pub async fn admin_list(
    pool: &PgPool,
    query: &AdminKnowledgeQuery,
) -> Result<KnowledgeListResponse, AppError> {
    let category = validate_category(query.category.as_deref())?;
    let status = validate_status(query.status.as_deref())?;
    let pattern = clean_query(query.q.as_deref())?;
    let (page, size) = page_and_size(query.page, query.size, MAX_ADMIN_PAGE_SIZE);
    let offset = i64::from(page - 1) * i64::from(size);

    let total: i64 = sqlx::query_scalar(
        "SELECT COUNT(*)::bigint FROM knowledge_articles a \
         WHERE ($1::text IS NULL OR a.category = $1) \
           AND ($2::text IS NULL OR a.status = $2) \
           AND ($3::text IS NULL OR a.title ILIKE $3 OR a.summary ILIKE $3)",
    )
    .bind(category)
    .bind(status)
    .bind(pattern.as_deref())
    .fetch_one(pool)
    .await
    .map_err(AppError::Database)?;

    let rows: Vec<ArticleRow> = sqlx::query_as(&format!(
        "{ARTICLE_SELECT} \
         WHERE ($1::text IS NULL OR a.category = $1) \
           AND ($2::text IS NULL OR a.status = $2) \
           AND ($3::text IS NULL OR a.title ILIKE $3 OR a.summary ILIKE $3) \
         ORDER BY CASE a.status WHEN 'pending' THEN 0 ELSE 1 END, \
                  a.created_at DESC, a.id DESC LIMIT $4 OFFSET $5"
    ))
    .bind(category)
    .bind(status)
    .bind(pattern.as_deref())
    .bind(i64::from(size))
    .bind(offset)
    .fetch_all(pool)
    .await
    .map_err(AppError::Database)?;

    Ok(KnowledgeListResponse {
        total,
        page,
        size,
        items: rows.into_iter().map(|row| row.summary()).collect(),
        is_plus: false,
        can_submit: false,
    })
}

pub async fn detail(
    pool: &PgPool,
    user: &AuthUser,
    article_id: i64,
) -> Result<KnowledgeArticleDetail, AppError> {
    detail_response(pool, user, article_id).await
}

pub async fn create(
    pool: &PgPool,
    user: &AuthUser,
    input: &KnowledgeArticleInput,
) -> Result<KnowledgeArticleDetail, AppError> {
    if !plus_service::is_plus(pool, user.id).await? {
        return Err(AppError::ForbiddenWith(
            "需要开通 Plus Theseus 才能投稿".to_owned(),
        ));
    }
    let category = input.category.trim();
    if !is_known_category(category) {
        return Err(AppError::BadRequest(
            "栏目只能是 408 或 interview".to_owned(),
        ));
    }
    let article = normalize_article(
        &input.title,
        input.summary.as_deref(),
        &input.content,
        &input.tags,
    )?;

    let article_id: i64 = sqlx::query_scalar(
        "INSERT INTO knowledge_articles \
         (author_id, category, title, summary, content, tags) \
         VALUES ($1, $2, $3, $4, $5, $6) RETURNING id",
    )
    .bind(user.id)
    .bind(category)
    .bind(&article.title)
    .bind(&article.summary)
    .bind(&article.content)
    .bind(&article.tags)
    .fetch_one(pool)
    .await
    .map_err(AppError::Database)?;

    detail_response(pool, user, article_id).await
}

pub async fn update(
    pool: &PgPool,
    user: &AuthUser,
    article_id: i64,
    input: &KnowledgeArticleUpdate,
) -> Result<KnowledgeArticleDetail, AppError> {
    let row = fetch_row(pool, article_id)
        .await?
        .ok_or_else(|| AppError::NotFound("文章不存在".to_owned()))?;
    if row.author_id != Some(user.id) {
        return Err(AppError::ForbiddenWith("只能编辑自己的投稿".to_owned()));
    }
    if row.status == KNOWLEDGE_STATUS_APPROVED {
        return Err(AppError::ConflictWith(
            "审核通过后不能直接编辑，请联系管理员退回".to_owned(),
        ));
    }
    let article = normalize_article(
        &input.title,
        input.summary.as_deref(),
        &input.content,
        &input.tags,
    )?;

    sqlx::query(
        "UPDATE knowledge_articles \
         SET title = $2, summary = $3, content = $4, tags = $5, \
             status = 'pending', review_note = NULL, reviewed_by = NULL, \
             reviewed_at = NULL, updated_at = CURRENT_TIMESTAMP \
         WHERE id = $1",
    )
    .bind(article_id)
    .bind(&article.title)
    .bind(&article.summary)
    .bind(&article.content)
    .bind(&article.tags)
    .execute(pool)
    .await
    .map_err(AppError::Database)?;

    detail_response(pool, user, article_id).await
}

pub async fn delete(
    pool: &PgPool,
    user: &AuthUser,
    article_id: i64,
) -> Result<KnowledgeMutationResponse, AppError> {
    let row = fetch_row(pool, article_id)
        .await?
        .ok_or_else(|| AppError::NotFound("文章不存在".to_owned()))?;
    let is_admin = user.is_admin();
    if row.author_id != Some(user.id) && !is_admin {
        return Err(AppError::ForbiddenWith("只能删除自己的投稿".to_owned()));
    }
    if row.status == KNOWLEDGE_STATUS_APPROVED && !is_admin {
        return Err(AppError::ConflictWith(
            "审核通过后不能直接删除，请联系管理员下架".to_owned(),
        ));
    }
    sqlx::query("DELETE FROM knowledge_articles WHERE id = $1")
        .bind(article_id)
        .execute(pool)
        .await
        .map_err(AppError::Database)?;
    Ok(KnowledgeMutationResponse {
        message: "已删除投稿".to_owned(),
    })
}

pub async fn admin_resolve(
    pool: &PgPool,
    admin: &AuthUser,
    article_id: i64,
    input: &KnowledgeResolveInput,
) -> Result<KnowledgeResolveResponse, AppError> {
    let status = input.status.trim();
    if ![KNOWLEDGE_STATUS_APPROVED, KNOWLEDGE_STATUS_REJECTED].contains(&status) {
        return Err(AppError::BadRequest(
            "处理结果只能是 approved 或 rejected".to_owned(),
        ));
    }
    let note = input
        .note
        .as_deref()
        .map(str::trim)
        .filter(|value| !value.is_empty());
    if note.is_some_and(|value| value.chars().count() > MAX_NOTE_CHARS) {
        return Err(AppError::BadRequest(format!(
            "处理说明不能超过 {MAX_NOTE_CHARS} 字"
        )));
    }

    let mut transaction: Transaction<'_, Postgres> =
        pool.begin().await.map_err(AppError::Database)?;
    let current: Option<(Option<i32>, String, String, String)> = sqlx::query_as(
        "SELECT author_id, title, category, status FROM knowledge_articles \
         WHERE id = $1 FOR UPDATE",
    )
    .bind(article_id)
    .fetch_optional(&mut *transaction)
    .await
    .map_err(AppError::Database)?;
    let Some((author_id, title, category, _current_status)) = current else {
        return Err(AppError::NotFound("文章不存在".to_owned()));
    };

    sqlx::query(
        "UPDATE knowledge_articles \
         SET status = $2, review_note = $3, reviewed_by = $4, \
             reviewed_at = CURRENT_TIMESTAMP, updated_at = CURRENT_TIMESTAMP \
         WHERE id = $1",
    )
    .bind(article_id)
    .bind(status)
    .bind(note)
    .bind(admin.id)
    .execute(&mut *transaction)
    .await
    .map_err(AppError::Database)?;

    if let Some(author_id) = author_id {
        let approved = status == KNOWLEDGE_STATUS_APPROVED;
        let body = if approved {
            format!("你的{}投稿《{title}》已通过审核", category_label(&category))
        } else {
            format!("你的{}投稿《{title}》未通过审核", category_label(&category))
        };
        notification_service::create(
            &mut transaction,
            author_id,
            "knowledge_review",
            Some(admin.id),
            "投稿审核结果",
            Some(&body),
            Some(&format!("/knowledge/{article_id}")),
            Some("knowledge_article"),
            Some(article_id),
        )
        .await?;
    }

    transaction.commit().await.map_err(AppError::Database)?;

    Ok(KnowledgeResolveResponse {
        status: status.to_owned(),
        message: if status == KNOWLEDGE_STATUS_APPROVED {
            "已通过投稿".to_owned()
        } else {
            "已退回投稿".to_owned()
        },
    })
}
