<script setup lang="ts">
import { computed, onBeforeUnmount, onMounted, ref } from 'vue'
import { useRouter } from 'vue-router'
import NavBar from '../components/NavBar.vue'
import { toErrorMessage } from '../api/client'
import { cancelMatch, fetchContestEvents, fetchCurrentContest, matchContest } from '../api/contests'
import type { CameraPermission, ContestEventCard } from '../types/contest'

const router = useRouter()

type Phase = 'loading' | 'idle' | 'queued'

const phase = ref<Phase>('loading')
const queuePosition = ref<number | null>(null)
const queuedAt = ref<string | null>(null)
const now = ref(Date.now())
const cameraPermission = ref<CameraPermission | null>(null)
const myRating = ref<number | null>(null)
const ratingWindow = ref<number>(100)
const isStarting = ref(false)
const isCancelling = ref(false)
const error = ref('')
const notice = ref('')
const rulesOpen = ref(false)
const startFlowOpen = ref(false)
const eventCards = ref<ContestEventCard[]>([])

let pollTimer: number | null = null
let tickTimer: number | null = null
let syncing = false
let epoch = 0

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
    myRating.value = current.my_rating
    ratingWindow.value = current.rating_window
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
    return '摄像头权限已读取并立即关闭，仅记录授权状态。'
  }
  if (cameraPermission.value === 'denied') {
    return '你拒绝了摄像头权限，仍可开始匹配，但本次会记录为「未授权」。'
  }
  return '当前环境无法检测摄像头，本次匹配会记录为「不可用」。'
})

const detectCameraPermission = async (): Promise<CameraPermission> => {
  if (!navigator.mediaDevices?.getUserMedia) return 'unavailable'
  try {
    const stream = await navigator.mediaDevices.getUserMedia({ video: true })
    stream.getTracks().forEach((track) => track.stop())
    return 'granted'
  } catch (exception: unknown) {
    if (exception instanceof Error && exception.name === 'NotAllowedError') {
      return 'denied'
    }
    return 'unavailable'
  }
}

const startMatch = async (): Promise<void> => {
  if (isStarting.value) return
  startFlowOpen.value = true
}

const confirmStartMatch = async (): Promise<void> => {
  if (isStarting.value) return
  isStarting.value = true
  error.value = ''
  notice.value = ''
  try {
    cameraPermission.value = await detectCameraPermission()
    startFlowOpen.value = false
    if (cameraPermission.value !== 'granted') {
      error.value = cameraPermission.value === 'denied'
        ? '需要开启摄像头权限后才能开始排位赛'
        : '当前环境无法使用摄像头，暂时不能开始排位赛'
      return
    }
    const result = await matchContest(cameraPermission.value)
    notice.value = result.message
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
    error.value = toErrorMessage(exception)
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
    notice.value = result.message
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

onMounted(() => {
  tickTimer = window.setInterval(() => {
    now.value = Date.now()
  }, 1000)
  void loadCurrent(false).finally(() => {
    if (phase.value === 'loading') phase.value = 'idle'
  })
  void fetchContestEvents().then((events) => { eventCards.value = events }).catch(() => { eventCards.value = [] })
})

onBeforeUnmount(() => {
  stopPolling()
  if (tickTimer !== null) {
    window.clearInterval(tickTimer)
    tickTimer = null
  }
})
</script>

<template>
  <NavBar />
  <main class="teaching-page page-shell contests-page">
    <p v-if="error" class="form-error" role="alert">{{ error }}</p>
    <p v-if="notice && phase !== 'idle'" class="teaching-success" role="status">{{ notice }}</p>

    <div v-if="phase === 'loading'" class="empty-state">
      <p>正在检查比赛状态</p>
    </div>

    <section v-else-if="phase === 'idle'" class="teaching-panel contest-intro">
      <div class="section-heading contest-intro-heading">
        <h2>4 人排位赛</h2>
        <div class="contest-heading-actions">
          <span class="teaching-badge">60 分钟 · 4 题</span>
          <button class="contest-rules-button" type="button" :aria-expanded="rulesOpen" @click="rulesOpen = true">比赛规则</button>
        </div>
      </div>
      <p class="contest-summary">与其他 3 名段位分相近的选手匹配</p>

      <div class="contest-rating-strip">
        <div>
          <span>我的段位分</span>
          <strong>{{ myRating ?? '—' }}</strong>
        </div>
        <div>
          <span>同场分差上限</span>
          <strong>±{{ ratingWindow }}</strong>
        </div>
        <p class="teaching-subtle">匹配范围 ±{{ ratingWindow }} 分</p>
      </div>

      <div class="teaching-toolbar contest-start-row">
        <button
          class="primary-button"
          type="button"
          :disabled="isStarting"
          @click="startMatch"
        >
          {{ isStarting ? '正在匹配' : '开始排位赛' }}
        </button>
      </div>

      <p v-if="notice" class="teaching-success" role="status">{{ notice }}</p>

      <section v-if="rulesOpen" class="contest-rules-drawer" role="dialog" aria-modal="true" aria-labelledby="contest-rules-title">
        <div class="contest-rules-backdrop" @click="rulesOpen = false"></div>
        <div class="contest-rules-panel">
          <header><h2 id="contest-rules-title">比赛规则</h2><button type="button" aria-label="关闭比赛规则" @click="rulesOpen = false">×</button></header>
          <div class="contest-rules-content">
            <section><h3>比赛流程</h3><p>匹配 4 名选手后自动开始比赛，完成题目并提交，比赛结束后统一结算。</p></section>
            <section><h3>计分与排名</h3><p>排名综合通过题数、完成速度和代码表现计算，详细成绩在比赛结束后公布。</p></section>
            <section><h3>匹配与离场</h3><p>匹配范围为当前段位分上下 {{ ratingWindow }} 分。匹配成功后不能取消，可以提前完成并离场。</p></section>
            <section><h3>设备要求</h3><p>开始排位赛必须开启摄像头。摄像头仅用于授权状态记录，比赛开始后会关闭采集。</p></section>
          </div>
        </div>
      </section>

      <section v-if="startFlowOpen" class="contest-rules-drawer" role="dialog" aria-modal="true" aria-labelledby="contest-camera-title">
        <div class="contest-rules-backdrop" @click="startFlowOpen = false"></div>
        <div class="contest-rules-panel contest-start-panel">
          <header><h2 id="contest-camera-title">开启摄像头</h2><button type="button" aria-label="取消开始排位赛" @click="startFlowOpen = false">×</button></header>
          <div class="contest-rules-content">
            <p>开始排位赛需要开启摄像头。系统只记录授权状态，不会录制或上传视频。继续后，浏览器会请求摄像头权限。</p>
            <p v-if="cameraPermission === 'denied'" class="form-error">上次授权未通过，请在浏览器网站设置中允许摄像头后重试。</p>
            <p v-if="cameraPermission === 'unavailable'" class="form-error">当前环境无法访问摄像头，请检查设备连接和浏览器权限。</p>
            <div class="contest-start-flow-actions">
              <button class="forum-secondary-button" type="button" @click="startFlowOpen = false">暂不开始</button>
              <button class="primary-button" type="button" :disabled="isStarting" @click="confirmStartMatch">{{ isStarting ? '正在检查权限' : '继续并开启摄像头' }}</button>
            </div>
          </div>
        </div>
      </section>
    </section>

    <section v-if="eventCards.length" class="teaching-panel contest-events" aria-label="限时赛事">
      <div class="section-heading"><h2>限时赛事</h2><span class="teaching-subtle">{{ eventCards.length }} 场</span></div>
      <div class="contest-event-grid">
        <article v-for="event in eventCards" :key="event.id" :class="['contest-event-card', { 'is-ineligible': !event.eligible }]">
          <div class="contest-event-card-head"><span class="teaching-badge">{{ event.status === 'running' ? '进行中' : event.status === 'registration' ? '报名中' : '即将开始' }}</span><span class="teaching-subtle">{{ event.organizer }}</span></div>
          <h3>{{ event.title }}</h3>
          <p>{{ event.scope || '公开赛事' }} · {{ event.registered_count ?? 0 }}{{ event.capacity ? `/${event.capacity}` : '' }} 人</p>
          <p v-if="!event.eligible" class="contest-ineligible-reason">{{ event.ineligible_reason || '当前不符合参赛条件' }}</p>
          <button class="forum-secondary-button" type="button" :disabled="!event.eligible || event.action === 'full' || event.action === 'closed'">{{ !event.eligible ? '暂不可参加' : event.is_registered ? '进入赛事' : event.action === 'join' ? '加入赛事' : '报名' }}</button>
        </article>
      </div>
    </section>

    <section v-else-if="phase === 'queued'" class="teaching-panel contest-queue" aria-live="polite">
      <div class="section-heading">
        <h2>正在匹配</h2>
        <span class="teaching-badge contest-status-badge is-matching">等待中</span>
      </div>
      <p class="contest-queue-pulse" aria-hidden="true">
        <span></span><span></span><span></span>
      </p>
      <p class="contest-queue-position">
        当前排队位置 <strong>{{ queuePosition ?? '—' }}</strong>
      </p>
      <p class="teaching-subtle">已等待 {{ elapsedLabel }}</p>
      <p class="teaching-subtle">
        段位分 {{ myRating ?? '—' }} · 仅匹配分差 ≤ {{ ratingWindow }} 的对手
      </p>
      <p class="teaching-subtle">系统每隔 3 秒刷新队列，匹配成功后会自动进入比赛。</p>

      <div class="teaching-toolbar contest-queue-actions">
        <button
          class="forum-secondary-button"
          type="button"
          :disabled="isCancelling"
          @click="cancelQueue"
        >
          {{ isCancelling ? '正在取消' : '取消匹配' }}
        </button>
      </div>
      <p class="run-note">匹配成功后不能取消，请保持页面打开。</p>
      <p v-if="cameraNote" class="teaching-subtle contest-camera-note">{{ cameraNote }}</p>
    </section>
  </main>
</template>
