<script setup lang="ts">
import { computed, onMounted, watch } from 'vue'
import { useRoute, useRouter } from 'vue-router'
import NavBar from '../components/NavBar.vue'
import { useProblemStore } from '../store/problems'
import { DIFFICULTY_LABELS } from '../utils/constants'
import type { Difficulty } from '../types/oj'

const route = useRoute()
const router = useRouter()
const store = useProblemStore()
const difficultyOptions: Array<{ value: Difficulty | 'all'; label: string }> = [{ value: 'all', label: '全部' }, { value: 'easy', label: '简单' }, { value: 'medium', label: '中等' }, { value: 'hard', label: '困难' }]
const totalStart = computed(() => (store.filteredProblems.length ? (store.query.page - 1) * store.query.pageSize + 1 : 0))
const totalEnd = computed(() => Math.min(store.query.page * store.query.pageSize, store.filteredProblems.length))

const updateFromRoute = (): void => {
  const keyword = typeof route.query.keyword === 'string' ? route.query.keyword : ''
  const tag = typeof route.query.tag === 'string' ? route.query.tag : ''
  store.query.keyword = keyword
  store.query.tag = tag
}
const updateQuery = (): void => { store.query.page = 1 }
const toggleSort = (sortBy: 'id' | 'difficulty' | 'acceptance'): void => {
  if (store.query.sortBy === sortBy) store.query.order = store.query.order === 'asc' ? 'desc' : 'asc'
  else { store.query.sortBy = sortBy; store.query.order = 'asc' }
}
const reset = (): void => { store.resetQuery(); void router.replace('/problems') }

onMounted(() => { updateFromRoute(); void store.loadProblems() })
watch(() => route.query, updateFromRoute)
watch(() => [store.query.keyword, store.query.tag], () => { updateQuery() })
</script>

<template>
  <NavBar />
  <main class="problems-page page-shell">
    <header class="page-title"><p class="eyebrow">PROBLEM SET</p><h1>题库</h1><p>在问题里练习，在思考里成长。</p></header>
    <section class="filter-panel" aria-label="题目筛选">
      <div class="filter-search"><svg viewBox="0 0 24 24" aria-hidden="true"><circle cx="11" cy="11" r="6" /><path d="m16 16 4 4" /></svg><input v-model.trim="store.query.keyword" placeholder="搜索题目名称或标签" /></div>
      <div class="filter-row"><span>难度</span><div class="filter-pills"><button v-for="option in difficultyOptions" :key="option.value" type="button" :class="{ active: store.query.difficulty === option.value }" @click="store.query.difficulty = option.value; updateQuery()">{{ option.label }}</button></div></div>
      <div class="filter-row"><span>标签</span><div class="filter-pills tag-pills"><button type="button" :class="{ active: !store.query.tag }" @click="store.query.tag = ''; updateQuery()">全部</button><button v-for="tag in store.tags" :key="tag" type="button" :class="{ active: store.query.tag === tag }" @click="store.query.tag = tag; updateQuery()">{{ tag }}</button></div><button class="clear-filter" type="button" @click="reset">清空筛选</button></div>
    </section>
    <section class="problem-list-section">
      <div class="list-toolbar"><span>共 <strong>{{ store.filteredProblems.length }}</strong> 道题目</span><label>每页<select v-model.number="store.query.pageSize" @change="updateQuery"><option :value="20">20</option><option :value="50">50</option><option :value="100">100</option></select>题</label></div>
      <div class="problem-table-wrap">
        <table class="problem-table">
          <thead><tr><th class="status-col"></th><th><button type="button" @click="toggleSort('id')">题号 <span>↕</span></button></th><th>题目</th><th><button type="button" @click="toggleSort('difficulty')">难度 <span>↕</span></button></th><th><button type="button" @click="toggleSort('acceptance')">通过率 <span>↕</span></button></th><th>标签</th></tr></thead>
          <tbody v-if="!store.isLoading"><tr v-for="problem in store.pagedProblems" :key="problem.id" class="problem-row" @click="router.push(`/problem/${problem.id}`)"><td class="status-col"><span v-if="problem.solved" class="solved-icon" title="已通过">✓</span></td><td>{{ problem.id }}</td><td><RouterLink :to="`/problem/${problem.id}`" @click.stop>{{ problem.title }}</RouterLink></td><td><span :class="['difficulty', problem.difficulty]">{{ DIFFICULTY_LABELS[problem.difficulty] }}</span></td><td>{{ problem.acceptance }}%</td><td><span v-for="tag in problem.tags" :key="tag" class="tag">{{ tag }}</span></td></tr><tr v-if="!store.pagedProblems.length"><td colspan="6" class="empty-cell">没有匹配的题目，试试调整筛选条件。</td></tr></tbody>
          <tbody v-else><tr v-for="item in 5" :key="item"><td colspan="6"><span class="skeleton-line"></span></td></tr></tbody>
        </table>
      </div>
      <div class="pagination"><span>显示 {{ totalStart }}–{{ totalEnd }} / {{ store.filteredProblems.length }}</span><div><button type="button" :disabled="store.query.page <= 1" @click="store.query.page--">← 上一页</button><span>{{ store.query.page }} / {{ store.pageCount }}</span><button type="button" :disabled="store.query.page >= store.pageCount" @click="store.query.page++">下一页 →</button></div></div>
    </section>
  </main>
</template>
