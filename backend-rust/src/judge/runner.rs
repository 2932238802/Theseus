use std::{
    path::{Path, PathBuf},
    process::Stdio,
    time::Duration,
};

use serde::Deserialize;
use serde_json::Value;
use tokio::{io::AsyncWriteExt, process::Command};

use crate::{
    common::error::AppError,
    judge::{
        harness::{cpp, java, javascript, python},
        run_config::MAX_INPUT_BYTES,
    },
    models::run::RunConfig,
};

pub const OUTPUT_LIMIT: usize = 64 * 1024;
const CONTAINER_TTL_SECONDS: u32 = 300;
const DEFAULT_MEMORY_MB: u32 = 256;
const OUTPUT_READ_LIMIT: usize = OUTPUT_LIMIT + 1;

#[derive(Debug, Clone)]
pub struct SandboxConfig {
    pub image: String,
    pub runtime: String,
    pub allow_runc: bool,
    pub memory_mb: u32,
    /// Memory headroom while compiling. The generated C++ harness pulls in
    /// `bits/stdc++.h` + nlohmann/json, which needs ~350 MB for cc1plus alone;
    /// the run-time limit is far too small for that.
    pub compile_memory_mb: u32,
    pub compile_timeout: Duration,
}

#[derive(Debug, Clone, Deserialize, Default)]
pub struct HarnessResult {
    #[serde(default)]
    pub ok: bool,
    #[serde(default)]
    pub actual: Option<Value>,
    #[serde(default)]
    pub error: Option<String>,
    #[serde(default)]
    pub runtime_ms: i32,
    #[serde(default)]
    pub memory_kb: i32,
}

#[derive(Debug, Clone, Default)]
pub struct SandboxOutcome {
    pub timed_out: bool,
    pub oom: bool,
    pub exit_code: Option<i32>,
    pub result: Option<HarnessResult>,
    pub stdout: String,
    pub stderr: String,
    pub runtime_ms: i32,
    pub memory_kb: i32,
    pub truncated: bool,
}

/// Why a batch stopped before executing every requested case.
#[derive(Debug, Clone, Copy, PartialEq, Eq, Default)]
pub enum BatchStop {
    /// Every requested case produced a complete result block.
    #[default]
    Complete,
    /// A case exited non-zero and the script was asked to stop on failure.
    CaseFailed,
    /// The in-container total budget ran out before the next case started.
    BudgetExhausted,
    /// The shell/Docker call ended unexpectedly; the task should be retried.
    Aborted,
}

/// Outcomes of one `docker exec` that may contain several test cases.
#[derive(Debug, Clone, Default)]
pub struct BatchOutcome {
    /// Complete results, in the same order as the requested cases.
    pub cases: Vec<SandboxOutcome>,
    pub stop: BatchStop,
}

pub struct Program {
    files: Vec<(&'static str, String)>,
    compile: Option<Vec<&'static str>>,
    run: Vec<&'static str>,
}

pub enum SandboxStart {
    Ready(SandboxSession),
    CompileError { output: String },
}

pub struct SandboxSession {
    container: String,
    workspace: PathBuf,
    run_command: Vec<&'static str>,
    broken: bool,
}

pub fn program_for(language: &str, code: &str, config: &RunConfig) -> Result<Program, AppError> {
    let param_types = config
        .params
        .iter()
        .map(|param| param.param_type.clone())
        .collect::<Vec<_>>();
    match language {
        "python" => Ok(Program {
            files: vec![
                (
                    "runner.py",
                    python::generate_runner(
                        &config.function_name,
                        &param_types,
                        &config.return_type,
                    ),
                ),
                ("solution.py", code.to_owned()),
            ],
            compile: None,
            run: vec!["python3", "/workspace/runner.py"],
        }),
        "javascript" => Ok(Program {
            files: vec![
                (
                    "runner.js",
                    javascript::generate_runner(
                        &config.function_name,
                        &param_types,
                        &config.return_type,
                    ),
                ),
                ("solution.js", code.to_owned()),
            ],
            compile: None,
            run: vec!["node", "/workspace/runner.js"],
        }),
        "cpp" => Ok(Program {
            files: vec![(
                "main.cpp",
                cpp::generate_main(
                    code,
                    &config.function_name,
                    &param_types,
                    &config.return_type,
                ),
            )],
            compile: Some(vec![
                "g++",
                "-O2",
                "-std=c++17",
                "-pipe",
                "-I/opt/harness",
                "-o",
                "/workspace/program",
                "/workspace/main.cpp",
            ]),
            run: vec!["/workspace/program"],
        }),
        "java" => Ok(Program {
            files: vec![(
                "Main.java",
                java::generate_main(
                    code,
                    &config.function_name,
                    &param_types,
                    &config.return_type,
                ),
            )],
            compile: Some(vec![
                "sh",
                "-c",
                "mkdir -p /workspace/classes && javac -proc:none -encoding UTF-8 -cp /opt/harness/gson.jar -d /workspace/classes /workspace/Main.java",
            ]),
            run: vec![
                "java",
                "-Xmx384m",
                "-cp",
                "/workspace/classes:/opt/harness/gson.jar",
                "Main",
            ],
        }),
        _ => Err(AppError::BadRequest("不支持的编程语言".to_owned())),
    }
}

impl SandboxSession {
    pub async fn start(
        sandbox: &SandboxConfig,
        run_id: i64,
        program: &Program,
    ) -> Result<SandboxStart, AppError> {
        if sandbox.runtime != "runsc" && !sandbox.allow_runc {
            return Err(AppError::Internal(
                "沙箱运行时必须为 runsc，拒绝回退 runc".to_owned(),
            ));
        }
        if sandbox.image.trim().is_empty() {
            return Err(AppError::Internal("未配置运行镜像".to_owned()));
        }
        let workspace = create_workspace(run_id)?;
        let container = format!("theseus-run-{run_id}-{}", random_suffix());
        let result = Self::start_inner(sandbox, &container, &workspace, program).await;
        match result {
            Ok(SandboxStart::Ready(session)) => Ok(SandboxStart::Ready(session)),
            Ok(SandboxStart::CompileError { output }) => {
                cleanup(&container, &workspace).await;
                Ok(SandboxStart::CompileError { output })
            }
            Err(error) => {
                cleanup(&container, &workspace).await;
                Err(error)
            }
        }
    }

    async fn start_inner(
        sandbox: &SandboxConfig,
        container: &str,
        workspace: &Path,
        program: &Program,
    ) -> Result<SandboxStart, AppError> {
        for (name, content) in &program.files {
            std::fs::write(workspace.join(name), content)
                .map_err(|error| AppError::Internal(format!("写入运行文件失败: {error}")))?;
        }
        start_container(sandbox, container, program.compile.is_some()).await?;
        verify_runtime(sandbox, container).await?;
        if let Some(compile) = program.compile.as_ref() {
            let started = std::time::Instant::now();
            // 单文件语言（C++ / Java）把源码从 stdin 直接喂给编译命令，
            // 省掉一次进入 gVisor 沙箱的 docker exec。
            let (success, output) = match program.files.as_slice() {
                [(name, _)] => {
                    let script = compile_script(name, compile);
                    let source = workspace.join(name);
                    exec_capture_with_stdin(container, &script, &source, sandbox.compile_timeout)
                        .await?
                }
                files => {
                    for (name, _) in files {
                        write_to_container(workspace, container, name).await?;
                    }
                    exec_capture(container, compile, sandbox.compile_timeout).await?
                }
            };
            let elapsed_ms = started.elapsed().as_millis().min(u64::MAX as u128) as u64;
            if success {
                tracing::info!(container, elapsed_ms, "sandbox compile finished");
            } else {
                tracing::warn!(container, elapsed_ms, "sandbox compile failed");
            }
            if !success {
                return Ok(SandboxStart::CompileError { output });
            }
            // Compilation is the only step that needs the larger budget; restore
            // the strict run-time limit before executing any test case.
            apply_memory_limit(container, run_memory_mb(sandbox)).await;
        } else {
            for (name, _) in &program.files {
                write_to_container(workspace, container, name).await?;
            }
        }
        Ok(SandboxStart::Ready(Self {
            container: container.to_owned(),
            workspace: workspace.to_path_buf(),
            run_command: program.run.clone(),
            broken: false,
        }))
    }

    /// 在一次 `docker exec` 中顺序执行多个用例。
    ///
    /// 容器内脚本先把 stdin 里的 JSONL 写到 `/workspace/cases.jsonl`，再逐条
    /// 写入 `case.json`、带超时执行，并用随机标记回传 result/stdout/stderr。
    /// `stop_on_failure` 为真时，某个用例退出码非 0 就提前结束（提交判题）；
    /// 为假时继续执行剩余用例（运行示例，用户希望看到所有用例的结果）。
    pub async fn run_cases(
        &mut self,
        cases: &[Vec<Value>],
        per_case_timeout: Duration,
        total_budget: Duration,
        stop_on_failure: bool,
    ) -> Result<BatchOutcome, AppError> {
        if self.broken {
            return Ok(BatchOutcome {
                cases: Vec::new(),
                stop: BatchStop::Aborted,
            });
        }
        if cases.is_empty() {
            return Ok(BatchOutcome::default());
        }
        if total_budget.is_zero() {
            return Ok(BatchOutcome {
                cases: Vec::new(),
                stop: BatchStop::BudgetExhausted,
            });
        }

        // 每个用例一行紧凑 JSON；解析端按行读取，不会把多个数组混在一起。
        let mut payload = Vec::new();
        for args in cases {
            let line = serde_json::to_vec(args)
                .map_err(|error| AppError::Internal(format!("序列化运行参数失败: {error}")))?;
            if line.len() > MAX_INPUT_BYTES {
                return Err(AppError::BadRequest("自定义输入不能超过 64 KB".to_owned()));
            }
            payload.extend_from_slice(&line);
            payload.push(b'\n');
        }

        let tag = random_suffix();
        let script = batch_case_script(
            &self.run_command,
            per_case_timeout.as_secs().max(1),
            total_budget.as_secs().max(1),
            stop_on_failure,
            &tag,
        );
        let mut command = Command::new("docker");
        command
            .args([
                "exec",
                "-i",
                "--user",
                "65534:65534",
                &self.container,
                "sh",
                "-c",
                &script,
            ])
            .stdin(Stdio::piped())
            .stdout(Stdio::piped())
            .stderr(Stdio::null())
            .kill_on_drop(true);
        // 容器内脚本自带总预算；这里多留 10 秒只作为 Docker 卡死的保险。
        let host_timeout = total_budget + Duration::from_secs(10);
        let mut child = command
            .spawn()
            .map_err(|error| AppError::Internal(format!("沙箱执行进程启动失败: {error}")))?;
        if let Some(mut stdin) = child.stdin.take() {
            // 50 个用例最多约 3 MB，给足 30 秒避免写入被误判超时。
            match tokio::time::timeout(Duration::from_secs(30), stdin.write_all(&payload)).await {
                Ok(Ok(())) => {}
                Ok(Err(error)) => {
                    let _ = child.kill().await;
                    return Err(AppError::Internal(format!("写入运行参数失败: {error}")));
                }
                Err(_) => {
                    let _ = child.kill().await;
                    return Err(AppError::Internal("写入运行参数超时".to_owned()));
                }
            }
        }
        let stdout = match tokio::time::timeout(host_timeout, child.wait_with_output()).await {
            Ok(Ok(output)) => String::from_utf8_lossy(&output.stdout).into_owned(),
            Ok(Err(error)) => {
                return Err(AppError::Internal(format!("沙箱执行进程启动失败: {error}")));
            }
            Err(_) => {
                kill_container(&self.container).await;
                self.broken = true;
                return Ok(BatchOutcome {
                    cases: Vec::new(),
                    stop: BatchStop::Aborted,
                });
            }
        };

        let parsed = parse_cases_output(&stdout, &tag, cases.len());
        // 退出码 137 既可能是 timeout -s KILL，也可能是 cgroup OOM；只有
        // 容器确实 OOMKilled 时才标记为内存超限，且整批只 inspect 一次。
        let killed_by_signal = parsed.iter().any(|case| case.exit_code == Some(137));
        let oom = killed_by_signal && container_oom_killed(&self.container).await;
        let outcomes = parsed
            .iter()
            .map(|case| build_outcome(case, oom))
            .collect::<Vec<_>>();
        let budget_exhausted = stdout.contains(&budget_marker(&tag));
        let stop = if stop_on_failure && parsed.last().is_some_and(|case| case.exit_code != Some(0))
        {
            BatchStop::CaseFailed
        } else if parsed.len() == cases.len() {
            BatchStop::Complete
        } else if budget_exhausted {
            BatchStop::BudgetExhausted
        } else {
            BatchStop::Aborted
        };
        Ok(BatchOutcome {
            cases: outcomes,
            stop,
        })
    }

    pub async fn shutdown(self) {
        cleanup(&self.container, &self.workspace).await;
    }
}

async fn cleanup(container: &str, workspace: &Path) {
    remove_container(container).await;
    if let Err(error) = std::fs::remove_dir_all(workspace) {
        tracing::warn!(path = %workspace.display(), error = %error, "failed to remove run workspace");
    }
}

async fn exec_capture(
    container: &str,
    command: &[&str],
    timeout: Duration,
) -> Result<(bool, String), AppError> {
    let mut process = Command::new("docker");
    process
        .args(["exec", "--user", "65534:65534", container])
        .args(command)
        .stdin(Stdio::null())
        .stdout(Stdio::piped())
        .stderr(Stdio::piped());
    run_compile(process, timeout).await
}

/// 把源码文件作为 stdin 交给容器内的 `cat > 文件 && 编译命令`，
/// 使「写入源码 + 编译」只占一次 docker exec。
async fn exec_capture_with_stdin(
    container: &str,
    script: &str,
    source: &Path,
    timeout: Duration,
) -> Result<(bool, String), AppError> {
    let stdin = std::fs::File::open(source)
        .map_err(|error| AppError::Internal(format!("打开运行文件失败: {error}")))?;
    let mut process = Command::new("docker");
    process
        .args([
            "exec",
            "-i",
            "--user",
            "65534:65534",
            container,
            "sh",
            "-c",
            script,
        ])
        .stdin(Stdio::from(stdin))
        .stdout(Stdio::piped())
        .stderr(Stdio::piped());
    run_compile(process, timeout).await
}

async fn run_compile(mut process: Command, timeout: Duration) -> Result<(bool, String), AppError> {
    match tokio::time::timeout(timeout, process.output()).await {
        Ok(Ok(output)) => {
            let mut text = String::from_utf8_lossy(&output.stdout).into_owned();
            text.push_str(&String::from_utf8_lossy(&output.stderr));
            let (text, _) = truncate_output(&text);
            Ok((output.status.success(), text))
        }
        Ok(Err(error)) => Err(AppError::Internal(format!("沙箱编译进程启动失败: {error}"))),
        Err(_) => Ok((false, format!("编译超时（{} 秒）", timeout.as_secs()))),
    }
}

async fn start_container(
    sandbox: &SandboxConfig,
    container: &str,
    needs_compile: bool,
) -> Result<(), AppError> {
    let memory_mb = if needs_compile {
        compile_memory_mb(sandbox)
    } else {
        run_memory_mb(sandbox)
    };
    let mut command = Command::new("docker");
    command.args(["run", "-d", "--name", container]);
    if !sandbox.runtime.trim().is_empty() {
        command.args(["--runtime", &sandbox.runtime]);
    }
    command.args([
        "--network=none",
        "--read-only",
        "--tmpfs",
        "/workspace:rw,exec,size=128m,mode=1777",
        "--tmpfs",
        "/tmp:rw,exec,size=32m",
        "--user",
        "65534:65534",
        "--cap-drop=ALL",
        "--security-opt=no-new-privileges",
        "--pids-limit=64",
        &format!("--memory={memory_mb}m"),
        &format!("--memory-swap={memory_mb}m"),
        "--cpus=1",
        "--ulimit",
        "nofile=64:64",
        "--env",
        "HOME=/tmp",
        &sandbox.image,
        "sh",
        "-c",
        &format!("sleep {CONTAINER_TTL_SECONDS}"),
    ]);
    let output = command
        .output()
        .await
        .map_err(|error| AppError::Internal(format!("启动沙箱失败: {error}")))?;
    if !output.status.success() {
        return Err(AppError::Internal(format!(
            "启动沙箱失败: {}",
            String::from_utf8_lossy(&output.stderr).trim()
        )));
    }
    Ok(())
}

fn run_memory_mb(sandbox: &SandboxConfig) -> u32 {
    if sandbox.memory_mb == 0 {
        DEFAULT_MEMORY_MB
    } else {
        sandbox.memory_mb
    }
}

fn compile_memory_mb(sandbox: &SandboxConfig) -> u32 {
    sandbox.compile_memory_mb.max(run_memory_mb(sandbox))
}

/// Lowers the container's memory limit back to the run-time budget once the
/// compile step has finished. A failure is not fatal: the sandbox keeps the
/// (looser) compile budget, which is still bounded but weakens memory-limit
/// enforcement for the submitted code.
async fn apply_memory_limit(container: &str, memory_mb: u32) {
    let limit = format!("{memory_mb}m");
    let result = Command::new("docker")
        .args([
            "update",
            &format!("--memory={limit}"),
            &format!("--memory-swap={limit}"),
            container,
        ])
        .output()
        .await;
    match result {
        Ok(output) if output.status.success() => {}
        Ok(output) => tracing::warn!(
            container,
            error = %String::from_utf8_lossy(&output.stderr).trim(),
            "failed to lower sandbox memory limit after compile"
        ),
        Err(error) => tracing::warn!(
            container,
            error = %error,
            "failed to lower sandbox memory limit after compile"
        ),
    }
}

async fn verify_runtime(sandbox: &SandboxConfig, container: &str) -> Result<(), AppError> {
    let output = Command::new("docker")
        .args(["inspect", "--format", "{{.HostConfig.Runtime}}", container])
        .output()
        .await
        .map_err(|error| AppError::Internal(format!("检查沙箱运行时失败: {error}")))?;
    let runtime = String::from_utf8_lossy(&output.stdout).trim().to_owned();
    let effective = if runtime.is_empty() {
        "runc".to_owned()
    } else {
        runtime
    };
    if sandbox.runtime == "runsc" && effective != "runsc" {
        return Err(AppError::Internal(
            "沙箱运行时未启用 runsc，已拒绝执行".to_owned(),
        ));
    }
    Ok(())
}

/// Injects a file into the sandbox through `docker exec` instead of `docker cp`.
///
/// `docker cp` cannot be used here: the sandbox rootfs is read-only and the
/// only writable path is a `--tmpfs` mount. Docker's `checkWritablePath` only
/// inspects `-v`/`--mount` mounts (`HostConfig.Tmpfs` is tracked separately),
/// so cp is rejected with "container rootfs is marked read-only". Docker 28+
/// also gives every cp call a private mount namespace with its own tmpfs, so
/// even without `--read-only` the written file would be invisible to the
/// container's processes.
async fn write_to_container(workspace: &Path, container: &str, file: &str) -> Result<(), AppError> {
    let source = workspace.join(file);
    let stdin = std::fs::File::open(&source)
        .map_err(|error| AppError::Internal(format!("打开运行文件失败: {error}")))?;
    let output = Command::new("docker")
        .args(["exec", "-i", "--user", "65534:65534", container, "sh", "-c"])
        .arg(format!("cat > /workspace/{file}"))
        .stdin(Stdio::from(stdin))
        .stdout(Stdio::null())
        .stderr(Stdio::piped())
        .output()
        .await
        .map_err(|error| AppError::Internal(format!("注入沙箱文件失败: {error}")))?;
    if !output.status.success() {
        return Err(AppError::Internal(format!(
            "注入沙箱文件失败: {}",
            String::from_utf8_lossy(&output.stderr).trim()
        )));
    }
    Ok(())
}

async fn container_oom_killed(container: &str) -> bool {
    Command::new("docker")
        .args(["inspect", "--format", "{{.State.OOMKilled}}", container])
        .output()
        .await
        .ok()
        .is_some_and(|output| {
            String::from_utf8_lossy(&output.stdout)
                .trim()
                .eq_ignore_ascii_case("true")
        })
}

/// 多个用例的容器内脚本：整批参数从 stdin 一次落盘，循环里逐条执行。
///
/// 每条用例用带下标的一次性标记回传，调用方据此把结果对回原下标；退出码
/// 非 0 时是否继续由 `stop_on_failure` 决定。总预算用 `date +%s` 控制，
/// 预算耗尽时输出 `BUDGET_EXHAUSTED` 标记并停止。
fn batch_case_script(
    run_command: &[&str],
    per_case_secs: u64,
    budget_secs: u64,
    stop_on_failure: bool,
    tag: &str,
) -> String {
    let command = run_command
        .iter()
        .map(|part| shell_quote(part))
        .collect::<Vec<_>>()
        .join(" ");
    let break_on_failure = if stop_on_failure { "break" } else { ":" };
    format!(
        "cat > /workspace/cases.jsonl || exit 1; \
         i=0; \
         deadline=$(( $(date +%s) + {budget_secs} )); \
         while IFS= read -r line; do \
           [ -z \"$line\" ] && continue; \
           i=$((i+1)); \
           now=$(date +%s); \
           remaining=$((deadline - now)); \
           if [ \"$remaining\" -le 0 ]; then \
             printf '%s' \"__THESEUS_{tag}_BUDGET_EXHAUSTED__\"; \
             break; \
           fi; \
           case_seconds={per_case_secs}; \
           if [ \"$case_seconds\" -gt \"$remaining\" ]; then case_seconds=$remaining; fi; \
           printf '%s' \"$line\" > /workspace/case.json; \
           rm -f /workspace/result.json /workspace/stdout.txt /workspace/stderr.txt; \
           timeout -s KILL \"$case_seconds\" {command} < /dev/null; status=$?; \
           printf '%s' \"__THESEUS_{tag}_CASE_${{i}}_RESULT__\"; cat /workspace/result.json 2>/dev/null; \
           printf '%s' \"__THESEUS_{tag}_CASE_${{i}}_STDOUT__\"; head -c {OUTPUT_READ_LIMIT} /workspace/stdout.txt 2>/dev/null; \
           printf '%s' \"__THESEUS_{tag}_CASE_${{i}}_STDERR__\"; head -c {OUTPUT_READ_LIMIT} /workspace/stderr.txt 2>/dev/null; \
           printf '%s' \"__THESEUS_{tag}_CASE_${{i}}_EXIT__\"; printf '%s' \"$status\"; \
           printf '%s' \"__THESEUS_{tag}_CASE_${{i}}_END__\"; \
           if [ \"$status\" -ne 0 ]; then {break_on_failure}; fi; \
         done < /workspace/cases.jsonl"
    )
}

fn shell_quote(value: &str) -> String {
    format!("'{}'", value.replace('\'', "'\\''"))
}

/// 容器内的编译脚本：先从 stdin 落盘源码，再执行编译命令。
/// 只有 `cat` 成功时才编译，退出码取编译命令的退出码。
fn compile_script(file: &str, compile: &[&str]) -> String {
    let command = compile
        .iter()
        .map(|part| shell_quote(part))
        .collect::<Vec<_>>()
        .join(" ");
    format!("cat > /workspace/{file} && {command}")
}

#[derive(Debug, Clone, Default)]
struct ParsedCase {
    result: Option<HarnessResult>,
    stdout: String,
    stderr: String,
    exit_code: Option<i32>,
}

fn case_marker(tag: &str, index: usize, kind: &str) -> String {
    format!("__THESEUS_{tag}_CASE_{index}_{kind}__")
}

fn budget_marker(tag: &str) -> String {
    format!("__THESEUS_{tag}_BUDGET_EXHAUSTED__")
}

/// 按下标解析批量输出；某个用例的标记不完整时立即停止，后面的用例视为未执行。
fn parse_cases_output(text: &str, tag: &str, expected: usize) -> Vec<ParsedCase> {
    let mut parsed = Vec::with_capacity(expected);
    let mut cursor = text;
    for index in 1..=expected {
        let result_marker = case_marker(tag, index, "RESULT");
        let Some((_, rest)) = cursor.split_once(&result_marker) else {
            break;
        };
        let stdout_marker = case_marker(tag, index, "STDOUT");
        let stderr_marker = case_marker(tag, index, "STDERR");
        let exit_marker = case_marker(tag, index, "EXIT");
        let end_marker = case_marker(tag, index, "END");
        let Some((result_raw, rest)) = rest.split_once(&stdout_marker) else {
            break;
        };
        let Some((stdout_raw, rest)) = rest.split_once(&stderr_marker) else {
            break;
        };
        let Some((stderr_raw, rest)) = rest.split_once(&exit_marker) else {
            break;
        };
        let Some((exit_raw, rest)) = rest.split_once(&end_marker) else {
            break;
        };
        parsed.push(ParsedCase {
            result: serde_json::from_str(result_raw.trim()).ok(),
            stdout: stdout_raw.to_owned(),
            stderr: stderr_raw.to_owned(),
            exit_code: exit_raw.trim().parse().ok(),
        });
        cursor = rest;
    }
    parsed
}

fn build_outcome(case: &ParsedCase, oom: bool) -> SandboxOutcome {
    let (stdout, stdout_truncated) = truncate_output(&case.stdout);
    let (stderr, stderr_truncated) = truncate_output(&case.stderr);
    if oom && case.exit_code == Some(137) {
        return SandboxOutcome {
            oom: true,
            exit_code: case.exit_code,
            stdout,
            stderr,
            truncated: stdout_truncated || stderr_truncated,
            ..SandboxOutcome::default()
        };
    }
    if matches!(case.exit_code, Some(124) | Some(137)) {
        return SandboxOutcome {
            timed_out: true,
            exit_code: case.exit_code,
            stdout,
            stderr,
            truncated: stdout_truncated || stderr_truncated,
            ..SandboxOutcome::default()
        };
    }
    let memory_kb = case
        .result
        .as_ref()
        .map(|result| result.memory_kb.max(0))
        .unwrap_or_default();
    SandboxOutcome {
        timed_out: false,
        oom: false,
        exit_code: case.exit_code,
        result: case.result.clone(),
        stdout,
        stderr,
        runtime_ms: 0,
        memory_kb,
        truncated: stdout_truncated || stderr_truncated,
    }
}

async fn kill_container(container: &str) {
    let _ = Command::new("docker")
        .args(["kill", container])
        .output()
        .await;
}

async fn remove_container(container: &str) {
    let _ = Command::new("docker")
        .args(["rm", "-f", "-v", container])
        .output()
        .await;
}

fn create_workspace(run_id: i64) -> Result<PathBuf, AppError> {
    let workspace = std::env::temp_dir().join(format!("theseus-run-{run_id}-{}", random_suffix()));
    std::fs::create_dir_all(&workspace)
        .map_err(|error| AppError::Internal(format!("创建运行目录失败: {error}")))?;
    Ok(workspace)
}

fn random_suffix() -> String {
    format!("{:016x}", rand::random::<u64>())
}

pub fn truncate_output(value: &str) -> (String, bool) {
    if value.len() <= OUTPUT_LIMIT {
        return (value.to_owned(), false);
    }
    let mut end = OUTPUT_LIMIT;
    while end > 0 && !value.is_char_boundary(end) {
        end -= 1;
    }
    (format!("{}\n...[truncated]", &value[..end]), true)
}

#[cfg(test)]
mod tests {
    use serde_json::json;

    use super::{
        batch_case_script, compile_script, parse_cases_output, program_for, truncate_output,
    };
    use crate::judge::run_config::validate_run_config;

    fn config() -> crate::models::run::RunConfig {
        validate_run_config(&json!({
            "version": 1,
            "function_name": "twoSum",
            "params": [
                { "name": "nums", "type": "int[]" },
                { "name": "target", "type": "int" }
            ],
            "return_type": "int[]",
            "compare": { "mode": "exact" },
            "public_cases": []
        }))
        .expect("config should be valid")
    }

    #[test]
    fn builds_programs_for_every_language() {
        let config = config();
        let python = program_for("python", "class Solution: pass", &config).expect("python");
        assert_eq!(python.files.len(), 2);
        assert!(python.compile.is_none());

        let javascript =
            program_for("javascript", "var twoSum = function() {};", &config).expect("javascript");
        assert_eq!(javascript.files.len(), 2);

        let cpp = program_for("cpp", "class Solution {};", &config).expect("cpp");
        assert_eq!(cpp.files[0].0, "main.cpp");
        assert!(cpp.compile.is_some());

        let java = program_for("java", "class Solution {}", &config).expect("java");
        assert_eq!(java.files[0].0, "Main.java");
        assert!(java.compile.is_some());

        assert!(program_for("ruby", "", &config).is_err());
    }

    #[test]
    fn truncates_long_output_on_char_boundary() {
        let long = "汉".repeat(30_000);
        let (truncated, was_truncated) = truncate_output(&long);
        assert!(was_truncated);
        assert!(truncated.ends_with("...[truncated]"));
        assert!(truncated.len() <= 64 * 1024 + 32);
    }

    #[test]
    fn leaves_short_output_untouched() {
        let (value, truncated) = truncate_output("hello");
        assert_eq!(value, "hello");
        assert!(!truncated);
    }

    #[test]
    fn batch_script_runs_every_case_in_one_exec() {
        let script = batch_case_script(&["java", "-cp", "/a:/b", "Main"], 2, 10, true, "tag1");
        assert!(script.contains("cat > /workspace/cases.jsonl"));
        assert!(script.contains("while IFS= read -r line"));
        assert!(script.contains("'java' '-cp' '/a:/b' 'Main' < /dev/null"));
        assert!(script.contains("__THESEUS_tag1_CASE_${i}_RESULT__"));
        assert!(script.contains("__THESEUS_tag1_BUDGET_EXHAUSTED__"));
        assert!(script.contains("done < /workspace/cases.jsonl"));
        assert!(script.contains("if [ \"$status\" -ne 0 ]; then break; fi"));
    }

    #[test]
    fn batch_script_continues_after_failure_when_requested() {
        let script = batch_case_script(&["python3", "/workspace/main.py"], 2, 10, false, "tag1");
        assert!(script.contains("if [ \"$status\" -ne 0 ]; then :; fi"));
    }

    #[test]
    fn batch_script_executes_cases_and_stops_on_failure() {
        use std::io::Write;
        use std::process::{Command, Stdio};

        let workspace =
            std::env::temp_dir().join(format!("theseus-batch-test-{}", super::random_suffix()));
        std::fs::create_dir_all(&workspace).expect("workspace should be created");
        let ws = workspace.display().to_string();
        // 模拟 harness：读 case.json，写 result/stdout/stderr；含 "fail" 的用例退出 3。
        let fake = format!(
            "cat {ws}/case.json > {ws}/stdout.txt; \
             printf '%s' '{{\"ok\":true,\"actual\":1,\"runtime_ms\":1,\"memory_kb\":2}}' > {ws}/result.json; \
             printf '%s' 'boom' > {ws}/stderr.txt; \
             grep -q fail {ws}/case.json && exit 3; exit 0"
        );
        let run_command = ["sh", "-c", fake.as_str()];
        let payload = "[[1,2]]\n[\"fail\"]\n[[3,4]]\n";

        for (stop_on_failure, expected) in [(true, 2usize), (false, 3usize)] {
            let script = batch_case_script(&run_command, 2, 10, stop_on_failure, "tag1")
                .replace("/workspace", &ws);
            let mut child = Command::new("sh")
                .args(["-c", &script])
                .stdin(Stdio::piped())
                .stdout(Stdio::piped())
                .spawn()
                .expect("batch script should spawn");
            child
                .stdin
                .take()
                .expect("stdin should be piped")
                .write_all(payload.as_bytes())
                .expect("payload should be writable");
            let output = child.wait_with_output().expect("batch script should exit");
            let text = String::from_utf8_lossy(&output.stdout);
            let parsed = parse_cases_output(&text, "tag1", 3);
            assert_eq!(parsed.len(), expected, "script: {script}\noutput: {text}");
            assert_eq!(parsed[0].exit_code, Some(0));
            assert!(parsed[0].result.as_ref().is_some_and(|result| result.ok));
            assert_eq!(parsed[0].stderr, "boom");
            if stop_on_failure {
                assert_eq!(parsed[1].exit_code, Some(3));
            }
        }
        let _ = std::fs::remove_dir_all(&workspace);
    }

    #[test]
    fn batch_script_is_valid_shell() {
        use std::io::Write;
        use std::process::{Command, Stdio};

        for stop_on_failure in [true, false] {
            let script = batch_case_script(
                &["java", "-cp", "/a:/b", "Main"],
                2,
                10,
                stop_on_failure,
                "tag1",
            );
            let mut child = Command::new("sh")
                .arg("-n")
                .stdin(Stdio::piped())
                .spawn()
                .expect("sh should be available");
            child
                .stdin
                .take()
                .expect("stdin should be piped")
                .write_all(script.as_bytes())
                .expect("script should be writable");
            assert!(
                child.wait().expect("sh should exit").success(),
                "generated script is not valid shell: {script}"
            );
        }
    }

    #[test]
    fn compile_script_injects_source_through_stdin() {
        let script = compile_script("main.cpp", &["g++", "-O2", "-o", "/workspace/program"]);
        assert!(script.starts_with("cat > /workspace/main.cpp && "));
        assert!(script.contains("'g++' '-O2' '-o' '/workspace/program'"));
    }

    #[test]
    fn parses_multiple_case_blocks() {
        let tag = "tag1";
        let text = format!(
            "__THESEUS_{tag}_CASE_1_RESULT__{{\"ok\":true,\"actual\":42,\"runtime_ms\":1,\"memory_kb\":2048}}\
             __THESEUS_{tag}_CASE_1_STDOUT__hello\n\
             __THESEUS_{tag}_CASE_1_STDERR__oops\
             __THESEUS_{tag}_CASE_1_EXIT__0\
             __THESEUS_{tag}_CASE_1_END__\
             __THESEUS_{tag}_CASE_2_RESULT__\
             __THESEUS_{tag}_CASE_2_STDOUT__\
             __THESEUS_{tag}_CASE_2_STDERR__boom\
             __THESEUS_{tag}_CASE_2_EXIT__1\
             __THESEUS_{tag}_CASE_2_END__"
        );
        let parsed = parse_cases_output(&text, tag, 3);
        assert_eq!(parsed.len(), 2);
        assert_eq!(parsed[0].exit_code, Some(0));
        assert!(parsed[0].result.as_ref().is_some_and(|result| result.ok));
        assert_eq!(parsed[0].stdout, "hello\n");
        assert_eq!(parsed[0].stderr, "oops");
        assert_eq!(parsed[1].exit_code, Some(1));
        assert!(parsed[1].result.is_none());
        assert_eq!(parsed[1].stderr, "boom");
    }

    #[test]
    fn stops_parsing_at_first_incomplete_case() {
        let tag = "tag1";
        let text = format!(
            "__THESEUS_{tag}_CASE_1_RESULT__{{\"ok\":true}}\
             __THESEUS_{tag}_CASE_1_STDOUT__\
             __THESEUS_{tag}_CASE_1_STDERR__\
             __THESEUS_{tag}_CASE_1_EXIT__0\
             __THESEUS_{tag}_CASE_1_END__\
             __THESEUS_{tag}_CASE_2_RESULT__{{\"ok\":true}}"
        );
        let parsed = parse_cases_output(&text, tag, 2);
        assert_eq!(parsed.len(), 1);
    }

    #[test]
    fn missing_markers_produce_no_cases() {
        assert!(parse_cases_output("no markers here", "tag1", 2).is_empty());
    }
}
