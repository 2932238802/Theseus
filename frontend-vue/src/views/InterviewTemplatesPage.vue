<script setup lang="ts">
import { onMounted } from 'vue'
import MarkdownBody from '../components/MarkdownBody.vue'
import NavBar from '../components/NavBar.vue'
import { useInterviewTemplatesReader } from '../utils/interviewTemplatesReader'
import { formatForumDateTime } from '../utils/forum'

const {
  templates,
  selectedId,
  detail,
  listLoading,
  listError,
  detailLoading,
  detailError,
  forbidden,
  loadTemplates,
  selectTemplate,
} = useInterviewTemplatesReader()

const retryDetail = (): void => {
  if (selectedId.value !== null) void selectTemplate(selectedId.value)
}

onMounted(() => {
  void loadTemplates()
})
</script>

<template>
  <NavBar />
  <main class="forum-page interview-reader-page page-shell">
    <header class="forum-page-heading">
      <div class="forum-page-heading-context">
        <h1>HR 面模板与套路</h1>
        <p>先看结构与话术 再把你被问到的原题写进面经</p>
      </div>
      <RouterLink class="forum-secondary-button" :to="{ path: '/forum', query: { board: 'interview' } }">
        返回面经
      </RouterLink>
    </header>

    <section v-if="forbidden" class="forum-locked interview-reader-forbidden" role="status">
      <h2>当前账号无法查看该内容</h2>
      <p>可以返回面经列表继续浏览</p>
      <RouterLink class="forum-secondary-button" :to="{ path: '/forum', query: { board: 'interview' } }">
        返回面经
      </RouterLink>
    </section>

    <p v-else-if="listError" class="list-error" role="alert">
      {{ listError }}
      <button type="button" @click="loadTemplates">重试</button>
    </p>

    <div v-else class="interview-reader-layout">
      <nav class="interview-reader-nav" aria-label="HR 模板目录">
        <div class="interview-reader-nav-head">
          <h2>模板目录</h2>
          <span v-if="templates.length">{{ templates.length }} 篇</span>
        </div>
        <p v-if="listLoading" class="run-note">正在加载模板</p>
        <ol v-else-if="templates.length">
          <li v-for="item in templates" :key="item.id">
            <button
              type="button"
              :class="['interview-reader-item', { active: item.id === selectedId }]"
              :aria-current="item.id === selectedId ? 'page' : undefined"
              @click="selectTemplate(item.id)"
            >
              {{ item.title }}
            </button>
          </li>
        </ol>
        <p v-else class="interview-reader-empty">暂无模板</p>
      </nav>

      <section class="interview-reader-panel" aria-live="polite" :aria-busy="detailLoading">
        <p v-if="detailLoading" class="run-note">正在加载模板内容</p>
        <p v-else-if="detailError" class="list-error" role="alert">
          {{ detailError }}
          <button type="button" @click="retryDetail">重试</button>
        </p>
        <template v-else-if="detail">
          <header class="interview-reader-panel-head">
            <h2>{{ detail.title }}</h2>
            <span>更新于 {{ formatForumDateTime(detail.updatedAt) }}</span>
          </header>
          <MarkdownBody :content="detail.contentMd" />
        </template>
        <p v-else-if="listLoading" class="run-note">正在加载模板</p>
        <div v-else-if="!templates.length" class="interview-reader-empty">暂无模板</div>
        <div v-else class="interview-reader-empty">选择左侧模板查看内容</div>
      </section>
    </div>
  </main>
</template>
