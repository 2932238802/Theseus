import { defineStore } from 'pinia'
import { ref } from 'vue'
import { mockApi } from '../api/mock'
import type { Language, Problem, Submission } from '../types/oj'

const SUBMISSIONS_KEY = 'theseus-submissions'
const readSubmissions = (): Submission[] => {
  try {
    return JSON.parse(localStorage.getItem(SUBMISSIONS_KEY) ?? '[]') as Submission[]
  } catch {
    return []
  }
}

export const useSubmissionStore = defineStore('submissions', () => {
  const submissions = ref<Submission[]>(readSubmissions())
  const isSubmitting = ref(false)
  const latest = ref<Submission | null>(null)

  const submit = async (problem: Problem, language: Language, code: string): Promise<Submission> => {
    isSubmitting.value = true
    try {
      const submission = await mockApi.submit(problem, language, code)
      latest.value = submission
      submissions.value = [submission, ...submissions.value]
      localStorage.setItem(SUBMISSIONS_KEY, JSON.stringify(submissions.value))
      return submission
    } finally {
      isSubmitting.value = false
    }
  }

  return { submissions, isSubmitting, latest, submit }
})
