<script setup lang="ts">
import { computed, ref } from 'vue'
import { fetchCurrentUser } from '../api/auth'
import { removeAvatar, uploadAvatar } from '../api/profile'
import { toErrorMessage } from '../api/client'
import { useAuthStore } from '../store/auth'

const authStore = useAuthStore()
const input = ref<HTMLInputElement | null>(null)
const busy = ref(false)
const error = ref('')
const initial = computed(
  () => authStore.user?.username.slice(0, 1).toUpperCase() ?? 'T',
)

const pick = (): void => {
  input.value?.click()
}

const onChange = async (event: Event): Promise<void> => {
  const target = event.target as HTMLInputElement
  const file = target.files?.[0]
  target.value = ''
  if (!file || busy.value) return
  error.value = ''
  if (!['image/jpeg', 'image/png', 'image/webp'].includes(file.type)) {
    error.value = '只支持 JPG、PNG、WebP'
    return
  }
  if (file.size > 2 * 1024 * 1024) {
    error.value = '头像不能超过 2 MB'
    return
  }
  busy.value = true
  try {
    await uploadAvatar(file)
    const user = await fetchCurrentUser()
    authStore.updateUser(user)
  } catch (exception: unknown) {
    error.value = toErrorMessage(exception)
  } finally {
    busy.value = false
  }
}

const clear = async (): Promise<void> => {
  if (busy.value) return
  error.value = ''
  busy.value = true
  try {
    const user = await removeAvatar()
    authStore.updateUser(user)
  } catch (exception: unknown) {
    error.value = toErrorMessage(exception)
  } finally {
    busy.value = false
  }
}
</script>

<template>
  <div class="profile-avatar-uploader">
    <button
      class="profile-avatar-button"
      type="button"
      :disabled="busy"
      aria-label="更换头像"
      title="更换头像"
      @click="pick"
    >
      <img v-if="authStore.user?.avatarUrl" :src="authStore.user.avatarUrl" :alt="authStore.user.username" />
      <span v-else>{{ initial }}</span>
      <span class="profile-avatar-edit" aria-hidden="true">✎</span>
    </button>
    <input
      ref="input"
      class="visually-hidden"
      type="file"
      accept="image/jpeg,image/png,image/webp"
      hidden
      @change="onChange"
    />
    <div class="profile-avatar-actions">
      <button type="button" class="teaching-link-button" :disabled="busy" @click="pick">
        {{ busy ? '处理中' : authStore.user?.avatarUrl ? '更换头像' : '上传头像' }}
      </button>
      <button
        v-if="authStore.user?.avatarUrl"
        type="button"
        class="teaching-link-button danger"
        :disabled="busy"
        @click="clear"
      >
        删除
      </button>
    </div>
    <p v-if="error" class="form-error" role="alert">{{ error }}</p>
  </div>
</template>
