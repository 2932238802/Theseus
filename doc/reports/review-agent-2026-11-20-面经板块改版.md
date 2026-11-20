# Review Agent 评审报告（G3）

> 说明：本文件由 Doc Agent 根据 Review Agent 返回内容落盘；Review Agent 运行环境未能直接写文件。

- 范围：`main` @ `34ab300` 工作区全部未提交改动；24 个已跟踪文件修改、19 个未跟踪路径（`doc/archive/`、`doc/reports/` 目录内共 30 个文件）；T-001 ~ T-008
- 评审类型：首次评审（G3 独立评审）
- 来源 CR：CR-001 / CR-002 / CR-003（需求卡 G0 已确认，用户已确认 G1）
- G1 / DoR：通过；G2 已关闭，无阻断缺口
- 结论：**有条件通过**
- 一句话理由：22 条 AC 全部由 Review Agent 独立复现通过，权限、迁移、XSS 与重建脚本主路径未发现 P0/P1；但仓库冒烟未覆盖新接口、DB 约束允许面经 `interview_type` 为空、重建脚本删除前未校验显式传入的作者，另有 3 项文档/兼容性小问题，需返工或书面接受。

## 评审基线

- 范围：CR-001 / CR-002 / CR-003；T-001 迁移与模型、T-002 后端接口、T-003 导入与重建、T-004 前端类型、T-005 管理端模板与编辑器、T-006 读者端模板页、T-007 回归与文档、T-008 clippy 基线
- 环境：Rust 1.100.0、Node 24.22.1、PostgreSQL 18、Playwright 1.66.0-alpha + chromium-1254
- 关联需求：R-001 / R-002 / R-003 v1
- AC 清单：AC-001-1 ~ 6、AC-002-1 ~ 6、AC-003-1 ~ 10，共 22 条
- 明确不在范围：历史 `knowledge_*` 下线逻辑、既有论坛/评论/点赞/收藏实现本身、Redis/判题链路、Docker 备份成功路径

## AC 判定

| AC | 判定 | 独立证据 |
|---|---|---|
| AC-001-1 | 通过 | 临时 PG 执行 `rebuild --no-backup --yes`：删除 4、导入 9、终态面经 9 > 0，退出 0 |
| AC-001-2 | 通过 | 重建后正文检索 `参考答案/回答示例/复盘/待补充/答案` 命中 0；样例正文仅 `## 题目` 与题号 |
| AC-001-3 | 通过 | 未传 `--yes`：输出计划，退出 0；前后数据不变 |
| AC-001-4 | 通过 | `--author nobody_here --no-backup --yes`：删除 9 后导入失败，退出 1，打印 `restore.sh`；综合板块 4 条不变；备份失败时退出 1 且未删除 |
| AC-001-5 | 通过 | Playwright：`.forum-compose-notice` 显示「正文不要写答案 答案由评论区补充」；发布按钮满足字段后启用；API 发帖 201 |
| AC-001-6 | 通过 | Playwright：`.forum-answer-hint` 显示「本面经只收录题目 答案由评论区补充」；评论 201、列表 200；点赞/收藏未改动 |
| AC-002-1 | 通过 | `hr` total=1 且类型均 hr；`technical` total=1；非法值 400；total 与库内计数一致 |
| AC-002-2 | 通过 | 发面经缺类型 400；未知值 400；综合带类型 400；Playwright 未选类型时发布按钮 disabled |
| AC-002-3 | 通过 | 详情返回 `interview_type=hr`；综合详情 null；卡片/详情仅面经且非空显示中文标签 |
| AC-002-4 | 通过 | 管理员改 technical→manager 200；列表/详情即时；非管理员 403、综合帖 400、不存在 404；审计前后值正确 |
| AC-002-5 | 通过 | 独立 dry-run 9 个用例：显式 type、round、标题、tags 行为面推断；无法识别默认 technical；非法 type 告警后回退 |
| AC-002-6 | 通过 | 综合列表带 `interview_type=hr` 被忽略；综合详情 null；DB 拒绝综合板块写非空类型；综合评论 201 |
| AC-003-1 | 通过 | 管理端 POST 201；读者端列表立即出现；Playwright 新建后读者端可见 |
| AC-003-2 | 通过 | 121 字标题/20001 字正文/空标题/空正文均 400；120/20000 边界 201；更新后读者详情立即变化 |
| AC-003-3 | 通过 | Playwright 二次确认后删除；重复删除 404；审计存在 |
| AC-003-4 | 通过 | Playwright 拖拽 PUT 200、DOM 顺序变化、刷新保持；注入 500 后恢复并提示；重复/缺项/未知 ID 400 |
| AC-003-5 | 通过 | Playwright：Ctrl+B=`**abc**`、Ctrl+I=`*abc*`、Ctrl+K=`[abc](https://)`；工具栏标题/列表/行内代码正确 |
| AC-003-6 | 通过 | 预览与读者页移除 `<script>`、`onerror`、`javascript:`；正常粗体保留 |
| AC-003-7 | 通过 | 未登录跳转登录；非 Plus 403 中性「当前账号无法查看该内容」；Plus 200 |
| AC-003-8 | 通过 | 全部/技术面无入口，HR 面出现；发布页仅选 HR 后出现；非 Plus 无入口 |
| AC-003-9 | 通过 | 模板相关文件与入口/提示检索 `VIP/Plus/升级` 命中 0 |
| AC-003-10 | 通过 | 模板独立表，不进入面经列表；CRUD 前后 `interview=9`、`general=4` 不变 |

## 验证执行

### 静态与构建

| 命令 | 结果 |
|---|---|
| `cargo fmt --check` | exit 0 |
| `cargo clippy --all-targets --all-features -- -D warnings` | exit 0 |
| `cargo test` | 163 lib + 5 judge_worker = 168 passed，0 failed |
| `npm run build`（含 `vue-tsc -b`） | exit 0 |
| `bash -n`：`import_interview.sh`、`rebuild_interview_posts.sh`、`update.sh` | 全部通过 |
| `git diff --check` | exit 0 |
| `smoke_forum.sh` | 未能执行：环境缺少 `jq`，脚本 exit 2；改用独立 API + Playwright 回归 |

### 数据库与迁移

| 验证 | 结果 |
|---|---|
| 全新库 0001~0049 | 49 个迁移成功 |
| 0048/0049 重复应用 | 幂等 |
| 从 0047 存量库升级 | 成功，旧数据保留；旧面经 `interview_type=NULL` |
| 外键类型 | `users.id=integer`，`created_by/updated_by=INTEGER` |
| 删除级联 | comments / likes / favorites 均 `ON DELETE CASCADE` |
| 约束 | 综合+非空类型、面经+非法类型被拒；面经+NULL 被允许（P2-2） |
| 索引 | 部分索引与排序索引存在 |

### 重建脚本（独立临时库）

| 场景 | 结果 |
|---|---|
| 预览 | 9 个文件、4 条面经、4 条综合；exit 0；库未变 |
| 备份失败 | 退出 1，未删除 |
| 可导入文件 0 | 退出 2，删除前中止 |
| 正常重建 | 删除 4、导入 9，technical=8、hr=1、NULL=0；exit 0 |
| 导入失败（错误作者） | 删除 9 后导入 0；exit 1；打印 restore；综合 4 不变 |
| 再次重建 | 删除 0、导入 9；exit 0 |
| 是否接入 update.sh | 未接入 |

### API 与 Playwright

- API：类型筛选、缺类型/未知/综合带类型、非 Plus 提权、管理端改类型与审计、模板 401/403/404/400、CRUD、排序、综合回归均通过
- Playwright：45/45 通过（主流程 27、拖拽 6、编辑器 7、编辑与跳转 5）

### 无法执行及影响

- `smoke_forum.sh`：缺 `jq`；已用独立 API/Playwright 覆盖同区域，但仓库级回归仍未验证（P2-1）
- 真实备份成功路径与 `--docker`：Docker 不可用
- 真实中文输入法 composition：未在浏览器验证
- Redis：未安装，本 CR 不依赖

## 维度结论

| 维度 | 结论 | 说明 |
|---|---|---|
| 需求覆盖 | 通过 | 22/22 AC 独立复现 |
| 正确性 | 通过 | 列表/详情/创建/编辑/管理端与契约一致 |
| 边界与错误处理 | 通过（有 P2） | 空值/未知/长度/404 正确；重建作者校验缺失 P2-3 |
| 安全 | 通过 | 非 Plus 不能借编辑绕过；模板读写鉴权正确；XSS 清洗有效 |
| 性能与资源 | 通过 | 部分索引、分页、无 N+1；未压测 |
| 并发与一致性 | 通过 | 排序事务、`FOR UPDATE`；并发创建同 sort_order 由 id 兜底 |
| 可维护性 | 通过 | 沿用 handler/service/model 分层 |
| 测试有效性 | 有条件 | 仓库冒烟未覆盖新功能（P2-1） |
| 文档一致性 | 有条件 | STATUS/README 与 backend_api 一处需修（P3-1/P3-3） |
| 范围与风险 | 通过 | 除 T-008 外无无关代码；无调试残留；无新依赖 |
| 用户注释保护 | 通过 | 0 处修改/删除/重排 |
| 回归与影响面 | 部分 | 论坛/面经/模板回归通过；smoke 未执行且未扩展 |
| AC 追溯 | 通过 | 22 条 AC 均有可复现证据 |
| NFR | 通过（有备注） | 安全/隐私/可观测达标；兼容性备注 P3-2 |

## 缺陷清单

未发现 P0 或 P1。

### [P2-1] 仓库冒烟测试未覆盖本次新增接口

- 位置：`doc/archive/20261119/4-面经板块改版-开发文档.md:178`；`backend-rust/scripts/smoke_forum.sh`
- 问题：影响分析要求补类型筛选与模板 CRUD 冒烟；脚本 `interview_type` / `interview/templates` 命中 0
- 影响：后续改动破坏类型筛选、模板 CRUD、排序或权限时，仓库内冒烟无法发现
- 证据：`grep -c "interview_type\|interview/templates" backend-rust/scripts/smoke_forum.sh` 返回 0
- 建议：补充 hr/technical 筛选与 total、非法值 400、非 Plus 403、模板 401/403、CRUD、排序 400、审计存在
- 置信度：高

### [P2-2] `interview_type` CHECK 允许面经板块为空

- 位置：`backend-rust/migrations/0048_forum_interview_type.sql:11-17`
- 问题：`interview_type IS NULL OR (board='interview' AND ...)` 允许面经+NULL，与「面经类型只允许四枚举、重建后不出现空值」不一致；强制只在 API/导入层
- 影响：类型筛选漏掉空类型帖；重建是否执行决定最终一致性
- 证据：临时库 `INSERT board='interview', interview_type NULL` 成功
- 建议：重建后追加约束 `CHECK (board <> 'interview' OR interview_type IS NOT NULL)`，或在文档明确 NULL 仅为过渡态，并在重建校验中要求空类型计数为 0
- 置信度：高

### [P2-3] 重建脚本删除前未校验显式 `--author`

- 位置：`backend-rust/scripts/rebuild_interview_posts.sh:160-169`、`:221-227`、`:279-298`
- 问题：只有未传 `--author` 时才自动解析管理员；显式作者不存在时仍先删除，导入时才报错
- 影响：`--no-backup` 时面经帖及评论/点赞/收藏删除后才发现前置条件错误
- 证据：`--no-backup --yes --author nobody_here`：删除 9 后导入失败，exit 1
- 建议：备份/删除前 `SELECT 1 FROM users WHERE username = ... AND status='active'`，失败 exit 2；导入成功后校验空类型计数为 0
- 置信度：高

### [P3-1] `STATUS.md` / `README.md` 状态描述与工作区不一致

- 位置：`doc/STATUS.md:16`、`doc/README.md:1`
- 问题：STATUS 写「工作区干净」，实际 43 项变更；README 状态仍为「草稿（待用户复核）」
- 建议：Doc 在 G3 结论落盘时同步修正

### [P3-2] 编辑既有面经不传 `interview_type` 返回 400

- 位置：`backend-rust/src/services/forum_service.rs:1025`
- 问题：旧客户端编辑面经不带类型会 400，与「新增字段向后兼容」存在张力
- 影响：旧缓存前端/脚本失败；新前端不受影响
- 建议：沿用当前类型，或在 backend_api/CHANGELOG 明确这是有意的破坏性变更
- 置信度：高

### [P3-3] `backend_api.md` 对综合板块忽略参数的表述不准确

- 位置：`doc/backend_api.md:531`
- 问题：文档写「`board=general` 时该参数被忽略」，但非法值仍返回 400
- 建议：改为「合法值在综合板块被忽略；未知值仍返回 400」

## 已检查且未发现问题的区域

- 迁移：全新/升级/幂等、外键 INTEGER、级联删除、部分索引
- 重建脚本：删除条件严格 `board='interview'`；备份失败中止；0 文件提前退出；导入失败 restore；未接入 update.sh
- 权限：匿名/非 Plus/Plus/管理员 矩阵；非 Plus 自综合帖改面经 403
- 安全：XSS 清洗有效；无自写清洗或 `v-html`；SQL 参数绑定；审计前后值正确
- 契约：类型筛选仅面经；非法值 400；模板长度边界；排序完整性
- 前端：类型 chips、必选、标签、提示、HR 入口、中性 403、无 VIP/Plus、900px、拖拽回滚、快捷键
- 文档：需求卡/AC 未被修改；主文档与实现基本一致
- 用户注释：0 处变更
- 其他：无调试残留；无新依赖

## 残留风险

- 真实 `backup.sh` 成功路径与 `--docker` 未运行
- `smoke_forum.sh` 未执行（缺 jq），仓库级回归未覆盖新接口
- 真实中文输入法 composition 未在浏览器验证
- Playwright 版本偏差（1.66.0-alpha + chromium-1254）
- 管理端目前只有改类型 API，没有改类型页面入口；与 G1 设计一致
- 并发排序/创建未做压力验证
- 面经旧数据在重建前保持 `interview_type=NULL`（P2-2 过渡态）

## 下一步交接

- G3 结论：**有条件通过**（无 P0/P1；P2-1 / P2-2 / P2-3；P3-1 / P3-2 / P3-3）
- 返工项编号：
  - R1 = P2-1 仓库冒烟补类型筛选与模板 CRUD
  - R2 = P2-2 面经 `interview_type` 空值不变量（收紧或书面接受）
  - R3 = P2-3 重建脚本删除前校验 `--author`
  - R4 = P3-1 STATUS/README 状态修正
  - R5 = P3-2 编辑兼容策略决定（沿用当前类型或记录破坏性变更）
  - R6 = P3-3 `backend_api.md` 综合板块忽略参数表述
- 建议下一步：先做 R1~R3 返工；R4~R6 由 Doc/Dev 同步修正或书面接受；完成后 Doc 复核并交 Meta Agent 走 G4
