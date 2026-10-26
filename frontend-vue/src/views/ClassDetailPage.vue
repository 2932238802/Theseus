<script setup lang="ts">
import { computed, onMounted, ref, watch } from 'vue'
import { useRoute, useRouter } from 'vue-router'
import NavBar from '../components/NavBar.vue'
import { toErrorMessage } from '../api/client'
import { useClassStore } from '../store/classes'
import type { AssignmentSummary } from '../types/teaching'
import {
  assignmentStatusLabel,
  formatDateTime,
  isPast,
} from '../utils/teaching'

const route = useRoute()
const router = useRouter()
const classStore = useClassStore()
const classId = computed(() => Number(route.params.id))
const detail = computed(() => classStore.current)
const isOwner = computed(() => detail.value?.relation === 'owner')
const isArchived = computed(() => Boolean(detail.value?.archivedAt))

const actionError = ref('')
const actionMessage = ref('')
const inviteCode = ref('')
const memberIdentifier = ref('')
const isAddingMember = ref(false)
const removingUserId = ref<number | null>(null)
const isRotating = ref(false)
const isArchiving = ref(false)
const isLeaving = ref(false)

const classMeta = computed(() =>
  [detail.value?.courseName, detail.value?.term].filter(Boolean).join(' · '),
)
const activeMembers = computed(() =>
  (detail.value?.members ?? []).filter((member) => member.status === 'active'),
)
const removedMembers = computed(() =>
  (detail.value?.members ?? []).filter((member) => member.status === 'removed'),
)

const assignmentMeta = (assignment: AssignmentSummary): string => {
  const parts = [`${assignment.problemCount} 题`, `${assignment.totalPoints} 分`]
  if (assignment.dueAt) parts.push(`截止 ${formatDateTime(assignment.dueAt)}`)
  return parts.join(' · ')
}

const assignmentProgress = (assignment: AssignmentSummary): string => {
  if (isOwner.value) {
    return assignment.submittedStudentCount === undefined
      ? ''
      : `${assignment.submittedStudentCount} / ${assignment.studentCount ?? 0} 人已提交`
  }
  return `完成 ${assignment.myAcceptedCount} / ${assignment.problemCount}`
}

const clearActionState = (): void => {
  actionError.value = ''
  actionMessage.value = ''
}

const copyInviteCode = async (): Promise<void> => {
  if (!inviteCode.value) return
  clearActionState()
  try {
    await navigator.clipboard.writeText(inviteCode.value)
    actionMessage.value = '邀请码已复制'
  } catch {
    actionError.value = '复制失败 请手动选择邀请码'
  }
}

const rotateCode = async (): Promise<void> => {
  if (!detail.value || isRotating.value) return
  clearActionState()
  isRotating.value = true
  try {
    inviteCode.value = await classStore.rotateCode(detail.value.id)
    actionMessage.value = '邀请码已更新'
  } catch (exception: unknown) {
    actionError.value = toErrorMessage(exception)
  } finally {
    isRotating.value = false
  }
}

const addMember = async (): Promise<void> => {
  if (!detail.value || !memberIdentifier.value.trim() || isAddingMember.value) return
  clearActionState()
  isAddingMember.value = true
  try {
    await classStore.addMember(detail.value.id, memberIdentifier.value.trim())
    memberIdentifier.value = ''
    inviteCode.value = detail.value.inviteCode ?? inviteCode.value
  } catch (exception: unknown) {
    actionError.value = toErrorMessage(exception)
  } finally {
    isAddingMember.value = false
  }
}

const removeMember = async (userId: number, username: string): Promise<void> => {
  if (!detail.value) return
  if (!window.confirm(`确定将「${username}」移出班级吗？`)) return
  clearActionState()
  removingUserId.value = userId
  try {
    await classStore.removeMember(detail.value.id, userId)
  } catch (exception: unknown) {
    actionError.value = toErrorMessage(exception)
  } finally {
    removingUserId.value = null
  }
}

const archiveClass = async (): Promise<void> => {
  if (!detail.value) return
  if (!window.confirm('归档后不能再加入或发布作业 确定归档吗？')) return
  clearActionState()
  isArchiving.value = true
  try {
    await classStore.archive(detail.value.id)
    actionMessage.value = '班级已归档'
  } catch (exception: unknown) {
    actionError.value = toErrorMessage(exception)
  } finally {
    isArchiving.value = false
  }
}

const leaveClass = async (): Promise<void> => {
  if (!detail.value) return
  if (!window.confirm('确定退出该班级吗？')) return
  clearActionState()
  isLeaving.value = true
  try {
    await classStore.leave(detail.value.id)
    await router.push('/classes')
  } catch (exception: unknown) {
    actionError.value = toErrorMessage(exception)
  } finally {
    isLeaving.value = false
  }
}

const load = async (): Promise<void> => {
  if (!Number.isInteger(classId.value) || classId.value <= 0) return
  clearActionState()
  await classStore.loadClass(classId.value)
  inviteCode.value = classStore.current?.inviteCode ?? ''
}
onMounted(load)
watch(classId, load)
</script>

<template>
  <NavBar />
  <main class="teaching-page page-shell">
    <p v-if="classStore.isDetailLoading" class="empty-state"><span>正在加载班级</span></p>
    <div v-else-if="classStore.detailError" class="empty-state">
      <p>{{ classStore.detailError }}</p>
      <RouterLink class="primary-button" to="/classes">返回班级</RouterLink>
    </div>

    <template v-else-if="detail">
      <header class="teaching-page-header">
        <div>
          <p class="teaching-breadcrumb"><RouterLink to="/classes">班级</RouterLink><span>/</span><span>{{ detail.name }}</span></p>
          <h1>{{ detail.name }}</h1>
          <p v-if="classMeta" class="teaching-subtle">{{ classMeta }}</p>
        </div>
        <div class="teaching-header-actions">
          <RouterLink
            v-if="isOwner && !isArchived"
            class="primary-button"
            :to="`/classes/${detail.id}/assignments/new`"
          >
            创建作业
          </RouterLink>
          <button
            v-if="isOwner && !isArchived"
            class="teaching-secondary-button"
            type="button"
            :disabled="isArchiving"
            @click="archiveClass"
          >
            {{ isArchiving ? '归档中' : '归档班级' }}
          </button>
          <button
            v-if="detail.relation === 'student'"
            class="teaching-secondary-button danger"
            type="button"
            :disabled="isLeaving"
            @click="leaveClass"
          >
            {{ isLeaving ? '退出中' : '退出班级' }}
          </button>
        </div>
      </header>

      <p v-if="detail.archivedAt" class="teaching-badge">已归档于 {{ formatDateTime(detail.archivedAt) }}</p>
      <p v-if="detail.description" class="teaching-description">{{ detail.description }}</p>
      <p v-if="actionError" class="form-error" role="alert">{{ actionError }}</p>
      <p v-if="actionMessage" class="teaching-success" role="status">{{ actionMessage }}</p>

      <section v-if="isOwner" class="teaching-panel">
        <div class="section-heading"><h2>邀请码</h2></div>
        <div class="teaching-invite">
          <code>{{ inviteCode || '—' }}</code>
          <button type="button" :disabled="!inviteCode" @click="copyInviteCode">复制</button>
          <button type="button" :disabled="!inviteCode || isRotating || isArchived" @click="rotateCode">
            {{ isRotating ? '更新中' : '轮换' }}
          </button>
        </div>
      </section>

      <section v-if="isOwner" class="teaching-panel">
        <div class="section-heading"><h2>成员</h2><span class="teaching-subtle">{{ activeMembers.length }} 人</span></div>
        <form class="teaching-inline-form" @submit.prevent="addMember">
          <label>
            <span>用户名或邮箱</span>
            <input v-model="memberIdentifier" :disabled="isArchived" required />
          </label>
          <button class="primary-button" type="submit" :disabled="isArchived || isAddingMember || !memberIdentifier.trim()">
            {{ isAddingMember ? '添加中' : '添加成员' }}
          </button>
        </form>
        <div v-if="activeMembers.length" class="teaching-member-list">
          <article v-for="member in activeMembers" :key="member.userId">
            <div><strong>{{ member.username }}</strong><span>{{ member.email }}</span></div>
            <time>加入于 {{ formatDateTime(member.joinedAt) }}</time>
            <button
              type="button"
              class="danger"
              :disabled="isArchived || removingUserId === member.userId"
              @click="removeMember(member.userId, member.username)"
            >
              {{ removingUserId === member.userId ? '移除中' : '移除' }}
            </button>
          </article>
        </div>
        <p v-else class="empty-state"><span>还没有成员</span></p>

        <details v-if="removedMembers.length" class="teaching-removed">
          <summary>已移除成员 {{ removedMembers.length }} 人</summary>
          <div class="teaching-member-list">
            <article v-for="member in removedMembers" :key="member.userId">
              <div><strong>{{ member.username }}</strong><span>{{ member.email }}</span></div>
              <time>移除于 {{ formatDateTime(member.removedAt) }}</time>
            </article>
          </div>
        </details>
      </section>

      <section class="teaching-section">
        <div class="section-heading"><h2>作业</h2></div>
        <div v-if="detail.assignments.length" class="teaching-card-list">
          <RouterLink
            v-for="assignment in detail.assignments"
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
              <span>{{ assignmentProgress(assignment) }}</span>
              <span v-if="assignment.gradesPublishedAt">成绩已发布</span>
              <span v-else-if="assignment.status === 'published' && isPast(assignment.dueAt)">待发布成绩</span>
            </footer>
          </RouterLink>
        </div>
        <p v-else class="empty-state"><span>还没有作业</span></p>
      </section>
    </template>
  </main>
</template>
