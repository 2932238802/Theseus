import axios from 'axios'
import { useAuthStore } from '../store/auth'

export const http = axios.create({
  baseURL: import.meta.env.VITE_API_BASE_URL ?? '/api',
  timeout: 10_000,
})

http.interceptors.request.use((config) => {
  const authStore = useAuthStore()
  if (authStore.token) config.headers.Authorization = `Bearer ${authStore.token}`
  return config
})

http.interceptors.response.use(
  (response) => response,
  (error: unknown) => {
    const status = axios.isAxiosError(error) ? error.response?.status : undefined
    if (status === 401) {
      useAuthStore().logout()
      window.location.hash = '#/login'
    }
    return Promise.reject(error)
  },
)
