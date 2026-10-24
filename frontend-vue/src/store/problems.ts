import { defineStore } from 'pinia'
import { computed, ref } from 'vue'
import { toErrorMessage } from '../api/client'
import { type ProblemListRequest, fetchProblem, fetchProblems, fetchTags } from '../api/problems'
import type { Problem, ProblemQuery } from '../types/oj'

const INITIAL_QUERY: ProblemQuery = {
  keyword: '',
  difficulty: 'all',
  tag: '',
  status: 'all',
  sortBy: 'id',
  order: 'asc',
  page: 1,
  pageSize: 20,
}

const buildRequest = (query: ProblemQuery): ProblemListRequest => ({
  page: query.page,
  size: query.pageSize,
  difficulty: query.difficulty === 'all' ? undefined : query.difficulty,
  tag: query.tag || undefined,
  status: query.status === 'all' ? undefined : query.status,
  search: query.keyword.trim() || undefined,
  sort: query.sortBy === 'acceptance' ? 'acceptance_rate' : query.sortBy,
  order: query.order,
})

export const useProblemStore = defineStore('problems', () => {
  const problems = ref<Problem[]>([])
  const currentProblem = ref<Problem | null>(null)
  const tags = ref<string[]>([])
  const total = ref(0)
  const isLoading = ref(false)
  const error = ref('')
  const query = ref<ProblemQuery>({ ...INITIAL_QUERY })

  let listRequestSequence = 0
  let detailRequestSequence = 0
  let tagsLoaded = false

  const pageCount = computed(() => Math.max(1, Math.ceil(total.value / query.value.pageSize)))

  const loadTags = async (): Promise<void> => {
    if (tagsLoaded) return
    try {
      tags.value = await fetchTags()
      tagsLoaded = true
    } catch {
      tags.value = []
    }
  }

  const loadProblems = async (): Promise<void> => {
    const requestId = ++listRequestSequence
    isLoading.value = true
    error.value = ''
    try {
      const result = await fetchProblems(buildRequest(query.value))
      if (requestId !== listRequestSequence) return
      if (result.total > 0 && result.problems.length === 0 && query.value.page > 1) {
        query.value.page = 1
        void loadProblems()
        return
      }
      problems.value = result.problems
      total.value = result.total
    } catch (exception: unknown) {
      if (requestId !== listRequestSequence) return
      problems.value = []
      total.value = 0
      error.value = toErrorMessage(exception)
    } finally {
      if (requestId === listRequestSequence) isLoading.value = false
    }
  }

  const loadProblem = async (id: number): Promise<void> => {
    const requestId = ++detailRequestSequence
    isLoading.value = true
    error.value = ''
    currentProblem.value = null
    try {
      const problem = await fetchProblem(id)
      if (requestId !== detailRequestSequence) return
      currentProblem.value = problem
    } catch (exception: unknown) {
      if (requestId !== detailRequestSequence) return
      error.value = toErrorMessage(exception)
    } finally {
      if (requestId === detailRequestSequence) isLoading.value = false
    }
  }

  const resetQuery = (): void => {
    query.value = { ...INITIAL_QUERY }
  }

  return {
    problems,
    currentProblem,
    tags,
    total,
    isLoading,
    error,
    query,
    pageCount,
    loadProblems,
    loadProblem,
    loadTags,
    resetQuery,
  }
})
