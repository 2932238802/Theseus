<script setup lang="ts">
import { computed, onMounted, ref, watch } from 'vue'
import { useRoute } from 'vue-router'
import NavBar from '../components/NavBar.vue'
import { toErrorMessage } from '../api/client'
import {
  fetchAssignmentSubmissions,
  publishGrades,
  updateOverallGrade,
  updateProblemGrade,
} from '../api/assignments'
import { fetchSubmission } from '../api/submissions'
import {
  deleteOverride,
  fetchOverrides,
  fetchPolicyAudits,
  publishSolutions,
  setOverride,
} from '../api/policies'
import { useAssignmentStore } from '../store/assignments'
import type { Submission } from '../types/oj'
import type { GradebookCell, GradebookStudent } from '../types/teaching'
import type { ExemptionMode, OverrideItem, PolicyAudit } from '../types/policy'
import { formatDateTime, isPast, toIsoString } from '../utils/teaching'

const route = useRoute()
const assignmentStore = useAssignmentStore()
const assignmentId = computed(() => Number(route.params.id))
const gradebook = computed(() => assignmentStore.gradebook)
const includeRemoved = ref(false)
const actionError = ref('')
const actionMessage = ref('')
const isPublishing = ref(false)
const overrides = ref<OverrideItem[]>([])
const overrideMakeup = ref('')
const overrideWaive = ref(true)
const overrideExempt = ref(false)
const overrideMode = ref<ExemptionMode>('full_score')
const overrideReason = ref('')
const isSavingOverride = ref(false)
const audits = ref<PolicyAudit[]>([])
const showAudits = ref(false)
const auditsLoading = ref(false)

const cellTarget = ref<{ student: GradebookStudent; cell: GradebookCell } | null>(null)
const cellSubmissions = ref<Submission[]>([])
const cellSubmissionsLoading = ref(false)
const cellSubmissionsError = ref('')
const selectedSubmission = ref<Submission | null>(null)
const submissionDetailLoading = ref(false)
const manualScoreInput = ref('')
const feedbackInput = ref('')
const isSavingCell = ref(false)

const overallTarget = ref<GradebookStudent | null>(null)
const overallInput = ref('')
const isSavingOverall = ref(false)

const duePassed = computed(() => Boolean(gradebook.value?.assignment.dueAt && isPast(gradebook.value.assignment.dueAt)))
const gradesPublished = computed(() => Boolean(gradebook.value?.assignment.gradesPublishedAt))

const load = async (): Promise<void> => {
  if (!Number.isInteger(assignmentId.value) || assignmentId.value <= 0) return
  actionError.value = ''
  await assignmentStore.loadGradebook(assignmentId.value, includeRemoved.value)
  try {
    overrides.value = await fetchOverrides(assignmentId.value)
  } catch {
    overrides.value = []
  }
}

const cellFor = (student: GradebookStudent, problemId: number): GradebookCell | null =>
  student.problems.find((cell) => cell.problemId === problemId) ?? null

const overrideFor = (student: GradebookStudent, problemId: number): OverrideItem | undefined =>
  overrides.value.find(
    (item) => item.userId === student.userId && item.problemId === problemId,
  )

const openCell = async (student: GradebookStudent, problemId: number): Promise<void> => {
  const cell = cellFor(student, problemId)
  if (!cell) return
  actionError.value = ''
  cellTarget.value = { student, cell }
  manualScoreInput.value = cell.manualScore === null ? '' : String(cell.manualScore)
  feedbackInput.value = cell.feedback ?? ''
  const existing = overrideFor(student, problemId)
  overrideMakeup.value = existing?.makeupDueAt ? existing.makeupDueAt.slice(0, 16) : ''
  overrideWaive.value = existing?.waiveLatePenalty ?? true
  overrideExempt.value = existing?.exempt ?? false
  overrideMode.value = existing?.exemptionMode ?? 'full_score'
  overrideReason.value = existing?.reason ?? ''
  selectedSubmission.value = null
  cellSubmissionsError.value = ''
  cellSubmissions.value = []
  cellSubmissionsLoading.value = true
  try {
    const result = await fetchAssignmentSubmissions(assignmentId.value, {
      userId: student.userId,
      problemId,
      page: 1,
      size: 20,
    })
    cellSubmissions.value = result.submissions
  } catch (exception: unknown) {
    cellSubmissionsError.value = toErrorMessage(exception)
  } finally {
    cellSubmissionsLoading.value = false
  }
}

const closeCell = (): void => {
  cellTarget.value = null
  selectedSubmission.value = null
}

const viewSubmission = async (submission: Submission): Promise<void> => {
  submissionDetailLoading.value = true
  try {
    selectedSubmission.value = await fetchSubmission(submission.id)
  } catch (exception: unknown) {
    cellSubmissionsError.value = toErrorMessage(exception)
  } finally {
    submissionDetailLoading.value = false
  }
}

const saveCell = async (): Promise<void> => {
  if (!cellTarget.value || isSavingCell.value) return
  const { student, cell } = cellTarget.value
  if (student.status === 'removed') return
  actionError.value = ''
  actionMessage.value = ''
  const raw = manualScoreInput.value.trim()
  let manualScore: number | null = null
  if (raw) {
    const parsed = Number(raw)
    if (!Number.isInteger(parsed) || parsed < 0 || parsed > cellPoints(cell)) {
      actionError.value = `手动分必须是 0 到 ${cellPoints(cell)} 之间的整数`
      return
    }
    manualScore = parsed
  }
  const feedback = feedbackInput.value.trim() || null
  if (feedback && feedback.length > 2000) {
    actionError.value = '评语不能超过 2000 个字符'
    return
  }
  isSavingCell.value = true
  try {
    await updateProblemGrade(
      assignmentId.value,
      student.userId,
      cell.problemId,
      manualScore,
      feedback,
    )
    actionMessage.value = '分数已保存'
    await load()
  } catch (exception: unknown) {
    actionError.value = toErrorMessage(exception)
  } finally {
    isSavingCell.value = false
  }
}

const cellPoints = (cell: GradebookCell): number => {
  const problem = gradebook.value?.problems.find((item) => item.problemId === cell.problemId)
  return problem?.points ?? 0
}

const openOverall = (student: GradebookStudent): void => {
  overallTarget.value = student
  overallInput.value = student.overallFeedback ?? ''
}

const closeOverall = (): void => {
  overallTarget.value = null
}

const saveOverall = async (): Promise<void> => {
  if (!overallTarget.value || isSavingOverall.value) return
  if (overallTarget.value.status === 'removed') return
  actionError.value = ''
  actionMessage.value = ''
  const feedback = overallInput.value.trim()
  if (feedback.length > 5000) {
    actionError.value = '整体评语不能超过 5000 个字符'
    return
  }
  isSavingOverall.value = true
  try {
    await updateOverallGrade(assignmentId.value, overallTarget.value.userId, feedback || null)
    actionMessage.value = '整体评语已保存'
    await load()
  } catch (exception: unknown) {
    actionError.value = toErrorMessage(exception)
  } finally {
    isSavingOverall.value = false
  }
}

const publish = async (): Promise<void> => {
  if (isPublishing.value || !duePassed.value || gradesPublished.value) return
  if (!window.confirm('发布后学生可以查看成绩 确定发布吗？')) return
  actionError.value = ''
  actionMessage.value = ''
  isPublishing.value = true
  try {
    await publishGrades(assignmentId.value)
    actionMessage.value = '成绩已发布'
    await load()
  } catch (exception: unknown) {
    actionError.value = toErrorMessage(exception)
  } finally {
    isPublishing.value = false
  }
}

const cellLabel = (cell: GradebookCell): string => {
  if (cell.exempt) return '免修'
  if (cell.accepted) return '已通过'
  return cell.attempts > 0 ? `尝试 ${cell.attempts} 次` : '未提交'
}

const saveOverride = async (): Promise<void> => {
  if (!cellTarget.value || isSavingOverride.value) return
  const { student, cell } = cellTarget.value
  if (!overrideExempt.value && !overrideMakeup.value) {
    actionError.value = '补交截止和免修至少设置一项'
    return
  }
  actionError.value = ''
  actionMessage.value = ''
  isSavingOverride.value = true
  try {
    await setOverride(assignmentId.value, student.userId, cell.problemId, {
      makeupDueAt: overrideMakeup.value ? toIsoString(overrideMakeup.value) : undefined,
      waiveLatePenalty: overrideWaive.value,
      exempt: overrideExempt.value,
      exemptionMode: overrideExempt.value ? overrideMode.value : undefined,
      reason: overrideReason.value.trim() || undefined,
    })
    actionMessage.value = '补交/免修已保存'
    await load()
  } catch (exception: unknown) {
    actionError.value = toErrorMessage(exception)
  } finally {
    isSavingOverride.value = false
  }
}

const removeOverride = async (): Promise<void> => {
  if (!cellTarget.value || isSavingOverride.value) return
  const { student, cell } = cellTarget.value
  actionError.value = ''
  isSavingOverride.value = true
  try {
    await deleteOverride(assignmentId.value, student.userId, cell.problemId)
    actionMessage.value = '例外已撤销'
    overrideMakeup.value = ''
    overrideExempt.value = false
    overrideReason.value = ''
    await load()
  } catch (exception: unknown) {
    actionError.value = toErrorMessage(exception)
  } finally {
    isSavingOverride.value = false
  }
}

const publishSolutionsNow = async (): Promise<void> => {
  actionError.value = ''
  actionMessage.value = ''
  try {
    await publishSolutions(assignmentId.value)
    actionMessage.value = '解析已发布'
  } catch (exception: unknown) {
    actionError.value = toErrorMessage(exception)
  }
}

const openAudits = async (): Promise<void> => {
  showAudits.value = true
  auditsLoading.value = true
  try {
    audits.value = await fetchPolicyAudits(assignmentId.value)
  } catch (exception: unknown) {
    actionError.value = toErrorMessage(exception)
  } finally {
    auditsLoading.value = false
  }
}

onMounted(load)
watch(includeRemoved, load)
</script>

<template>
  <NavBar />
  <main class="teaching-page teaching-wide page-shell">
    <p v-if="assignmentStore.isGradebookLoading && !gradebook" class="empty-state"><span>正在加载批改台</span></p>
    <div v-else-if="assignmentStore.gradebookError" class="empty-state">
      <p>{{ assignmentStore.gradebookError }}</p>
      <RouterLink class="primary-button" :to="`/assignments/${assignmentId}`">返回作业</RouterLink>
    </div>

    <template v-else-if="gradebook">
      <header class="teaching-page-header">
        <div>
          <p class="teaching-breadcrumb">
            <RouterLink :to="`/assignments/${assignmentId}`">{{ gradebook.assignment.title }}</RouterLink><span>/</span><span>批改台</span>
          </p>
          <h1>{{ gradebook.assignment.title }}</h1>
          <p class="teaching-subtle">
            <span>截止 {{ formatDateTime(gradebook.assignment.dueAt) }}</span>
            <span v-if="gradebook.assignment.gradesPublishedAt">成绩发布于 {{ formatDateTime(gradebook.assignment.gradesPublishedAt) }}</span>
          </p>
        </div>
        <div class="teaching-header-actions">
          <label class="teaching-switch">
            <input v-model="includeRemoved" type="checkbox" />
            <span>包含已移除成员</span>
          </label>
          <button class="teaching-secondary-button" type="button" :disabled="!duePassed" @click="publishSolutionsNow">
            发布解析
          </button>
          <button class="teaching-secondary-button" type="button" @click="openAudits">
            策略审计
          </button>
          <button
            class="primary-button"
            type="button"
            :disabled="isPublishing || gradesPublished || !duePassed"
            :title="gradesPublished ? '成绩已发布' : duePassed ? '' : '作业尚未截止'"
            @click="publish"
          >
            {{ gradesPublished ? '成绩已发布' : isPublishing ? '发布中' : '发布成绩' }}
          </button>
        </div>
      </header>

      <p v-if="actionError" class="form-error" role="alert">{{ actionError }}</p>
      <p v-if="actionMessage" class="teaching-success" role="status">{{ actionMessage }}</p>
      <p v-if="!duePassed && !gradesPublished" class="teaching-subtle">作业尚未截止 暂不能发布成绩</p>

      <div class="gradebook-scroll">
        <table class="gradebook-table">
          <thead>
            <tr>
              <th>学生</th>
              <th v-for="problem in gradebook.problems" :key="problem.problemId">
                <span>{{ problem.title }}</span>
                <small>{{ problem.points }} 分</small>
              </th>
              <th>总分</th>
              <th>整体评语</th>
            </tr>
          </thead>
          <tbody>
            <tr v-for="student in gradebook.students" :key="student.userId" :class="{ removed: student.status === 'removed' }">
              <td class="gradebook-student">
                <strong>{{ student.username }}</strong>
                <span>{{ student.email }}</span>
                <small v-if="student.status === 'removed'">已移除</small>
              </td>
              <td v-for="problem in gradebook.problems" :key="problem.problemId">
                <button
                  v-if="cellFor(student, problem.problemId)"
                  class="gradebook-cell"
                  type="button"
                  @click="openCell(student, problem.problemId)"
                >
                  <span>{{ cellLabel(cellFor(student, problem.problemId)!) }}</span>
                  <span v-if="cellFor(student, problem.problemId)!.isLate">
                    迟交 {{ cellFor(student, problem.problemId)!.lateDays }} 天
                  </span>
                  <span v-if="cellFor(student, problem.problemId)!.attemptsLimit">
                    次数 {{ cellFor(student, problem.problemId)!.attempts }} / {{ cellFor(student, problem.problemId)!.attemptsLimit }}
                  </span>
                  <span>自动 {{ cellFor(student, problem.problemId)!.autoScore }}</span>
                  <span v-if="cellFor(student, problem.problemId)!.manualScore !== null">
                    手动 {{ cellFor(student, problem.problemId)!.manualScore }}
                  </span>
                  <strong>{{ cellFor(student, problem.problemId)!.finalScore }}</strong>
                </button>
              </td>
              <td class="gradebook-total">{{ student.totalScore }}</td>
              <td>
                <button class="teaching-link-button" type="button" @click="openOverall(student)">
                  {{ student.overallFeedback ? '查看' : '填写' }}
                </button>
              </td>
            </tr>
          </tbody>
        </table>
        <p v-if="!gradebook.students.length" class="empty-state"><span>还没有学生</span></p>
      </div>
    </template>
  </main>

  <div v-if="cellTarget" class="modal-backdrop" @click.self="closeCell">
    <section class="run-dialog gradebook-dialog" role="dialog" aria-modal="true" aria-labelledby="gradebook-cell-title">
      <header>
        <div>
          <h2 id="gradebook-cell-title">{{ cellTarget.student.username }}</h2>
          <p>题目 #{{ cellTarget.cell.problemId }} · {{ cellPoints(cellTarget.cell) }} 分</p>
        </div>
        <button type="button" aria-label="关闭" @click="closeCell">×</button>
      </header>
      <div class="run-dialog-body">
        <p v-if="cellSubmissionsLoading" class="teaching-subtle">正在加载提交</p>
        <p v-else-if="cellSubmissionsError" class="form-error" role="alert">{{ cellSubmissionsError }}</p>
        <template v-else-if="cellSubmissions.length">
          <div class="teaching-submission-list">
            <article v-for="submission in cellSubmissions" :key="submission.id">
              <div>
                <strong>#{{ submission.id }}</strong>
                <span>{{ submission.language }}</span>
                <span :class="['result-status', submission.status === 'Accepted' ? 'accepted' : 'failed']">
                  {{ submission.status }}
                </span>
                <time>{{ formatDateTime(submission.createdAt) }}</time>
              </div>
              <button type="button" @click="viewSubmission(submission)">查看</button>
            </article>
          </div>
        </template>
        <p v-else class="teaching-subtle">还没有提交</p>

        <p v-if="submissionDetailLoading" class="teaching-subtle">正在加载提交详情</p>
        <div v-else-if="selectedSubmission" class="teaching-submission-detail">
          <dl>
            <div><dt>状态</dt><dd>{{ selectedSubmission.status }}</dd></div>
            <div><dt>通过用例</dt><dd>{{ selectedSubmission.testCasesPassed }} / {{ selectedSubmission.totalTestCases }}</dd></div>
            <div v-if="selectedSubmission.runtime"><dt>执行用时</dt><dd>{{ selectedSubmission.runtime }}</dd></div>
            <div v-if="selectedSubmission.memory"><dt>内存消耗</dt><dd>{{ selectedSubmission.memory }}</dd></div>
          </dl>
          <div v-if="selectedSubmission.code" class="run-block"><span>代码</span><pre>{{ selectedSubmission.code }}</pre></div>
        </div>

        <form class="teaching-grade-form" @submit.prevent="saveOverride">
          <h3>补交 / 免修</h3>
          <label>
            <span>补交截止（留空表示不补交）</span>
            <input v-model="overrideMakeup" type="datetime-local" :disabled="cellTarget.student.status === 'removed'" />
          </label>
          <label class="teaching-checkbox">
            <input v-model="overrideWaive" type="checkbox" :disabled="cellTarget.student.status === 'removed'" />
            <span>补交免迟交扣分</span>
          </label>
          <label class="teaching-checkbox">
            <input v-model="overrideExempt" type="checkbox" :disabled="cellTarget.student.status === 'removed'" />
            <span>该题免修</span>
          </label>
          <label v-if="overrideExempt">
            <span>免修计分</span>
            <select v-model="overrideMode" :disabled="cellTarget.student.status === 'removed'">
              <option value="full_score">计满分</option>
              <option value="excluded">从总分排除</option>
            </select>
          </label>
          <label>
            <span>原因</span>
            <textarea v-model="overrideReason" rows="2" maxlength="2000" :disabled="cellTarget.student.status === 'removed'"></textarea>
          </label>
          <div class="teaching-form-actions">
            <button class="teaching-secondary-button" type="button" :disabled="isSavingOverride" @click="removeOverride">
              撤销例外
            </button>
            <button class="primary-button" type="submit" :disabled="isSavingOverride || cellTarget.student.status === 'removed'">
              {{ isSavingOverride ? '保存中' : '保存补交/免修' }}
            </button>
          </div>
        </form>

        <form class="teaching-grade-form" @submit.prevent="saveCell">
          <label>
            <span>手动分</span>
            <input v-model="manualScoreInput" type="number" min="0" :max="cellPoints(cellTarget.cell)" :disabled="cellTarget.student.status === 'removed'" />
          </label>
          <label>
            <span>评语</span>
            <textarea v-model="feedbackInput" rows="4" maxlength="2000" :disabled="cellTarget.student.status === 'removed'"></textarea>
          </label>
          <p v-if="cellTarget.student.status === 'removed'" class="teaching-subtle">已移除成员只读</p>
          <div class="teaching-form-actions">
            <button class="primary-button" type="submit" :disabled="isSavingCell || cellTarget.student.status === 'removed'">
              {{ isSavingCell ? '保存中' : '保存' }}
            </button>
          </div>
        </form>
      </div>
    </section>
  </div>

  <div v-if="showAudits" class="modal-backdrop" @click.self="showAudits = false">
    <section class="run-dialog gradebook-dialog" role="dialog" aria-modal="true">
      <header>
        <div><h2>策略审计</h2><p>最近 200 条</p></div>
        <button type="button" aria-label="关闭" @click="showAudits = false">×</button>
      </header>
      <div class="run-dialog-body">
        <p v-if="auditsLoading" class="teaching-subtle">加载中</p>
        <p v-else-if="!audits.length" class="teaching-subtle">还没有审计记录</p>
        <article v-for="audit in audits" v-else :key="audit.id">
          <p><strong>{{ audit.action }}</strong> · {{ audit.actorUsername || '系统' }} · {{ formatDateTime(audit.createdAt) }}</p>
          <p v-if="audit.reason" class="teaching-subtle">{{ audit.reason }}</p>
          <pre class="teaching-code-block">{{ JSON.stringify(audit.afterData, null, 2) }}</pre>
        </article>
      </div>
    </section>
  </div>

  <div v-if="overallTarget" class="modal-backdrop" @click.self="closeOverall">
    <section class="run-dialog gradebook-dialog" role="dialog" aria-modal="true" aria-labelledby="gradebook-overall-title">
      <header>
        <div><h2 id="gradebook-overall-title">{{ overallTarget.username }}</h2><p>整体评语</p></div>
        <button type="button" aria-label="关闭" @click="closeOverall">×</button>
      </header>
      <div class="run-dialog-body">
        <form class="teaching-grade-form" @submit.prevent="saveOverall">
          <label>
            <span>整体评语</span>
            <textarea v-model="overallInput" rows="6" maxlength="5000" :disabled="overallTarget.status === 'removed'"></textarea>
          </label>
          <p v-if="overallTarget.status === 'removed'" class="teaching-subtle">已移除成员只读</p>
          <div class="teaching-form-actions">
            <button class="primary-button" type="submit" :disabled="isSavingOverall || overallTarget.status === 'removed'">
              {{ isSavingOverall ? '保存中' : '保存' }}
            </button>
          </div>
        </form>
      </div>
    </section>
  </div>
</template>
