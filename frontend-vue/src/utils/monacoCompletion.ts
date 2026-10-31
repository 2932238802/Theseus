import type { Monaco } from '@monaco-editor/loader'
import type { editor, languages, Position } from 'monaco-editor'

interface CompletionSnippet {
  label: string
  detail: string
  insertText: string
}

interface LanguageCompletion {
  keywords: string[]
  types: string[]
  functions: string[]
  constants: string[]
  modules: string[]
  methods: string[]
  snippets: CompletionSnippet[]
}

// Monaco 只内置 JS/TS 等语言服务，C++、Java、Python 没有真正的语义分析。
// 这里维护常用关键字、类型、标准库函数与代码片段，按输入前缀过滤，
// 达到题解编辑器里“基础补全”的效果；类型推断式的补全需要 LSP。
const COMPLETIONS: Record<string, LanguageCompletion> = {
  cpp: {
    keywords: [
      'alignas', 'alignof', 'and', 'and_eq', 'asm', 'auto', 'bitand', 'bitor', 'bool',
      'break', 'case', 'catch', 'char', 'char8_t', 'char16_t', 'char32_t', 'class',
      'co_await', 'co_return', 'co_yield', 'compl', 'concept', 'const', 'consteval',
      'constexpr', 'constinit', 'const_cast', 'continue', 'decltype', 'default', 'delete',
      'do', 'double', 'dynamic_cast', 'else', 'enum', 'explicit', 'export', 'extern',
      'false', 'final', 'float', 'for', 'friend', 'goto', 'if', 'import', 'inline', 'int',
      'long', 'module', 'mutable', 'namespace', 'new', 'noexcept', 'not', 'not_eq',
      'nullptr', 'operator', 'or', 'or_eq', 'override', 'private', 'protected', 'public',
      'register', 'reinterpret_cast', 'requires', 'return', 'short', 'signed', 'sizeof',
      'static', 'static_assert', 'static_cast', 'struct', 'switch', 'template', 'this',
      'thread_local', 'throw', 'true', 'try', 'typedef', 'typeid', 'typename', 'union',
      'unsigned', 'using', 'virtual', 'void', 'volatile', 'wchar_t', 'while', 'xor',
      'xor_eq',
    ],
    types: [
      'string', 'wstring', 'u8string', 'u16string', 'u32string', 'string_view', 'vector',
      'array', 'deque', 'list', 'forward_list', 'map', 'multimap', 'set', 'multiset',
      'unordered_map', 'unordered_multimap', 'unordered_set', 'unordered_multiset', 'stack',
      'queue', 'priority_queue', 'pair', 'tuple', 'bitset', 'complex', 'optional',
      'variant', 'any', 'function', 'shared_ptr', 'unique_ptr', 'weak_ptr',
      'initializer_list', 'stringstream', 'istringstream', 'ostringstream', 'fstream',
      'ifstream', 'ofstream', 'size_t', 'ptrdiff_t', 'int8_t', 'int16_t', 'int32_t',
      'int64_t', 'uint8_t', 'uint16_t', 'uint32_t', 'uint64_t', 'intmax_t', 'uintmax_t',
    ],
    functions: [
      'printf', 'scanf', 'puts', 'gets', 'fgets', 'memset', 'memcpy', 'memmove', 'strlen',
      'strcmp', 'strncmp', 'strcpy', 'strncpy', 'sort', 'stable_sort', 'partial_sort',
      'nth_element', 'reverse', 'max', 'min', 'abs', 'swap', 'fill', 'fill_n', 'count',
      'count_if', 'find', 'find_if', 'binary_search', 'lower_bound', 'upper_bound',
      'equal_range', 'unique', 'accumulate', 'iota', 'next_permutation',
      'prev_permutation', 'make_heap', 'push_heap', 'pop_heap', 'sort_heap', 'to_string',
      'stoi', 'stol', 'stoll', 'stoul', 'stoull', 'stof', 'stod', 'getline', 'sscanf',
      'sprintf', 'snprintf', 'toupper', 'tolower', 'isalpha', 'isdigit', 'isalnum',
      'isspace', 'gcd', 'lcm', 'pow', 'sqrt', 'log', 'log2', 'log10', 'exp', 'ceil',
      'floor', 'round', 'trunc', 'fmod', 'sin', 'cos', 'tan', 'fabs', 'hypot',
      'max_element', 'min_element', '__builtin_popcount', '__builtin_ctz',
      '__builtin_clz', '__builtin_ffs',
    ],
    constants: [
      'cin', 'cout', 'cerr', 'clog', 'endl', 'NULL', 'EOF', 'INT_MAX', 'INT_MIN',
      'LONG_MAX', 'LONG_MIN', 'LLONG_MAX', 'LLONG_MIN', 'UINT_MAX', 'SIZE_MAX',
      'DBL_MAX', 'DBL_MIN', 'M_PI', 'M_E',
    ],
    modules: ['std'],
    methods: [
      'push_back', 'pop_back', 'emplace_back', 'emplace', 'size', 'length', 'empty',
      'clear', 'front', 'back', 'begin', 'end', 'rbegin', 'rend', 'at', 'substr', 'find',
      'rfind', 'insert', 'erase', 'replace', 'append', 'compare', 'c_str', 'data',
      'resize', 'reserve', 'capacity', 'assign', 'swap', 'first', 'second', 'top', 'push',
      'pop', 'lower_bound', 'upper_bound', 'count',
    ],
    snippets: [
      { label: 'include', detail: '万能头文件', insertText: 'include <bits/stdc++.h>' },
      { label: 'using namespace', detail: 'std 命名空间', insertText: 'using namespace std;' },
      { label: 'main', detail: 'main 函数', insertText: 'int main() {\n\t$0\n\treturn 0;\n}' },
      {
        label: 'for',
        detail: 'for 循环',
        insertText: 'for (int ${1:i} = 0; ${1:i} < ${2:n}; ++${1:i}) {\n\t$0\n}',
      },
      {
        label: 'foreach',
        detail: '范围 for 循环',
        insertText: 'for (const auto &${1:item} : ${2:container}) {\n\t$0\n}',
      },
      { label: 'vector', detail: 'vector 声明', insertText: 'vector<${1:int}> ${2:name};' },
      {
        label: 'unordered_map',
        detail: 'unordered_map 声明',
        insertText: 'unordered_map<${1:int}, ${2:int}> ${3:name};',
      },
      { label: 'sort', detail: '排序', insertText: 'sort(${1:begin}, ${2:end});' },
      { label: 'cout', detail: '输出', insertText: 'cout << ${1:value} << endl;' },
      { label: 'cin', detail: '输入', insertText: 'cin >> ${1:value};' },
      {
        label: 'sync',
        detail: '关闭同步加速 IO',
        insertText: 'sync_with_stdio(false);\nstd::cin.tie(nullptr);',
      },
    ],
  },
  java: {
    keywords: [
      'abstract', 'assert', 'boolean', 'break', 'byte', 'case', 'catch', 'char', 'class',
      'const', 'continue', 'default', 'do', 'double', 'else', 'enum', 'extends', 'false',
      'final', 'finally', 'float', 'for', 'goto', 'if', 'implements', 'import',
      'instanceof', 'int', 'interface', 'long', 'native', 'new', 'null', 'package',
      'permits', 'private', 'protected', 'public', 'record', 'return', 'sealed', 'short',
      'static', 'strictfp', 'super', 'switch', 'synchronized', 'this', 'throw', 'throws',
      'transient', 'true', 'try', 'var', 'void', 'volatile', 'while', 'yield',
    ],
    types: [
      'String', 'StringBuilder', 'StringBuffer', 'Integer', 'Long', 'Short', 'Byte',
      'Character', 'Boolean', 'Double', 'Float', 'BigInteger', 'BigDecimal', 'ArrayList',
      'LinkedList', 'HashMap', 'LinkedHashMap', 'TreeMap', 'HashSet', 'LinkedHashSet',
      'TreeSet', 'ArrayDeque', 'PriorityQueue', 'Deque', 'Queue', 'Stack', 'List', 'Map',
      'Set', 'Collection', 'Collections', 'Arrays', 'Objects', 'Optional', 'Stream',
      'Collectors', 'Scanner', 'System', 'Math', 'Random', 'Thread', 'Exception',
      'RuntimeException', 'StringTokenizer', 'Comparator', 'Comparable', 'Iterator',
      'Iterable',
    ],
    functions: [
      'parseInt', 'parseLong', 'parseDouble', 'valueOf', 'toString', 'format', 'join',
      'max', 'min', 'abs', 'pow', 'sqrt', 'floor', 'ceil', 'round', 'random', 'sort',
      'binarySearch', 'fill', 'asList', 'stream', 'reverse', 'swap', 'copyOf',
      'copyOfRange', 'deepToString',
    ],
    constants: ['MAX_VALUE', 'MIN_VALUE', 'PI', 'E'],
    modules: [],
    methods: [
      'charAt', 'substring', 'length', 'size', 'isEmpty', 'add', 'addAll', 'remove',
      'get', 'set', 'put', 'getOrDefault', 'containsKey', 'containsValue', 'contains',
      'keySet', 'values', 'entrySet', 'poll', 'offer', 'peek', 'push', 'pop', 'append',
      'equals', 'compareTo', 'split', 'trim', 'replace', 'startsWith', 'endsWith',
      'indexOf', 'lastIndexOf', 'toCharArray', 'forEach', 'nextInt', 'nextLong',
      'nextDouble', 'nextLine', 'next', 'hasNext', 'hasNextInt', 'nextToken',
    ],
    snippets: [
      {
        label: 'main',
        detail: 'class + main 方法',
        insertText:
          'class ${1:Main} {\n\tpublic static void main(String[] args) {\n\t\t$0\n\t}\n}',
      },
      { label: 'sout', detail: 'System.out.println', insertText: 'System.out.println(${1:value});' },
      { label: 'println', detail: 'println 调用', insertText: 'println(${1:value});' },
      {
        label: 'for',
        detail: 'for 循环',
        insertText: 'for (int ${1:i} = 0; ${1:i} < ${2:n}; ${1:i}++) {\n\t$0\n}',
      },
      {
        label: 'Scanner',
        detail: 'Scanner 输入',
        insertText: 'Scanner ${1:sc} = new Scanner(System.in);',
      },
      { label: 'ArrayList', detail: 'ArrayList 实例', insertText: 'new ArrayList<${1:Integer}>()' },
      { label: 'HashMap', detail: 'HashMap 实例', insertText: 'new HashMap<${1:Integer}, ${2:Integer}>()' },
      {
        label: 'StringBuilder',
        detail: 'StringBuilder 实例',
        insertText: 'StringBuilder ${1:sb} = new StringBuilder();',
      },
    ],
  },
  python: {
    keywords: [
      'and', 'as', 'assert', 'async', 'await', 'break', 'case', 'class', 'continue',
      'def', 'del', 'elif', 'else', 'except', 'False', 'finally', 'for', 'from', 'global',
      'if', 'import', 'in', 'is', 'lambda', 'match', 'None', 'nonlocal', 'not', 'or',
      'pass', 'raise', 'return', 'self', 'True', 'try', 'while', 'with', 'yield',
    ],
    types: [
      'str', 'int', 'float', 'bool', 'list', 'dict', 'set', 'tuple', 'bytes', 'bytearray',
      'frozenset', 'complex', 'object', 'type', 'range', 'slice', 'memoryview',
    ],
    functions: [
      'print', 'len', 'input', 'open', 'sorted', 'reversed', 'enumerate', 'zip', 'map',
      'filter', 'sum', 'min', 'max', 'abs', 'round', 'pow', 'divmod', 'any', 'all',
      'iter', 'next', 'repr', 'hash', 'id', 'isinstance', 'issubclass', 'getattr',
      'setattr', 'hasattr', 'delattr', 'callable', 'format', 'ord', 'chr', 'hex', 'oct',
      'bin', 'ascii', 'eval', 'exec', 'compile', 'globals', 'locals', 'vars', 'dir',
      'help', 'exit', 'quit', 'maxsize', 'setrecursionlimit',
    ],
    constants: ['inf', 'nan'],
    modules: [
      'sys', 'math', 'collections', 'itertools', 'functools', 'heapq', 'bisect', 're',
      'string', 'random', 'time', 'datetime', 'typing', 'os', 'json', 'copy', 'decimal',
      'fractions',
    ],
    methods: [
      'append', 'extend', 'insert', 'remove', 'pop', 'index', 'count', 'sort', 'reverse',
      'copy', 'clear', 'keys', 'values', 'items', 'get', 'update', 'setdefault', 'add',
      'discard', 'union', 'intersection', 'difference', 'issubset', 'issuperset', 'split',
      'rsplit', 'join', 'strip', 'lstrip', 'rstrip', 'replace', 'startswith', 'endswith',
      'find', 'rfind', 'upper', 'lower', 'capitalize', 'title', 'isdigit', 'isalpha',
      'isalnum', 'isspace', 'zfill', 'bit_length', 'to_bytes', 'from_bytes', 'readline',
      'readlines', 'read', 'write', 'writelines', 'flush', 'close', 'heappush', 'heappop',
      'heapify', 'bisect_left', 'bisect_right', 'itemgetter', 'lru_cache',
    ],
    snippets: [
      { label: 'print', detail: '输出', insertText: 'print(${1:value})' },
      {
        label: 'main',
        detail: '入口判断',
        insertText: 'if __name__ == "__main__":\n\t$0',
      },
      {
        label: 'for',
        detail: 'for 循环',
        insertText: 'for ${1:item} in ${2:items}:\n\t$0',
      },
      { label: 'def', detail: '函数定义', insertText: 'def ${1:name}(${2:args}):\n\t$0' },
      {
        label: 'comprehension',
        detail: '列表推导式',
        insertText: '[${1:expr} for ${2:item} in ${3:items}]',
      },
      {
        label: 'inputints',
        detail: '读入一行整数',
        insertText: 'list(map(int, input().split()))',
      },
      { label: 'importsys', detail: '导入 sys', insertText: 'import sys' },
      { label: 'deque', detail: '导入 deque', insertText: 'from collections import deque' },
      {
        label: 'defaultdict',
        detail: '导入 defaultdict',
        insertText: 'from collections import defaultdict',
      },
      { label: 'counter', detail: '导入 Counter', insertText: 'from collections import Counter' },
    ],
  },
}

const kindOf = (monaco: Monaco, kind: string): languages.CompletionItemKind => {
  switch (kind) {
    case 'type':
      return monaco.languages.CompletionItemKind.Class
    case 'function':
      return monaco.languages.CompletionItemKind.Function
    case 'constant':
      return monaco.languages.CompletionItemKind.Constant
    case 'module':
      return monaco.languages.CompletionItemKind.Module
    case 'method':
      return monaco.languages.CompletionItemKind.Method
    default:
      return monaco.languages.CompletionItemKind.Keyword
  }
}

export const registerCompletionProviders = (monaco: Monaco): Array<{ dispose: () => void }> => {
  const disposables: Array<{ dispose: () => void }> = []
  for (const [languageId, completion] of Object.entries(COMPLETIONS)) {
    disposables.push(
      monaco.languages.registerCompletionItemProvider(languageId, {
        provideCompletionItems(model: editor.ITextModel, position: Position) {
          const word = model.getWordUntilPosition(position)
          const range = new monaco.Range(
            position.lineNumber,
            word.startColumn,
            position.lineNumber,
            word.endColumn,
          )
          const snippetLabels = new Set(completion.snippets.map((snippet) => snippet.label))
          // 同名条目只保留第一次出现的分类，避免关键字、函数、方法重复展示
          const seen = new Set(snippetLabels)
          const suggestions: languages.CompletionItem[] = []

          const add = (labels: string[], kind: string): void => {
            for (const label of labels) {
              if (seen.has(label)) continue
              seen.add(label)
              suggestions.push({
                label,
                kind: kindOf(monaco, kind),
                insertText: label,
                range,
              })
            }
          }

          add(completion.keywords, 'keyword')
          add(completion.types, 'type')
          add(completion.functions, 'function')
          add(completion.constants, 'constant')
          add(completion.modules, 'module')
          add(completion.methods, 'method')
          for (const snippet of completion.snippets) {
            suggestions.push({
              label: snippet.label,
              detail: snippet.detail,
              kind: monaco.languages.CompletionItemKind.Snippet,
              insertText: snippet.insertText,
              insertTextRules: monaco.languages.CompletionItemInsertTextRule.InsertAsSnippet,
              range,
              sortText: `0${snippet.label}`,
            })
          }
          return { suggestions }
        },
      }),
    )
  }
  return disposables
}
