use axum::{
    extract::{Query, State},
    http::HeaderMap,
    response::IntoResponse,
};

use crate::{
    AppState,
    common::{error::AppError, response::ok},
    middleware::auth::optional_authenticate,
    models::ranking::RankingQuery,
    services::ranking_service,
};

pub async fn list(
    State(state): State<AppState>,
    headers: HeaderMap,
    Query(query): Query<RankingQuery>,
) -> Result<impl IntoResponse, AppError> {
    let me_id = optional_authenticate(&state.pool, &headers, &state.config)
        .await
        .filter(|user| user.is_student())
        .map(|user| user.id);
    let data = ranking_service::list(&state.pool, &query, me_id).await?;
    Ok(ok(data))
}
