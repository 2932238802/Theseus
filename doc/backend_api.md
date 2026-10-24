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

数据库迁移在服务启动时自动执行。题目提交会先返回 `pending`，随后由 `JudgeService` 进入 `judging` 并在评测器未配置时记录 `runtime_error`；该服务边界不会执行不受信任的用户代码。自定义题目通过 `POST /api/problems/custom` 提交，管理员通过待审核接口审批后才会公开。

## 接口清单

| 方法 | 路径 | 鉴权 | 说明 |
|---|---|---|---|
| POST | `/api/auth/register` | 否 | 注册，返回 `{message}` |
| POST | `/api/auth/login` | 否 | 登录，`username` 字段可传用户名或邮箱，返回 `{token,user}` |
| GET | `/api/problems` | 可选 | 分页题库，见下方查询参数 |
| GET | `/api/problems/tags` | 否 | 已审核题目的去重标签数组 |
| GET | `/api/problems/{id}` | 可选 | 已审核题目详情 |
| GET | `/api/stats` | 否 | `{total_problems,total_submissions,accepted_submissions}` |
| POST | `/api/problems/custom` | 用户 | 提交自定义题目，状态为 `pending` |
| POST | `/api/admin/problems` | 管理员 | 创建题目 |
| GET | `/api/admin/problems/pending` | 管理员 | 待审核题目 |
| PUT | `/api/admin/problems/{id}/review` | 管理员 | 审核题目 |
| PUT | `/api/admin/problems/{id}` | 管理员 | 更新题目 |
| DELETE | `/api/admin/problems/{id}` | 管理员 | 删除题目 |
| GET | `/api/submissions` | 用户 | 当前用户提交列表，管理员可传 `user_id` |
| POST | `/api/submissions` | 用户 | 创建提交，返回 `{submission_id,status,message}` |
| GET | `/api/submissions/{id}` | 用户/管理员 | 提交详情，仅本人或管理员可读 |

### `GET /api/problems` 查询参数

| 参数 | 取值 | 说明 |
|---|---|---|
| `page` | 正整数 | 默认 1 |
| `size` | 1-100 | 默认 20 |
| `difficulty` | `easy \| medium \| hard` | 难度筛选 |
| `tag` | 字符串 | 标签筛选 |
| `status` | `not_started \| attempted \| accepted` | 需要登录 |
| `search` | 字符串 | 标题或描述模糊搜索 |
| `sort` | `id \| difficulty \| acceptance_rate` | 白名单排序字段，默认 `id` |
| `order` | `asc \| desc` | 排序方向，默认 `asc` |

非法 `sort`/`order` 返回 400。登录失败（用户不存在或密码错误）返回 401 与 `用户名或密码错误`。
