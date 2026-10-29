import type { Difficulty } from './oj'

export interface HomeContinue {
  problem_id: number
  problem_title: string
  difficulty: Difficulty
  language: string
  status: string
  last_activity_at: string
  action: 'resume' | 'review'
}

export interface HomeStats {
  streak_days: number
  accepted_problems: number
  review_problems: number
  week_submissions: number
}

export interface HomeActivity {
  submission_id: number
  problem_id: number
  problem_title: string
  language: string
  status: string
  submitted_at: string
}

export interface HomeOverview {
  continue_learning: HomeContinue | null
  stats: HomeStats
  recent_activity: HomeActivity[]
}
