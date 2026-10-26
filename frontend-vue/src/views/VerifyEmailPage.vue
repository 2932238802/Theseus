<script setup lang="ts">
import { computed, onMounted, ref } from 'vue'
import { useRoute, useRouter } from 'vue-router'
import { resendVerification, verifyEmail } from '../api/auth'
import { toErrorMessage } from '../api/client'
import { useAuthStore } from '../store/auth'

const route = useRoute()
const router = useRouter()
const authStore = useAuthStore()
const token = computed(() => (typeof route.query.token === 'string' ? route.query.token.trim() : ''))
const sent = computed(() => route.query.sent === '1')
const state = ref<'idle' | 'verifying' | 'success' | 'error'>(token.value ? 'verifying' : 'idle')
const message = ref('')
const resending = ref(false)
const resendMessage = ref('')

const runVerification = async (): Promise<void> => {
  state.value = 'verifying'
  try {
    message.value = await verifyEmail(token.value)
    await authStore.refreshMe()
    state.value = 'success'
  } catch (exception: unknown) {
    message.value = toErrorMessage(exception)
    state.value = 'error'
  }
}

const resend = async (): Promise<void> => {
  if (!authStore.isAuthenticated) {
    await router.push({ name: 'login', query: { redirect: '/verify-email?sent=1' } })
    return
  }
  resending.value = true
  resendMessage.value = ''
  try {
    const result = await resendVerification()
    resendMessage.value = result.message
  } catch (exception: unknown) {
    resendMessage.value = toErrorMessage(exception)
  } finally {
    resending.value = false
  }
}

onMounted(() => {
  if (token.value) void runVerification()
})
</script>

<template>
  <main class="auth-page">
    <section class="auth-card" aria-labelledby="verify-title">
      <RouterLink class="brand auth-brand" to="/">
        <span class="brand-mark" aria-hidden="true">T</span>
        <span class="brand-name">Theseus</span>
      </RouterLink>

      <header class="auth-heading">
        <h1 id="verify-title">验证邮箱</h1>
        <p>{{ authStore.user?.email ?? '通过注册邮箱完成验证' }}</p>
      </header>

      <div v-if="state === 'verifying'" class="auth-notice">正在验证</div>
      <div v-else-if="state === 'success'" class="auth-notice is-success">{{ message }}</div>
      <div v-else-if="state === 'error'" class="auth-notice is-error" role="alert">{{ message }}</div>
      <div v-else-if="authStore.isEmailVerified" class="auth-notice is-success">邮箱已验证</div>
      <div v-else class="auth-notice">
        {{ sent ? '验证邮件已发送 请查收邮箱' : '打开邮件中的链接即可完成验证' }}
      </div>

      <div class="auth-actions">
        <button
          v-if="state !== 'success' && !authStore.isEmailVerified"
          class="primary-button"
          type="button"
          :disabled="resending"
          @click="resend"
        >
          {{ resending ? '发送中' : '重新发送验证邮件' }}
        </button>
        <RouterLink class="auth-secondary-link" to="/problems">进入题库</RouterLink>
      </div>
      <p v-if="resendMessage" class="auth-footnote" role="status">{{ resendMessage }}</p>
      <p v-if="state === 'error'" class="auth-footnote">
        <RouterLink to="/login">返回登录</RouterLink>
      </p>
    </section>
  </main>
</template>
