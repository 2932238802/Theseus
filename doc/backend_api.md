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

数据库迁移在服务启动时自动执行。题目提交会先返回 `pending`，随后由 `JudgeService` 进入 `judging` 并在评测器未配置时记录 `runtime_error`；该服务边界不会执行不受信任的用户代码。自定义题目通过 `POST /api/problems/custom` 提交，管理员通过待审核接口审批后才会公开。

## 接口清单

| 方法 | 路径 | 鉴权 | 说明 |
|---|---|---|---|
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
| GET | `/api/contests/featured` | 用户 | 竞赛首页：排位赛配置、规则分组与限时赛事列表 |
| GET | `/api/contests/events` | 用户 | 赛事列表，支持 `type`、`status`、`following`、`page`、`page_size` |
| GET | `/api/contests/events/{id}` | 用户 | 赛事详情（含说明、规则和报名链接） |
| POST | `/api/contests/events/{id}/follow` | 用户 | 关注赛事 |
| DELETE | `/api/contests/events/{id}/follow` | 用户 | 取消关注 |
| POST | `/api/contests/events/{id}/register` | 用户 | 公开赛事报名，返回更新后的赛事卡片 |
| POST | `/api/contests/events/{id}/join` | 用户 | 邀请赛事直接加入，返回更新后的赛事卡片 |
| POST | `/api/contests/events/{id}/enter` | 用户 | 进入赛事比赛，返回 `{event_id,contest_id}` |
| GET | `/api/contests/events/{id}/leaderboard` | 用户 | 赛事排行榜 |
| GET | `/api/contests/rankings` | 用户 | 排位榜，`limit` 默认 20 |
| POST | `/api/ws/ticket` | 用户 | 换取一次性 WebSocket 连接票据 |
| GET | `/api/ws?ticket=...` | 票据 | WebSocket 升级，见「实时推送」一节 |
| GET | `/api/admin/events` | 管理员 | 赛事管理列表 |
| POST | `/api/admin/events` | 管理员 | 创建赛事 |
| GET | `/api/admin/events/{id}` | 管理员 | 赛事管理详情 |
| PUT | `/api/admin/events/{id}` | 管理员 | 更新赛事 |
| POST | `/api/admin/events/{id}/forum` | 管理员 | 同步赛事到校园墙并置顶 |
| GET | `/api/admin/contests/{id}/proctor-events` | 管理员 | 疑似粘贴事件与复核状态 |
| POST | `/api/admin/contests/{id}/proctor-events/{event_id}/review` | 管理员 | 提交复核结论 `{status,note}`；确认后扣分并重新结算 |
| PUT | `/api/admin/users/{id}/reputation` | 管理员 | 定量恢复信誉分 `{score,note}`；恢复到 0 分以上自动解封 |
| PUT | `/api/assignments/{id}` | 教师 | 修改作业；发布后仅允许延长截止时间 |
| POST | `/api/assignments/{id}/solutions/publish` | 教师 | 发布答案解析，要求作业已截止 |
| GET | `/api/assignments/{id}/overrides` | 教师 | 查询学生补交/免修例外 |
| PUT | `/api/assignments/{id}/overrides/{user_id}/problems/{problem_id}` | 教师 | 设置补交/免修 |
| DELETE | `/api/assignments/{id}/overrides/{user_id}/problems/{problem_id}` | 教师 | 撤销补交/免修 |
| GET | `/api/assignments/{id}/statistics` | 学生/教师 | 匿名组织统计；学生需作业开启统计 |
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

完整设计见 `doc/2610272_个人界面的完善.md`。头像文件默认写入 `UPLOAD_DIR=./uploads`，通过 `/uploads` 静态访问；生产环境需设置持久化目录。

- `GET /api/auth/me` 增加 `avatar_url`、`pending_email`、`created_at`。
- `PUT /api/profile/username` 请求 `{"username":"..."}`，唯一性冲突返回 409。
- `POST /api/profile/email` 请求 `{"email":"..."}`；验证新邮箱前旧邮箱继续可用。
- `PUT /api/profile/password` 请求 `{"current_password":"...","new_password":"..."}`，返回新 token。
- `DELETE /api/profile` 请求 `{"password":"...","username":"..."}`；教师有未归档组织或最后一个管理员时返回 409。
- `POST /api/profile/avatar` 使用 `multipart/form-data`，字段 `file`，JPG/PNG/WebP ≤2MB。
- `GET /api/profile/analytics?days=30` 返回概览、趋势、难度和标签统计。
- `GET /api/forum/favorites?page=&size=` 返回当前用户收藏的帖子。
- `GET /api/profile/favorites/problems?page=&size=` 返回收藏的已审核题目 `{total,page,size,favorites:[{problem_id,title,difficulty,acceptance_rate,favorited_at}]}`
- `GET /api/profile/favorites/comments?page=&size=` 返回收藏的评论 `{total,page,size,favorites:[{comment_id,post_id,post_title,parent_id,body_md,author,created_at,favorited_at}]}` 作者字段沿用公开作者结构，匿名评论不会泄露真实用户名
- 收藏与取消收藏接口均返回 `{favorited}`，重复调用幂等；题目详情和列表的 `favorited` 字段、论坛评论和回复的 `favorited` 字段只对当前登录用户生效
- `GET /api/profile/notification-preferences` 返回 `{email,email_verified,preferences:[{category,channel,enabled}]}`，未保存过的类别返回代码里的默认值
- `PUT /api/profile/notification-preferences` 请求 `{"preferences":[{"category":"forum","enabled":true}]}`，可一次提交多项，返回与 GET 相同的完整偏好；`category` 取 `class|assignment|forum|account|contest|announcement`
- 偏好只控制邮件渠道，站内信始终接收；通知邮件只发送到已验证的邮箱，后台邮件循环每轮把待处理通知转入发件箱，用户关闭某类别后该类别不再产生新邮件

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
- `eligible = false` 时前端置灰操作，原因在 `ineligible_reason`；目前仅支持组织范围，因此原因可能是「仅限指定组织的学生参加」。
- 排名排序：进行中赛事优先且按结束时间，其余按开始时间升序。

报名与加入错误：

| 场景 | 状态码 |
|---|---:|
| 赛事不存在或未发布 | 404 |
| 外部链接赛事走站内报名、报名/加入接口与 `registration_mode` 不匹配 | 400 |
| 非指定组织成员 | 403 |
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

`GET /api/contests/rankings?limit=20` 返回 `{entries,my_rank,my_rating,total,server_time}`，`entries` 元素为 `{rank,user_id,username,rating,played,wins,is_me}`。统计只包含非赛事比赛的已结束场次，`limit` 取值 1-100。

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
