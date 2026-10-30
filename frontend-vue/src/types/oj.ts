import type { RunConfig } from './run'

export type Difficulty = 'easy' | 'medium' | 'hard'
export type Language = 'cpp' | 'java' | 'python' | 'javascript'

export type ProblemStatus = 'not_started' | 'attempted' | 'accepted'

export type BackendSubmissionStatus =
  | 'pending'
  | 'judging'
  | 'accepted'
  | 'wrong_answer'
  | 'time_limit_exceeded'
  | 'memory_limit_exceeded'
  | 'runtime_error'
  | 'compile_error'
  | 'internal_error'

export type SubmissionStatus =
  | 'Accepted'
  | 'Wrong Answer'
  | 'Runtime Error'
  | 'Running'
  | 'Time Limit Exceeded'
  | 'Memory Limit Exceeded'
  | 'Compile Error'
  | 'Internal Error'

export interface User {
  id: number
  username: string
  email: string
  role?: string
  avatar?: string
  avatarUrl?: string
  pendingEmail?: string
  createdAt?: string
  emailVerified: boolean
}

export interface ProblemExample {
  input: string
  output: string
  explanation?: string
}

export interface Problem {
  id: number
  /** 题库顺序题号，按已发布题目 id 升序连续编号。 */
  number: number
  title: string
  difficulty: Difficulty
  acceptance: number
  tags: string[]
  status: ProblemStatus
  description: string
  examples: ProblemExample[]
  codeTemplate: Partial<Record<Language, string>>
  runConfig?: RunConfig
  timeLimit: number
  memoryLimit: number
  submitCount: number
  acceptCount: number
  favorited: boolean
}

export interface SubmissionCaseResult {
  index: number
  args: unknown
  expected?: unknown
  actual: unknown
  stdout: string
  stderr: string
  status: string
}

export interface Submission {
  id: number
  problemId: number
  problemTitle: string
  language: Language
  code: string
  status: SubmissionStatus
  rawStatus: BackendSubmissionStatus
  testCasesPassed: number
  totalTestCases: number
  runtime?: string
  memory?: string
  createdAt: string
  finishedAt?: string
  compileOutput?: string
  failedCase?: SubmissionCaseResult
  message?: string
}

export interface ProblemQuery {
  keyword: string
  difficulty: Difficulty | 'all'
  tag: string
  status: ProblemStatus | 'all'
  sortBy: 'id' | 'difficulty' | 'acceptance'
  order: 'asc' | 'desc'
  page: number
  pageSize: number
}

export interface Stats {
  totalProblems: number
  totalSubmissions: number
  acceptedSubmissions: number
}
