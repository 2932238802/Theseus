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
import { registerMonacoThemes } from '../utils/monacoTheme'
import {
  createLspSession,
  isLspLanguage,
  type LspSession,
  type LspStatus,
} from '../utils/lspClient'

const props = defineProps<{
  modelValue: string
  language: Language
  fontSize: number
  theme: string
  lspEnabled: boolean
  shortcutBindings?: Record<string, string | null>
}>()
const emit = defineEmits<{
  'update:modelValue': [value: string]
  shortcut: [actionId: string]
  pasteText: [text: string]
  lspStatus: [status: LspStatus | 'off']
}>()

// 编辑器静态资源随前端一起部署，不再依赖公网 CDN
loader.config({ paths: { vs: `${import.meta.env.BASE_URL}monaco/vs` } })

const container = ref<HTMLElement | null>(null)
const status = ref<'loading' | 'ready' | 'error'>('loading')
let monacoEditor: editor.IStandaloneCodeEditor | undefined
let monacoApi: Monaco | undefined
let shortcutRuleDisposable: { dispose: () => void } | undefined
let commandDisposables: Array<{ dispose: () => void }> = []
let completionKeyRuleDisposable: { dispose: () => void } | undefined
let lspSession: LspSession | undefined
let lspGeneration = 0
let lspSignature = 'off'
let commandPrefix = ''
let disposed = false

const monacoLanguage = computed(() => LANGUAGE_OPTIONS.find((item) => item.value === props.language)?.monaco ?? 'javascript')
// Python 惯例 4 空格，其余语言保持 2 空格
const tabSize = computed(() => (props.language === 'python' ? 4 : 2))

// 关闭补全时同时关掉自动建议和参数提示，避免残留零散弹窗
const completionOptions = (
  enabled: boolean,
): editor.IEditorOptions & editor.IGlobalEditorOptions => ({
  quickSuggestions: enabled ? { other: true, comments: false, strings: false } : false,
  suggestOnTriggerCharacters: enabled,
  // 有语言服务时只显示语义结果，关掉 Monaco 自带的单词补全
  wordBasedSuggestions: 'off',
  parameterHints: { enabled },
  tabCompletion: enabled ? 'on' : 'off',
  acceptSuggestionOnEnter: enabled ? 'on' : 'off',
  snippetSuggestions: enabled ? 'inline' : 'none',
})

const applyCompletionKeyRule = (monaco: Monaco, enabled: boolean): void => {
  // 关闭时连 Ctrl+Space 手动触发也一并禁用
  completionKeyRuleDisposable?.dispose()
  completionKeyRuleDisposable = undefined
  if (!enabled) {
    completionKeyRuleDisposable = monaco.editor.addKeybindingRules([
      {
        keybinding: monaco.KeyMod.CtrlCmd | monaco.KeyCode.Space,
        command: null,
        when: 'editorTextFocus',
      },
    ])
  }
}

const syncLsp = (): void => {
  // 语言与开关同时变化时两个 watcher 都会触发，用签名去重
  const signature =
    props.lspEnabled && monacoApi && monacoEditor && isLspLanguage(props.language)
      ? props.language
      : 'off'
  if (signature === lspSignature) return
  lspSignature = signature
  lspGeneration += 1
  const generation = lspGeneration
  lspSession?.dispose()
  lspSession = undefined
  emit('lspStatus', 'off')
  if (signature === 'off') return
  const model = monacoEditor?.getModel()
  if (!model) return
  lspSession = createLspSession({
    monaco: monacoApi as Monaco,
    model,
    language: signature,
    onStatus: (status) => {
      if (generation === lspGeneration) emit('lspStatus', status)
    },
  })
}

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

const initialize = async (): Promise<void> => {
  await nextTick()
  if (disposed || !container.value) return
  try {
    const monaco = await loader.init()
    // 加载期间组件可能已经卸载，此时不能再创建编辑器
    if (disposed || !container.value) return
    monacoApi = monaco
    registerMonacoThemes(monaco)
    const instance = monaco.editor.create(container.value, {
      value: props.modelValue,
      language: monacoLanguage.value,
      theme: props.theme,
      fontSize: props.fontSize,
      fontFamily: "'JetBrains Mono', Consolas, monospace",
      ariaLabel: '代码编辑器',
      minimap: { enabled: false },
      automaticLayout: true,
      padding: { top: 16, bottom: 16 },
      scrollBeyondLastLine: false,
      lineNumbersMinChars: 3,
      tabSize: tabSize.value,
      insertSpaces: true,
      renderLineHighlight: 'line',
      cursorBlinking: 'smooth',
      smoothScrolling: true,
      scrollbar: { verticalScrollbarSize: 10, horizontalScrollbarSize: 10 },
      ...completionOptions(props.lspEnabled),
    })
    monacoEditor = instance
    registerShortcutCommands(monaco)
    applyShortcutRules()
    applyCompletionKeyRule(monaco, props.lspEnabled)
    instance.onDidChangeModelContent(() => emit('update:modelValue', instance.getValue()))
    status.value = 'ready'
    syncLsp()
  } catch (error: unknown) {
    if (disposed) return
    status.value = 'error'
    console.error('编辑器加载失败', error)
  }
}

onMounted(() => {
  if (!container.value) return
  container.value.addEventListener('paste', onPaste)
  void initialize()
})

// 外部整体替换代码时保留撤销栈和光标位置（重置、载入历史提交、切换草稿）
watch(() => props.modelValue, (value) => {
  const instance = monacoEditor
  const model = instance?.getModel()
  if (!instance || !model || model.getValue() === value) return
  const position = instance.getPosition()
  instance.pushUndoStop()
  instance.executeEdits('theseus-replace-value', [
    { range: model.getFullModelRange(), text: value, forceMoveMarkers: true },
  ])
  instance.pushUndoStop()
  if (position) instance.setPosition(position)
})
watch(monacoLanguage, (language) => {
  const model = monacoEditor?.getModel()
  if (!model || !monacoApi) return
  monacoApi.editor.setModelLanguage(model, language)
  model.updateOptions({ tabSize: tabSize.value, insertSpaces: true })
  syncLsp()
})
watch(() => props.fontSize, (fontSize) => monacoEditor?.updateOptions({ fontSize }))
watch(() => props.theme, (theme) => {
  monacoApi?.editor.setTheme(theme)
})
watch(() => props.lspEnabled, (enabled) => {
  monacoEditor?.updateOptions(completionOptions(enabled))
  if (monacoApi) applyCompletionKeyRule(monacoApi, enabled)
  syncLsp()
})
watch(() => props.shortcutBindings, applyShortcutRules, { deep: true })

const focus = (): void => monacoEditor?.focus()
const reload = (): void => window.location.reload()

defineExpose({ focus })

onBeforeUnmount(() => {
  disposed = true
  container.value?.removeEventListener('paste', onPaste)
  shortcutRuleDisposable?.dispose()
  shortcutRuleDisposable = undefined
  for (const disposable of commandDisposables) disposable.dispose()
  commandDisposables = []
  completionKeyRuleDisposable?.dispose()
  completionKeyRuleDisposable = undefined
  lspGeneration += 1
  lspSession?.dispose()
  lspSession = undefined
  monacoEditor?.dispose()
  monacoEditor = undefined
  monacoApi = undefined
})
</script>

<template>
  <div class="code-editor-shell" :aria-busy="status === 'loading'">
    <div ref="container" class="code-editor"></div>
    <p v-if="status === 'loading'" class="code-editor-status">正在加载编辑器</p>
    <div v-else-if="status === 'error'" class="code-editor-status is-error" role="alert">
      <span>编辑器加载失败</span>
      <button type="button" @click="reload">刷新页面</button>
    </div>
  </div>
</template>
