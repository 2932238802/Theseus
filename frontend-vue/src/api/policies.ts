import type {
  AssignmentStatistics,
  OverrideItem,
  OverridePayload,
  PeerSubmission,
  PolicyAudit,
} from '../types/policy'
import { type ApiEnvelope, unwrap } from './client'
import { http } from './http'

interface BackendOverride {
  user_id: number
  username: string
  problem_id: number
  makeup_due_at: string | null
  waive_late_penalty: boolean
  exempt: boolean
  exemption_mode: string | null
  reason: string | null
  created_by: number | null
  created_at: string
  updated_at: string
}

interface BackendOverrideList {
  overrides: BackendOverride[]
}

const optional = (value: string | null): string | undefined => value ?? undefined

const mapOverride = (row: BackendOverride): OverrideItem => ({
  userId: row.user_id,
  username: row.username,
  problemId: row.problem_id,
  makeupDueAt: optional(row.makeup_due_at),
  waiveLatePenalty: row.waive_late_penalty,
  exempt: row.exempt,
  exemptionMode:
    row.exemption_mode === 'full_score' || row.exemption_mode === 'excluded'
      ? row.exemption_mode
      : undefined,
  reason: optional(row.reason),
  createdBy: row.created_by ?? undefined,
  createdAt: row.created_at,
  updatedAt: row.updated_at,
})

interface BackendPolicyAudit {
  id: number
  actor_id: number | null
  actor_username: string | null
  action: string
  before_data: unknown
  after_data: unknown
  reason: string | null
  created_at: string
}

interface BackendStatistics {
  student_count: number
  submitted_student_count: number
  average_score: number
  my_total_score?: number
  my_position_bucket?: AssignmentStatistics['myPositionBucket']
  problems: Array<{
    problem_id: number
    points: number
    accepted_student_count: number
    pass_rate: number
    average_score: number
    exempt_count: number
  }>
}

interface BackendPeerSubmission {
  username: string
  language: string
  submitted_at: string
  code: string
}

interface BackendPeerSubmissionList {
  submissions: BackendPeerSubmission[]
}

export const fetchOverrides = async (assignmentId: number): Promise<OverrideItem[]> => {
  const data = await unwrap(
    http.get<ApiEnvelope<BackendOverrideList>>(`/assignments/${assignmentId}/overrides`),
  )
  return data.overrides.map(mapOverride)
}

export const setOverride = async (
  assignmentId: number,
  userId: number,
  problemId: number,
  payload: OverridePayload,
): Promise<OverrideItem[]> => {
  const data = await unwrap(
    http.put<ApiEnvelope<BackendOverrideList>>(
      `/assignments/${assignmentId}/overrides/${userId}/problems/${problemId}`,
      {
        makeup_due_at: payload.makeupDueAt,
        waive_late_penalty: payload.waiveLatePenalty,
        exempt: payload.exempt,
        exemption_mode: payload.exemptionMode,
        reason: payload.reason,
      },
    ),
  )
  return data.overrides.map(mapOverride)
}

export const deleteOverride = async (
  assignmentId: number,
  userId: number,
  problemId: number,
): Promise<OverrideItem[]> => {
  const data = await unwrap(
    http.delete<ApiEnvelope<BackendOverrideList>>(
      `/assignments/${assignmentId}/overrides/${userId}/problems/${problemId}`,
    ),
  )
  return data.overrides.map(mapOverride)
}

export const publishSolutions = async (
  assignmentId: number,
): Promise<{ solutionsPublishedAt: string }> => {
  const data = await unwrap(
    http.post<ApiEnvelope<{ message: string; solutions_published_at: string }>>(
      `/assignments/${assignmentId}/solutions/publish`,
    ),
  )
  return { solutionsPublishedAt: data.solutions_published_at }
}

export const fetchPolicyAudits = async (assignmentId: number): Promise<PolicyAudit[]> => {
  const data = await unwrap(
    http.get<ApiEnvelope<{ audits: BackendPolicyAudit[] }>>(
      `/assignments/${assignmentId}/policy-audits`,
    ),
  )
  return data.audits.map((row) => ({
    id: row.id,
    actorId: row.actor_id ?? undefined,
    actorUsername: optional(row.actor_username),
    action: row.action,
    beforeData: row.before_data,
    afterData: row.after_data,
    reason: optional(row.reason),
    createdAt: row.created_at,
  }))
}

export const fetchAssignmentStatistics = async (
  assignmentId: number,
): Promise<AssignmentStatistics> => {
  const data = await unwrap(
    http.get<ApiEnvelope<BackendStatistics>>(`/assignments/${assignmentId}/statistics`),
  )
  return {
    studentCount: data.student_count,
    submittedStudentCount: data.submitted_student_count,
    averageScore: data.average_score,
    myTotalScore: data.my_total_score,
    myPositionBucket: data.my_position_bucket,
    problems: data.problems.map((problem) => ({
      problemId: problem.problem_id,
      points: problem.points,
      acceptedStudentCount: problem.accepted_student_count,
      passRate: problem.pass_rate,
      averageScore: problem.average_score,
      exemptCount: problem.exempt_count,
    })),
  }
}

export const fetchPeerSubmissions = async (
  assignmentId: number,
  problemId: number,
): Promise<PeerSubmission[]> => {
  const data = await unwrap(
    http.get<ApiEnvelope<BackendPeerSubmissionList>>(
      `/assignments/${assignmentId}/problems/${problemId}/peer-submissions`,
    ),
  )
  return data.submissions.map((row) => ({
    username: row.username,
    language: row.language,
    submittedAt: row.submitted_at,
    code: row.code,
  }))
}
