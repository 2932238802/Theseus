import { defineStore } from 'pinia'
import { ref } from 'vue'
import { toErrorMessage } from '../api/client'
import { createRun, fetchRun, fetchRunStatus } from '../api/runs'
import type { Language } from '../types/oj'
import {
  isTerminalRunStatus,
  type RunDetail,
  type RunMode,
  type RunStatusResponse,
} from '../types/run'

const POLL_INTERVAL = 800
const POLL_TIMEOUT = 60_000

const wait = (milliseconds: number): Promise<void> =>
  new Promise((resolve) => window.setTimeout(resolve, milliseconds))

export const useRunStore = defineStore('runs', () => {
  const status = ref<RunStatusResponse | null>(null)
  const detail = ref<RunDetail | null>(null)
  const isRunning = ref(false)
  const error = ref('')

  let pollToken = 0

  const stopPolling = (): void => {
    pollToken += 1
  }

  const pollRun = async (id: number): Promise<void> => {
    const token = ++pollToken
    const deadline = Date.now() + POLL_TIMEOUT
    while (Date.now() < deadline) {
      if (token !== pollToken) return
      const next = await fetchRunStatus(id)
      if (token !== pollToken) return
      status.value = next
      if (isTerminalRunStatus(next.status)) {
        detail.value = await fetchRun(id)
        return
      }
      await wait(POLL_INTERVAL)
    }
    if (token === pollToken) {
      throw new Error('运行排队或执行超时，请稍后重试。')
    }
  }

  const run = async (
    problemId: number,
    language: Language,
    code: string,
    mode: RunMode,
    input?: unknown,
  ): Promise<void> => {
    if (isRunning.value) return
    isRunning.value = true
    error.value = ''
    status.value = null
    detail.value = null
    try {
      const created = await createRun({
        problemId,
        language,
        mode,
        code,
        input: mode === 'custom' ? input : undefined,
      })
      status.value = {
        id: created.runId,
        status: created.status,
        casePassed: 0,
        caseTotal: 0,
        errorMessage: null,
        updatedAt: new Date().toISOString(),
      }
      await pollRun(created.runId)
    } catch (exception: unknown) {
      error.value = toErrorMessage(exception)
      throw exception
    } finally {
      isRunning.value = false
    }
  }

  const reset = (): void => {
    stopPolling()
    status.value = null
    detail.value = null
    error.value = ''
  }

  return {
    status,
    detail,
    isRunning,
    error,
    run,
    reset,
    stopPolling,
  }
})
