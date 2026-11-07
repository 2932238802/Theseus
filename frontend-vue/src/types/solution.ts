import type { BackendSubmissionStatus, Language } from './oj'

export type SolutionMode = 'server' | 'local'

export interface SolutionLastSubmission {
  id: number
  status: BackendSubmissionStatus
  testCasesPassed: number
  totalTestCases: number
  runtime: number | null
  memory: number | null
  submittedAt: string
}

export interface ProblemSolution {
  /** 前端统一使用字符串 ID，本地解法与云端解法共用一套选择逻辑 */
  id: string
  /** 云端解法 ID，本地模式为空 */
  serverId: number | null
  slot: number
  name: string
  language: Language
  code: string
  createdAt: string
  updatedAt: string
  lastSubmission: SolutionLastSubmission | null
}
