import type { AssignmentStatus } from '../types/teaching'

export const ASSIGNMENT_STATUS_LABELS: Record<AssignmentStatus, string> = {
  draft: '草稿',
  published: '已发布',
  archived: '已归档',
}

export const assignmentStatusLabel = (status: AssignmentStatus): string =>
  ASSIGNMENT_STATUS_LABELS[status]

export const formatDateTime = (value?: string): string =>
  value ? new Date(value).toLocaleString('zh-CN') : '—'

export const formatDateInput = (value?: string): string => {
  if (!value) return ''
  const date = new Date(value)
  const offset = date.getTimezoneOffset() * 60_000
  return new Date(date.getTime() - offset).toISOString().slice(0, 16)
}

export const toIsoString = (value: string): string | undefined =>
  value ? new Date(value).toISOString() : undefined

export const isPast = (value?: string): boolean =>
  Boolean(value && new Date(value).getTime() <= Date.now())

export const problemAttemptLabel = (attempts: number, accepted: boolean): string => {
  if (accepted) return '已通过'
  return attempts > 0 ? '尝试中' : '未开始'
}

export const gradeSummary = (score: number | undefined, points: number): string =>
  score === undefined ? '—' : `${score} / ${points}`
