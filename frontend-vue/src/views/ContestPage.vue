<script setup lang="ts">
import axios from 'axios'
import { computed, onBeforeUnmount, onMounted, ref, watch } from 'vue'
import { useRoute, useRouter } from 'vue-router'
import NavBar from '../components/NavBar.vue'
import { toErrorMessage } from '../api/client'
import { toast } from '../store/toast'
import { fetchContest, finishContest, sendContestHeartbeat } from '../api/contests'
import { useAuthStore } from '../store/auth'
import type {
  ContestDetail,
  ContestParticipant,
  ContestStatus,
} from '../types/contest'
import { DIFFICULTY_LABELS } from '../utils/constants'
import { useContestEvents } from '../utils/contestEvents'
import { formatDateTime } from '../utils/teaching'

const route = useRoute()
const router = useRouter()
const authStore = useAuthStore()

const parseContestId = (value: unknown): number | null => {
  const parsed = Number(value)
  return Number.isInteger(parsed) && parsed > 0 ? parsed : null
}

const contestIdRef = ref<number | null>(parseContestId(route.params.id))
const enabledRef = ref(false)
const { flushNow: flushContestEvents } = useContestEvents(contestIdRef, enabledRef)

const detail = ref<ContestDetail | null>(null)
const isLoading = ref(true)
const error = ref('')
const actionError = ref('')
const isFinishing = ref(false)
const serverOffset = ref(0)
const serverNow = ref(Date.now())
const connectionState = ref<'online' | 'reconnecting' | 'timedOut'>('online')

let pollTimer: number | null = null
let tickTimer: number | null = null
let heartbeatTimer: number | null = null
let heartbeating = false
let syncing = false

const STATUS_LABELS: Record<ContestStatus, string> = {
  matching: '匹配中',
  running: '进行中',
  settling: '结算中',
  finished: '已结束',
  cancelled: '已取消',
}

const stopPolling = (): void => {
  if (pollTimer !== null) {
    window.clearInterval(pollTimer)
    pollTimer = null
  }
}

const startPolling = (): void => {
  if (pollTimer !== null) return
  pollTimer = window.setInterval(() => {
    void loadContest(true)
  }, 5000)
}

const stopHeartbeat = (): void => {
  if (heartbeatTimer !== null) {
    window.clearInterval(heartbeatTimer)
    heartbeatTimer = null
  }
}

const isPlaying = (status: ContestDetail['my_status'] | undefined): boolean =>
  status === 'active' || status === 'disconnected'

const canHeartbeat = (): boolean =>
  detail.value?.status === 'running' && isPlaying(detail.value.my_status)

const startHeartbeat = (): void => {
  if (heartbeatTimer !== null) return
  heartbeatTimer = window.setInterval(() => {
    void sendHeartbeat()
  }, 10000)
}

const sendHeartbeat = async (): Promise<void> => {
  if (!contestIdRef.value || heartbeating) return
  if (!canHeartbeat()) {
    stopHeartbeat()
    return
  }
  heartbeating = true
  try {
    const data = await sendContestHeartbeat(contestIdRef.value)
    if (detail.value) {
      detail.value.status = data.status
      detail.value.my_status = data.my_status
      detail.value.ends_at = data.ends_at
    }
    if (data.my_status === 'timed_out') {
      connectionState.value = 'timedOut'
      stopHeartbeat()
    } else if (data.my_status === 'finished') {
      connectionState.value = 'online'
      stopHeartbeat()
    } else {
      connectionState.value = 'online'
      startHeartbeat()
    }
  } catch (exception: unknown) {
    // 409 means the contest already ended or was cancelled; the detail poll
    // decides whether to redirect to results or show the cancelled notice.
    if (axios.isAxiosError(exception) && exception.response?.status === 409) {
      void loadContest(true)
    } else {
      connectionState.value = 'reconnecting'
    }
  } finally {
    heartbeating = false
  }
}

const keepHeartbeat = (data: ContestDetail): void => {
  if (data.status === 'running' && isPlaying(data.my_status)) {
    startHeartbeat()
    void sendHeartbeat()
  } else {
    stopHeartbeat()
  }
}

const loadContest = async (silent = false): Promise<void> => {
  if (!contestIdRef.value || syncing) return
  syncing = true
  if (!silent) isLoading.value = true
  try {
    const data = await fetchContest(contestIdRef.value)
    detail.value = data
    const serverTime = new Date(data.server_time).getTime()
    serverOffset.value = Number.isFinite(serverTime) ? serverTime - Date.now() : 0
    serverNow.value = Date.now() + serverOffset.value
    enabledRef.value = data.status === 'running' && isPlaying(data.my_status)
    if (data.my_status === 'timed_out') connectionState.value = 'timedOut'
    else if (data.status !== 'running') connectionState.value = 'online'
    if (data.status === 'finished') {
      stopPolling()
      stopHeartbeat()
      await router.replace(`/contests/${data.id}/result`)
      return
    }
    if (data.status === 'running' || data.status === 'settling') startPolling()
    else stopPolling()
    keepHeartbeat(data)
  } catch (exception: unknown) {
    if (!silent) error.value = toErrorMessage(exception)
  } finally {
    syncing = false
    if (!silent) isLoading.value = false
  }
}

const statusLabel = computed(() =>
  detail.value ? STATUS_LABELS[detail.value.status] : '',
)
const statusClass = computed(() => (detail.value ? `is-${detail.value.status}` : ''))

const remainingSeconds = computed(() => {
  if (!detail.value) return 0
  const endsAt = new Date(detail.value.ends_at).getTime()
  if (!Number.isFinite(endsAt)) return 0
  return Math.max(0, Math.floor((endsAt - serverNow.value) / 1000))
})

const countdown = computed(() => {
  const total = remainingSeconds.value
  const minutes = Math.floor(total / 60)
  const seconds = total % 60
  return `${String(minutes).padStart(2, '0')}:${String(seconds).padStart(2, '0')}`
})

const countdownClass = computed(() => {
  if (remainingSeconds.value <= 300 && detail.value?.status === 'running') return 'is-critical'
  if (remainingSeconds.value <= 900 && detail.value?.status === 'running') return 'is-warning'
  return ''
})

const problems = computed(() =>
  [...(detail.value?.problems ?? [])].sort((a, b) => a.position - b.position),
)

const solvedCount = computed(() => problems.value.filter((problem) => problem.accepted).length)
const attemptedCount = computed(
  () => problems.value.filter((problem) => !problem.accepted && problem.attempts > 0).length,
)
const activeParticipantCount = computed(
  () => detail.value?.participants.filter((participant) => participant.status === 'active').length ?? 0,
)

const participantStatusLabel = (participant: ContestParticipant): string => {
  if (participant.status === 'queued') return '排队中'
  if (participant.status === 'active') return '作答中'
  if (participant.status === 'disconnected') return '断线重连中'
  if (participant.status === 'timed_out') return '断线超时'
  return detail.value?.status === 'finished' ? '已结算' : '已离场'
}

const participantStatusClass = (participant: ContestParticipant): string => {
  if (participant.status === 'active') return 'is-active'
  if (participant.status === 'finished') return 'is-finished'
  if (participant.status === 'disconnected') return 'is-disconnected'
  if (participant.status === 'timed_out') return 'is-timed-out'
  return 'is-queued'
}

const isMe = (participant: ContestParticipant): boolean =>
  participant.user_id === authStore.user?.id

const finishAndLeave = async (): Promise<void> => {
  if (
    !detail.value ||
    !contestIdRef.value ||
    detail.value.my_status === 'finished' ||
    isFinishing.value
  ) {
    return
  }
  if (!window.confirm('完成后将停止计时并离场，成绩会在比赛结束后结算，确定继续吗？')) return
  isFinishing.value = true
  actionError.value = ''
  try {
    await flushContestEvents()
    const result = await finishContest(contestIdRef.value)
    toast.success(result.message || '已离场，成绩将在比赛结束后公布')
    enabledRef.value = false
    stopHeartbeat()
    await loadContest(true)
  } catch (exception: unknown) {
    actionError.value = toErrorMessage(exception)
  } finally {
    isFinishing.value = false
  }
}

const tick = (): void => {
  serverNow.value = Date.now() + serverOffset.value
}

const handleVisibilityChange = (): void => {
  if (document.visibilityState !== 'visible' || !contestIdRef.value) return
  void loadContest(true)
  void sendHeartbeat()
}

watch(
  () => route.params.id,
  async () => {
    const nextId = parseContestId(route.params.id)
    if (nextId === contestIdRef.value) return
    enabledRef.value = false
    await flushContestEvents()
    stopPolling()
    stopHeartbeat()
    connectionState.value = 'online'
    contestIdRef.value = nextId
    detail.value = null
    error.value = ''
    actionError.value = ''
    if (!nextId) {
      isLoading.value = false
      error.value = '比赛地址无效'
      return
    }
    void loadContest(false)
  },
)

onMounted(() => {
  tickTimer = window.setInterval(tick, 1000)
  document.addEventListener('visibilitychange', handleVisibilityChange)
  if (contestIdRef.value) void loadContest(false)
  else {
    isLoading.value = false
    error.value = '比赛地址无效'
  }
})

onBeforeUnmount(() => {
  stopPolling()
  stopHeartbeat()
  document.removeEventListener('visibilitychange', handleVisibilityChange)
  if (tickTimer !== null) {
    window.clearInterval(tickTimer)
    tickTimer = null
  }
})
</script>

<template>
  <NavBar />
  <main class="teaching-page page-shell contest-page">
    <div v-if="isLoading && !detail" class="empty-state">
      <p>正在加载比赛</p>
    </div>
    <p v-else-if="error && !detail" class="form-error" role="alert">{{ error }}</p>

    <template v-else-if="detail">
      <header class="teaching-page-header contest-page-header">
        <div>
          <h1>{{ detail.event_id ? '赛事比赛' : '排位赛' }} #{{ detail.id }}</h1>
          <p class="teaching-subtle contest-header-meta">
            <span class="teaching-badge contest-status-badge" :class="statusClass">
              {{ statusLabel }}
            </span>
            <span>题目 {{ detail.problem_count }} 道</span>
            <span v-if="!detail.event_id">段位分 {{ detail.my_rating }}</span>
            <span>开始于 {{ formatDateTime(detail.starts_at) }}</span>
            <span>结束于 {{ formatDateTime(detail.ends_at) }}</span>
          </p>
        </div>
        <div class="contest-countdown" :class="countdownClass" aria-label="比赛倒计时">
          <span>
            {{ detail.status === 'running' ? '剩余时间' : detail.status === 'settling' ? '正在结算' : '比赛时间' }}
          </span>
          <strong>{{ detail.status === 'running' ? countdown : '--:--' }}</strong>
        </div>
      </header>

      <p v-if="error" class="form-error" role="alert">{{ error }}</p>
      <p v-if="actionError" class="form-error" role="alert">{{ actionError }}</p>
      <p v-if="connectionState === 'reconnecting'" class="contest-connection-banner" role="status">
        网络中断，正在重连
      </p>
      <p v-else-if="connectionState === 'timedOut'" class="form-error" role="alert">
        断线超过 120 秒，成绩按断线时结算
      </p>

      <section v-if="detail.status === 'cancelled'" class="teaching-panel contest-cancelled">
        <p class="form-error">本场比赛已取消，成绩不会结算</p>
        <RouterLink class="primary-button" to="/contests">返回竞赛首页</RouterLink>
      </section>

      <section class="teaching-panel contest-finish-panel">
        <div>
          <strong>
            {{ detail.my_status === 'finished'
              ? '你已离场'
              : detail.my_status === 'timed_out'
                ? '断线超时'
                : '完成后可以提前离场' }}
          </strong>
          <p v-if="detail.my_status === 'finished'" class="teaching-subtle">
            成绩将在{{ detail.event_id ? '赛事结束' : '比赛结束' }}后公布，你可以继续留在本页查看题目与选手状态
          </p>
          <p v-else-if="detail.my_status === 'timed_out'" class="teaching-subtle">
            成绩按断线前已提交的内容结算，不能再提交本场比赛
          </p>
          <p v-else class="teaching-subtle">
            离场后不能再提交本场比赛的题目，比赛结束时间为
            {{ formatDateTime(detail.ends_at) }}
          </p>
        </div>
        <button
          class="primary-button"
          type="button"
          :disabled="detail.my_status !== 'active' || isFinishing || detail.status !== 'running'"
          @click="finishAndLeave"
        >
          {{ detail.my_status === 'finished'
            ? '已离场'
            : detail.my_status === 'timed_out'
              ? '已超时'
              : isFinishing
                ? '正在离场'
                : '完成并离场' }}
        </button>
      </section>

      <section class="contest-progress-strip" aria-label="比赛进度">
        <div>
          <span>我的进度</span>
          <strong>{{ solvedCount }}<small>/{{ problems.length }}</small></strong>
          <em>已通过题目</em>
        </div>
        <div>
          <span>已尝试</span>
          <strong>{{ attemptedCount }}</strong>
          <em>道未通过题目</em>
        </div>
        <div>
          <span>场上选手</span>
          <strong>{{ activeParticipantCount }}<small>/{{ detail.participants.length }}</small></strong>
          <em>正在作答</em>
        </div>
        <div class="contest-progress-meter">
          <span>完成度</span>
          <div class="contest-progress-track" role="progressbar" :aria-valuenow="solvedCount" :aria-valuemin="0" :aria-valuemax="problems.length">
            <i :style="{ width: `${problems.length ? (solvedCount / problems.length) * 100 : 0}%` }"></i>
          </div>
          <em>{{ problems.length ? Math.round((solvedCount / problems.length) * 100) : 0 }}%</em>
        </div>
      </section>

      <section class="teaching-section">
        <div class="section-heading">
          <div>
            <h2>题目</h2>
            <p class="section-heading-note">先完成有把握的题目，再回头处理高难度题目。</p>
          </div>
          <span class="teaching-subtle">共 {{ problems.length }} 题</span>
        </div>
        <div class="problem-table-wrap">
          <table class="problem-table contest-problems-table">
            <thead>
              <tr>
                <th scope="col" class="status-col"></th>
                <th scope="col">顺序</th>
                <th scope="col">题目</th>
                <th scope="col">难度</th>
                <th scope="col">标签</th>
                <th scope="col">分值</th>
                <th scope="col">我的表现</th>
              </tr>
            </thead>
            <tbody>
              <tr
                v-for="problem in problems"
                :key="problem.problem_id"
                :class="{ 'is-solved-row': problem.accepted, 'is-attempted-row': !problem.accepted && problem.attempts > 0 }"
              >
                <td class="status-col">
                  <span v-if="problem.accepted" class="contest-problem-status is-solved" title="已通过">✓</span>
                  <span v-else-if="problem.attempts > 0" class="contest-problem-status is-attempted" title="已尝试">·</span>
                </td>
                <td>{{ problem.position }}</td>
                <td>
                  <RouterLink
                    :to="`/problem/${problem.problem_id}?contest_id=${detail.id}`"
                    class="contest-problem-link"
                  >
                    {{ problem.title }}
                  </RouterLink>
                </td>
                <td>
                  <span :class="['difficulty', problem.difficulty]">
                    {{ DIFFICULTY_LABELS[problem.difficulty] }}
                  </span>
                </td>
                <td><span v-for="tag in problem.tags" :key="tag" class="tag">{{ tag }}</span></td>
                <td>{{ problem.points }}</td>
                <td>
                  <span v-if="problem.accepted" class="contest-result-label is-solved">已通过</span>
                  <span v-else-if="problem.attempts > 0" class="contest-result-label is-attempted">{{ problem.attempts }} 次尝试</span>
                  <span v-else class="contest-result-label">未开始</span>
                </td>
              </tr>
              <tr v-if="!problems.length">
                <td colspan="7" class="empty-cell">暂无题目</td>
              </tr>
            </tbody>
          </table>
        </div>
      </section>

      <section class="teaching-section">
        <div class="section-heading">
          <div>
            <h2>选手</h2>
            <p class="section-heading-note">实时显示本场参赛者的作答状态。</p>
          </div>
          <span class="teaching-subtle">{{ detail.participants.length }} 人</span>
        </div>
        <div class="problem-table-wrap">
          <table class="problem-table contest-participants-table">
            <thead>
              <tr>
                <th scope="col">选手</th>
                <th scope="col">状态</th>
                <th scope="col">通过题数</th>
                <th v-if="detail.status === 'finished'" scope="col">总分</th>
                <th v-if="detail.status === 'finished'" scope="col">排名</th>
              </tr>
            </thead>
            <tbody>
              <tr
                v-for="participant in detail.participants"
                :key="participant.user_id"
                :class="{ 'is-me': isMe(participant) }"
              >
                <td>
                  <span class="contest-participant-name">
                    {{ participant.username }}
                    <span v-if="isMe(participant)" class="ranking-you">我</span>
                  </span>
                </td>
                <td>
                  <span class="teaching-badge contest-participant-status" :class="participantStatusClass(participant)">{{ participantStatusLabel(participant) }}</span>
                </td>
                <td>{{ participant.solved_count }}</td>
                <td v-if="detail.status === 'finished'">{{ participant.total_score ?? '—' }}</td>
                <td v-if="detail.status === 'finished'">{{ participant.rank ?? '—' }}</td>
              </tr>
              <tr v-if="!detail.participants.length">
                <td :colspan="detail.status === 'finished' ? 5 : 3" class="empty-cell">暂无选手</td>
              </tr>
            </tbody>
          </table>
        </div>
      </section>
    </template>
  </main>
</template>
