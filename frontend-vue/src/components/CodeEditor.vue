<script setup lang="ts">
import { computed, nextTick, onBeforeUnmount, onMounted, ref, watch } from 'vue'
import loader from '@monaco-editor/loader'
import type { editor } from 'monaco-editor'
import { LANGUAGE_OPTIONS } from '../utils/constants'
import type { Language } from '../types/oj'

const props = defineProps<{
  modelValue: string
  language: Language
  fontSize: number
  dark: boolean
}>()
const emit = defineEmits<{
  'update:modelValue': [value: string]
}>()

const container = ref<HTMLElement | null>(null)
let monacoEditor: editor.IStandaloneCodeEditor | undefined
let resizeObserver: ResizeObserver | undefined
const monacoLanguage = computed(() => LANGUAGE_OPTIONS.find((item) => item.value === props.language)?.monaco ?? 'javascript')

onMounted(async () => {
  await nextTick()
  if (!container.value) return
  const monaco = await loader.init()
  const instance = monaco.editor.create(container.value, {
    value: props.modelValue,
    language: monacoLanguage.value,
    theme: props.dark ? 'vs-dark' : 'vs',
    fontSize: props.fontSize,
    fontFamily: 'JetBrains Mono, Consolas, monospace',
    minimap: { enabled: false },
    automaticLayout: true,
    padding: { top: 16, bottom: 16 },
    scrollBeyondLastLine: false,
    lineNumbersMinChars: 3,
    tabSize: 2,
  })
  monacoEditor = instance
  instance.onDidChangeModelContent(() => emit('update:modelValue', instance.getValue()))
  resizeObserver = new ResizeObserver(() => instance.layout())
  resizeObserver.observe(container.value)
})

watch(() => props.modelValue, (value) => {
  if (monacoEditor && monacoEditor.getValue() !== value) monacoEditor.setValue(value)
})
watch(monacoLanguage, (language) => {
  if (monacoEditor) loader.init().then((monaco) => monaco.editor.setModelLanguage(monacoEditor?.getModel()!, language))
})
watch(() => props.fontSize, (fontSize) => monacoEditor?.updateOptions({ fontSize }))
watch(() => props.dark, (dark) => loader.init().then((monaco) => monaco.editor.setTheme(dark ? 'vs-dark' : 'vs')))

onBeforeUnmount(() => {
  resizeObserver?.disconnect()
  monacoEditor?.dispose()
})
</script>

<template>
  <div ref="container" class="code-editor" aria-label="代码编辑器"></div>
</template>
