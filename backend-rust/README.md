# Theseus Rust Backend

这是 Theseus 在线编程训练平台的 Axum + PostgreSQL 后端首版。

## 运行

1. 安装 Rust stable 和 PostgreSQL 18。
2. 创建数据库并复制环境变量：

```bash
cp .env.example .env
# 按本地 PostgreSQL 修改 DATABASE_URL 和 JWT_SECRET
cargo run
```

服务默认监听 `127.0.0.1:3000`，启动时会自动执行 `migrations/` 下的 SQLx migration。

## API

- `POST /api/auth/register` 注册
- `POST /api/auth/login` 登录并获取 JWT
- `GET /api/problems` 分页获取题目，可按 `difficulty`、`tag`、`status`、`search` 筛选
- `GET /api/problems/:id` 获取题目详情
- `POST /api/submissions` 提交代码，需要 JWT
- `GET /api/submissions/:id` 获取自己的提交详情
- `GET /api/submissions` 获取自己的提交记录（管理员可按 `user_id` 查询）
- `POST /api/admin/problems` 管理员创建题目
- `PUT /api/admin/problems/:id` 管理员更新题目
- `DELETE /api/admin/problems/:id` 管理员删除题目

响应统一为：

```json
{"success":true,"data":{},"error":null}
```

首版 `JudgeService` 实现了 `pending -> judging -> runtime_error` 的异步生命周期和提交统计更新。由于服务尚未接入隔离执行器，它不会伪造 `accepted` 结果，也不会直接执行不受信任的用户代码；生产部署应接入隔离的 Judge worker/container，并在该服务边界内完成真实评测。

自定义题目使用 `POST /api/problems/custom` 提交，初始状态为 `pending`。管理员可通过 `GET /api/admin/problems/pending` 查看待审题目，并用 `PUT /api/admin/problems/:id/review` 携带 `{ "status": "approved" }` 或 `{ "status": "rejected" }` 完成审核。

## 检查

```bash
cargo fmt --check
cargo test
cargo clippy --all-targets --all-features -- -D warnings
```
