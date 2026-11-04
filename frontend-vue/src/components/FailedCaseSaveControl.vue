<script setup lang="ts">
import { computed, ref } from 'vue'
import { addJudgeCase } from '../api/problems'
import { toErrorMessage } from '../api/client'
import { toast } from '../store/toast'

const props = defineProps<{
  problemId: number
  args: unknown
  expected: unknown
}>()

const selected = ref(false)
const state = ref<'idle' | 'saving' | 'added' | 'exists'>('idle')
const error = ref('')

const buttonLabel = computed(() => {
  if (state.value === 'saving') return '保存中'
  if (state.value === 'added') return '已加入'
  if (state.value === 'exists') return '已存在'
  return '保存'
})
const finished = computed(() => state.value === 'added' || state.value === 'exists')

const save = async (): Promise<void> => {
  if (!selected.value || state.value === 'saving' || finished.value) return
  state.value = 'saving'
  error.value = ''
  try {
    const result = await addJudgeCase(props.problemId, props.args, props.expected)
    state.value = result.added ? 'added' : 'exists'
    selected.value = false
    toast.success(
      result.added
        ? `已加入测试用例，共 ${result.total} 条隐藏用例`
        : '该用例已在测试用例中，无需重复添加',
    )
  } catch (exception: unknown) {
    state.value = 'idle'
    error.value = toErrorMessage(exception)
    toast.error(error.value)
  }
}
</script>

<template>
  <div class="judge-case-save">
    <label>
      <input v-model="selected" type="checkbox" :disabled="state === 'saving' || finished" />
      <span>将这条失败用例加入测试用例</span>
    </label>
    <button
      class="teaching-secondary-button"
      type="button"
      :disabled="!selected || state === 'saving' || finished"
      @click="save"
    >
      {{ buttonLabel }}
    </button>
    <p v-if="error" class="form-error" role="alert">{{ error }}</p>
  </div>
</template>
