import type { Difficulty } from './oj'

export type ContestStatus = 'matching' | 'running' | 'settling' | 'finished' | 'cancelled'

export type ContestParticipantStatus = 'queued' | 'active' | 'finished'

export type ContestMatchState = 'queued' | 'matched'

export type ContestCurrentState = 'idle' | 'queued' | 'contest'

export type CameraPermission = 'granted' | 'denied' | 'unavailable'

export interface ContestSummary {
  id: number
  status: ContestStatus
  duration_seconds: number
  problem_count: number
  starts_at: string
  ends_at: string
  finished_at: string | null
  participant_count?: number
  my_status?: 'active' | 'finished'
  server_time?: string
}

export interface ContestMatchResult {
  state: ContestMatchState
  queue_position: number | null
  contest: ContestSummary | null
  message: string
}

export interface ContestCurrent {
  state: ContestCurrentState
  queue_position: number | null
  queued_at: string | null
  contest: ContestSummary | null
  my_rating: number
  rating_window: number
  server_time: string
}

export interface ContestProblemSummary {
  problem_id: number
  position: number
  title: string
  difficulty: Difficulty
  tags: string[]
  points: number
  accepted: boolean
  attempts: number
}

export interface ContestParticipant {
  user_id: number
  username: string
  status: ContestParticipantStatus
  finished_at: string | null
  solved_count: number
  total_score: number | null
  rank: number | null
}

export interface ContestDetail {
  id: number
  status: ContestStatus
  duration_seconds: number
  problem_count: number
  starts_at: string
  ends_at: string
  finished_at: string | null
  server_time: string
  my_status: 'active' | 'finished'
  my_rank: number | null
  my_total_score: number | null
  my_rating: number
  rating_window: number
  problems: ContestProblemSummary[]
  participants: ContestParticipant[]
}

export interface ContestRankingItem {
  rank: number
  user_id: number
  username: string
  total_score: number
  solved_count: number
  speed_score: number
  coding_score: number
  finished_at: string | null
  is_me: boolean
  rating_before: number | null
  rating_after: number | null
  rating_delta: number | null
}

export interface ContestMineDetail {
  problem_id: number
  title?: string
  accepted: boolean
  accepted_at: string | null
  attempts: number
  wrong_answer: number
  compile_error: number
  runtime_error: number
  time_score: number
}

export interface ContestMine extends ContestRankingItem {
  detail?: ContestMineDetail[]
}

export interface ContestResult {
  contest: {
    id: number
    status: ContestStatus
    duration_seconds: number
    problem_count: number
    starts_at: string
    ends_at: string
    finished_at: string | null
  }
  ranking: ContestRankingItem[]
  mine: ContestMine | null
}

export interface ContestEventInput {
  event_id: string
  event_type: string
  client_time: string
  session_id: string
  payload?: Record<string, unknown>
}

export interface ContestEventResult {
  accepted: number
  duplicates: number
  message: string
}
