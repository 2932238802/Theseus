<script setup lang="ts">
import { computed, onMounted, ref } from 'vue'
import NavBar from '../components/NavBar.vue'
import { toErrorMessage } from '../api/client'
import { changeUserRole, changeUserStatus, deleteAdminUser, fetchAdminUsers } from '../api/adminUsers'
import { useAuthStore } from '../store/auth'
import type { AccountStatus, AdminUser, Role } from '../types/teaching'
import { formatDateTime } from '../utils/teaching'

type RoleFilter = Role | ''

const ROLE_LABELS: Record<Role, string> = {
  student: '学生',
  teacher: '教师',
  admin: '管理员',
}
const STATUS_LABELS: Record<AccountStatus, string> = {
  active: '正常',
  disabled: '已禁用',
  deleted: '已删除',
}
const ROLE_OPTIONS: Role[] = ['student', 'teacher', 'admin']
const ROLE_FILTERS: Array<{ value: RoleFilter; label: string }> = [
  { value: '', label: '全部角色' },
  { value: 'student', label: '学生' },
  { value: 'teacher', label: '教师' },
  { value: 'admin', label: '管理员' },
]
const PAGE_SIZE = 20

const authStore = useAuthStore()
const query = ref('')
const roleFilter = ref<RoleFilter>('')
const users = ref<AdminUser[]>([])
const total = ref(0)
const page = ref(1)
const isLoading = ref(false)
const listError = ref('')
const notice = ref('')
const actionError = ref('')
const busyUserId = ref<number | null>(null)

const demoteTarget = ref<{ user: AdminUser; nextRole: Role } | null>(null)
const archiveOwnedClasses = ref(false)
const demoteError = ref('')
const demoteSubmitting = ref(false)

let listSequence = 0

const pageCount = computed(() => Math.max(1, Math.ceil(total.value / PAGE_SIZE)))
const isSelf = (user: AdminUser): boolean => user.id === authStore.user?.id

const load = async (targetPage = page.value): Promise<void> => {
  const sequence = ++listSequence
  isLoading.value = true
  listError.value = ''
  try {
    const result = await fetchAdminUsers({
      q: query.value.trim() || undefined,
      role: roleFilter.value,
      page: targetPage,
      size: PAGE_SIZE,
    })
    if (sequence !== listSequence) return
    if (result.total > 0 && result.users.length === 0 && targetPage > 1) {
      await load(Math.max(1, Math.ceil(result.total / PAGE_SIZE)))
      return
    }
    users.value = result.users
    total.value = result.total
    page.value = result.total > 0 ? result.page : 1
  } catch (exception: unknown) {
    if (sequence !== listSequence) return
    users.value = []
    total.value = 0
    listError.value = toErrorMessage(exception)
  } finally {
    if (sequence === listSequence) isLoading.value = false
  }
}

const search = (): void => {
  notice.value = ''
  actionError.value = ''
  void load(1)
}

const resetFilters = (): void => {
  query.value = ''
  roleFilter.value = ''
  search()
}

const successMessage = (message: string, archivedCount: number): string => {
  const base = message || '角色已更新 立即生效'
  return archivedCount > 0 ? `${base} 已归档 ${archivedCount} 个班级` : base
}

const applyRole = async (user: AdminUser, role: Role, archive: boolean): Promise<void> => {
  busyUserId.value = user.id
  actionError.value = ''
  notice.value = ''
  try {
    const result = await changeUserRole(user.id, {
      role,
      archiveOwnedClasses: archive,
    })
    notice.value = successMessage(result.message, result.archivedClassCount)
  } catch (exception: unknown) {
    actionError.value = toErrorMessage(exception)
  } finally {
    busyUserId.value = null
    await load()
  }
}

const requestRole = (user: AdminUser, event: Event): void => {
  const select = event.target as HTMLSelectElement
  const nextRole = select.value as Role
  select.value = user.role
  actionError.value = ''
  notice.value = ''
  if (nextRole === user.role || busyUserId.value !== null) return

  if (user.role === 'student' && user.activeMembershipCount > 0) {
    actionError.value = `该学生仍有 ${user.activeMembershipCount} 个班级 请先退出班级`
    return
  }

  if (user.role === 'teacher' && user.ownedActiveClassCount > 0) {
    demoteTarget.value = { user, nextRole }
    archiveOwnedClasses.value = false
    demoteError.value = ''
    return
  }

  if (nextRole === 'admin') {
    if (!window.confirm(`确定将「${user.username}」设为管理员吗？`)) return
  } else if (user.role === 'admin') {
    if (!window.confirm(`确定将「${user.username}」降级为${ROLE_LABELS[nextRole]}吗？`)) return
  }

  void applyRole(user, nextRole, false)
}

const toggleStatus = async (user: AdminUser): Promise<void> => {
  if (busyUserId.value !== null || isSelf(user) || user.status === 'deleted') return
  const nextStatus = user.status === 'active' ? 'disabled' : 'active'
  const actionLabel = nextStatus === 'disabled' ? '禁用' : '恢复'
  const hint = nextStatus === 'disabled' ? '禁用后该用户将无法登录' : '恢复后该用户可以重新登录'
  if (!window.confirm(`确定${actionLabel}账号「${user.username}」吗？${hint}`)) return

  busyUserId.value = user.id
  actionError.value = ''
  notice.value = ''
  try {
    const result = await changeUserStatus(user.id, nextStatus)
    notice.value = result.message
  } catch (exception: unknown) {
    actionError.value = toErrorMessage(exception)
  } finally {
    busyUserId.value = null
    await load()
  }
}

const removeUser = async (user: AdminUser): Promise<void> => {
  if (busyUserId.value !== null || isSelf(user) || user.status === 'deleted') return
  if (
    !window.confirm(
      `确定删除账号「${user.username}」吗？删除后该账号将无法登录，用户名与邮箱会被匿名化，此操作不可撤销`,
    )
  ) {
    return
  }

  busyUserId.value = user.id
  actionError.value = ''
  notice.value = ''
  try {
    const result = await deleteAdminUser(user.id)
    notice.value = result.message
  } catch (exception: unknown) {
    actionError.value = toErrorMessage(exception)
  } finally {
    busyUserId.value = null
    await load()
  }
}

const confirmDemote = async (): Promise<void> => {
  if (!demoteTarget.value || !archiveOwnedClasses.value || demoteSubmitting.value) return
  const { user, nextRole } = demoteTarget.value
  demoteError.value = ''
  demoteSubmitting.value = true
  try {
    const result = await changeUserRole(user.id, {
      role: nextRole,
      archiveOwnedClasses: true,
    })
    notice.value = successMessage(result.message, result.archivedClassCount)
    demoteTarget.value = null
  } catch (exception: unknown) {
    demoteError.value = toErrorMessage(exception)
  } finally {
    demoteSubmitting.value = false
    await load()
  }
}

const closeDemote = (): void => {
  if (demoteSubmitting.value) return
  demoteTarget.value = null
}

onMounted(() => {
  void load(1)
})
</script>

<template>
  <NavBar />
  <main class="teaching-page teaching-wide page-shell">
    <header class="teaching-page-header">
      <div>
        <h1>用户管理</h1>
      </div>
    </header>

    <section class="admin-panel">
      <form class="admin-content-filters" @submit.prevent="search">
        <label>
          <span>搜索</span>
          <input v-model="query" placeholder="用户名或邮箱" />
        </label>
        <label>
          <span>角色</span>
          <select v-model="roleFilter" @change="search">
            <option v-for="option in ROLE_FILTERS" :key="option.value" :value="option.value">
              {{ option.label }}
            </option>
          </select>
        </label>
        <button class="primary-button" type="submit" :disabled="isLoading">搜索</button>
        <button class="teaching-secondary-button" type="button" :disabled="isLoading" @click="resetFilters">
          重置
        </button>
        <span class="admin-total">{{ total }} 个用户</span>
      </form>

      <p v-if="actionError" class="form-error" role="alert">{{ actionError }}</p>
      <p v-if="notice" class="teaching-success" role="status">{{ notice }}</p>
      <p v-if="listError" class="form-error" role="alert">{{ listError }}</p>
      <p v-if="isLoading" class="teaching-subtle">正在加载用户</p>

      <div v-else-if="users.length" class="admin-table-scroll">
        <table class="admin-users-table">
          <thead>
            <tr>
              <th>用户名</th>
              <th>邮箱</th>
              <th>角色</th>
              <th>状态</th>
              <th>班级</th>
              <th>注册时间</th>
              <th>操作</th>
            </tr>
          </thead>
          <tbody>
            <tr v-for="user in users" :key="user.id">
              <td>
                <strong>{{ user.username }}</strong>
                <small v-if="isSelf(user)">当前账号</small>
              </td>
              <td>{{ user.email }}</td>
              <td>
                <span :class="['role-badge', user.role]">{{ ROLE_LABELS[user.role] }}</span>
              </td>
              <td>
                <span :class="['teaching-badge', `status-${user.status}`]">{{ STATUS_LABELS[user.status] }}</span>
              </td>
              <td class="admin-user-classes">
                <span v-if="user.role === 'student'">加入 {{ user.activeMembershipCount }}</span>
                <span v-else-if="user.role === 'teacher'">拥有 {{ user.ownedActiveClassCount }}</span>
                <span v-else>—</span>
              </td>
              <td>{{ formatDateTime(user.createdAt) }}</td>
              <td>
                <div class="admin-user-actions">
                  <select
                    :value="user.role"
                    :disabled="isSelf(user) || busyUserId === user.id || user.status === 'deleted'"
                    :title="isSelf(user) ? '不能修改自己的角色' : user.status === 'deleted' ? '账号已删除' : ''"
                    @change="requestRole(user, $event)"
                  >
                    <option v-for="role in ROLE_OPTIONS" :key="role" :value="role">
                      {{ ROLE_LABELS[role] }}
                    </option>
                  </select>
                  <button
                    v-if="user.status !== 'deleted'"
                    type="button"
                    class="forum-secondary-button"
                    :disabled="isSelf(user) || busyUserId === user.id"
                    @click="toggleStatus(user)"
                  >
                    {{ user.status === 'disabled' ? '恢复' : '禁用' }}
                  </button>
                  <button
                    v-if="user.status !== 'deleted'"
                    type="button"
                    class="forum-danger-button"
                    :disabled="isSelf(user) || busyUserId === user.id"
                    @click="removeUser(user)"
                  >
                    删除
                  </button>
                </div>
              </td>
            </tr>
          </tbody>
        </table>
      </div>
      <p v-else-if="!listError" class="empty-state"><span>没有匹配的用户</span></p>

      <div v-if="total > 0" class="pagination">
        <button type="button" :disabled="page <= 1 || isLoading" @click="load(page - 1)">← 上一页</button>
        <span>第 {{ page }} / {{ pageCount }} 页</span>
        <button type="button" :disabled="page >= pageCount || isLoading" @click="load(page + 1)">下一页 →</button>
      </div>
    </section>
  </main>

  <div v-if="demoteTarget" class="modal-backdrop" @click.self="closeDemote">
    <section class="run-dialog gradebook-dialog" role="dialog" aria-modal="true" aria-labelledby="demote-title">
      <header>
        <div>
          <h2 id="demote-title">变更教师「{{ demoteTarget.user.username }}」的角色</h2>
          <p>该教师仍有 {{ demoteTarget.user.ownedActiveClassCount }} 个未归档班级</p>
        </div>
        <button type="button" aria-label="关闭" @click="closeDemote">×</button>
      </header>
      <div class="run-dialog-body">
        <p class="teaching-subtle">变更为{{ ROLE_LABELS[demoteTarget.nextRole] }}会先归档这些班级</p>
        <label class="teaching-switch">
          <input v-model="archiveOwnedClasses" type="checkbox" />
          <span>归档这些班级后降级</span>
        </label>
        <p v-if="demoteError" class="form-error" role="alert">{{ demoteError }}</p>
        <div class="teaching-form-actions">
          <button class="teaching-secondary-button" type="button" :disabled="demoteSubmitting" @click="closeDemote">
            取消
          </button>
          <button
            class="primary-button"
            type="button"
            :disabled="!archiveOwnedClasses || demoteSubmitting"
            @click="confirmDemote"
          >
            {{ demoteSubmitting ? '降级中' : '确认降级' }}
          </button>
        </div>
      </div>
    </section>
  </div>
</template>
