import type { ReviewStatus } from '../types/problemReview'

export const REVIEW_STATUS_LABELS: Record<ReviewStatus, string> = {
  pending: '待审核',
  approved: '已通过',
  rejected: '已退回',
}

export const REVIEW_STATUS_OPTIONS: Array<{ value: ReviewStatus | 'all'; label: string }> = [
  { value: 'all', label: '全部状态' },
  { value: 'pending', label: '待审核' },
  { value: 'approved', label: '已通过' },
  { value: 'rejected', label: '已退回' },
]

export const reviewStatusLabel = (status: ReviewStatus): string => REVIEW_STATUS_LABELS[status]
