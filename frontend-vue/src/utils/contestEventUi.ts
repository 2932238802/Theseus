import type { ContestEventCard, ContestEventStatus, ContestEventType } from '../types/contest'
import { formatDateTime } from './teaching'

export const EVENT_STATUS_LABELS: Record<ContestEventStatus, string> = {
  registration: '报名中',
  upcoming: '即将开始',
  running: '进行中',
  full: '已满员',
  finished: '已结束',
}

export const EVENT_TYPE_LABELS: Record<ContestEventType, string> = {
  official: '官方',
  teacher: '老师',
  school: '学校',
}

export const eventStatusLabel = (event: ContestEventCard): string => EVENT_STATUS_LABELS[event.status]

export const eventButtonLabel = (event: ContestEventCard): string => {
  if (!event.eligible) return '暂不可参加'
  if (event.is_registered) return event.action === 'enter' ? '进入赛事' : '查看详情'
  switch (event.action) {
    case 'register':
      return '报名'
    case 'join':
      return '加入赛事'
    case 'enter':
      return '进入赛事'
    case 'full':
      return '已满员'
    case 'closed':
      return '已截止'
    default:
      return '查看详情'
  }
}

export const isEventActionDisabled = (event: ContestEventCard): boolean =>
  !event.eligible || event.action === 'full' || event.action === 'closed'

const pad = (value: number): string => String(value).padStart(2, '0')

export const clockLabel = (milliseconds: number): string => {
  const total = Math.max(0, Math.floor(milliseconds / 1000))
  const hours = Math.floor(total / 3600)
  const minutes = Math.floor((total % 3600) / 60)
  const seconds = total % 60
  return `${pad(hours)}:${pad(minutes)}:${pad(seconds)}`
}

export const eventTimeLabel = (event: ContestEventCard, now: number): string => {
  const startsAt = new Date(event.starts_at).getTime()
  const endsAt = new Date(event.ends_at).getTime()
  if (!Number.isFinite(startsAt) || !Number.isFinite(endsAt)) return ''
  if (event.status === 'running') return `还剩 ${clockLabel(endsAt - now)}`
  if (event.status === 'finished') return '已结束'
  const untilStart = startsAt - now
  if (untilStart > 0 && untilStart <= 24 * 3600 * 1000) {
    return `距开始 ${clockLabel(untilStart)}`
  }
  return `${formatDateTime(event.starts_at)} 开始`
}

export const eventDeadlineLabel = (event: ContestEventCard): string =>
  event.status === 'registration' && event.registration_deadline
    ? `截止报名 ${formatDateTime(event.registration_deadline)}`
    : ''

export const eventCapacityLabel = (event: ContestEventCard): string =>
  event.capacity == null
    ? `${event.registered_count} 人参加`
    : `${event.registered_count}/${event.capacity} 人`
