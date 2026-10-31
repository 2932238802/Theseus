import type { Monaco } from '@monaco-editor/loader'
import type { editor, IPosition, IRange } from 'monaco-editor'
import { fetchLspTicket } from '../api/lsp'
import type { Language } from '../types/oj'

export type LspLanguage = Extract<Language, 'cpp' | 'python'>

export type LspStatus = 'connecting' | 'ready' | 'error'

export interface LspSession {
  dispose: () => void
}

export interface LspSessionOptions {
  monaco: Monaco
  model: editor.ITextModel
  language: LspLanguage
  onStatus: (status: LspStatus) => void
}

const LSP_LANGUAGES: readonly string[] = ['cpp', 'python']
const COMPLETION_TIMEOUT_MS = 8_000
const HOVER_TIMEOUT_MS = 5_000
const INITIALIZE_TIMEOUT_MS = 30_000
const READY_TIMEOUT_MS = 15_000

export const isLspLanguage = (language: Language): language is LspLanguage =>
  LSP_LANGUAGES.includes(language)

interface JsonRpcMessage {
  id?: number | string | null
  method?: string
  params?: unknown
  result?: unknown
  error?: { code: number; message: string }
}

interface LspPosition {
  line: number
  character: number
}

interface LspRange {
  start: LspPosition
  end: LspPosition
}

interface LspTextEdit {
  range: LspRange
  newText: string
}

interface LspCompletionItem {
  label: string | { label: string; detail?: string; description?: string }
  kind?: number
  detail?: string
  documentation?: string | { kind: string; value: string }
  sortText?: string
  filterText?: string
  insertText?: string
  insertTextFormat?: number
  textEdit?: LspTextEdit | { insert: LspRange; replace: LspRange; newText: string }
  additionalTextEdits?: LspTextEdit[]
  preselect?: boolean
  deprecated?: boolean
}

interface LspCompletionList {
  isIncomplete?: boolean
  items: LspCompletionItem[]
}

interface LspHover {
  contents: unknown
  range?: LspRange
}

interface LspDiagnostic {
  range: LspRange
  severity?: number
  message: string
  source?: string
  code?: string | number
}

const resolveSocketUrl = (path: string, ticket: string): string => {
  const base = import.meta.env.VITE_API_BASE_URL ?? '/api'
  const normalized = base.replace(/\/$/, '')
  const url = new URL(
    `${normalized}${path}`,
    /^https?:\/\//.test(normalized) ? undefined : window.location.origin,
  )
  url.protocol = url.protocol === 'https:' ? 'wss:' : 'ws:'
  url.searchParams.set('ticket', ticket)
  return url.toString()
}

const toLspPosition = (position: { lineNumber: number; column: number }): LspPosition => ({
  line: position.lineNumber - 1,
  character: position.column - 1,
})

class LspSessionImpl implements LspSession {
  private readonly monaco: Monaco
  private readonly model: editor.ITextModel
  private readonly language: LspLanguage
  private readonly onStatus: (status: LspStatus) => void
  private socket: WebSocket | undefined
  private disposed = false
  private tornDown = false
  private ready = false
  private nextId = 1
  private version = 1
  private rootUri = ''
  private documentUri = ''
  private readonly pending = new Map<
    number,
    { resolve: (value: unknown) => void; reject: (error: Error) => void }
  >()
  private disposables: Array<{ dispose: () => void }> = []
  private readyWaiter:
    | { resolve: (rootUri: string) => void; reject: (error: Error) => void }
    | undefined

  constructor(options: LspSessionOptions) {
    this.monaco = options.monaco
    this.model = options.model
    this.language = options.language
    this.onStatus = options.onStatus
    this.onStatus('connecting')
    void this.connect()
  }

  dispose(): void {
    if (this.disposed) return
    this.disposed = true
    this.teardown()
  }

  private async connect(): Promise<void> {
    try {
      const ticket = await fetchLspTicket(this.language)
      if (this.disposed) return
      const socket = new WebSocket(resolveSocketUrl(ticket.path, ticket.ticket))
      this.socket = socket
      socket.addEventListener('message', (event) => this.handleMessage(event))
      socket.addEventListener('close', () => this.handleClose())
      socket.addEventListener('error', () => {
        // close 事件随后到达，统一在那里收尾。
      })

      const rootUri = await this.waitForReady()
      if (this.disposed) return
      this.rootUri = rootUri
      const extension = this.language === 'cpp' ? 'cpp' : 'py'
      this.documentUri = `${rootUri}/main.${extension}`

      const initResult = (await this.request(
        'initialize',
        this.initializeParams(),
        INITIALIZE_TIMEOUT_MS,
      )) as { capabilities?: { completionProvider?: { triggerCharacters?: unknown } } } | null
      if (this.disposed) return
      this.notify('initialized', {})
      this.notify('textDocument/didOpen', {
        textDocument: {
          uri: this.documentUri,
          languageId: this.language,
          version: this.version,
          text: this.model.getValue(),
        },
      })
      this.registerProviders(initResult)
      this.registerDocumentSync()
      this.ready = true
      this.onStatus('ready')
    } catch (error: unknown) {
      if (this.disposed) return
      console.error('语义补全连接失败', error)
      this.onStatus('error')
      this.teardown()
      this.disposed = true
    }
  }

  private initializeParams(): unknown {
    return {
      processId: null,
      clientInfo: { name: 'Theseus' },
      rootUri: this.rootUri,
      workspaceFolders: [{ uri: this.rootUri, name: 'theseus' }],
      capabilities: {
        textDocument: {
          synchronization: { dynamicRegistration: false },
          completion: {
            dynamicRegistration: false,
            completionItem: {
              snippetSupport: true,
              documentationFormat: ['markdown', 'plaintext'],
              insertReplaceSupport: true,
              textEditSupport: true,
              resolveSupport: {
                properties: ['documentation', 'detail', 'additionalTextEdits'],
              },
            },
          },
          hover: { dynamicRegistration: false, contentFormat: ['markdown', 'plaintext'] },
          publishDiagnostics: { relatedInformation: true, versionSupport: true },
        },
        workspace: { configuration: true, workspaceFolders: true },
        window: { workDoneProgress: true },
      },
      // 判题使用 C++17；clangd 在没有 compile_commands.json 时使用这组兜底参数。
      initializationOptions: this.language === 'cpp' ? { fallbackFlags: ['-std=c++17'] } : {},
    }
  }

  private waitForReady(): Promise<string> {
    return new Promise((resolve, reject) => {
      const timer = window.setTimeout(() => {
        this.readyWaiter = undefined
        reject(new Error('语言服务启动超时'))
      }, READY_TIMEOUT_MS)
      this.readyWaiter = {
        resolve: (rootUri) => {
          window.clearTimeout(timer)
          this.readyWaiter = undefined
          resolve(rootUri)
        },
        reject: (error) => {
          window.clearTimeout(timer)
          this.readyWaiter = undefined
          reject(error)
        },
      }
    })
  }

  private handleMessage(event: MessageEvent): void {
    let message: JsonRpcMessage
    try {
      message = JSON.parse(String(event.data)) as JsonRpcMessage
    } catch {
      return
    }
    if (message.method === 'theseus/ready') {
      const params = message.params as { rootUri?: unknown } | undefined
      if (typeof params?.rootUri === 'string') this.readyWaiter?.resolve(params.rootUri)
      return
    }
    if (message.method && message.id !== undefined && message.id !== null) {
      this.respondToServerRequest(message)
      return
    }
    if (message.method) {
      this.handleNotification(message.method, message.params)
      return
    }
    if (typeof message.id !== 'number') return
    const entry = this.pending.get(message.id)
    if (!entry) return
    this.pending.delete(message.id)
    if (message.error) entry.reject(new Error(message.error.message))
    else entry.resolve(message.result)
  }

  private respondToServerRequest(message: JsonRpcMessage): void {
    const id = message.id
    let result: unknown = null
    if (message.method === 'workspace/configuration') {
      const params = message.params as { items?: unknown[] } | undefined
      result = Array.isArray(params?.items) ? params.items.map(() => null) : []
    } else if (message.method === 'workspace/workspaceFolders') {
      result = [{ uri: this.rootUri, name: 'theseus' }]
    } else if (message.method === 'workspace/applyEdit') {
      result = { applied: false }
    }
    this.sendRaw({ jsonrpc: '2.0', id, result })
  }

  private handleNotification(method: string, params: unknown): void {
    if (method === 'textDocument/publishDiagnostics') {
      this.applyDiagnostics(params as { uri?: string; diagnostics?: LspDiagnostic[] })
    }
  }

  private applyDiagnostics(params: {
    uri?: string
    diagnostics?: LspDiagnostic[]
  }): void {
    if (this.disposed || this.model.isDisposed() || params.uri !== this.documentUri) return
    if (!Array.isArray(params.diagnostics)) return
    const markers = params.diagnostics.map((diagnostic) => ({
      severity: this.markerSeverity(diagnostic.severity),
      startLineNumber: diagnostic.range.start.line + 1,
      startColumn: diagnostic.range.start.character + 1,
      endLineNumber: diagnostic.range.end.line + 1,
      endColumn: diagnostic.range.end.character + 1,
      message: diagnostic.message,
      source: diagnostic.source ?? 'language server',
      code:
        diagnostic.code === undefined || diagnostic.code === null
          ? undefined
          : String(diagnostic.code),
    }))
    this.monaco.editor.setModelMarkers(this.model, 'lsp', markers)
  }

  private markerSeverity(severity: number | undefined): number {
    switch (severity) {
      case 1:
        return this.monaco.MarkerSeverity.Error
      case 2:
        return this.monaco.MarkerSeverity.Warning
      case 3:
        return this.monaco.MarkerSeverity.Info
      case 4:
        return this.monaco.MarkerSeverity.Hint
      default:
        return this.monaco.MarkerSeverity.Info
    }
  }

  private registerProviders(
    initResult: { capabilities?: { completionProvider?: { triggerCharacters?: unknown } } } | null,
  ): void {
    const advertised = initResult?.capabilities?.completionProvider?.triggerCharacters
    const triggers = Array.isArray(advertised)
      ? advertised.filter(
          (character): character is string =>
            typeof character === 'string' && character.length > 0,
        )
      : []
    this.disposables.push(
      this.monaco.languages.registerCompletionItemProvider(this.language, {
        triggerCharacters: triggers.length ? triggers : ['.', ':', '>'],
        provideCompletionItems: (model: editor.ITextModel, position: IPosition) =>
          this.provideCompletion(model, position),
      }),
    )
    this.disposables.push(
      this.monaco.languages.registerHoverProvider(this.language, {
        provideHover: (model: editor.ITextModel, position: IPosition) =>
          this.provideHover(model, position),
      }),
    )
  }

  private registerDocumentSync(): void {
    this.disposables.push(
      this.model.onDidChangeContent((event) => {
        if (!this.ready || this.disposed) return
        this.version += 1
        // Monaco 给出的 range 基于变更前的文档；从后往前发送，
        // 依次应用时前面的位置不会受后面编辑影响。
        const contentChanges = [...event.changes]
          .sort((left, right) => right.rangeOffset - left.rangeOffset)
          .map((change) => ({
            range: {
              start: {
                line: change.range.startLineNumber - 1,
                character: change.range.startColumn - 1,
              },
              end: {
                line: change.range.endLineNumber - 1,
                character: change.range.endColumn - 1,
              },
            },
            rangeLength: change.rangeLength,
            text: change.text,
          }))
        this.notify('textDocument/didChange', {
          textDocument: { uri: this.documentUri, version: this.version },
          contentChanges,
        })
      }),
    )
  }

  private async provideCompletion(
    model: editor.ITextModel,
    position: { lineNumber: number; column: number },
  ): Promise<{ suggestions: unknown[] }> {
    if (!this.ready || this.disposed || model !== this.model) return { suggestions: [] }
    const word = model.getWordUntilPosition(position)
    const fallbackRange = new this.monaco.Range(
      position.lineNumber,
      word.startColumn,
      position.lineNumber,
      word.endColumn,
    )
    try {
      const result = (await this.request(
        'textDocument/completion',
        {
          textDocument: { uri: this.documentUri },
          position: toLspPosition(position),
        },
        COMPLETION_TIMEOUT_MS,
      )) as LspCompletionItem[] | LspCompletionList | null
      const items = Array.isArray(result) ? result : (result?.items ?? [])
      return { suggestions: items.map((item) => this.toSuggestion(item, fallbackRange)) }
    } catch (error: unknown) {
      console.warn('补全请求失败', error)
      return { suggestions: [] }
    }
  }

  private async provideHover(
    model: editor.ITextModel,
    position: { lineNumber: number; column: number },
  ): Promise<{ contents: Array<{ value: string }>; range?: unknown } | null> {
    if (!this.ready || this.disposed || model !== this.model) return null
    try {
      const result = (await this.request(
        'textDocument/hover',
        {
          textDocument: { uri: this.documentUri },
          position: toLspPosition(position),
        },
        HOVER_TIMEOUT_MS,
      )) as LspHover | null
      const contents = toMarkdownHover(result?.contents)
      if (!contents) return null
      return {
        contents: [{ value: contents }],
        range: result?.range ? this.toMonacoRange(result.range) : undefined,
      }
    } catch (error: unknown) {
      console.warn('悬停请求失败', error)
      return null
    }
  }

  private toSuggestion(
    item: LspCompletionItem,
    fallbackRange: IRange,
  ): Record<string, unknown> {
    const label = typeof item.label === 'string' ? item.label : item.label.label
    const detail =
      typeof item.label === 'string'
        ? item.detail
        : [item.label.detail, item.label.description].filter(Boolean).join(' ')
    let range = fallbackRange
    let insertText = item.insertText ?? label
    const textEdit = item.textEdit
    if (textEdit) {
      if ('range' in textEdit) {
        range = this.toMonacoRange(textEdit.range)
      } else {
        range = this.toMonacoRange(textEdit.replace)
      }
      insertText = textEdit.newText
    }
    const suggestion: Record<string, unknown> = {
      label,
      kind: this.completionKind(item.kind),
      detail: detail || undefined,
      documentation: toDocumentation(item.documentation),
      sortText: item.sortText,
      filterText: item.filterText,
      insertText,
      range,
      preselect: item.preselect,
      tags: item.deprecated ? [this.monaco.languages.CompletionItemTag.Deprecated] : undefined,
    }
    if (item.insertTextFormat === 2) {
      suggestion.insertTextRules =
        this.monaco.languages.CompletionItemInsertTextRule.InsertAsSnippet
    }
    if (item.additionalTextEdits?.length) {
      suggestion.additionalTextEdits = item.additionalTextEdits.map((edit) => ({
        range: this.toMonacoRange(edit.range),
        text: edit.newText,
      }))
    }
    return suggestion
  }

  private completionKind(kind: number | undefined): number {
    const kinds = this.monaco.languages.CompletionItemKind
    switch (kind) {
      case 1:
        return kinds.Text
      case 2:
        return kinds.Method
      case 3:
        return kinds.Function
      case 4:
        return kinds.Constructor
      case 5:
        return kinds.Field
      case 6:
        return kinds.Variable
      case 7:
        return kinds.Class
      case 8:
        return kinds.Interface
      case 9:
        return kinds.Module
      case 10:
        return kinds.Property
      case 11:
        return kinds.Unit
      case 12:
        return kinds.Value
      case 13:
        return kinds.Enum
      case 14:
        return kinds.Keyword
      case 15:
        return kinds.Snippet
      case 16:
        return kinds.Color
      case 17:
        return kinds.File
      case 18:
        return kinds.Reference
      case 19:
        return kinds.Folder
      case 20:
        return kinds.EnumMember
      case 21:
        return kinds.Constant
      case 22:
        return kinds.Struct
      case 23:
        return kinds.Event
      case 24:
        return kinds.Operator
      case 25:
        return kinds.TypeParameter
      default:
        return kinds.Text
    }
  }

  private toMonacoRange(range: LspRange): IRange {
    return new this.monaco.Range(
      range.start.line + 1,
      range.start.character + 1,
      range.end.line + 1,
      range.end.character + 1,
    )
  }

  private request(method: string, params: unknown, timeoutMs = 10_000): Promise<unknown> {
    return new Promise((resolve, reject) => {
      if (!this.socket || this.socket.readyState !== WebSocket.OPEN) {
        reject(new Error('语言服务未连接'))
        return
      }
      const id = this.nextId++
      const timer = window.setTimeout(() => {
        this.pending.delete(id)
        reject(new Error(`${method} 请求超时`))
      }, timeoutMs)
      this.pending.set(id, {
        resolve: (value) => {
          window.clearTimeout(timer)
          resolve(value)
        },
        reject: (error) => {
          window.clearTimeout(timer)
          reject(error)
        },
      })
      this.sendRaw({ jsonrpc: '2.0', id, method, params })
    })
  }

  private notify(method: string, params: unknown): void {
    this.sendRaw({ jsonrpc: '2.0', method, params })
  }

  private sendRaw(message: unknown): void {
    if (!this.socket || this.socket.readyState !== WebSocket.OPEN) return
    this.socket.send(JSON.stringify(message))
  }

  private handleClose(): void {
    if (this.disposed) return
    this.onStatus('error')
    this.teardown()
    this.disposed = true
  }

  private teardown(): void {
    if (this.tornDown) return
    this.tornDown = true
    this.ready = false
    for (const disposable of this.disposables) disposable.dispose()
    this.disposables = []
    for (const entry of this.pending.values()) entry.reject(new Error('语言服务已断开'))
    this.pending.clear()
    this.readyWaiter?.reject(new Error('语言服务已断开'))
    this.readyWaiter = undefined
    try {
      if (!this.model.isDisposed()) this.monaco.editor.setModelMarkers(this.model, 'lsp', [])
    } catch {
      // 编辑器已经销毁时不再清理标记。
    }
    try {
      this.socket?.close()
    } catch {
      // 连接尚未建立或已关闭时忽略。
    }
    this.socket = undefined
  }
}

const toDocumentation = (
  documentation: LspCompletionItem['documentation'],
): string | { value: string } | undefined => {
  if (!documentation) return undefined
  if (typeof documentation === 'string') return documentation
  return { value: documentation.value }
}

const toMarkdownHover = (contents: unknown): string | null => {
  if (contents === null || contents === undefined) return null
  if (typeof contents === 'string') return contents
  if (Array.isArray(contents)) {
    const parts = contents.map(toMarkdownHover).filter((part): part is string => Boolean(part))
    return parts.length ? parts.join('\n\n') : null
  }
  if (typeof contents === 'object') {
    const value = contents as { kind?: string; value?: unknown; language?: string }
    if (typeof value.value !== 'string') return null
    if (typeof value.language === 'string') {
      return `\`\`\`${value.language}\n${value.value}\n\`\`\``
    }
    return value.value
  }
  return null
}

export const createLspSession = (options: LspSessionOptions): LspSession =>
  new LspSessionImpl(options)
