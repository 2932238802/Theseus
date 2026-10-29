import type { Language } from '../types/oj'
import { type ApiEnvelope, unwrap } from './client'
import { http } from './http'

interface BackendDraft {
  language: string
  code: string
  updated_at: string
}

interface DraftData {
  draft: BackendDraft | null
}

export interface ProblemDraft {
  language: Language
  code: string
  updatedAt: string
}

const toLanguage = (value: string): Language =>
  value === 'java' || value === 'python' || value === 'javascript' ? value : 'cpp'

export const fetchProblemDraft = async (
  problemId: number,
  language: Language,
): Promise<ProblemDraft | null> => {
  const data = await unwrap(
    http.get<ApiEnvelope<DraftData>>(`/problems/${problemId}/draft`, {
      params: { language },
    }),
  )
  if (!data.draft) return null
  return {
    language: toLanguage(data.draft.language),
    code: data.draft.code,
    updatedAt: data.draft.updated_at,
  }
}

export const saveProblemDraft = async (
  problemId: number,
  language: Language,
  code: string,
): Promise<void> => {
  await unwrap(
    http.put<ApiEnvelope<DraftData>>(`/problems/${problemId}/draft`, {
      language,
      code,
    }),
  )
}
