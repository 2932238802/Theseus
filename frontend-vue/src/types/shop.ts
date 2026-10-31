export type PlusApplicationStatus = 'pending' | 'approved' | 'rejected'
export type PlusApplicationKind = 'new' | 'renewal'

export interface PlusMembership {
  started_at: string
  expires_at: string
  days_left: number
}

export interface PlusApplication {
  id: number
  user_id: number
  username: string
  reason: string
  kind: PlusApplicationKind
  status: PlusApplicationStatus
  review_note: string | null
  reviewed_by: string | null
  reviewed_at: string | null
  membership_expires_at: string | null
  created_at: string
}

export interface MyPlusState {
  is_plus: boolean
  membership?: PlusMembership
  application?: PlusApplication
}

export interface PlusApplicationList {
  total: number
  page: number
  size: number
  items: PlusApplication[]
}

export interface PlusApplicationResolveResult {
  status: PlusApplicationStatus
  message: string
  expires_at?: string
}
