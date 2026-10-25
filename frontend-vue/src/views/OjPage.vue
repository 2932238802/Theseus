<script setup lang="ts">
import { computed, onBeforeUnmount, onMounted, ref, watch } from 'vue'
import { useRoute, useRouter } from 'vue-router'
import NavBar from '../components/NavBar.vue'
import CodeEditor from '../components/CodeEditor.vue'
import { useAuthStore } from '../store/auth'
import { useProblemStore } from '../store/problems'
import { useRunStore } from '../store/runs'
import { useSubmissionStore } from '../store/submissions'
import {
  DIFFICULTY_LABELS,
  LANGUAGE_OPTIONS,
  RUN_CASE_STATUS_LABELS,
  RUN_STATUS_LABELS,
} from '../utils/constants'
import type { Language } from '../types/oj'
import type { RunMode } from '../types/run'

const route = useRoute()
const router = useRouter()
const authStore = useAuthStore()
const problemStore = useProblemStore()
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
const activeOutputTab = ref<'run' | 'submit'>('submit')
const isRunDialogOpen = ref(false)
const runMode = ref<RunMode>('examples')
const runInput = ref('')
const runInputError = ref('')
const runFeatureEnabled = import.meta.env.VITE_RUN_CODE_ENABLED !== 'false'

const runConfig = computed(() => problemStore.currentProblem?.runConfig)
const canRun = computed(
  () =>
    runFeatureEnabled &&
    Boolean(runConfig.value) &&
    (language.value === 'python' || language.value === 'javascript') &&
    Boolean(problemStore.currentProblem),
)
const runDisabledReason = computed(() => {
  if (!runFeatureEnabled) return '运行功能暂未开放'
  if (!runConfig.value) return '该题暂未配置运行'
  if (language.value !== 'python' && language.value !== 'javascript') return '暂不支持运行该语言，当前支持 Python 与 JavaScript'
  return ''
})
const hasPublicCases = computed(() => (runConfig.value?.publicCases.length ?? 0) > 0)
const runButtonLabel = computed(() => {
  if (!runStore.isRunning) return '运行'
  const current = runStore.status?.status
  if (current === 'running') return '运行中…'
  if (current === 'compiling') return '编译中…'
  return '排队中…'
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
const loadPage = async (): Promise<void> => {
  submissionStore.stopPolling()
  submissionStore.latest = null
  runStore.reset()
  activeOutputTab.value = 'submit'
  isRunDialogOpen.value = false
  await problemStore.loadProblem(problemId.value)
  restoreDraft()
}
const submitCode = async (): Promise<void> => {
  if (!problemStore.currentProblem || !code.value.trim() || submissionStore.isSubmitting) return
  if (!authStore.isAuthenticated) {
    await router.push({ name: 'login', query: { redirect: route.fullPath } })
    return
  }
  saveDraft()
  isOutputOpen.value = true
  activeOutputTab.value = 'submit'
  try {
    await submissionStore.submit(problemStore.currentProblem.id, language.value, code.value)
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
const typeMatches = (type: string, value: unknown): boolean => {
  switch (type) {
    case 'int':
      return typeof value === 'number' && Number.isInteger(value) && value >= -2147483648 && value <= 2147483647
    case 'long':
      return typeof value === 'number' && Number.isSafeInteger(value)
    case 'double':
      return typeof value === 'number' && Number.isFinite(value)
    case 'bool':
      return typeof value === 'boolean'
    case 'string':
      return typeof value === 'string'
    default:
      break
  }
  if (type.endsWith('[]') && !type.endsWith('[][]')) {
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
    throw new Error(`参数个数不匹配：需要 ${config.params.length} 个，收到 ${parsed.length} 个`)
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
const formatValue = (value: unknown): string => {
  if (value === undefined) return '—'
  return JSON.stringify(value, null, 2) ?? 'null'
}

onMounted(() => { void loadPage() })
watch(language, () => {
  restoreDraft()
  isRunDialogOpen.value = false
})
watch(code, saveDraft)
watch(() => route.params.id, () => { void loadPage() })
onBeforeUnmount(() => {
  submissionStore.stopPolling()
  runStore.stopPolling()
})
</script>

<template>
  <NavBar />
  <main class="oj-page">
    <div v-if="problemStore.isLoading" class="oj-loading">正在准备题目…</div>
    <div v-else-if="problemStore.error" class="oj-error"><h1>无法打开题目</h1><p>{{ problemStore.error }}</p><RouterLink class="primary-button" to="/problems">返回题库</RouterLink></div>
    <template v-else-if="problemStore.currentProblem">
      <section class="problem-pane">
        <div class="problem-pane-inner">
          <div class="breadcrumb"><RouterLink to="/problems">题库</RouterLink><span>/</span><span>{{ problemStore.currentProblem.id }}. {{ problemStore.currentProblem.title }}</span></div>
          <header class="problem-heading"><h1>{{ problemStore.currentProblem.title }}</h1><span :class="['difficulty', problemStore.currentProblem.difficulty]">{{ DIFFICULTY_LABELS[problemStore.currentProblem.difficulty] }}</span></header>
          <div class="problem-tags"><span v-for="tag in problemStore.currentProblem.tags" :key="tag" class="tag">{{ tag }}</span><span class="acceptance-stat">通过率 {{ problemStore.currentProblem.acceptance.toFixed(1) }}%</span></div>
          <article class="problem-content"><p v-for="paragraph in problemStore.currentProblem.description.split('\n\n')" :key="paragraph">{{ paragraph.replaceAll('**', '').replaceAll('*', '') }}</p><h2>示例</h2><div v-for="(example, index) in problemStore.currentProblem.examples" :key="`${example.input}-${index}`" class="example-block"><span>示例 {{ index + 1 }}</span><pre><b>输入：</b>{{ example.input }}
<b>输出：</b>{{ example.output }}</pre><p v-if="example.explanation"><b>解释：</b>{{ example.explanation }}</p></div><p v-if="!problemStore.currentProblem.examples.length" class="output-placeholder">暂无示例。</p><h2>限制</h2><ul><li>时间限制：{{ problemStore.currentProblem.timeLimit }} ms</li><li>内存限制：{{ problemStore.currentProblem.memoryLimit }} MB</li></ul></article>
        </div>
      </section>
      <section class="editor-pane">
        <div class="editor-toolbar"><select v-model="language" aria-label="选择编程语言"><option v-for="option in LANGUAGE_OPTIONS" :key="option.value" :value="option.value">{{ option.label }}</option></select><div class="editor-tools"><button type="button" aria-label="减小字号" title="减小字体" @click="fontSize = Math.max(12, fontSize - 1)">A−</button><span>{{ fontSize }}</span><button type="button" aria-label="增大字号" title="增大字体" @click="fontSize = Math.min(20, fontSize + 1)">A+</button><button type="button" aria-label="切换编辑器主题" title="切换编辑器主题" @click="isDark = !isDark">◐</button></div></div>
        <CodeEditor v-model="code" :language="language" :font-size="fontSize" :dark="isDark" />
        <section class="output-panel" :class="{ collapsed: !isOutputOpen }">
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
              <p class="run-note">运行结果不计入提交，也不影响通过率。</p>
              <template v-if="runStore.detail">
                <p v-if="runStore.detail.errorMessage" class="form-error" role="alert">{{ runStore.detail.errorMessage }}</p>
                <p class="run-summary">通过 {{ runStore.detail.casePassed }} / {{ runStore.detail.caseTotal }}</p>
                <template v-if="runStore.detail.mode === 'examples'">
                  <div v-for="item in runStore.detail.cases" :key="item.index" class="run-case">
                    <header><span>示例 {{ item.index + 1 }}</span><span :class="['case-status', item.status]">{{ RUN_CASE_STATUS_LABELS[item.status] }}</span></header>
                    <div class="run-block"><span>输入</span><pre>{{ formatValue(item.args) }}</pre></div>
                    <div class="run-block"><span>期望</span><pre>{{ formatValue(item.expected) }}</pre></div>
                    <div v-if="item.actual !== undefined" class="run-block"><span>实际</span><pre>{{ formatValue(item.actual) }}</pre></div>
                    <div v-if="item.stdout" class="run-block"><span>stdout</span><pre>{{ item.stdout }}</pre></div>
                    <div v-if="item.stderr" class="run-block"><span>stderr</span><pre>{{ item.stderr }}</pre></div>
                    <p v-if="item.truncated" class="run-note">输出超过 64 KB，已截断。</p>
                  </div>
                </template>
                <template v-else>
                  <dl>
                    <div v-if="runStore.detail.runtimeMs !== null"><dt>执行用时</dt><dd>{{ runStore.detail.runtimeMs }} ms</dd></div>
                    <div v-if="runStore.detail.memoryKb"><dt>内存消耗</dt><dd>{{ runStore.detail.memoryKb >= 1024 ? `${(runStore.detail.memoryKb / 1024).toFixed(1)} MB` : `${runStore.detail.memoryKb} KB` }}</dd></div>
                  </dl>
                  <div v-if="runCase && runCase.status === 'passed'" class="run-block"><span>返回值</span><pre>{{ formatValue(runCase.actual) }}</pre></div>
                  <div v-if="runCase?.stdout" class="run-block"><span>stdout</span><pre>{{ runCase.stdout }}</pre></div>
                  <div v-if="runCase?.stderr" class="run-block"><span>stderr</span><pre>{{ runCase.stderr }}</pre></div>
                  <p v-if="runCase?.truncated" class="run-note">输出超过 64 KB，已截断。</p>
                </template>
              </template>
              <p v-else-if="runStore.error" class="form-error" role="alert">{{ runStore.error }}</p>
              <p v-else-if="!runStore.isRunning" class="output-placeholder">运行代码后将在这里显示结果。</p>
            </template>
            <template v-else>
              <template v-if="submissionStore.latest"><p>{{ submissionStore.latest.message }}</p><dl><div v-if="submissionStore.latest.totalTestCases"><dt>通过用例</dt><dd>{{ submissionStore.latest.testCasesPassed }} / {{ submissionStore.latest.totalTestCases }}</dd></div><div v-if="submissionStore.latest.runtime"><dt>执行用时</dt><dd>{{ submissionStore.latest.runtime }}</dd></div><div v-if="submissionStore.latest.memory"><dt>内存消耗</dt><dd>{{ submissionStore.latest.memory }}</dd></div></dl></template>
              <p v-else class="output-placeholder">提交代码后将在这里显示评测结果。</p>
              <p v-if="submissionStore.error" class="form-error" role="alert">{{ submissionStore.error }}</p>
            </template>
          </div>
        </section>
        <footer class="editor-actions">
          <button class="reset-button" type="button" @click="resetCode">↺ 重置代码</button>
          <div>
            <button v-if="runFeatureEnabled" class="run-button" type="button" :disabled="!canRun || runStore.isRunning || submissionStore.isSubmitting" :title="runDisabledReason || '运行自定义输入'" @click="openRunDialog">{{ runButtonLabel }}</button>
            <button class="submit-button" type="button" :disabled="submissionStore.isSubmitting || runStore.isRunning || !code.trim()" @click="submitCode">{{ submissionStore.isSubmitting ? '评测中…' : '提交代码' }} <span>→</span></button>
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
          <p class="run-note">共 {{ runConfig?.publicCases.length ?? 0 }} 条公开用例，运行结果不计入提交。</p>
          <ol class="example-preview">
            <li v-for="(item, index) in runConfig?.publicCases ?? []" :key="index">
              <span>示例 {{ index + 1 }}</span>
              <pre>输入：{{ formatValue(item.args) }}
期望：{{ formatValue(item.expected) }}</pre>
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
</template>
