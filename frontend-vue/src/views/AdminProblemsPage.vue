<script setup lang="ts">
import { computed, onMounted, ref } from 'vue'
import MarkdownBody from '../components/MarkdownBody.vue'
import NavBar from '../components/NavBar.vue'
import ProblemForm from '../components/ProblemForm.vue'
import { toErrorMessage } from '../api/client'
import { toast } from '../store/toast'
import {
  fetchAdminProblem,
  fetchAdminProblems,
  reviewAdminProblem,
  updateAdminProblem,
} from '../api/problemReview'
import type {
  AdminProblemSummary,
  ProblemEditorPayload,
  ReviewedProblemDetail,
  ReviewStatus,
} from '../types/problemReview'
import { DIFFICULTY_LABELS } from '../utils/constants'
import { formatDateTime } from '../utils/teaching'
import { REVIEW_STATUS_LABELS, REVIEW_STATUS_OPTIONS } from '../utils/problemReview'

type StatusFilter = ReviewStatus | 'all'

const PAGE_SIZE = 20

const problems = ref<AdminProblemSummary[]>([])
const total = ref(0)
const page = ref(1)
const statusFilter = ref<StatusFilter>('pending')
const query = ref('')
const loading = ref(false)
const listError = ref('')
let listSequence = 0

const detailOpen = ref(false)
const detail = ref<ReviewedProblemDetail | null>(null)
const detailLoading = ref(false)
const detailError = ref('')
const formSubmitting = ref(false)
const formError = ref('')
const reviewNote = ref('')
const reviewSubmitting = ref(false)
const reviewError = ref('')
let detailSequence = 0

const pageCount = computed(() => Math.max(1, Math.ceil(total.value / PAGE_SIZE)))
const totalStart = computed(() => (total.value ? (page.value - 1) * PAGE_SIZE + 1 : 0))
const totalEnd = computed(() => Math.min(page.value * PAGE_SIZE, total.value))
const canReview = computed(() => detail.value?.reviewStatus === 'pending')

const load = async (targetPage = page.value): Promise<void> => {
  const requestId = ++listSequence
  loading.value = true
  listError.value = ''
  try {
    const result = await fetchAdminProblems({
      page: targetPage,
      size: PAGE_SIZE,
      status: statusFilter.value,
      q: query.value.trim() || undefined,
    })
    if (requestId !== listSequence) return
    if (result.total > 0 && result.problems.length === 0 && result.page > 1) {
      await load(Math.max(1, Math.ceil(result.total / PAGE_SIZE)))
      return
    }
    problems.value = result.problems
    total.value = result.total
    page.value = result.total > 0 ? result.page : 1
  } catch (exception: unknown) {
    if (requestId !== listSequence) return
    problems.value = []
    total.value = 0
    listError.value = toErrorMessage(exception)
  } finally {
    if (requestId === listSequence) loading.value = false
  }
}

const setFilter = (status: StatusFilter): void => {
  if (statusFilter.value === status) return
  statusFilter.value = status
  void load(1)
}

const search = (): void => {
  void load(1)
}

const changePage = (targetPage: number): void => {
  if (targetPage < 1 || targetPage > pageCount.value || targetPage === page.value) return
  void load(targetPage)
}

const loadDetail = async (id: number): Promise<void> => {
  const requestId = ++detailSequence
  detailLoading.value = true
  detailError.value = ''
  formError.value = ''
  reviewError.value = ''
  try {
    const result = await fetchAdminProblem(id)
    if (requestId !== detailSequence) return
    detail.value = result
    reviewNote.value = result.reviewNote ?? ''
  } catch (exception: unknown) {
    if (requestId !== detailSequence) return
    detail.value = null
    detailError.value = toErrorMessage(exception)
  } finally {
    if (requestId === detailSequence) detailLoading.value = false
  }
}

const openDetail = (problem: AdminProblemSummary): void => {
  detailOpen.value = true
  detail.value = null
  void loadDetail(problem.id)
}

const closeDetail = (): void => {
  if (formSubmitting.value || reviewSubmitting.value) return
  detailOpen.value = false
  detail.value = null
  reviewNote.value = ''
}

const saveConfig = async (payload: ProblemEditorPayload): Promise<void> => {
  if (!detail.value || formSubmitting.value) return
  formSubmitting.value = true
  formError.value = ''
  try {
    const result = await updateAdminProblem(detail.value.id, payload)
    await loadDetail(detail.value.id)
    toast.success(result.message || '配置已保存')
    await load()
  } catch (exception: unknown) {
    formError.value = toErrorMessage(exception)
  } finally {
    formSubmitting.value = false
  }
}

const submitReview = async (status: 'approved' | 'rejected'): Promise<void> => {
  if (!detail.value || reviewSubmitting.value) return
  const note = reviewNote.value.trim()
  reviewError.value = ''
  if (status === 'rejected' && !note) {
    reviewError.value = '拒绝题目时必须填写退回原因'
    return
  }
  reviewSubmitting.value = true
  try {
    const result = await reviewAdminProblem(detail.value.id, status, note || null)
    toast.success(result.message)
    await loadDetail(detail.value.id)
    await load()
  } catch (exception: unknown) {
    reviewError.value = toErrorMessage(exception)
  } finally {
    reviewSubmitting.value = false
  }
}

const jsonPreview = (value: unknown): string => {
  if (value === null || value === undefined) return '—'
  return JSON.stringify(value, null, 2)
}

onMounted(() => {
  void load(1)
})
</script>

<template>
  <NavBar />
  <main class="teaching-page teaching-wide page-shell">
    <header class="teaching-page-header">
      <div>
        <h1>题目审核</h1>
      </div>
    </header>

    <nav class="admin-tabs problem-review-tabs" aria-label="审核状态">
      <button
        v-for="option in REVIEW_STATUS_OPTIONS"
        :key="option.value"
        type="button"
        :class="{ active: statusFilter === option.value }"
        @click="setFilter(option.value)"
      >
        {{ option.label }}
      </button>
    </nav>

    <form class="admin-content-filters" @submit.prevent="search">
      <label>
        <span>搜索</span>
        <input v-model="query" placeholder="题目标题" />
      </label>
      <button class="primary-button" type="submit" :disabled="loading">搜索</button>
      <span class="admin-total">{{ total }} 道题目</span>
    </form>

    <p v-if="listError" class="form-error" role="alert">{{ listError }}</p>
    <p v-if="loading" class="teaching-subtle">正在加载题目</p>

    <section v-else-if="!problems.length" class="empty-state">
      <p>这个状态下还没有题目</p>
    </section>

    <section v-else class="teaching-panel">
      <div class="admin-table-scroll">
        <table class="admin-users-table problem-review-table">
          <thead>
            <tr>
              <th>题目</th>
              <th>难度</th>
              <th>出题人</th>
              <th>状态</th>
              <th>提交时间</th>
              <th>操作</th>
            </tr>
          </thead>
          <tbody>
            <tr v-for="problem in problems" :key="problem.id">
              <td>
                <strong>{{ problem.title }}</strong>
                <small>#{{ problem.id }}</small>
              </td>
              <td>{{ DIFFICULTY_LABELS[problem.difficulty] }}</td>
              <td>{{ problem.createdByUsername || '—' }}</td>
              <td>
                <span :class="['review-badge', problem.reviewStatus]">
                  {{ REVIEW_STATUS_LABELS[problem.reviewStatus] }}
                </span>
              </td>
              <td class="problem-review-time">{{ formatDateTime(problem.createdAt) }}</td>
              <td>
                <button class="teaching-secondary-button" type="button" @click="openDetail(problem)">
                  {{ problem.reviewStatus === 'pending' ? '审核' : '查看' }}
                </button>
              </td>
            </tr>
          </tbody>
        </table>
      </div>

      <div class="pagination">
        <span>显示 {{ totalStart }}–{{ totalEnd }} / {{ total }}</span>
        <div>
          <button type="button" :disabled="page <= 1 || loading" @click="changePage(page - 1)">← 上一页</button>
          <span>{{ page }} / {{ pageCount }}</span>
          <button type="button" :disabled="page >= pageCount || loading" @click="changePage(page + 1)">下一页 →</button>
        </div>
      </div>
    </section>

    <div v-if="detailOpen" class="modal-backdrop" @click.self="closeDetail">
      <section
        class="forum-dialog problem-review-dialog"
        role="dialog"
        aria-modal="true"
        aria-labelledby="problem-review-title"
      >
        <header>
          <div>
            <h2 id="problem-review-title">{{ detail?.title || '题目审核' }}</h2>
            <p v-if="detail">#{{ detail.id }} · {{ detail.createdByUsername || '未知用户' }}</p>
          </div>
          <button type="button" aria-label="关闭" @click="closeDetail">×</button>
        </header>

        <div class="forum-dialog-body">
          <p v-if="detailLoading" class="teaching-subtle">正在加载题目</p>
          <p v-else-if="detailError" class="form-error" role="alert">{{ detailError }}</p>

          <template v-else-if="detail">
            <div class="problem-review-meta">
              <span :class="['review-badge', detail.reviewStatus]">
                {{ REVIEW_STATUS_LABELS[detail.reviewStatus] }}
              </span>
              <span>提交 {{ formatDateTime(detail.createdAt) }}</span>
              <span v-if="detail.reviewedAt">审核 {{ formatDateTime(detail.reviewedAt) }}</span>
            </div>

            <template v-if="canReview">
              <p class="teaching-subtle">修改配置后先保存，再审核</p>
              <ProblemForm
                :key="detail.id"
                :initial="detail"
                :submitting="formSubmitting"
                :server-error="formError"
                submit-label="保存配置"
                @submit="saveConfig"
              />

              <section class="teaching-panel problem-review-actions">
                <h3>审核</h3>
                <label>
                  <span>审核意见 拒绝时必填</span>
                  <textarea v-model="reviewNote" rows="4" maxlength="1000" placeholder="说明通过或退回原因" />
                </label>
                <p v-if="reviewError" class="form-error" role="alert">{{ reviewError }}</p>
                <div class="problem-review-buttons">
                  <button
                    class="primary-button"
                    type="button"
                    :disabled="reviewSubmitting"
                    @click="submitReview('approved')"
                  >
                    通过
                  </button>
                  <button
                    class="teaching-secondary-button danger"
                    type="button"
                    :disabled="reviewSubmitting"
                    @click="submitReview('rejected')"
                  >
                    退回
                  </button>
                </div>
              </section>
            </template>

            <template v-else>
              <section class="teaching-panel problem-review-readonly">
                <h3>审核结果</h3>
                <p class="teaching-subtle">{{ detail.reviewNote || '没有填写审核意见' }}</p>
              </section>
              <section class="teaching-panel problem-review-readonly">
                <h3>题目描述</h3>
                <MarkdownBody :content="detail.description" />
              </section>
              <section v-if="detail.examples.length" class="teaching-panel problem-review-readonly">
                <h3>示例</h3>
                <div v-for="(example, index) in detail.examples" :key="index" class="problem-review-example">
                  <p><strong>输入</strong> <code>{{ example.input }}</code></p>
                  <p><strong>输出</strong> <code>{{ example.output }}</code></p>
                  <p v-if="example.explanation"><strong>解释</strong> {{ example.explanation }}</p>
                </div>
              </section>
              <section class="teaching-panel problem-review-readonly">
                <h3>评测配置</h3>
                <label>
                  <span>run_config</span>
                  <pre class="problem-review-json">{{ jsonPreview(detail.runConfig) }}</pre>
                </label>
                <label>
                  <span>judge_cases</span>
                  <pre class="problem-review-json">{{ jsonPreview(detail.judgeCases) }}</pre>
                </label>
              </section>
            </template>
          </template>
        </div>

        <footer>
          <button class="teaching-secondary-button" type="button" @click="closeDetail">关闭</button>
        </footer>
      </section>
    </div>
  </main>
</template>
