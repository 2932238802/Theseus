在线 OJ 平台前端开发需求文档 v1.0

## 一、项目概述

### 1.1 项目目标

开发一个在线编程训练平台，参考 LeetCode、洛谷等成熟 OJ 平台的交互体验，打造简约、高效的用户界面

### 1.3 设计风格

- 简约现代，参考 LeetCode CN 的界面风格
- 主色调：黑白灰淡蓝
- 深色模式支持（前期设计的时候，注意就要设计好）

---

## 二、页面结构

### 2.1 路由设计

```
/login              - 登录注册页（LoginAndRegisterPage.vue）
/                   - 首页（IndexPage.vue）
/problems           - 题库列表页（ProblemsPage.vue）
/problem/:id        - 题目详情+编程页（OjPage.vue）
/submit/:id         - 提交记录页（可选）
/profile            - 个人中心
```

### 2.2 页面详细说明

#### 2.2.1 LoginAndRegisterPage.vue（登录注册页）

**功能要求：**

- 登录表单

  - 用户名/邮箱输入框

  - 密码输入框（支持显示/隐藏密码）

  - "记住我"选项

  - 登录按钮

  - 表单验证（前端校验）

- 注册表单

  - 用户名输入框（3-16字符，字母数字下划线）

  - 邮箱输入框（格式验证）

  - 密码输入框（最少8位，需包含字母和数字）

  - 确认密码输入框

  - 注册按钮

  - 表单验证

- 交互细节

  - 登录/注册表单切换（Tab 或滑动切换）

  - 表单提交时显示 Loading 状态

  - 错误提示（用户名已存在、密码错误等）

  - 支持回车键提交
  - 注册成功的话直接跳转到首页，不用再进行登录

---

#### 2.2.2 IndexPage.vue（首页）

**功能要求：**

- 导航栏

  - Logo + 平台名称

  - 题库 个人 排行榜 暂时先三个入口

  - 用户头像 + 悬停的时候 下拉菜单（个人中心、退出登录）

- 主体内容

  - 每日一题推荐（卡片展示）

  - 题目分类导航（数组、字符串、动态规划等）

  - 统计数据（题目总数等）

- 快速入口

  - 搜索题目功能

  - "开始刷题"按钮（跳转题库）

    

---

#### 2.2.3 ProblemsPage.vue（题库列表页）

**功能要求：**

- 选功能
  - 难度筛选（简单、中等、困难）
  - 分类筛选（数组、字符串等）
  - 状态筛选（未做、已通过 暂时先不设计尝试过）
- 搜索功能
  - 支持题目名称、标签搜索
  - 实时搜索或搜索按钮触发

- 题目列表

  - 表格形式展示（题号、题目名称、难度、通过率、标签）

  - 支持排序（按题号、难度、通过率）

  - 分页器（每页 20/50/100 题可选）

- 交互

  - 点击题目行跳转到编程页

  - 显示做题状态图标（✓ 已通过 或者 没有通过）

---

#### 2.2.4 OjPage.vue（编程页）

**功能要求：**

**布局：** 左右分栏（可调整宽度）

**左侧：题目描述区域**

- 题目标题 + 难度标签

- 题目描述（支持 Markdown 渲染）

- 输入输出示例

- 数据范围和提示

- 标签展示

**右侧：代码编辑区域**

- 语言选择下拉框（C++、Java、Python、JavaScript 等）

- 代码编辑器（Monaco Editor）

  - 语法高亮

  - 代码自动补全

  - 主题切换（亮色/暗色）

  - 字体大小调整

- 功能按钮

  - **运行代码**：弹出输入框，用户输入测试用例

  - **提交代码**：提交到后端评测

  - **重置代码**：恢复默认代码模板

- 输出区域（可折叠）

  - 运行结果（通过/错误）

  - 错误信息

  - 执行时间、内存占用

---

## 三、功能清单

- [ ] 用户登录注册
- [ ] 题库列表展示
- [ ] 题目详情展示
- [ ] 代码编辑器集成
- [ ] 代码提交功能
- [ ] 提交结果展示

- [ ] 题目搜索功能
- [ ] 题目筛选功能
- [ ] 用户做题状态标记
- [ ] Token 过期处理和自动刷新
- [ ] 全局 Loading 和错误提示

- [ ] 提交记录页面
- [ ] 个人中心（做题统计、修改密码）
- [ ] 深色模式
- [ ] 题目收藏功能
- [ ] 题解社区（讨论区）

---

## 四、API 接口约定

### 4.1 用户相关

```javascript
// 登录
POST /api/auth/login
Request: 
{ 
     username: string, 
     password: string 
}

Response: 
{ 
    token: string, 
    user: 
    { 
    	id, 
        username, 
        email,
    } 
}

// 注册
POST /api/auth/register
Request: 
{ 
    username: string, 
    email: string, 
    password: string 
}

Response: 
{ 
    message: string 
}
```

// 其它接口 还没 约定 可以先 按照架构 进行设计



---

## 五、开发规范

### 5.1 代码规范

- 组件命名：大驼峰（PascalCase）
- 变量命名：蛇（snake_case）
- 常量命名：全大写下划线（UPPER_SNAKE_CASE）
- 文件命名：大驼峰 + .vue / .js

### 5.2 Git 提交规范

```
feat: 新增功能
fix: 修复 bug
style: 样式调整
refactor: 重构代码
docs: 文档更新
```

### 5.3 目录结构

```
src/
├── views/              # 页面组件
│   ├── LoginAndRegisterPage.vue
│   ├── IndexPage.vue
│   ├── ProblemsPage.vue
│   └── OjPage.vue
├── components/         # 公共组件
│   ├── NavBar.vue
│   ├── ProblemCard.vue
│   └── CodeEditor.vue
├── router/             # 路由配置
├── store/              # 状态管理
├── api/                # API 请求封装
├── utils/              # 工具函数
└── assets/             # 静态资源
```

---

## 六、验收标准

### 6.1 功能验收

- [ ] 用户可以正常注册、登录、退出
- [ ] 首页可以展示题目推荐和分类
- [ ] 题库页可以筛选、搜索、分页
- [ ] 编程页可以编写、运行、提交代码
- [ ] 提交后可以看到评测结果

### 6.2 性能要求

- [ ] 首屏加载时间 < 3 秒
- [ ] 页面切换流畅，无卡顿
- [ ] 代码编辑器响应及时

### 6.3 兼容性

- [ ] Chrome 最新版
- [ ] Firefox 最新版
- [ ] Edge 最新版
- [ ] Safari 最新版（Mac）



## 七、参考资源

- **Monaco Editor**：https://microsoft.github.io/monaco-editor/
- **Element Plus**：https://element-plus.org/
- **Vue Router**：https://router.vuejs.org/
- **Axios**：https://axios-http.com/

---

## 八、注意事项

1. **安全性**：Token 存储在 localStorage，请求时放在 Authorization 头
2. **错误处理**：统一封装 HTTP 拦截器，处理 401、500 等错误
3. **加载状态**：所有异步请求都要有 Loading 提示
4. **表单验证**：前后端都要做验证，前端提升体验
5. **代码复用**：公共组件要抽取，避免重复代码

---

## 九. SKILL的使用

- 开发的过程中使用 `frontend-design` 和 `frontend-spec` SKILL 协助开发