<script setup lang="ts">
import { dismissToast, toastItems } from '../store/toast'

const icons = {
  success: '✓',
  error: '!',
  info: 'i',
} as const
</script>

<template>
  <Teleport to="body">
    <div class="app-toast-stack" aria-live="polite">
      <TransitionGroup name="toast-pop">
        <div
          v-for="item in toastItems"
          :key="item.id"
          :class="['app-toast', `app-toast-${item.tone}`]"
          role="status"
        >
          <span class="app-toast-icon" aria-hidden="true">{{ icons[item.tone] }}</span>
          <span class="app-toast-message">{{ item.message }}</span>
          <button
            type="button"
            class="app-toast-close"
            aria-label="关闭提示"
            @click="dismissToast(item.id)"
          >
            ×
          </button>
          <span
            class="app-toast-progress"
            :style="{ animationDuration: `${item.duration}ms` }"
            aria-hidden="true"
          ></span>
        </div>
      </TransitionGroup>
    </div>
  </Teleport>
</template>
