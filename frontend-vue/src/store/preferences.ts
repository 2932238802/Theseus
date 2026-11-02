import { computed, ref } from 'vue'
import { defineStore } from 'pinia'
import { clearPreferences, fetchPreferences, savePreferences } from '../api/preferences'
import { toErrorMessage } from '../api/client'
import { FONT_SIZE_MAX, FONT_SIZE_MIN, LANGUAGE_OPTIONS } from '../utils/constants'
import { isEditorThemeChoice } from '../utils/monacoTheme'
import { applyTheme, currentTheme, isThemeMode } from '../utils/theme'
import type { EditorThemeChoice } from '../utils/monacoTheme'
import type { EditorTabSize } from '../types/preference'
import type { Language } from '../types/oj'
import type { ThemeMode } from '../types/profile'
import { useAuthStore } from './auth'
import { onShortcutChange, useShortcutStore } from './shortcuts'

export const PREFERENCE_KEYS = {
  appearanceTheme: 'appearance.theme',
  editorTheme: 'editor.theme',
  editorFontSize: 'editor.font_size',
  editorTabSize: 'editor.tab_size',
  editorCompletion: 'editor.completion',
  editorAiAssistant: 'editor.ai_assistant',
  editorAiContextNotice: 'editor.ai_context_notice',
  problemLanguage: 'problems.language',
  problemPageSize: 'problems.page_size',
  shortcutBindings: 'shortcuts.bindings',
} as const

const LEGACY_KEYS = {
  theme: 'theseus-theme',
  editorTheme: 'theseus-editor-theme',
  fontSize: 'theseus-editor-font-size',
  completion: 'theseus-editor-completion',
  language: 'theseus-preferred-language',
  shortcuts: 'theseus-shortcuts-v1',
} as const

// 记录本机镜像设置属于哪个账号，避免换账号登录时把上一个人的设置迁移过去
const ACCOUNT_MARKER_KEY = 'theseus-preferences-account'

const DEFAULT_VALUES: Record<string, unknown> = {
  [PREFERENCE_KEYS.appearanceTheme]: 'system',
  [PREFERENCE_KEYS.editorTheme]: 'system',
  [PREFERENCE_KEYS.editorFontSize]: 14,
  [PREFERENCE_KEYS.editorTabSize]: 'auto',
  [PREFERENCE_KEYS.editorCompletion]: false,
  [PREFERENCE_KEYS.editorAiAssistant]: false,
  [PREFERENCE_KEYS.editorAiContextNotice]: true,
  [PREFERENCE_KEYS.problemLanguage]: 'cpp',
  [PREFERENCE_KEYS.problemPageSize]: 20,
  [PREFERENCE_KEYS.shortcutBindings]: {},
}

const FONT_SIZES: [number, number] = [FONT_SIZE_MIN, FONT_SIZE_MAX]
const PAGE_SIZES = [20, 50, 100]
const TAB_SIZES = [2, 4, 8]

const isLanguage = (value: unknown): value is Language =>
  typeof value === 'string' && LANGUAGE_OPTIONS.some((option) => option.value === value)

const isTabSize = (value: unknown): value is EditorTabSize =>
  value === 'auto' || (typeof value === 'number' && TAB_SIZES.includes(value))

const isFontSize = (value: unknown): value is number =>
  typeof value === 'number' &&
  Number.isInteger(value) &&
  value >= FONT_SIZES[0] &&
  value <= FONT_SIZES[1]

const isPageSize = (value: unknown): value is number =>
  typeof value === 'number' && PAGE_SIZES.includes(value)

const isBindings = (value: unknown): value is Record<string, string | null> => {
  if (typeof value !== 'object' || value === null || Array.isArray(value)) return false
  return Object.values(value).every((entry) => entry === null || typeof entry === 'string')
}

const sanitize = (key: string, value: unknown): unknown => {
  switch (key) {
    case PREFERENCE_KEYS.appearanceTheme:
      return isThemeMode(value) ? value : undefined
    case PREFERENCE_KEYS.editorTheme:
      return isEditorThemeChoice(value) ? value : undefined
    case PREFERENCE_KEYS.editorFontSize:
      return isFontSize(value) ? value : undefined
    case PREFERENCE_KEYS.editorTabSize:
      return isTabSize(value) ? value : undefined
    case PREFERENCE_KEYS.editorCompletion:
      return typeof value === 'boolean' ? value : undefined
    case PREFERENCE_KEYS.editorAiAssistant:
      return typeof value === 'boolean' ? value : undefined
    case PREFERENCE_KEYS.editorAiContextNotice:
      return typeof value === 'boolean' ? value : undefined
    case PREFERENCE_KEYS.problemLanguage:
      return isLanguage(value) ? value : undefined
    case PREFERENCE_KEYS.problemPageSize:
      return isPageSize(value) ? value : undefined
    case PREFERENCE_KEYS.shortcutBindings:
      return isBindings(value) ? value : undefined
    default:
      return undefined
  }
}

const sanitizeAll = (source: Record<string, unknown>): Record<string, unknown> => {
  const result: Record<string, unknown> = {}
  for (const key of Object.values(PREFERENCE_KEYS)) {
    const value = sanitize(key, source[key])
    if (value !== undefined) result[key] = value
  }
  return result
}

const readLegacyValues = (): Record<string, unknown> => {
  const values: Record<string, unknown> = {}
  try {
    const theme = localStorage.getItem(LEGACY_KEYS.theme)
    if (isThemeMode(theme)) values[PREFERENCE_KEYS.appearanceTheme] = theme

    const editorTheme = localStorage.getItem(LEGACY_KEYS.editorTheme)
    if (isEditorThemeChoice(editorTheme)) values[PREFERENCE_KEYS.editorTheme] = editorTheme

    const fontText = localStorage.getItem(LEGACY_KEYS.fontSize)
    const fontSize = fontText === null ? null : Number(fontText)
    if (isFontSize(fontSize)) values[PREFERENCE_KEYS.editorFontSize] = fontSize

    const completion = localStorage.getItem(LEGACY_KEYS.completion)
    if (completion === 'on' || completion === 'off') {
      values[PREFERENCE_KEYS.editorCompletion] = completion === 'on'
    }

    const language = localStorage.getItem(LEGACY_KEYS.language)
    if (isLanguage(language)) values[PREFERENCE_KEYS.problemLanguage] = language

    const shortcutText = localStorage.getItem(LEGACY_KEYS.shortcuts)
    if (shortcutText) {
      const stored = JSON.parse(shortcutText) as { version?: unknown; bindings?: unknown }
      if (stored.version === 1 && isBindings(stored.bindings)) {
        values[PREFERENCE_KEYS.shortcutBindings] = stored.bindings
      }
    }
  } catch {
    // 本地存储被禁用时直接使用默认值
  }
  return values
}

export const usePreferenceStore = defineStore('preferences', () => {
  const authStore = useAuthStore()
  const shortcutStore = useShortcutStore()

  const values = ref<Record<string, unknown>>({
    ...DEFAULT_VALUES,
    ...readLegacyValues(),
    [PREFERENCE_KEYS.shortcutBindings]: { ...shortcutStore.overrides },
  })
  const loadedUserId = ref<number | null>(null)
  const isLoading = ref(false)
  const saveState = ref<'idle' | 'saving' | 'saved' | 'error'>('idle')
  const error = ref('')

  let loadPromise: Promise<void> | null = null
  let suppressSync = false
  let pending: Record<string, unknown> = {}
  let saveTimer: number | undefined

  const appearanceTheme = computed<ThemeMode>(() =>
    isThemeMode(values.value[PREFERENCE_KEYS.appearanceTheme])
      ? (values.value[PREFERENCE_KEYS.appearanceTheme] as ThemeMode)
      : 'system',
  )
  const editorTheme = computed<EditorThemeChoice>(() =>
    isEditorThemeChoice(values.value[PREFERENCE_KEYS.editorTheme])
      ? (values.value[PREFERENCE_KEYS.editorTheme] as EditorThemeChoice)
      : 'system',
  )
  const editorFontSize = computed<number>(() =>
    isFontSize(values.value[PREFERENCE_KEYS.editorFontSize])
      ? (values.value[PREFERENCE_KEYS.editorFontSize] as number)
      : 14,
  )
  const editorTabSize = computed<EditorTabSize>(() =>
    isTabSize(values.value[PREFERENCE_KEYS.editorTabSize])
      ? (values.value[PREFERENCE_KEYS.editorTabSize] as EditorTabSize)
      : 'auto',
  )
  const editorCompletion = computed<boolean>(() =>
    values.value[PREFERENCE_KEYS.editorCompletion] === true,
  )
  const editorAiAssistant = computed<boolean>(() =>
    values.value[PREFERENCE_KEYS.editorAiAssistant] === true,
  )
  const editorAiContextNotice = computed<boolean>(() =>
    values.value[PREFERENCE_KEYS.editorAiContextNotice] !== false,
  )
  const problemLanguage = computed<Language>(() =>
    isLanguage(values.value[PREFERENCE_KEYS.problemLanguage])
      ? (values.value[PREFERENCE_KEYS.problemLanguage] as Language)
      : 'cpp',
  )
  const problemPageSize = computed<number>(() =>
    isPageSize(values.value[PREFERENCE_KEYS.problemPageSize])
      ? (values.value[PREFERENCE_KEYS.problemPageSize] as number)
      : 20,
  )
  const isLoaded = computed(
    () => authStore.user !== null && loadedUserId.value === authStore.user.id,
  )

  const mirrorLocal = (key: string, value: unknown): void => {
    try {
      switch (key) {
        case PREFERENCE_KEYS.appearanceTheme:
          if (isThemeMode(value)) applyTheme(value)
          break
        case PREFERENCE_KEYS.editorTheme:
          if (typeof value === 'string') localStorage.setItem(LEGACY_KEYS.editorTheme, value)
          break
        case PREFERENCE_KEYS.editorFontSize:
          if (typeof value === 'number') localStorage.setItem(LEGACY_KEYS.fontSize, String(value))
          break
        case PREFERENCE_KEYS.editorCompletion:
          localStorage.setItem(LEGACY_KEYS.completion, value === true ? 'on' : 'off')
          break
        case PREFERENCE_KEYS.problemLanguage:
          if (typeof value === 'string') localStorage.setItem(LEGACY_KEYS.language, value)
          break
        default:
          break
      }
    } catch {
      // 本地存储不可用时以服务端与内存值为准
    }
  }

  const flush = async (): Promise<void> => {
    window.clearTimeout(saveTimer)
    saveTimer = undefined
    const batch = pending
    pending = {}
    if (!authStore.isAuthenticated || Object.keys(batch).length === 0) return
    saveState.value = 'saving'
    error.value = ''
    const before = { ...values.value }
    try {
      const remote = await savePreferences(batch)
      // 请求期间又改了别的项时，保留本地较新的值
      const merged = { ...values.value }
      for (const [key, value] of Object.entries(sanitizeAll(remote))) {
        if (key in pending) continue
        if (JSON.stringify(values.value[key]) !== JSON.stringify(before[key])) continue
        merged[key] = value
      }
      values.value = merged
      saveState.value = Object.keys(pending).length ? 'saving' : 'saved'
    } catch (exception: unknown) {
      error.value = toErrorMessage(exception)
      saveState.value = 'error'
    }
  }

  const queueSave = (entries: Record<string, unknown>): void => {
    if (suppressSync || !authStore.isAuthenticated) return
    const userId = authStore.user?.id
    if (userId) {
      try {
        localStorage.setItem(ACCOUNT_MARKER_KEY, String(userId))
      } catch {
        // 标记只用于避免跨账号迁移，写不进去时不影响本次同步
      }
    }
    pending = { ...pending, ...entries }
    saveState.value = 'saving'
    window.clearTimeout(saveTimer)
    saveTimer = window.setTimeout(() => {
      void flush()
    }, 350)
  }

  const setValue = (key: string, value: unknown): void => {
    if (JSON.stringify(values.value[key]) === JSON.stringify(value)) return
    values.value = { ...values.value, [key]: value }
    mirrorLocal(key, value)
    queueSave({ [key]: value })
  }

  const setAppearanceTheme = (value: ThemeMode): void =>
    setValue(PREFERENCE_KEYS.appearanceTheme, value)
  const setEditorTheme = (value: EditorThemeChoice): void =>
    setValue(PREFERENCE_KEYS.editorTheme, value)
  const setEditorFontSize = (value: number): void => {
    const clamped = Math.min(FONT_SIZES[1], Math.max(FONT_SIZES[0], Math.round(value)))
    setValue(PREFERENCE_KEYS.editorFontSize, clamped)
  }
  const setEditorTabSize = (value: EditorTabSize): void =>
    setValue(PREFERENCE_KEYS.editorTabSize, value)
  const setEditorCompletion = (value: boolean): void =>
    setValue(PREFERENCE_KEYS.editorCompletion, value)
  const setEditorAiAssistant = (value: boolean): void =>
    setValue(PREFERENCE_KEYS.editorAiAssistant, value)
  const setEditorAiContextNotice = (value: boolean): void =>
    setValue(PREFERENCE_KEYS.editorAiContextNotice, value)
  const setProblemLanguage = (value: Language): void =>
    setValue(PREFERENCE_KEYS.problemLanguage, value)
  const setProblemPageSize = (value: number): void =>
    setValue(PREFERENCE_KEYS.problemPageSize, value)
  const toggleAppearanceTheme = (): void =>
    setAppearanceTheme(currentTheme.value === 'dark' ? 'light' : 'dark')

  const load = async (force = false): Promise<void> => {
    const userId = authStore.user?.id
    if (!userId) return
    if (!force && loadedUserId.value === userId) return
    if (loadPromise) return loadPromise
    isLoading.value = true
    error.value = ''
    loadPromise = (async () => {
      try {
        const before = { ...values.value }
        const remote = sanitizeAll(await fetchPreferences())
        // 拉取期间用户改过的键保留本地值，其余键采用账号值
        const merged = { ...values.value }
        const applied: Record<string, unknown> = {}
        for (const [key, value] of Object.entries(remote)) {
          if (JSON.stringify(values.value[key]) !== JSON.stringify(before[key])) continue
          merged[key] = value
          applied[key] = value
        }
        if (PREFERENCE_KEYS.shortcutBindings in applied) {
          suppressSync = true
          shortcutStore.applyOverrides(applied[PREFERENCE_KEYS.shortcutBindings])
          suppressSync = false
          merged[PREFERENCE_KEYS.shortcutBindings] = { ...shortcutStore.overrides }
        }
        values.value = merged
        for (const key of [
          PREFERENCE_KEYS.appearanceTheme,
          PREFERENCE_KEYS.editorTheme,
          PREFERENCE_KEYS.editorFontSize,
          PREFERENCE_KEYS.editorCompletion,
          PREFERENCE_KEYS.problemLanguage,
        ]) {
          if (key in applied) mirrorLocal(key, applied[key])
        }
        // 首次登录把本机已有个性化设置同步到账号，避免换设备后丢失
        let marker: string | null = null
        try {
          marker = localStorage.getItem(ACCOUNT_MARKER_KEY)
        } catch {
          marker = null
        }
        const canMigrate = marker === null || marker === String(userId)
        const localOnly: Record<string, unknown> = {}
        if (canMigrate) {
          for (const [key, value] of Object.entries(readLegacyValues())) {
            if (!(key in remote)) localOnly[key] = value
          }
        }
        if (Object.keys(remote).length > 0 || canMigrate) {
          try {
            localStorage.setItem(ACCOUNT_MARKER_KEY, String(userId))
          } catch {
            // 标记写不进去时只影响下次迁移判断
          }
        }
        if (Object.keys(localOnly).length) {
          pending = { ...pending, ...localOnly }
          saveState.value = 'saving'
          window.clearTimeout(saveTimer)
          saveTimer = window.setTimeout(() => {
            void flush()
          }, 0)
        }
        loadedUserId.value = userId
      } catch (exception: unknown) {
        error.value = toErrorMessage(exception)
        saveState.value = 'error'
      } finally {
        isLoading.value = false
        loadPromise = null
      }
    })()
    return loadPromise
  }

  const resetSession = (): void => {
    loadedUserId.value = null
    window.clearTimeout(saveTimer)
    saveTimer = undefined
    pending = {}
    saveState.value = 'idle'
    error.value = ''
    values.value = {
      ...DEFAULT_VALUES,
      ...readLegacyValues(),
      [PREFERENCE_KEYS.shortcutBindings]: { ...shortcutStore.overrides },
    }
  }

  const resetAll = async (): Promise<void> => {
    suppressSync = true
    values.value = {
      ...DEFAULT_VALUES,
      [PREFERENCE_KEYS.shortcutBindings]: {},
    }
    for (const key of [
      PREFERENCE_KEYS.appearanceTheme,
      PREFERENCE_KEYS.editorTheme,
      PREFERENCE_KEYS.editorFontSize,
      PREFERENCE_KEYS.editorCompletion,
      PREFERENCE_KEYS.problemLanguage,
    ]) {
      mirrorLocal(key, values.value[key])
    }
    shortcutStore.resetAll()
    suppressSync = false
    window.clearTimeout(saveTimer)
    saveTimer = undefined
    pending = {}
    saveState.value = 'saving'
    error.value = ''
    try {
      await clearPreferences()
      saveState.value = 'saved'
    } catch (exception: unknown) {
      error.value = toErrorMessage(exception)
      saveState.value = 'error'
    }
  }

  // 快捷键面板修改后同步到账号
  onShortcutChange(() => {
    if (suppressSync) return
    setValue(PREFERENCE_KEYS.shortcutBindings, { ...shortcutStore.overrides })
  })

  return {
    values,
    isLoading,
    isLoaded,
    saveState,
    error,
    appearanceTheme,
    editorTheme,
    editorFontSize,
    editorTabSize,
    editorCompletion,
    editorAiAssistant,
    editorAiContextNotice,
    problemLanguage,
    problemPageSize,
    load,
    flush,
    resetSession,
    resetAll,
    setAppearanceTheme,
    setEditorTheme,
    setEditorFontSize,
    setEditorTabSize,
    setEditorCompletion,
    setEditorAiAssistant,
    setEditorAiContextNotice,
    setProblemLanguage,
    setProblemPageSize,
    toggleAppearanceTheme,
  }
})
