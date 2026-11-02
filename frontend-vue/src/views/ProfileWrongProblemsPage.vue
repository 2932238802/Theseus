<script setup lang="ts">
import { computed, onMounted, ref } from 'vue'
import NavBar from '../components/NavBar.vue'
import {
  dismissWrongProblem,
  fetchWrongProblems,
  restoreWrongProblem,
} from '../api/wrongProblems'
import { fetchTags } from '../api/problems'
import { toErrorMessage } from '../api/client'
import { DIFFICULTY_LABELS, LANGUAGE_OPTIONS } from '../utils/constants'
import type { WrongProblemItem } from '../types/wrongProblem'

const size = 20
const problems = ref<WrongProblemItem[]>([])
const total = ref(0)
const page = ref(1)
const loading = ref(false)
const error = ref('')
const difficulty = ref('')
const tag = ref('')
const sort = ref<'recent' | 'attempts'>('recent')
const tags = ref<string[]>([])
const busyId = ref<number | null>(null)
const undoItem = ref<WrongProblemItem | null>(null)
const undoError = ref('')

const DIFFICULTY_OPTIONS = [
  { value: '', label: '全部' },
  { value: 'easy', label: '简单' },
  { value: 'medium', label: '中等' },
  { value: 'hard', label: '困难' },
]
const SORT_OPTIONS: Array<{ value: 'recent' | 'attempts'; label: string }> = [
  { value: 'recent', label: '最近失败' },
  { value: 'attempts', label: '失败次数' },
]
const FAILURE_LABELS: Record<string, string> = {
  wrong_answer: '答案错误',
  time_limit_exceeded: '运行超时',
  memory_limit_exceeded: '内存超限',
  runtime_error: '运行错误',
  compile_error: '编译错误',
  internal_error: '评测异常',
}

const totalPages = computed(() => Math.max(1, Math.ceil(total.value / size)))

const languageLabel = (value: string): string =>
  LANGUAGE_OPTIONS.find((option) => option.value === value)?.label ?? value

const failureLabel = (value: string): string => FAILURE_LABELS[value] ?? '未通过'

const timeLabel = (value: string): string =>
  new Date(value).toLocaleString('zh-CN', {
    month: '2-digit',
    day: '2-digit',
    hour: '2-digit',
    minute: '2-digit',
  })

const load = async (nextPage = page.value): Promise<void> => {
  loading.value = true
  error.value = ''
  try {
    const result = await fetchWrongProblems({
      page: nextPage,
      size,
      difficulty: difficulty.value || undefined,
      tag: tag.value || undefined,
      sort: sort.value,
    })
    problems.value = result.problems
    total.value = result.total
    page.value = result.page
  } catch (exception: unknown) {
    error.value = toErrorMessage(exception)
  } finally {
    loading.value = false
  }
}

const reload = (): void => {
  undoItem.value = null
  undoError.value = ''
  void load(1)
}

const dismiss = async (item: WrongProblemItem): Promise<void> => {
  if (busyId.value !== null) return
  busyId.value = item.problemId
  undoError.value = ''
  try {
    await dismissWrongProblem(item.problemId)
    undoItem.value = item
    if (problems.value.length === 1 && page.value > 1) {
      await load(page.value - 1)
    } else {
      await load(page.value)
    }
  } catch (exception: unknown) {
    undoError.value = toErrorMessage(exception)
  } finally {
    busyId.value = null
  }
}

const undo = async (): Promise<void> => {
  const item = undoItem.value
  if (!item) return
  busyId.value = item.problemId
  undoError.value = ''
  try {
    await restoreWrongProblem(item.problemId)
    undoItem.value = null
    await load(page.value)
  } catch (exception: unknown) {
    undoError.value = toErrorMessage(exception)
  } finally {
    busyId.value = null
  }
}

onMounted(() => {
  void load(1)
  fetchTags()
    .then((result) => {
      tags.value = result
    })
    .catch(() => {
      tags.value = []
    })
})
</script>

<template>
  <NavBar />
  <main class="profile-page page-shell wrong-problems-page">
    <header class="teaching-page-header">
      <div>
        <h1>错题本</h1>
        <p class="teaching-subtle">通过后自动移出 再次做错会重新出现</p>
      </div>
    </header>

    <section class="filter-panel" aria-label="错题筛选">
      <div class="filter-row">
        <span>难度</span>
        <div class="filter-pills">
          <button
            v-for="option in DIFFICULTY_OPTIONS"
            :key="option.value"
            type="button"
            :class="{ active: difficulty === option.value }"
            @click="difficulty = option.value; reload()"
          >
            {{ option.label }}
          </button>
        </div>
      </div>
      <div class="filter-row">
        <span>标签</span>
        <select v-model="tag" aria-label="按标签筛选" @change="reload">
          <option value="">全部标签</option>
          <option v-for="item in tags" :key="item" :value="item">{{ item }}</option>
        </select>
      </div>
      <div class="filter-row">
        <span>排序</span>
        <div class="filter-pills">
          <button
            v-for="option in SORT_OPTIONS"
            :key="option.value"
            type="button"
            :class="{ active: sort === option.value }"
            @click="sort = option.value; reload()"
          >
            {{ option.label }}
          </button>
        </div>
      </div>
    </section>

    <p v-if="undoItem" class="run-note">
      已移出「{{ undoItem.title }}」
      <button type="button" class="teaching-link-button" :disabled="busyId !== null" @click="undo">撤销</button>
    </p>
    <p v-if="undoError" class="form-error" role="alert">{{ undoError }}</p>
    <p v-if="error" class="form-error" role="alert">
      {{ error }}
      <button type="button" class="teaching-link-button" @click="load(page)">重试</button>
    </p>

    <p v-if="loading" class="empty-state"><span>正在加载错题</span></p>
    <div v-else-if="problems.length" class="profile-favorites">
      <article v-for="item in problems" :key="item.problemId">
        <div>
          <RouterLink :to="`/problem/${item.problemId}`">
            <strong>{{ item.title }}</strong>
          </RouterLink>
          <p>
            <span :class="['difficulty', item.difficulty]">{{ DIFFICULTY_LABELS[item.difficulty] }}</span>
            · 失败 {{ item.attemptCount }} 次
            · 最近一次 {{ failureLabel(item.lastStatus) }}<template v-if="item.lastTotalTestCases > 0"> {{ item.lastTestCasesPassed }}/{{ item.lastTotalTestCases }}</template>
            · 通过率 {{ item.acceptanceRate.toFixed(1) }}%
          </p>
          <p>
            {{ languageLabel(item.lastLanguage) }} · 最近失败于 {{ timeLabel(item.lastFailedAt) }}
            <template v-if="item.tags.length"> · {{ item.tags.join(' / ') }}</template>
          </p>
        </div>
        <div class="profile-favorite-actions">
          <RouterLink class="teaching-secondary-button" :to="`/problem/${item.problemId}`">
            重做
          </RouterLink>
          <button
            type="button"
            class="teaching-secondary-button danger"
            :disabled="busyId === item.problemId"
            @click="dismiss(item)"
          >
            {{ busyId === item.problemId ? '移出中' : '移出' }}
          </button>
        </div>
      </article>
    </div>
    <div v-else class="empty-state">
      <p>错题本是空的</p>
      <RouterLink class="primary-button" to="/problems">去题库练习 <span>→</span></RouterLink>
    </div>

    <div v-if="total > size" class="profile-pager">
      <button
        type="button"
        class="teaching-secondary-button"
        :disabled="page <= 1 || loading"
        @click="load(page - 1)"
      >
        上一页
      </button>
      <span>{{ page }} / {{ totalPages }}</span>
      <button
        type="button"
        class="teaching-secondary-button"
        :disabled="page >= totalPages || loading"
        @click="load(page + 1)"
      >
        下一页
      </button>
    </div>
  </main>
</template>
