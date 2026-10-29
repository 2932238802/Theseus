/**
 * 比赛编辑器里的粘贴内容初筛。
 *
 * 只做本地启发式判断，不把完整剪贴板内容上传：
 * - 粘贴内容与当前代码、题目描述/示例/代码模板都不重合
 * - 长度达到阈值，且看起来像一段代码
 * 同时满足才记为疑似作弊，最终由比赛组织者人工复核。
 */

export interface PasteContext {
  code: string
  problemText: string
}

export interface PasteInspection {
  suspicious: boolean
  length: number
  lines: number
  codeSimilarity: number
  problemSimilarity: number
  preview: string
}

const MAX_INSPECT_CHARS = 20_000
const MIN_SUSPICIOUS_CHARS = 80
const MAX_CODE_SIMILARITY = 0.32
const MAX_PROBLEM_SIMILARITY = 0.15
const PREVIEW_CHARS = 200

const CODE_HINT =
  /\b(function|const|let|var|def|class|return|import|from|public|private|protected|static|void|int|float|double|char|string|bool|for|while|if|else|switch|try|catch|throw|struct|impl|fn|mut|use|package)\b|[{};=<>]/

const tokenize = (value: string): Set<string> => {
  const source = value.slice(0, MAX_INSPECT_CHARS).toLowerCase()
  const latin = source.match(/[a-z_][a-z0-9_]*/g) ?? []
  const han = source.match(/[\u4e00-\u9fff]/g) ?? []
  const hanBigrams: string[] = []
  for (let index = 0; index + 1 < han.length; index += 1) {
    hanBigrams.push(han[index] + han[index + 1])
  }
  return new Set([...latin, ...hanBigrams])
}

/** 粘贴内容中有多少比例的词元已经出现在上下文里。 */
const containment = (pasted: Set<string>, context: Set<string>): number => {
  if (!pasted.size || !context.size) return 0
  let shared = 0
  for (const token of pasted) {
    if (context.has(token)) shared += 1
  }
  return shared / pasted.size
}

const round3 = (value: number): number => Math.round(value * 1000) / 1000

export const inspectPaste = (text: string, context: PasteContext): PasteInspection => {
  const trimmed = text.trim()
  const preview = trimmed.slice(0, PREVIEW_CHARS)
  const result: PasteInspection = {
    suspicious: false,
    length: trimmed.length,
    lines: trimmed ? trimmed.split('\n').length : 0,
    codeSimilarity: 0,
    problemSimilarity: 0,
    preview,
  }
  if (trimmed.length < MIN_SUSPICIOUS_CHARS) return result
  if (!CODE_HINT.test(trimmed)) return result

  const pasted = tokenize(trimmed)
  result.codeSimilarity = round3(containment(pasted, tokenize(context.code)))
  result.problemSimilarity = round3(containment(pasted, tokenize(context.problemText)))
  result.suspicious =
    result.codeSimilarity < MAX_CODE_SIMILARITY &&
    result.problemSimilarity < MAX_PROBLEM_SIMILARITY
  return result
}
