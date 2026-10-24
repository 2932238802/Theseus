<script setup lang="ts">
import { computed, onMounted, ref } from 'vue'
import { useRouter } from 'vue-router'
import NavBar from '../components/NavBar.vue'
import { fetchStats } from '../api/stats'
import { useProblemStore } from '../store/problems'
import { DIFFICULTY_LABELS } from '../utils/constants'
import type { Stats } from '../types/oj'

const router = useRouter()
const problemStore = useProblemStore()
const searchKeyword = ref('')
const stats = ref<Stats | null>(null)
const categories = computed(() => problemStore.tags.slice(0, 6))
const featuredProblem = computed(() => problemStore.problems[0] ?? null)
const statsItems = computed(() => {
  if (stats.value) {
    return [
      { value: stats.value.totalProblems.toLocaleString(), label: '题目' },
      { value: stats.value.totalSubmissions.toLocaleString(), label: '提交' },
      { value: stats.value.acceptedSubmissions.toLocaleString(), label: '通过' },
    ]
  }
  if (problemStore.total) return [{ value: problemStore.total.toLocaleString(), label: '题目' }]
  return []
})

onMounted(() => {
  void problemStore.loadProblems()
  void problemStore.loadTags()
  void fetchStats().then((value) => { stats.value = value }).catch(() => { stats.value = null })
})
const search = (): void => { void router.push({ path: '/problems', query: { keyword: searchKeyword.value } }) }
</script>

<template>
  <NavBar />
  <main class="home-page page-shell">
    <header class="page-title"><h1>开始刷题</h1><p>搜索题目，或从今日推荐开始。</p></header>

    <section class="search-card" aria-label="题目搜索">
      <form class="search-form" @submit.prevent="search">
        <svg viewBox="0 0 24 24" aria-hidden="true"><circle cx="11" cy="11" r="6" /><path d="m16 16 4 4" /></svg>
        <input v-model.trim="searchKeyword" placeholder="搜索题目、标签或关键词" aria-label="搜索题目" />
        <button class="primary-button" type="submit">搜索</button>
      </form>
    </section>

    <section class="daily-section" aria-labelledby="daily-title">
      <div class="section-heading"><h2 id="daily-title">今日推荐</h2><RouterLink class="inline-link" to="/problems">全部题目</RouterLink></div>
      <article v-if="featuredProblem" class="daily-card" @click="router.push(`/problem/${featuredProblem.id}`)">
        <div class="daily-main">
          <div class="problem-meta"><span :class="['difficulty', featuredProblem.difficulty]">{{ DIFFICULTY_LABELS[featuredProblem.difficulty] }}</span><span v-for="tag in featuredProblem.tags" :key="tag" class="tag">{{ tag }}</span></div>
          <h3>{{ featuredProblem.title }}</h3>
          <p>{{ featuredProblem.description.slice(0, 90) }}…</p>
        </div>
        <div class="daily-stat"><strong>{{ featuredProblem.acceptance.toFixed(1) }}<small>%</small></strong><span>通过率</span></div>
      </article>
      <div v-else class="empty-state"><p>题库暂时没有题目。</p></div>
    </section>

    <section v-if="categories.length" class="categories-section" aria-labelledby="categories-title">
      <div class="section-heading"><h2 id="categories-title">分类</h2></div>
      <div class="tag-group">
        <RouterLink v-for="category in categories" :key="category" :to="{ path: '/problems', query: { tag: category } }" class="tag tag-link">{{ category }}</RouterLink>
      </div>
    </section>

    <section v-if="statsItems.length" class="stats-section" aria-label="平台统计">
      <article v-for="item in statsItems" :key="item.label"><strong>{{ item.value }}</strong><span>{{ item.label }}</span></article>
    </section>
  </main>
</template>
