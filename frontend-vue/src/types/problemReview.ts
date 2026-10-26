import type { Difficulty, Language, ProblemExample } from './oj'

export type ReviewStatus = 'pending' | 'approved' | 'rejected'

export interface MyProblemSummary {
  id: number
  title: string
  difficulty: Difficulty
  reviewStatus: ReviewStatus
  reviewNote: string | null
  reviewedAt: string | null
  createdAt: string
  updatedAt: string
}

export interface MyProblemListResult {
  total: number
  page: number
  size: number
  problems: MyProblemSummary[]
}

export interface AdminProblemSummary {
  id: number
  title: string
  difficulty: Difficulty
  createdBy: number | null
  createdByUsername: string | null
  reviewStatus: ReviewStatus
  reviewNote: string | null
  reviewedAt: string | null
  createdAt: string
  updatedAt: string
}

export interface AdminProblemListResult {
  total: number
  page: number
  size: number
  problems: AdminProblemSummary[]
}

export interface ReviewedProblemDetail {
  id: number
  title: string
  description: string
  difficulty: Difficulty
  timeLimit: number
  memoryLimit: number
  tags: string[]
  examples: ProblemExample[]
  testCases: unknown
  codeTemplate: Partial<Record<Language, string>>
  runConfig: unknown
  judgeCases: unknown
  acceptanceRate: number
  submitCount: number
  acceptCount: number
  reviewStatus: ReviewStatus
  reviewNote: string | null
  createdBy: number | null
  createdByUsername: string | null
  reviewedBy: number | null
  reviewedAt: string | null
  createdAt: string
  updatedAt: string
}

export interface ProblemEditorPayload {
  title: string
  description: string
  difficulty: Difficulty
  timeLimit: number
  memoryLimit: number
  tags: string[]
  examples: ProblemExample[]
  testCases: unknown
  runConfig: unknown
  judgeCases: unknown
}

export interface ProblemMutationResult {
  id: number
  message: string
}

export interface ReviewProblemResult {
  id: number
  message: string
}
