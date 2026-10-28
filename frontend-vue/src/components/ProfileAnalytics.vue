<script setup lang="ts">
import { computed } from 'vue'
import type { ProfileAnalytics } from '../types/profile'

const props = defineProps<{
  analytics: ProfileAnalytics | null
  loading: boolean
  error: string
}>()

const maxTrend = computed(() =>
  Math.max(1, ...(props.analytics?.trend.map((point) => point.submissions) ?? [1])),
)
const difficultyMax = computed(() =>
  Math.max(1, ...(props.analytics?.difficulty.map((item) => item.attempted) ?? [1])),
)
const tagMax = computed(() =>
  Math.max(1, ...(props.analytics?.tags.map((item) => item.attempted) ?? [1])),
)
const difficultyLabels: Record<string, string> = {
  easy: '简单',
  medium: '中等',
  hard: '困难',
}
const percent = (value: number, max: number): string => `${Math.max(4, (value / max) * 100)}%`
</script>

<template>
  <section class="teaching-panel profile-analytics">
    <div class="section-heading">
      <h2>学习分析</h2>
      <span class="teaching-subtle">近 {{ analytics?.days ?? 30 }} 天</span>
    </div>
    <p v-if="loading" class="teaching-subtle">正在加载学习分析</p>
    <p v-else-if="error" class="form-error" role="alert">{{ error }}</p>
    <div v-else-if="!analytics || analytics.summary.totalSubmissions === 0" class="empty-state profile-empty-analytics">
      <strong>还没有学习记录</strong>
      <span>完成第一道题后，这里会显示你的学习进度。</span>
      <RouterLink class="primary-button" to="/problems">去题库</RouterLink>
    </div>
    <template v-else>
      <div class="profile-mini-stats">
        <article><strong>{{ analytics.summary.acceptedProblems }}</strong><span>通过题目</span></article>
        <article><strong>{{ analytics.summary.attemptedProblems }}</strong><span>已尝试题目</span></article>
        <article><strong>{{ analytics.summary.acceptanceRate }}%</strong><span>通过率</span></article>
        <article><strong>{{ analytics.summary.streakDays }}</strong><span>连续通过天数</span></article>
      </div>

      <div class="profile-chart-block">
        <h3>提交趋势</h3>
        <div class="profile-trend">
          <div v-for="point in analytics.trend" :key="point.date" class="profile-trend-column" :title="`${point.date}：提交 ${point.submissions}，通过 ${point.accepted}`">
            <div class="profile-trend-bars">
              <span class="profile-trend-total" :style="{ height: percent(point.submissions, maxTrend) }"></span>
              <span class="profile-trend-accepted" :style="{ height: percent(point.accepted, maxTrend) }"></span>
            </div>
            <small>{{ point.date.slice(5) }}</small>
          </div>
        </div>
        <div class="profile-chart-legend">
          <span><i class="total"></i>提交</span>
          <span><i class="accepted"></i>通过</span>
        </div>
      </div>

      <div class="profile-chart-block">
        <h3>难度分布</h3>
        <div v-for="item in analytics.difficulty" :key="item.difficulty" class="profile-meter-row">
          <span>{{ difficultyLabels[item.difficulty] ?? item.difficulty }}</span>
          <div class="profile-meter">
            <span :style="{ width: percent(item.accepted, difficultyMax) }"></span>
          </div>
          <small>{{ item.accepted }} / {{ item.attempted }}</small>
        </div>
      </div>

      <div class="profile-chart-block">
        <h3>标签掌握度</h3>
        <div v-for="item in analytics.tags" :key="item.tag" class="profile-meter-row">
          <span>{{ item.tag }}</span>
          <div class="profile-meter">
            <span :style="{ width: percent(item.accepted, tagMax) }"></span>
          </div>
          <small>{{ item.accepted }} / {{ item.attempted }}</small>
        </div>
        <p v-if="!analytics.tags.length" class="teaching-subtle">暂无标签数据</p>
      </div>
    </template>
  </section>
</template>
