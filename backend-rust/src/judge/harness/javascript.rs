const NODE_RUNNER: &str = r#"const fs = require("fs");
const path = require("path");

const WORKSPACE = "/workspace";
const FUNCTION_NAME = "__FUNCTION_NAME__";
const OUTPUT_LIMIT = 65536;

function writeText(name, text) {
  fs.writeFileSync(path.join(WORKSPACE, name), text.slice(0, OUTPUT_LIMIT), "utf8");
}

let stdoutText = "";
let stderrText = "";
const originalStdoutWrite = process.stdout.write.bind(process.stdout);
const originalStderrWrite = process.stderr.write.bind(process.stderr);

process.stdout.write = function (chunk, encoding, callback) {
  stdoutText += String(chunk);
  if (typeof encoding === "function") {
    encoding();
  } else if (typeof callback === "function") {
    callback();
  }
  return true;
};
process.stderr.write = function (chunk, encoding, callback) {
  stderrText += String(chunk);
  if (typeof encoding === "function") {
    encoding();
  } else if (typeof callback === "function") {
    callback();
  }
  return true;
};

const payload = { ok: false, actual: null, error: null, runtime_ms: 0, memory_kb: 0 };
const started = process.hrtime.bigint();
try {
  const args = JSON.parse(fs.readFileSync(path.join(WORKSPACE, "case.json"), "utf8"));
  const source = fs.readFileSync(path.join(WORKSPACE, "solution.js"), "utf8");
  const factory = new Function(
    source + "\n;return typeof " + FUNCTION_NAME + " === \"function\" ? " + FUNCTION_NAME + " : undefined;",
  );
  const solution = factory();
  if (typeof solution !== "function") {
    throw new Error("未找到函数 " + FUNCTION_NAME);
  }
  const actual = solution.apply(null, args);
  payload.ok = true;
  payload.actual = actual === undefined ? null : actual;
} catch (error) {
  const name = error && error.name ? error.name : "Error";
  const message = error && error.message ? error.message : String(error);
  payload.error = name + ": " + message;
  if (error && error.stack) {
    stderrText += error.stack + "\n";
  }
} finally {
  payload.runtime_ms = Number(process.hrtime.bigint() - started) / 1e6 | 0;
  payload.memory_kb = Math.round(process.memoryUsage().rss / 1024);
  process.stdout.write = originalStdoutWrite;
  process.stderr.write = originalStderrWrite;
  let serialized;
  try {
    serialized = JSON.stringify(payload);
  } catch (error) {
    serialized = JSON.stringify({
      ok: false,
      actual: null,
      error: "返回值无法序列化为 JSON: " + String(error),
      runtime_ms: payload.runtime_ms,
      memory_kb: payload.memory_kb,
    });
  }
  fs.writeFileSync(path.join(WORKSPACE, "result.json"), serialized, "utf8");
  writeText("stdout.txt", stdoutText);
  writeText("stderr.txt", stderrText);
}
"#;

pub fn generate_runner(function_name: &str) -> String {
    NODE_RUNNER.replace("__FUNCTION_NAME__", function_name)
}

#[cfg(test)]
mod tests {
    use super::generate_runner;

    #[test]
    fn embeds_function_name_and_reads_workspace_files() {
        let runner = generate_runner("twoSum");
        assert!(runner.contains(r#"const FUNCTION_NAME = "twoSum";"#));
        assert!(runner.contains(r#"const WORKSPACE = "/workspace";"#));
        assert!(runner.contains("case.json"));
        assert!(runner.contains("solution.js"));
        assert!(!runner.contains("__FUNCTION_NAME__"));
    }
}
