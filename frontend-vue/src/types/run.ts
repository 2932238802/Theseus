export type RunMode = 'examples' | 'custom'

export type RunStatus =
  | 'queued'
  | 'compiling'
  | 'running'
  | 'completed'
  | 'compile_error'
  | 'runtime_error'
  | 'time_limit_exceeded'
  | 'memory_limit_exceeded'
  | 'internal_error'

export type RunCaseStatus =
  | 'passed'
  | 'failed'
  | 'runtime_error'
  | 'timeout'
  | 'memory_limit_exceeded'
  | 'internal_error'

export interface RunConfig {
  version: number
  functionName: string
  params: Array<{ name: string; type: string }>
  returnType: string
  compare: { mode: 'exact' | 'double'; epsilon?: number }
  publicCases: Array<{ args: unknown[]; expected: unknown }>
}

export interface RunCase {
  index: number
  args: unknown[]
  expected?: unknown
  actual?: unknown
  stdout: string
  stderr: string
  status: RunCaseStatus
  matched?: boolean
  runtimeMs?: number
  memoryKb?: number
  truncated: boolean
}

export interface RunStatusResponse {
  id: number
  status: RunStatus
  casePassed: number
  caseTotal: number
  errorMessage: string | null
  updatedAt: string
}

export interface RunDetail {
  id: number
  problemId: number | null
  problemTitle: string
  language: string
  mode: RunMode
  code: string
  input: unknown
  status: RunStatus
  casePassed: number
  caseTotal: number
  compileOutput: string | null
  errorMessage: string | null
  runtimeMs: number | null
  memoryKb: number | null
  createdAt: string
  startedAt: string | null
  finishedAt: string | null
  cases: RunCase[]
}

export const isTerminalRunStatus = (status: RunStatus): boolean =>
  status !== 'queued' && status !== 'compiling' && status !== 'running'
