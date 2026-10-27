export interface ProfileAnalyticsSummary {
  acceptedProblems: number
  attemptedProblems: number
  totalSubmissions: number
  acceptedSubmissions: number
  acceptanceRate: number
  activeClasses: number
  streakDays: number
}

export interface ProfileTrendPoint {
  date: string
  submissions: number
  accepted: number
}

export interface ProfileDifficulty {
  difficulty: string
  attempted: number
  accepted: number
}

export interface ProfileTag {
  tag: string
  attempted: number
  accepted: number
}

export interface ProfileAnalytics {
  days: number
  summary: ProfileAnalyticsSummary
  trend: ProfileTrendPoint[]
  difficulty: ProfileDifficulty[]
  tags: ProfileTag[]
}

export interface ForumFavorite {
  postId: number
  title: string
  status: 'published' | 'hidden' | 'deleted'
  favoriteCount: number
  commentCount: number
  favoritedAt: string
  author: { id: number; username: string }
}

export interface ForumFavoriteList {
  total: number
  page: number
  size: number
  favorites: ForumFavorite[]
}

export type ThemeMode = 'light' | 'dark' | 'system'
