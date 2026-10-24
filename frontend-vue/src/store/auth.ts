import { defineStore } from 'pinia'
import { computed, ref } from 'vue'
import { login as loginRequest, register as registerRequest } from '../api/auth'
import { toErrorMessage } from '../api/client'
import type { User } from '../types/oj'
import { clearSession, getStoredUser, getToken, persistSession } from '../utils/session'

export const useAuthStore = defineStore('auth', () => {
  const token = ref(getToken())
  const user = ref<User | null>(getStoredUser())
  const isLoading = ref(false)
  const error = ref('')
  const isAuthenticated = computed(() => Boolean(token.value && user.value))

  const applySession = (nextToken: string, nextUser: User, remember: boolean): void => {
    token.value = nextToken
    user.value = nextUser
    persistSession(nextToken, nextUser, remember)
  }

  const login = async (identifier: string, password: string, remember: boolean): Promise<void> => {
    isLoading.value = true
    error.value = ''
    try {
      const session = await loginRequest(identifier, password)
      applySession(session.token, session.user, remember)
    } catch (exception: unknown) {
      error.value = toErrorMessage(exception)
      throw exception
    } finally {
      isLoading.value = false
    }
  }

  const register = async (username: string, email: string, password: string): Promise<void> => {
    isLoading.value = true
    error.value = ''
    try {
      await registerRequest(username, email, password)
      const session = await loginRequest(username, password)
      applySession(session.token, session.user, true)
    } catch (exception: unknown) {
      error.value = toErrorMessage(exception)
      throw exception
    } finally {
      isLoading.value = false
    }
  }

  const logout = (): void => {
    token.value = ''
    user.value = null
    error.value = ''
    clearSession()
  }

  return { token, user, isLoading, error, isAuthenticated, login, register, logout }
})
