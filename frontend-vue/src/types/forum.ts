export type ForumTagCode = 'general' | 'help' | 'solution' | 'discussion' | 'announcement'
export type ForumBoard = 'general' | 'interview'
export type ForumSort = 'latest' | 'hot'
export type ForumStatus = 'published' | 'hidden' | 'deleted'
export type ReportTargetType = 'post' | 'comment'
export type ReportReason = 'spam' | 'abuse' | 'spoiler' | 'illegal' | 'other'
export type ReportStatus = 'pending' | 'resolved' | 'rejected'

export const FORUM_BOARDS = [
  { code: 'general', label: '综合', plusOnly: false },
  { code: 'interview', label: '面经', plusOnly: true },
] as const satisfies ReadonlyArray<{ code: ForumBoard; label: string; plusOnly: boolean }>

export const FORUM_TAGS = [
  { code: 'general', label: '综合', adminOnly: false },
  { code: 'help', label: '求助', adminOnly: false },
  { code: 'solution', label: '题解', adminOnly: false },
  { code: 'discussion', label: '讨论', adminOnly: false },
  { code: 'announcement', label: '公告', adminOnly: true },
] as const satisfies ReadonlyArray<{ code: ForumTagCode; label: string; adminOnly: boolean }>

export const REPORT_REASONS = [
  { code: 'spam', label: '垃圾广告' },
  { code: 'abuse', label: '人身攻击' },
  { code: 'spoiler', label: '剧透' },
  { code: 'illegal', label: '违法违规' },
  { code: 'other', label: '其他' },
] as const satisfies ReadonlyArray<{ code: ReportReason; label: string }>

export const FORUM_TAG_LABELS: Record<ForumTagCode, string> = {
  general: '综合',
  help: '求助',
  solution: '题解',
  discussion: '讨论',
  announcement: '公告',
}

export const REPORT_REASON_LABELS: Record<ReportReason, string> = {
  spam: '垃圾广告',
  abuse: '人身攻击',
  spoiler: '剧透',
  illegal: '违法违规',
  other: '其他',
}

export interface ForumAuthor {
  displayName: string
  isAnonymous: boolean
  isSelf: boolean
  isPlus: boolean
}

export interface ForumProblemRef {
  id: number
  title: string
  difficulty: 'easy' | 'medium' | 'hard'
}

export interface ForumPostSummary {
  id: number
  board: ForumBoard
  title: string
  excerpt: string
  interviewDate: string | null
  company: string | null
  role: string | null
  viewCount: number
  tags: string[]
  author: ForumAuthor
  problem: ForumProblemRef | null
  isAnonymous: boolean
  status: ForumStatus
  isPinned: boolean
  likeCount: number
  favoriteCount: number
  commentCount: number
  liked: boolean
  favorited: boolean
  createdAt: string
  updatedAt: string
  editedAt: string | null
}

export interface ForumPostDetail extends ForumPostSummary {
  bodyMd: string
  canEdit: boolean
  canDelete: boolean
  canModerate: boolean
  hiddenReason: 'moderation' | 'report_threshold' | null
}

export interface ForumReplyTo {
  commentId: number
  displayName: string
}

export interface ForumReply {
  id: number
  postId: number
  parentId: number | null
  replyTo: ForumReplyTo | null
  bodyMd: string
  author: ForumAuthor
  isTombstone: boolean
  createdAt: string
  editedAt: string | null
  canEdit: boolean
  canDelete: boolean
  favorited: boolean
}

export interface ForumComment extends ForumReply {
  replyTotal: number
  repliesTruncated: boolean
  replies: ForumReply[]
}

export interface ForumPostListResult {
  total: number
  page: number
  size: number
  posts: ForumPostSummary[]
}

export interface ForumCommentsResult {
  total: number
  page: number
  size: number
  comments: ForumComment[]
}

export interface ForumRepliesResult {
  total: number
  page: number
  size: number
  replies: ForumReply[]
}

export interface ForumPostListQuery {
  page: number
  size: number
  board?: ForumBoard
  tag?: string
  company?: string
  role?: string
  q?: string
  sort?: ForumSort
  mine?: boolean
}

export interface ForumPostPayload {
  board?: ForumBoard
  title: string
  body_md: string
  tags: string[]
  interview_date?: string | null
  company?: string | null
  role?: string | null
  problem_id: number | null
}

export interface ForumInterviewFacets {
  companies: string[]
  roles: string[]
}

export interface ForumCommentPayload {
  body_md: string
  parent_id?: number | null
  reply_to_comment_id?: number | null
  is_anonymous?: boolean
}

export interface ForumReportPayload {
  target_type: ReportTargetType
  target_id: number
  reason: ReportReason
  detail?: string
}

export interface ForumPostCreated {
  id: number
  status: ForumStatus
}

export interface ForumMutation {
  id: number
  message: string
}

export interface ForumReactionResult {
  liked?: boolean
  favorited?: boolean
  likeCount?: number
  favoriteCount?: number
}

export interface ForumReportResult {
  reportId: number
  hidden: boolean
  message: string
}

// ---------------------------------------------------------------------------
// Admin
// ---------------------------------------------------------------------------

export interface AdminAuthor {
  id: number
  username: string
  email: string
  role: string
}

export interface AdminForumPostSummary extends Omit<ForumPostSummary, 'author' | 'liked' | 'favorited'> {
  author: AdminAuthor
  hiddenReason: 'moderation' | 'report_threshold' | null
  pendingReportCount: number
  hiddenAt: string | null
}

export interface AdminForumComment {
  id: number
  postId: number
  parentId: number | null
  replyToCommentId: number | null
  bodyMd: string
  author: AdminAuthor
  isAnonymous: boolean
  status: ForumStatus
  hiddenReason: 'moderation' | 'report_threshold' | null
  pendingReportCount: number
  createdAt: string
  editedAt: string | null
}

export interface AdminForumPostDetail {
  post: AdminForumPostSummary
  bodyMd: string
  hiddenBy: number | null
  comments: AdminForumComment[]
}

export interface AdminForumPostListResult {
  total: number
  page: number
  size: number
  posts: AdminForumPostSummary[]
}

export interface AdminReportTargetPreview {
  postId: number | null
  title: string | null
  excerpt: string
  status: ForumStatus
  author: AdminAuthor | null
}

export interface AdminReport {
  id: number
  targetType: ReportTargetType
  targetId: number
  targetPreview: AdminReportTargetPreview
  reporter: { id: number; username: string }
  reason: ReportReason
  detail: string | null
  status: ReportStatus
  resolutionNote: string | null
  handledAt: string | null
  createdAt: string
}

export interface AdminReportListResult {
  pendingTotal: number
  total: number
  page: number
  size: number
  reports: AdminReport[]
}

export interface AdminReportDecisionResult {
  id: number
  status: 'resolved' | 'rejected'
  targetStatus: ForumStatus
  restored: boolean
  message: string
}

export interface AdminMuteResult {
  muteId: number | null
  userId: number
  endsAt: string | null
  message: string
}

export interface AdminForumPostListQuery {
  page: number
  size: number
  status?: ForumStatus
  board?: ForumBoard
  q?: string
  author?: string
}

export interface AdminReportListQuery {
  page: number
  size: number
  status?: ReportStatus | 'all'
}

// ---------------------------------------------------------------------------
// Notifications
// ---------------------------------------------------------------------------

export type NotificationType =
  | 'forum_comment'
  | 'forum_reply'
  | 'forum_mention'
  | 'forum_moderation'
  | 'forum_mute'
  | 'assignment_published'
  | 'assignment_grades_published'
  | 'problem_review'
  | 'knowledge_review'
  | 'class_invite'
  | 'class_invite_accepted'
  | 'class_invite_declined'
  | 'system_notice'

export interface ForumNotification {
  id: number
  type: NotificationType | string
  title: string
  body: string | null
  link: string | null
  read: boolean
  createdAt: string
  relatedType?: string | null
  relatedId?: number | null
  invitationStatus?: string | null
}

export interface NotificationListResult {
  total: number
  unread: number
  page: number
  size: number
  notifications: ForumNotification[]
}

export interface NotificationListQuery {
  page: number
  size: number
  unread_only?: boolean
}
