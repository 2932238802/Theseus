import type {
  AdminUserList,
  ChangeRolePayload,
  ChangeRoleResult,
  ChangeUserStatusResult,
  DeleteUserResult,
  RestoreReputationResult,
  Role,
} from '../types/teaching'
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

export const changeUserStatus = async (
  userId: number,
  status: 'active' | 'disabled',
): Promise<ChangeUserStatusResult> => {
  const data = await unwrap(
    http.put<
      ApiEnvelope<{
        id: number
        username: string
        status: 'active' | 'disabled'
        message: string
      }>
    >(`/admin/users/${userId}/status`, { status }),
  )
  return {
    id: data.id,
    username: data.username,
    status: data.status,
    message: data.message,
  }
}

export const restoreUserReputation = async (
  userId: number,
  score: number,
  note?: string,
): Promise<RestoreReputationResult> => {
  const data = await unwrap(
    http.put<
      ApiEnvelope<{
        id: number
        username: string
        status: RestoreReputationResult['status']
        reputation_score: number
        message: string
      }>
    >(`/admin/users/${userId}/reputation`, { score, note }),
  )
  return {
    id: data.id,
    username: data.username,
    status: data.status,
    reputationScore: data.reputation_score,
    message: data.message,
  }
}

export const deleteAdminUser = async (userId: number): Promise<DeleteUserResult> => {
  const data = await unwrap(
    http.delete<ApiEnvelope<{ id: number; message: string }>>(`/admin/users/${userId}`),
  )
  return {
    id: data.id,
    message: data.message,
  }
}
