import { defineStore } from 'pinia'
import { computed, ref } from 'vue'
import { mockApi } from '../api/mock'
import type { User } from '../types/oj'

const TOKEN_KEY = 'theseus-token'
const USER_KEY = 'theseus-user'

const getStoredUser = (): User | null => {
  const rawUser = localStorage.getItem(USER_KEY)
  if (!rawUser) return null
  try {
    return JSON.parse(rawUser) as User
  } catch {
    localStorage.removeItem(USER_KEY)
    return null
  }
}

export const useAuthStore = defineStore('auth', () => {
  const token = ref(localStorage.getItem(TOKEN_KEY) ?? '')
  const user = ref<User | null>(getStoredUser())
  const isLoading = ref(false)
  const error = ref('')
  const isAuthenticated = computed(() => Boolean(token.value && user.value))

  const persistSession = (nextToken: string, nextUser: User, remember = true): void => {
    token.value = nextToken
    user.value = nextUser
    if (remember) {
      localStorage.setItem(TOKEN_KEY, nextToken)
      localStorage.setItem(USER_KEY, JSON.stringify(nextUser))
    }
  }

  const login = async (username: string, password: string, remember: boolean): Promise<void> => {
    isLoading.value = true
    error.value = ''
    try {
      const session = await mockApi.login(username, password)
      persistSession(session.token, session.user, remember)
    } catch (exception: unknown) {
      error.value = exception instanceof Error ? exception.message : '登录失败，请稍后再试。'
      throw exception
    } finally {
      isLoading.value = false
    }
  }

  const register = async (username: string, email: string, password: string): Promise<void> => {
    isLoading.value = true
    error.value = ''
    try {
      const session = await mockApi.register(username, email, password)
      persistSession(session.token, session.user)
    } catch (exception: unknown) {
      error.value = exception instanceof Error ? exception.message : '注册失败，请稍后再试。'
      throw exception
    } finally {
      isLoading.value = false
    }
  }

  const logout = (): void => {
    token.value = ''
    user.value = null
    error.value = ''
    localStorage.removeItem(TOKEN_KEY)
    localStorage.removeItem(USER_KEY)
  }

  return { token, user, isLoading, error, isAuthenticated, login, register, logout }
})
