<script setup lang="ts">
import { computed, onBeforeUnmount, onMounted, ref } from 'vue'
import MarkdownEditor from '../components/MarkdownEditor.vue'
import NavBar from '../components/NavBar.vue'
import { toErrorMessage } from '../api/client'
import {
  createInterviewTemplate,
  deleteInterviewTemplate,
  listAdminInterviewTemplates,
  reorderInterviewTemplates,
  updateInterviewTemplate,
  type InterviewTemplateDetail,
  type InterviewTemplateInput,
} from '../api/interviewTemplates'
import { toast } from '../store/toast'
import { formatForumDateTime } from '../utils/forum'

const templates = ref<InterviewTemplateDetail[]>([])
const loading = ref(false)
const loadError = ref('')

const selectedId = ref<number | null>(null)
const title = ref('')
const content = ref('')
const formError = ref('')
const saving = ref(false)
const deleting = ref(false)

const dragging = ref(false)
const dragIndex = ref<number | null>(null)
const reordering = ref(false)
let originalOrder: number[] = []
let dragHandle: HTMLElement | null = null
let dragPointerId: number | null = null

const titleLength = computed(() => title.value.trim().length)
const contentLength = computed(() => content.value.trim().length)
const canSave = computed(
  () =>
    !saving.value &&
    !deleting.value &&
    titleLength.value >= 1 &&
    titleLength.value <= 120 &&
    contentLength.value >= 1 &&
    contentLength.value <= 20000,
)

const orderIds = (list: InterviewTemplateDetail[]): number[] => list.map((item) => item.id)

const selectTemplate = (template: InterviewTemplateDetail): void => {
  selectedId.value = template.id
  title.value = template.title
  content.value = template.contentMd
  formError.value = ''
}

const startCreate = (): void => {
  selectedId.value = null
  title.value = ''
  content.value = ''
  formError.value = ''
}

const selectFirst = (): void => {
  const first = templates.value[0]
  if (first) selectTemplate(first)
  else startCreate()
}

const load = async (preferredId?: number): Promise<void> => {
  loading.value = true
  loadError.value = ''
  try {
    const list = await listAdminInterviewTemplates()
    templates.value = list
    const targetId = preferredId === undefined ? selectedId.value : preferredId
    const target = targetId === null ? null : list.find((item) => item.id === targetId) ?? null
    if (target) {
      selectTemplate(target)
      return
    }
    if (list.length > 0 && preferredId === undefined && selectedId.value === null) {
      selectTemplate(list[0] as InterviewTemplateDetail)
      return
    }
    if (list.length === 0) {
      selectedId.value = null
      title.value = ''
      content.value = ''
    }
  } catch (exception: unknown) {
    templates.value = []
    selectedId.value = null
    title.value = ''
    content.value = ''
    loadError.value = toErrorMessage(exception)
  } finally {
    loading.value = false
  }
}

const save = async (): Promise<void> => {
  if (!canSave.value) return
  saving.value = true
  formError.value = ''
  const creating = selectedId.value === null
  try {
    const payload: InterviewTemplateInput = {
      title: title.value.trim(),
      content_md: content.value.trim(),
    }
    const saved = creating
      ? await createInterviewTemplate(payload)
      : await updateInterviewTemplate(selectedId.value as number, payload)
    toast.success(creating ? '模板已创建' : '模板已更新')
    await load(saved.id)
  } catch (exception: unknown) {
    formError.value = toErrorMessage(exception)
    toast.error(formError.value)
  } finally {
    saving.value = false
  }
}

const remove = async (): Promise<void> => {
  const id = selectedId.value
  if (id === null || deleting.value) return
  const current = templates.value.find((item) => item.id === id)
  if (!window.confirm(`确定删除模板「${current?.title ?? title.value}」吗？删除后不可恢复`)) {
    return
  }
  const index = templates.value.findIndex((item) => item.id === id)
  const next = templates.value[index + 1] ?? templates.value[index - 1] ?? null
  deleting.value = true
  formError.value = ''
  try {
    const result = await deleteInterviewTemplate(id)
    toast.success(result.message)
    selectedId.value = null
    await load(next ? next.id : undefined)
    if (templates.value.length === 0) startCreate()
  } catch (exception: unknown) {
    formError.value = toErrorMessage(exception)
    toast.error(formError.value)
  } finally {
    deleting.value = false
  }
}

const restoreOrder = async (ids: number[]): Promise<void> => {
  const byId = new Map(templates.value.map((item) => [item.id, item]))
  const restored = ids
    .map((id) => byId.get(id))
    .filter((item): item is InterviewTemplateDetail => item !== undefined)
  if (restored.length === ids.length && restored.length === templates.value.length) {
    templates.value = restored
    return
  }
  await load()
}

const persistOrder = async (current: number[]): Promise<void> => {
  const snapshot = [...originalOrder]
  reordering.value = true
  try {
    const result = await reorderInterviewTemplates(current)
    originalOrder = [...current]
    toast.success(result.message)
  } catch (exception: unknown) {
    await restoreOrder(snapshot)
    toast.error(toErrorMessage(exception))
  } finally {
    reordering.value = false
  }
}

const onDragMove = (event: PointerEvent): void => {
  if (!dragging.value || dragIndex.value === null) return
  const element = document.elementFromPoint(event.clientX, event.clientY)
  const item = element instanceof HTMLElement
    ? element.closest<HTMLElement>('[data-template-index]')
    : null
  if (!item) return
  const targetIndex = Number(item.dataset.templateIndex)
  if (!Number.isInteger(targetIndex) || targetIndex < 0 || targetIndex >= templates.value.length) {
    return
  }
  if (targetIndex === dragIndex.value) return
  const [moved] = templates.value.splice(dragIndex.value, 1)
  if (!moved) return
  templates.value.splice(targetIndex, 0, moved)
  dragIndex.value = targetIndex
}

const endDrag = (): void => {
  window.removeEventListener('pointermove', onDragMove)
  window.removeEventListener('pointerup', endDrag)
  window.removeEventListener('pointercancel', endDrag)
  if (dragHandle && dragPointerId !== null) {
    try {
      if (dragHandle.hasPointerCapture(dragPointerId)) {
        dragHandle.releasePointerCapture(dragPointerId)
      }
    } catch {
      // 指针可能已释放，忽略
    }
  }
  dragHandle = null
  dragPointerId = null
  dragging.value = false
  const wasDragging = dragIndex.value !== null
  dragIndex.value = null
  if (!wasDragging) return

  const current = orderIds(templates.value)
  const unchanged =
    current.length === originalOrder.length &&
    current.every((id, index) => id === originalOrder[index])
  if (unchanged) return
  void persistOrder(current)
}

const startDrag = (event: PointerEvent, index: number): void => {
  if (event.button !== 0 || loading.value || saving.value || deleting.value || reordering.value) {
    return
  }
  event.preventDefault()
  dragging.value = true
  dragIndex.value = index
  originalOrder = orderIds(templates.value)
  dragHandle = event.currentTarget as HTMLElement | null
  dragPointerId = event.pointerId
  if (dragHandle?.setPointerCapture) dragHandle.setPointerCapture(event.pointerId)
  window.addEventListener('pointermove', onDragMove)
  window.addEventListener('pointerup', endDrag)
  window.addEventListener('pointercancel', endDrag)
}

onMounted(() => {
  void load()
})

onBeforeUnmount(() => {
  window.removeEventListener('pointermove', onDragMove)
  window.removeEventListener('pointerup', endDrag)
  window.removeEventListener('pointercancel', endDrag)
})
</script>

<template>
  <NavBar />
  <main class="admin-forum-page page-shell">
    <header class="forum-page-heading">
      <div>
        <h1>面经模板</h1>
        <p class="teaching-subtle">左侧拖拽调整顺序 右侧编辑 Markdown 正文</p>
      </div>
      <button type="button" class="primary-button" @click="startCreate">新建模板</button>
    </header>

    <p v-if="loadError" class="form-error" role="alert">{{ loadError }}</p>

    <div class="interview-template-layout">
      <section class="interview-template-list-panel" aria-label="模板列表">
        <div class="section-heading">
          <h2>模板列表</h2>
          <span class="admin-total">{{ templates.length }} 个</span>
        </div>

        <p v-if="loading" class="run-note">正在加载模板</p>
        <div v-else-if="templates.length" class="interview-template-list">
          <ol>
            <li
              v-for="(template, index) in templates"
              :key="template.id"
              :data-template-index="index"
              :class="[
                'interview-template-item',
                {
                  active: template.id === selectedId,
                  dragging: dragging && dragIndex === index,
                },
              ]"
            >
              <button
                type="button"
                class="interview-template-drag"
                aria-label="拖拽调整顺序"
                title="拖拽调整顺序"
                @pointerdown="startDrag($event, index)"
              >
                <span aria-hidden="true">≡</span>
              </button>
              <button
                type="button"
                class="interview-template-main"
                @click="selectTemplate(template)"
              >
                <strong>{{ template.title }}</strong>
                <span>更新于 {{ formatForumDateTime(template.updatedAt) }}</span>
              </button>
            </li>
          </ol>
        </div>
        <div v-else class="empty-state">
          <p>还没有模板 先新建一个</p>
        </div>
      </section>

      <section class="interview-template-editor admin-panel" aria-label="模板编辑">
        <div class="section-heading">
          <h2>{{ selectedId === null ? '新建模板' : '编辑模板' }}</h2>
          <button
            v-if="selectedId === null && templates.length > 0"
            type="button"
            class="teaching-link-button"
            @click="selectFirst"
          >
            取消新建
          </button>
        </div>

        <form class="teaching-form" @submit.prevent="save">
          <label>
            <span>标题（1–120 字）</span>
            <input
              v-model="title"
              type="text"
              maxlength="120"
              placeholder="例如 自我介绍模板"
              required
            />
            <small class="teaching-subtle">{{ title.length }} / 120</small>
          </label>

          <div class="forum-field">
            <span>正文（Markdown，1–20000 字）</span>
            <MarkdownEditor
              v-model="content"
              :maxlength="20000"
              placeholder="用 Markdown 编写模板内容 支持工具栏与 Ctrl/Cmd+B、I、K 快捷键"
            />
            <small class="teaching-subtle">{{ content.length }} / 20000</small>
          </div>

          <p v-if="formError" class="form-error" role="alert">{{ formError }}</p>

          <div class="teaching-form-actions">
            <button
              v-if="selectedId !== null"
              type="button"
              class="forum-danger-button"
              :disabled="deleting || saving"
              @click="remove"
            >
              {{ deleting ? '删除中' : '删除模板' }}
            </button>
            <button type="submit" class="primary-button" :disabled="!canSave">
              {{ saving ? '保存中' : '保存' }}
            </button>
          </div>
        </form>
      </section>
    </div>
  </main>
</template>
