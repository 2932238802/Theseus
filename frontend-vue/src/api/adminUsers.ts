import type { AdminUserList, ChangeRolePayload, ChangeRoleResult, Role } from '../types/teaching'
import { type ApiEnvelope, unwrap } from './client'
import {
  type BackendAdminUserList,
  mapAdminUserList,
} from './teachingAdapters'
import { http } from './http'

export interface AdminUserQuery {
  q?: string
  role?: Role | ''
  page?: number
  size?: number
}

export const fetchAdminUsers = async (query: AdminUserQuery): Promise<AdminUserList> => {
  const params: Record<string, string | number> = {}
  if (query.q) params.q = query.q
  if (query.role) params.role = query.role
  if (query.page) params.page = query.page
  if (query.size) params.size = query.size
  const data = await unwrap(http.get<ApiEnvelope<BackendAdminUserList>>('/admin/users', { params }))
  return mapAdminUserList(data)
}

export const changeUserRole = async (
  userId: number,
  payload: ChangeRolePayload,
): Promise<ChangeRoleResult> => {
  const data = await unwrap(
    http.put<
      ApiEnvelope<{
        id: number
        username: string
        role: Role
        message: string
        archived_class_count: number
      }>
    >(`/admin/users/${userId}/role`, {
      role: payload.role,
      archive_owned_classes: payload.archiveOwnedClasses ?? false,
    }),
  )
  return {
    id: data.id,
    username: data.username,
    role: data.role,
    message: data.message,
    archivedClassCount: data.archived_class_count,
  }
}
