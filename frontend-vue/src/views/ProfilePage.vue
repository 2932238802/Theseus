<script setup lang="ts">
import { computed, onMounted, ref } from 'vue'
import NavBar from '../components/NavBar.vue'
import AvatarUploader from '../components/AvatarUploader.vue'
import AccountSettingsDialog from '../components/AccountSettingsDialog.vue'
import ProfileAnalytics from '../components/ProfileAnalytics.vue'
import { toErrorMessage } from '../api/client'
import { fetchAnalytics } from '../api/profile'
import { fetchSubmission } from '../api/submissions'
import { useAuthStore } from '../store/auth'
import { useRunStore } from '../store/runs'
import { useSubmissionStore } from '../store/submissions'
import { RUN_CASE_STATUS_LABELS, RUN_STATUS_LABELS } from '../utils/constants'
import type { RunDetail, RunSummary } from '../types/run'
import type { Submission } from '../types/oj'
import type { ProfileAnalytics as ProfileAnalyticsData } from '../types/profile'
import { formatInline } from '../utils/format'

const authStore = useAuthStore()
const submissionStore = useSubmissionStore()
const runStore = useRunStore()
const runFeatureEnabled = import.meta.env.VITE_RUN_CODE_ENABLED !== 'false'
const activeTab = ref<'submissions' | 'runs'>('submissions')
const selectedRun = ref<RunDetail | null>(null)
const runDetailLoading = ref(false)
const runDetailError = ref('')
const deletingId = ref<number | null>(null)
const selectedSubmission = ref<Submission | null>(null)
const submissionDetailLoading = ref(false)
const submissionDetailError = ref('')
const analytics = ref<ProfileAnalyticsData | null>(null)
const analyticsLoading = ref(true)
const analyticsError = ref('')
const showSettings = ref(false)

const roleLabel = computed(() => {
  if (authStore.isTeacher) return '教师'
  if (authStore.isAdmin) return '管理员'
  return '学生'
})

const formatTime = (value: string): string => new Date(value).toLocaleString('zh-CN')
const formatMemory = (value: number | null): string => {
  if (!value) return '—'
  return value >= 1024 ? `${(value / 1024).toFixed(1)} MB` : `${value} KB`
}
const isAcceptedRun = (status: string): boolean => status === 'completed'

const loadAnalytics = async (): Promise<void> => {
  analyticsLoading.value = true
  analyticsError.value = ''
  try {
    analytics.value = await fetchAnalytics(30)
  } catch (exception: unknown) {
    analyticsError.value = toErrorMessage(exception)
  } finally {
    analyticsLoading.value = false
  }
}

const openRunDetail = async (record: RunSummary): Promise<void> => {
  runDetailLoading.value = true
  runDetailError.value = ''
  try {
    selectedRun.value = await runStore.loadDetail(record.id)
  } catch (exception: unknown) {
    runDetailError.value = toErrorMessage(exception)
  } finally {
    runDetailLoading.value = false
  }
}

const closeRunDetail = (): void => {
  selectedRun.value = null
  runDetailError.value = ''
}

const openSubmissionDetail = async (submission: Submission): Promise<void> => {
  submissionDetailLoading.value = true
  submissionDetailError.value = ''
  try {
    selectedSubmission.value = await fetchSubmission(submission.id)
  } catch (exception: unknown) {
    submissionDetailError.value = toErrorMessage(exception)
  } finally {
    submissionDetailLoading.value = false
  }
}

const closeSubmissionDetail = (): void => {
  selectedSubmission.value = null
  submissionDetailError.value = ''
}

const deleteRecord = async (record: RunSummary): Promise<void> => {
  if (!window.confirm(`确定删除「${record.problemTitle}」的这条运行记录吗？删除后无法恢复`)) return
  deletingId.value = record.id
  runStore.recordsError = ''
  try {
    await runStore.removeRecord(record.id)
    if (selectedRun.value?.id === record.id) closeRunDetail()
  } catch (exception: unknown) {
    runStore.recordsError = toErrorMessage(exception)
  } finally {
    deletingId.value = null
  }
}

const selectTab = (tab: 'submissions' | 'runs'): void => {
  activeTab.value = tab
  if (tab === 'runs' && !runStore.records.length && !runStore.recordsLoading) {
    void runStore.loadRecords({ page: 1, size: 20 })
  }
}

onMounted(() => {
  void loadAnalytics()
  void submissionStore.loadSubmissions({ page: 1, size: 50 })
  if (runFeatureEnabled) {
    void runStore.loadRecords({ page: 1, size: 20 })
  }
})
</script>

<template>
  <NavBar />
  <main class="profile-page page-shell">
    <section class="profile-hero">
      <AvatarUploader />
      <div class="profile-identity">
        <h1>{{ authStore.user?.username ?? '游客' }}</h1>
        <p>{{ authStore.user?.email ?? '登录后同步你的练习进度' }}</p>
        <div class="profile-badges">
          <span class="teaching-badge">{{ roleLabel }}</span>
          <span v-if="authStore.user?.emailVerified" class="teaching-badge">邮箱已验证</span>
          <span v-else class="teaching-badge">邮箱未验证</span>
          <span v-if="authStore.user?.pendingEmail" class="teaching-badge">待验证 {{ authStore.user.pendingEmail }}</span>
          <span v-if="authStore.user?.createdAt" class="teaching-subtle">
            加入于 {{ new Date(authStore.user.createdAt).toLocaleDateString('zh-CN') }}
          </span>
        </div>
      </div>
      <button class="teaching-secondary-button" type="button" @click="showSettings = true">
        账号设置
      </button>
    </section>

    <section class="profile-stats">
      <article><strong>{{ analytics?.summary.acceptedProblems ?? 0 }}</strong><span>通过题目</span></article>
      <article><strong>{{ analytics?.summary.totalSubmissions ?? 0 }}</strong><span>总提交数</span></article>
      <article><strong>{{ analytics?.summary.acceptanceRate ?? 0 }}<small>%</small></strong><span>通过率</span></article>
      <article><strong>{{ analytics?.summary.attemptedProblems ?? 0 }}</strong><span>已尝试题目</span></article>
      <article><strong>{{ analytics?.summary.activeClasses ?? 0 }}</strong><span>活跃班级</span></article>
      <article><strong>{{ analytics?.summary.streakDays ?? 0 }}</strong><span>连续通过天数</span></article>
    </section>

    <div>
      <ProfileAnalytics :analytics="analytics" :loading="analyticsLoading" :error="analyticsError" />
    </div>

    <div id="profile-records" class="profile-tabs" role="tablist">
      <button type="button" role="tab" :aria-selected="activeTab === 'submissions'" :class="{ active: activeTab === 'submissions' }" @click="selectTab('submissions')">提交记录</button>
      <button v-if="runFeatureEnabled" type="button" role="tab" :aria-selected="activeTab === 'runs'" :class="{ active: activeTab === 'runs' }" @click="selectTab('runs')">运行记录</button>
    </div>

    <section v-if="activeTab === 'submissions'" class="recent-section">
      <div class="section-heading"><h2>最近提交</h2></div>
      <p v-if="submissionStore.error" class="form-error" role="alert">{{ submissionStore.error }}</p>
      <div v-if="submissionStore.isLoading" class="empty-state"><p>正在加载提交记录</p></div>
      <div v-else-if="submissionStore.submissions.length" class="submission-list run-record-list">
        <article v-for="submission in submissionStore.submissions" :key="submission.id">
          <RouterLink :to="`/problem/${submission.problemId}`">{{ submission.problemTitle }}</RouterLink>
          <span>{{ submission.language }}</span>
          <span :class="['result-status', submission.status === 'Accepted' ? 'accepted' : 'failed']">{{ submission.status }}<template v-if="submission.totalTestCases > 0"> · {{ submission.testCasesPassed }}/{{ submission.totalTestCases }}</template></span>
          <time>{{ formatTime(submission.createdAt) }}</time>
          <div class="run-record-actions">
            <button type="button" :disabled="submissionDetailLoading" @click="openSubmissionDetail(submission)">查看</button>
          </div>
        </article>
      </div>
      <p v-if="submissionDetailLoading" class="run-note">正在加载提交详情</p>
      <p v-if="submissionDetailError" class="form-error" role="alert">{{ submissionDetailError }}</p>
      <div v-else-if="!submissionStore.submissions.length" class="empty-state">
        <p>还没有提交记录</p>
        <RouterLink class="primary-button" to="/problems">去开始第一题 <span>→</span></RouterLink>
      </div>
    </section>

    <section v-else class="recent-section">
      <div class="section-heading"><h2>运行记录</h2><span class="run-note">共 {{ runStore.recordsTotal }} 条 仅保留最近运行结果</span></div>
      <p v-if="runStore.recordsError" class="form-error" role="alert">{{ runStore.recordsError }}</p>
      <div v-if="runStore.recordsLoading" class="empty-state"><p>正在加载运行记录</p></div>
      <div v-else-if="runStore.records.length" class="submission-list run-record-list">
        <article v-for="record in runStore.records" :key="record.id">
          <RouterLink v-if="record.problemId" :to="`/problem/${record.problemId}`">{{ record.problemTitle }}</RouterLink>
          <span v-else>{{ record.problemTitle }}</span>
          <span>{{ record.language }}</span>
          <span :class="['result-status', isAcceptedRun(record.status) ? 'accepted' : 'failed']">{{ RUN_STATUS_LABELS[record.status] }}<template v-if="record.caseTotal > 0"> · {{ record.casePassed }}/{{ record.caseTotal }}</template></span>
          <time>{{ formatTime(record.createdAt) }}</time>
          <div class="run-record-actions">
            <button type="button" :disabled="runDetailLoading" @click="openRunDetail(record)">查看</button>
            <button type="button" class="danger" :disabled="deletingId === record.id" @click="deleteRecord(record)">{{ deletingId === record.id ? '删除中' : '删除' }}</button>
          </div>
        </article>
      </div>
      <div v-else class="empty-state"><p>还没有运行记录 去题目页运行代码试试</p><RouterLink class="primary-button" to="/problems">去题库看看 <span>→</span></RouterLink></div>
      <p v-if="runDetailLoading" class="run-note">正在加载运行详情</p>
      <p v-if="runDetailError" class="form-error" role="alert">{{ runDetailError }}</p>
    </section>
  </main>

  <AccountSettingsDialog v-if="showSettings" @close="showSettings = false" />

  <div v-if="selectedSubmission" class="modal-backdrop" @click.self="closeSubmissionDetail">
    <section class="run-dialog run-record-dialog" role="dialog" aria-modal="true" aria-labelledby="submission-record-title">
      <header><div><h2 id="submission-record-title">{{ selectedSubmission.problemTitle }}</h2><p>{{ selectedSubmission.language }} · 提交 #{{ selectedSubmission.id }}</p></div><button type="button" aria-label="关闭" @click="closeSubmissionDetail">×</button></header>
      <div class="run-dialog-body">
        <p v-if="selectedSubmission.message" :class="selectedSubmission.rawStatus === 'accepted' ? 'run-note' : 'form-error'">{{ selectedSubmission.message }}</p>
        <dl>
          <div><dt>状态</dt><dd>{{ selectedSubmission.status }}</dd></div>
          <div><dt>通过用例</dt><dd>{{ selectedSubmission.testCasesPassed }} / {{ selectedSubmission.totalTestCases }}</dd></div>
          <div v-if="selectedSubmission.runtime"><dt>执行用时</dt><dd>{{ selectedSubmission.runtime }}</dd></div>
          <div v-if="selectedSubmission.memory"><dt>内存消耗</dt><dd>{{ selectedSubmission.memory }}</dd></div>
          <div><dt>提交时间</dt><dd>{{ formatTime(selectedSubmission.createdAt) }}</dd></div>
          <div v-if="selectedSubmission.finishedAt"><dt>结束时间</dt><dd>{{ formatTime(selectedSubmission.finishedAt) }}</dd></div>
        </dl>
        <div v-if="selectedSubmission.compileOutput" class="run-block"><span>编译输出</span><pre>{{ selectedSubmission.compileOutput }}</pre></div>
        <template v-if="selectedSubmission.failedCase">
          <div class="run-block"><span>失败用例 #{{ selectedSubmission.failedCase.index + 1 }} · 输入</span><pre>{{ formatInline(selectedSubmission.failedCase.args) }}</pre></div>
          <div v-if="selectedSubmission.failedCase.expected !== undefined" class="run-block"><span>期望</span><pre>{{ formatInline(selectedSubmission.failedCase.expected) }}</pre></div>
          <div v-if="selectedSubmission.failedCase.actual !== null" class="run-block"><span>实际</span><pre>{{ formatInline(selectedSubmission.failedCase.actual) }}</pre></div>
          <div v-if="selectedSubmission.failedCase.stdout" class="run-block"><span>stdout</span><pre>{{ selectedSubmission.failedCase.stdout }}</pre></div>
          <div v-if="selectedSubmission.failedCase.stderr" class="run-block"><span>stderr</span><pre>{{ selectedSubmission.failedCase.stderr }}</pre></div>
        </template>
        <div v-if="selectedSubmission.code" class="run-block"><span>代码</span><pre>{{ selectedSubmission.code }}</pre></div>
      </div>
    </section>
  </div>

  <div v-if="selectedRun" class="modal-backdrop" @click.self="closeRunDetail">
    <section class="run-dialog run-record-dialog" role="dialog" aria-modal="true" aria-labelledby="run-record-title">
      <header><div><h2 id="run-record-title">{{ selectedRun.problemTitle }}</h2><p>{{ selectedRun.language }} · 运行 #{{ selectedRun.id }}</p></div><button type="button" aria-label="关闭" @click="closeRunDetail">×</button></header>
      <div class="run-dialog-body">
        <p v-if="selectedRun.errorMessage" class="form-error" role="alert">{{ selectedRun.errorMessage }}</p>
        <dl>
          <div><dt>状态</dt><dd>{{ RUN_STATUS_LABELS[selectedRun.status] }}</dd></div>
          <div><dt>通过用例</dt><dd>{{ selectedRun.casePassed }} / {{ selectedRun.caseTotal }}</dd></div>
          <div><dt>运行模式</dt><dd>{{ selectedRun.mode === 'examples' ? '公开示例' : '自定义输入' }}</dd></div>
          <div v-if="selectedRun.runtimeMs !== null"><dt>执行用时</dt><dd>{{ selectedRun.runtimeMs }} ms</dd></div>
          <div><dt>内存消耗</dt><dd>{{ formatMemory(selectedRun.memoryKb) }}</dd></div>
          <div><dt>创建时间</dt><dd>{{ formatTime(selectedRun.createdAt) }}</dd></div>
        </dl>
        <div v-if="selectedRun.compileOutput" class="run-block"><span>编译输出</span><pre>{{ selectedRun.compileOutput }}</pre></div>
        <div v-if="selectedRun.mode === 'custom'" class="run-block"><span>输入</span><pre>{{ formatInline(selectedRun.input) }}</pre></div>
        <div v-for="item in selectedRun.cases" :key="item.index" class="run-case">
          <header><span>用例 {{ item.index + 1 }}</span><span :class="['case-status', item.status]">{{ RUN_CASE_STATUS_LABELS[item.status] }}</span></header>
          <div class="run-block"><span>输入</span><pre>{{ formatInline(item.args) }}</pre></div>
          <div v-if="item.expected !== undefined" class="run-block"><span>期望</span><pre>{{ formatInline(item.expected) }}</pre></div>
          <div v-if="item.actual !== undefined" class="run-block"><span>实际</span><pre>{{ formatInline(item.actual) }}</pre></div>
          <div v-if="item.stdout" class="run-block"><span>stdout</span><pre>{{ item.stdout }}</pre></div>
          <div v-if="item.stderr" class="run-block"><span>stderr</span><pre>{{ item.stderr }}</pre></div>
          <p v-if="item.truncated" class="run-note">输出超过 64 KB 已截断</p>
        </div>
        <details class="run-code"><summary>查看代码</summary><pre>{{ selectedRun.code }}</pre></details>
      </div>
      <footer><button class="run-button" type="button" @click="closeRunDetail">关闭</button></footer>
    </section>
  </div>
</template>
