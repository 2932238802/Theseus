<script setup lang="ts">
import { computed, onMounted, ref, watch } from 'vue'
import { useRoute, useRouter } from 'vue-router'
import MarkdownBody from '../components/MarkdownBody.vue'
import NavBar from '../components/NavBar.vue'
import { toErrorMessage } from '../api/client'
import { toast } from '../store/toast'
import { useAssignmentStore } from '../store/assignments'
import {
  exportAssignmentStatistics,
  fetchAssignmentStatistics,
  fetchPeerSubmissions,
  publishSolutions,
} from '../api/policies'
import { fetchMyGradeAppeal, submitGradeAppeal } from '../api/assignments'
import type { AssignmentStatistics, GradeAppeal, PeerSubmission } from '../types/policy'
import {
  DIFFICULTY_LABELS,
} from '../utils/constants'
import {
  GRADE_APPEAL_STATUS_LABELS,
  assignmentStatusLabel,
  formatDateTime,
  gradeSummary,
  isPast,
  problemAttemptLabel,
} from '../utils/teaching'

const route = useRoute()
const router = useRouter()
const assignmentStore = useAssignmentStore()
const assignmentId = computed(() => Number(route.params.id))
const detail = computed(() => assignmentStore.current)
const actionError = ref('')
const isWorking = ref(false)
const stats = ref<AssignmentStatistics | null>(null)
const statsError = ref('')
const peerProblemId = ref<number | null>(null)
const peerSubmissions = ref<PeerSubmission[]>([])
const peerError = ref('')
const peerLoading = ref(false)
const isExportingStats = ref(false)
const myAppeal = ref<GradeAppeal | null>(null)
const appealFormOpen = ref(false)
const appealReason = ref('')
const appealError = ref('')
const isSubmittingAppeal = ref(false)

const isDraft = computed(() => detail.value?.status === 'draft')
const isPublished = computed(() => detail.value?.status === 'published')
const isArchived = computed(() => detail.value?.status === 'archived')
const isClosed = computed(() => isPast(detail.value?.dueAt) || isArchived.value)
const canShowScores = computed(() => Boolean(detail.value?.isOwner || detail.value?.totalScore !== undefined))
const canSeeStats = computed(
  () => Boolean(detail.value?.isOwner || (detail.value?.showClassStats && canShowScores.value)),
)
const canAppeal = computed(
  () => Boolean(!detail.value?.isOwner && detail.value?.gradesPublished && canShowScores.value),
)

const load = async (): Promise<void> => {
  if (!Number.isInteger(assignmentId.value) || assignmentId.value <= 0) return
  actionError.value = ''
  await assignmentStore.loadAssignment(assignmentId.value)
  stats.value = null
  statsError.value = ''
  peerProblemId.value = null
  peerSubmissions.value = []
  myAppeal.value = null
  if (detail.value && !detail.value.isOwner && detail.value.gradesPublished && canShowScores.value) {
    try {
      myAppeal.value = await fetchMyGradeAppeal(assignmentId.value)
    } catch {
      myAppeal.value = null
    }
  }
  if (detail.value && (detail.value.isOwner || (detail.value.showClassStats && canShowScores.value))) {
    try {
      stats.value = await fetchAssignmentStatistics(assignmentId.value)
    } catch (exception: unknown) {
      statsError.value = toErrorMessage(exception)
    }
  }
}

const runAction = async (action: () => Promise<unknown>, message: string): Promise<void> => {
  if (isWorking.value) return
  actionError.value = ''
  isWorking.value = true
  try {
    await action()
    toast.success(message)
  } catch (exception: unknown) {
    actionError.value = toErrorMessage(exception)
  } finally {
    isWorking.value = false
  }
}

const publish = (): void => {
  if (!detail.value) return
  void runAction(async () => {
    await assignmentStore.publish(detail.value!.id)
  }, '作业已发布')
}

const archive = (): void => {
  if (!detail.value) return
  if (!window.confirm('归档后学生不能再提交 确定归档吗？')) return
  void runAction(async () => {
    await assignmentStore.archive(detail.value!.id)
  }, '作业已归档')
}

const remove = (): void => {
  if (!detail.value) return
  if (!window.confirm('确定删除这份草稿吗？删除后无法恢复')) return
  const classId = detail.value.classId
  void runAction(async () => {
    await assignmentStore.remove(detail.value!.id)
    await router.push(`/classes/${classId}`)
  }, '草稿已删除')
}

const problemHref = (problemId: number): string =>
  `/problem/${problemId}?assignment_id=${assignmentId.value}`

const publishSolutionsNow = (): void => {
  if (!detail.value) return
  void runAction(async () => {
    await publishSolutions(detail.value!.id)
    await load()
  }, '解析已发布')
}

const exportStats = async (): Promise<void> => {
  if (isExportingStats.value || !detail.value) return
  actionError.value = ''
  isExportingStats.value = true
  try {
    const blob = await exportAssignmentStatistics(detail.value.id)
    const title = detail.value.title.replace(/[\\/:*?"<>|]/g, '_')
    const url = URL.createObjectURL(blob)
    const anchor = document.createElement('a')
    anchor.href = url
    anchor.download = `${title}-统计.csv`
    anchor.click()
    setTimeout(() => URL.revokeObjectURL(url), 0)
    toast.success('统计报表已导出')
  } catch (exception: unknown) {
    actionError.value = toErrorMessage(exception)
  } finally {
    isExportingStats.value = false
  }
}

const openAppeal = (): void => {
  appealReason.value = ''
  appealError.value = ''
  appealFormOpen.value = true
}

const closeAppeal = (): void => {
  appealFormOpen.value = false
}

const submitAppeal = async (): Promise<void> => {
  if (isSubmittingAppeal.value) return
  const reason = appealReason.value.trim()
  if (!reason) {
    appealError.value = '请填写申诉理由'
    return
  }
  appealError.value = ''
  isSubmittingAppeal.value = true
  try {
    await submitGradeAppeal(assignmentId.value, reason)
    myAppeal.value = await fetchMyGradeAppeal(assignmentId.value)
    appealFormOpen.value = false
    toast.success('申诉已提交')
  } catch (exception: unknown) {
    appealError.value = toErrorMessage(exception)
  } finally {
    isSubmittingAppeal.value = false
  }
}

const togglePeerCode = async (problemId: number): Promise<void> => {
  if (peerProblemId.value === problemId) {
    peerProblemId.value = null
    peerSubmissions.value = []
    return
  }
  peerProblemId.value = problemId
  peerSubmissions.value = []
  peerError.value = ''
  peerLoading.value = true
  try {
    peerSubmissions.value = await fetchPeerSubmissions(assignmentId.value, problemId)
  } catch (exception: unknown) {
    peerError.value = toErrorMessage(exception)
  } finally {
    peerLoading.value = false
  }
}

const positionLabel = (bucket?: string): string => {
  if (bucket === 'top10') return '前 10%'
  if (bucket === 'top25') return '前 25%'
  if (bucket === 'top50') return '前 50%'
  if (bucket === 'rest') return '后半段'
  return '-'
}

onMounted(load)
watch(assignmentId, load)
</script>

<template>
  <NavBar />
  <main class="teaching-page page-shell">
    <p v-if="assignmentStore.isLoading" class="empty-state"><span>正在加载作业</span></p>
    <div v-else-if="assignmentStore.error" class="empty-state">
      <p>{{ assignmentStore.error }}</p>
      <RouterLink class="primary-button" to="/classes">返回组织</RouterLink>
    </div>

    <template v-else-if="detail">
      <header class="teaching-page-header">
        <div>
          <h1>{{ detail.title }}</h1>
          <p class="teaching-subtle">
            <span :class="['teaching-badge', detail.status]">{{ assignmentStatusLabel(detail.status) }}</span>
            <span v-if="detail.startAt">开始 {{ formatDateTime(detail.startAt) }}</span>
            <span v-if="detail.dueAt">截止 {{ formatDateTime(detail.dueAt) }}</span>
            <span v-if="detail.latePolicy === 'allow'">
              允许迟交 · 每日 {{ detail.latePenaltyPerDay }}% · 封顶 {{ detail.latePenaltyCap }}%
            </span>
            <span v-else>禁止迟交</span>
            <span>计分：{{ detail.scoringPolicy === 'highest' ? '取最高' : detail.scoringPolicy === 'last' ? '取最后一次' : '取首次通过' }}</span>
          </p>
        </div>
        <div v-if="detail.isOwner" class="teaching-header-actions">
          <RouterLink
            v-if="!isArchived"
            class="teaching-secondary-button"
            :to="`/assignments/${detail.id}/edit`"
          >
            编辑作业
          </RouterLink>
          <RouterLink
            v-if="isPublished"
            class="teaching-secondary-button"
            :to="`/assignments/${detail.id}/grade`"
          >
            批改台
          </RouterLink>
          <button
            v-if="isPublished"
            class="teaching-secondary-button"
            type="button"
            :disabled="isExportingStats"
            @click="exportStats"
          >
            {{ isExportingStats ? '导出中' : '导出统计报表' }}
          </button>
          <button
            v-if="isDraft"
            class="primary-button"
            type="button"
            :disabled="isWorking"
            @click="publish"
          >
            发布
          </button>
          <button
            v-if="isPublished && !detail.solutionsPublished && isPast(detail.dueAt)"
            class="teaching-secondary-button"
            type="button"
            :disabled="isWorking"
            @click="publishSolutionsNow"
          >
            发布解析
          </button>
          <button
            v-if="isPublished"
            class="teaching-secondary-button"
            type="button"
            :disabled="isWorking"
            @click="archive"
          >
            归档
          </button>
          <button
            v-if="isDraft"
            class="teaching-secondary-button danger"
            type="button"
            :disabled="isWorking"
            @click="remove"
          >
            删除草稿
          </button>
        </div>
      </header>

      <p v-if="actionError" class="form-error" role="alert">{{ actionError }}</p>

      <section class="teaching-panel">
        <MarkdownBody v-if="detail.description" :content="detail.description" />
        <p v-else class="teaching-subtle">没有描述</p>
      </section>

      <section v-if="detail.isOwner" class="teaching-stats">
        <article><strong>{{ detail.studentCount ?? 0 }}</strong><span>学生</span></article>
        <article><strong>{{ detail.submittedStudentCount ?? 0 }}</strong><span>已提交</span></article>
        <article><strong>{{ detail.problems.length }}</strong><span>题目</span></article>
        <article><strong>{{ detail.lateStudentCount ?? 0 }}</strong><span>迟交学生</span></article>
        <article><strong>{{ detail.exemptCount ?? 0 }}</strong><span>免修记录</span></article>
      </section>

      <section v-if="!detail.isOwner && canShowScores" class="teaching-stats">
        <article><strong>{{ detail.totalScore ?? 0 }}</strong><span>总分</span></article>
        <article>
          <strong>{{ detail.problems.filter((problem) => problem.accepted).length }} / {{ detail.problems.length }}</strong>
          <span>通过题目</span>
        </article>
      </section>

      <section class="teaching-section">
        <div class="section-heading"><h2>题目</h2></div>
        <div class="teaching-assignment-problems">
          <article v-for="problem in detail.problems" :key="problem.problemId">
            <div class="teaching-problem-heading">
              <RouterLink v-if="!detail.isOwner" :to="problemHref(problem.problemId)">
                {{ problem.position + 1 }}. {{ problem.title }}
              </RouterLink>
              <span v-else>{{ problem.position + 1 }}. {{ problem.title }}</span>
              <span :class="['difficulty', problem.difficulty]">{{ DIFFICULTY_LABELS[problem.difficulty] }}</span>
              <span class="teaching-points">{{ problem.points }} 分</span>
            </div>
            <div class="teaching-problem-meta">
              <template v-if="detail.isOwner">
                <span v-if="problem.acceptedStudentCount !== undefined">{{ problem.acceptedStudentCount }} 人通过</span>
              </template>
              <template v-else>
                <span>{{ problemAttemptLabel(problem.attempts, problem.accepted) }}</span>
                <span>
                  {{ problem.attempts }} 次提交
                  <template v-if="problem.attemptsLimit">
                    / 上限 {{ problem.attemptsLimit }}
                  </template>
                </span>
                <span v-if="problem.exempt" class="teaching-badge">
                  免修{{ problem.exemptionMode === 'excluded' ? '（不计分）' : '' }}
                </span>
                <span v-if="problem.isLate" class="teaching-badge">
                  迟交 {{ problem.lateDays }} 天
                </span>
                <span v-if="canShowScores" class="teaching-score">
                  {{ gradeSummary(problem.finalScore, problem.points) }}
                </span>
                <span v-if="problem.feedback" class="teaching-feedback">{{ problem.feedback }}</span>
                <span v-if="problem.solutionsVisible && problem.solutionMd" class="teaching-solution">
                  解析：<MarkdownBody :content="problem.solutionMd" />
                </span>
                <button
                  v-if="detail.allowPeerCode && canShowScores"
                  type="button"
                  class="teaching-link-button"
                  @click="togglePeerCode(problem.problemId)"
                >
                  {{ peerProblemId === problem.problemId ? '收起同学代码' : '查看同学 AC 代码' }}
                </button>
              </template>
            </div>
          </article>
          <p v-if="!detail.problems.length" class="empty-state"><span>还没有题目</span></p>
        </div>
      </section>

      <section v-if="!detail.isOwner" class="teaching-panel">
        <p v-if="isArchived" class="teaching-subtle">作业已归档 不能提交</p>
        <p v-else-if="isClosed" class="teaching-subtle">已截止 不能提交</p>
        <p v-else-if="!detail.canSubmit" class="teaching-subtle">当前不能提交</p>
        <p v-else class="teaching-subtle">点击题目进入作答</p>
        <div v-if="canShowScores && detail.overallFeedback" class="teaching-overall-feedback">
          <span>整体评语</span>
          <p>{{ detail.overallFeedback }}</p>
        </div>
      </section>

      <section v-if="!detail.isOwner && canAppeal" class="teaching-panel">
        <div class="section-heading">
          <h2>成绩申诉</h2>
          <button v-if="!myAppeal" class="teaching-secondary-button" type="button" @click="openAppeal">
            提交申诉
          </button>
        </div>
        <p v-if="!myAppeal" class="teaching-subtle">对成绩有疑问可提交一次申诉 由老师处理</p>
        <template v-else>
          <p class="teaching-subtle">
            <span :class="['teaching-badge', myAppeal.status]">
              {{ GRADE_APPEAL_STATUS_LABELS[myAppeal.status] }}
            </span>
            <span>提交于 {{ formatDateTime(myAppeal.createdAt) }}</span>
            <span v-if="myAppeal.handledAt">处理于 {{ formatDateTime(myAppeal.handledAt) }}</span>
          </p>
          <p class="teaching-appeal-reason">{{ myAppeal.reason }}</p>
          <p v-if="myAppeal.handleNote" class="teaching-subtle">老师说明：{{ myAppeal.handleNote }}</p>
        </template>
      </section>

      <section v-if="peerProblemId !== null" class="teaching-panel">
        <div class="section-heading"><h2>同学 AC 代码</h2></div>
        <p v-if="peerLoading" class="teaching-subtle">加载中</p>
        <p v-else-if="peerError" class="form-error">{{ peerError }}</p>
        <p v-else-if="!peerSubmissions.length" class="teaching-subtle">暂时没有可查看的提交</p>
        <article v-for="submission in peerSubmissions" v-else :key="`${submission.username}-${submission.submittedAt}`">
          <p class="teaching-subtle">{{ submission.username }} · {{ submission.language }} · {{ formatDateTime(submission.submittedAt) }}</p>
          <pre class="teaching-code-block">{{ submission.code }}</pre>
        </article>
      </section>

      <section v-if="canSeeStats" class="teaching-panel">
        <div class="section-heading"><h2>组织统计</h2></div>
        <p v-if="statsError" class="form-error">{{ statsError }}</p>
        <template v-else-if="stats">
          <div class="teaching-stats">
            <article><strong>{{ stats.averageScore }}</strong><span>组织平均分</span></article>
            <article><strong>{{ stats.submittedStudentCount }} / {{ stats.studentCount }}</strong><span>已提交</span></article>
            <article v-if="stats.myTotalScore !== undefined"><strong>{{ stats.myTotalScore }}</strong><span>我的总分</span></article>
            <article v-if="stats.myPositionBucket"><strong>{{ positionLabel(stats.myPositionBucket) }}</strong><span>我的位置</span></article>
          </div>
          <div class="teaching-assignment-problems">
            <article v-for="problem in stats.problems" :key="problem.problemId">
              <div class="teaching-problem-meta">
                <span>#{{ problem.problemId }}</span>
                <span>通过率 {{ Math.round(problem.passRate * 100) }}%</span>
                <span>平均 {{ problem.averageScore }} / {{ problem.points }}</span>
                <span v-if="problem.exemptCount">免修 {{ problem.exemptCount }}</span>
                <span v-if="problem.notSubmittedCount">未提交 {{ problem.notSubmittedCount }}</span>
              </div>
            </article>
          </div>
        </template>
        <p v-else class="teaching-subtle">加载中</p>
      </section>
    </template>
  </main>

  <div v-if="appealFormOpen" class="modal-backdrop" @click.self="closeAppeal">
    <section class="run-dialog" role="dialog" aria-modal="true" aria-labelledby="grade-appeal-title">
      <header>
        <div>
          <h2 id="grade-appeal-title">成绩申诉</h2>
          <p>{{ detail?.title }}</p>
        </div>
        <button type="button" aria-label="关闭" @click="closeAppeal">×</button>
      </header>
      <div class="run-dialog-body">
        <form class="teaching-grade-form" @submit.prevent="submitAppeal">
          <label>
            <span>申诉理由</span>
            <textarea
              v-model="appealReason"
              rows="5"
              maxlength="2000"
              placeholder="说明需要老师复核的题目与原因"
            ></textarea>
          </label>
          <p v-if="appealError" class="form-error" role="alert">{{ appealError }}</p>
          <p class="teaching-subtle">每份作业只能提交一次申诉</p>
          <div class="teaching-form-actions">
            <button class="teaching-secondary-button" type="button" @click="closeAppeal">取消</button>
            <button class="primary-button" type="submit" :disabled="isSubmittingAppeal">
              {{ isSubmittingAppeal ? '提交中' : '提交申诉' }}
            </button>
          </div>
        </form>
      </div>
    </section>
  </div>
</template>
