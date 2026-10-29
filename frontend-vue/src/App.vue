<script setup lang="ts">
import { onBeforeUnmount, onMounted } from 'vue'
import { useRoute, useRouter } from 'vue-router'
import ToastHost from './components/ToastHost.vue'
import { useAuthStore } from './store/auth'

const authStore = useAuthStore()
const router = useRouter()
const route = useRoute()

const routeAllowed = (): boolean => {
  if (route.meta.requiresStudent && !authStore.isStudent) return false
  if (route.meta.requiresTeacher && !authStore.isTeacher) return false
  if (route.meta.requiresAdmin && !authStore.isAdmin) return false
  return true
}

const redirectIfForbidden = (): void => {
  if (!routeAllowed()) void router.replace({ name: 'home' })
}

const onForbidden = async (): Promise<void> => {
  await authStore.refreshMe()
  redirectIfForbidden()
}

onMounted(() => {
  window.addEventListener('theseus:forbidden', onForbidden)
  if (authStore.isAuthenticated) {
    void authStore.refreshMe().then(redirectIfForbidden)
  }
})

onBeforeUnmount(() => {
  window.removeEventListener('theseus:forbidden', onForbidden)
})
</script>

<template>
  <div v-if="authStore.isAuthenticated && !authStore.isEmailVerified && route.path !== '/verify-email'" class="email-verify-banner" role="status">
    <span>邮箱未验证 加入班级 提交作业或发帖前需要先验证</span>
    <RouterLink to="/verify-email">去验证</RouterLink>
  </div>
  <RouterView />
  <ToastHost />
  <footer class="app-footer" aria-label="站点信息">LosAngelous/Theseus</footer>
</template>
