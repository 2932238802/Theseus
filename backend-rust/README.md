# Theseus Rust Backend

这是 Theseus 在线编程训练平台的 Axum + PostgreSQL 后端首版。

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

- `POST /api/auth/register` 注册
- `POST /api/auth/login` 登录并获取 JWT
- `GET /api/problems` 分页获取题目，可按 `difficulty`、`tag`、`status`、`search` 筛选，并通过白名单 `sort=id|difficulty|acceptance_rate`、`order=asc|desc` 排序
- `GET /api/problems/tags` 获取已审核题目的去重标签
- `GET /api/problems/:id` 获取题目详情
- `GET /api/stats` 获取题目总数、提交总数与通过提交数
- `POST /api/submissions` 提交代码，需要 JWT
- `GET /api/submissions/:id` 获取自己的提交详情
- `GET /api/submissions` 获取自己的提交记录（管理员可按 `user_id` 查询）
- `POST /api/runs` 创建代码运行任务，需要 JWT
- `GET /api/runs/:id/status` 轮询运行状态
- `GET /api/runs/:id` 获取运行详情（代码、输入与逐用例结果）
- `GET /api/runs` 分页获取自己的运行记录，可按 `problem_id` 过滤
- `DELETE /api/runs/:id` 删除自己的已结束运行记录
- `POST /api/admin/problems` 管理员创建题目
- `PUT /api/admin/problems/:id` 管理员更新题目
- `DELETE /api/admin/problems/:id` 管理员删除题目

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

仅用于本地/测试环境，写入固定 ID 1001-1003 的三道题：

```bash
psql "$DATABASE_URL" -f scripts/seed_dev.sql
psql "$DATABASE_URL" -f scripts/clean_dev.sql  # 清理
```

自定义题目使用 `POST /api/problems/custom` 提交，初始状态为 `pending`。管理员可通过 `GET /api/admin/problems/pending` 查看待审题目，并用 `PUT /api/admin/problems/:id/review` 携带 `{ "status": "approved" }` 或 `{ "status": "rejected" }` 完成审核。

## 检查

```bash
cargo fmt --check
cargo test
cargo clippy --all-targets --all-features -- -D warnings
```
