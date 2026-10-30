<script setup lang="ts">
import { computed, onMounted, ref } from 'vue'
import NavBar from '../components/NavBar.vue'
import {
  fetchAppealQueue,
  fetchCheatReport,
  fetchCheatReports,
  resolveAppeal,
  reviewCheatReport,
} from '../api/anticheat'
import { toErrorMessage } from '../api/client'
import { toast } from '../store/toast'
import type {
  AppealQueueResponse,
  CheatReportDetailResponse,
  CheatReportListResponse,
  CheatReportStatus,
  CheatSeverity,
} from '../types/anticheat'
import { formatDateTime } from '../utils/teaching'

type Tab = 'reports' | 'appeals'
type StatusFilter = 'all' | CheatReportStatus
type ReportDecision = 'confirmed' | 'dismissed'
type AppealDecision = 'upheld' | 'overturned'

const STATUS_LABELS: Record<CheatReportStatus, string> = {
  open: '待处理',
  confirmed: '已确认',
  dismissed: '已排除',
  appealed: '申诉中',
  upheld: '维持结论',
  overturned: '已撤销',
}

const SEVERITY_LABELS: Record<CheatSeverity, string> = {
  low: '低',
  medium: '中',
  high: '高',
}

const ACTION_LABELS: Record<string, string> = {
  created: '自动生成报告',
  confirmed: '确认作弊',
  dismissed: '排除报告',
  appealed: '学生申请申诉',
  upheld: '维持作弊结论',
  overturned: '撤销作弊结论',
  penalty_restored: '恢复判零前成绩',
}

const FILTERS: Array<{ value: StatusFilter; label: string }> = [
  { value: 'open', label: '待处理' },
  { value: 'confirmed', label: '已确认' },
  { value: 'appealed', label: '申诉中' },
  { value: 'dismissed', label: '已排除' },
  { value: 'all', label: '全部' },
]

const tab = ref<Tab>('reports')
const status = ref<StatusFilter>('open')
const reports = ref<CheatReportListResponse | null>(null)
const appeals = ref<AppealQueueResponse | null>(null)
const loading = ref(true)
const error = ref('')
const detail = ref<CheatReportDetailResponse | null>(null)
const detailLoading = ref(false)
const reviewNote = ref('')
const applyZero = ref(false)
const resolveNote = ref('')
const submitting = ref(false)

const reportItems = computed(() => reports.value?.items ?? [])
const appealItems = computed(() => appeals.value?.items ?? [])

const percent = (value: number): string => `${Math.round(value * 100)}%`

const loadReports = async (silent = false): Promise<void> => {
  if (!silent) loading.value = true
  error.value = ''
  try {
    reports.value = await fetchCheatReports({
      status: status.value === 'all' ? undefined : status.value,
      page: 1,
      size: 50,
    })
  } catch (exception: unknown) {
    error.value = toErrorMessage(exception)
  } finally {
    loading.value = false
  }
}

const loadAppeals = async (silent = false): Promise<void> => {
  if (!silent) loading.value = true
  error.value = ''
  try {
    appeals.value = await fetchAppealQueue()
  } catch (exception: unknown) {
    error.value = toErrorMessage(exception)
  } finally {
    loading.value = false
  }
}

const switchTab = async (value: Tab): Promise<void> => {
  tab.value = value
  if (value === 'reports') {
    await loadReports()
  } else {
    await loadAppeals()
  }
}

const selectFilter = async (value: StatusFilter): Promise<void> => {
  status.value = value
  await loadReports()
}

const openDetail = async (reportId: number): Promise<void> => {
  detailLoading.value = true
  error.value = ''
  reviewNote.value = ''
  resolveNote.value = ''
  applyZero.value = false
  try {
    detail.value = await fetchCheatReport(reportId)
  } catch (exception: unknown) {
    error.value = toErrorMessage(exception)
  } finally {
    detailLoading.value = false
  }
}

const closeDetail = (): void => {
  detail.value = null
}

const refresh = async (): Promise<void> => {
  await Promise.all([loadReports(true), loadAppeals(true)])
}

const submitReview = async (decision: ReportDecision): Promise<void> => {
  if (!detail.value || submitting.value) return
  submitting.value = true
  error.value = ''
  try {
    const result = await reviewCheatReport(detail.value.report.id, {
      decision,
      note: reviewNote.value.trim() || undefined,
      apply_zero: decision === 'confirmed' && applyZero.value,
    })
    toast.success(result.message)
    closeDetail()
    await refresh()
  } catch (exception: unknown) {
    error.value = toErrorMessage(exception)
  } finally {
    submitting.value = false
  }
}

const submitResolve = async (decision: AppealDecision): Promise<void> => {
  if (!detail.value?.appeal || submitting.value) return
  submitting.value = true
  error.value = ''
  try {
    const result = await resolveAppeal(detail.value.appeal.id, {
      decision,
      note: resolveNote.value.trim() || undefined,
    })
    toast.success(result.message)
    closeDetail()
    await refresh()
  } catch (exception: unknown) {
    error.value = toErrorMessage(exception)
  } finally {
    submitting.value = false
  }
}

onMounted(() => {
  void loadReports().then(() => loadAppeals(true))
})
</script>

<template>
  <NavBar />
  <main class="anticheat-page page-shell">
    <header class="teaching-page-header">
      <div>
        <h1>作弊复核</h1>
      </div>
      <button class="forum-secondary-button" type="button" :disabled="loading" @click="refresh">
        刷新
      </button>
    </header>

    <div class="anticheat-tabs" role="tablist" aria-label="复核内容">
      <button
        type="button"
        role="tab"
        :aria-selected="tab === 'reports'"
        :class="{ active: tab === 'reports' }"
        @click="switchTab('reports')"
      >
        相似度报告
        <span v-if="reports?.pending_count">{{ reports.pending_count }}</span>
      </button>
      <button
        type="button"
        role="tab"
        :aria-selected="tab === 'appeals'"
        :class="{ active: tab === 'appeals' }"
        @click="switchTab('appeals')"
      >
        学生申诉
        <span v-if="appeals?.total">{{ appeals.total }}</span>
      </button>
    </div>

    <p v-if="error" class="form-error" role="alert">{{ error }}</p>

    <template v-if="tab === 'reports'">
      <div class="anticheat-filters" role="tablist" aria-label="报告状态筛选">
        <button
          v-for="option in FILTERS"
          :key="option.value"
          type="button"
          role="tab"
          :aria-selected="status === option.value"
          :class="{ active: status === option.value }"
          @click="selectFilter(option.value)"
        >
          {{ option.label }}
        </button>
      </div>

      <div v-if="loading" class="anticheat-empty">正在加载报告</div>
      <div v-else-if="reportItems.length" class="anticheat-list">
        <article
          v-for="item in reportItems"
          :key="item.id"
          class="anticheat-card"
          role="button"
          tabindex="0"
          @click="openDetail(item.id)"
          @keydown.enter="openDetail(item.id)"
        >
          <header>
            <div class="anticheat-card-title">
              <strong>{{ item.target_username }}</strong>
              <span :class="['anticheat-score', `is-${item.severity}`]">
                {{ percent(item.score) }}
              </span>
              <span :class="['anticheat-status', `is-${item.status}`]">
                {{ STATUS_LABELS[item.status] }}
              </span>
            </div>
            <time>{{ formatDateTime(item.created_at) }}</time>
          </header>
          <p class="anticheat-card-meta">
            {{ item.assignment_title ?? '作业' }} · {{ item.problem_title }}
          </p>
          <p v-if="item.matched_username" class="anticheat-card-subtle">
            与 {{ item.matched_username }} 的提交相似
            <template v-if="item.penalty_applied"> · 该题已计 0 分</template>
          </p>
        </article>
      </div>
      <div v-else class="anticheat-empty">当前筛选下没有报告</div>
    </template>

    <template v-else>
      <div v-if="loading" class="anticheat-empty">正在加载申诉</div>
      <div v-else-if="appealItems.length" class="anticheat-list">
        <article
          v-for="item in appealItems"
          :key="item.appeal_id"
          class="anticheat-card"
          role="button"
          tabindex="0"
          @click="openDetail(item.report_id)"
          @keydown.enter="openDetail(item.report_id)"
        >
          <header>
            <div class="anticheat-card-title">
              <strong>{{ item.target_username }}</strong>
              <span :class="['anticheat-score', `is-${item.severity}`]">
                {{ percent(item.score) }}
              </span>
              <span class="anticheat-status is-appealed">待裁定</span>
            </div>
            <time>{{ formatDateTime(item.created_at) }}</time>
          </header>
          <p class="anticheat-card-meta">
            {{ item.assignment_title ?? '作业' }} · {{ item.problem_title }}
          </p>
          <p class="anticheat-card-subtle">{{ item.reason }}</p>
        </article>
      </div>
      <div v-else class="anticheat-empty">没有待裁定申诉</div>
    </template>

    <div v-if="detail || detailLoading" class="anticheat-dialog" @click.self="closeDetail">
      <section class="anticheat-dialog-panel" role="dialog" aria-modal="true" aria-label="报告详情">
        <header class="anticheat-dialog-header">
          <h2>提交比对</h2>
          <button class="forum-secondary-button" type="button" @click="closeDetail">关闭</button>
        </header>

        <div v-if="detailLoading || !detail" class="anticheat-empty">正在加载详情</div>

        <template v-else>
          <dl class="anticheat-metrics">
            <div>
              <dt>学生</dt>
              <dd>{{ detail.report.target_username }}</dd>
            </div>
            <div>
              <dt>作业</dt>
              <dd>{{ detail.report.assignment_title ?? '—' }}</dd>
            </div>
            <div>
              <dt>题目</dt>
              <dd>{{ detail.report.problem_title }}</dd>
            </div>
            <div>
              <dt>相似度</dt>
              <dd>{{ percent(detail.report.score) }} · {{ SEVERITY_LABELS[detail.report.severity] }}</dd>
            </div>
            <div>
              <dt>状态</dt>
              <dd>{{ STATUS_LABELS[detail.report.status] }}</dd>
            </div>
            <div>
              <dt>该题判零</dt>
              <dd>{{ detail.report.penalty_applied ? '是' : '否' }}</dd>
            </div>
          </dl>

          <div class="anticheat-code-grid">
            <section>
              <h3>{{ detail.evidence.target_submission.username }} 的提交</h3>
              <pre>{{ detail.evidence.target_submission.code }}</pre>
            </section>
            <section v-if="detail.evidence.pairs[0]">
              <h3>
                {{ detail.evidence.pairs[0].username }} 的提交
                <span class="anticheat-card-subtle">
                  {{ percent(detail.evidence.pairs[0].score) }}
                </span>
              </h3>
              <pre>{{ detail.evidence.pairs[0].code }}</pre>
            </section>
          </div>

          <p v-if="detail.evidence.pairs.length > 1" class="anticheat-card-subtle">
            另有 {{ detail.evidence.pairs.length - 1 }} 份相似提交，仅展示相似度最高的一份
          </p>

          <section v-if="detail.appeal" class="anticheat-block">
            <h3>学生申诉</h3>
            <p>{{ detail.appeal.reason }}</p>
            <p class="anticheat-card-subtle">
              {{ detail.appeal.status === 'pending' ? '等待处理' : detail.appeal.status === 'upheld' ? '维持结论' : '申诉通过' }}
              <template v-if="detail.appeal.handled_by_username">
                · {{ detail.appeal.handled_by_username }}
              </template>
              <template v-if="detail.appeal.handled_at">
                · {{ formatDateTime(detail.appeal.handled_at) }}
              </template>
            </p>
            <p v-if="detail.appeal.handle_note" class="anticheat-card-subtle">
              处理备注：{{ detail.appeal.handle_note }}
            </p>
          </section>

          <section v-if="detail.actions.length" class="anticheat-block">
            <h3>处理记录</h3>
            <ul class="anticheat-actions">
              <li v-for="(action, index) in detail.actions" :key="index">
                <strong>{{ ACTION_LABELS[action.action] ?? action.action }}</strong>
                <span v-if="action.actor_username"> · {{ action.actor_username }}</span>
                <span> · {{ formatDateTime(action.created_at) }}</span>
                <p v-if="action.note">{{ action.note }}</p>
              </li>
            </ul>
          </section>

          <section v-if="detail.report.status === 'open'" class="anticheat-block">
            <h3>复核结论</h3>
            <textarea
              v-model="reviewNote"
              maxlength="500"
              rows="3"
              placeholder="复核备注（可选）"
              aria-label="复核备注"
            ></textarea>
            <label class="anticheat-checkbox">
              <input v-model="applyZero" type="checkbox" />
              同时将该题作业判 0 分（可在申诉翻案时恢复）
            </label>
            <div class="anticheat-form-actions">
              <button
                class="primary-button"
                type="button"
                :disabled="submitting"
                @click="submitReview('confirmed')"
              >
                {{ submitting ? '保存中' : '确认作弊' }}
              </button>
              <button
                class="forum-secondary-button"
                type="button"
                :disabled="submitting"
                @click="submitReview('dismissed')"
              >
                排除报告
              </button>
            </div>
          </section>

          <section
            v-if="detail.report.status === 'appealed' && detail.appeal?.status === 'pending'"
            class="anticheat-block"
          >
            <h3>裁定申诉</h3>
            <textarea
              v-model="resolveNote"
              maxlength="500"
              rows="3"
              placeholder="处理备注（可选）"
              aria-label="申诉处理备注"
            ></textarea>
            <div class="anticheat-form-actions">
              <button
                class="forum-secondary-button"
                type="button"
                :disabled="submitting"
                @click="submitResolve('upheld')"
              >
                维持结论
              </button>
              <button
                class="primary-button"
                type="button"
                :disabled="submitting"
                @click="submitResolve('overturned')"
              >
                撤销结论并恢复成绩
              </button>
            </div>
          </section>
        </template>
      </section>
    </div>
  </main>
</template>
