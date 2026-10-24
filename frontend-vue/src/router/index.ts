import { createRouter, createWebHistory } from 'vue-router'
import { useAuthStore } from '../store/auth'
import IndexPage from '../views/IndexPage.vue'
import LoginAndRegisterPage from '../views/LoginAndRegisterPage.vue'
import NotFoundPage from '../views/NotFoundPage.vue'
import OjPage from '../views/OjPage.vue'
import ProblemsPage from '../views/ProblemsPage.vue'
import ProfilePage from '../views/ProfilePage.vue'
import RankingsPage from '../views/RankingsPage.vue'

const router = createRouter({
  history: createWebHistory(),
  scrollBehavior: () => ({ top: 0 }),
  routes: [
    { path: '/', name: 'home', component: IndexPage },
    { path: '/login', name: 'login', component: LoginAndRegisterPage, meta: { guestOnly: true } },
    { path: '/problems', name: 'problems', component: ProblemsPage },
    { path: '/problem/:id', name: 'problem', component: OjPage, props: true },
    { path: '/profile', name: 'profile', component: ProfilePage, meta: { requiresAuth: true } },
    { path: '/rankings', name: 'rankings', component: RankingsPage },
    { path: '/:pathMatch(.*)*', name: 'not-found', component: NotFoundPage },
  ],
})

router.beforeEach((to) => {
  const authStore = useAuthStore()
  if (to.meta.requiresAuth && !authStore.isAuthenticated) {
    return { name: 'login', query: { redirect: to.fullPath } }
  }
  if (to.meta.guestOnly && authStore.isAuthenticated) return { name: 'home' }
  return true
})

export default router
