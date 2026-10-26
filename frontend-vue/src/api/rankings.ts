import type { RankingResult } from '../types/ranking'
import { type BackendRankingResult, mapRankingResult } from './adapters'
import { type ApiEnvelope, unwrap } from './client'
import { http } from './http'

export const fetchRankings = async (page: number, size: number): Promise<RankingResult> => {
  const data = await unwrap(
    http.get<ApiEnvelope<BackendRankingResult>>('/rankings', { params: { page, size } }),
  )
  return mapRankingResult(data)
}
