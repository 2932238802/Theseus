const PYTHON_RUNNER: &str = r#"import io
import json
import resource
import sys
import time
import traceback

WORKSPACE = "/workspace"
FUNCTION_NAME = "__FUNCTION_NAME__"
PARAM_TYPES = __PARAM_TYPES__
RETURN_TYPE = "__RETURN_TYPE__"
OUTPUT_LIMIT = 65536


class ListNode:
    def __init__(self, val=0, next=None):
        self.val = val
        self.next = next


class TreeNode:
    def __init__(self, val=0, left=None, right=None):
        self.val = val
        self.left = left
        self.right = right


def to_list_node(values):
    head = None
    for value in reversed(values or []):
        head = ListNode(value, head)
    return head


def from_list_node(node):
    values = []
    while node is not None:
        values.append(node.val)
        node = node.next
    return values


def to_tree(values):
    if not values or values[0] is None:
        return None
    root = TreeNode(values[0])
    queue = [root]
    index = 1
    while queue and index < len(values):
        node = queue.pop(0)
        if index < len(values) and values[index] is not None:
            node.left = TreeNode(values[index])
            queue.append(node.left)
        index += 1
        if index < len(values) and values[index] is not None:
            node.right = TreeNode(values[index])
            queue.append(node.right)
        index += 1
    return root


def from_tree(root):
    if root is None:
        return []
    values = []
    queue = [root]
    while queue:
        node = queue.pop(0)
        if node is None:
            values.append(None)
            continue
        values.append(node.val)
        queue.append(node.left)
        queue.append(node.right)
    while values and values[-1] is None:
        values.pop()
    return values


def convert_arg(value, type_name):
    if type_name == "ListNode":
        return to_list_node(value)
    if type_name == "TreeNode":
        return to_tree(value)
    return value


def convert_result(value):
    if RETURN_TYPE == "ListNode":
        return from_list_node(value)
    if RETURN_TYPE == "TreeNode":
        return from_tree(value)
    return value


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
        namespace = {"__name__": "__main__", "ListNode": ListNode, "TreeNode": TreeNode}
        exec(compile(source, "solution.py", "exec"), namespace)
        solution_type = namespace.get("Solution")
        if solution_type is None:
            raise RuntimeError("未找到 Solution 类")
        converted = [convert_arg(value, type_name) for value, type_name in zip(args, PARAM_TYPES)]
        actual = getattr(solution_type(), FUNCTION_NAME)(*converted)
        payload["ok"] = True
        payload["actual"] = convert_result(actual)
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

pub fn generate_runner(function_name: &str, param_types: &[String], return_type: &str) -> String {
    let param_types = serde_json::to_string(param_types).unwrap_or_else(|_| "[]".to_owned());
    PYTHON_RUNNER
        .replace("__FUNCTION_NAME__", function_name)
        .replace("__PARAM_TYPES__", &param_types)
        .replace("__RETURN_TYPE__", return_type)
}

#[cfg(test)]
mod tests {
    use super::generate_runner;

    #[test]
    fn embeds_function_name_and_type_metadata() {
        let runner = generate_runner("reverseList", &["ListNode".to_owned()], "ListNode");
        assert!(runner.contains("FUNCTION_NAME = \"reverseList\""));
        assert!(runner.contains("PARAM_TYPES = [\"ListNode\"]"));
        assert!(runner.contains("RETURN_TYPE = \"ListNode\""));
        assert!(runner.contains(r#"WORKSPACE = "/workspace""#));
        assert!(runner.contains("def from_tree"));
        assert!(!runner.contains("__FUNCTION_NAME__"));
        assert!(!runner.contains("__PARAM_TYPES__"));
    }
}
