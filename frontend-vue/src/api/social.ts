import { type ApiEnvelope, unwrap } from './client'
import { http } from './http'
import { bool, nullableText, number, record, text, type UnknownRecord } from './parse'
import type {
  FeedCounts,
  FollowingListResult,
  FollowingUser,
  PrivacySettings,
} from '../types/social'

const mapFollowingUser = (value: unknown): FollowingUser => {
  const item = record(value)
  return {
    id: number(item.id),
    username: text(item.username),
    grade: nullableText(item.grade),
    role: text(item.role, 'student'),
    avatarUrl: nullableText(item.avatar_url),
    isPlus: bool(item.is_plus),
    isSameSchool: bool(item.is_same_school),
    followedAt: text(item.followed_at),
  }
}

export const followUser = async (userId: number): Promise<boolean> => {
  const data = await unwrap(
    http.post<ApiEnvelope<UnknownRecord>>(`/users/${userId}/follow`),
  )
  return bool(record(data).following, true)
}

export const unfollowUser = async (userId: number): Promise<boolean> => {
  const data = await unwrap(
    http.delete<ApiEnvelope<UnknownRecord>>(`/users/${userId}/follow`),
  )
  return bool(record(data).following)
}

export const fetchFollowing = async (): Promise<FollowingListResult> => {
  const data = await unwrap(http.get<ApiEnvelope<UnknownRecord>>('/profile/following'))
  const item = record(data)
  const users = Array.isArray(item.users) ? item.users.map(mapFollowingUser) : []
  return { total: number(item.total, users.length), users }
}

export const fetchFeedCounts = async (): Promise<FeedCounts> => {
  const data = await unwrap(http.get<ApiEnvelope<UnknownRecord>>('/forum/feed-counts'))
  const item = record(data)
  return { following: number(item.following), school: number(item.school) }
}

export const fetchPrivacy = async (): Promise<PrivacySettings> => {
  const data = await unwrap(http.get<ApiEnvelope<UnknownRecord>>('/profile/privacy'))
  return { hideActivityFromSocial: bool(record(data).hide_activity_from_social) }
}

export const updatePrivacy = async (hideActivityFromSocial: boolean): Promise<PrivacySettings> => {
  const data = await unwrap(
    http.put<ApiEnvelope<UnknownRecord>>('/profile/privacy', {
      hide_activity_from_social: hideActivityFromSocial,
    }),
  )
  return { hideActivityFromSocial: bool(record(data).hide_activity_from_social) }
}
