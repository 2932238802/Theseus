<script setup lang="ts">
import { computed, onMounted, ref } from 'vue'
import { RouterLink } from 'vue-router'
import NavBar from '../components/NavBar.vue'
import { toErrorMessage } from '../api/client'
import { fetchKnowledgeArticles } from '../api/knowledge'
import { useAuthStore } from '../store/auth'
import type { KnowledgeCategory, KnowledgeList } from '../types/knowledge'
import { formatDateTime } from '../utils/teaching'

const props = defineProps<{ category: KnowledgeCategory }>()

const authStore = useAuthStore()
const data = ref<KnowledgeList | null>(null)
const loading = ref(true)
const error = ref('')
const searchInput = ref('')
const query = ref('')
const activeTag = ref('')

const categoryLabel = computed(() => (props.category === '408' ? '408 专区' : '面经'))
const pageCount = computed(() => {
  if (!data.value) return 1
  return Math.max(1, Math.ceil(data.value.total / data.value.size))
})
const hasPrevious = computed(() => (data.value?.page ?? 1) > 1)
const hasNext = computed(() => (data.value?.page ?? 1) < pageCount.value)
const showGate = computed(
  () => Boolean(data.value) && !data.value?.is_plus && !authStore.isAdmin,
)

const load = async (page = data.value?.page ?? 1): Promise<void> => {
  loading.value = true
  error.value = ''
  try {
    data.value = await fetchKnowledgeArticles({
      category: props.category,
      q: query.value || undefined,
      tag: activeTag.value || undefined,
      page,
      size: 12,
    })
  } catch (exception: unknown) {
    error.value = toErrorMessage(exception)
  } finally {
    loading.value = false
  }
}

const applySearch = (): void => {
  query.value = searchInput.value.trim()
  void load(1)
}

const clearSearch = (): void => {
  searchInput.value = ''
  query.value = ''
  void load(1)
}

const selectTag = (tag: string): void => {
  activeTag.value = tag
  void load(1)
}

const clearTag = (): void => {
  activeTag.value = ''
  void load(1)
}

onMounted(() => {
  void load(1)
})
</script>

<template>
  <NavBar />
  <main class="teaching-page page-shell knowledge-page">
    <header class="teaching-page-header">
      <div>
        <h1>{{ categoryLabel }}</h1>
      </div>
      <RouterLink
        v-if="data?.can_submit"
        class="primary-button"
        :to="{ path: '/knowledge/new', query: { category } }"
      >
        投稿
      </RouterLink>
    </header>

    <p v-if="showGate" class="knowledge-gate-note">
      <span>正文需要 Plus Theseus 才能阅读</span>
      <RouterLink to="/shop">去开通</RouterLink>
    </p>

    <form class="knowledge-toolbar" role="search" @submit.prevent="applySearch">
      <input
        v-model="searchInput"
        type="search"
        maxlength="100"
        placeholder="搜索标题或摘要"
        aria-label="搜索标题或摘要"
      />
      <button class="forum-secondary-button" type="submit">搜索</button>
      <button
        v-if="query"
        class="forum-secondary-button"
        type="button"
        @click="clearSearch"
      >
        清除
      </button>
      <button
        v-if="activeTag"
        class="forum-tag"
        type="button"
        @click="clearTag"
      >
        标签：{{ activeTag }} ×
      </button>
    </form>

    <p v-if="error" class="form-error" role="alert">{{ error }}</p>

    <div v-if="loading" class="empty-state"><p>正在加载</p></div>
    <div v-else-if="!data?.items.length" class="empty-state"><p>还没有内容</p></div>

    <section v-else class="knowledge-list" aria-label="内容列表">
      <article v-for="item in data.items" :key="item.id" class="knowledge-card">
        <RouterLink class="knowledge-card-title" :to="`/knowledge/${item.id}`">
          {{ item.title }}
        </RouterLink>
        <p v-if="item.summary" class="knowledge-card-summary">{{ item.summary }}</p>
        <div class="knowledge-card-meta">
          <span>{{ item.author ?? '已注销用户' }}</span>
          <span>{{ formatDateTime(item.created_at) }}</span>
        </div>
        <div v-if="item.tags.length" class="forum-tag-row">
          <button
            v-for="tag in item.tags"
            :key="tag"
            class="forum-tag"
            type="button"
            @click="selectTag(tag)"
          >
            {{ tag }}
          </button>
        </div>
      </article>
    </section>

    <div v-if="data && data.total > 0" class="pagination">
      <span>共 {{ data.total }} 篇</span>
      <div>
        <button type="button" :disabled="!hasPrevious" @click="load(data.page - 1)">
          ← 上一页
        </button>
        <span>{{ data.page }} / {{ pageCount }}</span>
        <button type="button" :disabled="!hasNext" @click="load(data.page + 1)">
          下一页 →
        </button>
      </div>
    </div>
  </main>
</template>
