import { type ApiEnvelope, unwrap } from './client'
import { http } from './http'
import { number, record, text } from './parse'
import type { LspLanguage } from '../utils/lspClient'

export interface LspTicket {
  ticket: string
  expiresInSeconds: number
  language: LspLanguage
  /** WebSocket 路径，相对于 API 根地址。 */
  path: string
}

/** 用登录 JWT 换取短期语言服务连接票据。 */
export const fetchLspTicket = async (language: LspLanguage): Promise<LspTicket> => {
  const data = await unwrap(
    http.post<ApiEnvelope<unknown>>('/lsp/ticket', { language }),
  )
  const payload = record(data)
  const returned = text(payload.language)
  return {
    ticket: text(payload.ticket),
    expiresInSeconds: number(payload.expires_in_seconds, 60),
    language: returned === 'cpp' || returned === 'python' ? returned : language,
    path: text(payload.path) || '/lsp/ws',
  }
}
