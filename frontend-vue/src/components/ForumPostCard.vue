<script setup lang="ts">
import ProblemReferenceCard from './ProblemReferenceCard.vue'
import type { ForumPostSummary } from '../types/forum'
import { FORUM_TAG_LABELS } from '../types/forum'
import { formatForumTime } from '../utils/forum'

defineProps<{ post: ForumPostSummary }>()
</script>

<template>
  <article :class="['forum-post-card', { pinned: post.isPinned }]">
    <div class="forum-post-card-main">
      <div class="forum-post-card-topline">
        <span v-if="post.isPinned" class="forum-pin-badge">置顶</span>
        <RouterLink class="forum-post-card-title" :to="`/forum/${post.id}`">{{ post.title }}</RouterLink>
        <span v-for="tag in post.tags" :key="tag" class="forum-tag">{{ FORUM_TAG_LABELS[tag as keyof typeof FORUM_TAG_LABELS] ?? tag }}</span>
      </div>
      <p class="forum-post-card-excerpt">{{ post.excerpt }}</p>
      <div v-if="post.problem" class="forum-post-card-problem">
        <ProblemReferenceCard :problem="post.problem" />
      </div>
      <div class="forum-post-card-meta">
        <span :class="{ 'forum-author-anonymous': post.author.isAnonymous }">
          {{ post.author.displayName }}<template v-if="post.author.isSelf">（我）</template>
        </span>
        <span aria-hidden="true">·</span>
        <time :datetime="post.createdAt">{{ formatForumTime(post.createdAt) }}</time>
        <span class="forum-post-card-stats">
          <span title="点赞">♥ {{ post.likeCount }}</span>
          <span title="收藏">★ {{ post.favoriteCount }}</span>
          <span title="评论">💬 {{ post.commentCount }}</span>
        </span>
      </div>
    </div>
  </article>
</template>
