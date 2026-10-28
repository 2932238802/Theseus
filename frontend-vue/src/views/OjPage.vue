<script setup lang="ts">
import { computed, onBeforeUnmount, onMounted, ref, watch } from 'vue'
import { useRoute, useRouter } from 'vue-router'
import NavBar from '../components/NavBar.vue'
import CodeEditor from '../components/CodeEditor.vue'
import ShortcutDialog from '../components/ShortcutDialog.vue'
import { useAuthStore } from '../store/auth'
import { useProblemStore } from '../store/problems'
import { useRunStore } from '../store/runs'
import { useShortcutStore } from '../store/shortcuts'
import { useSubmissionStore } from '../store/submissions'
import { fetchAssignment } from '../api/assignments'
import { fetchContestProblem } from '../api/contests'
import { toErrorMessage } from '../api/client'
import type { AssignmentDetail } from '../types/teaching'
import {
  DIFFICULTY_LABELS,
  LANGUAGE_OPTIONS,
  RUN_CASE_STATUS_LABELS,
  RUN_STATUS_LABELS,
} from '../utils/constants'
import { SHORTCUT_ACTIONS, matchesShortcut } from '../utils/shortcuts'
import type { Language } from '../types/oj'
import type { RunMode } from '../types/run'
import { formatArgs, formatInline } from '../utils/format'
import { useContestEvents } from '../utils/contestEvents'

const route = useRoute()
const router = useRouter()
const authStore = useAuthStore()
const problemStore = useProblemStore()
const shortcutStore = useShortcutStore()
const submissionStore = useSubmissionStore()
const runStore = useRunStore()
const problemId = computed(() => Number(route.params.id))
const language = ref<Language>('javascript')
const code = ref('')
const fontSize = ref(14)
const isOutputOpen = ref(true)
const isDark = ref(document.documentElement.dataset.theme === 'dark')
const draftKey = computed(() => `theseus-draft-${problemId.value}-${language.value}`)
const isAccepted = computed(() => submissionStore.latest?.status === 'Accepted')
const latestFailedCase = computed(() => submissionStore.latest?.failedCase ?? null)
const activeOutputTab = ref<'run' | 'submit'>('submit')
const isRunDialogOpen = ref(false)
const isShortcutDialogOpen = ref(false)
const runMode = ref<RunMode>('examples')
const runInput = ref('')
const runInputError = ref('')
const runFeatureEnabled = import.meta.env.VITE_RUN_CODE_ENABLED !== 'false'
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
useContestEvents(contestId, contestEventsEnabled)
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
const outputStatusLabel = computed(() =>
  activeOutputTab.value === 'run' ? runStatusLabel.value : submissionStore.latest?.status ?? '',
)
const outputSucceeded = computed(() =>
  activeOutputTab.value === 'run'
    ? runStore.detail?.status === 'completed'
    : isAccepted.value,
)
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
const saveDraft = (): void => {
  if (code.value) localStorage.setItem(draftKey.value, code.value)
}
const resetCode = (): void => {
  code.value = templateFor(language.value)
  saveDraft()
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
  activeOutputTab.value = 'submit'
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
    await submissionStore.submit(
      problemStore.currentProblem.id,
      language.value,
      code.value,
      contestId.value ? undefined : (assignmentId.value ?? undefined),
      contestId.value ?? undefined,
    )
  } catch {
    isOutputOpen.value = true
  }
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
watch(language, () => {
  restoreDraft()
  isRunDialogOpen.value = false
})
watch(code, saveDraft)
watch([() => route.params.id, contestId], () => { void loadPage() })
watch(assignmentId, () => { void loadAssignmentContext() })
onBeforeUnmount(() => {
  submissionStore.stopPolling()
  runStore.stopPolling()
  window.removeEventListener('resize', onWindowResize)
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
    <div v-else-if="assignmentError" class="oj-error"><h1>无法打开作业</h1><p>{{ assignmentError }}</p><RouterLink class="primary-button" to="/classes">返回班级</RouterLink></div>
    <div v-else-if="problemStore.error" class="oj-error"><h1>无法打开题目</h1><p>{{ problemStore.error }}</p><RouterLink class="primary-button" to="/problems">返回题库</RouterLink></div>
    <template v-else-if="problemStore.currentProblem">
      <section class="problem-pane">
        <div class="problem-pane-inner">
          <div class="breadcrumb"><RouterLink :to="contestId ? '/contests' : '/problems'">{{ contestId ? '竞赛' : '题库' }}</RouterLink><span>/</span><span>{{ problemStore.currentProblem.id }}. {{ problemStore.currentProblem.title }}</span></div>
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
          <header class="problem-heading"><h1>{{ problemStore.currentProblem.title }}</h1><span :class="['difficulty', problemStore.currentProblem.difficulty]">{{ DIFFICULTY_LABELS[problemStore.currentProblem.difficulty] }}</span></header>
          <div class="problem-tags"><span v-for="tag in problemStore.currentProblem.tags" :key="tag" class="tag">{{ tag }}</span><span class="acceptance-stat">通过率 {{ problemStore.currentProblem.acceptance.toFixed(1) }}%</span></div>
          <article class="problem-content"><p v-for="paragraph in problemStore.currentProblem.description.split('\n\n')" :key="paragraph">{{ paragraph.replaceAll('**', '').replaceAll('*', '') }}</p><h2>示例</h2><div v-for="(example, index) in problemStore.currentProblem.examples" :key="`${example.input}-${index}`" class="example-block"><span>示例 {{ index + 1 }}</span><pre><b>输入：</b>{{ example.input }}
<b>输出：</b>{{ example.output }}</pre><p v-if="example.explanation"><b>解释：</b>{{ example.explanation }}</p></div><p v-if="!problemStore.currentProblem.examples.length" class="output-placeholder">暂无示例</p><h2>限制</h2><ul><li>时间限制：{{ problemStore.currentProblem.timeLimit }} ms</li><li>内存限制：{{ problemStore.currentProblem.memoryLimit }} MB</li></ul></article>
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
        <div class="editor-toolbar"><select v-model="language" aria-label="选择编程语言"><option v-for="option in LANGUAGE_OPTIONS" :key="option.value" :value="option.value">{{ option.label }}</option></select><div class="editor-tools"><button type="button" aria-label="减小字号" title="减小字体" @click="fontSize = Math.max(12, fontSize - 1)">A−</button><span>{{ fontSize }}</span><button type="button" aria-label="增大字号" title="增大字体" @click="fontSize = Math.min(20, fontSize + 1)">A+</button><button type="button" aria-label="切换编辑器主题" title="切换编辑器主题" @click="isDark = !isDark">◐</button><button type="button" aria-label="快捷键" title="快捷键" @click="isShortcutDialogOpen = true">⌨</button></div></div>
        <CodeEditor v-model="code" :language="language" :font-size="fontSize" :dark="isDark" :shortcut-bindings="shortcutStore.resolved" @shortcut="handleShortcut" />
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
              <button type="button" class="output-toggle" :aria-expanded="isOutputOpen" :aria-label="isOutputOpen ? '收起结果面板' : '展开结果面板'" @click="isOutputOpen = !isOutputOpen"><span>{{ isOutputOpen ? '⌄' : '›' }}</span></button>
            </div>
            <span v-if="(activeOutputTab === 'run' && runStore.isRunning)" class="running-state"><i class="spinner"></i> {{ runButtonLabel }}</span>
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
            <template v-else>
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

  <ShortcutDialog v-if="isShortcutDialogOpen" @close="isShortcutDialogOpen = false" />
</template>
