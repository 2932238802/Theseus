import type { Monaco } from '@monaco-editor/loader'
import type { editor, languages, Position } from 'monaco-editor'

interface CompletionSnippet {
  label: string
  detail: string
  insertText: string
}

// Monaco 只内置 JS/TS 等语言服务，C++、Java、Python 需要自己提供补全项。
// 这里给出关键字和常用代码片段，开启补全后由 Monaco 按前缀过滤。
const KEYWORDS: Record<string, string[]> = {
  cpp: [
    'alignas', 'alignof', 'auto', 'bool', 'break', 'case', 'catch', 'char', 'class',
    'const', 'constexpr', 'const_cast', 'continue', 'decltype', 'default', 'delete',
    'do', 'double', 'dynamic_cast', 'else', 'enum', 'explicit', 'extern', 'false',
    'float', 'for', 'friend', 'goto', 'if', 'inline', 'int', 'long', 'mutable',
    'namespace', 'new', 'noexcept', 'nullptr', 'operator', 'override', 'private',
    'protected', 'public', 'register', 'reinterpret_cast', 'return', 'short', 'signed',
    'sizeof', 'static', 'static_assert', 'static_cast', 'struct', 'switch', 'template',
    'this', 'throw', 'true', 'try', 'typedef', 'typeid', 'typename', 'union',
    'unsigned', 'using', 'virtual', 'void', 'volatile', 'while',
  ],
  java: [
    'abstract', 'assert', 'boolean', 'break', 'byte', 'case', 'catch', 'char', 'class',
    'const', 'continue', 'default', 'do', 'double', 'else', 'enum', 'extends', 'false',
    'final', 'finally', 'float', 'for', 'if', 'implements', 'import', 'instanceof',
    'int', 'interface', 'long', 'native', 'new', 'null', 'package', 'private',
    'protected', 'public', 'return', 'short', 'static', 'strictfp', 'super', 'switch',
    'synchronized', 'this', 'throw', 'throws', 'transient', 'true', 'try', 'void',
    'volatile', 'while',
  ],
  python: [
    'and', 'as', 'assert', 'async', 'await', 'break', 'class', 'continue', 'def', 'del',
    'elif', 'else', 'except', 'False', 'finally', 'for', 'from', 'global', 'if',
    'import', 'in', 'is', 'lambda', 'None', 'nonlocal', 'not', 'or', 'pass', 'raise',
    'return', 'self', 'True', 'try', 'while', 'with', 'yield',
  ],
}

const SNIPPETS: Record<string, CompletionSnippet[]> = {
  cpp: [
    { label: '#include', detail: 'C++ 万能头文件', insertText: '#include <bits/stdc++.h>\n' },
    {
      label: 'for',
      detail: 'for 循环',
      insertText: 'for (int ${1:i} = 0; ${1:i} < ${2:n}; ++${1:i}) {\n\t$0\n}',
    },
    { label: 'vector', detail: 'std::vector', insertText: 'std::vector<int> ${1:name};' },
    {
      label: 'unordered_map',
      detail: 'std::unordered_map',
      insertText: 'std::unordered_map<int, int> ${1:name};',
    },
    { label: 'sort', detail: 'std::sort', insertText: 'std::sort(${1:begin}, ${2:end});' },
    {
      label: 'main',
      detail: 'main 函数',
      insertText: 'int main() {\n\t$0\n\treturn 0;\n}',
    },
  ],
  java: [
    { label: 'println', detail: 'System.out.println', insertText: 'System.out.println(${1:value});' },
    {
      label: 'for',
      detail: 'for 循环',
      insertText: 'for (int ${1:i} = 0; ${1:i} < ${2:n}; ${1:i}++) {\n\t$0\n}',
    },
    {
      label: 'main',
      detail: 'class + main 方法',
      insertText:
        'class ${1:Main} {\n\tpublic static void main(String[] args) {\n\t\t$0\n\t}\n}',
    },
    { label: 'ArrayList', detail: 'ArrayList 实例', insertText: 'new ArrayList<>()' },
    { label: 'HashMap', detail: 'HashMap 实例', insertText: 'new HashMap<>()' },
  ],
  python: [
    { label: 'print', detail: '输出', insertText: 'print(${1:value})' },
    {
      label: 'for',
      detail: 'for 循环',
      insertText: 'for ${1:item} in ${2:items}:\n\t$0',
    },
    { label: 'def', detail: '函数定义', insertText: 'def ${1:name}(${2:args}):\n\t$0' },
    {
      label: 'main',
      detail: '入口判断',
      insertText: 'if __name__ == "__main__":\n\t$0',
    },
    {
      label: 'comprehension',
      detail: '列表推导式',
      insertText: '[${1:expr} for ${2:item} in ${3:items}]',
    },
  ],
}

export const registerCompletionProviders = (monaco: Monaco): Array<{ dispose: () => void }> => {
  const disposables: Array<{ dispose: () => void }> = []
  for (const [languageId, keywords] of Object.entries(KEYWORDS)) {
    const snippets = SNIPPETS[languageId] ?? []
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
          const suggestions: languages.CompletionItem[] = [
            ...keywords.map((keyword) => ({
              label: keyword,
              kind: monaco.languages.CompletionItemKind.Keyword,
              insertText: keyword,
              range,
            })),
            ...snippets.map((snippet) => ({
              label: snippet.label,
              detail: snippet.detail,
              kind: monaco.languages.CompletionItemKind.Snippet,
              insertText: snippet.insertText,
              insertTextRules: monaco.languages.CompletionItemInsertTextRule.InsertAsSnippet,
              range,
            })),
          ]
          return { suggestions }
        },
      }),
    )
  }
  return disposables
}
