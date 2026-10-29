import type { AdminEventInput, AdminEventView } from '../types/contest'
import { type ApiEnvelope, unwrap } from './client'
import { http } from './http'

export const fetchAdminEvents = async (): Promise<AdminEventView[]> => {
  const data = await unwrap(http.get<ApiEnvelope<{ events: AdminEventView[] }>>('/admin/events'))
  return data.events
}

export const fetchAdminEvent = async (id: number): Promise<AdminEventView> =>
  unwrap(http.get<ApiEnvelope<AdminEventView>>(`/admin/events/${id}`))

export const createAdminEvent = async (input: AdminEventInput): Promise<AdminEventView> =>
  unwrap(http.post<ApiEnvelope<AdminEventView>>('/admin/events', input))

export const updateAdminEvent = async (
  id: number,
  input: AdminEventInput,
): Promise<AdminEventView> =>
  unwrap(http.put<ApiEnvelope<AdminEventView>>(`/admin/events/${id}`, input))

export interface EventForumSync {
  event_id: number
  forum_post_id: number
  pinned: boolean
  message: string
}

export const syncAdminEventForum = async (id: number): Promise<EventForumSync> =>
  unwrap(http.post<ApiEnvelope<EventForumSync>>(`/admin/events/${id}/forum`))
