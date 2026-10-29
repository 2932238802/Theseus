import { type ApiEnvelope, unwrap } from './client'
import { http } from './http'
import { number, record, text } from './parse'

export interface RealtimeTicket {
  ticket: string
  expiresInSeconds: number
}

/** 用普通 JWT 换取一次性 WebSocket 连接票据。 */
export const fetchRealtimeTicket = async (): Promise<RealtimeTicket> => {
  const data = await unwrap(http.post<ApiEnvelope<unknown>>('/ws/ticket'))
  const payload = record(data)
  return {
    ticket: text(payload.ticket),
    expiresInSeconds: number(payload.expires_in_seconds, 60),
  }
}
