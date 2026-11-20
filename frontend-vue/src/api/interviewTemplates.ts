import { type ApiEnvelope, unwrap } from './client'
import { http } from './http'
import { number, record, text } from './parse'

/** 读者端左侧列表项，正文按需加载。 */
export interface InterviewTemplateSummary {
  id: number
  title: string
  sortOrder: number
  updatedAt: string
}

/** 详情或管理端条目，包含 Markdown 正文。 */
export interface InterviewTemplateDetail extends InterviewTemplateSummary {
  contentMd: string
  createdAt: string
}

/** 写接口沿用后端的 snake_case 字段。 */
export interface InterviewTemplateInput {
  title: string
  content_md: string
}

export interface InterviewTemplateMutation {
  id: number
  message: string
}

const mapSummary = (value: unknown): InterviewTemplateSummary => {
  const item = record(value)
  return {
    id: number(item.id),
    title: text(item.title),
    sortOrder: number(item.sort_order),
    updatedAt: text(item.updated_at),
  }
}

const mapDetail = (value: unknown): InterviewTemplateDetail => {
  const item = record(value)
  return {
    ...mapSummary(item),
    contentMd: text(item.content_md),
    createdAt: text(item.created_at),
  }
}

const mapList = <T>(value: unknown, mapper: (entry: unknown) => T): T[] =>
  Array.isArray(value) ? value.map(mapper) : []

export const listInterviewTemplates = async (): Promise<InterviewTemplateSummary[]> => {
  const data = await unwrap(http.get<ApiEnvelope<unknown>>('/forum/interview/templates'))
  return mapList(data, mapSummary)
}

export const getInterviewTemplate = async (id: number): Promise<InterviewTemplateDetail> => {
  const data = await unwrap(http.get<ApiEnvelope<unknown>>(`/forum/interview/templates/${id}`))
  return mapDetail(data)
}

export const listAdminInterviewTemplates = async (): Promise<InterviewTemplateDetail[]> => {
  const data = await unwrap(http.get<ApiEnvelope<unknown>>('/admin/interview/templates'))
  return mapList(data, mapDetail)
}

export const createInterviewTemplate = async (
  payload: InterviewTemplateInput,
): Promise<InterviewTemplateDetail> => {
  const data = await unwrap(http.post<ApiEnvelope<unknown>>('/admin/interview/templates', payload))
  return mapDetail(data)
}

export const updateInterviewTemplate = async (
  id: number,
  payload: InterviewTemplateInput,
): Promise<InterviewTemplateDetail> => {
  const data = await unwrap(
    http.put<ApiEnvelope<unknown>>(`/admin/interview/templates/${id}`, payload),
  )
  return mapDetail(data)
}

export const deleteInterviewTemplate = async (id: number): Promise<InterviewTemplateMutation> => {
  const data = await unwrap(http.delete<ApiEnvelope<unknown>>(`/admin/interview/templates/${id}`))
  const item = record(data)
  return {
    id: number(item.id, id),
    message: text(item.message, '模板已删除'),
  }
}

export const reorderInterviewTemplates = async (
  ids: number[],
): Promise<{ message: string }> => {
  const data = await unwrap(
    http.put<ApiEnvelope<unknown>>('/admin/interview/templates/order', { ids }),
  )
  const item = record(data)
  return { message: text(item.message, '模板顺序已更新') }
}
