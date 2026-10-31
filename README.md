# Theseus

面向校内的在线算法训练与教学平台：刷题判题、组织作业、4 人排位赛与限时赛事、面经板块、论坛与站内通知、商店与 Plus Theseus。

## 功能

- **刷题与判题**：多语言代码运行与提交，公开用例 + 隐藏用例，Docker/gVisor 沙箱隔离；题目页提供提交记录、代码回看与逐行对比。
- **教学闭环**：教师创建组织、组题布置作业；学生提交，教师批改并发布成绩。
- **竞赛**：4 人实时匹配、段位分与赛季软重置、限时赛事与年级范围、赛事排行榜、赛事申诉与成绩导出、断线重连。
- **面经板块**：并入论坛，`/forum?board=interview`。Plus 用户、管理员与作者可查看，非 Plus 显示开通提示；答案写在评论区，支持标签、公司/岗位筛选、搜索、阅读数、点赞、收藏与举报。
- **社区**：校园墙发帖、评论、举报，管理员审核与禁言。
- **通知**：站内信 + WebSocket 实时推送，按类别配置邮件偏好。
- **商店与 Plus Theseus**：学生和教师可提交 Plus 开通申请，管理员审核时填写开通天数；Plus 权益为面经板块权限与专属标识，到期自动失效。
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
├── backend-rust/     # Axum API、judge_worker、anticheat_worker 与数据库迁移
├── frontend-vue/     # Vue 3 单页应用
├── deploy/           # Docker Compose、.env 模板与备份/恢复/管理员脚本
├── doc/              # 总体设计、接口与实施文档
├── dev.sh            # 本地一键启动 API + Worker + 前端
└── update.sh         # 服务器拉取代码后的增量更新（备份 / 构建 / 迁移 / 核对）
```

## 本地运行

依赖：Rust stable、Node 22、PostgreSQL、Redis、Docker（判题用）。

首次运行可自动搭建开发环境（二选一，不会安装运行环境）：

```bash
./build_env.sh dev        # Rust / Node / PostgreSQL / Redis / Docker / 依赖 / 判题镜像
./dev.sh
```

也可以手动执行：

```bash
# 1. 初始化 PostgreSQL / Redis（Ubuntu/Debian）
sudo backend-rust/scripts/setup_local_services.sh --with-docker

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

判题 Worker 需要构建运行镜像，详见 [`backend-rust/README.md`](backend-rust/README.md)；`./build_env.sh dev` 会自动完成。用户上传文件（目前为头像）保存在 `backend-rust/uploads/`（开发环境，由 `UPLOAD_DIR` 决定），不会提交到 Git。

## 服务器部署

单机生产环境使用 Docker Compose（PostgreSQL、Redis、API、判题/防作弊 Worker、前端 Nginx）。先把运行依赖装好（只装运行环境，不装 Rust/Node/PostgreSQL/Redis）：

```bash
./build_env.sh runtime
```

然后：

```bash
cd deploy
cp .env.example .env    # 若脚本已生成则直接编辑
docker compose build
docker compose up -d
```

日常更新：

```bash
cd /opt/theseus
git pull
./update.sh
```

`update.sh` 会备份数据库与 uploads、构建镜像、先用新 backend 应用增量迁移，确认迁移成功后再启动 Worker 与前端，并在最后核对健康状态；失败时打印回滚命令。可用 `--skip-build` 复用现有镜像，或 `--no-backup` 跳过备份（不推荐）。

健康检查：`GET /healthz`（存活）与 `GET /readyz`（PostgreSQL / Redis）。备份使用 `deploy/scripts/backup.sh`，恢复使用 `deploy/scripts/restore.sh`。完整步骤、gVisor 安装、HTTPS 反代与运维清单见 [`doc/2610305_服务器部署方案.md`](doc/2610305_服务器部署方案.md)。

## 检查与测试

```bash
cd backend-rust && cargo fmt --check && cargo clippy --all-targets --all-features -- -D warnings && cargo test
cd frontend-vue && npm run build
```

真实链路的冒烟脚本位于 `backend-rust/scripts/`，覆盖教学、判题、论坛、题目审核、邮箱、竞赛与实时推送。

## 文档

总体设计与进度见 [`doc/总体设计.md`](doc/总体设计.md)，接口契约见 [`doc/backend_api.md`](doc/backend_api.md)，文档索引见 [`doc/AGENTS.md`](doc/AGENTS.md)。
