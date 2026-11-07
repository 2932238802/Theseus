use sqlx::PgPool;

use crate::{
    common::error::AppError,
    models::draft::{DraftResponse, DraftView, SaveDraftRequest},
    services::solution_service,
};

/// 兼容旧接口：按语言读取最近一次有内容的解法。
pub async fn get_draft(
    pool: &PgPool,
    user_id: i32,
    problem_id: i32,
    language: &str,
) -> Result<DraftResponse, AppError> {
    let solution =
        solution_service::get_draft_solution(pool, user_id, problem_id, language).await?;
    Ok(DraftResponse {
        draft: solution.map(|solution| DraftView {
            language: solution.language,
            code: solution.code,
            updated_at: solution.updated_at,
        }),
    })
}

/// 兼容旧接口：写回该语言最近使用的解法，没有则新建。
pub async fn save_draft(
    pool: &PgPool,
    user_id: i32,
    problem_id: i32,
    request: SaveDraftRequest,
) -> Result<DraftResponse, AppError> {
    let solution = solution_service::save_legacy_draft(
        pool,
        user_id,
        problem_id,
        &request.language,
        &request.code,
    )
    .await?;
    Ok(DraftResponse {
        draft: solution.map(|solution| DraftView {
            language: solution.language,
            code: solution.code,
            updated_at: solution.updated_at,
        }),
    })
}
