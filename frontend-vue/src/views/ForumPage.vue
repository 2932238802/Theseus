<script setup lang="ts">
import { computed, onBeforeUnmount, onMounted, ref, watch } from 'vue'
import { useRoute, useRouter } from 'vue-router'
import ForumPostCard from '../components/ForumPostCard.vue'
import NavBar from '../components/NavBar.vue'
import { useAuthStore } from '../store/auth'
import { useForumStore } from '../store/forum'
import { FORUM_BOARDS, FORUM_TAGS } from '../types/forum'

const route = useRoute()
const router = useRouter()
const authStore = useAuthStore()
const forumStore = useForumStore()
const searchInput = ref(forumStore.query.q ?? '')
let searchTimer: number | undefined

const board = computed(() => forumStore.query.board ?? 'general')
const isInterview = computed(() => board.value === 'interview')
const locked = computed(() => forumStore.error.includes('Plus'))

const totalStart = computed(() =>
  forumStore.total ? (forumStore.query.page - 1) * forumStore.query.size + 1 : 0,
)
const totalEnd = computed(() =>
  Math.min(forumStore.query.page * forumStore.query.size, forumStore.total),
)
const hasFilters = computed(
  () =>
    Boolean(
      forumStore.query.tag ||
        forumStore.query.company ||
        forumStore.query.role ||
        forumStore.query.q ||
        forumStore.query.mine,
    ),
)

const onSearchInput = (): void => {
  window.clearTimeout(searchTimer)
  searchTimer = window.setTimeout(() => forumStore.setSearch(searchInput.value), 300)
}

const clearFilters = (): void => {
  const current = board.value
  searchInput.value = ''
  forumStore.resetQuery()
  forumStore.query.board = current
  void forumStore.loadPosts()
}

const onCompanyChange = (event: Event): void => {
  forumStore.setCompany((event.target as HTMLSelectElement).value)
}

const onRoleChange = (event: Event): void => {
  forumStore.setRole((event.target as HTMLSelectElement).value)
}

const selectBoard = (next: 'general' | 'interview'): void => {
  if (next === 'interview' && !authStore.isAuthenticated) {
    void router.push({ name: 'login', query: { redirect: '/forum?board=interview' } })
    return
  }
  searchInput.value = ''
  forumStore.setBoard(next)
}

watch(
  board,
  (value) => {
    const query = value === 'interview' ? { board: 'interview' } : {}
    void router.replace({ path: '/forum', query })
  },
)

onMounted(() => {
  const requested = route.query.board
  if (requested === 'interview') {
    forumStore.query.board = 'interview'
  } else {
    forumStore.query.board = 'general'
  }
  void forumStore.loadPosts()
  void forumStore.loadFacets()
})

onBeforeUnmount(() => window.clearTimeout(searchTimer))
</script>

<template>
  <NavBar />
  <main class="forum-page page-shell">
    <section class="forum-toolbar" aria-label="论坛筛选">
      <div class="forum-toolbar-row">
        <div class="forum-sort-tabs" role="tablist" aria-label="排序">
          <button
            type="button"
            role="tab"
            :aria-selected="(forumStore.query.sort ?? 'latest') === 'latest'"
            :class="{ active: (forumStore.query.sort ?? 'latest') === 'latest' }"
            @click="forumStore.setSort('latest')"
          >
            最新
          </button>
          <button
            type="button"
            role="tab"
            :aria-selected="forumStore.query.sort === 'hot'"
            :class="{ active: forumStore.query.sort === 'hot' }"
            @click="forumStore.setSort('hot')"
          >
            热门
          </button>
        </div>
        <label class="forum-search">
          <svg viewBox="0 0 24 24" aria-hidden="true"><circle cx="11" cy="11" r="6" /><path d="m16 16 4 4" /></svg>
          <input
            v-model="searchInput"
            type="search"
            maxlength="100"
            placeholder="搜索标题或正文"
            aria-label="搜索帖子"
            @input="onSearchInput"
            @keydown.enter.prevent="forumStore.setSearch(searchInput)"
          />
        </label>
        <RouterLink
          class="primary-button forum-compose-button"
          :to="
            authStore.isAuthenticated
              ? { path: '/forum/new', query: isInterview ? { board: 'interview' } : {} }
              : { name: 'login', query: { redirect: isInterview ? '/forum/new?board=interview' : '/forum/new' } }
          "
        >
          发帖 <span aria-hidden="true">→</span>
        </RouterLink>
      </div>

      <div class="forum-board-tabs" role="tablist" aria-label="板块">
        <button
          v-for="item in FORUM_BOARDS"
          :key="item.code"
          type="button"
          role="tab"
          :aria-selected="board === item.code"
          :class="['forum-board-tab', { active: board === item.code }]"
          @click="selectBoard(item.code)"
        >
          {{ item.label }}
          <span v-if="item.plusOnly" class="nav-vip-badge">VIP</span>
        </button>
      </div>

      <div class="forum-toolbar-row forum-tag-row">
        <template v-if="!isInterview">
          <button
            type="button"
            :class="['forum-filter-pill', { active: !forumStore.query.tag }]"
            @click="forumStore.setTag('')"
          >
            全部
          </button>
          <button
            v-for="tag in FORUM_TAGS"
            :key="tag.code"
            type="button"
            :class="['forum-filter-pill', { active: forumStore.query.tag === tag.code }]"
            @click="forumStore.setTag(tag.code)"
          >
            {{ tag.label }}
          </button>
        </template>
        <template v-else>
          <label v-if="forumStore.facets.companies.length" class="forum-select-filter">
            <span>公司</span>
            <select :value="forumStore.query.company ?? ''" @change="onCompanyChange">
              <option value="">全部公司</option>
              <option v-for="company in forumStore.facets.companies" :key="company" :value="company">
                {{ company }}
              </option>
            </select>
          </label>
          <label v-if="forumStore.facets.roles.length" class="forum-select-filter">
            <span>岗位</span>
            <select :value="forumStore.query.role ?? ''" @change="onRoleChange">
              <option value="">全部岗位</option>
              <option v-for="role in forumStore.facets.roles" :key="role" :value="role">
                {{ role }}
              </option>
            </select>
          </label>
        </template>
        <button
          v-if="authStore.isAuthenticated"
          type="button"
          :class="['forum-filter-pill', { active: forumStore.query.mine }]"
          @click="forumStore.setMine(!forumStore.query.mine)"
        >
          只看我的
        </button>
        <button v-if="hasFilters" type="button" class="clear-filter" @click="clearFilters">清空筛选</button>
      </div>
    </section>

    <section class="forum-feed" aria-live="polite">
      <section v-if="locked" class="forum-locked">
        <h1>面经仅对 Plus Theseus 开放</h1>
        <p>开通后可以查看面经 并在评论区留下答案</p>
        <RouterLink class="primary-button" to="/shop">去开通</RouterLink>
      </section>
      <p v-else-if="forumStore.error" class="list-error" role="alert">
        {{ forumStore.error }}
        <button type="button" @click="forumStore.loadPosts">重试</button>
      </p>

      <div v-if="!locked && forumStore.isLoading" class="forum-feed-loading">
        <span v-for="item in 3" :key="item" class="skeleton-line"></span>
      </div>
      <div v-else-if="!locked && forumStore.posts.length" class="forum-post-list">
        <ForumPostCard v-for="post in forumStore.posts" :key="post.id" :post="post" />
      </div>
      <div v-else-if="!locked && !forumStore.error" class="empty-state">
        <p>{{ hasFilters ? '没有匹配的帖子 试试调整筛选条件' : isInterview ? '还没有面经' : '还没有帖子 来发第一帖' }}</p>
        <RouterLink v-if="!hasFilters" class="primary-button" :to="isInterview ? '/forum/new?board=interview' : '/forum/new'">去发帖</RouterLink>
      </div>

      <div v-if="!locked && forumStore.total > 0" class="pagination">
        <span>显示 {{ totalStart }}–{{ totalEnd }} / {{ forumStore.total }}</span>
        <div>
          <button type="button" :disabled="forumStore.query.page <= 1" @click="forumStore.setPage(forumStore.query.page - 1)">
            ← 上一页
          </button>
          <span>{{ forumStore.query.page }} / {{ forumStore.pageCount }}</span>
          <button
            type="button"
            :disabled="forumStore.query.page >= forumStore.pageCount"
            @click="forumStore.setPage(forumStore.query.page + 1)"
          >
            下一页 →
          </button>
        </div>
      </div>
    </section>
  </main>
</template>
