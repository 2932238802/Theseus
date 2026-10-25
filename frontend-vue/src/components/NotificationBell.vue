<script setup lang="ts">
import { onBeforeUnmount, onMounted, watch } from 'vue'
import { useAuthStore } from '../store/auth'
import { useNotificationStore } from '../store/notifications'

const authStore = useAuthStore()
const notificationStore = useNotificationStore()

const sync = (authenticated: boolean): void => {
  if (authenticated) notificationStore.startPolling()
  else notificationStore.clear()
}

onMounted(() => sync(authStore.isAuthenticated))
watch(() => authStore.isAuthenticated, sync)
onBeforeUnmount(() => notificationStore.stopPolling())
</script>

<template>
  <RouterLink
    v-if="authStore.isAuthenticated"
    class="notification-bell"
    to="/notifications"
    aria-label="站内通知"
    title="站内通知"
  >
    <svg viewBox="0 0 24 24" aria-hidden="true">
      <path d="M18 8a6 6 0 1 0-12 0c0 5-2 6-2 6h16s-2-1-2-6M10 20a2 2 0 0 0 4 0" />
    </svg>
    <span v-if="notificationStore.unread > 0" class="notification-badge">
      {{ notificationStore.unread > 99 ? '99+' : notificationStore.unread }}
    </span>
  </RouterLink>
</template>
