import type { User } from '../types/oj'
import type { ForumFavoriteList, ProfileAnalytics } from '../types/profile'
import { type ApiEnvelope, unwrap } from './client'
import { type BackendUser, mapUser } from './adapters'
import { http } from './http'

interface EmailChangeData {
  message: string
  pending_email: string
}

interface PasswordChangeData {
  token: string
  user: BackendUser
}

interface AvatarData {
  message: string
  avatar_url: string
}

interface BackendAnalytics {
  days: number
  summary: {
    accepted_problems: number
    attempted_problems: number
    total_submissions: number
    accepted_submissions: number
    acceptance_rate: number
    active_classes: number
    streak_days: number
  }
  trend: Array<{ date: string; submissions: number; accepted: number }>
  difficulty: Array<{ difficulty: string; attempted: number; accepted: number }>
  tags: Array<{ tag: string; attempted: number; accepted: number }>
}

interface BackendFavorite {
  post_id: number
  title: string
  status: string
  favorite_count: number
  comment_count: number
  favorited_at: string
  author: { id: number; username: string }
}

interface BackendFavoriteList {
  total: number
  page: number
  size: number
  favorites: BackendFavorite[]
}

export const updateUsername = async (username: string): Promise<User> => {
  const data = await unwrap(http.put<ApiEnvelope<BackendUser>>('/profile/username', { username }))
  return mapUser(data)
}

export const requestEmailChange = async (
  email: string,
): Promise<{ message: string; pendingEmail: string }> => {
  const data = await unwrap(
    http.post<ApiEnvelope<EmailChangeData>>('/profile/email', { email }),
  )
  return { message: data.message, pendingEmail: data.pending_email }
}

export const cancelEmailChange = async (): Promise<User> => {
  const data = await unwrap(http.delete<ApiEnvelope<BackendUser>>('/profile/email/pending'))
  return mapUser(data)
}

export const changePassword = async (
  currentPassword: string,
  newPassword: string,
): Promise<{ token: string; user: User }> => {
  const data = await unwrap(
    http.put<ApiEnvelope<PasswordChangeData>>('/profile/password', {
      current_password: currentPassword,
      new_password: newPassword,
    }),
  )
  return { token: data.token, user: mapUser(data.user) }
}

export const logoutAllDevices = async (): Promise<void> => {
  await unwrap(http.post<ApiEnvelope<{ message: string }>>('/auth/logout-all'))
}

export const deleteAccount = async (password: string, username: string): Promise<void> => {
  await unwrap(
    http.delete<ApiEnvelope<{ message: string }>>('/profile', {
      data: { password, username },
    }),
  )
}

export const uploadAvatar = async (file: File): Promise<{ avatarUrl: string; message: string }> => {
  const form = new FormData()
  form.append('file', file)
  const data = await unwrap(
    http.post<ApiEnvelope<AvatarData>>('/profile/avatar', form),
  )
  return { avatarUrl: data.avatar_url, message: data.message }
}

export const removeAvatar = async (): Promise<User> => {
  const data = await unwrap(http.delete<ApiEnvelope<BackendUser>>('/profile/avatar'))
  return mapUser(data)
}

export const fetchAnalytics = async (days = 30): Promise<ProfileAnalytics> => {
  const data = await unwrap(
    http.get<ApiEnvelope<BackendAnalytics>>('/profile/analytics', { params: { days } }),
  )
  return {
    days: data.days,
    summary: {
      acceptedProblems: data.summary.accepted_problems,
      attemptedProblems: data.summary.attempted_problems,
      totalSubmissions: data.summary.total_submissions,
      acceptedSubmissions: data.summary.accepted_submissions,
      acceptanceRate: data.summary.acceptance_rate,
      activeClasses: data.summary.active_classes,
      streakDays: data.summary.streak_days,
    },
    trend: data.trend,
    difficulty: data.difficulty,
    tags: data.tags,
  }
}

export const fetchForumFavorites = async (
  page = 1,
  size = 20,
): Promise<ForumFavoriteList> => {
  const data = await unwrap(
    http.get<ApiEnvelope<BackendFavoriteList>>('/forum/favorites', {
      params: { page, size },
    }),
  )
  return {
    total: data.total,
    page: data.page,
    size: data.size,
    favorites: data.favorites.map((row) => ({
      postId: row.post_id,
      title: row.title,
      status:
        row.status === 'hidden' || row.status === 'deleted' ? row.status : 'published',
      favoriteCount: row.favorite_count,
      commentCount: row.comment_count,
      favoritedAt: row.favorited_at,
      author: row.author,
    })),
  }
}
