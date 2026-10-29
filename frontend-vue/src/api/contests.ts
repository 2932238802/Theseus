import type { Problem } from '../types/oj'
import type {
  CameraPermission,
  ContestCurrent,
  ContestDetail,
  ContestEventCard,
  ContestEventDetail,
  ContestEventInput,
  ContestEventResult,
  ContestFeatured,
  ContestMatchResult,
  ContestResult,
} from '../types/contest'
import { type ApiEnvelope, unwrap } from './client'
import { type BackendProblem, mapProblem } from './adapters'
import { http } from './http'

export const matchContest = async (
  cameraPermission?: CameraPermission,
): Promise<ContestMatchResult> =>
  unwrap(
    http.post<ApiEnvelope<ContestMatchResult>>('/contests/match', {
      camera_permission: cameraPermission,
    }),
  )

export const cancelMatch = async (): Promise<{ message: string }> =>
  unwrap(http.delete<ApiEnvelope<{ message: string }>>('/contests/match'))

export const fetchCurrentContest = async (): Promise<ContestCurrent> =>
  unwrap(http.get<ApiEnvelope<ContestCurrent>>('/contests/current'))

export const fetchFeaturedContests = async (): Promise<ContestFeatured> =>
  unwrap(http.get<ApiEnvelope<ContestFeatured>>('/contests/featured'))

export const fetchContestEventDetail = async (id: number): Promise<ContestEventDetail> =>
  unwrap(http.get<ApiEnvelope<ContestEventDetail>>(`/contests/events/${id}`))

export const registerContestEvent = async (id: number): Promise<ContestEventCard> =>
  unwrap(http.post<ApiEnvelope<ContestEventCard>>(`/contests/events/${id}/register`))

export const joinContestEvent = async (id: number): Promise<ContestEventCard> =>
  unwrap(http.post<ApiEnvelope<ContestEventCard>>(`/contests/events/${id}/join`))

export const fetchContest = async (id: number): Promise<ContestDetail> =>
  unwrap(http.get<ApiEnvelope<ContestDetail>>(`/contests/${id}`))

export const fetchContestProblem = async (
  contestId: number,
  problemId: number,
): Promise<Problem> => {
  const data = await unwrap(
    http.get<ApiEnvelope<BackendProblem>>(`/contests/${contestId}/problems/${problemId}`),
  )
  return mapProblem(data)
}

export const finishContest = async (
  id: number,
): Promise<{ message: string; finished: boolean }> =>
  unwrap(http.post<ApiEnvelope<{ message: string; finished: boolean }>>(`/contests/${id}/finish`))

export const fetchContestResult = async (id: number): Promise<ContestResult> =>
  unwrap(http.get<ApiEnvelope<ContestResult>>(`/contests/${id}/result`))

export const sendContestEvents = async (
  id: number,
  events: ContestEventInput[],
): Promise<ContestEventResult> =>
  unwrap(
    http.post<ApiEnvelope<ContestEventResult>>(`/contests/${id}/events`, { events }),
  )
