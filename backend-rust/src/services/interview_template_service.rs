//! HR 面模板 Wiki 的读写。
//!
//! 读者端权限与面经板块一致：Plus 会员或管理员；管理端写操作只允许管理员。
//! 新模板默认追加到末尾，排序由管理员通过整体重排接口写入。

use std::collections::HashSet;

use sqlx::PgPool;

use crate::{
    common::error::AppError,
    config::Config,
    middleware::auth::AuthUser,
    models::interview_template::{
        InterviewTemplateDetail, InterviewTemplateInput, InterviewTemplateMutationResponse,
        InterviewTemplateOrderInput, InterviewTemplateOrderResponse, InterviewTemplateSummary,
        MAX_TEMPLATE_CONTENT_CHARS, MAX_TEMPLATE_TITLE_CHARS,
    },
    services::{forum_service, plus_service},
};

const DETAIL_SELECT: &str =
    "SELECT id, title, content_md, sort_order, created_at, updated_at FROM interview_templates";

fn normalize_input(input: &InterviewTemplateInput) -> Result<(String, String), AppError> {
    let title = input.title.trim();
    if title.is_empty() {
        return Err(AppError::BadRequest("标题不能为空".to_owned()));
    }
    if title.chars().count() > MAX_TEMPLATE_TITLE_CHARS {
        return Err(AppError::BadRequest(format!(
            "标题不能超过 {MAX_TEMPLATE_TITLE_CHARS} 个字符"
        )));
    }
    let content = input.content_md.trim();
    if content.is_empty() {
        return Err(AppError::BadRequest("正文不能为空".to_owned()));
    }
    if content.chars().count() > MAX_TEMPLATE_CONTENT_CHARS {
        return Err(AppError::BadRequest(format!(
            "正文不能超过 {MAX_TEMPLATE_CONTENT_CHARS} 个字符"
        )));
    }
    Ok((title.to_owned(), content.to_owned()))
}

async fn ensure_reader_access(pool: &PgPool, viewer: Option<&AuthUser>) -> Result<(), AppError> {
    let Some(user) = viewer else {
        return Err(AppError::Unauthorized);
    };
    if user.is_admin() {
        return Ok(());
    }
    if plus_service::is_plus(pool, user.id).await? {
        Ok(())
    } else {
        Err(AppError::ForbiddenWith(
            "需要开通 Plus Theseus 才能查看面经".to_owned(),
        ))
    }
}

fn not_found() -> AppError {
    AppError::NotFound("模板不存在或已被删除".to_owned())
}

pub async fn list_reader(
    pool: &PgPool,
    config: &Config,
    viewer: Option<&AuthUser>,
) -> Result<Vec<InterviewTemplateSummary>, AppError> {
    forum_service::ensure_enabled(config)?;
    ensure_reader_access(pool, viewer).await?;
    let rows: Vec<InterviewTemplateSummary> = sqlx::query_as(
        "SELECT id, title, sort_order, updated_at FROM interview_templates \
         ORDER BY sort_order ASC, id ASC",
    )
    .fetch_all(pool)
    .await
    .map_err(AppError::Database)?;
    Ok(rows)
}

pub async fn get_reader(
    pool: &PgPool,
    config: &Config,
    viewer: Option<&AuthUser>,
    template_id: i64,
) -> Result<InterviewTemplateDetail, AppError> {
    forum_service::ensure_enabled(config)?;
    ensure_reader_access(pool, viewer).await?;
    if template_id <= 0 {
        return Err(not_found());
    }
    let row: Option<InterviewTemplateDetail> =
        sqlx::query_as(&format!("{DETAIL_SELECT} WHERE id = $1"))
            .bind(template_id)
            .fetch_optional(pool)
            .await
            .map_err(AppError::Database)?;
    row.ok_or_else(not_found)
}

pub async fn list_admin(pool: &PgPool) -> Result<Vec<InterviewTemplateDetail>, AppError> {
    let rows: Vec<InterviewTemplateDetail> =
        sqlx::query_as(&format!("{DETAIL_SELECT} ORDER BY sort_order ASC, id ASC"))
            .fetch_all(pool)
            .await
            .map_err(AppError::Database)?;
    Ok(rows)
}

pub async fn create(
    pool: &PgPool,
    admin: &AuthUser,
    input: &InterviewTemplateInput,
) -> Result<InterviewTemplateDetail, AppError> {
    let (title, content) = normalize_input(input)?;
    let row: InterviewTemplateDetail = sqlx::query_as(
        "INSERT INTO interview_templates \
         (title, content_md, sort_order, created_by, updated_by) \
         VALUES ($1, $2, \
                 (SELECT COALESCE(MAX(sort_order), -1) + 1 FROM interview_templates), \
                 $3, $3) \
         RETURNING id, title, content_md, sort_order, created_at, updated_at",
    )
    .bind(&title)
    .bind(&content)
    .bind(admin.id)
    .fetch_one(pool)
    .await
    .map_err(AppError::Database)?;
    Ok(row)
}

pub async fn update(
    pool: &PgPool,
    admin: &AuthUser,
    template_id: i64,
    input: &InterviewTemplateInput,
) -> Result<InterviewTemplateDetail, AppError> {
    if template_id <= 0 {
        return Err(not_found());
    }
    let (title, content) = normalize_input(input)?;
    let row: Option<InterviewTemplateDetail> = sqlx::query_as(
        "UPDATE interview_templates \
         SET title = $2, content_md = $3, updated_by = $4, \
             updated_at = CURRENT_TIMESTAMP \
         WHERE id = $1 \
         RETURNING id, title, content_md, sort_order, created_at, updated_at",
    )
    .bind(template_id)
    .bind(&title)
    .bind(&content)
    .bind(admin.id)
    .fetch_optional(pool)
    .await
    .map_err(AppError::Database)?;
    row.ok_or_else(not_found)
}

/// 物理删除；返回被删除的标题，供审计摘要使用。
pub async fn delete(
    pool: &PgPool,
    template_id: i64,
) -> Result<(InterviewTemplateMutationResponse, String), AppError> {
    if template_id <= 0 {
        return Err(not_found());
    }
    let title: Option<String> =
        sqlx::query_scalar("DELETE FROM interview_templates WHERE id = $1 RETURNING title")
            .bind(template_id)
            .fetch_optional(pool)
            .await
            .map_err(AppError::Database)?;
    let title = title.ok_or_else(not_found)?;
    Ok((
        InterviewTemplateMutationResponse {
            id: template_id,
            message: "模板已删除".to_owned(),
        },
        title,
    ))
}

/// 整体重排：`ids` 必须恰好覆盖全部模板，按数组下标写 `sort_order`。
pub async fn reorder(
    pool: &PgPool,
    input: &InterviewTemplateOrderInput,
) -> Result<InterviewTemplateOrderResponse, AppError> {
    let mut seen = HashSet::with_capacity(input.ids.len());
    for id in &input.ids {
        if *id <= 0 || !seen.insert(*id) {
            return Err(AppError::BadRequest(
                "排序列表包含无效或重复的模板".to_owned(),
            ));
        }
    }

    let mut tx = pool.begin().await.map_err(AppError::Database)?;
    let current: Vec<i64> =
        sqlx::query_scalar("SELECT id FROM interview_templates ORDER BY id FOR UPDATE")
            .fetch_all(&mut *tx)
            .await
            .map_err(AppError::Database)?;
    let current_set: HashSet<i64> = current.into_iter().collect();
    if current_set.len() != input.ids.len() || input.ids.iter().any(|id| !current_set.contains(id))
    {
        return Err(AppError::BadRequest("排序列表必须覆盖全部模板".to_owned()));
    }

    for (index, id) in input.ids.iter().enumerate() {
        let sort_order = i32::try_from(index)
            .map_err(|_| AppError::BadRequest("模板数量超出排序上限".to_owned()))?;
        sqlx::query("UPDATE interview_templates SET sort_order = $2 WHERE id = $1")
            .bind(id)
            .bind(sort_order)
            .execute(&mut *tx)
            .await
            .map_err(AppError::Database)?;
    }
    tx.commit().await.map_err(AppError::Database)?;
    Ok(InterviewTemplateOrderResponse {
        message: "模板顺序已更新".to_owned(),
    })
}

#[cfg(test)]
mod tests {
    use super::normalize_input;
    use crate::models::interview_template::{
        InterviewTemplateInput, MAX_TEMPLATE_CONTENT_CHARS, MAX_TEMPLATE_TITLE_CHARS,
    };

    fn input(title: &str, content: &str) -> InterviewTemplateInput {
        InterviewTemplateInput {
            title: title.to_owned(),
            content_md: content.to_owned(),
        }
    }

    #[test]
    fn trims_valid_template_input() {
        let (title, content) = normalize_input(&input("  STAR 模板 ", " 正文 ")).unwrap();
        assert_eq!(title, "STAR 模板");
        assert_eq!(content, "正文");
    }

    #[test]
    fn rejects_empty_template_fields() {
        assert!(normalize_input(&input("   ", "正文")).is_err());
        assert!(normalize_input(&input("标题", "  \n ")).is_err());
    }

    #[test]
    fn enforces_template_lengths() {
        let long_title = "字".repeat(MAX_TEMPLATE_TITLE_CHARS);
        assert!(normalize_input(&input(&long_title, "正文")).is_ok());
        assert!(normalize_input(&input(&format!("{long_title}字"), "正文")).is_err());

        let long_content = "字".repeat(MAX_TEMPLATE_CONTENT_CHARS);
        assert!(normalize_input(&input("标题", &long_content)).is_ok());
        assert!(normalize_input(&input("标题", &format!("{long_content}字"))).is_err());
    }
}
