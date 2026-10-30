<script setup lang="ts">
import { computed, onMounted, reactive, ref } from 'vue'
import NavBar from '../components/NavBar.vue'
import {
  fetchAdminContestAppeals,
  resolveAdminContestAppeal,
} from '../api/adminEvents'
import { toErrorMessage } from '../api/client'
import { toast } from '../store/toast'
import type { ContestAppeal, ContestAppealStatus } from '../types/contest'
import { formatDateTime } from '../utils/teaching'

const STATUS_OPTIONS: Array<{ value: '' | ContestAppealStatus; label: string }> = [
  { value: '', label: '全部' },
  { value: 'pending', label: '待处理' },
  { value: 'accepted', label: '已通过' },
  { value: 'rejected', label: '未通过' },
]

const STATUS_LABELS: Record<ContestAppealStatus, string> = {
  pending: '待处理',
  accepted: '已通过',
  rejected: '未通过',
}

const status = ref<'' | ContestAppealStatus>('pending')
const items = ref<ContestAppeal[]>([])
const loading = ref(true)
const error = ref('')
const resolvingId = ref<number | null>(null)
const notes = reactive<Record<number, string>>({})

const pendingCount = computed(() => items.value.filter((item) => item.status === 'pending').length)

const load = async (): Promise<void> => {
  loading.value = true
  error.value = ''
  try {
    items.value = (await fetchAdminContestAppeals(status.value || undefined)).items
  } catch (exception: unknown) {
    error.value = toErrorMessage(exception)
  } finally {
    loading.value = false
  }
}

const setStatus = (value: '' | ContestAppealStatus): void => {
  if (status.value === value) return
  status.value = value
  void load()
}

const resolve = async (
  item: ContestAppeal,
  decision: 'accepted' | 'rejected',
): Promise<void> => {
  if (resolvingId.value !== null) return
  resolvingId.value = item.id
  error.value = ''
  try {
    const result = await resolveAdminContestAppeal(item.id, decision, notes[item.id] ?? '')
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
  <main class="teaching-page page-shell contests-page">
    <header class="teaching-page-header">
      <div>
        <RouterLink class="teaching-breadcrumb" :to="{ name: 'contests' }">竞赛首页</RouterLink>
        <h1>赛事申诉</h1>
        <p class="teaching-subtle">
          通过申诉会撤销作弊判定、恢复信誉分并重新结算排名
        </p>
      </div>
      <div class="teaching-toolbar">
        <RouterLink class="forum-secondary-button" :to="{ name: 'admin-events' }">
          赛事管理
        </RouterLink>
        <button class="forum-secondary-button" type="button" :disabled="loading" @click="load">
          刷新
        </button>
      </div>
    </header>

    <nav class="teaching-toolbar" aria-label="申诉筛选">
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
      <div v-if="loading" class="empty-state"><p>正在加载申诉</p></div>
      <div v-else-if="!items.length" class="empty-state"><p>没有符合条件的申诉</p></div>
      <div v-else class="contest-admin-table-wrap">
        <table class="contest-detail-table contest-admin-table">
          <thead>
            <tr>
              <th scope="col">比赛</th>
              <th scope="col">学生</th>
              <th scope="col">申诉理由</th>
              <th scope="col">状态</th>
              <th scope="col">处理</th>
            </tr>
          </thead>
          <tbody>
            <tr v-for="item in items" :key="item.id">
              <td>
                <RouterLink class="contest-problem-link" :to="`/contests/${item.contest_id}/result`">
                  {{ item.event_title ?? `比赛 #${item.contest_id}` }}
                </RouterLink>
                <div class="teaching-subtle">
                  {{ formatDateTime(item.created_at) }}
                  <template v-if="item.disqualified"> · 已取消资格</template>
                </div>
              </td>
              <td>{{ item.username }}</td>
              <td class="contest-appeal-reason">{{ item.reason }}</td>
              <td>
                {{ STATUS_LABELS[item.status] }}
                <div v-if="item.handled_by" class="teaching-subtle">
                  {{ item.handled_by }}
                  <template v-if="item.handled_at">
                    · {{ formatDateTime(item.handled_at) }}
                  </template>
                </div>
                <div v-if="item.handle_note" class="teaching-subtle">
                  说明：{{ item.handle_note }}
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
                  <button
                    class="primary-button"
                    type="button"
                    :disabled="resolvingId === item.id"
                    @click="resolve(item, 'accepted')"
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
