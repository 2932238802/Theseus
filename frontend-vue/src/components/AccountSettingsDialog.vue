<script setup lang="ts">
import { onMounted, ref } from 'vue'
import { useRouter } from 'vue-router'
import { toErrorMessage } from '../api/client'
import { toast } from '../store/toast'
import {
  cancelEmailChange,
  changePassword,
  deleteAccount,
  fetchBadges,
  requestEmailChange,
  setBadgeVisibility,
  updateUsername,
} from '../api/profile'
import { useAuthStore } from '../store/auth'
import type { ProfileBadge } from '../types/profile'

const emit = defineEmits<{ close: [] }>()
const router = useRouter()
const authStore = useAuthStore()

const usernameInput = ref(authStore.user?.username ?? '')
const emailInput = ref('')
const currentPassword = ref('')
const newPassword = ref('')
const confirmPassword = ref('')
const deletePassword = ref('')
const deleteUsername = ref('')
const busy = ref('')
const error = ref('')
const badges = ref<ProfileBadge[]>([])
const badgesLoading = ref(true)
const activeSection = ref<'username' | 'email' | 'password' | 'sessions' | 'badges' | 'danger'>(
  'username',
)
const sections = [
  { key: 'username', label: '用户名' },
  { key: 'email', label: '邮箱' },
  { key: 'password', label: '密码' },
  { key: 'sessions', label: '设备会话' },
  { key: 'badges', label: '徽章展示' },
  { key: 'danger', label: '注销账号' },
] as const

const run = async (key: string, action: () => Promise<void>): Promise<void> => {
  if (busy.value) return
  busy.value = key
  error.value = ''
  try {
    await action()
  } catch (exception: unknown) {
    error.value = toErrorMessage(exception)
  } finally {
    busy.value = ''
  }
}

const saveUsername = (): void => {
  void run('username', async () => {
    const user = await updateUsername(usernameInput.value.trim())
    authStore.updateUser(user)
    toast.success('用户名已更新')
  })
}

const saveEmail = (): void => {
  void run('email', async () => {
    const result = await requestEmailChange(emailInput.value.trim())
    emailInput.value = ''
    await authStore.refreshMe()
    toast.success(result.message)
  })
}

const cancelPendingEmail = (): void => {
  void run('email-cancel', async () => {
    const user = await cancelEmailChange()
    authStore.updateUser(user)
    toast.success('已取消待验证邮箱')
  })
}

const savePassword = (): void => {
  if (newPassword.value !== confirmPassword.value) {
    error.value = '两次输入的新密码不一致'
    return
  }
  void run('password', async () => {
    const result = await changePassword(currentPassword.value, newPassword.value)
    authStore.replaceSession(result.token, result.user)
    currentPassword.value = ''
    newPassword.value = ''
    confirmPassword.value = ''
    toast.success('密码已更新，其他设备已退出')
  })
}

const loadBadges = async (): Promise<void> => {
  badgesLoading.value = true
  try {
    badges.value = await fetchBadges()
  } catch (exception: unknown) {
    error.value = toErrorMessage(exception)
  } finally {
    badgesLoading.value = false
  }
}

const toggleBadge = (badge: ProfileBadge): void => {
  const hidden = !badge.hidden
  void run(`badge-${badge.code}`, async () => {
    const result = await setBadgeVisibility(badge.code, hidden)
    badge.hidden = hidden
    toast.success(result.message)
  })
}

onMounted(() => {
  void loadBadges()
})

const logoutEverywhere = (): void => {
  if (!window.confirm('退出所有设备后，当前浏览器也需要重新登录，确定继续吗？')) return
  void run('logout-all', async () => {
    await authStore.logoutAll()
    await router.push('/login')
  })
}

const removeAccount = (): void => {
  if (!window.confirm('注销后账号立即不可登录，历史提交和成绩会保留但身份匿名化，确定继续吗？')) return
  void run('delete', async () => {
    await deleteAccount(deletePassword.value, deleteUsername.value.trim())
    authStore.logout()
    await router.push('/login')
  })
}
</script>

<template>
  <div class="modal-backdrop" @click.self="emit('close')">
    <section class="run-dialog profile-settings-dialog" role="dialog" aria-modal="true" aria-labelledby="profile-settings-title">
      <header>
        <div>
          <h2 id="profile-settings-title">账号设置</h2>
          <p>{{ authStore.user?.email }}</p>
        </div>
        <button type="button" aria-label="关闭" @click="emit('close')">×</button>
      </header>
      <div class="run-dialog-body">
        <p v-if="error" class="form-error" role="alert">{{ error }}</p>

        <div class="profile-settings-layout">
          <nav class="profile-settings-nav" aria-label="账号设置分类">
            <button
              v-for="section in sections"
              :key="section.key"
              type="button"
              :class="{
                'is-active': activeSection === section.key,
                'is-danger': section.key === 'danger',
              }"
              :aria-current="activeSection === section.key ? 'page' : undefined"
              @click="activeSection = section.key"
            >
              {{ section.label }}
            </button>
          </nav>

          <div class="profile-settings-panel">
            <form v-show="activeSection === 'username'" class="teaching-grade-form" @submit.prevent="saveUsername">
          <h3>用户名</h3>
          <label>
            <span>新用户名</span>
            <input v-model="usernameInput" maxlength="50" required />
          </label>
          <div class="teaching-form-actions">
            <button class="primary-button" type="submit" :disabled="busy === 'username'">
              {{ busy === 'username' ? '保存中' : '保存用户名' }}
            </button>
          </div>
        </form>

        <form v-show="activeSection === 'email'" class="teaching-grade-form" @submit.prevent="saveEmail">
          <h3>邮箱</h3>
          <p class="teaching-subtle">
            当前邮箱：{{ authStore.user?.email }}
            <span v-if="authStore.user?.emailVerified">（已验证）</span>
            <span v-else>（未验证）</span>
          </p>
          <p v-if="authStore.user?.pendingEmail" class="teaching-subtle">
            待验证新邮箱：{{ authStore.user.pendingEmail }}
          </p>
          <label>
            <span>新邮箱</span>
            <input v-model="emailInput" type="email" maxlength="100" required />
          </label>
          <div class="teaching-form-actions">
            <button
              v-if="authStore.user?.pendingEmail"
              class="teaching-secondary-button"
              type="button"
              :disabled="busy === 'email-cancel'"
              @click="cancelPendingEmail"
            >
              取消待验证
            </button>
            <button class="primary-button" type="submit" :disabled="busy === 'email'">
              {{ busy === 'email' ? '发送中' : '发送验证邮件' }}
            </button>
          </div>
        </form>

        <form v-show="activeSection === 'password'" class="teaching-grade-form" @submit.prevent="savePassword">
          <h3>密码</h3>
          <label>
            <span>当前密码</span>
            <input v-model="currentPassword" type="password" autocomplete="current-password" required />
          </label>
          <label>
            <span>新密码</span>
            <input v-model="newPassword" type="password" autocomplete="new-password" minlength="8" maxlength="128" required />
          </label>
          <label>
            <span>确认新密码</span>
            <input v-model="confirmPassword" type="password" autocomplete="new-password" required />
          </label>
          <div class="teaching-form-actions">
            <button class="primary-button" type="submit" :disabled="busy === 'password'">
              {{ busy === 'password' ? '保存中' : '修改密码' }}
            </button>
          </div>
        </form>

        <section v-show="activeSection === 'sessions'" class="teaching-grade-form">
          <h3>设备会话</h3>
          <p class="teaching-subtle">退出所有设备会使当前浏览器也退出登录</p>
          <div class="teaching-form-actions">
            <button class="teaching-secondary-button" type="button" :disabled="busy === 'logout-all'" @click="logoutEverywhere">
              退出所有设备
            </button>
          </div>
        </section>

        <section v-show="activeSection === 'badges'" class="teaching-grade-form">
          <p class="teaching-subtle">
            关闭后，该徽章不会在论坛和排行榜等公开位置展示，个人界面仍会标记为已隐藏
          </p>
          <p v-if="badgesLoading" class="teaching-subtle">加载中</p>
          <p v-else-if="!badges.length" class="teaching-subtle">暂无可用徽章</p>
          <ul v-else class="profile-badge-settings">
            <li
              v-for="badge in badges"
              :key="badge.code"
              :class="{ 'is-locked': !badge.earned }"
            >
              <div>
                <strong>{{ badge.name }}</strong>
                <small v-if="badge.earned">
                  {{ badge.description }} · 有效期至
                  {{ new Date(badge.expiresAt ?? '').toLocaleDateString('zh-CN') }}
                </small>
                <small v-else>{{ badge.description }} · 未获得</small>
              </div>
              <label v-if="badge.earned" class="profile-badge-toggle">
                <input
                  type="checkbox"
                  :checked="!badge.hidden"
                  :disabled="busy === `badge-${badge.code}`"
                  @change="toggleBadge(badge)"
                />
                <span>展示</span>
              </label>
              <span v-else class="profile-badge-locked">未获得</span>
            </li>
          </ul>
        </section>

        <section v-show="activeSection === 'danger'" class="teaching-grade-form profile-danger-zone">
          <h3>注销账号</h3>
          <p class="teaching-subtle">
            注销后账号立即不可登录，用户名和邮箱会匿名化；历史提交、成绩和教学记录保留；
            教师需先归档自己的班级
          </p>
          <label>
            <span>当前密码</span>
            <input v-model="deletePassword" type="password" autocomplete="current-password" />
          </label>
          <label>
            <span>输入用户名确认</span>
            <input v-model="deleteUsername" :placeholder="authStore.user?.username" />
          </label>
          <div class="teaching-form-actions">
            <button class="teaching-secondary-button danger" type="button" :disabled="busy === 'delete'" @click="removeAccount">
              {{ busy === 'delete' ? '注销中' : '注销账号' }}
            </button>
          </div>
        </section>
          </div>
        </div>
      </div>
    </section>
  </div>
</template>
