/*
 * Theseus 项目全景思维导图数据
 * 维护方式：改本文件的 branches，再执行
 *   node doc/map/build-md.mjs
 * 生成 theseus-mindmap.md；HTML 直接读取本文件，无需构建。
 * 基线：2026-11-21 · main @ fda4570 / 7448de9
 */
globalThis.THESEUS_MINDMAP = {
  title: "Theseus 校内 OJ 算法服务平台",
  subtitle: "项目全景思维导图 · 基线 2026-11-21 · fda4570 / 7448de9",
  hint: "点击节点展开或收起 · 滚轮缩放 · 拖拽平移",
  branches: [
    {
      label: "定位与目标",
      color: "#2563eb",
      children: [
        { label: "校内单租户在线算法服务平台" },
        { label: "刷题 · 判题 · 作业 · 匹配 · 论坛 · 防作弊" },
        { label: "三角色互斥：学生 / 教师 / 管理员" },
        {
          label: "设计原则",
          children: [
            { label: "简单但完整：模块化单体" },
            { label: "PostgreSQL 是唯一事实来源" },
            { label: "判题 / 邮件 / 扫描异步化" },
            { label: "最小权限与资源归属" },
            { label: "防作弊重证据，人工复核" }
          ]
        },
        {
          label: "成功标准",
          children: [
            { label: "判题 P95 ≤ 15 秒出终态" },
            { label: "隐藏用例零泄露" },
            { label: "教学闭环可完整演示" },
            { label: "单机可重启恢复" }
          ]
        },
        {
          label: "非目标",
          children: [
            { label: "多学校 SaaS" },
            { label: "支付 / 证书" },
            { label: "原生 App" },
            { label: "微服务拆分" }
          ]
        }
      ]
    },
    {
      label: "用户与角色",
      color: "#7c3aed",
      children: [
        {
          label: "学生",
          children: [
            { label: "题库浏览 / 运行 / 提交" },
            { label: "加入组织，完成作业" },
            { label: "4 人匹配与限时赛事" },
            { label: "论坛 / 面经 / 笔记 / 错题本" }
          ]
        },
        {
          label: "教师",
          children: [
            { label: "管理自有组织与学生" },
            { label: "组题 / 布置作业 / 批改" },
            { label: "个人出题交管理员审核" },
            { label: "可用题库 / 论坛 / 通知" }
          ]
        },
        {
          label: "管理员",
          children: [
            { label: "题目审核与用户角色管理" },
            { label: "论坛 / 通知 / 赛事 / Plus" },
            { label: "审计日志与平台监控" },
            { label: "不进入教学数据" }
          ]
        },
        {
          label: "角色互斥",
          children: [
            { label: "每账号仅一个角色" },
            { label: "不叠加、不继承" },
            { label: "认证每次读取数据库" }
          ]
        }
      ]
    },
    {
      label: "总体架构",
      color: "#db2777",
      children: [
        {
          label: "前端",
          children: [
            { label: "Vue 3 + TypeScript + Vite" },
            { label: "Pinia · Vue Router · Monaco" },
            { label: "页面路由懒加载" }
          ]
        },
        {
          label: "接入层",
          children: [
            { label: "Nginx 静态资源与 /api 反代" },
            { label: "安全响应头与 CORS 白名单" }
          ]
        },
        {
          label: "API 进程",
          children: [
            { label: "Rust + Axum 0.8 模块化单体" },
            { label: "REST + WebSocket Hub" },
            { label: "鉴权 / 业务编排 / 审计" },
            {
              label: "进程内后台任务",
              children: [
                { label: "邮件 outbox 投递" },
                { label: "匹配与赛事结算" },
                { label: "Plus 到期提醒" },
                { label: "实时消息扇出" },
                { label: "判题超时回收" }
              ]
            }
          ]
        },
        {
          label: "异步 Worker",
          children: [
            { label: "judge_worker：判题与运行" },
            { label: "anticheat_worker：相似度扫描" },
            { label: "lsp_gateway：语义补全网关" }
          ]
        },
        {
          label: "数据与中间件",
          children: [
            { label: "PostgreSQL：唯一事实来源" },
            { label: "Redis：Streams / 缓存 / 限流 / 匹配池 / PubSub" },
            { label: "SMTP + outbox：验证与通知邮件" }
          ]
        },
        {
          label: "沙箱",
          children: [
            { label: "Docker / gVisor" },
            { label: "非 root · 只读根 · 无网络" },
            { label: "CPU / 内存 / PID / 时间 / 输出限制" }
          ]
        }
      ]
    },
    {
      label: "身份与账号",
      color: "#ea580c",
      children: [
        { label: "注册 / 登录 / JWT" },
        { label: "三角色互斥认证" },
        { label: "邮箱验证与密码找回" },
        { label: "一次性令牌 + outbox 投递" },
        {
          label: "单设备登录",
          children: [
            { label: "登录递增 token_version" },
            { label: "旧 JWT 立即失效" },
            { label: "前端提示修改密码" }
          ]
        },
        {
          label: "GitHub OAuth",
          children: [
            { label: "只绑定已有账号" },
            { label: "不自动建号" },
            { label: "未配置凭据时入口隐藏" }
          ]
        },
        { label: "注销与匿名化" },
        { label: "设置中心与偏好同步" }
      ]
    },
    {
      label: "题库 · 判题 · 练习",
      color: "#16a34a",
      children: [
        {
          label: "题库",
          children: [
            { label: "1000 题" },
            { label: "新增 800 题：300 简单 / 340 中等 / 160 困难" },
            { label: "标签 / 难度 / 搜索 / 统计" },
            { label: "隐藏用例与公开示例" }
          ]
        },
        {
          label: "个人出题与审核",
          children: [
            { label: "学生 / 教师提交，落库 pending" },
            { label: "管理员审核后进入题库" },
            {
              label: "审核状态机",
              children: [
                { label: "draft → pending → approved → archived" },
                { label: "rejected 可退回 draft" }
              ]
            }
          ]
        },
        {
          label: "判题",
          children: [
            { label: "POST /api/runs 运行" },
            { label: "POST /api/submissions 提交" },
            { label: "Redis Streams 异步队列" },
            { label: "Docker 沙箱执行" },
            { label: "首个失败用例与提交快照" },
            { label: "WebSocket 推送 + 2 秒轮询兜底" },
            { label: "终态：AC / WA / TLE / MLE / RE / CE" }
          ]
        },
        {
          label: "练习与学习",
          children: [
            { label: "首页学习工作台" },
            { label: "继续学习 / 随机一题 / 最近活动" },
            { label: "错题本与待复习" },
            { label: "收藏与学习分析" },
            { label: "跨设备草稿，Mod+S 即存" }
          ]
        },
        {
          label: "一题多解",
          children: [
            { label: "每题最多 5 份独立解法" },
            { label: "本机与服务端双模式" },
            { label: "登录后合并游客解法" }
          ]
        },
        {
          label: "题目笔记与题解",
          children: [
            { label: "私有 Markdown 笔记" },
            { label: "题解与讨论区复用论坛" }
          ]
        }
      ]
    },
    {
      label: "匹配 · 赛事 · 段位",
      color: "#0891b2",
      children: [
        { label: "4 人实时匹配" },
        {
          label: "超时降级",
          children: [
            { label: "3 分钟降为 3 人房" },
            { label: "5 分钟降为 2 人房" }
          ]
        },
        { label: "段位分与比赛结算" },
        {
          label: "断线重连",
          children: [
            { label: "10 秒心跳" },
            { label: "30 秒标记断线" },
            { label: "120 秒冻结成绩" },
            { label: "全员断线取消排位赛" }
          ]
        },
        {
          label: "限时赛事",
          children: [
            { label: "公开 / 邀请 / 外部链接报名" },
            { label: "名额 / 组织 / 年级范围" },
            { label: "赛事内答题与排行榜" },
            { label: "赛事申诉与成绩 CSV" },
            { label: "校园墙公告同步" }
          ]
        },
        {
          label: "赛季与排位",
          children: [
            { label: "赛季软重置回 1000 附近" },
            { label: "排位榜与赛季榜" },
            { label: "赛季奖励未开始" }
          ]
        }
      ]
    },
    {
      label: "组织 · 作业 · 批改",
      color: "#ca8a04",
      children: [
        {
          label: "组织",
          children: [
            { label: "创建 / 归档 / 邀请码" },
            { label: "成员添加 / 移除 / 退出" },
            { label: "CSV 批量导入学生" }
          ]
        },
        { label: "作业生命周期：draft → scheduled → active → closed → archived" },
        {
          label: "作业策略",
          children: [
            { label: "迟交宽限与按天扣分" },
            { label: "每题提交次数" },
            { label: "三种计分策略" },
            { label: "成绩可见时机" },
            { label: "补交 / 免修" },
            { label: "解析独立发布" }
          ]
        },
        {
          label: "批改",
          children: [
            { label: "自动判题分" },
            { label: "教师手动分与评语" },
            { label: "整体评语与批改台" },
            { label: "截止后发布成绩" }
          ]
        },
        {
          label: "成绩与统计",
          children: [
            { label: "成绩申诉" },
            { label: "作业统计报表" },
            { label: "成绩 CSV 导出" },
            { label: "站内信与邮件通知" }
          ]
        }
      ]
    },
    {
      label: "防作弊",
      color: "#dc2626",
      children: [
        {
          label: "预防",
          children: [
            { label: "摄像头与屏幕共享授权" },
            { label: "切屏 / 粘贴事件记录" },
            { label: "粘贴内容初筛" }
          ]
        },
        {
          label: "检测",
          children: [
            { label: "token 归一化 + winnowing 指纹" },
            { label: "同作业 / 同题 / 同语言扫描" },
            { label: "similarity_pairs 相似度对" }
          ]
        },
        {
          label: "复核",
          children: [
            { label: "超阈值生成教师报告" },
            { label: "教师确认或排除" },
            { label: "确认时可选该题判 0" },
            { label: "管理员负载均衡分派" }
          ]
        },
        {
          label: "处罚与申诉",
          children: [
            { label: "确认作弊扣 25 信誉分" },
            { label: "取消本场成绩并重排" },
            { label: "低于 40 禁排位 / 赛事 / 论坛" },
            { label: "负分自动封号并入邮箱黑名单" },
            { label: "学生可申诉一次并恢复成绩" },
            { label: "每日签到 +0.1 信誉分" }
          ]
        },
        {
          label: "边界",
          children: [
            { label: "信号只生成报告" },
            { label: "不自动定罪" },
            { label: "全程审计留痕" }
          ]
        }
      ]
    },
    {
      label: "论坛 · 面经",
      color: "#4f46e5",
      children: [
        {
          label: "论坛 / 校园墙",
          children: [
            { label: "发帖 / 评论 / 点赞 / 收藏" },
            { label: "引用题目与举报" },
            { label: "管理员审核与禁言" }
          ]
        },
        {
          label: "面经板块",
          children: [
            { label: "board 为 interview 的帖子" },
            { label: "Plus / 管理员 / 作者可见" },
            { label: "正文只收题目，答案写评论" },
            { label: "公司 / 岗位结构化筛选" },
            { label: "阅读数与最佳答案" },
            {
              label: "面试类型",
              children: [
                { label: "technical / hr / algorithm / manager" }
              ]
            },
            { label: "HR 模板 Wiki" }
          ]
        },
        {
          label: "题目讨论",
          children: [
            { label: "按 problem_id 聚合帖子" },
            { label: "热度 / 最新排序" },
            { label: "竞赛答题页隐藏入口" }
          ]
        }
      ]
    },
    {
      label: "通知 · 商店 · 管理端",
      color: "#0d9488",
      children: [
        {
          label: "通知",
          children: [
            { label: "站内信 / 未读数 / 通知中心" },
            { label: "管理员按用户 / 角色 / 全站发送" },
            { label: "邮件类别偏好与投递" },
            { label: "WebSocket 实时推送" }
          ]
        },
        {
          label: "商店 Plus",
          children: [
            { label: "学生与教师可见，管理员不显示" },
            { label: "申请 → 管理员审核" },
            { label: "有效期 1–3650 天" },
            { label: "有效期内可提前续费并顺延" },
            { label: "到期前 7 / 3 / 1 天提醒" },
            { label: "权益：面经板块 + Plus 标识" }
          ]
        },
        {
          label: "管理端",
          children: [
            { label: "用户 / 角色 / 题目审核" },
            { label: "论坛 / 通知 / 赛事 / Plus" },
            { label: "赛季 / 赛事申诉" },
            { label: "审计日志筛选与 CSV 导出" },
            { label: "判题配置与队列监控" }
          ]
        }
      ]
    },
    {
      label: "AI · LSP · 设置",
      color: "#9333ea",
      children: [
        {
          label: "AI 助手",
          children: [
            { label: "仅 Plus 与管理员可用" },
            { label: "OpenAI 兼容接口" },
            { label: "只发送题面与公开示例" },
            { label: "不发送隐藏用例" },
            { label: "每日额度 ai_usage" },
            { label: "作业级开关" },
            { label: "Markdown + KaTeX" }
          ]
        },
        {
          label: "语义补全",
          children: [
            { label: "clangd 与 pyright" },
            { label: "一次性票据 + WebSocket" },
            { label: "仅 C++ 与 Python" },
            { label: "比赛模式禁用" }
          ]
        },
        {
          label: "设置中心",
          children: [
            { label: "外观 / 编辑器 / 快捷键" },
            { label: "题目默认值与分页" },
            { label: "user_preferences 跨设备同步" },
            { label: "未登录回退本机设置" }
          ]
        }
      ]
    },
    {
      label: "数据模型",
      color: "#b45309",
      children: [
        {
          label: "身份",
          children: [
            { label: "users / oauth_identities" },
            { label: "user_preferences" }
          ]
        },
        {
          label: "题库与判题",
          children: [
            { label: "problems / judge_cases" },
            { label: "submissions / problem_solutions" },
            { label: "problem_notes / problem_drafts" }
          ]
        },
        {
          label: "教学",
          children: [
            { label: "classes / class_members" },
            { label: "assignments / assignment_submissions" },
            { label: "assignment_grade_appeals" }
          ]
        },
        {
          label: "竞赛",
          children: [
            { label: "contests / contest_registrations" },
            { label: "seasons / season_ratings" }
          ]
        },
        {
          label: "社区",
          children: [
            { label: "forum_posts / forum_comments" },
            { label: "interview_templates" }
          ]
        },
        {
          label: "平台",
          children: [
            { label: "notifications / audit_logs" },
            { label: "plus_applications / plus_memberships" },
            { label: "similarity_pairs / wrong_problem_dismissals" }
          ]
        }
      ]
    },
    {
      label: "接口与事件",
      color: "#be123c",
      children: [
        {
          label: "REST /api/*",
          children: [
            { label: "接口契约见 backend_api.md" },
            { label: "统一错误码与鉴权" }
          ]
        },
        {
          label: "WebSocket",
          children: [
            { label: "POST /api/ws/ticket 一次性票据" },
            { label: "GET /api/ws" },
            { label: "notification.new" },
            { label: "match.found" },
            { label: "submission.result" }
          ]
        },
        {
          label: "异步任务",
          children: [
            { label: "Redis Streams 判题队列" },
            { label: "outbox 邮件投递" },
            { label: "相似度扫描" }
          ]
        },
        {
          label: "健康与指标",
          children: [
            { label: "/healthz /readyz" },
            { label: "/metrics" }
          ]
        },
        {
          label: "限流与幂等",
          children: [
            { label: "固定窗口限流" },
            { label: "登录失败锁定" },
            { label: "Retry-After" }
          ]
        }
      ]
    },
    {
      label: "安全 · 运维 · 交付",
      color: "#15803d",
      children: [
        {
          label: "安全",
          children: [
            { label: "三角色最小权限" },
            { label: "CORS 白名单与安全响应头" },
            { label: "Markdown / 模板 XSS 清洗" },
            { label: "沙箱隔离与资源限制" },
            { label: "审计追加式留痕" }
          ]
        },
        {
          label: "性能",
          children: [
            { label: "首页并行查询" },
            { label: "复合索引与慢查询采集" },
            { label: "k6 读路径压测" }
          ]
        },
        {
          label: "可观测",
          children: [
            { label: "Prometheus / Alertmanager / Grafana" },
            { label: "结构化日志与 Worker 心跳" },
            { label: "判题积压 / 死信告警" }
          ]
        },
        {
          label: "部署",
          children: [
            { label: "Docker Compose 单机" },
            { label: "Nginx 反代与 TLS 手册" },
            { label: "备份 / 恢复 / update.sh" }
          ]
        },
        {
          label: "CI/CD",
          children: [
            { label: "fmt / clippy / test / build" },
            { label: "cargo audit / npm audit" },
            { label: "GHCR 完整 SHA 镜像" },
            { label: "首次远程 CI 待验证" }
          ]
        }
      ]
    },
    {
      label: "路线与当前状态",
      color: "#0369a1",
      children: [
        { label: "P0 刷题 · 判题 · 论坛 · 通知 — 已完成" },
        { label: "P1 教学闭环 — 已完成" },
        { label: "P2 通知与防作弊 — 已完成" },
        {
          label: "P3 匹配与赛事 — 部分完成",
          children: [
            { label: "匹配 / 段位 / 赛事 / 赛季已上线" },
            { label: "赛季奖励与定时切换未开始" }
          ]
        },
        {
          label: "P4 治理 · 观测 · 部署 — 部分完成",
          children: [
            { label: "部署 / 观测 / CI 已上线" },
            { label: "CD 与多实例未开始" }
          ]
        },
        { label: "P5 AI 与移动端优化 — 部分完成" },
        {
          label: "当前阻塞",
          children: [
            { label: "CI 结果待确认" },
            { label: "服务器部署待执行" },
            { label: "cargo audit 与 npm audit 本地未复跑" }
          ]
        },
        {
          label: "关键指标",
          children: [
            { label: "题库 1000 题" },
            { label: "后端 163 + 5 tests" },
            { label: "前端 build 通过" },
            { label: "冒烟脚本 smoke_*.sh" }
          ]
        }
      ]
    },
    {
      label: "文档与代码地图",
      color: "#6d28d9",
      children: [
        {
          label: "文档入口",
          children: [
            { label: "doc/README.md 索引" },
            { label: "doc/STATUS.md 当前状态" },
            { label: "doc/总体设计.md 设计基线" },
            { label: "doc/backend_api.md 接口契约" },
            { label: "doc/AGENTS.md 维护约定" }
          ]
        },
        {
          label: "归档与报告",
          children: [
            { label: "doc/archive/YYYYMMDD/" },
            { label: "doc/reports/" }
          ]
        },
        {
          label: "素材",
          children: [
            { label: "doc/interview/ 面经原始 Markdown" },
            { label: "doc/mockups/ 页面原型" },
            { label: "doc/map/ 本思维导图" }
          ]
        },
        {
          label: "代码入口",
          children: [
            { label: "backend-rust/ API · Worker · LSP" },
            { label: "frontend-vue/ Vue 3 SPA" },
            { label: "deploy/ Compose 与运维脚本" }
          ]
        },
        {
          label: "验证入口",
          children: [
            { label: "dev.sh 本地全栈" },
            { label: "update.sh 增量部署" },
            { label: "smoke_*.sh 接口冒烟" }
          ]
        }
      ]
    }
  ]
};
