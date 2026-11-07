<script setup lang="ts">
import { nextTick, ref } from 'vue'
import { formatForumTime } from '../utils/forum'
import {
  solutionBadgeLabel,
  solutionBadgeStatus,
  solutionLanguageLabel,
  solutionMeta,
} from '../utils/solution'
import type { ProblemSolution } from '../types/solution'

const props = defineProps<{
  solutions: ProblemSolution[]
  activeId: string
  max: number
  loading: boolean
  error: string
}>()

const emit = defineEmits<{
  switch: [id: string]
  add: []
  rename: [id: string, name: string]
  delete: [id: string]
}>()

const renamingId = ref('')
const renameValue = ref('')
const renameInput = ref<HTMLInputElement | null>(null)
const setRenameInput = (element: unknown): void => {
  renameInput.value = element instanceof HTMLInputElement ? element : null
}

const startRename = async (solution: ProblemSolution): Promise<void> => {
  renamingId.value = solution.id
  renameValue.value = solution.name
  await nextTick()
  renameInput.value?.focus()
  renameInput.value?.select()
}

const commitRename = (solution: ProblemSolution): void => {
  if (renamingId.value !== solution.id) return
  const value = renameValue.value.trim()
  renamingId.value = ''
  if (!value || value === solution.name) return
  emit('rename', solution.id, value)
}

const cancelRename = (): void => {
  renamingId.value = ''
}

const indexLabel = (index: number): string => String(index + 1).padStart(2, '0')
</script>

<template>
  <div class="solutions-panel">
    <div class="solutions-head">
      <h2>
        我的解法
        <span class="count-pill">{{ props.solutions.length }} / {{ props.max }}</span>
      </h2>
      <button
        type="button"
        class="new-solution-button"
        :disabled="props.solutions.length >= props.max || props.loading"
        :title="props.solutions.length >= props.max ? `最多保存 ${props.max} 个解法` : '新建解法'"
        @click="emit('add')"
      >
        ＋ 新建解法
      </button>
    </div>
    <p v-if="props.solutions.length >= props.max" class="solution-limit-note">
      已达 {{ props.max }} 个解法上限 删除一个后才能继续新建
    </p>
    <p v-if="props.error" class="form-error" role="alert">{{ props.error }}</p>
    <p v-if="props.loading && !props.solutions.length" class="output-placeholder">正在加载解法</p>
    <ol v-else class="solution-list">
      <li
        v-for="(solution, index) in props.solutions"
        :key="solution.id"
        :class="['solution-card', { 'is-active': solution.id === props.activeId }]"
      >
        <div class="solution-card-main" @click="emit('switch', solution.id)">
          <span class="solution-index">{{ indexLabel(index) }}</span>
          <div class="solution-info">
            <div class="solution-title-row">
              <input
                v-if="renamingId === solution.id"
                :ref="setRenameInput"
                v-model="renameValue"
                class="solution-rename-input"
                maxlength="60"
                aria-label="解法名称"
                @click.stop
                @keydown.enter.prevent="commitRename(solution)"
                @keydown.esc.prevent="cancelRename"
                @blur="commitRename(solution)"
              />
              <span v-else class="solution-name">{{ solution.name }}</span>
              <span :class="['solution-status', solutionBadgeStatus(solution)]">{{ solutionBadgeLabel(solution) }}</span>
              <span class="solution-lang">{{ solutionLanguageLabel(solution) }}</span>
              <span v-if="solution.id === props.activeId" class="solution-flag">当前编辑</span>
            </div>
            <p class="solution-meta">{{ solutionMeta(solution) }}</p>
            <p class="solution-time">更新于 {{ formatForumTime(solution.updatedAt) }}</p>
          </div>
        </div>
        <div class="solution-actions">
          <button type="button" @click.stop="emit('switch', solution.id)">编辑</button>
          <button type="button" @click.stop="startRename(solution)">重命名</button>
          <button
            type="button"
            class="is-danger"
            :disabled="props.solutions.length <= 1"
            :title="props.solutions.length <= 1 ? '至少保留一个解法' : '删除解法'"
            @click.stop="emit('delete', solution.id)"
          >
            删除
          </button>
        </div>
      </li>
    </ol>
  </div>
</template>
