export type Difficulty = 'easy' | 'medium' | 'hard'
export type SubmissionStatus = 'Accepted' | 'Wrong Answer' | 'Runtime Error' | 'Running'
export type Language = 'cpp' | 'java' | 'python' | 'javascript'

export interface User {
  id: number
  username: string
  email: string
  avatar?: string
}

export interface Problem {
  id: number
  title: string
  difficulty: Difficulty
  acceptance: number
  tags: string[]
  solved?: boolean
  description: string
  inputDescription: string
  outputDescription: string
  examples: Array<{ input: string; output: string; explanation?: string }>
  constraints: string[]
  hints?: string[]
}

export interface Submission {
  id: string
  problemId: number
  problemTitle: string
  language: Language
  code: string
  status: SubmissionStatus
  runtime?: string
  memory?: string
  createdAt: string
  message?: string
}

export interface ProblemQuery {
  keyword: string
  difficulty: Difficulty | 'all'
  tag: string
  sortBy: 'id' | 'difficulty' | 'acceptance'
  order: 'asc' | 'desc'
  page: number
  pageSize: number
}
