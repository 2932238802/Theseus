import type { User } from '../types/oj'
import { type ApiEnvelope, unwrap } from './client'
import { type BackendUser, mapUser } from './adapters'
import { http } from './http'

interface LoginData {
  token: string
  user: BackendUser
}

interface RegisterData {
  message: string
}

export const login = async (identifier: string, password: string): Promise<{ token: string; user: User }> => {
  const data = await unwrap(
    http.post<ApiEnvelope<LoginData>>('/auth/login', { username: identifier, password }),
  )
  return { token: data.token, user: mapUser(data.user) }
}

export const register = async (username: string, email: string, password: string): Promise<string> => {
  const data = await unwrap(
    http.post<ApiEnvelope<RegisterData>>('/auth/register', { username, email, password }),
  )
  return data.message
}
