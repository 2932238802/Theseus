<script setup lang="ts">
import { computed, onBeforeUnmount, onMounted, ref } from 'vue'
import { useRoute, useRouter } from 'vue-router'
import NavBar from '../components/NavBar.vue'
import { toErrorMessage } from '../api/client'
import { toast } from '../store/toast'
import {
  enterContestEvent,
  fetchContestEventDetail,
  fetchContestEventLeaderboard,
  followContestEvent,
  joinContestEvent,
  registerContestEvent,
  unfollowContestEvent,
} from '../api/contests'
import type {
  ContestEventCard,
  ContestEventDetail,
  EventLeaderboard,
} from '../types/contest'
import {
  EVENT_TYPE_LABELS,
  eventButtonLabel,
  eventCapacityLabel,
  eventDeadlineLabel,
  eventStatusLabel,
  eventTimeLabel,
} from '../utils/contestEventUi'
import { formatDateTime } from '../utils/teaching'

const route = useRoute()
const router = useRouter()

const eventId = computed(() => Number(route.params.eventId))
const detail = ref<ContestEventDetail | null>(null)
const loading = ref(true)
const error = ref('')
const actionError = ref('')
const actionId = ref(false)
const followId = ref(false)
const entering = ref(false)
const leaderboard = ref<EventLeaderboard | null>(null)
const leaderboardLoading = ref(false)
const leaderboardError = ref('')
const now = ref(Date.now())

let tickTimer: number | null = null
let leaderboardTimer: number | null = null

const canEnter = computed(
  () => detail.value !== null && detail.value.is_registered && detail.value.action === 'enter',
)

const leaderboardStateLabel = computed(() => {
  switch (leaderboard.value?.state) {
    case 'pending':
      return '比赛尚未开始，以下为已报名选手'
    case 'running':
      return '比赛进行中，结束后公布最终排名'
    case 'settling':
      return '正在结算，请稍后刷新'
    case 'finished':
      return '最终排名'
    default:
      return ''
  }
})

const canRegister = computed(
  () =>
    detail.value !== null &&
    detail.value.eligible &&
    !detail.value.is_registered &&
    (detail.value.action === 'register' || detail.value.action === 'join'),
)

const loadLeaderboard = async (silent = false): Promise<void> => {
  if (!Number.isInteger(eventId.value) || eventId.value <= 0) return
  if (!silent) leaderboardLoading.value = true
  leaderboardError.value = ''
  try {
    leaderboard.value = await fetchContestEventLeaderboard(eventId.value)
  } catch (exception: unknown) {
    if (!silent) leaderboardError.value = toErrorMessage(exception)
  } finally {
    leaderboardLoading.value = false
  }
}

const load = async (): Promise<void> => {
  if (!Number.isInteger(eventId.value) || eventId.value <= 0) {
    error.value = '赛事不存在'
    loading.value = false
    return
  }
  loading.value = true
  error.value = ''
  try {
    detail.value = await fetchContestEventDetail(eventId.value)
    await loadLeaderboard()
  } catch (exception: unknown) {
    error.value = toErrorMessage(exception)
  } finally {
    loading.value = false
  }
}

const applyCard = (card: ContestEventCard): void => {
  if (detail.value && detail.value.id === card.id) {
    detail.value = { ...detail.value, ...card }
  }
}

const handleAction = async (): Promise<void> => {
  if (!detail.value || actionId.value || !canRegister.value) return
  actionError.value = ''
  actionId.value = true
  const action = detail.value.action
  try {
    const card =
      action === 'join'
        ? await joinContestEvent(detail.value.id)
        : await registerContestEvent(detail.value.id)
    applyCard(card)
    toast.success(
      card.is_registered
        ? action === 'join'
          ? '已加入赛事'
          : '报名成功'
        : '操作成功',
    )
    void loadLeaderboard(true)
  } catch (exception: unknown) {
    actionError.value = toErrorMessage(exception)
    void load()
  } finally {
    actionId.value = false
  }
}

const toggleFollow = async (): Promise<void> => {
  if (!detail.value || followId.value) return
  followId.value = true
  actionError.value = ''
  try {
    const result = detail.value.is_followed
      ? await unfollowContestEvent(detail.value.id)
      : await followContestEvent(detail.value.id)
    applyCard({ ...detail.value, is_followed: result.is_followed })
  } catch (exception: unknown) {
    actionError.value = toErrorMessage(exception)
  } finally {
    followId.value = false
  }
}

const handleEnter = async (): Promise<void> => {
  if (!detail.value || entering.value) return
  actionError.value = ''
  entering.value = true
  try {
    const result = await enterContestEvent(detail.value.id)
    await router.push({ name: 'contest', params: { id: result.contest_id } })
  } catch (exception: unknown) {
    actionError.value = toErrorMessage(exception)
    await load()
  } finally {
    entering.value = false
  }
}

const goBack = (): void => {
  void router.push({ name: 'contest-events' })
}

onMounted(() => {
  tickTimer = window.setInterval(() => {
    now.value = Date.now()
  }, 1000)
  leaderboardTimer = window.setInterval(() => {
    if (detail.value?.status === 'running' || detail.value?.status === 'finished') {
      void loadLeaderboard(true)
    }
  }, 15_000)
  void load()
})

onBeforeUnmount(() => {
  if (tickTimer !== null) {
    window.clearInterval(tickTimer)
    tickTimer = null
  }
  if (leaderboardTimer !== null) {
    window.clearInterval(leaderboardTimer)
    leaderboardTimer = null
  }
})
</script>

<template>
  <NavBar />
  <main class="teaching-page page-shell contests-page">
    <div v-if="loading" class="empty-state"><p>正在加载赛事</p></div>

    <div v-else-if="error" class="empty-state">
      <p class="form-error" role="alert">{{ error }}</p>
      <button class="forum-secondary-button" type="button" @click="goBack">返回全部赛事</button>
    </div>

    <template v-else-if="detail">
      <header class="contest-event-detail-head">
        <div>
          <RouterLink class="teaching-breadcrumb" :to="{ name: 'contest-events' }">
            全部赛事
          </RouterLink>
          <div class="contest-event-detail-title">
            <h1>{{ detail.title }}</h1>
            <span :class="['contest-event-status', `is-${detail.status}`]">
              {{ eventStatusLabel(detail) }}
            </span>
            <span v-if="detail.is_registered" class="contest-event-registered">已报名</span>
          </div>
          <p class="teaching-subtle">
            {{ detail.organizer }} · {{ EVENT_TYPE_LABELS[detail.type] }}
          </p>
        </div>
        <button
          class="contest-follow-button"
          type="button"
          :aria-pressed="detail.is_followed"
          :disabled="followId"
          @click="toggleFollow"
        >
          {{ detail.is_followed ? '已关注' : '关注赛事' }}
        </button>
      </header>

      <section class="teaching-panel contest-event-detail">
        <div class="contest-event-meta-grid">
          <div class="contest-event-meta-item">
            <span>时间</span>
            <strong>{{ eventTimeLabel(detail, now) }}</strong>
            <small>{{ formatDateTime(detail.starts_at) }} – {{ formatDateTime(detail.ends_at) }}</small>
          </div>
          <div class="contest-event-meta-item">
            <span>参赛范围</span>
            <strong>{{ detail.scope || '公开赛事' }}</strong>
            <small>{{ eventCapacityLabel(detail) }}</small>
          </div>
          <div v-if="detail.registration_deadline" class="contest-event-meta-item">
            <span>报名截止</span>
            <strong>{{ formatDateTime(detail.registration_deadline) }}</strong>
            <small>{{ eventDeadlineLabel(detail) || '报名已截止' }}</small>
          </div>
        </div>

        <p v-if="actionError" class="form-error" role="alert">{{ actionError }}</p>
        <p v-if="detail.ineligible_reason" class="contest-ineligible-reason">
          {{ detail.ineligible_reason }}
        </p>

        <div class="contest-event-detail-actions">
          <button
            v-if="canEnter"
            class="primary-button"
            type="button"
            :disabled="entering"
            @click="handleEnter"
          >
            {{ entering ? '正在进入…' : '进入赛事' }}
          </button>
          <button
            v-else-if="canRegister"
            class="primary-button"
            type="button"
            :disabled="actionId"
            @click="handleAction"
          >
            {{ actionId ? '处理中…' : eventButtonLabel(detail) }}
          </button>
          <span v-else-if="detail.is_registered" class="teaching-subtle">
            已报名，赛事开始后可从竞赛首页进入
          </span>
          <span v-else-if="detail.action === 'full' || detail.action === 'closed'" class="teaching-subtle">
            {{ detail.ineligible_reason || eventButtonLabel(detail) }}
          </span>
          <a
            v-if="detail.registration_url"
            class="forum-secondary-button contest-event-link"
            :href="detail.registration_url"
            target="_blank"
            rel="noopener noreferrer"
          >
            打开报名链接
          </a>
        </div>

        <div v-if="detail.description" class="contest-event-detail-section">
          <h2>赛事说明</h2>
          <p>{{ detail.description }}</p>
        </div>

        <div v-if="detail.rules.length" class="contest-event-detail-section">
          <h2>赛事规则</h2>
          <details
            v-for="(group, index) in detail.rules"
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

        <div class="contest-event-detail-section">
          <h2>赛事排行榜</h2>
          <p class="teaching-subtle">{{ leaderboardStateLabel }}</p>
          <p v-if="leaderboardError" class="form-error" role="alert">{{ leaderboardError }}</p>
          <div v-if="leaderboardLoading" class="teaching-subtle">正在加载排行榜</div>
          <p v-else-if="leaderboard && !leaderboard.entries.length" class="teaching-subtle">
            暂无参赛选手
          </p>
          <div v-else-if="leaderboard" class="contest-leaderboard-wrap">
            <table class="contest-detail-table contest-leaderboard">
              <thead>
                <tr>
                  <th scope="col">排名</th>
                  <th scope="col">参赛者</th>
                  <th scope="col">通过</th>
                  <th scope="col">总分</th>
                </tr>
              </thead>
              <tbody>
                <tr
                  v-for="entry in leaderboard.entries"
                  :key="entry.user_id"
                  :class="{ 'is-me': entry.is_me }"
                >
                  <td>{{ entry.rank ?? '—' }}</td>
                  <td>
                    {{ entry.username }}
                    <span v-if="entry.is_me" class="contest-event-registered">我</span>
                  </td>
                  <td>{{ entry.solved_count }}</td>
                  <td>{{ entry.total_score === null ? '—' : entry.total_score.toFixed(2) }}</td>
                </tr>
              </tbody>
            </table>
          </div>
        </div>
      </section>
    </template>
  </main>
</template>
