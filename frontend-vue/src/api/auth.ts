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

interface AuthMessageData {
  message: string
}

interface ResendVerificationData {
  message: string
  email: string
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

export const verifyEmail = async (token: string): Promise<string> => {
  const data = await unwrap(http.post<ApiEnvelope<AuthMessageData>>('/auth/verify-email', { token }))
  return data.message
}

export const resendVerification = async (): Promise<ResendVerificationData> =>
  unwrap(http.post<ApiEnvelope<ResendVerificationData>>('/auth/verify-email/resend'))

export const forgotPassword = async (email: string): Promise<string> => {
  const data = await unwrap(
    http.post<ApiEnvelope<AuthMessageData>>('/auth/forgot-password', { email }),
  )
  return data.message
}

export const resetPassword = async (token: string, password: string): Promise<string> => {
  const data = await unwrap(
    http.post<ApiEnvelope<AuthMessageData>>('/auth/reset-password', { token, password }),
  )
  return data.message
}

export const fetchCurrentUser = async (): Promise<User> => {
  const data = await unwrap(http.get<ApiEnvelope<BackendUser>>('/auth/me'))
  return mapUser(data)
}
