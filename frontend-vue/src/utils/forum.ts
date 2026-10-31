import type { ForumStatus, NotificationType, ReportStatus } from '../types/forum'

export const formatForumTime = (value: string): string => {
  const date = new Date(value)
  if (Number.isNaN(date.getTime())) return ''
  const diff = Date.now() - date.getTime()
  const minutes = Math.floor(diff / 60_000)
  if (minutes < 1) return '刚刚'
  if (minutes < 60) return `${minutes} 分钟前`
  const hours = Math.floor(minutes / 60)
  if (hours < 24) return `${hours} 小时前`
  const days = Math.floor(hours / 24)
  if (days < 7) return `${days} 天前`
  return date.toLocaleDateString('zh-CN', {
    year: 'numeric',
    month: '2-digit',
    day: '2-digit',
  })
}

export const formatForumDateTime = (value: string | null): string => {
  if (!value) return '—'
  const date = new Date(value)
  return Number.isNaN(date.getTime()) ? '—' : date.toLocaleString('zh-CN')
}

export const FORUM_STATUS_LABELS: Record<ForumStatus, string> = {
  published: '已发布',
  hidden: '已隐藏',
  deleted: '已删除',
}

export const REPORT_STATUS_LABELS: Record<ReportStatus, string> = {
  pending: '待处理',
  resolved: '已隐藏',
  rejected: '已驳回',
}

export const NOTIFICATION_TYPE_LABELS: Record<string, string> = {
  forum_comment: '评论',
  forum_reply: '回复',
  forum_mention: '@提及',
  forum_moderation: '审核',
  forum_mute: '禁言',
  assignment_published: '作业',
  assignment_grades_published: '成绩',
  problem_review: '题目审核',
  knowledge_review: '学习审核',
  class_invite: '组织邀请',
  class_invite_accepted: '邀请结果',
  class_invite_declined: '邀请结果',
  system_notice: '站内通知',
}

export const NOTIFICATION_TYPE_ICONS: Record<string, string> = {
  forum_comment: '💬',
  forum_reply: '↩',
  forum_mention: '@',
  forum_moderation: '⚑',
  forum_mute: '⏸',
  assignment_published: '📘',
  assignment_grades_published: '📊',
  problem_review: '✓',
  knowledge_review: '📚',
  class_invite: '✉',
  class_invite_accepted: '✅',
  class_invite_declined: '↩',
  system_notice: '📣',
}

export const notificationIcon = (type: NotificationType | string): string =>
  NOTIFICATION_TYPE_ICONS[type] ?? '•'

export const notificationLabel = (type: NotificationType | string): string =>
  NOTIFICATION_TYPE_LABELS[type] ?? '通知'

export const forumStatusLabel = (status: ForumStatus): string => FORUM_STATUS_LABELS[status]
