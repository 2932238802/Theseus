<script setup lang="ts">
import { onMounted, ref } from 'vue'
import NavBar from '../components/NavBar.vue'
import { favoriteForumPost } from '../api/forum'
import { fetchForumFavorites } from '../api/profile'
import { toErrorMessage } from '../api/client'
import type { ForumFavorite } from '../types/profile'

const favorites = ref<ForumFavorite[]>([])
const total = ref(0)
const page = ref(1)
const size = 20
const loading = ref(true)
const error = ref('')
const busyId = ref<number | null>(null)

const load = async (nextPage = page.value): Promise<void> => {
  loading.value = true
  error.value = ''
  try {
    const result = await fetchForumFavorites(nextPage, size)
    favorites.value = result.favorites
    total.value = result.total
    page.value = result.page
  } catch (exception: unknown) {
    error.value = toErrorMessage(exception)
  } finally {
    loading.value = false
  }
}

const remove = async (item: ForumFavorite): Promise<void> => {
  if (busyId.value) return
  busyId.value = item.postId
  error.value = ''
  try {
    await favoriteForumPost(item.postId, false)
    await load()
  } catch (exception: unknown) {
    error.value = toErrorMessage(exception)
  } finally {
    busyId.value = null
  }
}

const statusLabel = (status: ForumFavorite['status']): string => {
  if (status === 'hidden') return '已隐藏'
  if (status === 'deleted') return '已删除'
  return '正常'
}

const totalPages = (): number => Math.max(1, Math.ceil(total.value / size))

onMounted(() => void load())
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
        <p class="teaching-subtle">共 {{ total }} 条论坛收藏</p>
      </div>
    </header>

    <p v-if="error" class="form-error" role="alert">{{ error }}</p>
    <p v-if="loading" class="empty-state"><span>正在加载收藏</span></p>
    <div v-else-if="favorites.length" class="profile-favorites">
      <article v-for="item in favorites" :key="item.postId">
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
          <button type="button" class="teaching-secondary-button danger" :disabled="busyId === item.postId" @click="remove(item)">
            {{ busyId === item.postId ? '取消中' : '取消收藏' }}
          </button>
        </div>
      </article>
    </div>
    <div v-else class="empty-state">
      <p>还没有收藏帖子，去校园墙看看</p>
      <RouterLink class="primary-button" to="/forum">去校园墙 <span>→</span></RouterLink>
    </div>

    <div v-if="total > size" class="profile-pager">
      <button type="button" class="teaching-secondary-button" :disabled="page <= 1 || loading" @click="load(page - 1)">上一页</button>
      <span>{{ page }} / {{ totalPages() }}</span>
      <button type="button" class="teaching-secondary-button" :disabled="page >= totalPages() || loading" @click="load(page + 1)">下一页</button>
    </div>
  </main>
</template>
