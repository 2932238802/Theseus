import type { BackendSubmissionStatus, Language, Submission } from '../types/oj'
import { type ApiEnvelope, unwrap } from './client'
import {
  type BackendSubmission,
  type BackendSubmissionList,
  type BackendSubmissionStatusPayload,
  mapSubmission,
  normalizeSubmissionStatus,
} from './adapters'
import { http } from './http'

export interface CreatedSubmission {
  submissionId: number
  status: string
  message: string
}

interface BackendCreatedSubmission {
  submission_id: number
  status: string
  message: string
}

export const createSubmission = async (
  problemId: number,
  language: Language,
  code: string,
  assignmentId?: number,
): Promise<CreatedSubmission> => {
  const data = await unwrap(
    http.post<ApiEnvelope<BackendCreatedSubmission>>('/submissions', {
      problem_id: problemId,
      language,
      code,
      assignment_id: assignmentId,
    }),
  )
  return { submissionId: data.submission_id, status: data.status, message: data.message }
}

export interface SubmissionStatusSnapshot {
  rawStatus: BackendSubmissionStatus
  testCasesPassed: number
  totalTestCases: number
  message?: string
  updatedAt: string
}

export const fetchSubmissionStatus = async (id: number): Promise<SubmissionStatusSnapshot> => {
  const data = await unwrap(
    http.get<ApiEnvelope<BackendSubmissionStatusPayload>>(`/submissions/${id}/status`),
  )
  return {
    rawStatus: normalizeSubmissionStatus(data.status),
    testCasesPassed: data.test_cases_passed,
    totalTestCases: data.total_test_cases,
    message: data.error_message ?? undefined,
    updatedAt: data.updated_at,
  }
}

export const fetchSubmission = async (id: number): Promise<Submission> => {
  const data = await unwrap(http.get<ApiEnvelope<BackendSubmission>>(`/submissions/${id}`))
  return mapSubmission(data)
}

export interface SubmissionListRequest {
  page: number
  size: number
  problemId?: number
}

export interface SubmissionListResult {
  total: number
  page: number
  size: number
  submissions: Submission[]
}

export const fetchSubmissions = async (request: SubmissionListRequest): Promise<SubmissionListResult> => {
  const params: Record<string, number> = { page: request.page, size: request.size }
  if (request.problemId) params.problem_id = request.problemId
  const data = await unwrap(
    http.get<ApiEnvelope<BackendSubmissionList>>('/submissions', { params }),
  )
  return {
    total: data.total,
    page: data.page,
    size: data.size,
    submissions: data.submissions.map(mapSubmission),
  }
}
