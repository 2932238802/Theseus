<script setup lang="ts">
import { computed, onMounted, ref } from 'vue'
import { useRouter } from 'vue-router'
import MarkdownBody from '../components/MarkdownBody.vue'
import NavBar from '../components/NavBar.vue'
import { toErrorMessage } from '../api/client'
import { useInvitationStore } from '../store/invitations'
import { useNotificationStore } from '../store/notifications'
import { formatForumDateTime, notificationIcon, notificationLabel } from '../utils/forum'
import type { ForumNotification } from '../types/forum'

const router = useRouter()
const notificationStore = useNotificationStore()
const invitationStore = useInvitationStore()

const actionError = ref('')
const actionMessage = ref('')
const actingNotificationId = ref<number | null>(null)

const hasMore = computed(
  () => notificationStore.notifications.length < notificationStore.total,
)

const isPendingInvitation = (item: ForumNotification): boolean =>
  item.type === 'class_invite' &&
  item.invitationStatus === 'pending' &&
  item.relatedId !== null &&
  item.relatedId !== undefined

const load = (page: number, append = false): void => {
  void notificationStore.loadNotifications(page, append)
}

const openNotification = async (item: ForumNotification): Promise<void> => {
  await notificationStore.markRead(item.id)
  if (item.link) await router.push(item.link)
}

const respondInvitation = async (
  item: ForumNotification,
  action: 'accept' | 'decline',
): Promise<void> => {
  if (item.relatedId === null || item.relatedId === undefined) return
  actionError.value = ''
  actionMessage.value = ''
  actingNotificationId.value = item.id
  try {
    const result =
      action === 'accept'
        ? await invitationStore.accept(item.relatedId)
        : await invitationStore.decline(item.relatedId)
    item.invitationStatus = result.status
    actionMessage.value = result.message
    await notificationStore.markRead(item.id)
  } catch (exception: unknown) {
    actionError.value = toErrorMessage(exception)
  } finally {
    actingNotificationId.value = null
  }
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
    <p v-if="actionError" class="form-error" role="alert">{{ actionError }}</p>
    <p v-if="actionMessage" class="teaching-success" role="status">{{ actionMessage }}</p>

    <div v-if="notificationStore.isLoading && !notificationStore.notifications.length" class="run-note">
      正在加载通知
    </div>
    <div v-else-if="notificationStore.notifications.length" class="notification-list">
      <article
        v-for="item in notificationStore.notifications"
        :key="item.id"
        :class="['notification-item', { unread: !item.read }]"
      >
        <span class="notification-icon" aria-hidden="true">{{ notificationIcon(item.type) }}</span>
        <div class="notification-content">
          <div class="notification-topline">
            <strong>{{ item.title }}</strong>
            <span class="notification-type">{{ notificationLabel(item.type) }}</span>
            <span v-if="!item.read" class="notification-unread-dot" aria-label="未读"></span>
          </div>
          <MarkdownBody
            v-if="item.body && item.type === 'system_notice'"
            class="notification-markdown"
            :content="item.body"
          />
          <p v-else-if="item.body" class="notification-body">{{ item.body }}</p>

          <div v-if="isPendingInvitation(item)" class="notification-actions">
            <button
              type="button"
              class="primary-button"
              :disabled="actingNotificationId === item.id"
              @click="respondInvitation(item, 'accept')"
            >
              {{ actingNotificationId === item.id ? '处理中' : '接受邀请' }}
            </button>
            <button
              type="button"
              class="teaching-secondary-button"
              :disabled="actingNotificationId === item.id"
              @click="respondInvitation(item, 'decline')"
            >
              拒绝
            </button>
          </div>

          <div class="notification-footer">
            <time class="notification-time" :datetime="item.createdAt">
              {{ formatForumDateTime(item.createdAt) }}
            </time>
            <button
              v-if="item.link"
              type="button"
              class="notification-open"
              @click="openNotification(item)"
            >
              查看详情 →
            </button>
          </div>
        </div>
      </article>

      <button
        v-if="hasMore"
        type="button"
        class="forum-secondary-button notification-load-more"
        :disabled="notificationStore.isLoading"
        @click="load(notificationStore.page + 1, true)"
      >
        {{ notificationStore.isLoading ? '加载中' : '加载更多通知' }}
      </button>
    </div>
    <div v-else-if="!notificationStore.isLoading" class="empty-state">
      <p>暂时没有通知</p>
    </div>
  </main>
</template>
