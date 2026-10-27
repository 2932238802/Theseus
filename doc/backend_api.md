# Theseus 后端 API

后端地址默认是 `http://127.0.0.1:3000`。所有接口都返回统一结构：

```json
{"success":true,"data":{},"error":null}
```

认证接口返回的 JWT 通过 `Authorization: Bearer <token>` 访问受保护资源。管理员接口还要求 token 中的用户角色是 `admin`。

> **角色模型：** 当前使用 `student` / `teacher` / `admin` 三个互斥角色，认证每次从 `users.role` 读取；管理员不能查看其他人的提交，教师只能访问自己的班级。详见 `doc/总体设计.md` 与 `doc/2610259_班级与作业设计方案.md`。

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
| POST | `/api/problems/custom` | 用户 | 提交自定义题目，状态为 `pending`；迁移后仅 `teacher` 可提交 |
| POST | `/api/admin/problems` | 管理员 | 创建题目 |
| GET | `/api/admin/problems/pending` | 管理员 | 待审核题目 |
| PUT | `/api/admin/problems/{id}/review` | 管理员 | 审核题目 |
| PUT | `/api/admin/problems/{id}` | 管理员 | 更新题目 |
| DELETE | `/api/admin/problems/{id}` | 管理员 | 删除题目 |
| GET | `/api/submissions` | 用户 | 当前用户提交列表；管理员当前可传 `user_id`，角色迁移后该分支移除 |
| POST | `/api/submissions` | 用户 | 创建提交，返回 `{submission_id,status,message}` |
| GET | `/api/submissions/{id}` | 用户 | 提交详情；本人或作业 owner 教师可读 |
| GET | `/api/auth/me` | 用户 | 当前用户资料，含头像、待验证邮箱、注册时间 |
| PUT | `/api/profile/username` | 用户 | 修改用户名 |
| POST | `/api/profile/email` | 用户 | 请求修改邮箱，发送新邮箱验证 |
| DELETE | `/api/profile/email/pending` | 用户 | 取消待验证邮箱 |
| PUT | `/api/profile/password` | 用户 | 修改密码，返回新 token |
| POST | `/api/auth/logout-all` | 用户 | 退出所有设备 |
| DELETE | `/api/profile` | 用户 | 注销账号并匿名化 |
| POST | `/api/profile/avatar` | 用户 | 上传头像（multipart） |
| DELETE | `/api/profile/avatar` | 用户 | 删除头像 |
| GET | `/api/profile/analytics` | 用户 | 个人学习分析 |
| GET | `/api/forum/favorites` | 用户 | 当前用户论坛收藏列表 |
| PUT | `/api/assignments/{id}` | 教师 | 修改作业；发布后仅允许延长截止时间 |
| POST | `/api/assignments/{id}/solutions/publish` | 教师 | 发布答案解析，要求作业已截止 |
| GET | `/api/assignments/{id}/overrides` | 教师 | 查询学生补交/免修例外 |
| PUT | `/api/assignments/{id}/overrides/{user_id}/problems/{problem_id}` | 教师 | 设置补交/免修 |
| DELETE | `/api/assignments/{id}/overrides/{user_id}/problems/{problem_id}` | 教师 | 撤销补交/免修 |
| GET | `/api/assignments/{id}/statistics` | 学生/教师 | 匿名班级统计；学生需作业开启统计 |
| GET | `/api/assignments/{id}/policy-audits` | 教师 | 策略、例外和解析发布审计 |
| GET | `/api/assignments/{id}/problems/{problem_id}/peer-submissions` | 学生/教师 | 同学 AC 代码；需作业开启开关 |

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


## 作业策略接口

完整语义见 `doc/2610271_作业策略的实现.md`。

### 创建/修改作业

`POST /api/classes/{id}/assignments` 与 `PUT /api/assignments/{id}` 支持策略字段：

```json
{
  "late_policy": "allow",
  "late_grace_hours": 24,
  "late_penalty_per_day": 10,
  "late_penalty_cap": 50,
  "max_attempts": 5,
  "scoring_policy": "highest",
  "score_visibility": "after_publish",
  "allow_peer_code": false,
  "show_class_stats": true,
  "problems": [
    {
      "problem_id": 1101,
      "points": 100,
      "max_attempts": 3,
      "solution_md": "解析文本"
    }
  ]
}
```

- `late_policy`：`forbid` / `allow`。
- `scoring_policy`：`highest` / `last` / `first_ac`。
- `score_visibility`：`after_publish` / `after_due` / `during`。
- 发布后策略字段锁定，只允许延长 `due_at`；补交/免修和解析发布不受影响。

### 补交/免修

```http
PUT /api/assignments/{id}/overrides/{user_id}/problems/{problem_id}
```

```json
{
  "makeup_due_at": "2026-11-05T15:59:00Z",
  "waive_late_penalty": true,
  "exempt": false,
  "exemption_mode": null,
  "reason": "病假补交"
}
```

- `exempt = true` 时，`exemption_mode` 必须是 `full_score` 或 `excluded`。
- 删除同一路径的 `DELETE` 请求可撤销例外。
- 每次写入都记录 `assignment_policy_audits` 并通知学生。

### 提交策略错误

| 场景 | 状态码 | 文案 |
|---|---:|---|
| 超过迟交窗口 | 409 | 作业已截止 |
| 该题免修 | 409 | 该题已免修 |
| 次数用尽 | 409 | 该题提交次数已用完 |
| 发布后修改锁定策略 | 409 | 作业已发布，计分、次数、迟交和可见性策略不可修改 |
| 未截止发布解析 | 409 | 作业尚未截止，不能发布解析 |


## 个人中心接口

完整设计见 `doc/2610272_个人界面的完善.md`。

- `GET /api/auth/me` 增加 `avatar_url`、`pending_email`、`created_at`。
- `PUT /api/profile/username` 请求 `{"username":"..."}`，唯一性冲突返回 409。
- `POST /api/profile/email` 请求 `{"email":"..."}`；验证新邮箱前旧邮箱继续可用。
- `PUT /api/profile/password` 请求 `{"current_password":"...","new_password":"..."}`，返回新 token。
- `DELETE /api/profile` 请求 `{"password":"...","username":"..."}`；教师有未归档班级或最后一个管理员时返回 409。
- `POST /api/profile/avatar` 使用 `multipart/form-data`，字段 `file`，JPG/PNG/WebP ≤2MB。
- `GET /api/profile/analytics?days=30` 返回概览、趋势、难度和标签统计。
- `GET /api/forum/favorites?page=&size=` 返回当前用户收藏的帖子。
