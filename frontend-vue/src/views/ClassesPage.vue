<script setup lang="ts">
import { onMounted, reactive, ref } from 'vue'
import { useRouter } from 'vue-router'
import NavBar from '../components/NavBar.vue'
import { toErrorMessage } from '../api/client'
import { useAuthStore } from '../store/auth'
import { useClassStore } from '../store/classes'
import type { ClassSummary } from '../types/teaching'
import { formatDateTime } from '../utils/teaching'

const router = useRouter()
const authStore = useAuthStore()
const classStore = useClassStore()

const isCreating = ref(false)
const showCreateForm = ref(false)
const createError = ref('')
const createForm = reactive({
  name: '',
  courseName: '',
  term: '',
  description: '',
})

const inviteCode = ref('')
const joinError = ref('')
const isJoining = ref(false)

const createClass = async (): Promise<void> => {
  if (!createForm.name.trim() || isCreating.value) return
  isCreating.value = true
  createError.value = ''
  try {
    const created = await classStore.create({
      name: createForm.name.trim(),
      courseName: createForm.courseName.trim() || undefined,
      term: createForm.term.trim() || undefined,
      description: createForm.description.trim() || undefined,
    })
    await router.push(`/classes/${created.id}`)
  } catch (exception: unknown) {
    createError.value = toErrorMessage(exception)
  } finally {
    isCreating.value = false
  }
}

const joinClass = async (): Promise<void> => {
  if (!inviteCode.value.trim() || isJoining.value) return
  isJoining.value = true
  joinError.value = ''
  try {
    const joined = await classStore.join(inviteCode.value.trim())
    inviteCode.value = ''
    await router.push(`/classes/${joined.id}`)
  } catch (exception: unknown) {
    joinError.value = toErrorMessage(exception)
  } finally {
    isJoining.value = false
  }
}

const classMeta = (item: ClassSummary): string =>
  [item.courseName, item.term].filter(Boolean).join(' · ')

onMounted(() => {
  void classStore.loadClasses()
})
</script>

<template>
  <NavBar />
  <main class="teaching-page page-shell">
    <header class="page-title">
      <h1>{{ authStore.isTeacher ? '我教的班级' : '我加入的班级' }}</h1>
    </header>

    <section v-if="authStore.isTeacher" class="teaching-toolbar">
      <button class="primary-button" type="button" @click="showCreateForm = !showCreateForm">
        {{ showCreateForm ? '收起' : '创建班级' }}
      </button>
    </section>

    <section v-if="authStore.isTeacher && showCreateForm" class="teaching-panel">
      <form class="teaching-form" @submit.prevent="createClass">
        <div class="teaching-form-grid">
          <label>
            <span>班级名称</span>
            <input v-model="createForm.name" maxlength="100" required />
          </label>
          <label>
            <span>课程名称</span>
            <input v-model="createForm.courseName" maxlength="100" />
          </label>
          <label>
            <span>学期</span>
            <input v-model="createForm.term" maxlength="30" />
          </label>
        </div>
        <label>
          <span>描述</span>
          <textarea v-model="createForm.description" rows="3" maxlength="5000"></textarea>
        </label>
        <p v-if="createError" class="form-error" role="alert">{{ createError }}</p>
        <div class="teaching-form-actions">
          <button class="primary-button" type="submit" :disabled="isCreating || !createForm.name.trim()">
            {{ isCreating ? '创建中…' : '创建班级' }}
          </button>
        </div>
      </form>
    </section>

    <section v-if="authStore.isStudent" class="teaching-panel">
      <form class="teaching-inline-form" @submit.prevent="joinClass">
        <label>
          <span>邀请码</span>
          <input v-model="inviteCode" maxlength="8" placeholder="8 位邀请码" required />
        </label>
        <button class="primary-button" type="submit" :disabled="isJoining || !inviteCode.trim()">
          {{ isJoining ? '加入中…' : '加入班级' }}
        </button>
      </form>
      <p v-if="joinError" class="form-error" role="alert">{{ joinError }}</p>
    </section>

    <p v-if="classStore.error" class="form-error" role="alert">{{ classStore.error }}</p>

    <section class="teaching-list" aria-live="polite">
      <div v-if="classStore.isLoading" class="empty-state"><p>正在加载班级…</p></div>
      <template v-else-if="classStore.classes.length">
        <RouterLink
          v-for="item in classStore.classes"
          :key="item.id"
          class="teaching-card"
          :to="`/classes/${item.id}`"
        >
          <header>
            <h2>{{ item.name }}</h2>
            <span v-if="item.archivedAt" class="teaching-badge">已归档</span>
          </header>
          <p v-if="classMeta(item)" class="teaching-card-meta">{{ classMeta(item) }}</p>
          <p v-if="item.description" class="teaching-card-description">{{ item.description }}</p>
          <footer>
            <span>{{ item.memberCount }} 名学生</span>
            <span>{{ item.assignmentCount }} 份作业</span>
            <span v-if="item.archivedAt">归档于 {{ formatDateTime(item.archivedAt) }}</span>
          </footer>
        </RouterLink>
      </template>
      <div v-else-if="!classStore.error" class="empty-state">
        <p>{{ authStore.isTeacher ? '还没有班级。' : '还没有加入班级。' }}</p>
      </div>
    </section>
  </main>
</template>
