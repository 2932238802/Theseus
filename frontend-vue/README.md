# Theseus Frontend

Theseus 在线编程训练平台的 Vue 3 前端，包含题库、提交评测、排行榜、论坛 / 校园墙与站内通知。

## 角色模型

设计与 `doc/2610259_班级与作业设计方案.md` 一致：`student` / `teacher` / `admin` 三个**互斥**角色，不继承、不兼任。

| 角色 | 可见导航 | 说明 |
|---|---|---|
| `student` | 题库、校园墙、排行榜、我的组织、通知、个人中心 | 加入组织、提交作业、查看自己的成绩、参加 4 人匹配 |
| `teacher` | 题库、校园墙、排行榜、我的组织、通知、个人中心 | 管理自己的组织、作业和成绩；不加入组织、不提交作业、不显示管理端 |
| `admin` | 题库、校园墙、排行榜、管理、通知、个人中心 | 用户/角色、题目审核、论坛管理；不显示“我的组织”，不进入教学数据 |

- 题库练习、运行、论坛、通知对所有登录角色开放；只有组织作业要求 `student`。
- 前端角色判断使用精确的 `isStudent` / `isTeacher` / `isAdmin`，不存在“教师包含学生”或“管理员包含教师”的继承。
- 管理端用户页只允许 `admin` 进入；教师页面只允许 `teacher`；学生组织页只允许 `student`。
- 教师打开题目页时可以带 `assignment_id` 预览作业题目，但提交按钮只做“运行”，不能产生作业提交。
- 4 人匹配入口只对 `student` 显示；教师和管理员可以正常刷题。

**当前前端状态：** 已实现三角色导航、组织/作业/批改页面、排行榜页面、教师出题与管理员题目审核、管理员用户页；4 人匹配界面尚未实现。`user` 会按 `student` 处理。

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
- 不写占位式描述，例如“数据加载后将在此展示排名。”；未完成功能用空状态说明当前状态即可。
- 不重复按钮、标签、表单项已经表达的意思，也不在标题下堆完整说明句。
- 保留必要的校验规则、匿名/隐私说明、不可逆操作警告、错误信息和空状态引导；这些内容放在对应控件附近，而不是页面标题下。
- 需要用户做选择时，用短标签或按钮，不用一句话解释。

## 当前能力

- 注册、登录（支持用户名或邮箱）、退出与会话保持。
- 邮箱验证：注册后发送验证链接、未验证提示条、重新发送、验证结果页。
- 密码找回：忘记密码邮件、一次性重置链接、重置后旧会话失效。
- 题库服务端分页、难度/标签/状态筛选、搜索与排序。
- 题目详情、代码模板、代码草稿本地保存。
- 提交代码并轮询评测结果，个人中心展示真实提交记录。
- 首页统计与标签来自后端接口。
- 校园墙：列表、标签筛选、搜索、最新/热门排序、分页。
- 帖子：Markdown 发帖/编辑、题目引用、匿名发布、软删除、点赞、收藏、举报。
- 评论：两级评论、回复归一化、匿名评论、编辑/软删除、加载更多。
- 通知：导航栏未读数、评论/回复/@提及/审核/禁言通知页、全部已读。
- 论坛管理端：举报队列、内容管理、真实作者查看、隐藏/恢复/删除、置顶、禁言/解除。
- 组织：教师创建/归档组织、邀请码轮换、按用户名或邮箱添加成员、移除成员；学生邀请码加入与退出。
- 作业：教师创建草稿、选题与排序、发布、延长截止、归档、删除草稿；学生查看作业与完成进度。
- 批改：学生 × 题目矩阵、提交代码查看、单题手动分与评语、整体评语、发布成绩、包含已移除成员。
- 管理员用户页：用户名/邮箱搜索、角色筛选、角色修改、学生退出组织与教师归档降级提示。
- 教师出题：创建或编辑被退回的题目，表单填写基本信息，JSON 配置判题参数与隐藏用例。
- 管理员题目审核：待审核队列、题目检索、查看/修改判题配置、通过或退回并填写评语；结果通知出题教师。
- 排行榜：全局学生刷题榜，按通过题数排名，显示提交数与通过率，支持分页和当前用户排名。
- OJ 快捷键：运行、提交、结果面板、精选编辑器动作，支持自定义和快捷键手册。

## 排行榜

`/rankings` 展示全局学生刷题榜。

- 只统计 `student`，且至少通过 1 道已审核题目。
- 通过题数按 `user_problem_status` 的去重题目计算，组织作业提交同样计入。
- 提交数和通过率只统计终态提交，排除 `pending`、`judging` 和 `internal_error`。
- 排序：通过题数 → 通过率 → 最后通过时间早者优先 → `user_id`。
- 游客可查看；登录学生可以看到“我的排名”和当前行高亮；教师和管理员不上榜。

接口：

```text
GET /api/rankings?page=1&size=20
```

返回 `total`、`page`、`size`、`entries` 和 `me`。`entries` 每项包含 `rank`、`user_id`、`username`、`solved`、`submissions`、`acceptance_rate`；`me` 只对已上榜的登录学生返回，否则为 `null`。

## 快捷键

OJ 题目页编辑器工具栏的「⌨」按钮打开快捷键弹窗，包含「设置」和「手册」两个标签。修改后立即生效，手册同步更新。

| 动作 | 默认键 |
|---|---|
| 运行代码 | `Ctrl/Cmd+Enter` |
| 提交代码 | `Ctrl/Cmd+Shift+Enter` |
| 展开/收起结果 | ``Ctrl/Cmd + ` `` |
| 查找 | `Ctrl/Cmd+F` |
| 替换 | `Ctrl/Cmd+H` |
| 切换行注释 | `Ctrl/Cmd+/` |
| 格式化文档 | `Shift+Alt+F` |
| 删除行 | `Ctrl/Cmd+Shift+K` |
| 选中下一个相同项 | `Ctrl/Cmd+D` |

- 运行快捷键在有公开用例时直接运行示例，否则打开自定义输入弹窗。
- 可修改应用动作和上表中的编辑器动作；撤销、重做、复制粘贴、全选、Tab 缩进等系统键只读。
- 冲突、浏览器保留键和只读系统键在保存前会被拒绝。
- 配置保存在当前浏览器的 `localStorage`，键名 `theseus-shortcuts-v1`，不随账号同步。
- 编辑器快捷键仅在编辑器聚焦时生效；页面级动作在输入框、弹窗和快捷键捕获期间不会触发。

## 论坛 / 校园墙

### 页面路由

| 路由 | 说明 |
|---|---|
| `/forum` | 校园墙列表，支持标签、搜索、排序、分页和“只看我的” |
| `/forum/new` | 发帖；`/forum/new?edit=<id>` 编辑自己的帖子 |
| `/forum/:id` | 帖子详情、评论、回复、点赞/收藏、举报 |
| `/notifications` | 站内通知（需要登录） |
| `/rankings` | 全局学生排行榜（游客可查看） |
| `/verify-email` | 邮箱验证结果与重新发送；`?token=` 自动验证，`?sent=1` 显示已发送 |
| `/forgot-password` | 输入邮箱请求重置链接 |
| `/reset-password` | 使用 `?token=` 设置新密码 |
| `/classes` | 组织列表：教师查看自己创建的组织，学生查看已加入的组织 |
| `/classes/:id` | 组织详情：教师管理邀请码与成员，学生查看作业与退出组织 |
| `/classes/:id/assignments/new` | 创建作业草稿（需要 `teacher`） |
| `/teacher/problems` | 教师自己的题目列表，按审核状态筛选（需要 `teacher`） |
| `/teacher/problems/new` | 创建题目并提交审核（需要 `teacher`） |
| `/teacher/problems/:id/edit` | 编辑被退回的题目并重新提交（需要 `teacher`） |
| `/admin/problems` | 题目审核队列与审核详情（需要 `admin`） |
| `/assignments/:id` | 作业详情与题目列表 |
| `/assignments/:id/edit` | 编辑作业（需要 `teacher`） |
| `/assignments/:id/grade` | 批改台（需要 `teacher`） |
| `/admin/users` | 用户与角色管理（需要 `admin`） |
| `/admin/forum` | 论坛管理端（需要 `admin` 角色） |

未登录用户可以浏览列表、详情、评论和题目卡片，但发帖、评论、点赞、收藏、举报和通知需要登录。

未验证邮箱账号可以登录和刷题；页面顶部会显示验证提示。加入组织、提交组织作业、发帖和评论会返回 403，需先完成邮箱验证。

### 匿名规则

- 发帖和评论都可以选择匿名。
- 公开列表、详情、评论和通知只返回“匿名同学”，不返回 `author_id`、用户名或邮箱。
- 管理端会显示匿名内容的真实作者，用于审核和禁言。
- 匿名内容被隐藏或删除后，回复中的目标用户显示为“已隐藏”。

### 本地开发管理员

本地开发数据库可通过后端种子脚本创建管理员账号（仅用于开发/测试环境）：

```bash
psql "$DATABASE_URL" -f backend-rust/scripts/seed_admin.sql
```

| 用户名 | 密码 | 邮箱 |
|---|---|---|
| `admin` | `admin` | `admin@theseus.local` |

脚本幂等，已存在的 `admin` 账号不会被覆盖；账号邮箱已标记为验证通过。使用 `/login` 登录后，导航栏会出现「管理」，也可以直接打开 `/admin/forum`。

注册接口默认创建 `student`。全新数据库可以先注册一个账号，再由数据库提升为管理员（仅限本地/测试环境）：

```sql
UPDATE users SET role = 'admin' WHERE username = '你的用户名';
```

认证每次从数据库读取角色，修改后刷新页面即可生效，不需要重新登录。日常角色调整请使用 `/admin/users`，由接口执行“学生退出组织、教师归档自有组织、最后一个管理员保护”等校验。

部署到公网前请修改开发账号的密码。

### 论坛管理端操作（当前）

打开 `/admin/forum`：

1. **举报队列**：按待处理/已隐藏/已驳回/全部筛选。可“隐藏内容”（会写入审计并通知作者）或“驳回举报”；达到阈值的自动隐藏内容可由管理员恢复。
2. **内容管理**：按状态、关键词、作者筛选帖子和评论。可查看详情、隐藏、恢复、删除、置顶/取消置顶。
3. **禁言**：在内容卡片或详情中选择“禁言作者”，填写时长（24 小时、3 天、7 天、30 天或永久）和原因；也可解除禁言。禁言只阻止发帖和评论，不影响浏览与举报。
4. 所有管理员操作都会写入 `forum_moderation_actions` 审计表。

用户/角色管理已提供 `/admin/users`，题目审核已提供 `/admin/problems`。管理员不会获得“我的组织”入口。

### 教师出题与题目审核

1. 教师在 `/teacher/problems/new` 填写标题、描述、难度、限制、标签、示例，并用 JSON 配置 `run_config`、`judge_cases` 和 `test_cases`。提交后状态为 `pending`。
2. 管理员在 `/admin/problems` 查看待审核题目，可直接修改判题配置后保存，再填写评语并选择“通过”或“退回”。退回必须填写原因。
3. 通过前后端会校验 `run_config` 有效，且至少包含 1 条公开或隐藏用例；通过后题目进入公开题库。
4. 被退回的题目在 `/teacher/problems` 显示审核意见，教师可进入编辑页修改并重新提交，状态回到 `pending`。
5. 每次审核结果都会向出题教师发送 `problem_review` 站内通知。

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

- 4 人匹配页面尚未开放。
- 快捷键配置仅保存在当前浏览器，不随账号同步；不支持多键序列。
- 论坛首期只支持 Markdown 子集，不支持图片、附件、富文本和无限嵌套评论。
- 已审核通过的题目不能由教师直接编辑；需要修改时请管理员退回后重新提交。
- 通知只做站内轮询，不发送邮件/短信，也没有 WebSocket 推送；邮件仅用于邮箱验证和密码找回。
