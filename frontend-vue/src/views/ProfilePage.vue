<script setup lang="ts">
import { computed, onMounted } from 'vue'
import NavBar from '../components/NavBar.vue'
import { useAuthStore } from '../store/auth'
import { useSubmissionStore } from '../store/submissions'

const authStore = useAuthStore()
const submissionStore = useSubmissionStore()
const acceptedSubmissions = computed(() => submissionStore.submissions.filter((submission) => submission.status === 'Accepted'))
const acceptedProblemCount = computed(() => new Set(acceptedSubmissions.value.map((submission) => submission.problemId)).size)
const attemptedProblemCount = computed(() => new Set(submissionStore.submissions.map((submission) => submission.problemId)).size)
const acceptanceRate = computed(() => submissionStore.submissions.length ? Math.round((acceptedSubmissions.value.length / submissionStore.submissions.length) * 100) : 0)

onMounted(() => {
  void submissionStore.loadSubmissions({ page: 1, size: 50 })
})
</script>

<template>
  <NavBar />
  <main class="profile-page page-shell">
    <header class="page-title"><h1>个人中心</h1><p>查看你的练习进度与最近提交。</p></header>
    <section class="profile-overview"><div class="large-avatar">{{ authStore.user?.avatar ?? authStore.user?.username.slice(0, 1).toUpperCase() ?? 'T' }}</div><div><h2>{{ authStore.user?.username ?? '游客' }}</h2><p>{{ authStore.user?.email ?? '登录后同步你的练习进度' }}</p></div></section>
    <section class="profile-stats"><article><strong>{{ acceptedProblemCount }}</strong><span>通过题目</span></article><article><strong>{{ submissionStore.total }}</strong><span>总提交数</span></article><article><strong>{{ acceptanceRate }}<small>%</small></strong><span>通过率</span></article><article><strong>{{ attemptedProblemCount }}</strong><span>已尝试题目</span></article></section>
    <section class="recent-section"><div class="section-heading"><h2>最近提交</h2></div>
      <p v-if="submissionStore.error" class="form-error" role="alert">{{ submissionStore.error }}</p>
      <div v-if="submissionStore.isLoading" class="empty-state"><p>正在加载提交记录…</p></div>
      <div v-else-if="submissionStore.submissions.length" class="submission-list"><article v-for="submission in submissionStore.submissions" :key="submission.id"><RouterLink :to="`/problem/${submission.problemId}`">{{ submission.problemTitle }}</RouterLink><span>{{ submission.language }}</span><span :class="['result-status', submission.status === 'Accepted' ? 'accepted' : 'failed']">{{ submission.status }}</span><time>{{ new Date(submission.createdAt).toLocaleString('zh-CN') }}</time></article></div>
      <div v-else class="empty-state"><p>还没有提交记录。</p><RouterLink class="primary-button" to="/problems">去开始第一题 <span>→</span></RouterLink></div>
    </section>
  </main>
</template>
