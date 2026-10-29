import type { HomeOverview } from '../types/home'
import { type ApiEnvelope, unwrap } from './client'
import { http } from './http'

export const fetchHomeOverview = async (): Promise<HomeOverview> =>
  unwrap(http.get<ApiEnvelope<HomeOverview>>('/home/overview'))

export const fetchRandomProblem = async (): Promise<number> => {
  const data = await unwrap(http.get<ApiEnvelope<{ problem_id: number }>>('/problems/random'))
  return data.problem_id
}
