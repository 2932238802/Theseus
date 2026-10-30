<script setup lang="ts">
import { computed, onMounted, ref } from 'vue'
import NavBar from '../components/NavBar.vue'
import { toErrorMessage } from '../api/client'
import { exportAuditLogs, fetchAuditLogs, fetchAuditMeta } from '../api/audit'
import { toast } from '../store/toast'
import type { AuditLogEntry, AuditMetaResponse } from '../types/audit'
import { formatDateTime } from '../utils/teaching'

const PAGE_SIZE = 20

const ACTION_LABELS: Record<string, string> = {
  'auth.login': '登录',
  'user.role_change': '变更角色',
  'user.status_change': '变更状态',
  'user.reputation_restore': '恢复信誉分',
  'user.delete': '删除用户',
  'problem.create': '创建题目',
  'problem.submit': '提交题目',
  'problem.review': '审核题目',
  'problem.update': '修改题目',
  'problem.delete': '删除题目',
  'grade.problem_update': '修改单题批改',
  'grade.overall_update': '修改整体评语',
  'grade.publish': '发布成绩',
  'notification.send': '发送通知',
  'forum.post_status': '帖子状态',
  'forum.comment_status': '评论状态',
  'forum.pin': '置顶操作',
  'forum.report_decide': '处理举报',
  'forum.mute': '禁言用户',
  'forum.unmute': '解除禁言',
  'anticheat.review': '作弊复核',
  'anticheat.appeal_resolve': '裁定申诉',
  'anticheat.appeal_submit': '提交申诉',
  'contest.proctor_review': '监考复核',
  'contest.event_create': '创建赛事',
  'contest.event_update': '更新赛事',
  'contest.event_forum': '赛事同步校园墙',
  'audit.export': '导出审计',
}

const ROLE_LABELS: Record<string, string> = {
  student: '学生',
  teacher: '教师',
  admin: '管理员',
}

const TARGET_LABELS: Record<string, string> = {
  user: '用户',
  problem: '题目',
  assignment: '作业',
  notification: '通知',
  forum_post: '帖子',
  forum_comment: '评论',
  forum_report: '举报',
  cheat_report: '作弊报告',
  appeal: '申诉',
  contest: '竞赛',
  contest_event: '赛事',
  audit_log: '审计日志',
}

const q = ref('')
const action = ref('')
const targetType = ref('')
const from = ref('')
const to = ref('')
const logs = ref<AuditLogEntry[]>([])
const total = ref(0)
const page = ref(1)
const meta = ref<AuditMetaResponse | null>(null)
const isLoading = ref(false)
const isExporting = ref(false)
const listError = ref('')
const selected = ref<AuditLogEntry | null>(null)

let listSequence = 0

const pageCount = computed(() => Math.max(1, Math.ceil(total.value / PAGE_SIZE)))

const actionLabel = (value: string): string => ACTION_LABELS[value] ?? value
const targetLabel = (value: string): string => TARGET_LABELS[value] ?? value
const roleLabel = (value: string): string => ROLE_LABELS[value] ?? value
const actorText = (entry: AuditLogEntry): string =>
  entry.actor_username || (entry.actor_id ? `已删除用户 #${entry.actor_id}` : '系统')

const currentQuery = () => ({
  q: q.value.trim() || undefined,
  action: action.value || undefined,
  target_type: targetType.value || undefined,
  from: from.value || undefined,
  to: to.value || undefined,
})

const load = async (targetPage = page.value): Promise<void> => {
  const requestId = ++listSequence
  isLoading.value = true
  listError.value = ''
  try {
    const result = await fetchAuditLogs({
      ...currentQuery(),
      page: targetPage,
      size: PAGE_SIZE,
    })
    if (requestId !== listSequence) return
    logs.value = result.logs
    total.value = result.total
    page.value = result.page
  } catch (exception: unknown) {
    if (requestId !== listSequence) return
    logs.value = []
    total.value = 0
    listError.value = toErrorMessage(exception)
  } finally {
    if (requestId === listSequence) isLoading.value = false
  }
}

const loadMeta = async (): Promise<void> => {
  try {
    meta.value = await fetchAuditMeta()
  } catch {
    // 筛选下拉依赖元数据；失败时仍允许手动搜索。
    meta.value = null
  }
}

const search = (): void => {
  void load(1)
}

const resetFilters = (): void => {
  q.value = ''
  action.value = ''
  targetType.value = ''
  from.value = ''
  to.value = ''
  void load(1)
}

const download = async (): Promise<void> => {
  if (isExporting.value) return
  isExporting.value = true
  listError.value = ''
  try {
    const blob = await exportAuditLogs(currentQuery())
    const url = URL.createObjectURL(blob)
    const anchor = document.createElement('a')
    anchor.href = url
    anchor.download = 'audit-logs.csv'
    document.body.appendChild(anchor)
    anchor.click()
    anchor.remove()
    URL.revokeObjectURL(url)
    toast.success('审计日志已导出')
  } catch (exception: unknown) {
    listError.value = toErrorMessage(exception)
  } finally {
    isExporting.value = false
  }
}

const openDetail = (entry: AuditLogEntry): void => {
  selected.value = entry
}

const closeDetail = (): void => {
  selected.value = null
}

const pretty = (value: unknown): string => {
  if (value === null || value === undefined) return '—'
  return JSON.stringify(value, null, 2)
}

onMounted(() => {
  void loadMeta()
  void load(1)
})
</script>

<template>
  <NavBar />
  <main class="teaching-page teaching-wide page-shell">
    <header class="teaching-page-header">
      <div>
        <h1>审计日志</h1>
      </div>
    </header>

    <section class="admin-panel">
      <form class="admin-content-filters" @submit.prevent="search">
        <label>
          <span>关键词</span>
          <input v-model="q" placeholder="操作者、动作、摘要或 IP" />
        </label>
        <label>
          <span>动作</span>
          <select v-model="action">
            <option value="">全部动作</option>
            <option v-for="item in meta?.actions ?? []" :key="item.value" :value="item.value">
              {{ actionLabel(item.value) }}（{{ item.count }}）
            </option>
          </select>
        </label>
        <label>
          <span>对象</span>
          <select v-model="targetType">
            <option value="">全部对象</option>
            <option v-for="item in meta?.target_types ?? []" :key="item.value" :value="item.value">
              {{ targetLabel(item.value) }}（{{ item.count }}）
            </option>
          </select>
        </label>
        <label>
          <span>开始日期</span>
          <input v-model="from" type="date" />
        </label>
        <label>
          <span>结束日期</span>
          <input v-model="to" type="date" />
        </label>
        <button class="primary-button" type="submit" :disabled="isLoading">搜索</button>
        <button class="teaching-secondary-button" type="button" :disabled="isLoading" @click="resetFilters">
          重置
        </button>
        <button class="forum-secondary-button" type="button" :disabled="isExporting" @click="download">
          {{ isExporting ? '导出中' : '导出 CSV' }}
        </button>
        <span class="admin-total">{{ total }} 条记录</span>
      </form>

      <p v-if="listError" class="form-error" role="alert">{{ listError }}</p>
      <p v-if="isLoading" class="teaching-subtle">正在加载审计日志</p>

      <div v-else-if="logs.length" class="admin-table-scroll">
        <table class="admin-users-table">
          <thead>
            <tr>
              <th>时间</th>
              <th>操作者</th>
              <th>动作</th>
              <th>对象</th>
              <th>摘要</th>
              <th>IP</th>
              <th>详情</th>
            </tr>
          </thead>
          <tbody>
            <tr v-for="entry in logs" :key="entry.id">
              <td class="audit-time">{{ formatDateTime(entry.created_at) }}</td>
              <td>
                <strong>{{ actorText(entry) }}</strong>
                <small>{{ roleLabel(entry.actor_role) }}</small>
              </td>
              <td>
                <span class="audit-action">{{ actionLabel(entry.action) }}</span>
                <small class="audit-action-code">{{ entry.action }}</small>
              </td>
              <td>
                {{ targetLabel(entry.target_type) }}
                <small v-if="entry.target_id"> #{{ entry.target_id }}</small>
              </td>
              <td class="audit-summary">{{ entry.summary }}</td>
              <td class="audit-ip">{{ entry.ip ?? '—' }}</td>
              <td>
                <button class="forum-secondary-button" type="button" @click="openDetail(entry)">
                  查看
                </button>
              </td>
            </tr>
          </tbody>
        </table>
      </div>
      <p v-else-if="!listError" class="empty-state"><span>没有匹配的审计记录</span></p>

      <div v-if="total > 0" class="pagination">
        <button type="button" :disabled="page <= 1 || isLoading" @click="load(page - 1)">← 上一页</button>
        <span>第 {{ page }} / {{ pageCount }} 页</span>
        <button type="button" :disabled="page >= pageCount || isLoading" @click="load(page + 1)">下一页 →</button>
      </div>
    </section>
  </main>

  <div v-if="selected" class="modal-backdrop" @click.self="closeDetail">
    <section class="run-dialog gradebook-dialog audit-dialog" role="dialog" aria-modal="true" aria-labelledby="audit-detail-title">
      <header>
        <div>
          <h2 id="audit-detail-title">{{ actionLabel(selected.action) }}</h2>
          <p>{{ formatDateTime(selected.created_at) }}</p>
        </div>
        <button type="button" aria-label="关闭" @click="closeDetail">×</button>
      </header>
      <div class="run-dialog-body">
        <dl class="audit-meta">
          <div>
            <dt>操作者</dt>
            <dd>{{ actorText(selected) }}（{{ roleLabel(selected.actor_role) }}）</dd>
          </div>
          <div>
            <dt>动作</dt>
            <dd><code>{{ selected.action }}</code></dd>
          </div>
          <div>
            <dt>对象</dt>
            <dd>{{ targetLabel(selected.target_type) }}<template v-if="selected.target_id"> #{{ selected.target_id }}</template></dd>
          </div>
          <div>
            <dt>IP</dt>
            <dd>{{ selected.ip ?? '—' }}</dd>
          </div>
          <div class="audit-meta-wide">
            <dt>User-Agent</dt>
            <dd class="audit-ua">{{ selected.user_agent ?? '—' }}</dd>
          </div>
          <div class="audit-meta-wide">
            <dt>摘要</dt>
            <dd>{{ selected.summary }}</dd>
          </div>
        </dl>

        <div class="audit-diff">
          <section>
            <h3>变更前</h3>
            <pre>{{ pretty(selected.before) }}</pre>
          </section>
          <section>
            <h3>变更后</h3>
            <pre>{{ pretty(selected.after) }}</pre>
          </section>
        </div>
      </div>
    </section>
  </div>
</template>
