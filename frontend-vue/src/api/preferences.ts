import { type ApiEnvelope, unwrap } from './client'
import { http } from './http'
import { record } from './parse'

const preferencesFrom = (value: unknown): Record<string, unknown> =>
  record(record(value).preferences)

export const fetchPreferences = async (): Promise<Record<string, unknown>> => {
  const data = await unwrap(http.get<ApiEnvelope<unknown>>('/profile/preferences'))
  return preferencesFrom(data)
}

export const savePreferences = async (
  preferences: Record<string, unknown>,
): Promise<Record<string, unknown>> => {
  const data = await unwrap(
    http.put<ApiEnvelope<unknown>>('/profile/preferences', { preferences }),
  )
  return preferencesFrom(data)
}

export const clearPreferences = async (): Promise<void> => {
  await unwrap(http.delete<ApiEnvelope<unknown>>('/profile/preferences'))
}

export const deletePreference = async (key: string): Promise<Record<string, unknown>> => {
  const data = await unwrap(
    http.delete<ApiEnvelope<unknown>>(`/profile/preferences/${encodeURIComponent(key)}`),
  )
  return preferencesFrom(data)
}
