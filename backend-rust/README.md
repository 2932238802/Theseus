# Theseus Rust Backend

这是 Theseus 在线编程训练平台的 Axum + PostgreSQL 后端首版。

## 角色模型

设计与 `doc/2610259_班级与作业设计方案.md` 一致：`student` / `teacher` / `admin` 三个**互斥**角色，每个账号只有一个角色，不继承、不兼任。

| 角色 | 能做什么 | 不能做什么 |
|---|---|---|
| `student` | 题库练习、4 人匹配、加入组织、提交作业、查看自己的成绩、论坛、通知 | 创建组织、批改、管理用户、进入管理端 |
| `teacher` | 题库练习、创建和管理自己的组织、布置/批改作业、创建题目并提交审核、论坛、通知 | 加入组织、提交组织作业、管理用户、论坛管理 |
| `admin` | 题库练习、用户/角色管理、题目审核、论坛管理、匹配配置、广播、审计、系统配置 | 创建组织、批改、查看组织/作业/提交/成绩数据 |

- 题库练习、运行、论坛、通知对所有登录角色开放，不代表“学生身份”。
- 只有带 `assignment_id` 的组织作业提交要求 `student`；教师不能提交作业，只能用题目页“运行”预览。
- 4 人匹配和段位只允许 `student`。
- 管理员如果确实需要授课，必须先转为教师；角色变更后立即生效，前端刷新 `/me` 即可。
- 角色变更需要清理数据：学生升教师前退出所有组织；教师降级前没有未归档的自有组织，或确认归档后降级；最后一个管理员不能降级。
- 角色变更立即生效；认证中间件每次请求从数据库读取 `users.role`，JWT 里的角色不作为权限依据。

**当前代码状态：** 已实现 `student` / `teacher` / `admin` 迁移、教师角色、组织/作业/批改接口、管理员用户管理接口、竞赛/赛事、审计与商店 Plus 申请接口和对应前端页面。`user` 由迁移回填为 `student`。

## 运行

1. 安装 Rust stable、PostgreSQL 18 与 Redis。
2. 本地一键安装并初始化 PostgreSQL/Redis（Ubuntu/Debian，需要 sudo）：

```bash
sudo scripts/setup_local_services.sh
```

3. 创建数据库并复制环境变量：

```bash
cp .env.example .env
# 按本地 PostgreSQL 修改 DATABASE_URL 和 JWT_SECRET
cargo run
```

服务默认监听 `127.0.0.1:3000`，启动时会自动执行 `migrations/` 下的 SQLx migration。

## API

- `POST /api/auth/register` 注册并排队发送验证邮件
- `POST /api/auth/login` 登录并获取 JWT
- `GET /api/auth/me` 读取当前账号、角色与邮箱验证状态（每次从数据库读取）
- `POST /api/auth/verify-email` 使用一次性令牌验证邮箱
- `POST /api/auth/verify-email/resend` 重新发送验证邮件（需登录，60 秒冷却）
- `POST /api/auth/forgot-password` 请求密码重置邮件；无论邮箱是否存在都返回相同文案
- `POST /api/auth/reset-password` 使用一次性令牌重置密码；成功后旧 JWT 全部失效
- `GET /api/problems` 分页获取题目，可按 `difficulty`、`tag`、`status`、`search` 筛选，并通过白名单 `sort=id|difficulty|acceptance_rate`、`order=asc|desc` 排序
- `GET /api/problems/tags` 获取已审核题目的去重标签
- `GET /api/problems/:id` 获取题目详情
- `GET /api/stats` 获取题目总数、提交总数与通过提交数
- `POST /api/submissions` 提交代码，需要 JWT；无 `assignment_id` 的练习提交对所有登录角色开放，带 `assignment_id` 的作业提交只允许 `student`
- `GET /api/submissions/:id` 获取自己的提交详情；作业 owner 教师可以查看该作业下的学生提交，管理员不能查看他人提交
- `GET /api/submissions` 获取自己的提交记录；显式查询他人提交返回 403
- `POST /api/runs` 创建代码运行任务，需要 JWT
- `GET /api/runs/:id/status` 轮询运行状态
- `GET /api/runs/:id` 获取运行详情（代码、输入与逐用例结果）
- `GET /api/runs` 分页获取自己的运行记录，可按 `problem_id` 过滤
- `DELETE /api/runs/:id` 删除自己的已结束运行记录
- `GET /api/admin/users` 管理员搜索/筛选用户
- `PUT /api/admin/users/:id/role` 管理员修改角色；教师降级可携带 `archive_owned_classes`
- `POST /api/admin/problems` 管理员创建官方题目
- `GET /api/admin/problems/pending` 管理员查看待审核题目
- `PUT /api/admin/problems/:id/review` 管理员审核题目
- `PUT /api/admin/problems/:id` 管理员更新题目
- `DELETE /api/admin/problems/:id` 管理员删除题目
- `POST /api/problems/custom` 学生/教师提交自定义题目，初始状态为 `pending`
- `GET /api/problems/mine` 学生/教师查看自己创建的题目，可按 `status` 筛选
- `GET /api/problems/mine/:id` 学生/教师查看自己的题目详情
- `PUT /api/problems/mine/:id` 学生/教师修改被退回的题目并重新提交审核
- `GET /api/admin/problems` 管理员分页查看题目，可按 `status`、`q` 筛选
- `GET /api/admin/problems/:id` 管理员查看题目完整配置
- `GET /api/shop/plus` 当前用户的 Plus Theseus 开通状态与最近一条申请
- `POST /api/shop/plus/apply` 学生/教师提交开通申请 `{reason}`，需已验证邮箱
- `GET /api/admin/plus-applications` 管理员分页查看 Plus 申请，可按 `status` 筛选
- `POST /api/admin/plus-applications/:id/resolve` 管理员通过或驳回申请 `{status,note}`，写站内信与审计日志

### 角色相关行为

- JWT 只确认用户身份；`AuthUser.role` 每次从 `users.role` 读取，角色变更立即生效，不要求重新登录。
- 题目创建：学生和教师通过 `POST /api/problems/custom` 提交审核，管理员审核；`admin` 返回 403。
- 管理员访问 `/api/classes/*`、`/api/assignments/*`、教学提交/成绩接口统一返回 403；管理员不能查看其他人的提交，包括练习提交。
- 教师不能加入组织、不能提交组织作业；学生不能创建组织、不能批改。
- 4 人匹配只允许 `student`；教师和管理员只能使用题库练习。

### 邮箱验证与密码找回

- 新注册账号的 `email_verified_at` 为空；迁移前的已有账号会自动标记为已验证。
- 未验证账号**可以登录、刷题和查看通知**，但加入组织、提交组织作业、发帖和评论会返回 403，提示先验证邮箱。
- 验证与重置令牌都是 32 字节随机值，数据库只保存 SHA-256；令牌一次性使用并带过期时间。
- 重置密码会把 `users.token_version` 加一，旧 JWT 立即失效，需要重新登录；重置链接同时被视为邮箱所有权证明，会把未验证账号标记为已验证。
- 找回密码对不存在的邮箱也返回同一句通用文案，避免枚举账号。
- 注册、重发验证和找回密码只向 `email_outbox` 入队；API 进程内的 dispatcher 负责投递，SMTP 延迟不会阻塞请求。
- `EMAIL_MODE=log` 会把邮件正文（含一次性链接）写入服务端日志，**仅用于本地开发**；生产必须使用 `smtp`。

| 变量 | 默认值 | 说明 |
|---|---:|---|
| `FRONTEND_BASE_URL` | `http://localhost:5173` | 生成验证/重置链接的前端地址 |
| `EMAIL_MODE` | `log` | `log` 只写日志；`smtp` 投递到 SMTP |
| `EMAIL_FROM` | `Theseus <no-reply@theseus.local>` | 发件人 |
| `EMAIL_SMTP_HOST` | `127.0.0.1` | SMTP 主机；本地 Mailpit 用 `127.0.0.1` |
| `EMAIL_SMTP_PORT` | `1025` | SMTP 端口 |
| `EMAIL_SMTP_USERNAME` | 空 | 可选 SMTP 用户名 |
| `EMAIL_SMTP_PASSWORD` | 空 | 可选 SMTP 密码 |
| `EMAIL_SMTP_TLS` | `false` | 本地 Mailpit 关闭；生产按服务商开启 |
| `EMAIL_VERIFY_TTL_HOURS` | `24` | 验证链接有效期 |
| `PASSWORD_RESET_TTL_MINUTES` | `30` | 重置链接有效期 |
| `EMAIL_DISPATCH_INTERVAL_SECS` | `5` | dispatcher 轮询间隔 |
| `UPLOAD_DIR` | `./uploads` | 头像等上传文件目录；生产必须使用持久化目录 |

投递失败会按 30 秒递增退避重试，最多 5 次，之后标记为 `failed` 并保留 `last_error`。

### 教学接口

```text
GET    /api/admin/users
PUT    /api/admin/users/{id}/role

GET    /api/classes
POST   /api/classes
GET    /api/classes/{id}
PUT    /api/classes/{id}
POST   /api/classes/join
POST   /api/classes/{id}/members
DELETE /api/classes/{id}/members/{user_id}
DELETE /api/classes/{id}/members/me
POST   /api/classes/{id}/invite-code/rotate
POST   /api/classes/{id}/archive

GET    /api/classes/{id}/assignments
POST   /api/classes/{id}/assignments
GET    /api/assignments/{id}
PUT    /api/assignments/{id}
PUT    /api/assignments/{id}/problems
POST   /api/assignments/{id}/publish
POST   /api/assignments/{id}/archive
DELETE /api/assignments/{id}
GET    /api/assignments/{id}/submissions

GET    /api/assignments/{id}/gradebook
PUT    /api/assignments/{id}/grades/{user_id}/problems/{problem_id}
PUT    /api/assignments/{id}/grades/{user_id}
POST   /api/assignments/{id}/grades/publish
```

组织作业的 `POST /api/submissions` 与 `GET /api/submissions/{id}` 复用现有提交接口，不需要新增路径。

具体权限和错误码见 `doc/2610259_班级与作业设计方案.md` 第 6 节。

响应统一为：

```json
{"success":true,"data":{},"error":null}
```

提交代码（`POST /api/submissions`）只做校验、入队，并把 `run_config` 与隐藏用例冻结进提交记录；实际评测由 `judge_worker` 消费独立提交队列完成，API 进程不执行用户代码。

## 运行代码（Judge Worker）

运行链路为 `POST /api/runs` → PostgreSQL `code_runs` → Redis Stream → 独立 `judge_worker` 进程 → Docker 沙箱。Worker 与 API 分离部署：

```bash
# 构建四个语言运行镜像
docker build -f docker/runners/python.Dockerfile -t theseus/runner-python:dev docker/runners
docker build -f docker/runners/node.Dockerfile   -t theseus/runner-node:dev   docker/runners
docker build -f docker/runners/cpp.Dockerfile    -t theseus/runner-cpp:dev    docker/runners
docker build -f docker/runners/java.Dockerfile   -t theseus/runner-java:dev   docker/runners

cargo run --bin judge_worker
```

Worker 支持 `RUN_WORKER_CONCURRENCY` 个并行消费者，使用消费组 `XREADGROUP`/`XACK` 消费任务，并定期通过 `XAUTOCLAIM` 回收超过 120 秒未确认的 Pending 消息；同一任务重试超过 `RUN_MAX_DELIVERIES` 次后写入死信流 `RUN_DEAD_STREAM` 并标记 `internal_error`。Worker 每 10 秒刷新一次 `theseus:run:worker:{name}` 心跳（TTL 30 秒），可用于监控。多实例部署时每个进程必须使用不同的 `RUN_WORKER_NAME`，否则消费者名与心跳键会冲突。

API 进程在创建运行前会检查是否存在存活 Worker 心跳：一个都没有时直接返回 `503`，不会写入 `code_runs`，也不会占用用户并发锁或消耗限流次数。同时 API 进程每 `RUN_REAPER_INTERVAL_SECS`（默认 30 秒）扫描一次超时任务：`queued` 超过 `RUN_QUEUE_TIMEOUT_SECS`（默认 90 秒）或 `compiling`/`running` 超过 `RUN_STALE_TIMEOUT_SECS`（默认 300 秒）的记录会被标记为 `internal_error` 并释放并发锁，避免 Worker 离线时任务无限期卡住。并发锁的 TTL 按「排队超时 + 运行超时 + 用例数 × 单用例超时 + 30 秒缓冲」计算，不再固定为 10 分钟。

本地开发可设置 `RUN_SANDBOX_RUNTIME=runc` 与 `RUN_SANDBOX_ALLOW_RUNC=true`；生产必须使用 `runsc`（gVisor）并保持 `RUN_SANDBOX_ALLOW_RUNC=false`。

常用巡检命令：

```bash
redis-cli XINFO GROUPS theseus:judge:runs        # 队列深度、PEL、消费者
redis-cli XPENDING theseus:judge:runs judge-workers
redis-cli XLEN theseus:judge:runs:dead           # 死信数量
redis-cli --scan --pattern 'theseus:run:worker:*' # 存活 Worker 心跳
```

## 提交判题

提交链路为 `POST /api/submissions` → PostgreSQL `submissions`（冻结 `run_config_snapshot` / `judge_cases_snapshot`）→ Redis Stream `SUBMIT_STREAM` → `judge_worker` 的提交消费循环 → 同一套 Docker 沙箱。运行与提交共享 `RUN_WORKER_CONCURRENCY` 个沙箱信号量，避免两类任务同时把 CPU/内存吃满。

- 判题集合 = `run_config.public_cases`（公开，在前）+ `problems.judge_cases`（隐藏，在后），遇到第一个不通过用例立即停止；剩余用例记为 `skipped`。
- 隐藏用例不进入 Redis 消息、日志或普通题目接口；用户只能看到通过数和**首个失败用例**，其中 `expected` 仅在 `wrong_answer` 时返回。
- 提交重试与死信使用 `SUBMIT_MAX_DELIVERIES` / `SUBMIT_DEAD_STREAM`；排队超时与 judging 卡死分别由 `SUBMIT_QUEUE_TIMEOUT_SECS`、`SUBMIT_STALE_TIMEOUT_SECS` 回收。
- 限流与并发槽位独立于运行：每用户 10 次/分钟、同时 1 个提交。
- `SUBMIT_JUDGE_ENABLED=false` 时创建接口返回 503；开启前必须先启动带提交消费循环的 Worker，否则创建接口会因没有 `theseus:submit:worker:*` 心跳同样返回 503。

常用巡检命令：

```bash
redis-cli XINFO GROUPS theseus:judge:submissions
redis-cli XPENDING theseus:judge:submissions judge-submit-workers
redis-cli XLEN theseus:judge:submissions:dead
redis-cli --scan --pattern 'theseus:submit:worker:*'
```

## 开发种子数据

仅用于本地/测试环境。`seed_dev.sql` 写入固定 ID 1001-1003 的三道题；`seed_problems_15.sql` 写入固定 ID 1101-1115 的 15 道题（6 道简单、6 道中等、3 道困难），每题都带 `run_config`、公开用例、隐藏 `judge_cases` 和四种语言的代码模板，可直接用于运行与提交评测。`seed_admin.sql` 创建管理员账号 `admin`（密码 `admin`，邮箱 `admin@theseus.local`，邮箱已验证）；脚本幂等，已存在的账号不会被覆盖：

```bash
psql "$DATABASE_URL" -f scripts/seed_admin.sql
psql "$DATABASE_URL" -f scripts/seed_dev.sql
psql "$DATABASE_URL" -f scripts/seed_problems_15.sql
psql "$DATABASE_URL" -f scripts/clean_dev.sql  # 清理全部固定 ID 种子题
```

管理员账号仅用于本地开发/测试，部署到公网前必须修改密码或删除该账号。日常角色调整请使用 `/admin/users`，由接口执行“学生退出组织、教师归档自有组织、最后一个管理员保护”等校验。

自定义题目使用 `POST /api/problems/custom` 提交，仅 `teacher` 可调用，初始状态为 `pending`。管理员可通过 `GET /api/admin/problems/pending` 查看待审题目，并用 `PUT /api/admin/problems/:id/review` 携带 `{ "status": "approved" }` 或 `{ "status": "rejected" }` 完成审核。

## 冒烟测试

`scripts/smoke_submission.sh` 对真实运行的 API + judge_worker + PostgreSQL + Redis + Docker 沙箱执行一遍「注册 → 提交 → 排队 → 评测 → 终态 → 计数」链路，覆盖 AC / WA / CE / TLE / RE、首错裁剪、隐藏用例不泄露、权限隔离、重复投递幂等与计数一致性。

前置条件：

1. 已启动 API 与 judge_worker（`SUBMIT_JUDGE_ENABLED=true`），并构建 Python/C++ 运行镜像；
2. 已执行 `psql "$DATABASE_URL" -f scripts/seed_dev.sql`（题 1001 需 3 条公开 + 3 条隐藏用例）；
3. 已安装 `bash >= 4.2`、`curl`、`jq`、`psql`、`redis-cli`。

```bash
# 在仓库根目录运行
./backend-rust/scripts/smoke_submission.sh

# 常用选项
SMOKE_KEEP_DATA=1 ./backend-rust/scripts/smoke_submission.sh        # 保留测试账号与提交
SMOKE_SKIP_CPP=1 ./backend-rust/scripts/smoke_submission.sh         # 跳过 C++ 编译错误用例
SMOKE_RESTORE_COUNTERS=1 ./backend-rust/scripts/smoke_submission.sh # 回滚题目计数（需无并发提交）
SMOKE_VERBOSE=1 ./backend-rust/scripts/smoke_submission.sh          # 打印每次 HTTP 请求
```

退出码：`0` 全部通过（可含 SKIP）；`1` 存在断言失败；`2` 前置条件不满足（工具、种子、Worker 心跳、开关）；`3` API/PostgreSQL/Redis 不可达。

每次运行会在 `.dev-logs/` 生成 `smoke-submission-<UTC>.log` 与同名 `.json` 报告。报告只记录 `user_id`、`submission_id`、状态与耗时，不写入 token、密码、源码、隐藏用例或数据库连接串。默认会删除测试账号及其级联数据；`SMOKE_KEEP_DATA=1` 时保留并打印清理 SQL。

### 组织与作业

`scripts/smoke_teaching.sh` 对真实运行的 API + PostgreSQL（学生提交还需要 judge_worker）执行一遍教学闭环：管理员改角色 → 教师创建组织 → 学生邀请码加入 → 发布作业 → 学生提交并判题 → 教师批改 → 发布成绩 → 教师降级归档 → 清理。同时覆盖角色边界、管理员隔离、非 owner 教师 404、成绩发布前后的可见性和截止后提交拒绝。

前置条件：

1. 已应用 `migrations/0005_teaching.sql`；
2. 已启动 API；验证学生提交和判题时还需启动 judge_worker，并构建 Python 运行镜像；
3. 已执行 `psql "$DATABASE_URL" -f scripts/seed_problems_15.sql`（题 1101 用于作业）；
4. 已安装 `bash >= 4.2`、`curl`、`jq`、`psql`。

```bash
# 在仓库根目录运行
./backend-rust/scripts/smoke_teaching.sh

SMOKE_KEEP_DATA=1 ./backend-rust/scripts/smoke_teaching.sh   # 保留测试账号与教学数据
SMOKE_VERBOSE=1 ./backend-rust/scripts/smoke_teaching.sh      # 打印每次 HTTP 请求
```

脚本只提升/降级自己注册的一次性账号，不修改真实账号；报告不写入 token、密码、提交代码或数据库连接串。默认清理测试账号、其组织、作业和提交；`SMOKE_KEEP_DATA=1` 时保留并打印清理 SQL。

### 教师出题与题目审核

`scripts/smoke_problem_review.sh` 对真实运行的 API + PostgreSQL 执行一遍题目生命周期：教师提交待审核题目 → 教师自审被拒 → 管理员列表/详情 → 退回必须填写原因 → 教师收到通知 → 编辑重提并清空意见 → 审核通过并公开 → 重复审核拒绝 → 空用例题目不能通过 → 清理。

前置条件：

1. 已应用 `migrations/0006_problem_review.sql`；
2. 已启动 API；
3. 已安装 `bash >= 4.2`、`curl`、`jq`、`psql`。

```bash
# 在仓库根目录运行
./backend-rust/scripts/smoke_problem_review.sh

SMOKE_KEEP_DATA=1 ./backend-rust/scripts/smoke_problem_review.sh   # 保留测试账号与题目
SMOKE_VERBOSE=1 ./backend-rust/scripts/smoke_problem_review.sh      # 打印每次 HTTP 请求
```

脚本只使用随机一次性账号，报告不写入 token、密码、隐藏用例或数据库连接串。默认清理测试账号及其创建的题目；`SMOKE_KEEP_DATA=1` 时保留并打印清理 SQL。

### 邮箱验证与密码找回

`scripts/smoke_auth_email.sh` 对真实运行的 API + PostgreSQL 执行：注册 → 未验证仍可登录 → 加入组织/交作业/发帖被拦 → 重发冷却 → 读取 outbox 验证邮箱 → 重复验证拒绝 → 找回密码 → 重置密码 → 旧 JWT/旧密码失效 → 新密码登录 → 清理。

前置条件：

1. 已应用 `migrations/0007_auth_email.sql`；
2. 已启动 API；
3. 已安装 `bash >= 4.2`、`curl`、`jq`、`psql`。

```bash
# 在仓库根目录运行
./backend-rust/scripts/smoke_auth_email.sh

SMOKE_KEEP_DATA=1 ./backend-rust/scripts/smoke_auth_email.sh   # 保留测试账号
SMOKE_VERBOSE=1 ./backend-rust/scripts/smoke_auth_email.sh      # 打印每次 HTTP 请求
```

脚本从 `email_outbox` 读取一次性令牌，但不会打印令牌、密码或邮件正文。默认清理测试账号与对应 outbox；`SMOKE_KEEP_DATA=1` 时保留。


## 检查

```bash
cargo fmt --check
cargo test
cargo clippy --all-targets --all-features -- -D warnings

# 前端
cd ../frontend-vue && npm run build
```

数据库迁移和真实 API 链路用 `scripts/` 下的冒烟脚本验证：`smoke_profile.sh` 覆盖个人中心、账号安全、头像、学习分析和收藏。
