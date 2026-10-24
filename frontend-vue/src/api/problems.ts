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

export const fetchTags = async (): Promise<string[]> => {
  return unwrap(http.get<ApiEnvelope<string[]>>('/problems/tags'))
}
