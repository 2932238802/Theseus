<script setup lang="ts">
import { computed, nextTick, ref } from 'vue'
import MarkdownBody from './MarkdownBody.vue'
import {
  insertMarkdownLink,
  prefixMarkdownLines,
  resolveMarkdownShortcut,
  wrapMarkdownSelection,
  type MarkdownEditResult,
  type MarkdownLinePrefix,
  type MarkdownSelection,
} from '../utils/markdownEditor'

const props = withDefaults(
  defineProps<{
    modelValue: string
    placeholder?: string
    maxlength?: number
    rows?: number
    disabled?: boolean
  }>(),
  {
    placeholder: '支持 Markdown 语法',
    maxlength: 20000,
    rows: 18,
    disabled: false,
  },
)

const emit = defineEmits<{
  'update:modelValue': [value: string]
}>()

const textareaRef = ref<HTMLTextAreaElement | null>(null)
const mode = ref<'edit' | 'preview'>('edit')
const composing = ref(false)
const lastSelection = ref<{ start: number; end: number } | null>(null)

const count = computed(() => (props.modelValue ?? '').length)
const isPreview = computed(() => mode.value === 'preview')
const hasContent = computed(() => (props.modelValue ?? '').trim().length > 0)

const readSelection = (): MarkdownSelection | null => {
  const element = textareaRef.value
  if (!element) return null
  return {
    value: props.modelValue ?? '',
    selectionStart: element.selectionStart,
    selectionEnd: element.selectionEnd,
  }
}

const applyResult = (result: MarkdownEditResult): void => {
  emit('update:modelValue', result.text)
  void nextTick(() => {
    const element = textareaRef.value
    if (!element) return
    element.focus()
    const start = Math.min(result.selectionStart, element.value.length)
    const end = Math.min(result.selectionEnd, element.value.length)
    element.setSelectionRange(start, end)
  })
}

const edit = (transform: (selection: MarkdownSelection) => MarkdownEditResult): void => {
  if (props.disabled || isPreview.value) return
  const selection = readSelection()
  if (!selection) return
  applyResult(transform(selection))
}

const wrap = (before: string, after: string, placeholder: string): void => {
  edit((selection) => wrapMarkdownSelection(selection, before, after, placeholder))
}

const prefix = (kind: MarkdownLinePrefix): void => {
  edit((selection) => prefixMarkdownLines(selection, kind))
}

const insertLink = (): void => {
  edit(insertMarkdownLink)
}

const onInput = (event: Event): void => {
  emit('update:modelValue', (event.target as HTMLTextAreaElement).value)
}

const onKeydown = (event: KeyboardEvent): void => {
  if (props.disabled || isPreview.value) return
  const shortcut = resolveMarkdownShortcut({
    key: event.key,
    ctrlKey: event.ctrlKey,
    metaKey: event.metaKey,
    altKey: event.altKey,
    shiftKey: event.shiftKey,
    isComposing: event.isComposing || composing.value,
    keyCode: event.keyCode,
  })
  if (!shortcut) return
  event.preventDefault()
  if (shortcut === 'bold') wrap('**', '**', '加粗文字')
  else if (shortcut === 'italic') wrap('*', '*', '斜体文字')
  else insertLink()
}

const onCompositionStart = (): void => {
  composing.value = true
}

const onCompositionEnd = (): void => {
  composing.value = false
}

const togglePreview = (): void => {
  if (isPreview.value) {
    mode.value = 'edit'
    void nextTick(() => {
      const element = textareaRef.value
      if (!element) return
      element.focus()
      const max = element.value.length
      const start = lastSelection.value?.start ?? max
      const end = lastSelection.value?.end ?? max
      element.setSelectionRange(Math.min(start, max), Math.min(end, max))
    })
    return
  }

  const element = textareaRef.value
  if (element) lastSelection.value = { start: element.selectionStart, end: element.selectionEnd }
  mode.value = 'preview'
}
</script>

<template>
  <div class="md-editor" :class="{ 'is-preview': isPreview }">
    <div class="md-editor-toolbar" role="toolbar" aria-label="Markdown 编辑工具栏">
      <button
        type="button"
        class="md-editor-tool md-editor-tool-strong"
        title="加粗（Ctrl/Cmd+B）"
        aria-label="加粗"
        :disabled="disabled || isPreview"
        @click="wrap('**', '**', '加粗文字')"
      >
        B
      </button>
      <button
        type="button"
        class="md-editor-tool md-editor-tool-italic"
        title="斜体（Ctrl/Cmd+I）"
        aria-label="斜体"
        :disabled="disabled || isPreview"
        @click="wrap('*', '*', '斜体文字')"
      >
        I
      </button>
      <button
        type="button"
        class="md-editor-tool"
        title="标题"
        aria-label="标题"
        :disabled="disabled || isPreview"
        @click="prefix('heading')"
      >
        H
      </button>
      <button
        type="button"
        class="md-editor-tool"
        title="无序列表"
        aria-label="无序列表"
        :disabled="disabled || isPreview"
        @click="prefix('unordered-list')"
      >
        • 列表
      </button>
      <button
        type="button"
        class="md-editor-tool"
        title="有序列表"
        aria-label="有序列表"
        :disabled="disabled || isPreview"
        @click="prefix('ordered-list')"
      >
        1. 列表
      </button>
      <button
        type="button"
        class="md-editor-tool"
        title="引用"
        aria-label="引用"
        :disabled="disabled || isPreview"
        @click="prefix('quote')"
      >
        引用
      </button>
      <button
        type="button"
        class="md-editor-tool"
        title="行内代码"
        aria-label="行内代码"
        :disabled="disabled || isPreview"
        @click="wrap('`', '`', '代码')"
      >
        代码
      </button>
      <button
        type="button"
        class="md-editor-tool"
        title="插入链接（Ctrl/Cmd+K）"
        aria-label="插入链接"
        :disabled="disabled || isPreview"
        @click="insertLink"
      >
        链接
      </button>
      <span class="md-editor-spacer"></span>
      <span class="md-editor-count">{{ count }} / {{ maxlength }}</span>
      <button
        type="button"
        class="md-editor-tool md-editor-preview-toggle"
        :class="{ active: isPreview }"
        :aria-pressed="isPreview"
        @click="togglePreview"
      >
        {{ isPreview ? '返回编辑' : '预览' }}
      </button>
    </div>

    <textarea
      v-if="!isPreview"
      ref="textareaRef"
      class="md-editor-textarea"
      :value="modelValue"
      :placeholder="placeholder"
      :maxlength="maxlength"
      :rows="rows"
      :disabled="disabled"
      spellcheck="false"
      @input="onInput"
      @keydown="onKeydown"
      @compositionstart="onCompositionStart"
      @compositionend="onCompositionEnd"
    ></textarea>
    <div v-else class="md-editor-preview" aria-live="polite">
      <MarkdownBody v-if="hasContent" :content="modelValue" />
      <p v-else class="md-editor-empty">暂无内容可预览</p>
    </div>
  </div>
</template>
