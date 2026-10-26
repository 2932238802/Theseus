use axum::{
    Router,
    routing::{delete, get, post, put},
};
use tower_http::{cors::CorsLayer, trace::TraceLayer};

use crate::{
    AppState,
    handlers::{
        admin_forum_handler, admin_user_handler, assignment_handler, auth_handler, class_handler,
        forum_handler, notification_handler, problem_handler, ranking_handler, run_handler,
        submission_handler,
    },
};

pub fn router(state: AppState) -> Router {
    Router::new()
        .route("/api/auth/register", post(auth_handler::register))
        .route("/api/auth/login", post(auth_handler::login))
        .route("/api/auth/me", get(auth_handler::me))
        .route("/api/auth/verify-email", post(auth_handler::verify_email))
        .route(
            "/api/auth/verify-email/resend",
            post(auth_handler::resend_verification),
        )
        .route(
            "/api/auth/forgot-password",
            post(auth_handler::forgot_password),
        )
        .route(
            "/api/auth/reset-password",
            post(auth_handler::reset_password),
        )
        .route("/api/admin/users", get(admin_user_handler::list))
        .route(
            "/api/admin/users/{id}/role",
            put(admin_user_handler::change_role),
        )
        .route(
            "/api/classes",
            get(class_handler::list).post(class_handler::create),
        )
        .route("/api/classes/join", post(class_handler::join))
        .route(
            "/api/classes/{id}",
            get(class_handler::get).put(class_handler::update),
        )
        .route("/api/classes/{id}/members", post(class_handler::add_member))
        .route("/api/classes/{id}/members/me", delete(class_handler::leave))
        .route(
            "/api/classes/{id}/members/{user_id}",
            delete(class_handler::remove_member),
        )
        .route(
            "/api/classes/{id}/invite-code/rotate",
            post(class_handler::rotate_invite_code),
        )
        .route("/api/classes/{id}/archive", post(class_handler::archive))
        .route(
            "/api/classes/{id}/assignments",
            get(assignment_handler::list).post(assignment_handler::create),
        )
        .route(
            "/api/assignments/{id}",
            get(assignment_handler::get)
                .put(assignment_handler::update)
                .delete(assignment_handler::delete),
        )
        .route(
            "/api/assignments/{id}/problems",
            put(assignment_handler::update_problems),
        )
        .route(
            "/api/assignments/{id}/publish",
            post(assignment_handler::publish),
        )
        .route(
            "/api/assignments/{id}/archive",
            post(assignment_handler::archive),
        )
        .route(
            "/api/assignments/{id}/submissions",
            get(assignment_handler::submissions),
        )
        .route(
            "/api/assignments/{id}/gradebook",
            get(assignment_handler::gradebook),
        )
        .route(
            "/api/assignments/{id}/grades/publish",
            post(assignment_handler::publish_grades),
        )
        .route(
            "/api/assignments/{id}/grades/{user_id}",
            put(assignment_handler::update_overall_grade),
        )
        .route(
            "/api/assignments/{id}/grades/{user_id}/problems/{problem_id}",
            put(assignment_handler::update_problem_grade),
        )
        .route(
            "/api/runs",
            post(run_handler::create).get(run_handler::list),
        )
        .route("/api/runs/{id}/status", get(run_handler::status))
        .route(
            "/api/runs/{id}",
            get(run_handler::detail).delete(run_handler::remove),
        )
        .route("/api/problems", get(problem_handler::list))
        .route("/api/problems/tags", get(problem_handler::tags))
        .route("/api/problems/{id}", get(problem_handler::get))
        .route("/api/stats", get(problem_handler::stats))
        .route("/api/rankings", get(ranking_handler::list))
        .route("/api/problems/custom", post(problem_handler::submit_custom))
        .route("/api/problems/mine", get(problem_handler::mine))
        .route(
            "/api/problems/mine/{id}",
            get(problem_handler::mine_get).put(problem_handler::update_mine),
        )
        .route(
            "/api/admin/problems",
            get(problem_handler::admin_list).post(problem_handler::create),
        )
        .route("/api/admin/problems/pending", get(problem_handler::pending))
        .route(
            "/api/admin/problems/{id}/review",
            axum::routing::put(problem_handler::review),
        )
        .route(
            "/api/admin/problems/{id}",
            axum::routing::put(problem_handler::update)
                .delete(problem_handler::delete)
                .get(problem_handler::admin_get),
        )
        .route(
            "/api/submissions",
            get(submission_handler::list).post(submission_handler::create),
        )
        .route(
            "/api/submissions/{id}/status",
            get(submission_handler::status),
        )
        .route("/api/submissions/{id}", get(submission_handler::get))
        .route(
            "/api/forum/posts",
            get(forum_handler::list_posts).post(forum_handler::create_post),
        )
        .route(
            "/api/forum/posts/{id}",
            get(forum_handler::get_post)
                .put(forum_handler::update_post)
                .delete(forum_handler::delete_post),
        )
        .route(
            "/api/forum/posts/{id}/like",
            post(forum_handler::like_post).delete(forum_handler::unlike_post),
        )
        .route(
            "/api/forum/posts/{id}/favorite",
            post(forum_handler::favorite_post).delete(forum_handler::unfavorite_post),
        )
        .route(
            "/api/forum/posts/{id}/comments",
            get(forum_handler::list_comments).post(forum_handler::create_comment),
        )
        .route(
            "/api/forum/comments/{id}/replies",
            get(forum_handler::list_replies),
        )
        .route(
            "/api/forum/comments/{id}",
            put(forum_handler::update_comment).delete(forum_handler::delete_comment),
        )
        .route("/api/forum/reports", post(forum_handler::create_report))
        .route("/api/notifications", get(notification_handler::list))
        .route(
            "/api/notifications/unread-count",
            get(notification_handler::unread_count),
        )
        .route(
            "/api/notifications/read-all",
            put(notification_handler::mark_all_read),
        )
        .route(
            "/api/notifications/{id}/read",
            put(notification_handler::mark_read),
        )
        .route(
            "/api/admin/forum/posts",
            get(admin_forum_handler::list_posts),
        )
        .route(
            "/api/admin/forum/posts/{id}",
            get(admin_forum_handler::get_post),
        )
        .route(
            "/api/admin/forum/posts/{id}/status",
            put(admin_forum_handler::change_post_status),
        )
        .route(
            "/api/admin/forum/comments/{id}/status",
            put(admin_forum_handler::change_comment_status),
        )
        .route(
            "/api/admin/forum/posts/{id}/pin",
            put(admin_forum_handler::pin_post),
        )
        .route(
            "/api/admin/forum/reports",
            get(admin_forum_handler::list_reports),
        )
        .route(
            "/api/admin/forum/reports/{id}",
            put(admin_forum_handler::decide_report),
        )
        .route(
            "/api/admin/forum/users/{id}/mute",
            post(admin_forum_handler::mute_user).delete(admin_forum_handler::unmute_user),
        )
        .route(
            "/api/admin/forum/actions",
            get(admin_forum_handler::list_actions),
        )
        .with_state(state)
        .layer(CorsLayer::permissive())
        .layer(TraceLayer::new_for_http())
}
