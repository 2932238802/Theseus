<script setup lang="ts">
import { computed, nextTick, onMounted, ref } from 'vue'
import MarkdownBody from '../components/MarkdownBody.vue'
import NavBar from '../components/NavBar.vue'
import { toErrorMessage } from '../api/client'
import { toast } from '../store/toast'
import {
  changeAdminCommentStatus,
  changeAdminPostStatus,
  decideAdminReport,
  fetchAdminForumPost,
  fetchAdminForumPosts,
  fetchAdminReports,
  muteForumUser,
  pinAdminForumPost,
  unmuteForumUser,
} from '../api/forum'
import type {
  AdminForumPostDetail,
  AdminForumPostSummary,
  AdminReport,
  AdminReportTargetPreview,
  ForumBoard,
  ForumStatus,
  ReportStatus,
} from '../types/forum'
import { REPORT_REASON_LABELS, FORUM_TAG_LABELS } from '../types/forum'
import {
  FORUM_STATUS_LABELS,
  REPORT_STATUS_LABELS,
  formatForumDateTime,
  formatForumTime,
} from '../utils/forum'

type Tab = 'reports' | 'content'
type ReportFilter = ReportStatus | 'all'
type ContentFilter = ForumStatus | 'all'

const REPORT_FILTERS: Array<{ code: ReportFilter; label: string }> = [
  { code: 'pending', label: '待处理' },
  { code: 'resolved', label: '已隐藏' },
  { code: 'rejected', label: '已驳回' },
  { code: 'all', label: '全部' },
]
const CONTENT_FILTERS: Array<{ code: ContentFilter; label: string }> = [
  { code: 'all', label: '全部状态' },
  { code: 'published', label: '已发布' },
  { code: 'hidden', label: '已隐藏' },
  { code: 'deleted', label: '已删除' },
]
const MUTE_DURATIONS = [
  { value: '24', label: '24 小时' },
  { value: '72', label: '3 天' },
  { value: '168', label: '7 天' },
  { value: '720', label: '30 天' },
  { value: 'permanent', label: '永久' },
]
const PAGE_SIZE = 20

const tab = ref<Tab>('reports')
const actionError = ref('')
const busyKey = ref('')

const reports = ref<AdminReport[]>([])
const reportTotal = ref(0)
const pendingReportTotal = ref(0)
const reportPage = ref(1)
const reportFilter = ref<ReportFilter>('pending')
const reportsLoading = ref(false)
const reportsError = ref('')

const posts = ref<AdminForumPostSummary[]>([])
const contentTotal = ref(0)
const contentPage = ref(1)
const contentFilter = ref<ContentFilter>('all')
const contentBoard = ref<ForumBoard | 'all'>('all')
const contentQuery = ref('')
const contentAuthor = ref('')
const contentLoading = ref(false)
const contentError = ref('')

const detailOpen = ref(false)
const detail = ref<AdminForumPostDetail | null>(null)
const detailLoading = ref(false)
const detailError = ref('')
const detailPostId = ref<number | null>(null)

const muteOpen = ref(false)
const muteTarget = ref<{ id: number; username: string } | null>(null)
const muteDuration = ref('24')
const muteReason = ref('')
const muteError = ref('')
const muteSubmitting = ref(false)

let reportSequence = 0
let contentSequence = 0
let detailSequence = 0

const reportPageCount = computed(() =>
  Math.max(1, Math.ceil(reportTotal.value / PAGE_SIZE)),
)
const contentPageCount = computed(() =>
  Math.max(1, Math.ceil(contentTotal.value / PAGE_SIZE)),
)
const pendingCount = computed(() => pendingReportTotal.value)

const loadReports = async (page = reportPage.value): Promise<void> => {
  const requestId = ++reportSequence
  reportsLoading.value = true
  reportsError.value = ''
  try {
    const result = await fetchAdminReports({
      page,
      size: PAGE_SIZE,
      status: reportFilter.value,
    })
    if (requestId !== reportSequence) return
    if (result.total > 0 && result.reports.length === 0 && page > 1) {
      await loadReports(Math.max(1, Math.ceil(result.total / PAGE_SIZE)))
      return
    }
    reports.value = result.reports
    reportTotal.value = result.total
    pendingReportTotal.value = result.pendingTotal
    reportPage.value = result.total > 0 ? result.page : 1
  } catch (exception: unknown) {
    if (requestId !== reportSequence) return
    reports.value = []
    reportTotal.value = 0
    reportsError.value = toErrorMessage(exception)
  } finally {
    if (requestId === reportSequence) reportsLoading.value = false
  }
}

const loadContent = async (page = contentPage.value): Promise<void> => {
  const requestId = ++contentSequence
  contentLoading.value = true
  contentError.value = ''
  try {
    const result = await fetchAdminForumPosts({
      page,
      size: PAGE_SIZE,
      status: contentFilter.value === 'all' ? undefined : contentFilter.value,
      board: contentBoard.value === 'all' ? undefined : contentBoard.value,
      q: contentQuery.value.trim() || undefined,
      author: contentAuthor.value.trim() || undefined,
    })
    if (requestId !== contentSequence) return
    if (result.total > 0 && result.posts.length === 0 && page > 1) {
      await loadContent(Math.max(1, Math.ceil(result.total / PAGE_SIZE)))
      return
    }
    posts.value = result.posts
    contentTotal.value = result.total
    contentPage.value = result.total > 0 ? result.page : 1
  } catch (exception: unknown) {
    if (requestId !== contentSequence) return
    posts.value = []
    contentTotal.value = 0
    contentError.value = toErrorMessage(exception)
  } finally {
    if (requestId === contentSequence) contentLoading.value = false
  }
}

const setReportFilter = (filter: ReportFilter): void => {
  reportFilter.value = filter
  void loadReports(1)
}

const applyContentFilters = (): void => {
  void loadContent(1)
}

const resetContentFilters = (): void => {
  contentFilter.value = 'all'
  contentBoard.value = 'all'
  contentQuery.value = ''
  contentAuthor.value = ''
  void loadContent(1)
}

const refreshAll = async (): Promise<void> => {
  actionError.value = ''
  await Promise.all([loadReports(reportPage.value), loadContent(contentPage.value)])
}

const askReason = (message: string): string | null => {
  const value = window.prompt(message)
  if (value === null) return null
  const reason = value.trim()
  if (!reason) {
    actionError.value = '隐藏内容时必须填写原因'
    return null
  }
  return reason
}

const loadDetail = async (postId: number): Promise<void> => {
  const requestId = ++detailSequence
  detailPostId.value = postId
  detailLoading.value = true
  detailError.value = ''
  try {
    const result = await fetchAdminForumPost(postId)
    if (requestId !== detailSequence) return
    detail.value = result
  } catch (exception: unknown) {
    if (requestId !== detailSequence) return
    detail.value = null
    detailError.value = toErrorMessage(exception)
  } finally {
    if (requestId === detailSequence) detailLoading.value = false
  }
}

const scrollToDetailComment = async (commentId: number): Promise<void> => {
  await nextTick()
  document
    .getElementById(`admin-comment-${commentId}`)
    ?.scrollIntoView({ block: 'center' })
}

const openDetail = async (postId: number, commentId?: number): Promise<void> => {
  detailOpen.value = true
  detail.value = null
  await loadDetail(postId)
  if (commentId !== undefined) await scrollToDetailComment(commentId)
}

const closeDetail = (): void => {
  detailSequence += 1
  detailOpen.value = false
  detail.value = null
  detailError.value = ''
  detailPostId.value = null
}

const refreshDetailIfOpen = async (postId: number): Promise<void> => {
  if (detailOpen.value && detailPostId.value === postId) await loadDetail(postId)
}

const changePostStatus = async (
  post: AdminForumPostSummary,
  next: ForumStatus,
): Promise<void> => {
  if (busyKey.value) return
  let reason: string | undefined
  if (next === 'hidden') {
    const value = askReason(`隐藏帖子 #${post.id} 请填写原因`)
    if (value === null) return
    reason = value
  }
  if (next === 'deleted' && !window.confirm(`确定删除帖子「${post.title}」吗？删除后不可恢复`)) return
  actionError.value = ''
  busyKey.value = `post-${post.id}`
  try {
    const result = await changeAdminPostStatus(post.id, next, reason)
    toast.success(result.message)
    await Promise.all([loadContent(contentPage.value), loadReports(reportPage.value)])
    await refreshDetailIfOpen(post.id)
  } catch (exception: unknown) {
    actionError.value = toErrorMessage(exception)
  } finally {
    busyKey.value = ''
  }
}

const togglePin = async (post: AdminForumPostSummary): Promise<void> => {
  if (busyKey.value) return
  actionError.value = ''
  busyKey.value = `post-${post.id}`
  try {
    const result = await pinAdminForumPost(post.id, !post.isPinned)
    toast.success(result.message || (result.isPinned ? '帖子已置顶' : '帖子已取消置顶'))
    await loadContent(contentPage.value)
    await refreshDetailIfOpen(post.id)
  } catch (exception: unknown) {
    actionError.value = toErrorMessage(exception)
  } finally {
    busyKey.value = ''
  }
}

const changeCommentStatus = async (
  postId: number,
  commentId: number,
  next: ForumStatus,
): Promise<void> => {
  if (busyKey.value) return
  let reason: string | undefined
  if (next === 'hidden') {
    const value = askReason(`隐藏评论 #${commentId} 请填写原因`)
    if (value === null) return
    reason = value
  }
  if (next === 'deleted' && !window.confirm(`确定删除评论 #${commentId} 吗？删除后不可恢复`)) return
  actionError.value = ''
  busyKey.value = `comment-${commentId}`
  try {
    const result = await changeAdminCommentStatus(commentId, next, reason)
    toast.success(result.message)
    await Promise.all([loadContent(contentPage.value), loadDetail(postId)])
    await loadReports(reportPage.value)
  } catch (exception: unknown) {
    actionError.value = toErrorMessage(exception)
  } finally {
    busyKey.value = ''
  }
}

const decideReport = async (report: AdminReport, decision: 'hide' | 'keep'): Promise<void> => {
  if (busyKey.value) return
  const note = window.prompt(
    decision === 'hide' ? '可选：填写处理备注' : '可选：填写驳回备注',
  )
  if (note === null) return
  actionError.value = ''
  busyKey.value = `report-${report.id}`
  try {
    const result = await decideAdminReport(report.id, decision, note.trim() || undefined)
    toast.success(result.message)
    await Promise.all([loadReports(reportPage.value), loadContent(contentPage.value)])
    if (detailOpen.value && detailPostId.value !== null) await loadDetail(detailPostId.value)
  } catch (exception: unknown) {
    actionError.value = toErrorMessage(exception)
  } finally {
    busyKey.value = ''
  }
}

const locateReportTarget = async (report: AdminReport): Promise<void> => {
  tab.value = 'content'
  if (report.targetType === 'post') {
    await openDetail(report.targetId)
    return
  }
  if (report.targetPreview.postId !== null) {
    await openDetail(report.targetPreview.postId, report.targetId)
    return
  }
  // 评论所属帖子已被彻底删除时后端拿不到 post_id，退化为按标题筛选
  contentFilter.value = 'all'
  contentQuery.value = report.targetPreview.title ?? ''
  await loadContent(1)
}

const openMute = (author: { id: number; username: string }): void => {
  muteTarget.value = { id: author.id, username: author.username }
  muteDuration.value = '24'
  muteReason.value = ''
  muteError.value = ''
  muteOpen.value = true
}

const closeMute = (): void => {
  muteOpen.value = false
  muteTarget.value = null
  muteError.value = ''
}

const submitMute = async (): Promise<void> => {
  if (!muteTarget.value) return
  const reason = muteReason.value.trim()
  if (!reason) {
    muteError.value = '请填写禁言原因'
    return
  }
  muteSubmitting.value = true
  muteError.value = ''
  try {
    const result = await muteForumUser(
      muteTarget.value.id,
      muteDuration.value === 'permanent' ? null : Number(muteDuration.value),
      reason,
    )
    toast.success(result.message)
    closeMute()
  } catch (exception: unknown) {
    muteError.value = toErrorMessage(exception)
  } finally {
    muteSubmitting.value = false
  }
}

const unmuteUser = async (author: { id: number; username: string }): Promise<void> => {
  if (!window.confirm(`确定解除用户 ${author.username} 的禁言吗？`)) return
  actionError.value = ''
  try {
    const result = await unmuteForumUser(author.id)
    toast.success(result.message)
  } catch (exception: unknown) {
    actionError.value = toErrorMessage(exception)
  }
}

const previewTitle = (preview: AdminReportTargetPreview): string =>
  preview.title || preview.excerpt || '（内容已不存在）'

const statusClass = (status: string): string => `status-${status}`

const hiddenReasonLabel = (reason: string | null): string =>
  reason === 'report_threshold' ? '举报自动隐藏' : reason === 'moderation' ? '管理员隐藏' : ''

const tagLabel = (tag: string): string =>
  FORUM_TAG_LABELS[tag as keyof typeof FORUM_TAG_LABELS] ?? tag

onMounted(() => {
  void loadReports(1)
  void loadContent(1)
})
</script>

<template>
  <NavBar />
  <main class="admin-forum-page page-shell">
    <header class="forum-page-heading">
      <div>
        <h1>论坛管理</h1>
      </div>
      <button type="button" class="forum-secondary-button" :disabled="reportsLoading || contentLoading" @click="refreshAll">
        刷新
      </button>
    </header>

    <nav class="admin-tabs" aria-label="论坛管理分区">
      <button type="button" :class="{ active: tab === 'reports' }" @click="tab = 'reports'">
        举报队列 <span v-if="pendingCount">{{ pendingCount }}</span>
      </button>
      <button type="button" :class="{ active: tab === 'content' }" @click="tab = 'content'">内容管理</button>
    </nav>

    <p v-if="actionError" class="form-error" role="alert">{{ actionError }}</p>

    <section v-if="tab === 'reports'" class="admin-panel" aria-label="举报队列">
      <div class="admin-panel-toolbar">
        <div class="forum-sort-tabs" role="tablist" aria-label="举报状态">
          <button
            v-for="filter in REPORT_FILTERS"
            :key="filter.code"
            type="button"
            role="tab"
            :aria-selected="reportFilter === filter.code"
            :class="{ active: reportFilter === filter.code }"
            @click="setReportFilter(filter.code)"
          >
            {{ filter.label }}
          </button>
        </div>
        <span class="admin-total">共 {{ reportTotal }} 条</span>
      </div>

      <p v-if="reportsError" class="form-error" role="alert">{{ reportsError }}</p>
      <div v-if="reportsLoading" class="run-note">正在加载举报</div>
      <div v-else-if="reports.length" class="admin-report-list">
        <article v-for="report in reports" :key="report.id" class="admin-report-card">
          <header>
            <div class="admin-report-tags">
              <span :class="['forum-tag', statusClass(report.status)]">
                {{ REPORT_STATUS_LABELS[report.status] }}
              </span>
              <span class="forum-tag">{{ report.targetType === 'post' ? '帖子' : '评论' }}</span>
              <span class="forum-tag">{{ REPORT_REASON_LABELS[report.reason] }}</span>
            </div>
            <span class="admin-report-id">#{{ report.id }}</span>
          </header>

          <button type="button" class="admin-report-preview" @click="locateReportTarget(report)">
            <strong>{{ previewTitle(report.targetPreview) }}</strong>
            <span v-if="report.targetPreview.excerpt" class="admin-report-excerpt">{{ report.targetPreview.excerpt }}</span>
            <span>
              被举报人：
              <template v-if="report.targetPreview.author">
                {{ report.targetPreview.author.username }}（{{ report.targetPreview.author.email }}）
              </template>
              <template v-else>未知用户</template>
              · 内容状态：{{ FORUM_STATUS_LABELS[report.targetPreview.status] }}
            </span>
          </button>

          <p v-if="report.detail" class="admin-report-detail">补充说明：{{ report.detail }}</p>

          <div class="admin-report-meta">
            <span>举报人：{{ report.reporter.username }}</span>
            <time :datetime="report.createdAt">{{ formatForumDateTime(report.createdAt) }}</time>
          </div>

          <div v-if="report.status === 'pending'" class="admin-report-actions">
            <button
              type="button"
              class="forum-danger-button"
              :disabled="busyKey === `report-${report.id}`"
              @click="decideReport(report, 'hide')"
            >
              隐藏内容
            </button>
            <button
              type="button"
              class="forum-secondary-button"
              :disabled="busyKey === `report-${report.id}`"
              @click="decideReport(report, 'keep')"
            >
              驳回举报
            </button>
            <button type="button" class="forum-secondary-button" @click="locateReportTarget(report)">定位内容</button>
          </div>
          <p v-else class="admin-resolution">
            处理结果：{{ REPORT_STATUS_LABELS[report.status] }}
            <template v-if="report.resolutionNote"> · {{ report.resolutionNote }}</template>
            <template v-if="report.handledAt"> · {{ formatForumDateTime(report.handledAt) }}</template>
          </p>
        </article>
      </div>
      <div v-else class="empty-state"><p>当前筛选下没有举报</p></div>

      <div v-if="reportTotal > 0" class="pagination">
        <span>第 {{ reportPage }} / {{ reportPageCount }} 页</span>
        <div>
          <button type="button" :disabled="reportPage <= 1" @click="loadReports(reportPage - 1)">← 上一页</button>
          <button type="button" :disabled="reportPage >= reportPageCount" @click="loadReports(reportPage + 1)">下一页 →</button>
        </div>
      </div>
    </section>

    <section v-else class="admin-panel" aria-label="内容管理">
      <form class="admin-content-filters" @submit.prevent="applyContentFilters">
        <label>
          <span>状态</span>
          <select v-model="contentFilter" @change="applyContentFilters">
            <option v-for="filter in CONTENT_FILTERS" :key="filter.code" :value="filter.code">{{ filter.label }}</option>
          </select>
        </label>
        <label>
          <span>板块</span>
          <select v-model="contentBoard" @change="applyContentFilters">
            <option value="all">全部板块</option>
            <option value="general">综合</option>
            <option value="interview">面经</option>
          </select>
        </label>
        <label>
          <span>关键词</span>
          <input v-model="contentQuery" type="search" maxlength="100" placeholder="标题或正文" />
        </label>
        <label>
          <span>作者</span>
          <input v-model="contentAuthor" type="search" maxlength="100" placeholder="用户名" />
        </label>
        <button type="submit" class="primary-button">筛选</button>
        <button type="button" class="forum-secondary-button" @click="resetContentFilters">重置</button>
      </form>

      <p v-if="contentError" class="form-error" role="alert">{{ contentError }}</p>
      <div v-if="contentLoading" class="run-note">正在加载内容</div>
      <div v-else-if="posts.length" class="admin-content-list">
        <article v-for="post in posts" :key="post.id" class="admin-content-card">
          <header>
            <div class="admin-content-title">
              <span :class="['forum-tag', statusClass(post.status)]">{{ FORUM_STATUS_LABELS[post.status] }}</span>
              <span v-if="post.board === 'interview'" class="forum-board-badge">面经</span>
              <span v-if="post.isPinned" class="forum-tag">置顶</span>
              <button type="button" @click="openDetail(post.id)">#{{ post.id }} {{ post.title }}</button>
            </div>
            <span v-if="post.pendingReportCount" class="admin-pending-badge">
              {{ post.pendingReportCount }} 条待处理举报
            </span>
          </header>

          <p class="admin-content-excerpt">{{ post.excerpt }}</p>

          <div class="admin-content-meta">
            <span>
              作者：{{ post.author.username }}（{{ post.author.email }}）
              <span v-if="post.isAnonymous" class="admin-anonymous-badge">匿名发布</span>
            </span>
            <span>点赞 {{ post.likeCount }} · 收藏 {{ post.favoriteCount }} · 评论 {{ post.commentCount }}</span>
            <span>发布于 {{ formatForumDateTime(post.createdAt) }}</span>
            <span v-if="post.hiddenAt">
              {{ hiddenReasonLabel(post.hiddenReason) }}于 {{ formatForumDateTime(post.hiddenAt) }}
            </span>
          </div>

          <div class="admin-content-actions">
            <button type="button" class="forum-secondary-button" @click="openDetail(post.id)">查看详情</button>
            <button
              v-if="post.status === 'published'"
              type="button"
              class="forum-secondary-button"
              :disabled="busyKey === `post-${post.id}`"
              @click="changePostStatus(post, 'hidden')"
            >
              隐藏
            </button>
            <button
              v-if="post.status === 'hidden'"
              type="button"
              class="forum-secondary-button"
              :disabled="busyKey === `post-${post.id}`"
              @click="changePostStatus(post, 'published')"
            >
              恢复
            </button>
            <button
              v-if="post.status === 'published'"
              type="button"
              class="forum-secondary-button"
              :disabled="busyKey === `post-${post.id}`"
              @click="togglePin(post)"
            >
              {{ post.isPinned ? '取消置顶' : '置顶' }}
            </button>
            <button
              v-if="post.status !== 'deleted'"
              type="button"
              class="forum-danger-button"
              :disabled="busyKey === `post-${post.id}`"
              @click="changePostStatus(post, 'deleted')"
            >
              删除
            </button>
            <button type="button" class="forum-secondary-button" @click="openMute(post.author)">禁言作者</button>
            <button type="button" class="forum-secondary-button" @click="unmuteUser(post.author)">解除禁言</button>
          </div>
        </article>
      </div>
      <div v-else class="empty-state"><p>没有匹配的内容</p></div>

      <div v-if="contentTotal > 0" class="pagination">
        <span>共 {{ contentTotal }} 条 · 第 {{ contentPage }} / {{ contentPageCount }} 页</span>
        <div>
          <button type="button" :disabled="contentPage <= 1" @click="loadContent(contentPage - 1)">← 上一页</button>
          <button type="button" :disabled="contentPage >= contentPageCount" @click="loadContent(contentPage + 1)">下一页 →</button>
        </div>
      </div>
    </section>

    <div v-if="detailOpen" class="modal-backdrop" @click.self="closeDetail">
      <section class="forum-dialog admin-detail-dialog" role="dialog" aria-modal="true" aria-labelledby="admin-detail-title">
        <header>
          <div>
            <h2 id="admin-detail-title">
              {{ detail ? `#${detail.post.id} ${detail.post.title}` : '内容详情' }}
            </h2>
            <p v-if="detail">帖子状态：{{ FORUM_STATUS_LABELS[detail.post.status] }} · 真实作者：{{ detail.post.author.username }}（{{ detail.post.author.email }}）</p>
          </div>
          <button type="button" aria-label="关闭" @click="closeDetail">×</button>
        </header>

        <div class="forum-dialog-body">
          <p v-if="detailLoading" class="run-note">正在加载详情</p>
          <p v-else-if="detailError" class="form-error" role="alert">{{ detailError }}</p>
          <template v-else-if="detail">
            <p v-if="actionError" class="form-error" role="alert">{{ actionError }}</p>
                    <div class="admin-detail-meta">
              <span v-if="detail.post.isAnonymous" class="admin-anonymous-badge">前台匿名</span>
              <span v-for="tag in detail.post.tags" :key="tag" class="forum-tag">{{ tagLabel(tag) }}</span>
              <span>点赞 {{ detail.post.likeCount }}</span>
              <span>收藏 {{ detail.post.favoriteCount }}</span>
              <span>评论 {{ detail.post.commentCount }}</span>
              <span>待处理举报 {{ detail.post.pendingReportCount }}</span>
            </div>

            <div class="admin-detail-actions">
              <button
                v-if="detail.post.status === 'published'"
                type="button"
                class="forum-secondary-button"
                :disabled="Boolean(busyKey)"
                @click="changePostStatus(detail.post, 'hidden')"
              >
                隐藏帖子
              </button>
              <button
                v-if="detail.post.status === 'hidden'"
                type="button"
                class="forum-secondary-button"
                :disabled="Boolean(busyKey)"
                @click="changePostStatus(detail.post, 'published')"
              >
                恢复帖子
              </button>
              <button
                v-if="detail.post.status === 'published'"
                type="button"
                class="forum-secondary-button"
                :disabled="Boolean(busyKey)"
                @click="togglePin(detail.post)"
              >
                {{ detail.post.isPinned ? '取消置顶' : '置顶' }}
              </button>
              <button
                v-if="detail.post.status !== 'deleted'"
                type="button"
                class="forum-danger-button"
                :disabled="Boolean(busyKey)"
                @click="changePostStatus(detail.post, 'deleted')"
              >
                删除帖子
              </button>
              <button type="button" class="forum-secondary-button" @click="openMute(detail.post.author)">禁言作者</button>
              <button type="button" class="forum-secondary-button" @click="unmuteUser(detail.post.author)">解除禁言</button>
            </div>

            <MarkdownBody :content="detail.bodyMd" />

            <h3 class="admin-detail-comments-title">全部评论（{{ detail.comments.length }}）</h3>
            <div v-if="detail.comments.length" class="admin-detail-comments">
              <article
                v-for="comment in detail.comments"
                :id="`admin-comment-${comment.id}`"
                :key="comment.id"
                class="admin-detail-comment"
              >
                <header>
                  <strong>#{{ comment.id }} {{ comment.author.username }}</strong>
                  <span>{{ comment.author.email }}</span>
                  <span v-if="comment.isAnonymous" class="admin-anonymous-badge">匿名</span>
                  <span :class="['forum-tag', statusClass(comment.status)]">{{ FORUM_STATUS_LABELS[comment.status] }}</span>
                  <span v-if="comment.pendingReportCount" class="admin-pending-badge">{{ comment.pendingReportCount }} 举报</span>
                </header>
                <p v-if="comment.parentId" class="admin-detail-reply">
                  楼层 {{ comment.parentId }}<template v-if="comment.replyToCommentId"> · 回复 #{{ comment.replyToCommentId }}</template>
                </p>
                <MarkdownBody :content="comment.bodyMd" />
                <div class="admin-comment-actions">
                  <button
                    v-if="comment.status === 'published'"
                    type="button"
                    :disabled="busyKey === `comment-${comment.id}`"
                    @click="changeCommentStatus(detail.post.id, comment.id, 'hidden')"
                  >
                    隐藏
                  </button>
                  <button
                    v-if="comment.status === 'hidden'"
                    type="button"
                    :disabled="busyKey === `comment-${comment.id}`"
                    @click="changeCommentStatus(detail.post.id, comment.id, 'published')"
                  >
                    恢复
                  </button>
                  <button
                    v-if="comment.status !== 'deleted'"
                    type="button"
                    class="danger"
                    :disabled="busyKey === `comment-${comment.id}`"
                    @click="changeCommentStatus(detail.post.id, comment.id, 'deleted')"
                  >
                    删除
                  </button>
                  <span>{{ formatForumTime(comment.createdAt) }}</span>
                </div>
              </article>
            </div>
            <p v-else class="run-note">还没有评论</p>
          </template>
        </div>
      </section>
    </div>

    <div v-if="muteOpen && muteTarget" class="modal-backdrop" @click.self="closeMute">
      <section class="forum-dialog admin-mute-dialog" role="dialog" aria-modal="true" aria-labelledby="mute-dialog-title">
        <header>
          <div>
            <h2 id="mute-dialog-title">禁言用户</h2>
            <p>{{ muteTarget.username }}（ID {{ muteTarget.id }}）将无法发帖和评论</p>
          </div>
          <button type="button" aria-label="关闭" @click="closeMute">×</button>
        </header>
        <div class="forum-dialog-body">
          <label class="forum-field">
            <span>禁言时长</span>
            <select v-model="muteDuration">
              <option v-for="option in MUTE_DURATIONS" :key="option.value" :value="option.value">{{ option.label }}</option>
            </select>
          </label>
          <label class="forum-field">
            <span>禁言原因</span>
            <textarea v-model="muteReason" rows="3" maxlength="500" placeholder="必填 用户会收到通知"></textarea>
          </label>
          <p v-if="muteError" class="form-error" role="alert">{{ muteError }}</p>
        </div>
        <footer>
          <button type="button" class="forum-secondary-button" @click="closeMute">取消</button>
          <button type="button" class="forum-danger-button" :disabled="muteSubmitting" @click="submitMute">
            {{ muteSubmitting ? '提交中' : '确认禁言' }}
          </button>
        </footer>
      </section>
    </div>
  </main>
</template>
