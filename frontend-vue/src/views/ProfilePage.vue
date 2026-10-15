<script setup lang="ts">
import { computed } from 'vue'
import NavBar from '../components/NavBar.vue'
import { useAuthStore } from '../store/auth'
import { useSubmissionStore } from '../store/submissions'

const authStore = useAuthStore()
const submissionStore = useSubmissionStore()
const acceptedCount = computed(() => submissionStore.submissions.filter((submission) => submission.status === 'Accepted').length)
</script>

<template>
  <NavBar />
  <main class="profile-page page-shell">
    <header class="page-title"><p class="eyebrow">YOUR PROGRESS</p><h1>个人中心</h1><p>所有微小但坚定的前进，都值得被看见。</p></header>
    <section class="profile-overview"><div class="large-avatar">{{ authStore.user?.avatar ?? 'T' }}</div><div><h2>{{ authStore.user?.username ?? '游客' }}</h2><p>{{ authStore.user?.email ?? '登录后同步你的练习进度' }}</p><span class="level-label">算法探索者 · LEVEL 01</span></div></section>
    <section class="profile-stats"><article><strong>{{ acceptedCount }}</strong><span>通过题目</span></article><article><strong>{{ submissionStore.submissions.length }}</strong><span>总提交数</span></article><article><strong>{{ submissionStore.submissions.length ? Math.round((acceptedCount / submissionStore.submissions.length) * 100) : 0 }}<small>%</small></strong><span>通过率</span></article><article><strong>0</strong><span>连续练习天数</span></article></section>
    <section class="recent-section"><div class="section-heading"><div><p class="eyebrow">RECENT SUBMISSIONS</p><h2>最近提交</h2></div></div><div v-if="submissionStore.submissions.length" class="submission-list"><article v-for="submission in submissionStore.submissions" :key="submission.id"><RouterLink :to="`/problem/${submission.problemId}`">{{ submission.problemTitle }}</RouterLink><span>{{ submission.language }}</span><span :class="['result-status', submission.status === 'Accepted' ? 'accepted' : 'failed']">{{ submission.status }}</span><time>{{ new Date(submission.createdAt).toLocaleString('zh-CN') }}</time></article></div><div v-else class="empty-state"><p>还没有提交记录。</p><RouterLink class="primary-button" to="/problems">去开始第一题 <span>→</span></RouterLink></div></section>
  </main>
</template>
