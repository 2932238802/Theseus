import type { Language } from '../types/oj'
import type {
  RunCase,
  RunCaseStatus,
  RunDetail,
  RunListResult,
  RunMode,
  RunStatus,
  RunStatusResponse,
  RunSummary,
} from '../types/run'
import { type ApiEnvelope, unwrap } from './client'
import { http } from './http'

interface BackendCreateRun {
  run_id: number
  status: RunStatus
}

interface BackendRunStatus {
  id: number
  status: RunStatus
  case_passed: number
  case_total: number
  error_message: string | null
  updated_at: string
}

interface BackendRunCase {
  index: number
  args: unknown[]
  expected?: unknown
  actual?: unknown
  stdout?: string
  stderr?: string
  status: RunCaseStatus
  matched?: boolean
  runtime_ms?: number
  memory_kb?: number
  truncated?: boolean
}

interface BackendRunDetail {
  id: number
  problem_id: number | null
  problem_title: string
  language: string
  mode: RunMode
  code: string
  input: unknown
  status: RunStatus
  case_passed: number
  case_total: number
  compile_output: string | null
  error_message: string | null
  runtime_ms: number | null
  memory_kb: number | null
  created_at: string
  started_at: string | null
  finished_at: string | null
  cases: BackendRunCase[]
}

interface BackendRunSummary {
  id: number
  problem_id: number | null
  problem_title: string
  language: string
  mode: RunMode
  status: RunStatus
  case_passed: number
  case_total: number
  created_at: string
}

interface BackendRunList {
  total: number
  page: number
  size: number
  runs: BackendRunSummary[]
}

export interface CreateRunRequest {
  problemId: number
  language: Language
  mode: RunMode
  code: string
  input?: unknown
}

export interface CreatedRun {
  runId: number
  status: RunStatus
}

const mapRunCase = (runCase: BackendRunCase): RunCase => ({
  index: runCase.index,
  args: Array.isArray(runCase.args) ? runCase.args : [],
  expected: runCase.expected,
  actual: runCase.actual,
  stdout: runCase.stdout ?? '',
  stderr: runCase.stderr ?? '',
  status: runCase.status,
  matched: runCase.matched,
  runtimeMs: runCase.runtime_ms,
  memoryKb: runCase.memory_kb,
  truncated: Boolean(runCase.truncated),
})

const mapRunStatus = (status: BackendRunStatus): RunStatusResponse => ({
  id: status.id,
  status: status.status,
  casePassed: status.case_passed,
  caseTotal: status.case_total,
  errorMessage: status.error_message,
  updatedAt: status.updated_at,
})

const mapRunDetail = (run: BackendRunDetail): RunDetail => ({
  id: run.id,
  problemId: run.problem_id,
  problemTitle: run.problem_title,
  language: run.language,
  mode: run.mode,
  code: run.code,
  input: run.input,
  status: run.status,
  casePassed: run.case_passed,
  caseTotal: run.case_total,
  compileOutput: run.compile_output,
  errorMessage: run.error_message,
  runtimeMs: run.runtime_ms,
  memoryKb: run.memory_kb,
  createdAt: run.created_at,
  startedAt: run.started_at,
  finishedAt: run.finished_at,
  cases: Array.isArray(run.cases) ? run.cases.map(mapRunCase) : [],
})

export interface ListRunsParams {
  page?: number
  size?: number
  problemId?: number
}

const mapRunSummary = (run: BackendRunSummary): RunSummary => ({
  id: run.id,
  problemId: run.problem_id,
  problemTitle: run.problem_title,
  language: run.language,
  mode: run.mode,
  status: run.status,
  casePassed: run.case_passed,
  caseTotal: run.case_total,
  createdAt: run.created_at,
})

export const createRun = async (request: CreateRunRequest): Promise<CreatedRun> => {
  const data = await unwrap(
    http.post<ApiEnvelope<BackendCreateRun>>('/runs', {
      problem_id: request.problemId,
      language: request.language,
      mode: request.mode,
      code: request.code,
      input: request.input,
    }),
  )
  return { runId: data.run_id, status: data.status }
}

export const fetchRunStatus = async (id: number): Promise<RunStatusResponse> => {
  const data = await unwrap(
    http.get<ApiEnvelope<BackendRunStatus>>(`/runs/${id}/status`),
  )
  return mapRunStatus(data)
}

export const fetchRun = async (id: number): Promise<RunDetail> => {
  const data = await unwrap(http.get<ApiEnvelope<BackendRunDetail>>(`/runs/${id}`))
  return mapRunDetail(data)
}

export const listRuns = async (params: ListRunsParams = {}): Promise<RunListResult> => {
  const query = new URLSearchParams()
  if (params.page !== undefined) query.set('page', String(params.page))
  if (params.size !== undefined) query.set('size', String(params.size))
  if (params.problemId !== undefined) query.set('problem_id', String(params.problemId))
  const suffix = query.size ? `?${query.toString()}` : ''
  const data = await unwrap(http.get<ApiEnvelope<BackendRunList>>(`/runs${suffix}`))
  return {
    total: data.total,
    page: data.page,
    size: data.size,
    runs: data.runs.map(mapRunSummary),
  }
}

export const deleteRun = async (id: number): Promise<void> => {
  await unwrap(http.delete<ApiEnvelope<unknown>>(`/runs/${id}`))
}
