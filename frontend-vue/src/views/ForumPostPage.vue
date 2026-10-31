<script setup lang="ts">
import { computed, nextTick, onMounted, ref, watch } from 'vue'
import { useRoute, useRouter } from 'vue-router'
import MarkdownBody from '../components/MarkdownBody.vue'
import NavBar from '../components/NavBar.vue'
import ProblemReferenceCard from '../components/ProblemReferenceCard.vue'
import ReportDialog from '../components/ReportDialog.vue'
import { toErrorMessage } from '../api/client'
import { toast } from '../store/toast'
import { setCommentFavorite } from '../api/favorites'
import { changeAdminCommentStatus, changeAdminPostStatus, createForumComment, pinAdminForumPost } from '../api/forum'
import { useAuthStore } from '../store/auth'
import { useForumStore } from '../store/forum'
import { FORUM_TAG_LABELS } from '../types/forum'
import type { ForumReply } from '../types/forum'
import { formatForumDateTime, formatForumTime } from '../utils/forum'

const route = useRoute()
const router = useRouter()
const authStore = useAuthStore()
const forumStore = useForumStore()

const postId = computed(() => {
  const raw = Array.isArray(route.params.id) ? route.params.id[0] : route.params.id
  const value = Number(raw)
  return Number.isInteger(value) && value > 0 ? value : 0
})

const locked = computed(() => forumStore.postError.includes('Plus'))

const commentBody = ref('')
const commentAnonymous = ref(false)
const commentError = ref('')
const commentSubmitting = ref(false)

const replyRootId = ref<number | null>(null)
const replyTargetId = ref<number | null>(null)
const replyTargetName = ref('')
const replyBody = ref('')
const replyAnonymous = ref(false)
const replyError = ref('')
const replySubmitting = ref(false)

const editingId = ref<number | null>(null)
const editingBody = ref('')
const editError = ref('')

const reportOpen = ref(false)
const reportTarget = ref<{ type: 'post' | 'comment'; id: number } | null>(null)
const actionError = ref('')
const actionBusy = ref(false)
const likeBusy = ref(false)
const favoriteBusy = ref(false)
const commentFavoriteBusy = ref<number | null>(null)

const post = computed(() => forumStore.currentPost)

const toggleCommentFavorite = async (comment: ForumReply): Promise<void> => {
  if (!requireLogin() || commentFavoriteBusy.value !== null) return
  const before = comment.favorited
  comment.favorited = !before
  commentFavoriteBusy.value = comment.id
  actionError.value = ''
  try {
    comment.favorited = await setCommentFavorite(comment.id, comment.favorited)
  } catch (exception: unknown) {
    comment.favorited = before
    actionError.value = toErrorMessage(exception)
  } finally {
    commentFavoriteBusy.value = null
  }
}

const requireLogin = (): boolean => {
  if (authStore.isAuthenticated) return true
  void router.push({ name: 'login', query: { redirect: route.fullPath } })
  return false
}

const scrollToHash = async (): Promise<void> => {
  if (!route.hash) return
  await nextTick()
  const target = document.getElementById(route.hash.slice(1))
  if (target) target.scrollIntoView({ block: 'center' })
}

const reloadThread = async (): Promise<void> => {
  if (!postId.value) return
  await Promise.all([forumStore.loadPost(postId.value), forumStore.loadComments(postId.value)])
  await scrollToHash()
}

const openReply = (rootId: number, targetId: number, targetName: string): void => {
  if (!requireLogin()) return
  replyRootId.value = rootId
  replyTargetId.value = targetId
  replyTargetName.value = targetName
  replyBody.value = ''
  replyError.value = ''
  replyAnonymous.value = false
}

const cancelReply = (): void => {
  replyRootId.value = null
  replyTargetId.value = null
  replyTargetName.value = ''
  replyBody.value = ''
  replyError.value = ''
}

const submitComment = async (): Promise<void> => {
  if (!requireLogin() || !post.value) return
  const body = commentBody.value.trim()
  commentError.value = ''
  if (!body) {
    commentError.value = '评论不能为空'
    return
  }
  if (body.length > 5000) {
    commentError.value = '评论不能超过 5000 个字符'
    return
  }
  commentSubmitting.value = true
  try {
    await createForumComment(post.value.id, {
      body_md: body,
      is_anonymous: commentAnonymous.value,
    })
    commentBody.value = ''
    commentAnonymous.value = false
    await reloadThread()
  } catch (exception: unknown) {
    commentError.value = toErrorMessage(exception)
  } finally {
    commentSubmitting.value = false
  }
}

const submitReply = async (): Promise<void> => {
  if (!requireLogin() || !post.value || replyRootId.value === null || replyTargetId.value === null) return
  const body = replyBody.value.trim()
  replyError.value = ''
  if (!body) {
    replyError.value = '回复不能为空'
    return
  }
  if (body.length > 5000) {
    replyError.value = '回复不能超过 5000 个字符'
    return
  }
  replySubmitting.value = true
  try {
    await createForumComment(post.value.id, {
      body_md: body,
      parent_id: replyRootId.value,
      reply_to_comment_id: replyTargetId.value,
      is_anonymous: replyAnonymous.value,
    })
    cancelReply()
    await reloadThread()
  } catch (exception: unknown) {
    replyError.value = toErrorMessage(exception)
  } finally {
    replySubmitting.value = false
  }
}

const startEdit = (id: number, body: string): void => {
  editingId.value = id
  editingBody.value = body
  editError.value = ''
}

const cancelEdit = (): void => {
  editingId.value = null
  editingBody.value = ''
  editError.value = ''
}

const saveEdit = async (): Promise<void> => {
  if (editingId.value === null) return
  const body = editingBody.value.trim()
  editError.value = ''
  if (!body) {
    editError.value = '评论不能为空'
    return
  }
  try {
    await forumStore.editComment(editingId.value, body)
    cancelEdit()
  } catch (exception: unknown) {
    editError.value = toErrorMessage(exception)
  }
}

const removeComment = async (id: number): Promise<void> => {
  if (!window.confirm('确定删除这条评论吗？删除后无法恢复')) return
  actionError.value = ''
  try {
    await forumStore.removeComment(id)
    await reloadThread()
  } catch (exception: unknown) {
    actionError.value = toErrorMessage(exception)
  }
}

const toggleLike = async (): Promise<void> => {
  if (likeBusy.value || !requireLogin()) return
  actionError.value = ''
  likeBusy.value = true
  try {
    await forumStore.toggleLike()
  } catch (exception: unknown) {
    actionError.value = toErrorMessage(exception)
  } finally {
    likeBusy.value = false
  }
}

const toggleFavorite = async (): Promise<void> => {
  if (favoriteBusy.value || !requireLogin()) return
  actionError.value = ''
  favoriteBusy.value = true
  try {
    await forumStore.toggleFavorite()
  } catch (exception: unknown) {
    actionError.value = toErrorMessage(exception)
  } finally {
    favoriteBusy.value = false
  }
}

const openReport = (type: 'post' | 'comment', id: number): void => {
  if (!requireLogin()) return
  reportTarget.value = { type, id }
  reportOpen.value = true
}

const onReportSubmitted = async (message: string): Promise<void> => {
  reportOpen.value = false
  toast.success(message)
  await reloadThread()
}

const deletePost = async (): Promise<void> => {
  if (!post.value || !window.confirm('确定删除这个帖子吗？删除后无法恢复')) return
  actionError.value = ''
  try {
    await forumStore.removePost(post.value.id)
    await router.push('/forum')
  } catch (exception: unknown) {
    actionError.value = toErrorMessage(exception)
  }
}

const adminHidePost = async (): Promise<void> => {
  if (!post.value) return
  const reason = window.prompt('请输入隐藏原因（必填）')
  if (reason === null) return
  if (!reason.trim()) {
    actionError.value = '隐藏帖子时必须填写原因'
    return
  }
  actionBusy.value = true
  actionError.value = ''
  try {
    await changeAdminPostStatus(post.value.id, 'hidden', reason.trim())
    await router.push('/admin/forum')
  } catch (exception: unknown) {
    actionError.value = toErrorMessage(exception)
  } finally {
    actionBusy.value = false
  }
}

const adminRestorePost = async (): Promise<void> => {
  if (!post.value) return
  actionBusy.value = true
  try {
    await changeAdminPostStatus(post.value.id, 'published')
    await reloadThread()
  } catch (exception: unknown) {
    actionError.value = toErrorMessage(exception)
  } finally {
    actionBusy.value = false
  }
}

const adminDeletePost = async (): Promise<void> => {
  if (!post.value || !window.confirm('管理员删除帖子后不可恢复 确定继续吗？')) return
  actionBusy.value = true
  try {
    await changeAdminPostStatus(post.value.id, 'deleted', '管理员删除')
    await router.push('/forum')
  } catch (exception: unknown) {
    actionError.value = toErrorMessage(exception)
  } finally {
    actionBusy.value = false
  }
}

const adminTogglePin = async (): Promise<void> => {
  if (!post.value) return
  actionBusy.value = true
  try {
    await pinAdminForumPost(post.value.id, !post.value.isPinned)
    await reloadThread()
  } catch (exception: unknown) {
    actionError.value = toErrorMessage(exception)
  } finally {
    actionBusy.value = false
  }
}

const adminHideComment = async (id: number): Promise<void> => {
  const reason = window.prompt('请输入隐藏原因（必填）')
  if (reason === null || !reason.trim()) return
  try {
    await changeAdminCommentStatus(id, 'hidden', reason.trim())
    await reloadThread()
  } catch (exception: unknown) {
    actionError.value = toErrorMessage(exception)
  }
}

const tagLabel = (tag: string): string =>
  FORUM_TAG_LABELS[tag as keyof typeof FORUM_TAG_LABELS] ?? tag

const replyDisplay = (reply: ForumReply, rootId: number): string =>
  reply.replyTo && reply.replyTo.commentId !== rootId
    ? `回复 ${reply.replyTo.displayName}：`
    : ''

const moreReplyPage = (rootId: number): number => {
  const comment = forumStore.comments.find((item) => item.id === rootId)
  return comment ? Math.floor(comment.replies.length / 20) + 1 : 1
}

const loadMoreComments = async (): Promise<void> => {
  if (!postId.value) return
  await forumStore.loadComments(postId.value, forumStore.commentsPage + 1, true)
}

const loadMoreReplies = async (rootId: number): Promise<void> => {
  await forumStore.loadMoreReplies(rootId, moreReplyPage(rootId))
}

watch(
  () => route.params.id,
  () => {
    forumStore.clearComments()
    if (postId.value) void reloadThread()
  },
)

onMounted(() => {
  forumStore.clearComments()
  if (postId.value) void reloadThread()
})
</script>

<template>
  <NavBar />
  <main class="forum-page forum-detail-page page-shell">
    <p v-if="forumStore.postLoading" class="run-note">正在加载帖子</p>
    <section v-else-if="locked" class="forum-locked">
      <h1>面经仅对 Plus Theseus 开放</h1>
      <p>开通后可以查看面经 并在评论区留下答案</p>
      <RouterLink class="primary-button" to="/shop">去开通</RouterLink>
    </section>
    <section v-else-if="!postId || forumStore.postError" class="forum-not-found">
      <h1>帖子不存在或已被删除</h1>
      <p>{{ forumStore.postError || '请检查链接是否正确' }}</p>
      <RouterLink class="primary-button" to="/forum">返回校园墙</RouterLink>
    </section>

    <template v-else-if="post">
      <article class="forum-detail">
        <div v-if="post.status === 'hidden'" class="forum-hidden-warning" role="status">
          该帖子已被隐藏 仅你和管理员可见 {{ post.hiddenReason === 'report_threshold' ? '原因：举报达到阈值' : '原因：管理员操作' }}
        </div>

        <header class="forum-detail-heading">
          <div class="forum-post-card-topline">
            <span v-if="post.isPinned" class="forum-pin-badge">置顶</span>
            <span v-if="post.board === 'interview'" class="forum-board-badge">面经</span>
            <span v-if="post.company" class="forum-tag forum-tag-structured">{{ post.company }}</span>
            <span v-if="post.role" class="forum-tag forum-tag-structured">{{ post.role }}</span>
            <span
              v-for="tag in post.tags.filter((tag) => tag !== post?.company)"
              :key="tag"
              class="forum-tag"
            >{{ tagLabel(tag) }}</span>
          </div>
          <h1>{{ post.title }}</h1>
          <div class="forum-post-card-meta">
            <span :class="{ 'forum-author-anonymous': post.author.isAnonymous }">{{ post.author.displayName }}</span>
            <span v-if="post.author.isPlus" class="forum-plus-badge">Plus</span>
            <span aria-hidden="true">·</span>
            <time v-if="post.interviewDate" :datetime="post.interviewDate">面试 {{ post.interviewDate }}</time>
            <time v-else :datetime="post.createdAt">{{ formatForumTime(post.createdAt) }}</time>
            <span>· 浏览 {{ post.viewCount }}</span>
            <span v-if="post.editedAt">· 已编辑 {{ formatForumDateTime(post.editedAt) }}</span>
          </div>
        </header>

        <ProblemReferenceCard v-if="post.problem" :problem="post.problem" />

        <MarkdownBody class="forum-detail-body" :content="post.bodyMd" />

        <div class="forum-action-row">
          <button v-if="post.status === 'published'" type="button" :class="['forum-action-button', { active: post.liked }]" :disabled="likeBusy" @click="toggleLike">
            ♥ 点赞 <strong>{{ post.likeCount }}</strong>
          </button>
          <button v-if="post.status === 'published'" type="button" :class="['forum-action-button', { active: post.favorited }]" :disabled="favoriteBusy" @click="toggleFavorite">
            ★ 收藏 <strong>{{ post.favoriteCount }}</strong>
          </button>
          <button v-if="post.status === 'published'" type="button" class="forum-action-button" @click="openReport('post', post.id)">举报</button>
          <button
            v-if="post.canEdit"
            type="button"
            class="forum-action-button"
            @click="router.push(`/forum/new?edit=${post.id}`)"
          >
            编辑
          </button>
          <button v-if="post.canDelete" type="button" class="forum-action-button danger" @click="deletePost">删除</button>
          <span class="forum-action-spacer"></span>
          <template v-if="post.canModerate">
            <button v-if="post.status === 'published'" type="button" class="forum-action-button admin" :disabled="actionBusy" @click="adminHidePost">管理员隐藏</button>
            <button v-else-if="post.status === 'hidden'" type="button" class="forum-action-button admin" :disabled="actionBusy" @click="adminRestorePost">管理员恢复</button>
            <button v-if="post.status === 'published'" type="button" class="forum-action-button admin" :disabled="actionBusy" @click="adminTogglePin">
              {{ post.isPinned ? '取消置顶' : '置顶' }}
            </button>
            <button v-if="post.status !== 'deleted'" type="button" class="forum-action-button admin danger" :disabled="actionBusy" @click="adminDeletePost">管理员删除</button>
          </template>
        </div>

        <p v-if="actionError" class="form-error" role="alert">{{ actionError }}</p>
      </article>

      <section class="forum-comments" aria-label="评论">
        <div class="forum-comments-heading">
          <h2>评论 <span>{{ post.commentCount }}</span></h2>
          <p v-if="post.board === 'interview'" class="run-note">答案可以直接写在评论区</p>
        </div>

        <form v-if="authStore.isAuthenticated && post.status === 'published'" class="forum-comment-form" @submit.prevent="submitComment">
          <textarea v-model="commentBody" maxlength="5000" rows="3" placeholder="写下你的评论 支持 Markdown"></textarea>
          <div class="forum-comment-form-actions">
            <label class="forum-checkbox"><input v-model="commentAnonymous" type="checkbox" /> 匿名评论</label>
            <button type="submit" class="primary-button" :disabled="commentSubmitting">
              {{ commentSubmitting ? '发送中' : '发表评论' }}
            </button>
          </div>
          <p v-if="commentError" class="form-error" role="alert">{{ commentError }}</p>
        </form>
        <p v-else-if="post.status !== 'published'" class="forum-login-hint">
          帖子已被隐藏 暂时不能评论
        </p>
        <p v-else class="forum-login-hint">
          <RouterLink :to="{ name: 'login', query: { redirect: route.fullPath } }">登录</RouterLink> 后可以评论
        </p>

        <p v-if="forumStore.commentsError" class="form-error" role="alert">{{ forumStore.commentsError }}</p>
        <div v-if="forumStore.commentsLoading && !forumStore.comments.length" class="run-note">正在加载评论</div>
        <div v-else-if="forumStore.comments.length" class="forum-comment-list">
          <article v-for="comment in forumStore.comments" :id="`comment-${comment.id}`" :key="comment.id" class="forum-comment">
            <div class="forum-comment-main">
              <header class="forum-comment-header">
                <span :class="{ 'forum-author-anonymous': comment.author.isAnonymous }">{{ comment.author.displayName }}</span>
                <span v-if="comment.author.isPlus" class="forum-plus-badge">Plus</span>
                <span v-if="comment.isTombstone" class="forum-tombstone-label">该评论已隐藏</span>
                <time :datetime="comment.createdAt">{{ formatForumTime(comment.createdAt) }}</time>
                <span v-if="comment.editedAt" class="run-note">已编辑</span>
              </header>

              <template v-if="!comment.isTombstone">
                <div v-if="editingId === comment.id" class="forum-inline-editor">
                  <textarea v-model="editingBody" rows="3" maxlength="5000"></textarea>
                  <p v-if="editError" class="form-error">{{ editError }}</p>
                  <div>
                    <button type="button" class="forum-secondary-button" @click="cancelEdit">取消</button>
                    <button type="button" class="primary-button" @click="saveEdit">保存</button>
                  </div>
                </div>
                <MarkdownBody v-else :content="comment.bodyMd" />
              </template>
              <p v-else class="forum-tombstone-text">评论内容已不可见 仅保留楼层结构</p>

              <div class="forum-comment-actions">
                <button v-if="!comment.isTombstone && authStore.isAuthenticated && post.status === 'published'" type="button" @click="openReply(comment.id, comment.id, comment.author.displayName)">回复</button>
                <button
                  v-if="!comment.isTombstone && authStore.isAuthenticated && post.status === 'published'"
                  type="button"
                  :class="{ 'is-favorite': comment.favorited }"
                  :disabled="commentFavoriteBusy === comment.id"
                  @click="toggleCommentFavorite(comment)"
                >
                  {{ comment.favorited ? '★ 已收藏' : '☆ 收藏' }}
                </button>
                <button v-if="comment.canEdit" type="button" @click="startEdit(comment.id, comment.bodyMd)">编辑</button>
                <button v-if="comment.canDelete" type="button" class="danger" @click="removeComment(comment.id)">删除</button>
                <button v-if="!comment.isTombstone && post.status === 'published'" type="button" @click="openReport('comment', comment.id)">举报</button>
                <button v-if="post.canModerate && !comment.isTombstone" type="button" class="admin" @click="adminHideComment(comment.id)">隐藏</button>
              </div>

              <div v-if="replyRootId === comment.id" class="forum-reply-form">
                <span class="forum-reply-target">回复 {{ replyTargetName }}</span>
                <textarea v-model="replyBody" rows="2" maxlength="5000" placeholder="写下你的回复"></textarea>
                <div class="forum-comment-form-actions">
                  <label class="forum-checkbox"><input v-model="replyAnonymous" type="checkbox" /> 匿名回复</label>
                  <button type="button" class="forum-secondary-button" @click="cancelReply">取消</button>
                  <button type="button" class="primary-button" :disabled="replySubmitting" @click="submitReply">
                    {{ replySubmitting ? '发送中' : '回复' }}
                  </button>
                </div>
                <p v-if="replyError" class="form-error" role="alert">{{ replyError }}</p>
              </div>

              <div v-if="comment.replies.length" class="forum-reply-list">
                <article v-for="reply in comment.replies" :id="`comment-${reply.id}`" :key="reply.id" class="forum-reply">
                  <header class="forum-comment-header">
                    <span :class="{ 'forum-author-anonymous': reply.author.isAnonymous }">{{ reply.author.displayName }}</span>
                    <span v-if="reply.author.isPlus" class="forum-plus-badge">Plus</span>
                    <span v-if="reply.replyTo" class="forum-reply-mention">{{ replyDisplay(reply, comment.id) }}</span>
                    <time :datetime="reply.createdAt">{{ formatForumTime(reply.createdAt) }}</time>
                  </header>

                  <template v-if="!reply.isTombstone">
                    <div v-if="editingId === reply.id" class="forum-inline-editor">
                      <textarea v-model="editingBody" rows="2" maxlength="5000"></textarea>
                      <p v-if="editError" class="form-error">{{ editError }}</p>
                      <div>
                        <button type="button" class="forum-secondary-button" @click="cancelEdit">取消</button>
                        <button type="button" class="primary-button" @click="saveEdit">保存</button>
                      </div>
                    </div>
                    <MarkdownBody v-else :content="reply.bodyMd" />
                  </template>

                  <div v-if="!reply.isTombstone" class="forum-comment-actions">
                    <button v-if="authStore.isAuthenticated && post.status === 'published'" type="button" @click="openReply(comment.id, reply.id, reply.author.displayName)">回复</button>
                    <button
                      v-if="authStore.isAuthenticated && post.status === 'published'"
                      type="button"
                      :class="{ 'is-favorite': reply.favorited }"
                      :disabled="commentFavoriteBusy === reply.id"
                      @click="toggleCommentFavorite(reply)"
                    >
                      {{ reply.favorited ? '★ 已收藏' : '☆ 收藏' }}
                    </button>
                    <button v-if="reply.canEdit" type="button" @click="startEdit(reply.id, reply.bodyMd)">编辑</button>
                    <button v-if="reply.canDelete" type="button" class="danger" @click="removeComment(reply.id)">删除</button>
                    <button v-if="post.status === 'published'" type="button" @click="openReport('comment', reply.id)">举报</button>
                    <button v-if="post.canModerate" type="button" class="admin" @click="adminHideComment(reply.id)">隐藏</button>
                  </div>
                </article>
              </div>

              <button
                v-if="comment.repliesTruncated"
                type="button"
                class="forum-more-replies"
                @click="loadMoreReplies(comment.id)"
              >
                加载更多回复（{{ comment.replies.length }} / {{ comment.replyTotal }}）
              </button>
            </div>
          </article>
        </div>
        <button
          v-if="forumStore.comments.length < forumStore.commentsTotal"
          type="button"
          class="forum-load-more"
          :disabled="forumStore.commentsLoading"
          @click="loadMoreComments"
        >
          {{ forumStore.commentsLoading ? '加载中' : `加载更多评论（${forumStore.comments.length} / ${forumStore.commentsTotal}）` }}
        </button>
        <div
          v-else-if="!forumStore.commentsLoading && forumStore.comments.length === 0"
          class="empty-state"
        >
          <p>还没有评论 来坐第一个沙发</p>
        </div>
      </section>
    </template>

    <ReportDialog
      v-if="reportTarget"
      :visible="reportOpen"
      :target-type="reportTarget.type"
      :target-id="reportTarget.id"
      @close="reportOpen = false"
      @submitted="onReportSubmitted"
    />
  </main>
</template>
