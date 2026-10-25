import { defineStore } from 'pinia'
import { ref } from 'vue'
import {
  addClassMember,
  archiveClass,
  createClass,
  fetchClass,
  fetchClasses,
  joinClass,
  leaveClass,
  removeClassMember,
  rotateInviteCode,
} from '../api/classes'
import { toErrorMessage } from '../api/client'
import type { ClassDetail, ClassSummary } from '../types/teaching'

export const useClassStore = defineStore('classes', () => {
  const classes = ref<ClassSummary[]>([])
  const current = ref<ClassDetail | null>(null)
  const isLoading = ref(false)
  const isDetailLoading = ref(false)
  const error = ref('')
  const detailError = ref('')

  let listSequence = 0
  let detailSequence = 0

  const loadClasses = async (): Promise<void> => {
    const sequence = ++listSequence
    isLoading.value = true
    error.value = ''
    try {
      const result = await fetchClasses()
      if (sequence !== listSequence) return
      classes.value = result
    } catch (exception: unknown) {
      if (sequence !== listSequence) return
      error.value = toErrorMessage(exception)
    } finally {
      if (sequence === listSequence) isLoading.value = false
    }
  }

  const loadClass = async (id: number): Promise<void> => {
    const sequence = ++detailSequence
    isDetailLoading.value = true
    detailError.value = ''
    current.value = null
    try {
      const result = await fetchClass(id)
      if (sequence !== detailSequence) return
      current.value = result
    } catch (exception: unknown) {
      if (sequence !== detailSequence) return
      detailError.value = toErrorMessage(exception)
    } finally {
      if (sequence === detailSequence) isDetailLoading.value = false
    }
  }

  const refreshCurrent = async (): Promise<void> => {
    if (current.value) await loadClass(current.value.id)
  }

  const create = async (...args: Parameters<typeof createClass>): Promise<ClassDetail> => {
    const result = await createClass(...args)
    await loadClasses()
    return result
  }

  const join = async (inviteCode: string): Promise<ClassSummary> => {
    const result = await joinClass(inviteCode)
    await loadClasses()
    return result
  }

  const addMember = async (classId: number, identifier: string): Promise<void> => {
    await addClassMember(classId, identifier)
    await refreshCurrent()
  }

  const removeMember = async (classId: number, userId: number): Promise<void> => {
    await removeClassMember(classId, userId)
    await refreshCurrent()
  }

  const leave = async (classId: number): Promise<void> => {
    await leaveClass(classId)
    current.value = null
    await loadClasses()
  }

  const rotateCode = async (classId: number): Promise<string> => {
    const code = await rotateInviteCode(classId)
    await refreshCurrent()
    return code
  }

  const archive = async (classId: number): Promise<void> => {
    await archiveClass(classId)
    await Promise.all([loadClasses(), refreshCurrent()])
  }

  const reset = (): void => {
    classes.value = []
    current.value = null
    error.value = ''
    detailError.value = ''
  }

  return {
    classes,
    current,
    isLoading,
    isDetailLoading,
    error,
    detailError,
    loadClasses,
    loadClass,
    create,
    join,
    addMember,
    removeMember,
    leave,
    rotateCode,
    archive,
    refreshCurrent,
    reset,
  }
})
