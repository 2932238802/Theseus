<script setup lang="ts">
import { computed, onBeforeUnmount, onMounted, ref, watch } from 'vue'
import { useRoute, useRouter } from 'vue-router'
import NavBar from '../components/NavBar.vue'
import { toErrorMessage } from '../api/client'
import { toast } from '../store/toast'
import { fetchContest, finishContest } from '../api/contests'
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

let pollTimer: number | null = null
let tickTimer: number | null = null
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
    enabledRef.value = data.status === 'running' && data.my_status !== 'finished'
    if (data.status === 'finished') {
      stopPolling()
      await router.replace(`/contests/${data.id}/result`)
      return
    }
    if (data.status === 'running' || data.status === 'settling') startPolling()
    else stopPolling()
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

const problems = computed(() =>
  [...(detail.value?.problems ?? [])].sort((a, b) => a.position - b.position),
)

const participantStatusLabel = (participant: ContestParticipant): string => {
  if (participant.status === 'queued') return '排队中'
  if (participant.status === 'active') return '作答中'
  return detail.value?.status === 'finished' ? '已结算' : '已离场'
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

watch(
  () => route.params.id,
  async () => {
    const nextId = parseContestId(route.params.id)
    if (nextId === contestIdRef.value) return
    enabledRef.value = false
    await flushContestEvents()
    stopPolling()
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
  if (contestIdRef.value) void loadContest(false)
  else {
    isLoading.value = false
    error.value = '比赛地址无效'
  }
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
  <main class="teaching-page page-shell contest-page">
    <nav class="teaching-breadcrumb" aria-label="面包屑">
      <RouterLink to="/contests">竞赛</RouterLink>
      <span>/</span>
      <RouterLink v-if="detail?.event_id" :to="`/contests/events/${detail.event_id}`">赛事详情</RouterLink>
      <span v-if="detail?.event_id">/</span>
      <span>{{ contestIdRef ? `${detail?.event_id ? '赛事比赛' : '排位赛'} #${contestIdRef}` : '排位赛' }}</span>
    </nav>

    <div v-if="isLoading && !detail" class="empty-state">
      <p>正在加载比赛</p>
    </div>
    <p v-else-if="error && !detail" class="form-error" role="alert">{{ error }}</p>

    <template v-else-if="detail">
      <header class="teaching-page-header">
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
        <div class="contest-countdown" aria-label="比赛倒计时">
          <span>
            {{ detail.status === 'running' ? '剩余时间' : detail.status === 'settling' ? '正在结算' : '比赛时间' }}
          </span>
          <strong>{{ detail.status === 'running' ? countdown : '--:--' }}</strong>
        </div>
      </header>

      <p v-if="error" class="form-error" role="alert">{{ error }}</p>
      <p v-if="actionError" class="form-error" role="alert">{{ actionError }}</p>

      <section v-if="detail.status === 'cancelled'" class="teaching-panel contest-cancelled">
        <p class="form-error">本场比赛已取消，成绩不会结算</p>
        <RouterLink class="primary-button" to="/contests">返回竞赛首页</RouterLink>
      </section>

      <section class="teaching-panel contest-finish-panel">
        <div>
          <strong>{{ detail.my_status === 'finished' ? '你已离场' : '完成后可以提前离场' }}</strong>
          <p v-if="detail.my_status === 'finished'" class="teaching-subtle">
            成绩将在{{ detail.event_id ? '赛事结束' : '比赛结束' }}后公布，你可以继续留在本页查看题目与选手状态
          </p>
          <p v-else class="teaching-subtle">
            离场后不能再提交本场比赛的题目，比赛结束时间为
            {{ formatDateTime(detail.ends_at) }}
          </p>
        </div>
        <button
          class="primary-button"
          type="button"
          :disabled="detail.my_status === 'finished' || isFinishing || detail.status !== 'running'"
          @click="finishAndLeave"
        >
          {{ detail.my_status === 'finished' ? '已离场' : isFinishing ? '正在离场' : '完成并离场' }}
        </button>
      </section>

      <section class="teaching-section">
        <div class="section-heading">
          <h2>题目</h2>
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
              <tr v-for="problem in problems" :key="problem.problem_id">
                <td class="status-col">
                  <span v-if="problem.accepted" class="solved-icon" title="已通过">✓</span>
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
                  <span v-if="problem.accepted" class="solved-icon">已通过</span>
                  <span v-else-if="problem.attempts > 0">{{ problem.attempts }} 次尝试</span>
                  <span v-else>未开始</span>
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
          <h2>选手</h2>
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
              <tr v-for="participant in detail.participants" :key="participant.user_id">
                <td>
                  <span class="contest-participant-name">
                    {{ participant.username }}
                    <span v-if="isMe(participant)" class="ranking-you">我</span>
                  </span>
                </td>
                <td>
                  <span class="teaching-badge">{{ participantStatusLabel(participant) }}</span>
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
