import type { Submission } from '../types/oj'
import type {
  AssignmentDetail,
  AssignmentProblemInput,
  AssignmentSummary,
  Gradebook,
} from '../types/teaching'
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
  problems?: AssignmentProblemInput[]
}

interface BackendAssignmentPayload {
  title: string
  description?: string
  start_at?: string
  due_at?: string
  problems?: Array<{ problem_id: number; points: number }>
}

interface BackendProblemInput {
  problem_id: number
  points: number
}

const mapProblemInputs = (problems: AssignmentProblemInput[]): BackendProblemInput[] =>
  problems.map((problem) => ({ problem_id: problem.problemId, points: problem.points }))

const toBackendPayload = (payload: AssignmentPayload): BackendAssignmentPayload => ({
  title: payload.title,
  description: payload.description,
  start_at: payload.startAt,
  due_at: payload.dueAt,
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
