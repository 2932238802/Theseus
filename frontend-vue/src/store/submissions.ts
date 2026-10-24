import { defineStore } from 'pinia'
import { ref } from 'vue'
import { toErrorMessage } from '../api/client'
import { isTerminalStatus } from '../api/adapters'
import { createSubmission, fetchSubmission, fetchSubmissions } from '../api/submissions'
import type { Language, Submission } from '../types/oj'

const POLL_INTERVAL = 1000
const POLL_TIMEOUT = 60_000

const wait = (milliseconds: number): Promise<void> =>
  new Promise((resolve) => window.setTimeout(resolve, milliseconds))

export const useSubmissionStore = defineStore('submissions', () => {
  const submissions = ref<Submission[]>([])
  const total = ref(0)
  const page = ref(1)
  const size = ref(20)
  const isSubmitting = ref(false)
  const isLoading = ref(false)
  const error = ref('')
  const latest = ref<Submission | null>(null)

  let pollToken = 0
  let listRequestSequence = 0

  const stopPolling = (): void => {
    pollToken += 1
  }

  const pollSubmission = async (id: number): Promise<Submission | null> => {
    const token = ++pollToken
    const deadline = Date.now() + POLL_TIMEOUT
    let current: Submission | null = null
    while (Date.now() < deadline) {
      if (token !== pollToken) return current
      current = await fetchSubmission(id)
      latest.value = current
      if (isTerminalStatus(current.rawStatus)) return current
      await wait(POLL_INTERVAL)
    }
    if (token !== pollToken) return current
    throw new Error('评测超时，请稍后在个人中心查看结果。')
  }

  const submit = async (problemId: number, language: Language, code: string): Promise<Submission | null> => {
    isSubmitting.value = true
    error.value = ''
    try {
      const created = await createSubmission(problemId, language, code)
      latest.value = {
        id: created.submissionId,
        problemId,
        problemTitle: '',
        language,
        code,
        status: 'Running',
        rawStatus: 'pending',
        testCasesPassed: 0,
        totalTestCases: 0,
        createdAt: new Date().toISOString(),
        message: created.message,
      }
      const final = await pollSubmission(created.submissionId)
      if (final && isTerminalStatus(final.rawStatus)) {
        latest.value = final
        submissions.value = [final, ...submissions.value.filter((item) => item.id !== final.id)]
        total.value += 1
      }
      return final
    } catch (exception: unknown) {
      error.value = toErrorMessage(exception)
      throw exception
    } finally {
      isSubmitting.value = false
    }
  }

  const loadSubmissions = async (options?: {
    page?: number
    size?: number
    problemId?: number
  }): Promise<void> => {
    const requestId = ++listRequestSequence
    isLoading.value = true
    error.value = ''
    try {
      const result = await fetchSubmissions({
        page: options?.page ?? page.value,
        size: options?.size ?? size.value,
        problemId: options?.problemId,
      })
      if (requestId !== listRequestSequence) return
      submissions.value = result.submissions
      total.value = result.total
      page.value = result.page
      size.value = result.size
    } catch (exception: unknown) {
      if (requestId !== listRequestSequence) return
      error.value = toErrorMessage(exception)
    } finally {
      if (requestId === listRequestSequence) isLoading.value = false
    }
  }

  const reset = (): void => {
    stopPolling()
    submissions.value = []
    total.value = 0
    page.value = 1
    latest.value = null
    error.value = ''
  }

  return {
    submissions,
    total,
    page,
    size,
    isSubmitting,
    isLoading,
    error,
    latest,
    submit,
    loadSubmissions,
    stopPolling,
    reset,
  }
})
