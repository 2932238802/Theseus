<script setup lang="ts">
import { nextTick, onBeforeUnmount, onMounted, ref } from 'vue'

const emit = defineEmits<{
  close: []
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
        tabindex="-1"
        @keydown.esc.stop="close"
      >
        <button class="accepted-dialog-close" type="button" aria-label="关闭" @click="close">
          ×
        </button>

        <div class="accepted-emblem" aria-hidden="true"><span>✓</span></div>
        <p id="accepted-title" class="accepted-eyebrow">Accepted</p>
      </section>
    </div>
  </Teleport>
</template>
