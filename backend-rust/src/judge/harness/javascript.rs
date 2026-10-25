const NODE_RUNNER: &str = r#"const fs = require("fs");
const path = require("path");

const WORKSPACE = "/workspace";
const FUNCTION_NAME = "__FUNCTION_NAME__";
const PARAM_TYPES = __PARAM_TYPES__;
const RETURN_TYPE = "__RETURN_TYPE__";
const OUTPUT_LIMIT = 65536;

function writeText(name, text) {
  fs.writeFileSync(path.join(WORKSPACE, name), text.slice(0, OUTPUT_LIMIT), "utf8");
}

function toListNode(values) {
  let head = null;
  for (let index = (values || []).length - 1; index >= 0; index -= 1) {
    head = { val: values[index], next: head };
  }
  return head;
}

function fromListNode(node) {
  const values = [];
  while (node !== null && node !== undefined) {
    values.push(node.val);
    node = node.next;
  }
  return values;
}

function toTree(values) {
  if (!values || values.length === 0 || values[0] === null) return null;
  const root = { val: values[0], left: null, right: null };
  const queue = [root];
  let index = 1;
  while (queue.length > 0 && index < values.length) {
    const node = queue.shift();
    if (index < values.length && values[index] !== null) {
      node.left = { val: values[index], left: null, right: null };
      queue.push(node.left);
    }
    index += 1;
    if (index < values.length && values[index] !== null) {
      node.right = { val: values[index], left: null, right: null };
      queue.push(node.right);
    }
    index += 1;
  }
  return root;
}

function fromTree(root) {
  if (root === null || root === undefined) return [];
  const values = [];
  const queue = [root];
  while (queue.length > 0) {
    const node = queue.shift();
    if (node === null || node === undefined) {
      values.push(null);
      continue;
    }
    values.push(node.val);
    queue.push(node.left);
    queue.push(node.right);
  }
  while (values.length > 0 && values[values.length - 1] === null) values.pop();
  return values;
}

function convertArg(value, typeName) {
  if (typeName === "ListNode") return toListNode(value);
  if (typeName === "TreeNode") return toTree(value);
  return value;
}

function convertResult(value) {
  if (RETURN_TYPE === "ListNode") return fromListNode(value);
  if (RETURN_TYPE === "TreeNode") return fromTree(value);
  return value;
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
  const converted = args.map((value, index) => convertArg(value, PARAM_TYPES[index]));
  const actual = solution.apply(null, converted);
  payload.ok = true;
  payload.actual = convertResult(actual === undefined ? null : actual);
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

pub fn generate_runner(function_name: &str, param_types: &[String], return_type: &str) -> String {
    let param_types = serde_json::to_string(param_types).unwrap_or_else(|_| "[]".to_owned());
    NODE_RUNNER
        .replace("__FUNCTION_NAME__", function_name)
        .replace("__PARAM_TYPES__", &param_types)
        .replace("__RETURN_TYPE__", return_type)
}

#[cfg(test)]
mod tests {
    use super::generate_runner;

    #[test]
    fn embeds_function_name_and_type_metadata() {
        let runner = generate_runner("invertTree", &["TreeNode".to_owned()], "TreeNode");
        assert!(runner.contains(r#"const FUNCTION_NAME = "invertTree";"#));
        assert!(runner.contains(r#"const PARAM_TYPES = ["TreeNode"];"#));
        assert!(runner.contains(r#"const RETURN_TYPE = "TreeNode";"#));
        assert!(runner.contains("function fromTree"));
        assert!(!runner.contains("__FUNCTION_NAME__"));
    }
}
