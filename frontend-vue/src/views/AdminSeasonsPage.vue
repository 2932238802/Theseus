<script setup lang="ts">
import { onMounted, reactive, ref } from 'vue'
import NavBar from '../components/NavBar.vue'
import {
  createAdminSeason,
  fetchAdminSeasons,
  updateAdminSeason,
} from '../api/adminEvents'
import { toErrorMessage } from '../api/client'
import { toast } from '../store/toast'
import type { SeasonStatus, SeasonSummary } from '../types/contest'
import { formatDateTime } from '../utils/teaching'

const STATUS_OPTIONS: Array<{ value: SeasonStatus; label: string }> = [
  { value: 'draft', label: '草稿' },
  { value: 'published', label: '已发布' },
  { value: 'cancelled', label: '已取消' },
]

const STATE_LABELS: Record<SeasonSummary['state'], string> = {
  upcoming: '未开始',
  active: '进行中',
  finished: '已结束',
  cancelled: '已取消',
}

interface SeasonForm {
  id: number | null
  name: string
  starts_at: string
  ends_at: string
  soft_reset_ratio: string
  status: SeasonStatus
}

const seasons = ref<SeasonSummary[]>([])
const loading = ref(true)
const error = ref('')
const formOpen = ref(false)
const formError = ref('')
const saving = ref(false)
const form = reactive<SeasonForm>(emptyForm())

function emptyForm(): SeasonForm {
  return {
    id: null,
    name: '',
    starts_at: '',
    ends_at: '',
    soft_reset_ratio: '0.5',
    status: 'draft',
  }
}

const pad = (value: number): string => String(value).padStart(2, '0')

const toLocalInput = (value: string): string => {
  const date = new Date(value)
  if (!Number.isFinite(date.getTime())) return ''
  return `${date.getFullYear()}-${pad(date.getMonth() + 1)}-${pad(date.getDate())}T${pad(date.getHours())}:${pad(date.getMinutes())}`
}

const fromLocalInput = (value: string): string => {
  const date = new Date(value)
  if (!Number.isFinite(date.getTime())) return ''
  return date.toISOString()
}

const load = async (): Promise<void> => {
  loading.value = true
  error.value = ''
  try {
    seasons.value = await fetchAdminSeasons()
  } catch (exception: unknown) {
    error.value = toErrorMessage(exception)
  } finally {
    loading.value = false
  }
}

const openCreate = (): void => {
  Object.assign(form, emptyForm())
  formError.value = ''
  formOpen.value = true
}

const openEdit = (season: SeasonSummary): void => {
  Object.assign(form, {
    id: season.id,
    name: season.name,
    starts_at: toLocalInput(season.starts_at),
    ends_at: toLocalInput(season.ends_at),
    soft_reset_ratio: String(season.soft_reset_ratio),
    status: season.status,
  } satisfies SeasonForm)
  formError.value = ''
  formOpen.value = true
}

const save = async (): Promise<void> => {
  if (saving.value) return
  const name = form.name.trim()
  const startsAt = fromLocalInput(form.starts_at)
  const endsAt = fromLocalInput(form.ends_at)
  const ratio = Number(form.soft_reset_ratio)
  if (!name) {
    formError.value = '请填写赛季名称'
    return
  }
  if (!startsAt || !endsAt) {
    formError.value = '请填写完整的开始和结束时间'
    return
  }
  if (new Date(endsAt) <= new Date(startsAt)) {
    formError.value = '结束时间必须晚于开始时间'
    return
  }
  if (!Number.isFinite(ratio) || ratio < 0 || ratio > 1) {
    formError.value = '软重置系数必须在 0 到 1 之间'
    return
  }
  saving.value = true
  formError.value = ''
  try {
    const input = {
      name,
      starts_at: startsAt,
      ends_at: endsAt,
      soft_reset_ratio: ratio,
      status: form.status,
    }
    if (form.id === null) {
      await createAdminSeason(input)
      toast.success('赛季已创建')
    } else {
      await updateAdminSeason(form.id, input)
      toast.success('赛季已更新')
    }
    formOpen.value = false
    await load()
  } catch (exception: unknown) {
    formError.value = toErrorMessage(exception)
  } finally {
    saving.value = false
  }
}

onMounted(() => {
  void load()
})
</script>

<template>
  <NavBar />
  <main class="teaching-page page-shell contests-page">
    <header class="teaching-page-header">
      <div>
        <RouterLink class="teaching-breadcrumb" :to="{ name: 'contests' }">竞赛首页</RouterLink>
        <h1>赛季管理</h1>
        <p class="teaching-subtle">赛季开始时按系数软重置段位分，同时间段只能有一个已发布赛季</p>
      </div>
      <div class="teaching-toolbar">
        <RouterLink class="forum-secondary-button" :to="{ name: 'admin-events' }">
          赛事管理
        </RouterLink>
        <button class="primary-button" type="button" @click="openCreate">新建赛季</button>
      </div>
    </header>

    <p v-if="error" class="form-error" role="alert">{{ error }}</p>

    <section v-if="formOpen" class="teaching-panel contest-admin-form" aria-label="赛季表单">
      <div class="section-heading">
        <h2>{{ form.id === null ? '新建赛季' : `编辑赛季 #${form.id}` }}</h2>
        <button class="forum-secondary-button" type="button" @click="formOpen = false">关闭</button>
      </div>
      <div class="contest-admin-grid">
        <label class="contest-admin-field">
          <span>赛季名称</span>
          <input v-model="form.name" type="text" maxlength="100" />
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
          <span>开始时间</span>
          <input v-model="form.starts_at" type="datetime-local" />
        </label>
        <label class="contest-admin-field">
          <span>结束时间</span>
          <input v-model="form.ends_at" type="datetime-local" />
        </label>
        <label class="contest-admin-field">
          <span>软重置系数</span>
          <input v-model="form.soft_reset_ratio" type="number" min="0" max="1" step="0.05" />
        </label>
      </div>
      <p v-if="formError" class="form-error" role="alert">{{ formError }}</p>
      <div class="teaching-toolbar">
        <button class="primary-button" type="button" :disabled="saving" @click="save">
          {{ saving ? '正在保存' : '保存赛季' }}
        </button>
        <button class="forum-secondary-button" type="button" @click="formOpen = false">
          取消
        </button>
      </div>
    </section>

    <section class="teaching-panel">
      <div v-if="loading" class="empty-state"><p>正在加载赛季</p></div>
      <div v-else-if="!seasons.length" class="empty-state">
        <p>还没有赛季，排位赛将继续使用全局段位分</p>
      </div>
      <div v-else class="contest-admin-table-wrap">
        <table class="contest-detail-table contest-admin-table">
          <thead>
            <tr>
              <th scope="col">赛季</th>
              <th scope="col">状态</th>
              <th scope="col">时间</th>
              <th scope="col">软重置</th>
              <th scope="col">操作</th>
            </tr>
          </thead>
          <tbody>
            <tr v-for="season in seasons" :key="season.id">
              <td>
                <strong>{{ season.name }}</strong>
                <div class="teaching-subtle">#{{ season.id }}</div>
              </td>
              <td>
                {{ STATE_LABELS[season.state] }}
                <div class="teaching-subtle">
                  {{ STATUS_OPTIONS.find((option) => option.value === season.status)?.label }}
                </div>
              </td>
              <td>
                {{ formatDateTime(season.starts_at) }}
                <div class="teaching-subtle">至 {{ formatDateTime(season.ends_at) }}</div>
              </td>
              <td>{{ season.soft_reset_ratio }}</td>
              <td>
                <button class="forum-secondary-button" type="button" @click="openEdit(season)">
                  编辑
                </button>
              </td>
            </tr>
          </tbody>
        </table>
      </div>
    </section>
  </main>
</template>
