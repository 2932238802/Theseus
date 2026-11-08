<script setup lang="ts">
import DOMPurify from 'dompurify'
import { marked } from 'marked'
import { computed, nextTick, onBeforeUnmount, onMounted, ref, watch } from 'vue'
import { extractMath, renderMathIn } from '../utils/markdownMath'

const props = defineProps<{ content: string }>()

marked.setOptions({ gfm: true, breaks: true })

const ALLOWED_TAGS = [
  'p',
  'br',
  'strong',
  'em',
  'del',
  'blockquote',
  'ul',
  'ol',
  'li',
  'h1',
  'h2',
  'h3',
  'h4',
  'code',
  'pre',
  'a',
  'hr',
  'table',
  'thead',
  'tbody',
  'tr',
  'th',
  'td',
  'img',
]

const rendered = computed(() => {
  const source = props.content ?? ''
  // 公式先抽成占位符，避免 marked 处理掉 LaTeX 反斜杠或拆开多行 $$
  const extraction = extractMath(source)
  const parsed = marked.parse(extraction.markdown, { async: false }) as string
  const clean = DOMPurify.sanitize(parsed, {
    ALLOWED_TAGS,
    ALLOWED_ATTR: ['href', 'title', 'start', 'colspan', 'rowspan', 'src', 'alt'],
    FORBID_TAGS: ['iframe', 'script', 'style', 'form', 'input', 'button', 'svg'],
    FORBID_ATTR: ['style'],
    ALLOW_DATA_ATTR: false,
    ALLOW_UNKNOWN_PROTOCOLS: false,
    ALLOWED_URI_REGEXP: /^(?:(?:https?|mailto):|[^a-z]|[a-z+.-]+(?:[^a-z+.\-:]|$))/i,
  })

  // 统一外链和图片行为；在清洗后再设置属性，避免信任 Markdown 中的原始属性
  const template = document.createElement('template')
  template.innerHTML = String(clean)
  template.content.querySelectorAll('a').forEach((link) => {
    link.setAttribute('target', '_blank')
    link.setAttribute('rel', 'noopener noreferrer')
  })
  template.content.querySelectorAll('img').forEach((image) => {
    const src = image.getAttribute('src') ?? ''
    // 只允许 http(s) 和站内相对路径，其余协议直接移除图片
    if (!/^(?:https?:\/\/|\/)/i.test(src)) {
      image.remove()
      return
    }
    const alt = image.getAttribute('alt') ?? ''
    image.setAttribute('referrerpolicy', 'no-referrer')
    image.setAttribute('loading', 'lazy')
    image.setAttribute('decoding', 'async')
    image.setAttribute('tabindex', '0')
    image.setAttribute('role', 'button')
    image.setAttribute('aria-label', alt ? `查看大图：${alt}` : '查看大图')
  })

  return { html: template.innerHTML, math: extraction.math }
})

const html = computed(() => rendered.value.html)

const containerRef = ref<HTMLElement | null>(null)
let mathRenderId = 0

const renderMath = async (): Promise<void> => {
  const renderId = ++mathRenderId
  await nextTick()
  const container = containerRef.value
  if (!container || renderId !== mathRenderId) return
  // 公式内容变化时占位符与清洗结果可能完全相同，需主动重置后再渲染，避免残留旧公式
  container.innerHTML = rendered.value.html
  await renderMathIn(container, rendered.value.math)
}

watch(rendered, () => {
  void renderMath()
})

onMounted(() => {
  void renderMath()
})

interface ImagePreview {
  src: string
  alt: string
}

const preview = ref<ImagePreview | null>(null)
const previewCloseRef = ref<HTMLButtonElement | null>(null)
let lastFocusedImage: HTMLImageElement | null = null
let previousBodyOverflow = ''

const onPreviewKeydown = (event: KeyboardEvent): void => {
  if (event.key !== 'Escape') return
  event.preventDefault()
  closePreview()
}

const openPreview = async (image: HTMLImageElement): Promise<void> => {
  const src = image.getAttribute('src') ?? ''
  if (!src) return
  lastFocusedImage = image
  preview.value = { src, alt: image.getAttribute('alt') ?? '' }
  previousBodyOverflow = document.body.style.overflow
  document.body.style.overflow = 'hidden'
  window.addEventListener('keydown', onPreviewKeydown)
  await nextTick()
  previewCloseRef.value?.focus()
}

const closePreview = (): void => {
  if (!preview.value) return
  preview.value = null
  document.body.style.overflow = previousBodyOverflow
  window.removeEventListener('keydown', onPreviewKeydown)
  const image = lastFocusedImage
  lastFocusedImage = null
  if (image?.isConnected) image.focus()
}

const onContainerClick = (event: MouseEvent): void => {
  if (!(event.target instanceof HTMLImageElement)) return
  // 图片可能被 Markdown 链接包裹，点击时优先预览而不是打开外链
  if (event.target.closest('a')) event.preventDefault()
  void openPreview(event.target)
}

const onContainerKeydown = (event: KeyboardEvent): void => {
  if (event.key !== 'Enter' && event.key !== ' ') return
  if (!(event.target instanceof HTMLImageElement)) return
  event.preventDefault()
  void openPreview(event.target)
}

onBeforeUnmount(() => {
  window.removeEventListener('keydown', onPreviewKeydown)
  if (preview.value) document.body.style.overflow = previousBodyOverflow
})
</script>

<template>
  <div
    ref="containerRef"
    class="markdown-body"
    v-html="html"
    @click="onContainerClick"
    @keydown="onContainerKeydown"
  ></div>
  <Teleport to="body">
    <div
      v-if="preview"
      class="markdown-image-preview"
      role="dialog"
      aria-modal="true"
      :aria-label="preview.alt ? `图片预览：${preview.alt}` : '图片预览'"
      @click.self="closePreview"
    >
      <button
        ref="previewCloseRef"
        type="button"
        class="markdown-image-preview-close"
        aria-label="关闭图片预览"
        @click="closePreview"
      >
        ×
      </button>
      <img :src="preview.src" :alt="preview.alt" />
    </div>
  </Teleport>
</template>
