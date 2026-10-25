<script setup lang="ts">
import { onBeforeUnmount, onMounted } from 'vue'
import { useRoute, useRouter } from 'vue-router'
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
  <RouterView />
</template>
