export type CheatReportStatus =
  | 'open'
  | 'confirmed'
  | 'dismissed'
  | 'appealed'
  | 'upheld'
  | 'overturned'

export type CheatSeverity = 'low' | 'medium' | 'high'

export type AppealStatus = 'pending' | 'upheld' | 'overturned'

export interface CheatReportQuery {
  status?: CheatReportStatus
  assignment_id?: number
  page?: number
  size?: number
}

export interface CheatReportSummary {
  id: number
  status: CheatReportStatus
  severity: CheatSeverity
  score: number
  created_at: string
  decided_at: string | null
  assignment_id: number | null
  assignment_title: string | null
  class_id: number | null
  class_name: string | null
  problem_id: number
  problem_title: string
  target_user_id: number
  target_username: string
  submission_id: number
  matched_submission_id: number | null
  matched_username: string | null
  reviewer_id: number | null
  reviewer_username: string | null
  appeal_status: AppealStatus | null
  penalty_applied: boolean
  decision_note: string | null
}

export interface CheatReportListResponse {
  total: number
  page: number
  size: number
  pending_count: number
  items: CheatReportSummary[]
}

export interface SubmissionEvidence {
  id: number
  user_id: number
  username: string
  language: string
  status: string
  submitted_at: string
  code: string
}

export interface MatchFragment {
  a_start: number
  a_end: number
  b_start: number
  b_end: number
}

export interface SimilarityDetail {
  score?: number
  containment?: number
  jaccard?: number
  a_grams?: number
  b_grams?: number
  matched_grams?: number
  fragments?: MatchFragment[]
}

export interface EvidencePair {
  submission_id: number
  user_id: number
  username: string
  language: string
  submitted_at: string
  score: number
  detail: SimilarityDetail
  code: string
}

export interface ReportEvidence {
  algorithm: string
  target_submission: SubmissionEvidence
  pairs: EvidencePair[]
}

export interface AppealView {
  id: number
  reason: string
  status: AppealStatus
  created_at: string
  handled_by: number | null
  handled_by_username: string | null
  handle_note: string | null
  handled_at: string | null
}

export interface ReportActionView {
  action: string
  actor_username: string | null
  note: string | null
  created_at: string
}

export interface CheatReportDetailResponse {
  report: CheatReportSummary
  evidence: ReportEvidence
  appeal: AppealView | null
  actions: ReportActionView[]
}

export interface MyReportSummary {
  id: number
  status: CheatReportStatus
  severity: CheatSeverity
  score: number
  created_at: string
  decided_at: string | null
  assignment_id: number | null
  assignment_title: string | null
  problem_id: number
  problem_title: string
  decision_note: string | null
  penalty_applied: boolean
  appeal_status: AppealStatus | null
}

export interface MyReportListResponse {
  items: MyReportSummary[]
}

export interface MyReportDetailResponse {
  report: MyReportSummary
  submission: SubmissionEvidence
  appeal: AppealView | null
  actions: ReportActionView[]
}

export interface CheatReviewInput {
  decision: 'confirmed' | 'dismissed'
  note?: string
  apply_zero: boolean
}

export interface ReviewResponse {
  message: string
  status: CheatReportStatus
  penalty_applied: boolean
}

export interface AppealSubmitResponse {
  message: string
  appeal_id: number
  status: AppealStatus
}

export interface AppealQueueItem {
  appeal_id: number
  report_id: number
  reason: string
  created_at: string
  target_user_id: number
  target_username: string
  assignment_id: number | null
  assignment_title: string | null
  problem_id: number
  problem_title: string
  score: number
  severity: CheatSeverity
  decision_note: string | null
  decided_at: string | null
}

export interface AppealQueueResponse {
  total: number
  page: number
  size: number
  items: AppealQueueItem[]
}

export interface AppealResolveInput {
  decision: 'upheld' | 'overturned'
  note?: string
}

export interface AppealResolveResponse {
  message: string
  appeal_status: AppealStatus
  report_status: CheatReportStatus
  penalty_restored: boolean
}
