<script setup lang="ts">
import type { ContestEventCard } from '../types/contest'
import {
  EVENT_TYPE_LABELS,
  eventButtonLabel,
  eventCapacityLabel,
  eventDeadlineLabel,
  eventStatusLabel,
  eventTimeLabel,
  isEventActionDisabled,
} from '../utils/contestEventUi'

defineProps<{
  event: ContestEventCard
  now: number
  busy?: boolean
  showFollow?: boolean
}>()

const emit = defineEmits<{
  open: [event: ContestEventCard]
  action: [event: ContestEventCard]
  follow: [event: ContestEventCard]
}>()
</script>

<template>
  <article
    :class="[
      'contest-event-card',
      { 'is-ineligible': !event.eligible || event.action === 'full' || event.action === 'closed' },
    ]"
  >
    <div class="contest-event-card-head">
      <span :class="['contest-event-status', `is-${event.status}`]">
        {{ eventStatusLabel(event) }}
      </span>
      <span class="teaching-subtle contest-event-organizer">
        {{ event.organizer }} · {{ EVENT_TYPE_LABELS[event.type] }}
      </span>
    </div>
    <h3>
      <button class="contest-event-title" type="button" @click="emit('open', event)">
        {{ event.title }}
      </button>
      <span v-if="event.is_registered" class="contest-event-registered">已报名</span>
    </h3>
    <p class="contest-event-meta">
      {{ event.scope || '公开赛事' }} · {{ eventCapacityLabel(event) }}
    </p>
    <p class="contest-event-time">{{ eventTimeLabel(event, now) }}</p>
    <p v-if="eventDeadlineLabel(event)" class="teaching-subtle">
      {{ eventDeadlineLabel(event) }}
    </p>
    <p v-if="event.ineligible_reason" class="contest-ineligible-reason">
      {{ event.ineligible_reason }}
    </p>
    <div class="contest-event-card-actions">
      <button
        class="forum-secondary-button"
        type="button"
        :disabled="isEventActionDisabled(event) || busy"
        @click="emit('action', event)"
      >
        {{ busy ? '处理中…' : eventButtonLabel(event) }}
      </button>
      <button
        v-if="showFollow"
        class="contest-follow-button"
        type="button"
        :aria-pressed="event.is_followed"
        @click="emit('follow', event)"
      >
        {{ event.is_followed ? '已关注' : '关注' }}
      </button>
    </div>
  </article>
</template>
