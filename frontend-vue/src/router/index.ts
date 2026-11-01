import { createRouter, createWebHistory } from 'vue-router'
import { useAuthStore } from '../store/auth'
import IndexPage from '../views/IndexPage.vue'
import LoginAndRegisterPage from '../views/LoginAndRegisterPage.vue'
const OAuthCallbackPage = () => import('../views/OAuthCallbackPage.vue')

// 页面按路由拆包：首屏只加载首页与登录页，其余页面在跳转时才下载
const AdminAuditPage = () => import('../views/AdminAuditPage.vue')
const AdminContestAppealsPage = () => import('../views/AdminContestAppealsPage.vue')
const AdminEventsPage = () => import('../views/AdminEventsPage.vue')
const AdminForumPage = () => import('../views/AdminForumPage.vue')
const AdminNotifyPage = () => import('../views/AdminNotifyPage.vue')
const AdminPlusApplicationsPage = () => import('../views/AdminPlusApplicationsPage.vue')
const AdminProblemsPage = () => import('../views/AdminProblemsPage.vue')
const AdminSeasonsPage = () => import('../views/AdminSeasonsPage.vue')
const AdminUsersPage = () => import('../views/AdminUsersPage.vue')
const AssignmentComposePage = () => import('../views/AssignmentComposePage.vue')
const AssignmentDetailPage = () => import('../views/AssignmentDetailPage.vue')
const ClassDetailPage = () => import('../views/ClassDetailPage.vue')
const ClassesPage = () => import('../views/ClassesPage.vue')
const ContestPage = () => import('../views/ContestPage.vue')
const ContestProctorPage = () => import('../views/ContestProctorPage.vue')
const ContestEventDetailPage = () => import('../views/ContestEventDetailPage.vue')
const ContestEventsPage = () => import('../views/ContestEventsPage.vue')
const ContestRankedLeaderboardPage = () => import('../views/ContestRankedLeaderboardPage.vue')
const ContestResultPage = () => import('../views/ContestResultPage.vue')
const ContestsPage = () => import('../views/ContestsPage.vue')
const ForumComposePage = () => import('../views/ForumComposePage.vue')
const ForumPage = () => import('../views/ForumPage.vue')
const ForumPostPage = () => import('../views/ForumPostPage.vue')
const ForgotPasswordPage = () => import('../views/ForgotPasswordPage.vue')
const GradebookPage = () => import('../views/GradebookPage.vue')
const MyAssignmentsPage = () => import('../views/MyAssignmentsPage.vue')
const NotFoundPage = () => import('../views/NotFoundPage.vue')
const NotificationsPage = () => import('../views/NotificationsPage.vue')
const OjPage = () => import('../views/OjPage.vue')
const ProblemsPage = () => import('../views/ProblemsPage.vue')
const PersonalProblemComposePage = () => import('../views/PersonalProblemComposePage.vue')
const PersonalProblemsPage = () => import('../views/PersonalProblemsPage.vue')
const ProfilePage = () => import('../views/ProfilePage.vue')
const SettingsPage = () => import('../views/SettingsPage.vue')
const ProfileFavoritesPage = () => import('../views/ProfileFavoritesPage.vue')
const ProfileNotesPage = () => import('../views/ProfileNotesPage.vue')
const ProfileWrongProblemsPage = () => import('../views/ProfileWrongProblemsPage.vue')
const ResetPasswordPage = () => import('../views/ResetPasswordPage.vue')
const ShopPage = () => import('../views/ShopPage.vue')
const StudentAppealsPage = () => import('../views/StudentAppealsPage.vue')
const TeacherCheatReportsPage = () => import('../views/TeacherCheatReportsPage.vue')
const VerifyEmailPage = () => import('../views/VerifyEmailPage.vue')

const router = createRouter({
  history: createWebHistory(),
  scrollBehavior: () => ({ top: 0 }),
  routes: [
    { path: '/', name: 'home', component: IndexPage },
    { path: '/login', name: 'login', component: LoginAndRegisterPage, meta: { guestOnly: true } },
    { path: '/oauth/callback', name: 'oauth-callback', component: OAuthCallbackPage },
    { path: '/verify-email', name: 'verify-email', component: VerifyEmailPage },
    { path: '/forgot-password', name: 'forgot-password', component: ForgotPasswordPage },
    { path: '/reset-password', name: 'reset-password', component: ResetPasswordPage },
    { path: '/problems', name: 'problems', component: ProblemsPage },
    { path: '/problem/:id', name: 'problem', component: OjPage, props: true },
    { path: '/profile', name: 'profile', component: ProfilePage, meta: { requiresAuth: true } },
    { path: '/settings', name: 'settings', component: SettingsPage, meta: { requiresAuth: true } },
    { path: '/profile/favorites', name: 'profile-favorites', component: ProfileFavoritesPage, meta: { requiresAuth: true } },
    { path: '/profile/notes', name: 'profile-notes', component: ProfileNotesPage, meta: { requiresAuth: true } },
    { path: '/profile/wrong-problems', name: 'profile-wrong-problems', component: ProfileWrongProblemsPage, meta: { requiresAuth: true } },
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
