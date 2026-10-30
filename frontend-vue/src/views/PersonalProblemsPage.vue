<script setup lang="ts">
import { computed, onMounted, ref } from 'vue'
import NavBar from '../components/NavBar.vue'
import { toErrorMessage } from '../api/client'
import { fetchMyProblems } from '../api/problemReview'
import type { MyProblemSummary, ReviewStatus } from '../types/problemReview'
import { formatDateTime } from '../utils/teaching'
import { DIFFICULTY_LABELS } from '../utils/constants'
import { REVIEW_STATUS_LABELS, REVIEW_STATUS_OPTIONS } from '../utils/problemReview'

type StatusFilter = ReviewStatus | 'all'

const PAGE_SIZE = 20
const problems = ref<MyProblemSummary[]>([])
const total = ref(0)
const page = ref(1)
const statusFilter = ref<StatusFilter>('all')
const loading = ref(false)
const error = ref('')
let requestSequence = 0

const pageCount = computed(() => Math.max(1, Math.ceil(total.value / PAGE_SIZE)))
const totalStart = computed(() => (total.value ? (page.value - 1) * PAGE_SIZE + 1 : 0))
const totalEnd = computed(() => Math.min(page.value * PAGE_SIZE, total.value))

const load = async (targetPage = page.value): Promise<void> => {
  const requestId = ++requestSequence
  loading.value = true
  error.value = ''
  try {
    const result = await fetchMyProblems({
      page: targetPage,
      size: PAGE_SIZE,
      status: statusFilter.value,
    })
    if (requestId !== requestSequence) return
    if (result.total > 0 && result.problems.length === 0 && result.page > 1) {
      await load(Math.max(1, Math.ceil(result.total / PAGE_SIZE)))
      return
    }
    problems.value = result.problems
    total.value = result.total
    page.value = result.total > 0 ? result.page : 1
  } catch (exception: unknown) {
    if (requestId !== requestSequence) return
    problems.value = []
    total.value = 0
    error.value = toErrorMessage(exception)
  } finally {
    if (requestId === requestSequence) loading.value = false
  }
}

const setFilter = (status: StatusFilter): void => {
  if (statusFilter.value === status) return
  statusFilter.value = status
  void load(1)
}

const changePage = (targetPage: number): void => {
  if (targetPage < 1 || targetPage > pageCount.value || targetPage === page.value) return
  void load(targetPage)
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
        <h1>个人出题</h1>
      </div>
      <RouterLink class="primary-button" to="/personal/problems/new">新建题目</RouterLink>
    </header>

    <nav class="admin-tabs problem-review-tabs" aria-label="题目状态">
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

    <p v-if="error" class="form-error" role="alert">{{ error }}</p>
    <p v-if="loading" class="teaching-subtle">正在加载题目</p>

    <section v-else-if="!problems.length" class="empty-state">
      <p>这个状态下还没有题目</p>
      <RouterLink class="primary-button" to="/personal/problems/new">去出题</RouterLink>
    </section>

    <section v-else class="teaching-panel">
      <div class="admin-table-scroll">
        <table class="admin-users-table problem-review-table">
          <thead>
            <tr>
              <th>题目</th>
              <th>难度</th>
              <th>状态</th>
              <th>审核意见</th>
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
              <td>
                <span :class="['review-badge', problem.reviewStatus]">
                  {{ REVIEW_STATUS_LABELS[problem.reviewStatus] }}
                </span>
              </td>
              <td class="problem-review-note">{{ problem.reviewNote || '—' }}</td>
              <td class="problem-review-time">{{ formatDateTime(problem.createdAt) }}</td>
              <td class="problem-review-actions">
                <RouterLink
                  v-if="problem.reviewStatus === 'rejected'"
                  class="teaching-secondary-button"
                  :to="`/personal/problems/${problem.id}/edit`"
                >
                  编辑重提
                </RouterLink>
                <RouterLink
                  v-else-if="problem.reviewStatus === 'approved'"
                  class="teaching-secondary-button"
                  :to="`/problem/${problem.id}`"
                >
                  查看
                </RouterLink>
                <span v-else class="teaching-subtle">等待审核</span>
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
  </main>
</template>
