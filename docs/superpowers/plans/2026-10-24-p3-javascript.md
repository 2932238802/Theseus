# P3 JavaScript 运行 Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

> **Commit policy:** 用户已自行提交 P1/P2。除非用户明确要求，不要执行 git add/commit。

**Goal:** 在 P1/P2 运行链路上支持 `language=javascript`：Node harness、JS 模板、Node 镜像配置、Service/Worker/前端语言放开，`examples` 与 `custom` 均可用。

**Architecture:** `runner.rs` 抽出共享的 `execute_script`，`execute_python`/`execute_javascript` 仅封装文件名、harness 源码与启动命令；Worker 按语言选择镜像与执行器；比较与状态聚合完全复用 P2。

**Tech Stack:** Rust、Node.js 22、Docker(shim 本地验证)、Vue 3。

---

## Task 1: JS 模板与 Node harness

**Files:**
- Modify: `backend-rust/src/judge/run_config.rs`
- Create: `backend-rust/src/judge/harness/javascript.rs`
- Modify: `backend-rust/src/judge/harness/mod.rs`

- [ ] `run_config.rs` 新增：

```rust
pub fn javascript_template(config: &RunConfig) -> String {
    let parameters = config
        .params
        .iter()
        .map(|param| param.name.clone())
        .collect::<Vec<_>>()
        .join(", ");
    format!(
        "var {} = function({}) {{\n}};\n",
        config.function_name, parameters
    )
}
```

- [ ] 测试：`javascript_template` 输出包含 `var twoSum = function(nums, target) {`。

- [ ] 创建 `javascript.rs`：`pub fn generate_runner(function_name: &str) -> String`，模板要点：
  - `const WORKSPACE = "/workspace";`、`const FUNCTION_NAME = "__FUNCTION_NAME__";`
  - 读取 `case.json`、`solution.js`；`(0, eval)(source)`；`globalThis[FUNCTION_NAME]` 必须是函数。
  - 覆写 `process.stdout.write`/`process.stderr.write` 捕获输出；`console.log` 走 stdout。
  - 成功写 `{ok:true, actual, error:null, runtime_ms, memory_kb}`；异常写 `{ok:false, actual:null, error:"Name: message", ...}` 并把 stack 加入 stderr。
  - `undefined` 返回值规范为 `null`；JSON.stringify 失败时写 `ok:false` + “返回值无法序列化为 JSON”。
  - 用 `fs.writeFileSync` 写 `result.json`、`stdout.txt`、`stderr.txt`，文本截断 65536 字符。
- [ ] 测试：生成器包含函数名且不含占位符。

## Task 2: Runner 共享执行器

**Files:**
- Modify: `backend-rust/src/judge/runner.rs`

- [ ] 新增：

```rust
pub async fn execute_javascript(
    sandbox: &SandboxConfig,
    run_id: i64,
    code: &str,
    args: &[Value],
    function_name: &str,
    timeout: Duration,
) -> Result<SandboxOutcome, AppError> {
    execute_script(
        sandbox,
        run_id,
        code,
        args,
        timeout,
        ScriptSpec {
            harness_file: "runner.js",
            source_file: "solution.js",
            harness_source: generate_node_runner(function_name),
            command: &["node", "/workspace/runner.js"],
            image_label: "Node",
        },
    )
    .await
}
```

- [ ] `execute_python` 改为同样调用 `execute_script`（`runner.py`/`solution.py`/`python3`/`Python`）。
- [ ] 内部 `execute_script` 承接现有 `execute_python` 的 workspace/container/清理逻辑；`run_in_container` 接收 `ScriptSpec`，写入 `spec.harness_file`/`spec.source_file`，复制 `[harness_file, source_file, "case.json"]`，命令为 `docker exec --user 65534:65534 <container> <command...>`。
- [ ] 镜像为空时报 `未配置 {image_label} 运行镜像`。
- [ ] 现有 `truncate_output` 测试保留。

## Task 3: 配置与镜像

**Files:**
- Modify: `backend-rust/src/config.rs`
- Modify: `backend-rust/.env`
- Modify: `backend-rust/.env.example`
- Create: `backend-rust/docker/runners/node.Dockerfile`

- [ ] Config 增加 `pub run_image_node: String`，从 `RUN_IMAGE_NODE` 读取，默认 `node:22-slim`。
- [ ] `.env`：`RUN_IMAGE_NODE=theseus/runner-node:dev`。
- [ ] `.env.example`：`RUN_IMAGE_NODE=registry.example.com/theseus/runner-node@sha256:replace-me`。
- [ ] Dockerfile：

```dockerfile
FROM node:22-slim

RUN useradd --uid 65534 --no-create-home --shell /usr/sbin/nologin runner 2>/dev/null || true
WORKDIR /workspace
USER 65534:65534
```

## Task 4: Service 与 Worker 语言支持

**Files:**
- Modify: `backend-rust/src/services/run_service.rs`
- Modify: `backend-rust/src/bin/judge_worker.rs`

- [ ] `validate_language`：`"python" | "javascript" => Ok(())`；`"cpp" | "java"` 返回 `当前仅支持 Python 和 JavaScript 运行`；其他返回 `不支持的编程语言`。
- [ ] 测试改为验收 python/javascript，拒绝 cpp/ruby。
- [ ] Worker 语言检查改为仅拒绝非 python/javascript。
- [ ] Worker 增加：

```rust
struct Sandboxes {
    python: SandboxConfig,
    node: SandboxConfig,
}

impl Sandboxes {
    fn for_language(&self, language: &str) -> Option<&SandboxConfig> {
        match language {
            "python" => Some(&self.python),
            "javascript" => Some(&self.node),
            _ => None,
        }
    }
}
```

- [ ] `main` 构造两个 `SandboxConfig`（`config.run_image_python` / `config.run_image_node`），`process_run` 接收 `&Sandboxes`。
- [ ] 用例循环内按语言调用 `execute_python` 或 `execute_javascript`；无匹配语言时 `fail_run`。

## Task 5: 前端语言放开

**Files:**
- Modify: `frontend-vue/src/views/OjPage.vue`

- [ ] `canRun` 中语言条件改为 `(language.value === 'python' || language.value === 'javascript')`。
- [ ] `runDisabledReason` 改为 `暂不支持运行该语言，当前支持 Python 与 JavaScript`。
- [ ] 其他逻辑（弹窗、示例/自定义、结果面板、轮询）不变。

## Task 6: 种子与验证

**Files:**
- Modify: `backend-rust/scripts/seed_dev.sql`

- [ ] 1001 的 `javascript` 模板改为：

```json
"javascript": "var twoSum = function(nums, target) {\n};\n",
```

- [ ] 重新灌入种子。
- [ ] `cargo fmt --check && cargo clippy --all-targets && cargo test`。
- [ ] `cd frontend-vue && npm run build`。
- [ ] 扩展 `/tmp/theseus-docker-shim/docker`：`exec` 时若命令为 `node` 则运行 `node`，并把 `runner.js` 中的 `const WORKSPACE = "/workspace"` 替换为 shim 目录；Python 分支保持。
- [ ] 端到端：
  - JS `mode=custom` 正确求和 → `completed`，actual 正确。
  - JS `mode=examples` 返回 `[0,1]` → `completed` 2/3。
  - JS 抛异常 → `runtime_error`。
  - 运行不写 `submissions`。
- [ ] 清理测试用户/运行记录/Redis 键/临时 shim。
- [ ] 更新 CR-005 状态为 P1–P3 已实施。

## Self-Review

- 覆盖：JS 模板、harness、runner、镜像、配置、Service/Worker、前端、种子、验证。
- 无占位符；类型/函数名前后一致（`execute_script`/`ScriptSpec`/`execute_javascript`/`run_image_node`）。
