# Theseus

面向校内的在线算法训练与教学平台：刷题判题、组织作业、4 人排位赛、论坛与站内通知。

## 功能

- **刷题与判题**：多语言代码运行与提交，公开用例 + 隐藏用例，Docker/gVisor 沙箱隔离。
- **教学闭环**：教师创建组织、组题布置作业；学生提交，教师批改并发布成绩。
- **竞赛**：4 人实时匹配、段位分、限时赛事、赛事排行榜与断线重连。
- **社区**：校园墙发帖、评论、举报，管理员审核与禁言。
- **通知**：站内信 + WebSocket 实时推送，按类别配置邮件偏好。
- **三角色互斥权限**：`student` / `teacher` / `admin`，各司其职，不继承、不兼任。

## 技术栈

| 层 | 选型 |
|---|---|
| 前端 | Vue 3 · TypeScript · Vite · Pinia · Monaco Editor |
| 后端 | Rust · Axum · SQLx |
| 存储 | PostgreSQL（事实来源） · Redis Streams（队列 / 缓存） |
| 沙箱 | Docker / gVisor，支持 Python、Node.js、C++、Java |

## 目录结构

```text
Theseus/
├── backend-rust/     # Axum API 与 judge_worker
├── frontend-vue/     # Vue 3 单页应用
├── doc/              # 总体设计、接口与实施文档
└── dev.sh            # 本地一键启动 API + Worker + 前端
```

## 本地运行

依赖：Rust stable、PostgreSQL 18、Redis、Docker（判题用）。

```bash
# 1. 初始化 PostgreSQL / Redis（Ubuntu/Debian）
sudo backend-rust/scripts/setup_local_services.sh

# 2. 配置后端环境变量
cp backend-rust/.env.example backend-rust/.env

# 3. 安装前端依赖
cd frontend-vue && npm install && cd ..

# 4. 一键启动
./dev.sh
```

- 前端：<http://127.0.0.1:5173>
- API：<http://127.0.0.1:3000>
- 日志：`.dev-logs/`

数据库迁移在 API 启动时自动执行。需要种子数据时：

```bash
psql "$DATABASE_URL" -f backend-rust/scripts/seed_problems_15.sql
psql "$DATABASE_URL" -f backend-rust/scripts/seed_admin.sql   # 仅本地开发
```

判题 Worker 需要构建运行镜像，详见 [`backend-rust/README.md`](backend-rust/README.md)。

## 检查与测试

```bash
cd backend-rust && cargo fmt --check && cargo clippy --all-targets --all-features -- -D warnings && cargo test
cd frontend-vue && npm run build
```

真实链路的冒烟脚本位于 `backend-rust/scripts/`，覆盖教学、判题、论坛、题目审核、邮箱、竞赛与实时推送。

## 文档

总体设计与进度见 [`doc/总体设计.md`](doc/总体设计.md)，接口契约见 [`doc/backend_api.md`](doc/backend_api.md)，文档索引见 [`doc/AGENTS.md`](doc/AGENTS.md)。
