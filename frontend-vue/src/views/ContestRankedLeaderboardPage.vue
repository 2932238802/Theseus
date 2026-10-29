<script setup lang="ts">
import { computed, onMounted, ref } from 'vue'
import NavBar from '../components/NavBar.vue'
import { toErrorMessage } from '../api/client'
import { fetchRankedContestLeaderboard } from '../api/contests'
import type { RankedLeaderboard } from '../types/contest'

const data = ref<RankedLeaderboard | null>(null)
const loading = ref(true)
const error = ref('')

const totalLabel = computed(() =>
  data.value ? `共 ${data.value.total} 名活跃学生` : '',
)

const myEntry = computed(() => data.value?.entries.find((entry) => entry.is_me) ?? null)

const load = async (): Promise<void> => {
  loading.value = true
  error.value = ''
  try {
    data.value = await fetchRankedContestLeaderboard(50)
  } catch (exception: unknown) {
    error.value = toErrorMessage(exception)
  } finally {
    loading.value = false
  }
}

onMounted(() => {
  void load()
})
</script>

<template>
  <NavBar />
  <main class="teaching-page page-shell contests-page">
    <header class="teaching-page-header">
      <div>
        <RouterLink class="teaching-breadcrumb" :to="{ name: 'contests' }">竞赛首页</RouterLink>
        <h1>排位榜</h1>
        <p class="teaching-subtle">{{ totalLabel || '按段位分排序，赛事比赛不计入排位分' }}</p>
      </div>
      <RouterLink class="forum-secondary-button" :to="{ name: 'contests' }">返回竞赛</RouterLink>
    </header>

    <div v-if="loading" class="empty-state"><p>正在加载排位榜</p></div>

    <div v-else-if="error" class="contest-events-feedback">
      <p class="form-error" role="alert">{{ error }}</p>
      <button class="forum-secondary-button" type="button" @click="load">重试</button>
    </div>

    <template v-else-if="data">
      <section class="ranking-me contest-ranked-me" aria-label="我的排位">
        <div class="ranking-me-rank">
          <span>我的排名</span>
          <strong>{{ data.my_rank === null ? '—' : `#${data.my_rank}` }}</strong>
        </div>
        <div class="ranking-me-stat">
          <span>段位分</span>
          <strong>{{ data.my_rating }}</strong>
        </div>
        <div v-if="myEntry" class="ranking-me-stat">
          <span>已参赛</span>
          <strong>{{ myEntry.played }}</strong>
        </div>
        <div v-if="myEntry" class="ranking-me-stat">
          <span>第一名</span>
          <strong>{{ myEntry.wins }}</strong>
        </div>
      </section>

      <section class="teaching-panel">
        <p v-if="!data.entries.length" class="teaching-subtle">还没有排位记录</p>
        <div v-else class="contest-leaderboard-wrap">
          <table class="contest-detail-table contest-leaderboard">
            <thead>
              <tr>
                <th scope="col">排名</th>
                <th scope="col">学生</th>
                <th scope="col">段位分</th>
                <th scope="col">参赛场次</th>
                <th scope="col">第一名</th>
              </tr>
            </thead>
            <tbody>
              <tr
                v-for="entry in data.entries"
                :key="entry.user_id"
                :class="{ 'is-me': entry.is_me }"
              >
                <td>#{{ entry.rank }}</td>
                <td>
                  {{ entry.username }}
                  <span v-if="entry.is_me" class="contest-event-registered">我</span>
                </td>
                <td>{{ entry.rating }}</td>
                <td>{{ entry.played }}</td>
                <td>{{ entry.wins }}</td>
              </tr>
            </tbody>
          </table>
        </div>
      </section>
    </template>
  </main>
</template>
