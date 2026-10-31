<script setup lang="ts">
import { computed, onMounted, ref } from 'vue'
import NavBar from '../components/NavBar.vue'
import { fetchProblemNotes } from '../api/notes'
import { toErrorMessage } from '../api/client'
import { DIFFICULTY_LABELS } from '../utils/constants'
import type { ProblemNoteListItem } from '../types/note'

const size = 20
const notes = ref<ProblemNoteListItem[]>([])
const total = ref(0)
const page = ref(1)
const loading = ref(false)
const error = ref('')

const totalPages = computed(() => Math.max(1, Math.ceil(total.value / size)))

const load = async (nextPage = page.value): Promise<void> => {
  loading.value = true
  error.value = ''
  try {
    const result = await fetchProblemNotes(nextPage, size)
    notes.value = result.notes
    total.value = result.total
    page.value = result.page
  } catch (exception: unknown) {
    error.value = toErrorMessage(exception)
  } finally {
    loading.value = false
  }
}

const updatedLabel = (value: string): string =>
  new Date(value).toLocaleString('zh-CN', {
    month: '2-digit',
    day: '2-digit',
    hour: '2-digit',
    minute: '2-digit',
  })

onMounted(() => {
  void load(1)
})
</script>

<template>
  <NavBar />
  <main class="profile-page page-shell">
    <header class="teaching-page-header">
      <div>
        <h1>我的笔记</h1>
      </div>
    </header>

    <p v-if="error" class="form-error" role="alert">{{ error }}</p>
    <p v-if="loading" class="empty-state"><span>正在加载笔记</span></p>
    <div v-else-if="notes.length" class="profile-favorites">
      <article v-for="item in notes" :key="item.problemId">
        <div>
          <RouterLink :to="`/problem/${item.problemId}`">
            <strong>{{ item.title }}</strong>
          </RouterLink>
          <p>
            <span :class="['difficulty', item.difficulty]">{{ DIFFICULTY_LABELS[item.difficulty] }}</span>
            · 更新于 {{ updatedLabel(item.updatedAt) }}
          </p>
          <p class="profile-favorite-excerpt">{{ item.excerpt }}</p>
        </div>
        <div class="profile-favorite-actions">
          <RouterLink class="teaching-secondary-button" :to="`/problem/${item.problemId}`">
            打开题目
          </RouterLink>
        </div>
      </article>
    </div>
    <div v-else class="empty-state">
      <p>还没有题目笔记</p>
      <RouterLink class="primary-button" to="/problems">去题库 <span>→</span></RouterLink>
    </div>

    <div v-if="total > size" class="profile-pager">
      <button
        type="button"
        class="teaching-secondary-button"
        :disabled="page <= 1 || loading"
        @click="load(page - 1)"
      >
        上一页
      </button>
      <span>{{ page }} / {{ totalPages }}</span>
      <button
        type="button"
        class="teaching-secondary-button"
        :disabled="page >= totalPages || loading"
        @click="load(page + 1)"
      >
        下一页
      </button>
    </div>
  </main>
</template>
