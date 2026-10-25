import { defineStore } from 'pinia'
import { ref } from 'vue'
import { toErrorMessage } from '../api/client'
import { createRun, deleteRun, fetchRun, fetchRunStatus, listRuns } from '../api/runs'
import type { Language } from '../types/oj'
import {
  isTerminalRunStatus,
  type RunDetail,
  type RunMode,
  type RunStatusResponse,
  type RunSummary,
} from '../types/run'

const POLL_INTERVAL = 800
// Backend reaps queued runs after 90s and stuck running runs after 300s by
// default; keep polling past that so the reaped terminal status is visible.
const POLL_TIMEOUT = 330_000

const wait = (milliseconds: number): Promise<void> =>
  new Promise((resolve) => window.setTimeout(resolve, milliseconds))

export const useRunStore = defineStore('runs', () => {
  const status = ref<RunStatusResponse | null>(null)
  const detail = ref<RunDetail | null>(null)
  const isRunning = ref(false)
  const error = ref('')
  const records = ref<RunSummary[]>([])
  const recordsTotal = ref(0)
  const recordsPage = ref(1)
  const recordsSize = ref(20)
  const recordsLoading = ref(false)
  const recordsError = ref('')

  let pollToken = 0
  let recordsRequestSequence = 0

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
      throw new Error('运行仍未结束，请稍后刷新运行记录查看结果。')
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

  const loadRecords = async (options?: {
    page?: number
    size?: number
    problemId?: number
  }): Promise<void> => {
    const requestId = ++recordsRequestSequence
    recordsLoading.value = true
    recordsError.value = ''
    try {
      const result = await listRuns({
        page: options?.page ?? recordsPage.value,
        size: options?.size ?? recordsSize.value,
        problemId: options?.problemId,
      })
      if (requestId !== recordsRequestSequence) return
      records.value = result.runs
      recordsTotal.value = result.total
      recordsPage.value = result.page
      recordsSize.value = result.size
    } catch (exception: unknown) {
      if (requestId !== recordsRequestSequence) return
      recordsError.value = toErrorMessage(exception)
    } finally {
      if (requestId === recordsRequestSequence) recordsLoading.value = false
    }
  }

  const loadDetail = async (id: number): Promise<RunDetail> => {
    const record = await fetchRun(id)
    detail.value = record
    return record
  }

  const removeRecord = async (id: number): Promise<void> => {
    await deleteRun(id)
    records.value = records.value.filter((record) => record.id !== id)
    recordsTotal.value = Math.max(0, recordsTotal.value - 1)
    if (detail.value?.id === id) detail.value = null
  }

  return {
    status,
    detail,
    isRunning,
    error,
    records,
    recordsTotal,
    recordsPage,
    recordsSize,
    recordsLoading,
    recordsError,
    run,
    loadRecords,
    loadDetail,
    removeRecord,
    reset,
    stopPolling,
  }
})
