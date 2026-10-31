<script setup lang="ts">
import { computed, onMounted, ref } from 'vue'
import { RouterLink } from 'vue-router'
import NavBar from '../components/NavBar.vue'
import { toErrorMessage } from '../api/client'
import { deleteKnowledgeArticle, fetchMyKnowledgeArticles } from '../api/knowledge'
import { toast } from '../store/toast'
import type { KnowledgeCategory, KnowledgeList, KnowledgeStatus } from '../types/knowledge'
import { formatDateTime } from '../utils/teaching'

const STATUS_OPTIONS: Array<{ value: '' | KnowledgeStatus; label: string }> = [
  { value: '', label: '全部' },
  { value: 'pending', label: '审核中' },
  { value: 'approved', label: '已通过' },
  { value: 'rejected', label: '未通过' },
]

const STATUS_LABELS: Record<KnowledgeStatus, string> = {
  pending: '审核中',
  approved: '已通过',
  rejected: '未通过',
}

const CATEGORY_OPTIONS: Array<{ value: '' | KnowledgeCategory; label: string }> = [
  { value: '', label: '全部栏目' },
  { value: '408', label: '408' },
  { value: 'interview', label: '面经' },
]

const STATUS_CLASSES: Record<KnowledgeStatus, string> = {
  pending: 'status-pending',
  approved: 'status-published',
  rejected: 'status-rejected',
}

const data = ref<KnowledgeList | null>(null)
const loading = ref(true)
const error = ref('')
const status = ref<'' | KnowledgeStatus>('')
const category = ref<'' | KnowledgeCategory>('')
const deletingId = ref<number | null>(null)

const pageCount = computed(() => {
  if (!data.value) return 1
  return Math.max(1, Math.ceil(data.value.total / data.value.size))
})
const hasPrevious = computed(() => (data.value?.page ?? 1) > 1)
const hasNext = computed(() => (data.value?.page ?? 1) < pageCount.value)

const load = async (page = data.value?.page ?? 1): Promise<void> => {
  loading.value = true
  error.value = ''
  try {
    data.value = await fetchMyKnowledgeArticles({
      status: status.value || undefined,
      category: category.value || undefined,
      page,
      size: 12,
    })
  } catch (exception: unknown) {
    error.value = toErrorMessage(exception)
  } finally {
    loading.value = false
  }
}

const setStatus = (value: '' | KnowledgeStatus): void => {
  if (status.value === value) return
  status.value = value
  void load(1)
}

const setCategory = (value: '' | KnowledgeCategory): void => {
  if (category.value === value) return
  category.value = value
  void load(1)
}

const remove = async (id: number): Promise<void> => {
  if (deletingId.value !== null) return
  if (!window.confirm('删除后无法恢复 确定删除吗')) return
  deletingId.value = id
  error.value = ''
  try {
    const result = await deleteKnowledgeArticle(id)
    toast.success(result.message)
    await load()
  } catch (exception: unknown) {
    error.value = toErrorMessage(exception)
  } finally {
    deletingId.value = null
  }
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
        <h1>我的投稿</h1>
      </div>
      <RouterLink
        v-if="data?.can_submit"
        class="primary-button"
        to="/knowledge/new?category=408"
      >
        投稿
      </RouterLink>
    </header>

    <nav class="teaching-toolbar" aria-label="投稿筛选">
      <button
        v-for="option in STATUS_OPTIONS"
        :key="option.value"
        class="forum-secondary-button"
        type="button"
        :class="{ 'is-active': status === option.value }"
        @click="setStatus(option.value)"
      >
        {{ option.label }}
      </button>
      <span class="teaching-subtle">|</span>
      <button
        v-for="option in CATEGORY_OPTIONS"
        :key="option.value"
        class="forum-secondary-button"
        type="button"
        :class="{ 'is-active': category === option.value }"
        @click="setCategory(option.value)"
      >
        {{ option.label }}
      </button>
    </nav>

    <p v-if="error" class="form-error" role="alert">{{ error }}</p>

    <div v-if="loading" class="empty-state"><p>正在加载投稿</p></div>
    <div v-else-if="!data?.items.length" class="empty-state"><p>还没有投稿</p></div>

    <section v-else class="knowledge-list" aria-label="我的投稿">
      <article v-for="item in data.items" :key="item.id" class="knowledge-card">
        <div class="knowledge-card-title-row">
          <RouterLink class="knowledge-card-title" :to="`/knowledge/${item.id}`">
            {{ item.title }}
          </RouterLink>
          <span class="forum-tag" :class="STATUS_CLASSES[item.status]">
            {{ STATUS_LABELS[item.status] }}
          </span>
        </div>
        <p v-if="item.summary" class="knowledge-card-summary">{{ item.summary }}</p>
        <div class="knowledge-card-meta">
          <span>{{ item.category === '408' ? '408' : '面经' }}</span>
          <span>{{ formatDateTime(item.created_at) }}</span>
        </div>
        <div class="knowledge-card-actions">
          <RouterLink
            v-if="item.status !== 'approved'"
            class="forum-secondary-button"
            :to="`/knowledge/${item.id}/edit`"
          >
            编辑
          </RouterLink>
          <button
            v-if="item.status !== 'approved'"
            class="forum-secondary-button"
            type="button"
            :disabled="deletingId === item.id"
            @click="remove(item.id)"
          >
            删除
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
