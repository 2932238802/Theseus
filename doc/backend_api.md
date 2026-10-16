# Theseus 后端 API

后端地址默认是 `http://127.0.0.1:3000`。所有接口都返回统一结构：

```json
{"success":true,"data":{},"error":null}
```

认证接口返回的 JWT 通过 `Authorization: Bearer <token>` 访问受保护资源。管理员接口还要求 token 中的用户角色是 `admin`。

## 运行环境

```bash
cd backend-rust
cp .env.example .env
cargo run
```

数据库迁移在服务启动时自动执行。题目提交会先返回 `pending`，随后由 `JudgeService` 更新为评测结果。
