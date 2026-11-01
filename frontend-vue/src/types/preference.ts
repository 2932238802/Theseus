import type { EditorThemeChoice } from '../utils/monacoTheme'
import type { Language } from './oj'
import type { ThemeMode } from './profile'

export type EditorTabSize = 'auto' | 2 | 4 | 8

export interface PreferenceDefaults {
  appearanceTheme: ThemeMode
  editorTheme: EditorThemeChoice
  editorFontSize: number
  editorTabSize: EditorTabSize
  editorCompletion: boolean
  problemLanguage: Language
  problemPageSize: number
  shortcutBindings: Record<string, string | null>
}
