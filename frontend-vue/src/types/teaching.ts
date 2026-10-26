export type Role = 'student' | 'teacher' | 'admin'

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
  accepted: boolean
  lastStatus?: string
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
  now: string
  isOwner: boolean
  canSubmit: boolean
  problems: AssignmentProblem[]
  totalScore?: number
  overallFeedback?: string
  studentCount?: number
  submittedStudentCount?: number
}

export interface AssignmentProblemInput {
  problemId: number
  points: number
}

export interface GradebookCell {
  problemId: number
  attempts: number
  accepted: boolean
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
  }
  problems: GradebookProblem[]
  students: GradebookStudent[]
}

export interface AdminUser {
  id: number
  username: string
  email: string
  role: Role
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
