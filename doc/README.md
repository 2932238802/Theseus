> 维护者：Doc Agent ｜ 最近更新：2026-11-21 ｜ 状态：CR-004 依赖安全修复已提交 `fda4570`；面经改版 G4 通过 `7448de9`（功能 `6db10be`）

# Theseus 文档索引

`doc/` 根目录只保留现状文档（`总体设计.md`、`backend_api.md`、`STATUS.md`）、面经、原型与报告；开发文档统一归档到 `archive/YYYYMMDD/`，流程状态看 `STATUS.md`。

| 入口 | 内容 |
| --- | --- |
| [STATUS.md](./STATUS.md) | 当前 CR、门禁、进行中任务、阻塞、下一步 |
| [archive/](./archive/) | 历史需求方案与实施台账，按 `YYYYMMDD` 归档 |
| [AGENTS.md](./AGENTS.md) | 既有设计文档地图与当前进度快照 |
| [总体设计.md](./总体设计.md) | 产品定位、架构、权限、数据模型、接口、路线与总体进度 |
| [backend_api.md](./backend_api.md) | 后端接口契约与错误码 |
| [interview/](./interview/) | 面经原始 Markdown，按公司/岗位/轮次存放 |
| [mockups/](./mockups/) | 页面原型 HTML |
| [reports/](./reports/) | 各角色报告 |
| [map/](./map/) | 项目全景思维导图（离线交互 HTML + Mermaid 源图） |

- 新增开发文档统一放到 `archive/YYYYMMDD/`，文件名沿用 `序号-主题-文档类型.md`。
- 2026-11-21 起，根目录历史设计文档（`2610xxx` / `2611xxx`）已删除；需要追溯时从 git 历史（`fda4570` 及更早提交）查看。
- 版本、进度与接口以代码和 `AGENTS.md` 的进度快照为准。
