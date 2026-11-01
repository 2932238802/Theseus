import type { User } from '../types/oj'
import type { OAuthBinding, OAuthProvider } from '../types/oauth'
import { type ApiEnvelope, unwrap } from './client'
import { type BackendUser, mapUser } from './adapters'
import { http } from './http'

interface BackendOAuthProvider {
  provider: string
  enabled: boolean
}

interface BackendOAuthProviders {
  providers: BackendOAuthProvider[]
}

interface BackendOAuthBinding {
  provider: string
  login_name: string
  display_name?: string | null
  email?: string | null
  created_at: string
  last_login_at?: string | null
}

interface BackendOAuthBindings {
  bindings: BackendOAuthBinding[]
}

interface BackendOAuthStart {
  authorize_url: string
}

interface BackendOAuthExchange {
  token: string
  user: BackendUser
}

interface BackendOAuthMessage {
  message: string
}

const optionalText = (value?: string | null): string | undefined =>
  value && value.trim() ? value : undefined

const mapBinding = (binding: BackendOAuthBinding): OAuthBinding => ({
  provider: binding.provider,
  loginName: binding.login_name,
  displayName: optionalText(binding.display_name),
  email: optionalText(binding.email),
  createdAt: binding.created_at,
  lastLoginAt: optionalText(binding.last_login_at),
})

export const fetchOAuthProviders = async (): Promise<OAuthProvider[]> => {
  const data = await unwrap(
    http.get<ApiEnvelope<BackendOAuthProviders>>('/auth/oauth/providers'),
  )
  return data.providers.map((provider) => ({
    provider: provider.provider,
    enabled: provider.enabled,
  }))
}

export const startOAuth = async (
  provider: string,
  mode: 'login' | 'bind',
  redirect?: string,
): Promise<string> => {
  const data = await unwrap(
    http.post<ApiEnvelope<BackendOAuthStart>>(`/auth/oauth/${provider}/start`, {
      mode,
      redirect,
    }),
  )
  return data.authorize_url
}

export const exchangeOAuthCode = async (
  code: string,
): Promise<{ token: string; user: User }> => {
  const data = await unwrap(
    http.post<ApiEnvelope<BackendOAuthExchange>>('/auth/oauth/exchange', { code }),
  )
  return { token: data.token, user: mapUser(data.user) }
}

export const fetchOAuthBindings = async (): Promise<OAuthBinding[]> => {
  const data = await unwrap(
    http.get<ApiEnvelope<BackendOAuthBindings>>('/auth/oauth/bindings'),
  )
  return data.bindings.map(mapBinding)
}

export const unbindOAuth = async (provider: string, password: string): Promise<string> => {
  const data = await unwrap(
    http.delete<ApiEnvelope<BackendOAuthMessage>>(`/auth/oauth/${provider}`, {
      data: { password },
    }),
  )
  return data.message
}
