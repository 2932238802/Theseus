<script setup lang="ts">
import { computed, onMounted, reactive, ref } from 'vue'
import NavBar from '../components/NavBar.vue'
import { toErrorMessage } from '../api/client'
import {
  fetchAdminPlusApplications,
  resolveAdminPlusApplication,
} from '../api/shop'
import { toast } from '../store/toast'
import type { PlusApplication, PlusApplicationStatus } from '../types/shop'
import { formatDateTime } from '../utils/teaching'

const STATUS_OPTIONS: Array<{ value: '' | PlusApplicationStatus; label: string }> = [
  { value: '', label: '全部' },
  { value: 'pending', label: '待处理' },
  { value: 'approved', label: '已通过' },
  { value: 'rejected', label: '未通过' },
]

const STATUS_LABELS: Record<PlusApplicationStatus, string> = {
  pending: '待处理',
  approved: '已通过',
  rejected: '未通过',
}

const status = ref<'' | PlusApplicationStatus>('pending')
const items = ref<PlusApplication[]>([])
const loading = ref(true)
const error = ref('')
const resolvingId = ref<number | null>(null)
const notes = reactive<Record<number, string>>({})
const days = reactive<Record<number, number>>({})
const DEFAULT_DAYS = 30

const pendingCount = computed(() => items.value.filter((item) => item.status === 'pending').length)

const load = async (): Promise<void> => {
  loading.value = true
  error.value = ''
  try {
    items.value = (await fetchAdminPlusApplications(status.value || undefined)).items
    for (const item of items.value) {
      if (item.status === 'pending' && days[item.id] === undefined) days[item.id] = DEFAULT_DAYS
    }
  } catch (exception: unknown) {
    error.value = toErrorMessage(exception)
  } finally {
    loading.value = false
  }
}

const setStatus = (value: '' | PlusApplicationStatus): void => {
  if (status.value === value) return
  status.value = value
  void load()
}

const resolve = async (
  item: PlusApplication,
  decision: 'approved' | 'rejected',
): Promise<void> => {
  if (resolvingId.value !== null) return
  const openDays = days[item.id] ?? DEFAULT_DAYS
  if (decision === 'approved' && (!Number.isInteger(openDays) || openDays < 1 || openDays > 3650)) {
    error.value = '开通天数需在 1 到 3650 天之间'
    return
  }
  resolvingId.value = item.id
  error.value = ''
  try {
    const result = await resolveAdminPlusApplication(
      item.id,
      decision,
      notes[item.id] ?? '',
      decision === 'approved' ? openDays : undefined,
    )
    toast.success(result.message)
    delete notes[item.id]
    await load()
  } catch (exception: unknown) {
    error.value = toErrorMessage(exception)
  } finally {
    resolvingId.value = null
  }
}

onMounted(() => {
  void load()
})
</script>

<template>
  <NavBar />
  <main class="teaching-page page-shell">
    <header class="teaching-page-header">
      <div>
        <h1>Plus 申请</h1>
      </div>
      <button class="forum-secondary-button" type="button" :disabled="loading" @click="load">
        刷新
      </button>
    </header>

    <nav class="teaching-toolbar" aria-label="申请筛选">
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
      <span v-if="status === 'pending'" class="teaching-subtle">{{ pendingCount }} 条待处理</span>
    </nav>

    <p v-if="error" class="form-error" role="alert">{{ error }}</p>

    <section class="teaching-panel">
      <div v-if="loading" class="empty-state"><p>正在加载申请</p></div>
      <div v-else-if="!items.length" class="empty-state"><p>没有符合条件的申请</p></div>
      <div v-else class="contest-admin-table-wrap">
        <table class="contest-detail-table contest-admin-table">
          <thead>
            <tr>
              <th scope="col">用户</th>
              <th scope="col">申请说明</th>
              <th scope="col">状态</th>
              <th scope="col">处理</th>
            </tr>
          </thead>
          <tbody>
            <tr v-for="item in items" :key="item.id">
              <td>
                {{ item.username }}
                <div v-if="item.kind === 'renewal'" class="teaching-subtle">续费申请</div>
                <div class="teaching-subtle">{{ formatDateTime(item.created_at) }}</div>
              </td>
              <td class="contest-appeal-reason">{{ item.reason }}</td>
              <td>
                {{ STATUS_LABELS[item.status] }}
                <div v-if="item.reviewed_by" class="teaching-subtle">
                  {{ item.reviewed_by }}
                  <template v-if="item.reviewed_at">
                    · {{ formatDateTime(item.reviewed_at) }}
                  </template>
                </div>
                <div v-if="item.review_note" class="teaching-subtle">
                  说明：{{ item.review_note }}
                </div>
                <div v-if="item.membership_expires_at" class="teaching-subtle">
                  有效期至 {{ formatDateTime(item.membership_expires_at) }}
                </div>
              </td>
              <td>
                <div v-if="item.status === 'pending'" class="contest-admin-actions">
                  <input
                    v-model="notes[item.id]"
                    type="text"
                    maxlength="500"
                    placeholder="处理说明（可选）"
                  />
                  <input
                    v-model.number="days[item.id]"
                    type="number"
                    min="1"
                    max="3650"
                    class="plus-days-input"
                    placeholder="天数"
                    aria-label="开通天数"
                  />
                  <button
                    class="primary-button"
                    type="button"
                    :disabled="resolvingId === item.id"
                    @click="resolve(item, 'approved')"
                  >
                    通过
                  </button>
                  <button
                    class="forum-secondary-button"
                    type="button"
                    :disabled="resolvingId === item.id"
                    @click="resolve(item, 'rejected')"
                  >
                    驳回
                  </button>
                </div>
                <span v-else class="teaching-subtle">已处理</span>
              </td>
            </tr>
          </tbody>
        </table>
      </div>
    </section>
  </main>
</template>
