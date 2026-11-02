import { computed, ref } from 'vue'
import { defineStore } from 'pinia'
import { checkIn as postCheckIn, fetchCheckinStatus } from '../api/home'
import type { CheckinResult, CheckinStatus } from '../types/home'
import { useAuthStore } from './auth'

export const useCheckinStore = defineStore('checkin', () => {
  const authStore = useAuthStore()

  const status = ref<CheckinStatus | null>(null)
  const isLoading = ref(false)
  const isChecking = ref(false)

  let loadedUserId: number | null = null
  let inFlight: Promise<void> | null = null

  const streak = computed(() => status.value?.checkin_streak ?? 0)
  const checkedInToday = computed(() => status.value?.checked_in_today ?? false)

  const load = async (force = false): Promise<void> => {
    const userId = authStore.user?.id ?? null
    if (!userId) {
      status.value = null
      loadedUserId = null
      return
    }
    if (!force && loadedUserId === userId) return
    if (inFlight) return inFlight
    if (loadedUserId !== userId) status.value = null
    isLoading.value = true
    inFlight = (async () => {
      try {
        status.value = await fetchCheckinStatus()
        loadedUserId = userId
      } catch {
        // 火苗只用于展示，失败时静默隐藏
      } finally {
        isLoading.value = false
        inFlight = null
      }
    })()
    return inFlight
  }

  const checkIn = async (): Promise<CheckinResult> => {
    isChecking.value = true
    try {
      const result = await postCheckIn()
      status.value = {
        checked_in_today: true,
        reputation_score: result.reputation_score,
        checkin_streak: result.checkin_streak,
      }
      loadedUserId = authStore.user?.id ?? loadedUserId
      return result
    } finally {
      isChecking.value = false
    }
  }

  return {
    status,
    isLoading,
    isChecking,
    streak,
    checkedInToday,
    load,
    checkIn,
  }
})
