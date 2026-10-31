<script setup lang="ts">
import { computed, onMounted, ref } from 'vue'
import { RouterLink, useRoute, useRouter } from 'vue-router'
import MarkdownBody from '../components/MarkdownBody.vue'
import NavBar from '../components/NavBar.vue'
import { toErrorMessage } from '../api/client'
import { createKnowledgeArticle, fetchKnowledgeArticle, updateKnowledgeArticle } from '../api/knowledge'
import { toast } from '../store/toast'
import type { KnowledgeCategory } from '../types/knowledge'

const route = useRoute()
const router = useRouter()

const editId = computed(() => {
  const value = Number(route.params.id)
  return Number.isInteger(value) && value > 0 ? value : null
})
const isEdit = computed(() => editId.value !== null)
const category = ref<KnowledgeCategory>(
  route.query.category === 'interview' ? 'interview' : '408',
)
const title = ref('')
const summary = ref('')
const tagsInput = ref('')
const content = ref('')
const preview = ref(false)
const loading = ref(route.params.id !== undefined)
const submitting = ref(false)
const error = ref('')
const loadFailed = ref(false)

const categoryLabel = computed(() => (category.value === '408' ? '408 专区' : '面经'))
const listPath = computed(() =>
  category.value === 'interview' ? '/knowledge/interview' : '/knowledge/408',
)
const parsedTags = computed(() =>
  tagsInput.value
    .split(/[,，\n]/)
    .map((tag) => tag.trim())
    .filter(Boolean),
)
const canSubmit = computed(
  () =>
    title.value.trim().length > 0 &&
    title.value.trim().length <= 120 &&
    content.value.trim().length > 0 &&
    content.value.trim().length <= 20_000,
)

const loadEditTarget = async (): Promise<void> => {
  if (!editId.value) return
  loading.value = true
  error.value = ''
  loadFailed.value = false
  try {
    const article = await fetchKnowledgeArticle(editId.value)
    if (!article.can_edit) {
      error.value =
        article.status === 'approved'
          ? '审核通过后不能直接编辑，请联系管理员退回'
          : '只能编辑自己的投稿'
      loadFailed.value = true
      return
    }
    category.value = article.category
    title.value = article.title
    summary.value = article.summary
    tagsInput.value = article.tags.join('，')
    content.value = article.content ?? ''
  } catch (exception: unknown) {
    error.value = toErrorMessage(exception)
    loadFailed.value = true
  } finally {
    loading.value = false
  }
}

const submit = async (): Promise<void> => {
  if (submitting.value) return
  error.value = ''
  if (!canSubmit.value) {
    error.value = '请填写标题和正文'
    return
  }
  if (parsedTags.value.length > 8) {
    error.value = '标签不能超过 8 个'
    return
  }
  submitting.value = true
  try {
    const payload = {
      title: title.value.trim(),
      summary: summary.value.trim() || undefined,
      content: content.value.trim(),
      tags: parsedTags.value,
    }
    if (isEdit.value && editId.value) {
      const article = await updateKnowledgeArticle(editId.value, payload)
      toast.success('已重新提交审核')
      await router.push(`/knowledge/${article.id}`)
    } else {
      const article = await createKnowledgeArticle({ category: category.value, ...payload })
      toast.success('已提交审核')
      await router.push(`/knowledge/${article.id}`)
    }
  } catch (exception: unknown) {
    error.value = toErrorMessage(exception)
  } finally {
    submitting.value = false
  }
}

onMounted(() => {
  if (isEdit.value) void loadEditTarget()
})
</script>

<template>
  <NavBar />
  <main class="teaching-page page-shell knowledge-page">
    <header class="teaching-page-header">
      <div>
        <h1>{{ isEdit ? '编辑投稿' : '投稿' }}</h1>
      </div>
      <RouterLink class="forum-secondary-button" :to="listPath">取消</RouterLink>
    </header>

    <div v-if="loading" class="empty-state"><p>正在加载投稿</p></div>
    <p v-if="error" class="form-error" role="alert">{{ error }}</p>

    <template v-if="!loading && !loadFailed">
      <form class="teaching-form" @submit.prevent="submit">
        <div class="teaching-form-grid">
          <label>
            <span>栏目</span>
            <select v-if="!isEdit" v-model="category">
              <option value="408">408</option>
              <option value="interview">面经</option>
            </select>
            <span v-else class="knowledge-readonly-value">{{ categoryLabel }}</span>
          </label>
          <label>
            <span>标题</span>
            <input v-model="title" type="text" maxlength="120" placeholder="给这篇内容起个标题" />
          </label>
        </div>

        <label>
          <span>摘要</span>
          <input
            v-model="summary"
            type="text"
            maxlength="300"
            placeholder="留空时自动截取正文开头"
          />
        </label>

        <label>
          <span>标签</span>
          <input
            v-model="tagsInput"
            type="text"
            maxlength="200"
            placeholder="用逗号分隔 最多 8 个"
          />
        </label>

        <div class="knowledge-compose-tabs" role="tablist" aria-label="正文编辑方式">
          <button
            type="button"
            role="tab"
            :aria-selected="!preview"
            :class="{ 'is-active': !preview }"
            @click="preview = false"
          >
            编辑
          </button>
          <button
            type="button"
            role="tab"
            :aria-selected="preview"
            :class="{ 'is-active': preview }"
            @click="preview = true"
          >
            预览
          </button>
        </div>

        <textarea
          v-if="!preview"
          v-model="content"
          class="knowledge-editor"
          rows="18"
          maxlength="20000"
          placeholder="支持 Markdown"
        ></textarea>
        <div v-else class="knowledge-preview teaching-panel">
          <MarkdownBody v-if="content.trim()" :content="content" />
          <p v-else class="teaching-subtle">还没有正文</p>
        </div>

        <div class="teaching-form-actions">
          <span class="teaching-subtle">{{ content.trim().length }} / 20000</span>
          <button class="primary-button" type="submit" :disabled="submitting">
            {{ submitting ? '提交中…' : isEdit ? '重新提交审核' : '提交审核' }}
          </button>
        </div>
      </form>
    </template>
  </main>
</template>
