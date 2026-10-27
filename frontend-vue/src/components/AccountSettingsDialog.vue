<script setup lang="ts">
import { ref } from 'vue'
import { useRouter } from 'vue-router'
import { toErrorMessage } from '../api/client'
import {
  cancelEmailChange,
  changePassword,
  deleteAccount,
  requestEmailChange,
  updateUsername,
} from '../api/profile'
import { useAuthStore } from '../store/auth'

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
const message = ref('')

const run = async (key: string, action: () => Promise<void>): Promise<void> => {
  if (busy.value) return
  busy.value = key
  error.value = ''
  message.value = ''
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
    message.value = '用户名已更新'
  })
}

const saveEmail = (): void => {
  void run('email', async () => {
    const result = await requestEmailChange(emailInput.value.trim())
    emailInput.value = ''
    await authStore.refreshMe()
    message.value = result.message
  })
}

const cancelPendingEmail = (): void => {
  void run('email-cancel', async () => {
    const user = await cancelEmailChange()
    authStore.updateUser(user)
    message.value = '已取消待验证邮箱'
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
    message.value = '密码已更新，其他设备已退出'
  })
}

const logoutEverywhere = (): void => {
  if (!window.confirm('退出所有设备后，当前浏览器也需要重新登录。确定继续吗？')) return
  void run('logout-all', async () => {
    await authStore.logoutAll()
    await router.push('/login')
  })
}

const removeAccount = (): void => {
  if (!window.confirm('注销后账号立即不可登录，历史提交和成绩会保留但身份匿名化。确定继续吗？')) return
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
        <p v-if="message" class="teaching-success" role="status">{{ message }}</p>

        <form class="teaching-grade-form" @submit.prevent="saveUsername">
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

        <form class="teaching-grade-form" @submit.prevent="saveEmail">
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

        <form class="teaching-grade-form" @submit.prevent="savePassword">
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

        <section class="teaching-grade-form">
          <h3>设备会话</h3>
          <p class="teaching-subtle">退出所有设备会使当前浏览器也退出登录。</p>
          <div class="teaching-form-actions">
            <button class="teaching-secondary-button" type="button" :disabled="busy === 'logout-all'" @click="logoutEverywhere">
              退出所有设备
            </button>
          </div>
        </section>

        <section class="teaching-grade-form profile-danger-zone">
          <h3>注销账号</h3>
          <p class="teaching-subtle">
            注销后账号立即不可登录，用户名和邮箱会匿名化；历史提交、成绩和教学记录保留。
            教师需先归档自己的班级。
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
    </section>
  </div>
</template>
