<script setup lang="ts">
import { computed, onBeforeUnmount, onMounted, watch } from 'vue'
import { useRoute, useRouter } from 'vue-router'
import NavBar from '../components/NavBar.vue'
import { useAuthStore } from '../store/auth'
import { useProblemStore } from '../store/problems'
import { DIFFICULTY_LABELS, PROBLEM_STATUS_OPTIONS } from '../utils/constants'
import type { Difficulty } from '../types/oj'

const route = useRoute()
const router = useRouter()
const store = useProblemStore()
const authStore = useAuthStore()
const difficultyOptions: Array<{ value: Difficulty | 'all'; label: string }> = [{ value: 'all', label: '全部' }, { value: 'easy', label: '简单' }, { value: 'medium', label: '中等' }, { value: 'hard', label: '困难' }]
const totalStart = computed(() => (store.total ? (store.query.page - 1) * store.query.pageSize + 1 : 0))
const totalEnd = computed(() => Math.min(store.query.page * store.query.pageSize, store.total))

let keywordTimer: number | undefined

const applyFilters = (): void => {
  store.query.page = 1
  void store.loadProblems()
}

const updateFromRoute = (): void => {
  const keyword = typeof route.query.keyword === 'string' ? route.query.keyword : ''
  const tag = typeof route.query.tag === 'string' ? route.query.tag : ''
  store.query.keyword = keyword
  store.query.tag = tag
}
const toggleSort = (sortBy: 'id' | 'difficulty' | 'acceptance'): void => {
  if (store.query.sortBy === sortBy) store.query.order = store.query.order === 'asc' ? 'desc' : 'asc'
  else { store.query.sortBy = sortBy; store.query.order = 'asc' }
  applyFilters()
}
const changePage = (page: number): void => {
  store.query.page = page
  void store.loadProblems()
}
const reset = (): void => {
  store.resetQuery()
  void router.replace('/problems')
  void store.loadProblems()
}
const onKeywordInput = (): void => {
  window.clearTimeout(keywordTimer)
  keywordTimer = window.setTimeout(applyFilters, 350)
}

onMounted(() => {
  updateFromRoute()
  void store.loadTags()
  void store.loadProblems()
})
watch(() => route.query, () => {
  updateFromRoute()
  applyFilters()
})
onBeforeUnmount(() => window.clearTimeout(keywordTimer))
</script>

<template>
  <NavBar />
  <main class="problems-page page-shell">
    <header class="page-title"><h1>题库</h1><p>按难度、标签和状态筛选题目。</p></header>
    <section class="filter-panel" aria-label="题目筛选">
      <form class="filter-search" @submit.prevent="applyFilters"><svg viewBox="0 0 24 24" aria-hidden="true"><circle cx="11" cy="11" r="6" /><path d="m16 16 4 4" /></svg><input v-model.trim="store.query.keyword" aria-label="搜索题目名称或标签" placeholder="搜索题目名称或标签" @input="onKeywordInput" /><button class="primary-button" type="submit">搜索</button></form>
      <div class="filter-row"><span>难度</span><div class="filter-pills"><button v-for="option in difficultyOptions" :key="option.value" type="button" :class="{ active: store.query.difficulty === option.value }" @click="store.query.difficulty = option.value; applyFilters()">{{ option.label }}</button></div></div>
      <div class="filter-row"><span>标签</span><div class="filter-pills tag-pills"><button type="button" :class="{ active: !store.query.tag }" @click="store.query.tag = ''; applyFilters()">全部</button><button v-for="tag in store.tags" :key="tag" type="button" :class="{ active: store.query.tag === tag }" @click="store.query.tag = tag; applyFilters()">{{ tag }}</button></div><button class="clear-filter" type="button" @click="reset">清空筛选</button></div>
      <div v-if="authStore.isAuthenticated" class="filter-row"><span>状态</span><div class="filter-pills"><button v-for="option in PROBLEM_STATUS_OPTIONS" :key="option.value" type="button" :class="{ active: store.query.status === option.value }" @click="store.query.status = option.value; applyFilters()">{{ option.label }}</button></div></div>
    </section>
    <section class="problem-list-section">
      <div class="list-toolbar"><span>共 <strong>{{ store.total }}</strong> 道题目</span><label>每页<select v-model.number="store.query.pageSize" @change="applyFilters"><option :value="20">20</option><option :value="50">50</option><option :value="100">100</option></select>题</label></div>
      <p v-if="store.error" class="list-error" role="alert">{{ store.error }} <button type="button" @click="store.loadProblems">重试</button></p>
      <div class="problem-table-wrap">
        <table class="problem-table">
          <thead><tr><th class="status-col"></th><th><button type="button" @click="toggleSort('id')">题号 <span>↕</span></button></th><th>题目</th><th><button type="button" @click="toggleSort('difficulty')">难度 <span>↕</span></button></th><th><button type="button" @click="toggleSort('acceptance')">通过率 <span>↕</span></button></th><th>标签</th></tr></thead>
          <tbody v-if="!store.isLoading"><tr v-for="problem in store.problems" :key="problem.id" class="problem-row" @click="router.push(`/problem/${problem.id}`)"><td class="status-col"><span v-if="problem.status === 'accepted'" class="solved-icon" title="已通过">✓</span><span v-else-if="problem.status === 'attempted'" class="attempted-icon" title="尝试过">•</span></td><td>{{ problem.id }}</td><td><RouterLink :to="`/problem/${problem.id}`" @click.stop>{{ problem.title }}</RouterLink></td><td><span :class="['difficulty', problem.difficulty]">{{ DIFFICULTY_LABELS[problem.difficulty] }}</span></td><td>{{ problem.acceptance.toFixed(1) }}%</td><td><span v-for="tag in problem.tags" :key="tag" class="tag">{{ tag }}</span></td></tr><tr v-if="!store.problems.length && !store.error"><td colspan="6" class="empty-cell">没有匹配的题目，试试调整筛选条件。</td></tr></tbody>
          <tbody v-else><tr v-for="item in 5" :key="item"><td colspan="6"><span class="skeleton-line"></span></td></tr></tbody>
        </table>
      </div>
      <div class="pagination"><span>显示 {{ totalStart }}–{{ totalEnd }} / {{ store.total }}</span><div><button type="button" :disabled="store.query.page <= 1" @click="changePage(store.query.page - 1)">← 上一页</button><span>{{ store.query.page }} / {{ store.pageCount }}</span><button type="button" :disabled="store.query.page >= store.pageCount" @click="changePage(store.query.page + 1)">下一页 →</button></div></div>
    </section>
  </main>
</template>
