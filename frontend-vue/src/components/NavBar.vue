<script setup lang="ts">
import { computed, onBeforeUnmount, onMounted, ref } from 'vue'
import { RouterLink, useRoute, useRouter } from 'vue-router'
import NotificationBell from './NotificationBell.vue'
import { useAuthStore } from '../store/auth'
import { isDarkTheme, toggleTheme as applyThemeToggle } from '../utils/theme'

const authStore = useAuthStore()
const router = useRouter()
const route = useRoute()
const isMenuOpen = ref(false)
const isDark = ref(isDarkTheme())

const userInitial = computed(() => authStore.user?.avatar ?? authStore.user?.username.slice(0, 1).toUpperCase() ?? 'T')
const isManageOpen = ref(false)
const manageRef = ref<HTMLElement | null>(null)
const isAdminArea = computed(() => route.path.startsWith('/admin'))

const closeManage = (): void => {
  isManageOpen.value = false
}

const onDocumentPointerDown = (event: PointerEvent): void => {
  if (!isManageOpen.value) return
  if (event.target instanceof Node && manageRef.value?.contains(event.target)) return
  closeManage()
}

const onWindowKeydown = (event: KeyboardEvent): void => {
  if (event.key === 'Escape' && isManageOpen.value) closeManage()
}

const toggleTheme = (): void => {
  isDark.value = applyThemeToggle() === 'dark'
}

const logout = (): void => {
  authStore.logout()
  void router.push('/login')
}

onMounted(() => {
  document.addEventListener('pointerdown', onDocumentPointerDown)
  window.addEventListener('keydown', onWindowKeydown)
})

onBeforeUnmount(() => {
  document.removeEventListener('pointerdown', onDocumentPointerDown)
  window.removeEventListener('keydown', onWindowKeydown)
})
</script>

<template>
  <header class="site-header">
    <RouterLink class="brand" to="/" aria-label="Theseus 首页">
      <span class="brand-mark" aria-hidden="true">T</span>
      <span class="brand-name">Theseus</span>
    </RouterLink>

    <nav class="main-nav" aria-label="主导航">
      <RouterLink to="/problems">题库</RouterLink>
      <RouterLink to="/forum">校园墙</RouterLink>
      <RouterLink class="nav-rankings" to="/rankings">排行榜</RouterLink>
      <RouterLink v-if="authStore.isTeacher" class="nav-teacher-problems" to="/teacher/problems">出题</RouterLink>
      <RouterLink v-if="authStore.isStudent || authStore.isTeacher" class="nav-classes" to="/classes">我的班级</RouterLink>
      <RouterLink v-if="authStore.isAuthenticated" class="nav-profile" to="/profile">个人</RouterLink>
      <div v-if="authStore.isAdmin" ref="manageRef" class="nav-menu" :class="{ 'is-active': isAdminArea }">
        <button
          id="admin-menu-button"
          type="button"
          aria-haspopup="menu"
          aria-controls="admin-menu-panel"
          :aria-expanded="isManageOpen"
          @click="isManageOpen = !isManageOpen"
        >
          管理<span class="nav-caret" aria-hidden="true"></span>
        </button>
        <div
          v-if="isManageOpen"
          id="admin-menu-panel"
          class="nav-menu-panel"
          role="menu"
          aria-labelledby="admin-menu-button"
        >
          <RouterLink role="menuitem" to="/admin/problems" @click="closeManage">题目审核</RouterLink>
          <RouterLink role="menuitem" to="/admin/forum" @click="closeManage">论坛管理</RouterLink>
          <RouterLink role="menuitem" to="/admin/users" @click="closeManage">用户管理</RouterLink>
          <RouterLink role="menuitem" to="/admin/notifications" @click="closeManage">通知管理</RouterLink>
        </div>
      </div>
    </nav>

    <div class="header-actions">
      <NotificationBell />
      <button class="icon-button" type="button" :aria-label="isDark ? '切换至浅色模式' : '切换至深色模式'" @click="toggleTheme">
        <svg v-if="isDark" viewBox="0 0 24 24" aria-hidden="true"><path d="M12 3v2m0 14v2M3 12h2m14 0h2m-2.64-6.36-1.41 1.41M7.05 16.95l-1.41 1.41m0-12.72 1.41 1.41m9.9 9.9 1.41 1.41M15.5 12a3.5 3.5 0 1 1-7 0 3.5 3.5 0 0 1 7 0Z" /></svg>
        <svg v-else viewBox="0 0 24 24" aria-hidden="true"><path d="M20.1 15.1A8.5 8.5 0 0 1 8.9 3.9 8.5 8.5 0 1 0 20.1 15.1Z" /></svg>
      </button>
      <template v-if="authStore.isAuthenticated">
        <button class="avatar-button" type="button" :aria-label="`用户菜单：${authStore.user?.username ?? ''}`" aria-haspopup="menu" :aria-expanded="isMenuOpen" @click="isMenuOpen = !isMenuOpen">
          <img v-if="authStore.user?.avatarUrl" :src="authStore.user.avatarUrl" :alt="authStore.user.username" />
          <template v-else>{{ userInitial }}</template>
        </button>
        <div v-if="isMenuOpen" class="user-menu">
          <strong>{{ authStore.user?.username }}</strong>
          <span>{{ authStore.user?.email }}</span>
          <hr />
          <RouterLink v-if="authStore.isTeacher" to="/teacher/problems" @click="isMenuOpen = false">我的题目</RouterLink>
          <RouterLink to="/profile" @click="isMenuOpen = false">个人</RouterLink>
          <button type="button" @click="logout">退出登录</button>
        </div>
      </template>
      <RouterLink v-else class="header-login" to="/login">登录</RouterLink>
    </div>
  </header>
</template>
