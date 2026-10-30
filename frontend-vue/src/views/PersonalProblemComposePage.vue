<script setup lang="ts">
import { computed, onMounted, ref } from 'vue'
import { useRoute, useRouter } from 'vue-router'
import NavBar from '../components/NavBar.vue'
import ProblemForm from '../components/ProblemForm.vue'
import { toErrorMessage } from '../api/client'
import {
  createMyProblem,
  fetchMyProblem,
  updateMyProblem,
} from '../api/problemReview'
import type { ProblemEditorPayload, ReviewedProblemDetail } from '../types/problemReview'

const route = useRoute()
const router = useRouter()
const isEdit = computed(() => route.name === 'personal-problem-edit')
const problemId = computed(() => Number(route.params.id))

const initial = ref<ReviewedProblemDetail | null>(null)
const loading = ref(false)
const loadError = ref('')
const submitting = ref(false)
const submitError = ref('')

const load = async (): Promise<void> => {
  if (!isEdit.value) return
  if (!Number.isInteger(problemId.value) || problemId.value <= 0) {
    loadError.value = '题目不存在'
    return
  }
  loading.value = true
  loadError.value = ''
  try {
    const detail = await fetchMyProblem(problemId.value)
    if (detail.reviewStatus !== 'rejected') {
      throw new Error('只有已退回的题目可以编辑重提')
    }
    initial.value = detail
  } catch (exception: unknown) {
    loadError.value = toErrorMessage(exception)
  } finally {
    loading.value = false
  }
}

const submit = async (payload: ProblemEditorPayload): Promise<void> => {
  if (submitting.value) return
  submitting.value = true
  submitError.value = ''
  try {
    if (isEdit.value) {
      await updateMyProblem(problemId.value, payload)
    } else {
      await createMyProblem(payload)
    }
    await router.push('/personal/problems')
  } catch (exception: unknown) {
    submitError.value = toErrorMessage(exception)
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
  <main class="teaching-page teaching-wide page-shell">
    <header class="teaching-page-header">
      <div>
        <h1>{{ isEdit ? '编辑题目' : '新建题目' }}</h1>
      </div>
      <RouterLink class="teaching-secondary-button" to="/personal/problems">返回个人出题</RouterLink>
    </header>

    <p v-if="loading" class="teaching-subtle">正在加载题目</p>
    <p v-else-if="loadError" class="form-error" role="alert">{{ loadError }}</p>
    <ProblemForm
      v-else
      :key="initial?.id ?? 'new'"
      :initial="initial"
      :submitting="submitting"
      :server-error="submitError"
      :submit-label="isEdit ? '重新提交审核' : '提交审核'"
      @submit="submit"
    />
  </main>
</template>
