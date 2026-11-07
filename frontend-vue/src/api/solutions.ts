import type { BackendSubmissionStatus, Language } from '../types/oj'
import type { ProblemSolution, SolutionLastSubmission } from '../types/solution'
import { type ApiEnvelope, unwrap } from './client'
import { http } from './http'

interface BackendSolutionSubmission {
  id: number
  status: string
  test_cases_passed: number
  total_test_cases: number
  runtime: number | null
  memory: number | null
  submitted_at: string
}

interface BackendSolution {
  id: number
  slot: number
  name: string
  language: string
  code: string
  created_at: string
  updated_at: string
  last_submission: BackendSolutionSubmission | null
}

interface BackendSolutionList {
  max: number
  solutions: BackendSolution[]
}

export interface SolutionListResult {
  max: number
  solutions: ProblemSolution[]
}

const LANGUAGES: Language[] = ['cpp', 'java', 'python', 'javascript']
const KNOWN_STATUSES: BackendSubmissionStatus[] = [
  'pending',
  'judging',
  'accepted',
  'wrong_answer',
  'time_limit_exceeded',
  'memory_limit_exceeded',
  'runtime_error',
  'compile_error',
  'internal_error',
]

const normalizeLanguage = (value: string): Language =>
  LANGUAGES.includes(value as Language) ? (value as Language) : 'cpp'

const normalizeStatus = (value: string): BackendSubmissionStatus =>
  KNOWN_STATUSES.includes(value as BackendSubmissionStatus)
    ? (value as BackendSubmissionStatus)
    : 'runtime_error'

const mapLastSubmission = (
  value: BackendSolutionSubmission | null,
): SolutionLastSubmission | null => {
  if (!value) return null
  return {
    id: value.id,
    status: normalizeStatus(value.status),
    testCasesPassed: value.test_cases_passed,
    totalTestCases: value.total_test_cases,
    runtime: value.runtime,
    memory: value.memory,
    submittedAt: value.submitted_at,
  }
}

export const mapSolution = (value: BackendSolution): ProblemSolution => ({
  id: String(value.id),
  serverId: value.id,
  slot: value.slot,
  name: value.name,
  language: normalizeLanguage(value.language),
  code: value.code,
  createdAt: value.created_at,
  updatedAt: value.updated_at,
  lastSubmission: mapLastSubmission(value.last_submission),
})

const mapList = (value: BackendSolutionList): SolutionListResult => ({
  max: value.max,
  solutions: value.solutions.map(mapSolution),
})

export const fetchProblemSolutions = async (
  problemId: number,
  language: Language,
): Promise<SolutionListResult> => {
  const data = await unwrap(
    http.get<ApiEnvelope<BackendSolutionList>>(`/problems/${problemId}/solutions`, {
      params: { language },
    }),
  )
  return mapList(data)
}

export interface CreateSolutionPayload {
  name?: string
  language: Language
  code?: string
}

export const createProblemSolution = async (
  problemId: number,
  payload: CreateSolutionPayload,
): Promise<ProblemSolution> => {
  const data = await unwrap(
    http.post<ApiEnvelope<BackendSolution>>(`/problems/${problemId}/solutions`, payload),
  )
  return mapSolution(data)
}

export interface UpdateSolutionPayload {
  name?: string
  language?: Language
  code?: string
}

export const updateProblemSolution = async (
  problemId: number,
  solutionId: number,
  payload: UpdateSolutionPayload,
): Promise<ProblemSolution> => {
  const data = await unwrap(
    http.put<ApiEnvelope<BackendSolution>>(
      `/problems/${problemId}/solutions/${solutionId}`,
      payload,
    ),
  )
  return mapSolution(data)
}

export const deleteProblemSolution = async (
  problemId: number,
  solutionId: number,
): Promise<SolutionListResult> => {
  const data = await unwrap(
    http.delete<ApiEnvelope<BackendSolutionList>>(
      `/problems/${problemId}/solutions/${solutionId}`,
    ),
  )
  return mapList(data)
}
