import axios from 'axios'
import { ref } from 'vue'
import { toErrorMessage } from '../api/client'
import {
  getInterviewTemplate,
  listInterviewTemplates,
  type InterviewTemplateDetail,
  type InterviewTemplateSummary,
} from '../api/interviewTemplates'

/** 403 时统一使用中性文案，不暴露会员等级或权益信息。 */
export const TEMPLATE_FORBIDDEN_MESSAGE = '当前账号无法查看该内容'

export const isForbiddenError = (error: unknown): boolean =>
  axios.isAxiosError(error) && error.response?.status === 403

export const templateErrorMessage = (error: unknown): string =>
  isForbiddenError(error) ? TEMPLATE_FORBIDDEN_MESSAGE : toErrorMessage(error)

/**
 * HR 模板入口只在面经板块且选中 HR 面时出现。
 * 综合板块、全部类型以及技术面 / 算法面 / 主管面均不显示。
 */
export const shouldShowHrTemplateEntry = (
  board: string,
  interviewType: string | null | undefined,
): boolean => board === 'interview' && interviewType === 'hr'

/**
 * 读者端模板页状态：左侧列表来自列表接口，右侧正文按需加载。
 * 默认选中第一项；切换时用递增序号丢弃过期响应。
 */
export const useInterviewTemplatesReader = () => {
  const templates = ref<InterviewTemplateSummary[]>([])
  const selectedId = ref<number | null>(null)
  const detail = ref<InterviewTemplateDetail | null>(null)
  const listLoading = ref(false)
  const listError = ref('')
  const detailLoading = ref(false)
  const detailError = ref('')
  const forbidden = ref(false)
  let detailSequence = 0

  const selectTemplate = async (id: number): Promise<void> => {
    if (selectedId.value === id && detail.value?.id === id) return
    selectedId.value = id
    const requestId = ++detailSequence
    detailLoading.value = true
    detailError.value = ''
    try {
      const loaded = await getInterviewTemplate(id)
      if (requestId !== detailSequence) return
      detail.value = loaded
    } catch (exception: unknown) {
      if (requestId !== detailSequence) return
      detail.value = null
      if (isForbiddenError(exception)) {
        forbidden.value = true
      } else {
        detailError.value = templateErrorMessage(exception)
      }
    } finally {
      if (requestId === detailSequence) detailLoading.value = false
    }
  }

  const loadTemplates = async (): Promise<void> => {
    listLoading.value = true
    listError.value = ''
    forbidden.value = false
    try {
      const list = await listInterviewTemplates()
      templates.value = list
      listLoading.value = false
      if (list.length === 0) {
        selectedId.value = null
        detail.value = null
        return
      }
      const stillExists =
        selectedId.value !== null && list.some((item) => item.id === selectedId.value)
      const targetId = stillExists ? (selectedId.value as number) : (list[0] as InterviewTemplateSummary).id
      await selectTemplate(targetId)
    } catch (exception: unknown) {
      templates.value = []
      selectedId.value = null
      detail.value = null
      if (isForbiddenError(exception)) {
        forbidden.value = true
      } else {
        listError.value = templateErrorMessage(exception)
      }
    } finally {
      listLoading.value = false
    }
  }

  return {
    templates,
    selectedId,
    detail,
    listLoading,
    listError,
    detailLoading,
    detailError,
    forbidden,
    loadTemplates,
    selectTemplate,
  }
}
