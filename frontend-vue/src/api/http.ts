import axios from 'axios'
import { clearSession, getToken } from '../utils/session'

export const http = axios.create({
  baseURL: import.meta.env.VITE_API_BASE_URL ?? '/api',
  timeout: 10_000,
})

const isAuthRequest = (url: string | undefined): boolean =>
  Boolean(url?.startsWith('/auth/') && !url.startsWith('/auth/me'))

const isSessionReplaced = (error: unknown): boolean => {
  if (!axios.isAxiosError(error)) return false
  const data = error.response?.data as { error?: unknown } | undefined
  return typeof data?.error === 'string' && data.error.includes('其他设备登录')
}

http.interceptors.request.use((config) => {
  const token = getToken()
  if (token) config.headers.Authorization = `Bearer ${token}`
  return config
})

http.interceptors.response.use(
  (response) => response,
  (error: unknown) => {
    const status = axios.isAxiosError(error) ? error.response?.status : undefined
    const url = axios.isAxiosError(error) ? error.config?.url : undefined
    if (status === 401 && !isAuthRequest(url)) {
      clearSession()
      const target = isSessionReplaced(error) ? '/login?kicked=1' : '/login'
      if (window.location.pathname !== '/login') window.location.assign(target)
    } else if (status === 403) {
      window.dispatchEvent(new CustomEvent('theseus:forbidden'))
    }
    return Promise.reject(error)
  },
)
