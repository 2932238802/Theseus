import type {
  BackendSubmissionStatus,
  Difficulty,
  Language,
  Problem,
  ProblemExample,
  ProblemStatus,
  Stats,
  Submission,
  SubmissionCaseResult,
  SubmissionStatus,
  User,
} from '../types/oj'
import type { RunConfig } from '../types/run'
import type { RankingEntry, RankingResult } from '../types/ranking'

export interface BackendUser {
  id: number
  username: string
  email: string
  role: string
  grade?: string | null
  avatar_url: string | null
  pending_email: string | null
  created_at: string
  email_verified: boolean
}

export interface BackendProblem {
  id: number
  number?: number
  title: string
  description: string
  difficulty: string
  time_limit: number
  memory_limit: number
  tags: string[]
  examples: unknown
  code_template: unknown
  run_config?: unknown
  acceptance_rate: number
  submit_count: number
  accept_count: number
  status: string | null
  favorited?: boolean
}

export interface BackendProblemList {
  total: number
  page: number
  size: number
  problems: BackendProblem[]
}

export interface BackendSubmission {
  id: number
  problem_id: number
  problem_title: string
  language: string
  code?: string
  status: string
  test_cases_passed: number
  total_test_cases: number
  runtime: number | null
  memory: number | null
  error_message: string | null
  compile_output?: string | null
  failed_case?: unknown
  submitted_at: string
  finished_at?: string | null
}

export interface BackendSubmissionStatusPayload {
  id: number
  status: string
  test_cases_passed: number
  total_test_cases: number
  error_message: string | null
  updated_at: string
}

export interface BackendSubmissionList {
  total: number
  page: number
  size: number
  submissions: BackendSubmission[]
}

export interface BackendStats {
  total_problems: number
  total_submissions: number
  accepted_submissions: number
}

export interface BackendRankingEntry {
  rank: number
  user_id: number
  username: string
  solved: number
  submissions: number
  acceptance_rate: number
}

export interface BackendRankingResult {
  total: number
  page: number
  size: number
  entries: BackendRankingEntry[]
  me: BackendRankingEntry | null
}

const LANGUAGES: Language[] = ['cpp', 'java', 'python', 'javascript']

const STATUS_LABELS: Record<BackendSubmissionStatus, SubmissionStatus> = {
  pending: 'Running',
  judging: 'Running',
  accepted: 'Accepted',
  wrong_answer: 'Wrong Answer',
  time_limit_exceeded: 'Time Limit Exceeded',
  memory_limit_exceeded: 'Memory Limit Exceeded',
  runtime_error: 'Runtime Error',
  compile_error: 'Compile Error',
  internal_error: 'Internal Error',
}

const STATUS_MESSAGES: Record<BackendSubmissionStatus, string> = {
  pending: '正在排队评测',
  judging: '正在评测中',
  accepted: '全部测试用例通过',
  wrong_answer: '输出与预期结果不一致',
  time_limit_exceeded: '运行时间超过题目限制',
  memory_limit_exceeded: '运行内存超过题目限制',
  runtime_error: '程序运行时发生错误',
  compile_error: '代码编译失败',
  internal_error: '评测服务出现异常 请稍后重试',
}

const isRecord = (value: unknown): value is Record<string, unknown> =>
  typeof value === 'object' && value !== null && !Array.isArray(value)

const normalizeDifficulty = (value: string): Difficulty =>
  value === 'easy' || value === 'medium' || value === 'hard' ? value : 'easy'

const normalizeLanguage = (value: string): Language =>
  LANGUAGES.includes(value as Language) ? (value as Language) : 'javascript'

const normalizeProblemStatus = (value: string | null): ProblemStatus =>
  value === 'attempted' || value === 'accepted' ? value : 'not_started'

export const normalizeSubmissionStatus = (value: string): BackendSubmissionStatus =>
  value in STATUS_LABELS ? (value as BackendSubmissionStatus) : 'runtime_error'

export const submissionStatusLabel = (value: BackendSubmissionStatus): SubmissionStatus =>
  STATUS_LABELS[value]

export const submissionStatusMessage = (value: BackendSubmissionStatus): string =>
  STATUS_MESSAGES[value]

export const isTerminalStatus = (value: BackendSubmissionStatus): boolean =>
  value !== 'pending' && value !== 'judging'

export const mapExamples = (value: unknown): ProblemExample[] => {
  if (!Array.isArray(value)) return []
  return value.filter(isRecord).map((example) => ({
    input: typeof example.input === 'string' ? example.input : String(example.input ?? ''),
    output: typeof example.output === 'string' ? example.output : String(example.output ?? ''),
    explanation: typeof example.explanation === 'string' ? example.explanation : undefined,
  }))
}

export const mapCodeTemplate = (value: unknown): Partial<Record<Language, string>> => {
  if (!isRecord(value)) return {}
  const template: Partial<Record<Language, string>> = {}
  for (const language of LANGUAGES) {
    const code = value[language]
    if (typeof code === 'string') template[language] = code
  }
  return template
}

const formatRuntime = (value: number | null): string | undefined =>
  typeof value === 'number' && value >= 0 ? `${value} ms` : undefined

const formatMemory = (value: number | null): string | undefined => {
  if (typeof value !== 'number' || value < 0) return undefined
  return value >= 1024 ? `${(value / 1024).toFixed(1)} MB` : `${value} KB`
}

const mapRunConfig = (value: unknown): RunConfig | undefined => {
  if (!isRecord(value)) return undefined
  const functionName = typeof value.function_name === 'string' ? value.function_name : ''
  const returnType = typeof value.return_type === 'string' ? value.return_type : ''
  if (!functionName || !returnType) return undefined
  const params = Array.isArray(value.params)
    ? value.params.filter(isRecord).flatMap((param) => {
        const name = typeof param.name === 'string' ? param.name : ''
        const type = typeof param.type === 'string' ? param.type : ''
        return name && type ? [{ name, type }] : []
      })
    : []
  const publicCases = Array.isArray(value.public_cases)
    ? value.public_cases.filter(isRecord).flatMap((publicCase) => {
        if (!Array.isArray(publicCase.args)) return []
        return [{ args: publicCase.args, expected: publicCase.expected }]
      })
    : []
  const compare = isRecord(value.compare) ? value.compare : {}
  return {
    version: typeof value.version === 'number' ? value.version : 1,
    functionName,
    params,
    returnType,
    compare: {
      mode: compare.mode === 'double' ? 'double' : 'exact',
      epsilon: typeof compare.epsilon === 'number' ? compare.epsilon : undefined,
    },
    publicCases,
  }
}

export const mapUser = (user: BackendUser): User => ({
  id: user.id,
  username: user.username,
  email: user.email,
  role: user.role,
  grade: user.grade ?? null,
  avatar: user.username.slice(0, 1).toUpperCase(),
  avatarUrl: user.avatar_url ?? undefined,
  pendingEmail: user.pending_email ?? undefined,
  createdAt: user.created_at,
  emailVerified: user.email_verified === true,
})

export const mapProblem = (problem: BackendProblem): Problem => ({
  id: problem.id,
  number: typeof problem.number === 'number' ? problem.number : problem.id,
  title: problem.title,
  difficulty: normalizeDifficulty(problem.difficulty),
  acceptance: Number(problem.acceptance_rate) || 0,
  tags: Array.isArray(problem.tags) ? problem.tags : [],
  status: normalizeProblemStatus(problem.status),
  description: problem.description ?? '',
  examples: mapExamples(problem.examples),
  codeTemplate: mapCodeTemplate(problem.code_template),
  runConfig: mapRunConfig(problem.run_config),
  timeLimit: problem.time_limit,
  memoryLimit: problem.memory_limit,
  submitCount: problem.submit_count,
  acceptCount: problem.accept_count,
  favorited: problem.favorited === true,
})

const mapFailedCase = (value: unknown): SubmissionCaseResult | undefined => {
  if (!isRecord(value)) return undefined
  return {
    index: typeof value.index === 'number' ? value.index : 0,
    args: value.args,
    expected: 'expected' in value ? value.expected : undefined,
    actual: value.actual ?? null,
    stdout: typeof value.stdout === 'string' ? value.stdout : '',
    stderr: typeof value.stderr === 'string' ? value.stderr : '',
    status: typeof value.status === 'string' ? value.status : 'failed',
  }
}

export const mapSubmission = (submission: BackendSubmission): Submission => {
  const rawStatus = normalizeSubmissionStatus(submission.status)
  return {
    id: submission.id,
    problemId: submission.problem_id,
    problemTitle: submission.problem_title,
    language: normalizeLanguage(submission.language),
    code: submission.code ?? '',
    status: STATUS_LABELS[rawStatus],
    rawStatus,
    testCasesPassed: submission.test_cases_passed,
    totalTestCases: submission.total_test_cases,
    runtime: formatRuntime(submission.runtime),
    memory: formatMemory(submission.memory),
    createdAt: submission.submitted_at,
    finishedAt: submission.finished_at ?? undefined,
    compileOutput: submission.compile_output ?? undefined,
    failedCase: mapFailedCase(submission.failed_case),
    message: submission.error_message ?? STATUS_MESSAGES[rawStatus],
  }
}

export const mapStats = (stats: BackendStats): Stats => ({
  totalProblems: stats.total_problems,
  totalSubmissions: stats.total_submissions,
  acceptedSubmissions: stats.accepted_submissions,
})

export const mapRankingEntry = (entry: BackendRankingEntry): RankingEntry => ({
  rank: entry.rank,
  userId: entry.user_id,
  username: entry.username,
  solved: entry.solved,
  submissions: entry.submissions,
  acceptanceRate: Number(entry.acceptance_rate) || 0,
})

export const mapRankingResult = (result: BackendRankingResult): RankingResult => ({
  total: result.total,
  page: result.page,
  size: result.size,
  entries: Array.isArray(result.entries) ? result.entries.map(mapRankingEntry) : [],
  me: result.me ? mapRankingEntry(result.me) : null,
})
