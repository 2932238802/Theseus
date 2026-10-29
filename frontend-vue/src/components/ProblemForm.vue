<script setup lang="ts">
import { reactive, ref, watch } from 'vue'
import type { Difficulty, ProblemExample } from '../types/oj'
import type { ProblemEditorPayload, ReviewedProblemDetail } from '../types/problemReview'
import { DIFFICULTY_LABELS } from '../utils/constants'

const props = withDefaults(
  defineProps<{
    initial?: ReviewedProblemDetail | null
    submitLabel?: string
    submitting?: boolean
    serverError?: string
  }>(),
  {
    initial: null,
    submitLabel: '提交审核',
    submitting: false,
    serverError: '',
  },
)

const emit = defineEmits<{
  submit: [payload: ProblemEditorPayload]
}>()

const DEFAULT_RUN_CONFIG = `{
  "version": 1,
  "function_name": "solve",
  "params": [
    { "name": "nums", "type": "int[]" }
  ],
  "return_type": "int",
  "compare": { "mode": "exact" },
  "public_cases": [
    { "args": [[1, 2, 3]], "expected": 6 }
  ]
}`

const form = reactive({
  title: '',
  description: '',
  difficulty: 'easy' as Difficulty,
  timeLimit: 1000,
  memoryLimit: 256,
  tagsText: '',
})
const examples = ref<ProblemExample[]>([{ input: '', output: '', explanation: '' }])
const testCasesText = ref('[]')
const runConfigText = ref(DEFAULT_RUN_CONFIG)
const judgeCasesText = ref('[]')
const formError = ref('')

const blankExample = (): ProblemExample => ({ input: '', output: '', explanation: '' })

const applyInitial = (value: ReviewedProblemDetail | null): void => {
  formError.value = ''
  if (!value) {
    form.title = ''
    form.description = ''
    form.difficulty = 'easy'
    form.timeLimit = 1000
    form.memoryLimit = 256
    form.tagsText = ''
    examples.value = [blankExample()]
    testCasesText.value = '[]'
    runConfigText.value = DEFAULT_RUN_CONFIG
    judgeCasesText.value = '[]'
    return
  }
  form.title = value.title
  form.description = value.description
  form.difficulty = value.difficulty
  form.timeLimit = value.timeLimit
  form.memoryLimit = value.memoryLimit
  form.tagsText = value.tags.join(', ')
  examples.value = value.examples.length
    ? value.examples.map((example) => ({ ...example }))
    : [blankExample()]
  testCasesText.value = Array.isArray(value.testCases)
    ? JSON.stringify(value.testCases, null, 2)
    : '[]'
  runConfigText.value =
    value.runConfig === null || value.runConfig === undefined
      ? ''
      : JSON.stringify(value.runConfig, null, 2)
  judgeCasesText.value = Array.isArray(value.judgeCases)
    ? JSON.stringify(value.judgeCases, null, 2)
    : '[]'
}

watch(() => props.initial, applyInitial, { immediate: true })

const addExample = (): void => {
  examples.value.push(blankExample())
}

const removeExample = (index: number): void => {
  examples.value.splice(index, 1)
  if (!examples.value.length) examples.value.push(blankExample())
}

const parseJson = (label: string, text: string, fallback: unknown): unknown => {
  const trimmed = text.trim()
  if (!trimmed) return fallback
  try {
    return JSON.parse(trimmed) as unknown
  } catch {
    throw new Error(`${label} 不是合法 JSON`)
  }
}

const normalizeTags = (): string[] => {
  const seen = new Set<string>()
  return form.tagsText
    .split(/[,，]/)
    .map((tag) => tag.trim())
    .filter((tag) => tag && !seen.has(tag) && Boolean(seen.add(tag)))
}

const normalizeExamples = (): ProblemExample[] => {
  const rows = examples.value
    .map((example) => ({
      input: example.input.trim(),
      output: example.output.trim(),
      explanation: example.explanation?.trim() || undefined,
    }))
    .filter((example) => example.input || example.output || example.explanation)
  if (rows.some((example) => !example.input || !example.output)) {
    throw new Error('每个示例都需要填写输入和输出')
  }
  return rows
}

const submit = (): void => {
  formError.value = ''
  try {
    if (!form.title.trim()) throw new Error('题目标题不能为空')
    if (!form.description.trim()) throw new Error('题目描述不能为空')
    const imageWithoutAlt = [...form.description.matchAll(/!\[([^\]]*)\]\(([^)]+)\)/g)].some(
      (match) => !match[1]?.trim(),
    )
    if (imageWithoutAlt) {
      throw new Error('题面图片需要填写替代文本，例如 ![二维网格示意图](https://...)')
    }
    const timeLimit = Number(form.timeLimit)
    const memoryLimit = Number(form.memoryLimit)
    if (!Number.isInteger(timeLimit) || timeLimit <= 0) throw new Error('时间限制必须是正整数')
    if (!Number.isInteger(memoryLimit) || memoryLimit <= 0) throw new Error('内存限制必须是正整数')

    const testCases = parseJson('test_cases', testCasesText.value, [])
    if (!Array.isArray(testCases)) throw new Error('test_cases 必须是 JSON 数组')
    const runConfig = parseJson('run_config', runConfigText.value, null)
    if (runConfig !== null && (typeof runConfig !== 'object' || Array.isArray(runConfig))) {
      throw new Error('run_config 必须是 JSON 对象')
    }
    const judgeCases = parseJson('judge_cases', judgeCasesText.value, null)
    if (judgeCases !== null && !Array.isArray(judgeCases)) {
      throw new Error('judge_cases 必须是 JSON 数组')
    }

    emit('submit', {
      title: form.title.trim(),
      description: form.description.trim(),
      difficulty: form.difficulty,
      timeLimit,
      memoryLimit,
      tags: normalizeTags(),
      examples: normalizeExamples(),
      testCases,
      runConfig,
      judgeCases,
    })
  } catch (error: unknown) {
    formError.value = error instanceof Error ? error.message : '表单填写有误'
  }
}

const formatJson = (): void => {
  formError.value = ''
  try {
    if (testCasesText.value.trim()) {
      const parsed = JSON.parse(testCasesText.value) as unknown
      testCasesText.value = JSON.stringify(parsed, null, 2)
    }
    if (runConfigText.value.trim()) {
      const parsed = JSON.parse(runConfigText.value) as unknown
      runConfigText.value = JSON.stringify(parsed, null, 2)
    }
    if (judgeCasesText.value.trim()) {
      const parsed = JSON.parse(judgeCasesText.value) as unknown
      judgeCasesText.value = JSON.stringify(parsed, null, 2)
    }
  } catch {
    formError.value = 'JSON 格式不正确'
  }
}

const fillTemplate = (): void => {
  runConfigText.value = DEFAULT_RUN_CONFIG
  judgeCasesText.value = '[]'
}
</script>

<template>
  <form class="teaching-form problem-editor" @submit.prevent="submit">
    <section class="teaching-panel problem-editor-section">
      <h2>基本信息</h2>
      <div class="teaching-form-grid">
        <label class="problem-editor-wide">
          <span>标题</span>
          <input v-model="form.title" maxlength="200" placeholder="题目名称" />
        </label>
        <label>
          <span>难度</span>
          <select v-model="form.difficulty">
            <option v-for="(label, value) in DIFFICULTY_LABELS" :key="value" :value="value">
              {{ label }}
            </option>
          </select>
        </label>
        <label>
          <span>时间限制 ms</span>
          <input v-model.number="form.timeLimit" type="number" min="1" step="1" />
        </label>
        <label>
          <span>内存限制 MB</span>
          <input v-model.number="form.memoryLimit" type="number" min="1" step="1" />
        </label>
        <label class="problem-editor-wide">
          <span>标签</span>
          <input v-model="form.tagsText" placeholder="数学, 数组" />
        </label>
        <label class="problem-editor-wide">
          <span>描述</span>
          <textarea v-model="form.description" rows="10" placeholder="支持 Markdown" />
        </label>
      </div>
    </section>

    <section class="teaching-panel problem-editor-section">
      <header class="problem-editor-section-header">
        <h2>示例</h2>
        <button class="teaching-secondary-button" type="button" @click="addExample">添加示例</button>
      </header>
      <div v-if="!examples.length" class="teaching-subtle">还没有示例</div>
      <div
        v-for="(example, index) in examples"
        :key="index"
        class="problem-example-row"
      >
        <label>
          <span>输入</span>
          <textarea v-model="example.input" rows="3" placeholder="x = 121" />
        </label>
        <label>
          <span>输出</span>
          <textarea v-model="example.output" rows="3" placeholder="true" />
        </label>
        <label>
          <span>解释 可选</span>
          <textarea v-model="example.explanation" rows="3" />
        </label>
        <button
          class="teaching-secondary-button problem-example-remove"
          type="button"
          @click="removeExample(index)"
        >
          删除
        </button>
      </div>
    </section>

    <section class="teaching-panel problem-editor-section">
      <header class="problem-editor-section-header">
        <h2>评测配置</h2>
        <div class="problem-editor-actions">
          <button class="teaching-secondary-button" type="button" @click="fillTemplate">填入模板</button>
          <button class="teaching-secondary-button" type="button" @click="formatJson">格式化 JSON</button>
        </div>
      </header>
      <p class="teaching-subtle">
        run_config 定义函数签名和公开用例；judge_cases 是隐藏用例，不会出现在公开题目页
      </p>
      <label>
        <span>run_config</span>
        <textarea v-model="runConfigText" class="problem-json" rows="18" spellcheck="false" />
      </label>
      <label>
        <span>judge_cases</span>
        <textarea v-model="judgeCasesText" class="problem-json" rows="10" spellcheck="false" />
      </label>
      <label>
        <span>test_cases 兼容字段 可留空</span>
        <textarea v-model="testCasesText" class="problem-json" rows="6" spellcheck="false" />
      </label>
    </section>

    <p v-if="formError || serverError" class="form-error" role="alert">
      {{ formError || serverError }}
    </p>
    <div class="problem-editor-submit">
      <button class="primary-button" type="submit" :disabled="submitting">
        {{ submitting ? '提交中' : submitLabel }}
      </button>
    </div>
  </form>
</template>
