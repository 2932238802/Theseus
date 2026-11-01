# 详解 `#[error("请求参数无效: {0}")]` 这套语法

涉及三层东西：

1. Rust 的**属性语法** `#[...]`
2. **derive 宏 + helper attribute** 机制
3. thiserror 给 `#[error]` 定义的**格式串规则**

---

## 一、`#[...]` 本身只是属性

Rust 属性就是挂在 item（struct / enum / variant / field / fn …）上的一段 token：

```rust
#[derive(Debug, Error)]
pub enum AppError {
    #[error("请求参数无效: {0}")]
    BadRequest(String),
}
```

- `#[...]` 是 **outer attribute**，作用于后面紧跟的那一项
- `#![...]` 是 **inner attribute**，作用于所在模块，比如 `#![allow(dead_code)]`
- 属性本身没有固定语义，由**编译器内置规则**或**宏**来解释
- `#[error(...)]` 不是 Rust 内置属性，它由 thiserror 的 derive 宏注册并解释

关键点：`#[derive(Error)]` 和 `#[error("...")]` 是一对，缺一不可

---

## 二、derive 宏与 helper attribute

`#[derive(Error)]` 是过程宏（proc macro）。thiserror 内部大致这样声明：

```rust
#[proc_macro_derive(Error, attributes(error, from, source, backtrace))]
pub fn derive_error(input: TokenStream) -> TokenStream { ... }
```

- `attributes(...)` 列表里声明的名字，就是 **helper attribute**
- 编译器允许这些属性出现在被 derive 的类型的变体和字段上，并原样交给宏
- 所以：

```rust
#[error("...")]     // 需要 #[derive(Error)] 才有效
struct Foo;
```

单独写会报 `cannot find attribute 'error' in this scope`

反过来，`#[derive(Debug)]` 不提供 `#[error]` 这种 helper，两者互不干扰

---

## 三、`#[error("...")]` 的位置与参数

可放在三处：

```rust
// 1. 整个 enum 的每个 variant 上（本项目的形式）
#[derive(Error, Debug)]
enum E {
    #[error("请求参数无效: {0}")]
    BadRequest(String),
}

// 2. 单个 struct 上
#[derive(Error, Debug)]
#[error("连接失败: {host}")]
struct ConnError { host: String }

// 3. 元组 struct 上
#[derive(Error, Debug)]
#[error("超时 {0}ms")]
struct Timeout(u64);
```

参数只有两种合法形态：

```rust
#[error("任意格式串")]      // 生成 Display
#[error(transparent)]       // 委托给内部错误，见第七节
```

每个 variant 都必须有 `#[error(...)]`，否则 thiserror 报错

---

## 四、格式串里 `{0}` 的规则

`#[error("请求参数无效: {0}")]` 中的字符串**就是 `format!` 的格式串**，规则与标准库完全一致

### 1. 字段插值简写

thiserror 官方文档给出的展开对照：

| 写法 | 展开 |
| --- | --- |
| `#[error("{var}")]` | `write!(f, "{}", self.var)` |
| `#[error("{0}")]` | `write!(f, "{}", self.0)` |
| `#[error("{var:?}")]` | `write!(f, "{:?}", self.var)` |
| `#[error("{0:?}")]` | `write!(f, "{:?}", self.0)` |

- `{0}` 里的 `0` 是 **tuple variant 的字段下标**，从 0 开始
- 命名字段直接写字段名：`{expected}`、`{expected:?}`
- 只有被格式串引用到的字段，才会作为参数传给内部的 `write!`

### 2. 可与额外参数混用

```rust
#[error("invalid lookahead {0} (expected < {max})", max = i32::MAX)]
InvalidLookahead(u32),
```

额外参数可以是任意表达式；若需要引用本结构的字段，用 `.0` / `.0.name` 这种写法：

```rust
#[error("first letter must be lowercase but was {:?}", first_char(.0))]
WrongCase(String),

#[error("invalid index {idx}, expected {}..={}", .limits.lo, .limits.hi)]
OutOfBounds { idx: usize, limits: Limits },
```

### 3. 裸 `{}` 不行

因为 thiserror 只把**被显式引用**的字段放进 `write!` 的参数列表，裸占位符没有对应实参

实测编译错误：

```text
error: 1 positional argument in format string, but no arguments were given
```

所以必须写 `{0}`、`{name}`、`.0` 这类明确引用

### 4. 完整格式语法都支持

`{0:?}`、`{0:#?}`、`{0:>8}`、`{0:.3}`、`{0:#x}`、`{0:width$}` … 与 `format!` 完全一样

### 5. 字段类型约束

- `{0}` 要求字段实现 `Display`
- `{0:?}` 要求字段实现 `Debug`
- 类型不满足时在**编译期**报错，不会运行期 panic

---

## 五、`Display` 展开成什么样

```rust
#[derive(Debug, Error)]
pub enum AppError {
    #[error("请求参数无效: {0}")]
    BadRequest(String),
    #[error("请先登录")]
    Unauthorized,
    #[error("{0}")]
    RateLimited(String, u64),
}
```

概念上等价于手写：

```rust
impl std::fmt::Display for AppError {
    fn fmt(&self, f: &mut std::fmt::Formatter<'_>) -> std::fmt::Result {
        match self {
            AppError::BadRequest(detail) => write!(f, "请求参数无效: {0}", detail),
            AppError::Unauthorized => f.write_str("请先登录"),
            AppError::RateLimited(msg, _) => write!(f, "{0}", msg),
        }
    }
}

impl std::error::Error for AppError {}
```

注意：

- `RateLimited(String, u64)` 的 `u64` 没被模板引用，只参与 `match` 解构，不参与显示
- `Display` 只在调用 `to_string()` / `println!("{}", e)` / `format!` 时才计算，参数是 `&self`，不移动字段
- `#[derive(Debug)]` 是另一套，管 `{:?}`

---

## 六、配套的字段属性：`#[from]` / `#[source]` / `#[backtrace]`

### `#[from]`

```rust
#[error("数据库操作失败")]
Database(#[from] sqlx::Error),
```

生成：

```rust
impl From<sqlx::Error> for AppError {
    fn from(source: sqlx::Error) -> Self {
        AppError::Database(source)
    }
}
```

于是业务代码可以直接 `?`：

```rust
let user = sqlx::query_as::<_, User>("...")
    .fetch_one(&pool)
    .await?;          // sqlx::Error -> AppError
```

限制：带 `#[from]` 的 variant 除了 source 字段（和可能的 Backtrace）不能有别的字段

### `#[source]`

```rust
#[derive(Error, Debug)]
struct Outer {
    #[source]                 // 字段名就叫 source 时可省略
    inner: io::Error,
}
```

- 实现 `Error::source()`，返回底层错误
- `#[from]` 隐含 `#[source]`，不用同时写
- 用途：错误链遍历、日志链、`anyhow` 等显示 cause chain

### `#[backtrace]`

把 `Error::provide()` 转发给 source 的 backtrace（需要 nightly + 1.73+，本项目未用）

---

## 七、`#[error(transparent)]`

不添加任何自己的文案，`Display` 和 `source` 直接委托给内部错误：

```rust
#[derive(Error, Debug)]
pub enum AppError {
    #[error(transparent)]
    Other(#[from] anyhow::Error),
}
```

适合「其它错误统统包一层」的兜底 variant

---

## 八、回到本项目的完整链路

`backend-rust/src/common/error.rs`：

```rust
#[derive(Debug, Error)]
pub enum AppError {
    #[error("请求参数无效: {0}")]
    BadRequest(String),
    // ...
    #[error("数据库操作失败")]
    Database(#[from] sqlx::Error),
}
```

1. `?` 把 `sqlx::Error` 转成 `AppError::Database`（`#[from]`）
2. `into_response` 调用 `self.to_string()`，触发 `Display`，得到 `"请求参数无效: xxx"`
3. 包成 `{"success": false, "data": null, "error": "..."}`
4. 用 `status_code()` 决定 HTTP 状态码
5. 返回前端

对应关系：

| variant | Display 结果 | HTTP |
| --- | --- | --- |
| `BadRequest(s)` | `请求参数无效: {s}` | 400 |
| `Unauthorized` | `请先登录` | 401 |
| `ForbiddenWith(s)` | `{s}` | 403 |
| `RateLimited(s, secs)` | `{s}`，`secs` 进 `Retry-After` 头 | 429 |
| `Database(_)` | 对外 `数据库服务暂不可用`，详情只打日志 | 500 |

安全提醒：`BadRequest` / `NotFound` 等模板里的字段会**原样回到客户端**，不要放 SQL、文件路径、堆栈

---

## 九、常见坑

1. **裸 `{}` 不合法**，必须写 `{0}` 或 `{name}`
2. **格式串必须是字符串字面量**，不能是常量或变量
3. **字段没有实现对应 trait**：`{0}` 需要 `Display`，`{0:?}` 需要 `Debug`
4. **`#[error]` 必须和 `#[derive(Error)]` 一起用**，否则是未知属性
5. **`#[from]` 一个 variant 只能有一个**，且该 variant 不能带其它业务字段
6. **别把内部细节塞进 `Display`**，因为这个字符串默认会被 `into_response` 直接发给客户端
7. `#[derive(Debug)]` 与 `#[error]` 是两套东西，`{:?}` 出来的是 Debug 结构体，不是文案
