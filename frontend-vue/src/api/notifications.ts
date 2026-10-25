import { type ApiEnvelope, unwrap } from './client'
import { http } from './http'
import { number, record, text, type UnknownRecord } from './parse'
import type {
  ForumNotification,
  NotificationListQuery,
  NotificationListResult,
} from '../types/forum'

const mapNotification = (value: unknown): ForumNotification => {
  const item = record(value)
  return {
    id: number(item.id),
    type: text(item.type),
    title: text(item.title),
    body: typeof item.body === 'string' ? item.body : null,
    link: typeof item.link === 'string' ? item.link : null,
    read: item.read === true,
    createdAt: text(item.created_at),
  }
}

export const fetchNotifications = async (
  query: NotificationListQuery,
): Promise<NotificationListResult> => {
  const params: Record<string, string | number | boolean> = {
    page: query.page,
    size: query.size,
  }
  if (query.unread_only) params.unread_only = true
  const data = await unwrap(
    http.get<ApiEnvelope<UnknownRecord>>('/notifications', { params }),
  )
  return {
    total: number(data.total),
    unread: number(data.unread),
    page: number(data.page, query.page),
    size: number(data.size, query.size),
    notifications: Array.isArray(data.notifications)
      ? data.notifications.map(mapNotification)
      : [],
  }
}

export const fetchUnreadCount = async (): Promise<number> => {
  const data = await unwrap(
    http.get<ApiEnvelope<UnknownRecord>>('/notifications/unread-count'),
  )
  return number(data.unread)
}

export const markNotificationRead = async (id: number): Promise<void> => {
  await unwrap(http.put<ApiEnvelope<unknown>>(`/notifications/${id}/read`))
}

export const markAllNotificationsRead = async (): Promise<void> => {
  await unwrap(http.put<ApiEnvelope<unknown>>('/notifications/read-all'))
}
