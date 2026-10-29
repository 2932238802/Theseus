import { reactive } from 'vue'

export type ToastTone = 'success' | 'error' | 'info'

export interface ToastItem {
  id: number
  message: string
  tone: ToastTone
  duration: number
}

const MAX_TOASTS = 3
const DEFAULT_DURATION = 3200

export const toastItems = reactive<ToastItem[]>([])
const timers = new Map<number, number>()
let sequence = 0

export const dismissToast = (id: number): void => {
  const index = toastItems.findIndex((item) => item.id === id)
  if (index >= 0) toastItems.splice(index, 1)
  const timer = timers.get(id)
  if (timer !== undefined) {
    window.clearTimeout(timer)
    timers.delete(id)
  }
}

const push = (message: string, tone: ToastTone, duration = DEFAULT_DURATION): number => {
  const trimmed = message.trim()
  if (!trimmed) return 0
  const duplicate = toastItems.find((item) => item.message === trimmed && item.tone === tone)
  if (duplicate) dismissToast(duplicate.id)
  const id = ++sequence
  toastItems.push({ id, message: trimmed, tone, duration })
  while (toastItems.length > MAX_TOASTS) {
    const oldest = toastItems[0]
    if (oldest) dismissToast(oldest.id)
  }
  timers.set(
    id,
    window.setTimeout(() => dismissToast(id), duration),
  )
  return id
}

export const toast = {
  success: (message: string, duration?: number): number =>
    push(message, 'success', duration),
  error: (message: string, duration?: number): number => push(message, 'error', duration),
  info: (message: string, duration?: number): number => push(message, 'info', duration),
  dismiss: dismissToast,
}
