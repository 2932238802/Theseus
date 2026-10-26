import { defineStore } from 'pinia'
import { ref } from 'vue'
import { toErrorMessage } from '../api/client'
import {
  fetchNotifications,
  fetchUnreadCount,
  markAllNotificationsRead,
  markNotificationRead,
} from '../api/notifications'
import type { ForumNotification } from '../types/forum'

const POLL_INTERVAL_MS = 60_000

export const useNotificationStore = defineStore('notifications', () => {
  const notifications = ref<ForumNotification[]>([])
  const total = ref(0)
  const unread = ref(0)
  const page = ref(1)
  const size = ref(20)
  const isLoading = ref(false)
  const error = ref('')

  let timer: number | undefined
  let visibilityHandler: (() => void) | undefined
  let sequence = 0
  let unreadSequence = 0

  const refreshUnread = async (): Promise<void> => {
    const requestId = ++unreadSequence
    try {
      const value = await fetchUnreadCount()
      if (requestId === unreadSequence) unread.value = value
    } catch {
      // 未读数轮询失败不打断页面；下一次轮询会重试
    }
  }

  const loadNotifications = async (targetPage = 1, append = false): Promise<void> => {
    const requestId = ++sequence
    isLoading.value = true
    error.value = ''
    try {
      const result = await fetchNotifications({ page: targetPage, size: size.value })
      if (requestId !== sequence) return
      const merged = append
        ? [...notifications.value, ...result.notifications]
        : result.notifications
      notifications.value = Array.from(
        new Map(merged.map((notification) => [notification.id, notification])).values(),
      )
      total.value = result.total
      unread.value = result.unread
      page.value = result.page
    } catch (exception: unknown) {
      if (requestId !== sequence) return
      error.value = toErrorMessage(exception)
      if (!append) notifications.value = []
    } finally {
      if (requestId === sequence) isLoading.value = false
    }
  }

  const markRead = async (id: number): Promise<void> => {
    const item = notifications.value.find((notification) => notification.id === id)
    if (!item || item.read) return
    const actionSequence = sequence
    try {
      await markNotificationRead(id)
      if (actionSequence !== sequence) return
      item.read = true
      unread.value = Math.max(0, unread.value - 1)
    } catch (exception: unknown) {
      if (actionSequence === sequence) error.value = toErrorMessage(exception)
    }
  }

  const markAllRead = async (): Promise<void> => {
    const actionSequence = sequence
    try {
      await markAllNotificationsRead()
      if (actionSequence !== sequence) return
      notifications.value.forEach((notification) => {
        notification.read = true
      })
      unread.value = 0
    } catch (exception: unknown) {
      if (actionSequence === sequence) error.value = toErrorMessage(exception)
    }
  }

  const startPolling = (): void => {
    if (timer !== undefined) return
    void refreshUnread()
    timer = window.setInterval(() => {
      if (document.visibilityState === 'visible') void refreshUnread()
    }, POLL_INTERVAL_MS)
    visibilityHandler = () => {
      if (document.visibilityState === 'visible') void refreshUnread()
    }
    document.addEventListener('visibilitychange', visibilityHandler)
  }

  const stopPolling = (): void => {
    if (timer !== undefined) {
      window.clearInterval(timer)
      timer = undefined
    }
    if (visibilityHandler) {
      document.removeEventListener('visibilitychange', visibilityHandler)
      visibilityHandler = undefined
    }
  }

  const clear = (): void => {
    sequence += 1
    unreadSequence += 1
    stopPolling()
    notifications.value = []
    total.value = 0
    unread.value = 0
    page.value = 1
    error.value = ''
  }

  return {
    notifications,
    total,
    unread,
    page,
    size,
    isLoading,
    error,
    refreshUnread,
    loadNotifications,
    markRead,
    markAllRead,
    startPolling,
    stopPolling,
    clear,
  }
})
