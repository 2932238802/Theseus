use chrono::{DateTime, Utc};
use serde::{Deserialize, Serialize};
use sqlx::FromRow;

pub const FORUM_TAGS: [&str; 5] = ["general", "help", "solution", "discussion", "announcement"];
pub const FORUM_BOARDS: [&str; 2] = ["general", "interview"];
pub const BOARD_GENERAL: &str = "general";
pub const BOARD_INTERVIEW: &str = "interview";
pub const REPORT_REASONS: [&str; 5] = ["spam", "abuse", "spoiler", "illegal", "other"];
pub const MAX_TITLE_CHARS: usize = 120;
pub const MAX_POST_BODY_CHARS: usize = 20_000;
pub const MAX_INTERVIEW_TAGS: usize = 8;
pub const MAX_INTERVIEW_TAG_CHARS: usize = 20;
pub const MAX_INTERVIEW_DATE_CHARS: usize = 7;
pub const MAX_INTERVIEW_META_CHARS: usize = 40;
pub const MAX_COMMENT_BODY_CHARS: usize = 5_000;
pub const MAX_REPORT_DETAIL_CHARS: usize = 500;
pub const MAX_REASON_CHARS: usize = 500;
pub const MAX_SEARCH_CHARS: usize = 100;
pub const MAX_EMBEDDED_REPLIES: i64 = 50;

pub fn is_known_tag(value: &str) -> bool {
    FORUM_TAGS.contains(&value)
}

pub fn is_known_board(value: &str) -> bool {
    FORUM_BOARDS.contains(&value)
}

pub fn is_known_report_reason(value: &str) -> bool {
    REPORT_REASONS.contains(&value)
}

#[derive(Debug, Clone, Serialize)]
pub struct PublicAuthor {
    pub display_name: String,
    pub is_anonymous: bool,
    pub is_self: bool,
    pub is_plus: bool,
}

impl PublicAuthor {
    /// The only public constructor for content authors. Anonymous content must
    /// never leak the real user id or username through this type.
    pub fn new(
        author_id: i32,
        username: &str,
        is_anonymous: bool,
        is_plus: bool,
        viewer_id: Option<i32>,
    ) -> Self {
        Self {
            display_name: if is_anonymous {
                "匿名同学".to_owned()
            } else {
                username.to_owned()
            },
            is_anonymous,
            is_self: viewer_id == Some(author_id),
            is_plus: !is_anonymous && is_plus,
        }
    }

    pub fn hidden() -> Self {
        Self {
            display_name: "已隐藏".to_owned(),
            is_anonymous: false,
            is_self: false,
            is_plus: false,
        }
    }
}

#[derive(Debug, Clone, Serialize)]
pub struct AdminAuthor {
    pub id: i32,
    pub username: String,
    pub email: String,
    pub role: String,
}

impl AdminAuthor {
    pub fn new(id: i32, username: String, email: String, role: String) -> Self {
        Self {
            id,
            username,
            email,
            role,
        }
    }
}

#[derive(Debug, Clone, Serialize)]
pub struct Reporter {
    pub id: i32,
    pub username: String,
}

#[derive(Debug, Clone, Serialize)]
pub struct ProblemBrief {
    pub id: i32,
    pub title: String,
    pub difficulty: String,
}

#[derive(Debug, Clone, Serialize)]
pub struct ReplyTo {
    pub comment_id: i64,
    pub display_name: String,
}

#[derive(Debug, Deserialize)]
pub struct ForumPostListQuery {
    pub page: Option<u32>,
    pub size: Option<u32>,
    pub board: Option<String>,
    pub tag: Option<String>,
    pub company: Option<String>,
    pub role: Option<String>,
    pub problem_id: Option<i32>,
    pub q: Option<String>,
    pub sort: Option<String>,
    pub mine: Option<bool>,
}

#[derive(Debug, Deserialize)]
pub struct ForumCommentListQuery {
    pub page: Option<u32>,
    pub size: Option<u32>,
    pub sort: Option<String>,
}

#[derive(Debug, Deserialize)]
pub struct ForumReplyListQuery {
    pub page: Option<u32>,
    pub size: Option<u32>,
}

#[derive(Debug, Deserialize)]
pub struct CreatePostRequest {
    pub title: String,
    pub body_md: String,
    #[serde(default)]
    pub tags: Vec<String>,
    #[serde(default)]
    pub board: Option<String>,
    #[serde(default)]
    pub interview_date: Option<String>,
    #[serde(default)]
    pub company: Option<String>,
    #[serde(default)]
    pub role: Option<String>,
    pub problem_id: Option<i32>,
    #[serde(default)]
    pub is_anonymous: bool,
}

#[derive(Debug, Deserialize)]
pub struct UpdatePostRequest {
    pub title: String,
    pub body_md: String,
    #[serde(default)]
    pub tags: Vec<String>,
    #[serde(default)]
    pub interview_date: Option<String>,
    #[serde(default)]
    pub company: Option<String>,
    #[serde(default)]
    pub role: Option<String>,
    pub problem_id: Option<i32>,
}

#[derive(Debug, Deserialize)]
pub struct CreateCommentRequest {
    pub body_md: String,
    pub parent_id: Option<i64>,
    pub reply_to_comment_id: Option<i64>,
    #[serde(default)]
    pub is_anonymous: bool,
}

#[derive(Debug, Deserialize)]
pub struct UpdateCommentRequest {
    pub body_md: String,
}

#[derive(Debug, Deserialize)]
pub struct CreateReportRequest {
    pub target_type: String,
    pub target_id: i64,
    pub reason: String,
    pub detail: Option<String>,
}

#[derive(Debug, Clone, Serialize)]
pub struct ForumPostSummary {
    pub id: i64,
    pub board: String,
    pub title: String,
    pub excerpt: String,
    pub interview_date: Option<String>,
    pub company: Option<String>,
    pub role: Option<String>,
    pub view_count: i32,
    pub accepted_comment_id: Option<i64>,
    pub tags: Vec<String>,
    pub author: PublicAuthor,
    pub problem: Option<ProblemBrief>,
    pub is_anonymous: bool,
    pub status: String,
    pub is_pinned: bool,
    pub like_count: i32,
    pub favorite_count: i32,
    pub comment_count: i32,
    pub liked: bool,
    pub favorited: bool,
    pub created_at: DateTime<Utc>,
    pub updated_at: DateTime<Utc>,
    pub edited_at: Option<DateTime<Utc>>,
}

#[derive(Debug, Serialize)]
pub struct ForumPostDetail {
    #[serde(flatten)]
    pub summary: ForumPostSummary,
    pub body_md: String,
    pub can_edit: bool,
    pub can_delete: bool,
    pub can_moderate: bool,
    pub hidden_reason: Option<String>,
}

#[derive(Debug, Serialize)]
pub struct ForumPostListResponse {
    pub total: i64,
    pub page: u32,
    pub size: u32,
    pub posts: Vec<ForumPostSummary>,
}

#[derive(Debug, Serialize)]
pub struct ForumInterviewFacets {
    pub companies: Vec<String>,
    pub roles: Vec<String>,
}

#[derive(Debug, Serialize)]
pub struct ForumCommentView {
    pub id: i64,
    pub post_id: i64,
    pub parent_id: Option<i64>,
    pub reply_to: Option<ReplyTo>,
    pub body_md: String,
    pub author: PublicAuthor,
    pub is_tombstone: bool,
    pub created_at: DateTime<Utc>,
    pub edited_at: Option<DateTime<Utc>>,
    pub can_edit: bool,
    pub can_delete: bool,
    pub favorited: bool,
    pub is_accepted: bool,
    pub reply_total: i64,
    pub replies_truncated: bool,
    pub replies: Vec<ForumReplyView>,
}

#[derive(Debug, Serialize)]
pub struct ForumReplyView {
    pub id: i64,
    pub post_id: i64,
    pub parent_id: Option<i64>,
    pub reply_to: Option<ReplyTo>,
    pub body_md: String,
    pub author: PublicAuthor,
    pub is_tombstone: bool,
    pub created_at: DateTime<Utc>,
    pub edited_at: Option<DateTime<Utc>>,
    pub can_edit: bool,
    pub can_delete: bool,
    pub favorited: bool,
    pub is_accepted: bool,
}

#[derive(Debug, Serialize)]
pub struct ForumCommentsResponse {
    pub total: i64,
    pub page: u32,
    pub size: u32,
    pub comments: Vec<ForumCommentView>,
}

#[derive(Debug, Serialize)]
pub struct ForumRepliesResponse {
    pub total: i64,
    pub page: u32,
    pub size: u32,
    pub replies: Vec<ForumReplyView>,
}

#[derive(Debug, Serialize)]
pub struct ForumCommentCreated {
    pub id: i64,
    pub post_id: i64,
    pub parent_id: Option<i64>,
    pub reply_to: Option<ReplyTo>,
    pub body_md: String,
    pub author: PublicAuthor,
    pub created_at: DateTime<Utc>,
}

#[derive(Debug, Serialize)]
pub struct ForumPostCreated {
    pub id: i64,
    pub status: String,
}

#[derive(Debug, Serialize)]
pub struct ForumMutationResponse {
    pub id: i64,
    pub message: String,
}

#[derive(Debug, Serialize)]
pub struct LikeResponse {
    pub liked: bool,
    pub like_count: i32,
}

#[derive(Debug, Serialize)]
pub struct FavoriteResponse {
    pub favorited: bool,
    pub favorite_count: i32,
}

#[derive(Debug, Serialize)]
pub struct ForumReportResponse {
    pub report_id: i64,
    pub hidden: bool,
    pub message: String,
}

#[derive(Debug, Serialize)]
pub struct PinResponse {
    pub id: i64,
    pub is_pinned: bool,
    pub message: String,
}

#[derive(Debug, Deserialize)]
pub struct AcceptCommentRequest {
    pub comment_id: i64,
}

#[derive(Debug, Serialize)]
pub struct AcceptedCommentResponse {
    pub accepted_comment_id: Option<i64>,
    pub message: String,
}

#[derive(Debug, Deserialize)]
pub struct AdminForumPostListQuery {
    pub page: Option<u32>,
    pub size: Option<u32>,
    pub status: Option<String>,
    pub board: Option<String>,
    pub q: Option<String>,
    pub author: Option<String>,
}

#[derive(Debug, Deserialize)]
pub struct AdminStatusRequest {
    pub status: String,
    pub reason: Option<String>,
}

#[derive(Debug, Deserialize)]
pub struct AdminPinRequest {
    pub is_pinned: bool,
}

#[derive(Debug, Deserialize)]
pub struct AdminReportListQuery {
    pub page: Option<u32>,
    pub size: Option<u32>,
    pub status: Option<String>,
}

#[derive(Debug, Deserialize)]
pub struct AdminReportDecisionRequest {
    pub decision: String,
    pub note: Option<String>,
}

#[derive(Debug, Deserialize)]
pub struct AdminMuteRequest {
    pub duration_hours: Option<i64>,
    pub reason: String,
}

#[derive(Debug, Deserialize)]
pub struct AdminActionListQuery {
    pub page: Option<u32>,
    pub size: Option<u32>,
    pub target_type: Option<String>,
    pub target_id: Option<i64>,
}

#[derive(Debug, Clone, Serialize)]
pub struct AdminForumPostSummary {
    pub id: i64,
    pub board: String,
    pub title: String,
    pub excerpt: String,
    pub interview_date: Option<String>,
    pub company: Option<String>,
    pub role: Option<String>,
    pub view_count: i32,
    pub accepted_comment_id: Option<i64>,
    pub tags: Vec<String>,
    pub author: AdminAuthor,
    pub is_anonymous: bool,
    pub status: String,
    pub hidden_reason: Option<String>,
    pub is_pinned: bool,
    pub like_count: i32,
    pub favorite_count: i32,
    pub comment_count: i32,
    pub pending_report_count: i32,
    pub problem: Option<ProblemBrief>,
    pub created_at: DateTime<Utc>,
    pub updated_at: DateTime<Utc>,
    pub edited_at: Option<DateTime<Utc>>,
    pub hidden_at: Option<DateTime<Utc>>,
}

#[derive(Debug, Serialize)]
pub struct AdminForumPostListResponse {
    pub total: i64,
    pub page: u32,
    pub size: u32,
    pub posts: Vec<AdminForumPostSummary>,
}

#[derive(Debug, Serialize)]
pub struct AdminForumComment {
    pub id: i64,
    pub post_id: i64,
    pub parent_id: Option<i64>,
    pub reply_to_comment_id: Option<i64>,
    pub body_md: String,
    pub author: AdminAuthor,
    pub is_anonymous: bool,
    pub status: String,
    pub hidden_reason: Option<String>,
    pub pending_report_count: i32,
    pub created_at: DateTime<Utc>,
    pub edited_at: Option<DateTime<Utc>>,
}

#[derive(Debug, Serialize)]
pub struct AdminForumPostDetail {
    pub post: AdminForumPostSummary,
    pub body_md: String,
    pub hidden_by: Option<i32>,
    pub comments: Vec<AdminForumComment>,
}

#[derive(Debug, Clone, Serialize)]
pub struct AdminReportTargetPreview {
    pub post_id: Option<i64>,
    pub title: Option<String>,
    pub excerpt: String,
    pub status: String,
    pub author: Option<AdminAuthor>,
}

#[derive(Debug, Serialize)]
pub struct AdminReportRow {
    pub id: i64,
    pub target_type: String,
    pub target_id: i64,
    pub target_preview: AdminReportTargetPreview,
    pub reporter: Reporter,
    pub reason: String,
    pub detail: Option<String>,
    pub status: String,
    pub resolution_note: Option<String>,
    pub handled_at: Option<DateTime<Utc>>,
    pub created_at: DateTime<Utc>,
}

#[derive(Debug, Serialize)]
pub struct AdminReportListResponse {
    pub pending_total: i64,
    pub total: i64,
    pub page: u32,
    pub size: u32,
    pub reports: Vec<AdminReportRow>,
}

#[derive(Debug, Serialize)]
pub struct ReportDecisionResponse {
    pub id: i64,
    pub status: String,
    pub target_status: String,
    pub restored: bool,
    pub message: String,
}

#[derive(Debug, Serialize)]
pub struct MuteResponse {
    pub mute_id: Option<i64>,
    pub user_id: i32,
    pub ends_at: Option<DateTime<Utc>>,
    pub message: String,
}

#[derive(Debug, Serialize)]
pub struct AdminActionActor {
    pub id: i32,
    pub username: String,
}

#[derive(Debug, Serialize)]
pub struct AdminActionRow {
    pub id: i64,
    pub actor: Option<AdminActionActor>,
    pub action: String,
    pub target_type: String,
    pub target_id: Option<i64>,
    pub reason: Option<String>,
    pub metadata: serde_json::Value,
    pub created_at: DateTime<Utc>,
}

#[derive(Debug, Serialize)]
pub struct AdminActionListResponse {
    pub total: i64,
    pub page: u32,
    pub size: u32,
    pub actions: Vec<AdminActionRow>,
}

#[derive(Debug, FromRow)]
pub struct ForumPostRow {
    pub id: i64,
    pub author_id: i32,
    pub author_username: String,
    pub author_is_plus: bool,
    pub board: String,
    pub title: String,
    pub body_md: String,
    pub tags: Vec<String>,
    pub interview_date: Option<String>,
    pub company: Option<String>,
    pub role: Option<String>,
    pub view_count: i32,
    pub accepted_comment_id: Option<i64>,
    pub problem_id: Option<i32>,
    pub problem_title: Option<String>,
    pub problem_difficulty: Option<String>,
    pub is_anonymous: bool,
    pub status: String,
    pub hidden_reason: Option<String>,
    pub is_pinned: bool,
    pub like_count: i32,
    pub favorite_count: i32,
    pub comment_count: i32,
    pub created_at: DateTime<Utc>,
    pub updated_at: DateTime<Utc>,
    pub edited_at: Option<DateTime<Utc>>,
    pub liked: bool,
    pub favorited: bool,
    pub total: i64,
}

impl ForumPostRow {
    pub fn into_summary(self, viewer_id: Option<i32>) -> ForumPostSummary {
        let excerpt = crate::services::forum_service::make_excerpt(&self.body_md, 160);
        let problem = match (self.problem_id, self.problem_title, self.problem_difficulty) {
            (Some(id), Some(title), Some(difficulty)) => Some(ProblemBrief {
                id,
                title,
                difficulty,
            }),
            _ => None,
        };
        ForumPostSummary {
            id: self.id,
            board: self.board,
            title: self.title,
            excerpt,
            interview_date: self.interview_date,
            company: self.company,
            role: self.role,
            view_count: self.view_count,
            accepted_comment_id: self.accepted_comment_id,
            tags: self.tags,
            author: PublicAuthor::new(
                self.author_id,
                &self.author_username,
                self.is_anonymous,
                self.author_is_plus,
                viewer_id,
            ),
            problem,
            is_anonymous: self.is_anonymous,
            status: self.status,
            is_pinned: self.is_pinned,
            like_count: self.like_count,
            favorite_count: self.favorite_count,
            comment_count: self.comment_count,
            liked: self.liked,
            favorited: self.favorited,
            created_at: self.created_at,
            updated_at: self.updated_at,
            edited_at: self.edited_at,
        }
    }
}

#[derive(Debug, FromRow)]
pub struct AdminForumPostRow {
    pub id: i64,
    pub author_id: i32,
    pub author_username: String,
    pub author_email: String,
    pub author_role: String,
    pub board: String,
    pub title: String,
    pub body_md: String,
    pub tags: Vec<String>,
    pub interview_date: Option<String>,
    pub company: Option<String>,
    pub role: Option<String>,
    pub view_count: i32,
    pub accepted_comment_id: Option<i64>,
    pub problem_id: Option<i32>,
    pub problem_title: Option<String>,
    pub problem_difficulty: Option<String>,
    pub is_anonymous: bool,
    pub status: String,
    pub hidden_reason: Option<String>,
    pub hidden_by: Option<i32>,
    pub hidden_at: Option<DateTime<Utc>>,
    pub is_pinned: bool,
    pub like_count: i32,
    pub favorite_count: i32,
    pub comment_count: i32,
    pub pending_report_count: i32,
    pub created_at: DateTime<Utc>,
    pub updated_at: DateTime<Utc>,
    pub edited_at: Option<DateTime<Utc>>,
    pub total: i64,
}

impl AdminForumPostRow {
    pub fn into_summary(self) -> AdminForumPostSummary {
        let excerpt = crate::services::forum_service::make_excerpt(&self.body_md, 160);
        let problem = match (self.problem_id, self.problem_title, self.problem_difficulty) {
            (Some(id), Some(title), Some(difficulty)) => Some(ProblemBrief {
                id,
                title,
                difficulty,
            }),
            _ => None,
        };
        AdminForumPostSummary {
            id: self.id,
            board: self.board,
            title: self.title,
            excerpt,
            interview_date: self.interview_date,
            company: self.company,
            role: self.role,
            view_count: self.view_count,
            accepted_comment_id: self.accepted_comment_id,
            tags: self.tags,
            author: AdminAuthor::new(
                self.author_id,
                self.author_username,
                self.author_email,
                self.author_role,
            ),
            is_anonymous: self.is_anonymous,
            status: self.status,
            hidden_reason: self.hidden_reason,
            is_pinned: self.is_pinned,
            like_count: self.like_count,
            favorite_count: self.favorite_count,
            comment_count: self.comment_count,
            pending_report_count: self.pending_report_count,
            problem,
            created_at: self.created_at,
            updated_at: self.updated_at,
            edited_at: self.edited_at,
            hidden_at: self.hidden_at,
        }
    }
}

#[derive(Debug, FromRow)]
pub struct ForumCommentRow {
    pub id: i64,
    pub post_id: i64,
    pub author_id: i32,
    pub author_username: String,
    pub author_is_plus: bool,
    pub parent_id: Option<i64>,
    pub reply_to_comment_id: Option<i64>,
    pub reply_to_username: Option<String>,
    pub reply_to_is_anonymous: Option<bool>,
    pub reply_to_status: Option<String>,
    pub body_md: String,
    pub is_anonymous: bool,
    pub status: String,
    pub created_at: DateTime<Utc>,
    pub edited_at: Option<DateTime<Utc>>,
    pub reply_total: i64,
    pub total: i64,
    pub reply_rank: i64,
    pub favorited: bool,
    pub is_accepted: bool,
}

impl ForumCommentRow {
    fn reply_to(&self) -> Option<ReplyTo> {
        self.reply_to_comment_id.map(|comment_id| ReplyTo {
            comment_id,
            display_name: match (
                &self.reply_to_username,
                self.reply_to_is_anonymous,
                self.reply_to_status.as_deref(),
            ) {
                (_, _, Some(status)) if status != "published" => "已隐藏".to_owned(),
                (Some(_), Some(true), _) => "匿名同学".to_owned(),
                (Some(username), _, _) => username.clone(),
                (None, _, _) => "已删除用户".to_owned(),
            },
        })
    }

    pub fn into_reply_view(self, viewer_id: Option<i32>, is_admin: bool) -> ForumReplyView {
        let reply_to = self.reply_to();
        let is_author = viewer_id == Some(self.author_id);
        let published = self.status == "published";
        ForumReplyView {
            id: self.id,
            post_id: self.post_id,
            parent_id: self.parent_id,
            reply_to,
            body_md: self.body_md,
            author: PublicAuthor::new(
                self.author_id,
                &self.author_username,
                self.is_anonymous,
                self.author_is_plus,
                viewer_id,
            ),
            is_tombstone: false,
            created_at: self.created_at,
            edited_at: self.edited_at,
            can_edit: is_author && published,
            can_delete: (is_author || is_admin) && published,
            favorited: self.favorited,
            is_accepted: self.is_accepted,
        }
    }

    pub fn into_comment_view(
        self,
        viewer_id: Option<i32>,
        is_admin: bool,
        replies: Vec<ForumReplyView>,
        reply_total: i64,
    ) -> ForumCommentView {
        let reply_to = self.reply_to();
        let is_tombstone = self.status != "published";
        let is_author = viewer_id == Some(self.author_id);
        let published = self.status == "published";
        ForumCommentView {
            id: self.id,
            post_id: self.post_id,
            parent_id: self.parent_id,
            reply_to,
            body_md: if is_tombstone {
                String::new()
            } else {
                self.body_md
            },
            author: if is_tombstone {
                PublicAuthor::hidden()
            } else {
                PublicAuthor::new(
                    self.author_id,
                    &self.author_username,
                    self.is_anonymous,
                    self.author_is_plus,
                    viewer_id,
                )
            },
            is_tombstone,
            created_at: self.created_at,
            edited_at: self.edited_at,
            can_edit: is_author && published,
            can_delete: (is_author || is_admin) && published,
            favorited: self.favorited && !is_tombstone,
            is_accepted: self.is_accepted && !is_tombstone,
            reply_total,
            replies_truncated: reply_total > replies.len() as i64,
            replies,
        }
    }
}

#[derive(Debug, FromRow)]
pub struct AdminForumCommentRow {
    pub id: i64,
    pub post_id: i64,
    pub parent_id: Option<i64>,
    pub reply_to_comment_id: Option<i64>,
    pub body_md: String,
    pub author_id: i32,
    pub author_username: String,
    pub author_email: String,
    pub author_role: String,
    pub is_anonymous: bool,
    pub status: String,
    pub hidden_reason: Option<String>,
    pub pending_report_count: i32,
    pub created_at: DateTime<Utc>,
    pub edited_at: Option<DateTime<Utc>>,
}

impl AdminForumCommentRow {
    pub fn into_view(self) -> AdminForumComment {
        AdminForumComment {
            id: self.id,
            post_id: self.post_id,
            parent_id: self.parent_id,
            reply_to_comment_id: self.reply_to_comment_id,
            body_md: self.body_md,
            author: AdminAuthor::new(
                self.author_id,
                self.author_username,
                self.author_email,
                self.author_role,
            ),
            is_anonymous: self.is_anonymous,
            status: self.status,
            hidden_reason: self.hidden_reason,
            pending_report_count: self.pending_report_count,
            created_at: self.created_at,
            edited_at: self.edited_at,
        }
    }
}
