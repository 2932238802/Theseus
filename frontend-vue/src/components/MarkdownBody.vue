<script setup lang="ts">
import DOMPurify from 'dompurify'
import { marked } from 'marked'
import { computed } from 'vue'

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
]

const html = computed(() => {
  const source = props.content ?? ''
  const rendered = marked.parse(source, { async: false }) as string
  const clean = DOMPurify.sanitize(rendered, {
    ALLOWED_TAGS,
    ALLOWED_ATTR: ['href', 'title', 'start', 'colspan', 'rowspan'],
    FORBID_TAGS: ['img', 'iframe', 'script', 'style', 'form', 'input', 'button', 'svg'],
    FORBID_ATTR: ['style'],
    ALLOW_DATA_ATTR: false,
    ALLOW_UNKNOWN_PROTOCOLS: false,
    ALLOWED_URI_REGEXP: /^(?:(?:https?|mailto):|[^a-z]|[a-z+.-]+(?:[^a-z+.\-:]|$))/i,
  })

  // 统一外链行为；在清洗后再设置属性，避免信任 Markdown 中的 target/rel。
  const template = document.createElement('template')
  template.innerHTML = String(clean)
  template.content.querySelectorAll('a').forEach((link) => {
    link.setAttribute('target', '_blank')
    link.setAttribute('rel', 'noopener noreferrer')
  })
  return template.innerHTML
})
</script>

<template>
  <div class="markdown-body" v-html="html"></div>
</template>
