use std::{
    path::{Path, PathBuf},
    process::Stdio,
    time::Duration,
};

use serde::Deserialize;
use serde_json::Value;
use tokio::process::Command;

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
                "mkdir -p /workspace/classes && javac -encoding UTF-8 -cp /opt/harness/gson.jar -d /workspace/classes /workspace/Main.java",
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
        for (name, _) in &program.files {
            write_to_container(workspace, container, name).await?;
        }
        if let Some(compile) = program.compile.as_ref() {
            let started = std::time::Instant::now();
            let (success, output) =
                exec_capture(container, compile, sandbox.compile_timeout).await?;
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
        std::fs::write(self.workspace.join("case.json"), case)
            .map_err(|error| AppError::Internal(format!("写入运行参数失败: {error}")))?;
        clear_outputs(&self.container).await;
        write_to_container(&self.workspace, &self.container, "case.json").await?;

        let seconds = timeout.as_secs_f64().max(0.1);
        let deadline = format!("{seconds:.3}");
        let mut command = Command::new("docker");
        command
            .args(["exec", "--user", "65534:65534", &self.container])
            .args(["timeout", "-s", "KILL", &deadline])
            .args(&self.run_command)
            .stdin(Stdio::null())
            .stdout(Stdio::null())
            .stderr(Stdio::null());
        let host_timeout = timeout + Duration::from_secs(3);
        let started = std::time::Instant::now();
        let (timed_out, exit_code) =
            match tokio::time::timeout(host_timeout, command.output()).await {
                Ok(Ok(output)) => (false, output.status.code()),
                Ok(Err(error)) => {
                    return Err(AppError::Internal(format!("沙箱执行进程启动失败: {error}")));
                }
                Err(_) => {
                    kill_container(&self.container).await;
                    self.broken = true;
                    (true, None)
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

        let oom = container_oom_killed(&self.container).await;
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

        let result = read_result_file(&self.container).await;
        let memory_kb = result
            .as_ref()
            .map(|value| value.memory_kb.max(0))
            .unwrap_or_default();
        let (raw_stdout, stdout_truncated) = read_output_file(&self.container, "stdout.txt").await;
        let (raw_stderr, stderr_truncated) = read_output_file(&self.container, "stderr.txt").await;

        Ok(SandboxOutcome {
            timed_out: false,
            oom: false,
            exit_code,
            result,
            stdout: raw_stdout,
            stderr: raw_stderr,
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
    match tokio::time::timeout(timeout, process.output()).await {
        Ok(Ok(output)) => {
            let mut text = String::from_utf8_lossy(&output.stdout).into_owned();
            text.push_str(&String::from_utf8_lossy(&output.stderr));
            let (text, _) = truncate_output(&text);
            Ok((output.status.success(), text))
        }
        Ok(Err(error)) => Err(AppError::Internal(format!("沙箱编译进程启动失败: {error}"))),
        Err(_) => Ok((false, "编译超时（10 秒）".to_owned())),
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

async fn clear_outputs(container: &str) {
    let _ = Command::new("docker")
        .args([
            "exec",
            container,
            "rm",
            "-f",
            "/workspace/result.json",
            "/workspace/stdout.txt",
            "/workspace/stderr.txt",
        ])
        .output()
        .await;
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

/// Reads a file from the sandbox through `docker exec`. See
/// [`write_to_container`] for why `docker cp` cannot be used with the tmpfs
/// workspace.
async fn read_from_container(container: &str, file: &str) -> Option<Vec<u8>> {
    let output = Command::new("docker")
        .args(["exec", "--user", "65534:65534", container, "cat"])
        .arg(format!("/workspace/{file}"))
        .stdin(Stdio::null())
        .stdout(Stdio::piped())
        .stderr(Stdio::null())
        .output()
        .await
        .ok()?;
    if !output.status.success() {
        return None;
    }
    Some(output.stdout)
}

async fn read_result_file(container: &str) -> Option<HarnessResult> {
    let content = read_from_container(container, "result.json").await?;
    serde_json::from_slice(&content).ok()
}

async fn read_output_file(container: &str, file: &str) -> (String, bool) {
    let content = read_from_container(container, file)
        .await
        .map(|bytes| String::from_utf8_lossy(&bytes).into_owned())
        .unwrap_or_default();
    truncate_output(&content)
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

    use super::{program_for, truncate_output};
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
}
