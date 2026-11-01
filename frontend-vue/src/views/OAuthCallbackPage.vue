<script setup lang="ts">
import { onMounted, ref } from 'vue'
import { useRoute, useRouter } from 'vue-router'
import { toErrorMessage } from '../api/client'
import { exchangeOAuthCode } from '../api/oauth'
import { useAuthStore } from '../store/auth'

const route = useRoute()
const router = useRouter()
const authStore = useAuthStore()
const error = ref('')
const isExchanging = ref(true)

const safeRedirect = (value: unknown): string => {
  if (typeof value !== 'string') return '/'
  return value.startsWith('/') && !value.startsWith('//') && !value.includes('\\')
    ? value
    : '/'
}

onMounted(async () => {
  const code = typeof route.query.code === 'string' ? route.query.code : ''
  if (!code) {
    error.value = '登录票据缺失 请重新登录'
    isExchanging.value = false
    return
  }
  try {
    const session = await exchangeOAuthCode(code)
    authStore.replaceSession(session.token, session.user)
    await router.replace(safeRedirect(route.query.redirect))
  } catch (exception: unknown) {
    error.value = toErrorMessage(exception)
    isExchanging.value = false
  }
})
</script>

<template>
  <main class="auth-page">
    <section class="auth-card" aria-labelledby="oauth-title">
      <RouterLink class="brand auth-brand" to="/">
        <span class="brand-mark" aria-hidden="true">T</span>
        <span class="brand-name">Theseus</span>
      </RouterLink>
      <header class="auth-heading">
        <h1 id="oauth-title">{{ error ? '登录失败' : '正在完成登录' }}</h1>
      </header>
      <p v-if="isExchanging" class="teaching-subtle">正在验证第三方账号 请稍候</p>
      <p v-else class="form-error" role="alert">{{ error }}</p>
      <RouterLink v-if="!isExchanging" class="primary-button auth-submit" to="/login">
        返回登录
      </RouterLink>
    </section>
  </main>
</template>
