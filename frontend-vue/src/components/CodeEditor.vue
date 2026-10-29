<script lang="ts">
// Monaco command ids are global, so each mounted editor needs its own prefix.
let editorSequence = 0
</script>

<script setup lang="ts">
import { computed, nextTick, onBeforeUnmount, onMounted, ref, watch } from 'vue'
import loader, { type Monaco } from '@monaco-editor/loader'
import type { editor } from 'monaco-editor'
import { LANGUAGE_OPTIONS } from '../utils/constants'
import type { Language } from '../types/oj'
import { SHORTCUT_ACTIONS, resolveBinding, toMonacoKeybinding } from '../utils/shortcuts'

const props = defineProps<{
  modelValue: string
  language: Language
  fontSize: number
  dark: boolean
  shortcutBindings?: Record<string, string | null>
}>()
const emit = defineEmits<{
  'update:modelValue': [value: string]
  shortcut: [actionId: string]
  pasteText: [text: string]
}>()

const container = ref<HTMLElement | null>(null)
let monacoEditor: editor.IStandaloneCodeEditor | undefined
let monacoApi: Monaco | undefined
let resizeObserver: ResizeObserver | undefined
let shortcutRuleDisposable: { dispose: () => void } | undefined
let commandDisposables: Array<{ dispose: () => void }> = []
let commandPrefix = ''
const monacoLanguage = computed(() => LANGUAGE_OPTIONS.find((item) => item.value === props.language)?.monaco ?? 'javascript')

const commandId = (actionId: string): string => `${commandPrefix}${actionId}`

const registerShortcutCommands = (monaco: Monaco): void => {
  commandPrefix = `theseus.shortcut.${++editorSequence}.`
  for (const action of SHORTCUT_ACTIONS) {
    if (action.scope !== 'oj') continue
    commandDisposables.push(
      monaco.editor.addCommand({
        id: commandId(action.id),
        run: () => emit('shortcut', action.id),
      }),
    )
  }
}

const applyShortcutRules = (): void => {
  if (!monacoApi) return
  shortcutRuleDisposable?.dispose()
  shortcutRuleDisposable = undefined
  const bindings = props.shortcutBindings
  const rules: Array<{ keybinding: number; command?: string | null; when?: string | null }> = []

  for (const action of SHORTCUT_ACTIONS) {
    const binding = resolveBinding(action, bindings)
    if (action.scope === 'oj') {
      if (!binding) continue
      const keybinding = toMonacoKeybinding(monacoApi, binding)
      if (keybinding === null) continue
      rules.push({
        keybinding,
        command: commandId(action.id),
        when: 'editorTextFocus',
      })
      continue
    }
    if (!action.monacoCommand) continue
    if (!binding) {
      if (!action.defaultKey) continue
      const keybinding = toMonacoKeybinding(monacoApi, action.defaultKey)
      if (keybinding !== null) {
        rules.push({ keybinding, command: null, when: 'editorTextFocus' })
      }
      continue
    }
    if (binding === action.defaultKey) continue
    const keybinding = toMonacoKeybinding(monacoApi, binding)
    if (keybinding === null) continue
    rules.push({ keybinding, command: action.monacoCommand, when: 'editorTextFocus' })
    if (action.defaultKey) {
      const defaultKeybinding = toMonacoKeybinding(monacoApi, action.defaultKey)
      if (defaultKeybinding !== null) {
        rules.push({ keybinding: defaultKeybinding, command: null, when: 'editorTextFocus' })
      }
    }
  }

  if (rules.length) shortcutRuleDisposable = monacoApi.editor.addKeybindingRules(rules)
}

const onPaste = (event: ClipboardEvent): void => {
  const text = event.clipboardData?.getData('text/plain') ?? ''
  if (text) emit('pasteText', text)
}

onMounted(async () => {
  await nextTick()
  if (!container.value) return
  container.value.addEventListener('paste', onPaste)
  const monaco = await loader.init()
  monacoApi = monaco
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
  registerShortcutCommands(monaco)
  applyShortcutRules()
  instance.onDidChangeModelContent(() => emit('update:modelValue', instance.getValue()))
  resizeObserver = new ResizeObserver(() => instance.layout())
  resizeObserver.observe(container.value)
})

watch(() => props.modelValue, (value) => {
  if (monacoEditor && monacoEditor.getValue() !== value) monacoEditor.setValue(value)
})
watch(monacoLanguage, (language) => {
  if (monacoEditor) loader.init().then((monaco) => monaco.editor.setModelLanguage(monacoEditor!.getModel()!, language))
})
watch(() => props.fontSize, (fontSize) => monacoEditor?.updateOptions({ fontSize }))
watch(() => props.dark, (dark) => loader.init().then((monaco) => monaco.editor.setTheme(dark ? 'vs-dark' : 'vs')))
watch(() => props.shortcutBindings, applyShortcutRules, { deep: true })

const focus = (): void => monacoEditor?.focus()

defineExpose({ focus })

onBeforeUnmount(() => {
  container.value?.removeEventListener('paste', onPaste)
  resizeObserver?.disconnect()
  shortcutRuleDisposable?.dispose()
  shortcutRuleDisposable = undefined
  for (const disposable of commandDisposables) disposable.dispose()
  commandDisposables = []
  monacoEditor?.dispose()
  monacoEditor = undefined
  monacoApi = undefined
})
</script>

<template>
  <div ref="container" class="code-editor" aria-label="代码编辑器"></div>
</template>
