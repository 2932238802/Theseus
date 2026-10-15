<script setup lang="ts">
import { computed, onMounted, ref } from 'vue'
import { useRouter } from 'vue-router'
import NavBar from '../components/NavBar.vue'
import { useProblemStore } from '../store/problems'
import { DIFFICULTY_LABELS } from '../utils/constants'

const router = useRouter()
const problemStore = useProblemStore()
const searchKeyword = ref('')
const categories = ['数组', '字符串', '动态规划', '链表', '哈希表', '二分查找']
const featuredProblem = computed(() => problemStore.problems[2] ?? problemStore.problems[0])

onMounted(() => { void problemStore.loadProblems() })
const search = (): void => { void router.push({ path: '/problems', query: { keyword: searchKeyword.value } }) }
</script>

<template>
  <NavBar />
  <main class="home-page">
    <section class="hero-section">
      <div class="hero-grid" aria-hidden="true"></div>
      <p class="eyebrow">THE ALGORITHM PRACTICE GROUND</p>
      <h1>穿过迷宫，<em>找到</em><br />你的解法。</h1>
      <p class="hero-description">从第一行代码开始，在每一次尝试里建立属于自己的算法直觉。</p>
      <form class="hero-search" @submit.prevent="search">
        <svg viewBox="0 0 24 24" aria-hidden="true"><circle cx="11" cy="11" r="6" /><path d="m16 16 4 4" /></svg>
        <input v-model.trim="searchKeyword" placeholder="搜索题目、标签或关键词" aria-label="搜索题目" />
        <button type="submit">搜索</button>
      </form>
      <div class="hero-actions"><RouterLink class="primary-button" to="/problems">开始刷题 <span>→</span></RouterLink><a href="#daily" class="text-button">查看今日推荐 <span>↓</span></a></div>
      <div class="hero-number" aria-hidden="true">01</div>
    </section>

    <section id="daily" class="content-section daily-section">
      <div class="section-heading"><div><p class="eyebrow">DAILY CHALLENGE</p><h2>今日一题</h2></div><span class="date-mark">OCT<br /><strong>15</strong></span></div>
      <article v-if="featuredProblem" class="daily-card" @click="router.push(`/problem/${featuredProblem.id}`)">
        <div class="daily-index">{{ String(featuredProblem.id).padStart(2, '0') }}</div>
        <div class="daily-main"><div class="problem-meta"><span :class="['difficulty', featuredProblem.difficulty]">{{ DIFFICULTY_LABELS[featuredProblem.difficulty] }}</span><span v-for="tag in featuredProblem.tags" :key="tag" class="tag">{{ tag }}</span></div><h3>{{ featuredProblem.title }}</h3><p>{{ featuredProblem.description.slice(0, 72) }}…</p><span class="card-link">打开题目 <b>→</b></span></div>
        <div class="daily-stat"><strong>{{ featuredProblem.acceptance }}<small>%</small></strong><span>通过率</span></div>
      </article>
    </section>

    <section class="content-section categories-section">
      <div class="section-heading"><div><p class="eyebrow">EXPLORE BY TOPIC</p><h2>从一个方向开始</h2></div><RouterLink to="/problems" class="inline-link">全部题目 <span>→</span></RouterLink></div>
      <div class="category-grid">
        <RouterLink v-for="(category, index) in categories" :key="category" :to="{ path: '/problems', query: { tag: category } }" class="category-card"><span>0{{ index + 1 }}</span><h3>{{ category }}</h3><i>→</i></RouterLink>
      </div>
    </section>

    <section class="stats-band"><div><strong>2,840<span>+</span></strong><p>精选题目</p></div><div><strong>48<span>+</span></strong><p>知识主题</p></div><div><strong>186k<span>+</span></strong><p>完成提交</p></div><p class="stats-copy">每一个数字的背后，<br />都是一次更接近答案的尝试。</p></section>
  </main>
</template>
