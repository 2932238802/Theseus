<script setup lang="ts">
import NavBar from '../components/NavBar.vue'
</script>

<template>
  <NavBar />
  <main class="not-found page-shell"><h1>404 页面不存在</h1><p>你访问的页面不存在或已被移除</p><RouterLink class="primary-button" to="/problems">返回题库</RouterLink></main>
</template>
