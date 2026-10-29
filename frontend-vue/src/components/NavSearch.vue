<script setup lang="ts">
import { computed, nextTick, onBeforeUnmount, onMounted, ref } from 'vue'
import { useRouter } from 'vue-router'
import { useAuthStore } from '../store/auth'

type SearchGroup = '常用' | '社区' | '个人' | '教学' | '管理'

type SearchTarget = {
  label: string
  hint: string
  group: SearchGroup
  to: string
  keywords: string
}

const router = useRouter()
const authStore = useAuthStore()
const root = ref<HTMLElement | null>(null)
const input = ref<HTMLInputElement | null>(null)
const query = ref('')
const open = ref(false)
const activeIndex = ref(0)

const targets = computed<SearchTarget[]>(() => {
  const items: SearchTarget[] = [
    { label: '首页', hint: '返回 Theseus 首页', group: '常用', to: '/', keywords: 'home 首页' },
    { label: '题库', hint: '刷题与题目列表', group: '常用', to: '/problems', keywords: 'problems 题目 刷题' },
    { label: '论坛', hint: '讨论、题解与动态', group: '社区', to: '/forum', keywords: 'forum 帖子 讨论 社区 校园墙' },
    { label: '排行榜', hint: '按段位分排序', group: '社区', to: '/contests/rankings', keywords: 'rankings 榜单 排名 段位分' },
  ]
  if (authStore.isAuthenticated) {
    items.push(
      { label: '竞赛', hint: '4 人排位赛', group: '社区', to: '/contests', keywords: 'contest 竞赛 排位赛 比赛' },
      { label: '通知中心', hint: '站内通知与班级邀请', group: '个人', to: '/notifications', keywords: 'notifications 消息 通知 邀请' },
      { label: '个人主页', hint: '资料、提交记录与学习分析', group: '个人', to: '/profile', keywords: 'profile 个人 资料 记录 分析' },
      { label: '我的收藏', hint: '题目、帖子与评论', group: '个人', to: '/profile/favorites', keywords: 'favorites 收藏' },
    )
  }
  if (authStore.isStudent || authStore.isTeacher) {
    items.push({ label: '我的班级', hint: '班级、成员与作业', group: '教学', to: '/classes', keywords: 'classes 班级 作业' })
  }
  if (authStore.isTeacher) {
    items.push({ label: '出题', hint: '创建与维护题目', group: '教学', to: '/teacher/problems', keywords: 'teacher problems 出题 我的题目' })
  }
  if (authStore.isAdmin) {
    items.push(
      { label: '题目审核', hint: '审核待发布题目', group: '管理', to: '/admin/problems', keywords: 'admin problems 审核 题目 管理' },
      { label: '论坛管理', hint: '帖子与评论审核', group: '管理', to: '/admin/forum', keywords: 'admin forum 论坛 管理' },
      { label: '用户管理', hint: '用户与角色管理', group: '管理', to: '/admin/users', keywords: 'admin users 用户 角色' },
      { label: '赛事管理', hint: '创建赛事并配置规则与题目', group: '管理', to: '/admin/events', keywords: 'admin events 竞赛 赛事 报名 规则' },
      { label: '通知管理', hint: '向用户或角色发送通知', group: '管理', to: '/admin/notifications', keywords: 'admin notifications 通知 广播' },
    )
  }
  return items
})

const results = computed<SearchTarget[]>(() => {
  const terms = query.value.trim().toLowerCase().split(/\s+/).filter(Boolean)
  if (!terms.length) return targets.value
  return targets.value.filter((item) => {
    const haystack = `${item.label} ${item.hint} ${item.keywords}`.toLowerCase()
    return terms.every((term) => haystack.includes(term))
  })
})

const groupedResults = computed(() => {
  const groups: Array<{ label: SearchGroup; items: SearchTarget[] }> = []
  for (const item of results.value) {
    let group = groups.find((entry) => entry.label === item.group)
    if (!group) {
      group = { label: item.group, items: [] }
      groups.push(group)
    }
    group.items.push(item)
  }
  return groups
})

const activeId = computed(() =>
  open.value && results.value.length ? `nav-search-option-${activeIndex.value}` : undefined,
)

const indexOf = (item: SearchTarget): number => results.value.indexOf(item)

const openPanel = (): void => {
  open.value = true
  activeIndex.value = Math.min(activeIndex.value, Math.max(results.value.length - 1, 0))
}

const focusInput = (): void => {
  open.value = true
  void nextTick(() => {
    input.value?.focus()
    input.value?.select()
  })
}

const close = (clear = true): void => {
  open.value = false
  activeIndex.value = 0
  if (clear) query.value = ''
}

const onInput = (): void => {
  open.value = true
  activeIndex.value = 0
}

const moveActive = (delta: number): void => {
  if (!results.value.length) return
  open.value = true
  activeIndex.value =
    (activeIndex.value + delta + results.value.length) % results.value.length
}

const go = async (item: SearchTarget): Promise<void> => {
  close()
  input.value?.blur()
  await router.push(item.to)
}

const clearQuery = (): void => {
  query.value = ''
  activeIndex.value = 0
  open.value = true
  void nextTick(() => input.value?.focus())
}

const onInputKeydown = async (event: KeyboardEvent): Promise<void> => {
  if (event.key === 'ArrowDown') {
    event.preventDefault()
    moveActive(1)
  } else if (event.key === 'ArrowUp') {
    event.preventDefault()
    moveActive(-1)
  } else if (event.key === 'Home' && open.value) {
    event.preventDefault()
    activeIndex.value = 0
  } else if (event.key === 'End' && open.value) {
    event.preventDefault()
    activeIndex.value = Math.max(results.value.length - 1, 0)
  } else if (event.key === 'Enter') {
    if (!open.value) {
      openPanel()
      return
    }
    const item = results.value[activeIndex.value]
    if (item) {
      event.preventDefault()
      await go(item)
    }
  } else if (event.key === 'Escape') {
    if (open.value) {
      event.preventDefault()
      close()
    }
  } else if (event.key === 'Tab') {
    close(false)
  }
}

const onDocumentPointerDown = (event: PointerEvent): void => {
  if (!open.value) return
  if (event.target instanceof Node && root.value?.contains(event.target)) return
  close()
}

const onWindowKeydown = (event: KeyboardEvent): void => {
  if ((event.metaKey || event.ctrlKey) && event.key.toLowerCase() === 'k') {
    event.preventDefault()
    focusInput()
    return
  }
  if (event.key === 'Escape' && open.value) close()
}

const onFocusOut = (event: FocusEvent): void => {
  const next = event.relatedTarget
  if (next instanceof Node && root.value?.contains(next)) return
  close(false)
}

const optionId = (item: SearchTarget): string => `nav-search-option-${indexOf(item)}`

onMounted(() => {
  document.addEventListener('pointerdown', onDocumentPointerDown)
  window.addEventListener('keydown', onWindowKeydown)
})

onBeforeUnmount(() => {
  document.removeEventListener('pointerdown', onDocumentPointerDown)
  window.removeEventListener('keydown', onWindowKeydown)
})
</script>

<template>
  <div ref="root" class="nav-search" :class="{ 'is-open': open }">
    <button
      class="nav-search-toggle icon-button"
      type="button"
      aria-label="搜索页面"
      aria-haspopup="listbox"
      aria-controls="nav-search-results"
      :aria-expanded="open"
      @click="open ? close() : focusInput()"
    >
      <svg viewBox="0 0 24 24" aria-hidden="true">
        <circle cx="11" cy="11" r="6" />
        <path d="m16 16 4 4" />
      </svg>
    </button>

    <div class="nav-search-box">
      <svg viewBox="0 0 24 24" aria-hidden="true">
        <circle cx="11" cy="11" r="6" />
        <path d="m16 16 4 4" />
      </svg>
      <input
        ref="input"
        v-model="query"
        class="nav-search-input"
        type="search"
        placeholder="搜索页面"
        role="combobox"
        aria-label="搜索页面"
        aria-autocomplete="list"
        aria-controls="nav-search-results"
        :aria-expanded="open"
        :aria-activedescendant="activeId"
        @focus="openPanel"
        @input="onInput"
        @keydown="onInputKeydown"
        @focusout="onFocusOut"
      />
      <button
        v-if="query"
        class="nav-search-clear"
        type="button"
        aria-label="清空搜索"
        @click="clearQuery"
      >
        ×
      </button>
      <kbd v-else class="nav-search-kbd" aria-hidden="true">Ctrl K</kbd>
      <button class="nav-search-close" type="button" @click="close()">取消</button>
    </div>

    <div v-if="open" class="nav-search-backdrop" aria-hidden="true" @click="close()"></div>

    <div
      v-if="open"
      id="nav-search-results"
      class="nav-search-panel"
      role="listbox"
      aria-label="页面搜索结果"
    >
      <template v-if="groupedResults.length">
        <div v-for="group in groupedResults" :key="group.label" class="nav-search-group">
          <span class="nav-search-group-label" role="presentation">{{ group.label }}</span>
          <button
            v-for="item in group.items"
            :id="optionId(item)"
            :key="item.to"
            type="button"
            role="option"
            :aria-selected="activeIndex === indexOf(item)"
            :class="['nav-search-option', { active: activeIndex === indexOf(item) }]"
            @mousedown.prevent
            @mouseenter="activeIndex = indexOf(item)"
            @click="go(item)"
          >
            <span class="nav-search-option-text">
              <strong>{{ item.label }}</strong>
              <small>{{ item.hint }}</small>
            </span>
            <span class="nav-search-enter" aria-hidden="true">↵</span>
          </button>
        </div>
      </template>
      <p v-else class="nav-search-empty">没有匹配的页面</p>
    </div>
  </div>
</template>
