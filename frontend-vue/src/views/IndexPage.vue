<script setup lang="ts">
import { computed, onMounted, ref } from 'vue'
import { useRouter } from 'vue-router'
import NavBar from '../components/NavBar.vue'
import { toErrorMessage } from '../api/client'
import { checkIn, fetchHomeOverview, fetchRandomProblem } from '../api/home'
import { useAuthStore } from '../store/auth'
import { toast } from '../store/toast'
import { DIFFICULTY_LABELS, LANGUAGE_OPTIONS } from '../utils/constants'
import { latestDraftMeta, type DraftMeta } from '../utils/problemDrafts'
import { formatDateTime } from '../utils/teaching'
import type { HomeOverview } from '../types/home'
import type { Difficulty } from '../types/oj'

interface ContinueView {
  problemId: number
  title: string
  difficulty: Difficulty
  language: string
  status: string
  updatedAt: string
  action: 'resume' | 'review'
}

const router = useRouter()
const authStore = useAuthStore()
const searchKeyword = ref('')
const overview = ref<HomeOverview | null>(null)
const loading = ref(false)
const error = ref('')
const actionError = ref('')
const randomLoading = ref(false)
const draft = ref<DraftMeta | null>(null)
const checkinState = ref<HomeOverview['checkin'] | null>(null)
const checkinLoading = ref(false)

const continueEntry = computed<ContinueView | null>(() => {
  if (draft.value) {
    return {
      problemId: draft.value.problemId,
      title: draft.value.title,
      difficulty: draft.value.difficulty,
      language: draft.value.language,
      status: 'draft',
      updatedAt: draft.value.updatedAt,
      action: 'resume',
    }
  }
  const entry = overview.value?.continue_learning
  if (!entry) return null
  return {
    problemId: entry.problem_id,
    title: entry.problem_title,
    difficulty: entry.difficulty,
    language: entry.language,
    status: entry.status,
    updatedAt: entry.last_activity_at,
    action: entry.action,
  }
})

const languageLabel = (value: string): string =>
  LANGUAGE_OPTIONS.find((option) => option.value === value)?.label ?? value

const statusLabel = (status: string): string => {
  if (status === 'draft') return '草稿'
  if (status === 'accepted') return '已通过'
  if (status === 'pending' || status === 'judging') return '判题中'
  return '未通过'
}

const statsItems = computed(() => {
  if (!overview.value) return []
  const stats = overview.value.stats
  return [
    {
      label: '连续练习',
      value: stats.streak_days,
      unit: '天',
      to: null,
    },
    {
      label: '已通过',
      value: stats.accepted_problems,
      unit: '题',
      to: { path: '/problems', query: { status: 'accepted' } },
    },
    {
      label: '待复习',
      value: stats.review_problems,
      unit: '题',
      to: { path: '/problems', query: { status: 'attempted' } },
    },
    {
      label: '近 7 天提交',
      value: stats.week_submissions,
      unit: '次',
      to: { path: '/profile', query: { tab: 'submissions' } },
    },
  ]
})

const greeting = computed(() =>
  authStore.isAuthenticated
    ? `欢迎回来，${authStore.user?.username ?? ''}`
    : '开始今天的练习',
)

const shortcuts = [
  {
    label: '题库',
    description: '按标签和难度筛选',
    to: '/problems',
  },
  {
    label: '错题本',
    description: '查看尝试未通过的题',
    to: { path: '/problems', query: { status: 'attempted' } },
  },
  {
    label: '我的收藏',
    description: '收藏的题目、帖子与评论',
    to: '/profile/favorites',
  },
  {
    label: '提交记录',
    description: '最近提交与判题结果',
    to: { path: '/profile', query: { tab: 'submissions' } },
  },
] as const

const loadOverview = async (): Promise<void> => {
  if (!authStore.isAuthenticated) return
  loading.value = true
  error.value = ''
  try {
    overview.value = await fetchHomeOverview()
    checkinState.value = overview.value.checkin
  } catch (exception: unknown) {
    error.value = toErrorMessage(exception)
  } finally {
    loading.value = false
  }
}

const search = (): void => {
  void router.push({ path: '/problems', query: { keyword: searchKeyword.value } })
}

const openRandomProblem = async (): Promise<void> => {
  if (randomLoading.value) return
  randomLoading.value = true
  actionError.value = ''
  try {
    const problemId = await fetchRandomProblem()
    await router.push(`/problem/${problemId}`)
  } catch (exception: unknown) {
    actionError.value = toErrorMessage(exception)
  } finally {
    randomLoading.value = false
  }
}

const doCheckin = async (): Promise<void> => {
  if (checkinLoading.value || checkinState.value?.checked_in_today) return
  checkinLoading.value = true
  actionError.value = ''
  try {
    const result = await checkIn()
    checkinState.value = {
      checked_in_today: true,
      reputation_score: result.reputation_score,
    }
    toast.success(result.message)
  } catch (exception: unknown) {
    actionError.value = toErrorMessage(exception)
  } finally {
    checkinLoading.value = false
  }
}

const continueLink = computed(() => {
  const entry = continueEntry.value
  if (!entry) return '/problems'
  return {
    path: `/problem/${entry.problemId}`,
    query: { language: entry.language },
  }
})

onMounted(() => {
  draft.value = latestDraftMeta()
  void loadOverview()
})
</script>

<template>
  <NavBar />
  <main class="home-page page-shell">
    <header class="home-heading">
      <h1>{{ greeting }}</h1>
      <div v-if="authStore.isAuthenticated && checkinState" class="home-checkin">
        <button
          class="forum-secondary-button"
          type="button"
          :disabled="checkinState.checked_in_today || checkinLoading"
          @click="doCheckin"
        >
          {{ checkinState.checked_in_today ? '今日已签到' : '签到' }}
        </button>
      </div>
    </header>

    <section class="home-search" aria-label="题目搜索">
      <form class="home-search-form" @submit.prevent="search">
        <svg viewBox="0 0 24 24" aria-hidden="true">
          <circle cx="11" cy="11" r="6" />
          <path d="m16 16 4 4" />
        </svg>
        <input
          v-model.trim="searchKeyword"
          type="search"
          placeholder="搜索题目、编号、标签或关键词"
          aria-label="搜索题目、编号、标签或关键词"
        />
        <button class="primary-button" type="submit">搜索</button>
      </form>
      <button
        class="home-random-button"
        type="button"
        :disabled="randomLoading"
        title="随机一题"
        aria-label="随机一题"
        @click="openRandomProblem"
      >
        <svg viewBox="0 0 24 24" aria-hidden="true">
          <path d="M4 7h3l2 3M4 17h3l10-10h3M14 17h6M17 14v6" />
        </svg>
        <span>{{ randomLoading ? '抽取中' : '随机一题' }}</span>
      </button>
    </section>
    <p v-if="actionError" class="form-error" role="alert">{{ actionError }}</p>

    <div class="home-grid">
      <section class="home-section" aria-labelledby="home-continue-title">
        <div class="home-section-heading">
          <h2 id="home-continue-title">继续学习</h2>
          <RouterLink class="inline-link" to="/problems">浏览题库</RouterLink>
        </div>

        <div v-if="loading" class="home-skeleton" aria-hidden="true">
          <span></span>
          <span></span>
          <span></span>
        </div>

        <article v-else-if="continueEntry" class="home-continue">
          <div class="home-continue-main">
            <div class="home-continue-meta">
              <span :class="['difficulty', continueEntry.difficulty]">
                {{ DIFFICULTY_LABELS[continueEntry.difficulty] }}
              </span>
              <span class="home-chip">{{ statusLabel(continueEntry.status) }}</span>
              <span class="home-chip">{{ languageLabel(continueEntry.language) }}</span>
            </div>
            <h3>{{ continueEntry.title }}</h3>
            <p class="home-muted">
              {{ continueEntry.action === 'review' ? '上次通过' : '上次练习' }}
              · {{ formatDateTime(continueEntry.updatedAt) }}
            </p>
          </div>
          <RouterLink class="primary-button" :to="continueLink">
            {{ continueEntry.action === 'review' ? '复习上一题' : '继续作答' }}
          </RouterLink>
        </article>

        <div v-else-if="!authStore.isAuthenticated" class="home-empty">
          <p>登录后可以记录最近的练习和草稿</p>
          <RouterLink class="primary-button" :to="{ name: 'login', query: { redirect: '/' } }">
            登录
          </RouterLink>
        </div>

        <div v-else-if="error" class="home-empty">
          <p>{{ error }}</p>
          <button class="forum-secondary-button" type="button" @click="loadOverview">重试</button>
        </div>

        <div v-else class="home-empty">
          <p>从题库选择一道题开始</p>
          <RouterLink class="primary-button" to="/problems">浏览题库</RouterLink>
        </div>
      </section>

      <section class="home-section" aria-labelledby="home-stats-title">
        <div class="home-section-heading">
          <h2 id="home-stats-title">学习概览</h2>
        </div>

        <div v-if="loading" class="home-skeleton" aria-hidden="true">
          <span></span>
          <span></span>
        </div>

        <dl v-else-if="statsItems.length" class="home-stats">
          <template v-for="item in statsItems" :key="item.label">
            <RouterLink v-if="item.to" :to="item.to">
              <dt>{{ item.label }}</dt>
              <dd>{{ item.value }}<small>{{ item.unit }}</small></dd>
            </RouterLink>
            <div v-else>
              <dt>{{ item.label }}</dt>
              <dd>{{ item.value }}<small>{{ item.unit }}</small></dd>
            </div>
          </template>
        </dl>

        <p v-else class="home-muted">
          {{ authStore.isAuthenticated ? (error || '暂时没有统计数据') : '登录后显示学习统计' }}
        </p>
      </section>

      <section class="home-section" aria-labelledby="home-activity-title">
        <div class="home-section-heading">
          <h2 id="home-activity-title">最近活动</h2>
          <RouterLink class="inline-link" :to="{ path: '/profile', query: { tab: 'submissions' } }">
            查看全部
          </RouterLink>
        </div>

        <div v-if="loading" class="home-skeleton" aria-hidden="true">
          <span></span>
          <span></span>
        </div>

        <ul v-else-if="overview?.recent_activity.length" class="home-activity">
          <li v-for="item in overview.recent_activity" :key="item.submission_id">
            <RouterLink :to="`/problem/${item.problem_id}`">{{ item.problem_title }}</RouterLink>
            <span class="home-chip">{{ languageLabel(item.language) }}</span>
            <span :class="['home-result', item.status === 'accepted' ? 'is-accepted' : '']">
              {{ statusLabel(item.status) }}
            </span>
            <time>{{ formatDateTime(item.submitted_at) }}</time>
          </li>
        </ul>

        <p v-else-if="authStore.isAuthenticated && !error" class="home-muted">
          还没有提交记录
        </p>
        <p v-else-if="!authStore.isAuthenticated" class="home-muted">
          登录后显示最近提交
        </p>
      </section>

      <section class="home-section" aria-labelledby="home-shortcuts-title">
        <div class="home-section-heading">
          <h2 id="home-shortcuts-title">快捷入口</h2>
        </div>
        <nav class="home-shortcuts" aria-label="快捷入口">
          <RouterLink v-for="item in shortcuts" :key="item.label" :to="item.to">
            <span class="home-shortcut-icon" aria-hidden="true"></span>
            <span>
              <strong>{{ item.label }}</strong>
              <small>{{ item.description }}</small>
            </span>
          </RouterLink>
        </nav>
      </section>
    </div>
  </main>
</template>
