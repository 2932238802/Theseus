import axios from 'axios'
import type {
  AuditLogListResponse,
  AuditLogQuery,
  AuditMetaResponse,
} from '../types/audit'
import { type ApiEnvelope, unwrap } from './client'
import { http } from './http'

const cleanParams = (query: AuditLogQuery): Record<string, string | number> => {
  const params: Record<string, string | number> = {}
  if (query.page) params.page = query.page
  if (query.size) params.size = query.size
  if (query.action) params.action = query.action
  if (query.target_type) params.target_type = query.target_type
  if (query.actor_id) params.actor_id = query.actor_id
  if (query.q) params.q = query.q
  if (query.from) params.from = query.from
  if (query.to) params.to = query.to
  return params
}

export const fetchAuditLogs = async (query: AuditLogQuery = {}): Promise<AuditLogListResponse> =>
  unwrap(http.get<ApiEnvelope<AuditLogListResponse>>('/admin/audit-logs', { params: cleanParams(query) }))

export const fetchAuditMeta = async (): Promise<AuditMetaResponse> =>
  unwrap(http.get<ApiEnvelope<AuditMetaResponse>>('/admin/audit-logs/meta'))

export const exportAuditLogs = async (query: AuditLogQuery = {}): Promise<Blob> => {
  try {
    const response = await http.get<Blob>('/admin/audit-logs/export', {
      params: cleanParams(query),
      responseType: 'blob',
    })
    return response.data
  } catch (error: unknown) {
    // 后端错误仍返回 JSON；blob 响应需要读回文本才能显示具体原因。
    if (axios.isAxiosError(error) && error.response?.data instanceof Blob) {
      const text = await error.response.data.text()
      let message: string | null = null
      try {
        const body = JSON.parse(text) as ApiEnvelope<unknown>
        message = body.error
      } catch {
        message = null
      }
      if (message) throw new Error(message)
    }
    throw error
  }
}
