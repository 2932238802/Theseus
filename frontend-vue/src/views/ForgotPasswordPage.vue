<script setup lang="ts">
import { ref } from 'vue'
import { forgotPassword } from '../api/auth'
import { toErrorMessage } from '../api/client'

const email = ref('')
const submitting = ref(false)
const message = ref('')
const error = ref('')

const submit = async (): Promise<void> => {
  error.value = ''
  message.value = ''
  if (!/^\S+@\S+\.\S+$/.test(email.value)) {
    error.value = '请输入有效的邮箱地址'
    return
  }
  submitting.value = true
  try {
    message.value = await forgotPassword(email.value)
  } catch (exception: unknown) {
    error.value = toErrorMessage(exception)
  } finally {
    submitting.value = false
  }
}
</script>

<template>
  <main class="auth-page">
    <section class="auth-card" aria-labelledby="forgot-title">
      <RouterLink class="brand auth-brand" to="/">
        <span class="brand-mark" aria-hidden="true">T</span>
        <span class="brand-name">Theseus</span>
      </RouterLink>

      <header class="auth-heading">
        <h1 id="forgot-title">找回密码</h1>
        <p>输入注册邮箱 我们会发送重置链接</p>
      </header>

      <form @submit.prevent="submit">
        <label>邮箱<input v-model.trim="email" type="email" autocomplete="email" placeholder="name@example.com" /></label>
        <p v-if="error" class="form-error" role="alert">{{ error }}</p>
        <p v-if="message" class="auth-notice is-success" role="status">{{ message }}</p>
        <button class="primary-button auth-submit" type="submit" :disabled="submitting">
          {{ submitting ? '发送中' : '发送重置邮件' }}
        </button>
      </form>

      <p class="auth-footnote"><RouterLink to="/login">返回登录</RouterLink></p>
    </section>
  </main>
</template>
