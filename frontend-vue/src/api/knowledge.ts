import type {
  KnowledgeArticleDetail,
  KnowledgeArticleInput,
  KnowledgeArticleUpdateInput,
  KnowledgeCategory,
  KnowledgeList,
  KnowledgeMutationResult,
  KnowledgeResolveResult,
  KnowledgeStatus,
} from '../types/knowledge'
import { type ApiEnvelope, unwrap } from './client'
import { http } from './http'

interface KnowledgeQuery {
  category?: KnowledgeCategory
  tag?: string
  q?: string
  page?: number
  size?: number
}

interface MyKnowledgeQuery {
  category?: KnowledgeCategory
  status?: KnowledgeStatus
  page?: number
  size?: number
}

interface AdminKnowledgeQuery {
  category?: KnowledgeCategory
  status?: KnowledgeStatus
  q?: string
  page?: number
  size?: number
}

export const fetchKnowledgeArticles = async (
  params: KnowledgeQuery = {},
): Promise<KnowledgeList> =>
  unwrap(http.get<ApiEnvelope<KnowledgeList>>('/knowledge', { params }))

export const fetchKnowledgeArticle = async (
  id: number,
): Promise<KnowledgeArticleDetail> =>
  unwrap(http.get<ApiEnvelope<KnowledgeArticleDetail>>(`/knowledge/${id}`))

export const createKnowledgeArticle = async (
  input: KnowledgeArticleInput,
): Promise<KnowledgeArticleDetail> =>
  unwrap(http.post<ApiEnvelope<KnowledgeArticleDetail>>('/knowledge', input))

export const updateKnowledgeArticle = async (
  id: number,
  input: KnowledgeArticleUpdateInput,
): Promise<KnowledgeArticleDetail> =>
  unwrap(http.put<ApiEnvelope<KnowledgeArticleDetail>>(`/knowledge/${id}`, input))

export const deleteKnowledgeArticle = async (
  id: number,
): Promise<KnowledgeMutationResult> =>
  unwrap(http.delete<ApiEnvelope<KnowledgeMutationResult>>(`/knowledge/${id}`))

export const fetchMyKnowledgeArticles = async (
  params: MyKnowledgeQuery = {},
): Promise<KnowledgeList> =>
  unwrap(http.get<ApiEnvelope<KnowledgeList>>('/knowledge/mine', { params }))

export const fetchAdminKnowledgeArticles = async (
  params: AdminKnowledgeQuery = {},
): Promise<KnowledgeList> =>
  unwrap(http.get<ApiEnvelope<KnowledgeList>>('/admin/knowledge', { params }))

export const resolveAdminKnowledgeArticle = async (
  id: number,
  status: 'approved' | 'rejected',
  note?: string,
): Promise<KnowledgeResolveResult> =>
  unwrap(
    http.post<ApiEnvelope<KnowledgeResolveResult>>(
      `/admin/knowledge/${id}/resolve`,
      { status, note: note || undefined },
    ),
  )
