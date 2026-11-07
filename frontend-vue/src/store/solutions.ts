import { computed, ref } from 'vue'
import { defineStore } from 'pinia'
import { toErrorMessage } from '../api/client'
import {
  createProblemSolution,
  deleteProblemSolution,
  fetchProblemSolutions,
  updateProblemSolution,
} from '../api/solutions'
import { LANGUAGE_OPTIONS } from '../utils/constants'
import type { Language, Submission } from '../types/oj'
import type { ProblemSolution, SolutionMode } from '../types/solution'

const FALLBACK_MAX = 5
const MAX_NAME_CHARS = 60
const CODE_SAVE_DELAY = 900

const localKey = (problemId: number): string => `theseus-solutions-${problemId}`
const activeKey = (problemId: number): string => `theseus-active-solution-${problemId}`
const legacyDraftKey = (problemId: number, language: Language): string =>
  `theseus-draft-${problemId}-${language}`

const createLocalId = (): string => {
  const random =
    typeof crypto !== 'undefined' && 'randomUUID' in crypto
      ? crypto.randomUUID()
      : `${Date.now()}-${Math.random().toString(36).slice(2, 8)}`
  return `local-${random}`
}

const isSolution = (value: unknown): value is ProblemSolution => {
  if (!value || typeof value !== 'object') return false
  const item = value as Record<string, unknown>
  return (
    typeof item.id === 'string' &&
    typeof item.slot === 'number' &&
    typeof item.name === 'string' &&
    typeof item.language === 'string' &&
    typeof item.code === 'string'
  )
}

const now = (): string => new Date().toISOString()

export const useSolutionStore = defineStore('solutions', () => {
  const solutions = ref<ProblemSolution[]>([])
  const activeId = ref('')
  const max = ref(FALLBACK_MAX)
  const mode = ref<SolutionMode>('local')
  const problemId = ref<number | null>(null)
  const loading = ref(false)
  const saving = ref(false)
  const error = ref('')

  let codeSaveTimer: ReturnType<typeof setTimeout> | null = null
  let pendingCode: string | null = null
  let loadGeneration = 0
  const codeSaveRevision = new Map<string, number>()

  const activeSolution = computed<ProblemSolution | null>(() => {
    return solutions.value.find((item) => item.id === activeId.value) ?? null
  })
  const count = computed(() => solutions.value.length)
  const canAdd = computed(() => solutions.value.length < max.value)
  const canDelete = computed(() => solutions.value.length > 1)
  const isServerMode = computed(() => mode.value === 'server')

  const clearCodeTimer = (): void => {
    if (codeSaveTimer !== null) {
      clearTimeout(codeSaveTimer)
      codeSaveTimer = null
    }
  }

  const readLocal = (id: number): ProblemSolution[] | null => {
    try {
      const raw = localStorage.getItem(localKey(id))
      if (!raw) return null
      const parsed: unknown = JSON.parse(raw)
      if (!Array.isArray(parsed)) return null
      const items = parsed.filter(isSolution)
      return items.length ? items : null
    } catch {
      return null
    }
  }

  const persistLocal = (): void => {
    if (mode.value !== 'local' || problemId.value === null) return
    try {
      localStorage.setItem(localKey(problemId.value), JSON.stringify(solutions.value))
      if (activeId.value) {
        localStorage.setItem(activeKey(problemId.value), activeId.value)
      }
    } catch {
      // 本地存储不可用时仍然保留内存中的解法
    }
  }

  const persistActive = (): void => {
    if (problemId.value === null || !activeId.value) return
    try {
      localStorage.setItem(activeKey(problemId.value), activeId.value)
    } catch {
      // 忽略隐私模式下的写入失败
    }
  }

  const makeLocalSolution = (
    slot: number,
    language: Language,
    code: string,
    name = `解法 ${slot}`,
  ): ProblemSolution => {
    const timestamp = now()
    return {
      id: createLocalId(),
      serverId: null,
      slot,
      name,
      language,
      code,
      createdAt: timestamp,
      updatedAt: timestamp,
      lastSubmission: null,
    }
  }

  const seedLocal = (id: number, currentLanguage: Language): ProblemSolution[] => {
    const seeded: ProblemSolution[] = []
    // 把旧版按语言保存的本地草稿迁移成多个解法
    for (const option of LANGUAGE_OPTIONS.slice(0, FALLBACK_MAX)) {
      const draft = localStorage.getItem(legacyDraftKey(id, option.value))
      if (!draft || !draft.trim()) continue
      seeded.push(makeLocalSolution(seeded.length + 1, option.value, draft))
    }
    if (!seeded.length) {
      seeded.push(makeLocalSolution(1, currentLanguage, ''))
    }
    return seeded
  }

  /**
   * 游客在本机写的解法在登录后合并到服务端
   * 只在服务端该题还没有任何代码时执行，避免覆盖其它设备的编辑
   */
  interface LocalMigration {
    solutions: ProblemSolution[]
    complete: boolean
  }

  const migrateLocalSolutions = async (
    id: number,
    language: Language,
    base: ProblemSolution | null,
    extraSlots: number,
  ): Promise<LocalMigration> => {
    const local = readLocal(id) ?? seedLocal(id, language)
    const pending = local.filter((item) => item.code.trim() !== '')
    if (!pending.length) return { solutions: [], complete: true }
    const migrated: ProblemSolution[] = []
    let index = 0
    if (base?.serverId != null) {
      const first = pending[0]
      migrated.push(
        await updateProblemSolution(id, base.serverId, {
          name: first.name,
          language: first.language,
          code: first.code,
        }),
      )
      index = 1
    }
    let created = 0
    for (; index < pending.length && created < extraSlots; index += 1) {
      const item = pending[index]
      migrated.push(
        await createProblemSolution(id, {
          name: item.name,
          language: item.language,
          code: item.code,
        }),
      )
      created += 1
    }
    return { solutions: migrated, complete: migrated.length >= pending.length }
  }

  /// 游客草稿成功合并后清理本机副本，避免退出登录后再次合并
  const clearGuestStorage = (id: number): void => {
    try {
      localStorage.removeItem(localKey(id))
      localStorage.removeItem(activeKey(id))
      for (const option of LANGUAGE_OPTIONS) {
        localStorage.removeItem(legacyDraftKey(id, option.value))
      }
    } catch {
      // 隐私模式下删除失败不影响服务端已保存的内容
    }
  }

  const pickActive = (language: Language, storedId: string | null): string => {
    if (storedId && solutions.value.some((item) => item.id === storedId)) return storedId
    const sameLanguage = solutions.value.find((item) => item.language === language)
    return (sameLanguage ?? solutions.value[0])?.id ?? ''
  }

  const load = async (
    id: number,
    language: Language,
    requestedMode: SolutionMode,
  ): Promise<ProblemSolution | null> => {
    const generation = ++loadGeneration
    clearCodeTimer()
    pendingCode = null
    if (problemId.value !== null && problemId.value !== id) {
      // 切换题目时先清空旧题解法，避免加载期间展示上一题的名称与状态
      solutions.value = []
      activeId.value = ''
      max.value = FALLBACK_MAX
    }
    problemId.value = id
    mode.value = requestedMode
    loading.value = true
    error.value = ''
    try {
      let storedId: string | null = null
      try {
        storedId = localStorage.getItem(activeKey(id))
      } catch {
        storedId = null
      }
      if (requestedMode === 'server') {
        try {
          const result = await fetchProblemSolutions(id, language)
          if (generation !== loadGeneration) return null
          if (!result.solutions.length) throw new Error('解法列表为空')
          max.value = result.max
          let loaded = result.solutions
          const serverEmpty = loaded.every((item) => item.code.trim() === '')
          if (serverEmpty) {
            const migration = await migrateLocalSolutions(
              id,
              language,
              loaded[0] ?? null,
              Math.max(0, result.max - loaded.length),
            )
            if (generation !== loadGeneration) return null
            if (migration.solutions.length) {
              // 首个服务端空解法被游客内容填充，其余新建解法追加在后
              loaded = [
                migration.solutions[0],
                ...loaded.slice(1),
                ...migration.solutions.slice(1),
              ]
            }
            if (migration.complete && migration.solutions.length) clearGuestStorage(id)
          }
          solutions.value = loaded
        } catch (exception: unknown) {
          if (generation !== loadGeneration) return null
          // 云端不可用时退回本地多解法，保证仍然可以继续作答
          mode.value = 'local'
          error.value = toErrorMessage(exception)
          solutions.value = readLocal(id) ?? seedLocal(id, language)
          persistLocal()
        }
      } else {
        max.value = FALLBACK_MAX
        solutions.value = readLocal(id) ?? seedLocal(id, language)
        persistLocal()
      }
      if (generation !== loadGeneration) return null
      activeId.value = pickActive(language, storedId)
      persistActive()
      return activeSolution.value
    } finally {
      if (generation === loadGeneration) loading.value = false
    }
  }

  const saveCode = async (solution: ProblemSolution, code: string): Promise<void> => {
    if (mode.value === 'local') {
      persistLocal()
      return
    }
    if (problemId.value === null || solution.serverId === null) return
    const revision = (codeSaveRevision.get(solution.id) ?? 0) + 1
    codeSaveRevision.set(solution.id, revision)
    saving.value = true
    try {
      const updated = await updateProblemSolution(problemId.value, solution.serverId, { code })
      const current = solutions.value.find((item) => item.id === solution.id)
      if (
        current &&
        codeSaveRevision.get(solution.id) === revision &&
        current.code === code
      ) {
        current.updatedAt = updated.updatedAt
        current.lastSubmission = updated.lastSubmission
      }
      if (error.value) error.value = ''
    } catch (exception: unknown) {
      error.value = toErrorMessage(exception)
    } finally {
      if (codeSaveRevision.get(solution.id) === revision) saving.value = false
    }
  }

  const flushCode = async (): Promise<void> => {
    clearCodeTimer()
    const code = pendingCode
    pendingCode = null
    const solution = activeSolution.value
    if (!solution || code === null) {
      if (mode.value === 'local') persistLocal()
      return
    }
    await saveCode(solution, code)
  }

  const scheduleCodeSave = (): void => {
    clearCodeTimer()
    codeSaveTimer = setTimeout(() => {
      codeSaveTimer = null
      void flushCode()
    }, CODE_SAVE_DELAY)
  }

  const updateActiveCode = (code: string): void => {
    const solution = activeSolution.value
    if (!solution) return
    solution.code = code
    solution.updatedAt = now()
    if (mode.value === 'local') {
      persistLocal()
      return
    }
    pendingCode = code
    scheduleCodeSave()
  }

  const switchTo = async (id: string): Promise<ProblemSolution | null> => {
    await flushCode()
    const target = solutions.value.find((item) => item.id === id)
    if (!target) return null
    activeId.value = target.id
    persistActive()
    return target
  }

  const setActiveLanguage = async (
    language: Language,
    code: string,
  ): Promise<ProblemSolution | null> => {
    await flushCode()
    const solution = activeSolution.value
    if (!solution) return null
    solution.language = language
    solution.code = code
    solution.updatedAt = now()
    if (mode.value === 'local') {
      persistLocal()
      return solution
    }
    if (problemId.value === null || solution.serverId === null) return solution
    saving.value = true
    try {
      const updated = await updateProblemSolution(problemId.value, solution.serverId, {
        language,
        code,
      })
      solution.updatedAt = updated.updatedAt
    } catch (exception: unknown) {
      error.value = toErrorMessage(exception)
    } finally {
      saving.value = false
    }
    return solution
  }

  const add = async (language: Language): Promise<ProblemSolution> => {
    await flushCode()
    if (solutions.value.length >= max.value) {
      throw new Error(`最多保存 ${max.value} 个解法`)
    }
    let solution: ProblemSolution
    if (mode.value === 'server' && problemId.value !== null) {
      solution = await createProblemSolution(problemId.value, { language, code: '' })
      solutions.value.push(solution)
      max.value = Math.max(max.value, FALLBACK_MAX)
    } else {
      const usedSlots = new Set(solutions.value.map((item) => item.slot))
      let slot = 1
      while (usedSlots.has(slot) && slot <= FALLBACK_MAX) slot += 1
      if (slot > FALLBACK_MAX) throw new Error(`最多保存 ${FALLBACK_MAX} 个解法`)
      solution = makeLocalSolution(slot, language, '')
      solutions.value.push(solution)
      persistLocal()
    }
    activeId.value = solution.id
    persistActive()
    if (error.value) error.value = ''
    return solution
  }

  const rename = async (id: string, value: string): Promise<ProblemSolution | null> => {
    const solution = solutions.value.find((item) => item.id === id)
    if (!solution) return null
    const name = value.trim()
    if (!name) throw new Error('解法名称不能为空')
    if ([...name].length > MAX_NAME_CHARS) {
      throw new Error(`解法名称不能超过 ${MAX_NAME_CHARS} 个字符`)
    }
    const previous = solution.name
    solution.name = name
    solution.updatedAt = now()
    if (mode.value === 'local' || problemId.value === null || solution.serverId === null) {
      persistLocal()
      return solution
    }
    try {
      const updated = await updateProblemSolution(problemId.value, solution.serverId, { name })
      solution.updatedAt = updated.updatedAt
      return solution
    } catch (exception: unknown) {
      solution.name = previous
      error.value = toErrorMessage(exception)
      throw exception
    }
  }

  const chooseFallbackActive = (removedId: string): ProblemSolution | null => {
    if (activeId.value === removedId || !solutions.value.some((item) => item.id === activeId.value)) {
      const next = solutions.value[0] ?? null
      activeId.value = next?.id ?? ''
    }
    persistActive()
    persistLocal()
    return activeSolution.value
  }

  const remove = async (id: string): Promise<ProblemSolution | null> => {
    await flushCode()
    if (solutions.value.length <= 1) throw new Error('至少保留一个解法')
    const solution = solutions.value.find((item) => item.id === id)
    if (!solution) return activeSolution.value
    if (mode.value === 'server' && problemId.value !== null && solution.serverId !== null) {
      const result = await deleteProblemSolution(problemId.value, solution.serverId)
      solutions.value = result.solutions
      max.value = result.max
      return chooseFallbackActive(id)
    }
    solutions.value = solutions.value.filter((item) => item.id !== id)
    return chooseFallbackActive(id)
  }

  const recordSubmission = (submission: Submission): void => {
    const solution =
      (submission.solutionId
        ? solutions.value.find((item) => item.serverId === submission.solutionId)
        : null) ?? activeSolution.value
    if (!solution) return
    solution.lastSubmission = {
      id: submission.id,
      status: submission.rawStatus,
      testCasesPassed: submission.testCasesPassed,
      totalTestCases: submission.totalTestCases,
      runtime: submission.runtimeMs ?? null,
      memory: submission.memoryKb ?? null,
      submittedAt: submission.createdAt,
    }
    solution.updatedAt = now()
    persistLocal()
  }

  const reset = (): void => {
    loadGeneration += 1
    clearCodeTimer()
    pendingCode = null
    codeSaveRevision.clear()
    solutions.value = []
    activeId.value = ''
    max.value = FALLBACK_MAX
    mode.value = 'local'
    problemId.value = null
    loading.value = false
    saving.value = false
    error.value = ''
  }

  return {
    solutions,
    activeId,
    max,
    mode,
    problemId,
    loading,
    saving,
    error,
    activeSolution,
    count,
    canAdd,
    canDelete,
    isServerMode,
    load,
    updateActiveCode,
    setActiveLanguage,
    switchTo,
    add,
    rename,
    remove,
    flushCode,
    recordSubmission,
    reset,
  }
})
