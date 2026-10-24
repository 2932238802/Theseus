import type { Difficulty, Language, ProblemStatus } from '../types/oj'
import type { RunCaseStatus, RunStatus } from '../types/run'

export const DIFFICULTY_LABELS: Record<Difficulty, string> = {
  easy: '简单',
  medium: '中等',
  hard: '困难',
}

export const LANGUAGE_OPTIONS: Array<{ value: Language; label: string; monaco: string }> = [
  { value: 'cpp', label: 'C++', monaco: 'cpp' },
  { value: 'java', label: 'Java', monaco: 'java' },
  { value: 'python', label: 'Python 3', monaco: 'python' },
  { value: 'javascript', label: 'JavaScript', monaco: 'javascript' },
]

export const PROBLEM_STATUS_LABELS: Record<ProblemStatus | 'all', string> = {
  all: '全部',
  not_started: '未开始',
  attempted: '尝试过',
  accepted: '已通过',
}

export const PROBLEM_STATUS_OPTIONS: Array<{ value: ProblemStatus | 'all'; label: string }> = [
  { value: 'all', label: PROBLEM_STATUS_LABELS.all },
  { value: 'not_started', label: PROBLEM_STATUS_LABELS.not_started },
  { value: 'attempted', label: PROBLEM_STATUS_LABELS.attempted },
  { value: 'accepted', label: PROBLEM_STATUS_LABELS.accepted },
]

export const RUN_STATUS_LABELS: Record<RunStatus, string> = {
  queued: '排队中',
  compiling: '编译中',
  running: '运行中',
  completed: '已完成',
  compile_error: '编译错误',
  runtime_error: '运行时错误',
  time_limit_exceeded: '超出时间限制',
  memory_limit_exceeded: '超出内存限制',
  internal_error: '运行服务异常',
}

export const RUN_CASE_STATUS_LABELS: Record<RunCaseStatus, string> = {
  passed: '通过',
  failed: '未通过',
  runtime_error: '运行时错误',
  timeout: '超时',
  memory_limit_exceeded: '内存超限',
  internal_error: '运行异常',
}
