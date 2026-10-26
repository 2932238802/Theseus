<script setup lang="ts">
import { computed, onMounted, reactive, ref } from 'vue'
import { useRoute, useRouter } from 'vue-router'
import NavBar from '../components/NavBar.vue'
import MarkdownBody from '../components/MarkdownBody.vue'
import { toErrorMessage } from '../api/client'
import { fetchClass } from '../api/classes'
import { fetchProblems } from '../api/problems'
import { useAssignmentStore } from '../store/assignments'
import type { Problem } from '../types/oj'
import type { AssignmentProblemInput } from '../types/teaching'
import {
  DIFFICULTY_LABELS,
} from '../utils/constants'
import {
  formatDateInput,
  formatDateTime,
  toIsoString,
} from '../utils/teaching'

const route = useRoute()
const router = useRouter()
const assignmentStore = useAssignmentStore()
const isEdit = computed(() => route.name === 'assignment-edit')
const assignmentId = computed(() => Number(route.params.id))
const classId = computed(() => Number(route.params.id))

const form = reactive({
  title: '',
  description: '',
  startAt: '',
  dueAt: '',
})
const selected = ref<AssignmentProblemInput[]>([])
const className = ref('')
const status = ref<'draft' | 'published' | 'archived'>('draft')
const isPublished = computed(() => status.value === 'published')
const isArchived = computed(() => status.value === 'archived')
const isLoading = ref(true)
const loadError = ref('')
const formError = ref('')
const isSaving = ref(false)
const showPreview = ref(false)

const problemKeyword = ref('')
const problemResults = ref<Problem[]>([])
const problemLoading = ref(false)
const problemError = ref('')

const totalPoints = computed(() =>
  selected.value.reduce((sum, problem) => sum + (Number(problem.points) || 0), 0),
)
const selectedIds = computed(() => new Set(selected.value.map((problem) => problem.problemId)))

const fillForm = (detail: {
  title: string
  description?: string
  startAt?: string
  dueAt?: string
  status: 'draft' | 'published' | 'archived'
  className: string
  problems: Array<{ problemId: number; points: number }>
}): void => {
  form.title = detail.title
  form.description = detail.description ?? ''
  form.startAt = formatDateInput(detail.startAt)
  form.dueAt = formatDateInput(detail.dueAt)
  status.value = detail.status
  className.value = detail.className
  selected.value = isEdit.value
    ? detail.problems.map((problem) => ({ problemId: problem.problemId, points: problem.points }))
    : []
}

const load = async (): Promise<void> => {
  isLoading.value = true
  loadError.value = ''
  formError.value = ''
  try {
    if (isEdit.value) {
      await assignmentStore.loadAssignment(assignmentId.value)
      if (assignmentStore.error) throw new Error(assignmentStore.error)
      const detail = assignmentStore.current
      if (!detail) throw new Error('作业不存在')
      fillForm(detail)
      if (detail.isOwner === false) throw new Error('作业不存在')
    } else {
      const detail = await fetchClass(classId.value)
      className.value = detail.name
      if (detail.relation !== 'owner') throw new Error('班级不存在')
    }
    await searchProblems()
  } catch (exception: unknown) {
    loadError.value = toErrorMessage(exception)
  } finally {
    isLoading.value = false
  }
}

const searchProblems = async (): Promise<void> => {
  problemLoading.value = true
  problemError.value = ''
  try {
    const result = await fetchProblems({
      page: 1,
      size: 20,
      search: problemKeyword.value.trim() || undefined,
      sort: 'id',
      order: 'asc',
    })
    problemResults.value = result.problems.filter((problem) => Boolean(problem.runConfig))
  } catch (exception: unknown) {
    problemError.value = toErrorMessage(exception)
  } finally {
    problemLoading.value = false
  }
}

const addProblem = (problem: Problem): void => {
  formError.value = ''
  if (selectedIds.value.has(problem.id)) return
  if (selected.value.length >= 50) {
    formError.value = '每份作业最多 50 道题'
    return
  }
  selected.value.push({ problemId: problem.id, points: 100 })
}

const removeProblem = (problemId: number): void => {
  selected.value = selected.value.filter((problem) => problem.problemId !== problemId)
}

const moveProblem = (index: number, delta: number): void => {
  const next = index + delta
  if (next < 0 || next >= selected.value.length) return
  const items = [...selected.value]
  const [item] = items.splice(index, 1)
  items.splice(next, 0, item)
  selected.value = items
}

const normalizePoints = (): void => {
  for (const problem of selected.value) {
    const points = Number(problem.points)
    problem.points = Number.isFinite(points) ? Math.min(1000, Math.max(1, Math.round(points))) : 1
  }
}

const save = async (): Promise<void> => {
  if (isSaving.value) return
  formError.value = ''
  if (!form.title.trim()) {
    formError.value = '作业标题不能为空'
    return
  }
  if (selected.value.length > 50) {
    formError.value = '每份作业最多 50 道题'
    return
  }
  normalizePoints()
  isSaving.value = true
  try {
    if (!isEdit.value) {
      const created = await assignmentStore.create(classId.value, {
        title: form.title.trim(),
        description: form.description.trim(),
        startAt: toIsoString(form.startAt),
        dueAt: toIsoString(form.dueAt),
        problems: selected.value,
      })
      await router.push(`/assignments/${created.id}`)
      return
    }
    if (isPublished.value || isArchived.value) {
      await assignmentStore.update(assignmentId.value, {
        title: form.title.trim(),
        description: form.description.trim(),
        dueAt: toIsoString(form.dueAt),
      })
    } else {
      await assignmentStore.update(assignmentId.value, {
        title: form.title.trim(),
        description: form.description.trim(),
        startAt: toIsoString(form.startAt),
        dueAt: toIsoString(form.dueAt),
        problems: selected.value,
      })
    }
    await router.push(`/assignments/${assignmentId.value}`)
  } catch (exception: unknown) {
    formError.value = toErrorMessage(exception)
  } finally {
    isSaving.value = false
  }
}

const problemStatus = (problem: Problem): string => {
  const labels = [`#${problem.id}`, DIFFICULTY_LABELS[problem.difficulty]]
  return labels.join(' · ')
}

onMounted(load)
</script>

<template>
  <NavBar />
  <main class="teaching-page page-shell">
    <header class="teaching-page-header">
      <div>
        <p class="teaching-breadcrumb">
          <RouterLink to="/classes">班级</RouterLink><span>/</span>
          <RouterLink v-if="className" :to="`/classes/${isEdit ? assignmentStore.current?.classId : classId}`">{{ className }}</RouterLink>
          <span v-if="className">/</span><span>{{ isEdit ? '编辑作业' : '创建作业' }}</span>
        </p>
        <h1>{{ isEdit ? '编辑作业' : '创建作业' }}</h1>
      </div>
    </header>

    <p v-if="isLoading" class="empty-state"><span>正在加载</span></p>
    <div v-else-if="loadError" class="empty-state">
      <p>{{ loadError }}</p>
      <RouterLink class="primary-button" to="/classes">返回班级</RouterLink>
    </div>

    <template v-else>
      <p v-if="isArchived" class="teaching-subtle">作业已归档 只能查看</p>
      <p v-else-if="isPublished" class="teaching-subtle">
        已发布：可以修改标题 描述和截止时间 不能修改题目
      </p>

      <form class="teaching-form" @submit.prevent="save">
        <section class="teaching-panel">
          <label>
            <span>标题</span>
            <input v-model="form.title" maxlength="200" required />
          </label>
          <label>
            <span>描述</span>
            <textarea v-model="form.description" rows="8" maxlength="20000"></textarea>
          </label>
          <div class="teaching-form-actions">
            <button type="button" class="teaching-link-button" @click="showPreview = !showPreview">
              {{ showPreview ? '收起预览' : '预览' }}
            </button>
          </div>
          <div v-if="showPreview && form.description.trim()" class="teaching-preview">
            <MarkdownBody :content="form.description" />
          </div>
        </section>

        <section class="teaching-panel">
          <div class="teaching-form-grid">
            <label>
              <span>开始时间</span>
              <input
                v-model="form.startAt"
                type="datetime-local"
                :disabled="isPublished || isArchived"
              />
            </label>
            <label>
              <span>截止时间</span>
              <input v-model="form.dueAt" type="datetime-local" :disabled="isArchived" />
            </label>
          </div>
          <p v-if="isPublished && form.dueAt" class="teaching-subtle">
            原截止时间：{{ formatDateTime(assignmentStore.current?.dueAt) }}
          </p>
        </section>

        <section v-if="!isPublished && !isArchived" class="teaching-panel">
          <div class="section-heading">
            <h2>题目</h2>
            <span class="teaching-subtle">{{ selected.length }} / 50 · {{ totalPoints }} 分</span>
          </div>

          <div class="teaching-inline-form">
            <label>
              <span>搜索题目</span>
              <input
                v-model="problemKeyword"
                placeholder="题号或标题"
                @keydown.enter.prevent="searchProblems"
              />
            </label>
            <button type="button" class="teaching-secondary-button" :disabled="problemLoading" @click="searchProblems">
              {{ problemLoading ? '搜索中' : '搜索' }}
            </button>
          </div>
          <p v-if="problemError" class="form-error" role="alert">{{ problemError }}</p>

          <div class="teaching-problem-results">
            <article v-for="problem in problemResults" :key="problem.id">
              <div>
                <strong>{{ problem.title }}</strong>
                <span>{{ problemStatus(problem) }}</span>
              </div>
              <button
                type="button"
                :disabled="selectedIds.has(problem.id)"
                @click="addProblem(problem)"
              >
                {{ selectedIds.has(problem.id) ? '已添加' : '添加' }}
              </button>
            </article>
            <p v-if="!problemLoading && !problemResults.length" class="teaching-subtle">
              没有可评测的题目
            </p>
          </div>

          <div v-if="selected.length" class="teaching-selected-problems">
            <article v-for="(problem, index) in selected" :key="problem.problemId">
              <span>#{{ problem.problemId }}</span>
              <input v-model.number="problem.points" type="number" min="1" max="1000" aria-label="分值" />
              <div class="teaching-order-actions">
                <button type="button" :disabled="index === 0" aria-label="上移" @click="moveProblem(index, -1)">↑</button>
                <button type="button" :disabled="index === selected.length - 1" aria-label="下移" @click="moveProblem(index, 1)">↓</button>
                <button type="button" @click="removeProblem(problem.problemId)">移除</button>
              </div>
            </article>
          </div>
          <p v-else class="empty-state"><span>还没有题目</span></p>
        </section>

        <p v-if="formError" class="form-error" role="alert">{{ formError }}</p>
        <div class="teaching-form-actions">
          <RouterLink class="teaching-secondary-button" to="/classes">取消</RouterLink>
          <button class="primary-button" type="submit" :disabled="isSaving || isArchived">
            {{ isSaving ? '保存中' : '保存' }}
          </button>
        </div>
      </form>
    </template>
  </main>
</template>
