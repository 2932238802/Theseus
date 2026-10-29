<script setup lang="ts">
import { computed, onMounted, ref } from 'vue'
import { useRoute } from 'vue-router'
import NavBar from '../components/NavBar.vue'
import { toErrorMessage } from '../api/client'
import { toast } from '../store/toast'
import { fetchProctorEvents, reviewProctorEvent } from '../api/contests'
import type {
  ProctorEventItem,
  ProctorEventListResponse,
  ProctorReviewStatus,
} from '../types/contest'
import { formatDateTime } from '../utils/teaching'

type ReviewFilter = 'pending' | 'confirmed' | 'cleared' | 'all'

const route = useRoute()
const contestId = computed(() => Number(route.params.id))
const data = ref<ProctorEventListResponse | null>(null)
const loading = ref(true)
const error = ref('')
const filter = ref<ReviewFilter>('pending')
const notes = ref<Record<number, string>>({})
const reviewingId = ref<number | null>(null)

const FILTERS: Array<{ value: ReviewFilter; label: string }> = [
  { value: 'pending', label: '待复核' },
  { value: 'confirmed', label: '已确认' },
  { value: 'cleared', label: '已排除' },
  { value: 'all', label: '全部' },
]

const STATUS_LABELS: Record<ProctorReviewStatus, string> = {
  pending: '待复核',
  confirmed: '确认作弊',
  cleared: '已排除',
}

const items = computed(() => data.value?.items ?? [])
const filteredItems = computed(() =>
  filter.value === 'all'
    ? items.value
    : items.value.filter((item) => item.review_status === filter.value),
)
const countOf = (status: ReviewFilter): number =>
  status === 'all'
    ? items.value.length
    : items.value.filter((item) => item.review_status === status).length

const payloadNumber = (item: ProctorEventItem, key: string): number => {
  const value = item.payload?.[key]
  return typeof value === 'number' ? value : 0
}

const payloadText = (item: ProctorEventItem, key: string): string => {
  const value = item.payload?.[key]
  return typeof value === 'string' ? value : ''
}

const percent = (value: number): string => `${Math.round(value * 100)}%`

const load = async (silent = false): Promise<void> => {
  if (!Number.isInteger(contestId.value) || contestId.value <= 0) {
    error.value = '比赛编号无效'
    loading.value = false
    return
  }
  if (!silent) loading.value = true
  error.value = ''
  try {
    data.value = await fetchProctorEvents(contestId.value)
  } catch (exception: unknown) {
    error.value = toErrorMessage(exception)
  } finally {
    loading.value = false
  }
}

const review = async (
  item: ProctorEventItem,
  status: 'cleared' | 'confirmed',
): Promise<void> => {
  if (reviewingId.value !== null) return
  reviewingId.value = item.id
  error.value = ''
  try {
    const result = await reviewProctorEvent(
      contestId.value,
      item.id,
      status,
      notes.value[item.id],
    )
    const score =
      result.reputation_score === null ? '' : `，信誉分 ${result.reputation_score.toFixed(1)}`
    toast.success(
      status === 'confirmed'
        ? `${item.username} 已确认作弊${score}${result.rating_reranked ? '，排名已重新结算' : ''}`
        : `${item.username} 的粘贴记录已排除`,
    )
    await load(true)
  } catch (exception: unknown) {
    error.value = toErrorMessage(exception)
  } finally {
    reviewingId.value = null
  }
}

onMounted(() => {
  void load()
})
</script>

<template>
  <NavBar />
  <main class="proctor-page page-shell">
    <header class="teaching-page-header">
      <div>
        <RouterLink class="teaching-breadcrumb" to="/admin/events">赛事管理</RouterLink>
        <h1>粘贴复核</h1>
        <p v-if="data" class="teaching-subtle">
          {{ data.contest.event_title ?? `排位赛 #${data.contest.id}` }}
          · {{ formatDateTime(data.contest.starts_at) }} 至 {{ formatDateTime(data.contest.ends_at) }}
        </p>
        <p v-else class="teaching-subtle">比赛 #{{ contestId }}</p>
      </div>
      <button class="forum-secondary-button" type="button" :disabled="loading" @click="load()">
        刷新
      </button>
    </header>

    <p v-if="error" class="form-error" role="alert">{{ error }}</p>

    <div v-if="loading" class="proctor-empty">正在加载复核记录</div>

    <template v-else-if="data">
      <div class="proctor-summary">
        <span>疑似粘贴 {{ items.length }} 条</span>
        <span>待复核 {{ data.pending_count }} 条</span>
      </div>

      <div class="proctor-filters" role="tablist" aria-label="复核状态筛选">
        <button
          v-for="option in FILTERS"
          :key="option.value"
          type="button"
          role="tab"
          :aria-selected="filter === option.value"
          :class="{ active: filter === option.value }"
          @click="filter = option.value"
        >
          {{ option.label }}
          <span v-if="option.value !== 'all'">{{ countOf(option.value) }}</span>
        </button>
      </div>

      <div v-if="filteredItems.length" class="proctor-list">
        <article v-for="item in filteredItems" :key="item.id" class="proctor-card">
          <header>
            <div class="proctor-card-title">
              <strong>{{ item.username }}</strong>
              <span class="home-chip">粘贴</span>
              <span v-if="item.assigned_admin" class="home-chip">
                负责 {{ item.assigned_admin }}
              </span>
              <time>{{ formatDateTime(item.received_at) }}</time>
            </div>
            <span :class="['proctor-status', `is-${item.review_status}`]">
              {{ STATUS_LABELS[item.review_status] }}
            </span>
          </header>

          <dl class="proctor-metrics">
            <div>
              <dt>粘贴长度</dt>
              <dd>{{ payloadNumber(item, 'length') }} 字符 · {{ payloadNumber(item, 'lines') }} 行</dd>
            </div>
            <div>
              <dt>与当前代码重合</dt>
              <dd>{{ percent(payloadNumber(item, 'code_similarity')) }}</dd>
            </div>
            <div>
              <dt>与题目内容重合</dt>
              <dd>{{ percent(payloadNumber(item, 'problem_similarity')) }}</dd>
            </div>
            <div>
              <dt>语言</dt>
              <dd>{{ payloadText(item, 'language') || '未知' }}</dd>
            </div>
          </dl>

          <div v-if="payloadText(item, 'preview')" class="proctor-preview">
            <span>粘贴内容片段</span>
            <pre>{{ payloadText(item, 'preview') }}</pre>
            <small>仅记录前 200 个字符，不保存完整剪贴板内容</small>
          </div>

          <div v-if="item.review_status === 'pending' && item.assigned_to_me" class="proctor-actions">
            <input
              v-model="notes[item.id]"
              type="text"
              maxlength="500"
              placeholder="复核备注（可选）"
              aria-label="复核备注"
            />
            <button
              class="primary-button"
              type="button"
              :disabled="reviewingId !== null"
              title="确认后固定扣除 25 信誉分，并重新结算比赛排名"
              @click="review(item, 'confirmed')"
            >
              {{ reviewingId === item.id ? '保存中' : '确认作弊并扣 25 分' }}
            </button>
            <button
              class="forum-secondary-button"
              type="button"
              :disabled="reviewingId !== null"
              @click="review(item, 'cleared')"
            >
              排除
            </button>
          </div>

          <p
            v-else-if="item.review_status === 'pending' && !item.assigned_to_me"
            class="proctor-review-note"
          >
            该记录已分配给 {{ item.assigned_admin ?? '其他管理员' }}，无需重复处理
          </p>

          <p v-else class="proctor-review-note">
            {{ item.reviewed_by ? `由 ${item.reviewed_by} 复核` : '已复核' }}
            <template v-if="item.reviewed_at"> · {{ formatDateTime(item.reviewed_at) }}</template>
            <template v-if="item.review_note"> · {{ item.review_note }}</template>
          </p>
        </article>
      </div>

      <div v-else class="proctor-empty">
        {{ items.length ? '当前筛选下没有记录' : '还没有疑似粘贴记录' }}
      </div>
    </template>
  </main>
</template>
