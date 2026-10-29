import type {
  AdminUser,
  AdminUserList,
  AssignmentDetail,
  AssignmentProblem,
  AssignmentSummary,
  ClassDetail,
  ClassMember,
  ClassSummary,
  Gradebook,
  GradebookCell,
} from '../types/teaching'

export interface BackendClassOwner {
  id: number
  username: string
}

export interface BackendClassMember {
  user_id: number
  username: string
  email: string
  status: 'active' | 'removed'
  joined_at: string
  removed_at: string | null
}

export interface BackendAssignmentSummary {
  id: number
  class_id: number
  title: string
  description: string | null
  status: string
  start_at: string | null
  due_at: string | null
  published_at: string | null
  grades_published_at: string | null
  problem_count: number
  total_points: number
  my_accepted_count: number
  my_attempted_count: number
  student_count?: number
  submitted_student_count?: number
}

export interface BackendClassSummary {
  id: number
  name: string
  course_name: string | null
  term: string | null
  description: string | null
  owner: BackendClassOwner
  relation: 'owner' | 'student'
  member_count: number
  assignment_count: number
  archived_at: string | null
}

export interface BackendClassDetail extends BackendClassSummary {
  created_at: string
  invite_code?: string
  members?: BackendClassMember[]
  assignments: BackendAssignmentSummary[]
}

export interface BackendAssignmentProblem {
  problem_id: number
  title: string
  difficulty: string
  points: number
  position: number
  attempts: number
  attempts_limit: number | null
  attempts_left: number | null
  accepted: boolean
  last_status: string | null
  is_late: boolean
  late_days: number
  late_deduction: number
  exempt: boolean
  exemption_mode: string | null
  solutions_visible: boolean
  solution_md: string | null
  auto_score?: number
  manual_score?: number
  final_score?: number
  feedback?: string
  accepted_student_count?: number
}

export interface BackendAssignmentDetail {
  id: number
  class_id: number
  class_name: string
  title: string
  description: string | null
  status: string
  start_at: string | null
  due_at: string | null
  published_at: string | null
  grades_published_at: string | null
  grades_published: boolean
  late_policy: string
  late_grace_hours: number
  late_penalty_per_day: number
  late_penalty_cap: number
  scoring_policy: string
  score_visibility: string
  allow_peer_code: boolean
  show_class_stats: boolean
  solutions_published: boolean
  solutions_published_at: string | null
  my_deadline: string | null
  now: string
  is_owner: boolean
  can_submit: boolean
  problems: BackendAssignmentProblem[]
  total_score?: number
  overall_feedback?: string
  student_count?: number
  submitted_student_count?: number
  late_student_count?: number
  exempt_count?: number
}

export interface BackendGradebookCell {
  problem_id: number
  attempts: number
  attempts_limit: number | null
  accepted: boolean
  is_late: boolean
  late_days: number
  late_deduction: number
  exempt: boolean
  exemption_mode: string | null
  included_in_total: boolean
  auto_score: number
  manual_score: number | null
  final_score: number
  feedback: string | null
  last_submission_id: number | null
  last_status: string | null
}

export interface BackendGradebookStudent {
  user_id: number
  username: string
  email: string
  status: 'active' | 'removed'
  overall_feedback: string | null
  total_score: number
  problems: BackendGradebookCell[]
}

export interface BackendGradebook {
  assignment: {
    id: number
    title: string
    due_at: string | null
    grades_published_at: string | null
    late_policy: string
    scoring_policy: string
  }
  problems: Array<{ problem_id: number; title: string; points: number }>
  students: BackendGradebookStudent[]
}

export interface BackendAdminUser {
  id: number
  username: string
  email: string
  role: AdminUser['role']
  status: AdminUser['status']
  reputation_score: number
  active_membership_count: number
  owned_active_class_count: number
  created_at: string
  role_changed_at: string
}

export interface BackendAdminUserList {
  total: number
  page: number
  size: number
  users: BackendAdminUser[]
}

const optional = (value: string | null): string | undefined => value ?? undefined

const parseLatePolicy = (value: string): AssignmentDetail['latePolicy'] =>
  value === 'allow' ? 'allow' : 'forbid'

const parseScoringPolicy = (value: string): AssignmentDetail['scoringPolicy'] =>
  value === 'last' || value === 'first_ac' ? value : 'highest'

const parseScoreVisibility = (value: string): AssignmentDetail['scoreVisibility'] =>
  value === 'after_due' || value === 'during' ? value : 'after_publish'

const parseExemptionMode = (value: string | null): AssignmentProblem['exemptionMode'] =>
  value === 'full_score' || value === 'excluded' ? value : undefined

const normalizeStatus = (value: string): AssignmentSummary['status'] =>
  value === 'published' || value === 'archived' ? value : 'draft'

export const mapClassSummary = (row: BackendClassSummary): ClassSummary => ({
  id: row.id,
  name: row.name,
  courseName: optional(row.course_name),
  term: optional(row.term),
  description: optional(row.description),
  owner: { id: row.owner.id, username: row.owner.username },
  relation: row.relation,
  memberCount: row.member_count,
  assignmentCount: row.assignment_count,
  archivedAt: optional(row.archived_at),
})

export const mapClassMember = (row: BackendClassMember): ClassMember => ({
  userId: row.user_id,
  username: row.username,
  email: row.email,
  status: row.status,
  joinedAt: row.joined_at,
  removedAt: optional(row.removed_at),
})

export const mapAssignmentSummary = (row: BackendAssignmentSummary): AssignmentSummary => ({
  id: row.id,
  classId: row.class_id,
  title: row.title,
  description: optional(row.description),
  status: normalizeStatus(row.status),
  startAt: optional(row.start_at),
  dueAt: optional(row.due_at),
  publishedAt: optional(row.published_at),
  gradesPublishedAt: optional(row.grades_published_at),
  problemCount: row.problem_count,
  totalPoints: row.total_points,
  myAcceptedCount: row.my_accepted_count,
  myAttemptedCount: row.my_attempted_count,
  studentCount: row.student_count,
  submittedStudentCount: row.submitted_student_count,
})

export const mapClassDetail = (row: BackendClassDetail): ClassDetail => ({
  ...mapClassSummary(row),
  createdAt: row.created_at,
  inviteCode: row.invite_code,
  members: row.members?.map(mapClassMember),
  assignments: row.assignments.map(mapAssignmentSummary),
})

const mapAssignmentProblem = (row: BackendAssignmentProblem): AssignmentProblem => ({
  problemId: row.problem_id,
  title: row.title,
  difficulty:
    row.difficulty === 'medium' || row.difficulty === 'hard' ? row.difficulty : 'easy',
  points: row.points,
  position: row.position,
  attempts: row.attempts,
  attemptsLimit: row.attempts_limit,
  attemptsLeft: row.attempts_left,
  accepted: row.accepted,
  lastStatus: optional(row.last_status),
  isLate: row.is_late,
  lateDays: row.late_days,
  lateDeduction: row.late_deduction,
  exempt: row.exempt,
  exemptionMode: parseExemptionMode(row.exemption_mode),
  solutionsVisible: row.solutions_visible,
  solutionMd: optional(row.solution_md),
  autoScore: row.auto_score,
  manualScore: row.manual_score,
  finalScore: row.final_score,
  feedback: row.feedback,
  acceptedStudentCount: row.accepted_student_count,
})

export const mapAssignmentDetail = (row: BackendAssignmentDetail): AssignmentDetail => ({
  id: row.id,
  classId: row.class_id,
  className: row.class_name,
  title: row.title,
  description: optional(row.description),
  status: normalizeStatus(row.status),
  startAt: optional(row.start_at),
  dueAt: optional(row.due_at),
  publishedAt: optional(row.published_at),
  gradesPublishedAt: optional(row.grades_published_at),
  gradesPublished: row.grades_published,
  latePolicy: parseLatePolicy(row.late_policy),
  lateGraceHours: row.late_grace_hours,
  latePenaltyPerDay: row.late_penalty_per_day,
  latePenaltyCap: row.late_penalty_cap,
  scoringPolicy: parseScoringPolicy(row.scoring_policy),
  scoreVisibility: parseScoreVisibility(row.score_visibility),
  allowPeerCode: row.allow_peer_code,
  showClassStats: row.show_class_stats,
  solutionsPublished: row.solutions_published,
  solutionsPublishedAt: optional(row.solutions_published_at),
  myDeadline: optional(row.my_deadline),
  now: row.now,
  isOwner: row.is_owner,
  canSubmit: row.can_submit,
  problems: row.problems.map(mapAssignmentProblem),
  totalScore: row.total_score,
  overallFeedback: row.overall_feedback,
  studentCount: row.student_count,
  submittedStudentCount: row.submitted_student_count,
  lateStudentCount: row.late_student_count,
  exemptCount: row.exempt_count,
})

const mapGradebookCell = (row: BackendGradebookCell): GradebookCell => ({
  problemId: row.problem_id,
  attempts: row.attempts,
  attemptsLimit: row.attempts_limit,
  accepted: row.accepted,
  isLate: row.is_late,
  lateDays: row.late_days,
  lateDeduction: row.late_deduction,
  exempt: row.exempt,
  exemptionMode: parseExemptionMode(row.exemption_mode),
  includedInTotal: row.included_in_total,
  autoScore: row.auto_score,
  manualScore: row.manual_score,
  finalScore: row.final_score,
  feedback: row.feedback,
  lastSubmissionId: row.last_submission_id,
  lastStatus: row.last_status,
})

export const mapGradebook = (row: BackendGradebook): Gradebook => ({
  assignment: {
    id: row.assignment.id,
    title: row.assignment.title,
    dueAt: optional(row.assignment.due_at),
    gradesPublishedAt: optional(row.assignment.grades_published_at),
    latePolicy: parseLatePolicy(row.assignment.late_policy),
    scoringPolicy: parseScoringPolicy(row.assignment.scoring_policy),
  },
  problems: row.problems.map((problem) => ({
    problemId: problem.problem_id,
    title: problem.title,
    points: problem.points,
  })),
  students: row.students.map((student) => ({
    userId: student.user_id,
    username: student.username,
    email: student.email,
    status: student.status,
    overallFeedback: student.overall_feedback,
    totalScore: student.total_score,
    problems: student.problems.map(mapGradebookCell),
  })),
})

export const mapAdminUser = (row: BackendAdminUser): AdminUser => ({
  id: row.id,
  username: row.username,
  email: row.email,
  role: row.role,
  status: row.status,
  reputationScore: row.reputation_score,
  activeMembershipCount: row.active_membership_count,
  ownedActiveClassCount: row.owned_active_class_count,
  createdAt: row.created_at,
  roleChangedAt: row.role_changed_at,
})

export const mapAdminUserList = (row: BackendAdminUserList): AdminUserList => ({
  total: row.total,
  page: row.page,
  size: row.size,
  users: row.users.map(mapAdminUser),
})
