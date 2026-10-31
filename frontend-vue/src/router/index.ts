import { createRouter, createWebHistory } from 'vue-router'
import { useAuthStore } from '../store/auth'
import AdminAuditPage from '../views/AdminAuditPage.vue'
import AdminContestAppealsPage from '../views/AdminContestAppealsPage.vue'
import AdminEventsPage from '../views/AdminEventsPage.vue'
import AdminForumPage from '../views/AdminForumPage.vue'
import AdminNotifyPage from '../views/AdminNotifyPage.vue'
import AdminPlusApplicationsPage from '../views/AdminPlusApplicationsPage.vue'
import AdminProblemsPage from '../views/AdminProblemsPage.vue'
import AdminSeasonsPage from '../views/AdminSeasonsPage.vue'
import AdminUsersPage from '../views/AdminUsersPage.vue'
import AssignmentComposePage from '../views/AssignmentComposePage.vue'
import AssignmentDetailPage from '../views/AssignmentDetailPage.vue'
import ClassDetailPage from '../views/ClassDetailPage.vue'
import ClassesPage from '../views/ClassesPage.vue'
import ContestPage from '../views/ContestPage.vue'
import ContestProctorPage from '../views/ContestProctorPage.vue'
import ContestEventDetailPage from '../views/ContestEventDetailPage.vue'
import ContestEventsPage from '../views/ContestEventsPage.vue'
import ContestRankedLeaderboardPage from '../views/ContestRankedLeaderboardPage.vue'
import ContestResultPage from '../views/ContestResultPage.vue'
import ContestsPage from '../views/ContestsPage.vue'
import ForumComposePage from '../views/ForumComposePage.vue'
import ForumPage from '../views/ForumPage.vue'
import ForumPostPage from '../views/ForumPostPage.vue'
import ForgotPasswordPage from '../views/ForgotPasswordPage.vue'
import GradebookPage from '../views/GradebookPage.vue'
import IndexPage from '../views/IndexPage.vue'
import LoginAndRegisterPage from '../views/LoginAndRegisterPage.vue'
import MyAssignmentsPage from '../views/MyAssignmentsPage.vue'
import NotFoundPage from '../views/NotFoundPage.vue'
import NotificationsPage from '../views/NotificationsPage.vue'
import OjPage from '../views/OjPage.vue'
import ProblemsPage from '../views/ProblemsPage.vue'
import PersonalProblemComposePage from '../views/PersonalProblemComposePage.vue'
import PersonalProblemsPage from '../views/PersonalProblemsPage.vue'
import ProfilePage from '../views/ProfilePage.vue'
import ProfileFavoritesPage from '../views/ProfileFavoritesPage.vue'
import ResetPasswordPage from '../views/ResetPasswordPage.vue'
import ShopPage from '../views/ShopPage.vue'
import StudentAppealsPage from '../views/StudentAppealsPage.vue'
import TeacherCheatReportsPage from '../views/TeacherCheatReportsPage.vue'
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
    { path: '/profile/favorites', name: 'profile-favorites', component: ProfileFavoritesPage, meta: { requiresAuth: true } },
    { path: '/profile/appeals', name: 'profile-appeals', component: StudentAppealsPage, meta: { requiresAuth: true } },
    {
      path: '/profile/assignments',
      name: 'profile-assignments',
      component: MyAssignmentsPage,
      meta: { requiresAuth: true, requiresTeaching: true },
    },
    { path: '/rankings', redirect: { name: 'contest-rankings' } },
    { path: '/contests', name: 'contests', component: ContestsPage, meta: { requiresAuth: true } },
    { path: '/contests/events', name: 'contest-events', component: ContestEventsPage, meta: { requiresAuth: true } },
    { path: '/contests/rankings', name: 'contest-rankings', component: ContestRankedLeaderboardPage, meta: { requiresAuth: true } },
    { path: '/contests/events/:eventId', name: 'contest-event-detail', component: ContestEventDetailPage, meta: { requiresAuth: true } },
    { path: '/contests/:id', name: 'contest', component: ContestPage, meta: { requiresAuth: true } },
    { path: '/contests/:id/proctor', name: 'contest-proctor', component: ContestProctorPage, meta: { requiresAuth: true, requiresAdmin: true } },
    { path: '/contests/:id/result', name: 'contest-result', component: ContestResultPage, meta: { requiresAuth: true } },
    { path: '/knowledge/interview', redirect: { path: '/forum', query: { board: 'interview' } } },
    { path: '/knowledge/new', redirect: '/forum/new' },
    { path: '/knowledge/:id(\\d+)', redirect: '/forum' },
    { path: '/knowledge/:id(\\d+)/edit', redirect: '/forum' },
    { path: '/personal/knowledge', redirect: '/forum' },
    { path: '/forum', name: 'forum', component: ForumPage },
    {
      path: '/shop',
      name: 'shop',
      component: ShopPage,
      meta: { requiresAuth: true, requiresTeaching: true },
    },
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
      path: '/personal/problems',
      name: 'personal-problems',
      component: PersonalProblemsPage,
      meta: { requiresAuth: true, requiresTeaching: true },
    },
    {
      path: '/personal/problems/new',
      name: 'personal-problem-new',
      component: PersonalProblemComposePage,
      meta: { requiresAuth: true, requiresTeaching: true },
    },
    {
      path: '/personal/problems/:id/edit',
      name: 'personal-problem-edit',
      component: PersonalProblemComposePage,
      meta: { requiresAuth: true, requiresTeaching: true },
    },
    {
      path: '/campus/anticheat',
      name: 'campus-anticheat',
      component: TeacherCheatReportsPage,
      meta: { requiresAuth: true, requiresTeacher: true },
    },
    { path: '/teacher/problems', redirect: { name: 'personal-problems' } },
    { path: '/teacher/problems/new', redirect: { name: 'personal-problem-new' } },
    {
      path: '/teacher/problems/:id/edit',
      redirect: (to) => ({ name: 'personal-problem-edit', params: to.params }),
    },
    { path: '/teacher/anticheat', redirect: { name: 'campus-anticheat' } },
    {
      path: '/admin/problems',
      name: 'admin-problems',
      component: AdminProblemsPage,
      meta: { requiresAuth: true, requiresAdmin: true },
    },
    {
      path: '/admin/events',
      name: 'admin-events',
      component: AdminEventsPage,
      meta: { requiresAuth: true, requiresAdmin: true },
    },
    {
      path: '/admin/seasons',
      name: 'admin-seasons',
      component: AdminSeasonsPage,
      meta: { requiresAuth: true, requiresAdmin: true },
    },
    {
      path: '/admin/contest-appeals',
      name: 'admin-contest-appeals',
      component: AdminContestAppealsPage,
      meta: { requiresAuth: true, requiresAdmin: true },
    },
    {
      path: '/admin/forum',
      name: 'admin-forum',
      component: AdminForumPage,
      meta: { requiresAuth: true, requiresAdmin: true },
    },
    { path: '/admin/knowledge', redirect: '/admin/forum' },
    {
      path: '/admin/users',
      name: 'admin-users',
      component: AdminUsersPage,
      meta: { requiresAuth: true, requiresAdmin: true },
    },
    {
      path: '/admin/notifications',
      name: 'admin-notifications',
      component: AdminNotifyPage,
      meta: { requiresAuth: true, requiresAdmin: true },
    },
    {
      path: '/admin/audit',
      name: 'admin-audit',
      component: AdminAuditPage,
      meta: { requiresAuth: true, requiresAdmin: true },
    },
    {
      path: '/admin/plus-applications',
      name: 'admin-plus-applications',
      component: AdminPlusApplicationsPage,
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
