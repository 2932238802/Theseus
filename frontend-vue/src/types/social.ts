export interface FollowingUser {
  id: number
  username: string
  grade: string | null
  role: string
  avatarUrl: string | null
  isPlus: boolean
  isSameSchool: boolean
  followedAt: string
}

export interface FollowingListResult {
  total: number
  users: FollowingUser[]
}

export interface FeedCounts {
  following: number
  school: number
}

export interface PrivacySettings {
  hideActivityFromSocial: boolean
}
