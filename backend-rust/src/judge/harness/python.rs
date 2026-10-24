const PYTHON_RUNNER: &str = r#"import io
import json
import resource
import sys
import time
import traceback

WORKSPACE = "/workspace"
FUNCTION_NAME = "__FUNCTION_NAME__"
OUTPUT_LIMIT = 65536


def write_text(name, text):
    with open(WORKSPACE + "/" + name, "w", encoding="utf-8", errors="replace") as handle:
        handle.write(text[:OUTPUT_LIMIT])


def main():
    with open(WORKSPACE + "/case.json", "r", encoding="utf-8") as handle:
        args = json.load(handle)
    with open(WORKSPACE + "/solution.py", "r", encoding="utf-8") as handle:
        source = handle.read()

    stdout_buffer = io.StringIO()
    stderr_buffer = io.StringIO()
    original_stdout, original_stderr = sys.stdout, sys.stderr
    sys.stdout, sys.stderr = stdout_buffer, stderr_buffer
    payload = {"ok": False, "actual": None, "error": None, "runtime_ms": 0, "memory_kb": 0}
    started = time.monotonic()
    try:
        namespace = {"__name__": "__main__"}
        exec(compile(source, "solution.py", "exec"), namespace)
        solution_type = namespace.get("Solution")
        if solution_type is None:
            raise RuntimeError("未找到 Solution 类")
        actual = getattr(solution_type(), FUNCTION_NAME)(*args)
        payload["ok"] = True
        payload["actual"] = actual
    except BaseException as error:
        payload["error"] = type(error).__name__ + ": " + str(error)
        traceback.print_exc(file=stderr_buffer)
    finally:
        payload["runtime_ms"] = int((time.monotonic() - started) * 1000)
        try:
            payload["memory_kb"] = int(resource.getrusage(resource.RUSAGE_SELF).ru_maxrss)
        except Exception:
            payload["memory_kb"] = 0
        sys.stdout, sys.stderr = original_stdout, original_stderr
        stdout_text = stdout_buffer.getvalue()
        stderr_text = stderr_buffer.getvalue()
        try:
            with open(WORKSPACE + "/result.json", "w", encoding="utf-8") as handle:
                json.dump(payload, handle, ensure_ascii=False)
        except Exception as error:
            payload = {
                "ok": False,
                "actual": None,
                "error": "返回值无法序列化为 JSON: " + str(error),
                "runtime_ms": payload["runtime_ms"],
                "memory_kb": payload["memory_kb"],
            }
            with open(WORKSPACE + "/result.json", "w", encoding="utf-8") as handle:
                json.dump(payload, handle, ensure_ascii=False)
        write_text("stdout.txt", stdout_text)
        write_text("stderr.txt", stderr_text)


main()
"#;

pub fn generate_runner(function_name: &str) -> String {
    PYTHON_RUNNER.replace("__FUNCTION_NAME__", function_name)
}

#[cfg(test)]
mod tests {
    use super::generate_runner;

    #[test]
    fn embeds_function_name_and_reads_workspace_files() {
        let runner = generate_runner("twoSum");
        assert!(runner.contains("FUNCTION_NAME = \"twoSum\""));
        assert!(runner.contains(r#"WORKSPACE = "/workspace""#));
        assert!(runner.contains("WORKSPACE + \"/case.json\""));
        assert!(runner.contains("OUTPUT_LIMIT = 65536"));
        assert!(!runner.contains("__FUNCTION_NAME__"));
    }
}
