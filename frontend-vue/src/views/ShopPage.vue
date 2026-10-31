<script setup lang="ts">
import { computed, onMounted, ref } from 'vue'
import NavBar from '../components/NavBar.vue'
import { toErrorMessage } from '../api/client'
import { applyPlusTheseus, fetchMyPlusState } from '../api/shop'
import { toast } from '../store/toast'
import type { MyPlusState, PlusApplicationStatus } from '../types/shop'
import { formatDateTime } from '../utils/teaching'

const STATUS_LABELS: Record<PlusApplicationStatus, string> = {
  pending: '审核中',
  approved: '已开通',
  rejected: '未通过',
}

const state = ref<MyPlusState | null>(null)
const loading = ref(true)
const error = ref('')
const reason = ref('')
const submitting = ref(false)

const application = computed(() => state.value?.application ?? null)
const canApply = computed(
  () => !state.value?.is_plus && application.value?.status !== 'pending',
)
const reasonLength = computed(() => reason.value.trim().length)

const load = async (): Promise<void> => {
  loading.value = true
  error.value = ''
  try {
    state.value = await fetchMyPlusState()
  } catch (exception: unknown) {
    error.value = toErrorMessage(exception)
  } finally {
    loading.value = false
  }
}

const submit = async (): Promise<void> => {
  if (submitting.value) return
  if (!reason.value.trim()) {
    error.value = '请填写申请说明'
    return
  }
  submitting.value = true
  error.value = ''
  try {
    state.value = await applyPlusTheseus(reason.value.trim())
    reason.value = ''
    toast.success('申请已提交，请等待管理员审核')
  } catch (exception: unknown) {
    error.value = toErrorMessage(exception)
  } finally {
    submitting.value = false
  }
}

onMounted(() => {
  void load()
})
</script>

<template>
  <NavBar />
  <main class="teaching-page page-shell shop-page">
    <header class="teaching-page-header">
      <div>
        <h1>商店</h1>
      </div>
      <button class="forum-secondary-button" type="button" :disabled="loading" @click="load">
        刷新
      </button>
    </header>

    <p v-if="error" class="form-error" role="alert">{{ error }}</p>

    <section id="plus" class="teaching-panel shop-plus-card">
      <header class="shop-plus-header">
        <div class="shop-plus-title">
          <span class="shop-plus-badge" aria-hidden="true">Plus</span>
          <h2>Plus Theseus</h2>
        </div>
        <span v-if="application" :class="['shop-status', `is-${application.status}`]">
          {{ STATUS_LABELS[application.status] }}
        </span>
      </header>

      <p class="shop-plus-copy">
        Plus Theseus 的权益仍在规划中。现在提交申请，管理员审核通过后会记录开通状态，后续权益上线时直接生效。
      </p>

      <div v-if="loading" class="empty-state"><p>正在加载</p></div>
      <template v-else>
        <div v-if="application" class="shop-application">
          <dl>
            <div>
              <dt>提交时间</dt>
              <dd>{{ formatDateTime(application.created_at) }}</dd>
            </div>
            <div class="shop-application-reason">
              <dt>申请说明</dt>
              <dd>{{ application.reason }}</dd>
            </div>
            <div v-if="application.reviewed_at">
              <dt>审核时间</dt>
              <dd>{{ formatDateTime(application.reviewed_at) }}</dd>
            </div>
            <div v-if="application.review_note" class="shop-application-reason">
              <dt>审核说明</dt>
              <dd>{{ application.review_note }}</dd>
            </div>
          </dl>
        </div>

        <form v-if="canApply" class="shop-apply-form" @submit.prevent="submit">
          <label for="plus-reason">
            {{ application?.status === 'rejected' ? '重新申请' : '开通申请' }}
          </label>
          <textarea
            id="plus-reason"
            v-model="reason"
            rows="4"
            maxlength="500"
            placeholder="说明你的使用场景或开通理由"
          ></textarea>
          <div class="shop-apply-actions">
            <span class="teaching-subtle">{{ reasonLength }} / 500</span>
            <button class="primary-button" type="submit" :disabled="submitting">
              {{ submitting ? '提交中…' : '提交申请' }}
            </button>
          </div>
        </form>
        <p v-else-if="state?.is_plus" class="shop-plus-copy">你已开通 Plus Theseus。</p>
        <p v-else class="shop-plus-copy">申请已提交，请等待管理员审核。</p>
      </template>
    </section>
  </main>
</template>
