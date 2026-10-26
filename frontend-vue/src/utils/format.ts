// 展示用：紧凑单行，元素之间只补一个空格，贴近 LeetCode 与题面风格
// 不要用 JSON.stringify().replaceAll(',', ', ') 之类的写法，会误伤字符串内容
export const formatInline = (value: unknown): string => {
  if (value === undefined) return '—'
  if (Array.isArray(value)) return `[${value.map((item) => formatInline(item)).join(', ')}]`
  if (value !== null && typeof value === 'object') {
    const entries = Object.entries(value as Record<string, unknown>)
    return `{${entries
      .map(([key, item]) => `${JSON.stringify(key)}: ${formatInline(item)}`)
      .join(', ')}}`
  }
  return JSON.stringify(value) ?? 'null'
}

// 输入：参数个数与运行配置一致时按 `name = value` 展开，与题面一致；否则退化为紧凑数组
export const formatArgs = (args: unknown, params: Array<{ name: string }> = []): string => {
  if (!Array.isArray(args) || params.length !== args.length) return formatInline(args)
  return args.map((arg, index) => `${params[index].name} = ${formatInline(arg)}`).join(', ')
}
