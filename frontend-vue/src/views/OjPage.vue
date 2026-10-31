<script setup lang="ts">
import { computed, nextTick, onBeforeUnmount, onMounted, ref, watch } from 'vue'
import { useRoute, useRouter } from 'vue-router'
import NavBar from '../components/NavBar.vue'
import CodeEditor from '../components/CodeEditor.vue'
import ShortcutDialog from '../components/ShortcutDialog.vue'
import ProblemDiscussionPanel from '../components/ProblemDiscussionPanel.vue'
import ProblemNotePanel from '../components/ProblemNotePanel.vue'
import { useAuthStore } from '../store/auth'
import { useProblemStore } from '../store/problems'
import { useRunStore } from '../store/runs'
import { useShortcutStore } from '../store/shortcuts'
import { useSubmissionStore } from '../store/submissions'
import { fetchAssignment } from '../api/assignments'
import { fetchContestProblem } from '../api/contests'
import { fetchProblemDraft, saveProblemDraft } from '../api/drafts'
import { setProblemFavorite } from '../api/favorites'
import { fetchSubmission, fetchSubmissions } from '../api/submissions'
import { toErrorMessage } from '../api/client'
import type { AssignmentDetail } from '../types/teaching'
import {
  DIFFICULTY_LABELS,
  LANGUAGE_OPTIONS,
  RUN_CASE_STATUS_LABELS,
  RUN_STATUS_LABELS,
} from '../utils/constants'
import { SHORTCUT_ACTIONS, matchesShortcut } from '../utils/shortcuts'
import type { Language, Submission } from '../types/oj'
import type { RunMode } from '../types/run'
import { formatArgs, formatInline } from '../utils/format'
import { useContestEvents } from '../utils/contestEvents'
import { inspectPaste } from '../utils/pasteInspection'
import { clearDraftMeta, saveDraftMeta } from '../utils/problemDrafts'
import { buildLineDiff, type DiffRow } from '../utils/lineDiff'
import { currentTheme } from '../utils/theme'
import {
  EDITOR_THEME_OPTIONS,
  isEditorThemeChoice,
  resolveMonacoTheme,
  type EditorThemeChoice,
} from '../utils/monacoTheme'

const route = useRoute()
const router = useRouter()
const authStore = useAuthStore()
const problemStore = useProblemStore()
const shortcutStore = useShortcutStore()
const submissionStore = useSubmissionStore()
const runStore = useRunStore()
const problemId = computed(() => Number(route.params.id))
const PREFERRED_LANGUAGE_KEY = 'theseus-preferred-language'
const EDITOR_FONT_SIZE_KEY = 'theseus-editor-font-size'
const EDITOR_THEME_KEY = 'theseus-editor-theme'
const EDITOR_COMPLETION_KEY = 'theseus-editor-completion'
const MIN_FONT_SIZE = 12
const MAX_FONT_SIZE = 20
const isLanguage = (value: unknown): value is Language =>
  typeof value === 'string' && LANGUAGE_OPTIONS.some((option) => option.value === value)
const initialLanguage = (): Language => {
  const queryLanguage = route.query.language
  if (isLanguage(queryLanguage)) return queryLanguage
  const stored = localStorage.getItem(PREFERRED_LANGUAGE_KEY)
  return isLanguage(stored) ? stored : 'cpp'
}
const language = ref<Language>(initialLanguage())
const code = ref('')
const editorRef = ref<{ focus: () => void } | null>(null)
const storedFontSize = Number(localStorage.getItem(EDITOR_FONT_SIZE_KEY))
const fontSize = ref(
  Number.isInteger(storedFontSize) && storedFontSize >= MIN_FONT_SIZE && storedFontSize <= MAX_FONT_SIZE
    ? storedFontSize
    : 14,
)
const isOutputOpen = ref(true)
const isDark = computed(() => currentTheme.value === 'dark')
const storedEditorTheme = localStorage.getItem(EDITOR_THEME_KEY)
const editorTheme = ref<EditorThemeChoice>(
  isEditorThemeChoice(storedEditorTheme) ? storedEditorTheme : 'system',
)
const editorThemeName = computed(() => resolveMonacoTheme(editorTheme.value, isDark.value))
const draftKey = computed(() => `theseus-draft-${problemId.value}-${language.value}`)
const isAccepted = computed(() => submissionStore.latest?.status === 'Accepted')
const latestFailedCase = computed(() => submissionStore.latest?.failedCase ?? null)
type OutputTab = 'run' | 'submit' | 'history'
const activeOutputTab = ref<OutputTab>('submit')
type ProblemTab = 'description' | 'discussion' | 'note'
const problemTab = ref<ProblemTab>('description')
const HISTORY_PAGE_SIZE = 10
const historyItems = ref<Submission[]>([])
const historyTotal = ref(0)
const historyPage = ref(1)
const historyLoading = ref(false)
const historyError = ref('')
const historyLoaded = ref(false)
const historyDetail = ref<Submission | null>(null)
const historyDetailLoading = ref(false)
const historyDetailError = ref('')
const showHistoryDiff = ref(false)
let historyRequestSequence = 0
const isRunDialogOpen = ref(false)
const isShortcutDialogOpen = ref(false)
const runMode = ref<RunMode>('examples')
const runInput = ref('')
const runInputError = ref('')
const runFeatureEnabled = import.meta.env.VITE_RUN_CODE_ENABLED !== 'false'
const favoriteBusy = ref(false)
const favoriteError = ref('')
const submitFeatureEnabled = import.meta.env.VITE_SUBMIT_JUDGE_ENABLED === 'true'
const assignmentId = computed(() => {
  const value = Number(route.query.assignment_id)
  return Number.isInteger(value) && value > 0 ? value : null
})
const contestId = computed(() => {
  const value = Number(route.query.contest_id)
  return Number.isInteger(value) && value > 0 ? value : null
})
const contestEventsEnabled = computed(() => contestId.value !== null)
// 语法补全默认关闭，比赛模式下不可开启（按钮保留但置灰）
const completionEnabled = ref(localStorage.getItem(EDITOR_COMPLETION_KEY) === 'on')
const completionAllowed = computed(() => contestId.value === null)
const editorCompletion = computed(() => completionAllowed.value && completionEnabled.value)
const toggleProblemFavorite = async (): Promise<void> => {
  if (!authStore.isAuthenticated) {
    void router.push({ name: 'login', query: { redirect: route.fullPath } })
    return
  }
  const problem = problemStore.currentProblem
  if (!problem || favoriteBusy.value) return
  const before = problem.favorited
  problem.favorited = !before
  favoriteBusy.value = true
  favoriteError.value = ''
  try {
    problem.favorited = await setProblemFavorite(problem.id, problem.favorited)
  } catch (exception: unknown) {
    problem.favorited = before
    favoriteError.value = toErrorMessage(exception)
  } finally {
    favoriteBusy.value = false
  }
}
const { report: reportContestEvent } = useContestEvents(contestId, contestEventsEnabled)
const assignment = ref<AssignmentDetail | null>(null)
const assignmentError = ref('')
const assignmentLoading = ref(false)
const assignmentStateLabel = computed(() => {
  if (!assignmentId.value) return ''
  if (contestId.value) return ''
  if (!authStore.isAuthenticated) return '登录后可提交作业'
  if (authStore.isTeacher) return '教师预览不可提交'
  if (authStore.isAdmin) return '管理员不可提交'
  const detail = assignment.value
  if (!detail) return assignmentLoading.value ? '正在加载作业' : assignmentError.value
  if (detail.status === 'archived') return '作业已归档'
  if (detail.status === 'draft') return '作业尚未发布'
  if (detail.dueAt && new Date(detail.dueAt).getTime() < Date.now()) return '作业已截止'
  if (detail.startAt && new Date(detail.startAt).getTime() > Date.now()) return '作业尚未开始'
  return detail.canSubmit ? '' : '当前不能提交'
})
const canSubmitCode = computed(
  () =>
    Boolean(contestId.value) ||
    !assignmentId.value ||
    (authStore.isStudent && assignment.value?.canSubmit === true),
)

const runConfig = computed(() => problemStore.currentProblem?.runConfig)
const canRun = computed(
  () =>
    runFeatureEnabled &&
    Boolean(runConfig.value) &&
    Boolean(problemStore.currentProblem),
)
const runDisabledReason = computed(() => {
  if (!runFeatureEnabled) return '运行功能暂未开放'
  if (!runConfig.value) return '该题暂未配置运行'
  return ''
})
const hasPublicCases = computed(() => (runConfig.value?.publicCases.length ?? 0) > 0)
const runButtonLabel = computed(() => {
  if (!runStore.isRunning) return '运行'
  const current = runStore.status?.status
  if (current === 'running') return '运行中'
  if (current === 'compiling') return '编译中'
  return '排队中'
})
const runCase = computed(() => runStore.detail?.cases[0])
const runStatusLabel = computed(() =>
  runStore.status ? RUN_STATUS_LABELS[runStore.status.status] : '',
)
const outputStatusLabel = computed(() => {
  if (activeOutputTab.value === 'run') return runStatusLabel.value
  if (activeOutputTab.value === 'submit') return submissionStore.latest?.status ?? ''
  return ''
})
const outputSucceeded = computed(() =>
  activeOutputTab.value === 'run'
    ? runStore.detail?.status === 'completed'
    : isAccepted.value,
)
const historyTotalPages = computed(() =>
  Math.max(1, Math.ceil(historyTotal.value / HISTORY_PAGE_SIZE)),
)
const historyDiffRows = computed<DiffRow[] | null>(() => {
  const detail = historyDetail.value
  if (!detail) return null
  return buildLineDiff(detail.code, code.value)
})
const parameterHint = computed(() => {
  const config = runConfig.value
  if (!config) return ''
  const params = config.params.map((param) => `${param.name}: ${param.type}`).join(', ')
  return `${config.functionName}(${params}) -> ${config.returnType}`
})

const templateFor = (target: Language): string => problemStore.currentProblem?.codeTemplate[target] ?? ''
const restoreDraft = (): void => {
  code.value = localStorage.getItem(draftKey.value) ?? templateFor(language.value)
}
const hasOtherLanguageDraft = (): boolean =>
  LANGUAGE_OPTIONS.some((option) => {
    if (option.value === language.value) return false
    const stored = localStorage.getItem(`theseus-draft-${problemId.value}-${option.value}`)
    return Boolean(stored && stored !== templateFor(option.value))
  })
// 本地草稿延迟写盘：避免每次按键都同步读写 localStorage
let localDraftTimer: ReturnType<typeof setTimeout> | null = null
const cancelLocalDraftSave = (): void => {
  if (localDraftTimer !== null) {
    clearTimeout(localDraftTimer)
    localDraftTimer = null
  }
}
const saveDraft = (): void => {
  cancelLocalDraftSave()
  if (code.value) localStorage.setItem(draftKey.value, code.value)
  const problem = problemStore.currentProblem
  if (!problem) return
  if (code.value && code.value !== templateFor(language.value)) {
    saveDraftMeta({
      problemId: problem.id,
      title: problem.title,
      difficulty: problem.difficulty,
      language: language.value,
    })
  } else if (!hasOtherLanguageDraft()) {
    // 当前语言没有编辑内容时，只有其他语言也没有草稿才清除首页的继续学习记录
    clearDraftMeta(problem.id)
  }
}
const scheduleLocalDraftSave = (): void => {
  cancelLocalDraftSave()
  localDraftTimer = setTimeout(() => {
    localDraftTimer = null
    saveDraft()
  }, 400)
}
const resetCode = (): void => {
  code.value = templateFor(language.value)
  saveDraft()
  if (problemStore.currentProblem) clearDraftMeta(problemStore.currentProblem.id)
}

// 跨设备草稿：本地草稿仍然即时落盘，服务端在停止编辑约 1 秒后同步
let draftSyncTimer: ReturnType<typeof setTimeout> | null = null
let draftHydrationGeneration = 0
let activeHydrations = 0
let pendingDraftSync = false
let adoptingRemoteDraft = false

const cancelDraftSync = (): void => {
  if (draftSyncTimer !== null) {
    clearTimeout(draftSyncTimer)
    draftSyncTimer = null
  }
}

const pushDraftToServer = async (
  targetProblemId: number | undefined,
  targetLanguage: Language,
  content: string,
): Promise<void> => {
  if (!targetProblemId || contestId.value || !authStore.isAuthenticated) return
  try {
    await saveProblemDraft(targetProblemId, targetLanguage, content)
  } catch {
    // 同步失败不影响答题，下次编辑时会重试
  }
}

const scheduleDraftSync = (): void => {
  if (!authStore.isAuthenticated || contestId.value) return
  const problem = problemStore.currentProblem
  if (!problem) return
  if (activeHydrations > 0) {
    // 正在读取云端草稿，等读取结束后再决定推送哪一份
    pendingDraftSync = true
    return
  }
  cancelDraftSync()
  const payload = code.value === templateFor(language.value) ? '' : code.value
  const targetLanguage = language.value
  const targetProblemId = problem.id
  draftSyncTimer = setTimeout(() => {
    draftSyncTimer = null
    void pushDraftToServer(targetProblemId, targetLanguage, payload)
  }, 1000)
}

const hydrateDraftFromServer = async (): Promise<void> => {
  if (!authStore.isAuthenticated || contestId.value) return
  const problem = problemStore.currentProblem
  if (!problem) return
  const generation = ++draftHydrationGeneration
  const targetLanguage = language.value
  const localCode = code.value
  const template = templateFor(targetLanguage)
  activeHydrations += 1
  try {
    const remote = await fetchProblemDraft(problem.id, targetLanguage)
    if (generation !== draftHydrationGeneration) return
    if (language.value !== targetLanguage) return
    if (code.value !== localCode) {
      // 读取期间用户已经编辑，保留本地内容并稍后同步
      scheduleDraftSync()
      return
    }
    if (localCode !== template) {
      // 本地已有编辑，避免被云端覆盖
      scheduleDraftSync()
      return
    }
    if (!remote || remote.code === template) return
    adoptingRemoteDraft = true
    try {
      code.value = remote.code
      localStorage.setItem(`theseus-draft-${problem.id}-${targetLanguage}`, remote.code)
    } finally {
      adoptingRemoteDraft = false
    }
  } catch {
    // 读取失败时沿用本地草稿，后续编辑仍会同步
  } finally {
    activeHydrations -= 1
    if (activeHydrations === 0 && pendingDraftSync) {
      pendingDraftSync = false
      scheduleDraftSync()
    }
  }
}
const loadAssignmentContext = async (): Promise<void> => {
  assignment.value = null
  assignmentError.value = ''
  if (contestId.value) return
  if (!assignmentId.value || !authStore.isAuthenticated || authStore.isAdmin) return
  assignmentLoading.value = true
  try {
    assignment.value = await fetchAssignment(assignmentId.value)
  } catch (exception: unknown) {
    assignmentError.value = exception instanceof Error ? exception.message : '作业不存在'
  } finally {
    assignmentLoading.value = false
  }
}
let pageProblemRequest = 0
const loadProblemForPage = async (): Promise<void> => {
  const requestId = ++pageProblemRequest
  if (!contestId.value) {
    await problemStore.loadProblem(problemId.value)
    return
  }
  problemStore.currentProblem = null
  problemStore.error = ''
  problemStore.isLoading = true
  try {
    const problem = await fetchContestProblem(contestId.value, problemId.value)
    if (requestId !== pageProblemRequest) return
    problemStore.currentProblem = problem
  } catch (exception: unknown) {
    if (requestId !== pageProblemRequest) return
    problemStore.error = toErrorMessage(exception)
  } finally {
    if (requestId === pageProblemRequest) problemStore.isLoading = false
  }
}
const loadPage = async (): Promise<void> => {
  submissionStore.stopPolling()
  submissionStore.latest = null
  runStore.reset()
  historyRequestSequence += 1
  historyItems.value = []
  historyTotal.value = 0
  historyPage.value = 1
  historyLoaded.value = false
  historyLoading.value = false
  historyError.value = ''
  closeHistoryDetail()
  activeOutputTab.value = 'submit'
  problemTab.value = 'description'
  isRunDialogOpen.value = false
  if (contestId.value) {
    assignment.value = null
    assignmentError.value = ''
    assignmentLoading.value = false
  }
  await Promise.all([
    loadProblemForPage(),
    contestId.value ? Promise.resolve() : loadAssignmentContext(),
  ])
  restoreDraft()
  await hydrateDraftFromServer()
}
const problemContextText = (): string => {
  const problem = problemStore.currentProblem
  if (!problem) return ''
  const examples = problem.examples.flatMap((example) => [
    example.input,
    example.output,
    example.explanation ?? '',
  ])
  return [
    problem.title,
    problem.description,
    ...examples,
    problem.codeTemplate[language.value] ?? '',
  ].join('\n')
}

const handleEditorPaste = (text: string): void => {
  if (!contestId.value) return
  const problem = problemStore.currentProblem
  if (!problem) return
  const inspection = inspectPaste(text, {
    code: code.value,
    problemText: problemContextText(),
  })
  if (!inspection.suspicious) return
  reportContestEvent('paste_suspicious', {
    length: inspection.length,
    lines: inspection.lines,
    code_similarity: inspection.codeSimilarity,
    problem_similarity: inspection.problemSimilarity,
    preview: inspection.preview,
    preview_truncated: inspection.length > inspection.preview.length,
    language: language.value,
  })
}

const submitCode = async (): Promise<void> => {
  if (
    !submitFeatureEnabled ||
    runStore.isRunning ||
    !problemStore.currentProblem ||
    !code.value.trim() ||
    submissionStore.isSubmitting
  ) {
    return
  }
  if (!authStore.isAuthenticated) {
    await router.push({ name: 'login', query: { redirect: route.fullPath } })
    return
  }
  if (assignmentId.value && !canSubmitCode.value) return
  saveDraft()
  isOutputOpen.value = true
  activeOutputTab.value = 'submit'
  try {
    const final = await submissionStore.submit(
      problemStore.currentProblem.id,
      language.value,
      code.value,
      contestId.value ? undefined : (assignmentId.value ?? undefined),
      contestId.value ?? undefined,
    )
    if (final && historyLoaded.value) void loadHistory(1)
  } catch {
    isOutputOpen.value = true
  }
}
const languageLabel = (value: Language): string =>
  LANGUAGE_OPTIONS.find((option) => option.value === value)?.label ?? value
const formatTime = (value: string): string => new Date(value).toLocaleString('zh-CN')
const loadHistory = async (page = 1): Promise<void> => {
  if (!authStore.isAuthenticated) return
  const requestId = ++historyRequestSequence
  historyLoading.value = true
  historyError.value = ''
  try {
    const result = await fetchSubmissions({
      page,
      size: HISTORY_PAGE_SIZE,
      problemId: problemId.value,
    })
    if (requestId !== historyRequestSequence) return
    historyItems.value = result.submissions
    historyTotal.value = result.total
    historyPage.value = result.page
    historyLoaded.value = true
  } catch (exception: unknown) {
    if (requestId !== historyRequestSequence) return
    historyError.value = toErrorMessage(exception)
  } finally {
    if (requestId === historyRequestSequence) historyLoading.value = false
  }
}
const openHistoryTab = (): void => {
  activeOutputTab.value = 'history'
  isOutputOpen.value = true
  if (authStore.isAuthenticated && !historyLoaded.value && !historyLoading.value) {
    void loadHistory(1)
  }
}
const openHistoryDetail = async (item: Submission): Promise<void> => {
  historyDetailLoading.value = true
  historyDetailError.value = ''
  showHistoryDiff.value = false
  try {
    historyDetail.value = await fetchSubmission(item.id)
  } catch (exception: unknown) {
    historyDetailError.value = toErrorMessage(exception)
  } finally {
    historyDetailLoading.value = false
  }
}
const closeHistoryDetail = (): void => {
  historyDetail.value = null
  historyDetailError.value = ''
  showHistoryDiff.value = false
}
const applyHistoryCode = async (): Promise<void> => {
  const detail = historyDetail.value
  if (!detail) return
  if (
    code.value.trim() &&
    code.value !== detail.code &&
    !window.confirm('当前编辑器内容将被这条提交的代码替换，确定继续吗？')
  ) {
    return
  }
  const targetLanguage = detail.language
  closeHistoryDetail()
  language.value = targetLanguage
  await nextTick()
  code.value = detail.code
  saveDraft()
  activeOutputTab.value = 'submit'
  isOutputOpen.value = true
  await nextTick()
  editorRef.value?.focus()
}
const openRunDialog = async (): Promise<void> => {
  if (!canRun.value) return
  if (!authStore.isAuthenticated) {
    await router.push({ name: 'login', query: { redirect: route.fullPath } })
    return
  }
  runMode.value = hasPublicCases.value ? 'examples' : 'custom'
  const firstCase = runConfig.value?.publicCases[0]
  runInput.value = firstCase ? JSON.stringify(firstCase.args, null, 2) : '[]'
  runInputError.value = ''
  isRunDialogOpen.value = true
}
const closeRunDialog = (): void => {
  isRunDialogOpen.value = false
}
const isIntValue = (value: unknown): boolean =>
  typeof value === 'number' && Number.isInteger(value) && value >= -2147483648 && value <= 2147483647
const typeMatches = (type: string, value: unknown): boolean => {
  switch (type) {
    case 'int':
      return isIntValue(value)
    case 'long':
      return typeof value === 'number' && Number.isSafeInteger(value)
    case 'double':
      return typeof value === 'number' && Number.isFinite(value)
    case 'bool':
      return typeof value === 'boolean'
    case 'string':
      return typeof value === 'string'
    case 'ListNode':
      return Array.isArray(value) && value.every(isIntValue)
    case 'TreeNode':
      return Array.isArray(value) && value.every((item) => item === null || isIntValue(item))
    default:
      break
  }
  if (type.endsWith('[][]')) {
    const element = type.slice(0, -4)
    return (
      Array.isArray(value) &&
      value.every((row) => Array.isArray(row) && row.every((item) => typeMatches(element, item)))
    )
  }
  if (type.endsWith('[]')) {
    const element = type.slice(0, -2)
    return Array.isArray(value) && value.every((item) => typeMatches(element, item))
  }
  return false
}
const validateRunInput = (): unknown => {
  const config = runConfig.value
  if (!config) throw new Error('该题暂未配置运行')
  let parsed: unknown
  try {
    parsed = JSON.parse(runInput.value)
  } catch {
    throw new Error('输入不是合法的 JSON')
  }
  if (!Array.isArray(parsed)) throw new Error('输入必须是 JSON 参数数组')
  if (parsed.length !== config.params.length) {
    throw new Error(`参数个数不匹配：需要 ${config.params.length} 个 收到 ${parsed.length} 个`)
  }
  config.params.forEach((param, index) => {
    if (!typeMatches(param.type, parsed[index])) {
      throw new Error(`第 ${index + 1} 个参数 ${param.name} 应为 ${param.type} 类型`)
    }
  })
  return parsed
}
const startRun = (): void => {
  if (!problemStore.currentProblem || !canRun.value || runStore.isRunning) return
  saveDraft()
  isRunDialogOpen.value = false
  isOutputOpen.value = true
  activeOutputTab.value = 'run'
  if (runMode.value === 'examples') {
    runStore
      .run(problemStore.currentProblem.id, language.value, code.value, 'examples')
      .catch(() => undefined)
    return
  }
  let parsed: unknown
  try {
    parsed = validateRunInput()
  } catch (error: unknown) {
    runInputError.value = error instanceof Error ? error.message : '输入格式不正确'
    isRunDialogOpen.value = true
    return
  }
  runInputError.value = ''
  runStore
    .run(problemStore.currentProblem.id, language.value, code.value, 'custom', parsed)
    .catch(() => undefined)
}

const quickRun = async (): Promise<void> => {
  if (!authStore.isAuthenticated) {
    await router.push({ name: 'login', query: { redirect: route.fullPath } })
    return
  }
  const problem = problemStore.currentProblem
  if (!problem || !canRun.value || runStore.isRunning || submissionStore.isSubmitting) return
  saveDraft()
  isOutputOpen.value = true
  activeOutputTab.value = 'run'
  if (hasPublicCases.value) {
    isRunDialogOpen.value = false
    runStore.run(problem.id, language.value, code.value, 'examples').catch(() => undefined)
    return
  }
  await openRunDialog()
}

const handleShortcut = (actionId: string): void => {
  if (!problemStore.currentProblem) return
  switch (actionId) {
    case 'oj.run':
      void quickRun()
      break
    case 'oj.submit':
      void submitCode()
      break
    case 'oj.toggle-output':
      isOutputOpen.value = !isOutputOpen.value
      break
    case 'oj.reset-code':
      resetCode()
      break
    case 'oj.open-shortcuts':
      isShortcutDialogOpen.value = true
      break
    default:
      break
  }
}

const isTypingTarget = (target: EventTarget | null): boolean => {
  if (!(target instanceof HTMLElement)) return false
  if (target.isContentEditable) return true
  return target.tagName === 'INPUT' || target.tagName === 'TEXTAREA' || target.tagName === 'SELECT'
}

const onShortcutKeydown = (event: KeyboardEvent): void => {
  if (event.defaultPrevented || event.isComposing || event.repeat) return
  if (isRunDialogOpen.value || isShortcutDialogOpen.value) return
  if (isTypingTarget(event.target)) return
  if (event.target instanceof HTMLElement && event.target.closest('.monaco-editor')) return
  for (const action of SHORTCUT_ACTIONS) {
    if (action.scope !== 'oj') continue
    const binding =
      action.id in shortcutStore.resolved ? shortcutStore.resolved[action.id] : action.defaultKey
    if (binding && matchesShortcut(event, binding)) {
      event.preventDefault()
      handleShortcut(action.id)
      return
    }
  }
}

const MIN_PROBLEM_WIDTH = 320
const MIN_EDITOR_WIDTH = 420
const RESIZER_WIDTH = 8
const SPLIT_STORAGE_KEY = 'theseus-oj-split'
const pageRef = ref<HTMLElement | null>(null)
const resizerRef = ref<HTMLElement | null>(null)
const pageWidth = ref(0)
const problemWidth = ref(Number(localStorage.getItem(SPLIT_STORAGE_KEY)) || 0)

const currentProblemWidth = computed(
  () => problemWidth.value || (pageWidth.value - RESIZER_WIDTH) / 2,
)
const maxProblemWidth = computed(() =>
  Math.max(MIN_PROBLEM_WIDTH, pageWidth.value - MIN_EDITOR_WIDTH - RESIZER_WIDTH),
)
const clampWidth = (width: number): number =>
  Math.min(Math.max(width, MIN_PROBLEM_WIDTH), maxProblemWidth.value)
const applyWidth = (): void => {
  if (!pageRef.value) return
  pageRef.value.style.setProperty('--problem-width', `${clampWidth(currentProblemWidth.value)}px`)
}
const measurePageWidth = (): void => {
  if (pageRef.value) pageWidth.value = pageRef.value.clientWidth
}

let dragging = false
let activePointerId: number | null = null

const startResize = (event: PointerEvent): void => {
  if (event.pointerType === 'mouse' && event.button !== 0) return
  dragging = true
  activePointerId = event.pointerId
  resizerRef.value?.setPointerCapture(event.pointerId)
  document.body.classList.add('is-resizing')
}
const onPointerMove = (event: PointerEvent): void => {
  if (!dragging || !pageRef.value) return
  const left = pageRef.value.getBoundingClientRect().left
  problemWidth.value = clampWidth(event.clientX - left)
  applyWidth()
}
const stopResize = (): void => {
  if (!dragging) return
  dragging = false
  if (activePointerId !== null) {
    resizerRef.value?.releasePointerCapture(activePointerId)
    activePointerId = null
  }
  document.body.classList.remove('is-resizing')
  if (problemWidth.value) {
    localStorage.setItem(SPLIT_STORAGE_KEY, String(Math.round(problemWidth.value)))
  }
}
const resetSplit = (): void => {
  problemWidth.value = 0
  applyWidth()
  localStorage.removeItem(SPLIT_STORAGE_KEY)
}
const nudgeSplit = (delta: number): void => {
  problemWidth.value = clampWidth(currentProblemWidth.value + delta)
  applyWidth()
  localStorage.setItem(SPLIT_STORAGE_KEY, String(Math.round(problemWidth.value)))
}

// 编辑器与运行结果之间的上下分栏
const MIN_OUTPUT_HEIGHT = 96
const MIN_EDITOR_HEIGHT = 200
const EDITOR_TOOLBAR_HEIGHT = 52
const EDITOR_ACTIONS_HEIGHT = 60
const ROW_RESIZER_HEIGHT = 8
const OUTPUT_STORAGE_KEY = 'theseus-oj-output-height'
const editorPaneRef = ref<HTMLElement | null>(null)
const outputResizerRef = ref<HTMLElement | null>(null)
const outputPanelRef = ref<HTMLElement | null>(null)
const paneHeight = ref(0)
const outputHeight = ref(Number(localStorage.getItem(OUTPUT_STORAGE_KEY)) || 0)

// 未拖动过时高度由内容决定（0 表示不写死高度），所以这里直接量当前高度
const maxOutputHeight = computed(() =>
  Math.max(
    MIN_OUTPUT_HEIGHT,
    paneHeight.value -
      EDITOR_TOOLBAR_HEIGHT -
      EDITOR_ACTIONS_HEIGHT -
      ROW_RESIZER_HEIGHT -
      MIN_EDITOR_HEIGHT,
  ),
)
const currentOutputHeight = (): number =>
  Math.min(
    outputHeight.value || outputPanelRef.value?.offsetHeight || MIN_OUTPUT_HEIGHT,
    maxOutputHeight.value,
  )
const clampOutputHeight = (height: number): number =>
  Math.min(Math.max(height, MIN_OUTPUT_HEIGHT), maxOutputHeight.value)
const measurePaneHeight = (): void => {
  if (editorPaneRef.value) paneHeight.value = editorPaneRef.value.clientHeight
}
const applyOutputHeight = (): void => {
  const panel = outputPanelRef.value
  if (!panel) return
  if (!outputHeight.value || !isOutputOpen.value) {
    panel.style.removeProperty('height')
    panel.style.removeProperty('max-height')
    return
  }
  // 下限由拖动过程保证，这里只收敛上限，避免把用户拖出的高度弹回去
  panel.style.height = `${Math.min(outputHeight.value, maxOutputHeight.value)}px`
  panel.style.maxHeight = 'none'
}

let resizingRows = false
let rowPointerId: number | null = null
let rowStartY = 0
let rowStartHeight = 0
let rowMinHeight = MIN_OUTPUT_HEIGHT

const startResizeRows = (event: PointerEvent): void => {
  if (event.pointerType === 'mouse' && event.button !== 0) return
  resizingRows = true
  rowPointerId = event.pointerId
  rowStartY = event.clientY
  rowStartHeight = currentOutputHeight()
  // 结果区本身就比最小高度矮时（只有占位文案），允许它继续降低，避免第一次拖动就跳高
  rowMinHeight = Math.min(MIN_OUTPUT_HEIGHT, rowStartHeight)
  outputResizerRef.value?.setPointerCapture(event.pointerId)
  document.body.classList.add('is-resizing-rows')
}
const onRowPointerMove = (event: PointerEvent): void => {
  if (!resizingRows) return
  const next = rowStartHeight + (rowStartY - event.clientY)
  outputHeight.value = Math.min(Math.max(next, rowMinHeight), maxOutputHeight.value)
  applyOutputHeight()
}
const stopResizeRows = (): void => {
  if (!resizingRows) return
  resizingRows = false
  if (rowPointerId !== null) {
    outputResizerRef.value?.releasePointerCapture(rowPointerId)
    rowPointerId = null
  }
  document.body.classList.remove('is-resizing-rows')
  if (outputHeight.value) {
    localStorage.setItem(OUTPUT_STORAGE_KEY, String(Math.round(outputHeight.value)))
  }
}
const resetOutputHeight = (): void => {
  outputHeight.value = 0
  applyOutputHeight()
  localStorage.removeItem(OUTPUT_STORAGE_KEY)
}
const nudgeOutput = (delta: number): void => {
  const base = currentOutputHeight()
  outputHeight.value = Math.min(
    Math.max(base + delta, Math.min(MIN_OUTPUT_HEIGHT, base)),
    maxOutputHeight.value,
  )
  applyOutputHeight()
  localStorage.setItem(OUTPUT_STORAGE_KEY, String(Math.round(outputHeight.value)))
}
const onWindowResize = (): void => {
  measurePageWidth()
  applyWidth()
  measurePaneHeight()
  applyOutputHeight()
}

// 面板随题目加载才出现，出现后再补一次测量与恢复
watch(
  [editorPaneRef, outputPanelRef],
  () => {
    measurePaneHeight()
    applyOutputHeight()
  },
  { flush: 'post' },
)
watch(isOutputOpen, () => { applyOutputHeight() }, { flush: 'post' })

let pageObserver: ResizeObserver | null = null

onMounted(() => {
  void loadPage()
  measurePageWidth()
  applyWidth()
  measurePaneHeight()
  applyOutputHeight()
  window.addEventListener('resize', onWindowResize)
  window.addEventListener('beforeunload', saveDraft)
  window.addEventListener('keydown', onShortcutKeydown, true)
  window.addEventListener('pointermove', onPointerMove)
  window.addEventListener('pointerup', stopResize)
  window.addEventListener('pointercancel', stopResize)
  window.addEventListener('pointermove', onRowPointerMove)
  window.addEventListener('pointerup', stopResizeRows)
  window.addEventListener('pointercancel', stopResizeRows)
  if (typeof ResizeObserver !== 'undefined') {
    pageObserver = new ResizeObserver(() => {
      measurePageWidth()
      applyWidth()
    })
    if (pageRef.value) pageObserver.observe(pageRef.value)
  }
})
watch(language, (_next, previous) => {
  // 先取消尚未落盘的延迟写入，避免它用新语言覆盖旧语言的草稿
  cancelLocalDraftSave()
  localStorage.setItem(PREFERRED_LANGUAGE_KEY, language.value)
  // 先把上一种语言的当前代码落盘，再恢复新语言的草稿，避免切换时丢失编辑
  if (previous) {
    const previousKey = `theseus-draft-${problemId.value}-${previous}`
    if (code.value) localStorage.setItem(previousKey, code.value)
  }
  restoreDraft()
  isRunDialogOpen.value = false
  void hydrateDraftFromServer()
})
watch(fontSize, (value) => {
  localStorage.setItem(EDITOR_FONT_SIZE_KEY, String(value))
})
watch(editorTheme, (value) => {
  localStorage.setItem(EDITOR_THEME_KEY, value)
})
watch(completionEnabled, (value) => {
  localStorage.setItem(EDITOR_COMPLETION_KEY, value ? 'on' : 'off')
})
watch(code, () => {
  scheduleLocalDraftSave()
  if (!adoptingRemoteDraft) scheduleDraftSync()
})
watch(
  () => submissionStore.latest?.status,
  (status) => {
    if (status !== 'Accepted' || !problemStore.currentProblem) return
    clearDraftMeta(problemStore.currentProblem.id)
    // 通过后清掉云端草稿，避免首页继续学习展示已完成的题目
    cancelDraftSync()
    pendingDraftSync = false
    void pushDraftToServer(problemStore.currentProblem.id, language.value, '')
  },
)
watch([() => route.params.id, contestId], () => { void loadPage() })
watch(assignmentId, () => { void loadAssignmentContext() })
onBeforeUnmount(() => {
  submissionStore.stopPolling()
  runStore.stopPolling()
  // 把延迟写盘中的最后一次编辑立即落盘
  saveDraft()
  if (draftSyncTimer !== null || pendingDraftSync) {
    // 离开页面时立即把最后一次编辑同步到云端
    cancelDraftSync()
    pendingDraftSync = false
    const payload = code.value === templateFor(language.value) ? '' : code.value
    void pushDraftToServer(problemStore.currentProblem?.id, language.value, payload)
  }
  window.removeEventListener('resize', onWindowResize)
  window.removeEventListener('beforeunload', saveDraft)
  window.removeEventListener('keydown', onShortcutKeydown, true)
  window.removeEventListener('pointermove', onPointerMove)
  window.removeEventListener('pointerup', stopResize)
  window.removeEventListener('pointercancel', stopResize)
  window.removeEventListener('pointermove', onRowPointerMove)
  window.removeEventListener('pointerup', stopResizeRows)
  window.removeEventListener('pointercancel', stopResizeRows)
  pageObserver?.disconnect()
  pageObserver = null
  document.body.classList.remove('is-resizing')
  document.body.classList.remove('is-resizing-rows')
})
</script>

<template>
  <NavBar />
  <main ref="pageRef" class="oj-page">
    <div v-if="problemStore.isLoading || assignmentLoading" class="oj-loading">正在准备题目</div>
    <div v-else-if="assignmentError" class="oj-error"><h1>无法打开作业</h1><p>{{ assignmentError }}</p><RouterLink class="primary-button" to="/classes">返回组织</RouterLink></div>
    <div v-else-if="problemStore.error" class="oj-error"><h1>无法打开题目</h1><p>{{ problemStore.error }}</p><RouterLink class="primary-button" to="/problems">返回题库</RouterLink></div>
    <template v-else-if="problemStore.currentProblem">
      <section class="problem-pane">
        <div class="problem-pane-inner">
          <aside v-if="contestId" class="assignment-context contest-context">
            <div><span>比赛</span><strong>排位赛 #{{ contestId }}</strong></div>
            <span>比赛模式 · 题目由比赛提供，提交计入比赛成绩</span>
            <RouterLink :to="`/contests/${contestId}`">返回比赛</RouterLink>
          </aside>
          <aside v-else-if="assignmentId" class="assignment-context">
            <div><span>作业</span><strong>{{ assignment?.title ?? `作业 #${assignmentId}` }}</strong></div>
            <span v-if="assignment?.dueAt">截止 {{ new Date(assignment.dueAt).toLocaleString('zh-CN') }}</span>
            <span v-if="assignmentStateLabel" class="assignment-context-state">{{ assignmentStateLabel }}</span>
            <RouterLink :to="`/assignments/${assignmentId}`">返回作业</RouterLink>
          </aside>
          <header class="problem-heading">
            <h1>{{ problemStore.currentProblem.title }}</h1>
            <div class="problem-heading-actions">
              <button
                v-if="!contestId"
                type="button"
                :class="['problem-favorite-button', { active: problemStore.currentProblem.favorited }]"
                :disabled="favoriteBusy"
                @click="toggleProblemFavorite"
              >
                {{ problemStore.currentProblem.favorited ? '★ 已收藏' : '☆ 收藏' }}
              </button>
              <span :class="['difficulty', problemStore.currentProblem.difficulty]">{{ DIFFICULTY_LABELS[problemStore.currentProblem.difficulty] }}</span>
            </div>
          </header>
          <p v-if="favoriteError" class="form-error" role="alert">{{ favoriteError }}</p>
          <div class="problem-tags"><span v-for="tag in problemStore.currentProblem.tags" :key="tag" class="tag">{{ tag }}</span><span class="acceptance-stat">通过率 {{ problemStore.currentProblem.acceptance.toFixed(1) }}%</span></div>
          <div v-if="!contestId" class="problem-view-tabs" role="tablist" aria-label="题目内容">
            <button type="button" role="tab" :aria-selected="problemTab === 'description'" :class="{ active: problemTab === 'description' }" @click="problemTab = 'description'">题目描述</button>
            <button type="button" role="tab" :aria-selected="problemTab === 'discussion'" :class="{ active: problemTab === 'discussion' }" @click="problemTab = 'discussion'">题解与讨论</button>
            <button type="button" role="tab" :aria-selected="problemTab === 'note'" :class="{ active: problemTab === 'note' }" @click="problemTab = 'note'">笔记</button>
          </div>
          <article v-if="contestId || problemTab === 'description'" class="problem-content"><p v-for="paragraph in problemStore.currentProblem.description.split('\n\n')" :key="paragraph">{{ paragraph.replaceAll('**', '').replaceAll('*', '') }}</p><h2>示例</h2><div v-for="(example, index) in problemStore.currentProblem.examples" :key="`${example.input}-${index}`" class="example-block"><span>示例 {{ index + 1 }}</span><pre><b>输入：</b>{{ example.input }}
<b>输出：</b>{{ example.output }}</pre><p v-if="example.explanation"><b>解释：</b>{{ example.explanation }}</p></div><p v-if="!problemStore.currentProblem.examples.length" class="output-placeholder">暂无示例</p><h2>限制</h2><ul><li>时间限制：{{ problemStore.currentProblem.timeLimit }} ms</li><li>内存限制：{{ problemStore.currentProblem.memoryLimit }} MB</li></ul></article>
          <ProblemDiscussionPanel v-else-if="problemTab === 'discussion'" :problem-id="problemStore.currentProblem.id" />
          <ProblemNotePanel v-else :problem-id="problemStore.currentProblem.id" />
        </div>
      </section>
      <div
        ref="resizerRef"
        class="pane-resizer"
        role="separator"
        aria-orientation="vertical"
        aria-label="调整题目与编辑器宽度"
        :aria-valuenow="Math.round(clampWidth(currentProblemWidth))"
        :aria-valuemin="MIN_PROBLEM_WIDTH"
        :aria-valuemax="maxProblemWidth"
        tabindex="0"
        @pointerdown="startResize"
        @dblclick="resetSplit"
        @keydown.left.prevent="nudgeSplit(-24)"
        @keydown.right.prevent="nudgeSplit(24)"
      ></div>
      <section ref="editorPaneRef" class="editor-pane" :class="{ 'output-collapsed': !isOutputOpen }">
        <div class="editor-toolbar"><select v-model="language" aria-label="选择编程语言"><option v-for="option in LANGUAGE_OPTIONS" :key="option.value" :value="option.value">{{ option.label }}</option></select><div class="editor-tools"><button type="button" class="editor-completion-toggle" :class="{ active: editorCompletion }" :disabled="!completionAllowed" :aria-pressed="editorCompletion" :title="completionAllowed ? (completionEnabled ? '关闭语法补全' : '开启语法补全') : '比赛模式下不可使用语法补全'" @click="completionEnabled = !completionEnabled">补全</button><select v-model="editorTheme" class="editor-theme-select" aria-label="选择编辑器主题"><option v-for="option in EDITOR_THEME_OPTIONS" :key="option.value" :value="option.value">{{ option.label }}</option></select><button type="button" aria-label="减小字号" title="减小字体" @click="fontSize = Math.max(MIN_FONT_SIZE, fontSize - 1)">A−</button><span>{{ fontSize }}</span><button type="button" aria-label="增大字号" title="增大字体" @click="fontSize = Math.min(MAX_FONT_SIZE, fontSize + 1)">A+</button><button type="button" aria-label="快捷键" title="快捷键" @click="isShortcutDialogOpen = true">⌨</button></div></div>
        <CodeEditor ref="editorRef" v-model="code" :language="language" :font-size="fontSize" :theme="editorThemeName" :completion="editorCompletion" :shortcut-bindings="shortcutStore.resolved" @shortcut="handleShortcut" @paste-text="handleEditorPaste" />
        <div
          ref="outputResizerRef"
          class="pane-resizer-h"
          role="separator"
          aria-orientation="horizontal"
          aria-label="调整编辑器与运行结果的高度"
          :aria-valuenow="Math.round(clampOutputHeight(currentOutputHeight()))"
          :aria-valuemin="MIN_OUTPUT_HEIGHT"
          :aria-valuemax="maxOutputHeight"
          tabindex="0"
          @pointerdown="startResizeRows"
          @dblclick="resetOutputHeight"
          @keydown.up.prevent="nudgeOutput(24)"
          @keydown.down.prevent="nudgeOutput(-24)"
        ></div>
        <section ref="outputPanelRef" class="output-panel" :class="{ collapsed: !isOutputOpen }">
          <header>
            <div class="output-tabs">
              <button type="button" :class="{ active: activeOutputTab === 'run' }" @click="activeOutputTab = 'run'; isOutputOpen = true">运行结果</button>
              <button type="button" :class="{ active: activeOutputTab === 'submit' }" @click="activeOutputTab = 'submit'; isOutputOpen = true">提交结果</button>
              <button type="button" :class="{ active: activeOutputTab === 'history' }" @click="openHistoryTab">提交记录<template v-if="historyLoaded && historyTotal > 0"> · {{ historyTotal }}</template></button>
              <button type="button" class="output-toggle" :aria-expanded="isOutputOpen" :aria-label="isOutputOpen ? '收起结果面板' : '展开结果面板'" @click="isOutputOpen = !isOutputOpen"><span>{{ isOutputOpen ? '⌄' : '›' }}</span></button>
            </div>
            <span v-if="(activeOutputTab === 'run' && runStore.isRunning)" class="running-state"><i class="spinner"></i> {{ runButtonLabel }}</span>
            <span v-else-if="activeOutputTab === 'history' && historyLoaded" class="history-count">共 {{ historyTotal }} 条提交</span>
            <span v-else-if="outputStatusLabel" :class="['result-status', outputSucceeded ? 'accepted' : 'failed']">{{ outputStatusLabel }}<template v-if="activeOutputTab === 'run' && runStore.status && runStore.status.caseTotal > 0"> · {{ runStore.status.casePassed }}/{{ runStore.status.caseTotal }}</template></span>
          </header>
          <div v-if="isOutputOpen" class="output-body">
            <template v-if="activeOutputTab === 'run'">
              <p class="run-note">运行结果不计入提交 也不影响通过率</p>
              <template v-if="runStore.detail">
                <p v-if="runStore.detail.errorMessage" class="form-error" role="alert">{{ runStore.detail.errorMessage }}</p>
                <div v-if="runStore.detail.compileOutput" class="run-block"><span>编译输出</span><pre>{{ runStore.detail.compileOutput }}</pre></div>
                <p class="run-summary">通过 {{ runStore.detail.casePassed }} / {{ runStore.detail.caseTotal }}</p>
                <template v-if="runStore.detail.mode === 'examples'">
                  <div v-for="item in runStore.detail.cases" :key="item.index" class="run-case">
                    <header><span>示例 {{ item.index + 1 }}</span><span :class="['case-status', item.status]">{{ RUN_CASE_STATUS_LABELS[item.status] }}</span></header>
                    <div class="run-block"><span>输入</span><pre>{{ formatArgs(item.args, runConfig?.params) }}</pre></div>
                    <div class="run-block"><span>期望</span><pre>{{ formatInline(item.expected) }}</pre></div>
                    <div v-if="item.actual !== undefined" class="run-block"><span>实际</span><pre>{{ formatInline(item.actual) }}</pre></div>
                    <div v-if="item.stdout" class="run-block"><span>stdout</span><pre>{{ item.stdout }}</pre></div>
                    <div v-if="item.stderr" class="run-block"><span>stderr</span><pre>{{ item.stderr }}</pre></div>
                    <p v-if="item.truncated" class="run-note">输出超过 64 KB 已截断</p>
                  </div>
                </template>
                <template v-else>
                  <dl>
                    <div v-if="runStore.detail.runtimeMs !== null"><dt>执行用时</dt><dd>{{ runStore.detail.runtimeMs }} ms</dd></div>
                    <div v-if="runStore.detail.memoryKb"><dt>内存消耗</dt><dd>{{ runStore.detail.memoryKb >= 1024 ? `${(runStore.detail.memoryKb / 1024).toFixed(1)} MB` : `${runStore.detail.memoryKb} KB` }}</dd></div>
                  </dl>
                  <div v-if="runCase && runCase.status === 'passed'" class="run-block"><span>返回值</span><pre>{{ formatInline(runCase.actual) }}</pre></div>
                  <div v-if="runCase?.stdout" class="run-block"><span>stdout</span><pre>{{ runCase.stdout }}</pre></div>
                  <div v-if="runCase?.stderr" class="run-block"><span>stderr</span><pre>{{ runCase.stderr }}</pre></div>
                  <p v-if="runCase?.truncated" class="run-note">输出超过 64 KB 已截断</p>
                </template>
              </template>
              <p v-else-if="runStore.error" class="form-error" role="alert">{{ runStore.error }}</p>
              <p v-else-if="!runStore.isRunning" class="output-placeholder">运行代码后将在这里显示结果</p>
            </template>
            <template v-else-if="activeOutputTab === 'submit'">
              <template v-if="submissionStore.latest"><p>{{ submissionStore.latest.message }}</p><dl><div v-if="submissionStore.latest.totalTestCases"><dt>通过用例</dt><dd>{{ submissionStore.latest.testCasesPassed }} / {{ submissionStore.latest.totalTestCases }}</dd></div><div v-if="submissionStore.latest.runtime"><dt>执行用时</dt><dd>{{ submissionStore.latest.runtime }}</dd></div><div v-if="submissionStore.latest.memory"><dt>内存消耗</dt><dd>{{ submissionStore.latest.memory }}</dd></div></dl>
                <div v-if="submissionStore.latest.compileOutput" class="run-block"><span>编译输出</span><pre>{{ submissionStore.latest.compileOutput }}</pre></div>
                <template v-if="latestFailedCase">
                  <div class="run-block"><span>失败用例 #{{ latestFailedCase.index + 1 }} · 输入</span><pre>{{ formatInline(latestFailedCase.args) }}</pre></div>
                  <div v-if="latestFailedCase.expected !== undefined" class="run-block"><span>期望</span><pre>{{ formatInline(latestFailedCase.expected) }}</pre></div>
                  <div v-if="latestFailedCase.actual !== null" class="run-block"><span>实际</span><pre>{{ formatInline(latestFailedCase.actual) }}</pre></div>
                  <div v-if="latestFailedCase.stdout" class="run-block"><span>stdout</span><pre>{{ latestFailedCase.stdout }}</pre></div>
                  <div v-if="latestFailedCase.stderr" class="run-block"><span>stderr</span><pre>{{ latestFailedCase.stderr }}</pre></div>
                </template>
              </template>
              <p v-else class="output-placeholder">提交代码后将在这里显示评测结果</p>
              <p v-if="submissionStore.error" class="form-error" role="alert">{{ submissionStore.error }}</p>
            </template>
            <template v-else>
              <template v-if="!authStore.isAuthenticated">
                <p class="output-placeholder">登录后可查看本题的提交记录</p>
                <RouterLink class="primary-button" :to="{ name: 'login', query: { redirect: route.fullPath } }">去登录 <span>→</span></RouterLink>
              </template>
              <template v-else>
                <div class="history-toolbar">
                  <span class="run-note">仅显示本题的提交，可回看代码并重新载入编辑器</span>
                  <button type="button" class="history-refresh" :disabled="historyLoading" @click="loadHistory(historyPage)">{{ historyLoading ? '刷新中' : '刷新' }}</button>
                </div>
                <p v-if="historyError" class="form-error" role="alert">{{ historyError }}</p>
                <div v-if="historyLoading && !historyItems.length" class="output-placeholder">正在加载提交记录</div>
                <div v-else-if="historyItems.length" class="history-list">
                  <button v-for="item in historyItems" :key="item.id" type="button" class="history-item" @click="openHistoryDetail(item)">
                    <span :class="['result-status', item.status === 'Accepted' ? 'accepted' : 'failed']">{{ item.status }}</span>
                    <span class="history-id">#{{ item.id }}</span>
                    <span>{{ languageLabel(item.language) }}</span>
                    <span>{{ item.testCasesPassed }}/{{ item.totalTestCases }}</span>
                    <span>{{ item.runtime ?? '—' }}</span>
                    <time>{{ formatTime(item.createdAt) }}</time>
                  </button>
                </div>
                <div v-else-if="historyLoaded" class="output-placeholder">还没有提交记录</div>
                <div v-if="historyTotalPages > 1" class="history-pagination">
                  <button type="button" :disabled="historyPage <= 1 || historyLoading" @click="loadHistory(historyPage - 1)">上一页</button>
                  <span>{{ historyPage }} / {{ historyTotalPages }}</span>
                  <button type="button" :disabled="historyPage >= historyTotalPages || historyLoading" @click="loadHistory(historyPage + 1)">下一页</button>
                </div>
              </template>
            </template>
          </div>
        </section>
        <footer class="editor-actions">
          <button class="reset-button" type="button" @click="resetCode">↺ 重置代码</button>
          <div>
            <button v-if="runFeatureEnabled" class="run-button" type="button" :disabled="!canRun || runStore.isRunning || submissionStore.isSubmitting" :title="runDisabledReason || '运行自定义输入'" @click="openRunDialog">{{ runButtonLabel }}</button>
            <button class="submit-button" type="button" :disabled="!submitFeatureEnabled || submissionStore.isSubmitting || runStore.isRunning || !code.trim() || (Boolean(assignmentId) && !canSubmitCode)" :title="assignmentStateLabel || (submitFeatureEnabled ? '' : '提交评测暂未开放')" @click="submitCode">{{ !submitFeatureEnabled ? '提交评测暂未开放' : submissionStore.isSubmitting ? '评测中' : assignmentId && !canSubmitCode ? '不可提交' : '提交代码' }} <span v-if="submitFeatureEnabled">→</span></button>
          </div>
        </footer>
      </section>
    </template>
  </main>

  <div v-if="isRunDialogOpen" class="modal-backdrop" @click.self="closeRunDialog">
    <section class="run-dialog" role="dialog" aria-modal="true" aria-labelledby="run-dialog-title">
      <header><div><h2 id="run-dialog-title">运行代码</h2><p>自定义输入</p></div><button type="button" aria-label="关闭" @click="closeRunDialog">×</button></header>
      <div class="run-dialog-body">
        <div class="run-mode-tabs">
          <button type="button" :class="{ active: runMode === 'examples' }" :disabled="!hasPublicCases" @click="runMode = 'examples'">运行全部示例</button>
          <button type="button" :class="{ active: runMode === 'custom' }" @click="runMode = 'custom'">自定义输入</button>
        </div>
        <template v-if="runMode === 'examples'">
          <p class="run-note">共 {{ runConfig?.publicCases.length ?? 0 }} 条公开用例 运行结果不计入提交</p>
          <ol class="example-preview">
            <li v-for="(item, index) in runConfig?.publicCases ?? []" :key="index">
              <span>示例 {{ index + 1 }}</span>
              <pre>输入：{{ formatArgs(item.args, runConfig?.params) }}
期望：{{ formatInline(item.expected) }}</pre>
            </li>
          </ol>
        </template>
        <template v-else>
          <p class="run-hint">{{ parameterHint }}</p>
          <label for="run-input">JSON 参数数组</label>
          <textarea id="run-input" v-model="runInput" spellcheck="false" rows="8" @input="runInputError = ''"></textarea>
          <p v-if="runInputError" class="form-error" role="alert">{{ runInputError }}</p>
        </template>
      </div>
      <footer><button class="run-button" type="button" @click="closeRunDialog">取消</button><button class="primary-button" type="button" :disabled="runStore.isRunning" @click="startRun">运行</button></footer>
    </section>
  </div>

  <div v-if="historyDetail || historyDetailLoading || historyDetailError" class="modal-backdrop" @click.self="closeHistoryDetail">
    <section class="run-dialog run-record-dialog history-detail-dialog" role="dialog" aria-modal="true" aria-labelledby="history-detail-title">
      <header>
        <div>
          <h2 id="history-detail-title">提交 #{{ historyDetail?.id ?? '' }}</h2>
          <p v-if="historyDetail">{{ languageLabel(historyDetail.language) }} · {{ formatTime(historyDetail.createdAt) }}</p>
          <p v-else>正在加载提交详情</p>
        </div>
        <button type="button" aria-label="关闭" @click="closeHistoryDetail">×</button>
      </header>
      <div class="run-dialog-body">
        <p v-if="historyDetailLoading" class="run-note">正在加载提交详情</p>
        <p v-if="historyDetailError" class="form-error" role="alert">{{ historyDetailError }}</p>
        <template v-if="historyDetail">
          <p :class="historyDetail.status === 'Accepted' ? 'run-note' : 'form-error'">{{ historyDetail.message }}</p>
          <dl>
            <div><dt>状态</dt><dd>{{ historyDetail.status }}</dd></div>
            <div><dt>通过用例</dt><dd>{{ historyDetail.testCasesPassed }} / {{ historyDetail.totalTestCases }}</dd></div>
            <div v-if="historyDetail.runtime"><dt>执行用时</dt><dd>{{ historyDetail.runtime }}</dd></div>
            <div v-if="historyDetail.memory"><dt>内存消耗</dt><dd>{{ historyDetail.memory }}</dd></div>
          </dl>
          <div v-if="historyDetail.compileOutput" class="run-block"><span>编译输出</span><pre>{{ historyDetail.compileOutput }}</pre></div>
          <template v-if="historyDetail.failedCase">
            <div class="run-block"><span>失败用例 #{{ historyDetail.failedCase.index + 1 }} · 输入</span><pre>{{ formatInline(historyDetail.failedCase.args) }}</pre></div>
            <div v-if="historyDetail.failedCase.expected !== undefined" class="run-block"><span>期望</span><pre>{{ formatInline(historyDetail.failedCase.expected) }}</pre></div>
            <div v-if="historyDetail.failedCase.actual !== null" class="run-block"><span>实际</span><pre>{{ formatInline(historyDetail.failedCase.actual) }}</pre></div>
            <div v-if="historyDetail.failedCase.stdout" class="run-block"><span>stdout</span><pre>{{ historyDetail.failedCase.stdout }}</pre></div>
            <div v-if="historyDetail.failedCase.stderr" class="run-block"><span>stderr</span><pre>{{ historyDetail.failedCase.stderr }}</pre></div>
          </template>
          <div class="history-code-block">
            <div class="history-code-heading">
              <span>代码</span>
              <button type="button" class="history-diff-toggle" @click="showHistoryDiff = !showHistoryDiff">{{ showHistoryDiff ? '收起对比' : '对比当前代码' }}</button>
            </div>
            <pre class="history-code">{{ historyDetail.code }}</pre>
          </div>
          <div v-if="showHistoryDiff" class="history-diff">
            <div class="history-diff-heading"><span>历史代码</span><span>当前编辑器</span></div>
            <div v-if="historyDiffRows" class="history-diff-body">
              <div v-for="(row, index) in historyDiffRows" :key="index" :class="['history-diff-row', row.kind]">
                <span class="history-diff-no">{{ row.leftNumber ?? '' }}</span>
                <pre>{{ row.left ?? '' }}</pre>
                <span class="history-diff-no">{{ row.rightNumber ?? '' }}</span>
                <pre>{{ row.right ?? '' }}</pre>
              </div>
            </div>
            <p v-else class="run-note">代码较长，已跳过逐行对比</p>
          </div>
        </template>
      </div>
      <footer>
        <button class="run-button" type="button" @click="closeHistoryDetail">关闭</button>
        <button class="primary-button" type="button" :disabled="!historyDetail" @click="applyHistoryCode">载入编辑器</button>
      </footer>
    </section>
  </div>

  <ShortcutDialog v-if="isShortcutDialogOpen" @close="isShortcutDialogOpen = false" />
</template>
