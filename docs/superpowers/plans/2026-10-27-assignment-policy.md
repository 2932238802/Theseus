# 作业策略 Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** 按 `doc/2610271_作业策略的实现.md` 实现迟交、重交、计分、可见性、补交/免修、解析、统计与审计。

**Architecture:** 以 `assignments` 类型化策略字段为核心，新增学生例外表和审计表；后端新增纯函数 `assignment_policy` 模块统一计分；提交、详情、批改台共用该模块。

**Tech Stack:** Rust/Axum/SQLx/PostgreSQL/Redis、Vue 3/Pinia/TypeScript。

**Spec:** `doc/2610271_作业策略的实现.md`

---

## File Structure

- `backend-rust/migrations/0009_assignment_policies.sql`：策略字段、例外表、审计表、索引。
- `backend-rust/src/services/assignment_policy.rs`：纯计分/可见性函数与单元测试。
- `backend-rust/src/models/teaching.rs`：策略请求/响应 DTO。
- `backend-rust/src/services/assignment_service.rs`：创建/更新/详情/策略写入。
- `backend-rust/src/services/submission_service.rs`：提交窗口、次数、免修校验。
- `backend-rust/src/services/grade_service.rs`：批改台/统计使用统一计分。
- `backend-rust/src/handlers/assignment_handler.rs`、`routes/mod.rs`：例外、解析、统计、审计、他人代码接口。
- `frontend-vue/src/types/policy.ts`、`api/policies.ts`、`types/teaching.ts`、`api/assignments.ts`、`api/teachingAdapters.ts`：类型与 API。
- `frontend-vue/src/views/AssignmentComposePage.vue`、`AssignmentDetailPage.vue`、`GradebookPage.vue`：交互。
- `backend-rust/scripts/smoke_assignment_policy.sh`：真实接口冒烟。

---

## Task 1: 数据库迁移

**Files:** Create `backend-rust/migrations/0009_assignment_policies.sql`

- [ ] 写迁移：`assignments` 策略字段与 CHECK；`assignment_problems` 的 `solution_md/max_attempts`；`submissions` 的 `is_late/late_days`；`assignment_student_overrides`；`assignment_policy_audits`；索引。
- [ ] 运行 `cargo check` 确认没有 SQL 编译期依赖（迁移在启动时执行）。
- [ ] 用本地数据库启动后端或执行迁移 SQL 验证语法。

## Task 2: 策略纯函数与单元测试（TDD）

**Files:** Create `backend-rust/src/services/assignment_policy.rs`; Modify `services/mod.rs`

- [ ] 先写测试：迟交天数取整、宽限期、封顶、三种计分、免修优先级、手动分、可见性。
- [ ] 运行 `cargo test assignment_policy`，确认失败。
- [ ] 实现 `effective_deadline`、`submission_window_end`、`raw_late_days`、`effective_late_days`、`late_deduction`、`select_scoring_submission`、`compute_problem_grade`、`is_score_visible`、`is_solution_visible`。
- [ ] 运行 `cargo test assignment_policy`，确认通过。

## Task 3: 请求/响应模型与校验

**Files:** Modify `models/teaching.rs`、`services/assignment_service.rs`

- [ ] 扩展 `CreateAssignmentRequest`、`UpdateAssignmentRequest`、`AssignmentProblemInput`。
- [ ] 扩展 `AssignmentProblemView`、`AssignmentDetail`、`GradebookCell`、`GradebookAssignment`。
- [ ] 增加策略枚举常量与 `validate_policy_input`。
- [ ] 运行 `cargo test`。

## Task 4: 创建/更新/详情

**Files:** Modify `services/assignment_service.rs`

- [ ] 创建时写入策略字段和题目解析/次数覆盖。
- [ ] 草稿更新允许全部策略；发布后只允许延期并写审计。
- [ ] `detail` 返回有效截止、次数、迟交、免修、解析和可见性字段。
- [ ] 运行 `cargo test`。

## Task 5: 提交校验与快照

**Files:** Modify `services/submission_service.rs`

- [ ] `precheck_assignment` 查询策略、例外、次数。
- [ ] `persist_submission` 在事务内重新校验窗口、免修、次数，并写 `is_late/late_days`。
- [ ] 系统错误不计次数；错误文案按设计文档。
- [ ] 运行 `cargo test`。

## Task 6: 批改台计分

**Files:** Modify `services/grade_service.rs`

- [ ] 聚合查询补充提交时间和状态。
- [ ] 用 `assignment_policy` 计算自动分、迟交扣分、免修和最终分。
- [ ] 响应增加迟交、次数、免修字段。
- [ ] 运行 `cargo test`。

## Task 7: 例外/解析/统计/审计/他人代码接口

**Files:** Modify `models/teaching.rs`、`services/assignment_service.rs`、`services/grade_service.rs`、`handlers/assignment_handler.rs`、`routes/mod.rs`

- [ ] 实现 `PUT/DELETE /overrides/...`、`GET /overrides`。
- [ ] 实现 `POST /solutions/publish`。
- [ ] 实现 `GET /statistics`、`GET /policy-audits`、`GET /peer-submissions`。
- [ ] 所有写操作写审计和站内通知。
- [ ] 运行 `cargo test` + 手工 curl 验证。

## Task 8: 前端类型与 API

**Files:** Create `types/policy.ts`、`api/policies.ts`; Modify `types/teaching.ts`、`api/assignments.ts`、`api/teachingAdapters.ts`

- [ ] 类型映射 snake_case → camelCase。
- [ ] 封装策略、例外、解析、统计、审计、他人代码 API。
- [ ] 运行 `npm run build`。

## Task 9: 前端页面

**Files:** Modify `AssignmentComposePage.vue`、`AssignmentDetailPage.vue`、`GradebookPage.vue`; Create policy components

- [ ] 策略编辑区与逐题解析/次数。
- [ ] 学生详情：有效截止、次数、迟交提示、免修、解析、统计、他人代码。
- [ ] 批改台：迟交/次数/免修标记，补交/免修对话框，审计抽屉。
- [ ] 运行 `npm run build`。

## Task 10: 冒烟与文档

**Files:** Create `backend-rust/scripts/smoke_assignment_policy.sh`; Modify `doc/总体设计.md`、`doc/AGENTS.md`、`doc/backend_api.md`、`doc/2610259_班级与作业设计方案.md`

- [ ] 覆盖设计文档 §10.2 的用例。
- [ ] 更新进度快照为已完成/部分完成的事实描述。
- [ ] 运行 `cargo test`、`npm run build`、冒烟脚本。

---

## 执行顺序

Task 1 → 2 → 3 → 4 → 5 → 6 → 7 → 8 → 9 → 10。每个 Task 完成后运行对应验证命令；P1 到 Task 6，P2 为 Task 7-9。
