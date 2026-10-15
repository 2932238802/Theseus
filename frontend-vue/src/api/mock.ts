import type { Language, Problem, Submission, SubmissionStatus, User } from '../types/oj'

const PROBLEMS: Problem[] = [
  {
    id: 1, title: '两数之和', difficulty: 'easy', acceptance: 54.2, tags: ['数组', '哈希表'], solved: true,
    description: '给定一个整数数组 **nums** 和一个整数目标值 **target**，请你在该数组中找出和为目标值 *target* 的那两个整数，并返回它们的数组下标。\n\n你可以假设每种输入只会对应一个答案，并且你不能使用两次相同的元素。',
    inputDescription: '第一行输入数组 nums，第二行输入目标值 target。', outputDescription: '返回两个满足条件元素的下标。',
    examples: [{ input: 'nums = [2, 7, 11, 15]\ntarget = 9', output: '[0, 1]', explanation: '因为 nums[0] + nums[1] == 9，返回 [0, 1]。' }],
    constraints: ['2 ≤ nums.length ≤ 10⁴', '-10⁹ ≤ nums[i] ≤ 10⁹', '仅会存在一个有效答案'], hints: ['能否用哈希表记录已经遍历过的数字？'],
  },
  { id: 2, title: '两数相加', difficulty: 'medium', acceptance: 43.8, tags: ['链表', '数学'], description: '给你两个非空的链表，表示两个非负的整数。请你将这两个数相加，并以相同形式返回一个表示和的链表。', inputDescription: '输入两个逆序存储数字的链表。', outputDescription: '返回其和所表示的链表。', examples: [{ input: 'l1 = [2,4,3], l2 = [5,6,4]', output: '[7,0,8]' }], constraints: ['链表节点数在 [1, 100] 范围内'] },
  { id: 3, title: '无重复字符的最长子串', difficulty: 'medium', acceptance: 38.1, tags: ['哈希表', '字符串', '滑动窗口'], description: '给定一个字符串 s，请你找出其中不含有重复字符的最长子串的长度。', inputDescription: '一个字符串 s。', outputDescription: '最长无重复子串的长度。', examples: [{ input: 's = "abcabcbb"', output: '3', explanation: '因为无重复字符的最长子串是 "abc"。' }], constraints: ['0 ≤ s.length ≤ 5 × 10⁴'] },
  { id: 4, title: '寻找两个正序数组的中位数', difficulty: 'hard', acceptance: 40.6, tags: ['数组', '二分查找', '分治'], description: '给定两个大小分别为 m 和 n 的正序数组 nums1 和 nums2。请你找出并返回这两个正序数组的中位数。', inputDescription: '两个非递减整数数组。', outputDescription: '两个数组合并后的中位数。', examples: [{ input: 'nums1 = [1,3], nums2 = [2]', output: '2.0' }], constraints: ['0 ≤ m, n ≤ 1000', '1 ≤ m + n ≤ 2000'] },
  { id: 5, title: '最长回文子串', difficulty: 'medium', acceptance: 36.4, tags: ['字符串', '动态规划'], description: '给你一个字符串 s，找到 s 中最长的回文子串。', inputDescription: '一个字符串。', outputDescription: '最长回文子串。', examples: [{ input: 's = "babad"', output: '"bab"' }], constraints: ['1 ≤ s.length ≤ 1000'] },
  { id: 11, title: '盛最多水的容器', difficulty: 'medium', acceptance: 55.7, tags: ['数组', '双指针'], description: '给定一个长度为 n 的整数数组 height。有 n 条垂线，第 i 条线的两个端点是 (i, 0) 和 (i, height[i])。', inputDescription: '一个整数数组 height。', outputDescription: '能容纳水的最大面积。', examples: [{ input: 'height = [1,8,6,2,5,4,8,3,7]', output: '49' }], constraints: ['n ≥ 2'] },
]

const sleep = (milliseconds: number): Promise<void> => new Promise((resolve) => window.setTimeout(resolve, milliseconds))
const createUser = (username: string, email: string): User => ({ id: Date.now(), username, email, avatar: username.slice(0, 1).toUpperCase() })

export const mockApi = {
  async login(username: string, password: string): Promise<{ token: string; user: User }> {
    await sleep(650)
    if (username === 'error' || password === 'error') throw new Error('用户名或密码错误，请检查后重试。')
    return { token: `mock-token-${Date.now()}`, user: createUser(username, `${username}@theseus.dev`) }
  },
  async register(username: string, email: string, _password: string): Promise<{ token: string; user: User }> {
    await sleep(800)
    if (username.toLowerCase() === 'theseus') throw new Error('该用户名已被使用，请尝试其他用户名。')
    return { token: `mock-token-${Date.now()}`, user: createUser(username, email) }
  },
  async getProblems(): Promise<Problem[]> {
    await sleep(300)
    return PROBLEMS
  },
  async getProblem(id: number): Promise<Problem> {
    await sleep(250)
    const problem = PROBLEMS.find((item) => item.id === id)
    if (!problem) throw new Error('题目不存在或已下架。')
    return problem
  },
  async submit(problem: Problem, language: Language, code: string): Promise<Submission> {
    await sleep(900)
    const statuses: SubmissionStatus[] = code.trim().length < 16 ? ['Wrong Answer'] : ['Accepted', 'Accepted', 'Accepted', 'Runtime Error']
    const status = statuses[Math.floor(Math.random() * statuses.length)] ?? 'Accepted'
    return {
      id: `s-${Date.now()}`,
      problemId: problem.id,
      problemTitle: problem.title,
      language,
      code,
      status,
      runtime: status === 'Accepted' ? '48 ms' : undefined,
      memory: status === 'Accepted' ? '42.1 MB' : undefined,
      createdAt: new Date().toISOString(),
      message: status === 'Runtime Error' ? '运行时错误：请检查数组边界及空值处理。' : status === 'Wrong Answer' ? '输出与预期结果不一致。' : '全部测试用例通过。',
    }
  },
}
