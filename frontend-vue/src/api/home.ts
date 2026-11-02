import type { CheckinResult, CheckinStatus, HomeOverview } from '../types/home'
import { type ApiEnvelope, unwrap } from './client'
import { http } from './http'

export const fetchHomeOverview = async (): Promise<HomeOverview> =>
  unwrap(http.get<ApiEnvelope<HomeOverview>>('/home/overview'))

export const fetchCheckinStatus = async (): Promise<CheckinStatus> =>
  unwrap(http.get<ApiEnvelope<CheckinStatus>>('/home/check-in'))

export const checkIn = async (): Promise<CheckinResult> =>
  unwrap(http.post<ApiEnvelope<CheckinResult>>('/home/check-in'))

export const fetchRandomProblem = async (): Promise<number> => {
  const data = await unwrap(http.get<ApiEnvelope<{ problem_id: number }>>('/problems/random'))
  return data.problem_id
}
