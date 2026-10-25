import axios from 'axios'
import { clearSession, getToken } from '../utils/session'

export const http = axios.create({
  baseURL: import.meta.env.VITE_API_BASE_URL ?? '/api',
  timeout: 10_000,
})

const isAuthRequest = (url: string | undefined): boolean => Boolean(url?.startsWith('/auth/'))

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
      if (window.location.pathname !== '/login') window.location.assign('/login')
    }
    if (status === 403) {
      window.dispatchEvent(new CustomEvent('theseus:forbidden'))
    }
    return Promise.reject(error)
  },
)
