<script setup lang="ts">
import { computed, onBeforeUnmount, onMounted, ref } from 'vue'
import { useRouter } from 'vue-router'
import NavBar from '../components/NavBar.vue'
import ContestEventCardView from '../components/ContestEventCard.vue'
import { toErrorMessage } from '../api/client'
import { toast } from '../store/toast'
import {
  enterContestEvent,
  fetchContestEventList,
  followContestEvent,
  joinContestEvent,
  registerContestEvent,
  unfollowContestEvent,
} from '../api/contests'
import type {
  ContestEventCard,
  ContestEventList,
  ContestEventStatus,
  ContestEventType,
} from '../types/contest'

const router = useRouter()

type TypeFilter = 'all' | ContestEventType
type StatusFilter = 'all' | ContestEventStatus

const TYPE_FILTERS: Array<{ value: TypeFilter; label: string }> = [
  { value: 'all', label: '全部' },
  { value: 'official', label: '官方' },
  { value: 'teacher', label: '老师' },
  { value: 'school', label: '学校' },
]

const STATUS_FILTERS: Array<{ value: StatusFilter; label: string }> = [
  { value: 'all', label: '全部' },
  { value: 'registration', label: '报名中' },
  { value: 'upcoming', label: '即将开始' },
  { value: 'running', label: '进行中' },
  { value: 'finished', label: '已结束' },
]

const typeFilter = ref<TypeFilter>('all')
const statusFilter = ref<StatusFilter>('all')
const followingOnly = ref(false)
const page = ref(1)
const pageSize = 12
const data = ref<ContestEventList | null>(null)
const loading = ref(false)
const error = ref('')
const actionError = ref('')
const actionId = ref<number | null>(null)
const followId = ref<number | null>(null)
const now = ref(Date.now())

let tickTimer: number | null = null

const events = computed(() => data.value?.events ?? [])
const total = computed(() => data.value?.total ?? 0)
const totalPages = computed(() => Math.max(1, Math.ceil(total.value / pageSize)))

const replaceEvent = (card: ContestEventCard): void => {
  if (!data.value) return
  data.value = {
    ...data.value,
    events: data.value.events.map((event) =>
      event.id === card.id ? { ...event, ...card } : event,
    ),
  }
}

const load = async (): Promise<void> => {
  loading.value = true
  error.value = ''
  try {
    data.value = await fetchContestEventList({
      type: typeFilter.value === 'all' ? undefined : typeFilter.value,
      status: statusFilter.value === 'all' ? undefined : statusFilter.value,
      following: followingOnly.value || undefined,
      page: page.value,
      page_size: pageSize,
    })
  } catch (exception: unknown) {
    error.value = toErrorMessage(exception)
  } finally {
    loading.value = false
  }
}

const selectType = (value: TypeFilter): void => {
  if (typeFilter.value === value) return
  typeFilter.value = value
  page.value = 1
  void load()
}

const selectStatus = (value: StatusFilter): void => {
  if (statusFilter.value === value) return
  statusFilter.value = value
  page.value = 1
  void load()
}

const toggleFollowing = (): void => {
  followingOnly.value = !followingOnly.value
  page.value = 1
  void load()
}

const goPage = (next: number): void => {
  if (next < 1 || next > totalPages.value || next === page.value) return
  page.value = next
  void load()
}

const openEvent = (event: ContestEventCard): void => {
  void router.push({ name: 'contest-event-detail', params: { eventId: event.id } })
}

const handleAction = async (event: ContestEventCard): Promise<void> => {
  if (actionId.value !== null) return
  actionError.value = ''
  if (!event.eligible) {
    actionError.value = event.ineligible_reason ?? '当前不符合参赛条件'
    return
  }
  if (event.action === 'full') {
    actionError.value = '名额已满'
    return
  }
  if (event.action === 'closed') {
    actionError.value = event.ineligible_reason ?? '当前不可报名'
    return
  }
  if (event.action === 'enter') {
    actionId.value = event.id
    try {
      const result = await enterContestEvent(event.id)
      await router.push({ name: 'contest', params: { id: result.contest_id } })
    } catch (exception: unknown) {
      actionError.value = toErrorMessage(exception)
      void load()
    } finally {
      actionId.value = null
    }
    return
  }
  if (event.action !== 'register' && event.action !== 'join') {
    openEvent(event)
    return
  }
  actionId.value = event.id
  try {
    const card =
      event.action === 'join'
        ? await joinContestEvent(event.id)
        : await registerContestEvent(event.id)
    replaceEvent(card)
    toast.success(
      card.is_registered
        ? event.action === 'join'
          ? '已加入赛事'
          : '报名成功'
        : '操作成功',
    )
  } catch (exception: unknown) {
    actionError.value = toErrorMessage(exception)
    void load()
  } finally {
    actionId.value = null
  }
}

const toggleFollow = async (event: ContestEventCard): Promise<void> => {
  if (followId.value !== null) return
  followId.value = event.id
  actionError.value = ''
  try {
    const result = event.is_followed
      ? await unfollowContestEvent(event.id)
      : await followContestEvent(event.id)
    replaceEvent({ ...event, is_followed: result.is_followed })
  } catch (exception: unknown) {
    actionError.value = toErrorMessage(exception)
  } finally {
    followId.value = null
  }
}

onMounted(() => {
  tickTimer = window.setInterval(() => {
    now.value = Date.now()
  }, 1000)
  void load()
})

onBeforeUnmount(() => {
  if (tickTimer !== null) {
    window.clearInterval(tickTimer)
    tickTimer = null
  }
})
</script>

<template>
  <NavBar />
  <main class="teaching-page page-shell contests-page">
    <header class="teaching-page-header">
      <div>
        <RouterLink class="teaching-breadcrumb" :to="{ name: 'contests' }">竞赛首页</RouterLink>
        <h1>全部赛事</h1>
        <p class="teaching-subtle">按类型、状态筛选，或只看已关注的赛事</p>
      </div>
    </header>

    <div class="contest-filter-bar">
      <div class="contest-filter-group" role="group" aria-label="赛事类型">
        <button
          v-for="filter in TYPE_FILTERS"
          :key="filter.value"
          :class="['contest-filter-tab', { 'is-active': typeFilter === filter.value }]"
          type="button"
          @click="selectType(filter.value)"
        >
          {{ filter.label }}
        </button>
      </div>
      <div class="contest-filter-group" role="group" aria-label="赛事状态">
        <button
          v-for="filter in STATUS_FILTERS"
          :key="filter.value"
          :class="['contest-filter-tab', { 'is-active': statusFilter === filter.value }]"
          type="button"
          @click="selectStatus(filter.value)"
        >
          {{ filter.label }}
        </button>
        <button
          :class="['contest-filter-tab', { 'is-active': followingOnly }]"
          type="button"
          :aria-pressed="followingOnly"
          @click="toggleFollowing"
        >
          我的关注
        </button>
      </div>
    </div>

    <p v-if="actionError" class="form-error" role="alert">{{ actionError }}</p>

    <div v-if="loading" class="contest-event-grid" aria-busy="true">
      <div v-for="index in 3" :key="index" class="contest-event-card is-loading">
        <span class="skeleton-line"></span>
        <span class="skeleton-line skeleton-line-short"></span>
        <span class="skeleton-line"></span>
      </div>
    </div>

    <div v-else-if="error" class="contest-events-feedback">
      <p class="form-error" role="alert">{{ error }}</p>
      <button class="forum-secondary-button" type="button" @click="load">重试</button>
    </div>

    <p v-else-if="!events.length" class="teaching-subtle contest-events-empty">
      {{ followingOnly ? '还没有关注赛事' : '没有符合条件的赛事' }}
    </p>

    <template v-else>
      <div class="contest-event-grid">
        <ContestEventCardView
          v-for="event in events"
          :key="event.id"
          :event="event"
          :now="now"
          :busy="actionId === event.id"
          show-follow
          @open="openEvent"
          @action="handleAction"
          @follow="toggleFollow"
        />
      </div>

      <div v-if="totalPages > 1" class="pagination">
        <span>共 {{ total }} 场 · 第 {{ page }}/{{ totalPages }} 页</span>
        <div>
          <button
            class="forum-secondary-button"
            type="button"
            :disabled="page <= 1"
            @click="goPage(page - 1)"
          >
            上一页
          </button>
          <button
            class="forum-secondary-button"
            type="button"
            :disabled="page >= totalPages"
            @click="goPage(page + 1)"
          >
            下一页
          </button>
        </div>
      </div>
    </template>
  </main>
</template>
