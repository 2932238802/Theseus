/** Markdown 编辑器的纯函数逻辑，便于独立验证选区与快捷键判定。 */

export interface MarkdownSelection {
  value: string
  selectionStart: number
  selectionEnd: number
}

export interface MarkdownEditResult {
  text: string
  selectionStart: number
  selectionEnd: number
}

export type MarkdownShortcut = 'bold' | 'italic' | 'link'

export interface ShortcutKeyEvent {
  key: string
  ctrlKey?: boolean
  metaKey?: boolean
  altKey?: boolean
  shiftKey?: boolean
  isComposing?: boolean
  keyCode?: number
}

export type MarkdownLinePrefix = 'heading' | 'unordered-list' | 'ordered-list' | 'quote'

const clamp = (value: number, min: number, max: number): number =>
  Math.min(Math.max(value, min), max)

const normalizeRange = (
  value: string,
  selectionStart: number,
  selectionEnd: number,
): { start: number; end: number } => {
  const start = clamp(Math.min(selectionStart, selectionEnd), 0, value.length)
  const end = clamp(Math.max(selectionStart, selectionEnd), 0, value.length)
  return { start, end }
}

/** 在选区两侧包裹 Markdown 标记；无选区时插入占位文字并选中它。 */
export const wrapMarkdownSelection = (
  input: MarkdownSelection,
  before: string,
  after: string,
  placeholder: string,
): MarkdownEditResult => {
  const { start, end } = normalizeRange(input.value, input.selectionStart, input.selectionEnd)
  const selected = input.value.slice(start, end)
  const inner = selected || placeholder
  const text = input.value.slice(0, start) + before + inner + after + input.value.slice(end)
  const selectionStart = start + before.length
  return {
    text,
    selectionStart,
    selectionEnd: selectionStart + inner.length,
  }
}

/** 插入 Markdown 链接；有选区时以选区为文字并选中 URL。 */
export const insertMarkdownLink = (input: MarkdownSelection): MarkdownEditResult => {
  const { start, end } = normalizeRange(input.value, input.selectionStart, input.selectionEnd)
  const selected = input.value.slice(start, end)
  const label = selected || '链接文字'
  const url = 'https://'
  const text = input.value.slice(0, start) + `[${label}](${url})` + input.value.slice(end)
  const labelStart = start + 1
  const urlStart = labelStart + label.length + 2
  if (selected) {
    return { text, selectionStart: urlStart, selectionEnd: urlStart + url.length }
  }
  return { text, selectionStart: labelStart, selectionEnd: labelStart + label.length }
}

/** 给选区覆盖的行加前缀（标题 / 无序列表 / 有序列表 / 引用）。 */
export const prefixMarkdownLines = (
  input: MarkdownSelection,
  kind: MarkdownLinePrefix,
): MarkdownEditResult => {
  const { start, end } = normalizeRange(input.value, input.selectionStart, input.selectionEnd)
  const lineStart = input.value.lastIndexOf('\n', Math.max(0, start - 1)) + 1
  const nextBreak = input.value.indexOf('\n', end)
  const lineEnd = nextBreak === -1 ? input.value.length : nextBreak
  const lines = input.value.slice(lineStart, lineEnd).split('\n')
  let orderedIndex = 1

  const transformed = lines.map((line) => {
    if (line.trim() === '' && lines.length > 1) return line
    const indentMatch = /^(\s*)/.exec(line)
    const indent = indentMatch?.[1] ?? ''
    let body = line.slice(indent.length)

    switch (kind) {
      case 'heading':
        body = body.replace(/^#{1,6}\s+/, '')
        return `${indent}## ${body}`
      case 'unordered-list':
        body = body.replace(/^[-*+]\s+/, '')
        return `${indent}- ${body}`
      case 'ordered-list':
        body = body.replace(/^\d+[.)]\s+/, '')
        return `${indent}${orderedIndex++}. ${body}`
      case 'quote':
        body = body.replace(/^>\s?/, '')
        return `${indent}> ${body}`
    }
  })

  const block = transformed.join('\n')
  return {
    text: input.value.slice(0, lineStart) + block + input.value.slice(lineEnd),
    selectionStart: lineStart,
    selectionEnd: lineStart + block.length,
  }
}

/**
 * 解析编辑器快捷键。
 * 中文输入法组合输入期间（isComposing 或 keyCode 229）返回 null，避免误触。
 */
export const resolveMarkdownShortcut = (event: ShortcutKeyEvent): MarkdownShortcut | null => {
  if (event.isComposing || event.keyCode === 229) return null
  if (!(event.ctrlKey || event.metaKey) || event.altKey || event.shiftKey) return null
  const key = event.key.toLowerCase()
  if (key === 'b') return 'bold'
  if (key === 'i') return 'italic'
  if (key === 'k') return 'link'
  return null
}
