<script setup lang="ts">
import { computed } from 'vue'
import type { ProfileAnalytics, ProfileTrendPoint } from '../types/profile'

const props = defineProps<{
  analytics: ProfileAnalytics | null
  loading: boolean
  error: string
}>()

interface HeatCell {
  key: string
  level: number
  point?: ProfileTrendPoint
}

interface HeatMonth {
  key: string
  column: number
  label: string
}

const WEEKDAY_LABELS = ['一', '二', '三', '四', '五', '六', '日']
const HEAT_LEVELS = 4

const heatmapPoints = computed<ProfileTrendPoint[]>(() => {
  const heatmap = props.analytics?.heatmap
  return heatmap?.length ? heatmap : (props.analytics?.trend ?? [])
})

const heatLevel = (submissions: number, max: number): number => {
  if (submissions <= 0) return 0
  if (max <= 0) return 0
  const ratio = submissions / max
  if (ratio > 0.75) return 4
  if (ratio > 0.5) return 3
  if (ratio > 0.25) return 2
  return 1
}

const heatGrid = computed<{ cells: HeatCell[]; months: HeatMonth[]; columns: number }>(() => {
  const points = heatmapPoints.value
  if (!points.length) return { cells: [], months: [], columns: 0 }
  const first = new Date(`${points[0].date}T00:00:00`)
  const leading = Number.isNaN(first.getTime()) ? 0 : (first.getDay() + 6) % 7
  const cells: HeatCell[] = []
  for (let index = 0; index < leading; index += 1) {
    cells.push({ key: `pad-start-${index}`, level: -2 })
  }
  const max = Math.max(0, ...points.map((point) => point.submissions))
  const months: HeatMonth[] = []
  points.forEach((point) => {
    cells.push({ key: point.date, level: heatLevel(point.submissions, max), point })
    if (point.date.slice(8, 10) === '01') {
      months.push({
        key: point.date.slice(0, 7),
        column: Math.floor((cells.length - 1) / 7),
        label: `${Number(point.date.slice(5, 7))}月`,
      })
    }
  })
  while (cells.length % 7 !== 0) {
    cells.push({ key: `future-${cells.length}`, level: -2 })
  }
  return { cells, months, columns: cells.length / 7 }
})

const cellTitle = (cell: HeatCell): string | undefined =>
  cell.point
    ? `${cell.point.date}：提交 ${cell.point.submissions}，通过 ${cell.point.accepted}`
    : undefined

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
      <span>完成第一道题后，这里会显示你的学习进度</span>
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
        <div class="profile-chart-heading">
          <h3>提交趋势</h3>
          <span class="teaching-subtle">近一年</span>
        </div>
        <div class="profile-heatmap">
          <div
            class="profile-heatmap-grid"
            role="img"
            aria-label="近一年提交热力图"
            :style="{ '--heat-columns': String(heatGrid.columns || 1) }"
          >
            <span
              v-for="(label, index) in WEEKDAY_LABELS"
              v-show="index % 2 === 0"
              :key="`weekday-${index}`"
              class="profile-heatmap-weekday"
              :style="{ gridRow: index + 2, gridColumn: 1 }"
            >{{ label }}</span>
            <span
              v-for="month in heatGrid.months"
              :key="`month-${month.key}`"
              class="profile-heatmap-month"
              :style="{ gridRow: 1, gridColumn: month.column + 2 }"
            >{{ month.label }}</span>
            <span
              v-for="(cell, index) in heatGrid.cells"
              :key="cell.key"
              :class="['profile-heatmap-cell', cell.level === -1 ? 'is-blank' : cell.level === -2 ? 'is-future' : `level-${cell.level}`]"
              :title="cellTitle(cell)"
              :style="{ gridRow: (index % 7) + 2, gridColumn: Math.floor(index / 7) + 2 }"
            ></span>
          </div>
        </div>
        <div class="profile-chart-legend profile-heatmap-legend">
          <span>少</span>
          <span class="profile-heatmap-legend-scale" aria-hidden="true">
            <i v-for="level in HEAT_LEVELS + 1" :key="level" :class="`level-${level - 1}`"></i>
          </span>
          <span>多</span>
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
