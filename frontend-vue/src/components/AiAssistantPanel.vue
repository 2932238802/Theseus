<script setup lang="ts">
import { nextTick, onMounted, ref, watch } from 'vue'
import MarkdownBody from './MarkdownBody.vue'
import { sendAiMessage } from '../api/ai'
import { toErrorMessage } from '../api/client'
import { usePreferenceStore } from '../store/preferences'

interface ChatEntry {
  id: number
  role: 'user' | 'assistant'
  content: string
}

const props = defineProps<{
  problemId: number
  language: string
  code: string
}>()

// 记录上一道用过 AI 的题目，切题时提示上下文不会保存
const CONTEXT_STORAGE_KEY = 'theseus-ai-context-problem'
const preferenceStore = usePreferenceStore()
const showSwitchNotice = ref(false)

const messages = ref<ChatEntry[]>([])
const input = ref('')
const loading = ref(false)
const error = ref('')
const listRef = ref<HTMLElement | null>(null)
let sequence = 0

const scrollToBottom = async (): Promise<void> => {
  await nextTick()
  const list = listRef.value
  if (list) list.scrollTop = list.scrollHeight
}

watch(() => messages.value.length, (length) => {
  try {
    if (length > 0) {
      sessionStorage.setItem(CONTEXT_STORAGE_KEY, String(props.problemId))
    } else {
      sessionStorage.removeItem(CONTEXT_STORAGE_KEY)
    }
  } catch {
    // 存储不可用时只影响提醒，不影响对话
  }
  void scrollToBottom()
})

onMounted(() => {
  try {
    const previous = sessionStorage.getItem(CONTEXT_STORAGE_KEY)
    if (previous && Number(previous) !== props.problemId) {
      sessionStorage.removeItem(CONTEXT_STORAGE_KEY)
      showSwitchNotice.value = preferenceStore.editorAiContextNotice
    }
  } catch {
    // 存储不可用时不做提醒
  }
})

const dismissSwitchNotice = (): void => {
  showSwitchNotice.value = false
  preferenceStore.setEditorAiContextNotice(false)
}

const ask = async (): Promise<void> => {
  if (loading.value) return
  const text = input.value.trim()
  if (!text) return
  input.value = ''
  error.value = ''
  messages.value.push({ id: ++sequence, role: 'user', content: text })
  loading.value = true
  try {
    const reply = await sendAiMessage({
      problem_id: props.problemId,
      language: props.language,
      code: props.code,
      messages: messages.value.map(({ role, content }) => ({ role, content })),
    })
    messages.value.push({ id: ++sequence, role: 'assistant', content: reply.content })
  } catch (exception: unknown) {
    // 失败时撤回这条提问，避免重试产生重复上下文
    messages.value.pop()
    input.value = text
    error.value = toErrorMessage(exception)
  } finally {
    loading.value = false
  }
}

const clear = (): void => {
  messages.value = []
  error.value = ''
}

const onKeydown = (event: KeyboardEvent): void => {
  if (event.key !== 'Enter' || event.shiftKey || event.isComposing) return
  event.preventDefault()
  void ask()
}
</script>

<template>
  <section class="ai-assistant" aria-label="LosAngelous 特供ai服务">
    <header class="ai-assistant-head">
      <h2>LosAngelous 特供ai服务</h2>
      <button
        v-if="messages.length"
        type="button"
        class="ai-assistant-clear"
        :disabled="loading"
        @click="clear"
      >
        清空
      </button>
    </header>

    <div v-if="showSwitchNotice" class="ai-context-notice">
      <span>切换题目后 AI 上下文不会保存</span>
      <button type="button" @click="dismissSwitchNotice">下次不再提醒</button>
    </div>

    <div ref="listRef" class="ai-assistant-list">
      <article
        v-for="message in messages"
        :key="message.id"
        :class="['ai-assistant-message', `is-${message.role}`]"
      >
        <span class="ai-assistant-role">{{ message.role === 'user' ? '我' : 'AI' }}</span>
        <p v-if="message.role === 'user'" class="ai-assistant-text">{{ message.content }}</p>
        <MarkdownBody v-else :content="message.content" />
      </article>
      <div v-if="loading" class="ai-assistant-loading" aria-live="polite">思考中</div>
    </div>

    <p v-if="error" class="form-error" role="alert">{{ error }}</p>

    <form class="ai-assistant-composer" @submit.prevent="ask()">
      <textarea
        v-model="input"
        rows="2"
        :disabled="loading"
        placeholder="描述你的问题"
        aria-label="向 AI 助手提问"
        @keydown="onKeydown"
      ></textarea>
      <div class="ai-assistant-actions">
        <button type="submit" class="primary-button" :disabled="loading || !input.trim()">
          发送
        </button>
      </div>
    </form>
  </section>
</template>
