import type { Difficulty } from './oj'

export type ContestStatus = 'matching' | 'running' | 'settling' | 'finished' | 'cancelled'

export type ContestParticipantStatus = 'queued' | 'active' | 'finished'

export type ContestMatchState = 'queued' | 'matched'

export type ContestCurrentState = 'idle' | 'queued' | 'contest'

export type CameraPermission = 'granted' | 'denied' | 'unavailable'

export type ScreenPermission = CameraPermission

export type ContestEventStatus = 'registration' | 'upcoming' | 'running' | 'finished' | 'full'

export type ContestEventAction =
  | 'register'
  | 'join'
  | 'enter'
  | 'details'
  | 'full'
  | 'closed'

export type ContestEventType = 'official' | 'teacher' | 'school'

export interface EventRuleGroup {
  title: string
  items: string[]
}

export interface ContestEventCard {
  id: number
  title: string
  organizer: string
  type: ContestEventType
  status: ContestEventStatus
  starts_at: string
  ends_at: string
  registration_opens_at?: string | null
  registration_deadline?: string | null
  scope?: string | null
  capacity?: number | null
  registered_count: number
  is_registered: boolean
  is_followed: boolean
  eligible: boolean
  ineligible_reason?: string | null
  action: ContestEventAction
  rules_summary?: string | null
}

export interface ContestEventDetail extends ContestEventCard {
  description?: string | null
  registration_url?: string | null
  rules: EventRuleGroup[]
}

export interface RankedContestConfig {
  mode: 'ranked'
  title: string
  participants: number
  duration_minutes: number
  problem_count: number
  rating_window: number
  my_rating: number
  rules: EventRuleGroup[]
}

export interface ContestFeatured {
  ranked: RankedContestConfig
  events: ContestEventCard[]
  events_total: number
  server_time: string
}

export interface ContestEventListQuery {
  type?: ContestEventType
  status?: ContestEventStatus
  following?: boolean
  page?: number
  page_size?: number
}

export interface ContestEventList {
  events: ContestEventCard[]
  total: number
  page: number
  page_size: number
  server_time: string
}

export interface ContestSummary {
  id: number
  event_id?: number | null
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
  event_id: number | null
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
  disqualified: boolean
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
    event_id: number | null
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

export interface EnterContestEvent {
  event_id: number
  contest_id: number
}

export interface EventLeaderboardEntry {
  rank: number | null
  user_id: number
  username: string
  solved_count: number
  total_score: number | null
  is_me: boolean
}

export interface EventLeaderboard {
  event_id: number
  state: 'pending' | ContestStatus
  contest_id: number | null
  entries: EventLeaderboardEntry[]
  server_time: string
}

export interface RankedLeaderboardEntry {
  rank: number
  user_id: number
  username: string
  rating: number
  played: number
  wins: number
  is_me: boolean
}

export interface RankedLeaderboard {
  entries: RankedLeaderboardEntry[]
  my_rank: number | null
  my_rating: number
  total: number
  server_time: string
}

export interface AdminEventView {
  id: number
  title: string
  organizer: string
  type: ContestEventType
  description: string | null
  scope: string | null
  capacity: number | null
  registration_mode: 'open' | 'invite' | 'external'
  class_id: number | null
  registration_url: string | null
  registration_opens_at: string | null
  registration_deadline: string | null
  starts_at: string
  ends_at: string
  status: 'draft' | 'published' | 'cancelled'
  rules: EventRuleGroup[]
  problem_ids: number[]
  registered_count: number
  contest_id: number | null
  forum_post_id: number | null
  created_at: string
}

export interface AdminEventInput {
  title: string
  organizer: string
  description: string | null
  type: ContestEventType
  scope: string | null
  capacity: number | null
  registration_mode: 'open' | 'invite' | 'external'
  class_id: number | null
  registration_url: string | null
  registration_opens_at: string | null
  registration_closes_at: string | null
  starts_at: string
  ends_at: string
  status: 'draft' | 'published' | 'cancelled'
  rules: EventRuleGroup[]
  problem_ids: number[]
}

export type ProctorReviewStatus = 'pending' | 'cleared' | 'confirmed'

export interface ProctorContestInfo {
  id: number
  event_id: number | null
  event_title: string | null
  status: ContestStatus
  starts_at: string
  ends_at: string
}

export interface ProctorEventItem {
  id: number
  user_id: number
  username: string
  event_type: string
  payload: Record<string, unknown>
  client_time: string | null
  received_at: string
  review_status: ProctorReviewStatus
  review_note: string | null
  reviewed_by: string | null
  reviewed_at: string | null
  assigned_admin: string | null
  assigned_to_me: boolean
}

export interface ProctorEventListResponse {
  contest: ProctorContestInfo
  items: ProctorEventItem[]
  pending_count: number
}

export interface ProctorReviewResponse {
  message: string
  review_status: ProctorReviewStatus
  reputation_score: number | null
  disqualified: boolean
  rating_reranked: boolean
}
