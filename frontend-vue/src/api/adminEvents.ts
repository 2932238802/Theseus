import type {
  AdminEventInput,
  AdminEventView,
  AdminSeasonInput,
  ContestAppealList,
  ContestAppealResolveResult,
  SeasonList,
  SeasonSummary,
} from '../types/contest'
import { type ApiEnvelope, unwrap } from './client'
import { http } from './http'

export const fetchAdminEvents = async (): Promise<AdminEventView[]> => {
  const data = await unwrap(http.get<ApiEnvelope<{ events: AdminEventView[] }>>('/admin/events'))
  return data.events
}

export const fetchAdminEvent = async (id: number): Promise<AdminEventView> =>
  unwrap(http.get<ApiEnvelope<AdminEventView>>(`/admin/events/${id}`))

export const createAdminEvent = async (input: AdminEventInput): Promise<AdminEventView> =>
  unwrap(http.post<ApiEnvelope<AdminEventView>>('/admin/events', input))

export const updateAdminEvent = async (
  id: number,
  input: AdminEventInput,
): Promise<AdminEventView> =>
  unwrap(http.put<ApiEnvelope<AdminEventView>>(`/admin/events/${id}`, input))

export interface EventForumSync {
  event_id: number
  forum_post_id: number
  pinned: boolean
  message: string
}

export const syncAdminEventForum = async (id: number): Promise<EventForumSync> =>
  unwrap(http.post<ApiEnvelope<EventForumSync>>(`/admin/events/${id}/forum`))

export interface AdminSeasonList {
  items: SeasonSummary[]
}

export const fetchAdminSeasons = async (): Promise<SeasonSummary[]> => {
  const data = await unwrap(http.get<ApiEnvelope<AdminSeasonList>>('/admin/seasons'))
  return data.items
}

export const createAdminSeason = async (input: AdminSeasonInput): Promise<SeasonSummary> =>
  unwrap(http.post<ApiEnvelope<SeasonSummary>>('/admin/seasons', input))

export const updateAdminSeason = async (
  id: number,
  input: AdminSeasonInput,
): Promise<SeasonSummary> =>
  unwrap(http.put<ApiEnvelope<SeasonSummary>>(`/admin/seasons/${id}`, input))

export const fetchPublicSeasons = async (): Promise<SeasonList> =>
  unwrap(http.get<ApiEnvelope<SeasonList>>('/contests/seasons'))

export const fetchAdminContestAppeals = async (
  status?: string,
): Promise<ContestAppealList> =>
  unwrap(
    http.get<ApiEnvelope<ContestAppealList>>('/admin/contest-appeals', {
      params: status ? { status } : undefined,
    }),
  )

export const resolveAdminContestAppeal = async (
  id: number,
  status: 'accepted' | 'rejected',
  note?: string,
): Promise<ContestAppealResolveResult> =>
  unwrap(
    http.post<ApiEnvelope<ContestAppealResolveResult>>(
      `/admin/contest-appeals/${id}/resolve`,
      { status, note: note?.trim() || null },
    ),
  )

/// 触发浏览器下载赛事成绩 CSV。
export const downloadAdminEventResults = async (id: number): Promise<void> => {
  const response = await http.get<Blob>(`/admin/events/${id}/results/export`, {
    responseType: 'blob',
  })
  const url = URL.createObjectURL(response.data)
  const link = document.createElement('a')
  link.href = url
  link.download = `event-${id}-results.csv`
  document.body.append(link)
  link.click()
  link.remove()
  URL.revokeObjectURL(url)
}
