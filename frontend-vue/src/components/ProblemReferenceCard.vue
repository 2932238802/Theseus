<script setup lang="ts">
import type { ForumProblemRef } from '../types/forum'
import { DIFFICULTY_LABELS } from '../utils/constants'

defineProps<{ problem: ForumProblemRef }>()
</script>

<template>
  <RouterLink class="forum-problem-card" :to="`/problem/${problem.id}`">
    <span class="forum-problem-label">关联题目</span>
    <strong>{{ problem.id }}. {{ problem.title }}</strong>
    <span :class="['difficulty', problem.difficulty]">{{ DIFFICULTY_LABELS[problem.difficulty] }}</span>
    <span class="forum-problem-arrow" aria-hidden="true">→</span>
  </RouterLink>
</template>
