import { defineStore } from 'pinia'
import { computed, ref } from 'vue'
import { mockApi } from '../api/mock'
import type { Problem, ProblemQuery } from '../types/oj'

const INITIAL_QUERY: ProblemQuery = {
  keyword: '', difficulty: 'all', tag: '', sortBy: 'id', order: 'asc', page: 1, pageSize: 20,
}

export const useProblemStore = defineStore('problems', () => {
  const problems = ref<Problem[]>([])
  const currentProblem = ref<Problem | null>(null)
  const isLoading = ref(false)
  const error = ref('')
  const query = ref<ProblemQuery>({ ...INITIAL_QUERY })

  const tags = computed(() => [...new Set(problems.value.flatMap((problem) => problem.tags))].sort())
  const filteredProblems = computed(() => {
    const keyword = query.value.keyword.trim().toLocaleLowerCase()
    const ordered = problems.value.filter((problem) => {
      const matchedKeyword = !keyword || problem.title.toLocaleLowerCase().includes(keyword) || problem.tags.some((tag) => tag.toLocaleLowerCase().includes(keyword))
      const matchedDifficulty = query.value.difficulty === 'all' || problem.difficulty === query.value.difficulty
      const matchedTag = !query.value.tag || problem.tags.includes(query.value.tag)
      return matchedKeyword && matchedDifficulty && matchedTag
    })
    const multiplier = query.value.order === 'asc' ? 1 : -1
    return [...ordered].sort((first, second) => {
      if (query.value.sortBy === 'difficulty') return (['easy', 'medium', 'hard'].indexOf(first.difficulty) - ['easy', 'medium', 'hard'].indexOf(second.difficulty)) * multiplier
      return (first[query.value.sortBy] - second[query.value.sortBy]) * multiplier
    })
  })
  const pagedProblems = computed(() => {
    const start = (query.value.page - 1) * query.value.pageSize
    return filteredProblems.value.slice(start, start + query.value.pageSize)
  })
  const pageCount = computed(() => Math.max(1, Math.ceil(filteredProblems.value.length / query.value.pageSize)))

  const loadProblems = async (): Promise<void> => {
    isLoading.value = true
    error.value = ''
    try {
      problems.value = await mockApi.getProblems()
    } catch (exception: unknown) {
      error.value = exception instanceof Error ? exception.message : '题目加载失败。'
    } finally {
      isLoading.value = false
    }
  }
  const loadProblem = async (id: number): Promise<void> => {
    isLoading.value = true
    error.value = ''
    try {
      currentProblem.value = await mockApi.getProblem(id)
    } catch (exception: unknown) {
      currentProblem.value = null
      error.value = exception instanceof Error ? exception.message : '题目加载失败。'
    } finally {
      isLoading.value = false
    }
  }
  const resetQuery = (): void => { query.value = { ...INITIAL_QUERY } }

  return { problems, currentProblem, isLoading, error, query, tags, filteredProblems, pagedProblems, pageCount, loadProblems, loadProblem, resetQuery }
})
