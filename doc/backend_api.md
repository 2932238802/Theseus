# Theseus 后端 API

后端地址默认是 `http://127.0.0.1:3000`。所有接口都返回统一结构：

```json
{"success":true,"data":{},"error":null}
```

认证接口返回的 JWT 通过 `Authorization: Bearer <token>` 访问受保护资源。管理员接口还要求 token 中的用户角色是 `admin`。

> **角色模型：** 当前使用 `student` / `teacher` / `admin` 三个互斥角色，认证每次从 `users.role` 读取；管理员不能查看其他人的提交，教师只能访问自己的组织。详见 `doc/总体设计.md` 与 `doc/2610259_班级与作业设计方案.md`。

## 运行环境

```bash
cd backend-rust
cp .env.example .env
cargo run
```

数据库迁移在服务启动时自动执行。题目提交会先返回 `pending`，随后由 `JudgeService` 进入 `judging` 并在评测器未配置时记录 `runtime_error`；该服务边界不会执行不受信任的用户代码。学生和教师均可通过 `POST /api/problems/custom` 提交个人题目，管理员通过待审核接口审批后才会公开。

## 健康检查

- `GET /healthz`：存活探针，不访问数据库或 Redis，返回 `{"status":"ok"}`。
- `GET /readyz`：就绪探针，检查 PostgreSQL；启用判题（`RUN_CODE_ENABLED` 或 `SUBMIT_JUDGE_ENABLED`）时同时检查 Redis。正常返回 200：

```json
{"status":"ok","database":"ok","redis":"ok","version":"0.1.0"}
```

任一依赖不可用时返回 503，`status` 为 `degraded`，并由 `database` / `redis` 字段指出原因；未启用判题时 `redis` 为 `disabled`。两个接口均无鉴权，部署时只在内网/容器网络暴露。

## 接口清单

| 方法 | 路径 | 鉴权 | 说明 |
|---|---|---|---|
| GET | `/healthz` | 无 | 存活探针，仅返回 `{"status":"ok"}`，不访问依赖 |
| GET | `/readyz` | 无 | 就绪探针，检查 PostgreSQL 与（启用判题时的）Redis，异常返回 503 |
| POST | `/api/auth/register` | 否 | 注册，返回 `{message}` |
| POST | `/api/auth/login` | 否 | 登录，`username` 字段可传用户名或邮箱，返回 `{token,user}` |
| GET | `/api/home/overview` | 用户 | 首页学习工作台：继续学习、统计、最近活动、今日签到与信誉分 |
| POST | `/api/home/check-in` | 用户 | 每日签到，信誉分 +0.1（上限 100） |
| GET | `/api/problems` | 可选 | 分页题库，见下方查询参数 |
| GET | `/api/problems/random` | 否 | 随机返回一道已通过审核的题目 `{problem_id}` |
| GET | `/api/problems/tags` | 否 | 已审核题目的去重标签数组 |
| GET | `/api/problems/{id}` | 可选 | 已审核题目详情，登录时 `favorited` 表示是否已收藏 |
| POST | `/api/problems/{id}/favorite` | 用户 | 收藏题目 |
| DELETE | `/api/problems/{id}/favorite` | 用户 | 取消收藏题目 |
| GET | `/api/problems/{id}/draft` | 用户 | 读取云端草稿，查询参数 `language`，返回 `{draft:{language,code,updated_at}\|null}` |
| PUT | `/api/problems/{id}/draft` | 用户 | 保存云端草稿 `{language,code}`；`code` 为空或全空白时删除草稿 |
| GET | `/api/problems/{id}/note` | 用户 | 读取本人题目笔记，返回 `{note:{body_md,updated_at}\|null}` |
| PUT | `/api/problems/{id}/note` | 用户 | 保存本人题目笔记 `{body_md}`；内容为空或全空白时删除笔记 |
| GET | `/api/stats` | 否 | `{total_problems,total_submissions,accepted_submissions}` |
| POST | `/api/problems/custom` | 学生 / 教师 | 个人出题，题目以 `pending` 状态落库，管理员审核通过后公开；管理员请使用管理端接口 |
| GET | `/api/problems/mine` | 学生 / 教师 | 当前用户提交的题目，支持 `status`、`page`、`size` |
| GET | `/api/problems/mine/{id}` | 学生 / 教师 | 查看本人提交的题目详情，非本人返回 404 |
| PUT | `/api/problems/mine/{id}` | 学生 / 教师 | 仅 `rejected` 题目可修改并重新进入 `pending` |
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
| PUT | `/api/profile/grade` | 用户 | 更新年级，`null`/空字符串表示清除 |
| POST | `/api/auth/logout-all` | 用户 | 退出所有设备 |
| DELETE | `/api/profile` | 用户 | 注销账号并匿名化 |
| POST | `/api/profile/avatar` | 用户 | 上传头像（multipart） |
| DELETE | `/api/profile/avatar` | 用户 | 删除头像 |
| GET | `/api/profile/analytics` | 用户 | 个人学习分析，含信誉分与连续签到天数 |
| GET | `/api/profile/badges` | 用户 | 当前有效徽章列表 |
| PUT | `/api/profile/badges/{code}/visibility` | 用户 | 设置徽章是否在公开位置展示 `{hidden}` |
| GET | `/api/forum/favorites` | 用户 | 当前用户论坛帖子收藏列表 |
| POST | `/api/forum/comments/{id}/favorite` | 用户 | 收藏论坛评论或回复 |
| DELETE | `/api/forum/comments/{id}/favorite` | 用户 | 取消收藏论坛评论或回复 |
| GET | `/api/profile/favorites/problems` | 用户 | 当前用户题目收藏列表 |
| GET | `/api/profile/favorites/comments` | 用户 | 当前用户评论收藏列表 |
| GET | `/api/profile/notification-preferences` | 用户 | 通知邮件偏好与邮箱验证状态 |
| PUT | `/api/profile/notification-preferences` | 用户 | 批量更新通知邮件偏好 |
| GET | `/api/shop/plus` | 用户 | 当前 Plus 状态、当前会员期与最近一条申请 |
| POST | `/api/shop/plus/apply` | 学生 / 教师 | 提交 Plus 开通或续费申请 `{reason}`，需已验证邮箱 |
| GET | `/api/admin/plus-applications` | 管理员 | Plus 申请分页，支持 `status`、`page`、`size` |
| POST | `/api/admin/plus-applications/{id}/resolve` | 管理员 | 通过或驳回 `{status:"approved\|rejected",note,days}` |
| GET | `/api/contests/featured` | 用户 | 竞赛首页：排位赛配置、规则分组与限时赛事列表 |
| GET | `/api/contests/events` | 用户 | 赛事列表，支持 `type`、`status`、`following`、`page`、`page_size` |
| GET | `/api/contests/events/{id}` | 用户 | 赛事详情（含说明、规则和报名链接） |
| POST | `/api/contests/events/{id}/follow` | 用户 | 关注赛事 |
| DELETE | `/api/contests/events/{id}/follow` | 用户 | 取消关注 |
| POST | `/api/contests/events/{id}/register` | 用户 | 公开赛事报名，返回更新后的赛事卡片 |
| POST | `/api/contests/events/{id}/join` | 用户 | 邀请赛事直接加入，返回更新后的赛事卡片 |
| POST | `/api/contests/events/{id}/enter` | 用户 | 进入赛事比赛，返回 `{event_id,contest_id}` |
| GET | `/api/contests/events/{id}/leaderboard` | 用户 | 赛事排行榜 |
| GET | `/api/contests/rankings` | 用户 | 排位榜，`limit` 默认 20，可选 `season_id` |
| GET | `/api/contests/seasons` | 用户 | 当前赛季与公开赛季列表 |
| GET | `/api/contests/appeals/mine` | 用户 | 我的赛事申诉 |
| POST | `/api/contests/{id}/appeal` | 用户 | 提交赛事申诉 `{reason}`，每场一次 |
| POST | `/api/ws/ticket` | 用户 | 换取一次性 WebSocket 连接票据 |
| GET | `/api/ws?ticket=...` | 票据 | WebSocket 升级，见「实时推送」一节 |
| POST | `/api/lsp/ticket` | 用户 | 换取短期语义补全连接票据 |
| GET | `/api/admin/events` | 管理员 | 赛事管理列表 |
| POST | `/api/admin/events` | 管理员 | 创建赛事 |
| GET | `/api/admin/events/{id}` | 管理员 | 赛事管理详情 |
| PUT | `/api/admin/events/{id}` | 管理员 | 更新赛事 |
| POST | `/api/admin/events/{id}/forum` | 管理员 | 同步赛事到校园墙并置顶 |
| GET | `/api/admin/events/{id}/results/export` | 管理员 | 导出赛事成绩 CSV（UTF-8 BOM） |
| GET | `/api/admin/seasons` | 管理员 | 赛季列表（含草稿） |
| POST | `/api/admin/seasons` | 管理员 | 创建赛季 |
| PUT | `/api/admin/seasons/{id}` | 管理员 | 更新赛季 |
| GET | `/api/admin/contest-appeals` | 管理员 | 赛事申诉队列，支持 `status` |
| POST | `/api/admin/contest-appeals/{id}/resolve` | 管理员 | 通过/驳回申诉 `{status,note}` |
| GET | `/api/admin/contests/{id}/proctor-events` | 管理员 | 疑似粘贴事件与复核状态 |
| POST | `/api/admin/contests/{id}/proctor-events/{event_id}/review` | 管理员 | 提交复核结论 `{status,note}`；确认后扣分并重新结算 |
| GET | `/api/admin/audit-logs` | 管理员 | 审计日志分页，支持 `page`、`size`、`action`、`target_type`、`actor_id`、`q`、`from`、`to` |
| GET | `/api/admin/audit-logs/meta` | 管理员 | 动作与对象类型去重计数，供筛选下拉 |
| GET | `/api/admin/audit-logs/export` | 管理员 | 按当前筛选导出审计 CSV（UTF-8 BOM，最多 10000 行） |
| PUT | `/api/admin/users/{id}/reputation` | 管理员 | 定量恢复信誉分 `{score,note}`；恢复到 0 分以上自动解封 |
| PUT | `/api/assignments/{id}` | 教师 | 修改作业；发布后仅允许延长截止时间 |
| POST | `/api/assignments/{id}/solutions/publish` | 教师 | 发布答案解析，要求作业已截止 |
| GET | `/api/assignments/{id}/overrides` | 教师 | 查询学生补交/免修例外 |
| PUT | `/api/assignments/{id}/overrides/{user_id}/problems/{problem_id}` | 教师 | 设置补交/免修 |
| DELETE | `/api/assignments/{id}/overrides/{user_id}/problems/{problem_id}` | 教师 | 撤销补交/免修 |
| GET | `/api/assignments/{id}/statistics` | 学生/教师 | 匿名组织统计；学生需作业开启统计 |
| GET | `/api/assignments/{id}/gradebook` | 教师 | 批改台，`include_removed=1` 包含已移除成员 |
| GET | `/api/assignments/{id}/gradebook/export` | 教师 | 导出成绩 CSV（UTF-8 BOM），参数同批改台 |
| POST | `/api/classes/{id}/import` | 教师 | CSV 批量导入学生，逐行返回 `added/skipped` 结果 |
| GET | `/api/assignments/{id}/policy-audits` | 教师 | 策略、例外和解析发布审计 |
| GET | `/api/assignments/{id}/problems/{problem_id}/peer-submissions` | 学生/教师 | 同学 AC 代码；需作业开启开关 |
| GET | `/api/teacher/cheat-reports` | 教师 | 自己组织作业的相似度报告，支持 `status`、`assignment_id`、`page`、`size` |
| GET | `/api/teacher/cheat-reports/{id}` | 教师 | 报告详情：双方提交代码、匹配证据、申诉与审计轨迹 |
| POST | `/api/teacher/cheat-reports/{id}/review` | 教师 | 复核 `{decision,note,apply_zero}`；`decision` 为 `confirmed`/`dismissed` |
| GET | `/api/teacher/appeals` | 用户 | 当前用户作为处理人的待裁定申诉 |
| POST | `/api/teacher/appeals/{id}/resolve` | 处理人 | 裁定 `{decision,note}`；`decision` 为 `upheld`/`overturned` |
| GET | `/api/cheat-reports/mine` | 用户 | 当前用户已确认/申诉中的作弊报告 |
| GET | `/api/cheat-reports/{id}` | 当事人 | 报告详情，仅返回自己的提交，不含对方身份与代码 |
| POST | `/api/cheat-reports/{id}/appeal` | 当事人 | 提交一次申诉 `{reason}`，报告必须为 `confirmed` |

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

题目列表与详情额外返回 `number`：按已发布题目的数据库 `id` 升序连续编号的题号（1、2、3…），用于题库展示；`id` 仍是路由与判题使用的数据库主键。

### 个人出题

学生和教师均可提交题目：`POST /api/problems/custom` 落库为 `pending`，管理员通过 `/api/admin/problems/{id}/review` 审核通过后才进入题库。`/api/problems/mine*` 仅返回和操作当前用户自己提交的题目；管理员调用个人出题接口返回 403，应使用 `/api/admin/problems`。


### 审计日志

管理员可通过 `GET /api/admin/audit-logs` 查询敏感操作留痕，按 `action`、`target_type`、`actor_id` 精确筛选，`q` 模糊匹配操作者/动作/摘要/IP，`from`/`to` 接受 `YYYY-MM-DD` 或 RFC3339（日期按 UTC 整天）。`size` 上限 100，默认 20。

返回 `{total,page,size,logs[]}`，每条记录包含 `actor_id`、`actor_username`、`actor_role`、`action`、`target_type`、`target_id`、`summary`、`before`、`after`、`ip`、`user_agent`、`created_at`。`GET /api/admin/audit-logs/meta` 返回动作与对象类型的去重计数。

`GET /api/admin/audit-logs/export` 使用相同筛选参数导出 CSV，列为时间、操作者、角色、动作、对象类型、对象ID、摘要、变更前、变更后、IP、User-Agent；每次导出本身也会写一条 `audit.export`。

审计日志只追加，后端不提供修改或删除接口。成绩相关动作只记录操作者、作业与学生/题目 id，不写入分数或评语，避免管理员借审计接口读取教学数据。完整动作清单见 `doc/2610303_审计中心设计方案.md`。

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


## 教学数据导入与导出

设计见 `doc/2610302_教学数据导入导出设计方案.md`。

### 批量导入学生

```http
POST /api/classes/{id}/import
Authorization: Bearer <teacher>
Content-Type: application/json
```

```json
{
  "csv": "username,email\nalice,alice@example.com\nbob,\ncarol,carol@example.com"
}
```

- 仅组织 owner 教师可调用；组织已归档返回 409，非 owner 返回 404。
- CSV 支持 `username,email` 表头（中英文均可），也可省略表头；每行按顺序尝试用户名、邮箱。
- 有效行直接加入组织（与单条添加成员一致），不发送邀请；已是成员的行保持原状态。
- 单行失败不影响其他行，响应逐行给出结果：

```json
{
  "success": true,
  "data": {
    "added_count": 2,
    "skipped_count": 4,
    "rows": [
      {"line": 2, "identifier": "alice", "username": "alice", "status": "added", "reason": null},
      {"line": 3, "identifier": "bob", "username": "bob", "status": "already_member", "reason": "已经是组织成员"},
      {"line": 4, "identifier": "carol", "username": "carol", "status": "duplicate", "reason": "CSV 中重复出现"},
      {"line": 5, "identifier": "ghost", "username": null, "status": "not_found", "reason": "未找到该用户名或邮箱"},
      {"line": 6, "identifier": "teacher1", "username": "teacher1", "status": "not_student", "reason": "教师或管理员账号不能加入组织"}
    ]
  },
  "error": null
}
```

`status` 取值：`added`、`already_member`、`not_found`、`not_student`、`duplicate`、`invalid`。

限制：请求体 ≤1 MB，CSV ≤512 KB、最多 500 名学生、10 列、单字段 320 字符；超限或引号未闭合返回 400。空行与以 `#` 开头的行会被忽略。

### 导出成绩

```http
GET /api/assignments/{id}/gradebook/export?include_removed=0
Authorization: Bearer <teacher>
```

- 仅作业所属教师可调用；学生返回 403，非 owner 教师返回 404。
- 返回 `text/csv; charset=utf-8`，带 UTF-8 BOM，`Content-Disposition: attachment; filename="assignment-{id}-grades.csv"`。
- 列为：用户名、邮箱、成员状态、各题最终分（`题目名（N 分）`）、总分、整体评语；含逗号、引号或换行的字段按 CSV 规则转义。
- `include_removed=1` 与批改台一致，包含已移除但仍有提交或成绩的成员。

成绩发布仍走既有通知链路：`POST /api/assignments/{id}/grades/publish` 写入 `assignment_grades_published` 站内信，后台邮件循环按 `assignment` 类别偏好投递邮件。


## 个人中心接口

完整设计见 `doc/2610272_个人界面的完善.md`。头像文件默认写入 `UPLOAD_DIR=./uploads`，通过 `/uploads` 静态访问；生产环境需设置持久化目录。

- `GET /api/auth/me` 增加 `avatar_url`、`pending_email`、`created_at`。
- `PUT /api/profile/username` 请求 `{"username":"..."}`，唯一性冲突返回 409。
- `POST /api/profile/email` 请求 `{"email":"..."}`；验证新邮箱前旧邮箱继续可用。
- `PUT /api/profile/password` 请求 `{"current_password":"...","new_password":"..."}`，返回新 token。
- `PUT /api/profile/grade` 请求 `{"grade":"高二"}`，`grade` 为 `null` 或空字符串时清除；最长 20 字符，返回与 `GET /api/auth/me` 相同的用户资料。
- `DELETE /api/profile` 请求 `{"password":"...","username":"..."}`；教师有未归档组织或最后一个管理员时返回 409。
- `POST /api/profile/avatar` 使用 `multipart/form-data`，字段 `file`，JPG/PNG/WebP ≤2MB。
- `GET /api/profile/analytics?days=30` 返回概览、趋势、难度和标签统计。
- `GET /api/forum/favorites?page=&size=` 返回当前用户收藏的帖子；面经收藏只对 Plus 用户、管理员与面经作者返回。
- `GET /api/profile/notes?page=&size=` 返回当前用户的题目笔记摘要 `{total,page,size,notes:[{problem_id,title,difficulty,excerpt,updated_at}]}`，只包含已审核题目，摘要截取前 160 字
- 题目笔记仅本人可见，题目必须已审核，正文最长 32KB；空内容保存会删除笔记（`0037`）
- `GET /api/profile/favorites/problems?page=&size=` 返回收藏的已审核题目 `{total,page,size,favorites:[{problem_id,title,difficulty,acceptance_rate,favorited_at}]}`
- `GET /api/profile/favorites/comments?page=&size=` 返回收藏的评论 `{total,page,size,favorites:[{comment_id,post_id,post_title,parent_id,body_md,author,created_at,favorited_at}]}` 作者字段沿用公开作者结构，匿名评论不会泄露真实用户名
- 收藏与取消收藏接口均返回 `{favorited}`，重复调用幂等；题目详情和列表的 `favorited` 字段、论坛评论和回复的 `favorited` 字段只对当前登录用户生效
- `GET /api/profile/notification-preferences` 返回 `{email,email_verified,preferences:[{category,channel,enabled}]}`，未保存过的类别返回代码里的默认值
- `PUT /api/profile/notification-preferences` 请求 `{"preferences":[{"category":"forum","enabled":true}]}`，可一次提交多项，返回与 GET 相同的完整偏好；`category` 取 `class|assignment|forum|account|contest|announcement`
- 偏好只控制邮件渠道，站内信始终接收；通知邮件只发送到已验证的邮箱，后台邮件循环每轮把待处理通知转入发件箱，用户关闭某类别后该类别不再产生新邮件

## 商店与 Plus Theseus 接口

完整设计见 `doc/2610312_商店与Plus申请设计方案.md`。Plus 权益为面经板块权限与专属标识，有效期由管理员审核时填写。

- `GET /api/shop/plus` 返回 `{is_plus, membership?, application?}`。`is_plus` 表示 `plus_memberships.expires_at` 是否晚于当前时间；`membership` 含 `started_at`、`expires_at`、`days_left`；`application` 是最近一条申请，含 `id`、`user_id`、`username`、`reason`、`kind`、`status`、`review_note`、`reviewed_by`、`reviewed_at`、`membership_expires_at`、`created_at`。
- `POST /api/shop/plus/apply` 请求 `{"reason":"..."}`，说明去掉首尾空白后 1–500 字；管理员调用返回 403；已有待审核申请时返回 409；会员有效时提交的是续费申请（`kind:"renewal"`），否则为新开通（`kind:"new"`）。
- `GET /api/admin/plus-applications?status=pending&page=1&size=20` 返回 `{total,page,size,items[]}`，`status` 取 `pending|approved|rejected`，`size` 上限 100。
- `POST /api/admin/plus-applications/{id}/resolve` 请求 `{"status":"approved|rejected","note":"...","days":30}`，说明 ≤500 字；只允许处理 `pending`。`approved` 时 `days` 必填且为 1–3650，写入或顺延 `plus_memberships`；`rejected` 忽略 `days`。审核成功后向申请人写入 `plus_application` 站内信（邮件类别 `account`，通过时包含到期日期，续费时文案为续费），并记录审计动作 `plus.application_resolve`。
- API 进程每小时检查到期时间，在 7/3/1 天前写入 `plus_expiry` 站内信（邮件类别 `account`），同一会员期的每个节点只发一次；续费改变到期时间后重新计算。

## 面经板块（论坛）

完整设计见 `doc/2610313_面经板块设计方案.md` 与 `doc/2610314_题目题解与讨论区设计方案.md`。面经是论坛的一个板块，复用论坛的列表、详情、评论、点赞、收藏、举报与审核接口，通过 `board` 区分：

- 综合板块 `board=general`（默认），标签只接受 `general` / `help` / `solution` / `discussion` / `announcement`，最多 3 个
- 面经板块 `board=interview`，标签为自由文本，1–8 个，每个 ≤20 字；新增 `interview_date`（`YYYY-MM`，可空）、`company`、`role`（各 ≤40 字，可空）与 `view_count`（阅读数）

权限：

- `GET /api/forum/posts?board=interview`、`GET /api/forum/posts/{id}`、评论列表与详情、点赞、收藏、举报，要求 Plus、管理员或面经作者；其他用户返回 403，错误文案「需要开通 Plus Theseus 才能查看面经」
- `GET /api/forum/posts?board=interview&company=百度&role=后端` 支持公司与岗位精确筛选
- `GET /api/forum/interview/facets` 返回 `{companies,roles}`，取自已发布面经；要求 Plus 或管理员
- `POST /api/forum/posts` 带 `board:"interview"` 时要求 Plus 或管理员
- 管理员接口不受 Plus 限制，`GET /api/admin/forum/posts` 支持 `board` 筛选

请求示例：

```json
{
  "board": "interview",
  "title": "百度后端 · 二面（2026-10）",
  "body_md": "## 面试流程\n\n## 题目\n\n...",
  "tags": ["百度", "后端", "场景题"],
  "interview_date": "2026-10",
  "company": "百度",
  "role": "后端",
  "problem_id": null,
  "is_anonymous": false
}
```

- 板块创建后不可切换，`PUT /api/forum/posts/{id}` 只更新标题、正文、标签、面试时间、公司与岗位与关联题目
- 列表与详情响应新增 `board`、`interview_date`、`company`、`role`、`view_count`、`accepted_comment_id`
- 详情页每次成功打开后 `view_count` +1，列表与详情返回自增后的值
- `POST /api/forum/posts/{id}/accepted-comment` 请求 `{"comment_id":123}` 设置最佳答案，`DELETE` 取消；仅帖子作者与管理员可调用，只能采纳本帖子下未隐藏的顶层评论；响应 `{accepted_comment_id,message}`，评论与回复带 `is_accepted`
- `GET /api/forum/posts?problem_id=12&sort=hot` 返回关联该题的已发布帖子，用于题目页「题解与讨论」；`problem_id` 必须为正整数，未指定 `board` 时只返回综合板块内容
- 旧 `/api/knowledge*`、`/api/admin/knowledge*` 接口已移除；历史面经由迁移 `0032` 复制到 `forum_posts`

## 竞赛与限时赛事接口

完整设计见 `doc/2610281_实现多人竞赛匹配机制.md` 与 `doc/2610291_竞赛ui的完善.md`。

`POST /api/contests/match` 请求体为 `{camera_permission,screen_permission}`，取值 `granted|denied|unavailable`。两个字段都必须是 `granted`，否则返回 400；客户端应依次完成摄像头授权和屏幕共享后再调用。比赛创建时两个授权结果写入 `contest_participants` 并各记录一条 `contest_events`。

`GET /api/contests/featured` 返回：

```json
{
  "ranked": {
    "mode": "ranked",
    "title": "4 人排位赛",
    "participants": 4,
    "duration_minutes": 60,
    "problem_count": 4,
    "rating_window": 100,
    "my_rating": 1000,
    "season": { "id": 3, "name": "2026 秋季赛", "state": "active" },
    "rules": [{ "title": "比赛流程", "items": ["..."] }]
  },
  "events": [
    {
      "id": 1,
      "title": "校园算法挑战赛",
      "organizer": "教务处",
      "type": "school",
      "status": "registration",
      "starts_at": "2026-10-31T06:00:00Z",
      "ends_at": "2026-10-31T08:00:00Z",
      "registration_opens_at": null,
      "registration_deadline": "2026-10-30T15:59:00Z",
      "scope": "面向本校学生",
      "grade_scope": ["高一", "高二"],
      "capacity": 100,
      "registered_count": 12,
      "is_registered": false,
      "eligible": true,
      "ineligible_reason": null,
      "action": "register",
      "rules_summary": "..."
    }
  ],
  "server_time": "2026-10-29T04:00:00Z"
}
```

- `status`：`registration` 报名中、`upcoming` 即将开始、`running` 进行中、`full` 已满员；已结束和草稿赛事不返回。
- `action`：`register` 报名、`join` 加入、`enter` 进入赛事、`details` 查看详情、`full` 已满员、`closed` 已截止。
- `eligible = false` 时前端置灰操作，原因在 `ineligible_reason`：组织范围不符为「仅限指定组织的学生参加」，年级不符为「仅限 XX 学生参加」；未填写年级的用户不能报名限定了年级的赛事。
- 排名排序：进行中赛事优先且按结束时间，其余按开始时间升序。

报名与加入错误：

| 场景 | 状态码 |
|---|---:|
| 赛事不存在或未发布 | 404 |
| 外部链接赛事走站内报名、报名/加入接口与 `registration_mode` 不匹配 | 400 |
| 非指定组织成员 | 403 |
| 年级不在赛事范围内 | 403 |
| 赛事已开始或已结束 | 409 |
| 报名尚未开始或已截止 | 409 |
| 名额已满 | 409 |

重复报名幂等：已报名的用户再次调用返回 200 与最新卡片。`POST .../join` 仅适用于 `registration_mode = 'invite'` 的赛事；公开赛事应调用 `register`。

### 赛事列表与关注

`GET /api/contests/events` 返回 `{events,total,page,page_size,server_time}`，`events` 元素与 `featured.events` 的赛事卡片一致，并额外包含 `is_followed`。`type` 取 `official|teacher|school`，`status` 取 `registration|upcoming|running|ended|cancelled`，`following=true` 仅返回已关注赛事。

`POST|DELETE /api/contests/events/{id}/follow` 返回 `{is_followed}`，重复调用幂等。

`GET /api/admin/contests/{id}/proctor-events` 返回该场比赛的 `paste_suspicious` 事件：

```json
{
  "contest": { "id": 12, "event_id": 3, "event_title": "校园算法挑战赛", "status": "finished", "starts_at": "...", "ends_at": "..." },
  "items": [{
    "id": 88,
    "user_id": 7,
    "username": "alice",
    "event_type": "paste_suspicious",
    "payload": { "length": 420, "lines": 18, "code_similarity": 0.03, "problem_similarity": 0.05, "preview": "...", "preview_truncated": true, "language": "cpp" },
    "client_time": "...",
    "received_at": "...",
    "review_status": "pending",
    "review_note": null,
    "reviewed_by": null,
    "reviewed_at": null,
    "assigned_admin": "admin1",
    "assigned_to_me": true
  }],
  "pending_count": 1
}
```

`review_status` 取 `pending|cleared|confirmed`。新事件按「待复核数量最少」自动分配给在线管理员，`assigned_admin` 为负责管理员，`assigned_to_me` 表示当前管理员是否可以处理；无管理员可分或负责管理员已停用时，事件保持可被任意管理员接管。管理员可以滞后审批。

`POST .../review` 请求体 `{status,note}`，`status` 只能是 `cleared` 或 `confirmed`，备注不超过 500 字；只能由负责管理员或无人负责时提交。确认作弊会：

1. 固定扣除 25 信誉分，同一事件只扣一次；
2. 取消该用户本场成绩，并在比赛已结束时立即重新结算排名；
3. 排位赛按新名次重新计算段位分，只把新旧结果的差额应用到用户当前段位分，保证后续比赛不被覆盖；
4. 返回 `{message,review_status,reputation_score,disqualified,rating_reranked}`。

已确认的记录不能改回 `cleared`，重复确认不会重复扣分。信誉分低于 0 时账号自动变为 `banned`、当前登录失效，邮箱加入黑名单；低于 40 时禁止参与排位赛、赛事报名/进入和论坛发言。已确认作弊的处罚没有公开论坛通报。`GET /api/contests/{id}/result` 的排名项新增 `disqualified` 字段，被取消成绩的选手排在最后并标记「成绩已取消」。

### 赛事内答题

`POST /api/contests/events/{id}/enter` 要求赛事已发布、当前时间在 `[starts_at,ends_at)` 内且用户已报名。首次进入时按 `official_event_problems` 冻结题目快照并创建赛事比赛，然后把该用户从 `queued` 提升为 `active`，返回 `{event_id,contest_id}`。前端随后使用常规比赛接口 `GET /api/contests/{id}`、`/problems/{problem_id}`、`/events`、`/heartbeat`、`/finish`、`/result`。

赛事比赛特点：

- 题目只能来自赛事配置，未配置题目时返回 409「赛事暂未配置题目」。
- 提前离场不会立即结算，赛事结束后统一结算。
- 赛事比赛不修改 `users.contest_rating`；排名只在本赛事内生效。

错误：未报名 403，比赛未开始或已结束 409，未配置题目 409。

### 比赛心跳与在线状态

`contest_participants.status` 取 `queued|active|disconnected|timed_out|finished`。比赛进行中，客户端每 10 秒调用一次心跳；轮询比赛详情时也会补一次心跳。

`POST /api/contests/{id}/heartbeat` 无请求体，返回：

```json
{
  "contest_id": 42,
  "status": "running",
  "my_status": "active",
  "ends_at": "2026-10-29T12:00:00Z",
  "disconnected_at": null,
  "reconnect_grace_seconds": 120,
  "server_time": "2026-10-29T11:20:00Z"
}
```

- 只有比赛 `running` 且本人为 `active|disconnected` 时更新 `last_seen_at`；`disconnected` 会恢复为 `active` 并清空 `disconnected_at`，其他状态只读返回。
- 不是该场比赛的选手返回 404；比赛已结束或已取消返回 409，前端按详情状态处理。
- 后台任务每 5 秒扫描一次：`active` 超过 30 秒无心跳变为 `disconnected`；`last_seen_at` 超过 120 秒的 `disconnected` 变为 `timed_out` 并写站内信「比赛断线超时」；`timed_out` 选手不能再提交，`finished_at` 保持为空。
- 排位赛全员 `timed_out` 时比赛变为 `cancelled`，不结算、不改变段位分，参赛者收到站内信「比赛已取消」；赛事比赛不因全员断线取消。
- 排位赛没有 `active|disconnected` 且有选手 `finished` 时提前结算，不再等待 `ends_at + 20s`。
- `disqualified_at` 不为空的选手不参与在线判定，也不能通过心跳恢复为 `active`。

### 赛事排行榜

`GET /api/contests/events/{id}/leaderboard` 返回：

```json
{
  "event_id": 1,
  "state": "running",
  "contest_id": 12,
  "entries": [
    {
      "rank": 1,
      "user_id": 3,
      "username": "student",
      "solved_count": 3,
      "total_score": 285.5,
      "is_me": false
    }
  ],
  "server_time": "2026-10-29T04:00:00Z"
}
```

- 首位选手进入前 `state = pending`、`contest_id = null`，`entries` 为已报名用户。
- 进入后 `state` 为比赛状态 `running|settling|finished`；`rank` 结算前为 `null`，结算后按名次返回。

### 排位榜

`GET /api/contests/rankings?limit=20&season_id=3` 返回 `{entries,my_rank,my_rating,total,season,seasons,server_time}`，`entries` 元素为 `{rank,user_id,username,rating,played,wins,is_me}`。统计只包含非赛事比赛的已结束场次，`limit` 取值 1-100。

- 不传 `season_id` 时使用当前赛季；没有任何赛季配置时回退到旧的全局 `users.contest_rating` 统计，`season` 为 `null`。
- 指定 `season_id` 时读取 `season_ratings`，`my_rank` 与 `total` 也在该赛季范围内计算。
- `seasons` 为可切换的公开赛季列表，元素结构见「赛季」。

### 赛季

`GET /api/contests/seasons` 返回 `{current,items,server_time}`，`current` 与 `items` 的元素结构：

```json
{
  "id": 3,
  "name": "2026 秋季赛",
  "starts_at": "2026-09-01T00:00:00Z",
  "ends_at": "2026-12-31T23:59:59Z",
  "status": "published",
  "soft_reset_ratio": 0.5,
  "activated": true,
  "state": "active"
}
```

- `state` 由当前时间计算：`upcoming|active|finished|cancelled`，不落库。
- 赛季首次被访问时惰性激活：`activated=false` → 在事务内按 `max(0, round(1000 + (old - 1000) × soft_reset_ratio))` 写入 `season_ratings` 并切换 `users.contest_rating`，重复调用幂等。

`GET|POST|PUT /api/admin/seasons[/{id}]`：

- `GET` 返回 `{items}`，包含草稿与已取消赛季。
- 创建/更新请求 `{name,starts_at,ends_at,soft_reset_ratio?,status?}`；`status` 取 `draft|published|cancelled`，默认 `draft`；`soft_reset_ratio` 默认 `0.5`。
- 同一时间只允许一个 `published` 赛季覆盖当前时间，区间重叠返回 409。
- 已激活赛季禁止修改起止时间与软重置系数，只能改名、保持发布或取消。

### 赛事申诉

`GET /api/contests/appeals/mine` 返回 `{items,total,server_time}`，元素：

```json
{
  "id": 7,
  "contest_id": 12,
  "event_id": 3,
  "event_title": "校园算法挑战赛",
  "user_id": 3,
  "username": "student",
  "reason": "本人未粘贴代码，申请复核",
  "status": "pending",
  "handle_note": null,
  "handled_by": null,
  "disqualified": true,
  "created_at": "2026-10-30T08:00:00Z",
  "handled_at": null
}
```

- `POST /api/contests/{id}/appeal` 请求 `{"reason":"..."}`，理由 1–1000 字；要求比赛已结束（或已过 `ends_at`）且本人为参赛者，`(contest_id,user_id)` 唯一，重复提交返回 409。
- `GET /api/admin/contest-appeals?status=pending` 返回相同结构，待处理记录优先，最多 200 条。
- `POST /api/admin/contest-appeals/{id}/resolve` 请求 `{"status":"accepted|rejected","note":"..."}`，说明 ≤500 字；只允许处理 `pending`。
- **通过**时恢复该场 `paste_cheating` 扣除的信誉分（上限 100）、写 `appeal_restored` 流水，必要时解封并递增 `token_version`；清除取消资格标记、把已确认的监考复核改为 `cleared`，比赛已结束时重新排名并修正段位/赛季分。
- 返回 `{message,status,disqualified,rating_reranked}`；两种结果都发站内信并写 `contest.appeal_resolve` 审计日志。

### 赛事成绩导出

`GET /api/admin/events/{id}/results/export` 返回 `text/csv; charset=utf-8` 附件，带 UTF-8 BOM，列为排名、用户名、总分、通过题数、完成时间、是否取消资格；字段按 RFC 4180 转义。每次导出写 `contest.results_export` 审计日志。

### 赛事管理

`GET /api/admin/events` 返回 `{events:[AdminEventView]}`。`AdminEventView` 字段：

```json
{
  "id": 1,
  "title": "校园算法挑战赛",
  "organizer": "教务处",
  "type": "school",
  "description": "赛事说明",
  "scope": "面向本校学生",
  "grade_scope": ["高一", "高二"],
  "capacity": 100,
  "registration_mode": "open",
  "class_id": null,
  "registration_url": null,
  "registration_opens_at": null,
  "registration_deadline": "2026-10-30T15:59:00Z",
  "starts_at": "2026-10-31T06:00:00Z",
  "ends_at": "2026-10-31T08:00:00Z",
  "status": "draft",
  "rules": [{ "title": "参赛说明", "items": ["独立完成"] }],
  "problem_ids": [1, 2, 3],
  "registered_count": 12,
  "contest_id": null,
  "forum_post_id": null,
  "created_at": "2026-10-20T02:00:00Z"
}
```

`POST|PUT /api/admin/events[/{id}]` 接收同名字段与 `problem_ids`（按顺序生成题位）。校验规则：

- 标题 ≤200 字、主办方 ≤100 字、说明 ≤5000 字、范围 ≤200 字、外部链接 ≤500 字且为 http(s)。
- `grade_scope` 为年级数组，空数组表示不限；服务端去空白、去重，单项 ≤20 字符、最多 20 项。
- `type` 取 `official|teacher|school`，`registration_mode` 取 `open|invite|external`，`status` 取 `draft|published|cancelled`。
- 结束时间必须晚于开始时间；报名截止不晚于开始且晚于报名开始。
- 规则最多 20 组、每组最多 50 条，末尾中文句号会被自动去除。
- 题目最多 50 道且不能重复。
- 已生成比赛的赛事不能修改开始/结束时间（允许 60 秒内的时间精度误差）和题目，可修改其他信息；把状态改为 `cancelled` 会同时取消进行中的比赛。

`POST /api/admin/events/{id}/forum` 要求赛事已发布。首次调用会创建校园墙帖子并置顶，返回 `{event_id,forum_post_id,pinned,message}`；已同步过的赛事返回原帖子且 `pinned=false`。置顶位已满时帖子创建成功但不置顶。赛事结束或取消后后台任务自动取消置顶。

## 实时推送（WebSocket）

完整设计见 `doc/2610295_实时推送设计方案.md`。WebSocket 只做传输增强，比赛详情、通知列表与未读数仍以 REST 接口为准。

### 连接票据

`POST /api/ws/ticket` 需要登录，返回：

```json
{"ticket": "48位随机串", "expires_in_seconds": 60}
```

票据一次性使用，60 秒内有效。浏览器不能为 WebSocket 设置 `Authorization` 头，因此用它连接 `GET /api/ws?ticket=...`。开发环境 Vite 的 `/api` 代理需要开启 `ws: true`。

### 消息格式

连接后客户端发送 `{"type":"hello"}`，服务端返回 `ready`。统一信封：

```json
{"id": 17, "type": "notification.new", "data": {}, "server_time": "2026-10-29T12:00:00Z"}
```

| 类型 | 方向 | 说明 |
|---|---|---|
| `hello` | 客户端 → 服务端 | 握手，收到 `ready` |
| `pong` | 客户端 → 服务端 | 响应服务端的 `ping` |
| `ready` | 服务端 → 客户端 | `{user_id, server_time}` |
| `ping` | 服务端 → 客户端 | 每 30 秒一次；90 秒无客户端消息断开 |
| `notification.new` | 服务端 → 客户端 | 新站内信，`data` 与通知列表项同构 |
| `match.found` | 服务端 → 客户端 | `{contest_id, starts_at, ends_at, participant_count}` |
| `resync` | 服务端 → 客户端 | 事件积压被丢弃，客户端应重新拉取快照 |

- 匹配成局后房间内所有选手都会收到 `match.found`，客户端随后调用 `GET /api/contests/{id}` 获取题目与时间。
- 通知在写入数据库后约 2 秒内推送；离线期间的通知不补推，重连后通过 `GET /api/notifications/unread-count` 与列表接口恢复。
- v1 不支持通过 WebSocket 加入/取消匹配，也不支持 `last_event_id` 重放。

## 语义补全（LSP）

完整设计见 `doc/2610316_语义补全设计方案.md`。v1 只支持 C++ 与 Python。

### 连接票据

`POST /api/lsp/ticket` 需要登录，请求体：

```json
{"language": "cpp"}
```

`language` 接受 `cpp`、`c++`、`python`、`python3`；其它语言返回 400。成功响应：

```json
{"ticket": "短期 JWT", "expires_in_seconds": 60, "language": "cpp", "path": "/lsp/ws"}
```

票据 60 秒内有效。浏览器用它连接 `GET /api/lsp/ws?ticket=...`：生产环境由前端 Nginx 反代到 `lsp:3001`，开发环境由 Vite 代理到 `127.0.0.1:3001`。网关校验票据后启动语言服务器（C++ 为 `clangd`，Python 为 `pyright-langserver`），并发超过 `LSP_MAX_SESSIONS` 时握手返回 503。

WebSocket 文本帧直接承载 LSP JSON-RPC 消息。连接建立后网关先发送：

```json
{"jsonrpc":"2.0","method":"theseus/ready","params":{"rootUri":"file:///tmp/theseus-lsp-1-xxxxxxxxxxxx","language":"cpp"}}
```

客户端以 `rootUri` 作为 `initialize` 的工作区，并在其下打开 `main.cpp` / `main.py`。支持补全、悬停与诊断；语言服务退出或 WebSocket 断开后会话结束，前端需重新开启语义补全。

## 题目草稿接口

- `GET /api/problems/{id}/draft?language=cpp` 需要登录，`language` 取 `cpp|java|python|javascript`；只对已审核题目开放，返回 `{draft: {language, code, updated_at} | null}`。
- `PUT /api/problems/{id}/draft` 需要登录，请求体 `{language, code}`；`code` 上限 256 KB，超过返回参数错误；`code` 为空或全空白时删除该题该语言的草稿，返回 `{draft: null}`。
- 草稿按「用户 + 题目 + 语言」唯一，重复保存为覆盖写入并刷新 `updated_at`；题目取消审核后读取和保存均返回不可见错误。

## 首页工作台接口

`GET /api/home/overview` 需要登录，返回：

```json
{
  "continue_learning": {
    "problem_id": 12,
    "problem_title": "两数之和",
    "difficulty": "easy",
    "language": "cpp",
    "status": "wrong_answer",
    "last_activity_at": "2026-10-29T06:30:00Z",
    "action": "resume"
  },
  "stats": {
    "streak_days": 4,
    "accepted_problems": 18,
    "review_problems": 5,
    "week_submissions": 23
  },
  "recent_activity": [
    {
      "submission_id": 88,
      "problem_id": 12,
      "problem_title": "两数之和",
      "language": "cpp",
      "status": "accepted",
      "submitted_at": "2026-10-29T06:35:00Z"
    }
  ],
  "checkin": {
    "checked_in_today": false,
    "reputation_score": 98.5
  }
}
```

`continue_learning` 优先取最近一次未通过的提交，没有时取最近一次提交；再与最近一份云端草稿（仅限已审核题目）比较 `last_activity_at`，取更新的一方。来自草稿时 `status` 为 `draft`、`action` 为 `resume`。

`POST /api/home/check-in` 每个 UTC 自然日只能成功一次，返回 `{checked_in,reputation_score,checkin_streak,message}`；首次签到信誉分 +0.1，上限 100，已经签到或已满时 `checked_in=false` 或分数不变。签到成功提示会显示连续签到天数，个人界面展示「连续签到 N 天」。信誉分只能通过每日签到和管理员定量恢复，退款、上诉等人工复核结果由管理员通过 `PUT /api/admin/users/{id}/reputation` 处理。

### 徽章

当前只发放签到里程碑徽章，连续签到达到门槛后自动获得并续期：

| 徽章 | 门槛 | 有效期 |
|---|---|---|
| 七日精进 | 连续签到 7 天 | 30 天 |
| 月度坚持 | 连续签到 30 天 | 30 天 |
| 百日不辍 | 连续签到 100 天 | 30 天 |

`GET /api/profile/badges` 返回徽章目录及获得状态 `{badges:[{code,name,description,category,threshold_days,earned,awarded_at,expires_at,hidden}]}`；未获得的徽章 `earned=false`，`awarded_at` 和 `expires_at` 为 `null`。每次签到会刷新已获得徽章的有效期，停止签到后徽章在有效期结束时失效。`PUT /api/profile/badges/{code}/visibility` 请求体 `{hidden}`，用于按徽章选择性隐藏；隐藏只影响论坛、排行榜等公开位置的展示，个人界面仍会标记「已隐藏」。徽章设计支持多个并存，后续可以扩展其他类别。

- `continue_learning.action`：`resume` 表示最近有未通过且尚未通过的题目，`review` 表示没有未完成题目时回看最近一题
- `review_problems`：尝试过但未通过的题目数
- `week_submissions`：近 7 天提交数，不是自然周
- `recent_activity` 最多 5 条，按提交时间倒序
- 没有历史记录时 `continue_learning = null`，`recent_activity = []`

`GET /api/problems/random` 从 `review_status = 'approved'` 的题目中随机返回一题，题库为空时返回 404。

## 防作弊复核与申诉接口

设计见 `doc/2610301_防作弊代码相似度设计方案.md`。扫描只覆盖带 `assignment_id` 的作业提交，按同作业、同题、同语言、最近 `ANTICHEAT_WINDOW_DAYS` 天比对，默认阈值 `0.60/0.80/0.92`。相似度不自动处分。

### 教师报告队列

`GET /api/teacher/cheat-reports?status=open&assignment_id=1&page=1&size=20`

- 只返回当前教师自己组织作业的报告；`size` 上限 50。
- `status` 可取 `open`、`confirmed`、`dismissed`、`appealed`、`upheld`、`overturned`，省略或 `all` 表示全部。
- 返回 `{total,page,size,pending_count,items[]}`；`pending_count` 为 `open` 数量。
- 列表项含 `target_username`、`matched_username`、`score`、`severity`、`status`、`penalty_applied`、`appeal_status`。

`GET /api/teacher/cheat-reports/{id}` 返回：

```json
{
  "report": {},
  "evidence": {
    "algorithm": "winnowing-token",
    "target_submission": {"id": 2, "user_id": 2, "username": "...", "language": "python", "status": "accepted", "submitted_at": "...", "code": "..."},
    "pairs": [{"submission_id": 1, "username": "...", "score": 0.96, "detail": {}, "code": "..."}]
  },
  "appeal": null,
  "actions": [{"action": "created", "actor_username": null, "note": "...", "created_at": "..."}]
}
```

非本人组织或报告不存在统一返回 404。

### 复核

`POST /api/teacher/cheat-reports/{id}/review`

```json
{"decision": "confirmed", "note": "复核说明", "apply_zero": true}
```

- `decision` 只能是 `confirmed` 或 `dismissed`，`note` 不超过 500 字。
- 只有 `open` 可以复核，重复提交返回 409。
- `confirmed` 时若 `apply_zero=true`，把该题 `assignment_problem_grades.manual_score` 置 0，并把判零前的人工分、评语、批改人保存到 `cheat_reports.penalty_before`；该题不在作业中时返回 409。
- `dismissed` 不改成绩。
- 返回 `{message,status,penalty_applied}`，并向学生写入站内信。

### 学生申诉

`GET /api/cheat-reports/mine` 只返回 `target_user_id` 为当前用户且状态为 `confirmed`、`appealed`、`upheld`、`overturned` 的报告。`GET /api/cheat-reports/{id}` 只返回本人提交，不含比对对方信息。

`POST /api/cheat-reports/{id}/appeal`

```json
{"reason": "申诉理由"}
```

- 只有报告当事人、且报告为 `confirmed` 时可用；每份报告只能申诉一次。
- 成功后报告变为 `appealed`，申诉为 `pending`，通知该报告的 `reviewer_id`（无则通知作业教师）。
- 重复申诉或状态不符返回 409，非当事人返回 404。

### 申诉裁定

`GET /api/teacher/appeals` 返回当前用户作为 `reviewer_id` 的待处理申诉，按提交时间正序。

`POST /api/teacher/appeals/{id}/resolve`

```json
{"decision": "overturned", "note": "处理说明"}
```

- `decision` 只能是 `upheld` 或 `overturned`；只有该报告的处理人可裁定，其他人返回 403。
- `upheld`：报告变为 `upheld`，维持作弊结论。
- `overturned`：报告变为 `overturned`；若此前判零，按 `penalty_before` 恢复成绩（无原人工分则删除判零记录），返回 `penalty_restored`。
- 成功后通知学生，并追加 `upheld`/`overturned` 与必要的 `penalty_restored` 审计记录。

### 错误与限制

| 场景 | 状态码 |
|---|---|
| 参数无效、理由为空或超长 | 400 |
| 非本人组织报告 / 非当事人报告 | 404 |
| 非处理人裁定申诉 | 403 |
| 重复复核、重复申诉、状态不符、题目已移出作业 | 409 |

报告与申诉不返回隐藏用例、其他学生成绩或对方身份给当事人；完整比对代码只对作业所属教师开放。
