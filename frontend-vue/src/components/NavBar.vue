<script setup lang="ts">
import { computed, onBeforeUnmount, onMounted, ref, watch } from 'vue'
import { RouterLink, useRoute, useRouter } from 'vue-router'
import NotificationBell from './NotificationBell.vue'
import NavSearch from './NavSearch.vue'
import { fetchCurrentUser } from '../api/auth'
import { toErrorMessage } from '../api/client'
import { uploadAvatar } from '../api/profile'
import { useAuthStore } from '../store/auth'
import { useClassStore } from '../store/classes'
import { isDarkTheme, toggleTheme as applyThemeToggle } from '../utils/theme'

const authStore = useAuthStore()
const classStore = useClassStore()
const router = useRouter()
const route = useRoute()
const isMenuOpen = ref(false)
const isDark = ref(isDarkTheme())
const avatarInput = ref<HTMLInputElement | null>(null)
const avatarBusy = ref(false)
const avatarError = ref('')

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
const isLearnOpen = ref(false)
const learnRef = ref<HTMLElement | null>(null)
const isShopOpen = ref(false)
const shopRef = ref<HTMLElement | null>(null)
const isProfileMenuOpen = ref(false)
const profileMenuRef = ref<HTMLElement | null>(null)
const isCampusArea = computed(() =>
  ['/classes', '/assignments', '/campus'].some(
    (prefix) => route.path === prefix || route.path.startsWith(`${prefix}/`),
  ) || route.path === '/profile/assignments',
)
const isLearnArea = computed(
  () =>
    route.path === '/contests' ||
    route.path.startsWith('/contests/') ||
    route.path === '/knowledge' ||
    route.path.startsWith('/knowledge/') ||
    route.path === '/personal/knowledge',
)
const isShopArea = computed(
  () => route.path === '/shop' || route.path.startsWith('/shop/'),
)
const isProfileArea = computed(
  () =>
    (route.path === '/profile' ||
      route.path.startsWith('/profile/') ||
      route.path === '/personal' ||
      route.path.startsWith('/personal/')) &&
    route.path !== '/profile/assignments' &&
    route.path !== '/personal/knowledge',
)

const closeManage = (): void => {
  isManageOpen.value = false
}

const closeCampus = (): void => {
  isCampusOpen.value = false
}

const closeLearn = (): void => {
  isLearnOpen.value = false
}

const closeShop = (): void => {
  isShopOpen.value = false
}

const closeProfileMenu = (): void => {
  isProfileMenuOpen.value = false
}

const onDocumentPointerDown = (event: PointerEvent): void => {
  if (!(event.target instanceof Node)) return
  if (isManageOpen.value && !manageRef.value?.contains(event.target)) closeManage()
  if (isCampusOpen.value && !campusRef.value?.contains(event.target)) closeCampus()
  if (isLearnOpen.value && !learnRef.value?.contains(event.target)) closeLearn()
  if (isShopOpen.value && !shopRef.value?.contains(event.target)) closeShop()
  if (isProfileMenuOpen.value && !profileMenuRef.value?.contains(event.target)) closeProfileMenu()
}

const onWindowKeydown = (event: KeyboardEvent): void => {
  if (event.key !== 'Escape') return
  if (isManageOpen.value) closeManage()
  if (isCampusOpen.value) closeCampus()
  if (isLearnOpen.value) closeLearn()
  if (isShopOpen.value) closeShop()
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
    closeLearn()
    closeShop()
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

const chooseAvatar = (): void => {
  avatarError.value = ''
  avatarInput.value?.click()
}

const onAvatarChange = async (event: Event): Promise<void> => {
  const target = event.target as HTMLInputElement
  const file = target.files?.[0]
  target.value = ''
  if (!file || avatarBusy.value) return
  if (!['image/jpeg', 'image/png', 'image/webp'].includes(file.type)) {
    avatarError.value = '只支持 JPG、PNG、WebP'
    return
  }
  if (file.size > 2 * 1024 * 1024) {
    avatarError.value = '头像不能超过 2 MB'
    return
  }
  avatarBusy.value = true
  avatarError.value = ''
  try {
    await uploadAvatar(file)
    const user = await fetchCurrentUser()
    authStore.updateUser(user)
    isMenuOpen.value = false
  } catch (exception: unknown) {
    avatarError.value = toErrorMessage(exception)
  } finally {
    avatarBusy.value = false
  }
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
        ref="learnRef"
        class="nav-menu nav-contest"
        :class="{ 'is-active': isLearnArea }"
      >
        <button
          type="button"
          aria-haspopup="menu"
          aria-controls="learn-menu-panel"
          :aria-expanded="isLearnOpen"
          @click="isLearnOpen = !isLearnOpen"
        >
          学习<span class="nav-caret" aria-hidden="true"></span>
        </button>
        <div
          v-if="isLearnOpen"
          id="learn-menu-panel"
          class="nav-menu-panel"
          role="menu"
          aria-label="学习"
        >
          <RouterLink role="menuitem" to="/contests" @click="closeLearn">竞赛</RouterLink>
          <RouterLink role="menuitem" to="/contests/rankings" @click="closeLearn">
            排行榜
          </RouterLink>
          <RouterLink
            role="menuitem"
            to="/knowledge/408"
            title="Plus Theseus 专享 · 正文需开通"
            @click="closeLearn"
          >
            408
            <span class="nav-vip-badge">VIP</span>
          </RouterLink>
          <RouterLink
            role="menuitem"
            to="/knowledge/interview"
            title="Plus Theseus 专享 · 正文需开通"
            @click="closeLearn"
          >
            面经
            <span class="nav-vip-badge">VIP</span>
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
          <RouterLink
            v-if="authStore.isTeacher"
            role="menuitem"
            to="/campus/anticheat"
            @click="closeCampus"
          >
            作弊复核
          </RouterLink>
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
          <RouterLink
            v-if="canBrowseAssignments"
            role="menuitem"
            to="/personal/problems"
            @click="closeProfileMenu"
          >
            个人出题
          </RouterLink>
          <RouterLink
            v-if="canBrowseAssignments"
            role="menuitem"
            to="/personal/knowledge"
            @click="closeProfileMenu"
          >
            我的投稿
          </RouterLink>
          <RouterLink role="menuitem" to="/profile/favorites" @click="closeProfileMenu">
            个人收藏
          </RouterLink>
          <RouterLink
            v-if="authStore.isStudent"
            role="menuitem"
            to="/profile/appeals"
            @click="closeProfileMenu"
          >
            我的申诉
          </RouterLink>
        </div>
      </div>
      <div
        v-if="canBrowseAssignments"
        ref="shopRef"
        class="nav-menu nav-shop"
        :class="{ 'is-active': isShopArea }"
      >
        <button
          type="button"
          aria-haspopup="menu"
          aria-controls="shop-menu-panel"
          :aria-expanded="isShopOpen"
          @click="isShopOpen = !isShopOpen"
        >
          商店<span class="nav-caret" aria-hidden="true"></span>
        </button>
        <div
          v-if="isShopOpen"
          id="shop-menu-panel"
          class="nav-menu-panel"
          role="menu"
          aria-label="商店"
        >
          <RouterLink role="menuitem" to="/shop" @click="closeShop">
            升级为 Plus Theseus
          </RouterLink>
        </div>
      </div>
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
          <RouterLink role="menuitem" to="/admin/knowledge" @click="closeManage">
            408 与面经
          </RouterLink>
          <RouterLink role="menuitem" to="/admin/users" @click="closeManage">用户管理</RouterLink>
          <RouterLink role="menuitem" to="/admin/notifications" @click="closeManage">通知管理</RouterLink>
          <RouterLink role="menuitem" to="/admin/audit" @click="closeManage">审计日志</RouterLink>
          <RouterLink role="menuitem" to="/admin/plus-applications" @click="closeManage">
            Plus 申请
          </RouterLink>
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
          <RouterLink v-if="canBrowseAssignments" to="/personal/problems" @click="isMenuOpen = false">个人出题</RouterLink>
          <RouterLink to="/profile" @click="isMenuOpen = false">个人界面</RouterLink>
          <button type="button" :disabled="avatarBusy" @click="chooseAvatar">
            {{ avatarBusy ? '上传中…' : '更改头像' }}
          </button>
          <input
            ref="avatarInput"
            class="visually-hidden"
            type="file"
            accept="image/jpeg,image/png,image/webp"
            hidden
            @change="onAvatarChange"
          />
          <p v-if="avatarError" class="user-menu-error" role="alert">{{ avatarError }}</p>
          <button type="button" @click="logout">退出登录</button>
        </div>
      </template>
      <RouterLink v-else class="header-login" to="/login">登录</RouterLink>
    </div>
  </header>
</template>
