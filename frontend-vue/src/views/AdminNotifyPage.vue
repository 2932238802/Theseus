<script setup lang="ts">
import { computed, onMounted, ref } from 'vue'
import MarkdownBody from '../components/MarkdownBody.vue'
import NavBar from '../components/NavBar.vue'
import { fetchAdminUsers } from '../api/adminUsers'
import { toErrorMessage } from '../api/client'
import { toast } from '../store/toast'
import { sendNotification } from '../api/notifications'
import type { AdminUser, Role } from '../types/teaching'

type AudienceType = 'users' | 'role' | 'all'

const ROLE_LABELS: Record<Role, string> = {
  student: '学生',
  teacher: '教师',
  admin: '管理员',
}
const PAGE_SIZE = 20

const audienceType = ref<AudienceType>('users')
const roleTarget = ref<'student' | 'teacher'>('student')

const userQuery = ref('')
const users = ref<AdminUser[]>([])
const userTotal = ref(0)
const userPage = ref(1)
const isLoadingUsers = ref(false)
const userError = ref('')
const selectedUserIds = ref<number[]>([])
let userSequence = 0

const title = ref('')
const body = ref('')
const link = ref('')
const showPreview = ref(false)
const isSending = ref(false)
const sendError = ref('')

const pageCount = computed(() => Math.max(1, Math.ceil(userTotal.value / PAGE_SIZE)))
const canSend = computed(
  () =>
    Boolean(title.value.trim()) &&
    (audienceType.value !== 'users' || selectedUserIds.value.length > 0),
)

const loadUsers = async (targetPage = 1): Promise<void> => {
  const requestId = ++userSequence
  isLoadingUsers.value = true
  userError.value = ''
  try {
    const result = await fetchAdminUsers({
      q: userQuery.value.trim() || undefined,
      page: targetPage,
      size: PAGE_SIZE,
    })
    if (requestId !== userSequence) return
    users.value = result.users
    userTotal.value = result.total
    userPage.value = result.page
  } catch (exception: unknown) {
    if (requestId !== userSequence) return
    users.value = []
    userTotal.value = 0
    userError.value = toErrorMessage(exception)
  } finally {
    if (requestId === userSequence) isLoadingUsers.value = false
  }
}

const searchUsers = (): void => {
  sendError.value = ''
  void loadUsers(1)
}

const selectable = (user: AdminUser): boolean => user.role !== 'admin'

const toggleUser = (user: AdminUser): void => {
  if (!selectable(user)) return
  const index = selectedUserIds.value.indexOf(user.id)
  if (index >= 0) selectedUserIds.value.splice(index, 1)
  else selectedUserIds.value.push(user.id)
}

const audienceSummary = computed(() => {
  if (audienceType.value === 'users') {
    return selectedUserIds.value.length
      ? `已选择 ${selectedUserIds.value.length} 位用户`
      : '请选择接收用户'
  }
  if (audienceType.value === 'role') {
    return `所有${ROLE_LABELS[roleTarget.value]}`
  }
  return '全站所有用户（不含自己）'
})

const send = async (): Promise<void> => {
  if (!canSend.value || isSending.value) return
  sendError.value = ''
  if (audienceType.value !== 'users') {
    if (!window.confirm(`确定向${audienceSummary.value}发送通知吗？发送后不可撤回`)) return
  }
  isSending.value = true
  try {
    const result = await sendNotification({
      title: title.value.trim(),
      body: body.value.trim() || undefined,
      link: link.value.trim() || undefined,
      userIds: audienceType.value === 'users' ? [...selectedUserIds.value] : undefined,
      role: audienceType.value === 'role' ? roleTarget.value : undefined,
      all: audienceType.value === 'all' ? true : undefined,
    })
    toast.success(result.message)
    title.value = ''
    body.value = ''
    link.value = ''
    selectedUserIds.value = []
    showPreview.value = false
  } catch (exception: unknown) {
    sendError.value = toErrorMessage(exception)
  } finally {
    isSending.value = false
  }
}

onMounted(() => {
  void loadUsers(1)
})
</script>

<template>
  <NavBar />
  <main class="teaching-page teaching-wide page-shell">

    <div class="admin-notify-layout">
      <section class="admin-panel">
        <div class="section-heading"><h2>接收范围</h2></div>

        <div class="admin-notify-audience" role="radiogroup" aria-label="接收范围">
          <label :class="['admin-notify-option', { active: audienceType === 'users' }]">
            <input v-model="audienceType" type="radio" value="users" />
            <strong>指定用户</strong>
            <span>搜索并勾选学生或教师</span>
          </label>
          <label :class="['admin-notify-option', { active: audienceType === 'role' }]">
            <input v-model="audienceType" type="radio" value="role" />
            <strong>按角色</strong>
            <span>所有学生或所有教师</span>
          </label>
          <label :class="['admin-notify-option', { active: audienceType === 'all' }]">
            <input v-model="audienceType" type="radio" value="all" />
            <strong>全站</strong>
            <span>除自己外的所有用户</span>
          </label>
        </div>

        <template v-if="audienceType === 'users'">
          <form class="admin-content-filters" @submit.prevent="searchUsers">
            <label>
              <span>搜索</span>
              <input v-model="userQuery" placeholder="用户名或邮箱" />
            </label>
            <button class="primary-button" type="submit" :disabled="isLoadingUsers">搜索</button>
            <span class="admin-total">{{ userTotal }} 个用户</span>
          </form>

          <p class="teaching-subtle">已选择 {{ selectedUserIds.length }} 人 · 管理员账号不可选</p>
          <p v-if="userError" class="form-error" role="alert">{{ userError }}</p>

          <div v-if="isLoadingUsers" class="teaching-subtle">正在加载用户</div>
          <div v-else-if="users.length" class="admin-table-scroll admin-notify-user-scroll">
            <table class="admin-users-table admin-notify-user-table">
              <thead>
                <tr>
                  <th class="admin-notify-check-cell"></th>
                  <th>用户名</th>
                  <th>邮箱</th>
                  <th>角色</th>
                </tr>
              </thead>
              <tbody>
                <tr v-for="user in users" :key="user.id" :class="{ disabled: !selectable(user) }">
                  <td class="admin-notify-check-cell">
                    <input
                      type="checkbox"
                      :checked="selectedUserIds.includes(user.id)"
                      :disabled="!selectable(user)"
                      @change="toggleUser(user)"
                    />
                  </td>
                  <td><strong>{{ user.username }}</strong></td>
                  <td>{{ user.email }}</td>
                  <td>
                    <span :class="['role-badge', user.role]">{{ ROLE_LABELS[user.role] }}</span>
                  </td>
                </tr>
              </tbody>
            </table>
          </div>
          <p v-else-if="!userError" class="empty-state"><span>没有匹配的用户</span></p>

          <div v-if="userTotal > 0" class="pagination">
            <button type="button" :disabled="userPage <= 1 || isLoadingUsers" @click="loadUsers(userPage - 1)">
              ← 上一页
            </button>
            <span>第 {{ userPage }} / {{ pageCount }} 页</span>
            <button
              type="button"
              :disabled="userPage >= pageCount || isLoadingUsers"
              @click="loadUsers(userPage + 1)"
            >
              下一页 →
            </button>
          </div>
        </template>

        <div v-else-if="audienceType === 'role'" class="admin-notify-role">
          <label>
            <span>发送给</span>
            <select v-model="roleTarget">
              <option value="student">所有学生</option>
              <option value="teacher">所有教师</option>
            </select>
          </label>
        </div>

        <p v-else class="teaching-subtle">
          通知将发送给全站除当前管理员外的所有用户，该操作影响范围较大，请谨慎使用
        </p>
      </section>

      <section class="admin-panel">
        <div class="section-heading">
          <h2>通知内容</h2>
          <span class="teaching-subtle">{{ audienceSummary }}</span>
        </div>

        <form class="teaching-form" @submit.prevent="send">
          <label>
            <span>标题（最多 100 字）</span>
            <input v-model="title" maxlength="100" required />
          </label>
          <label>
            <span>正文（支持 Markdown，最多 5000 字）</span>
            <textarea v-model="body" rows="10" maxlength="5000"></textarea>
          </label>
          <label>
            <span>跳转链接（可选，站内路径）</span>
            <input v-model="link" maxlength="500" placeholder="/assignments/12" />
          </label>

          <p v-if="sendError" class="form-error" role="alert">{{ sendError }}</p>

          <div class="teaching-form-actions">
            <button
              class="teaching-secondary-button"
              type="button"
              :disabled="!body.trim()"
              @click="showPreview = !showPreview"
            >
              {{ showPreview ? '收起预览' : '预览正文' }}
            </button>
            <button class="primary-button" type="submit" :disabled="!canSend || isSending">
              {{ isSending ? '发送中' : '发送通知' }}
            </button>
          </div>
        </form>

        <div v-if="showPreview && body.trim()" class="teaching-preview">
          <MarkdownBody :content="body" />
        </div>
      </section>
    </div>
  </main>
</template>
