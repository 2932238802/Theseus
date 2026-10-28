import { onBeforeUnmount, onMounted, ref, watch, type Ref } from 'vue'
import type { ContestEventInput } from '../types/contest'
import { getToken } from './session'

const FLUSH_INTERVAL_MS = 10_000
const MAX_QUEUE_LENGTH = 200
const MAX_EVENTS_PER_BATCH = 100

interface QueuedContestEvent {
  contestId: number
  event: ContestEventInput
}

export interface ContestEventsController {
  sessionId: string
  flushNow: (keepalive?: boolean) => Promise<void>
  report: (eventType: string, payload?: Record<string, unknown>) => void
}

const randomId = (): string => {
  const cryptoApi = globalThis.crypto
  if (cryptoApi && typeof cryptoApi.randomUUID === 'function') return cryptoApi.randomUUID()
  return `${Date.now().toString(36)}-${Math.random().toString(36).slice(2, 10)}`
}

const apiBaseUrl = (): string =>
  (import.meta.env.VITE_API_BASE_URL ?? '/api').replace(/\/+$/, '')

export const useContestEvents = (
  contestId: Ref<number | null>,
  enabled?: Ref<boolean>,
): ContestEventsController => {
  const sessionId = randomId()
  const queue = ref<QueuedContestEvent[]>([])
  const isEnabled = (): boolean => enabled?.value ?? true

  let flushing = false
  let intervalId: number | null = null

  const trimQueue = (): void => {
    if (queue.value.length > MAX_QUEUE_LENGTH) {
      queue.value = queue.value.slice(queue.value.length - MAX_QUEUE_LENGTH)
    }
  }

  const buildEvent = (
    eventType: string,
    payload?: Record<string, unknown>,
  ): ContestEventInput => ({
    event_id: randomId(),
    event_type: eventType,
    client_time: new Date().toISOString(),
    session_id: sessionId,
    ...(payload ? { payload } : {}),
  })

  const report = (eventType: string, payload?: Record<string, unknown>): void => {
    const id = contestId.value
    if (!isEnabled() || id === null) return
    queue.value.push({ contestId: id, event: buildEvent(eventType, payload) })
    trimQueue()
  }

  const postEvents = async (
    id: number,
    events: ContestEventInput[],
    keepalive: boolean,
  ): Promise<boolean> => {
    try {
      const token = getToken()
      const headers: Record<string, string> = { 'Content-Type': 'application/json' }
      if (token) headers.Authorization = `Bearer ${token}`
      const response = await fetch(`${apiBaseUrl()}/contests/${id}/events`, {
        method: 'POST',
        headers,
        body: JSON.stringify({ events }),
        keepalive,
      })
      return response.ok
    } catch {
      return false
    }
  }

  const flushNow = async (keepalive = false): Promise<void> => {
    if (flushing || !queue.value.length) return
    const pending = queue.value.splice(0, queue.value.length)
    flushing = true
    const failed: QueuedContestEvent[] = []
    try {
      const groups = new Map<number, ContestEventInput[]>()
      for (const item of pending) {
        const events = groups.get(item.contestId)
        if (events) events.push(item.event)
        else groups.set(item.contestId, [item.event])
      }
      for (const [id, events] of groups) {
        for (let index = 0; index < events.length; index += MAX_EVENTS_PER_BATCH) {
          const batch = events.slice(index, index + MAX_EVENTS_PER_BATCH)
          const delivered = await postEvents(id, batch, keepalive)
          if (!delivered) {
            failed.push(...batch.map((event) => ({ contestId: id, event })))
          }
        }
      }
    } finally {
      // 网络或服务端异常时把失败的批次放回队列，等下一次定时补发。
      if (failed.length) {
        queue.value = [...failed, ...queue.value]
        trimQueue()
      }
      flushing = false
    }
  }

  const onVisibilityChange = (): void => {
    if (!isEnabled()) return
    report(
      document.visibilityState === 'hidden' ? 'visibility_hidden' : 'visibility_visible',
    )
  }

  const onPaste = (): void => {
    // 只记录粘贴动作的次数，绝不读取剪贴板内容。
    report('paste', { count: 1 })
  }

  const onPageHide = (): void => {
    void flushNow(true)
  }

  const onInterval = (): void => {
    if (!queue.value.length) return
    void flushNow(false)
  }

  watch(
    () => enabled?.value ?? true,
    (value, previous) => {
      if (previous && !value) void flushNow(false)
    },
  )

  onMounted(() => {
    document.addEventListener('visibilitychange', onVisibilityChange)
    document.addEventListener('paste', onPaste)
    window.addEventListener('pagehide', onPageHide)
    intervalId = window.setInterval(onInterval, FLUSH_INTERVAL_MS)
  })

  onBeforeUnmount(() => {
    void flushNow(true)
    document.removeEventListener('visibilitychange', onVisibilityChange)
    document.removeEventListener('paste', onPaste)
    window.removeEventListener('pagehide', onPageHide)
    if (intervalId !== null) {
      window.clearInterval(intervalId)
      intervalId = null
    }
  })

  return { sessionId, flushNow, report }
}
