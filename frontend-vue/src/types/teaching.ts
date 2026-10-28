import type {
  AssignmentPolicy,
  ExemptionMode,
} from './policy'

export type Role = 'student' | 'teacher' | 'admin'

export type AccountStatus = 'active' | 'disabled' | 'deleted'

export type AssignmentStatus = 'draft' | 'published' | 'archived'

export type ClassRelation = 'owner' | 'student'

export interface ClassOwner {
  id: number
  username: string
}

export interface ClassSummary {
  id: number
  name: string
  courseName?: string
  term?: string
  description?: string
  owner: ClassOwner
  relation: ClassRelation
  memberCount: number
  assignmentCount: number
  archivedAt?: string
}

export interface ClassMember {
  userId: number
  username: string
  email: string
  status: 'active' | 'removed'
  joinedAt: string
  removedAt?: string
}

export interface ClassDetail extends ClassSummary {
  createdAt: string
  inviteCode?: string
  members?: ClassMember[]
  assignments: AssignmentSummary[]
}

export interface AssignmentSummary {
  id: number
  classId: number
  title: string
  description?: string
  status: AssignmentStatus
  startAt?: string
  dueAt?: string
  publishedAt?: string
  gradesPublishedAt?: string
  problemCount: number
  totalPoints: number
  myAcceptedCount: number
  myAttemptedCount: number
  studentCount?: number
  submittedStudentCount?: number
}

export interface AssignmentProblem {
  problemId: number
  title: string
  difficulty: 'easy' | 'medium' | 'hard'
  points: number
  position: number
  attempts: number
  attemptsLimit?: number | null
  attemptsLeft?: number | null
  accepted: boolean
  lastStatus?: string
  isLate: boolean
  lateDays: number
  lateDeduction: number
  exempt: boolean
  exemptionMode?: ExemptionMode
  solutionsVisible: boolean
  solutionMd?: string
  autoScore?: number
  manualScore?: number
  finalScore?: number
  feedback?: string
  acceptedStudentCount?: number
}

export interface AssignmentDetail {
  id: number
  classId: number
  className: string
  title: string
  description?: string
  status: AssignmentStatus
  startAt?: string
  dueAt?: string
  publishedAt?: string
  gradesPublishedAt?: string
  gradesPublished: boolean
  latePolicy: AssignmentPolicy['latePolicy']
  lateGraceHours: number
  latePenaltyPerDay: number
  latePenaltyCap: number
  scoringPolicy: AssignmentPolicy['scoringPolicy']
  scoreVisibility: AssignmentPolicy['scoreVisibility']
  allowPeerCode: boolean
  showClassStats: boolean
  solutionsPublished: boolean
  solutionsPublishedAt?: string
  myDeadline?: string
  now: string
  isOwner: boolean
  canSubmit: boolean
  problems: AssignmentProblem[]
  totalScore?: number
  overallFeedback?: string
  studentCount?: number
  submittedStudentCount?: number
  lateStudentCount?: number
  exemptCount?: number
}

export interface AssignmentProblemInput {
  problemId: number
  points: number
  maxAttempts?: number | null
  solutionMd?: string
}

export interface GradebookCell {
  problemId: number
  attempts: number
  attemptsLimit?: number | null
  accepted: boolean
  isLate: boolean
  lateDays: number
  lateDeduction: number
  exempt: boolean
  exemptionMode?: ExemptionMode
  includedInTotal: boolean
  autoScore: number
  manualScore: number | null
  finalScore: number
  feedback: string | null
  lastSubmissionId: number | null
  lastStatus: string | null
}

export interface GradebookStudent {
  userId: number
  username: string
  email: string
  status: 'active' | 'removed'
  overallFeedback: string | null
  totalScore: number
  problems: GradebookCell[]
}

export interface GradebookProblem {
  problemId: number
  title: string
  points: number
}

export interface Gradebook {
  assignment: {
    id: number
    title: string
    dueAt?: string
    gradesPublishedAt?: string
    latePolicy: AssignmentPolicy['latePolicy']
    scoringPolicy: AssignmentPolicy['scoringPolicy']
  }
  problems: GradebookProblem[]
  students: GradebookStudent[]
}

export interface AdminUser {
  id: number
  username: string
  email: string
  role: Role
  status: AccountStatus
  activeMembershipCount: number
  ownedActiveClassCount: number
  createdAt: string
  roleChangedAt: string
}

export interface AdminUserList {
  total: number
  page: number
  size: number
  users: AdminUser[]
}

export interface ChangeRolePayload {
  role: Role
  archiveOwnedClasses?: boolean
}

export interface ChangeRoleResult {
  id: number
  username: string
  role: Role
  message: string
  archivedClassCount: number
}

export interface ChangeUserStatusResult {
  id: number
  username: string
  status: 'active' | 'disabled'
  message: string
}

export interface DeleteUserResult {
  id: number
  message: string
}

export type InvitationStatus = 'pending' | 'accepted' | 'declined' | 'cancelled' | 'expired'

export interface InviteCandidate {
  userId: number
  username: string
  email: string
  isMember: boolean
  hasPendingInvitation: boolean
}

export interface InvitationSkip {
  userId: number
  username: string
  reason: string
}

export interface CreateInvitationsResult {
  invitedCount: number
  skipped: InvitationSkip[]
  message: string
}

export interface OwnerInvitation {
  id: number
  inviteeId: number
  inviteeUsername: string
  inviteeEmail: string
  status: InvitationStatus
  expiresAt: string
  respondedAt?: string
  createdAt: string
}

export interface MyInvitation {
  id: number
  classId: number
  className: string
  courseName?: string
  term?: string
  inviterId: number
  inviterUsername: string
  status: InvitationStatus
  expiresAt: string
  createdAt: string
}

export interface InvitationMutationResult {
  id: number
  classId: number
  status: InvitationStatus
  message: string
}
