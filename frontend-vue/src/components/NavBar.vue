<script setup lang="ts">
import { computed, onBeforeUnmount, onMounted, ref, watch } from 'vue'
import { RouterLink, useRoute, useRouter } from 'vue-router'
import NotificationBell from './NotificationBell.vue'
import NavSearch from './NavSearch.vue'
import { useAuthStore } from '../store/auth'
import { useClassStore } from '../store/classes'
import { isDarkTheme, toggleTheme as applyThemeToggle } from '../utils/theme'

const authStore = useAuthStore()
const classStore = useClassStore()
const router = useRouter()
const route = useRoute()
const isMenuOpen = ref(false)
const isDark = ref(isDarkTheme())

const canBrowseAssignments = computed(() => authStore.isStudent || authStore.isTeacher)
const classListReady = computed(
  () => Boolean(authStore.user) && classStore.loadedForUserId === authStore.user?.id,
)
const hasClasses = computed(() => classListReady.value && classStore.classes.length > 0)

const userInitial = computed(() => authStore.user?.avatar ?? authStore.user?.username.slice(0, 1).toUpperCase() ?? 'T')
const roleLabel = computed(() => {
  if (authStore.isAdmin) return '管理员'
  if (authStore.isTeacher) return '教师'
  if (authStore.isStudent) return '学生'
  return ''
})
const roleKey = computed(() =>
  authStore.isAdmin ? 'admin' : authStore.isTeacher ? 'teacher' : authStore.isStudent ? 'student' : '',
)
const roleShort = computed(() => {
  if (authStore.isAdmin) return '管'
  if (authStore.isTeacher) return '师'
  if (authStore.isStudent) return '生'
  return ''
})
const isManageOpen = ref(false)
const manageRef = ref<HTMLElement | null>(null)
const isAdminArea = computed(() => route.path.startsWith('/admin'))
const isCampusOpen = ref(false)
const campusRef = ref<HTMLElement | null>(null)
const isContestOpen = ref(false)
const contestRef = ref<HTMLElement | null>(null)
const isProfileMenuOpen = ref(false)
const profileMenuRef = ref<HTMLElement | null>(null)
const isCampusArea = computed(() =>
  ['/classes', '/assignments'].some(
    (prefix) => route.path === prefix || route.path.startsWith(`${prefix}/`),
  ) || route.path === '/profile/assignments',
)
const isContestArea = computed(
  () => route.path === '/contests' || route.path.startsWith('/contests/'),
)
const isProfileArea = computed(
  () =>
    (route.path === '/profile' || route.path.startsWith('/profile/')) &&
    route.path !== '/profile/assignments',
)

const closeManage = (): void => {
  isManageOpen.value = false
}

const closeCampus = (): void => {
  isCampusOpen.value = false
}

const closeContest = (): void => {
  isContestOpen.value = false
}

const closeProfileMenu = (): void => {
  isProfileMenuOpen.value = false
}

const onDocumentPointerDown = (event: PointerEvent): void => {
  if (!(event.target instanceof Node)) return
  if (isManageOpen.value && !manageRef.value?.contains(event.target)) closeManage()
  if (isCampusOpen.value && !campusRef.value?.contains(event.target)) closeCampus()
  if (isContestOpen.value && !contestRef.value?.contains(event.target)) closeContest()
  if (isProfileMenuOpen.value && !profileMenuRef.value?.contains(event.target)) closeProfileMenu()
}

const onWindowKeydown = (event: KeyboardEvent): void => {
  if (event.key !== 'Escape') return
  if (isManageOpen.value) closeManage()
  if (isCampusOpen.value) closeCampus()
  if (isContestOpen.value) closeContest()
  if (isProfileMenuOpen.value) closeProfileMenu()
  if (isMenuOpen.value) isMenuOpen.value = false
}

const toggleTheme = (): void => {
  isDark.value = applyThemeToggle() === 'dark'
}

watch(
  () => route.fullPath,
  () => {
    closeManage()
    closeCampus()
    closeContest()
    closeProfileMenu()
    isMenuOpen.value = false
  },
)

watch(
  () => authStore.user?.id,
  (id) => {
    if (id && canBrowseAssignments.value) void classStore.ensureLoadedFor(id)
  },
  { immediate: true },
)

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
      <RouterLink class="nav-forum" to="/forum">论坛</RouterLink>
      <div
        v-if="authStore.isAuthenticated"
        ref="contestRef"
        class="nav-menu nav-contest"
        :class="{ 'is-active': isContestArea }"
      >
        <button
          type="button"
          aria-haspopup="menu"
          aria-controls="contest-menu-panel"
          :aria-expanded="isContestOpen"
          @click="isContestOpen = !isContestOpen"
        >
          赛事<span class="nav-caret" aria-hidden="true"></span>
        </button>
        <div
          v-if="isContestOpen"
          id="contest-menu-panel"
          class="nav-menu-panel"
          role="menu"
          aria-label="赛事"
        >
          <RouterLink role="menuitem" to="/contests" @click="closeContest">竞赛</RouterLink>
          <RouterLink role="menuitem" to="/contests/rankings" @click="closeContest">
            排行榜
          </RouterLink>
        </div>
      </div>
      <div
        v-if="canBrowseAssignments"
        ref="campusRef"
        class="nav-menu nav-campus"
        :class="{ 'is-active': isCampusArea }"
      >
        <button
          type="button"
          aria-haspopup="menu"
          aria-controls="campus-menu-panel"
          :aria-expanded="isCampusOpen"
          @click="isCampusOpen = !isCampusOpen"
        >
          校园<span class="nav-caret" aria-hidden="true"></span>
        </button>
        <div
          v-if="isCampusOpen"
          id="campus-menu-panel"
          class="nav-menu-panel"
          role="menu"
          aria-label="校园"
        >
          <RouterLink role="menuitem" to="/classes" @click="closeCampus">
            我的组织
          </RouterLink>
          <RouterLink
            v-if="hasClasses"
            role="menuitem"
            to="/profile/assignments"
            @click="closeCampus"
          >
            我的作业
          </RouterLink>
          <span
            v-else
            role="menuitem"
            class="nav-menu-disabled"
            aria-disabled="true"
            title="加入组织后可查看作业"
          >
            我的作业
          </span>
        </div>
      </div>
      <div
        v-if="authStore.isAuthenticated"
        ref="profileMenuRef"
        class="nav-menu nav-profile-menu"
        :class="{ 'is-active': isProfileArea }"
      >
        <button
          type="button"
          aria-haspopup="menu"
          aria-controls="profile-menu-panel"
          :aria-expanded="isProfileMenuOpen"
          @click="isProfileMenuOpen = !isProfileMenuOpen"
        >
          个人<span class="nav-caret" aria-hidden="true"></span>
        </button>
        <div
          v-if="isProfileMenuOpen"
          id="profile-menu-panel"
          class="nav-menu-panel"
          role="menu"
          aria-label="个人"
        >
          <RouterLink role="menuitem" to="/profile" @click="closeProfileMenu">个人界面</RouterLink>
          <RouterLink role="menuitem" to="/profile/favorites" @click="closeProfileMenu">
            个人收藏
          </RouterLink>
        </div>
      </div>
      <RouterLink v-if="authStore.isTeacher" class="nav-teacher-problems" to="/teacher/problems">出题</RouterLink>
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
          <RouterLink role="menuitem" to="/admin/events" @click="closeManage">赛事管理</RouterLink>
          <RouterLink role="menuitem" to="/admin/forum" @click="closeManage">论坛管理</RouterLink>
          <RouterLink role="menuitem" to="/admin/users" @click="closeManage">用户管理</RouterLink>
          <RouterLink role="menuitem" to="/admin/notifications" @click="closeManage">通知管理</RouterLink>
        </div>
      </div>
    </nav>

    <div class="header-actions">
      <NavSearch />
      <NotificationBell />
      <button class="icon-button" type="button" :aria-label="isDark ? '切换至浅色模式' : '切换至深色模式'" @click="toggleTheme">
        <svg v-if="isDark" viewBox="0 0 24 24" aria-hidden="true"><path d="M12 3v2m0 14v2M3 12h2m14 0h2m-2.64-6.36-1.41 1.41M7.05 16.95l-1.41 1.41m0-12.72 1.41 1.41m9.9 9.9 1.41 1.41M15.5 12a3.5 3.5 0 1 1-7 0 3.5 3.5 0 0 1 7 0Z" /></svg>
        <svg v-else viewBox="0 0 24 24" aria-hidden="true"><path d="M20.1 15.1A8.5 8.5 0 0 1 8.9 3.9 8.5 8.5 0 1 0 20.1 15.1Z" /></svg>
      </button>
      <template v-if="authStore.isAuthenticated">
        <button
          class="avatar-button"
          type="button"
          :aria-label="`用户菜单：${authStore.user?.username ?? ''}（${roleLabel}）`"
          aria-haspopup="menu"
          :aria-expanded="isMenuOpen"
          @click="isMenuOpen = !isMenuOpen"
        >
          <img v-if="authStore.user?.avatarUrl" :src="authStore.user.avatarUrl" :alt="authStore.user.username" />
          <template v-else>{{ userInitial }}</template>
          <span class="avatar-role-badge" :class="roleKey" aria-hidden="true" :title="`当前身份：${roleLabel}`">
            {{ roleShort }}
          </span>
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
