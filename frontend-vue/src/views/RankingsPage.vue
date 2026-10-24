<script setup lang="ts">
import NavBar from '../components/NavBar.vue'
</script>

<template>
  <NavBar />
  <main class="rankings-page page-shell">
    <header class="page-title"><h1>排行榜</h1><p>排行榜接口接入后将在此展示排名。</p></header>
    <section class="empty-state"><p>排行榜建设中，敬请期待。</p><RouterLink class="primary-button" to="/problems">先去刷题 <span>→</span></RouterLink></section>
  </main>
</template>
