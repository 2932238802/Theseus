export type DiffKind = 'equal' | 'removed' | 'added'

export interface DiffRow {
  kind: DiffKind
  leftNumber?: number
  rightNumber?: number
  left?: string
  right?: string
}

// 题目代码通常只有几百行；超过这个规模就放弃逐行对齐，避免在浏览器里
// 分配过大的 LCS 表。
const MAX_DIFF_CELLS = 4_000_000

const splitLines = (value: string): string[] => (value.length ? value.split('\n') : [])

/**
 * 按最长公共子序列对齐两份代码，返回左右并排的行。
 * 返回 null 表示代码过长，调用方应改为直接展示两段代码。
 */
export const buildLineDiff = (left: string, right: string): DiffRow[] | null => {
  const leftLines = splitLines(left)
  const rightLines = splitLines(right)
  if (leftLines.length * rightLines.length > MAX_DIFF_CELLS) return null

  const rows: DiffRow[] = []
  const height = leftLines.length
  const width = rightLines.length
  const table: Uint32Array[] = Array.from({ length: height + 1 }, () => new Uint32Array(width + 1))

  for (let i = 1; i <= height; i += 1) {
    const current = table[i]
    const previous = table[i - 1]
    for (let j = 1; j <= width; j += 1) {
      current[j] =
        leftLines[i - 1] === rightLines[j - 1]
          ? previous[j - 1] + 1
          : Math.max(previous[j], current[j - 1])
    }
  }

  let i = height
  let j = width
  while (i > 0 || j > 0) {
    if (i > 0 && j > 0 && leftLines[i - 1] === rightLines[j - 1]) {
      rows.push({ kind: 'equal', left: leftLines[i - 1], right: rightLines[j - 1] })
      i -= 1
      j -= 1
    } else if (j > 0 && (i === 0 || table[i][j - 1] >= table[i - 1][j])) {
      rows.push({ kind: 'added', right: rightLines[j - 1] })
      j -= 1
    } else {
      rows.push({ kind: 'removed', left: leftLines[i - 1] })
      i -= 1
    }
  }
  rows.reverse()

  let leftNumber = 0
  let rightNumber = 0
  for (const row of rows) {
    if (row.left !== undefined) {
      leftNumber += 1
      row.leftNumber = leftNumber
    }
    if (row.right !== undefined) {
      rightNumber += 1
      row.rightNumber = rightNumber
    }
  }
  return rows
}
