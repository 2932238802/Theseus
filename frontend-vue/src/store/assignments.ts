import { defineStore } from 'pinia'
import { ref } from 'vue'
import {
  archiveAssignment,
  createAssignment,
  deleteAssignment,
  fetchAssignment,
  fetchGradebook,
  publishAssignment,
  updateAssignment,
  updateAssignmentProblems,
  type AssignmentPayload,
} from '../api/assignments'
import { toErrorMessage } from '../api/client'
import type { AssignmentDetail, AssignmentProblemInput, Gradebook } from '../types/teaching'

export const useAssignmentStore = defineStore('assignments', () => {
  const current = ref<AssignmentDetail | null>(null)
  const gradebook = ref<Gradebook | null>(null)
  const isLoading = ref(false)
  const isGradebookLoading = ref(false)
  const error = ref('')
  const gradebookError = ref('')

  let detailSequence = 0
  let gradebookSequence = 0

  const loadAssignment = async (id: number): Promise<void> => {
    const sequence = ++detailSequence
    isLoading.value = true
    error.value = ''
    current.value = null
    try {
      const result = await fetchAssignment(id)
      if (sequence !== detailSequence) return
      current.value = result
    } catch (exception: unknown) {
      if (sequence !== detailSequence) return
      error.value = toErrorMessage(exception)
    } finally {
      if (sequence === detailSequence) isLoading.value = false
    }
  }

  const loadGradebook = async (id: number, includeRemoved: boolean): Promise<void> => {
    const sequence = ++gradebookSequence
    isGradebookLoading.value = true
    gradebookError.value = ''
    try {
      const result = await fetchGradebook(id, includeRemoved)
      if (sequence !== gradebookSequence) return
      gradebook.value = result
    } catch (exception: unknown) {
      if (sequence !== gradebookSequence) return
      gradebookError.value = toErrorMessage(exception)
    } finally {
      if (sequence === gradebookSequence) isGradebookLoading.value = false
    }
  }

  const create = async (classId: number, payload: AssignmentPayload): Promise<AssignmentDetail> => {
    const result = await createAssignment(classId, payload)
    current.value = result
    return result
  }

  const update = async (id: number, payload: AssignmentPayload): Promise<AssignmentDetail> => {
    const result = await updateAssignment(id, payload)
    current.value = result
    return result
  }

  const updateProblems = async (
    id: number,
    problems: AssignmentProblemInput[],
  ): Promise<AssignmentDetail> => {
    const result = await updateAssignmentProblems(id, problems)
    current.value = result
    return result
  }

  const publish = async (id: number): Promise<AssignmentDetail> => {
    const result = await publishAssignment(id)
    current.value = result
    return result
  }

  const archive = async (id: number): Promise<AssignmentDetail> => {
    const result = await archiveAssignment(id)
    current.value = result
    return result
  }

  const remove = async (id: number): Promise<void> => {
    await deleteAssignment(id)
    current.value = null
  }

  const reset = (): void => {
    current.value = null
    gradebook.value = null
    error.value = ''
    gradebookError.value = ''
  }

  return {
    current,
    gradebook,
    isLoading,
    isGradebookLoading,
    error,
    gradebookError,
    loadAssignment,
    loadGradebook,
    create,
    update,
    updateProblems,
    publish,
    archive,
    remove,
    reset,
  }
})
