# Review Agent 复审报告（G3 返工 R1–R3）

> 说明：本文件由 Doc Agent 根据 Review Agent 返回内容落盘；Review Agent 运行环境未直接写文件。

- 范围：`backend-rust/scripts/smoke_interview_templates.sh`（新增）、`backend-rust/scripts/rebuild_interview_posts.sh`（返工）、`doc/AGENTS.md`（R1 清单一处）、Doc 的 R4/R6 文档修正；基线 `main` @ `34ab300`，工作区未提交
- 评审类型：变更复审（只复核 R1/R2/R3 + 回归）
- 来源 CR：CR-001 / CR-002 / CR-003（G0 已确认，用户已确认 G1）
- G1 / DoR：通过；G2 已关闭
- 结论：**通过**
- 理由：R1 冒烟脚本补齐 jq 后真实执行 62/62 通过，清理只删自身数据且恢复全库模板顺序；R2 在临时 PostgreSQL 18.6 复现「正常 0 空值 / 注入空值 exit 1 并打印 restore」；R3 在备份/删除前校验作者，不存在/disabled 均 exit 2、计数不变、无备份无删除；`cargo fmt/clippy/test`、`bash -n`、`git diff --check`、`npm run build` 全绿；未改 Rust/前端业务代码，未引入回归。仅 2 项 P3 非阻塞建议。

## R1 / R2 / R3 判定

| 项 | 原 P2 | 判定 | 独立证据 |
|---|---|---|---|
| R1 | P2-1 仓库冒烟未覆盖新接口 | **已解决** | 实跑 `smoke_interview_templates.sh`：62 通过 / 0 失败 / exit 0（连续 3 次，含全新库）；覆盖 401/403/200、hr/technical 筛选 total=1 且类型一致、非法值 400、发帖三类 400、管理端改类型 + 审计前后值、模板 403/CRUD/121 字与 20001 字 400/读取/更新/重排/重复与缺项 400/删除与重复删除 404/四类审计 |
| R2 | P2-2 面经 `interview_type` 允许空 | **已解决（过渡态方案）** | 临时 PG 18.6（API 自动应用 49 迁移）：正常重建 exit 0、`hr=1/technical=8/NULL=0`；注入 1 条 NULL（总数仍 9）→ `[FAIL] ... 必须为 0` + restore，exit 1；再次正常重建恢复 NULL=0 |
| R3 | P2-3 删除前未校验显式 `--author` | **已解决** | `--author nobody_here --no-backup --yes` → exit 2，面经 1/综合 1 不变；`--author r13_disabled` → exit 2；带备份默认路径仍在 backup 前 exit 2；自动解析管理员预览正常；正常作者继续成功 |

关键实现：
- `rebuild_interview_posts.sh:178-187` `validate_author()`（username + status='active'，失败 exit 2）
- `:245-253` 在预览/备份（`:289`）/删除（`:305`）之前调用，显式与自动两路径覆盖
- `:189-193` `count_null_interview_types()`；`:362-368` 导入成功后要求为 0，否则 restore + exit 1
- `smoke_interview_templates.sh:199-228` 依赖检查；`:183-197` cleanup；`:419-442` 排序恢复

## 验证执行

| 命令 | 结果 |
|---|---|
| `cargo fmt --check` | exit 0 |
| 严格 clippy | exit 0 |
| `cargo test` | 163 lib + 5 judge_worker = 168 passed |
| `bash -n`（rebuild / smoke / import） | 全部通过 |
| `git diff --check` | exit 0 |
| `npm run build` | exit 0（built in 1.77s） |
| `smoke_interview_templates.sh` | 62 通过 / 0 失败 / exit 0（3 次） |
| 重建脚本 R2/R3（临时 PG 18.6） | 全部符合预期 |

说明：本机原本缺 jq，复审从 Ubuntu 的 jq/libjq1/libonig5 .deb 解包到 `/tmp` 仅作测试工具（未改仓库、未安装系统包），真实执行了冒烟；测试后端由当前源码 `cargo build`，API 在临时库 `127.0.0.1:3100`。

回归与清理：预置 2 个 sentinel 模板 + 1 条综合帖 + 9 条面经；冒烟后综合=1、面经=9 不变；sentinel 顺序完全恢复；`itsmoke_%` 用户/模板/帖子/审计残留均为 0。

## 维度结论

| 维度 | 结论 | 说明 |
|---|---|---|
| 需求覆盖（R1–R3） | 通过 | 三项返工全部落地并实跑验证 |
| 正确性 | 通过 | 断言与真实 API/DB 一致，无误报 |
| 边界与错误处理 | 通过 | 401/403/400/404/非法参数/作者不存在或 disabled/空类型均有判定 |
| 安全 | 通过 | 测试账号只读、无凭据输出；清理仅按 `itsmoke_%` |
| 测试有效性 | 通过 | 断言基于真实 HTTP 码、total、类型集合与 DB 审计列 |
| 文档一致性 | 通过 | AGENTS 清单已更新；R4/R6 修正到位 |
| 范围与风险 | 通过 | 返工窗口只改 2 个脚本 + AGENTS 一行；无 Rust/前端业务改动 |
| 用户注释保护 | 通过 | 0 处变更 |
| 回归与影响面 | 通过 | 全量回归绿；既有数据与模板顺序不变 |

## 新发现问题（P3，非阻塞）

### [P3] 冒烟脚本临时目录不会被清理

- 位置：`smoke_interview_templates.sh:41`、`:183-197`
- 问题：`:41` 的 `trap 'rm -rf "$TMP_DIR"' EXIT` 被 `:197` 的 `trap cleanup EXIT` 覆盖，`cleanup()` 未删除 `$TMP_DIR`
- 影响：每次运行残留 `/tmp/theseus-interview-smoke.XXXXXX`
- 建议：`cleanup()` 内追加 `rm -rf "$TMP_DIR"`

### [P3] 模板顺序恢复失败仍标记为已恢复

- 位置：`smoke_interview_templates.sh:172-181`、`:440-442`
- 问题：`restore_template_order()` 的 curl 带 `|| true` 后无条件 `ORDER_RESTORED=1`；`expect_status` 失败后也无条件置 1
- 影响：恢复 PUT 瞬时失败时 cleanup 不再重试，顺序可能保持反转
- 建议：仅在 HTTP 200 后置 `ORDER_RESTORED=1`，失败保留 0 供 cleanup 重试

## 文档同步检查

- `doc/AGENTS.md:83` 冒烟清单已补
- `doc/STATUS.md` 已更新为「G3 复审中 / R1–R3 完成 / R4/R6 修正 / R5 接受」，工作区不再写「干净」
- `doc/backend_api.md` 已修正综合板块参数表述，并标明编辑面经未回传类型返回 400 是有意的破坏性变更
- 开发文档 §8 已记录 R1–R6
- 需求卡与 AC 未被改动

## 范围结论

**是，只改 R1–R3。** 返工窗口内：
- Dev：`rebuild_interview_posts.sh`、`smoke_interview_templates.sh`、`doc/AGENTS.md`（一行）
- Doc：`doc/STATUS.md`、`doc/README.md`、`doc/backend_api.md`、`doc/archive/20261119/*`、`doc/reports/*`
- 未改动 `backend-rust/src/**` 或 `frontend-vue/src/**` 业务代码

## 残留风险

- 冒烟短暂反转全库模板顺序；正常/异常退出经 trap 恢复，SIGKILL + API 不可用时可能保持反转（低风险）
- 真实 `backup.sh` 成功路径与 `--docker` 未验证（Docker 不可用）
- 未做数千模板规模压测
- 真实中文输入法 composition 不在本轮范围
- `STATUS.md` 末尾「任务概览 暂无」为历史遗留小瑕疵

## 下一步交接

- 结论：**通过**，可进入 **G4**（2 项 P3 非阻塞，可并入后续维护）
- 交给：Meta Review Agent（G4 总审）
- 携带材料：本复审报告、首次 G3 报告、Dev 返工报告、需求卡与开发文档、`backend_api.md`、`STATUS.md`
- 基线：`main` @ `34ab300`，工作区未提交
