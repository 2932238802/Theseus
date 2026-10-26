import { createRouter, createWebHistory } from 'vue-router'
import { useAuthStore } from '../store/auth'
import AdminForumPage from '../views/AdminForumPage.vue'
import AdminProblemsPage from '../views/AdminProblemsPage.vue'
import AdminUsersPage from '../views/AdminUsersPage.vue'
import AssignmentComposePage from '../views/AssignmentComposePage.vue'
import AssignmentDetailPage from '../views/AssignmentDetailPage.vue'
import ClassDetailPage from '../views/ClassDetailPage.vue'
import ClassesPage from '../views/ClassesPage.vue'
import ForumComposePage from '../views/ForumComposePage.vue'
import ForumPage from '../views/ForumPage.vue'
import ForumPostPage from '../views/ForumPostPage.vue'
import ForgotPasswordPage from '../views/ForgotPasswordPage.vue'
import GradebookPage from '../views/GradebookPage.vue'
import IndexPage from '../views/IndexPage.vue'
import LoginAndRegisterPage from '../views/LoginAndRegisterPage.vue'
import NotFoundPage from '../views/NotFoundPage.vue'
import NotificationsPage from '../views/NotificationsPage.vue'
import OjPage from '../views/OjPage.vue'
import ProblemsPage from '../views/ProblemsPage.vue'
import ProfilePage from '../views/ProfilePage.vue'
import RankingsPage from '../views/RankingsPage.vue'
import ResetPasswordPage from '../views/ResetPasswordPage.vue'
import TeacherProblemComposePage from '../views/TeacherProblemComposePage.vue'
import TeacherProblemsPage from '../views/TeacherProblemsPage.vue'
import VerifyEmailPage from '../views/VerifyEmailPage.vue'

const router = createRouter({
  history: createWebHistory(),
  scrollBehavior: () => ({ top: 0 }),
  routes: [
    { path: '/', name: 'home', component: IndexPage },
    { path: '/login', name: 'login', component: LoginAndRegisterPage, meta: { guestOnly: true } },
    { path: '/verify-email', name: 'verify-email', component: VerifyEmailPage },
    { path: '/forgot-password', name: 'forgot-password', component: ForgotPasswordPage },
    { path: '/reset-password', name: 'reset-password', component: ResetPasswordPage },
    { path: '/problems', name: 'problems', component: ProblemsPage },
    { path: '/problem/:id', name: 'problem', component: OjPage, props: true },
    { path: '/profile', name: 'profile', component: ProfilePage, meta: { requiresAuth: true } },
    { path: '/rankings', name: 'rankings', component: RankingsPage },
    { path: '/forum', name: 'forum', component: ForumPage },
    { path: '/forum/new', name: 'forum-compose', component: ForumComposePage, meta: { requiresAuth: true } },
    { path: '/forum/:id', name: 'forum-post', component: ForumPostPage },
    { path: '/notifications', name: 'notifications', component: NotificationsPage, meta: { requiresAuth: true } },
    {
      path: '/classes',
      name: 'classes',
      component: ClassesPage,
      meta: { requiresAuth: true, requiresTeaching: true },
    },
    {
      path: '/classes/:id',
      name: 'class-detail',
      component: ClassDetailPage,
      meta: { requiresAuth: true, requiresTeaching: true },
    },
    {
      path: '/classes/:id/assignments/new',
      name: 'assignment-new',
      component: AssignmentComposePage,
      meta: { requiresAuth: true, requiresTeacher: true },
    },
    {
      path: '/assignments/:id',
      name: 'assignment-detail',
      component: AssignmentDetailPage,
      meta: { requiresAuth: true, requiresTeaching: true },
    },
    {
      path: '/assignments/:id/edit',
      name: 'assignment-edit',
      component: AssignmentComposePage,
      meta: { requiresAuth: true, requiresTeacher: true },
    },
    {
      path: '/assignments/:id/grade',
      name: 'assignment-grade',
      component: GradebookPage,
      meta: { requiresAuth: true, requiresTeacher: true },
    },
    {
      path: '/teacher/problems',
      name: 'teacher-problems',
      component: TeacherProblemsPage,
      meta: { requiresAuth: true, requiresTeacher: true },
    },
    {
      path: '/teacher/problems/new',
      name: 'teacher-problem-new',
      component: TeacherProblemComposePage,
      meta: { requiresAuth: true, requiresTeacher: true },
    },
    {
      path: '/teacher/problems/:id/edit',
      name: 'teacher-problem-edit',
      component: TeacherProblemComposePage,
      meta: { requiresAuth: true, requiresTeacher: true },
    },
    {
      path: '/admin/problems',
      name: 'admin-problems',
      component: AdminProblemsPage,
      meta: { requiresAuth: true, requiresAdmin: true },
    },
    {
      path: '/admin/forum',
      name: 'admin-forum',
      component: AdminForumPage,
      meta: { requiresAuth: true, requiresAdmin: true },
    },
    {
      path: '/admin/users',
      name: 'admin-users',
      component: AdminUsersPage,
      meta: { requiresAuth: true, requiresAdmin: true },
    },
    { path: '/:pathMatch(.*)*', name: 'not-found', component: NotFoundPage },
  ],
})

router.beforeEach((to) => {
  const authStore = useAuthStore()
  if (to.meta.requiresAuth && !authStore.isAuthenticated) {
    return { name: 'login', query: { redirect: to.fullPath } }
  }
  if (to.meta.requiresTeaching && !authStore.isStudent && !authStore.isTeacher) {
    return { name: 'home' }
  }
  if (to.meta.requiresStudent && !authStore.isStudent) return { name: 'home' }
  if (to.meta.requiresTeacher && !authStore.isTeacher) return { name: 'home' }
  if (to.meta.requiresAdmin && !authStore.isAdmin) return { name: 'home' }
  if (to.meta.guestOnly && authStore.isAuthenticated) return { name: 'home' }
  return true
})

export default router
