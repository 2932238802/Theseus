import type { CommentFavoriteList, ProblemFavoriteList } from '../types/profile'
import { type ApiEnvelope, unwrap } from './client'
import { http } from './http'
import { bool, nullableNumber, record, text } from './parse'

interface BackendProblemFavorite {
  problem_id: number
  title: string
  difficulty: string
  acceptance_rate: number
  favorited_at: string
}

interface BackendProblemFavoriteList {
  total: number
  page: number
  size: number
  favorites: BackendProblemFavorite[]
}

interface BackendCommentFavorite {
  comment_id: number
  post_id: number
  post_title: string
  parent_id: number | null
  body_md: string
  author: unknown
  created_at: string
  favorited_at: string
}

interface BackendCommentFavoriteList {
  total: number
  page: number
  size: number
  favorites: BackendCommentFavorite[]
}

interface ToggleData {
  favorited: boolean
}

const mapAuthor = (value: unknown) => {
  const item = record(value)
  return {
    displayName: text(item.display_name, '匿名同学'),
    isAnonymous: bool(item.is_anonymous),
    isSelf: bool(item.is_self),
    isPlus: bool(item.is_plus),
  }
}

export const setProblemFavorite = async (id: number, favorited: boolean): Promise<boolean> => {
  const data = favorited
    ? await unwrap(http.post<ApiEnvelope<ToggleData>>(`/problems/${id}/favorite`))
    : await unwrap(http.delete<ApiEnvelope<ToggleData>>(`/problems/${id}/favorite`))
  return data.favorited
}

export const setCommentFavorite = async (id: number, favorited: boolean): Promise<boolean> => {
  const data = favorited
    ? await unwrap(http.post<ApiEnvelope<ToggleData>>(`/forum/comments/${id}/favorite`))
    : await unwrap(http.delete<ApiEnvelope<ToggleData>>(`/forum/comments/${id}/favorite`))
  return data.favorited
}

export const fetchProblemFavorites = async (
  page = 1,
  size = 20,
): Promise<ProblemFavoriteList> => {
  const data = await unwrap(
    http.get<ApiEnvelope<BackendProblemFavoriteList>>('/profile/favorites/problems', {
      params: { page, size },
    }),
  )
  return {
    total: data.total,
    page: data.page,
    size: data.size,
    favorites: data.favorites.map((row) => ({
      problemId: row.problem_id,
      title: row.title,
      difficulty:
        row.difficulty === 'medium' || row.difficulty === 'hard' ? row.difficulty : 'easy',
      acceptanceRate: Number(row.acceptance_rate) || 0,
      favoritedAt: row.favorited_at,
    })),
  }
}

export const fetchCommentFavorites = async (
  page = 1,
  size = 20,
): Promise<CommentFavoriteList> => {
  const data = await unwrap(
    http.get<ApiEnvelope<BackendCommentFavoriteList>>('/profile/favorites/comments', {
      params: { page, size },
    }),
  )
  return {
    total: data.total,
    page: data.page,
    size: data.size,
    favorites: data.favorites.map((row) => ({
      commentId: row.comment_id,
      postId: row.post_id,
      postTitle: row.post_title,
      parentId: nullableNumber(row.parent_id),
      bodyMd: row.body_md,
      author: mapAuthor(row.author),
      createdAt: row.created_at,
      favoritedAt: row.favorited_at,
    })),
  }
}
