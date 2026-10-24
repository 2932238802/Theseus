# P2 示例运行 Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

> **Commit policy:** 本仓库当前 git 暂存区存在历史遗留的未合并/大量删除状态。除非用户明确要求，**不要执行 git add/commit**。每个任务以“验证通过”为完成标准。

**Goal:** 在 P1 运行代码功能上启用 `mode=examples`：后端按 `run_config.public_cases` 逐例执行并比较，前端提供示例/自定义双 Tab 与逐用例结果展示。

**Architecture:** 新增 Rust 侧 `judge/compare.rs` 负责 exact/double 比较；Worker 将执行计划统一抽象为 `Vec<(args, Option<expected>)>`，逐例调用现有 `execute_python`，每例写 Redis 状态缓存，最终聚合整体状态并写 PG；Service 放开 `examples` 模式并忽略输入；前端在运行弹窗增加示例预览，结果面板按 mode 分支渲染。

**Tech Stack:** Rust (Axum/sqlx/redis/serde_json)、Vue 3 + Pinia + TypeScript、PostgreSQL、Redis Streams、Docker shim（本地验证）。

---

## File Structure

- Create: `backend-rust/src/judge/compare.rs` — exact/double 深度比较及单元测试。
- Modify: `backend-rust/src/judge/mod.rs` — 注册 `pub mod compare;`。
- Modify: `backend-rust/src/services/run_service.rs` — 放开 `examples`、按 mode 处理 input、初始化 `case_total`。
- Modify: `backend-rust/src/bin/judge_worker.rs` — 统一用例计划、逐例执行、状态聚合、缓存更新、单元测试。
- Modify: `backend-rust/scripts/seed_dev.sql` — 为 1001 增加第 3 条公开用例（便于验证 2/3）。
- Modify: `frontend-vue/src/utils/constants.ts` — 增加 `RUN_CASE_STATUS_LABELS`。
- Modify: `frontend-vue/src/store/runs.ts` — `run()` 支持 mode/可选 input。
- Modify: `frontend-vue/src/views/OjPage.vue` — 弹窗双 Tab、逐用例结果、状态汇总。
- Modify: `frontend-vue/src/style.css` — 双 Tab、示例预览、用例卡片样式。

---

### Task 1: 返回值比较模块

**Files:**
- Create: `backend-rust/src/judge/compare.rs`
- Modify: `backend-rust/src/judge/mod.rs`

- [ ] **Step 1: 写失败测试（先只写测试和空实现签名）**

创建 `backend-rust/src/judge/compare.rs`：

```rust
use serde_json::Value;

pub const DEFAULT_DOUBLE_EPSILON: f64 = 1e-6;

pub fn values_match(
    mode: &str,
    epsilon: Option<f64>,
    _expected: &Value,
    _actual: &Value,
) -> bool {
    let _ = (mode, epsilon);
    false
}

#[cfg(test)]
mod tests {
    use serde_json::json;

    use super::{DEFAULT_DOUBLE_EPSILON, values_match};

    #[test]
    fn exact_matches_deep_equal_values() {
        assert!(values_match(
            "exact",
            None,
            &json!([0, 1]),
            &json!([0, 1])
        ));
        assert!(values_match(
            "exact",
            None,
            &json!({"a": [1, true, "x"]}),
            &json!({"a": [1, true, "x"]})
        ));
    }

    #[test]
    fn exact_is_order_sensitive_and_rejects_null_vs_empty_array() {
        assert!(!values_match("exact", None, &json!([1, 2]), &json!([2, 1])));
        assert!(!values_match("exact", None, &json!(null), &json!([])));
        assert!(!values_match("exact", None, &json!(1), &json!(1.0)));
    }

    #[test]
    fn double_mode_accepts_absolute_and_relative_tolerance() {
        assert!(values_match("double", None, &json!(1.0), &json!(1.0 + 5e-7)));
        assert!(values_match("double", None, &json!(1_000_000.0), &json!(1_000_000.5)));
        assert!(!values_match("double", None, &json!(1.0), &json!(1.01)));
        assert!(values_match("double", Some(0.1), &json!(1.0), &json!(1.05)));
    }

    #[test]
    fn double_mode_compares_arrays_elementwise() {
        assert!(values_match(
            "double",
            None,
            &json!([1.0, 2.0]),
            &json!([1.0000001, 2.0000001])
        ));
        assert!(!values_match(
            "double",
            None,
            &json!([1.0, 2.0]),
            &json!([1.0000001])
        ));
        assert!(!values_match(
            "double",
            None,
            &json!([1.0, 2.0]),
            &json!([1.0000001, 2.1])
        ));
    }

    #[test]
    fn default_epsilon_is_one_millionth() {
        assert_eq!(DEFAULT_DOUBLE_EPSILON, 1e-6);
    }
}
```

- [ ] **Step 2: 注册模块并运行测试确认失败**

在 `backend-rust/src/judge/mod.rs` 增加：

```rust
pub mod compare;
```

Run: `cd backend-rust && cargo test compare::tests -- --nocapture`
Expected: FAIL（`exact_matches_deep_equal_values` 等断言失败，因为实现返回 `false`）。

- [ ] **Step 3: 实现比较逻辑**

将 `compare.rs` 顶部替换为：

```rust
use serde_json::Value;

pub const DEFAULT_DOUBLE_EPSILON: f64 = 1e-6;

pub fn values_match(
    mode: &str,
    epsilon: Option<f64>,
    expected: &Value,
    actual: &Value,
) -> bool {
    if mode == "double" {
        let epsilon = epsilon
            .filter(|value| value.is_finite() && *value > 0.0)
            .unwrap_or(DEFAULT_DOUBLE_EPSILON);
        return double_match(expected, actual, epsilon);
    }
    expected == actual
}

fn double_match(expected: &Value, actual: &Value, epsilon: f64) -> bool {
    match (expected, actual) {
        (Value::Number(left), Value::Number(right)) => match (left.as_f64(), right.as_f64()) {
            (Some(left), Some(right)) => numbers_close(left, right, epsilon),
            _ => false,
        },
        (Value::Array(left), Value::Array(right)) => {
            left.len() == right.len()
                && left
                    .iter()
                    .zip(right)
                    .all(|(left, right)| double_match(left, right, epsilon))
        }
        _ => expected == actual,
    }
}

fn numbers_close(left: f64, right: f64, epsilon: f64) -> bool {
    if left == right {
        return true;
    }
    let difference = (left - right).abs();
    difference <= epsilon || difference <= epsilon * left.abs().max(right.abs())
}
```

- [ ] **Step 4: 运行测试确认通过**

Run: `cd backend-rust && cargo test compare::tests -- --nocapture`
Expected: `test result: ok. 5 passed`.

---

### Task 2: 后端放开 examples 模式

**Files:**
- Modify: `backend-rust/src/services/run_service.rs`
- Test: `backend-rust/src/services/run_service.rs`（同文件测试模块）

- [ ] **Step 1: 更新失败测试**

将 `src/services/run_service.rs` 测试模块中的 `only_custom_mode_is_supported_in_p1` 替换为：

```rust
    #[test]
    fn both_examples_and_custom_modes_are_supported() {
        assert!(validate_mode("examples").is_ok());
        assert!(validate_mode("custom").is_ok());
        assert!(validate_mode("batch").is_err());
    }
```

Run: `cd backend-rust && cargo test both_examples_and_custom_modes_are_supported`
Expected: FAIL（当前 `examples` 返回 Err）。

- [ ] **Step 2: 放开 validate_mode**

```rust
fn validate_mode(mode: &str) -> Result<(), AppError> {
    match mode {
        "examples" | "custom" => Ok(()),
        _ => Err(AppError::BadRequest("运行模式无效".to_owned())),
    }
}
```

- [ ] **Step 3: 按 mode 处理输入并初始化 case_total**

在 `RunService::create` 中，将这段：

```rust
        let run_config = validate_run_config(&run_config_value)?;
        let input = request
            .input
            .ok_or_else(|| AppError::BadRequest("自定义输入不能为空".to_owned()))?;
        validate_input(&run_config, &input)?;
```

替换为：

```rust
        let run_config = validate_run_config(&run_config_value)?;
        let (input, case_total) = if request.mode == "examples" {
            if run_config.public_cases.is_empty() {
                return Err(AppError::BadRequest("该题未配置可运行的示例".to_owned()));
            }
            (None, run_config.public_cases.len() as i32)
        } else {
            let input = request
                .input
                .ok_or_else(|| AppError::BadRequest("自定义输入不能为空".to_owned()))?;
            validate_input(&run_config, &input)?;
            (Some(input), 1)
        };
```

将 INSERT 语句中的 `..., status, case_total) VALUES ($1, $2, $3, $4, $5, $6, $7, $8, $9, 0)` 与绑定改为：

```rust
            "INSERT INTO code_runs (user_id, problem_id, problem_title, language, mode, code, input, run_config_snapshot, status, case_total) VALUES ($1, $2, $3, $4, $5, $6, $7, $8, $9, $10) RETURNING id",
```

```rust
        .bind(RUN_STATUS_QUEUED)
        .bind(case_total)
```

将 queued 缓存改为：

```rust
        let queued =
            CachedRunStatus::new(user.id, run_id, RUN_STATUS_QUEUED, 0, case_total, None);
```

- [ ] **Step 4: 运行单元测试**

Run: `cd backend-rust && cargo test --lib`
Expected: 全部通过（含新增 mode 测试）。

---

### Task 3: Worker 示例执行与状态聚合

**Files:**
- Modify: `backend-rust/src/bin/judge_worker.rs`

- [ ] **Step 1: 更新 imports 与常量**

在 imports 中增加：

```rust
use std::time::Instant;
```

并把 `backend_rust::{...}` 中的 `judge::{` 改为包含 compare 与 RunConfig：

```rust
use backend_rust::{
    config::Config,
    db::pool::create_pool,
    judge::{
        compare::values_match,
        queue,
        run_config::validate_input,
        runner::{SandboxConfig, SandboxOutcome, execute_python},
    },
    models::run::{
        CodeRunRow, RUN_STATUS_COMPILING, RUN_STATUS_COMPLETED, RUN_STATUS_INTERNAL_ERROR,
        RUN_STATUS_MEMORY_LIMIT_EXCEEDED, RUN_STATUS_RUNNING, RUN_STATUS_RUNTIME_ERROR,
        RUN_STATUS_TIME_LIMIT_EXCEEDED, RunCaseResult, RunConfig, is_terminal_status,
    },
    services::run_service::{
        CachedRunStatus, RunTerminalUpdate, claim_run, fetch_run_row, finish_run, mark_running,
        parse_run_config, release_user_lock, write_status_cache,
    },
};
```

在 `process_run` 前增加：

```rust
const CASE_TIMEOUT: Duration = Duration::from_secs(2);
const RUN_TIMEOUT: Duration = Duration::from_secs(10);
```

- [ ] **Step 2: 替换 process_run 的用例执行段**

保留 `process_run` 开头（fetch row、语言检查、`parse_run_config`）。将“`let input = ...; let args = ...; if !claim_run ...` 到函数结束”整段替换为：

```rust
    let cases = match build_cases(&row, &run_config) {
        Ok(cases) => cases,
        Err(message) => {
            fail_run(pool, redis, &row, &message).await;
            return;
        }
    };
    let total = cases.len() as i32;
    if !claim_run(pool, run_id).await.unwrap_or(false) {
        tracing::info!(run_id, "run was claimed by another worker or is terminal");
        return;
    }
    cache_status(redis, &row, RUN_STATUS_COMPILING, 0, total, None).await;

    let _ = mark_running(pool, run_id).await;
    cache_status(redis, &row, RUN_STATUS_RUNNING, 0, total, None).await;

    let started = Instant::now();
    let mut results = Vec::with_capacity(cases.len());
    let mut passed = 0i32;
    let mut first_error: Option<String> = None;
    for (index, (args, expected)) in cases.iter().enumerate() {
        let remaining = RUN_TIMEOUT.saturating_sub(started.elapsed());
        if remaining.is_zero() {
            if first_error.is_none() {
                first_error = Some("运行阶段超过 10 秒，剩余用例未执行".to_owned());
            }
            results.push(unrun_case(index as i32, args, expected));
            continue;
        }
        let outcome = execute_python(
            sandbox,
            run_id,
            &row.code,
            args,
            &run_config.function_name,
            CASE_TIMEOUT.min(remaining),
        )
        .await;
        let outcome = match outcome {
            Ok(outcome) => outcome,
            Err(error) => {
                fail_run(pool, redis, &row, &format!("沙箱执行失败: {error}")).await;
                return;
            }
        };
        let (case, matched, error) = build_case_result(
            index as i32,
            args,
            expected,
            &outcome,
            &run_config,
        );
        if matched {
            passed += 1;
        }
        if first_error.is_none() {
            first_error = error;
        }
        results.push(case);
        cache_status(redis, &row, RUN_STATUS_RUNNING, passed, total, None).await;
    }

    let status = aggregate_status(&results);
    let cases_value = json!(results);
    let runtime_ms = results
        .iter()
        .filter_map(|case| case.runtime_ms)
        .sum::<i32>();
    let memory_kb = results.iter().filter_map(|case| case.memory_kb).max();
    let error_message = (status != RUN_STATUS_COMPLETED)
        .then_some(first_error)
        .flatten();
    let updated = finish_run(
        pool,
        run_id,
        RunTerminalUpdate {
            status,
            cases: &cases_value,
            case_total: total,
            case_passed: passed,
            compile_output: None,
            error_message: error_message.as_deref(),
            runtime_ms: Some(runtime_ms),
            memory_kb,
        },
    )
    .await;
    if updated.unwrap_or(false) {
        cache_status(redis, &row, status, passed, total, error_message.clone()).await;
    }
    release_user_lock(redis, row.user_id, run_id).await;
    tracing::info!(
        run_id,
        user_id = row.user_id,
        status,
        case_passed = passed,
        case_total = total,
        runtime_ms,
        "run finished"
    );
```

- [ ] **Step 3: 删除旧 build_result，新增纯函数**

删除原 `fn build_result(...)`，替换为以下四个函数（放在原位置上）：

```rust
fn build_cases(
    row: &CodeRunRow,
    config: &RunConfig,
) -> Result<Vec<(Vec<Value>, Option<Value>)>, String> {
    if row.mode == "examples" {
        if config.public_cases.is_empty() {
            return Err("该题未配置可运行的示例".to_owned());
        }
        return Ok(config
            .public_cases
            .iter()
            .map(|case| (case.args.clone(), Some(case.expected.clone())))
            .collect());
    }
    let input = row.input.clone().unwrap_or(Value::Null);
    let args = validate_input(config, &input).map_err(|error| format!("运行参数无效: {error}"))?;
    Ok(vec![(args, None)])
}

fn build_case_result(
    index: i32,
    args: &[Value],
    expected: &Option<Value>,
    outcome: &SandboxOutcome,
    config: &RunConfig,
) -> (RunCaseResult, bool, Option<String>) {
    let runtime_ms = outcome
        .result
        .as_ref()
        .map(|result| result.runtime_ms)
        .filter(|value| *value > 0)
        .unwrap_or(outcome.runtime_ms)
        .max(0);
    let memory_kb = (outcome.memory_kb > 0).then_some(outcome.memory_kb);
    let (case_status, error) = if outcome.timed_out {
        (
            "timeout",
            Some("单个用例执行超过 2 秒".to_owned()),
        )
    } else if outcome.oom {
        (
            "memory_limit_exceeded",
            Some("执行内存超过 256 MB".to_owned()),
        )
    } else {
        match &outcome.result {
            Some(result) if result.ok => {
                let matched = expected.as_ref().is_none_or(|expected| {
                    let actual = result.actual.clone().unwrap_or(Value::Null);
                    values_match(
                        &config.compare.mode,
                        config.compare.epsilon,
                        expected,
                        &actual,
                    )
                });
                if matched {
                    ("passed", None)
                } else {
                    ("failed", None)
                }
            }
            Some(result) => (
                "runtime_error",
                Some(
                    result
                        .error
                        .clone()
                        .unwrap_or_else(|| "运行时错误".to_owned()),
                ),
            ),
            None => ("runtime_error", Some("运行未生成结果文件".to_owned())),
        }
    };
    let matched = expected.as_ref().map(|_| case_status == "passed");
    let case = RunCaseResult {
        index,
        args: Value::Array(args.to_vec()),
        expected: expected.clone(),
        actual: outcome.result.as_ref().and_then(|result| result.actual.clone()),
        stdout: outcome.stdout.clone(),
        stderr: outcome.stderr.clone(),
        status: case_status.to_owned(),
        matched,
        runtime_ms: Some(runtime_ms),
        memory_kb,
        truncated: outcome.truncated,
    };
    (case, case_status == "passed", error)
}

fn unrun_case(index: i32, args: &[Value], expected: &Option<Value>) -> RunCaseResult {
    RunCaseResult {
        index,
        args: Value::Array(args.to_vec()),
        expected: expected.clone(),
        actual: None,
        stdout: String::new(),
        stderr: String::new(),
        status: "timeout".to_owned(),
        matched: expected.as_ref().map(|_| false),
        runtime_ms: None,
        memory_kb: None,
        truncated: false,
    }
}

fn aggregate_status(cases: &[RunCaseResult]) -> &'static str {
    if cases
        .iter()
        .any(|case| case.status == "memory_limit_exceeded")
    {
        RUN_STATUS_MEMORY_LIMIT_EXCEEDED
    } else if cases.iter().any(|case| case.status == "timeout") {
        RUN_STATUS_TIME_LIMIT_EXCEEDED
    } else if cases.iter().any(|case| case.status == "runtime_error") {
        RUN_STATUS_RUNTIME_ERROR
    } else {
        RUN_STATUS_COMPLETED
    }
}
```

- [ ] **Step 4: 添加 Worker 单元测试**

在 `judge_worker.rs` 末尾增加：

```rust
#[cfg(test)]
mod tests {
    use super::aggregate_status;
    use backend_rust::models::run::{
        RUN_STATUS_COMPLETED, RUN_STATUS_MEMORY_LIMIT_EXCEEDED, RUN_STATUS_RUNTIME_ERROR,
        RUN_STATUS_TIME_LIMIT_EXCEEDED, RunCaseResult,
    };
    use serde_json::Value;

    fn case(status: &str) -> RunCaseResult {
        RunCaseResult {
            index: 0,
            args: Value::Array(Vec::new()),
            expected: None,
            actual: None,
            stdout: String::new(),
            stderr: String::new(),
            status: status.to_owned(),
            matched: None,
            runtime_ms: None,
            memory_kb: None,
            truncated: false,
        }
    }

    #[test]
    fn mismatched_examples_still_complete() {
        assert_eq!(
            aggregate_status(&[case("passed"), case("failed")]),
            RUN_STATUS_COMPLETED
        );
    }

    #[test]
    fn runtime_error_wins_over_completed() {
        assert_eq!(
            aggregate_status(&[case("passed"), case("runtime_error")]),
            RUN_STATUS_RUNTIME_ERROR
        );
    }

    #[test]
    fn timeout_wins_over_runtime_error_and_memory_wins_over_all() {
        assert_eq!(
            aggregate_status(&[case("runtime_error"), case("timeout")]),
            RUN_STATUS_TIME_LIMIT_EXCEEDED
        );
        assert_eq!(
            aggregate_status(&[case("timeout"), case("memory_limit_exceeded")]),
            RUN_STATUS_MEMORY_LIMIT_EXCEEDED
        );
    }
}
```

- [ ] **Step 5: 运行 Worker 测试与编译**

Run: `cd backend-rust && cargo test --bin judge_worker`
Expected: `3 passed`.

Run: `cd backend-rust && cargo check --all-targets`
Expected: 编译成功，无 error。

---

### Task 4: 种子数据增加第 3 条公开用例

**Files:**
- Modify: `backend-rust/scripts/seed_dev.sql`

- [ ] **Step 1: 修改 1001 的 public_cases**

将：

```json
        "public_cases": [
            {"args": [[2, 7, 11, 15], 9], "expected": [0, 1]},
            {"args": [[3, 2, 4], 6], "expected": [1, 2]}
        ]
```

替换为：

```json
        "public_cases": [
            {"args": [[2, 7, 11, 15], 9], "expected": [0, 1]},
            {"args": [[3, 2, 4], 6], "expected": [1, 2]},
            {"args": [[3, 3], 6], "expected": [0, 1]}
        ]
```

- [ ] **Step 2: 重新灌入种子数据并确认**

Run: `cd backend-rust && PGPASSWORD=theseus psql -h localhost -U theseus -d theseus -f scripts/seed_dev.sql`
Expected: 末尾输出 `setval` 与 `1003`。

Run: `PGPASSWORD=theseus psql -h localhost -U theseus -d theseus -tAc "select jsonb_array_length(run_config->'public_cases') from problems where id=1001;"`
Expected: `3`。

---

### Task 5: 前端示例运行 UI

**Files:**
- Modify: `frontend-vue/src/utils/constants.ts`
- Modify: `frontend-vue/src/store/runs.ts`
- Modify: `frontend-vue/src/views/OjPage.vue`
- Modify: `frontend-vue/src/style.css`

- [ ] **Step 1: 增加用例状态文案**

在 `src/utils/constants.ts` 顶部类型 import 增加 `RunCaseStatus`，并在文件末尾追加：

```ts
export const RUN_CASE_STATUS_LABELS: Record<RunCaseStatus, string> = {
  passed: '通过',
  failed: '未通过',
  runtime_error: '运行时错误',
  timeout: '超时',
  memory_limit_exceeded: '内存超限',
  internal_error: '运行异常',
}
```

- [ ] **Step 2: store 支持 mode 与可选 input**

将 `src/store/runs.ts` 中的 `run` 函数替换为：

```ts
  const run = async (
    problemId: number,
    language: Language,
    code: string,
    mode: RunMode,
    input?: unknown,
  ): Promise<void> => {
    if (isRunning.value) return
    isRunning.value = true
    error.value = ''
    status.value = null
    detail.value = null
    try {
      const created = await createRun({
        problemId,
        language,
        mode,
        code,
        input: mode === 'custom' ? input : undefined,
      })
      status.value = {
        id: created.runId,
        status: created.status,
        casePassed: 0,
        caseTotal: 0,
        errorMessage: null,
        updatedAt: new Date().toISOString(),
      }
      await pollRun(created.runId)
    } catch (exception: unknown) {
      error.value = toErrorMessage(exception)
      throw exception
    } finally {
      isRunning.value = false
    }
  }
```

并在 imports 中增加 `type RunMode`：

```ts
import { isTerminalRunStatus, type RunDetail, type RunMode, type RunStatusResponse } from '../types/run'
```

- [ ] **Step 3: OjPage 脚本增加示例状态**

在 `import { DIFFICULTY_LABELS, LANGUAGE_OPTIONS, RUN_STATUS_LABELS } from '../utils/constants'` 中追加 `RUN_CASE_STATUS_LABELS`。

在 `import type { Language } from '../types/oj'` 后增加：

```ts
import type { RunMode } from '../types/run'
```

在 `const isRunDialogOpen = ref(false)` 附近增加：

```ts
const runMode = ref<RunMode>('examples')
```

在 `runDisabledReason` 后增加：

```ts
const hasPublicCases = computed(() => (runConfig.value?.publicCases.length ?? 0) > 0)
```

将 `openRunDialog` 中的输入预填部分改为：

```ts
  runMode.value = hasPublicCases.value ? 'examples' : 'custom'
  const firstCase = runConfig.value?.publicCases[0]
  runInput.value = firstCase ? JSON.stringify(firstCase.args, null, 2) : '[]'
  runInputError.value = ''
  isRunDialogOpen.value = true
```

将 `startRun` 替换为：

```ts
const startRun = (): void => {
  if (!problemStore.currentProblem || !canRun.value || runStore.isRunning) return
  saveDraft()
  isRunDialogOpen.value = false
  isOutputOpen.value = true
  activeOutputTab.value = 'run'
  if (runMode.value === 'examples') {
    runStore
      .run(problemStore.currentProblem.id, language.value, code.value, 'examples')
      .catch(() => undefined)
    return
  }
  let parsed: unknown
  try {
    parsed = validateRunInput()
  } catch (error: unknown) {
    runInputError.value = error instanceof Error ? error.message : '输入格式不正确'
    isRunDialogOpen.value = true
    return
  }
  runInputError.value = ''
  runStore
    .run(problemStore.currentProblem.id, language.value, code.value, 'custom', parsed)
    .catch(() => undefined)
}
```

- [ ] **Step 4: 弹窗模板增加双 Tab**

将 `.run-dialog-body` 内部替换为：

```html
      <div class="run-dialog-body">
        <div class="run-mode-tabs">
          <button type="button" :class="{ active: runMode === 'examples' }" :disabled="!hasPublicCases" @click="runMode = 'examples'">运行全部示例</button>
          <button type="button" :class="{ active: runMode === 'custom' }" @click="runMode = 'custom'">自定义输入</button>
        </div>
        <template v-if="runMode === 'examples'">
          <p class="run-note">共 {{ runConfig?.publicCases.length ?? 0 }} 条公开用例，运行结果不计入提交。</p>
          <ol class="example-preview">
            <li v-for="(item, index) in runConfig?.publicCases ?? []" :key="index">
              <span>示例 {{ index + 1 }}</span>
              <pre>输入：{{ formatValue(item.args) }}
期望：{{ formatValue(item.expected) }}</pre>
            </li>
          </ol>
        </template>
        <template v-else>
          <p class="run-hint">{{ parameterHint }}</p>
          <label for="run-input">JSON 参数数组</label>
          <textarea id="run-input" v-model="runInput" spellcheck="false" rows="8" @input="runInputError = ''"></textarea>
          <p v-if="runInputError" class="form-error" role="alert">{{ runInputError }}</p>
        </template>
      </div>
```

- [ ] **Step 5: 结果面板按 mode 渲染**

将 `<template v-if="activeOutputTab === 'run'">` 内部（`<p class="run-note">` 开始到 `</template>` 前）替换为：

```html
              <p class="run-note">运行结果不计入提交，也不影响通过率。</p>
              <template v-if="runStore.detail">
                <p v-if="runStore.detail.errorMessage" class="form-error" role="alert">{{ runStore.detail.errorMessage }}</p>
                <p class="run-summary">通过 {{ runStore.detail.casePassed }} / {{ runStore.detail.caseTotal }}</p>
                <template v-if="runStore.detail.mode === 'examples'">
                  <div v-for="item in runStore.detail.cases" :key="item.index" class="run-case">
                    <header><span>示例 {{ item.index + 1 }}</span><span :class="['case-status', item.status]">{{ RUN_CASE_STATUS_LABELS[item.status] }}</span></header>
                    <div class="run-block"><span>输入</span><pre>{{ formatValue(item.args) }}</pre></div>
                    <div class="run-block"><span>期望</span><pre>{{ formatValue(item.expected) }}</pre></div>
                    <div v-if="item.actual !== undefined" class="run-block"><span>实际</span><pre>{{ formatValue(item.actual) }}</pre></div>
                    <div v-if="item.stdout" class="run-block"><span>stdout</span><pre>{{ item.stdout }}</pre></div>
                    <div v-if="item.stderr" class="run-block"><span>stderr</span><pre>{{ item.stderr }}</pre></div>
                    <p v-if="item.truncated" class="run-note">输出超过 64 KB，已截断。</p>
                  </div>
                </template>
                <template v-else>
                  <dl>
                    <div v-if="runStore.detail.runtimeMs !== null"><dt>执行用时</dt><dd>{{ runStore.detail.runtimeMs }} ms</dd></div>
                    <div v-if="runStore.detail.memoryKb"><dt>内存消耗</dt><dd>{{ runStore.detail.memoryKb >= 1024 ? `${(runStore.detail.memoryKb / 1024).toFixed(1)} MB` : `${runStore.detail.memoryKb} KB` }}</dd></div>
                  </dl>
                  <div v-if="runCase && runCase.status === 'passed'" class="run-block"><span>返回值</span><pre>{{ formatValue(runCase.actual) }}</pre></div>
                  <div v-if="runCase?.stdout" class="run-block"><span>stdout</span><pre>{{ runCase.stdout }}</pre></div>
                  <div v-if="runCase?.stderr" class="run-block"><span>stderr</span><pre>{{ runCase.stderr }}</pre></div>
                  <p v-if="runCase?.truncated" class="run-note">输出超过 64 KB，已截断。</p>
                </template>
              </template>
              <p v-else-if="runStore.error" class="form-error" role="alert">{{ runStore.error }}</p>
              <p v-else-if="!runStore.isRunning" class="output-placeholder">运行代码后将在这里显示结果。</p>
```

在结果面板 header 的状态 span 内追加通过数（若存在）：

```html
            <span v-else-if="outputStatusLabel" :class="['result-status', outputSucceeded ? 'accepted' : 'failed']">{{ outputStatusLabel }}<template v-if="activeOutputTab === 'run' && runStore.status && runStore.status.caseTotal > 0"> · {{ runStore.status.casePassed }}/{{ runStore.status.caseTotal }}</template></span>
```

- [ ] **Step 6: 增加样式**

在 `src/style.css` 的 `.run-dialog footer` 规则之后追加：

```css
.run-mode-tabs {
  display: flex;
  gap: var(--space-xs);
  margin-bottom: var(--space-md);
}

.run-mode-tabs > button {
  flex: 1;
  padding: 8px 12px;
  border: 1px solid var(--color-border);
  border-radius: var(--radius-sm);
  color: var(--color-text-secondary);
  font-size: 13px;
  font-weight: 500;
}

.run-mode-tabs > button:hover:not(:disabled) {
  color: var(--color-text);
  background: var(--color-bg);
}

.run-mode-tabs > button.active {
  border-color: var(--color-accent);
  background: var(--color-bg);
  color: var(--color-text);
}

.run-mode-tabs > button:disabled {
  cursor: not-allowed;
  opacity: 0.5;
}

.example-preview {
  display: grid;
  max-height: 240px;
  margin: 0;
  overflow: auto;
  gap: var(--space-sm);
  padding: 0;
  list-style: none;
}

.example-preview > li > span {
  color: var(--color-text-secondary);
  font-size: 12px;
}

.example-preview pre {
  margin: 4px 0 0;
  padding: var(--space-sm) var(--space-md);
  border: 1px solid var(--color-border);
  border-radius: var(--radius-sm);
  background: var(--color-bg);
  font-family: var(--font-mono);
  font-size: 12px;
  white-space: pre-wrap;
  word-break: break-word;
}

.run-summary {
  margin-bottom: var(--space-sm);
  color: var(--color-text-secondary);
  font-size: 13px;
  font-weight: 500;
}

.run-case {
  padding: var(--space-sm) 0;
  border-top: 1px solid var(--color-border);
}

.run-case > header {
  display: flex;
  align-items: center;
  justify-content: space-between;
  margin-bottom: var(--space-xs);
  color: var(--color-text-secondary);
  font-size: 12px;
}

.case-status.passed {
  color: var(--color-success, #15803d);
}

.case-status.failed,
.case-status.runtime_error,
.case-status.timeout,
.case-status.memory_limit_exceeded,
.case-status.internal_error {
  color: var(--color-danger, #b91c1c);
}
```

如果 `style.css` 中已有 `--color-success` / `--color-danger` 变量，使用现有变量名；没有则保留上述 fallback。

- [ ] **Step 7: 构建前端**

Run: `cd frontend-vue && npm run build`
Expected: `✓ built in ...` 且无 TypeScript 错误。

---

### Task 6: 全量验证与端到端

**Files:** 无新增（仅运行命令）

- [ ] **Step 1: 后端静态检查与测试**

Run: `cd backend-rust && cargo fmt --check && cargo clippy --all-targets && cargo test`
Expected: fmt 无输出；clippy 无 warning/error；所有测试通过。

- [ ] **Step 2: 启动本地服务与 Worker（含 docker shim）**

若无 `theseus/runner-python:dev` 镜像，使用 `/tmp/theseus-docker-shim/docker`（P1 验证时创建的模拟器；若已删除，按 P1 会话中的脚本重建）。命令：

```bash
cd backend-rust
setsid ./target/debug/backend-rust > /tmp/theseus-server.log 2>&1 &
PATH=/tmp/theseus-docker-shim:$PATH setsid ./target/debug/judge_worker > /tmp/theseus-worker.log 2>&1 &
```

- [ ] **Step 3: 示例运行成功（2/3）**

登录测试用户后调用（`$TOKEN` 为 token）：

```bash
curl -s -X POST localhost:3000/api/runs \
  -H "Authorization: Bearer $TOKEN" -H 'Content-Type: application/json' \
  -d '{"problem_id":1001,"language":"python","mode":"examples","code":"class Solution:\n    def twoSum(self, nums, target):\n        return [0, 1]\n"}'
```

Expected: 返回 202/`success:true` 与 `run_id`；轮询详情最终 `status=completed`、`case_passed=2`、`case_total=3`、3 条 cases 且 `matched` 分别为 true/false/true。

- [ ] **Step 4: 示例运行单例超时**

用 `time.sleep(5)` 的代码重复 Step 3。
Expected: 详情 `status=time_limit_exceeded`，`cases[0].status=timeout`，`case_total=3`（剩余用例为 timeout）。

- [ ] **Step 5: 回归自定义运行与提交隔离**

重复 P1 自定义运行请求（`mode=custom` + `input`），确认仍为 `completed`；查询 `submissions` 数量与 problems 统计前后不变。

- [ ] **Step 6: 清理测试数据与进程**

```bash
pkill -f '^./target/debug/judge_worker'
PGPASSWORD=theseus psql -h localhost -U theseus -d theseus -c "delete from code_runs;"
redis-cli --scan --pattern 'theseus:run:*' | xargs -r redis-cli del
```

保留 backend 服务运行（若会话开始时已在运行）。不要删除 `submissions` 表已有数据。

---

## Self-Review Checklist（已执行）

- Spec coverage: 比较规则（Task 1）、examples 创建/输入处理（Task 2）、逐例执行与聚合（Task 3）、种子数据（Task 4）、双 Tab/逐例 UI/通过 X/Y（Task 5）、验证（Task 6）均已覆盖。
- Placeholder scan: 无 TBD/TODO/“类似上文”占位；每个代码步骤均给出完整代码。
- Type consistency: `values_match(mode, epsilon, expected, actual)`、`RunMode`、`run(problemId, language, code, mode, input?)`、`RUN_CASE_STATUS_LABELS` 在各任务中命名一致。
