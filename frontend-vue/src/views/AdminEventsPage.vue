<script setup lang="ts">
import { computed, onMounted, reactive, ref } from 'vue'
import NavBar from '../components/NavBar.vue'
import {
  createAdminEvent,
  downloadAdminEventResults,
  fetchAdminEvents,
  syncAdminEventForum,
  updateAdminEvent,
} from '../api/adminEvents'
import { toErrorMessage } from '../api/client'
import { toast } from '../store/toast'
import { fetchProblems } from '../api/problems'
import type {
  AdminEventInput,
  AdminEventView,
  ContestEventType,
  EventRuleGroup,
} from '../types/contest'
import type { Problem } from '../types/oj'
import { formatDateTime } from '../utils/teaching'

const TYPE_OPTIONS: Array<{ value: ContestEventType; label: string }> = [
  { value: 'official', label: '官方' },
  { value: 'teacher', label: '老师' },
  { value: 'school', label: '学校' },
]

const STATUS_OPTIONS: Array<{ value: AdminEventView['status']; label: string }> = [
  { value: 'draft', label: '草稿' },
  { value: 'published', label: '已发布' },
  { value: 'cancelled', label: '已取消' },
]

const MODE_OPTIONS = [
  { value: 'open', label: '公开报名' },
  { value: 'invite', label: '邀请后加入' },
  { value: 'external', label: '外部链接报名' },
] as const

interface EventForm {
  id: number | null
  title: string
  organizer: string
  description: string
  type: ContestEventType
  scope: string
  gradeScope: string
  capacity: string
  registration_mode: 'open' | 'invite' | 'external'
  class_id: string
  registration_url: string
  registration_opens_at: string
  registration_closes_at: string
  starts_at: string
  ends_at: string
  status: AdminEventView['status']
  ruleGroups: EventRuleGroup[]
  problemIds: number[]
}

const events = ref<AdminEventView[]>([])
const loading = ref(true)
const error = ref('')
const forumError = ref('')
const syncingId = ref<number | null>(null)
const exportingId = ref<number | null>(null)
const saving = ref(false)

const formOpen = ref(false)
const formError = ref('')
const form = reactive<EventForm>(emptyForm())
const formHasContest = ref(false)

const problems = ref<Problem[]>([])
const problemsLoading = ref(false)
const problemsError = ref('')
const problemSearch = ref('')

function emptyForm(): EventForm {
  return {
    id: null,
    title: '',
    organizer: '',
    description: '',
    type: 'official',
    scope: '',
    gradeScope: '',
    capacity: '',
    registration_mode: 'open',
    class_id: '',
    registration_url: '',
    registration_opens_at: '',
    registration_closes_at: '',
    starts_at: '',
    ends_at: '',
    status: 'draft',
    ruleGroups: [{ title: '参赛说明', items: ['独立完成，按时提交'] }],
    problemIds: [],
  }
}

const pad = (value: number): string => String(value).padStart(2, '0')

const toLocalInput = (value: string | null): string => {
  if (!value) return ''
  const date = new Date(value)
  if (!Number.isFinite(date.getTime())) return ''
  return `${date.getFullYear()}-${pad(date.getMonth() + 1)}-${pad(date.getDate())}T${pad(date.getHours())}:${pad(date.getMinutes())}`
}

const fromLocalInput = (value: string): string | null => {
  if (!value) return null
  const date = new Date(value)
  return Number.isFinite(date.getTime()) ? date.toISOString() : null
}

const problemTitle = (id: number): string =>
  problems.value.find((problem) => problem.id === id)?.title ?? `题目 #${id}`

const filteredProblems = computed(() => {
  const keyword = problemSearch.value.trim().toLowerCase()
  if (!keyword) return problems.value.slice(0, 40)
  return problems.value
    .filter(
      (problem) =>
        problem.title.toLowerCase().includes(keyword) ||
        String(problem.id) === keyword ||
        problem.tags.some((tag) => tag.toLowerCase().includes(keyword)),
    )
    .slice(0, 40)
})

const hasContest = computed(() => formHasContest.value)

const loadEvents = async (): Promise<void> => {
  loading.value = true
  error.value = ''
  try {
    events.value = await fetchAdminEvents()
  } catch (exception: unknown) {
    error.value = toErrorMessage(exception)
  } finally {
    loading.value = false
  }
}

const loadProblems = async (): Promise<void> => {
  if (problems.value.length || problemsLoading.value) return
  problemsLoading.value = true
  problemsError.value = ''
  try {
    const result = await fetchProblems({
      page: 1,
      size: 100,
      sort: 'id',
      order: 'asc',
    })
    problems.value = result.problems
  } catch (exception: unknown) {
    problemsError.value = toErrorMessage(exception)
  } finally {
    problemsLoading.value = false
  }
}

const openCreate = (): void => {
  Object.assign(form, emptyForm())
  formHasContest.value = false
  formError.value = ''
  formOpen.value = true
  void loadProblems()
}

const openEdit = (event: AdminEventView): void => {
  Object.assign(form, {
    id: event.id,
    title: event.title,
    organizer: event.organizer,
    description: event.description ?? '',
    type: event.type,
    scope: event.scope ?? '',
    gradeScope: event.grade_scope.join(', '),
    capacity: event.capacity === null ? '' : String(event.capacity),
    registration_mode: event.registration_mode,
    class_id: event.class_id === null ? '' : String(event.class_id),
    registration_url: event.registration_url ?? '',
    registration_opens_at: toLocalInput(event.registration_opens_at),
    registration_closes_at: toLocalInput(event.registration_deadline),
    starts_at: toLocalInput(event.starts_at),
    ends_at: toLocalInput(event.ends_at),
    status: event.status,
    ruleGroups: event.rules.map((group) => ({ ...group, items: [...group.items] })),
    problemIds: [...event.problem_ids],
  } satisfies EventForm)
  formHasContest.value = event.contest_id !== null
  formError.value = ''
  formOpen.value = true
  void loadProblems()
}

const closeForm = (): void => {
  formOpen.value = false
  formError.value = ''
}

const addGroup = (): void => {
  form.ruleGroups.push({ title: '', items: [''] })
}

const removeGroup = (index: number): void => {
  form.ruleGroups.splice(index, 1)
}

const addRuleItem = (group: EventRuleGroup): void => {
  group.items.push('')
}

const removeRuleItem = (group: EventRuleGroup, index: number): void => {
  group.items.splice(index, 1)
}

const toggleProblem = (problemId: number): void => {
  const index = form.problemIds.indexOf(problemId)
  if (index >= 0) {
    form.problemIds.splice(index, 1)
  } else {
    form.problemIds.push(problemId)
  }
}

const removeProblem = (problemId: number): void => {
  const index = form.problemIds.indexOf(problemId)
  if (index >= 0) form.problemIds.splice(index, 1)
}

const moveProblem = (index: number, direction: -1 | 1): void => {
  const target = index + direction
  if (target < 0 || target >= form.problemIds.length) return
  const [item] = form.problemIds.splice(index, 1)
  form.problemIds.splice(target, 0, item)
}

const buildPayload = (): AdminEventInput | null => {
  if (!form.title.trim() || !form.organizer.trim()) {
    formError.value = '请填写赛事标题和主办方'
    return null
  }
  const startsAt = fromLocalInput(form.starts_at)
  const endsAt = fromLocalInput(form.ends_at)
  if (!startsAt || !endsAt) {
    formError.value = '请填写完整的开始和结束时间'
    return null
  }
  if (new Date(endsAt) <= new Date(startsAt)) {
    formError.value = '结束时间必须晚于开始时间'
    return null
  }
  const rules = form.ruleGroups
    .map((group) => ({
      title: group.title.trim(),
      items: group.items.map((item) => item.trim()).filter(Boolean),
    }))
    .filter((group) => group.title)
  return {
    title: form.title.trim(),
    organizer: form.organizer.trim(),
    description: form.description.trim() || null,
    type: form.type,
    scope: form.scope.trim() || null,
    grade_scope: form.gradeScope
      .split(/[,，、]/)
      .map((item) => item.trim())
      .filter(Boolean),
    capacity: form.capacity.trim() ? Number(form.capacity) : null,
    registration_mode: form.registration_mode,
    class_id: form.class_id.trim() ? Number(form.class_id) : null,
    registration_url: form.registration_url.trim() || null,
    registration_opens_at: fromLocalInput(form.registration_opens_at),
    registration_closes_at: fromLocalInput(form.registration_closes_at),
    starts_at: startsAt,
    ends_at: endsAt,
    status: form.status,
    rules,
    problem_ids: form.problemIds,
  }
}

const syncForum = async (event: AdminEventView): Promise<void> => {
  if (syncingId.value !== null) return
  syncingId.value = event.id
  forumError.value = ''
  try {
    const result = await syncAdminEventForum(event.id)
    events.value = events.value.map((item) =>
      item.id === event.id ? { ...item, forum_post_id: result.forum_post_id } : item,
    )
    toast.success(result.message)
  } catch (exception: unknown) {
    forumError.value = toErrorMessage(exception)
  } finally {
    syncingId.value = null
  }
}

const exportResults = async (event: AdminEventView): Promise<void> => {
  if (exportingId.value !== null) return
  exportingId.value = event.id
  forumError.value = ''
  try {
    await downloadAdminEventResults(event.id)
  } catch (exception: unknown) {
    forumError.value = toErrorMessage(exception)
  } finally {
    exportingId.value = null
  }
}

const save = async (): Promise<void> => {
  if (saving.value) return
  const payload = buildPayload()
  if (!payload) return
  saving.value = true
  formError.value = ''
  try {
    if (form.id === null) {
      await createAdminEvent(payload)
      toast.success('赛事已创建')
    } else {
      await updateAdminEvent(form.id, payload)
      toast.success('赛事已更新')
    }
    formOpen.value = false
    await loadEvents()
  } catch (exception: unknown) {
    formError.value = toErrorMessage(exception)
  } finally {
    saving.value = false
  }
}

onMounted(() => {
  void loadEvents()
})
</script>

<template>
  <NavBar />
  <main class="teaching-page page-shell contests-page">
    <header class="teaching-page-header">
      <div>
        <RouterLink class="teaching-breadcrumb" :to="{ name: 'contests' }">竞赛首页</RouterLink>
        <h1>赛事管理</h1>
        <p class="teaching-subtle">创建官方、老师和学校赛事，配置规则与题目</p>
      </div>
      <div class="teaching-toolbar">
        <RouterLink class="forum-secondary-button" :to="{ name: 'admin-seasons' }">
          赛季管理
        </RouterLink>
        <RouterLink class="forum-secondary-button" :to="{ name: 'admin-contest-appeals' }">
          赛事申诉
        </RouterLink>
        <button class="primary-button" type="button" @click="openCreate">新建赛事</button>
      </div>
    </header>

    <p v-if="forumError" class="form-error" role="alert">{{ forumError }}</p>
    <p v-if="error" class="form-error" role="alert">{{ error }}</p>

    <section v-if="formOpen" class="teaching-panel contest-admin-form" aria-label="赛事表单">
      <div class="section-heading">
        <h2>{{ form.id === null ? '新建赛事' : `编辑赛事 #${form.id}` }}</h2>
        <button class="forum-secondary-button" type="button" @click="closeForm">关闭</button>
      </div>

      <p v-if="hasContest" class="teaching-subtle">
        该赛事已生成比赛，开始/结束时间和题目已锁定，其余信息仍可修改
      </p>

      <div class="contest-admin-grid">
        <label class="contest-admin-field">
          <span>赛事标题</span>
          <input v-model="form.title" type="text" maxlength="200" />
        </label>
        <label class="contest-admin-field">
          <span>主办方</span>
          <input v-model="form.organizer" type="text" maxlength="100" />
        </label>
        <label class="contest-admin-field">
          <span>赛事类型</span>
          <select v-model="form.type">
            <option v-for="option in TYPE_OPTIONS" :key="option.value" :value="option.value">
              {{ option.label }}
            </option>
          </select>
        </label>
        <label class="contest-admin-field">
          <span>发布状态</span>
          <select v-model="form.status">
            <option v-for="option in STATUS_OPTIONS" :key="option.value" :value="option.value">
              {{ option.label }}
            </option>
          </select>
        </label>
        <label class="contest-admin-field">
          <span>参会范围说明</span>
          <input v-model="form.scope" type="text" maxlength="200" placeholder="面向全体学生" />
        </label>
        <label class="contest-admin-field">
          <span>限定年级</span>
          <input
            v-model="form.gradeScope"
            type="text"
            maxlength="300"
            placeholder="用逗号分隔，留空表示不限"
          />
        </label>
        <label class="contest-admin-field">
          <span>名额上限</span>
          <input v-model="form.capacity" type="number" min="1" placeholder="留空表示不限" />
        </label>
        <label class="contest-admin-field">
          <span>报名方式</span>
          <select v-model="form.registration_mode">
            <option v-for="option in MODE_OPTIONS" :key="option.value" :value="option.value">
              {{ option.label }}
            </option>
          </select>
        </label>
        <label class="contest-admin-field">
          <span>限定组织编号</span>
          <input v-model="form.class_id" type="number" min="1" placeholder="留空表示不限" />
        </label>
        <label class="contest-admin-field">
          <span>外部报名链接</span>
          <input v-model="form.registration_url" type="url" maxlength="500" />
        </label>
        <label class="contest-admin-field">
          <span>报名开始</span>
          <input v-model="form.registration_opens_at" type="datetime-local" />
        </label>
        <label class="contest-admin-field">
          <span>报名截止</span>
          <input v-model="form.registration_closes_at" type="datetime-local" />
        </label>
        <label class="contest-admin-field">
          <span>赛事开始</span>
          <input v-model="form.starts_at" type="datetime-local" :disabled="hasContest" />
        </label>
        <label class="contest-admin-field">
          <span>赛事结束</span>
          <input v-model="form.ends_at" type="datetime-local" :disabled="hasContest" />
        </label>
      </div>

      <label class="contest-admin-field">
        <span>赛事说明</span>
        <textarea v-model="form.description" rows="3" maxlength="5000"></textarea>
      </label>

      <section class="contest-admin-section">
        <div class="section-heading">
          <h3>赛事规则</h3>
          <button class="forum-secondary-button" type="button" @click="addGroup">添加分组</button>
        </div>
        <div v-for="(group, groupIndex) in form.ruleGroups" :key="groupIndex" class="contest-admin-rule-group">
          <div class="contest-admin-rule-head">
            <input v-model="group.title" type="text" maxlength="100" placeholder="分组标题" />
            <button class="contest-follow-button" type="button" @click="removeGroup(groupIndex)">
              删除分组
            </button>
          </div>
          <div
            v-for="itemIndex in group.items.length"
            :key="itemIndex"
            class="contest-admin-rule-item"
          >
            <input v-model="group.items[itemIndex - 1]" type="text" maxlength="500" />
            <button
              class="contest-follow-button"
              type="button"
              @click="removeRuleItem(group, itemIndex - 1)"
            >
              删除
            </button>
          </div>
          <button class="forum-secondary-button" type="button" @click="addRuleItem(group)">
            添加规则
          </button>
        </div>
      </section>

      <section class="contest-admin-section">
        <div class="section-heading">
          <h3>赛事题目</h3>
          <span class="teaching-subtle">{{ form.problemIds.length }} 道</span>
        </div>
        <ol v-if="form.problemIds.length" class="contest-admin-selected">
          <li v-for="(problemId, index) in form.problemIds" :key="problemId">
            <span>{{ problemTitle(problemId) }}</span>
            <span class="contest-admin-selected-actions">
              <button
                class="contest-follow-button"
                type="button"
                :disabled="hasContest || index === 0"
                @click="moveProblem(index, -1)"
              >
                上移
              </button>
              <button
                class="contest-follow-button"
                type="button"
                :disabled="hasContest || index === form.problemIds.length - 1"
                @click="moveProblem(index, 1)"
              >
                下移
              </button>
              <button
                class="contest-follow-button"
                type="button"
                :disabled="hasContest"
                @click="removeProblem(problemId)"
              >
                移除
              </button>
            </span>
          </li>
        </ol>
        <p v-else class="teaching-subtle">尚未选择题目，学生进入赛事时将提示未配置题目</p>

        <input
          v-model="problemSearch"
          type="search"
          class="contest-admin-search"
          placeholder="按题号、标题或标签筛选"
        />
        <p v-if="problemsError" class="form-error" role="alert">{{ problemsError }}</p>
        <p v-else-if="problemsLoading" class="teaching-subtle">正在加载题目</p>
        <div v-else class="contest-admin-problems">
          <label v-for="problem in filteredProblems" :key="problem.id" class="contest-admin-problem">
            <input
              type="checkbox"
              :checked="form.problemIds.includes(problem.id)"
              :disabled="hasContest"
              @change="toggleProblem(problem.id)"
            />
            <span>#{{ problem.id }} {{ problem.title }}</span>
            <small>{{ problem.tags.slice(0, 3).join(' · ') }}</small>
          </label>
        </div>
      </section>

      <p v-if="formError" class="form-error" role="alert">{{ formError }}</p>
      <div class="teaching-toolbar">
        <button class="primary-button" type="button" :disabled="saving" @click="save">
          {{ saving ? '正在保存' : '保存赛事' }}
        </button>
        <button class="forum-secondary-button" type="button" @click="closeForm">取消</button>
      </div>
    </section>

    <section class="teaching-panel">
      <div v-if="loading" class="empty-state"><p>正在加载赛事</p></div>
      <div v-else-if="!events.length" class="empty-state"><p>还没有创建赛事</p></div>
      <div v-else class="contest-admin-table-wrap">
        <table class="contest-detail-table contest-admin-table">
          <thead>
            <tr>
              <th scope="col">赛事</th>
              <th scope="col">类型</th>
              <th scope="col">状态</th>
              <th scope="col">时间</th>
              <th scope="col">报名</th>
              <th scope="col">操作</th>
            </tr>
          </thead>
          <tbody>
            <tr v-for="event in events" :key="event.id">
              <td>
                <strong>{{ event.title }}</strong>
                <div class="teaching-subtle">{{ event.organizer }}</div>
              </td>
              <td>{{ TYPE_OPTIONS.find((option) => option.value === event.type)?.label }}</td>
              <td>{{ STATUS_OPTIONS.find((option) => option.value === event.status)?.label }}</td>
              <td>
                {{ formatDateTime(event.starts_at) }}
                <div class="teaching-subtle">至 {{ formatDateTime(event.ends_at) }}</div>
              </td>
              <td>
                {{ event.registered_count }}
                <div v-if="event.grade_scope.length" class="teaching-subtle">
                  {{ event.grade_scope.join('、') }}
                </div>
              </td>
              <td>
                <div class="contest-admin-actions">
                  <button class="forum-secondary-button" type="button" @click="openEdit(event)">
                    编辑
                  </button>
                  <RouterLink
                    v-if="event.contest_id"
                    class="forum-secondary-button"
                    :to="`/contests/${event.contest_id}/proctor`"
                  >
                    粘贴复核
                  </RouterLink>
                  <button
                    v-if="event.contest_id"
                    class="forum-secondary-button"
                    type="button"
                    :disabled="exportingId === event.id"
                    @click="exportResults(event)"
                  >
                    {{ exportingId === event.id ? '导出中' : '导出成绩' }}
                  </button>
                  <RouterLink
                    v-if="event.forum_post_id"
                    class="forum-secondary-button"
                    :to="`/forum/${event.forum_post_id}`"
                  >
                    查看公告
                  </RouterLink>
                  <button
                    v-else-if="event.status === 'published'"
                    class="forum-secondary-button"
                    type="button"
                    :disabled="syncingId === event.id"
                    @click="syncForum(event)"
                  >
                    {{ syncingId === event.id ? '同步中' : '同步校园墙' }}
                  </button>
                </div>
              </td>
            </tr>
          </tbody>
        </table>
      </div>
    </section>
  </main>
</template>
