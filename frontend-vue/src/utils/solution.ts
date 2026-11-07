import { LANGUAGE_OPTIONS } from './constants'
import type { ProblemSolution } from '../types/solution'

export type SolutionBadgeStatus = 'accepted' | 'failed' | 'draft'

const isPending = (solution: ProblemSolution): boolean =>
  solution.lastSubmission?.status === 'pending' || solution.lastSubmission?.status === 'judging'

export const solutionBadgeStatus = (solution: ProblemSolution): SolutionBadgeStatus => {
  const submission = solution.lastSubmission
  if (!submission || isPending(solution)) return 'draft'
  return submission.status === 'accepted' ? 'accepted' : 'failed'
}

export const solutionBadgeLabel = (solution: ProblemSolution): string => {
  const submission = solution.lastSubmission
  if (!submission) return '草稿'
  if (isPending(solution)) return '评测中'
  return submission.status === 'accepted' ? '已通过' : '未通过'
}

export const solutionLanguageLabel = (solution: ProblemSolution): string =>
  LANGUAGE_OPTIONS.find((option) => option.value === solution.language)?.label ?? solution.language

const formatRuntime = (value: number | null): string =>
  typeof value === 'number' && value >= 0 ? `${value} ms` : ''

const formatMemory = (value: number | null): string => {
  if (typeof value !== 'number' || value < 0) return ''
  return value >= 1024 ? `${(value / 1024).toFixed(1)} MB` : `${value} KB`
}

export const solutionMeta = (solution: ProblemSolution): string => {
  const submission = solution.lastSubmission
  if (!submission) return '尚未提交'
  const parts = [`${submission.testCasesPassed} / ${submission.totalTestCases} 用例`]
  const runtime = formatRuntime(submission.runtime)
  const memory = formatMemory(submission.memory)
  if (runtime) parts.push(runtime)
  if (memory) parts.push(memory)
  return parts.join(' · ')
}
