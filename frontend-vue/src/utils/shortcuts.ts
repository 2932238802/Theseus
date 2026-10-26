import type { Monaco } from '@monaco-editor/loader'

export type ShortcutScope = 'editor' | 'oj'
export type ShortcutGroup = 'run' | 'search' | 'edit' | 'view' | 'system'

export interface ShortcutAction {
  id: string
  label: string
  group: ShortcutGroup
  scope: ShortcutScope
  defaultKey: string | null
  customizable: boolean
  monacoCommand?: string
  note?: string
}

export interface ParsedShortcut {
  mod: boolean
  shift: boolean
  alt: boolean
  key: string
}

export interface CapturedShortcut {
  value: string | null
  reason?: 'modifier-required' | 'unsupported-key' | 'alt-graph' | 'invalid-modifiers'
}

export const SHORTCUT_GROUP_LABELS: Record<ShortcutGroup, string> = {
  run: '运行与提交',
  search: '查找与替换',
  edit: '编辑',
  view: '视图',
  system: '系统键',
}

export const SHORTCUT_GROUP_ORDER: ShortcutGroup[] = ['run', 'search', 'edit', 'view', 'system']

export const SHORTCUT_ACTIONS: ShortcutAction[] = [
  {
    id: 'oj.run',
    label: '运行代码',
    group: 'run',
    scope: 'oj',
    defaultKey: 'Mod+Enter',
    customizable: true,
    note: '有公开用例时直接运行 否则打开自定义输入',
  },
  {
    id: 'oj.submit',
    label: '提交代码',
    group: 'run',
    scope: 'oj',
    defaultKey: 'Mod+Shift+Enter',
    customizable: true,
  },
  {
    id: 'oj.toggle-output',
    label: '展开/收起结果',
    group: 'view',
    scope: 'oj',
    defaultKey: 'Mod+`',
    customizable: true,
  },
  {
    id: 'oj.reset-code',
    label: '重置代码',
    group: 'run',
    scope: 'oj',
    defaultKey: null,
    customizable: true,
  },
  {
    id: 'oj.open-shortcuts',
    label: '快捷键面板',
    group: 'view',
    scope: 'oj',
    defaultKey: null,
    customizable: true,
  },
  {
    id: 'editor.find',
    label: '查找',
    group: 'search',
    scope: 'editor',
    defaultKey: 'Mod+F',
    customizable: true,
    monacoCommand: 'actions.find',
  },
  {
    id: 'editor.replace',
    label: '替换',
    group: 'search',
    scope: 'editor',
    defaultKey: 'Mod+H',
    customizable: true,
    monacoCommand: 'editor.action.startFindReplaceAction',
  },
  {
    id: 'editor.comment-line',
    label: '切换行注释',
    group: 'edit',
    scope: 'editor',
    defaultKey: 'Mod+/',
    customizable: true,
    monacoCommand: 'editor.action.commentLine',
  },
  {
    id: 'editor.format-document',
    label: '格式化文档',
    group: 'edit',
    scope: 'editor',
    defaultKey: 'Shift+Alt+F',
    customizable: true,
    monacoCommand: 'editor.action.formatDocument',
    note: '仅对支持格式化的语言生效',
  },
  {
    id: 'editor.copy-line-down',
    label: '向下复制行',
    group: 'edit',
    scope: 'editor',
    defaultKey: 'Shift+Alt+ArrowDown',
    customizable: true,
    monacoCommand: 'editor.action.copyLinesDownAction',
  },
  {
    id: 'editor.move-line-up',
    label: '上移行',
    group: 'edit',
    scope: 'editor',
    defaultKey: 'Alt+ArrowUp',
    customizable: true,
    monacoCommand: 'editor.action.moveLinesUpAction',
  },
  {
    id: 'editor.move-line-down',
    label: '下移行',
    group: 'edit',
    scope: 'editor',
    defaultKey: 'Alt+ArrowDown',
    customizable: true,
    monacoCommand: 'editor.action.moveLinesDownAction',
  },
  {
    id: 'editor.delete-line',
    label: '删除行',
    group: 'edit',
    scope: 'editor',
    defaultKey: 'Mod+Shift+K',
    customizable: true,
    monacoCommand: 'editor.action.deleteLines',
  },
  {
    id: 'editor.select-next-occurrence',
    label: '选中下一个相同项',
    group: 'edit',
    scope: 'editor',
    defaultKey: 'Mod+D',
    customizable: true,
    monacoCommand: 'editor.action.addSelectionToNextFindMatch',
  },
]

export const READONLY_SHORTCUTS: ShortcutAction[] = [
  { id: 'system.undo', label: '撤销', group: 'system', scope: 'editor', defaultKey: 'Mod+Z', customizable: false },
  {
    id: 'system.redo',
    label: '重做',
    group: 'system',
    scope: 'editor',
    defaultKey: 'Mod+Shift+Z',
    customizable: false,
    note: 'Windows 也可用 Ctrl+Y',
  },
  { id: 'system.cut', label: '剪切', group: 'system', scope: 'editor', defaultKey: 'Mod+X', customizable: false },
  { id: 'system.copy', label: '复制', group: 'system', scope: 'editor', defaultKey: 'Mod+C', customizable: false },
  { id: 'system.paste', label: '粘贴', group: 'system', scope: 'editor', defaultKey: 'Mod+V', customizable: false },
  { id: 'system.select-all', label: '全选', group: 'system', scope: 'editor', defaultKey: 'Mod+A', customizable: false },
  { id: 'system.indent', label: '增加缩进', group: 'system', scope: 'editor', defaultKey: 'Tab', customizable: false },
  { id: 'system.outdent', label: '减少缩进', group: 'system', scope: 'editor', defaultKey: 'Shift+Tab', customizable: false },
  { id: 'system.command-palette', label: '命令面板', group: 'system', scope: 'editor', defaultKey: 'F1', customizable: false },
  { id: 'system.goto-line', label: '跳转到行', group: 'system', scope: 'editor', defaultKey: 'Mod+G', customizable: false },
  {
    id: 'system.add-cursor-above',
    label: '添加上方光标',
    group: 'system',
    scope: 'editor',
    defaultKey: 'Mod+Alt+ArrowUp',
    customizable: false,
  },
  {
    id: 'system.add-cursor-below',
    label: '添加下方光标',
    group: 'system',
    scope: 'editor',
    defaultKey: 'Mod+Alt+ArrowDown',
    customizable: false,
  },
  {
    id: 'system.word-left',
    label: '按词向左移动',
    group: 'system',
    scope: 'editor',
    defaultKey: 'Mod+ArrowLeft',
    customizable: false,
  },
  {
    id: 'system.word-right',
    label: '按词向右移动',
    group: 'system',
    scope: 'editor',
    defaultKey: 'Mod+ArrowRight',
    customizable: false,
  },
  {
    id: 'system.select-word-left',
    label: '按词向左选择',
    group: 'system',
    scope: 'editor',
    defaultKey: 'Mod+Shift+ArrowLeft',
    customizable: false,
  },
  {
    id: 'system.select-word-right',
    label: '按词向右选择',
    group: 'system',
    scope: 'editor',
    defaultKey: 'Mod+Shift+ArrowRight',
    customizable: false,
  },
  {
    id: 'system.document-start',
    label: '文档开头',
    group: 'system',
    scope: 'editor',
    defaultKey: 'Mod+Home',
    customizable: false,
  },
  {
    id: 'system.document-end',
    label: '文档末尾',
    group: 'system',
    scope: 'editor',
    defaultKey: 'Mod+End',
    customizable: false,
  },
  {
    id: 'system.select-document-start',
    label: '选择到文档开头',
    group: 'system',
    scope: 'editor',
    defaultKey: 'Mod+Shift+Home',
    customizable: false,
  },
  {
    id: 'system.select-document-end',
    label: '选择到文档末尾',
    group: 'system',
    scope: 'editor',
    defaultKey: 'Mod+Shift+End',
    customizable: false,
  },
  { id: 'system.line-start', label: '行首', group: 'system', scope: 'editor', defaultKey: 'Home', customizable: false },
  { id: 'system.line-end', label: '行尾', group: 'system', scope: 'editor', defaultKey: 'End', customizable: false },
  {
    id: 'system.select-line-start',
    label: '选择到行首',
    group: 'system',
    scope: 'editor',
    defaultKey: 'Shift+Home',
    customizable: false,
  },
  {
    id: 'system.select-line-end',
    label: '选择到行尾',
    group: 'system',
    scope: 'editor',
    defaultKey: 'Shift+End',
    customizable: false,
  },
  {
    id: 'system.page-up',
    label: '向上翻页',
    group: 'system',
    scope: 'editor',
    defaultKey: 'PageUp',
    customizable: false,
  },
  {
    id: 'system.page-down',
    label: '向下翻页',
    group: 'system',
    scope: 'editor',
    defaultKey: 'PageDown',
    customizable: false,
  },
  {
    id: 'system.delete-word-left',
    label: '删除左侧单词',
    group: 'system',
    scope: 'editor',
    defaultKey: 'Mod+Backspace',
    customizable: false,
  },
  {
    id: 'system.delete-word-right',
    label: '删除右侧单词',
    group: 'system',
    scope: 'editor',
    defaultKey: 'Mod+Delete',
    customizable: false,
  },
  {
    id: 'system.scroll-up',
    label: '向上滚动',
    group: 'system',
    scope: 'editor',
    defaultKey: 'Mod+ArrowUp',
    customizable: false,
  },
  {
    id: 'system.scroll-down',
    label: '向下滚动',
    group: 'system',
    scope: 'editor',
    defaultKey: 'Mod+ArrowDown',
    customizable: false,
  },
]

export const ALL_SHORTCUT_ACTIONS: ShortcutAction[] = [...SHORTCUT_ACTIONS, ...READONLY_SHORTCUTS]

const ALLOWED_KEYS = new Set<string>([
  ...'ABCDEFGHIJKLMNOPQRSTUVWXYZ'.split(''),
  ...'0123456789'.split(''),
  'Enter',
  'Escape',
  'Tab',
  'Space',
  'Backspace',
  'Delete',
  'Home',
  'End',
  'PageUp',
  'PageDown',
  'ArrowUp',
  'ArrowDown',
  'ArrowLeft',
  'ArrowRight',
  'F1',
  'F2',
  'F3',
  'F4',
  'F5',
  'F6',
  'F7',
  'F8',
  'F9',
  'F10',
  'F11',
  'F12',
  '/',
  '\\',
  '`',
  '-',
  '=',
  '[',
  ']',
  ';',
  "'",
  ',',
  '.',
])

const CUSTOM_KEYS = new Set<string>([...ALLOWED_KEYS].filter((key) => !['F1', 'F5', 'F11', 'F12'].includes(key)))

const KEY_CODE_NAMES: Record<string, string> = {
  ...Object.fromEntries('ABCDEFGHIJKLMNOPQRSTUVWXYZ'.split('').map((letter) => [letter, `Key${letter}`])),
  ...Object.fromEntries('0123456789'.split('').map((digit) => [digit, `Digit${digit}`])),
  Enter: 'Enter',
  Escape: 'Escape',
  Tab: 'Tab',
  Space: 'Space',
  Backspace: 'Backspace',
  Delete: 'Delete',
  Home: 'Home',
  End: 'End',
  PageUp: 'PageUp',
  PageDown: 'PageDown',
  ArrowUp: 'UpArrow',
  ArrowDown: 'DownArrow',
  ArrowLeft: 'LeftArrow',
  ArrowRight: 'RightArrow',
  '/': 'Slash',
  '\\': 'Backslash',
  '`': 'Backquote',
  '-': 'Minus',
  '=': 'Equal',
  '[': 'BracketLeft',
  ']': 'BracketRight',
  ';': 'Semicolon',
  "'": 'Quote',
  ',': 'Comma',
  '.': 'Period',
  F1: 'F1',
  F2: 'F2',
  F3: 'F3',
  F4: 'F4',
  F5: 'F5',
  F6: 'F6',
  F7: 'F7',
  F8: 'F8',
  F9: 'F9',
  F10: 'F10',
  F11: 'F11',
  F12: 'F12',
}

const KEY_FROM_EVENT_CODE: Record<string, string> = {
  ...Object.fromEntries(
    'ABCDEFGHIJKLMNOPQRSTUVWXYZ'.split('').map((letter) => [`Key${letter}`, letter]),
  ),
  ...Object.fromEntries('0123456789'.split('').map((digit) => [`Digit${digit}`, digit])),
  Enter: 'Enter',
  NumpadEnter: 'Enter',
  Escape: 'Escape',
  Tab: 'Tab',
  Space: 'Space',
  Backspace: 'Backspace',
  Delete: 'Delete',
  Home: 'Home',
  End: 'End',
  PageUp: 'PageUp',
  PageDown: 'PageDown',
  ArrowUp: 'ArrowUp',
  ArrowDown: 'ArrowDown',
  ArrowLeft: 'ArrowLeft',
  ArrowRight: 'ArrowRight',
  Slash: '/',
  Backslash: '\\',
  IntlBackslash: '\\',
  Backquote: '`',
  Minus: '-',
  Equal: '=',
  BracketLeft: '[',
  BracketRight: ']',
  Semicolon: ';',
  Quote: "'",
  Comma: ',',
  Period: '.',
  F1: 'F1',
  F2: 'F2',
  F3: 'F3',
  F4: 'F4',
  F5: 'F5',
  F6: 'F6',
  F7: 'F7',
  F8: 'F8',
  F9: 'F9',
  F10: 'F10',
  F11: 'F11',
  F12: 'F12',
}

const MODIFIER_CODES = new Set([
  'ControlLeft',
  'ControlRight',
  'ShiftLeft',
  'ShiftRight',
  'AltLeft',
  'AltRight',
  'MetaLeft',
  'MetaRight',
  'CapsLock',
  'NumLock',
  'ScrollLock',
])

const KEY_DISPLAY: Record<string, string> = {
  ArrowUp: '↑',
  ArrowDown: '↓',
  ArrowLeft: '←',
  ArrowRight: '→',
  Space: 'Space',
  Escape: 'Esc',
  Delete: 'Del',
  PageUp: 'PgUp',
  PageDown: 'PgDn',
}

const BROWSER_RESERVED = new Set<string>([
  'Mod+W',
  'Mod+Shift+W',
  'Mod+T',
  'Mod+Shift+T',
  'Mod+N',
  'Mod+Shift+N',
  'Mod+R',
  'Mod+Shift+R',
  'Mod+L',
  'Mod+O',
  'Mod+Shift+O',
  'Mod+S',
  'Mod+Shift+S',
  'Mod+P',
  'Mod+Shift+P',
  'Mod+Shift+I',
  'Mod+Shift+J',
  'Mod+Shift+C',
  'Mod+Shift+K',
  'Mod+Space',
  'Alt+Space',
  'F5',
  'F11',
  'F12',
  'Alt+F4',
  'Alt+Tab',
  'Mod+Tab',
  ...'123456789'.split('').map((digit) => `Mod+${digit}`),
])

const OJ_BROWSER_RESERVED = new Set<string>([
  'Mod+D',
  'Mod+F',
  'Mod+H',
  'Mod+G',
  'Mod+Shift+L',
  'Mod+Shift+E',
  'Mod+Shift+F',
])

const EDITOR_BROWSER_DEFAULTS = new Set<string>(['Mod+D', 'Mod+F', 'Mod+H', 'Mod+G', 'Mod+Shift+K'])

const RESERVED_EXTRA = new Set<string>([
  'Mod+Y',
  'Mod+Shift+ArrowUp',
  'Mod+Shift+ArrowDown',
  'Mod+Shift+PageUp',
  'Mod+Shift+PageDown',
  'Mod+Shift+Backspace',
  'Mod+Shift+Delete',
])

const RESERVED_SHORTCUTS = new Set<string>([
  ...READONLY_SHORTCUTS.map((action) => action.defaultKey).filter((key): key is string => Boolean(key)),
  ...RESERVED_EXTRA,
])

export const resolveBinding = (
  action: ShortcutAction,
  bindings: Record<string, string | null> | undefined,
): string | null => {
  if (!bindings || !(action.id in bindings)) return action.defaultKey
  return bindings[action.id]
}

export const parseShortcut = (value: string): ParsedShortcut | null => {
  const parts = value.split('+')
  const key = parts.pop()
  if (!key || !ALLOWED_KEYS.has(key)) return null
  let mod = false
  let shift = false
  let alt = false
  for (const part of parts) {
    if (part === 'Mod') {
      if (mod) return null
      mod = true
    } else if (part === 'Shift') {
      if (shift) return null
      shift = true
    } else if (part === 'Alt') {
      if (alt) return null
      alt = true
    } else {
      return null
    }
  }
  return { mod, shift, alt, key }
}

export const formatShortcut = (shortcut: ParsedShortcut): string => {
  const parts: string[] = []
  if (shortcut.mod) parts.push('Mod')
  if (shortcut.shift) parts.push('Shift')
  if (shortcut.alt) parts.push('Alt')
  parts.push(shortcut.key)
  return parts.join('+')
}

export const canonicalizeShortcut = (value: string): string | null => {
  const parsed = parseShortcut(value)
  return parsed ? formatShortcut(parsed) : null
}

export const sameShortcut = (left: string, right: string): boolean => {
  const leftParsed = parseShortcut(left)
  const rightParsed = parseShortcut(right)
  if (!leftParsed || !rightParsed) return false
  return (
    leftParsed.mod === rightParsed.mod &&
    leftParsed.shift === rightParsed.shift &&
    leftParsed.alt === rightParsed.alt &&
    leftParsed.key === rightParsed.key
  )
}

export const isMacPlatform = (): boolean =>
  typeof navigator !== 'undefined' && /Mac|iPhone|iPad|iPod/.test(navigator.userAgent)

export const displayShortcut = (value: string | null, isMac = isMacPlatform()): string => {
  if (!value) return '未绑定'
  const parsed = parseShortcut(value)
  if (!parsed) return value
  const parts: string[] = []
  if (parsed.mod) parts.push(isMac ? '⌘' : 'Ctrl')
  if (parsed.shift) parts.push('Shift')
  if (parsed.alt) parts.push(isMac ? '⌥' : 'Alt')
  parts.push(KEY_DISPLAY[parsed.key] ?? parsed.key)
  return parts.join('+')
}

export const toMonacoKeybinding = (monaco: Monaco, value: string): number | null => {
  const parsed = parseShortcut(value)
  if (!parsed) return null
  const keyCodeName = KEY_CODE_NAMES[parsed.key]
  if (!keyCodeName) return null
  const keyCode = (monaco.KeyCode as unknown as Record<string, number>)[keyCodeName]
  if (typeof keyCode !== 'number') return null
  let binding = keyCode
  if (parsed.mod) binding |= monaco.KeyMod.CtrlCmd
  if (parsed.shift) binding |= monaco.KeyMod.Shift
  if (parsed.alt) binding |= monaco.KeyMod.Alt
  return binding
}

export const isModifierKeyEvent = (event: KeyboardEvent): boolean => MODIFIER_CODES.has(event.code)

export const shortcutFromKeyboardEvent = (event: KeyboardEvent): CapturedShortcut => {
  if (event.isComposing || event.key === 'Process' || event.key === 'Dead') {
    return { value: null, reason: 'unsupported-key' }
  }
  if (event.getModifierState?.('AltGraph')) return { value: null, reason: 'alt-graph' }
  if (MODIFIER_CODES.has(event.code)) return { value: null, reason: 'modifier-required' }
  const key = KEY_FROM_EVENT_CODE[event.code]
  if (!key) return { value: null, reason: 'unsupported-key' }
  if (event.ctrlKey && event.metaKey) return { value: null, reason: 'invalid-modifiers' }
  const mod = event.ctrlKey || event.metaKey
  const alt = event.altKey
  if (!mod && !alt) return { value: null, reason: 'modifier-required' }
  return { value: formatShortcut({ mod, shift: event.shiftKey, alt, key }) }
}

export const matchesShortcut = (event: KeyboardEvent, value: string): boolean => {
  const parsed = parseShortcut(value)
  if (!parsed || event.isComposing) return false
  if (event.getModifierState?.('AltGraph')) return false
  if (event.ctrlKey && event.metaKey) return false
  if (KEY_FROM_EVENT_CODE[event.code] !== parsed.key) return false
  if ((event.ctrlKey || event.metaKey) !== parsed.mod) return false
  if (event.shiftKey !== parsed.shift) return false
  if (event.altKey !== parsed.alt) return false
  return true
}

const isBrowserReserved = (value: string, scope: ShortcutScope): boolean => {
  if (scope === 'editor' && EDITOR_BROWSER_DEFAULTS.has(value)) return false
  if (scope === 'oj' && OJ_BROWSER_RESERVED.has(value)) return true
  return BROWSER_RESERVED.has(value)
}

export const validateShortcut = (
  action: ShortcutAction,
  value: string,
  bindings: Record<string, string | null>,
): string | null => {
  const parsed = parseShortcut(value)
  if (!parsed) return '快捷键格式不正确'
  if (!parsed.mod && !parsed.alt) return '快捷键需要包含 Ctrl/⌘ 或 Alt'
  if (!CUSTOM_KEYS.has(parsed.key)) return '该按键不能作为快捷键'
  const canonical = formatShortcut(parsed)
  if (RESERVED_SHORTCUTS.has(canonical)) return '该快捷键不可修改'
  if (isBrowserReserved(canonical, action.scope)) return '该快捷键被浏览器占用'
  for (const other of SHORTCUT_ACTIONS) {
    if (other.id === action.id) continue
    const otherBinding = resolveBinding(other, bindings)
    if (otherBinding && sameShortcut(otherBinding, canonical)) return `与「${other.label}」冲突`
  }
  return null
}
