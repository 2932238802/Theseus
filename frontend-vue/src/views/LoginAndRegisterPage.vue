<script setup lang="ts">
import { computed, ref } from 'vue'
import { useRouter } from 'vue-router'
import { useAuthStore } from '../store/auth'

const router = useRouter()
const authStore = useAuthStore()
const activeMode = ref<'login' | 'register'>('login')
const showPassword = ref(false)
const showConfirmPassword = ref(false)
const loginForm = ref({ username: '', password: '', remember: true })
const registerForm = ref({ username: '', email: '', password: '', confirmPassword: '' })
const formError = ref('')

const isLogin = computed(() => activeMode.value === 'login')

const switchMode = (mode: 'login' | 'register'): void => {
  activeMode.value = mode
  formError.value = ''
}

const validateRegister = (): string => {
  if (!/^[A-Za-z0-9_]{3,16}$/.test(registerForm.value.username)) return '用户名需为 3-16 位字母、数字或下划线。'
  if (!/^\S+@\S+\.\S+$/.test(registerForm.value.email)) return '请输入有效的邮箱地址。'
  if (!/^(?=.*[A-Za-z])(?=.*\d).{8,}$/.test(registerForm.value.password)) return '密码至少 8 位，并且需同时包含字母和数字。'
  if (registerForm.value.password !== registerForm.value.confirmPassword) return '两次输入的密码不一致。'
  return ''
}

const handleSubmit = async (): Promise<void> => {
  formError.value = ''
  try {
    if (isLogin.value) {
      if (!loginForm.value.username || !loginForm.value.password) {
        formError.value = '请输入用户名和密码。'
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
    }
    await router.push('/')
  } catch {
    formError.value = authStore.error
  }
}
</script>

<template>
  <main class="auth-page">
    <section class="auth-intro" aria-label="平台介绍">
      <RouterLink class="brand auth-brand" to="/">
        <span class="brand-mark" aria-hidden="true"><i></i><i></i><i></i></span>
        <span>theseus<span class="brand-dot">.</span></span>
      </RouterLink>
      <div class="auth-copy">
        <p class="eyebrow">BUILD YOUR WAY OUT</p>
        <h1>把每一次思考<br />变成更好的自己。</h1>
        <p>Theseus 是为持续思考者准备的算法训练场。解开一道题，也是在重写自己的路径。</p>
      </div>
      <div class="auth-quote"><span>“</span>迷宫不会缩小，但你会变强。</div>
      <div class="maze-lines" aria-hidden="true"></div>
    </section>

    <section class="auth-panel">
      <div class="auth-card">
        <div class="auth-heading">
          <p class="eyebrow">WELCOME TO THESEUS</p>
          <h2>{{ isLogin ? '继续你的旅程' : '创建你的账号' }}</h2>
          <p>{{ isLogin ? '登录后，继续你的算法训练。' : '只需一分钟，开启你的解题路径。' }}</p>
        </div>
        <div class="auth-tabs" role="tablist">
          <button :class="{ active: isLogin }" type="button" role="tab" @click="switchMode('login')">登录</button>
          <button :class="{ active: !isLogin }" type="button" role="tab" @click="switchMode('register')">注册</button>
        </div>
        <form @submit.prevent="handleSubmit">
          <template v-if="isLogin">
            <label>用户名或邮箱<input v-model.trim="loginForm.username" autocomplete="username" placeholder="请输入用户名或邮箱" /></label>
            <label>密码<div class="password-field"><input v-model="loginForm.password" :type="showPassword ? 'text' : 'password'" autocomplete="current-password" placeholder="请输入密码" /><button type="button" :aria-label="showPassword ? '隐藏密码' : '显示密码'" @click="showPassword = !showPassword">{{ showPassword ? '隐藏' : '显示' }}</button></div></label>
            <label class="remember"><input v-model="loginForm.remember" type="checkbox" /><span>记住我</span></label>
          </template>
          <template v-else>
            <label>用户名<input v-model.trim="registerForm.username" autocomplete="username" placeholder="3-16 位字母、数字或下划线" /></label>
            <label>邮箱<input v-model.trim="registerForm.email" type="email" autocomplete="email" placeholder="name@example.com" /></label>
            <label>密码<div class="password-field"><input v-model="registerForm.password" :type="showPassword ? 'text' : 'password'" autocomplete="new-password" placeholder="至少 8 位，包含字母和数字" /><button type="button" :aria-label="showPassword ? '隐藏密码' : '显示密码'" @click="showPassword = !showPassword">{{ showPassword ? '隐藏' : '显示' }}</button></div></label>
            <label>确认密码<div class="password-field"><input v-model="registerForm.confirmPassword" :type="showConfirmPassword ? 'text' : 'password'" autocomplete="new-password" placeholder="再次输入密码" /><button type="button" :aria-label="showConfirmPassword ? '隐藏密码' : '显示密码'" @click="showConfirmPassword = !showConfirmPassword">{{ showConfirmPassword ? '隐藏' : '显示' }}</button></div></label>
          </template>
          <p v-if="formError" class="form-error" role="alert">{{ formError }}</p>
          <button class="primary-button auth-submit" type="submit" :disabled="authStore.isLoading"><span v-if="authStore.isLoading" class="spinner"></span>{{ authStore.isLoading ? '处理中…' : isLogin ? '登录' : '注册并开始' }}<span v-if="!authStore.isLoading">→</span></button>
        </form>
        <p class="auth-footnote">继续即代表你同意 Theseus 的服务条款与隐私政策。</p>
      </div>
    </section>
  </main>
</template>
