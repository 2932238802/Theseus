# 项目状态面板

> 维护者：Doc Agent ｜ 最近更新：2026-11-20 ｜ 状态：进行中
> 本文件只记录当前状态，不承载需求细节；细节看对应文档。

## 当前

| 项 | 内容 |
| --- | --- |
| 当前 CR | CR-001 面经正文题目化 / CR-002 面经面试类型分类 / CR-003 HR 面模板 Wiki |
| 当前门禁 | **G4 通过（收尾提交中）** |
| 进行中任务 | P2-1 已完成；文档回填与补充提交 |
| 阻塞 | 无 |
| 下一步 | 提交补充提交并推送；P3 后续项不阻断 |
| 文档根目录 | `doc/` |
| 运行基线 | `main` @ `34ab300`；功能提交 `6db10be` 在 `feat/interview-revamp`，已推送 |
| 环境说明 | 当前为开发版，存量面经帖子为测试数据 |

## 角色记录

- 2026-11-19：建立 `doc/archive/`、`doc/reports/`、`doc/README.md` 与 `doc/STATUS.md`，对齐 Vesta 的文档归档约定。
- 2026-11-19：Doc Agent 完成只读调研：面经板块现状、`import_interview.sh --no-answers`、`update.sh` 数据脚本执行链路、现有分类与权限。
- 2026-11-19：用户确认 G1；6 项假设按默认值执行。开始 G2，派发 Dev Agent 执行 T-001。
- 2026-11-19：Dev Agent 交付 T-001 首版（迁移 0048/0049、模型、投影），报告 `doc/reports/dev-agent-2026-11-19-T-001-面经板块迁移.md`；空库/升级库与约束验证通过，`cargo test` 163 passed。
- 2026-11-19：Doc 核对发现 0049 外键用 BIGINT，与 `users.id SERIAL` 及项目惯例不符；已改开发文档为 INTEGER 并派返工 R1。
- 2026-11-19：预存在 clippy 基线问题：`src/utils/metrics.rs:260` 在 stable 1.100 触发 `needless_range_loop`，导致严格 clippy 失败；与本次改动无关，待用户决定是否单独建任务修复。
- 2026-11-19：发现仓库根目录新增未跟踪 `AGENTS.md` / `CLAUDE.md`（非本次任务产物）；用户确认保留。
- 2026-11-19：用户确认 clippy 基线问题单独建任务 T-008 先修，再继续 T-002。
- 2026-11-19：T-001 返工 R1 完成并核对通过；0049 外键已为 `INTEGER`，全新库与幂等验证通过，T-001 标记 DONE。开始 T-008。
- 2026-11-20：G4 P2-1 完成；`update.sh` 面经持续导入固定 `--no-answers`，`bash -n` 通过，dry-run 正文 150→76 字；报告 `doc/reports/dev-agent-2026-11-20-G4条件项-P2-1.md`。
- 2026-11-20：G4 总审 **通过**（无 P0/P1；22/22 AC 独立复现；62 项冒烟、42 项 Playwright UAT 全绿）。用户决策 P2-1 加 `--no-answers`、P2-2 保留板块切换。功能提交 `6db10be` 已推送 `feat/interview-revamp`。报告 `doc/reports/meta-2026-11-20-面经板块改版.md`。
- 2026-11-20：G3 复审 **通过**（无 P0/P1/P2；2 项 P3 非阻塞：冒烟 TMP_DIR 清理、模板顺序恢复标志）。报告 `doc/reports/review-agent-2026-11-20-G3返工复审.md`。进入 G4 总审。
- 2026-11-20：R1–R3 返工完成并核对；新增 `smoke_interview_templates.sh`（bash -n 通过，缺 jq 未实跑，独立 API E2E 46/46）；重建脚本增加作者 active 校验与空类型计数校验；报告 `doc/reports/dev-agent-2026-11-20-G3返工-R1-R3.md`。派发 G3 复审。
- 2026-11-20：G3 评审完成，结论 **有条件通过**（无 P0/P1；P2-1 冒烟未覆盖新接口、P2-2 面经类型空值约束、P2-3 重建脚本作者校验；P3-1 状态描述、P3-2 编辑兼容、P3-3 文档表述）。报告 `doc/reports/review-agent-2026-11-20-面经板块改版.md`。
- 2026-11-20：Doc 处理 R4/R6 并记录 R5；R2 采用「NULL 为重建前过渡态 + 重建脚本校验空类型数为 0」；R5 接受当前行为并在 `backend_api.md` 标明破坏性变更。派 Dev 返工 R1–R3。
- 2026-11-20：T-007 完成并核对；严格 clippy、163+5 tests、`vue-tsc`/build、47 项接口回归、`smoke_forum.sh` 22 通过、Playwright 36/36 + 失败注入 3/3；文档已同步 `backend_api.md` / `AGENTS.md` / `2610313` / 追溯矩阵。G2 关闭，派发 G3 独立评审。
- 2026-11-20：T-006 完成并核对；读者端模板页、HR 面入口、403 中性态完成，`vue-tsc`/build 通过，隔离 53 项 + 页面 SSR 9 项 + 入口 SSR 10 项通过；报告 `doc/reports/dev-agent-2026-11-19-T-006-读者端模板页.md`。T-006 标记 DONE，开始 T-007。
- 2026-11-20：T-005 完成并核对；`vue-tsc` 与 `npm run build` 通过，隔离脚本 55 项、编辑器 SSR 6 项通过；报告 `doc/reports/dev-agent-2026-11-19-T-005-管理端模板与编辑器.md`。T-005 标记 DONE，开始 T-006。
- 2026-11-20：T-003 完成并核对；`bash -n` 通过，临时 UTF8 库验证导入 9 篇（technical 8 / hr 1）、删除重建、备份失败中止、导入失败恢复提示；报告 `doc/reports/dev-agent-2026-11-19-T-003-面经导入与重建.md`。T-003 标记 DONE。
- 2026-11-20：T-004 完成并核对；`vue-tsc` 与 `npm run build` 通过，API/store 隔离验证 11/11；报告补写到 `doc/reports/dev-agent-2026-11-19-T-004-前端面经类型.md`。T-004 标记 DONE，开始 T-005。
- 2026-11-19：T-002 完成并核对；严格 clippy / fmt / test 通过，临时 UTF8 库 curl 69 项全过；报告由 Doc 补写到 `doc/reports/dev-agent-2026-11-19-T-002-面经后端接口.md`。开始 T-003 与 T-004 并行。
- 2026-11-19：T-008 完成并核对通过；`metrics.rs:260` 改为 `enumerate().skip(2)`，严格 clippy 恢复通过，T-008 标记 DONE。开始 T-002。
- 2026-11-19：产出 CR-001 / CR-002 / CR-003 需求卡、开发文档与 HTML 原型 `doc/mockups/interview-revamp.html`。
- 本轮起：Doc Agent 只维护文档与状态；开发、评审、总审分别交给 Dev / Review / Meta Agent。

## 任务概览

| 任务 | 状态 |
| --- | --- |
| T-001 数据迁移与模型 | DONE |
| T-002 后端接口 | DONE |
| T-003 导入与重建脚本 | DONE |
| T-004 前端面经类型 | DONE |
| T-005 管理端模板与编辑器 | DONE |
| T-006 读者端 HR 模板页与入口 | DONE |
| T-007 全量回归与文档同步 | DONE |
| T-008 修复 clippy 基线 | DONE |
| G3 返工 R1–R3 | DONE |
| G4 总审 | DONE（通过） |
| P2-1 `update.sh --no-answers` | DONE |
| P2-2 保留板块切换 | DONE（用户确认） |
| 补充提交（P2-1 + G4 文档） | DOING |
