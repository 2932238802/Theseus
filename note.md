# Theseus 项目全景梳理

> 学习助手笔记 · 2026-11-02
> 目标：把「一个校内算法训练平台」拆成可理解、可追踪、可动手验证的知识地图
> 覆盖：backend-rust / frontend-vue / deploy / doc

---

## 0. 一句话理解这个项目

Theseus 是一个**模块化单体 + 异步 Worker + 单页前端**的校内 OJ 平台

用户侧有四条主线

1. **刷题**：看题 → 写代码 → 运行 → 提交判题 → 看结果
2. **教学**：教师建班 → 布置作业 → 学生提交 → 评分 / 申诉 / 统计
3. **竞赛**：4 人排位匹配 → 限时答题 → 排行榜 → 段位结算 → 申诉
4. **社区**：论坛 / 面经 / 题解 / 笔记 / 通知 / Plus 会员

工程上最值得学习的三件事

- **同步请求与异步判题的分界**：HTTP 只负责收单，判题交给 Redis Stream + Worker
- **事实来源与缓存的分工**：PostgreSQL 是真相，Redis 只做队列、状态缓存、结果广播
- **失败关闭（fail-closed）**：没有 Worker 心跳就拒绝提交，而不是让任务无限排队

---

## 1. 先建立三条主线

### 1.1 同步请求主线

```text
Browser
  → Vite 代理 / Nginx 反代（同源 /api）
  → Axum Router（routes/mod.rs）
  → Handler（解析参数、认证、调用 Service）
  → Service（业务规则 + SQLx 查询）
  → PostgreSQL
  → ApiResponse { success, data, error }
  → Axios 拦截器 → Pinia Store / 页面状态
```

### 1.2 异步判题主线

```text
POST /api/submissions
  → 写 submissions 行（pending）
  → XADD Redis Stream
  → judge_worker XREADGROUP
  → Docker / gVisor 沙箱执行
  → 写回判题结果
  → Redis 状态缓存 + PUBLISH 终态事件
  → API 进程订阅事件
  → WebSocket 推送 submission.result
```

### 1.3 实时通知主线

```text
任意业务写 notifications 表（单条 / 群发 / 批量 INSERT）
  → API 进程 realtime_fanout_loop 每 2 秒读表尾增量
  → RealtimeHub 按 user_id 广播
  → WebSocket 连接
  → 前端 onRealtime('notification.new')
```

关键思想：**WebSocket 只是传输层，事件丢了就以数据库快照为准**

---

## 2. 目录地图

```text
Theseus/
├── backend-rust/          Rust 后端
│   ├── src/
│   │   ├── main.rs         API 进程装配 + 后台循环
│   │   ├── lib.rs          AppState 与模块导出
│   │   ├── config.rs       环境变量解析与校验
│   │   ├── routes/         全部 REST 路由表
│   │   ├── handlers/       HTTP 适配层（提取器 → Service）
│   │   ├── services/       业务层（规则 + SQL）
│   │   ├── models/         DTO、状态常量、响应结构
│   │   ├── middleware/     认证函数（不是全局中间件）
│   │   ├── judge/          队列、沙箱、语言 harness、结果比较
│   │   ├── realtime.rs     进程内广播中心
│   │   ├── utils/          JWT / 密码 / 限流 / 指标
│   │   └── bin/            judge_worker / anticheat_worker / lsp_gateway
│   ├── migrations/         43 个按序 SQL 迁移
│   └── scripts/            种子数据与真实链路冒烟脚本
├── frontend-vue/          Vue 3 SPA
│   ├── src/views/         页面级组件（按路由懒加载）
│   ├── src/components/    可复用组件
│   ├── src/api/           Axios 封装 + 后端类型适配
│   ├── src/store/         Pinia 共享状态
│   ├── src/router/        路由表 + 角色守卫
│   ├── src/utils/         会话、实时连接、编辑器、主题等
│   └── src/styles/        按领域拆分的 CSS
├── deploy/                Compose、Nginx、备份恢复、管理员脚本
├── doc/                   总体设计、接口契约、按功能的设计文档
├── dev.sh                 本地一键启动
└── update.sh              服务器增量更新
```

---

## 3. 运行时拓扑

```text
                ┌──────────────────────────────┐
                │           Nginx / Vite        │
                │   静态资源 + /api 反向代理      │
                └──────────────┬───────────────┘
                               │
                ┌──────────────▼───────────────┐
                │        backend-rust (API)     │
                │  Axum + SQLx + RealtimeHub    │
                │  6 个 tokio 后台循环            │
                └───┬──────────┬──────────┬────┘
                    │          │          │
          ┌─────────▼──┐  ┌────▼─────┐  ┌─▼──────────────┐
          │ PostgreSQL │  │  Redis   │  │ 本地 uploads/   │
          │ 事实来源    │  │ Streams  │  │ 头像等文件      │
          └────────────┘  │ 缓存     │  └────────────────┘
                          │ Pub/Sub  │
                          └────┬─────┘
                               │
          ┌────────────────────┼────────────────────┐
          │                    │                    │
   ┌──────▼──────┐      ┌──────▼───────┐     ┌──────▼────────┐
   │ judge_worker│      │anticheat_   │     │ lsp_gateway   │
   │ run+submit  │      │worker       │     │ 语义补全       │
   └──────┬──────┘      └──────────────┘     └───────────────┘
          │
   ┌──────▼──────────────────────────────┐
   │ Docker / gVisor (runsc) 沙箱         │
   │ Python · Node · C++ · Java           │
   └─────────────────────────────────────┘
```

### API 进程里的 6 个后台循环

`backend-rust/src/main.rs:47-54`

| 循环 | 作用 | 关键点 |
|---|---|---|
| `email_dispatch_loop` | 通知偏好转邮件 → 邮件 outbox 投递 | SMTP 延迟不阻塞注册/重置密码 |
| `contest_settlement_loop` | 竞赛到场扫描、到期结算、赛事置顶过期 | 每 5 秒，结算幂等 |
| `plus_reminder_loop` | Plus 到期前 7/3/1 天提醒 | 每小时检查 |
| `realtime_fanout_loop` | 读 notifications 表尾增量并推送 | 覆盖所有写入路径 |
| `submission_result_relay` | 订阅 Redis Pub/Sub，转 WebSocket | 断线 3 秒重连 |
| `reaper_loop` | 过期排队/执行中的 run 与 submission | 放在 API 进程，专治 Worker 不在线 |

`reaper_loop` 的设计理由值得记住：Worker 侧的清理器无法解决「根本没有 Worker 在消费」的问题，所以超时兜底必须放在 API 进程

---

## 4. 后端分层与约定

### 4.1 AppState 是唯一的依赖容器

`backend-rust/src/lib.rs:25-48`

```rust
pub struct AppState {
    pub pool: PgPool,
    pub config: Arc<Config>,
    pub submission_service: SubmissionService,
    pub run_service: RunService,
    pub realtime: RealtimeHub,
    pub redis: Option<ConnectionManager>,
}
```

- 全部字段都可廉价 clone，Axum 的 `State(state)` 直接复制
- `redis: Option<_>`：判题功能关闭时为 `None`，`/readyz` 把「禁用」与「故障」区分开
- Service 持有 `Arc<Config>` 和可选的 Redis 连接，不持有 Pool，调用时传入 Pool

### 4.2 一次请求的标准形状

以 `POST /api/submissions` 为例

```rust
// handlers/submission_handler.rs:18-32
pub async fn create(
    State(state): State<AppState>,
    headers: HeaderMap,
    Json(request): Json<SubmissionRequest>,
) -> Result<impl IntoResponse, AppError> {
    let user = authenticate(&state.pool, &headers, &state.config).await?;
    if request.assignment_id.is_some() || request.contest_id.is_some() {
        require_verified_email(&user)?;
    }
    let response = state.submission_service.create(&state.pool, &user, request).await?;
    Ok(created(response))
}
```

Handler 只做四件事

1. 提取 `State` / `Path` / `Query` / `Json` / `HeaderMap`
2. 调用 `authenticate` 或 `require_*`
3. 交给 Service
4. 用 `ok` / `created` / `accepted` 包装响应

### 4.3 分层职责

| 层 | 位置 | 职责 | 不该做的事 |
|---|---|---|---|
| Router | `routes/mod.rs` | 路径、方法、层、上传体积限制 | 业务判断 |
| Handler | `handlers/*.rs` | HTTP 参数、认证、调用 Service | 复杂 SQL、状态机 |
| Service | `services/*.rs` | 业务规则、事务、SQL、通知 | 拼 HTTP 响应 |
| Model | `models/*.rs` | Serde DTO、状态常量、校验辅助 | 访问数据库 |
| Utils | `utils/*.rs` | JWT、密码、限流、指标 | 领域规则 |

注意两个「非典型」选择

- **没有 Repository 层**：SQL 直接写在 Service 里，少一层映射，但领域逻辑和查询耦合
- **没有全局认证中间件**：每个 Handler 显式调用 `authenticate`，权限差异（可选登录、学生、教师、管理员、邮箱验证）就地表达

### 4.4 统一错误与响应

`common/response.rs` 固定信封

```json
{ "success": true, "data": { }, "error": null }
{ "success": false, "data": null, "error": "请求参数无效: ..." }
```

`common/error.rs` 用 thiserror 定义 `AppError`

- `#[from] sqlx::Error` → 业务代码可直接 `?`
- `status_code()` 决定 HTTP 状态
- `into_response()` 把错误转成统一信封
- `Database` 与 `Internal` 对外只给通用文案，真实原因写日志
- `RateLimited(_, seconds)` 额外写 `Retry-After` 响应头

安全提醒：`BadRequest` / `NotFound` 的字段会原样返回客户端，不要塞 SQL、路径、堆栈

### 4.5 数据库访问方式

- 使用 `sqlx::query` / `query_as` 的**运行时** API，不是 `query!` 编译期校验宏
- 迁移用 `sqlx::migrate!("./migrations")`，API 启动时自动执行
- 事务中常见模式：`FOR UPDATE` + 幂等状态迁移
- 唯一冲突用错误码 `23505` 判断（`is_unique_violation`）

---

## 5. 身份、会话与权限

### 5.1 认证链路

`middleware/auth.rs:35-64`

```text
Authorization: Bearer <JWT>
  → decode_token 校验签名与 exp
  → 取 sub（user_id）与 ver（token_version）
  → 查数据库拿当前 username / role / email_verified / status
  → 比对 ver 与数据库 token_version
```

两个关键设计

1. **角色以数据库为准**，JWT 里的 role 被忽略，管理员改角色后下一次请求立即生效
2. **token_version 实现单设备登录**，每次登录都递增版本，旧 JWT 立刻失效并返回 `SessionReplaced`

### 5.2 三种角色互斥

`student` / `teacher` / `admin` 不继承、不兼任

- `is_student()` / `is_teacher()` / `is_admin()` 是简单等于判断
- `require_student` / `require_teacher` / `require_admin` 是显式函数
- `require_verified_email` 单独控制「加入组织、交作业、发帖」

### 5.3 密码与会话存储

- 密码：Argon2 默认参数，随机盐（`utils/password.rs`）
- JWT：HS256，默认 24 小时（`utils/jwt.rs`）
- 前端：勾选「记住我」进 `localStorage`，否则进 `sessionStorage`（`utils/session.ts`）
- 401 拦截：清会话并跳登录；若是「其他设备登录」则带 `kicked=1`
- 403 拦截：派发 `theseus:forbidden` 事件，App.vue 重新拉取当前用户并校正路由

### 5.4 限流是进程内实现

`utils/rate_limit.rs`

- 滑动窗口计数 + 登录失败锁定
- 客户端 IP 取 `X-Real-IP` / `X-Forwarded-For`
- 当前单实例部署足够；多实例需要改 Redis 计数
- 业务限流另有一套：提交每分钟 10 次、同一用户同时只能有一个提交在评测

---

## 6. 判题系统：本项目最值得精读的部分

### 6.1 两条队列，一套机制

| 队列 | 用途 | Stream | 消费者组 |
|---|---|---|---|
| run | 「运行」按钮，公开示例/自定义输入 | `RUN_STREAM` | `RUN_CONSUMER_GROUP` |
| submit | 正式提交，公开 + 隐藏用例 | `SUBMIT_STREAM` | `SUBMIT_CONSUMER_GROUP` |

两者共用 `judge/queue.rs` 的读写、ACK、XAUTOCLAIM、死信逻辑，只靠字段名区分

- run 消息字段：`run_id`
- submit 消息字段：`submission_id`
- 另有 anticheat Stream 复用同一套机制

### 6.2 入队前的前置检查

`services/submission_service.rs`

```text
submit_judge_enabled?
  → problem_id / language / code 非空 / ≤64KB
  → 作业与比赛不能同时关联
  → 比赛提交：precheck_submission 校验参赛资格并取冻结快照
  → 其余提交：读取题目 run_config 与 judge_cases 摘要
  → case_total = 公开用例 + 隐藏用例数量
  → case_total ≤ submit_max_cases
  → 作业提交：precheck_assignment 校验提交窗口与策略
  → 是否有存活的 submit worker 心跳（没有就 503）
  → 用户每分钟限流
  → Redis SET NX 并发锁（同一用户只能有一个在测）
  → INSERT submissions（含 run_config_snapshot / judge_cases_snapshot）
  → 锁的 value 从随机 token 换成 submission_id
  → XADD 入队
  → 写 Redis pending 状态缓存
  → 写 user_problem_status = attempted
```

失败路径都会释放 Redis 锁与限流配额，避免「用户被永久锁死」

### 6.3 快照为什么重要

正式提交不直接读当前题目配置，而是把 `run_config` 和 `judge_cases` 冻结进 `submissions`

- 题目之后被修改，不影响已经提交的评测
- 比赛开始时把题目快照进 `contest_problems`
- Worker 只认快照，不认实时题面

这是典型的**不可变事实**设计：判题结果必须可复现

### 6.4 Worker 的消费循环

`src/bin/judge_worker.rs`

```text
main
  ├─ N 个 consumer_loop          XREADGROUP 阻塞 5 秒
  ├─ 1 个 claimer_loop           XAUTOCLAIM 回收闲置 >2 分钟的 Pending
  ├─ N 个 submission_consumer_loop
  ├─ 1 个 submission_claimer_loop
  └─ 1 个 heartbeat_loop         每 10 秒写 TTL 30 秒的心跳键
```

处理一条消息的幂等套路

1. 查数据库行
2. 已是终态 → 直接 ACK
3. 数据库原子 claim（`UPDATE ... WHERE status = 'pending'`）
4. 执行沙箱
5. 写终态（`WHERE status <> 'finished'` 之类的条件更新）
6. 成功才 ACK；基础设施错误不 ACK，留给 XAUTOCLAIM 重试
7. 重试次数超过上限 → 死信 Stream + 行标记 internal_error + 释放用户锁

关键点：**ACK 的语义是「这件事已经妥善处理」，不是「我读到了」**

### 6.5 沙箱实现

`judge/runner.rs`

启动容器参数

```text
--runtime runsc           （非 runsc 必须显式 allow_runc，仅本地开发）
--network=none
--read-only
--tmpfs /workspace:rw,exec,size=128m,mode=1777
--tmpfs /tmp:rw,exec,size=32m
--user 65534:65534
--cap-drop=ALL
--security-opt=no-new-privileges
--pids-limit=64
--memory=... --memory-swap=...   （编译期更高，运行期调回）
--cpus=1
--ulimit nofile=64:64
```

执行流程

1. 生成语言 harness（Python/JS 的 runner，C++/Java 的 main）
2. 写入工作目录
3. 容器启动后 `docker inspect` 复核运行时确实是 runsc
4. 通过 `docker exec -i ... cat > /workspace/file` 注入文件
   - 不用 `docker cp`：只读 rootfs + tmpfs 下 cp 会被拒绝或写进私有命名空间
5. 需要编译的语言先编译，编译预算单独配置
6. 编译成功后把内存限制降回运行预算
7. 每个用例写 `case.json`，`timeout -s KILL` 执行
8. 读 `result.json` / `stdout.txt` / `stderr.txt`
9. 用 `OOMKilled` 与退出码 137/124 辅助判定超时/内存
10. 清理容器与临时目录

安全细节值得单独记

- 用户代码以 `nobody` 运行
- 宿主侧还有一层 `tokio::time::timeout`，防止 docker 命令本身卡死
- 输出截断到 64 KB，按 UTF-8 字符边界截断
- 沙箱不可用时**返回错误让任务保持 pending**，而不是伪造失败

### 6.6 语言 harness 与结果比较

- `judge/harness/*.rs` 为每种语言生成「调用用户函数 → 读参数 → 写 result.json」的包装
- `run_config` 描述函数名、参数类型、返回类型、比较模式
- `judge/compare.rs` 负责精确/浮点等比较
- `judge/run_config.rs` 负责校验配置、输入大小、代码大小

这层把「LeetCode 式函数题」和「传统 stdin/stdout 题」统一成了函数调用模型

### 6.7 状态机

run 状态（`models/run.rs`）

```text
queued → compiling → running → completed
                     ├→ compile_error
                     ├→ runtime_error
                     ├→ time_limit_exceeded
                     └→ memory_limit_exceeded
任意阶段 → internal_error
```

submission 状态（`models/submission.rs`）

```text
pending → judging → accepted
                  ├→ wrong_answer
                  ├→ time_limit_exceeded
                  ├→ memory_limit_exceeded
                  ├→ runtime_error
                  ├→ compile_error
                  └→ internal_error
```

终态判断集中在 `is_terminal_status`，Worker、API、缓存三处共用

### 6.8 状态查询的缓存策略

`services/submission_service.rs` 的 `status()`

- 先读 Redis 缓存
- 只有提交者本人可以命中缓存
- 终态直接返回
- 非终态要求缓存更新时间在 10 秒内，否则回源数据库
- 回源后刷新缓存

这样既扛住了前端高频轮询，又避免 Worker 中途死亡导致缓存永远停在 `judging`

### 6.9 结果如何回到前端

```text
Worker 写终态
  → 写 Redis 状态缓存
  → PUBLISH theseus:realtime:submission
  → API 的 submission_result_relay 订阅
  → RealtimeHub.publish(user_id, "submission.result")
  → WebSocket
  → 前端收到事件后仍可走 REST 查询详情
```

轮询是兜底，WebSocket 是加速，两者都不假设对方一定成功

---

## 7. 实时推送

### 7.1 为什么先换票据

浏览器 WebSocket API 不能自定义 `Authorization` 头

```text
POST /api/ws/ticket  （带 Bearer）
  → 一次性 ticket，60 秒有效
GET /api/ws?ticket=...
  → consume_ticket：取出即删除，重复使用失败
```

### 7.2 RealtimeHub

`realtime.rs`

- `HashMap<i32, broadcast::Sender<RealtimeEvent>>`，每个用户一个频道
- 频道容量 64
- 事件带单调递增 `id` 与服务端时间
- 离线用户直接丢弃事件，数据库仍是真相
- 连接结束时 `prune`，避免用户表无限增长
- 优雅关闭时 `shutdown()` 清空频道，让长连接退出

多实例部署时，把 `publish` 换成 Redis Pub/Sub 即可，连接、票据、事件格式都不用变

### 7.3 WebSocket 协议

`handlers/ws_handler.rs`

```text
客户端 hello      → 服务端 ready { user_id, server_time }
服务端 ping       → 客户端 pong（或任意文本刷新活跃时间）
90 秒无消息       → 服务端断开
事件积压 Lagged   → 服务端发 resync，客户端重新拉快照
```

### 7.4 前端连接管理

`utils/realtime.ts`

- 模块级单例连接
- `handlers: Map<eventType, Set<handler>>`
- 第一个订阅者出现才连接，最后一个取消才断开
- 指数退避重连，最大 30 秒
- 登录态失效时 `resetRealtime()`

---

## 8. 核心业务域

### 8.1 题库与题目生命周期

- 题目由教师/管理员创建，管理员审核后 `review_status = approved`
- `run_config` 管函数签名与运行方式，`judge_cases` 管隐藏用例
- 学生可以创建「个人题目」，不进入公共题库
- 收藏、草稿、笔记、错题本都是「用户 × 题目」的附属数据

相关迁移：`0006_problem_review`、`0022_problem_drafts`、`0037_problem_notes`、`0039_wrong_problem_dismissals`

### 8.2 教学：班级、作业、评分

核心表

```text
classes → class_members
        → assignments → assignment_problems
                      → assignment_results
                      → assignment_problem_grades
                      → assignment_student_overrides
                      → assignment_grade_appeals
                      → assignment_policy_audits
```

评分策略集中在 `services/assignment_policy.rs`

| 维度 | 取值 |
|---|---|
| 迟交 | `forbid` / `allow` |
| 取分 | `highest` / `last` / `first_ac` |
| 成绩可见性 | `after_publish` / `after_due` / `during` |
| 免修 | `full_score` / `excluded` |

`StudentOverride` 支持补交截止时间、免迟交惩罚、免修
`assignment_policy_audits` 记录策略变更，方便教师回溯

作业统计与导出在 `assignment_service::statistics / export_statistics`，成绩申诉在 `grade_appeal_service`

### 8.3 竞赛：匹配、答题、结算

#### 匹配

`contest_service::try_match`（`contest_service.rs:2061`）

```text
BEGIN
  pg_advisory_xact_lock(CONTEST_LOCK_NAMESPACE)
  取排队中、账号 active、信誉分 ≥ 40 的用户，按入队时间 LIMIT 400 FOR UPDATE
  select_fair_group：
    优先 4 人，rating 极差 ≤ RATING_WINDOW
    队列太薄时，等待足够久后降级 3 人 / 2 人
  随机抽 4 道 approved 且配置完整的题
  创建 contests + contest_problems（冻结快照）
  创建 contest_participants
  记录摄像头/屏幕授权事件
  删除队列记录
COMMIT
```

用 PostgreSQL 咨询锁保证同一时刻只有一个匹配器在组局

#### 答题

- 比赛题目从 `contest_problems` 快照读取
- 提交时 `precheck_submission` 校验参赛资格与时间窗口
- 心跳接口维护在线状态，超时静默会被标记 `timed_out`
- 断线重连依赖 `current` / `heartbeat` / WebSocket 事件

#### 结算

`settle_due_contests` 每 5 秒扫描

- `running` 且超过结束时间 + 宽限期
- `settling` 且卡住超过 2 分钟（崩溃恢复）

`settle_contest` 在一个事务里

1. `FOR UPDATE` 锁竞赛
2. 状态改 `settling`（幂等标记）
3. 按提交记录计算每题：是否 AC、用时、错误次数
4. 总分 = 解题分 × solve_weight + 速度分 × speed_weight + 代码质量分 × coding_weight
5. 排名：总分 → 解题数 → 最后 AC 时间 → 完成时间 → user_id
6. 按名次算段位分增减，更新 `users.contest_rating` 与 `season_ratings`
7. 写通知
8. 状态改 `finished`

作弊取消资格后会触发 `rerank_contest`，对所有参赛者重算名次与段位分

### 8.4 防作弊

`services/similarity.rs`

- 不做 AST，做轻量词法归一化
- 去掉注释与字符串内容
- 标识符 → `ID`，数字 → `NUM`，字符串 → `STR`
- 保留关键字与标点
- 5-gram + winnowing 窗口 4 选指纹
- 相似度用 containment（交集 / 较小集合），对「复制后加料」更稳健
- 只做同语言比较

`services/anticheat_service.rs`

- 判题成功后投递到 anticheat Stream
- 扫描同题、同语言、时间窗口内的其他提交
- 相似度达到记录阈值写 `similarity_pairs`
- 达到举报阈值生成 `cheat_reports`
- 教师复核，学生可申诉
- 另有行为信号表 `submission_signals`

### 8.5 论坛与面经

- 统一在 `forum_posts` / `forum_comments`，用 `board = interview` 区分面经
- 面经访问受 Plus 权限控制
- 帖子可收藏、点赞、举报、置顶
- 评论可被作者采纳为最佳答案（`forum_accepted_answers`）
- 题解与讨论按 `problem_id` 聚合
- 通知支持 `@mention` 解析

`services/forum_service.rs` 是全项目最大的 Service（约 3500 行），说明社区规则的复杂度

### 8.6 通知与邮件

```text
业务事务内 INSERT notifications
  → realtime_fanout_loop 表尾增量 → WebSocket
  → email_dispatch_loop：
      按 notification_preferences 把待发通知转成 email_outbox
      再投递 due 的邮件
```

- `notifications` 是站内信事实来源
- `email_outbox` 是投递队列，失败可重试
- `email_mode = log` 时只写日志，适合本地开发
- `auth_tokens` 表存邮箱验证/密码重置 token 的哈希，带用途与过期时间

### 8.7 Plus 会员

- 学生/教师提交申请，管理员审核并填写开通天数
- `plus_memberships` 记录有效期
- 到期前 7/3/1 天提醒
- 到期自动失效
- 权益：面经访问、专属标识、AI 助手

### 8.8 AI 助手

`services/ai_service.rs`

```text
AI 可用 = ai_enabled && ai_api_key 已配置
访问条件：
  Plus 会员（管理员豁免）
  比赛进行中禁用（管理员豁免）
  作业未允许 AI 时禁用
  每日配额 ai_daily_limit
```

- OpenAI 兼容接口，`ai_base_url` 可指向 DeepSeek 等服务
- 只接收题目上下文与最近对话，不把隐藏用例发给模型
- 失败时退还配额
- 前端 `/ai/chat` 单独设 70 秒超时

### 8.9 审计与可观测

- `audit_logs` 记录管理端关键操作
- `/metrics` 输出 Prometheus 文本
- HTTP 指标按「方法 + 路由模板」聚合，避免路径参数导致标签爆炸
- 健康检查：`/healthz` 存活，`/readyz` 检查 PostgreSQL / Redis

---

## 9. 数据库地图

43 个迁移，63 张表，按领域分组

| 领域 | 代表表 |
|---|---|
| 用户与账号 | `users`、`auth_tokens`、`oauth_identities` |
| 题库 | `problems`、`problem_drafts`、`problem_notes`、`user_problem_status` |
| 判题 | `code_runs`、`submissions`、`similarity_pairs`、`submission_signals`、`cheat_reports` |
| 教学 | `classes`、`class_members`、`class_invitations`、`assignments`、`assignment_*` |
| 竞赛 | `contests`、`contest_queue`、`contest_participants`、`contest_problems`、`contest_events`、`contest_appeals`、`official_events`、`seasons`、`season_ratings` |
| 社区 | `forum_posts`、`forum_comments`、`forum_*_favorites`、`forum_post_likes`、`forum_reports`、`moderation_actions` |
| 通知 | `notifications`、`notification_preferences`、`email_outbox`、`email_blacklist` |
| 激励 | `reputation_events`、`reputation_checkins`、`badge_catalog`、`user_badges` |
| 商业化 | `plus_applications`、`plus_memberships`、`plus_expiry_notices` |
| 运维 | `audit_logs`、`user_preferences`、`ai_usage` |

几个值得注意的约束

- 用户唯一：`username`、`email`
- `submissions` 存 `run_config_snapshot` / `judge_cases_snapshot`
- `contest_problems` 存题目快照，保证比赛可复现
- `notification_preferences` 控制邮件类别
- `ai_usage` 主键 `(user_id, usage_day)` 实现每日配额

---

## 10. 前端结构

### 10.1 启动与路由

`main.ts` → `createApp` + Pinia + Router

`router/index.ts`

- 首页与登录页同步加载，其余页面全部 `() => import(...)` 懒加载
- 路由 meta 控制访问

```ts
meta: { requiresAuth, requiresTeaching, requiresStudent, requiresTeacher, requiresAdmin, guestOnly }
```

- `requiresTeaching` = 学生或教师（教学功能），管理员不走教学入口
- `/rankings`、`/knowledge/*`、`/teacher/*` 等保留重定向，兼容旧链接
- `beforeEach` 做角色守卫

### 10.2 API 层

```text
http.ts      Axios 实例：baseURL /api、10 秒超时、Bearer 注入、401/403 拦截
client.ts    ApiEnvelope 解包、错误文案、429 Retry-After 提示
adapters.ts  后端 snake_case → 前端 camelCase 领域类型
*.ts         按领域拆分的请求函数
```

约定

- 后端返回 `{ success, data, error }`，`unwrap` 统一解包
- 错误统一走 `toErrorMessage`，页面只拿字符串
- AI 请求单独把超时放宽到 70 秒

### 10.3 状态管理

Pinia 只放**跨页面共享**的状态

```text
auth           登录态、角色、当前用户
problems       题目列表与筛选
submissions    提交列表
runs           运行记录
notifications  通知与未读数
assignments / classes / forum / invitations
preferences / shortcuts / toast
```

页面内的临时状态（弹窗、分页、编辑器内容、侧栏宽度）留在 `views/*.vue` 的 `ref`

### 10.4 页面复杂度分布

| 页面 | 行数 | 说明 |
|---|---|---|
| `OjPage.vue` | ~1538 | 题目工作台：分栏、Monaco、运行、提交、历史对比、笔记、讨论、AI |
| `ContestsPage.vue` | ~904 | 匹配、赛事列表、倒计时 |
| `AdminForumPage.vue` | ~793 | 审核、举报、禁言 |
| `ClassDetailPage.vue` | ~755 | 成员、邀请、作业 |
| `GradebookPage.vue` | ~709 | 成绩册与导出 |

`OjPage` 是理解前端的关键：它同时串起题目、运行、判题、草稿、收藏、笔记、题解、AI 八条链路

### 10.5 实时事件的使用方式

```ts
const off = onRealtime('submission.result', (data) => {
  // 收到终态后拉取详情，不直接把事件当完整数据
})
onBeforeUnmount(off)
```

原则：**事件是「提醒你去拉取」，不是「唯一数据源」**

---

## 11. 横切关注点

| 主题 | 实现位置 | 要点 |
|---|---|---|
| 配置 | `config.rs` | 启动即校验，缺失关键变量直接失败 |
| 日志 | `tracing` | `RUST_LOG` 控制，结构化字段 |
| 指标 | `utils/metrics.rs` + `handlers/metrics_handler.rs` | 路由模板低基数，池/队列/心跳指标合并输出 |
| 限流 | `utils/rate_limit.rs` | 进程内，单实例假设 |
| 认证 | `middleware/auth.rs` | 函数调用，非中间件 |
| 审计 | `services/audit_service.rs` + `audit_logs` | 管理端操作留痕 |
| 文件上传 | `ServeDir` + `UPLOAD_DIR` | 头像限制 3 MB |
| CORS | `routes::cors_layer` | 默认同源，只对白名单放开 |
| 优雅关闭 | `main.rs` | 先关实时频道，再等 Axum 收尾 |
| CI | `.github/` | fmt / clippy / test / 前端构建 |

---

## 12. 推荐阅读顺序

### 第一遍：建立地图（1 小时）

1. `README.md`
2. `doc/总体设计.md` 的 0、1、3、5、6 章
3. `doc/AGENTS.md` 了解文档索引
4. 本文第 0-4 节

### 第二遍：跟一条同步请求（1 小时）

选一个简单接口，例如 `GET /api/problems/:id`

```text
routes/mod.rs
  → handlers/problem_handler.rs
  → services/problem_service 相关逻辑
  → models/problem.rs
  → migrations/0001_initial.sql + 0006_problem_review.sql
  → frontend-vue/src/api/problems.ts
  → frontend-vue/src/views/OjPage.vue
```

目标：能不看代码画出「参数 → SQL → JSON → 页面字段」的完整链路

### 第三遍：跟一次判题（3 小时，核心）

```text
handlers/submission_handler.rs
  → services/submission_service.rs::create
  → judge/queue.rs
  → bin/judge_worker.rs::process_submission
  → judge/runner.rs::SandboxSession
  → judge/harness/*.rs
  → services/submission_service.rs::status
  → utils/realtime.ts
```

重点回答

- 为什么先写数据库再入队
- 为什么入队前要检查 Worker 心跳
- 为什么 ACK 不代表「读到了」
- 为什么提交要存快照
- 为什么状态查询缓存只对本人且非终态要限时

### 第四遍：选一个业务域深挖（每个 2-3 小时）

推荐顺序

1. **教学**：`assignment_service` + `assignment_policy` + `grade_service`
2. **竞赛**：`contest_service` 的 `try_match` / `settle_contest` / `rerank_contest`
3. **防作弊**：`similarity.rs` + `anticheat_service`
4. **论坛**：`forum_service` + Plus 权限
5. **实时**：`realtime.rs` + `ws_handler.rs` + `utils/realtime.ts`

### 第五遍：动手验证

```bash
./dev.sh

curl -s http://127.0.0.1:3000/healthz
curl -s http://127.0.0.1:3000/readyz
curl -s http://127.0.0.1:3000/metrics | head

cd backend-rust && cargo test
cd frontend-vue && npm run build
```

真实链路冒烟脚本在 `backend-rust/scripts/`，覆盖教学、判题、论坛、题目审核、邮箱、竞赛、实时推送、防作弊、导入导出、审计

---

## 13. 自测问题

### 基础

1. `AppState` 为什么可以直接 clone
2. `redis: Option<ConnectionManager>` 在什么情况下是 `None`
3. API 进程为什么自己要跑 reaper
4. 为什么 CORS 默认是空的

### 认证

5. JWT 里的 role 为什么不可信
6. 用户改密码后，旧 token 为什么立即失效
7. `authenticate` 与 `optional_authenticate` 分别用在哪类接口
8. 邮箱未验证的用户还能做哪些事

### 判题

9. run 队列与 submit 队列为什么分开
10. 为什么入队前要检查 Worker 心跳
11. XAUTOCLAIM 解决什么问题
12. 死信队列里的任务最后处于什么状态
13. 沙箱为什么不用 `docker cp`
14. 编译期与运行期的内存限制为什么不同
15. 为什么提交要保存 `run_config_snapshot`
16. 状态缓存为什么只允许提交者命中

### 竞赛

17. 匹配为什么需要 PostgreSQL 咨询锁
18. 4 人局凑不齐时的降级策略
19. 结算为什么先改成 `settling`
20. 作弊取消资格后为什么要重算所有人

### 前端

21. 为什么路由要懒加载
22. Axios 的 401 与 403 拦截分别做什么
23. 为什么 WebSocket 事件不能作为唯一数据源
24. `adapters.ts` 存在的意义

---

## 14. 设计取舍备忘

| 选择 | 好处 | 代价 |
|---|---|---|
| 模块化单体 | 事务简单、部署简单、调试直观 | 单进程故障域，后台循环与 API 争资源 |
| 无 Repository 层 | 少一层样板，SQL 与业务就近 | 领域逻辑与查询耦合，复用靠函数 |
| 显式认证函数 | 权限差异就地表达，易读 | Handler 重复，容易漏写 |
| 进程内限流 / 广播 | 零外部依赖，延迟低 | 多实例需要改造 |
| Redis Stream | 消费组、ACK、Pending 回收、死信齐全 | 运维多一个组件 |
| Docker 沙箱 | 隔离强、语言镜像可扩展 | 启动开销大，依赖宿主机 Docker |
| 数据库快照 | 判题/比赛可复现 | 存储冗余，题目更新不回溯 |
| 前端按领域拆 API + Store | 类型清晰、页面轻 | 文件数量多，跨领域组合要写适配 |

---

## 15. 术语表

| 术语 | 含义 |
|---|---|
| run | 题目页「运行」，通常只用公开示例或自定义输入 |
| submission | 正式提交，公开 + 隐藏用例，产生判题结论 |
| harness | 包在用户代码外层、负责函数调用与结果输出的生成代码 |
| run_config | 函数签名、参数类型、返回类型、比较方式 |
| judge_cases | 隐藏用例集合 |
| snapshot | 提交或比赛开始时冻结的题目配置 |
| claim | 用条件 UPDATE 把任务从 pending 抢到执行态 |
| ACK | 确认消息已妥善处理，可以从 Pending 列表移除 |
| XAUTOCLAIM | 回收长时间未 ACK 的 Pending 消息 |
| dead stream | 重试超限后的死信队列 |
| containment | 交集 / 较小集合，衡量「一份代码有多少被另一份覆盖」 |
| Plus | 会员体系，面经、AI、标识等权益 |
| settle | 竞赛到期后的结算过程 |
| rerank | 取消资格等事件后重新计算名次与段位 |

---

## 16. 最后记住这张图

```text
                     ┌───────────────┐
                     │   PostgreSQL  │  事实来源
                     └───────┬───────┘
                             │
        ┌────────────────────┼────────────────────┐
        │                    │                    │
   同步 CRUD            异步任务队列          实时事件
        │                    │                    │
   Handler→Service     Redis Stream         RealtimeHub
        │                    │                    │
      HTTP 响应          judge_worker          WebSocket
                             │
                        Docker 沙箱
                             │
                     判题结果 + 状态缓存
```

一句话总结

> **HTTP 负责「收单」，数据库负责「记事实」，Redis 负责「排队与加速」，Worker 负责「干重活」，WebSocket 负责「提醒前端去拉最新事实」**
