<script setup lang="ts">
import { computed, nextTick, onBeforeUnmount, onMounted, ref, watch } from 'vue'
import { useRouter } from 'vue-router'
import NavBar from '../components/NavBar.vue'
import ContestEventCardView from '../components/ContestEventCard.vue'
import { toErrorMessage } from '../api/client'
import { toast } from '../store/toast'
import {
  cancelMatch,
  enterContestEvent,
  fetchContestEventDetail,
  fetchCurrentContest,
  fetchFeaturedContests,
  joinContestEvent,
  matchContest,
  registerContestEvent,
} from '../api/contests'
import type {
  CameraPermission,
  ContestEventCard,
  ContestEventDetail,
  ContestFeatured,
  ScreenPermission,
} from '../types/contest'
import { EVENT_STATUS_LABELS, EVENT_TYPE_LABELS, eventCapacityLabel } from '../utils/contestEventUi'
import { onRealtime } from '../utils/realtime'
import { formatDateTime } from '../utils/teaching'

const router = useRouter()

type Phase = 'loading' | 'idle' | 'queued'
type DrawerKind = 'rules' | 'start' | 'event'

const phase = ref<Phase>('loading')
const queuePosition = ref<number | null>(null)
const queuedAt = ref<string | null>(null)
const now = ref(Date.now())
const serverOffset = ref(0)
const cameraPermission = ref<CameraPermission | null>(null)
const screenPermission = ref<ScreenPermission | null>(null)
const startFlowError = ref('')
const currentMyRating = ref<number | null>(null)
const isStarting = ref(false)
const isCancelling = ref(false)
const error = ref('')
const rulesOpen = ref(false)
const startFlowOpen = ref(false)

const featured = ref<ContestFeatured | null>(null)
const eventsLoading = ref(true)
const eventsError = ref('')
const eventActionId = ref<number | null>(null)
const eventActionError = ref('')

const eventDetailOpen = ref(false)
const eventDetail = ref<ContestEventDetail | null>(null)
const eventDetailLoading = ref(false)
const eventDetailError = ref('')

const rulesPanel = ref<HTMLElement | null>(null)
const startPanel = ref<HTMLElement | null>(null)
const eventPanel = ref<HTMLElement | null>(null)

let pollTimer: number | null = null
let tickTimer: number | null = null
let refreshTimer: number | null = null
let syncing = false
let featuredSyncing = false
let epoch = 0
let restoreFocus: HTMLElement | null = null
let lastBoundaryRefresh = 0
let unsubscribeMatchFound: (() => void) | null = null

const stopPolling = (): void => {
  if (pollTimer !== null) {
    window.clearInterval(pollTimer)
    pollTimer = null
  }
}

const startPolling = (): void => {
  if (pollTimer !== null) return
  pollTimer = window.setInterval(() => {
    void loadCurrent(true)
  }, 3000)
}

const loadCurrent = async (silent = false): Promise<void> => {
  if (syncing) return
  const requestEpoch = epoch
  syncing = true
  try {
    const current = await fetchCurrentContest()
    if (requestEpoch !== epoch) return
    currentMyRating.value = current.my_rating
    if (current.state === 'contest' && current.contest) {
      stopPolling()
      await router.replace(`/contests/${current.contest.id}`)
      return
    }
    if (current.state === 'queued') {
      phase.value = 'queued'
      queuePosition.value = current.queue_position
      if (current.queued_at) queuedAt.value = current.queued_at
      startPolling()
      return
    }
    phase.value = 'idle'
    queuePosition.value = null
    queuedAt.value = null
    stopPolling()
  } catch (exception: unknown) {
    if (!silent) error.value = toErrorMessage(exception)
    if (phase.value === 'loading') phase.value = 'idle'
  } finally {
    syncing = false
  }
}

const loadFeatured = async (silent = false): Promise<void> => {
  if (featuredSyncing) return
  featuredSyncing = true
  if (!silent) eventsLoading.value = true
  try {
    const data = await fetchFeaturedContests()
    featured.value = data
    eventsError.value = ''
    const serverTime = new Date(data.server_time).getTime()
    if (Number.isFinite(serverTime)) serverOffset.value = serverTime - Date.now()
    if (currentMyRating.value === null) currentMyRating.value = data.ranked.my_rating
  } catch (exception: unknown) {
    if (!silent) eventsError.value = toErrorMessage(exception)
  } finally {
    featuredSyncing = false
    eventsLoading.value = false
  }
}

const ranked = computed(() => featured.value?.ranked ?? null)
const rankedRules = computed(() => featured.value?.ranked.rules ?? [])
const events = computed(() => featured.value?.events ?? [])
const eventsTotal = computed(() => featured.value?.events_total ?? events.value.length)
const myRating = computed(() => currentMyRating.value ?? featured.value?.ranked.my_rating ?? null)
const participantLabel = computed(() => `${ranked.value?.participants ?? 4} 人`)
const durationLabel = computed(() => `${ranked.value?.duration_minutes ?? 60} 分钟`)
const problemLabel = computed(() => `${ranked.value?.problem_count ?? 4} 题`)

const elapsedLabel = computed(() => {
  if (!queuedAt.value) return '0 分 00 秒'
  const started = new Date(queuedAt.value).getTime()
  if (!Number.isFinite(started)) return '0 分 00 秒'
  const total = Math.max(0, Math.floor((now.value - started) / 1000))
  const minutes = Math.floor(total / 60)
  const seconds = total % 60
  return `${minutes} 分 ${String(seconds).padStart(2, '0')} 秒`
})

const cameraNote = computed(() => {
  if (!cameraPermission.value) return ''
  if (cameraPermission.value === 'granted') {
    return '摄像头权限已读取并立即关闭，仅记录授权状态'
  }
  if (cameraPermission.value === 'denied') {
    return '摄像头授权未通过，请在浏览器网站设置中允许后重试'
  }
  return '当前环境无法检测摄像头'
})

const screenNote = computed(() => {
  if (!screenPermission.value) return ''
  if (screenPermission.value === 'granted') {
    return '屏幕共享权限已读取并立即关闭，仅记录授权状态'
  }
  if (screenPermission.value === 'denied') {
    return '屏幕共享未通过，请重新选择要共享的屏幕'
  }
  return '当前环境无法共享屏幕'
})

const bothPermissionsGranted = computed(
  () => cameraPermission.value === 'granted' && screenPermission.value === 'granted',
)

const replaceEvent = (card: ContestEventCard): void => {
  const current = featured.value
  if (!current) return
  featured.value = {
    ...current,
    events: current.events.map((event) => (event.id === card.id ? { ...event, ...card } : event)),
  }
}

const nextTransitionAt = computed<number | null>(() => {
  const boundaries: number[] = []
  for (const event of events.value) {
    const values = [
      event.registration_opens_at,
      event.registration_deadline,
      event.starts_at,
      event.ends_at,
    ]
    for (const value of values) {
      if (!value) continue
      const time = new Date(value).getTime()
      if (Number.isFinite(time) && time > now.value) boundaries.push(time)
    }
  }
  return boundaries.length ? Math.min(...boundaries) : null
})

const activeDrawer = computed<DrawerKind | null>(() => {
  if (startFlowOpen.value) return 'start'
  if (eventDetailOpen.value) return 'event'
  if (rulesOpen.value) return 'rules'
  return null
})

watch(activeDrawer, async (next, previous) => {
  if (next) {
    // 从一个抽屉直接切换到另一个时，保留最初的焦点来源。
    if (!previous) {
      restoreFocus = document.activeElement instanceof HTMLElement ? document.activeElement : null
    }
    await nextTick()
    const panel = next === 'rules' ? rulesPanel.value : next === 'start' ? startPanel.value : eventPanel.value
    panel?.querySelector<HTMLButtonElement>('header button')?.focus()
    return
  }
  if (previous) {
    restoreFocus?.focus()
    restoreFocus = null
  }
})

const openRules = (): void => {
  startFlowOpen.value = false
  eventDetailOpen.value = false
  rulesOpen.value = true
}

const openStartFlow = (): void => {
  if (isStarting.value) return
  rulesOpen.value = false
  eventDetailOpen.value = false
  startFlowError.value = ''
  startFlowOpen.value = true
}

const openEventDetail = async (event: ContestEventCard): Promise<void> => {
  rulesOpen.value = false
  startFlowOpen.value = false
  eventDetailOpen.value = true
  eventDetail.value = null
  eventDetailError.value = ''
  eventDetailLoading.value = true
  try {
    const data = await fetchContestEventDetail(event.id)
    eventDetail.value = data
    replaceEvent(data)
  } catch (exception: unknown) {
    eventDetailError.value = toErrorMessage(exception)
  } finally {
    eventDetailLoading.value = false
  }
}

const handleEventAction = async (event: ContestEventCard): Promise<void> => {
  if (eventActionId.value !== null) return
  eventActionError.value = ''
  if (!event.eligible) {
    eventActionError.value = event.ineligible_reason ?? '当前不符合参赛条件'
    return
  }
  if (event.action === 'full') {
    eventActionError.value = '名额已满'
    return
  }
  if (event.action === 'closed') {
    eventActionError.value = event.ineligible_reason ?? '当前不可报名'
    return
  }
  if (event.action === 'enter') {
    eventActionId.value = event.id
    try {
      const result = await enterContestEvent(event.id)
      await router.push({ name: 'contest', params: { id: result.contest_id } })
    } catch (exception: unknown) {
      eventActionError.value = toErrorMessage(exception)
      void loadFeatured(true)
    } finally {
      eventActionId.value = null
    }
    return
  }
  if (event.action === 'register' || event.action === 'join') {
    eventActionId.value = event.id
    try {
      const card =
        event.action === 'join'
          ? await joinContestEvent(event.id)
          : await registerContestEvent(event.id)
      replaceEvent(card)
      if (eventDetail.value && eventDetail.value.id === card.id) {
        eventDetail.value = { ...eventDetail.value, ...card }
      }
      toast.success(
        card.is_registered
          ? event.action === 'join'
            ? '已加入赛事'
            : '报名成功'
          : '操作成功',
      )
    } catch (exception: unknown) {
      eventActionError.value = toErrorMessage(exception)
      // 可能刚刚被其他人报满或管理员下架，静默同步一次状态。
      void loadFeatured(true)
    } finally {
      eventActionId.value = null
    }
    return
  }
  void openEventDetail(event)
}

interface PermissionProbe {
  permission: CameraPermission
  message: string
}

const detectCameraPermission = async (): Promise<PermissionProbe> => {
  if (!window.isSecureContext) {
    return {
      permission: 'unavailable',
      message: '当前页面不是安全上下文，浏览器不会弹出摄像头授权，请通过 localhost 或 HTTPS 访问',
    }
  }
  if (!navigator.mediaDevices?.getUserMedia) {
    return {
      permission: 'unavailable',
      message: '当前浏览器不支持摄像头采集，请使用最新版 Chrome、Edge 或 Firefox',
    }
  }
  try {
    const stream = await navigator.mediaDevices.getUserMedia({ video: true })
    stream.getTracks().forEach((track) => track.stop())
    return { permission: 'granted', message: '' }
  } catch (exception: unknown) {
    const name = exception instanceof Error ? exception.name : ''
    if (name === 'NotAllowedError' || name === 'PermissionDeniedError') {
      return {
        permission: 'denied',
        message: '摄像头权限被拒绝，请在浏览器地址栏的网站设置中允许摄像头后重试',
      }
    }
    if (name === 'NotFoundError' || name === 'DevicesNotFoundError') {
      return {
        permission: 'unavailable',
        message: '未检测到可用摄像头，请连接摄像头或检查系统隐私设置后重试',
      }
    }
    if (name === 'NotReadableError' || name === 'TrackStartError') {
      return {
        permission: 'unavailable',
        message: '摄像头被其他程序占用，请关闭占用摄像头的应用后重试',
      }
    }
    if (name === 'SecurityError') {
      return {
        permission: 'unavailable',
        message: '浏览器安全策略禁止访问摄像头，请检查站点权限设置',
      }
    }
    return {
      permission: 'unavailable',
      message: name ? `摄像头启动失败（${name}），请检查系统摄像头设置` : '摄像头启动失败，请检查系统摄像头设置',
    }
  }
}

const detectScreenPermission = async (): Promise<PermissionProbe> => {
  if (!window.isSecureContext) {
    return {
      permission: 'unavailable',
      message: '当前页面不是安全上下文，浏览器不会弹出屏幕共享，请通过 localhost 或 HTTPS 访问',
    }
  }
  if (!navigator.mediaDevices?.getDisplayMedia) {
    return {
      permission: 'unavailable',
      message: '当前浏览器不支持屏幕共享，请使用最新版 Chrome、Edge 或 Firefox',
    }
  }
  try {
    const stream = await navigator.mediaDevices.getDisplayMedia({ video: true, audio: false })
    stream.getTracks().forEach((track) => track.stop())
    return { permission: 'granted', message: '' }
  } catch (exception: unknown) {
    const name = exception instanceof Error ? exception.name : ''
    if (name === 'NotAllowedError' || name === 'PermissionDeniedError' || name === 'AbortError') {
      return {
        permission: 'denied',
        message: '屏幕共享被取消或拒绝，请重新点击并选择要共享的屏幕',
      }
    }
    if (name === 'NotFoundError' || name === 'DevicesNotFoundError') {
      return {
        permission: 'unavailable',
        message: '未找到可共享的屏幕，请检查系统屏幕录制权限后重试',
      }
    }
    if (name === 'NotReadableError' || name === 'TrackStartError') {
      return {
        permission: 'unavailable',
        message: '屏幕共享启动失败，请关闭占用屏幕录制的程序后重试',
      }
    }
    if (name === 'SecurityError') {
      return {
        permission: 'unavailable',
        message: '浏览器安全策略禁止屏幕共享，请检查站点权限设置',
      }
    }
    return {
      permission: 'unavailable',
      message: name ? `屏幕共享启动失败（${name}），请检查系统屏幕录制权限` : '屏幕共享启动失败，请检查系统屏幕录制权限',
    }
  }
}

const requestCamera = async (): Promise<void> => {
  if (isStarting.value) return
  isStarting.value = true
  startFlowError.value = ''
  try {
    const probe = await detectCameraPermission()
    cameraPermission.value = probe.permission
    if (probe.permission !== 'granted') {
      startFlowError.value = probe.message
    }
  } finally {
    isStarting.value = false
  }
}

const requestScreen = async (): Promise<void> => {
  if (isStarting.value) return
  isStarting.value = true
  startFlowError.value = ''
  try {
    const probe = await detectScreenPermission()
    screenPermission.value = probe.permission
    if (probe.permission !== 'granted') {
      startFlowError.value = probe.message
    }
  } finally {
    isStarting.value = false
  }
}

const beginMatch = async (): Promise<void> => {
  if (isStarting.value) return
  if (cameraPermission.value !== 'granted' || screenPermission.value !== 'granted') {
    startFlowError.value = '请先完成摄像头和屏幕共享授权'
    return
  }
  isStarting.value = true
  startFlowError.value = ''
  error.value = ''
  try {
    const result = await matchContest(cameraPermission.value, screenPermission.value)
    startFlowOpen.value = false
    toast.success(result.message)
    if (result.state === 'matched') {
      if (result.contest) {
        stopPolling()
        await router.push(`/contests/${result.contest.id}`)
      } else {
        error.value = '匹配成功但未获取到比赛信息，请刷新后重试'
      }
      return
    }
    phase.value = 'queued'
    queuePosition.value = result.queue_position
    queuedAt.value = new Date().toISOString()
    startPolling()
  } catch (exception: unknown) {
    startFlowError.value = toErrorMessage(exception)
  } finally {
    isStarting.value = false
  }
}

const cancelQueue = async (): Promise<void> => {
  if (isCancelling.value) return
  isCancelling.value = true
  error.value = ''
  epoch += 1
  try {
    const result = await cancelMatch()
    toast.success(result.message)
    stopPolling()
    phase.value = 'idle'
    queuePosition.value = null
    queuedAt.value = null
  } catch (exception: unknown) {
    error.value = toErrorMessage(exception)
    // 可能刚刚匹配成功，立即同步一次状态。
    void loadCurrent(true)
  } finally {
    isCancelling.value = false
  }
}

const tick = (): void => {
  now.value = Date.now() + serverOffset.value
  const boundary = nextTransitionAt.value
  // 跨过开始/截止/结束节点时刷新一次；失败时限流重试，避免每秒打接口。
  if (boundary !== null && now.value >= boundary && now.value - lastBoundaryRefresh > 5000) {
    lastBoundaryRefresh = now.value
    void loadFeatured(true)
  }
}

const onKeydown = (event: KeyboardEvent): void => {
  if (event.key !== 'Escape') return
  if (startFlowOpen.value) {
    startFlowOpen.value = false
  } else if (eventDetailOpen.value) {
    eventDetailOpen.value = false
  } else if (rulesOpen.value) {
    rulesOpen.value = false
  }
}

onMounted(() => {
  tickTimer = window.setInterval(tick, 1000)
  refreshTimer = window.setInterval(() => {
    void loadFeatured(true)
  }, 60_000)
  window.addEventListener('keydown', onKeydown)
  // 匹配成局只有发起请求的人能同步拿到结果，其余选手靠这条推送立即进入比赛页。
  unsubscribeMatchFound = onRealtime('match.found', (data) => {
    if (phase.value !== 'queued') return
    const contestId = Number(data.contest_id)
    if (!Number.isFinite(contestId) || contestId <= 0) return
    stopPolling()
    void router.push(`/contests/${contestId}`)
  })
  void loadCurrent(false).finally(() => {
    if (phase.value === 'loading') phase.value = 'idle'
  })
  void loadFeatured(false)
})

onBeforeUnmount(() => {
  unsubscribeMatchFound?.()
  unsubscribeMatchFound = null
  stopPolling()
  if (tickTimer !== null) {
    window.clearInterval(tickTimer)
    tickTimer = null
  }
  if (refreshTimer !== null) {
    window.clearInterval(refreshTimer)
    refreshTimer = null
  }
  window.removeEventListener('keydown', onKeydown)
})
</script>

<template>
  <NavBar />
  <main class="teaching-page page-shell contests-page">
    <p v-if="error" class="form-error" role="alert">{{ error }}</p>

    <div v-if="phase === 'loading'" class="empty-state">
      <p>正在检查比赛状态</p>
    </div>

    <section v-else-if="phase === 'idle'" class="teaching-panel contest-intro">
      <div class="section-heading contest-intro-heading">
        <h2>{{ ranked?.title ?? '4 人排位赛' }}</h2>
        <div class="contest-heading-actions">
          <span class="teaching-badge">{{ participantLabel }} · {{ durationLabel }} · {{ problemLabel }}</span>
          <RouterLink class="contest-rules-button contest-rules-link" :to="{ name: 'contest-rankings' }">
            排行榜
          </RouterLink>
          <button
            class="contest-rules-button"
            type="button"
            :aria-expanded="rulesOpen"
            @click="openRules"
          >
            比赛规则
          </button>
        </div>
      </div>
      <p class="contest-summary">
        与段位分相近的 {{ Math.max(1, (ranked?.participants ?? 4) - 1) }} 名选手匹配
      </p>

      <div class="contest-cta-row">
        <div class="contest-rating-strip">
          <span>我的段位分</span>
          <strong>{{ myRating ?? '—' }}</strong>
        </div>
        <button
          class="primary-button contest-start-button"
          type="button"
          :disabled="isStarting"
          @click="openStartFlow"
        >
          {{ isStarting ? '正在匹配' : '开始排位赛' }}
        </button>
      </div>

    </section>

    <section v-if="phase === 'queued'" class="teaching-panel contest-queue" aria-live="polite">
      <div class="section-heading">
        <h2>正在匹配</h2>
        <div class="contest-heading-actions">
          <span class="teaching-badge contest-status-badge is-matching">等待中</span>
          <button class="contest-rules-button" type="button" :aria-expanded="rulesOpen" @click="openRules">
            比赛规则
          </button>
        </div>
      </div>
      <p class="contest-queue-pulse" aria-hidden="true">
        <span></span><span></span><span></span>
      </p>
      <p class="contest-queue-position">
        当前排队位置 <strong>{{ queuePosition ?? '—' }}</strong>
      </p>
      <p class="teaching-subtle">已等待 {{ elapsedLabel }}</p>
      <p class="teaching-subtle">段位分 {{ myRating ?? '—' }}</p>
      <p class="teaching-subtle">系统每隔 3 秒刷新队列，匹配成功后会自动进入比赛</p>

      <div class="teaching-toolbar contest-queue-actions">
        <button class="forum-secondary-button" type="button" :disabled="isCancelling" @click="cancelQueue">
          {{ isCancelling ? '正在取消' : '取消匹配' }}
        </button>
      </div>
      <p class="run-note">匹配成功后不能取消，请保持页面打开</p>
      <p v-if="cameraNote" class="teaching-subtle contest-camera-note">{{ cameraNote }}</p>
      <p v-if="screenNote" class="teaching-subtle contest-camera-note">{{ screenNote }}</p>
    </section>

    <section
      v-if="rulesOpen"
      class="contest-rules-drawer"
      role="dialog"
      aria-modal="true"
      aria-labelledby="contest-rules-title"
    >
      <div class="contest-rules-backdrop" @click="rulesOpen = false"></div>
      <div ref="rulesPanel" class="contest-rules-panel">
        <header>
          <h2 id="contest-rules-title">比赛规则</h2>
          <button type="button" aria-label="关闭比赛规则" @click="rulesOpen = false">×</button>
        </header>
        <div class="contest-rules-content">
          <p v-if="!rankedRules.length" class="teaching-subtle">规则加载中…</p>
          <details
            v-for="(group, index) in rankedRules"
            :key="group.title"
            class="contest-rule-group"
            :open="index === 0"
          >
            <summary>{{ group.title }}</summary>
            <ul class="contest-rule-list">
              <li v-for="item in group.items" :key="item">{{ item }}</li>
            </ul>
          </details>
        </div>
      </div>
    </section>

    <section
      v-if="startFlowOpen"
      class="contest-rules-drawer"
      role="dialog"
      aria-modal="true"
      aria-labelledby="contest-camera-title"
    >
      <div class="contest-rules-backdrop" @click="startFlowOpen = false"></div>
      <div ref="startPanel" class="contest-rules-panel contest-start-panel">
        <header>
          <h2 id="contest-camera-title">开始排位赛</h2>
          <button type="button" aria-label="取消开始排位赛" @click="startFlowOpen = false">×</button>
        </header>
        <div class="contest-rules-content">
          <p>开始排位赛前需要完成以下两项授权；系统只记录授权状态，不会录制或上传画面</p>
          <ul class="contest-start-checks">
            <li>
              <div>
                <strong>摄像头</strong>
                <span class="teaching-subtle">{{ cameraPermission === 'granted' ? '已授权' : '未授权' }}</span>
              </div>
              <button
                class="forum-secondary-button"
                type="button"
                :disabled="isStarting"
                @click="requestCamera"
              >
                {{ cameraPermission === 'granted' ? '重新检测' : '开启摄像头' }}
              </button>
            </li>
            <li>
              <div>
                <strong>屏幕共享</strong>
                <span class="teaching-subtle">{{ screenPermission === 'granted' ? '已授权' : '未授权' }}</span>
              </div>
              <button
                class="forum-secondary-button"
                type="button"
                :disabled="isStarting"
                @click="requestScreen"
              >
                {{ screenPermission === 'granted' ? '重新选择' : '共享屏幕' }}
              </button>
            </li>
          </ul>
          <p v-if="startFlowError" class="form-error" role="alert">{{ startFlowError }}</p>
          <div class="contest-start-flow-actions">
            <button class="forum-secondary-button" type="button" @click="startFlowOpen = false">暂不开始</button>
            <button
              class="primary-button"
              type="button"
              :disabled="isStarting || !bothPermissionsGranted"
              @click="beginMatch"
            >
              {{ isStarting ? '正在检查权限' : '开始匹配' }}
            </button>
          </div>
        </div>
      </div>
    </section>

    <section
      v-if="eventDetailOpen"
      class="contest-rules-drawer"
      role="dialog"
      aria-modal="true"
      aria-labelledby="contest-event-title"
    >
      <div class="contest-rules-backdrop" @click="eventDetailOpen = false"></div>
      <div ref="eventPanel" class="contest-rules-panel">
        <header>
          <h2 id="contest-event-title">{{ eventDetail?.title ?? '赛事详情' }}</h2>
          <button type="button" aria-label="关闭赛事详情" @click="eventDetailOpen = false">×</button>
        </header>
        <div class="contest-rules-content">
          <p v-if="eventDetailLoading" class="teaching-subtle">正在加载赛事详情…</p>
          <p v-else-if="eventDetailError" class="form-error" role="alert">{{ eventDetailError }}</p>
          <template v-else-if="eventDetail">
            <p class="teaching-subtle">
              {{ eventDetail.organizer }} · {{ EVENT_TYPE_LABELS[eventDetail.type] }} ·
              {{ EVENT_STATUS_LABELS[eventDetail.status] }}
              <span v-if="eventDetail.is_registered" class="contest-event-registered">已报名</span>
            </p>
            <p>{{ formatDateTime(eventDetail.starts_at) }} – {{ formatDateTime(eventDetail.ends_at) }}</p>
            <p v-if="eventDetail.scope" class="teaching-subtle">{{ eventDetail.scope }} · {{ eventCapacityLabel(eventDetail) }}</p>
            <p v-if="eventDetail.description">{{ eventDetail.description }}</p>
            <p v-if="eventDetail.registration_deadline" class="teaching-subtle">
              截止报名 {{ formatDateTime(eventDetail.registration_deadline) }}
            </p>
            <details
              v-for="(group, index) in eventDetail.rules"
              :key="group.title"
              class="contest-rule-group"
              :open="index === 0"
            >
              <summary>{{ group.title }}</summary>
              <ul class="contest-rule-list">
                <li v-for="item in group.items" :key="item">{{ item }}</li>
              </ul>
            </details>
            <a
              v-if="eventDetail.registration_url"
              class="forum-secondary-button contest-event-link"
              :href="eventDetail.registration_url"
              target="_blank"
              rel="noopener noreferrer"
            >
              打开报名链接
            </a>
          </template>
        </div>
      </div>
    </section>

    <section class="teaching-panel contest-events" aria-label="限时赛事">
      <div class="section-heading">
        <h2>限时赛事</h2>
        <RouterLink class="contest-events-all" :to="{ name: 'contest-events' }">
          查看全部<span v-if="eventsTotal > events.length"> · {{ eventsTotal }} 场</span>
        </RouterLink>
      </div>

      <p v-if="eventActionError" class="form-error" role="alert">{{ eventActionError }}</p>

      <div v-if="eventsLoading" class="contest-event-grid" aria-busy="true">
        <div v-for="index in 2" :key="index" class="contest-event-card is-loading">
          <span class="skeleton-line"></span>
          <span class="skeleton-line skeleton-line-short"></span>
          <span class="skeleton-line"></span>
        </div>
      </div>

      <div v-else-if="eventsError" class="contest-events-feedback">
        <p class="form-error" role="alert">{{ eventsError }}</p>
        <button class="forum-secondary-button" type="button" @click="loadFeatured(false)">重试</button>
      </div>

      <p v-else-if="!events.length" class="teaching-subtle contest-events-empty">
        暂时没有可参加的限时赛事
      </p>

      <div v-else class="contest-event-grid">
        <ContestEventCardView
          v-for="event in events"
          :key="event.id"
          :event="event"
          :now="now"
          :busy="eventActionId === event.id"
          @open="openEventDetail"
          @action="handleEventAction"
        />
      </div>
    </section>
  </main>
</template>
