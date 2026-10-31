<script setup lang="ts">
import axios from 'axios'
import { computed, ref } from 'vue'
import { useRoute } from 'vue-router'
import NavBar from '../components/NavBar.vue'
import { toErrorMessage } from '../api/client'
import { fetchContestResult, fetchMyContestAppeals, submitContestAppeal } from '../api/contests'
import { toast } from '../store/toast'
import type { ContestAppeal, ContestResult } from '../types/contest'
import { formatDateTime } from '../utils/teaching'

const route = useRoute()

const contestId = Number(route.params.id)
const result = ref<ContestResult | null>(null)
const isLoading = ref(true)
const notFinished = ref(false)
const error = ref('')

const isEventContest = computed(() => result.value?.contest.event_id != null)

const myAppeal = ref<ContestAppeal | null>(null)
const appealReason = ref('')
const appealError = ref('')
const appealSubmitting = ref(false)

const APPEAL_STATUS_LABELS: Record<ContestAppeal['status'], string> = {
  pending: '等待处理',
  accepted: '已通过',
  rejected: '未通过',
}

const loadAppeal = async (): Promise<void> => {
  try {
    const list = await fetchMyContestAppeals()
    myAppeal.value = list.items.find((item) => item.contest_id === contestId) ?? null
  } catch {
    // 申诉列表不可用时不影响成绩页展示
  }
}

const submitAppeal = async (): Promise<void> => {
  if (appealSubmitting.value) return
  const reason = appealReason.value.trim()
  if (!reason) {
    appealError.value = '请填写申诉理由'
    return
  }
  appealSubmitting.value = true
  appealError.value = ''
  try {
    myAppeal.value = await submitContestAppeal(contestId, reason)
    appealReason.value = ''
    toast.success('申诉已提交')
  } catch (exception: unknown) {
    appealError.value = toErrorMessage(exception)
  } finally {
    appealSubmitting.value = false
  }
}

const isNotFinishedError = (exception: unknown): boolean =>
  axios.isAxiosError(exception) && exception.response?.status === 409

const formatScore = (value: number | null | undefined): string => {
  if (value === null || value === undefined) return '—'
  return Number.isInteger(value) ? String(value) : value.toFixed(1)
}

const formatDelta = (value: number | null | undefined): string => {
  if (value === null || value === undefined) return '—'
  return value > 0 ? `+${value}` : String(value)
}

const load = async (): Promise<void> => {
  if (!Number.isInteger(contestId) || contestId <= 0) {
    isLoading.value = false
    error.value = '比赛地址无效'
    return
  }
  isLoading.value = true
  error.value = ''
  notFinished.value = false
  try {
    result.value = await fetchContestResult(contestId)
    if (result.value.mine) await loadAppeal()
  } catch (exception: unknown) {
    if (isNotFinishedError(exception)) {
      notFinished.value = true
    } else {
      error.value = toErrorMessage(exception)
    }
  } finally {
    isLoading.value = false
  }
}

void load()
</script>

<template>
  <NavBar />
  <main class="teaching-page page-shell contest-result-page">
    <div v-if="isLoading" class="empty-state">
      <p>正在加载比赛结果</p>
    </div>

    <section v-else-if="notFinished" class="teaching-panel contest-not-finished">
      <div class="section-heading">
        <h2>比赛尚未结束</h2>
      </div>
      <p class="teaching-description">比赛结束后会公布最终排名与得分明细，请稍后再来查看</p>
      <RouterLink class="primary-button" :to="`/contests/${contestId}`">返回比赛</RouterLink>
    </section>

    <section v-else-if="error && !result" class="teaching-panel">
      <p class="form-error" role="alert">{{ error }}</p>
      <div class="teaching-toolbar">
        <button class="forum-secondary-button" type="button" @click="load">重试</button>
        <RouterLink class="primary-button" :to="`/contests/${contestId}`">返回比赛</RouterLink>
      </div>
    </section>

    <template v-else-if="result">
      <header class="teaching-page-header contest-page-header contest-result-header">
        <div>
          <span class="eyebrow">{{ isEventContest ? '赛事比赛结果' : '排位赛结果' }}</span>
          <h1>{{ isEventContest ? '赛事比赛' : '排位赛' }} #{{ result.contest.id }} 结果</h1>
          <p class="teaching-subtle contest-header-meta">
            <span class="teaching-badge contest-status-badge is-finished">已结束</span>
            <span>{{ result.contest.problem_count }} 道题</span>
            <span>开始于 {{ formatDateTime(result.contest.starts_at) }}</span>
            <span>结束于 {{ formatDateTime(result.contest.ends_at) }}</span>
          </p>
        </div>
        <RouterLink class="forum-secondary-button" :to="`/contests/${result.contest.id}`">返回比赛</RouterLink>
      </header>

      <section v-if="result.mine" class="ranking-me" aria-label="我的成绩">
        <div class="ranking-me-rank">
          <span>我的排名</span>
          <strong v-if="result.mine.disqualified" class="ranking-disqualified">成绩取消</strong>
          <strong v-else>#{{ result.mine.rank }}</strong>
          <small>共 {{ result.ranking.length }} 名选手</small>
        </div>
        <div class="ranking-me-stat">
          <span>总分</span>
          <strong>{{ formatScore(result.mine.total_score) }}</strong>
          <small>综合得分</small>
        </div>
        <div class="ranking-me-stat">
          <span>通过题数</span>
          <strong>{{ result.mine.solved_count }}</strong>
          <small>道题</small>
        </div>
        <div class="ranking-me-stat">
          <span>速度分</span>
          <strong>{{ formatScore(result.mine.speed_score) }}</strong>
          <small>占比 25%</small>
        </div>
        <div class="ranking-me-stat">
          <span>代码分</span>
          <strong>{{ formatScore(result.mine.coding_score) }}</strong>
          <small>占比 15%</small>
        </div>
        <div class="ranking-me-stat">
          <span>段位分</span>
          <strong>{{ formatScore(result.mine.rating_after) }}</strong>
          <small class="contest-rating-delta" :class="{ 'is-up': (result.mine.rating_delta ?? 0) > 0, 'is-down': (result.mine.rating_delta ?? 0) < 0 }">
            段位 {{ formatDelta(result.mine.rating_delta) }}
          </small>
        </div>
      </section>

      <section v-if="result.mine" class="teaching-section">
        <div class="section-heading">
          <h2>成绩申诉</h2>
          <span v-if="myAppeal" class="teaching-badge">
            {{ APPEAL_STATUS_LABELS[myAppeal.status] }}
          </span>
        </div>
        <div v-if="myAppeal" class="teaching-panel">
          <p class="teaching-subtle">
            提交于 {{ formatDateTime(myAppeal.created_at) }}
            <template v-if="myAppeal.handled_at">
              · 处理于 {{ formatDateTime(myAppeal.handled_at) }}
            </template>
          </p>
          <p>{{ myAppeal.reason }}</p>
          <p v-if="myAppeal.handle_note" class="teaching-subtle">
            处理说明：{{ myAppeal.handle_note }}
          </p>
        </div>
        <form v-else class="teaching-panel" @submit.prevent="submitAppeal">
          <p class="teaching-subtle">每场比赛只能申诉一次，提交后由管理员复核</p>
          <label class="contest-admin-field">
            <span>申诉理由</span>
            <textarea
              v-model="appealReason"
              rows="4"
              maxlength="1000"
              placeholder="请说明申诉理由"
            ></textarea>
          </label>
          <p v-if="appealError" class="form-error" role="alert">{{ appealError }}</p>
          <div class="teaching-toolbar">
            <button class="primary-button" type="submit" :disabled="appealSubmitting">
              {{ appealSubmitting ? '提交中' : '提交申诉' }}
            </button>
          </div>
        </form>
      </section>

      <section class="teaching-section">
        <div class="section-heading">
          <h2>最终排名</h2>
          <span class="teaching-subtle">按总分从高到低排列 · 共 {{ result.ranking.length }} 名选手</span>
        </div>
        <div v-if="result.ranking.length" class="ranking-table-wrap">
          <table class="ranking-table">
            <thead>
              <tr>
                <th scope="col" class="ranking-rank">排名</th>
                <th scope="col">选手</th>
                <th scope="col">总分</th>
                <th scope="col">通过题数</th>
                <th scope="col">速度分</th>
                <th scope="col">代码分</th>
                <th scope="col">段位分</th>
                <th scope="col">变化</th>
                <th scope="col">完成时间</th>
              </tr>
            </thead>
            <tbody>
              <tr
                v-for="entry in result.ranking"
                :key="entry.user_id"
                :class="{ 'is-me': entry.is_me, 'is-disqualified': entry.disqualified }"
              >
                <td
                  class="ranking-rank"
                  :class="{
                    top: !entry.disqualified && entry.rank <= 3,
                    'is-disqualified': entry.disqualified,
                  }"
                >
                  {{ entry.disqualified ? '—' : entry.rank }}
                </td>
                <td class="ranking-user">
                  {{ entry.username }}
                  <span v-if="entry.is_me" class="ranking-you">我</span>
                  <span v-if="entry.disqualified" class="ranking-disqualified">成绩已取消</span>
                </td>
                <td>{{ formatScore(entry.total_score) }}</td>
                <td>{{ entry.solved_count }}</td>
                <td>{{ formatScore(entry.speed_score) }}</td>
                <td>{{ formatScore(entry.coding_score) }}</td>
                <td>{{ formatScore(entry.rating_after) }}</td>
                <td
                  class="contest-rating-delta"
                  :class="{ 'is-up': (entry.rating_delta ?? 0) > 0, 'is-down': (entry.rating_delta ?? 0) < 0 }"
                >
                  {{ formatDelta(entry.rating_delta) }}
                </td>
                <td>{{ formatDateTime(entry.finished_at ?? undefined) }}</td>
              </tr>
            </tbody>
          </table>
        </div>
        <div v-else class="empty-state">
          <p>暂无排名数据</p>
        </div>
      </section>

      <section v-if="result.mine" class="teaching-section">
        <div class="section-heading">
          <h2>我的答题明细</h2>
          <span class="teaching-subtle">60% 通过题数 + 25% 速度 + 15% 代码书写</span>
        </div>
        <div v-if="result.mine.detail?.length" class="problem-table-wrap">
          <table class="problem-table contest-detail-table">
            <thead>
              <tr>
                <th scope="col">题目</th>
                <th scope="col">结果</th>
                <th scope="col">尝试</th>
                <th scope="col">错误分布</th>
                <th scope="col">时间分</th>
                <th scope="col">通过时间</th>
              </tr>
            </thead>
            <tbody>
              <tr v-for="item in result.mine.detail ?? []" :key="item.problem_id">
                <td>
                  <RouterLink
                    class="contest-problem-link"
                    :to="`/problem/${item.problem_id}?contest_id=${result.contest.id}`"
                  >
                    题目 {{ item.title ?? `#${item.problem_id}` }}
                  </RouterLink>
                </td>
                <td>
                  <span :class="item.accepted ? 'solved-icon' : 'attempted-icon'">
                    {{ item.accepted ? '已通过' : '未通过' }}
                  </span>
                </td>
                <td>{{ item.attempts }}</td>
                <td>
                  错答 {{ item.wrong_answer }} · 编译 {{ item.compile_error }} · 运行
                  {{ item.runtime_error }}
                </td>
                <td>{{ formatScore(item.time_score) }}</td>
                <td>{{ formatDateTime(item.accepted_at ?? undefined) }}</td>
              </tr>
            </tbody>
          </table>
        </div>
        <div v-else class="empty-state">
          <p>没有可展示的答题明细</p>
        </div>
        <p class="teaching-subtle contest-formula-note">
          计分规则：60% 通过题数 + 25% 速度 + 15% 代码书写
        </p>
      </section>

      <section v-else class="empty-state">
        <p>没有找到我的成绩记录</p>
        <RouterLink class="primary-button" to="/contests">返回竞赛首页</RouterLink>
      </section>
    </template>
  </main>
</template>
