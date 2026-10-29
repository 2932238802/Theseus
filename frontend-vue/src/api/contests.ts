import type { Problem } from '../types/oj'
import type {
  CameraPermission,
  ContestCurrent,
  ContestDetail,
  ContestEventCard,
  ContestEventDetail,
  ContestEventInput,
  ContestEventList,
  ContestEventListQuery,
  ContestEventResult,
  ContestFeatured,
  ContestHeartbeat,
  ContestMatchResult,
  ContestResult,
  EnterContestEvent,
  EventLeaderboard,
  ProctorEventListResponse,
  ProctorReviewResponse,
  RankedLeaderboard,
  ScreenPermission,
} from '../types/contest'
import { type ApiEnvelope, unwrap } from './client'
import { type BackendProblem, mapProblem } from './adapters'
import { http } from './http'

export const matchContest = async (
  cameraPermission?: CameraPermission,
  screenPermission?: ScreenPermission,
): Promise<ContestMatchResult> =>
  unwrap(
    http.post<ApiEnvelope<ContestMatchResult>>('/contests/match', {
      camera_permission: cameraPermission,
      screen_permission: screenPermission,
    }),
  )

export const cancelMatch = async (): Promise<{ message: string }> =>
  unwrap(http.delete<ApiEnvelope<{ message: string }>>('/contests/match'))

export const fetchCurrentContest = async (): Promise<ContestCurrent> =>
  unwrap(http.get<ApiEnvelope<ContestCurrent>>('/contests/current'))

export const fetchFeaturedContests = async (): Promise<ContestFeatured> =>
  unwrap(http.get<ApiEnvelope<ContestFeatured>>('/contests/featured'))

export const fetchContestEventList = async (
  query: ContestEventListQuery = {},
): Promise<ContestEventList> =>
  unwrap(
    http.get<ApiEnvelope<ContestEventList>>('/contests/events', {
      params: query,
    }),
  )

export const followContestEvent = async (id: number): Promise<{ is_followed: boolean }> =>
  unwrap(http.post<ApiEnvelope<{ is_followed: boolean }>>(`/contests/events/${id}/follow`))

export const unfollowContestEvent = async (id: number): Promise<{ is_followed: boolean }> =>
  unwrap(http.delete<ApiEnvelope<{ is_followed: boolean }>>(`/contests/events/${id}/follow`))

export const fetchContestEventDetail = async (id: number): Promise<ContestEventDetail> =>
  unwrap(http.get<ApiEnvelope<ContestEventDetail>>(`/contests/events/${id}`))

export const registerContestEvent = async (id: number): Promise<ContestEventCard> =>
  unwrap(http.post<ApiEnvelope<ContestEventCard>>(`/contests/events/${id}/register`))

export const joinContestEvent = async (id: number): Promise<ContestEventCard> =>
  unwrap(http.post<ApiEnvelope<ContestEventCard>>(`/contests/events/${id}/join`))

export const enterContestEvent = async (id: number): Promise<EnterContestEvent> =>
  unwrap(http.post<ApiEnvelope<EnterContestEvent>>(`/contests/events/${id}/enter`))

export const fetchContestEventLeaderboard = async (id: number): Promise<EventLeaderboard> =>
  unwrap(http.get<ApiEnvelope<EventLeaderboard>>(`/contests/events/${id}/leaderboard`))

export const fetchRankedContestLeaderboard = async (limit = 20): Promise<RankedLeaderboard> =>
  unwrap(http.get<ApiEnvelope<RankedLeaderboard>>('/contests/rankings', { params: { limit } }))

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

export const sendContestHeartbeat = async (id: number): Promise<ContestHeartbeat> =>
  unwrap(http.post<ApiEnvelope<ContestHeartbeat>>(`/contests/${id}/heartbeat`))

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

export const fetchProctorEvents = async (
  contestId: number,
): Promise<ProctorEventListResponse> =>
  unwrap(
    http.get<ApiEnvelope<ProctorEventListResponse>>(
      `/admin/contests/${contestId}/proctor-events`,
    ),
  )

export const reviewProctorEvent = async (
  contestId: number,
  eventId: number,
  status: 'cleared' | 'confirmed',
  note?: string,
): Promise<ProctorReviewResponse> =>
  unwrap(
    http.post<ApiEnvelope<ProctorReviewResponse>>(
      `/admin/contests/${contestId}/proctor-events/${eventId}/review`,
      { status, note: note?.trim() || null },
    ),
  )
