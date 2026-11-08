// Markdown 正文里的 KaTeX 公式处理。
// 公式必须在 marked 解析前抽出，否则 marked 会吃掉 LaTeX 的反斜杠转义（如 \{、\\），
// 多行 $$...$$ 也会被 breaks 选项拆成 <br>。
// 处理流程：抽取公式 → 占位符 → marked → DOMPurify → 用 KaTeX 替换占位符。
// KaTeX 按需加载，没有公式的页面不会下载公式运行时、样式与字体。

export interface MathItem {
  latex: string
  display: boolean
  raw: string
}

export interface MathExtraction {
  markdown: string
  math: Map<string, MathItem>
}

type Katex = typeof import('katex').default

const PLACEHOLDER_OPEN = '\uE000'
const PLACEHOLDER_CLOSE = '\uE001'
const PLACEHOLDER_RE = /\uE000(\d+)\uE001/g

const isSpace = (char: string | undefined): boolean =>
  char === undefined || /\s/.test(char)

const isLineStart = (source: string, index: number): boolean =>
  index === 0 || source[index - 1] === '\n'

// 返回代码块结束后的位置；未闭合时把剩余内容都当作代码块
const readFencedCode = (source: string, index: number): number | null => {
  if (!isLineStart(source, index)) return null
  const lineEnd = source.indexOf('\n', index)
  const line = source.slice(index, lineEnd < 0 ? source.length : lineEnd)
  const opening = /^ {0,3}(`{3,}|~{3,})(.*)$/.exec(line)
  if (!opening) return null

  const fence = opening[1]
  const fenceChar = fence[0]

  let cursor = lineEnd < 0 ? source.length : lineEnd + 1
  while (cursor < source.length) {
    const end = source.indexOf('\n', cursor)
    const contentEnd = end < 0 ? source.length : end
    const closing = /^ {0,3}(`{3,}|~{3,})\s*$/.exec(source.slice(cursor, contentEnd))
    if (closing && closing[1][0] === fenceChar && closing[1].length >= fence.length) {
      return end < 0 ? source.length : end + 1
    }
    if (end < 0) break
    cursor = end + 1
  }
  return source.length
}

// 返回行内代码结束后的位置；未闭合时返回 null，交给后续按普通文本处理
const readInlineCode = (source: string, index: number): number | null => {
  if (source[index] !== '`') return null
  let runLength = 1
  while (source[index + runLength] === '`') runLength += 1

  let cursor = index + runLength
  while (cursor < source.length) {
    const next = source.indexOf('`', cursor)
    if (next < 0) return null
    let nextRunLength = 1
    while (source[next + nextRunLength] === '`') nextRunLength += 1
    if (nextRunLength === runLength) return next + nextRunLength
    cursor = next + nextRunLength
  }
  return null
}

const findDisplayClose = (source: string, from: number): number => {
  for (let cursor = from; cursor < source.length - 1; cursor += 1) {
    if (source[cursor] === '\\') {
      cursor += 1
      continue
    }
    if (source[cursor] === '$' && source[cursor + 1] === '$') return cursor
  }
  return -1
}

// 行内公式不跨行；结束符前不能是空白，后接数字时更像货币金额（$5 和 $10）
const findInlineClose = (source: string, from: number): number => {
  for (let cursor = from; cursor < source.length; cursor += 1) {
    const char = source[cursor]
    if (char === '\\') {
      cursor += 1
      continue
    }
    if (char === '\n' || char === '\r') return -1
    if (char !== '$') continue
    if (/\d/.test(source[cursor + 1] ?? '')) continue
    if (isSpace(source[cursor - 1])) continue
    return cursor
  }
  return -1
}

/**
 * 把 Markdown 源码中的 $...$ / $$...$$ 替换为占位符。
 * 代码块、行内代码、HTML 标签属性与转义的 \$ 不参与抽取。
 */
export const extractMath = (source: string): MathExtraction => {
  const math = new Map<string, MathItem>()
  if (!source.includes('$')) return { markdown: source, math }

  const chunks: string[] = []
  let copyFrom = 0
  let cursor = 0

  while (cursor < source.length) {
    const char = source[cursor]

    // 转义字符整体跳过，\$ 不会被当成公式开头
    if (char === '\\') {
      cursor += 2
      continue
    }

    // 代码块优先于行内代码，避免 ~~~ 围栏被误判
    if (char === '`' || char === '~') {
      const fenceEnd = readFencedCode(source, cursor)
      if (fenceEnd !== null) {
        cursor = fenceEnd
        continue
      }
    }

    if (char === '`') {
      const codeEnd = readInlineCode(source, cursor)
      if (codeEnd !== null) {
        cursor = codeEnd
        continue
      }
    }

    // 跳过 HTML 标签，避免把属性值里的 $ 当成公式
    if (char === '<') {
      const tag = /^<\/?[A-Za-z][^>]*>/.exec(source.slice(cursor, cursor + 512))
      if (tag) {
        cursor += tag[0].length
        continue
      }
    }

    if (char !== '$') {
      cursor += 1
      continue
    }

    const display = source[cursor + 1] === '$'
    const contentStart = cursor + (display ? 2 : 1)

    // 行内公式不以空白或换行开头
    if (!display && isSpace(source[contentStart])) {
      cursor += 1
      continue
    }

    const close = display
      ? findDisplayClose(source, contentStart)
      : findInlineClose(source, contentStart)
    if (close < 0) {
      cursor += 1
      continue
    }

    const latex = source.slice(contentStart, close)
    if (!latex.trim()) {
      cursor = close + (display ? 2 : 1)
      continue
    }

    const token = `${PLACEHOLDER_OPEN}${math.size}${PLACEHOLDER_CLOSE}`
    math.set(token, {
      latex,
      display,
      raw: source.slice(cursor, close + (display ? 2 : 1)),
    })
    chunks.push(source.slice(copyFrom, cursor), token)
    cursor = close + (display ? 2 : 1)
    copyFrom = cursor
  }

  chunks.push(source.slice(copyFrom))
  return { markdown: chunks.join(''), math }
}

const renderMath = (
  item: MathItem,
  ownerDocument: Document,
  katex: Katex,
): Node => {
  const span = ownerDocument.createElement('span')
  try {
    katex.render(item.latex, span, {
      displayMode: item.display,
      throwOnError: true,
      strict: 'ignore',
      trust: false,
    })
  } catch {
    // 公式不合法时保留原始写法，避免整段内容显示为报错块
    span.textContent = item.raw
  }
  return span
}

/**
 * 用 KaTeX 替换 root 中的公式占位符。
 * 只有确实存在公式时才异步加载 KaTeX 运行时与样式。
 * 代码块内的占位符还原为原始写法；KaTeX 加载或渲染失败时同样回退到原文。
 */
export const renderMathIn = async (
  root: Node,
  math: Map<string, MathItem>,
): Promise<void> => {
  if (!math.size) return

  const ownerDocument = root.ownerDocument ?? document
  const walker = ownerDocument.createTreeWalker(root, NodeFilter.SHOW_TEXT)
  const candidates: {
    node: Text
    parts: (string | MathItem)[]
    inCode: boolean
  }[] = []

  for (let node = walker.nextNode(); node; node = walker.nextNode()) {
    if (!(node instanceof Text)) continue
    const value = node.nodeValue ?? ''
    if (!value.includes(PLACEHOLDER_OPEN)) continue

    const parent = node.parentElement
    if (parent?.closest('script, style, textarea, .katex')) continue
    const inCode = Boolean(parent?.closest('code, pre'))

    const parts: (string | MathItem)[] = []
    let lastIndex = 0
    let matched = false
    PLACEHOLDER_RE.lastIndex = 0
    for (let match = PLACEHOLDER_RE.exec(value); match; match = PLACEHOLDER_RE.exec(value)) {
      const item = math.get(match[0])
      if (!item) continue
      matched = true
      if (match.index > lastIndex) parts.push(value.slice(lastIndex, match.index))
      parts.push(item)
      lastIndex = match.index + match[0].length
    }
    if (!matched) continue
    if (lastIndex < value.length) parts.push(value.slice(lastIndex))
    candidates.push({ node, parts, inCode })
  }

  if (!candidates.length) return

  let katex: Katex | null = null
  if (candidates.some((candidate) => !candidate.inCode)) {
    try {
      // 运行时与样式一起按需加载，无公式的页面不下载 KaTeX CSS 与字体
      const [module] = await Promise.all([
        import('katex'),
        import('katex/dist/katex.min.css'),
      ])
      katex = module.default
    } catch {
      // 加载失败时走原文回退，不影响正文其它内容
    }
  }

  for (const { node, parts, inCode } of candidates) {
    // 等待 KaTeX 加载期间内容可能已被 v-html 替换，只处理仍属于当前容器的节点
    if (!root.contains(node)) continue
    const fragment = ownerDocument.createDocumentFragment()
    for (const part of parts) {
      if (typeof part === 'string') {
        fragment.append(ownerDocument.createTextNode(part))
      } else if (inCode || !katex) {
        fragment.append(ownerDocument.createTextNode(part.raw))
      } else {
        fragment.append(renderMath(part, ownerDocument, katex))
      }
    }
    node.replaceWith(fragment)
  }
}
