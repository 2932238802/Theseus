export type PlusApplicationStatus = 'pending' | 'approved' | 'rejected'

export interface PlusApplication {
  id: number
  user_id: number
  username: string
  reason: string
  status: PlusApplicationStatus
  review_note: string | null
  reviewed_by: string | null
  reviewed_at: string | null
  created_at: string
}

export interface MyPlusState {
  is_plus: boolean
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
}
