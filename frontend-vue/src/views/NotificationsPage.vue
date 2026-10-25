<script setup lang="ts">
import { computed, onMounted } from 'vue'
import { useRouter } from 'vue-router'
import NavBar from '../components/NavBar.vue'
import { useNotificationStore } from '../store/notifications'
import { formatForumDateTime, notificationIcon, notificationLabel } from '../utils/forum'
import type { ForumNotification } from '../types/forum'

const router = useRouter()
const notificationStore = useNotificationStore()

const hasMore = computed(
  () => notificationStore.notifications.length < notificationStore.total,
)

const load = (page: number, append = false): void => {
  void notificationStore.loadNotifications(page, append)
}

const openNotification = async (item: ForumNotification): Promise<void> => {
  await notificationStore.markRead(item.id)
  if (item.link) await router.push(item.link)
}

onMounted(() => {
  load(1)
  void notificationStore.refreshUnread()
})
</script>

<template>
  <NavBar />
  <main class="notifications-page page-shell">
    <header class="forum-page-heading">
      <div>
        <h1>站内通知</h1>
      </div>
      <button
        type="button"
        class="forum-secondary-button"
        :disabled="notificationStore.unread === 0 || notificationStore.isLoading"
        @click="notificationStore.markAllRead()"
      >
        全部标为已读
      </button>
    </header>

    <p v-if="notificationStore.error" class="form-error" role="alert">{{ notificationStore.error }}</p>

    <div v-if="notificationStore.isLoading && !notificationStore.notifications.length" class="run-note">
      正在加载通知…
    </div>
    <div v-else-if="notificationStore.notifications.length" class="notification-list">
      <button
        v-for="item in notificationStore.notifications"
        :key="item.id"
        type="button"
        :class="['notification-item', { unread: !item.read, 'has-link': Boolean(item.link) }]"
        @click="openNotification(item)"
      >
        <span class="notification-icon" aria-hidden="true">{{ notificationIcon(item.type) }}</span>
        <span class="notification-content">
          <span class="notification-topline">
            <strong>{{ item.title }}</strong>
            <span class="notification-type">{{ notificationLabel(item.type) }}</span>
            <span v-if="!item.read" class="notification-unread-dot" aria-label="未读"></span>
          </span>
          <span v-if="item.body" class="notification-body">{{ item.body }}</span>
          <time class="notification-time" :datetime="item.createdAt">{{ formatForumDateTime(item.createdAt) }}</time>
        </span>
        <span v-if="item.link" class="notification-arrow" aria-hidden="true">→</span>
      </button>

      <button
        v-if="hasMore"
        type="button"
        class="forum-secondary-button notification-load-more"
        :disabled="notificationStore.isLoading"
        @click="load(notificationStore.page + 1, true)"
      >
        {{ notificationStore.isLoading ? '加载中…' : '加载更多通知' }}
      </button>
    </div>
    <div v-else-if="!notificationStore.isLoading" class="empty-state">
      <p>暂时没有通知。</p>
    </div>
  </main>
</template>
