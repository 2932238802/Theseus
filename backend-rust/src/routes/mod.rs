use axum::{
    Router,
    routing::{get, post},
};
use tower_http::{cors::CorsLayer, trace::TraceLayer};

use crate::{
    AppState,
    handlers::{auth_handler, problem_handler, submission_handler},
};

pub fn router(state: AppState) -> Router {
    Router::new()
        .route("/api/auth/register", post(auth_handler::register))
        .route("/api/auth/login", post(auth_handler::login))
        .route("/api/problems", get(problem_handler::list))
        .route("/api/problems/{id}", get(problem_handler::get))
        .route("/api/problems/custom", post(problem_handler::submit_custom))
        .route("/api/admin/problems", post(problem_handler::create))
        .route("/api/admin/problems/pending", get(problem_handler::pending))
        .route(
            "/api/admin/problems/{id}/review",
            axum::routing::put(problem_handler::review),
        )
        .route(
            "/api/admin/problems/{id}",
            axum::routing::put(problem_handler::update).delete(problem_handler::delete),
        )
        .route(
            "/api/submissions",
            get(submission_handler::list).post(submission_handler::create),
        )
        .route("/api/submissions/{id}", get(submission_handler::get))
        .with_state(state)
        .layer(CorsLayer::permissive())
        .layer(TraceLayer::new_for_http())
}
