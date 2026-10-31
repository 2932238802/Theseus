import type { Difficulty } from './oj'

export interface ProblemNote {
  bodyMd: string
  updatedAt: string
}

export interface ProblemNoteListItem {
  problemId: number
  title: string
  difficulty: Difficulty
  excerpt: string
  updatedAt: string
}

export interface ProblemNoteListResult {
  total: number
  page: number
  size: number
  notes: ProblemNoteListItem[]
}
