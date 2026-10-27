import type { ThemeMode } from '../types/profile'

const STORAGE_KEY = 'theseus-theme'
const media = window.matchMedia('(prefers-color-scheme: dark)')

export const getThemeMode = (): ThemeMode => {
  const saved = localStorage.getItem(STORAGE_KEY)
  return saved === 'light' || saved === 'dark' || saved === 'system' ? saved : 'system'
}

const resolvedMode = (mode: ThemeMode): 'light' | 'dark' =>
  mode === 'system' ? (media.matches ? 'dark' : 'light') : mode

export const applyTheme = (mode: ThemeMode): void => {
  localStorage.setItem(STORAGE_KEY, mode)
  document.documentElement.dataset.theme = resolvedMode(mode)
}

export const initTheme = (): void => {
  applyTheme(getThemeMode())
  media.addEventListener('change', () => {
    if (getThemeMode() === 'system') applyTheme('system')
  })
}

export const toggleTheme = (): 'light' | 'dark' => {
  const next = resolvedMode(getThemeMode()) === 'dark' ? 'light' : 'dark'
  applyTheme(next)
  return next
}

export const isDarkTheme = (): boolean =>
  document.documentElement.dataset.theme === 'dark'
