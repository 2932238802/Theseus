export interface ProfileAnalyticsSummary {
  acceptedProblems: number
  attemptedProblems: number
  totalSubmissions: number
  acceptedSubmissions: number
  acceptanceRate: number
  activeClasses: number
  streakDays: number
  checkinStreak: number
  reputationScore: number
}

export interface ProfileBadge {
  code: string
  name: string
  description: string
  category: string
  thresholdDays: number
  earned: boolean
  awardedAt: string | null
  expiresAt: string | null
  hidden: boolean
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
  heatmap: ProfileTrendPoint[]
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

export interface ProblemFavorite {
  problemId: number
  title: string
  difficulty: 'easy' | 'medium' | 'hard'
  acceptanceRate: number
  favoritedAt: string
}

export interface ProblemFavoriteList {
  total: number
  page: number
  size: number
  favorites: ProblemFavorite[]
}

export interface CommentFavorite {
  commentId: number
  postId: number
  postTitle: string
  parentId: number | null
  bodyMd: string
  author: { displayName: string; isAnonymous: boolean; isSelf: boolean; isPlus: boolean }
  createdAt: string
  favoritedAt: string
}

export interface CommentFavoriteList {
  total: number
  page: number
  size: number
  favorites: CommentFavorite[]
}

export type ThemeMode = 'light' | 'dark' | 'system'
