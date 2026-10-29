<script setup lang="ts">
import { computed, onMounted, ref } from 'vue'
import { useRoute } from 'vue-router'
import NavBar from '../components/NavBar.vue'
import { favoriteForumPost } from '../api/forum'
import { fetchForumFavorites } from '../api/profile'
import {
  fetchCommentFavorites,
  fetchProblemFavorites,
  setCommentFavorite,
  setProblemFavorite,
} from '../api/favorites'
import { toErrorMessage } from '../api/client'
import { DIFFICULTY_LABELS } from '../utils/constants'
import type { CommentFavorite, ForumFavorite, ProblemFavorite } from '../types/profile'

type TabKey = 'problems' | 'posts' | 'comments'

const route = useRoute()
const tabFromQuery = (): TabKey => {
  const value = Array.isArray(route.query.tab) ? route.query.tab[0] : route.query.tab
  return value === 'posts' || value === 'comments' ? value : 'problems'
}

const tabs: Array<{ key: TabKey; label: string; unit: string }> = [
  { key: 'problems', label: '题目', unit: '道题目' },
  { key: 'posts', label: '帖子', unit: '篇帖子' },
  { key: 'comments', label: '评论', unit: '条评论' },
]
const activeTab = ref<TabKey>(tabFromQuery())
const size = 20
const busyId = ref('')

const problems = ref<ProblemFavorite[]>([])
const problemTotal = ref(0)
const problemPage = ref(1)
const problemLoading = ref(false)
const problemError = ref('')

const posts = ref<ForumFavorite[]>([])
const postTotal = ref(0)
const postPage = ref(1)
const postLoading = ref(false)
const postError = ref('')

const comments = ref<CommentFavorite[]>([])
const commentTotal = ref(0)
const commentPage = ref(1)
const commentLoading = ref(false)
const commentError = ref('')

const loaded = new Set<TabKey>()

const currentTotal = computed(() => {
  if (activeTab.value === 'problems') return problemTotal.value
  if (activeTab.value === 'posts') return postTotal.value
  return commentTotal.value
})
const currentPage = computed(() => {
  if (activeTab.value === 'problems') return problemPage.value
  if (activeTab.value === 'posts') return postPage.value
  return commentPage.value
})
const currentLoading = computed(() => {
  if (activeTab.value === 'problems') return problemLoading.value
  if (activeTab.value === 'posts') return postLoading.value
  return commentLoading.value
})
const totalPages = computed(() => Math.max(1, Math.ceil(currentTotal.value / size)))
const currentUnit = computed(
  () => tabs.find((tab) => tab.key === activeTab.value)?.unit ?? '条收藏',
)

const loadProblems = async (nextPage = problemPage.value): Promise<void> => {
  problemLoading.value = true
  problemError.value = ''
  try {
    const result = await fetchProblemFavorites(nextPage, size)
    problems.value = result.favorites
    problemTotal.value = result.total
    problemPage.value = result.page
    loaded.add('problems')
  } catch (exception: unknown) {
    problemError.value = toErrorMessage(exception)
  } finally {
    problemLoading.value = false
  }
}

const loadPosts = async (nextPage = postPage.value): Promise<void> => {
  postLoading.value = true
  postError.value = ''
  try {
    const result = await fetchForumFavorites(nextPage, size)
    posts.value = result.favorites
    postTotal.value = result.total
    postPage.value = result.page
    loaded.add('posts')
  } catch (exception: unknown) {
    postError.value = toErrorMessage(exception)
  } finally {
    postLoading.value = false
  }
}

const loadComments = async (nextPage = commentPage.value): Promise<void> => {
  commentLoading.value = true
  commentError.value = ''
  try {
    const result = await fetchCommentFavorites(nextPage, size)
    comments.value = result.favorites
    commentTotal.value = result.total
    commentPage.value = result.page
    loaded.add('comments')
  } catch (exception: unknown) {
    commentError.value = toErrorMessage(exception)
  } finally {
    commentLoading.value = false
  }
}

const loadTab = (tab: TabKey, page = 1): void => {
  if (tab === 'problems') void loadProblems(page)
  else if (tab === 'posts') void loadPosts(page)
  else void loadComments(page)
}

const selectTab = (tab: TabKey): void => {
  activeTab.value = tab
  if (!loaded.has(tab)) loadTab(tab, 1)
}

const loadPage = (page: number): void => {
  if (page < 1 || page > totalPages.value) return
  loadTab(activeTab.value, page)
}

const removeProblem = async (item: ProblemFavorite): Promise<void> => {
  if (busyId.value) return
  busyId.value = `problem-${item.problemId}`
  problemError.value = ''
  try {
    await setProblemFavorite(item.problemId, false)
    await loadProblems(problems.value.length === 1 && problemPage.value > 1 ? problemPage.value - 1 : problemPage.value)
  } catch (exception: unknown) {
    problemError.value = toErrorMessage(exception)
  } finally {
    busyId.value = ''
  }
}

const removePost = async (item: ForumFavorite): Promise<void> => {
  if (busyId.value) return
  busyId.value = `post-${item.postId}`
  postError.value = ''
  try {
    await favoriteForumPost(item.postId, false)
    await loadPosts(posts.value.length === 1 && postPage.value > 1 ? postPage.value - 1 : postPage.value)
  } catch (exception: unknown) {
    postError.value = toErrorMessage(exception)
  } finally {
    busyId.value = ''
  }
}

const removeComment = async (item: CommentFavorite): Promise<void> => {
  if (busyId.value) return
  busyId.value = `comment-${item.commentId}`
  commentError.value = ''
  try {
    await setCommentFavorite(item.commentId, false)
    await loadComments(comments.value.length === 1 && commentPage.value > 1 ? commentPage.value - 1 : commentPage.value)
  } catch (exception: unknown) {
    commentError.value = toErrorMessage(exception)
  } finally {
    busyId.value = ''
  }
}

const statusLabel = (status: ForumFavorite['status']): string => {
  if (status === 'hidden') return '已隐藏'
  if (status === 'deleted') return '已删除'
  return '正常'
}

const commentExcerpt = (body: string): string => {
  const compact = body.replace(/\s+/g, ' ').trim()
  return compact.length > 120 ? `${compact.slice(0, 120)}…` : compact
}

const commentAnchor = (item: CommentFavorite): string =>
  `/forum/${item.postId}#comment-${item.commentId}`

onMounted(() => loadTab(activeTab.value, 1))
</script>

<template>
  <NavBar />
  <main class="profile-page page-shell">
    <header class="teaching-page-header">
      <div>
        <p class="teaching-breadcrumb">
          <RouterLink to="/profile">个人</RouterLink><span>/</span><span>我的收藏</span>
        </p>
        <h1>我的收藏</h1>
        <p class="teaching-subtle">共 {{ currentTotal }} {{ currentUnit }}</p>
      </div>
    </header>

    <nav class="profile-tabs profile-favorites-tabs" aria-label="收藏分类">
      <button
        v-for="tab in tabs"
        :key="tab.key"
        type="button"
        :class="{ active: activeTab === tab.key }"
        :aria-current="activeTab === tab.key ? 'page' : undefined"
        @click="selectTab(tab.key)"
      >
        {{ tab.label }}
      </button>
    </nav>

    <template v-if="activeTab === 'problems'">
      <p v-if="problemError" class="form-error" role="alert">{{ problemError }}</p>
      <p v-if="problemLoading" class="empty-state"><span>正在加载收藏</span></p>
      <div v-else-if="problems.length" class="profile-favorites">
        <article v-for="item in problems" :key="item.problemId">
          <div>
            <RouterLink :to="`/problem/${item.problemId}`">
              <strong>{{ item.title }}</strong>
            </RouterLink>
            <p>
              <span :class="['difficulty', item.difficulty]">{{ DIFFICULTY_LABELS[item.difficulty] }}</span>
              · 通过率 {{ item.acceptanceRate.toFixed(1) }}%
              · 收藏于 {{ new Date(item.favoritedAt).toLocaleString('zh-CN') }}
            </p>
          </div>
          <div class="profile-favorite-actions">
            <button
              type="button"
              class="teaching-secondary-button danger"
              :disabled="busyId === `problem-${item.problemId}`"
              @click="removeProblem(item)"
            >
              {{ busyId === `problem-${item.problemId}` ? '取消中' : '取消收藏' }}
            </button>
          </div>
        </article>
      </div>
      <div v-else class="empty-state">
        <p>还没有收藏题目，去题库看看</p>
        <RouterLink class="primary-button" to="/problems">去题库 <span>→</span></RouterLink>
      </div>
    </template>

    <template v-else-if="activeTab === 'posts'">
      <p v-if="postError" class="form-error" role="alert">{{ postError }}</p>
      <p v-if="postLoading" class="empty-state"><span>正在加载收藏</span></p>
      <div v-else-if="posts.length" class="profile-favorites">
        <article v-for="item in posts" :key="item.postId">
          <div>
            <RouterLink v-if="item.status === 'published'" :to="`/forum/${item.postId}`">
              <strong>{{ item.title }}</strong>
            </RouterLink>
            <strong v-else>{{ item.title }}</strong>
            <p>
              {{ item.author.username }} · 收藏于 {{ new Date(item.favoritedAt).toLocaleString('zh-CN') }}
              · {{ item.favoriteCount }} 收藏 · {{ item.commentCount }} 评论
            </p>
          </div>
          <div class="profile-favorite-actions">
            <span :class="['teaching-badge', item.status]">{{ statusLabel(item.status) }}</span>
            <button
              type="button"
              class="teaching-secondary-button danger"
              :disabled="busyId === `post-${item.postId}`"
              @click="removePost(item)"
            >
              {{ busyId === `post-${item.postId}` ? '取消中' : '取消收藏' }}
            </button>
          </div>
        </article>
      </div>
      <div v-else class="empty-state">
        <p>还没有收藏帖子，去校园墙看看</p>
        <RouterLink class="primary-button" to="/forum">去校园墙 <span>→</span></RouterLink>
      </div>
    </template>

    <template v-else>
      <p v-if="commentError" class="form-error" role="alert">{{ commentError }}</p>
      <p v-if="commentLoading" class="empty-state"><span>正在加载收藏</span></p>
      <div v-else-if="comments.length" class="profile-favorites">
        <article v-for="item in comments" :key="item.commentId">
          <div class="profile-favorite-comment">
            <RouterLink :to="commentAnchor(item)">
              <strong>{{ item.postTitle }}</strong>
            </RouterLink>
            <p class="profile-favorite-excerpt">{{ commentExcerpt(item.bodyMd) }}</p>
            <p>
              {{ item.author.displayName }}
              <template v-if="item.parentId !== null"> · 回复</template>
              · 收藏于 {{ new Date(item.favoritedAt).toLocaleString('zh-CN') }}
            </p>
          </div>
          <div class="profile-favorite-actions">
            <button
              type="button"
              class="teaching-secondary-button danger"
              :disabled="busyId === `comment-${item.commentId}`"
              @click="removeComment(item)"
            >
              {{ busyId === `comment-${item.commentId}` ? '取消中' : '取消收藏' }}
            </button>
          </div>
        </article>
      </div>
      <div v-else class="empty-state">
        <p>还没有收藏评论，去校园墙参与讨论</p>
        <RouterLink class="primary-button" to="/forum">去校园墙 <span>→</span></RouterLink>
      </div>
    </template>

    <div v-if="currentTotal > size" class="profile-pager">
      <button
        type="button"
        class="teaching-secondary-button"
        :disabled="currentPage <= 1 || currentLoading"
        @click="loadPage(currentPage - 1)"
      >
        上一页
      </button>
      <span>{{ currentPage }} / {{ totalPages }}</span>
      <button
        type="button"
        class="teaching-secondary-button"
        :disabled="currentPage >= totalPages || currentLoading"
        @click="loadPage(currentPage + 1)"
      >
        下一页
      </button>
    </div>
  </main>
</template>
