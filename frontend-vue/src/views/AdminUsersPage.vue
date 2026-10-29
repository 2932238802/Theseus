<script setup lang="ts">
import { computed, onMounted, ref } from 'vue'
import NavBar from '../components/NavBar.vue'
import { toErrorMessage } from '../api/client'
import { toast } from '../store/toast'
import { changeUserRole, changeUserStatus, deleteAdminUser, fetchAdminUsers, restoreUserReputation } from '../api/adminUsers'
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
  banned: '已封禁',
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
const actionError = ref('')
const busyUserId = ref<number | null>(null)

const demoteTarget = ref<{ user: AdminUser; nextRole: Role } | null>(null)
const archiveOwnedClasses = ref(false)
const demoteError = ref('')
const demoteSubmitting = ref(false)

const restoreTarget = ref<AdminUser | null>(null)
const restoreScore = ref(50)
const restoreNote = ref('')
const restoreError = ref('')
const restoreSubmitting = ref(false)

let listSequence = 0

const pageCount = computed(() => Math.max(1, Math.ceil(total.value / PAGE_SIZE)))
const isSelf = (user: AdminUser): boolean => user.id === authStore.user?.id
const reputationClass = (score: number): string =>
  score < 40 ? 'is-low' : score <= 70 ? 'is-warn' : ''

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
  return archivedCount > 0 ? `${base} 已归档 ${archivedCount} 个组织` : base
}

const applyRole = async (user: AdminUser, role: Role, archive: boolean): Promise<void> => {
  busyUserId.value = user.id
  actionError.value = ''
  try {
    const result = await changeUserRole(user.id, {
      role,
      archiveOwnedClasses: archive,
    })
    toast.success(successMessage(result.message, result.archivedClassCount))
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
  if (nextRole === user.role || busyUserId.value !== null) return

  if (user.role === 'student' && user.activeMembershipCount > 0) {
    actionError.value = `该学生仍有 ${user.activeMembershipCount} 个组织 请先退出组织`
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
  try {
    const result = await changeUserStatus(user.id, nextStatus)
    toast.success(result.message)
  } catch (exception: unknown) {
    actionError.value = toErrorMessage(exception)
  } finally {
    busyUserId.value = null
    await load()
  }
}

const openRestore = (user: AdminUser): void => {
  if (busyUserId.value !== null || isSelf(user) || user.status === 'deleted') return
  restoreTarget.value = user
  restoreScore.value =
    user.status === 'banned'
      ? 50
      : Math.min(100, Math.round((user.reputationScore + 25) * 10) / 10)
  restoreNote.value = ''
  restoreError.value = ''
}

const closeRestore = (): void => {
  if (restoreSubmitting.value) return
  restoreTarget.value = null
}

const confirmRestore = async (): Promise<void> => {
  const target = restoreTarget.value
  if (!target || restoreSubmitting.value) return
  const score = Number(restoreScore.value)
  if (!Number.isFinite(score) || score <= target.reputationScore) {
    restoreError.value = '恢复后的信誉分需高于当前分数'
    return
  }
  if (score > 100) {
    restoreError.value = '信誉分不能超过 100'
    return
  }
  if (target.status === 'banned' && score <= 0) {
    restoreError.value = '解除封禁需要恢复到 0 分以上'
    return
  }

  restoreSubmitting.value = true
  restoreError.value = ''
  actionError.value = ''
  try {
    const result = await restoreUserReputation(
      target.id,
      score,
      restoreNote.value.trim() || undefined,
    )
    toast.success(result.message)
    restoreTarget.value = null
  } catch (exception: unknown) {
    restoreError.value = toErrorMessage(exception)
  } finally {
    restoreSubmitting.value = false
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
  try {
    const result = await deleteAdminUser(user.id)
    toast.success(result.message)
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
    toast.success(successMessage(result.message, result.archivedClassCount))
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
              <th>信誉分</th>
              <th>组织</th>
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
              <td>
                <span :class="['reputation-score', reputationClass(user.reputationScore)]">
                  {{ user.reputationScore.toFixed(1) }}
                </span>
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
                    :disabled="isSelf(user) || busyUserId === user.id || user.status === 'deleted' || user.status === 'banned'"
                    :title="isSelf(user) ? '不能修改自己的角色' : user.status === 'deleted' ? '账号已删除' : user.status === 'banned' ? '请先恢复信誉分' : ''"
                    @change="requestRole(user, $event)"
                  >
                    <option v-for="role in ROLE_OPTIONS" :key="role" :value="role">
                      {{ ROLE_LABELS[role] }}
                    </option>
                  </select>
                  <button
                    v-if="user.status === 'active' || user.status === 'disabled'"
                    type="button"
                    class="forum-secondary-button"
                    :disabled="isSelf(user) || busyUserId === user.id"
                    @click="toggleStatus(user)"
                  >
                    {{ user.status === 'disabled' ? '恢复' : '禁用' }}
                  </button>
                  <button
                    v-if="user.status !== 'deleted' && !isSelf(user)"
                    type="button"
                    :class="user.status === 'banned' ? 'primary-button' : 'forum-secondary-button'"
                    :disabled="busyUserId === user.id || (user.status !== 'banned' && user.reputationScore >= 100)"
                    @click="openRestore(user)"
                  >
                    {{ user.status === 'banned' ? '解除封禁' : '恢复信誉' }}
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
          <p>该教师仍有 {{ demoteTarget.user.ownedActiveClassCount }} 个未归档组织</p>
        </div>
        <button type="button" aria-label="关闭" @click="closeDemote">×</button>
      </header>
      <div class="run-dialog-body">
        <p class="teaching-subtle">变更为{{ ROLE_LABELS[demoteTarget.nextRole] }}会先归档这些组织</p>
        <label class="teaching-switch">
          <input v-model="archiveOwnedClasses" type="checkbox" />
          <span>归档这些组织后降级</span>
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
  <div v-if="restoreTarget" class="modal-backdrop" @click.self="closeRestore">
    <section class="run-dialog gradebook-dialog" role="dialog" aria-modal="true" aria-labelledby="restore-reputation-title">
      <header>
        <div>
          <h2 id="restore-reputation-title">恢复「{{ restoreTarget.username }}」的信誉分</h2>
          <p>
            当前 {{ restoreTarget.reputationScore.toFixed(1) }} 分
            <template v-if="restoreTarget.status === 'banned'"> · 账号已封禁</template>
          </p>
        </div>
        <button type="button" aria-label="关闭" @click="closeRestore">×</button>
      </header>
      <div class="run-dialog-body">
        <p class="teaching-subtle">
          信誉分只能通过管理员上调；恢复到 0 分以上会同时解除账号与邮箱封禁
        </p>
        <label class="reputation-dialog-field">
          <span>恢复至</span>
          <input v-model.number="restoreScore" type="number" min="0" max="100" step="0.1" />
        </label>
        <label class="reputation-dialog-field">
          <span>恢复原因</span>
          <input v-model="restoreNote" type="text" maxlength="500" placeholder="例如 申诉复核通过（可选）" />
        </label>
        <p v-if="restoreError" class="form-error" role="alert">{{ restoreError }}</p>
        <div class="teaching-form-actions">
          <button class="teaching-secondary-button" type="button" :disabled="restoreSubmitting" @click="closeRestore">
            取消
          </button>
          <button class="primary-button" type="button" :disabled="restoreSubmitting" @click="confirmRestore">
            {{ restoreSubmitting ? '保存中' : '确认恢复' }}
          </button>
        </div>
      </div>
    </section>
  </div>
</template>
