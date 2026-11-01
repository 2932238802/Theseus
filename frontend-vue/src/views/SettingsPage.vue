<script setup lang="ts">
import { computed, onMounted, ref } from 'vue'
import NavBar from '../components/NavBar.vue'
import ShortcutDialog from '../components/ShortcutDialog.vue'
import { usePreferenceStore } from '../store/preferences'
import { useShortcutStore } from '../store/shortcuts'
import { LANGUAGE_OPTIONS } from '../utils/constants'
import { EDITOR_THEME_OPTIONS, type EditorThemeChoice } from '../utils/monacoTheme'
import type { EditorTabSize } from '../types/preference'
import type { Language } from '../types/oj'
import type { ThemeMode } from '../types/profile'

const prefs = usePreferenceStore()
const shortcutStore = useShortcutStore()
const shortcutOpen = ref(false)
const resetConfirm = ref(false)

const THEME_OPTIONS: Array<{ value: ThemeMode; label: string }> = [
  { value: 'light', label: '浅色' },
  { value: 'dark', label: '深色' },
  { value: 'system', label: '跟随系统' },
]
const TAB_OPTIONS: Array<{ value: EditorTabSize; label: string }> = [
  { value: 'auto', label: '自动' },
  { value: 2, label: '2 空格' },
  { value: 4, label: '4 空格' },
  { value: 8, label: '8 空格' },
]
const PAGE_SIZE_OPTIONS = [20, 50, 100]

const editorTheme = computed({
  get: () => prefs.editorTheme,
  set: (value: EditorThemeChoice) => prefs.setEditorTheme(value),
})
const editorTabSize = computed({
  get: () => prefs.editorTabSize,
  set: (value: EditorTabSize) => prefs.setEditorTabSize(value),
})
const problemLanguage = computed({
  get: () => prefs.problemLanguage,
  set: (value: Language) => prefs.setProblemLanguage(value),
})
const problemPageSize = computed({
  get: () => prefs.problemPageSize,
  set: (value: number) => prefs.setProblemPageSize(value),
})

const customizedShortcuts = computed(() => Object.keys(shortcutStore.overrides).length)
const saveLabel = computed(() => {
  if (prefs.saveState === 'error') return '同步失败'
  if (!prefs.isLoaded) return prefs.isLoading ? '正在同步' : '仅保存在本机'
  if (prefs.saveState === 'saving') return '正在保存'
  return '已同步到账号'
})

const resetShortcuts = (): void => {
  shortcutStore.resetAll()
}

const resetAll = async (): Promise<void> => {
  if (!resetConfirm.value) {
    resetConfirm.value = true
    return
  }
  resetConfirm.value = false
  await prefs.resetAll()
}

onMounted(() => {
  void prefs.load()
})
</script>

<template>
  <NavBar />
  <main class="settings-page page-shell">
    <header class="settings-header">
      <div>
        <h1>个人偏好设置</h1>
        <p>登录后自动同步到账号 换设备继续保持</p>
      </div>
      <span class="settings-sync" :class="{ 'is-error': prefs.saveState === 'error' }">
        {{ saveLabel }}
      </span>
    </header>

    <p v-if="prefs.error" class="settings-error" role="alert">{{ prefs.error }}</p>

    <section class="settings-section" aria-labelledby="settings-appearance">
      <header>
        <h2 id="settings-appearance">外观</h2>
        <p>全站深浅色与代码编辑器配色</p>
      </header>
      <div class="settings-row">
        <div class="settings-label">
          <strong>全站主题</strong>
          <small>跟随系统时会随设备切换</small>
        </div>
        <div class="settings-pills" role="group" aria-label="全站主题">
          <button
            v-for="option in THEME_OPTIONS"
            :key="option.value"
            type="button"
            :class="{ active: prefs.appearanceTheme === option.value }"
            :aria-pressed="prefs.appearanceTheme === option.value"
            @click="prefs.setAppearanceTheme(option.value)"
          >
            {{ option.label }}
          </button>
        </div>
      </div>
      <div class="settings-row">
        <div class="settings-label">
          <strong>编辑器主题</strong>
          <small>默认跟随全站主题</small>
        </div>
        <select v-model="editorTheme" aria-label="编辑器主题">
          <option v-for="option in EDITOR_THEME_OPTIONS" :key="option.value" :value="option.value">
            {{ option.label }}
          </option>
        </select>
      </div>
    </section>

    <section class="settings-section" aria-labelledby="settings-editor">
      <header>
        <h2 id="settings-editor">编辑器</h2>
        <p>字号 缩进与语义补全</p>
      </header>
      <div class="settings-row">
        <div class="settings-label">
          <strong>字号</strong>
          <small>10 到 32</small>
        </div>
        <div class="settings-stepper">
          <button
            type="button"
            aria-label="减小字号"
            :disabled="prefs.editorFontSize <= 12"
            @click="prefs.setEditorFontSize(prefs.editorFontSize - 1)"
          >
            A−
          </button>
          <span>{{ prefs.editorFontSize }}</span>
          <button
            type="button"
            aria-label="增大字号"
            :disabled="prefs.editorFontSize >= 20"
            @click="prefs.setEditorFontSize(prefs.editorFontSize + 1)"
          >
            A+
          </button>
        </div>
      </div>
      <div class="settings-row">
        <div class="settings-label">
          <strong>缩进宽度</strong>
          <small>自动时 Python 用 4 空格 其余语言用 2 空格</small>
        </div>
        <select v-model="editorTabSize" aria-label="缩进宽度">
          <option v-for="option in TAB_OPTIONS" :key="option.value" :value="option.value">
            {{ option.label }}
          </option>
        </select>
      </div>
      <div class="settings-row">
        <div class="settings-label">
          <strong>语义补全</strong>
          <small>默认关闭 比赛模式下不可使用</small>
        </div>
        <button
          type="button"
          class="settings-toggle"
          :class="{ active: prefs.editorCompletion }"
          :aria-pressed="prefs.editorCompletion"
          @click="prefs.setEditorCompletion(!prefs.editorCompletion)"
        >
          {{ prefs.editorCompletion ? '已开启' : '已关闭' }}
        </button>
      </div>
    </section>

    <section class="settings-section" aria-labelledby="settings-problems">
      <header>
        <h2 id="settings-problems">题目</h2>
        <p>答题页默认语言与题库每页数量</p>
      </header>
      <div class="settings-row">
        <div class="settings-label">
          <strong>默认语言</strong>
          <small>进入题目时优先使用该语言</small>
        </div>
        <select v-model="problemLanguage" aria-label="默认语言">
          <option v-for="option in LANGUAGE_OPTIONS" :key="option.value" :value="option.value">
            {{ option.label }}
          </option>
        </select>
      </div>
      <div class="settings-row">
        <div class="settings-label">
          <strong>每页题数</strong>
          <small>题库列表与分页数量</small>
        </div>
        <select v-model.number="problemPageSize" aria-label="每页题数">
          <option v-for="size in PAGE_SIZE_OPTIONS" :key="size" :value="size">{{ size }}</option>
        </select>
      </div>
    </section>

    <section class="settings-section" aria-labelledby="settings-shortcuts">
      <header>
        <h2 id="settings-shortcuts">快捷键</h2>
        <p>答题页与编辑器内的按键绑定</p>
      </header>
      <div class="settings-row">
        <div class="settings-label">
          <strong>自定义按键</strong>
          <small>{{ customizedShortcuts ? `已修改 ${customizedShortcuts} 项` : '当前使用默认按键' }}</small>
        </div>
        <div class="settings-actions">
          <button type="button" class="settings-button" @click="shortcutOpen = true">打开快捷键设置</button>
          <button
            type="button"
            class="settings-button is-quiet"
            :disabled="!customizedShortcuts"
            @click="resetShortcuts"
          >
            恢复默认
          </button>
        </div>
      </div>
    </section>

    <section class="settings-section" aria-labelledby="settings-account">
      <header>
        <h2 id="settings-account">账号</h2>
        <p>用户名 邮箱 密码 登录设备与第三方账号</p>
      </header>
      <div class="settings-row">
        <div class="settings-label">
          <strong>账号与安全</strong>
          <small>在个人界面中打开账号设置</small>
        </div>
        <RouterLink class="settings-button" to="/profile">前往个人界面</RouterLink>
      </div>
    </section>

    <footer class="settings-footer">
      <p>恢复默认会清除账号内保存的全部个性化设置</p>
      <div class="settings-actions">
        <button v-if="resetConfirm" type="button" class="settings-button is-quiet" @click="resetConfirm = false">
          取消
        </button>
        <button type="button" class="settings-button is-danger" @click="resetAll">
          {{ resetConfirm ? '确认恢复默认' : '恢复默认设置' }}
        </button>
      </div>
    </footer>
  </main>
  <ShortcutDialog v-if="shortcutOpen" @close="shortcutOpen = false" />
</template>
