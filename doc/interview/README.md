# 面经归档

这里存放面试记录与复盘，按「公司 / 岗位 / 轮次」归档

Markdown 是面经的原始来源，不参与前后端构建
`backend-rust/scripts/import_interview.sh` 可以把这里的文件批量导入论坛面经板块 `forum_posts`

## 目录约定

```text
doc/interview/
├── README.md
└── <company>/
    └── <role>/
        └── <YYYY-MM>-round-<n>.md
```

- 一场面试一个文件，二面、三面分开
- 公司、岗位用英文小写，轮次用 `round-1`、`round-2`
- 时间只记录到月，例如 `2026-10`
- 文件名不写结果，结果放在 frontmatter

## 文件格式

````markdown
---
company: 百度
role: 后端
round: 二面
date: 2026-10
result: 待补充
tags: [场景题, 手撕]
---

# 百度后端 · 二面（2026-10）

| 项目 | 内容 |
|---|---|
| 公司 | 百度 |
| 岗位 | 后端 |
| 轮次 | 二面 |
| 时间 | 2026-10 |
| 形式 | 场景题 + 手撕 |
| 结果 | 待补充 |

## 面试流程

1. 自我介绍
2. 实习相关
3. 场景题

## 题目

### 1. 题目名

**题目**

面试官原话或题意复述

**思路**

- 关键判断
- 边界情况
- 复杂度

**代码**

```cpp
// 可选
```

**追问**

- 可能的追问与回答方向

## 复盘

- 答得好的地方
- 没答好的地方
- 下次怎么改

## 待补充

- 还不确定的信息
````

`result` 只使用 `待补充`、`已通过`、`未通过`、`未知`

## 导入到面经板块

```bash
# 预览解析结果，不写数据库
./backend-rust/scripts/import_interview.sh --dry-run

# 导入，作者为指定用户名
./backend-rust/scripts/import_interview.sh --author <用户名>

# 标题已存在时覆盖正文、标签、面试时间、公司与岗位
./backend-rust/scripts/import_interview.sh --author <用户名> --update

# 只导入题目，去掉面试流程、复盘、待补充与答案
./backend-rust/scripts/import_interview.sh --author <用户名> --update --no-answers
```

- 标题取文件中的一级标题，也是去重键
- `--no-answers` 只保留题目与 `**题目**` / `**题意**` 描述；面试流程、复盘、待补充与答案都不导入
- 面试时间取 frontmatter 的 `date`，写入 `interview_date`，列表与详情优先显示
- 公司与岗位取 frontmatter 的 `company`、`role`，缺省回退到目录名，写入同名字段供筛选
- 标签取 frontmatter 的 `tags`，并自动加入公司，最多 8 个
- 每个文件导入为已发布的面经帖子，板块为 `interview`
- 写库时必须用 `--author` 指定作者，论坛帖子不允许没有作者
- 导入后面经只对 Plus 用户、管理员与作者可见，答案放在评论区
- 脚本只新增或更新帖子，不删除已有内容

## 索引

| 公司 | 岗位 | 轮次 | 时间 | 结果 | 记录 |
|---|---|---|---|---|---|
| 百度 | 后端 | 二面 | 2026-10 | 待补充 | [二面](./baidu/backend/2026-10-round-2.md) |
| 百度 | 后端 | 三面 | 2026-10 | 待补充 | [三面](./baidu/backend/2026-10-round-3.md) |
| 华为 | 通软 | 一面 | 2026-10 | 待补充 | [一面](./huawei/general-software/2026-10-round-1.md) |
| 华为 | 通软 | 二面 | 2026-10 | 待补充 | [二面](./huawei/general-software/2026-10-round-2.md) |
| 字节跳动 | 后端 | 一面 | 2026-10 | 待补充 | [一面](./bytedance/backend/2026-10-round-1.md) |
| 字节跳动 | 后端 | 三面 | 2026-10 | 待补充 | [三面](./bytedance/backend/2026-10-round-3.md) |
| 神州控股 | 后端 | 一面 | 2026-10 | 待补充 | [一面](./shenzhou/backend/2026-10-round-1.md) |
| 谐云 | 测试实习 | 一面 | 2026-10 | 待补充 | [一面](./xieyun/qa-intern/2026-10-round-1.md) |
| 浩瀚深度 | C++/Rust 研发 | 一面 | 2026-10 | 待补充 | [一面](./haohan/cpp-rust/2026-10-round-1.md) |

字节目前只记录了第一面和第三面
后续补到二面时，按同样命名新增 `2026-10-round-2.md` 并在这里加一行

## 备注

- 面经只记录题目与自己的思路，不记录面试官个人信息
- 涉及公司内部信息的内容不写
- 代码以能讲清楚思路为准，不追求完整工程实现
