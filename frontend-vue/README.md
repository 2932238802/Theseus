# Theseus Frontend

Theseus 在线编程训练平台的 Vue 3 前端。

## 技术栈

Vue 3 + TypeScript + Vite + Pinia + Vue Router + Axios + Monaco Editor。

## 运行

1. 先启动后端（默认 `http://127.0.0.1:3000`）。
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

## 当前能力

- 注册、登录（支持用户名或邮箱）、退出与会话保持。
- 题库服务端分页、难度/标签/状态筛选、搜索与排序。
- 题目详情、代码模板、代码草稿本地保存。
- 提交代码并轮询评测结果，个人中心展示真实提交记录。
- 首页统计与标签来自后端接口。

## 已知限制

- 后端评测器尚未接入，提交会返回真实的 `runtime_error`，不会伪造通过结果。
- 排行榜、运行代码、管理端界面暂未开放。
- 管理员题目管理仅提供后端接口，前端界面不在当前范围。
