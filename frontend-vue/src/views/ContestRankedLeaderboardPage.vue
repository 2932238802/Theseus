<script setup lang="ts">
import { onMounted, ref } from 'vue'
import NavBar from '../components/NavBar.vue'
import { toErrorMessage } from '../api/client'
import { fetchRankedContestLeaderboard } from '../api/contests'
import type { RankedLeaderboard } from '../types/contest'

const data = ref<RankedLeaderboard | null>(null)
const loading = ref(true)
const error = ref('')

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
    <div v-if="loading" class="empty-state"><p>正在加载排行榜</p></div>

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
              </tr>
            </tbody>
          </table>
        </div>
      </section>
    </template>
  </main>
</template>
