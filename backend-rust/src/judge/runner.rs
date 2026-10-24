use std::{
    path::{Path, PathBuf},
    process::Stdio,
    time::{Duration, Instant},
};

use serde::Deserialize;
use serde_json::Value;
use tokio::process::Command;

use crate::{
    common::error::AppError, judge::harness::python::generate_runner,
    judge::run_config::MAX_INPUT_BYTES,
};

pub const OUTPUT_LIMIT: usize = 64 * 1024;
const MEMORY_LIMIT_MB: u32 = 256;
const CONTAINER_TTL_SECONDS: u32 = 30;

#[derive(Debug, Clone)]
pub struct SandboxConfig {
    pub image: String,
    pub runtime: String,
    pub allow_runc: bool,
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

pub async fn execute_python(
    sandbox: &SandboxConfig,
    run_id: i64,
    code: &str,
    args: &[Value],
    function_name: &str,
    timeout: Duration,
) -> Result<SandboxOutcome, AppError> {
    if sandbox.runtime != "runsc" && !sandbox.allow_runc {
        return Err(AppError::Internal(
            "沙箱运行时必须为 runsc，拒绝回退 runc".to_owned(),
        ));
    }
    if sandbox.image.trim().is_empty() {
        return Err(AppError::Internal("未配置 Python 运行镜像".to_owned()));
    }

    let workspace = create_workspace(run_id)?;
    let container = format!("theseus-run-{run_id}-{}", random_suffix());
    let result = run_in_container(
        sandbox,
        &container,
        &workspace,
        code,
        args,
        function_name,
        timeout,
    )
    .await;
    remove_container(&container).await;
    if let Err(error) = std::fs::remove_dir_all(&workspace) {
        tracing::warn!(path = %workspace.display(), error = %error, "failed to remove run workspace");
    }
    result
}

async fn run_in_container(
    sandbox: &SandboxConfig,
    container: &str,
    workspace: &Path,
    code: &str,
    args: &[Value],
    function_name: &str,
    timeout: Duration,
) -> Result<SandboxOutcome, AppError> {
    std::fs::write(workspace.join("runner.py"), generate_runner(function_name))
        .map_err(|error| AppError::Internal(format!("写入 harness 失败: {error}")))?;
    std::fs::write(workspace.join("solution.py"), code)
        .map_err(|error| AppError::Internal(format!("写入用户代码失败: {error}")))?;
    let case = serde_json::to_vec(args)
        .map_err(|error| AppError::Internal(format!("序列化运行参数失败: {error}")))?;
    if case.len() > MAX_INPUT_BYTES {
        return Err(AppError::BadRequest("自定义输入不能超过 64 KB".to_owned()));
    }
    std::fs::write(workspace.join("case.json"), case)
        .map_err(|error| AppError::Internal(format!("写入运行参数失败: {error}")))?;

    start_container(sandbox, container).await?;
    verify_runtime(sandbox, container).await?;
    for file in ["runner.py", "solution.py", "case.json"] {
        copy_to_container(workspace, container, file).await?;
    }

    let started = Instant::now();
    let mut command = Command::new("docker");
    command
        .args([
            "exec",
            "--user",
            "65534:65534",
            container,
            "python3",
            "/workspace/runner.py",
        ])
        .stdin(Stdio::null())
        .stdout(Stdio::null())
        .stderr(Stdio::null());
    let (timed_out, exit_code) = match tokio::time::timeout(timeout, command.output()).await {
        Ok(Ok(output)) => (false, output.status.code()),
        Ok(Err(error)) => {
            return Err(AppError::Internal(format!("沙箱执行进程启动失败: {error}")));
        }
        Err(_) => {
            let _ = kill_container(container).await;
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

    let oom = exit_code == Some(137) || container_oom_killed(container).await;
    let result = read_result_file(workspace, container).await;
    let memory_kb = result
        .as_ref()
        .map(|value| value.memory_kb.max(0))
        .unwrap_or_default();
    let (raw_stdout, stdout_truncated) = read_output_file(workspace, container, "stdout.txt").await;
    let (raw_stderr, stderr_truncated) = read_output_file(workspace, container, "stderr.txt").await;

    Ok(SandboxOutcome {
        timed_out: false,
        oom,
        exit_code,
        result,
        stdout: raw_stdout,
        stderr: raw_stderr,
        runtime_ms: wall_ms,
        memory_kb,
        truncated: stdout_truncated || stderr_truncated,
    })
}

async fn start_container(sandbox: &SandboxConfig, container: &str) -> Result<(), AppError> {
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
        &format!("--memory={MEMORY_LIMIT_MB}m"),
        &format!("--memory-swap={MEMORY_LIMIT_MB}m"),
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

async fn copy_to_container(workspace: &Path, container: &str, file: &str) -> Result<(), AppError> {
    let source = workspace.join(file);
    let destination = format!("{container}:/workspace/{file}");
    let output = Command::new("docker")
        .arg("cp")
        .arg(&source)
        .arg(&destination)
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

async fn read_result_file(workspace: &Path, container: &str) -> Option<HarnessResult> {
    let target = workspace.join("result.json");
    copy_from_container(container, "result.json", &target).await;
    std::fs::read_to_string(&target)
        .ok()
        .and_then(|content| serde_json::from_str::<HarnessResult>(&content).ok())
}

async fn read_output_file(workspace: &Path, container: &str, file: &str) -> (String, bool) {
    let target = workspace.join(file);
    copy_from_container(container, file, &target).await;
    let content = std::fs::read_to_string(&target).unwrap_or_default();
    truncate_output(&content)
}

async fn copy_from_container(container: &str, file: &str, target: &Path) {
    let source = format!("{container}:/workspace/{file}");
    let _ = Command::new("docker")
        .arg("cp")
        .arg(&source)
        .arg(target)
        .output()
        .await;
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
    use super::truncate_output;

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
