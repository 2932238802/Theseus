<script setup lang="ts">
import { ref, watch } from 'vue'
import { toErrorMessage } from '../api/client'
import { createForumReport } from '../api/forum'
import { REPORT_REASONS, type ReportReason, type ReportTargetType } from '../types/forum'

const props = defineProps<{
  visible: boolean
  targetType: ReportTargetType
  targetId: number
}>()

const emit = defineEmits<{
  close: []
  submitted: [message: string]
}>()

const reason = ref<ReportReason>('spam')
const detail = ref('')
const error = ref('')
const loading = ref(false)

watch(
  () => props.visible,
  (visible) => {
    if (visible) {
      reason.value = 'spam'
      detail.value = ''
      error.value = ''
    }
  },
)

const submit = async (): Promise<void> => {
  error.value = ''
  loading.value = true
  try {
    const result = await createForumReport({
      target_type: props.targetType,
      target_id: props.targetId,
      reason: reason.value,
      detail: detail.value.trim() || undefined,
    })
    emit('submitted', result.hidden ? `${result.message}，内容已自动隐藏` : result.message)
  } catch (exception: unknown) {
    error.value = toErrorMessage(exception)
  } finally {
    loading.value = false
  }
}
</script>

<template>
  <div v-if="visible" class="modal-backdrop" @click.self="emit('close')">
    <section class="forum-dialog" role="dialog" aria-modal="true" aria-labelledby="report-dialog-title">
      <header>
        <div>
          <h2 id="report-dialog-title">举报内容</h2>
          <p>请选择原因，管理员会尽快复核。</p>
        </div>
        <button type="button" aria-label="关闭" @click="emit('close')">×</button>
      </header>
      <div class="forum-dialog-body">
        <fieldset class="forum-report-reasons">
          <legend>举报原因</legend>
          <label v-for="item in REPORT_REASONS" :key="item.code">
            <input v-model="reason" type="radio" name="report-reason" :value="item.code" />
            {{ item.label }}
          </label>
        </fieldset>
        <label class="forum-field">
          <span>补充说明（可选，最多 500 字）</span>
          <textarea v-model="detail" maxlength="500" rows="4" placeholder="请描述具体问题"></textarea>
        </label>
        <p v-if="error" class="form-error" role="alert">{{ error }}</p>
      </div>
      <footer>
        <button type="button" class="forum-secondary-button" @click="emit('close')">取消</button>
        <button type="button" class="forum-danger-button" :disabled="loading" @click="submit">
          {{ loading ? '提交中…' : '提交举报' }}
        </button>
      </footer>
    </section>
  </div>
</template>
