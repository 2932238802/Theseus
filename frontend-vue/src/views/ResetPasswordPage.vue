<script setup lang="ts">
import { computed, ref } from 'vue'
import { useRoute, useRouter } from 'vue-router'
import { resetPassword } from '../api/auth'
import { toErrorMessage } from '../api/client'
import { useAuthStore } from '../store/auth'

const route = useRoute()
const router = useRouter()
const authStore = useAuthStore()
const token = computed(() => (typeof route.query.token === 'string' ? route.query.token.trim() : ''))
const password = ref('')
const confirmPassword = ref('')
const showPassword = ref(false)
const submitting = ref(false)
const error = ref('')
const message = ref('')

const submit = async (): Promise<void> => {
  error.value = ''
  message.value = ''
  if (!token.value) {
    error.value = '重置链接缺少令牌'
    return
  }
  if (!/^(?=.*[A-Za-z])(?=.*\d).{8,}$/.test(password.value)) {
    error.value = '密码至少 8 位 并且需同时包含字母和数字'
    return
  }
  if (password.value !== confirmPassword.value) {
    error.value = '两次输入的密码不一致'
    return
  }
  submitting.value = true
  try {
    message.value = await resetPassword(token.value, password.value)
    authStore.logout()
    window.setTimeout(() => void router.push('/login'), 1200)
  } catch (exception: unknown) {
    error.value = toErrorMessage(exception)
  } finally {
    submitting.value = false
  }
}
</script>

<template>
  <main class="auth-page">
    <section class="auth-card" aria-labelledby="reset-title">
      <RouterLink class="brand auth-brand" to="/">
        <span class="brand-mark" aria-hidden="true">T</span>
        <span class="brand-name">Theseus</span>
      </RouterLink>

      <header class="auth-heading">
        <h1 id="reset-title">重置密码</h1>
        <p>设置新密码后 所有设备需要重新登录</p>
      </header>

      <form @submit.prevent="submit">
        <label>新密码<div class="password-field"><input v-model="password" :type="showPassword ? 'text' : 'password'" autocomplete="new-password" placeholder="至少 8 位 包含字母和数字" /><button type="button" :aria-label="showPassword ? '隐藏密码' : '显示密码'" @click="showPassword = !showPassword">{{ showPassword ? '隐藏' : '显示' }}</button></div></label>
        <label>确认密码<div class="password-field"><input v-model="confirmPassword" :type="showPassword ? 'text' : 'password'" autocomplete="new-password" placeholder="再次输入新密码" /><button type="button" :aria-label="showPassword ? '隐藏密码' : '显示密码'" @click="showPassword = !showPassword">{{ showPassword ? '隐藏' : '显示' }}</button></div></label>
        <p v-if="error" class="form-error" role="alert">{{ error }}</p>
        <p v-if="message" class="auth-notice is-success" role="status">{{ message }}</p>
        <button class="primary-button auth-submit" type="submit" :disabled="submitting">
          {{ submitting ? '提交中' : '重置密码' }}
        </button>
      </form>

      <p class="auth-footnote"><RouterLink to="/login">返回登录</RouterLink></p>
    </section>
  </main>
</template>
