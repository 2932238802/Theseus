# rust 后端迭代文档

## [CR-001] 2026-10-16

### 项目背景
- 为在线编程训练平台提供后端服务，支持用户管理、题库管理、代码提交与评测等核心功能

### 技术选型

- 语言与框架:
  - 语言：Rust
  - Web 框架：Axum
  - 数据库：PostgreSQL
  - ORM：SeaORM / Diesel
  - 认证：JWT (JSON Web Token)
- 部署环境
  - 本地 Linux / WSL
  - PostgreSQL 18

### 整体架构

- 结构示意图
┌─────────────┐
│  前端 Vue   │
└──────┬──────┘
       │ HTTP/HTTPS
       ↓
┌─────────────────────┐
│   API 网关层        │
│  (Axum/Actix)       │
├─────────────────────┤
│   业务逻辑层        │
│  - 用户服务         │
│  - 题库服务         │
│  - 提交服务         │
└──────┬──────────────┘
       │
       ├──→ PostgreSQL (用户、题库、提交记录)
       │
       └──→ Judge 服务 (代码评测，异步队列)

### 模块划分
backend-rust/
├── src/
│   ├── main.rs                 # 入口
│   ├── config.rs               # 配置管理
│   ├── routes/                 # 路由层
│   │   ├── mod.rs
│   │   ├── auth.rs             # 认证路由
│   │   ├── problems.rs         # 题库路由
│   │   └── submissions.rs      # 提交路由
│   ├── handlers/               # 业务逻辑层
│   │   ├── mod.rs
│   │   ├── auth_handler.rs
│   │   ├── problem_handler.rs
│   │   └── submission_handler.rs
│   ├── models/                 # 数据模型
│   │   ├── mod.rs
│   │   ├── user.rs
│   │   ├── problem.rs
│   │   └── submission.rs
│   ├── db/                     # 数据库访问层
│   │   ├── mod.rs
│   │   ├── pool.rs             # 连接池
│   │   └── migrations/         # 数据库迁移
│   ├── services/               # 服务层
│   │   ├── mod.rs
│   │   ├── judge_service.rs    # 评测服务
│   │   └── auth_service.rs
│   ├── middleware/             # 中间件
│   │   ├── mod.rs
│   │   ├── auth.rs             # JWT 验证
│   │   └── logger.rs
│   └── utils/                  # 工具函数
│       ├── mod.rs
│       ├── jwt.rs
│       └── password.rs
├── tests/                      # 集成测试
├── migrations/                 # 数据库迁移脚本
├── Cargo.toml
├── .env.example                # 环境变量示例
└── README.md

### 数据库设计

- 用户表设计

```sql
CREATE TABLE users (
    id SERIAL PRIMARY KEY,
    username VARCHAR(50) UNIQUE NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    password_hash VARCHAR(255) NOT NULL,
    role VARCHAR(20) DEFAULT 'user',  -- user, admin
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX idx_users_username ON users(username);
CREATE INDEX idx_users_email ON users(email);
```

- 题目表

```sql
CREATE TABLE problems (
    id SERIAL PRIMARY KEY,
    title VARCHAR(200) NOT NULL,
    description TEXT NOT NULL,           -- Markdown 格式
    difficulty VARCHAR(20) NOT NULL,     -- easy, medium, hard
    time_limit INTEGER DEFAULT 1000,     -- 毫秒
    memory_limit INTEGER DEFAULT 256,    -- MB
    tags TEXT[],                         -- 标签数组
    examples JSONB,                      -- 示例数据 JSON
    test_cases JSONB,                    -- 测试用例 JSON
    acceptance_rate DECIMAL(5,2) DEFAULT 0.00,
    submit_count INTEGER DEFAULT 0,
    accept_count INTEGER DEFAULT 0,
    created_by INTEGER REFERENCES users(id),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX idx_problems_difficulty ON problems(difficulty);
CREATE INDEX idx_problems_tags ON problems USING GIN(tags);
```

- 提交记录表

```sql
CREATE TABLE submissions (
    id SERIAL PRIMARY KEY,
    user_id INTEGER REFERENCES users(id) ON DELETE CASCADE,
    problem_id INTEGER REFERENCES problems(id) ON DELETE CASCADE,
    language VARCHAR(20) NOT NULL,       -- cpp, java, python, javascript
    code TEXT NOT NULL,
    status VARCHAR(30) NOT NULL,         -- pending, judging, accepted, wrong_answer, 
                                         -- time_limit_exceeded, memory_limit_exceeded, 
                                         -- runtime_error, compile_error
    test_cases_passed INTEGER DEFAULT 0,
    total_test_cases INTEGER DEFAULT 0,
    runtime INTEGER,                     -- 毫秒
    memory INTEGER,                      -- KB
    error_message TEXT,
    submitted_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX idx_submissions_user_id ON submissions(user_id);
CREATE INDEX idx_submissions_problem_id ON submissions(problem_id);
CREATE INDEX idx_submissions_status ON submissions(status);
```

- 题目收藏表

```sql
CREATE TABLE favorites (
    id SERIAL PRIMARY KEY,
    user_id INTEGER REFERENCES users(id) ON DELETE CASCADE,
    problem_id INTEGER REFERENCES problems(id) ON DELETE CASCADE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    UNIQUE(user_id, problem_id)
);
```

- 用户状态表

```sql
CREATE TABLE user_problem_status (
    id SERIAL PRIMARY KEY,
    user_id INTEGER REFERENCES users(id) ON DELETE CASCADE,
    problem_id INTEGER REFERENCES problems(id) ON DELETE CASCADE,
    status VARCHAR(20) NOT NULL,         -- not_started, attempted, accepted
    last_submission_id INTEGER REFERENCES submissions(id),
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    UNIQUE(user_id, problem_id)
);
CREATE INDEX idx_ups_user_id ON user_problem_status(user_id);
```

### API 设计

- 注册
```tex
POST /api/auth/register
Content-Type: application/json

Request:
{
  "username": "testuser",
  "email": "test@example.com",
  "password": "password123"
}

Response (201 Created):
{
  "message": "注册成功"
}

Response (400 Bad Request):
{
  "error": "用户名已存在"
}
```

- 登录

```tex
POST /api/auth/login
Content-Type: application/json

Request:
{
  "username": "testuser",
  "password": "password123"
}

Response (200 OK):
{
  "token": "eyJhbGciOiJIUzI1NiIs...",
  "user": {
    "id": 1,
    "username": "testuser",
    "email": "test@example.com",
    "role": "user"
  }
}

Response (401 Unauthorized):
{
  "error": "用户名或密码错误"
}
```

- 获取题目列表

```tex
GET /api/problems?page=1&size=20&difficulty=easy&tag=array&status=accepted

Query 参数：
- page: 页码（默认 1）
- size: 每页数量（默认 20）
- difficulty: 难度筛选（easy/medium/hard）
- tag: 标签筛选
- status: 状态筛选（not_started/attempted/accepted）

Response (200 OK):
{
  "total": 150,
  "page": 1,
  "size": 20,
  "problems": [
    {
      "id": 1,
      "title": "两数之和",
      "difficulty": "easy",
      "acceptance_rate": 48.5,
      "tags": ["数组", "哈希表"],
      "status": "accepted"  // 当前用户的做题状态
    }
  ]
}
```

- 获取题目详情

```tex
GET /api/problems/:id
Authorization: Bearer <token>  (可选，如果需要显示用户状态)

Response (200 OK):
{
  "id": 1,
  "title": "两数之和",
  "description": "给定一个整数数组...",  // Markdown
  "difficulty": "easy",
  "time_limit": 1000,
  "memory_limit": 256,
  "tags": ["数组", "哈希表"],
  "examples": [
    {
      "input": "nums = [2,7,11,15], target = 9",
      "output": "[0,1]",
      "explanation": "因为 nums[0] + nums[1] == 9"
    }
  ],
  "code_template": {
    "cpp": "class Solution {\npublic:\n    vector<int> twoSum(vector<int>& nums, int target) {\n        \n    }\n};",
    "python": "class Solution:\n    def twoSum(self, nums: List[int], target: int) -> List[int]:\n        pass",
    "java": "class Solution {\n    public int[] twoSum(int[] nums, int target) {\n        \n    }\n}"
  },
  "acceptance_rate": 48.5,
  "submit_count": 1000,
  "accept_count": 485,
  "status": "accepted"  // 用户状态（需要登录）
}

Response (404 Not Found):
{
  "error": "题目不存在"
}

```

- 提交代码

```tex
POST /api/submissions
Authorization: Bearer <token>
Content-Type: application/json

Request:
{
  "problem_id": 1,
  "language": "python",
  "code": "class Solution:\n    def twoSum(self, nums, target):\n        return [0, 1]"
}

Response (201 Created):
{
  "submission_id": 12345,
  "status": "pending",
  "message": "提交成功，正在评测中"
}

Response (400 Bad Request):
{
  "error": "代码不能为空"
}

Response (401 Unauthorized):
{
  "error": "请先登录"
}

```

- 查询提交结果

```tex
GET /api/submissions/:id
Authorization: Bearer <token>

Response (200 OK):
{
  "id": 12345,
  "problem_id": 1,
  "problem_title": "两数之和",
  "language": "python",
  "code": "class Solution:...",
  "status": "accepted",
  "test_cases_passed": 10,
  "total_test_cases": 10,
  "runtime": 45,       // 毫秒
  "memory": 14200,     // KB
  "submitted_at": "2025-01-15T10:30:00Z"
}

// 如果状态是 wrong_answer
{
  "status": "wrong_answer",
  "test_cases_passed": 8,
  "total_test_cases": 10,
  "error_message": "测试用例 9 失败：\n输入: [1,2,3], 5\n预期输出: [0,2]\n实际输出: [0,1]"
}

// 如果状态是 compile_error
{
  "status": "compile_error",
  "error_message": "SyntaxError: invalid syntax (line 3)"
}

```

- 获取用户提交记录

```tex
GET /api/submissions?user_id=1&problem_id=1&page=1&size=20
Authorization: Bearer <token>

Response (200 OK):
{
  "total": 15,
  "page": 1,
  "size": 20,
  "submissions": [
    {
      "id": 12345,
      "problem_id": 1,
      "problem_title": "两数之和",
      "language": "python",
      "status": "accepted",
      "runtime": 45,
      "memory": 14200,
      "submitted_at": "2025-01-15T10:30:00Z"
    }
  ]
}

```

- 创建题目

```tex
POST /api/admin/problems
Authorization: Bearer <admin_token>
Content-Type: application/json

Request:
{
  "title": "两数之和",
  "description": "给定一个整数数组...",
  "difficulty": "easy",
  "time_limit": 1000,
  "memory_limit": 256,
  "tags": ["数组", "哈希表"],
  "examples": [...],
  "test_cases": [
    {
      "input": "[2,7,11,15]\n9",
      "output": "[0,1]"
    }
  ],
  "code_template": {...}
}

Response (201 Created):
{
  "id": 101,
  "message": "题目创建成功"
}

```

### 代码规范

- 私有 成员函数 用 `_l_` 开头
- public 成员函数 用 `l_` 开头
- 全局函数 内敛函数 用 `L_` 开头
- 全局常量 定义在 下面两个文件里面 记得注释好
  - commom/constant_number.rs
  - common/constant_str.rs
- 使用 rustfmt 格式化代码：cargo fmt
- 使用 clippy 检查代码：cargo clippy
- 错误处理使用 Result<T, E>，避免 unwrap()

- API 响应统一格式：

    ```Rust
    #[derive(Serialize)]
    pub struct ApiResponse<T> {
        pub success: bool,
        pub data: Option<T>,
        pub error: Option<String>,
    }
    ```
  
### git 提交规范

```tex
feat: 添加用户注册功能
fix: 修复 JWT 过期时间计算错误
refactor: 重构题目查询逻辑
docs: 更新 API 文档
test: 添加用户登录测试
```

### 验收标准

- 用户可以注册、登录，获取 JWT token
- 可以获取题库列表，支持分页、筛选、搜索
- 可以查看题目详情
- 可以提交代码，返回评测结果
- 用户可以提交自定义题目 管理员可以审批也可以创建、修改、删除题目
- 所有 API 有完整的错误处理
- 核心功能有单元测试覆盖
- 有基本的 API 文档

### SKILL使用
- 使用 `rust-patterns` 和 `rust-testing` 等SKILL 完成这个任务