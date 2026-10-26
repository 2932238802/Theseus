import { computed, ref } from 'vue'
import { defineStore } from 'pinia'
import {
  SHORTCUT_ACTIONS,
  canonicalizeShortcut,
  formatShortcut,
  parseShortcut,
  resolveBinding,
  sameShortcut,
  validateShortcut,
  type ShortcutAction,
} from '../utils/shortcuts'

export const SHORTCUT_STORAGE_KEY = 'theseus-shortcuts-v1'
const STORAGE_VERSION = 1

interface StoredShortcuts {
  version: number
  bindings: Record<string, string | null>
}

const getStorage = (): Storage | null => {
  try {
    return window.localStorage
  } catch {
    return null
  }
}

const findAction = (id: string): ShortcutAction | undefined =>
  SHORTCUT_ACTIONS.find((action) => action.id === id)

const readStoredBindings = (): Record<string, string | null> => {
  const storage = getStorage()
  if (!storage) return {}
  const raw = storage.getItem(SHORTCUT_STORAGE_KEY)
  if (!raw) return {}
  let stored: StoredShortcuts
  try {
    stored = JSON.parse(raw) as StoredShortcuts
  } catch {
    return {}
  }
  if (!stored || stored.version !== STORAGE_VERSION || typeof stored.bindings !== 'object' || !stored.bindings) {
    return {}
  }

  const working: Record<string, string | null> = {}
  for (const action of SHORTCUT_ACTIONS) working[action.id] = action.defaultKey
  const accepted: Record<string, string | null> = {}
  const entries = Object.entries(stored.bindings)

  // Apply explicit unbinds first so a key freed in storage can be reused regardless of key order.
  for (const [id, rawValue] of entries) {
    if (rawValue !== null) continue
    const action = findAction(id)
    if (!action || action.defaultKey === null) continue
    working[id] = null
    accepted[id] = null
  }

  for (const [id, rawValue] of entries) {
    if (typeof rawValue !== 'string') continue
    const action = findAction(id)
    if (!action) continue
    const parsed = parseShortcut(rawValue)
    if (!parsed) continue
    const canonical = formatShortcut(parsed)
    if (canonical === action.defaultKey) continue
    if (validateShortcut(action, canonical, working)) continue
    working[id] = canonical
    accepted[id] = canonical
  }
  return accepted
}

export const useShortcutStore = defineStore('shortcuts', () => {
  const overrides = ref<Record<string, string | null>>(readStoredBindings())

  const resolved = computed<Record<string, string | null>>(() => {
    const result: Record<string, string | null> = {}
    for (const action of SHORTCUT_ACTIONS) {
      result[action.id] = action.id in overrides.value ? overrides.value[action.id] : action.defaultKey
    }
    return result
  })

  const persist = (): void => {
    const storage = getStorage()
    if (!storage) return
    try {
      if (Object.keys(overrides.value).length === 0) {
        storage.removeItem(SHORTCUT_STORAGE_KEY)
        return
      }
      const payload: StoredShortcuts = { version: STORAGE_VERSION, bindings: overrides.value }
      storage.setItem(SHORTCUT_STORAGE_KEY, JSON.stringify(payload))
    } catch {
      // Storage can be full or blocked; keep the in-memory setting.
    }
  }

  const setBinding = (actionId: string, value: string): string | null => {
    const action = findAction(actionId)
    if (!action) return '未知动作'
    const canonical = canonicalizeShortcut(value)
    if (!canonical) return '快捷键格式不正确'
    const error = validateShortcut(action, canonical, resolved.value)
    if (error) return error
    if (canonical === action.defaultKey) delete overrides.value[actionId]
    else overrides.value[actionId] = canonical
    persist()
    return null
  }

  const unbind = (actionId: string): void => {
    const action = findAction(actionId)
    if (!action) return
    if (action.defaultKey === null) delete overrides.value[actionId]
    else overrides.value[actionId] = null
    persist()
  }

  const resetBinding = (actionId: string): string | null => {
    const action = findAction(actionId)
    if (!action) return '未知动作'
    if (action.defaultKey) {
      for (const other of SHORTCUT_ACTIONS) {
        if (other.id === actionId) continue
        const binding = resolveBinding(other, resolved.value)
        if (binding && sameShortcut(binding, action.defaultKey)) {
          return `默认键与「${other.label}」冲突，请先修改「${other.label}」`
        }
      }
    }
    delete overrides.value[actionId]
    persist()
    return null
  }

  const resetAll = (): void => {
    overrides.value = {}
    const storage = getStorage()
    try {
      storage?.removeItem(SHORTCUT_STORAGE_KEY)
    } catch {
      // Ignore blocked storage.
    }
  }

  const isCustomized = (actionId: string): boolean => {
    const action = findAction(actionId)
    if (!action || !(actionId in overrides.value)) return false
    return overrides.value[actionId] !== action.defaultKey
  }

  return {
    overrides,
    resolved,
    setBinding,
    unbind,
    resetBinding,
    resetAll,
    isCustomized,
  }
})
