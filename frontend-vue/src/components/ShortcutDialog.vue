<script setup lang="ts">
import { computed, onBeforeUnmount, onMounted, ref } from 'vue'
import { useShortcutStore } from '../store/shortcuts'
import {
  ALL_SHORTCUT_ACTIONS,
  SHORTCUT_ACTIONS,
  SHORTCUT_GROUP_LABELS,
  SHORTCUT_GROUP_ORDER,
  displayShortcut,
  isModifierKeyEvent,
  shortcutFromKeyboardEvent,
  type ShortcutAction,
  type ShortcutGroup,
} from '../utils/shortcuts'

const emit = defineEmits<{
  close: []
}>()

type Tab = 'settings' | 'manual'

interface ShortcutActionGroup {
  key: ShortcutGroup
  label: string
  actions: ShortcutAction[]
}

const shortcutStore = useShortcutStore()
const activeTab = ref<Tab>('settings')
const capturingId = ref<string | null>(null)
const captureError = ref('')
const panelError = ref('')
const dialogRef = ref<HTMLElement | null>(null)
let captureListenerActive = false

const groupsFor = (actions: ShortcutAction[]): ShortcutActionGroup[] =>
  SHORTCUT_GROUP_ORDER.map((group) => ({
    key: group,
    label: SHORTCUT_GROUP_LABELS[group],
    actions: actions.filter((action) => action.group === group),
  })).filter((group) => group.actions.length > 0)

const settingsGroups = computed(() => groupsFor(SHORTCUT_ACTIONS))
const manualGroups = computed(() => groupsFor(ALL_SHORTCUT_ACTIONS))

const bindingOf = (action: ShortcutAction): string | null =>
  action.customizable
    ? action.id in shortcutStore.resolved
      ? shortcutStore.resolved[action.id]
      : action.defaultKey
    : action.defaultKey

const display = (value: string | null): string => displayShortcut(value)

const detachCapture = (): void => {
  if (!captureListenerActive) return
  window.removeEventListener('keydown', onCaptureKeydown, true)
  captureListenerActive = false
}

const cancelCapture = (): void => {
  detachCapture()
  capturingId.value = null
  captureError.value = ''
}

const startCapture = (actionId: string): void => {
  panelError.value = ''
  if (capturingId.value === actionId) {
    cancelCapture()
    return
  }
  cancelCapture()
  capturingId.value = actionId
  window.addEventListener('keydown', onCaptureKeydown, true)
  captureListenerActive = true
}

const captureErrorMessage = (reason: string | undefined): string => {
  if (reason === 'modifier-required') return '快捷键需要包含 Ctrl/⌘ 或 Alt'
  if (reason === 'alt-graph') return '该组合键不可用'
  if (reason === 'invalid-modifiers') return '不能同时使用 Ctrl 和 ⌘'
  return '该按键不能作为快捷键'
}

const onCaptureKeydown = (event: KeyboardEvent): void => {
  const actionId = capturingId.value
  if (!actionId) return
  event.preventDefault()
  event.stopPropagation()
  if (event.isComposing) return
  if (isModifierKeyEvent(event)) return
  if (event.key === 'Escape' && !event.ctrlKey && !event.metaKey && !event.altKey && !event.shiftKey) {
    cancelCapture()
    return
  }
  if (
    (event.key === 'Backspace' || event.key === 'Delete') &&
    !event.ctrlKey &&
    !event.metaKey &&
    !event.altKey &&
    !event.shiftKey
  ) {
    shortcutStore.unbind(actionId)
    cancelCapture()
    return
  }
  const captured = shortcutFromKeyboardEvent(event)
  if (!captured.value) {
    captureError.value = captureErrorMessage(captured.reason)
    return
  }
  const error = shortcutStore.setBinding(actionId, captured.value)
  if (error) {
    captureError.value = error
    return
  }
  cancelCapture()
}

const selectTab = (tab: Tab): void => {
  if (activeTab.value === tab) return
  cancelCapture()
  panelError.value = ''
  activeTab.value = tab
}

const resetOne = (actionId: string): void => {
  cancelCapture()
  panelError.value = shortcutStore.resetBinding(actionId) ?? ''
}

const resetAll = (): void => {
  if (!window.confirm('恢复全部默认快捷键？')) return
  cancelCapture()
  panelError.value = ''
  shortcutStore.resetAll()
}

const close = (): void => {
  cancelCapture()
  emit('close')
}

const onWindowBlur = (): void => {
  cancelCapture()
}

const onWindowKeydown = (event: KeyboardEvent): void => {
  if (event.key !== 'Escape' || event.isComposing || capturingId.value) return
  event.preventDefault()
  close()
}

onMounted(() => {
  window.addEventListener('blur', onWindowBlur)
  window.addEventListener('keydown', onWindowKeydown)
  dialogRef.value?.focus()
})

onBeforeUnmount(() => {
  window.removeEventListener('blur', onWindowBlur)
  window.removeEventListener('keydown', onWindowKeydown)
  detachCapture()
})
</script>

<template>
  <div class="modal-backdrop" @click.self="close">
    <section
      ref="dialogRef"
      class="run-dialog shortcut-dialog"
      role="dialog"
      aria-modal="true"
      aria-labelledby="shortcut-title"
      tabindex="-1"
      @keydown.esc.stop="close"
    >
      <header>
        <div>
          <h2 id="shortcut-title">快捷键</h2>
        </div>
        <button type="button" aria-label="关闭" @click="close">×</button>
      </header>

      <div class="shortcut-tabs" role="tablist" aria-label="快捷键视图">
        <button
          type="button"
          role="tab"
          :aria-selected="activeTab === 'settings'"
          :class="{ active: activeTab === 'settings' }"
          @click="selectTab('settings')"
        >
          设置
        </button>
        <button
          type="button"
          role="tab"
          :aria-selected="activeTab === 'manual'"
          :class="{ active: activeTab === 'manual' }"
          @click="selectTab('manual')"
        >
          手册
        </button>
      </div>

      <div class="run-dialog-body shortcut-body">
        <template v-if="activeTab === 'settings'">
          <p class="shortcut-hint">修改后立即生效，仅保存在当前浏览器。</p>
          <p v-if="panelError" class="shortcut-error" role="alert">{{ panelError }}</p>
          <section v-for="group in settingsGroups" :key="group.key" class="shortcut-group">
            <h3>{{ group.label }}</h3>
            <div
              v-for="action in group.actions"
              :key="action.id"
              class="shortcut-row"
              :class="{ capturing: capturingId === action.id }"
            >
              <div class="shortcut-row-label">
                <span>{{ action.label }}</span>
                <small v-if="action.note">{{ action.note }}</small>
              </div>
              <button
                type="button"
                class="shortcut-key"
                :class="{ capturing: capturingId === action.id }"
                :aria-label="`修改${action.label}快捷键`"
                @click="startCapture(action.id)"
              >
                {{ capturingId === action.id ? '按下新的组合键…' : display(bindingOf(action)) }}
              </button>
              <button
                v-if="shortcutStore.isCustomized(action.id)"
                type="button"
                class="teaching-link-button"
                @click="resetOne(action.id)"
              >
                重置
              </button>
              <span v-else class="shortcut-placeholder" aria-hidden="true"></span>
              <p v-if="capturingId === action.id && captureError" class="shortcut-error" role="alert">
                {{ captureError }}
              </p>
              <p v-else-if="capturingId === action.id" class="shortcut-capture-hint">
                Esc 取消，Backspace 解除绑定
              </p>
            </div>
          </section>
        </template>

        <template v-else>
          <section v-for="group in manualGroups" :key="group.key" class="shortcut-group">
            <h3>{{ group.label }}</h3>
            <div v-for="action in group.actions" :key="action.id" class="shortcut-manual-row">
              <div class="shortcut-row-label">
                <span>{{ action.label }}</span>
                <small v-if="action.note">{{ action.note }}</small>
              </div>
              <span class="shortcut-scope">{{ action.scope === 'editor' ? '编辑器（聚焦时）' : '题目页' }}</span>
              <kbd>{{ display(bindingOf(action)) }}</kbd>
              <span v-if="action.customizable && shortcutStore.isCustomized(action.id)" class="shortcut-badge">
                已自定义
              </span>
              <span v-else-if="!action.customizable" class="shortcut-badge readonly">只读</span>
              <span v-else class="shortcut-placeholder" aria-hidden="true"></span>
            </div>
          </section>
        </template>
      </div>

      <footer v-if="activeTab === 'settings'">
        <button class="teaching-secondary-button" type="button" @click="resetAll">全部恢复默认</button>
      </footer>
    </section>
  </div>
</template>
