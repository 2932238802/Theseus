import type { Difficulty, Language } from '../types/oj'

const META_KEY = 'theseus-draft-meta'

export interface DraftMeta {
  problemId: number
  title: string
  difficulty: Difficulty
  language: Language
  updatedAt: string
}

type DraftMetaMap = Record<string, DraftMeta>

const readMap = (): DraftMetaMap => {
  try {
    const raw = localStorage.getItem(META_KEY)
    if (!raw) return {}
    const parsed = JSON.parse(raw) as unknown
    if (!parsed || typeof parsed !== 'object') return {}
    return parsed as DraftMetaMap
  } catch {
    return {}
  }
}

const writeMap = (map: DraftMetaMap): void => {
  try {
    localStorage.setItem(META_KEY, JSON.stringify(map))
  } catch {
    // 本地存储不可用时静默降级，首页改用后端学习记录
  }
}

export const saveDraftMeta = (meta: Omit<DraftMeta, 'updatedAt'>): void => {
  const map = readMap()
  map[String(meta.problemId)] = { ...meta, updatedAt: new Date().toISOString() }
  writeMap(map)
}

export const clearDraftMeta = (problemId: number): void => {
  const map = readMap()
  if (!(String(problemId) in map)) return
  delete map[String(problemId)]
  writeMap(map)
}

export const latestDraftMeta = (): DraftMeta | null => {
  const map = readMap()
  const entries = Object.values(map)
  if (!entries.length) return null
  return entries.reduce((latest, entry) =>
    new Date(entry.updatedAt).getTime() > new Date(latest.updatedAt).getTime() ? entry : latest,
  )
}
