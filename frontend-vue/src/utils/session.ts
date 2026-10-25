import type { User } from '../types/oj'

export const TOKEN_KEY = 'theseus-token'
export const USER_KEY = 'theseus-user'

const getSessionStorage = (): Storage | null => {
  try {
    return window.sessionStorage
  } catch {
    return null
  }
}

const getLocalStorage = (): Storage | null => {
  try {
    return window.localStorage
  } catch {
    return null
  }
}

export const getToken = (): string => getLocalStorage()?.getItem(TOKEN_KEY) ?? getSessionStorage()?.getItem(TOKEN_KEY) ?? ''

export const getStoredUser = (): User | null => {
  const rawUser = getLocalStorage()?.getItem(USER_KEY) ?? getSessionStorage()?.getItem(USER_KEY)
  if (!rawUser) return null
  try {
    return JSON.parse(rawUser) as User
  } catch {
    clearSession()
    return null
  }
}

export const persistSession = (token: string, user: User, remember: boolean): void => {
  clearSession()
  const storage = remember ? getLocalStorage() : getSessionStorage()
  storage?.setItem(TOKEN_KEY, token)
  storage?.setItem(USER_KEY, JSON.stringify(user))
}

export const updateSessionUser = (user: User): void => {
  for (const storage of [getLocalStorage(), getSessionStorage()]) {
    if (storage?.getItem(TOKEN_KEY)) storage.setItem(USER_KEY, JSON.stringify(user))
  }
}

export const clearSession = (): void => {
  for (const storage of [getLocalStorage(), getSessionStorage()]) {
    storage?.removeItem(TOKEN_KEY)
    storage?.removeItem(USER_KEY)
  }
}
