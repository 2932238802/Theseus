import type { Difficulty } from '../types/oj'
import type { ProblemNote, ProblemNoteListItem, ProblemNoteListResult } from '../types/note'
import { type ApiEnvelope, unwrap } from './client'
import { http } from './http'
import { isRecord, number, record, text } from './parse'

const mapDifficulty = (value: unknown): Difficulty =>
  value === 'medium' || value === 'hard' ? value : 'easy'

const mapNote = (value: unknown): ProblemNote | null => {
  if (!isRecord(value)) return null
  return {
    bodyMd: text(value.body_md),
    updatedAt: text(value.updated_at),
  }
}

export const fetchProblemNote = async (id: number): Promise<ProblemNote | null> => {
  const data = await unwrap(http.get<ApiEnvelope<unknown>>(`/problems/${id}/note`))
  return mapNote(record(data).note)
}

export const saveProblemNote = async (id: number, bodyMd: string): Promise<ProblemNote | null> => {
  const data = await unwrap(
    http.put<ApiEnvelope<unknown>>(`/problems/${id}/note`, { body_md: bodyMd }),
  )
  return mapNote(record(data).note)
}

export const fetchProblemNotes = async (
  page: number,
  size: number,
): Promise<ProblemNoteListResult> => {
  const data = await unwrap(http.get<ApiEnvelope<unknown>>('/profile/notes', { params: { page, size } }))
  const item = record(data)
  return {
    total: number(item.total),
    page: number(item.page, page),
    size: number(item.size, size),
    notes: Array.isArray(item.notes)
      ? item.notes.map((entry): ProblemNoteListItem => {
          const note = record(entry)
          return {
            problemId: number(note.problem_id),
            title: text(note.title),
            difficulty: mapDifficulty(note.difficulty),
            excerpt: text(note.excerpt),
            updatedAt: text(note.updated_at),
          }
        })
      : [],
  }
}
