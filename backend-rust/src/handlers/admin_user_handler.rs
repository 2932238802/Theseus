use axum::{
    Json,
    extract::{Path, Query, State},
    http::HeaderMap,
    response::IntoResponse,
};

use crate::{
    AppState,
    common::{error::AppError, response::ok},
    middleware::auth::require_admin,
    models::teaching::{AdminUserListQuery, ChangeRoleRequest},
    services::admin_user_service,
};

pub async fn list(
    State(state): State<AppState>,
    headers: HeaderMap,
    Query(query): Query<AdminUserListQuery>,
) -> Result<impl IntoResponse, AppError> {
    require_admin(&state.pool, &headers, &state.config).await?;
    let data = admin_user_service::list_users(&state.pool, &query).await?;
    Ok(ok(data))
}

pub async fn change_role(
    State(state): State<AppState>,
    headers: HeaderMap,
    Path(id): Path<i32>,
    Json(request): Json<ChangeRoleRequest>,
) -> Result<impl IntoResponse, AppError> {
    let admin = require_admin(&state.pool, &headers, &state.config).await?;
    let data = admin_user_service::change_role(&state.pool, admin.id, id, &request).await?;
    Ok(ok(data))
}
