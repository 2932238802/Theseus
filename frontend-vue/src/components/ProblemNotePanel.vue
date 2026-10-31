<script setup lang="ts">
import { computed, onBeforeUnmount, ref, watch } from 'vue'
import { useRoute } from 'vue-router'
import MarkdownBody from './MarkdownBody.vue'
import { toErrorMessage } from '../api/client'
import { fetchProblemNote, saveProblemNote } from '../api/notes'
import { useAuthStore } from '../store/auth'

const props = defineProps<{ problemId: number }>()

const route = useRoute()
const authStore = useAuthStore()

const body = ref('')
const savedBody = ref('')
const savedAt = ref('')
const loading = ref(false)
const ready = ref(false)
const error = ref('')
const saveError = ref('')
const savingCount = ref(0)
const mode = ref<'edit' | 'preview'>('edit')
let timer: number | undefined
let chain: Promise<void> = Promise.resolve()

const loginTarget = computed(() => ({ name: 'login', query: { redirect: route.fullPath } }))
const statusLabel = computed(() => {
  if (saveError.value) return '保存失败'
  if (savingCount.value > 0) return '保存中'
  if (savedAt.value) {
    return `已保存 ${new Date(savedAt.value).toLocaleTimeString('zh-CN', {
      hour: '2-digit',
      minute: '2-digit',
    })}`
  }
  return body.value ? '未保存' : ''
})

const queueSave = (problemId: number, next: string): void => {
  savingCount.value += 1
  chain = chain.then(async () => {
    try {
      const note = await saveProblemNote(problemId, next)
      if (problemId !== props.problemId) return
      savedBody.value = next
      savedAt.value = note?.updatedAt ?? ''
      saveError.value = ''
    } catch (exception: unknown) {
      if (problemId === props.problemId) saveError.value = toErrorMessage(exception)
    } finally {
      savingCount.value = Math.max(0, savingCount.value - 1)
    }
  })
}

const scheduleSave = (): void => {
  window.clearTimeout(timer)
  const problemId = props.problemId
  const next = body.value
  timer = window.setTimeout(() => queueSave(problemId, next), 700)
}

const retry = (): void => {
  if (!ready.value || savingCount.value > 0) return
  queueSave(props.problemId, body.value)
}

const load = async (): Promise<void> => {
  window.clearTimeout(timer)
  body.value = ''
  savedBody.value = ''
  savedAt.value = ''
  error.value = ''
  saveError.value = ''
  mode.value = 'edit'
  ready.value = false
  if (!authStore.isAuthenticated) return
  loading.value = true
  try {
    const note = await fetchProblemNote(props.problemId)
    body.value = note?.bodyMd ?? ''
    savedBody.value = body.value
    savedAt.value = note?.updatedAt ?? ''
  } catch (exception: unknown) {
    error.value = toErrorMessage(exception)
  } finally {
    loading.value = false
    ready.value = true
  }
}

watch(
  () => props.problemId,
  () => {
    void load()
  },
  { immediate: true },
)

watch(body, () => {
  if (!ready.value || body.value === savedBody.value) return
  scheduleSave()
})

onBeforeUnmount(() => {
  window.clearTimeout(timer)
  if (!ready.value || !authStore.isAuthenticated) return
  if (body.value === savedBody.value) return
  queueSave(props.problemId, body.value)
})
</script>

<template>
  <section class="problem-note" aria-label="题目笔记">
    <header class="problem-note-head">
      <div>
        <h2>我的笔记</h2>
        <p>私有笔记 仅自己可见</p>
      </div>
      <div v-if="authStore.isAuthenticated && ready && !error" class="problem-note-tools">
        <span v-if="statusLabel" :class="['problem-note-status', { error: !!saveError }]">
          {{ statusLabel }}
        </span>
        <button v-if="saveError" type="button" class="problem-note-retry" @click="retry">
          重试
        </button>
        <button
          type="button"
          :class="['problem-note-mode', { active: mode === 'edit' }]"
          @click="mode = 'edit'"
        >
          编辑
        </button>
        <button
          type="button"
          :class="['problem-note-mode', { active: mode === 'preview' }]"
          @click="mode = 'preview'"
        >
          预览
        </button>
      </div>
    </header>

    <div v-if="!authStore.isAuthenticated" class="problem-note-empty">
      <p>登录后可以记录题目笔记</p>
      <RouterLink class="primary-button" :to="loginTarget">去登录</RouterLink>
    </div>
    <div v-else-if="loading" class="run-note">正在加载笔记</div>
    <div v-else-if="error" class="problem-note-empty">
      <p class="form-error" role="alert">{{ error }}</p>
      <button type="button" class="problem-note-retry" @click="load">重试</button>
    </div>
    <template v-else>
      <textarea
        v-if="mode === 'edit'"
        v-model="body"
        class="problem-note-editor"
        placeholder="记录思路 关键代码或错因"
        spellcheck="false"
      ></textarea>
      <div v-else class="problem-note-preview">
        <MarkdownBody v-if="body.trim()" :content="body" />
        <p v-else class="problem-note-placeholder">还没有内容</p>
      </div>
    </template>
  </section>
</template>
