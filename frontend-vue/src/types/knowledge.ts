export type KnowledgeCategory = '408' | 'interview'
export type KnowledgeStatus = 'pending' | 'approved' | 'rejected'

export interface KnowledgeArticleSummary {
  id: number
  category: KnowledgeCategory
  title: string
  summary: string
  tags: string[]
  author: string | null
  status: KnowledgeStatus
  created_at: string
  updated_at: string
}

export interface KnowledgeArticleDetail extends KnowledgeArticleSummary {
  content: string | null
  locked: boolean
  is_mine: boolean
  can_edit: boolean
  review_note: string | null
  reviewed_by: string | null
  reviewed_at: string | null
}

export interface KnowledgeList {
  total: number
  page: number
  size: number
  items: KnowledgeArticleSummary[]
  is_plus: boolean
  can_submit: boolean
}

export interface KnowledgeArticleInput {
  category: KnowledgeCategory
  title: string
  summary?: string
  content: string
  tags: string[]
}

export interface KnowledgeArticleUpdateInput {
  title: string
  summary?: string
  content: string
  tags: string[]
}

export interface KnowledgeResolveResult {
  status: KnowledgeStatus
  message: string
}

export interface KnowledgeMutationResult {
  message: string
}
