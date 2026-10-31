<script setup lang="ts">
import { computed, onMounted, ref } from 'vue'
import { RouterLink, useRoute } from 'vue-router'
import MarkdownBody from '../components/MarkdownBody.vue'
import NavBar from '../components/NavBar.vue'
import { toErrorMessage } from '../api/client'
import { fetchKnowledgeArticle } from '../api/knowledge'
import type { KnowledgeArticleDetail, KnowledgeStatus } from '../types/knowledge'
import { formatDateTime } from '../utils/teaching'

const STATUS_LABELS: Record<KnowledgeStatus, string> = {
  pending: '审核中',
  approved: '已通过',
  rejected: '未通过',
}

const STATUS_CLASSES: Record<KnowledgeStatus, string> = {
  pending: 'status-pending',
  approved: 'status-published',
  rejected: 'status-rejected',
}

const route = useRoute()
const article = ref<KnowledgeArticleDetail | null>(null)
const loading = ref(true)
const error = ref('')

const articleId = computed(() => Number(route.params.id))
const categoryLabel = computed(() => (article.value?.category === '408' ? '408 专区' : '面经'))
const listPath = computed(() =>
  article.value?.category === 'interview' ? '/knowledge/interview' : '/knowledge/408',
)
const statusLabel = computed(() =>
  article.value ? STATUS_LABELS[article.value.status] : '',
)
const statusClass = computed(() =>
  article.value ? STATUS_CLASSES[article.value.status] : '',
)

const load = async (): Promise<void> => {
  loading.value = true
  error.value = ''
  try {
    article.value = await fetchKnowledgeArticle(articleId.value)
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
  <main class="teaching-page page-shell knowledge-page">
    <div v-if="loading" class="empty-state"><p>正在加载</p></div>

    <div v-else-if="error" class="contest-events-feedback">
      <p class="form-error" role="alert">{{ error }}</p>
      <RouterLink class="forum-secondary-button" to="/knowledge/408">返回 408 专区</RouterLink>
    </div>

    <template v-else-if="article">
      <RouterLink class="knowledge-back" :to="listPath">← {{ categoryLabel }}</RouterLink>

      <header class="knowledge-detail-header">
        <div class="knowledge-detail-title-row">
          <h1>{{ article.title }}</h1>
          <span class="forum-tag" :class="statusClass">{{ statusLabel }}</span>
        </div>
        <div class="knowledge-card-meta">
          <span>{{ article.author ?? '已注销用户' }}</span>
          <span>{{ formatDateTime(article.created_at) }}</span>
          <span v-if="article.updated_at !== article.created_at">
            更新于 {{ formatDateTime(article.updated_at) }}
          </span>
        </div>
        <div v-if="article.tags.length" class="forum-tag-row">
          <span v-for="tag in article.tags" :key="tag" class="forum-tag">{{ tag }}</span>
        </div>
      </header>

      <p v-if="article.summary" class="knowledge-detail-summary">{{ article.summary }}</p>

      <div v-if="article.status === 'pending'" class="knowledge-status-note">
        正在等待管理员审核
      </div>

      <section
        v-else-if="article.status === 'rejected'"
        class="teaching-panel knowledge-status-note is-rejected"
      >
        <strong>审核未通过</strong>
        <p>{{ article.review_note || '未填写审核说明' }}</p>
        <RouterLink v-if="article.can_edit" class="primary-button" :to="`/knowledge/${article.id}/edit`">
          修改并重新提交
        </RouterLink>
      </section>

      <section v-if="article.locked" class="teaching-panel knowledge-locked">
        <h2>正文需要 Plus Theseus</h2>
        <p>开通后可阅读 408 与面经的完整内容</p>
        <RouterLink class="primary-button" to="/shop">去开通</RouterLink>
      </section>

      <article v-else-if="article.content" class="knowledge-content teaching-panel">
        <MarkdownBody :content="article.content" />
      </article>

      <div
        v-if="article.can_edit && article.status === 'pending'"
        class="knowledge-detail-actions"
      >
        <RouterLink class="forum-secondary-button" :to="`/knowledge/${article.id}/edit`">
          编辑投稿
        </RouterLink>
      </div>
    </template>
  </main>
</template>
