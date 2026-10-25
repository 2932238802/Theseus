/** 后端 JSON 字段解析的共享小工具，供各适配器复用。 */

export type UnknownRecord = Record<string, unknown>

export const isRecord = (value: unknown): value is UnknownRecord =>
  typeof value === 'object' && value !== null && !Array.isArray(value)

export const record = (value: unknown): UnknownRecord => (isRecord(value) ? value : {})

export const text = (value: unknown, fallback = ''): string =>
  typeof value === 'string' ? value : fallback

export const number = (value: unknown, fallback = 0): number =>
  typeof value === 'number' && Number.isFinite(value) ? value : fallback

export const bool = (value: unknown, fallback = false): boolean =>
  typeof value === 'boolean' ? value : fallback

export const nullableText = (value: unknown): string | null =>
  typeof value === 'string' ? value : null

export const nullableNumber = (value: unknown): number | null =>
  typeof value === 'number' && Number.isFinite(value) ? value : null
