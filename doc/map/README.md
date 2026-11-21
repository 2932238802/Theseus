# Theseus 项目思维导图

项目全景的单页地图，覆盖定位、角色、架构、核心业务、数据模型、接口、安全运维、路线与文档代码入口。

## 打开方式

| 入口 | 说明 |
| --- | --- |
| [theseus-mindmap.html](./theseus-mindmap.html) | 推荐。离线交互版，无需安装依赖；点击节点展开/收起，滚轮缩放，拖拽平移，支持搜索 |
| [theseus-mindmap.md](./theseus-mindmap.md) | Mermaid mindmap 源图 + 纯文本大纲，适合 GitHub / VS Code 预览或 grep |
| [mindmap-data.js](./mindmap-data.js) | 唯一数据源 |

## 维护

```bash
# 改完 mindmap-data.js 后重新生成 Mermaid 与大纲
node doc/map/build-md.mjs
```

- 新增/调整节点只改 `mindmap-data.js` 的 `branches`，不要手改 `theseus-mindmap.md` 的生成段落。
- 状态口径以 `doc/AGENTS.md` 的进度快照与 `doc/STATUS.md` 为准；更新状态时同步顶部基线日期与提交号。
- 导图只放可验证事实，不写密钥、内网地址、真实用户隐私与隐藏用例内容。

## 内容来源

- `doc/总体设计.md`：定位、架构、业务模块、数据模型、接口、路线
- `doc/AGENTS.md`：当前进度快照与文档维护约定
- `doc/STATUS.md`：当前 CR、门禁、阻塞与下一步
- `backend-rust/`、`frontend-vue/`、`deploy/`：进程与代码入口

> 基线：2026-11-21 · `main` @ `fda4570` / `7448de9`
