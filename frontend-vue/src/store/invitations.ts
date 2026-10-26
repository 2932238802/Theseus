import { defineStore } from 'pinia'
import { ref } from 'vue'
import { toErrorMessage } from '../api/client'
import {
  acceptInvitation,
  declineInvitation,
  fetchMyInvitations,
} from '../api/invitations'
import type { InvitationMutationResult, MyInvitation } from '../types/teaching'

export const useInvitationStore = defineStore('invitations', () => {
  const invitations = ref<MyInvitation[]>([])
  const isLoading = ref(false)
  const error = ref('')
  const actingId = ref<number | null>(null)

  let sequence = 0

  const load = async (): Promise<void> => {
    const requestId = ++sequence
    isLoading.value = true
    error.value = ''
    try {
      const result = await fetchMyInvitations()
      if (requestId !== sequence) return
      invitations.value = result
    } catch (exception: unknown) {
      if (requestId !== sequence) return
      error.value = toErrorMessage(exception)
      invitations.value = []
    } finally {
      if (requestId === sequence) isLoading.value = false
    }
  }

  const respond = async (
    id: number,
    action: 'accept' | 'decline',
  ): Promise<InvitationMutationResult> => {
    actingId.value = id
    try {
      const result =
        action === 'accept' ? await acceptInvitation(id) : await declineInvitation(id)
      invitations.value = invitations.value.filter((item) => item.id !== id)
      return result
    } finally {
      actingId.value = null
    }
  }

  const accept = (id: number): Promise<InvitationMutationResult> => respond(id, 'accept')
  const decline = (id: number): Promise<InvitationMutationResult> => respond(id, 'decline')

  const reset = (): void => {
    sequence += 1
    invitations.value = []
    isLoading.value = false
    error.value = ''
    actingId.value = null
  }

  return {
    invitations,
    isLoading,
    error,
    actingId,
    load,
    accept,
    decline,
    reset,
  }
})
