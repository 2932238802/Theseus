<script setup lang="ts">
import { computed, onBeforeUnmount, onMounted, ref } from 'vue'
import { useRouter } from 'vue-router'
import NavBar from '../components/NavBar.vue'
import { toErrorMessage } from '../api/client'
import { cancelMatch, fetchCurrentContest, matchContest } from '../api/contests'
import type { CameraPermission } from '../types/contest'

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
  isStarting.value = true
  error.value = ''
  notice.value = ''
  try {
    cameraPermission.value = await detectCameraPermission()
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
      <div class="section-heading">
        <h2>4 人排位赛</h2>
        <span class="teaching-badge">60 分钟 · 4 题</span>
      </div>
      <p class="teaching-description">
        与其他 3 名段位分相近的选手同时匹配，在 60 分钟内完成 4 道题。比赛结束后按
        60% 通过题数 + 25% 速度 + 15% 代码书写综合排名。
      </p>

      <div class="contest-rating-strip">
        <div>
          <span>我的段位分</span>
          <strong>{{ myRating ?? '—' }}</strong>
        </div>
        <div>
          <span>同场分差上限</span>
          <strong>±{{ ratingWindow }}</strong>
        </div>
        <p class="teaching-subtle">
          只与分差不超过 {{ ratingWindow }} 分的对手匹配。在线人数够但分差过大时，宁可不开局。
        </p>
      </div>

      <ul class="contest-rules">
        <li>匹配成功后自动进入比赛，比赛中不能取消。</li>
        <li>可以提前「完成并离场」，离场后成绩保留并等待结算。</li>
        <li>开始匹配时会请求摄像头权限；授权状态仅用于比赛记录。</li>
      </ul>

      <div class="teaching-toolbar contest-start-row">
        <button
          class="primary-button"
          type="button"
          :disabled="isStarting"
          @click="startMatch"
        >
          {{ isStarting ? '正在匹配' : '开始排位赛' }}
        </button>
        <span class="teaching-subtle">即使未授权摄像头也可以继续匹配</span>
      </div>

      <p v-if="cameraNote" class="teaching-subtle contest-camera-note">{{ cameraNote }}</p>
      <p v-if="notice" class="teaching-success" role="status">{{ notice }}</p>
    </section>

    <section v-else class="teaching-panel contest-queue" aria-live="polite">
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
