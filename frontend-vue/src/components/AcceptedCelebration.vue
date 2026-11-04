<script setup lang="ts">
import { nextTick, onBeforeUnmount, onMounted, ref } from 'vue'

defineProps<{
  problemTitle: string
  language: string
  testCasesPassed: number
  totalTestCases: number
  runtime?: string
  memory?: string
  hasNext: boolean
}>()

const emit = defineEmits<{
  close: []
  viewHistory: []
  next: []
}>()

interface ConfettiPiece {
  id: number
  glyph: string
  left: number
  delay: number
  duration: number
  size: number
  drift: number
  spin: number
}

const glyphs = ['🎉', '🎊', '✨', '⭐', '🥳', '💚', '🚀']
const confetti: ConfettiPiece[] = Array.from({ length: 46 }, (_, index) => ({
  id: index,
  glyph: glyphs[index % glyphs.length] ?? '🎉',
  left: (index * 37 + 7) % 100,
  delay: -((index * 0.31) % 5),
  duration: 4.2 + ((index * 13) % 26) / 10,
  size: 17 + ((index * 11) % 22),
  drift: ((index * 47) % 220) - 110,
  spin: ((index * 53) % 760) - 380,
}))

const dialogRef = ref<HTMLElement | null>(null)

const pieceStyle = (piece: ConfettiPiece): string =>
  [
    `left:${piece.left}%`,
    `animation-delay:${piece.delay}s`,
    `animation-duration:${piece.duration}s`,
    `font-size:${piece.size}px`,
    `--confetti-drift:${piece.drift}px`,
    `--confetti-spin:${piece.spin}deg`,
  ].join(';')

const close = (): void => emit('close')

const onWindowKeydown = (event: KeyboardEvent): void => {
  if (event.key !== 'Escape' || event.isComposing) return
  event.preventDefault()
  close()
}

onMounted(() => {
  document.body.classList.add('accepted-celebration-open')
  window.addEventListener('keydown', onWindowKeydown)
  void nextTick(() => dialogRef.value?.focus())
})

onBeforeUnmount(() => {
  document.body.classList.remove('accepted-celebration-open')
  window.removeEventListener('keydown', onWindowKeydown)
})
</script>

<template>
  <Teleport to="body">
    <div class="accepted-celebration" @click.self="close">
      <div class="accepted-celebration-glow" aria-hidden="true"></div>
      <div class="accepted-confetti" aria-hidden="true">
        <span
          v-for="piece in confetti"
          :key="piece.id"
          class="accepted-confetti-piece"
          :style="pieceStyle(piece)"
        >
          {{ piece.glyph }}
        </span>
      </div>

      <section
        ref="dialogRef"
        class="accepted-dialog"
        role="dialog"
        aria-modal="true"
        aria-labelledby="accepted-title"
        aria-describedby="accepted-description"
        tabindex="-1"
        @keydown.esc.stop="close"
      >
        <button class="accepted-dialog-close" type="button" aria-label="关闭" @click="close">
          ×
        </button>

        <div class="accepted-emblem" aria-hidden="true"><span>✓</span></div>
        <p class="accepted-eyebrow">Accepted</p>
        <h2 id="accepted-title">通过全部测试用例</h2>
        <p id="accepted-description" class="accepted-problem">{{ problemTitle }}</p>
        <p class="accepted-message">漂亮！这道题已经被你拿下。</p>

        <dl class="accepted-stats">
          <div>
            <dt>通过用例</dt>
            <dd>{{ testCasesPassed }} / {{ totalTestCases }}</dd>
          </div>
          <div>
            <dt>执行用时</dt>
            <dd>{{ runtime || '—' }}</dd>
          </div>
          <div>
            <dt>内存消耗</dt>
            <dd>{{ memory || '—' }}</dd>
          </div>
          <div>
            <dt>语言</dt>
            <dd>{{ language }}</dd>
          </div>
        </dl>

        <div class="accepted-actions">
          <button v-if="hasNext" class="accepted-primary" type="button" @click="emit('next')">
            挑战下一题 <span aria-hidden="true">→</span>
          </button>
          <button v-else class="accepted-primary" type="button" @click="close">
            继续刷题
          </button>
          <button class="accepted-secondary" type="button" @click="emit('viewHistory')">
            查看提交记录
          </button>
        </div>

        <p class="accepted-hint">按 Esc 关闭</p>
      </section>
    </div>
  </Teleport>
</template>
