import type { ClassDetail, ClassMember, ClassSummary } from '../types/teaching'
import { type ApiEnvelope, unwrap } from './client'
import {
  type BackendClassDetail,
  type BackendClassMember,
  type BackendClassSummary,
  mapClassDetail,
  mapClassMember,
  mapClassSummary,
} from './teachingAdapters'
import { http } from './http'

export interface ClassPayload {
  name: string
  courseName?: string
  term?: string
  description?: string
}

interface BackendClassPayload {
  name: string
  course_name?: string
  term?: string
  description?: string
}

const toBackendPayload = (payload: ClassPayload): BackendClassPayload => ({
  name: payload.name,
  course_name: payload.courseName,
  term: payload.term,
  description: payload.description,
})

export const fetchClasses = async (): Promise<ClassSummary[]> => {
  const data = await unwrap(http.get<ApiEnvelope<{ classes: BackendClassSummary[] }>>('/classes'))
  return data.classes.map(mapClassSummary)
}

export const createClass = async (payload: ClassPayload): Promise<ClassDetail> => {
  const data = await unwrap(
    http.post<ApiEnvelope<BackendClassDetail>>('/classes', toBackendPayload(payload)),
  )
  return mapClassDetail(data)
}

export const fetchClass = async (id: number): Promise<ClassDetail> => {
  const data = await unwrap(http.get<ApiEnvelope<BackendClassDetail>>(`/classes/${id}`))
  return mapClassDetail(data)
}

export const updateClass = async (id: number, payload: ClassPayload): Promise<ClassDetail> => {
  const data = await unwrap(
    http.put<ApiEnvelope<BackendClassDetail>>(`/classes/${id}`, toBackendPayload(payload)),
  )
  return mapClassDetail(data)
}

export const joinClass = async (inviteCode: string): Promise<ClassSummary> => {
  const data = await unwrap(
    http.post<ApiEnvelope<BackendClassSummary>>('/classes/join', { invite_code: inviteCode }),
  )
  return mapClassSummary(data)
}

export const addClassMember = async (classId: number, identifier: string): Promise<ClassMember> => {
  const data = await unwrap(
    http.post<ApiEnvelope<BackendClassMember>>(`/classes/${classId}/members`, { identifier }),
  )
  return mapClassMember(data)
}

export const removeClassMember = async (classId: number, userId: number): Promise<void> => {
  await unwrap(http.delete<ApiEnvelope<{ message: string }>>(`/classes/${classId}/members/${userId}`))
}

export const leaveClass = async (classId: number): Promise<void> => {
  await unwrap(http.delete<ApiEnvelope<{ message: string }>>(`/classes/${classId}/members/me`))
}

export const rotateInviteCode = async (classId: number): Promise<string> => {
  const data = await unwrap(
    http.post<ApiEnvelope<{ invite_code: string }>>(`/classes/${classId}/invite-code/rotate`),
  )
  return data.invite_code
}

export const archiveClass = async (classId: number): Promise<void> => {
  await unwrap(http.post<ApiEnvelope<{ message: string }>>(`/classes/${classId}/archive`))
}
