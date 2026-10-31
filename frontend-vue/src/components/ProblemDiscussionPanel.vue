<script setup lang="ts">
import { computed, ref, watch } from 'vue'
import { fetchForumPosts } from '../api/forum'
import { toErrorMessage } from '../api/client'
import { useAuthStore } from '../store/auth'
import type { ForumPostSummary, ForumSort } from '../types/forum'
import { FORUM_TAG_LABELS } from '../types/forum'
import { formatForumTime } from '../utils/forum'

const props = defineProps<{ problemId: number }>()

const authStore = useAuthStore()
const posts = ref<ForumPostSummary[]>([])
const total = ref(0)
const page = ref(1)
const sort = ref<ForumSort>('hot')
const loading = ref(false)
const loaded = ref(false)
const error = ref('')
let requestSequence = 0
const PAGE_SIZE = 10

const composePath = computed(() => `/forum/new?problem=${props.problemId}`)
const composeTarget = computed(() =>
  authStore.isAuthenticated
    ? composePath.value
    : { name: 'login', query: { redirect: composePath.value } },
)
const hasMore = computed(() => posts.value.length < total.value)

const load = async (append = false): Promise<void> => {
  const requestId = ++requestSequence
  const nextPage = append ? page.value + 1 : 1
  loading.value = true
  error.value = ''
  try {
    const result = await fetchForumPosts({
      page: nextPage,
      size: PAGE_SIZE,
      problem_id: props.problemId,
      sort: sort.value,
    })
    if (requestId !== requestSequence) return
    posts.value = append ? [...posts.value, ...result.posts] : result.posts
    total.value = result.total
    page.value = nextPage
    loaded.value = true
  } catch (exception: unknown) {
    if (requestId !== requestSequence) return
    error.value = toErrorMessage(exception)
    if (!append) {
      posts.value = []
      total.value = 0
    }
  } finally {
    if (requestId === requestSequence) loading.value = false
  }
}

const setSort = (next: ForumSort): void => {
  if (sort.value === next) return
  sort.value = next
  page.value = 1
  void load()
}

const tagLabel = (tag: string): string =>
  FORUM_TAG_LABELS[tag as keyof typeof FORUM_TAG_LABELS] ?? tag

watch(
  () => props.problemId,
  () => {
    posts.value = []
    total.value = 0
    page.value = 1
    loaded.value = false
    void load()
  },
  { immediate: true },
)
</script>

<template>
  <section class="problem-discussion" aria-label="题解与讨论">
    <header class="problem-discussion-head">
      <h2>题解与讨论</h2>
      <RouterLink class="primary-button" :to="composeTarget">写题解</RouterLink>
    </header>
    <div class="problem-discussion-sort" role="group" aria-label="排序方式">
      <button type="button" :class="{ active: sort === 'hot' }" @click="setSort('hot')">最热</button>
      <button type="button" :class="{ active: sort === 'latest' }" @click="setSort('latest')">最新</button>
    </div>

    <p v-if="error" class="form-error" role="alert">{{ error }}</p>
    <div v-if="loading && !posts.length" class="run-note">正在加载题解</div>
    <div v-else-if="loaded && !posts.length" class="problem-discussion-empty">
      <p>还没有题解或讨论</p>
      <RouterLink class="primary-button" :to="composeTarget">写下第一篇</RouterLink>
    </div>
    <div v-else-if="posts.length" class="problem-discussion-list">
      <RouterLink
        v-for="post in posts"
        :key="post.id"
        class="problem-discussion-item"
        :to="`/forum/${post.id}`"
      >
        <div class="problem-discussion-title">
          <h3>{{ post.title }}</h3>
          <span v-for="tag in post.tags.slice(0, 3)" :key="tag" class="forum-tag">{{ tagLabel(tag) }}</span>
        </div>
        <div class="problem-discussion-meta">
          <span :class="{ 'forum-author-anonymous': post.author.isAnonymous }">{{ post.author.displayName }}</span>
          <span v-if="post.author.isPlus" class="forum-plus-badge">Plus</span>
          <time :datetime="post.createdAt">{{ formatForumTime(post.createdAt) }}</time>
          <span>♥ {{ post.likeCount }}</span>
          <span>💬 {{ post.commentCount }}</span>
        </div>
      </RouterLink>
    </div>
    <button
      v-if="hasMore"
      type="button"
      class="problem-discussion-more"
      :disabled="loading"
      @click="load(true)"
    >
      {{ loading ? '加载中' : '加载更多' }}
    </button>
  </section>
</template>
