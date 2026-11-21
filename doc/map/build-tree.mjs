#!/usr/bin/env node
/*
 * 生成 Archify tree JSON（theseus-mindmap.tree.json）。
 * 这是面向阅读的高层导图：13 个能力域 + 关键能力节点；
 * 完整 352 节点大纲见 theseus-mindmap.md（由 build-md.mjs 从 mindmap-data.js 生成）。
 *
 * 用法：
 *   node doc/map/build-tree.mjs
 *   ARCHIFY_CHROME=<chrome> node /path/to/archify/bin/archify.mjs finalize tree \
 *     doc/map/theseus-mindmap.tree.json doc/map/theseus-mindmap.html --quality showcase --json
 */
import fs from "node:fs";
import path from "node:path";
import { fileURLToPath } from "node:url";

const dir = path.dirname(fileURLToPath(import.meta.url));

const BLUEPRINT = [
  {
    label: "定位与角色",
    children: [
      "校内单租户 OJ 平台",
      "刷题 / 判题 / 作业 / 匹配",
      "三角色互斥",
      "模块化单体与最小权限",
      "教学闭环可演示",
      "非目标：SaaS / 支付 / App"
    ]
  },
  {
    label: "总体架构",
    children: [
      "Vue 3 前端",
      "Nginx + REST / WSS",
      "Rust + Axum 单体",
      "judge / anticheat / lsp",
      "PostgreSQL + Redis",
      "Docker / gVisor 沙箱"
    ]
  },
  {
    label: "身份与账号",
    children: [
      "注册 / 登录 / JWT",
      "邮箱验证与找回",
      "单设备登录",
      "GitHub OAuth",
      "注销与匿名化",
      "设置中心与偏好"
    ]
  },
  {
    label: "题库 · 判题 · 练习",
    children: [
      "题库 1000 题",
      "标签 / 难度 / 搜索",
      "个人出题与审核",
      "隐藏用例与示例",
      "Redis Streams 判题",
      "一题多解 / 笔记",
      "工作台 / 错题本"
    ]
  },
  {
    label: "匹配 · 赛事 · 段位",
    children: [
      "4 人实时匹配",
      "3 / 5 分钟降级",
      "段位分与结算",
      "断线重连",
      "限时赛事与排行榜",
      "赛季软重置"
    ]
  },
  {
    label: "组织 · 作业 · 批改",
    children: [
      "组织 / 邀请 / CSV",
      "作业生命周期",
      "迟交 / 重交 / 计分",
      "批改台与手动分",
      "成绩发布 / 申诉"
    ]
  },
  {
    label: "防作弊",
    children: [
      "摄像头 / 屏幕授权",
      "切屏 / 粘贴事件",
      "相似度扫描与复核",
      "信誉分与处罚",
      "申诉与成绩恢复",
      "审计留痕"
    ]
  },
  {
    label: "论坛 · 面经",
    children: [
      "论坛 / 校园墙",
      "评论 / 点赞 / 收藏",
      "面经板块与 Plus",
      "公司 / 岗位筛选",
      "最佳答案 / 模板",
      "题解与讨论区"
    ]
  },
  {
    label: "通知 · 商店 · 管理端",
    children: [
      "站内信 / 通知中心",
      "邮件与 WebSocket",
      "Plus 申请 / 续费",
      "有效期与提醒",
      "管理端审核",
      "审计日志"
    ]
  },
  {
    label: "AI · LSP · 设置",
    children: [
      "AI 助手（Plus）",
      "OpenAI 兼容接口",
      "clangd / pyright",
      "设置跨设备同步"
    ]
  },
  {
    label: "数据与接口",
    children: [
      "users / oauth",
      "problems / cases",
      "classes / assignments",
      "contests / seasons",
      "forum_posts / templates",
      "audit / plus",
      "REST /api/*",
      "WebSocket 事件",
      "Streams / outbox"
    ]
  },
  {
    label: "安全 · 运维 · 交付",
    children: [
      "最小权限",
      "限流 / 登录锁定",
      "沙箱与 XSS 清洗",
      "Prometheus / Grafana",
      "Compose / update.sh",
      "CI / GHCR 镜像"
    ]
  },
  {
    label: "路线 · 文档",
    children: [
      "P0–P2 已完成",
      "P3 部分完成",
      "P4 部分完成",
      "P5 部分完成",
      "阻塞：CI / 部署",
      "文档与代码地图"
    ]
  }
];

const nodes = [{ id: "root", label: "Theseus 校内 OJ 算法服务平台" }];
let seq = 0;
for (const branch of BLUEPRINT) {
  const branchId = "n" + (++seq);
  nodes.push({ id: branchId, label: branch.label, parent: "root" });
  for (const child of branch.children) {
    nodes.push({ id: "n" + (++seq), label: child, parent: branchId });
  }
}

const tree = {
  schema_version: 1,
  diagram_type: "tree",
  meta: {
    title: "Theseus 项目全景思维导图",
    locale: "zh-CN",
    output: "doc/map/theseus-mindmap.html",
    quality_profile: "showcase"
  },
  layout: {
    direction: "down",
    gapX: 16,
    gapY: 24,
    nodeW: 120,
    nodeMaxW: 150
  },
  nodes
};

const outPath = path.join(dir, "theseus-mindmap.tree.json");
fs.writeFileSync(outPath, JSON.stringify(tree, null, 2) + "\n", "utf8");
console.log(
  "已生成 " + path.relative(process.cwd(), outPath) + "（" + nodes.length + " 个节点）"
);
