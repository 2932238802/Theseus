<script setup lang="ts">
import { computed, nextTick, ref, watch } from 'vue'
import MarkdownBody from './MarkdownBody.vue'
import { sendAiMessage, type AiStatus } from '../api/ai'
import { toErrorMessage } from '../api/client'

interface ChatEntry {
  id: number
  role: 'user' | 'assistant'
  content: string
}

const props = defineProps<{
  problemId: number
  language: string
  code: string
  status: AiStatus | null
}>()

const emit = defineEmits<{ usage: [value: { daily_limit: number; used_today: number }] }>()

const SUGGESTIONS = ['解释题意', '分析我的代码问题', '给我一点提示', '复杂度怎么优化']

const messages = ref<ChatEntry[]>([])
const input = ref('')
const loading = ref(false)
const error = ref('')
const listRef = ref<HTMLElement | null>(null)
let sequence = 0

const enabled = computed(() => props.status?.enabled === true)
const remaining = computed(() => {
  if (!props.status) return null
  return Math.max(0, props.status.daily_limit - props.status.used_today)
})

const scrollToBottom = async (): Promise<void> => {
  await nextTick()
  const list = listRef.value
  if (list) list.scrollTop = list.scrollHeight
}

watch(() => messages.value.length, () => {
  void scrollToBottom()
})

const ask = async (preset?: string): Promise<void> => {
  if (loading.value) return
  const text = (preset ?? input.value).trim()
  if (!text) return
  if (!enabled.value) {
    error.value = 'AI 助手暂未开放'
    return
  }
  if (!preset) input.value = ''
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
    emit('usage', { daily_limit: reply.daily_limit, used_today: reply.used_today })
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
  <section class="ai-assistant" aria-label="AI 助手">
    <header class="ai-assistant-head">
      <div>
        <h2>AI 助手</h2>
        <p>AI 生成内容可能出错 请自行判断</p>
      </div>
      <span v-if="remaining !== null" class="ai-assistant-quota">今日剩余 {{ remaining }} 次</span>
    </header>

    <div v-if="!enabled" class="ai-assistant-empty">
      <p>AI 助手暂未开放</p>
      <p>请稍后再试</p>
    </div>

    <template v-else>
      <div ref="listRef" class="ai-assistant-list">
        <div v-if="!messages.length && !loading" class="ai-assistant-empty">
          <p>可以让我解释题意 分析你的代码 或者给一点提示</p>
          <div class="ai-assistant-suggestions">
            <button
              v-for="item in SUGGESTIONS"
              :key="item"
              type="button"
              class="ai-assistant-suggestion"
              @click="ask(item)"
            >
              {{ item }}
            </button>
          </div>
        </div>
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
          rows="3"
          :disabled="loading"
          placeholder="描述你的问题 例如 这段代码为什么只能过一半"
          aria-label="向 AI 助手提问"
          @keydown="onKeydown"
        ></textarea>
        <div class="ai-assistant-actions">
          <button v-if="messages.length" type="button" class="ai-assistant-clear" :disabled="loading" @click="clear">清空</button>
          <button type="submit" class="primary-button" :disabled="loading || !input.trim()">发送</button>
        </div>
      </form>
    </template>
  </section>
</template>
