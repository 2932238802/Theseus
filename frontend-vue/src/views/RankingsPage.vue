<script setup lang="ts">
import { computed, onMounted, ref, watch } from 'vue'
import NavBar from '../components/NavBar.vue'
import { toErrorMessage } from '../api/client'
import { fetchRankings } from '../api/rankings'
import { useAuthStore } from '../store/auth'
import type { RankingResult } from '../types/ranking'

const PAGE_SIZE = 20

const authStore = useAuthStore()
const data = ref<RankingResult | null>(null)
const page = ref(1)
const loading = ref(false)
const error = ref('')
let requestSequence = 0

const entries = computed(() => data.value?.entries ?? [])
const total = computed(() => data.value?.total ?? 0)
const pageSize = computed(() => data.value?.size || PAGE_SIZE)
const pageCount = computed(() => Math.max(1, Math.ceil(total.value / pageSize.value)))
const totalStart = computed(() => (total.value ? (page.value - 1) * pageSize.value + 1 : 0))
const totalEnd = computed(() => Math.min(page.value * pageSize.value, total.value))
const me = computed(() => data.value?.me ?? null)

const load = async (targetPage = page.value): Promise<void> => {
  const requestId = ++requestSequence
  loading.value = true
  error.value = ''
  try {
    const result = await fetchRankings(targetPage, PAGE_SIZE)
    if (requestId !== requestSequence) return
    data.value = result
    page.value = result.page
  } catch (exception: unknown) {
    if (requestId !== requestSequence) return
    error.value = toErrorMessage(exception)
  } finally {
    if (requestId === requestSequence) loading.value = false
  }
}

const changePage = (targetPage: number): void => {
  if (targetPage < 1 || targetPage > pageCount.value || targetPage === page.value) return
  void load(targetPage)
}

onMounted(() => {
  void load(1)
})

watch(() => `${authStore.user?.id ?? ''}:${authStore.isStudent}`, () => {
  void load(page.value)
})
</script>

<template>
  <NavBar />
  <main class="rankings-page page-shell">
    <header class="page-title"><h1>排行榜</h1></header>

    <section v-if="authStore.isStudent && data && !error" class="ranking-me" aria-label="我的排名">
      <template v-if="me">
        <div class="ranking-me-rank"><span>我的排名</span><strong>#{{ me.rank }}</strong></div>
        <div class="ranking-me-stat"><span>通过</span><strong>{{ me.solved }}</strong></div>
        <div class="ranking-me-stat"><span>提交</span><strong>{{ me.submissions }}</strong></div>
        <div class="ranking-me-stat"><span>通过率</span><strong>{{ me.acceptanceRate.toFixed(1) }}%</strong></div>
      </template>
      <div v-else class="ranking-me-empty">
        <p>还没有 AC 题目 暂未上榜</p>
        <RouterLink class="primary-button" to="/problems">去刷题</RouterLink>
      </div>
    </section>

    <p class="ranking-hint">
      <span>仅学生参与排名 同分按通过率 再按最后通过时间早者优先</span>
      <RouterLink v-if="!authStore.isAuthenticated" to="/login?redirect=/rankings">登录后查看我的排名</RouterLink>
    </p>

    <p v-if="error" class="list-error" role="alert">{{ error }} <button type="button" @click="load(page)">重试</button></p>

    <section v-if="loading && !data" class="empty-state"><p>正在加载排行榜</p></section>
    <section v-else-if="!entries.length && !error" class="empty-state">
      <p>还没有上榜的同学</p>
      <RouterLink class="primary-button" to="/problems">去刷题</RouterLink>
    </section>

    <template v-else-if="entries.length">
      <div class="ranking-table-wrap">
        <table class="ranking-table">
          <thead>
            <tr>
              <th scope="col" class="ranking-rank">排名</th>
              <th scope="col">用户</th>
              <th scope="col">通过</th>
              <th scope="col">提交</th>
              <th scope="col">通过率</th>
            </tr>
          </thead>
          <tbody>
            <tr
              v-for="entry in entries"
              :key="entry.userId"
              :class="{ 'is-me': entry.userId === authStore.user?.id }"
            >
              <td class="ranking-rank" :class="{ top: entry.rank <= 3 }">{{ entry.rank }}</td>
              <td class="ranking-user">
                {{ entry.username }}
                <span v-if="entry.userId === authStore.user?.id" class="ranking-you">我</span>
              </td>
              <td>{{ entry.solved }}</td>
              <td>{{ entry.submissions }}</td>
              <td>{{ entry.acceptanceRate.toFixed(1) }}%</td>
            </tr>
          </tbody>
        </table>
      </div>
      <div class="pagination">
        <span>显示 {{ totalStart }}–{{ totalEnd }} / {{ total }}</span>
        <div>
          <button type="button" :disabled="page <= 1 || loading" @click="changePage(page - 1)">← 上一页</button>
          <span>{{ page }} / {{ pageCount }}</span>
          <button type="button" :disabled="page >= pageCount || loading" @click="changePage(page + 1)">下一页 →</button>
        </div>
      </div>
    </template>
  </main>
</template>
