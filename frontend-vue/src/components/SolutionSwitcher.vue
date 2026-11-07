<script setup lang="ts">
import { computed, onBeforeUnmount, onMounted, ref, watch } from 'vue'
import { solutionBadgeLabel, solutionBadgeStatus, solutionLanguageLabel } from '../utils/solution'
import type { ProblemSolution } from '../types/solution'

const props = defineProps<{
  solutions: ProblemSolution[]
  activeId: string
  max: number
}>()

const emit = defineEmits<{
  switch: [id: string]
  add: []
  delete: [id: string]
}>()

const rootRef = ref<HTMLElement | null>(null)
const open = ref(false)

const activeSolution = computed(
  () => props.solutions.find((item) => item.id === props.activeId) ?? null,
)

const toggle = (): void => {
  open.value = !open.value
}

const closePopover = (): void => {
  open.value = false
}

const switchTo = (id: string): void => {
  closePopover()
  if (id !== props.activeId) emit('switch', id)
}

const requestDelete = (id: string): void => {
  closePopover()
  emit('delete', id)
}

const onDocumentPointerDown = (event: PointerEvent): void => {
  if (!open.value) return
  const target = event.target
  if (rootRef.value && target instanceof Node && !rootRef.value.contains(target)) {
    closePopover()
  }
}

const onKeydown = (event: KeyboardEvent): void => {
  if (event.key === 'Escape') closePopover()
}

watch(() => props.activeId, closePopover)

onMounted(() => {
  document.addEventListener('pointerdown', onDocumentPointerDown, true)
  document.addEventListener('keydown', onKeydown)
})

onBeforeUnmount(() => {
  document.removeEventListener('pointerdown', onDocumentPointerDown, true)
  document.removeEventListener('keydown', onKeydown)
})
</script>

<template>
  <div ref="rootRef" class="switch-wrap">
    <button
      type="button"
      class="switch-button"
      aria-haspopup="true"
      :aria-expanded="open"
      title="切换解法"
      @click.stop="toggle"
    >
      <span
        :class="['switch-dot', activeSolution ? solutionBadgeStatus(activeSolution) : 'draft']"
        aria-hidden="true"
      ></span>
      <span class="switch-name">{{ activeSolution?.name ?? '解法' }}</span>
      <span class="switch-count">{{ props.solutions.length }} / {{ props.max }}</span>
      <span class="switch-caret" aria-hidden="true">▾</span>
    </button>
    <div
      v-if="open"
      class="solution-popover"
      role="dialog"
      aria-label="切换解法"
      @click.stop
    >
      <div class="popover-head">
        <strong>切换解法</strong>
        <span>{{ props.solutions.length }} / {{ props.max }}</span>
      </div>
      <ul class="solution-row-list">
        <li
          v-for="solution in props.solutions"
          :key="solution.id"
          :class="['solution-row', { 'is-active': solution.id === props.activeId }]"
        >
          <button type="button" class="solution-row-main" @click="switchTo(solution.id)">
            <span
              :class="['switch-dot', solutionBadgeStatus(solution)]"
              aria-hidden="true"
            ></span>
            <span class="row-info">
              <span class="row-title">
                {{ solution.name }}
                <span v-if="solution.id === props.activeId" class="row-current">当前</span>
              </span>
              <span class="row-meta">
                {{ solutionBadgeLabel(solution) }} · {{ solutionLanguageLabel(solution) }}
              </span>
            </span>
          </button>
          <span class="row-actions">
            <button
              type="button"
              class="row-delete"
              :disabled="props.solutions.length <= 1"
              :title="props.solutions.length <= 1 ? '至少保留一个解法' : '删除解法'"
              @click.stop="requestDelete(solution.id)"
            >
              删除
            </button>
          </span>
        </li>
      </ul>
      <div class="popover-foot">
        <button
          type="button"
          class="popover-add"
          :disabled="props.solutions.length >= props.max"
          @click="closePopover(); emit('add')"
        >
          ＋ 新建解法
        </button>
        <span class="popover-hint">
          {{ props.solutions.length >= props.max ? `已达 ${props.max} 个上限` : `最多保存 ${props.max} 个` }}
        </span>
      </div>
    </div>
  </div>
</template>
