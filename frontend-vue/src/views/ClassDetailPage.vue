<script setup lang="ts">
import { computed, onMounted, reactive, ref, watch } from 'vue'
import { useRoute, useRouter } from 'vue-router'
import MarkdownBody from '../components/MarkdownBody.vue'
import NavBar from '../components/NavBar.vue'
import { toErrorMessage } from '../api/client'
import { toast } from '../store/toast'
import {
  fetchClassInvitations,
  fetchInviteCandidates,
  sendClassInvitations,
} from '../api/invitations'
import { sendNotification } from '../api/notifications'
import { useClassStore } from '../store/classes'
import type {
  AssignmentSummary,
  InviteCandidate,
  OwnerInvitation,
} from '../types/teaching'
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
const inviteCode = ref('')
const removingUserId = ref<number | null>(null)
const isRotating = ref(false)
const isArchiving = ref(false)
const isLeaving = ref(false)

const inviteQuery = ref('')
const inviteCandidates = ref<InviteCandidate[]>([])
const selectedCandidateIds = ref<number[]>([])
const pendingInvitations = ref<OwnerInvitation[]>([])
const invitationsError = ref('')
const isSearchingInvites = ref(false)
const isSendingInvites = ref(false)
const hasSearchedInvites = ref(false)

const notifyForm = reactive({
  audience: 'all' as 'all' | 'selected',
  title: '',
  body: '',
  link: '',
})
const selectedNotifyIds = ref<number[]>([])
const showNotifyPreview = ref(false)
const isSendingNotice = ref(false)
const notifyError = ref('')

let inviteSearchSequence = 0

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
}

const copyInviteCode = async (): Promise<void> => {
  if (!inviteCode.value) return
  clearActionState()
  try {
    await navigator.clipboard.writeText(inviteCode.value)
    toast.success('邀请码已复制')
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
    toast.success('邀请码已更新')
  } catch (exception: unknown) {
    actionError.value = toErrorMessage(exception)
  } finally {
    isRotating.value = false
  }
}

const loadInvitations = async (): Promise<void> => {
  if (!detail.value || !isOwner.value) return
  try {
    pendingInvitations.value = await fetchClassInvitations(detail.value.id)
  } catch (exception: unknown) {
    invitationsError.value = toErrorMessage(exception)
  }
}

const searchCandidates = async (): Promise<void> => {
  if (!detail.value || !inviteQuery.value.trim() || isSearchingInvites.value) return
  const requestId = ++inviteSearchSequence
  invitationsError.value = ''
  isSearchingInvites.value = true
  try {
    const result = await fetchInviteCandidates(detail.value.id, inviteQuery.value.trim())
    if (requestId !== inviteSearchSequence) return
    inviteCandidates.value = result
    hasSearchedInvites.value = true
    selectedCandidateIds.value = selectedCandidateIds.value.filter((id) =>
      result.some((candidate) => candidate.userId === id),
    )
  } catch (exception: unknown) {
    if (requestId !== inviteSearchSequence) return
    inviteCandidates.value = []
    selectedCandidateIds.value = []
    hasSearchedInvites.value = false
    invitationsError.value = toErrorMessage(exception)
  } finally {
    if (requestId === inviteSearchSequence) isSearchingInvites.value = false
  }
}

const toggleCandidate = (candidate: InviteCandidate): void => {
  if (candidate.isMember) return
  const index = selectedCandidateIds.value.indexOf(candidate.userId)
  if (index >= 0) selectedCandidateIds.value.splice(index, 1)
  else selectedCandidateIds.value.push(candidate.userId)
}

const sendInvitations = async (): Promise<void> => {
  if (!detail.value || !selectedCandidateIds.value.length || isSendingInvites.value) return
  invitationsError.value = ''
  isSendingInvites.value = true
  try {
    const result = await sendClassInvitations(detail.value.id, [...selectedCandidateIds.value])
    const successMessage = result.skipped.length
      ? `${result.message}；${result.skipped
          .map((item) => `${item.username}：${item.reason}`)
          .join('，')}`
      : result.message
    selectedCandidateIds.value = []
    await Promise.all([loadInvitations(), classStore.refreshCurrent()])
    if (inviteQuery.value.trim()) await searchCandidates()
    toast.success(successMessage)
  } catch (exception: unknown) {
    invitationsError.value = toErrorMessage(exception)
  } finally {
    isSendingInvites.value = false
  }
}

const toggleNotifyMember = (userId: number): void => {
  const index = selectedNotifyIds.value.indexOf(userId)
  if (index >= 0) selectedNotifyIds.value.splice(index, 1)
  else selectedNotifyIds.value.push(userId)
}

const sendClassNotice = async (): Promise<void> => {
  if (!detail.value || !notifyForm.title.trim() || isSendingNotice.value) return
  notifyError.value = ''
  if (notifyForm.audience === 'selected' && !selectedNotifyIds.value.length) {
    notifyError.value = '请至少选择一位接收学生'
    return
  }
  isSendingNotice.value = true
  try {
    const result = await sendNotification({
      classId: detail.value.id,
      title: notifyForm.title.trim(),
      body: notifyForm.body.trim() || undefined,
      link: notifyForm.link.trim() || undefined,
      userIds:
        notifyForm.audience === 'selected' ? [...selectedNotifyIds.value] : undefined,
    })
    toast.success(result.message)
    notifyForm.title = ''
    notifyForm.body = ''
    notifyForm.link = ''
    selectedNotifyIds.value = []
    showNotifyPreview.value = false
  } catch (exception: unknown) {
    notifyError.value = toErrorMessage(exception)
  } finally {
    isSendingNotice.value = false
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
    toast.success('班级已归档')
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

const resetInvitationState = (): void => {
  inviteSearchSequence += 1
  inviteQuery.value = ''
  inviteCandidates.value = []
  selectedCandidateIds.value = []
  hasSearchedInvites.value = false
  pendingInvitations.value = []
  invitationsError.value = ''
  isSearchingInvites.value = false
  isSendingInvites.value = false
  notifyForm.audience = 'all'
  notifyForm.title = ''
  notifyForm.body = ''
  notifyForm.link = ''
  selectedNotifyIds.value = []
  showNotifyPreview.value = false
  notifyError.value = ''
}

const load = async (): Promise<void> => {
  if (!Number.isInteger(classId.value) || classId.value <= 0) return
  clearActionState()
  resetInvitationState()
  await classStore.loadClass(classId.value)
  inviteCode.value = classStore.current?.inviteCode ?? ''
  await loadInvitations()
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

      <section v-if="isOwner && !isArchived" class="teaching-panel">
        <div class="section-heading">
          <h2>邀请学生</h2>
          <span class="teaching-subtle">学生确认后加入班级</span>
        </div>
        <form class="teaching-inline-form" @submit.prevent="searchCandidates">
          <label>
            <span>搜索学生</span>
            <input
              v-model="inviteQuery"
              maxlength="100"
              placeholder="输入用户名或邮箱"
              required
            />
          </label>
          <button
            class="primary-button"
            type="submit"
            :disabled="isSearchingInvites || !inviteQuery.trim()"
          >
            {{ isSearchingInvites ? '搜索中' : '搜索' }}
          </button>
        </form>

        <p v-if="invitationsError" class="form-error" role="alert">{{ invitationsError }}</p>

        <template v-if="inviteCandidates.length">
          <div class="teaching-candidate-list">
            <label
              v-for="candidate in inviteCandidates"
              :key="candidate.userId"
              :class="['teaching-candidate', { disabled: candidate.isMember }]"
            >
              <input
                type="checkbox"
                :checked="selectedCandidateIds.includes(candidate.userId)"
                :disabled="candidate.isMember"
                @change="toggleCandidate(candidate)"
              />
              <span class="teaching-candidate-main">
                <strong>{{ candidate.username }}</strong>
                <span>{{ candidate.email }}</span>
              </span>
              <span v-if="candidate.isMember" class="teaching-badge">已加入</span>
              <span v-else-if="candidate.hasPendingInvitation" class="teaching-badge draft">已邀请 · 再次发送顺延有效期</span>
            </label>
          </div>
          <div class="teaching-form-actions">
            <button
              class="primary-button"
              type="button"
              :disabled="isSendingInvites || !selectedCandidateIds.length"
              @click="sendInvitations"
            >
              {{ isSendingInvites ? '发送中' : `发送邀请（${selectedCandidateIds.length}）` }}
            </button>
          </div>
        </template>
        <p v-else-if="hasSearchedInvites && !isSearchingInvites" class="empty-state">
          <span>没有找到匹配的学生</span>
        </p>

        <div class="teaching-subsection">
          <h3>待确认邀请 <span class="teaching-subtle">{{ pendingInvitations.length }} 人</span></h3>
          <div v-if="pendingInvitations.length" class="teaching-member-list">
            <article v-for="invitation in pendingInvitations" :key="invitation.id">
              <div>
                <strong>{{ invitation.inviteeUsername }}</strong>
                <span>{{ invitation.inviteeEmail }}</span>
              </div>
              <time>{{ formatDateTime(invitation.expiresAt) }} 到期</time>
            </article>
          </div>
          <p v-else class="teaching-subtle">暂无待确认邀请</p>
        </div>
      </section>

      <section v-if="isOwner && !isArchived" class="teaching-panel">
        <div class="section-heading">
          <h2>给本班学生发通知</h2>
          <span class="teaching-subtle">支持 Markdown</span>
        </div>
        <div class="teaching-audience">
          <label>
            <input v-model="notifyForm.audience" type="radio" value="all" />
            <span>全班学生（{{ activeMembers.length }} 人）</span>
          </label>
          <label>
            <input
              v-model="notifyForm.audience"
              type="radio"
              value="selected"
              :disabled="!activeMembers.length"
            />
            <span>指定学生</span>
          </label>
        </div>

        <div v-if="notifyForm.audience === 'selected'" class="teaching-candidate-list compact">
          <label
            v-for="member in activeMembers"
            :key="member.userId"
            class="teaching-candidate"
          >
            <input
              type="checkbox"
              :checked="selectedNotifyIds.includes(member.userId)"
              @change="toggleNotifyMember(member.userId)"
            />
            <span class="teaching-candidate-main">
              <strong>{{ member.username }}</strong>
              <span>{{ member.email }}</span>
            </span>
          </label>
        </div>

        <form class="teaching-form" @submit.prevent="sendClassNotice">
          <label>
            <span>标题</span>
            <input v-model="notifyForm.title" maxlength="100" required />
          </label>
          <label>
            <span>正文（Markdown）</span>
            <textarea v-model="notifyForm.body" rows="6" maxlength="5000"></textarea>
          </label>
          <label>
            <span>跳转链接（可选，站内路径）</span>
            <input v-model="notifyForm.link" maxlength="500" placeholder="/assignments/12" />
          </label>
          <p v-if="notifyError" class="form-error" role="alert">{{ notifyError }}</p>
          <div class="teaching-form-actions">
            <button
              class="teaching-secondary-button"
              type="button"
              :disabled="!notifyForm.body.trim()"
              @click="showNotifyPreview = !showNotifyPreview"
            >
              {{ showNotifyPreview ? '收起预览' : '预览正文' }}
            </button>
            <button
              class="primary-button"
              type="submit"
              :disabled="isSendingNotice || !notifyForm.title.trim()"
            >
              {{ isSendingNotice ? '发送中' : '发送通知' }}
            </button>
          </div>
        </form>
        <div v-if="showNotifyPreview && notifyForm.body.trim()" class="teaching-preview">
          <MarkdownBody :content="notifyForm.body" />
        </div>
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
