import { fetchRealtimeTicket } from '../api/ws'
import { getToken } from './session'

export type RealtimePayload = Record<string, unknown>
export type RealtimeHandler = (data: RealtimePayload) => void

interface RealtimeMessage {
  id?: number
  type?: string
  data?: unknown
  server_time?: string
}

const handlers = new Map<string, Set<RealtimeHandler>>()
const MAX_RECONNECT_DELAY_MS = 30_000

let socket: WebSocket | null = null
let connecting = false
let manuallyClosed = false
let reconnectTimer: number | null = null
let reconnectAttempts = 0

const emit = (type: string, data: RealtimePayload): void => {
  const subscribers = handlers.get(type)
  if (!subscribers) return
  for (const handler of [...subscribers]) {
    try {
      handler(data)
    } catch (error: unknown) {
      console.error('realtime handler failed', error)
    }
  }
}

const clearReconnectTimer = (): void => {
  if (reconnectTimer !== null) {
    window.clearTimeout(reconnectTimer)
    reconnectTimer = null
  }
}

const scheduleReconnect = (): void => {
  if (manuallyClosed || handlers.size === 0 || !getToken()) return
  if (reconnectTimer !== null) return
  const delay = Math.min(MAX_RECONNECT_DELAY_MS, 1000 * 2 ** Math.min(reconnectAttempts, 5))
  reconnectAttempts += 1
  reconnectTimer = window.setTimeout(() => {
    reconnectTimer = null
    void openRealtime()
  }, delay)
}

const resolveSocketUrl = (ticket: string): string => {
  const base = import.meta.env.VITE_API_BASE_URL ?? '/api'
  const normalized = base.replace(/\/$/, '')
  const url = new URL(
    `${normalized}/ws`,
    /^https?:\/\//.test(normalized) ? undefined : window.location.origin,
  )
  url.protocol = url.protocol === 'https:' ? 'wss:' : 'ws:'
  url.searchParams.set('ticket', ticket)
  return url.toString()
}

const handleMessage = (raw: unknown): void => {
  let message: RealtimeMessage
  try {
    message = JSON.parse(String(raw)) as RealtimeMessage
  } catch {
    return
  }
  if (!message || typeof message.type !== 'string') return
  if (message.type === 'ping') {
    socket?.send(JSON.stringify({ type: 'pong' }))
    return
  }
  emit(message.type, message.data && typeof message.data === 'object' ? (message.data as RealtimePayload) : {})
}

async function openRealtime(): Promise<void> {
  if (socket !== null || connecting || handlers.size === 0) return
  const token = getToken()
  if (!token) return
  connecting = true
  manuallyClosed = false
  try {
    const { ticket } = await fetchRealtimeTicket()
    if (!ticket) throw new Error('empty realtime ticket')
    // 换取票据期间可能已经登出或所有订阅者都取消了。
    if (manuallyClosed || handlers.size === 0 || !getToken()) {
      connecting = false
      return
    }
    const ws = new WebSocket(resolveSocketUrl(ticket))
    socket = ws
    ws.onopen = () => {
      connecting = false
      reconnectAttempts = 0
      ws.send(JSON.stringify({ type: 'hello' }))
    }
    ws.onmessage = (event: MessageEvent) => {
      handleMessage(event.data)
    }
    ws.onerror = () => {
      // 交给 onclose 统一重连。
      ws.close()
    }
    ws.onclose = () => {
      if (socket === ws) socket = null
      connecting = false
      emit('closed', {})
      scheduleReconnect()
    }
  } catch {
    connecting = false
    scheduleReconnect()
  }
}

/** 订阅服务端实时事件；返回取消函数。第一个订阅会自动建立连接。 */
export const onRealtime = (type: string, handler: RealtimeHandler): (() => void) => {
  let subscribers = handlers.get(type)
  if (!subscribers) {
    subscribers = new Set()
    handlers.set(type, subscribers)
  }
  subscribers.add(handler)
  void openRealtime()
  return () => {
    subscribers?.delete(handler)
    if (subscribers && subscribers.size === 0) handlers.delete(type)
    if (handlers.size === 0) closeRealtime()
  }
}

export const closeRealtime = (): void => {
  manuallyClosed = true
  clearReconnectTimer()
  reconnectAttempts = 0
  connecting = false
  const current = socket
  socket = null
  current?.close()
}

/** 登录态失效时由调用方主动断开；之后的订阅会重新连接。 */
export const resetRealtime = (): void => {
  closeRealtime()
}
