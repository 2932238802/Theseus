import type { Problem } from '../types/oj'
import { type ApiEnvelope, unwrap } from './client'
import { type BackendProblem, type BackendProblemList, mapProblem } from './adapters'
import { http } from './http'

export interface ProblemListRequest {
  page: number
  size: number
  difficulty?: string
  tag?: string
  status?: string
  search?: string
  sort: string
  order: 'asc' | 'desc'
}

export interface ProblemListResult {
  total: number
  page: number
  size: number
  problems: Problem[]
}

const buildParams = (request: ProblemListRequest): Record<string, string | number> => {
  const params: Record<string, string | number> = {
    page: request.page,
    size: request.size,
    sort: request.sort,
    order: request.order,
  }
  if (request.difficulty) params.difficulty = request.difficulty
  if (request.tag) params.tag = request.tag
  if (request.status) params.status = request.status
  if (request.search) params.search = request.search
  return params
}

export const fetchProblems = async (request: ProblemListRequest): Promise<ProblemListResult> => {
  const data = await unwrap(
    http.get<ApiEnvelope<BackendProblemList>>('/problems', { params: buildParams(request) }),
  )
  return {
    total: data.total,
    page: data.page,
    size: data.size,
    problems: data.problems.map(mapProblem),
  }
}

export const fetchProblem = async (id: number): Promise<Problem> => {
  const data = await unwrap(http.get<ApiEnvelope<BackendProblem>>(`/problems/${id}`))
  return mapProblem(data)
}

export interface ProblemNeighbors {
  total: number
  prevId: number | null
  nextId: number | null
}

export const fetchProblemNeighbors = async (id: number): Promise<ProblemNeighbors> => {
  const data = await unwrap(
    http.get<ApiEnvelope<{ total: number; prev_id: number | null; next_id: number | null }>>(
      `/problems/${id}/neighbors`,
    ),
  )
  return {
    total: Number(data.total) || 0,
    prevId: typeof data.prev_id === 'number' ? data.prev_id : null,
    nextId: typeof data.next_id === 'number' ? data.next_id : null,
  }
}

export interface AddJudgeCaseResult {
  added: boolean
  total: number
}

export const addJudgeCase = async (
  problemId: number,
  args: unknown,
  expected: unknown,
): Promise<AddJudgeCaseResult> =>
  unwrap(
    http.post<ApiEnvelope<AddJudgeCaseResult>>(`/problems/${problemId}/judge-cases`, {
      args,
      expected,
    }),
  )

export const fetchTags = async (): Promise<string[]> => {
  return unwrap(http.get<ApiEnvelope<string[]>>('/problems/tags'))
}
