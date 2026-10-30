import type { Submission } from '../types/oj'
import type {
  AssignmentDetail,
  AssignmentProblemInput,
  AssignmentSummary,
  Gradebook,
} from '../types/teaching'
import type {
  LatePolicy,
  ScoreVisibility,
  ScoringPolicy,
} from '../types/policy'
import { type ApiEnvelope, unwrap } from './client'
import {
  type BackendAssignmentDetail,
  type BackendAssignmentSummary,
  type BackendGradebook,
  mapAssignmentDetail,
  mapAssignmentSummary,
  mapGradebook,
} from './teachingAdapters'
import { type BackendSubmissionList, mapSubmission } from './adapters'
import { http } from './http'

export interface AssignmentPayload {
  title: string
  description?: string
  startAt?: string
  dueAt?: string
  latePolicy?: LatePolicy
  lateGraceHours?: number
  latePenaltyPerDay?: number
  latePenaltyCap?: number
  maxAttempts?: number | null
  scoringPolicy?: ScoringPolicy
  scoreVisibility?: ScoreVisibility
  allowPeerCode?: boolean
  showClassStats?: boolean
  problems?: AssignmentProblemInput[]
}

interface BackendAssignmentPayload {
  title: string
  description?: string
  start_at?: string
  due_at?: string
  late_policy?: LatePolicy
  late_grace_hours?: number
  late_penalty_per_day?: number
  late_penalty_cap?: number
  max_attempts?: number | null
  scoring_policy?: ScoringPolicy
  score_visibility?: ScoreVisibility
  allow_peer_code?: boolean
  show_class_stats?: boolean
  problems?: BackendProblemInput[]
}

interface BackendProblemInput {
  problem_id: number
  points: number
  max_attempts?: number | null
  solution_md?: string
}

const mapProblemInputs = (problems: AssignmentProblemInput[]): BackendProblemInput[] =>
  problems.map((problem) => ({
    problem_id: problem.problemId,
    points: problem.points,
    max_attempts: problem.maxAttempts,
    solution_md: problem.solutionMd,
  }))

const toBackendPayload = (payload: AssignmentPayload): BackendAssignmentPayload => ({
  title: payload.title,
  description: payload.description,
  start_at: payload.startAt,
  due_at: payload.dueAt,
  late_policy: payload.latePolicy,
  late_grace_hours: payload.lateGraceHours,
  late_penalty_per_day: payload.latePenaltyPerDay,
  late_penalty_cap: payload.latePenaltyCap,
  max_attempts: payload.maxAttempts,
  scoring_policy: payload.scoringPolicy,
  score_visibility: payload.scoreVisibility,
  allow_peer_code: payload.allowPeerCode,
  show_class_stats: payload.showClassStats,
  problems: payload.problems ? mapProblemInputs(payload.problems) : undefined,
})

export const fetchClassAssignments = async (classId: number): Promise<AssignmentSummary[]> => {
  const data = await unwrap(
    http.get<ApiEnvelope<{ assignments: BackendAssignmentSummary[] }>>(
      `/classes/${classId}/assignments`,
    ),
  )
  return data.assignments.map(mapAssignmentSummary)
}

export const createAssignment = async (
  classId: number,
  payload: AssignmentPayload,
): Promise<AssignmentDetail> => {
  const data = await unwrap(
    http.post<ApiEnvelope<BackendAssignmentDetail>>(
      `/classes/${classId}/assignments`,
      toBackendPayload(payload),
    ),
  )
  return mapAssignmentDetail(data)
}

export const fetchAssignment = async (id: number): Promise<AssignmentDetail> => {
  const data = await unwrap(http.get<ApiEnvelope<BackendAssignmentDetail>>(`/assignments/${id}`))
  return mapAssignmentDetail(data)
}

export const updateAssignment = async (
  id: number,
  payload: AssignmentPayload,
): Promise<AssignmentDetail> => {
  const data = await unwrap(
    http.put<ApiEnvelope<BackendAssignmentDetail>>(`/assignments/${id}`, toBackendPayload(payload)),
  )
  return mapAssignmentDetail(data)
}

export const updateAssignmentProblems = async (
  id: number,
  problems: AssignmentProblemInput[],
): Promise<AssignmentDetail> => {
  const data = await unwrap(
    http.put<ApiEnvelope<BackendAssignmentDetail>>(`/assignments/${id}/problems`, {
      problems: mapProblemInputs(problems),
    }),
  )
  return mapAssignmentDetail(data)
}

export const publishAssignment = async (id: number): Promise<AssignmentDetail> => {
  const data = await unwrap(
    http.post<ApiEnvelope<BackendAssignmentDetail>>(`/assignments/${id}/publish`),
  )
  return mapAssignmentDetail(data)
}

export const archiveAssignment = async (id: number): Promise<AssignmentDetail> => {
  const data = await unwrap(
    http.post<ApiEnvelope<BackendAssignmentDetail>>(`/assignments/${id}/archive`),
  )
  return mapAssignmentDetail(data)
}

export const deleteAssignment = async (id: number): Promise<void> => {
  await unwrap(http.delete<ApiEnvelope<{ id: number; message: string }>>(`/assignments/${id}`))
}

export interface AssignmentSubmissionQuery {
  userId?: number
  problemId?: number
  page?: number
  size?: number
}

export interface AssignmentSubmissionResult {
  total: number
  page: number
  size: number
  submissions: Submission[]
}

export const fetchAssignmentSubmissions = async (
  id: number,
  query: AssignmentSubmissionQuery = {},
): Promise<AssignmentSubmissionResult> => {
  const params: Record<string, number> = {}
  if (query.userId) params.user_id = query.userId
  if (query.problemId) params.problem_id = query.problemId
  if (query.page) params.page = query.page
  if (query.size) params.size = query.size
  const data = await unwrap(
    http.get<ApiEnvelope<BackendSubmissionList>>(`/assignments/${id}/submissions`, { params }),
  )
  return {
    total: data.total,
    page: data.page,
    size: data.size,
    submissions: data.submissions.map(mapSubmission),
  }
}

export const fetchGradebook = async (id: number, includeRemoved: boolean): Promise<Gradebook> => {
  const data = await unwrap(
    http.get<ApiEnvelope<BackendGradebook>>(`/assignments/${id}/gradebook`, {
      params: { include_removed: includeRemoved ? 1 : 0 },
    }),
  )
  return mapGradebook(data)
}

export const exportGradebook = async (id: number, includeRemoved: boolean): Promise<Blob> => {
  const response = await http.get<Blob>(`/assignments/${id}/gradebook/export`, {
    params: { include_removed: includeRemoved ? 1 : 0 },
    responseType: 'blob',
  })
  return response.data
}

export const updateProblemGrade = async (
  assignmentId: number,
  userId: number,
  problemId: number,
  manualScore: number | null,
  feedback: string | null,
): Promise<void> => {
  await unwrap(
    http.put<ApiEnvelope<{ message: string }>>(
      `/assignments/${assignmentId}/grades/${userId}/problems/${problemId}`,
      { manual_score: manualScore, feedback },
    ),
  )
}

export const updateOverallGrade = async (
  assignmentId: number,
  userId: number,
  overallFeedback: string | null,
): Promise<void> => {
  await unwrap(
    http.put<ApiEnvelope<{ message: string }>>(`/assignments/${assignmentId}/grades/${userId}`, {
      overall_feedback: overallFeedback,
    }),
  )
}

export const publishGrades = async (id: number): Promise<{ gradesPublishedAt: string }> => {
  const data = await unwrap(
    http.post<ApiEnvelope<{ message: string; grades_published_at: string }>>(
      `/assignments/${id}/grades/publish`,
    ),
  )
  return { gradesPublishedAt: data.grades_published_at }
}
