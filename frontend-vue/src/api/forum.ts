import { type ApiEnvelope, unwrap } from './client'
import { http } from './http'
import {
  bool,
  isRecord,
  nullableNumber,
  nullableText,
  number,
  record,
  text,
  type UnknownRecord,
} from './parse'
import type {
  AdminForumPostDetail,
  AdminForumPostListQuery,
  AdminForumPostListResult,
  AdminForumPostSummary,
  AdminForumComment,
  AdminReport,
  AdminReportDecisionResult,
  AdminReportListQuery,
  AdminReportListResult,
  AdminMuteResult,
  ForumComment,
  ForumCommentsResult,
  ForumAcceptedCommentResult,
  ForumBoard,
  ForumMutation,
  ForumPostDetail,
  ForumPostListQuery,
  ForumPostListResult,
  ForumPostPayload,
  ForumPostSummary,
  ForumProblemRef,
  ForumReactionResult,
  ForumReply,
  ForumReportPayload,
  ForumReportResult,
  ForumRepliesResult,
  ForumCommentPayload,
  ForumInterviewFacets,
  ForumStatus,
} from '../types/forum'

const status = (value: unknown): ForumStatus =>
  value === 'hidden' || value === 'deleted' ? value : 'published'
const board = (value: unknown): ForumBoard => (value === 'interview' ? 'interview' : 'general')
const hiddenReason = (value: unknown): 'moderation' | 'report_threshold' | null =>
  value === 'moderation' || value === 'report_threshold' ? value : null

const mapAuthor = (value: unknown) => {
  const item = record(value)
  return {
    displayName: text(item.display_name, '匿名同学'),
    isAnonymous: bool(item.is_anonymous),
    isSelf: bool(item.is_self),
    isPlus: bool(item.is_plus),
  }
}

const mapProblem = (value: unknown): ForumProblemRef | null => {
  if (!isRecord(value)) return null
  const difficulty = value.difficulty
  return {
    id: number(value.id),
    title: text(value.title),
    difficulty: difficulty === 'medium' || difficulty === 'hard' ? difficulty : 'easy',
  }
}

const mapPostSummary = (value: unknown): ForumPostSummary => {
  const item = record(value)
  return {
    id: number(item.id),
    board: board(item.board),
    title: text(item.title),
    excerpt: text(item.excerpt),
    interviewDate: nullableText(item.interview_date),
    company: nullableText(item.company),
    role: nullableText(item.role),
    viewCount: number(item.view_count),
    acceptedCommentId: nullableNumber(item.accepted_comment_id),
    tags: Array.isArray(item.tags) ? item.tags.filter((tag): tag is string => typeof tag === 'string') : [],
    author: mapAuthor(item.author),
    problem: mapProblem(item.problem),
    isAnonymous: bool(item.is_anonymous),
    status: status(item.status),
    isPinned: bool(item.is_pinned),
    likeCount: number(item.like_count),
    favoriteCount: number(item.favorite_count),
    commentCount: number(item.comment_count),
    liked: bool(item.liked),
    favorited: bool(item.favorited),
    createdAt: text(item.created_at),
    updatedAt: text(item.updated_at),
    editedAt: nullableText(item.edited_at),
  }
}

const mapPostDetail = (value: unknown): ForumPostDetail => {
  const item = record(value)
  return {
    ...mapPostSummary(item),
    bodyMd: text(item.body_md),
    canEdit: bool(item.can_edit),
    canDelete: bool(item.can_delete),
    canModerate: bool(item.can_moderate),
    hiddenReason: hiddenReason(item.hidden_reason),
  }
}

const mapReplyTo = (value: unknown) => {
  if (!isRecord(value)) return null
  return {
    commentId: number(value.comment_id),
    displayName: text(value.display_name, '匿名同学'),
  }
}

const mapReply = (value: unknown): ForumReply => {
  const item = record(value)
  return {
    id: number(item.id),
    postId: number(item.post_id),
    parentId: nullableNumber(item.parent_id),
    replyTo: mapReplyTo(item.reply_to),
    bodyMd: text(item.body_md),
    author: mapAuthor(item.author),
    isTombstone: bool(item.is_tombstone),
    createdAt: text(item.created_at),
    editedAt: nullableText(item.edited_at),
    canEdit: bool(item.can_edit),
    canDelete: bool(item.can_delete),
    favorited: bool(item.favorited),
    isAccepted: bool(item.is_accepted),
  }
}

const mapComment = (value: unknown): ForumComment => {
  const item = record(value)
  return {
    ...mapReply(item),
    replyTotal: number(item.reply_total),
    repliesTruncated: bool(item.replies_truncated),
    replies: Array.isArray(item.replies) ? item.replies.map(mapReply) : [],
  }
}

const mapAdminAuthor = (value: unknown) => {
  const item = record(value)
  return {
    id: number(item.id),
    username: text(item.username),
    email: text(item.email),
    role: text(item.role, 'user'),
  }
}

const mapAdminPost = (value: unknown): AdminForumPostSummary => {
  const item = record(value)
  return {
    id: number(item.id),
    board: board(item.board),
    title: text(item.title),
    excerpt: text(item.excerpt),
    interviewDate: nullableText(item.interview_date),
    company: nullableText(item.company),
    role: nullableText(item.role),
    viewCount: number(item.view_count),
    acceptedCommentId: nullableNumber(item.accepted_comment_id),
    tags: Array.isArray(item.tags) ? item.tags.filter((tag): tag is string => typeof tag === 'string') : [],
    author: mapAdminAuthor(item.author),
    problem: mapProblem(item.problem),
    isAnonymous: bool(item.is_anonymous),
    status: status(item.status),
    isPinned: bool(item.is_pinned),
    likeCount: number(item.like_count),
    favoriteCount: number(item.favorite_count),
    commentCount: number(item.comment_count),
    createdAt: text(item.created_at),
    updatedAt: text(item.updated_at),
    editedAt: nullableText(item.edited_at),
    hiddenReason: hiddenReason(item.hidden_reason),
    pendingReportCount: number(item.pending_report_count),
    hiddenAt: nullableText(item.hidden_at),
  }
}

const mapAdminComment = (value: unknown): AdminForumComment => {
  const item = record(value)
  return {
    id: number(item.id),
    postId: number(item.post_id),
    parentId: nullableNumber(item.parent_id),
    replyToCommentId: nullableNumber(item.reply_to_comment_id),
    bodyMd: text(item.body_md),
    author: mapAdminAuthor(item.author),
    isAnonymous: bool(item.is_anonymous),
    status: status(item.status),
    hiddenReason: hiddenReason(item.hidden_reason),
    pendingReportCount: number(item.pending_report_count),
    createdAt: text(item.created_at),
    editedAt: nullableText(item.edited_at),
  }
}

const mapReport = (value: unknown): AdminReport => {
  const item = record(value)
  const preview = record(item.target_preview)
  const reporter = record(item.reporter)
  const reason = text(item.reason, 'other')
  const reportStatus = text(item.status, 'pending')
  return {
    id: number(item.id),
    targetType: item.target_type === 'comment' ? 'comment' : 'post',
    targetId: number(item.target_id),
    targetPreview: {
      postId: nullableNumber(preview.post_id),
      title: nullableText(preview.title),
      excerpt: text(preview.excerpt),
      status: status(preview.status),
      author: isRecord(preview.author) ? mapAdminAuthor(preview.author) : null,
    },
    reporter: { id: number(reporter.id), username: text(reporter.username) },
    reason:
      reason === 'abuse' || reason === 'spoiler' || reason === 'illegal' || reason === 'spam'
        ? reason
        : 'other',
    detail: nullableText(item.detail),
    status:
      reportStatus === 'resolved' || reportStatus === 'rejected' ? reportStatus : 'pending',
    resolutionNote: nullableText(item.resolution_note),
    handledAt: nullableText(item.handled_at),
    createdAt: text(item.created_at),
  }
}

const listParams = (query: ForumPostListQuery): Record<string, string | number | boolean> => {
  const params: Record<string, string | number | boolean> = { page: query.page, size: query.size }
  if (query.board) params.board = query.board
  if (query.tag) params.tag = query.tag
  if (query.company) params.company = query.company
  if (query.role) params.role = query.role
  if (query.problem_id) params.problem_id = query.problem_id
  if (query.q) params.q = query.q
  if (query.sort) params.sort = query.sort
  if (query.mine) params.mine = true
  return params
}

export const fetchForumPosts = async (query: ForumPostListQuery): Promise<ForumPostListResult> => {
  const data = await unwrap(
    http.get<ApiEnvelope<UnknownRecord>>('/forum/posts', { params: listParams(query) }),
  )
  const posts = Array.isArray(data.posts) ? data.posts.map(mapPostSummary) : []
  return {
    total: number(data.total),
    page: number(data.page, query.page),
    size: number(data.size, query.size),
    posts,
  }
}

export const fetchForumInterviewFacets = async (): Promise<ForumInterviewFacets> => {
  const data = await unwrap(http.get<ApiEnvelope<unknown>>('/forum/interview/facets'))
  const item = record(data)
  const list = (value: unknown): string[] =>
    Array.isArray(value) ? value.filter((entry): entry is string => typeof entry === 'string') : []
  return { companies: list(item.companies), roles: list(item.roles) }
}

export const fetchForumPost = async (id: number): Promise<ForumPostDetail> => {
  const data = await unwrap(http.get<ApiEnvelope<unknown>>(`/forum/posts/${id}`))
  return mapPostDetail(data)
}

export const createForumPost = async (
  payload: ForumPostPayload,
  isAnonymous: boolean,
): Promise<{ id: number; status: ForumStatus }> => {
  const data = await unwrap(
    http.post<ApiEnvelope<unknown>>('/forum/posts', { ...payload, is_anonymous: isAnonymous }),
  )
  const item = record(data)
  return { id: number(item.id), status: status(item.status) }
}

export const updateForumPost = async (
  id: number,
  payload: ForumPostPayload,
): Promise<ForumMutation> => {
  const data = await unwrap(http.put<ApiEnvelope<unknown>>(`/forum/posts/${id}`, payload))
  const item = record(data)
  return { id: number(item.id, id), message: text(item.message, '帖子已更新') }
}

export const deleteForumPost = async (id: number): Promise<ForumMutation> => {
  const data = await unwrap(http.delete<ApiEnvelope<unknown>>(`/forum/posts/${id}`))
  const item = record(data)
  return { id: number(item.id, id), message: text(item.message, '帖子已删除') }
}

const reaction = (value: unknown, kind: 'like' | 'favorite'): ForumReactionResult => {
  const item = record(value)
  return kind === 'like'
    ? { liked: bool(item.liked), likeCount: number(item.like_count) }
    : { favorited: bool(item.favorited), favoriteCount: number(item.favorite_count) }
}

export const likeForumPost = async (id: number, liked: boolean): Promise<ForumReactionResult> => {
  const data = liked
    ? await unwrap(http.post<ApiEnvelope<unknown>>(`/forum/posts/${id}/like`))
    : await unwrap(http.delete<ApiEnvelope<unknown>>(`/forum/posts/${id}/like`))
  return reaction(data, 'like')
}

export const favoriteForumPost = async (
  id: number,
  favorited: boolean,
): Promise<ForumReactionResult> => {
  const data = favorited
    ? await unwrap(http.post<ApiEnvelope<unknown>>(`/forum/posts/${id}/favorite`))
    : await unwrap(http.delete<ApiEnvelope<unknown>>(`/forum/posts/${id}/favorite`))
  return reaction(data, 'favorite')
}

export const acceptForumComment = async (
  postId: number,
  commentId: number,
): Promise<ForumAcceptedCommentResult> => {
  const data = await unwrap(
    http.post<ApiEnvelope<unknown>>(`/forum/posts/${postId}/accepted-comment`, {
      comment_id: commentId,
    }),
  )
  const item = record(data)
  return {
    acceptedCommentId: nullableNumber(item.accepted_comment_id),
    message: text(item.message, '已设为最佳答案'),
  }
}

export const clearAcceptedForumComment = async (
  postId: number,
): Promise<ForumAcceptedCommentResult> => {
  const data = await unwrap(
    http.delete<ApiEnvelope<unknown>>(`/forum/posts/${postId}/accepted-comment`),
  )
  const item = record(data)
  return {
    acceptedCommentId: nullableNumber(item.accepted_comment_id),
    message: text(item.message, '已取消最佳答案'),
  }
}

export const fetchForumComments = async (
  postId: number,
  page: number,
  size: number,
): Promise<ForumCommentsResult> => {
  const data = await unwrap(
    http.get<ApiEnvelope<UnknownRecord>>(`/forum/posts/${postId}/comments`, {
      params: { page, size, sort: 'asc' },
    }),
  )
  return {
    total: number(data.total),
    page: number(data.page, page),
    size: number(data.size, size),
    comments: Array.isArray(data.comments) ? data.comments.map(mapComment) : [],
  }
}

export const fetchForumReplies = async (
  rootCommentId: number,
  page: number,
  size: number,
): Promise<ForumRepliesResult> => {
  const data = await unwrap(
    http.get<ApiEnvelope<UnknownRecord>>(`/forum/comments/${rootCommentId}/replies`, {
      params: { page, size },
    }),
  )
  return {
    total: number(data.total),
    page: number(data.page, page),
    size: number(data.size, size),
    replies: Array.isArray(data.replies) ? data.replies.map(mapReply) : [],
  }
}

export const createForumComment = async (
  postId: number,
  payload: ForumCommentPayload,
): Promise<ForumComment> => {
  const data = await unwrap(
    http.post<ApiEnvelope<unknown>>(`/forum/posts/${postId}/comments`, {
      ...payload,
      is_anonymous: payload.is_anonymous ?? false,
    }),
  )
  return mapComment(data)
}

export const updateForumComment = async (id: number, bodyMd: string): Promise<ForumMutation> => {
  const data = await unwrap(
    http.put<ApiEnvelope<unknown>>(`/forum/comments/${id}`, { body_md: bodyMd }),
  )
  const item = record(data)
  return { id: number(item.id, id), message: text(item.message, '评论已更新') }
}

export const deleteForumComment = async (id: number): Promise<ForumMutation> => {
  const data = await unwrap(http.delete<ApiEnvelope<unknown>>(`/forum/comments/${id}`))
  const item = record(data)
  return { id: number(item.id, id), message: text(item.message, '评论已删除') }
}

export const createForumReport = async (
  payload: ForumReportPayload,
): Promise<ForumReportResult> => {
  const data = await unwrap(http.post<ApiEnvelope<unknown>>('/forum/reports', payload))
  const item = record(data)
  return {
    reportId: number(item.report_id),
    hidden: bool(item.hidden),
    message: text(item.message, '举报已提交'),
  }
}

// ---------------------------------------------------------------------------
// Admin
// ---------------------------------------------------------------------------

export const fetchAdminForumPosts = async (
  query: AdminForumPostListQuery,
): Promise<AdminForumPostListResult> => {
  const params: Record<string, string | number> = { page: query.page, size: query.size }
  if (query.status) params.status = query.status
  if (query.board) params.board = query.board
  if (query.q) params.q = query.q
  if (query.author) params.author = query.author
  const data = await unwrap(
    http.get<ApiEnvelope<UnknownRecord>>('/admin/forum/posts', { params }),
  )
  return {
    total: number(data.total),
    page: number(data.page, query.page),
    size: number(data.size, query.size),
    posts: Array.isArray(data.posts) ? data.posts.map(mapAdminPost) : [],
  }
}

export const fetchAdminForumPost = async (id: number): Promise<AdminForumPostDetail> => {
  const data = await unwrap(http.get<ApiEnvelope<unknown>>(`/admin/forum/posts/${id}`))
  const item = record(data)
  return {
    post: mapAdminPost(item.post),
    bodyMd: text(item.body_md),
    hiddenBy: nullableNumber(item.hidden_by),
    comments: Array.isArray(item.comments) ? item.comments.map(mapAdminComment) : [],
  }
}

export const changeAdminPostStatus = async (
  id: number,
  next: ForumStatus,
  reason?: string,
): Promise<ForumMutation> => {
  const data = await unwrap(
    http.put<ApiEnvelope<unknown>>(`/admin/forum/posts/${id}/status`, { status: next, reason }),
  )
  const item = record(data)
  return { id: number(item.id, id), message: text(item.message, '帖子状态已更新') }
}

export const changeAdminCommentStatus = async (
  id: number,
  next: ForumStatus,
  reason?: string,
): Promise<ForumMutation> => {
  const data = await unwrap(
    http.put<ApiEnvelope<unknown>>(`/admin/forum/comments/${id}/status`, {
      status: next,
      reason,
    }),
  )
  const item = record(data)
  return { id: number(item.id, id), message: text(item.message, '评论状态已更新') }
}

export const pinAdminForumPost = async (
  id: number,
  isPinned: boolean,
): Promise<{ id: number; isPinned: boolean; message: string }> => {
  const data = await unwrap(
    http.put<ApiEnvelope<unknown>>(`/admin/forum/posts/${id}/pin`, { is_pinned: isPinned }),
  )
  const item = record(data)
  return {
    id: number(item.id, id),
    isPinned: bool(item.is_pinned, isPinned),
    message: text(item.message),
  }
}

export const fetchAdminReports = async (
  query: AdminReportListQuery,
): Promise<AdminReportListResult> => {
  const params: Record<string, string | number> = { page: query.page, size: query.size }
  if (query.status) params.status = query.status
  const data = await unwrap(
    http.get<ApiEnvelope<UnknownRecord>>('/admin/forum/reports', { params }),
  )
  return {
    pendingTotal: number(data.pending_total),
    total: number(data.total),
    page: number(data.page, query.page),
    size: number(data.size, query.size),
    reports: Array.isArray(data.reports) ? data.reports.map(mapReport) : [],
  }
}

export const decideAdminReport = async (
  id: number,
  decision: 'hide' | 'keep',
  note?: string,
): Promise<AdminReportDecisionResult> => {
  const data = await unwrap(
    http.put<ApiEnvelope<unknown>>(`/admin/forum/reports/${id}`, { decision, note }),
  )
  const item = record(data)
  const targetStatus = status(item.target_status)
  return {
    id: number(item.id, id),
    status: item.status === 'resolved' ? 'resolved' : 'rejected',
    targetStatus,
    restored: bool(item.restored),
    message: text(item.message),
  }
}

export const muteForumUser = async (
  userId: number,
  durationHours: number | null,
  reason: string,
): Promise<AdminMuteResult> => {
  const data = await unwrap(
    http.post<ApiEnvelope<unknown>>(`/admin/forum/users/${userId}/mute`, {
      duration_hours: durationHours,
      reason,
    }),
  )
  const item = record(data)
  return {
    muteId: nullableNumber(item.mute_id),
    userId: number(item.user_id, userId),
    endsAt: nullableText(item.ends_at),
    message: text(item.message),
  }
}

export const unmuteForumUser = async (userId: number): Promise<AdminMuteResult> => {
  const data = await unwrap(
    http.delete<ApiEnvelope<unknown>>(`/admin/forum/users/${userId}/mute`),
  )
  const item = record(data)
  return {
    muteId: null,
    userId: number(item.user_id, userId),
    endsAt: null,
    message: text(item.message),
  }
}
