import { type ApiEnvelope, unwrap } from './client'
import { http } from './http'

export interface AiChatMessage {
  role: 'user' | 'assistant'
  content: string
}

export interface AiStatus {
  enabled: boolean
  is_plus: boolean
  plus_required: boolean
  contest_locked: boolean
  daily_limit: number
  used_today: number
}

export interface AiReply {
  content: string
  daily_limit: number
  used_today: number
}

export interface AiChatPayload {
  problem_id: number
  language: string
  code: string
  messages: AiChatMessage[]
}

export const fetchAiStatus = async (): Promise<AiStatus> =>
  unwrap(http.get<ApiEnvelope<AiStatus>>('/ai/status'))

export const sendAiMessage = async (payload: AiChatPayload): Promise<AiReply> =>
  unwrap(
    http.post<ApiEnvelope<AiReply>>('/ai/chat', payload, {
      // 模型生成通常需要十几秒，留出比服务端 45 秒更长的余量
      timeout: 70_000,
    }),
  )
