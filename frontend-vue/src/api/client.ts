import axios, { type AxiosResponse } from 'axios'

export interface ApiEnvelope<T> {
  success: boolean
  data: T | null
  error: string | null
}

export const unwrap = async <T>(request: Promise<AxiosResponse<ApiEnvelope<T>>>): Promise<T> => {
  const response = await request
  const body = response.data
  if (!body.success || body.data === null) {
    throw new Error(body.error ?? '请求失败，请稍后重试。')
  }
  return body.data
}

export const toErrorMessage = (error: unknown): string => {
  if (axios.isAxiosError(error)) {
    const body = error.response?.data as ApiEnvelope<unknown> | undefined
    if (body?.error) {
      if (error.response?.status === 429) {
        const retryAfter = error.response.headers['retry-after']
        const seconds = Number(Array.isArray(retryAfter) ? retryAfter[0] : retryAfter)
        if (Number.isFinite(seconds) && seconds > 0) {
          return `${body.error}（请在 ${Math.ceil(seconds)} 秒后重试）`
        }
      }
      return body.error
    }
    if (error.code === 'ECONNABORTED') return '请求超时，请稍后重试。'
    if (!error.response) return '无法连接服务器，请检查后端是否启动。'
  }
  return error instanceof Error ? error.message : '请求失败，请稍后重试。'
}
