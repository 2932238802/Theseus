import type {
  AppealQueueResponse,
  AppealResolveInput,
  AppealResolveResponse,
  AppealSubmitResponse,
  CheatReportDetailResponse,
  CheatReportListResponse,
  CheatReportQuery,
  CheatReviewInput,
  MyReportDetailResponse,
  MyReportListResponse,
  ReviewResponse,
} from '../types/anticheat'
import { type ApiEnvelope, unwrap } from './client'
import { http } from './http'

export const fetchCheatReports = async (
  query: CheatReportQuery = {},
): Promise<CheatReportListResponse> =>
  unwrap(http.get<ApiEnvelope<CheatReportListResponse>>('/teacher/cheat-reports', { params: query }))

export const fetchCheatReport = async (id: number): Promise<CheatReportDetailResponse> =>
  unwrap(http.get<ApiEnvelope<CheatReportDetailResponse>>(`/teacher/cheat-reports/${id}`))

export const reviewCheatReport = async (
  id: number,
  input: CheatReviewInput,
): Promise<ReviewResponse> =>
  unwrap(http.post<ApiEnvelope<ReviewResponse>>(`/teacher/cheat-reports/${id}/review`, input))

export const fetchAppealQueue = async (
  page = 1,
  size = 50,
): Promise<AppealQueueResponse> =>
  unwrap(
    http.get<ApiEnvelope<AppealQueueResponse>>('/teacher/appeals', {
      params: { page, size },
    }),
  )

export const resolveAppeal = async (
  id: number,
  input: AppealResolveInput,
): Promise<AppealResolveResponse> =>
  unwrap(http.post<ApiEnvelope<AppealResolveResponse>>(`/teacher/appeals/${id}/resolve`, input))

export const fetchMyCheatReports = async (): Promise<MyReportListResponse> =>
  unwrap(http.get<ApiEnvelope<MyReportListResponse>>('/cheat-reports/mine'))

export const fetchMyCheatReport = async (id: number): Promise<MyReportDetailResponse> =>
  unwrap(http.get<ApiEnvelope<MyReportDetailResponse>>(`/cheat-reports/${id}`))

export const submitCheatAppeal = async (
  id: number,
  reason: string,
): Promise<AppealSubmitResponse> =>
  unwrap(http.post<ApiEnvelope<AppealSubmitResponse>>(`/cheat-reports/${id}/appeal`, { reason }))
