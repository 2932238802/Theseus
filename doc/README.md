> 维护者：Doc Agent ｜ 最近更新：2026-11-20 ｜ 状态：G4 通过，已提交 `6db10be`

# Theseus 文档索引

`doc/` 保留既有设计文档；新增需求按 `archive/YYYYMMDD/` 归档，流程状态看 `STATUS.md`。

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

- 新增需求先写需求卡，确认后再写开发文档；文件名沿用 `序号-主题-文档类型.md`。
- 既有 `YYMMDDNN_主题.md` 设计文档保持原位，不重命名、不搬迁。
- 版本、进度与接口以代码和 `AGENTS.md` 的进度快照为准。
