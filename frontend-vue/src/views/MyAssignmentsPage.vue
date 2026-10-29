<script setup lang="ts">
import { computed, onMounted, ref } from 'vue'
import NavBar from '../components/NavBar.vue'
import { fetchClassAssignments } from '../api/assignments'
import { useAuthStore } from '../store/auth'
import { useClassStore } from '../store/classes'
import type { AssignmentSummary, ClassRelation, ClassSummary } from '../types/teaching'
import { assignmentStatusLabel, formatDateTime, isPast } from '../utils/teaching'

interface AssignmentGroup {
  classInfo: ClassSummary
  assignments: AssignmentSummary[]
  failed: boolean
}

const authStore = useAuthStore()
const classStore = useClassStore()

const groups = ref<AssignmentGroup[]>([])
const loading = ref(true)
const error = ref('')

const totalAssignments = computed(() =>
  groups.value.reduce((total, group) => total + group.assignments.length, 0),
)

const pendingCount = computed(() => {
  if (!authStore.isStudent) return 0
  return groups.value.reduce(
    (total, group) =>
      total +
      group.assignments.filter(
        (assignment) =>
          assignment.status === 'published' &&
          assignment.myAcceptedCount < assignment.problemCount &&
          !isPast(assignment.dueAt),
      ).length,
    0,
  )
})

const activeCount = computed(() =>
  groups.value.reduce(
    (total, group) =>
      total +
      group.assignments.filter(
        (assignment) => assignment.status === 'published' && !isPast(assignment.dueAt),
      ).length,
    0,
  ),
)

const highlight = computed(() =>
  authStore.isStudent
    ? { label: '待完成', value: pendingCount.value }
    : { label: '进行中', value: activeCount.value },
)

const assignmentMeta = (assignment: AssignmentSummary): string => {
  const parts = [`${assignment.problemCount} 题`, `${assignment.totalPoints} 分`]
  if (assignment.dueAt) parts.push(`截止 ${formatDateTime(assignment.dueAt)}`)
  return parts.join(' · ')
}

const assignmentProgress = (assignment: AssignmentSummary, relation: ClassRelation): string => {
  if (relation === 'owner') {
    return assignment.submittedStudentCount === undefined
      ? ''
      : `${assignment.submittedStudentCount} / ${assignment.studentCount ?? 0} 人已提交`
  }
  return `完成 ${assignment.myAcceptedCount} / ${assignment.problemCount}`
}

const load = async (): Promise<void> => {
  loading.value = true
  error.value = ''
  const userId = authStore.user?.id
  if (!userId) {
    groups.value = []
    loading.value = false
    return
  }
  await classStore.ensureLoadedFor(userId)
  if (classStore.loadedForUserId !== userId) {
    error.value = classStore.error || '组织列表加载失败，请稍后重试'
    groups.value = []
    loading.value = false
    return
  }
  const classes = [...classStore.classes].sort(
    (left, right) => Number(Boolean(left.archivedAt)) - Number(Boolean(right.archivedAt)),
  )
  const results = await Promise.allSettled(
    classes.map((classInfo) => fetchClassAssignments(classInfo.id)),
  )
  groups.value = classes.map((classInfo, index) => {
    const result = results[index]
    if (result && result.status === 'fulfilled') {
      return { classInfo, assignments: result.value, failed: false }
    }
    return { classInfo, assignments: [], failed: true }
  })
  const failed = groups.value.filter((group) => group.failed).length
  if (failed) error.value = `${failed} 个组织的作业加载失败，可点击刷新重试`
  loading.value = false
}

onMounted(() => {
  void load()
})
</script>

<template>
  <NavBar />
  <main class="teaching-page page-shell">
    <header class="teaching-page-header">
      <div>
        <h1>我的作业</h1>
      </div>
      <div class="teaching-header-actions">
        <button
          class="teaching-secondary-button"
          type="button"
          :disabled="loading"
          @click="load"
        >
          {{ loading ? '刷新中' : '刷新' }}
        </button>
      </div>
    </header>

    <p v-if="error" class="form-error" role="alert">{{ error }}</p>

    <div v-if="loading" class="teaching-empty-block is-centered">
      <p>正在加载作业</p>
    </div>
    <div v-else-if="!classStore.classes.length" class="teaching-empty-block is-centered">
      <span class="teaching-empty-icon" aria-hidden="true">
        <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.6">
          <path d="M4 20.5V6.5l8-3 8 3v14" stroke-linejoin="round" />
          <path d="M9 20.5v-5h6v5" stroke-linejoin="round" />
          <path d="M8 9h1.5M14.5 9H16M8 12h1.5M14.5 12H16" stroke-linecap="round" />
        </svg>
      </span>
      <div>
        <strong>{{ authStore.isTeacher ? '还没有组织' : '还没有加入组织' }}</strong>
        <p>
          {{ authStore.isTeacher ? '创建组织后即可布置和查看作业' : '加入组织后才能看到老师布置的作业' }}
        </p>
      </div>
      <RouterLink class="primary-button" to="/classes">去我的组织 <span>→</span></RouterLink>
    </div>
    <template v-else>
      <div class="teaching-stat-strip">
        <div class="teaching-stat">
          <span>参与组织</span>
          <strong>{{ groups.length }}<small>个</small></strong>
        </div>
        <div class="teaching-stat">
          <span>可见作业</span>
          <strong>{{ totalAssignments }}<small>份</small></strong>
        </div>
        <div class="teaching-stat">
          <span>{{ highlight.label }}</span>
          <strong>{{ highlight.value }}<small>份</small></strong>
        </div>
      </div>

      <section
        v-for="group in groups"
        :key="group.classInfo.id"
        class="assignment-group"
      >
        <header class="assignment-group-heading">
          <div class="assignment-group-title">
            <h2>
              <RouterLink :to="`/classes/${group.classInfo.id}`">
                {{ group.classInfo.name }}
              </RouterLink>
            </h2>
            <span v-if="group.classInfo.archivedAt" class="teaching-badge archived">
              已归档
            </span>
          </div>
          <div class="assignment-group-side">
            <span class="teaching-badge">{{ group.assignments.length }} 份作业</span>
            <RouterLink class="inline-link" :to="`/classes/${group.classInfo.id}`">
              查看组织
            </RouterLink>
          </div>
        </header>
        <p v-if="group.failed" class="form-error" role="alert">该组织的作业加载失败</p>
        <div v-else-if="group.assignments.length" class="teaching-card-list">
          <RouterLink
            v-for="assignment in group.assignments"
            :key="assignment.id"
            class="teaching-card"
            :to="`/assignments/${assignment.id}`"
          >
            <header>
              <h3>{{ assignment.title }}</h3>
              <span :class="['teaching-badge', assignment.status]">{{ assignmentStatusLabel(assignment.status) }}</span>
            </header>
            <p class="teaching-card-meta">{{ assignmentMeta(assignment) }}</p>
            <footer>
              <span>{{ assignmentProgress(assignment, group.classInfo.relation) }}</span>
              <span v-if="assignment.gradesPublishedAt">成绩已发布</span>
              <span v-else-if="assignment.status === 'published' && isPast(assignment.dueAt)">待发布成绩</span>
            </footer>
          </RouterLink>
        </div>
        <div v-else class="teaching-empty-block">
          <span class="teaching-empty-icon" aria-hidden="true">
            <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.6">
              <path d="M7 3.5h8.5L19 7v13.5H7z" stroke-linejoin="round" />
              <path d="M15 3.5V7h4" stroke-linejoin="round" />
              <path d="M10 11h6M10 15h6" stroke-linecap="round" />
            </svg>
          </span>
          <div>
            <strong>还没有作业</strong>
            <p v-if="group.classInfo.relation === 'owner'">
              {{ group.classInfo.archivedAt ? '组织已归档，无法继续创建作业' : '在组织详情页创建作业后会显示在这里' }}
            </p>
            <p v-else>老师布置作业后会显示在这里</p>
          </div>
        </div>
      </section>
    </template>
  </main>
</template>
