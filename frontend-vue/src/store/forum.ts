import { defineStore } from 'pinia'
import { computed, ref } from 'vue'
import { toErrorMessage } from '../api/client'
import { followUser, unfollowUser, fetchFeedCounts } from '../api/social'
import {
  deleteForumComment,
  deleteForumPost,
  favoriteForumPost,
  fetchForumComments,
  fetchForumInterviewFacets,
  fetchForumPost,
  fetchForumPosts,
  fetchForumReplies,
  likeForumPost,
  updateForumComment,
} from '../api/forum'
import type {
  ForumBoard,
  ForumComment,
  ForumInterviewFacets,
  ForumPostDetail,
  ForumPostListQuery,
  ForumPostSummary,
  ForumReply,
  ForumScope,
  ForumSort,
} from '../types/forum'
import type { FeedCounts } from '../types/social'

export const useForumStore = defineStore('forum', () => {
  const posts = ref<ForumPostSummary[]>([])
  const total = ref(0)
  const isLoading = ref(false)
  const error = ref('')
  const query = ref<ForumPostListQuery>({ page: 1, size: 20, sort: 'latest' })
  const facets = ref<ForumInterviewFacets>({ companies: [], roles: [] })
  const feedCounts = ref<FeedCounts>({ following: 0, school: 0 })

  const currentPost = ref<ForumPostDetail | null>(null)
  const postLoading = ref(false)
  const postError = ref('')

  const comments = ref<ForumComment[]>([])
  const commentsTotal = ref(0)
  const commentsPage = ref(1)
  const commentsSize = ref(20)
  const commentsLoading = ref(false)
  const commentsError = ref('')

  let listSequence = 0
  let detailSequence = 0
  let commentsSequence = 0

  const pageCount = computed(() => Math.max(1, Math.ceil(total.value / query.value.size)))

  const loadPosts = async (): Promise<void> => {
    const requestId = ++listSequence
    isLoading.value = true
    error.value = ''
    try {
      const result = await fetchForumPosts(query.value)
      if (requestId !== listSequence) return
      if (result.total > 0 && result.posts.length === 0 && query.value.page > 1) {
        const lastPage = Math.max(1, Math.ceil(result.total / query.value.size))
        if (lastPage !== query.value.page) {
          query.value.page = lastPage
          void loadPosts()
        }
        return
      }
      posts.value = result.posts
      total.value = result.total
    } catch (exception: unknown) {
      if (requestId !== listSequence) return
      posts.value = []
      total.value = 0
      error.value = toErrorMessage(exception)
    } finally {
      if (requestId === listSequence) isLoading.value = false
    }
  }

  const applyFilters = (): void => {
    query.value.page = 1
    void loadPosts()
  }

  const setTag = (tag: string): void => {
    query.value.tag = tag
    applyFilters()
  }

  const setBoard = (board: ForumBoard): void => {
    if (query.value.board === board) return
    query.value.board = board
    query.value.tag = undefined
    query.value.company = undefined
    query.value.role = undefined
    applyFilters()
    void loadFacets()
  }

  const loadFacets = async (): Promise<void> => {
    if (query.value.board !== 'interview') {
      facets.value = { companies: [], roles: [] }
      return
    }
    try {
      facets.value = await fetchForumInterviewFacets()
    } catch {
      facets.value = { companies: [], roles: [] }
    }
  }

  const setCompany = (company: string): void => {
    query.value.company = company || undefined
    applyFilters()
  }

  const setRole = (role: string): void => {
    query.value.role = role || undefined
    applyFilters()
  }

  const setSort = (sort: ForumSort): void => {
    query.value.sort = sort
    applyFilters()
  }

  const setSearch = (keyword: string): void => {
    query.value.q = keyword.trim() || undefined
    applyFilters()
  }

  const setMine = (mine: boolean): void => {
    query.value.mine = mine
    if (mine) query.value.scope = undefined
    applyFilters()
  }

  const setScope = (scope: ForumScope): void => {
    if ((query.value.scope ?? 'all') === scope) return
    query.value.scope = scope === 'all' ? undefined : scope
    if (scope !== 'all') query.value.mine = undefined
    applyFilters()
  }

  const loadFeedCounts = async (): Promise<void> => {
    try {
      feedCounts.value = await fetchFeedCounts()
    } catch {
      feedCounts.value = { following: 0, school: 0 }
    }
  }

  const toggleAuthorFollow = async (post: ForumPostSummary): Promise<void> => {
    const author = post.author
    if (!author.id || author.isSelf || author.isAnonymous) return
    const next = !author.isFollowing
    author.isFollowing = next
    try {
      const following = next ? await followUser(author.id) : await unfollowUser(author.id)
      author.isFollowing = following
      if (!following && query.value.scope === 'following') {
        posts.value = posts.value.filter((item) => item.id !== post.id)
        total.value = Math.max(0, total.value - 1)
      }
    } catch (exception) {
      author.isFollowing = !next
      throw exception
    }
    void loadFeedCounts()
  }

  const setPage = (page: number): void => {
    query.value.page = Math.max(1, page)
    void loadPosts()
  }

  const resetQuery = (): void => {
    query.value = { page: 1, size: 20, sort: 'latest' }
  }

  const loadPost = async (id: number): Promise<void> => {
    const requestId = ++detailSequence
    postLoading.value = true
    postError.value = ''
    currentPost.value = null
    try {
      const detail = await fetchForumPost(id)
      if (requestId !== detailSequence) return
      currentPost.value = detail
    } catch (exception: unknown) {
      if (requestId !== detailSequence) return
      postError.value = toErrorMessage(exception)
    } finally {
      if (requestId === detailSequence) postLoading.value = false
    }
  }

  const loadComments = async (postId: number, page = 1, append = false): Promise<void> => {
    const requestId = ++commentsSequence
    commentsLoading.value = true
    commentsError.value = ''
    try {
      const result = await fetchForumComments(postId, page, commentsSize.value)
      if (requestId !== commentsSequence) return
      if (!append && result.total > 0 && result.comments.length === 0 && page > 1) {
        const lastPage = Math.max(1, Math.ceil(result.total / commentsSize.value))
        if (lastPage !== page) {
          void loadComments(postId, lastPage)
          return
        }
      }
      comments.value = append ? [...comments.value, ...result.comments] : result.comments
      commentsTotal.value = result.total
      commentsPage.value = result.page
    } catch (exception: unknown) {
      if (requestId !== commentsSequence) return
      commentsError.value = toErrorMessage(exception)
      if (!append) comments.value = []
    } finally {
      if (requestId === commentsSequence) commentsLoading.value = false
    }
  }

  const loadMoreReplies = async (rootId: number, page: number): Promise<void> => {
    const comment = comments.value.find((item) => item.id === rootId)
    if (!comment) return
    const requestId = commentsSequence
    try {
      const result = await fetchForumReplies(rootId, page, 20)
      if (requestId !== commentsSequence) return
      const known = new Set(comment.replies.map((reply) => reply.id))
      comment.replies = [
        ...comment.replies,
        ...result.replies.filter((reply) => !known.has(reply.id)),
      ]
      comment.repliesTruncated = comment.replies.length < comment.replyTotal
    } catch (exception: unknown) {
      commentsError.value = toErrorMessage(exception)
    }
  }

  const toggleLike = async (): Promise<void> => {
    const post = currentPost.value
    if (!post) return
    const beforeLiked = post.liked
    const beforeCount = post.likeCount
    post.liked = !beforeLiked
    post.likeCount += post.liked ? 1 : -1
    try {
      const result = await likeForumPost(post.id, post.liked)
      post.liked = result.liked ?? post.liked
      post.likeCount = result.likeCount ?? post.likeCount
    } catch (exception: unknown) {
      post.liked = beforeLiked
      post.likeCount = beforeCount
      throw exception
    }
  }

  const toggleFavorite = async (): Promise<void> => {
    const post = currentPost.value
    if (!post) return
    const beforeFavorited = post.favorited
    const beforeCount = post.favoriteCount
    post.favorited = !beforeFavorited
    post.favoriteCount += post.favorited ? 1 : -1
    try {
      const result = await favoriteForumPost(post.id, post.favorited)
      post.favorited = result.favorited ?? post.favorited
      post.favoriteCount = result.favoriteCount ?? post.favoriteCount
    } catch (exception: unknown) {
      post.favorited = beforeFavorited
      post.favoriteCount = beforeCount
      throw exception
    }
  }

  const removePost = async (id: number): Promise<void> => {
    await deleteForumPost(id)
    if (currentPost.value?.id === id) currentPost.value = null
  }

  const editComment = async (id: number, bodyMd: string): Promise<void> => {
    await updateForumComment(id, bodyMd)
    const apply = (comment: ForumReply): void => {
      if (comment.id === id) {
        comment.bodyMd = bodyMd
        comment.editedAt = new Date().toISOString()
      }
    }
    for (const comment of comments.value) {
      apply(comment)
      comment.replies.forEach(apply)
    }
  }

  const removeComment = async (id: number): Promise<void> => {
    await deleteForumComment(id)
  }

  const clearComments = (): void => {
    comments.value = []
    commentsTotal.value = 0
    commentsPage.value = 1
    commentsError.value = ''
  }

  return {
    posts,
    total,
    isLoading,
    error,
    query,
    facets,
    feedCounts,
    pageCount,
    currentPost,
    postLoading,
    postError,
    comments,
    commentsTotal,
    commentsPage,
    commentsSize,
    commentsLoading,
    commentsError,
    loadPosts,
    applyFilters,
    setBoard,
    setTag,
    setCompany,
    setRole,
    loadFacets,
    setSort,
    setSearch,
    setMine,
    setScope,
    loadFeedCounts,
    toggleAuthorFollow,
    setPage,
    resetQuery,
    loadPost,
    loadComments,
    loadMoreReplies,
    toggleLike,
    toggleFavorite,
    removePost,
    editComment,
    removeComment,
    clearComments,
  }
})
