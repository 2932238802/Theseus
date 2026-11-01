<script setup lang="ts">
import { computed, onMounted, ref } from 'vue'
import { useRoute, useRouter } from 'vue-router'
import { toErrorMessage } from '../api/client'
import { fetchOAuthProviders, startOAuth } from '../api/oauth'
import { useAuthStore } from '../store/auth'
import { getRememberedUsername } from '../utils/session'

const route = useRoute()
const router = useRouter()
const authStore = useAuthStore()
const activeMode = ref<'login' | 'register'>('login')
const showPassword = ref(false)
const showConfirmPassword = ref(false)
const loginForm = ref({ username: getRememberedUsername(), password: '', remember: true })
const registerForm = ref({ username: '', email: '', password: '', confirmPassword: '' })
const formError = ref('')
const oauthProviders = ref<{ provider: string; enabled: boolean }[]>([])
const oauthBusy = ref('')

const isLogin = computed(() => activeMode.value === 'login')
const kicked = computed(() => route.query.kicked === '1')

const OAUTH_LABELS: Record<string, string> = {
  github: 'GitHub',
}

const oauthMessage = computed(() => {
  switch (route.query.oauth) {
    case 'unbound':
      return '该 GitHub 账号尚未绑定 Theseus 账号 请先用密码登录后在账号设置中绑定'
    case 'disabled':
      return '该账号当前不可登录'
    case 'denied':
      return '已取消 GitHub 授权'
    case 'error':
      return 'GitHub 登录失败 请稍后再试'
    default:
      return ''
  }
})

const loadProviders = async (): Promise<void> => {
  try {
    oauthProviders.value = (await fetchOAuthProviders()).filter((item) => item.enabled)
  } catch {
    oauthProviders.value = []
  }
}

const loginWithOAuth = async (provider: string): Promise<void> => {
  if (oauthBusy.value) return
  oauthBusy.value = provider
  formError.value = ''
  try {
    const redirect = typeof route.query.redirect === 'string' ? route.query.redirect : undefined
    window.location.assign(await startOAuth(provider, 'login', redirect))
  } catch (exception: unknown) {
    formError.value = toErrorMessage(exception)
    oauthBusy.value = ''
  }
}

onMounted(() => {
  void loadProviders()
})

const switchMode = (mode: 'login' | 'register'): void => {
  activeMode.value = mode
  formError.value = ''
}

const validateRegister = (): string => {
  if (!/^[A-Za-z0-9_]{3,16}$/.test(registerForm.value.username)) return '用户名需为 3-16 位字母 数字或下划线'
  if (!/^\S+@\S+\.\S+$/.test(registerForm.value.email)) return '请输入有效的邮箱地址'
  if (!/^(?=.*[A-Za-z])(?=.*\d).{8,}$/.test(registerForm.value.password)) return '密码至少 8 位 并且需同时包含字母和数字'
  if (registerForm.value.password !== registerForm.value.confirmPassword) return '两次输入的密码不一致'
  return ''
}

const handleSubmit = async (): Promise<void> => {
  formError.value = ''
  try {
    if (isLogin.value) {
      if (!loginForm.value.username || !loginForm.value.password) {
        formError.value = '请输入用户名和密码'
        return
      }
      await authStore.login(loginForm.value.username, loginForm.value.password, loginForm.value.remember)
    } else {
      const message = validateRegister()
      if (message) {
        formError.value = message
        return
      }
      await authStore.register(registerForm.value.username, registerForm.value.email, registerForm.value.password)
      await router.push({ name: 'verify-email', query: { sent: '1' } })
      return
    }
    const redirect = typeof route.query.redirect === 'string' ? route.query.redirect : '/'
    await router.push(redirect.startsWith('/') && !redirect.startsWith('//') ? redirect : '/')
  } catch {
    formError.value = authStore.error
  }
}
</script>

<template>
  <main class="auth-page">
    <section class="auth-card" aria-labelledby="auth-title">
      <RouterLink class="brand auth-brand" to="/">
        <span class="brand-mark" aria-hidden="true">T</span>
        <span class="brand-name">Theseus</span>
      </RouterLink>

      <header class="auth-heading">
        <h1 id="auth-title">{{ isLogin ? '登录' : '注册' }}</h1>
      </header>

      <div class="auth-tabs" role="tablist" aria-label="登录或注册">
        <button :class="{ active: isLogin }" type="button" role="tab" :aria-selected="isLogin" @click="switchMode('login')">登录</button>
        <button :class="{ active: !isLogin }" type="button" role="tab" :aria-selected="!isLogin" @click="switchMode('register')">注册</button>
      </div>

      <div v-if="kicked && isLogin" class="auth-session-alert" role="alert">
        <strong>账号已在其他设备登录</strong>
        <p>如果不是你本人操作 请立即<RouterLink to="/forgot-password">修改密码</RouterLink></p>
        <p>重新登录会退出那台设备</p>
      </div>

      <form @submit.prevent="handleSubmit">
        <template v-if="isLogin">
          <label>用户名或邮箱<input v-model.trim="loginForm.username" autocomplete="username" placeholder="请输入用户名或邮箱" /></label>
          <label>密码<div class="password-field"><input v-model="loginForm.password" :type="showPassword ? 'text' : 'password'" autocomplete="current-password" placeholder="请输入密码" /><button type="button" :aria-label="showPassword ? '隐藏密码' : '显示密码'" @click="showPassword = !showPassword">{{ showPassword ? '隐藏' : '显示' }}</button></div></label>
          <div class="auth-inline-links">
            <label class="remember" title="只记住账号 不保存密码"><input v-model="loginForm.remember" type="checkbox" /><span>记住账号</span></label>
            <RouterLink to="/forgot-password">忘记密码</RouterLink>
          </div>
        </template>
        <template v-else>
          <label>用户名<input v-model.trim="registerForm.username" autocomplete="username" placeholder="3-16 位字母 数字或下划线" /></label>
          <label>邮箱<input v-model.trim="registerForm.email" type="email" autocomplete="email" placeholder="name@example.com" /></label>
          <label>密码<div class="password-field"><input v-model="registerForm.password" :type="showPassword ? 'text' : 'password'" autocomplete="new-password" placeholder="至少 8 位 包含字母和数字" /><button type="button" :aria-label="showPassword ? '隐藏密码' : '显示密码'" @click="showPassword = !showPassword">{{ showPassword ? '隐藏' : '显示' }}</button></div></label>
          <label>确认密码<div class="password-field"><input v-model="registerForm.confirmPassword" :type="showConfirmPassword ? 'text' : 'password'" autocomplete="new-password" placeholder="再次输入密码" /><button type="button" :aria-label="showConfirmPassword ? '隐藏密码' : '显示密码'" @click="showConfirmPassword = !showConfirmPassword">{{ showConfirmPassword ? '隐藏' : '显示' }}</button></div></label>
        </template>
        <p v-if="formError" class="form-error" role="alert">{{ formError }}</p>
        <button class="primary-button auth-submit" type="submit" :disabled="authStore.isLoading"><span v-if="authStore.isLoading" class="spinner"></span>{{ authStore.isLoading ? '处理中' : isLogin ? '登录' : '注册并开始' }}</button>
      </form>

      <p v-if="oauthMessage" class="auth-oauth-message" role="status">{{ oauthMessage }}</p>
      <div v-if="oauthProviders.length" class="auth-oauth">
        <span class="auth-oauth-divider">或使用第三方账号</span>
        <button
          v-for="item in oauthProviders"
          :key="item.provider"
          class="auth-oauth-button"
          type="button"
          :disabled="Boolean(oauthBusy)"
          @click="loginWithOAuth(item.provider)"
        >
          使用 {{ OAUTH_LABELS[item.provider] ?? item.provider }} 登录
        </button>
      </div>

      <p class="auth-footnote">继续即代表你同意 Theseus 的服务条款与隐私政策</p>
      <p class="auth-developer">LosAngelous/Theseus</p>
    </section>
  </main>
</template>
