import type { Difficulty, Language, ProblemExample } from '../types/oj'
import type {
  AdminProblemListResult,
  AdminProblemSummary,
  MyProblemListResult,
  MyProblemSummary,
  ProblemEditorPayload,
  ProblemMutationResult,
  ReviewedProblemDetail,
  ReviewProblemResult,
  ReviewStatus,
} from '../types/problemReview'
import { mapCodeTemplate, mapExamples } from './adapters'
import { type ApiEnvelope, unwrap } from './client'
import { http } from './http'

export interface MyProblemQuery {
  page: number
  size: number
  status?: ReviewStatus | 'all'
}

export interface AdminProblemQuery {
  page: number
  size: number
  status?: ReviewStatus | 'all'
  q?: string
}

interface BackendProblemSummary {
  id: number
  title: string
  difficulty: string
  review_status: string
  review_note: string | null
  reviewed_at: string | null
  created_at: string
  updated_at: string
}

interface BackendMyProblemList {
  total: number
  page: number
  size: number
  problems: BackendProblemSummary[]
}

interface BackendAdminProblemSummary extends BackendProblemSummary {
  created_by: number | null
  created_by_username: string | null
}

interface BackendAdminProblemList {
  total: number
  page: number
  size: number
  problems: BackendAdminProblemSummary[]
}

interface BackendReviewedProblemDetail {
  id: number
  title: string
  description: string
  difficulty: string
  time_limit: number
  memory_limit: number
  tags: string[]
  examples: unknown
  test_cases: unknown
  code_template: unknown
  run_config: unknown
  judge_cases: unknown
  acceptance_rate: number
  submit_count: number
  accept_count: number
  review_status: string
  review_note: string | null
  created_by: number | null
  created_by_username: string | null
  reviewed_by: number | null
  reviewed_at: string | null
  created_at: string
  updated_at: string
}

const normalizeDifficulty = (value: string): Difficulty =>
  value === 'easy' || value === 'medium' || value === 'hard' ? value : 'easy'

const normalizeReviewStatus = (value: string): ReviewStatus =>
  value === 'approved' || value === 'rejected' ? value : 'pending'

const mapMyProblem = (problem: BackendProblemSummary): MyProblemSummary => ({
  id: problem.id,
  title: problem.title,
  difficulty: normalizeDifficulty(problem.difficulty),
  reviewStatus: normalizeReviewStatus(problem.review_status),
  reviewNote: problem.review_note,
  reviewedAt: problem.reviewed_at,
  createdAt: problem.created_at,
  updatedAt: problem.updated_at,
})

const mapAdminProblem = (problem: BackendAdminProblemSummary): AdminProblemSummary => ({
  ...mapMyProblem(problem),
  createdBy: problem.created_by,
  createdByUsername: problem.created_by_username,
})

const mapProblemDetail = (problem: BackendReviewedProblemDetail): ReviewedProblemDetail => ({
  id: problem.id,
  title: problem.title,
  description: problem.description ?? '',
  difficulty: normalizeDifficulty(problem.difficulty),
  timeLimit: problem.time_limit,
  memoryLimit: problem.memory_limit,
  tags: Array.isArray(problem.tags) ? problem.tags : [],
  examples: mapExamples(problem.examples),
  testCases: problem.test_cases,
  codeTemplate: mapCodeTemplate(problem.code_template),
  runConfig: problem.run_config,
  judgeCases: problem.judge_cases,
  acceptanceRate: Number(problem.acceptance_rate) || 0,
  submitCount: problem.submit_count,
  acceptCount: problem.accept_count,
  reviewStatus: normalizeReviewStatus(problem.review_status),
  reviewNote: problem.review_note,
  createdBy: problem.created_by,
  createdByUsername: problem.created_by_username,
  reviewedBy: problem.reviewed_by,
  reviewedAt: problem.reviewed_at,
  createdAt: problem.created_at,
  updatedAt: problem.updated_at,
})

const buildListParams = (query: MyProblemQuery | AdminProblemQuery): Record<string, string | number> => {
  const params: Record<string, string | number> = {
    page: query.page,
    size: query.size,
  }
  if (query.status && query.status !== 'all') params.status = query.status
  if ('q' in query && query.q) params.q = query.q
  return params
}

const toProblemRequest = (payload: ProblemEditorPayload): Record<string, unknown> => ({
  title: payload.title,
  description: payload.description,
  difficulty: payload.difficulty,
  time_limit: payload.timeLimit,
  memory_limit: payload.memoryLimit,
  tags: payload.tags,
  examples: payload.examples,
  test_cases: payload.testCases ?? [],
  run_config: payload.runConfig ?? null,
  judge_cases: payload.judgeCases ?? null,
})

export const fetchMyProblems = async (query: MyProblemQuery): Promise<MyProblemListResult> => {
  const data = await unwrap(
    http.get<ApiEnvelope<BackendMyProblemList>>('/problems/mine', {
      params: buildListParams(query),
    }),
  )
  return {
    total: data.total,
    page: data.page,
    size: data.size,
    problems: Array.isArray(data.problems) ? data.problems.map(mapMyProblem) : [],
  }
}

export const fetchMyProblem = async (id: number): Promise<ReviewedProblemDetail> => {
  const data = await unwrap(
    http.get<ApiEnvelope<BackendReviewedProblemDetail>>(`/problems/mine/${id}`),
  )
  return mapProblemDetail(data)
}

export const createMyProblem = async (
  payload: ProblemEditorPayload,
): Promise<ProblemMutationResult> => {
  return unwrap(
    http.post<ApiEnvelope<ProblemMutationResult>>('/problems/custom', toProblemRequest(payload)),
  )
}

export const updateMyProblem = async (
  id: number,
  payload: ProblemEditorPayload,
): Promise<ProblemMutationResult> => {
  return unwrap(
    http.put<ApiEnvelope<ProblemMutationResult>>(
      `/problems/mine/${id}`,
      toProblemRequest(payload),
    ),
  )
}

export const fetchAdminProblems = async (
  query: AdminProblemQuery,
): Promise<AdminProblemListResult> => {
  const data = await unwrap(
    http.get<ApiEnvelope<BackendAdminProblemList>>('/admin/problems', {
      params: buildListParams(query),
    }),
  )
  return {
    total: data.total,
    page: data.page,
    size: data.size,
    problems: Array.isArray(data.problems) ? data.problems.map(mapAdminProblem) : [],
  }
}

export const fetchAdminProblem = async (id: number): Promise<ReviewedProblemDetail> => {
  const data = await unwrap(
    http.get<ApiEnvelope<BackendReviewedProblemDetail>>(`/admin/problems/${id}`),
  )
  return mapProblemDetail(data)
}

export const updateAdminProblem = async (
  id: number,
  payload: ProblemEditorPayload,
): Promise<ProblemMutationResult> => {
  return unwrap(
    http.put<ApiEnvelope<ProblemMutationResult>>(
      `/admin/problems/${id}`,
      toProblemRequest(payload),
    ),
  )
}

export const reviewAdminProblem = async (
  id: number,
  status: 'approved' | 'rejected',
  note: string | null,
): Promise<ReviewProblemResult> => {
  return unwrap(
    http.put<ApiEnvelope<ReviewProblemResult>>(`/admin/problems/${id}/review`, {
      status,
      note,
    }),
  )
}

export type { ProblemExample, Language }
