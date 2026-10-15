<script setup lang="ts">
import NavBar from '../components/NavBar.vue'
</script>

<template>
  <NavBar />
  <main class="not-found page-shell"><p class="eyebrow">LOST IN THE MAZE</p><strong>404</strong><h1>这里没有出口。</h1><p>也许这条路径从未存在，但下一道题的答案正在等你。</p><RouterLink class="primary-button" to="/problems">返回题库 <span>→</span></RouterLink></main>
</template>
