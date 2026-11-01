export type LatePolicy = 'forbid' | 'allow'
export type ScoringPolicy = 'highest' | 'last' | 'first_ac'
export type ScoreVisibility = 'after_publish' | 'after_due' | 'during'
export type ExemptionMode = 'full_score' | 'excluded'

export interface AssignmentPolicy {
  latePolicy: LatePolicy
  lateGraceHours: number
  latePenaltyPerDay: number
  latePenaltyCap: number
  maxAttempts?: number | null
  scoringPolicy: ScoringPolicy
  scoreVisibility: ScoreVisibility
  allowPeerCode: boolean
  showClassStats: boolean
}

export interface OverrideItem {
  userId: number
  username: string
  problemId: number
  makeupDueAt?: string
  waiveLatePenalty: boolean
  exempt: boolean
  exemptionMode?: ExemptionMode
  reason?: string
  createdBy?: number
  createdAt: string
  updatedAt: string
}

export interface OverridePayload {
  makeupDueAt?: string
  waiveLatePenalty: boolean
  exempt: boolean
  exemptionMode?: ExemptionMode
  reason?: string
}

export interface PolicyAudit {
  id: number
  actorId?: number
  actorUsername?: string
  action: string
  beforeData?: unknown
  afterData?: unknown
  reason?: string
  createdAt: string
}

export interface AssignmentStatsProblem {
  problemId: number
  points: number
  acceptedStudentCount: number
  passRate: number
  averageScore: number
  exemptCount: number
  notSubmittedCount: number
}

export interface AssignmentStatistics {
  studentCount: number
  submittedStudentCount: number
  averageScore: number
  myTotalScore?: number
  myPositionBucket?: 'top10' | 'top25' | 'top50' | 'rest'
  problems: AssignmentStatsProblem[]
}

export type GradeAppealStatus = 'pending' | 'accepted' | 'rejected'

export interface GradeAppeal {
  id: number
  assignmentId: number
  userId: number
  username: string
  email: string
  reason: string
  status: GradeAppealStatus
  handleNote?: string
  handledBy?: number
  handlerUsername?: string
  handledAt?: string
  createdAt: string
}

export interface PeerSubmission {
  username: string
  language: string
  submittedAt: string
  code: string
}
