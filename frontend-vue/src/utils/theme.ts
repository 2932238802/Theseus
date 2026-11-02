import { ref } from 'vue'
import type { ThemeMode } from '../types/profile'

const STORAGE_KEY = 'theseus-theme'
const media = window.matchMedia('(prefers-color-scheme: dark)')

export type ResolvedTheme = Exclude<ThemeMode, 'system'>

export interface ThemeOption {
  value: ResolvedTheme
  label: string
  dark: boolean
  /** 设置页色卡用的三个代表色，不需要与 CSS 变量严格一一对应 */
  swatch: { bg: string; surface: string; accent: string; text: string }
}

// 全站配色参考 VS Code 的常见主题；浅色在前，设置页会按 dark 字段分组。
export const THEME_OPTIONS: ThemeOption[] = [
  {
    value: 'light',
    label: 'Light+',
    dark: false,
    swatch: { bg: '#e9e9ee', surface: '#f7f7f9', accent: '#4a4a5c', text: '#24242c' },
  },
  {
    value: 'github-light',
    label: 'GitHub Light',
    dark: false,
    swatch: { bg: '#ffffff', surface: '#f6f8fa', accent: '#0969da', text: '#24292f' },
  },
  {
    value: 'solarized-light',
    label: 'Solarized Light',
    dark: false,
    swatch: { bg: '#fdf6e3', surface: '#eee8d5', accent: '#268bd2', text: '#4b5f66' },
  },
  {
    value: 'dark',
    label: 'Dark+',
    dark: true,
    swatch: { bg: '#1c1c1c', surface: '#38384a', accent: '#b3b6bd', text: '#f2f2f2' },
  },
  {
    value: 'one-dark',
    label: 'One Dark',
    dark: true,
    swatch: { bg: '#282c34', surface: '#21252b', accent: '#61afef', text: '#abb2bf' },
  },
  {
    value: 'monokai',
    label: 'Monokai',
    dark: true,
    swatch: { bg: '#272822', surface: '#2f3029', accent: '#ff6188', text: '#f8f8f2' },
  },
  {
    value: 'dracula',
    label: 'Dracula',
    dark: true,
    swatch: { bg: '#282a36', surface: '#2f3142', accent: '#bd93f9', text: '#f8f8f2' },
  },
  {
    value: 'nord',
    label: 'Nord',
    dark: true,
    swatch: { bg: '#2e3440', surface: '#3b4252', accent: '#88c0d0', text: '#eceff4' },
  },
  {
    value: 'tokyo-night',
    label: 'Tokyo Night',
    dark: true,
    swatch: { bg: '#1a1b26', surface: '#24283b', accent: '#7aa2f7', text: '#c0caf5' },
  },
  {
    value: 'github-dark',
    label: 'GitHub Dark',
    dark: true,
    swatch: { bg: '#0d1117', surface: '#161b22', accent: '#58a6ff', text: '#e6edf3' },
  },
]

export const THEME_GROUPS = [
  { label: '浅色', options: THEME_OPTIONS.filter((option) => !option.dark) },
  { label: '深色', options: THEME_OPTIONS.filter((option) => option.dark) },
]

export const SYSTEM_THEME_LABEL = '跟随系统'

const DARK_THEMES = new Set<ResolvedTheme>(
  THEME_OPTIONS.filter((option) => option.dark).map((option) => option.value),
)
const THEME_VALUES = new Set<string>(['system', ...THEME_OPTIONS.map((option) => option.value)])

export const isThemeMode = (value: unknown): value is ThemeMode =>
  typeof value === 'string' && THEME_VALUES.has(value)

const resolveTheme = (mode: ThemeMode, systemDark: boolean): ResolvedTheme =>
  mode === 'system' ? (systemDark ? 'dark' : 'light') : mode

export const getThemeMode = (): ThemeMode => {
  const saved = localStorage.getItem(STORAGE_KEY)
  return isThemeMode(saved) ? saved : 'system'
}

// 当前生效的深浅基色：编辑器「跟随全站主题」、导航图标等只需要知道深浅
export const currentTheme = ref<'light' | 'dark'>(
  DARK_THEMES.has(resolveTheme(getThemeMode(), media.matches)) ? 'dark' : 'light',
)

// 当前生效的主题 id，用来让编辑器跟随具体的 VS Code 配色
export const currentThemeId = ref<ResolvedTheme>(
  resolveTheme(getThemeMode(), media.matches),
)

export const applyTheme = (mode: ThemeMode): void => {
  localStorage.setItem(STORAGE_KEY, mode)
  const resolved = resolveTheme(mode, media.matches)
  document.documentElement.dataset.theme = resolved
  currentThemeId.value = resolved
  currentTheme.value = DARK_THEMES.has(resolved) ? 'dark' : 'light'
}

export const initTheme = (): void => {
  applyTheme(getThemeMode())
  media.addEventListener('change', () => {
    if (getThemeMode() === 'system') applyTheme('system')
  })
}

export const toggleTheme = (): 'light' | 'dark' => {
  const next = currentTheme.value === 'dark' ? 'light' : 'dark'
  applyTheme(next)
  return next
}

export const isDarkTheme = (): boolean => currentTheme.value === 'dark'
