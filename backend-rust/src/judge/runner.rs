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

    pub async fn run_case(
        &mut self,
        args: &[Value],
        timeout: Duration,
    ) -> Result<SandboxOutcome, AppError> {
        if self.broken {
            return Ok(SandboxOutcome {
                timed_out: true,
                ..SandboxOutcome::default()
            });
        }
        let case = serde_json::to_vec(args)
            .map_err(|error| AppError::Internal(format!("序列化运行参数失败: {error}")))?;
        if case.len() > MAX_INPUT_BYTES {
            return Err(AppError::BadRequest("自定义输入不能超过 64 KB".to_owned()));
        }

        // 一次 docker exec 完成：写入参数、执行、回传结果与输出。
        // 每个用例只付一次容器调用开销，避免逐文件注入/读取把判题拖到数秒。
        let seconds = timeout.as_secs_f64().max(0.1);
        let tag = random_suffix();
        let script = case_script(&self.run_command, seconds, &tag);
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
        let host_timeout = timeout + Duration::from_secs(3);
        let started = std::time::Instant::now();
        let mut child = command
            .spawn()
            .map_err(|error| AppError::Internal(format!("沙箱执行进程启动失败: {error}")))?;
        if let Some(mut stdin) = child.stdin.take() {
            // 参数最多 64 KB，写入应当瞬间完成；加超时避免 dockerd 卡住时
            // 调用方无限等待。
            match tokio::time::timeout(Duration::from_secs(5), stdin.write_all(&case)).await {
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
        let (timed_out, stdout, exit_code) =
            match tokio::time::timeout(host_timeout, child.wait_with_output()).await {
                Ok(Ok(output)) => (
                    false,
                    String::from_utf8_lossy(&output.stdout).into_owned(),
                    output.status.code(),
                ),
                Ok(Err(error)) => {
                    return Err(AppError::Internal(format!("沙箱执行进程启动失败: {error}")));
                }
                Err(_) => {
                    kill_container(&self.container).await;
                    self.broken = true;
                    (true, String::new(), None)
                }
            };
        let wall_ms = started.elapsed().as_millis().min(i32::MAX as u128) as i32;
        if timed_out {
            return Ok(SandboxOutcome {
                timed_out: true,
                exit_code,
                runtime_ms: wall_ms,
                ..SandboxOutcome::default()
            });
        }

        // OOMKilled 只在退出码为 137 时检查，正常用例不再额外 docker inspect。
        let oom = exit_code == Some(137) && container_oom_killed(&self.container).await;
        if oom {
            return Ok(SandboxOutcome {
                oom: true,
                exit_code,
                runtime_ms: wall_ms,
                ..SandboxOutcome::default()
            });
        }
        if matches!(exit_code, Some(137) | Some(124)) {
            return Ok(SandboxOutcome {
                timed_out: true,
                exit_code,
                runtime_ms: wall_ms,
                ..SandboxOutcome::default()
            });
        }

        let (result, raw_stdout, raw_stderr) = parse_case_output(&stdout, &tag);
        let memory_kb = result
            .as_ref()
            .map(|value| value.memory_kb.max(0))
            .unwrap_or_default();
        let (stdout, stdout_truncated) = truncate_output(&raw_stdout);
        let (stderr, stderr_truncated) = truncate_output(&raw_stderr);

        Ok(SandboxOutcome {
            timed_out: false,
            oom: false,
            exit_code,
            result,
            stdout,
            stderr,
            runtime_ms: wall_ms,
            memory_kb,
            truncated: stdout_truncated || stderr_truncated,
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

/// 单个用例的容器内脚本：清理旧输出、从 stdin 写入参数、带超时执行，
/// 再用一次性标记把结果、stdout、stderr 一起回传。
fn case_script(run_command: &[&str], seconds: f64, tag: &str) -> String {
    let deadline = format!("{seconds:.3}");
    let command = run_command
        .iter()
        .map(|part| shell_quote(part))
        .collect::<Vec<_>>()
        .join(" ");
    format!(
        "rm -f /workspace/result.json /workspace/stdout.txt /workspace/stderr.txt; \
         cat > /workspace/case.json; \
         timeout -s KILL {deadline} {command}; status=$?; \
         printf '%s' '__THESEUS_{tag}_RESULT__'; cat /workspace/result.json 2>/dev/null; \
         printf '%s' '__THESEUS_{tag}_STDOUT__'; head -c {OUTPUT_READ_LIMIT} /workspace/stdout.txt 2>/dev/null; \
         printf '%s' '__THESEUS_{tag}_STDERR__'; head -c {OUTPUT_READ_LIMIT} /workspace/stderr.txt 2>/dev/null; \
         exit $status"
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

fn parse_case_output(text: &str, tag: &str) -> (Option<HarnessResult>, String, String) {
    let result_marker = format!("__THESEUS_{tag}_RESULT__");
    let stdout_marker = format!("__THESEUS_{tag}_STDOUT__");
    let stderr_marker = format!("__THESEUS_{tag}_STDERR__");
    let Some((_, rest)) = text.split_once(&result_marker) else {
        return (None, String::new(), String::new());
    };
    let (result_raw, rest) = rest.split_once(&stdout_marker).unwrap_or((rest, ""));
    let (stdout_raw, stderr_raw) = rest.split_once(&stderr_marker).unwrap_or((rest, ""));
    let result = serde_json::from_str::<HarnessResult>(result_raw.trim()).ok();
    (result, stdout_raw.to_owned(), stderr_raw.to_owned())
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

    use super::{case_script, compile_script, parse_case_output, program_for, truncate_output};
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
    fn quotes_run_command_in_case_script() {
        let script = case_script(&["java", "-cp", "/a:/b", "Main"], 2.0, "tag1");
        assert!(script.contains("timeout -s KILL 2.000 'java' '-cp' '/a:/b' 'Main'"));
        assert!(script.contains("__THESEUS_tag1_RESULT__"));
        assert!(script.contains("cat > /workspace/case.json"));
    }

    #[test]
    fn compile_script_injects_source_through_stdin() {
        let script = compile_script("main.cpp", &["g++", "-O2", "-o", "/workspace/program"]);
        assert!(script.starts_with("cat > /workspace/main.cpp && "));
        assert!(script.contains("'g++' '-O2' '-o' '/workspace/program'"));
    }

    #[test]
    fn parses_result_stdout_and_stderr() {
        let tag = "tag1";
        let text = format!(
            "__THESEUS_{tag}_RESULT__{{\"ok\":true,\"actual\":42,\"runtime_ms\":1,\"memory_kb\":2048}}\
             __THESEUS_{tag}_STDOUT__hello\n\
             __THESEUS_{tag}_STDERR__oops"
        );
        let (result, stdout, stderr) = parse_case_output(&text, tag);
        let result = result.expect("result should parse");
        assert!(result.ok);
        assert_eq!(stdout, "hello\n");
        assert_eq!(stderr, "oops");
    }

    #[test]
    fn missing_result_marker_returns_empty_output() {
        let (result, stdout, stderr) = parse_case_output("no markers here", "tag1");
        assert!(result.is_none());
        assert!(stdout.is_empty());
        assert!(stderr.is_empty());
    }
}
