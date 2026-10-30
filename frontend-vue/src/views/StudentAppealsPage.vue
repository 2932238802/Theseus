<script setup lang="ts">
import { computed, onMounted, ref } from 'vue'
import NavBar from '../components/NavBar.vue'
import { fetchMyCheatReport, fetchMyCheatReports, submitCheatAppeal } from '../api/anticheat'
import { fetchMyContestAppeals } from '../api/contests'
import { toErrorMessage } from '../api/client'
import { toast } from '../store/toast'
import type { ContestAppeal } from '../types/contest'
import type {
  CheatReportStatus,
  MyReportDetailResponse,
  MyReportListResponse,
  MyReportSummary,
} from '../types/anticheat'
import { formatDateTime } from '../utils/teaching'

const STATUS_LABELS: Record<CheatReportStatus, string> = {
  open: '待处理',
  confirmed: '已确认',
  dismissed: '已排除',
  appealed: '申诉处理中',
  upheld: '维持结论',
  overturned: '已撤销',
}

const reports = ref<MyReportListResponse | null>(null)
const loading = ref(true)
const error = ref('')
const detail = ref<MyReportDetailResponse | null>(null)
const detailLoading = ref(false)
const reason = ref('')
const submitting = ref(false)

const items = computed<MyReportSummary[]>(() => reports.value?.items ?? [])

const CONTEST_APPEAL_LABELS: Record<ContestAppeal['status'], string> = {
  pending: '待处理',
  accepted: '已通过',
  rejected: '未通过',
}

const contestAppeals = ref<ContestAppeal[]>([])

const percent = (value: number): string => `${Math.round(value * 100)}%`

const load = async (): Promise<void> => {
  loading.value = true
  error.value = ''
  try {
    reports.value = await fetchMyCheatReports()
    contestAppeals.value = (await fetchMyContestAppeals()).items
  } catch (exception: unknown) {
    error.value = toErrorMessage(exception)
  } finally {
    loading.value = false
  }
}

const openDetail = async (id: number): Promise<void> => {
  detailLoading.value = true
  error.value = ''
  reason.value = ''
  try {
    detail.value = await fetchMyCheatReport(id)
  } catch (exception: unknown) {
    error.value = toErrorMessage(exception)
  } finally {
    detailLoading.value = false
  }
}

const closeDetail = (): void => {
  detail.value = null
}

const submitAppeal = async (): Promise<void> => {
  if (!detail.value || submitting.value) return
  if (!reason.value.trim()) {
    error.value = '请填写申诉理由'
    return
  }
  submitting.value = true
  error.value = ''
  try {
    const result = await submitCheatAppeal(detail.value.report.id, reason.value.trim())
    toast.success(result.message)
    const reportId = detail.value.report.id
    closeDetail()
    await load()
    await openDetail(reportId)
  } catch (exception: unknown) {
    error.value = toErrorMessage(exception)
  } finally {
    submitting.value = false
  }
}

onMounted(() => {
  void load()
})
</script>

<template>
  <NavBar />
  <main class="anticheat-page page-shell">
    <header class="teaching-page-header">
      <div>
        <h1>我的申诉</h1>
      </div>
      <button class="forum-secondary-button" type="button" :disabled="loading" @click="load">
        刷新
      </button>
    </header>

    <p v-if="error" class="form-error" role="alert">{{ error }}</p>

    <div v-if="loading" class="anticheat-empty">正在加载</div>
    <div v-else-if="items.length" class="anticheat-list">
      <article
        v-for="item in items"
        :key="item.id"
        class="anticheat-card"
        role="button"
        tabindex="0"
        @click="openDetail(item.id)"
        @keydown.enter="openDetail(item.id)"
      >
        <header>
          <div class="anticheat-card-title">
            <strong>{{ item.problem_title }}</strong>
            <span :class="['anticheat-status', `is-${item.status}`]">
              {{ STATUS_LABELS[item.status] }}
            </span>
          </div>
          <time>{{ formatDateTime(item.created_at) }}</time>
        </header>
        <p class="anticheat-card-meta">
          {{ item.assignment_title ?? '作业' }} · 相似度 {{ percent(item.score) }}
          <template v-if="item.penalty_applied"> · 该题已计 0 分</template>
        </p>
      </article>
    </div>
    <div v-else class="anticheat-empty">
      暂无可申诉记录。教师确认相似度报告后，可在这里提交一次申诉。
    </div>

    <section class="teaching-section">
      <div class="section-heading">
        <h2>赛事申诉</h2>
      </div>
      <div v-if="contestAppeals.length" class="anticheat-list">
        <RouterLink
          v-for="item in contestAppeals"
          :key="item.id"
          class="anticheat-card"
          :to="`/contests/${item.contest_id}/result`"
        >
          <header>
            <div class="anticheat-card-title">
              <strong>{{ item.event_title ?? `比赛 #${item.contest_id}` }}</strong>
              <span :class="['anticheat-status', `is-${item.status}`]">
                {{ CONTEST_APPEAL_LABELS[item.status] }}
              </span>
            </div>
            <time>{{ formatDateTime(item.created_at) }}</time>
          </header>
          <p class="anticheat-card-meta">{{ item.reason }}</p>
          <p v-if="item.handle_note" class="anticheat-card-subtle">
            处理说明：{{ item.handle_note }}
          </p>
        </RouterLink>
      </div>
      <div v-else class="anticheat-empty">
        比赛结束后可以在结果页对成绩或作弊判定提交申诉。
      </div>
    </section>

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
              <dt>作业</dt>
              <dd>{{ detail.report.assignment_title ?? '—' }}</dd>
            </div>
            <div>
              <dt>题目</dt>
              <dd>{{ detail.report.problem_title }}</dd>
            </div>
            <div>
              <dt>相似度</dt>
              <dd>{{ percent(detail.report.score) }}</dd>
            </div>
            <div>
              <dt>状态</dt>
              <dd>{{ STATUS_LABELS[detail.report.status] }}</dd>
            </div>
            <div>
              <dt>该题判零</dt>
              <dd>{{ detail.report.penalty_applied ? '是' : '否' }}</dd>
            </div>
            <div>
              <dt>提交时间</dt>
              <dd>{{ formatDateTime(detail.submission.submitted_at) }}</dd>
            </div>
          </dl>

          <p v-if="detail.report.decision_note" class="anticheat-note">
            教师备注：{{ detail.report.decision_note }}
          </p>

          <section class="anticheat-block">
            <h3>我的提交</h3>
            <pre>{{ detail.submission.code }}</pre>
          </section>

          <section v-if="detail.appeal" class="anticheat-block">
            <h3>申诉结果</h3>
            <p>{{ detail.appeal.reason }}</p>
            <p class="anticheat-card-subtle">
              {{ detail.appeal.status === 'pending' ? '等待处理' : detail.appeal.status === 'upheld' ? '维持作弊结论' : '申诉通过，作弊结论已撤销' }}
              <template v-if="detail.appeal.handled_at">
                · {{ formatDateTime(detail.appeal.handled_at) }}
              </template>
            </p>
            <p v-if="detail.appeal.handle_note" class="anticheat-card-subtle">
              处理备注：{{ detail.appeal.handle_note }}
            </p>
          </section>

          <section v-if="detail.report.status === 'confirmed'" class="anticheat-block">
            <h3>提交申诉</h3>
            <p class="anticheat-card-subtle">
              每份报告只能申诉一次，将由处理该报告的老师裁定。
            </p>
            <textarea
              v-model="reason"
              maxlength="2000"
              rows="4"
              placeholder="请说明申诉理由"
              aria-label="申诉理由"
            ></textarea>
            <div class="anticheat-form-actions">
              <button
                class="primary-button"
                type="button"
                :disabled="submitting"
                @click="submitAppeal"
              >
                {{ submitting ? '提交中' : '提交申诉' }}
              </button>
            </div>
          </section>
        </template>
      </section>
    </div>
  </main>
</template>
