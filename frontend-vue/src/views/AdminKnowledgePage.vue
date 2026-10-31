<script setup lang="ts">
import { computed, onMounted, reactive, ref } from 'vue'
import { RouterLink } from 'vue-router'
import NavBar from '../components/NavBar.vue'
import { toErrorMessage } from '../api/client'
import { fetchAdminKnowledgeArticles, resolveAdminKnowledgeArticle } from '../api/knowledge'
import { toast } from '../store/toast'
import type { KnowledgeCategory, KnowledgeList, KnowledgeStatus } from '../types/knowledge'
import { formatDateTime } from '../utils/teaching'

const STATUS_OPTIONS: Array<{ value: '' | KnowledgeStatus; label: string }> = [
  { value: '', label: '全部' },
  { value: 'pending', label: '待审核' },
  { value: 'approved', label: '已通过' },
  { value: 'rejected', label: '未通过' },
]

const STATUS_LABELS: Record<KnowledgeStatus, string> = {
  pending: '待审核',
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
const status = ref<'' | KnowledgeStatus>('pending')
const category = ref<'' | KnowledgeCategory>('')
const searchInput = ref('')
const query = ref('')
const resolvingId = ref<number | null>(null)
const notes = reactive<Record<number, string>>({})

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
    data.value = await fetchAdminKnowledgeArticles({
      status: status.value || undefined,
      category: category.value || undefined,
      q: query.value || undefined,
      page,
      size: 20,
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

const applySearch = (): void => {
  query.value = searchInput.value.trim()
  void load(1)
}

const resolve = async (
  id: number,
  decision: 'approved' | 'rejected',
): Promise<void> => {
  if (resolvingId.value !== null) return
  resolvingId.value = id
  error.value = ''
  try {
    const result = await resolveAdminKnowledgeArticle(id, decision, notes[id] ?? '')
    toast.success(result.message)
    delete notes[id]
    await load()
  } catch (exception: unknown) {
    error.value = toErrorMessage(exception)
  } finally {
    resolvingId.value = null
  }
}

onMounted(() => {
  void load(1)
})
</script>

<template>
  <NavBar />
  <main class="teaching-page page-shell">
    <header class="teaching-page-header">
      <div>
        <h1>408 与面经审核</h1>
      </div>
      <button class="forum-secondary-button" type="button" :disabled="loading" @click="load()">
        刷新
      </button>
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

    <form class="knowledge-toolbar" role="search" @submit.prevent="applySearch">
      <input
        v-model="searchInput"
        type="search"
        maxlength="100"
        placeholder="搜索标题或摘要"
        aria-label="搜索标题或摘要"
      />
      <button class="forum-secondary-button" type="submit">搜索</button>
    </form>

    <p v-if="error" class="form-error" role="alert">{{ error }}</p>

    <section class="teaching-panel">
      <div v-if="loading" class="empty-state"><p>正在加载投稿</p></div>
      <div v-else-if="!data?.items.length" class="empty-state"><p>没有符合条件的投稿</p></div>
      <div v-else class="contest-admin-table-wrap">
        <table class="contest-detail-table contest-admin-table">
          <thead>
            <tr>
              <th scope="col">标题</th>
              <th scope="col">栏目</th>
              <th scope="col">作者</th>
              <th scope="col">状态</th>
              <th scope="col">处理</th>
            </tr>
          </thead>
          <tbody>
            <tr v-for="item in data.items" :key="item.id">
              <td>
                <RouterLink :to="`/knowledge/${item.id}`" target="_blank">
                  {{ item.title }}
                </RouterLink>
                <div class="teaching-subtle">{{ formatDateTime(item.created_at) }}</div>
              </td>
              <td>{{ item.category === '408' ? '408' : '面经' }}</td>
              <td>{{ item.author ?? '已注销用户' }}</td>
              <td>
                <span class="forum-tag" :class="STATUS_CLASSES[item.status]">
                  {{ STATUS_LABELS[item.status] }}
                </span>
              </td>
              <td>
                <div class="contest-admin-actions">
                  <input
                    v-model="notes[item.id]"
                    type="text"
                    maxlength="500"
                    placeholder="处理说明（可选）"
                  />
                  <button
                    v-if="item.status !== 'approved'"
                    class="primary-button"
                    type="button"
                    :disabled="resolvingId === item.id"
                    @click="resolve(item.id, 'approved')"
                  >
                    通过
                  </button>
                  <button
                    v-if="item.status !== 'rejected'"
                    class="forum-secondary-button"
                    type="button"
                    :disabled="resolvingId === item.id"
                    @click="resolve(item.id, 'rejected')"
                  >
                    {{ item.status === 'approved' ? '下架' : '退回' }}
                  </button>
                </div>
              </td>
            </tr>
          </tbody>
        </table>
      </div>
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
