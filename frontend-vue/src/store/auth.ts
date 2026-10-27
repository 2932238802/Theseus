import { defineStore } from 'pinia'
import { computed, ref } from 'vue'
import { fetchCurrentUser, login as loginRequest, register as registerRequest } from '../api/auth'
import { logoutAllDevices } from '../api/profile'
import { toErrorMessage } from '../api/client'
import type { User } from '../types/oj'
import {
  clearSession,
  forgetUsername,
  getStoredUser,
  getToken,
  persistSession,
  rememberUsername,
  updateSessionToken,
  updateSessionUser,
} from '../utils/session'

export const useAuthStore = defineStore('auth', () => {
  const token = ref(getToken())
  const user = ref<User | null>(getStoredUser())
  const isLoading = ref(false)
  const error = ref('')
  const isAuthenticated = computed(() => Boolean(token.value && user.value))
  const role = computed(() => (user.value?.role === 'user' ? 'student' : user.value?.role))
  const isStudent = computed(() => role.value === 'student')
  const isTeacher = computed(() => role.value === 'teacher')
  const isAdmin = computed(() => role.value === 'admin')
  const isEmailVerified = computed(() => user.value?.emailVerified === true)

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
      if (remember) rememberUsername(identifier)
      else forgetUsername()
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
      rememberUsername(username)
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

  const logoutAll = async (): Promise<void> => {
    try {
      await logoutAllDevices()
    } finally {
      logout()
    }
  }

  const updateUser = (nextUser: User): void => {
    user.value = nextUser
    updateSessionUser(nextUser)
  }

  const replaceSession = (nextToken: string, nextUser: User): void => {
    token.value = nextToken
    user.value = nextUser
    updateSessionToken(nextToken)
    updateSessionUser(nextUser)
  }

  const refreshMe = async (): Promise<boolean> => {
    if (!token.value) return false
    try {
      const currentUser = await fetchCurrentUser()
      user.value = currentUser
      updateSessionUser(currentUser)
      return true
    } catch {
      return false
    }
  }

  return {
    token,
    user,
    isLoading,
    error,
    isAuthenticated,
    role,
    isStudent,
    isTeacher,
    isAdmin,
    isEmailVerified,
    login,
    register,
    logout,
    logoutAll,
    updateUser,
    replaceSession,
    refreshMe,
  }
})
