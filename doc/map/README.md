# Theseus 项目思维导图

项目全景地图。HTML 版由 [Archify](https://github.com/tt-a1i/archify) 的 `tree` 渲染器生成，覆盖 13 个能力域与关键能力节点；完整 352 节点大纲保留在 Markdown 版。

## 打开方式

| 入口 | 说明 |
| --- | --- |
| [theseus-mindmap.html](./theseus-mindmap.html) | 推荐。Archify 交互版：深浅主题、节点索引、搜索、导出 SVG / PNG / WebM |
| [theseus-mindmap.md](./theseus-mindmap.md) | 完整 Mermaid mindmap + 纯文本大纲，适合 grep、GitHub / VS Code 预览 |
| [theseus-mindmap.tree.json](./theseus-mindmap.tree.json) | Archify tree 的输入 JSON（13 个分支，93 个节点） |
| [mindmap-data.js](./mindmap-data.js) | 完整 352 节点的数据源，供 Markdown 生成 |

## 维护

```bash
# 1. 更新完整大纲：改 mindmap-data.js 后重新生成 Markdown
node doc/map/build-md.mjs

# 2. 更新 HTML 高层导图：改 build-tree.mjs 的 BLUEPRINT 后生成 Archify JSON
node doc/map/build-tree.mjs

# 3. 用 Archify 重新渲染并跑完整门禁（validate / deliver / check / browser-check）
ARCHIFY_CHROME=<chrome 路径> node <archify>/bin/archify.mjs finalize tree \
  doc/map/theseus-mindmap.tree.json doc/map/theseus-mindmap.html \
  --quality showcase --json
```

- HTML 只放高层能力地图；更细的节点写入 Markdown 版，避免树宽超过可读性下限。
- 状态口径以 `doc/AGENTS.md` 的进度快照与 `doc/STATUS.md` 为准；更新状态时同步顶部基线日期与提交号。
- 导图只放可验证事实，不写密钥、内网地址、真实用户隐私与隐藏用例内容。
- `finalize` 生成的 `*.finalize.json`、`*.finalize-summary.json`、`*.delivery.json`、`*.browser-check.json` 是本地校验回执，不提交。

## 内容来源

- `doc/总体设计.md`：定位、架构、业务模块、数据模型、接口、路线
- `doc/AGENTS.md`：当前进度快照与文档维护约定
- `doc/STATUS.md`：当前 CR、门禁、阻塞与下一步
- `backend-rust/`、`frontend-vue/`、`deploy/`：进程与代码入口

> 基线：2026-11-21 · `main` @ `fda4570` / `7448de9` · Archify 3.2.0
