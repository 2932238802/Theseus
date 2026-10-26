export interface RankingEntry {
  rank: number
  userId: number
  username: string
  solved: number
  submissions: number
  acceptanceRate: number
}

export interface RankingResult {
  total: number
  page: number
  size: number
  entries: RankingEntry[]
  me: RankingEntry | null
}
