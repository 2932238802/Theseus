<script setup lang="ts">
import { onMounted, ref } from 'vue'
import { toErrorMessage } from '../api/client'
import { fetchFollowing, unfollowUser } from '../api/social'
import { toast } from '../store/toast'
import type { FollowingUser } from '../types/social'

const emit = defineEmits<{ close: [] }>()

const users = ref<FollowingUser[]>([])
const loading = ref(true)
const error = ref('')
const busyId = ref<number | null>(null)

const roleLabel = (role: string): string =>
  role === 'teacher' ? '教师' : role === 'admin' ? '管理员' : '学生'
const initial = (name: string): string => name.trim().slice(0, 1).toUpperCase() || '?'
const formatDate = (value: string): string =>
  value ? new Date(value).toLocaleDateString('zh-CN') : '—'

const load = async (): Promise<void> => {
  loading.value = true
  error.value = ''
  try {
    const result = await fetchFollowing()
    users.value = result.users
  } catch (exception: unknown) {
    error.value = toErrorMessage(exception)
  } finally {
    loading.value = false
  }
}

const unfollow = async (user: FollowingUser): Promise<void> => {
  if (busyId.value !== null) return
  busyId.value = user.id
  error.value = ''
  try {
    await unfollowUser(user.id)
    users.value = users.value.filter((item) => item.id !== user.id)
    toast.success(`已取消关注 ${user.username}`)
  } catch (exception: unknown) {
    error.value = toErrorMessage(exception)
  } finally {
    busyId.value = null
  }
}

onMounted(() => void load())
</script>

<template>
  <div class="modal-backdrop" @click.self="emit('close')">
    <section
      class="run-dialog following-dialog"
      role="dialog"
      aria-modal="true"
      aria-labelledby="following-title"
    >
      <header>
        <div>
          <h2 id="following-title">关注的人</h2>
        </div>
        <button type="button" aria-label="关闭" @click="emit('close')">×</button>
      </header>
      <div class="run-dialog-body">
        <p v-if="error" class="form-error" role="alert">{{ error }}</p>
        <p v-if="loading" class="teaching-subtle">加载中</p>
        <div v-else-if="!users.length" class="empty-state">
          <p>还没有关注的人 在论坛里关注感兴趣的同学</p>
        </div>
        <ul v-else class="following-list">
          <li v-for="user in users" :key="user.id">
            <span class="following-avatar" aria-hidden="true">
              <img v-if="user.avatarUrl" :src="user.avatarUrl" :alt="user.username" />
              <template v-else>{{ initial(user.username) }}</template>
            </span>
            <div class="following-identity">
              <strong>
                {{ user.username }}
                <span v-if="user.isPlus" class="forum-plus-badge">Plus</span>
              </strong>
              <small>
                {{ roleLabel(user.role) }}
                <template v-if="user.grade"> · {{ user.grade }}</template>
                <template v-if="user.isSameSchool"> · 同校</template>
                · 关注于 {{ formatDate(user.followedAt) }}
              </small>
            </div>
            <button
              type="button"
              class="following-unfollow-button"
              :disabled="busyId === user.id"
              title="取消关注"
              @click="unfollow(user)"
            >
              {{ busyId === user.id ? '处理中' : '已关注' }}
            </button>
          </li>
        </ul>
      </div>
    </section>
  </div>
</template>
