export interface AuditLogEntry {
  id: number
  actor_id: number | null
  actor_username: string
  actor_role: string
  action: string
  target_type: string
  target_id: number | null
  summary: string
  before: unknown
  after: unknown
  ip: string | null
  user_agent: string | null
  created_at: string
}

export interface AuditLogListResponse {
  total: number
  page: number
  size: number
  logs: AuditLogEntry[]
}

export interface AuditLogQuery {
  page?: number
  size?: number
  action?: string
  target_type?: string
  actor_id?: number
  q?: string
  from?: string
  to?: string
}

export interface AuditMetaCount {
  value: string
  count: number
}

export interface AuditMetaResponse {
  actions: AuditMetaCount[]
  target_types: AuditMetaCount[]
  total: number
}
