<script setup lang="ts">
import { computed, ref } from 'vue'
import { useRoute, useRouter } from 'vue-router'
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

const isLogin = computed(() => activeMode.value === 'login')

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

      <p class="auth-footnote">继续即代表你同意 Theseus 的服务条款与隐私政策</p>
    </section>
  </main>
</template>
