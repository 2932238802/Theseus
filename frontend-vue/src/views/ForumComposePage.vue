<script setup lang="ts">
import { computed, onBeforeUnmount, onMounted, ref, watch } from 'vue'
import { useRoute, useRouter } from 'vue-router'
import MarkdownBody from '../components/MarkdownBody.vue'
import NavBar from '../components/NavBar.vue'
import { toErrorMessage } from '../api/client'
import { createForumPost, fetchForumPost, updateForumPost } from '../api/forum'
import { fetchProblems } from '../api/problems'
import { fetchMyPlusState } from '../api/shop'
import { useAuthStore } from '../store/auth'
import { FORUM_BOARDS, FORUM_TAGS } from '../types/forum'
import type { ForumBoard } from '../types/forum'
import type { Difficulty, Problem } from '../types/oj'
import { DIFFICULTY_LABELS } from '../utils/constants'

const DRAFT_PREFIX = 'theseus-forum-draft'

const route = useRoute()
const router = useRouter()
const authStore = useAuthStore()

const editId = computed(() => {
  const raw = Array.isArray(route.query.edit) ? route.query.edit[0] : route.query.edit
  const value = Number(raw)
  return Number.isInteger(value) && value > 0 ? value : null
})
const isEdit = computed(() => editId.value !== null)
const isAdmin = computed(() => authStore.isAdmin)
const isPlus = ref(false)
const canInterview = computed(() => isAdmin.value || isPlus.value)
const draftKey = `${DRAFT_PREFIX}:${authStore.user?.id ?? 'guest'}`

const board = ref<ForumBoard>('general')
const interviewDate = ref('')
const company = ref('')
const role = ref('')
const isInterview = computed(() => board.value === 'interview')
const title = ref('')
const bodyMd = ref('')
const tags = ref<string[]>([])
const tagInput = ref('')
const anonymous = ref(false)
const selectedProblem = ref<Problem | null>(null)
const preview = ref(false)

const problemQuery = ref('')
const problemResults = ref<Problem[]>([])
const problemLoading = ref(false)
const problemError = ref('')

const loading = ref(false)
const submitting = ref(false)
const error = ref('')
const hasDraft = ref(false)
const loadFailed = ref(false)
let problemTimer: number | undefined
let problemSequence = 0
let draftEnabled = false

const availableTags = computed(() => FORUM_TAGS.filter((tag) => !tag.adminOnly || isAdmin.value))
const maxTags = computed(() => (isInterview.value ? 8 : 3))
const canSubmit = computed(
  () =>
    title.value.trim().length > 0 &&
    title.value.trim().length <= 120 &&
    bodyMd.value.trim().length > 0 &&
    bodyMd.value.trim().length <= 20_000 &&
    tags.value.length >= 1 &&
    tags.value.length <= maxTags.value &&
    (!isInterview.value || !interviewDate.value || /^\d{4}-\d{2}$/.test(interviewDate.value)),
)

const toggleTag = (code: string): void => {
  if (tags.value.includes(code)) {
    tags.value = tags.value.filter((tag) => tag !== code)
  } else if (tags.value.length < maxTags.value) {
    tags.value = [...tags.value, code]
  }
}

const addTag = (): void => {
  const candidates = tagInput.value
    .split(/[,，、]/)
    .map((tag) => tag.trim())
    .filter(Boolean)
  tagInput.value = ''
  for (const candidate of candidates) {
    if (tags.value.length >= 8) break
    const tag = candidate.slice(0, 20)
    if (!tags.value.includes(tag)) tags.value = [...tags.value, tag]
  }
}

const removeTag = (tag: string): void => {
  tags.value = tags.value.filter((item) => item !== tag)
}

const selectBoard = (next: ForumBoard): void => {
  if (next === board.value) return
  if (next === 'interview' && !canInterview.value) return
  board.value = next
  tags.value = []
  tagInput.value = ''
  if (next === 'general') {
    interviewDate.value = ''
    company.value = ''
    role.value = ''
  }
}

const searchProblems = async (): Promise<void> => {
  const keyword = problemQuery.value.trim()
  const requestId = ++problemSequence
  if (!keyword) {
    problemResults.value = []
    problemLoading.value = false
    return
  }
  problemLoading.value = true
  problemError.value = ''
  try {
    const result = await fetchProblems({
      page: 1,
      size: 10,
      search: keyword,
      sort: 'id',
      order: 'asc',
    })
    if (requestId !== problemSequence) return
    problemResults.value = result.problems
  } catch (exception: unknown) {
    if (requestId !== problemSequence) return
    problemError.value = toErrorMessage(exception)
    problemResults.value = []
  } finally {
    if (requestId === problemSequence) problemLoading.value = false
  }
}

const onProblemInput = (): void => {
  window.clearTimeout(problemTimer)
  problemTimer = window.setTimeout(searchProblems, 300)
}

const selectProblem = (problem: Problem): void => {
  problemSequence += 1
  selectedProblem.value = problem
  problemQuery.value = ''
  problemResults.value = []
}

const clearProblem = (): void => {
  problemSequence += 1
  selectedProblem.value = null
}

const saveDraft = (): void => {
  if (!draftEnabled || isEdit.value) return
  localStorage.setItem(
    draftKey,
    JSON.stringify({
      board: board.value,
      interviewDate: interviewDate.value,
      company: company.value,
      role: role.value,
      title: title.value,
      bodyMd: bodyMd.value,
      tags: tags.value,
      anonymous: anonymous.value,
      problem: selectedProblem.value
        ? {
            id: selectedProblem.value.id,
            title: selectedProblem.value.title,
            difficulty: selectedProblem.value.difficulty,
            acceptance: selectedProblem.value.acceptance,
            tags: selectedProblem.value.tags,
            status: selectedProblem.value.status,
            description: '',
            examples: [],
            codeTemplate: {},
            timeLimit: selectedProblem.value.timeLimit,
            memoryLimit: selectedProblem.value.memoryLimit,
            submitCount: selectedProblem.value.submitCount,
            acceptCount: selectedProblem.value.acceptCount,
          }
        : null,
    }),
  )
  hasDraft.value = true
}

const restoreDraft = (): void => {
  const raw = localStorage.getItem(draftKey)
  if (!raw) return
  try {
    const draft = JSON.parse(raw) as {
      board?: unknown
      interviewDate?: unknown
      company?: unknown
      role?: unknown
      title?: unknown
      bodyMd?: unknown
      tags?: unknown
      anonymous?: unknown
      problem?: unknown
    }
    if (draft.board === 'interview' && canInterview.value) board.value = 'interview'
    if (typeof draft.interviewDate === 'string') interviewDate.value = draft.interviewDate
    if (typeof draft.company === 'string') company.value = draft.company.slice(0, 40)
    if (typeof draft.role === 'string') role.value = draft.role.slice(0, 40)
    if (typeof draft.title === 'string') title.value = draft.title
    if (typeof draft.bodyMd === 'string') bodyMd.value = draft.bodyMd
    if (Array.isArray(draft.tags)) {
      const values = draft.tags.filter((tag): tag is string => typeof tag === 'string')
      tags.value =
        board.value === 'interview'
          ? values.slice(0, 8).map((tag) => tag.slice(0, 20))
          : values.filter((tag) => availableTags.value.some((item) => item.code === tag))
    }
    if (typeof draft.anonymous === 'boolean') anonymous.value = draft.anonymous
    if (draft.problem && typeof draft.problem === 'object') {
      selectedProblem.value = draft.problem as Problem
    }
    hasDraft.value = true
  } catch {
    localStorage.removeItem(draftKey)
    hasDraft.value = false
  }
}

const loadEditTarget = async (): Promise<void> => {
  if (!editId.value) return
  loading.value = true
  error.value = ''
  loadFailed.value = false
  try {
    const post = await fetchForumPost(editId.value)
    if (!post.canEdit) {
      error.value =
        post.status === 'hidden'
          ? '帖子已被隐藏 无法编辑'
          : '只有作者本人可以编辑已发布的帖子'
      loadFailed.value = true
      return
    }
    title.value = post.title
    bodyMd.value = post.bodyMd
    board.value = post.board
    interviewDate.value = post.interviewDate ?? ''
    company.value = post.company ?? ''
    role.value = post.role ?? ''
    tags.value = post.tags
    if (post.problem) {
      selectedProblem.value = {
        id: post.problem.id,
        number: post.problem.id,
        title: post.problem.title,
        difficulty: post.problem.difficulty as Difficulty,
        acceptance: 0,
        tags: [],
        status: 'not_started',
        description: '',
        examples: [],
        codeTemplate: {},
        timeLimit: 0,
        memoryLimit: 0,
        submitCount: 0,
        acceptCount: 0,
        favorited: false,
      }
    }
  } catch (exception: unknown) {
    error.value = toErrorMessage(exception)
    loadFailed.value = true
  } finally {
    loading.value = false
  }
}

const submit = async (): Promise<void> => {
  error.value = ''
  if (!canSubmit.value) {
    error.value =
      board.value === 'interview'
        ? '请填写标题 正文 并选择 1–8 个标签'
        : '请填写标题 正文 并选择 1–3 个标签'
    return
  }
  submitting.value = true
  try {
    const payload = {
      board: board.value,
      title: title.value.trim(),
      body_md: bodyMd.value.trim(),
      tags: tags.value,
      interview_date: isInterview.value ? interviewDate.value || null : null,
      company: isInterview.value ? company.value.trim() || null : null,
      role: isInterview.value ? role.value.trim() || null : null,
      problem_id: selectedProblem.value?.id ?? null,
    }
    if (isEdit.value && editId.value) {
      await updateForumPost(editId.value, payload)
      router.push(`/forum/${editId.value}`)
    } else {
      const created = await createForumPost(payload, anonymous.value)
      draftEnabled = false
      hasDraft.value = false
      localStorage.removeItem(draftKey)
      router.push(`/forum/${created.id}`)
    }
  } catch (exception: unknown) {
    error.value = toErrorMessage(exception)
    saveDraft()
  } finally {
    submitting.value = false
  }
}

watch([board, interviewDate, company, role, title, bodyMd, tags, anonymous, selectedProblem], saveDraft, {
  deep: true,
})

onMounted(async () => {
  if (isEdit.value) {
    await loadEditTarget()
    return
  }
  if (authStore.isAuthenticated && !authStore.isAdmin) {
    try {
      const state = await fetchMyPlusState()
      isPlus.value = state.is_plus
    } catch {
      isPlus.value = false
    }
  }
  const requested = Array.isArray(route.query.board) ? route.query.board[0] : route.query.board
  if (requested === 'interview') {
    if (canInterview.value) {
      board.value = 'interview'
    } else {
      error.value = '面经需要开通 Plus Theseus'
    }
  }
  restoreDraft()
  draftEnabled = true
})

onBeforeUnmount(() => {
  saveDraft()
  window.clearTimeout(problemTimer)
})
</script>

<template>
  <NavBar />
  <main class="forum-page forum-compose-page page-shell">
    <header class="forum-page-heading">
      <div>
        <h1>{{ isEdit ? '编辑帖子' : '发帖' }}</h1>
      </div>
      <RouterLink class="forum-secondary-button" :to="isEdit ? `/forum/${editId}` : '/forum'">取消</RouterLink>
    </header>

    <p v-if="loading" class="run-note">正在加载帖子</p>
    <p v-if="error" class="form-error" role="alert">{{ error }}</p>

    <form v-if="!loading && !loadFailed" class="forum-compose-form" @submit.prevent="submit">
      <fieldset v-if="!isEdit" class="forum-field forum-tag-picker">
        <legend>板块</legend>
        <div class="forum-tag-picker-options">
          <button
            v-for="item in FORUM_BOARDS"
            :key="item.code"
            type="button"
            :class="['forum-filter-pill', { active: board === item.code }]"
            :disabled="item.plusOnly && !canInterview"
            @click="selectBoard(item.code)"
          >
            {{ item.label }}<template v-if="item.plusOnly"> · VIP</template>
          </button>
        </div>
        <p v-if="!canInterview" class="run-note">面经仅对 Plus Theseus 开放</p>
      </fieldset>

      <label class="forum-field">
        <span>标题 <small>{{ title.trim().length }} / 120</small></span>
        <input
          v-model="title"
          type="text"
          maxlength="120"
          :placeholder="isInterview ? '公司 · 岗位 · 轮次' : '用一句话说明你想讨论什么'"
          required
        />
      </label>

      <label v-if="isInterview" class="forum-field">
        <span>面试时间 <small>可选</small></span>
        <input v-model="interviewDate" type="month" />
      </label>

      <div v-if="isInterview" class="forum-field-group">
        <label class="forum-field">
          <span>公司 <small>可选</small></span>
          <input v-model="company" type="text" maxlength="40" placeholder="如 百度" />
        </label>
        <label class="forum-field">
          <span>岗位 <small>可选</small></span>
          <input v-model="role" type="text" maxlength="40" placeholder="如 后端" />
        </label>
      </div>

      <fieldset v-if="!isInterview" class="forum-field forum-tag-picker">
        <legend>标签 <small>选择 1–3 个</small></legend>
        <div class="forum-tag-picker-options">
          <button
            v-for="tag in availableTags"
            :key="tag.code"
            type="button"
            :class="['forum-filter-pill', { active: tags.includes(tag.code) }]"
            @click="toggleTag(tag.code)"
          >
            {{ tag.label }}<template v-if="tag.adminOnly"> · 管理员</template>
          </button>
        </div>
      </fieldset>

      <div v-else class="forum-field">
        <span>标签 <small>{{ tags.length }} / 8</small></span>
        <div class="forum-tag-input">
          <input
            v-model="tagInput"
            type="text"
            maxlength="20"
            placeholder="公司 方向 等 回车添加"
            @keydown.enter.prevent="addTag"
          />
          <button type="button" class="forum-secondary-button" @click="addTag">添加</button>
        </div>
        <div v-if="tags.length" class="forum-tag-picker-options">
          <button
            v-for="tag in tags"
            :key="tag"
            type="button"
            class="forum-filter-pill active"
            @click="removeTag(tag)"
          >
            {{ tag }} ×
          </button>
        </div>
      </div>

      <div class="forum-field">
        <span>关联题目 <small>可选 最多 1 道</small></span>
        <div v-if="selectedProblem" class="forum-selected-problem">
          <span>#{{ selectedProblem.id }} {{ selectedProblem.title }}</span>
          <span :class="['difficulty', selectedProblem.difficulty]">{{ DIFFICULTY_LABELS[selectedProblem.difficulty] }}</span>
          <button type="button" class="clear-filter" @click="clearProblem">清除</button>
        </div>
        <template v-else>
          <input
            v-model="problemQuery"
            type="search"
            maxlength="100"
            placeholder="搜索已通过审核的题目"
            @input="onProblemInput"
          />
          <p v-if="problemLoading" class="run-note">正在搜索题目</p>
          <p v-if="problemError" class="form-error" role="alert">{{ problemError }}</p>
          <div v-if="problemResults.length" class="forum-problem-results">
            <button
              v-for="problem in problemResults"
              :key="problem.id"
              type="button"
              @click="selectProblem(problem)"
            >
              <span>#{{ problem.id }} {{ problem.title }}</span>
              <span :class="['difficulty', problem.difficulty]">{{ DIFFICULTY_LABELS[problem.difficulty] }}</span>
            </button>
          </div>
        </template>
      </div>

      <label v-if="!isEdit" class="forum-checkbox">
        <input v-model="anonymous" type="checkbox" />
        匿名发布（前台显示“匿名同学” 管理员仍可看到真实作者）
      </label>

      <div class="forum-editor">
        <div class="forum-editor-tabs" role="tablist">
          <button type="button" role="tab" :aria-selected="!preview" :class="{ active: !preview }" @click="preview = false">编辑</button>
          <button type="button" role="tab" :aria-selected="preview" :class="{ active: preview }" @click="preview = true">预览</button>
          <span>{{ bodyMd.trim().length }} / 20000</span>
        </div>
        <textarea
          v-if="!preview"
          v-model="bodyMd"
          rows="18"
          maxlength="20000"
          :placeholder="isInterview ? '写下这次面试的流程 题目和你的思路 答案可以留给评论区' : '写下你的想法 支持标题 列表 引用 代码块和链接'"
          required
        ></textarea>
        <div v-else class="forum-editor-preview">
          <MarkdownBody v-if="bodyMd.trim()" :content="bodyMd" />
          <p v-else class="run-note">还没有正文可预览</p>
        </div>
      </div>

      <p v-if="!isEdit && hasDraft" class="run-note">草稿会自动保存在本机</p>
      <div class="forum-compose-actions">
        <button type="button" class="forum-secondary-button" @click="preview = !preview">
          {{ preview ? '继续编辑' : '预览正文' }}
        </button>
        <button type="submit" class="primary-button" :disabled="submitting || !canSubmit">
          {{ submitting ? '提交中' : isEdit ? '保存修改' : '发布' }}
        </button>
      </div>
    </form>
  </main>
</template>
