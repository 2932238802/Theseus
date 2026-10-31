import type {
  MyPlusState,
  PlusApplicationList,
  PlusApplicationResolveResult,
  PlusApplicationStatus,
} from '../types/shop'
import { type ApiEnvelope, unwrap } from './client'
import { http } from './http'

export const fetchMyPlusState = async (): Promise<MyPlusState> =>
  unwrap(http.get<ApiEnvelope<MyPlusState>>('/shop/plus'))

export const applyPlusTheseus = async (reason: string): Promise<MyPlusState> =>
  unwrap(http.post<ApiEnvelope<MyPlusState>>('/shop/plus/apply', { reason }))

export const fetchAdminPlusApplications = async (
  status?: PlusApplicationStatus,
): Promise<PlusApplicationList> =>
  unwrap(
    http.get<ApiEnvelope<PlusApplicationList>>('/admin/plus-applications', {
      params: status ? { status } : undefined,
    }),
  )

export const resolveAdminPlusApplication = async (
  id: number,
  status: 'approved' | 'rejected',
  note?: string,
): Promise<PlusApplicationResolveResult> =>
  unwrap(
    http.post<ApiEnvelope<PlusApplicationResolveResult>>(
      `/admin/plus-applications/${id}/resolve`,
      { status, note: note || undefined },
    ),
  )
