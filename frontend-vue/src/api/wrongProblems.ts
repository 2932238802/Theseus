import type { Difficulty } from '../types/oj'
import type { WrongProblemItem, WrongProblemListResult } from '../types/wrongProblem'
import { type ApiEnvelope, unwrap } from './client'
import { http } from './http'
import { number, record, text } from './parse'

export interface WrongProblemListRequest {
  page: number
  size: number
  difficulty?: string
  tag?: string
  sort?: 'recent' | 'attempts'
}

const mapDifficulty = (value: unknown): Difficulty =>
  value === 'medium' || value === 'hard' ? value : 'easy'

const mapWrongProblem = (value: unknown): WrongProblemItem => {
  const item = record(value)
  return {
    problemId: number(item.problem_id),
    title: text(item.title),
    difficulty: mapDifficulty(item.difficulty),
    tags: Array.isArray(item.tags) ? item.tags.filter((tag): tag is string => typeof tag === 'string') : [],
    acceptanceRate: number(item.acceptance_rate),
    attemptCount: number(item.attempt_count),
    lastFailedAt: text(item.last_failed_at),
    lastStatus: text(item.last_status, 'wrong_answer'),
    lastLanguage: text(item.last_language),
    lastTestCasesPassed: number(item.last_test_cases_passed),
    lastTotalTestCases: number(item.last_total_test_cases),
  }
}

export const fetchWrongProblems = async (
  request: WrongProblemListRequest,
): Promise<WrongProblemListResult> => {
  const params: Record<string, string | number> = {
    page: request.page,
    size: request.size,
  }
  if (request.difficulty) params.difficulty = request.difficulty
  if (request.tag) params.tag = request.tag
  if (request.sort) params.sort = request.sort
  const data = record(
    await unwrap(http.get<ApiEnvelope<unknown>>('/profile/wrong-problems', { params })),
  )
  return {
    total: number(data.total),
    page: number(data.page, request.page),
    size: number(data.size, request.size),
    problems: Array.isArray(data.problems) ? data.problems.map(mapWrongProblem) : [],
  }
}

export const dismissWrongProblem = async (problemId: number): Promise<boolean> => {
  const data = record(
    await unwrap(http.delete<ApiEnvelope<unknown>>(`/profile/wrong-problems/${problemId}`)),
  )
  return data.dismissed === true
}

export const restoreWrongProblem = async (problemId: number): Promise<boolean> => {
  const data = record(
    await unwrap(http.post<ApiEnvelope<unknown>>(`/profile/wrong-problems/${problemId}`)),
  )
  return data.dismissed === true
}
