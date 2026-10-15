<script setup lang="ts">
import NavBar from '../components/NavBar.vue'

const rankingList = [
  { rank: 1, name: 'binary_orbit', solved: 286, streak: 42 },
  { rank: 2, name: 'LatticeWalker', solved: 264, streak: 31 },
  { rank: 3, name: 'octet', solved: 241, streak: 18 },
  { rank: 4, name: 'minerva', solved: 218, streak: 26 },
  { rank: 5, name: 'zenith', solved: 197, streak: 14 },
]
</script>

<template>
  <NavBar />
  <main class="rankings-page page-shell">
    <header class="page-title"><p class="eyebrow">LEADERBOARD</p><h1>排行榜</h1><p>和优秀的人同行，也和昨天的自己竞争。</p></header>
    <section class="ranking-podium"><article v-for="entry in rankingList.slice(0, 3)" :key="entry.rank" :class="`podium-${entry.rank}`"><span class="rank-medal">0{{ entry.rank }}</span><div class="rank-avatar">{{ entry.name.slice(0, 1).toUpperCase() }}</div><h2>{{ entry.name }}</h2><p>{{ entry.solved }} <span>题已通过</span></p></article></section>
    <section class="ranking-table"><header><span>排名</span><span>用户</span><span>通过题目</span><span>连续练习</span></header><article v-for="entry in rankingList" :key="entry.rank"><strong>0{{ entry.rank }}</strong><div><i>{{ entry.name.slice(0, 1).toUpperCase() }}</i>{{ entry.name }}</div><span>{{ entry.solved }}</span><span>{{ entry.streak }} 天</span></article></section>
  </main>
</template>
