import type { Difficulty } from './oj'

export interface WrongProblemItem {
  problemId: number
  title: string
  difficulty: Difficulty
  tags: string[]
  acceptanceRate: number
  attemptCount: number
  lastFailedAt: string
  lastStatus: string
  lastLanguage: string
  lastTestCasesPassed: number
  lastTotalTestCases: number
}

export interface WrongProblemListResult {
  total: number
  page: number
  size: number
  problems: WrongProblemItem[]
}
