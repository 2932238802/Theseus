<script setup lang="ts">
import { computed, onMounted, ref, watch } from 'vue'
import { useRoute } from 'vue-router'
import NavBar from '../components/NavBar.vue'
import CodeEditor from '../components/CodeEditor.vue'
import { useProblemStore } from '../store/problems'
import { useSubmissionStore } from '../store/submissions'
import { DEFAULT_CODE, DIFFICULTY_LABELS, LANGUAGE_OPTIONS } from '../utils/constants'
import type { Language } from '../types/oj'

const route = useRoute()
const problemStore = useProblemStore()
const submissionStore = useSubmissionStore()
const problemId = computed(() => Number(route.params.id))
const language = ref<Language>('javascript')
const code = ref('')
const fontSize = ref(14)
const isOutputOpen = ref(true)
const isDark = ref(document.documentElement.dataset.theme === 'dark')
const customInput = ref('')
const isRunDialogOpen = ref(false)
const draftKey = computed(() => `theseus-draft-${problemId.value}-${language.value}`)

const restoreDraft = (): void => { code.value = localStorage.getItem(draftKey.value) ?? DEFAULT_CODE[language.value] }
const saveDraft = (): void => { localStorage.setItem(draftKey.value, code.value) }
const resetCode = (): void => { code.value = DEFAULT_CODE[language.value] }
const loadPage = async (): Promise<void> => { await problemStore.loadProblem(problemId.value); restoreDraft() }
const submitCode = async (): Promise<void> => {
  if (!problemStore.currentProblem || !code.value.trim()) return
  saveDraft()
  await submissionStore.submit(problemStore.currentProblem, language.value, code.value)
  isOutputOpen.value = true
}
const runCode = (): void => { isRunDialogOpen.value = true }
const confirmRun = (): void => { isRunDialogOpen.value = false; isOutputOpen.value = true }

onMounted(() => { void loadPage() })
watch(language, restoreDraft)
watch(code, saveDraft)
watch(() => route.params.id, () => { void loadPage() })
</script>

<template>
  <NavBar />
  <main class="oj-page">
    <div v-if="problemStore.isLoading" class="oj-loading">正在准备题目…</div>
    <div v-else-if="problemStore.error" class="oj-error"><h1>无法打开题目</h1><p>{{ problemStore.error }}</p><RouterLink class="primary-button" to="/problems">返回题库</RouterLink></div>
    <template v-else-if="problemStore.currentProblem">
      <section class="problem-pane">
        <div class="problem-pane-inner">
          <div class="breadcrumb"><RouterLink to="/problems">题库</RouterLink><span>/</span><span>{{ problemStore.currentProblem.id }}. {{ problemStore.currentProblem.title }}</span></div>
          <header class="problem-heading"><div><p class="eyebrow">PROBLEM {{ String(problemStore.currentProblem.id).padStart(3, '0') }}</p><h1>{{ problemStore.currentProblem.title }}</h1></div><span :class="['difficulty', problemStore.currentProblem.difficulty]">{{ DIFFICULTY_LABELS[problemStore.currentProblem.difficulty] }}</span></header>
          <div class="problem-tags"><span v-for="tag in problemStore.currentProblem.tags" :key="tag" class="tag">{{ tag }}</span><span class="acceptance-stat">通过率 {{ problemStore.currentProblem.acceptance }}%</span></div>
          <article class="problem-content"><p v-for="paragraph in problemStore.currentProblem.description.split('\n\n')" :key="paragraph">{{ paragraph.replaceAll('**', '').replaceAll('*', '') }}</p><h2>输入描述</h2><p>{{ problemStore.currentProblem.inputDescription }}</p><h2>输出描述</h2><p>{{ problemStore.currentProblem.outputDescription }}</p><h2>示例</h2><div v-for="(example, index) in problemStore.currentProblem.examples" :key="example.input" class="example-block"><span>示例 {{ index + 1 }}</span><pre><b>输入：</b>{{ example.input }}
<b>输出：</b>{{ example.output }}</pre><p v-if="example.explanation"><b>解释：</b>{{ example.explanation }}</p></div><h2>数据范围</h2><ul><li v-for="constraint in problemStore.currentProblem.constraints" :key="constraint">{{ constraint }}</li></ul><template v-if="problemStore.currentProblem.hints?.length"><h2>提示</h2><ul><li v-for="hint in problemStore.currentProblem.hints" :key="hint">{{ hint }}</li></ul></template></article>
        </div>
      </section>
      <section class="editor-pane">
        <div class="editor-toolbar"><select v-model="language" aria-label="选择编程语言"><option v-for="option in LANGUAGE_OPTIONS" :key="option.value" :value="option.value">{{ option.label }}</option></select><div class="editor-tools"><button type="button" title="减小字体" @click="fontSize = Math.max(12, fontSize - 1)">A−</button><span>{{ fontSize }}</span><button type="button" title="增大字体" @click="fontSize = Math.min(20, fontSize + 1)">A+</button><button type="button" title="切换编辑器主题" @click="isDark = !isDark">◐</button></div></div>
        <CodeEditor v-model="code" :language="language" :font-size="fontSize" :dark="isDark" />
        <section class="output-panel" :class="{ collapsed: !isOutputOpen }"><header><button type="button" @click="isOutputOpen = !isOutputOpen"><span>{{ isOutputOpen ? '⌄' : '›' }}</span> 运行结果</button><span v-if="submissionStore.isSubmitting" class="running-state"><i class="spinner"></i> 判题中…</span><span v-else-if="submissionStore.latest" :class="['result-status', submissionStore.latest.status === 'Accepted' ? 'accepted' : 'failed']">{{ submissionStore.latest.status }}</span></header><div v-if="isOutputOpen" class="output-body"><template v-if="submissionStore.latest"><p>{{ submissionStore.latest.message }}</p><dl v-if="submissionStore.latest.status === 'Accepted'"><div><dt>执行用时</dt><dd>{{ submissionStore.latest.runtime }}</dd></div><div><dt>内存消耗</dt><dd>{{ submissionStore.latest.memory }}</dd></div></dl><p class="mock-note">当前为本地模拟评测结果。</p></template><p v-else class="output-placeholder">提交代码后将在这里显示评测结果。</p></div></section>
        <footer class="editor-actions"><button class="reset-button" type="button" @click="resetCode">↺ 重置代码</button><div><button class="run-button" type="button" @click="runCode">运行代码</button><button class="submit-button" type="button" :disabled="submissionStore.isSubmitting || !code.trim()" @click="submitCode">{{ submissionStore.isSubmitting ? '评测中…' : '提交代码' }} <span>→</span></button></div></footer>
      </section>
    </template>
  </main>
  <div v-if="isRunDialogOpen" class="dialog-backdrop" @click.self="isRunDialogOpen = false"><section class="run-dialog" role="dialog" aria-modal="true" aria-label="运行自定义测试"><header><h2>自定义测试</h2><button type="button" @click="isRunDialogOpen = false">×</button></header><p>输入测试数据，运行结果将在下方结果面板中展示。</p><textarea v-model="customInput" placeholder="请输入测试用例"></textarea><footer><button class="run-button" type="button" @click="confirmRun">运行</button></footer></section></div>
</template>
