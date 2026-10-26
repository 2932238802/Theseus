import type { ApiEnvelope, } from './client'
import { unwrap } from './client'
import { http } from './http'
import { bool, number, record, text, type UnknownRecord } from './parse'
import type {
  CreateInvitationsResult,
  InvitationMutationResult,
  InvitationStatus,
  InviteCandidate,
  MyInvitation,
  OwnerInvitation,
} from '../types/teaching'

const status = (value: unknown): InvitationStatus =>
  text(value) as InvitationStatus

const mapCandidate = (value: unknown): InviteCandidate => {
  const item = record(value)
  return {
    userId: number(item.user_id),
    username: text(item.username),
    email: text(item.email),
    isMember: bool(item.is_member),
    hasPendingInvitation: bool(item.has_pending_invitation),
  }
}

const mapOwnerInvitation = (value: unknown): OwnerInvitation => {
  const item = record(value)
  return {
    id: number(item.id),
    inviteeId: number(item.invitee_id),
    inviteeUsername: text(item.invitee_username),
    inviteeEmail: text(item.invitee_email),
    status: status(item.status),
    expiresAt: text(item.expires_at),
    respondedAt: typeof item.responded_at === 'string' ? item.responded_at : undefined,
    createdAt: text(item.created_at),
  }
}

const mapMyInvitation = (value: unknown): MyInvitation => {
  const item = record(value)
  return {
    id: number(item.id),
    classId: number(item.class_id),
    className: text(item.class_name),
    courseName: typeof item.course_name === 'string' ? item.course_name : undefined,
    term: typeof item.term === 'string' ? item.term : undefined,
    inviterId: number(item.inviter_id),
    inviterUsername: text(item.inviter_username),
    status: status(item.status),
    expiresAt: text(item.expires_at),
    createdAt: text(item.created_at),
  }
}

const mapMutation = (value: unknown): InvitationMutationResult => {
  const data = record(value)
  return {
    id: number(data.id),
    classId: number(data.class_id),
    status: status(data.status),
    message: text(data.message),
  }
}

export const fetchInviteCandidates = async (
  classId: number,
  q: string,
): Promise<InviteCandidate[]> => {
  const data = await unwrap(
    http.get<ApiEnvelope<UnknownRecord>>(`/classes/${classId}/invite-candidates`, {
      params: { q },
    }),
  )
  return Array.isArray(data.candidates)
    ? data.candidates.map(mapCandidate)
    : []
}

export const sendClassInvitations = async (
  classId: number,
  userIds: number[],
): Promise<CreateInvitationsResult> => {
  const data = await unwrap(
    http.post<ApiEnvelope<UnknownRecord>>(`/classes/${classId}/invitations`, {
      user_ids: userIds,
    }),
  )
  const skipped = Array.isArray(data.skipped)
    ? data.skipped.map((value) => {
        const item = record(value)
        return {
          userId: number(item.user_id),
          username: text(item.username),
          reason: text(item.reason),
        }
      })
    : []
  return {
    invitedCount: number(data.invited_count),
    skipped,
    message: text(data.message),
  }
}

export const fetchClassInvitations = async (classId: number): Promise<OwnerInvitation[]> => {
  const data = await unwrap(
    http.get<ApiEnvelope<UnknownRecord>>(`/classes/${classId}/invitations`),
  )
  return Array.isArray(data.invitations)
    ? data.invitations.map(mapOwnerInvitation)
    : []
}

export const fetchMyInvitations = async (): Promise<MyInvitation[]> => {
  const data = await unwrap(http.get<ApiEnvelope<UnknownRecord>>('/invitations'))
  return Array.isArray(data.invitations) ? data.invitations.map(mapMyInvitation) : []
}

export const acceptInvitation = async (id: number): Promise<InvitationMutationResult> => {
  const data = await unwrap(
    http.post<ApiEnvelope<UnknownRecord>>(`/invitations/${id}/accept`),
  )
  return mapMutation(data)
}

export const declineInvitation = async (id: number): Promise<InvitationMutationResult> => {
  const data = await unwrap(
    http.post<ApiEnvelope<UnknownRecord>>(`/invitations/${id}/decline`),
  )
  return mapMutation(data)
}
