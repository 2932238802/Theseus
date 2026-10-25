<script setup lang="ts">
import { computed, onMounted, ref, watch } from 'vue'
import { useRoute, useRouter } from 'vue-router'
import MarkdownBody from '../components/MarkdownBody.vue'
import NavBar from '../components/NavBar.vue'
import { toErrorMessage } from '../api/client'
import { useAssignmentStore } from '../store/assignments'
import {
  DIFFICULTY_LABELS,
} from '../utils/constants'
import {
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
const actionMessage = ref('')
const isWorking = ref(false)

const isDraft = computed(() => detail.value?.status === 'draft')
const isPublished = computed(() => detail.value?.status === 'published')
const isArchived = computed(() => detail.value?.status === 'archived')
const isClosed = computed(() => isPast(detail.value?.dueAt) || isArchived.value)
const canShowScores = computed(() => Boolean(detail.value?.gradesPublished))

const load = async (): Promise<void> => {
  if (!Number.isInteger(assignmentId.value) || assignmentId.value <= 0) return
  actionError.value = ''
  actionMessage.value = ''
  await assignmentStore.loadAssignment(assignmentId.value)
}

const runAction = async (action: () => Promise<unknown>, message: string): Promise<void> => {
  if (isWorking.value) return
  actionError.value = ''
  actionMessage.value = ''
  isWorking.value = true
  try {
    await action()
    actionMessage.value = message
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
  if (!window.confirm('归档后学生不能再提交，确定归档吗？')) return
  void runAction(async () => {
    await assignmentStore.archive(detail.value!.id)
  }, '作业已归档')
}

const remove = (): void => {
  if (!detail.value) return
  if (!window.confirm('确定删除这份草稿吗？删除后无法恢复。')) return
  const classId = detail.value.classId
  void runAction(async () => {
    await assignmentStore.remove(detail.value!.id)
    await router.push(`/classes/${classId}`)
  }, '草稿已删除')
}

const problemHref = (problemId: number): string =>
  `/problem/${problemId}?assignment_id=${assignmentId.value}`

onMounted(load)
watch(assignmentId, load)
</script>

<template>
  <NavBar />
  <main class="teaching-page page-shell">
    <p v-if="assignmentStore.isLoading" class="empty-state"><span>正在加载作业…</span></p>
    <div v-else-if="assignmentStore.error" class="empty-state">
      <p>{{ assignmentStore.error }}</p>
      <RouterLink class="primary-button" to="/classes">返回班级</RouterLink>
    </div>

    <template v-else-if="detail">
      <header class="teaching-page-header">
        <div>
          <p class="teaching-breadcrumb">
            <RouterLink to="/classes">班级</RouterLink><span>/</span>
            <RouterLink :to="`/classes/${detail.classId}`">{{ detail.className }}</RouterLink><span>/</span>
            <span>{{ detail.title }}</span>
          </p>
          <h1>{{ detail.title }}</h1>
          <p class="teaching-subtle">
            <span :class="['teaching-badge', detail.status]">{{ assignmentStatusLabel(detail.status) }}</span>
            <span v-if="detail.startAt">开始 {{ formatDateTime(detail.startAt) }}</span>
            <span v-if="detail.dueAt">截止 {{ formatDateTime(detail.dueAt) }}</span>
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
            v-if="isDraft"
            class="primary-button"
            type="button"
            :disabled="isWorking"
            @click="publish"
          >
            发布
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
      <p v-if="actionMessage" class="teaching-success" role="status">{{ actionMessage }}</p>

      <section class="teaching-panel">
        <MarkdownBody v-if="detail.description" :content="detail.description" />
        <p v-else class="teaching-subtle">没有描述。</p>
      </section>

      <section v-if="detail.isOwner" class="teaching-stats">
        <article><strong>{{ detail.studentCount ?? 0 }}</strong><span>学生</span></article>
        <article><strong>{{ detail.submittedStudentCount ?? 0 }}</strong><span>已提交</span></article>
        <article><strong>{{ detail.problems.length }}</strong><span>题目</span></article>
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
                <span>{{ problem.attempts }} 次提交</span>
                <span v-if="canShowScores" class="teaching-score">
                  {{ gradeSummary(problem.finalScore, problem.points) }}
                </span>
                <span v-if="problem.feedback" class="teaching-feedback">{{ problem.feedback }}</span>
              </template>
            </div>
          </article>
          <p v-if="!detail.problems.length" class="empty-state"><span>还没有题目。</span></p>
        </div>
      </section>

      <section v-if="!detail.isOwner" class="teaching-panel">
        <p v-if="isArchived" class="teaching-subtle">作业已归档，不能提交。</p>
        <p v-else-if="isClosed" class="teaching-subtle">已截止，不能提交。</p>
        <p v-else-if="!detail.canSubmit" class="teaching-subtle">当前不能提交。</p>
        <p v-else class="teaching-subtle">点击题目进入作答。</p>
        <div v-if="canShowScores && detail.overallFeedback" class="teaching-overall-feedback">
          <span>整体评语</span>
          <p>{{ detail.overallFeedback }}</p>
        </div>
      </section>
    </template>
  </main>
</template>
