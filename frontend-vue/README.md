# Theseus Frontend

Theseus 在线编程训练平台的 Vue 3 前端，包含题库、提交评测、论坛 / 校园墙与站内通知。

## 角色模型

设计与 `doc/2610259_班级与作业设计方案.md` 一致：`student` / `teacher` / `admin` 三个**互斥**角色，不继承、不兼任。

| 角色 | 可见导航 | 说明 |
|---|---|---|
| `student` | 题库、论坛、我的班级、通知、个人中心 | 加入班级、提交作业、查看自己的成绩、参加 4 人匹配 |
| `teacher` | 题库、论坛、我的班级、通知、个人中心 | 管理自己的班级、作业和成绩；不加入班级、不提交作业、不显示管理端 |
| `admin` | 题库、论坛、管理、通知、个人中心 | 用户/角色、题目审核、论坛管理；不显示“我的班级”，不进入教学数据 |

- 题库练习、运行、论坛、通知对所有登录角色开放；只有班级作业要求 `student`。
- 前端角色判断使用精确的 `isStudent` / `isTeacher` / `isAdmin`，不存在“教师包含学生”或“管理员包含教师”的继承。
- 管理端用户页只允许 `admin` 进入；教师页面只允许 `teacher`；学生班级页只允许 `student`。
- 教师打开题目页时可以带 `assignment_id` 预览作业题目，但提交按钮只做“运行”，不能产生作业提交。
- 4 人匹配入口只对 `student` 显示；教师和管理员可以正常刷题。

**当前前端状态：** 已实现三角色导航、班级/作业/批改页面和管理员用户页；4 人匹配与题目审核界面尚未实现。`user` 会按 `student` 处理。

## 技术栈

Vue 3 + TypeScript + Vite + Pinia + Vue Router + Axios + Monaco Editor + marked + DOMPurify。

## 运行

1. 启动 PostgreSQL、Redis（Redis 只影响判题，论坛不需要）和后端：默认 `http://127.0.0.1:3000`。后端启动时会自动执行 `backend-rust/migrations`，首次升级会创建论坛相关表（`0004_forum.sql`）。
2. 安装依赖并启动开发服务器：

```bash
npm install
npm run dev
```

开发环境通过 Vite proxy 把 `/api` 转发到 `http://127.0.0.1:3000`。如需直连其他地址，复制 `.env.example` 为 `.env` 并设置 `VITE_API_BASE_URL`。

## 构建

```bash
npm run build
```

构建包含 `vue-tsc` 类型检查。论坛 Markdown 渲染使用 `marked` 解析，再由 `DOMPurify` 按白名单清洗；原始 HTML、图片、iframe、事件属性和 `javascript:` 链接不会进入页面。

## 界面文案规范

界面文案保持简单：只保留用户不知道、且会影响操作的信息。

- 页面标题下只放标题，不再写解释页面用途的副标题。筛选器、列表、按钮本身已经说明功能，例如“按难度、标签和状态筛选题目。”这类话直接删除。
- 不写占位式描述，例如“排行榜接口接入后将在此展示排名。”；未完成功能用空状态说明当前状态即可。
- 不重复按钮、标签、表单项已经表达的意思，也不在标题下堆完整说明句。
- 保留必要的校验规则、匿名/隐私说明、不可逆操作警告、错误信息和空状态引导；这些内容放在对应控件附近，而不是页面标题下。
- 需要用户做选择时，用短标签或按钮，不用一句话解释。

## 当前能力

- 注册、登录（支持用户名或邮箱）、退出与会话保持。
- 题库服务端分页、难度/标签/状态筛选、搜索与排序。
- 题目详情、代码模板、代码草稿本地保存。
- 提交代码并轮询评测结果，个人中心展示真实提交记录。
- 首页统计与标签来自后端接口。
- 校园墙：列表、标签筛选、搜索、最新/热门排序、分页。
- 帖子：Markdown 发帖/编辑、题目引用、匿名发布、软删除、点赞、收藏、举报。
- 评论：两级评论、回复归一化、匿名评论、编辑/软删除、加载更多。
- 通知：导航栏未读数、评论/回复/@提及/审核/禁言通知页、全部已读。
- 论坛管理端：举报队列、内容管理、真实作者查看、隐藏/恢复/删除、置顶、禁言/解除。
- 班级：教师创建/归档班级、邀请码轮换、按用户名或邮箱添加成员、移除成员；学生邀请码加入与退出。
- 作业：教师创建草稿、选题与排序、发布、延长截止、归档、删除草稿；学生查看作业与完成进度。
- 批改：学生 × 题目矩阵、提交代码查看、单题手动分与评语、整体评语、发布成绩、包含已移除成员。
- 管理员用户页：用户名/邮箱搜索、角色筛选、角色修改、学生退班与教师归档降级提示。

## 论坛 / 校园墙

### 页面路由

| 路由 | 说明 |
|---|---|
| `/forum` | 校园墙列表，支持标签、搜索、排序、分页和“只看我的” |
| `/forum/new` | 发帖；`/forum/new?edit=<id>` 编辑自己的帖子 |
| `/forum/:id` | 帖子详情、评论、回复、点赞/收藏、举报 |
| `/notifications` | 站内通知（需要登录） |
| `/classes` | 班级列表：教师查看自己创建的班级，学生查看已加入的班级 |
| `/classes/:id` | 班级详情：教师管理邀请码与成员，学生查看作业与退出班级 |
| `/classes/:id/assignments/new` | 创建作业草稿（需要 `teacher`） |
| `/assignments/:id` | 作业详情与题目列表 |
| `/assignments/:id/edit` | 编辑作业（需要 `teacher`） |
| `/assignments/:id/grade` | 批改台（需要 `teacher`） |
| `/admin/users` | 用户与角色管理（需要 `admin`） |
| `/admin/forum` | 论坛管理端（需要 `admin` 角色） |

未登录用户可以浏览列表、详情、评论和题目卡片，但发帖、评论、点赞、收藏、举报和通知需要登录。

### 匿名规则

- 发帖和评论都可以选择匿名。
- 公开列表、详情、评论和通知只返回“匿名同学”，不返回 `author_id`、用户名或邮箱。
- 管理端会显示匿名内容的真实作者，用于审核和禁言。
- 匿名内容被隐藏或删除后，回复中的目标用户显示为“已隐藏”。

### 本地开发管理员

当前本地开发数据库已创建管理员账号（仅用于开发/测试环境）：

| 用户名 | 密码 | 邮箱 |
|---|---|---|
| `admin` | `admin` | `admin@theseus.local` |

使用 `/login` 登录后，导航栏会出现「管理」，也可以直接打开 `/admin/forum`。

注册接口默认创建 `student`。全新数据库可以先注册一个账号，再由数据库提升为管理员（仅限本地/测试环境）：

```sql
UPDATE users SET role = 'admin' WHERE username = '你的用户名';
```

认证每次从数据库读取角色，修改后刷新页面即可生效，不需要重新登录。日常角色调整请使用 `/admin/users`，由接口执行“学生退出班级、教师归档自有班级、最后一个管理员保护”等校验。

部署到公网前请修改开发账号的密码。

### 论坛管理端操作（当前）

打开 `/admin/forum`：

1. **举报队列**：按待处理/已隐藏/已驳回/全部筛选。可“隐藏内容”（会写入审计并通知作者）或“驳回举报”；达到阈值的自动隐藏内容可由管理员恢复。
2. **内容管理**：按状态、关键词、作者筛选帖子和评论。可查看详情、隐藏、恢复、删除、置顶/取消置顶。
3. **禁言**：在内容卡片或详情中选择“禁言作者”，填写时长（24 小时、3 天、7 天、30 天或永久）和原因；也可解除禁言。禁言只阻止发帖和评论，不影响浏览与举报。
4. 所有管理员操作都会写入 `forum_moderation_actions` 审计表。

用户/角色管理已提供 `/admin/users`；题目审核界面仍未实现。管理员不会获得“我的班级”入口。

### 论坛环境变量

在 `backend-rust/.env` 中配置（完整示例见 `backend-rust/.env.example`）：

| 变量 | 默认值 | 说明 |
|---|---:|---|
| `FORUM_ENABLED` | `true` | 关闭后所有公共论坛接口返回 503；`/api/admin/forum/*` 仍可用，便于管理员在关闭期间清理内容 |
| `FORUM_POST_COOLDOWN_SECS` | `60` | 两次发帖的最小间隔 |
| `FORUM_POST_DAILY_LIMIT` | `20` | 每日发帖上限 |
| `FORUM_COMMENT_COOLDOWN_SECS` | `10` | 两次评论的最小间隔 |
| `FORUM_COMMENT_DAILY_LIMIT` | `200` | 每日评论上限 |
| `FORUM_REPORT_DAILY_LIMIT` | `20` | 每日举报上限 |
| `FORUM_REPORT_HIDE_THRESHOLD` | `3` | 不同举报人达到该数量后自动隐藏（2–10） |
| `FORUM_MAX_PINNED` | `5` | 最大置顶帖子数 |

### 论坛接口

公开/登录用户接口：

```text
GET    /api/forum/posts
POST   /api/forum/posts
GET    /api/forum/posts/{id}
PUT    /api/forum/posts/{id}
DELETE /api/forum/posts/{id}
POST   /api/forum/posts/{id}/like
DELETE /api/forum/posts/{id}/like
POST   /api/forum/posts/{id}/favorite
DELETE /api/forum/posts/{id}/favorite
GET    /api/forum/posts/{id}/comments
POST   /api/forum/posts/{id}/comments
GET    /api/forum/comments/{id}/replies
PUT    /api/forum/comments/{id}
DELETE /api/forum/comments/{id}
POST   /api/forum/reports
GET    /api/notifications
GET    /api/notifications/unread-count
PUT    /api/notifications/{id}/read
PUT    /api/notifications/read-all
```

管理员接口：

```text
GET  /api/admin/forum/posts
GET  /api/admin/forum/posts/{id}
PUT  /api/admin/forum/posts/{id}/status
PUT  /api/admin/forum/comments/{id}/status
PUT  /api/admin/forum/posts/{id}/pin
GET  /api/admin/forum/reports
PUT  /api/admin/forum/reports/{id}
POST /api/admin/forum/users/{id}/mute
DELETE /api/admin/forum/users/{id}/mute
GET  /api/admin/forum/actions
```

所有接口返回统一 envelope：`{ "success": true, "data": ..., "error": null }`。

## 论坛冒烟测试

`backend-rust/scripts/smoke_forum.sh` 会连接真实 API 和 PostgreSQL，用随机一次性账号覆盖：

```text
发帖 → 匿名隐私 → 评论/回复通知 → 回复归一化 → 点赞/收藏幂等
→ 举报 → 阈值自动隐藏 → 管理员审核/恢复 → 禁言 → 编辑 → 删除 → 清理
```

前置条件：

- 后端已启动，`backend-rust/.env` 存在且 `DATABASE_URL` 可用；
- 至少有一道已审核题目（默认 `1001`，可用 `SMOKE_PROBLEM_ID` 覆盖）；
- 已安装 `bash >= 4.2`、`curl`、`jq`、`psql`；
- 只对本地/测试数据库运行；脚本不会修改真实管理员密码。

```bash
cd /path/to/Theseus
./backend-rust/scripts/smoke_forum.sh
```

可选参数：

```bash
SMOKE_KEEP_DATA=1 ./backend-rust/scripts/smoke_forum.sh   # 保留测试数据并打印清理 SQL
SMOKE_VERBOSE=1 ./backend-rust/scripts/smoke_forum.sh     # 输出调试信息
SMOKE_API_BASE=http://127.0.0.1:3000 ./backend-rust/scripts/smoke_forum.sh
SMOKE_REPORT_DIR=/tmp/theseus-smoke ./backend-rust/scripts/smoke_forum.sh
```

默认结束后清理测试账号及其帖子、评论、举报、通知、禁言记录。报告写到仓库根目录 `.dev-logs/smoke-forum-<UTC>.log` 和 `.json`，不包含 token、密码、数据库连接串或帖子正文。退出码：`0` 全部通过或仅跳过，`1` 断言失败，`2` 前置条件不满足，`3` 服务不可达。

## 计数器修复

论坛的点赞、收藏、评论数、待处理举报数是事务内维护的冗余计数。若手工改库或怀疑计数漂移，可在 API 在线时执行：

```bash
psql "$DATABASE_URL" -f backend-rust/scripts/rebuild_forum_counters.sql
```

脚本在单个事务中根据源表重建计数，只写论坛计数列。

## 已知限制

- 排行榜、4 人匹配页面尚未开放。
- 论坛首期只支持 Markdown 子集，不支持图片、附件、富文本和无限嵌套评论。
- 管理员题目审核仅提供后端接口，前端界面不在当前范围。
- 通知只做站内轮询，不发送邮件/短信，也没有 WebSocket 推送。
