import type { Stats } from '../types/oj'
import { type ApiEnvelope, unwrap } from './client'
import { type BackendStats, mapStats } from './adapters'
import { http } from './http'

export const fetchStats = async (): Promise<Stats> => {
  const data = await unwrap(http.get<ApiEnvelope<BackendStats>>('/stats'))
  return mapStats(data)
}
