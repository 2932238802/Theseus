use crate::judge::run_config::java_type;

const JAVA_TEMPLATE: &str = r#"import java.io.FileOutputStream;
import java.io.PrintStream;
import java.nio.charset.StandardCharsets;
import java.nio.file.Files;
import java.nio.file.Paths;
import java.util.ArrayDeque;
import java.util.ArrayList;
import java.util.Deque;
import java.util.LinkedList;
import java.util.List;

import com.google.gson.Gson;
import com.google.gson.JsonArray;
import com.google.gson.JsonElement;
import com.google.gson.JsonNull;
import com.google.gson.JsonObject;
import com.google.gson.JsonParser;

__USER_CODE__

public class Main {
    static final Gson GSON = new Gson();

__HELPERS__

    static void writeResult(boolean ok, JsonElement actual, String error, long runtimeMs, long memoryKb) {
        JsonObject payload = new JsonObject();
        payload.addProperty("ok", ok);
        payload.add("actual", actual == null ? JsonNull.INSTANCE : actual);
        payload.add("error", error == null ? JsonNull.INSTANCE : new com.google.gson.JsonPrimitive(error));
        payload.addProperty("runtime_ms", runtimeMs);
        payload.addProperty("memory_kb", memoryKb);
        try {
            Files.write(Paths.get("/workspace/result.json"), payload.toString().getBytes(StandardCharsets.UTF_8));
        } catch (Exception ignored) {
        }
    }

    public static void main(String[] arguments) {
        PrintStream originalOut = System.out;
        PrintStream originalErr = System.err;
        try {
            System.setOut(new PrintStream(new FileOutputStream("/workspace/stdout.txt"), true, StandardCharsets.UTF_8));
            System.setErr(new PrintStream(new FileOutputStream("/workspace/stderr.txt"), true, StandardCharsets.UTF_8));
        } catch (Exception ignored) {
        }
        long started = System.nanoTime();
        boolean ok = false;
        JsonElement actual = JsonNull.INSTANCE;
        String error = null;
        try {
            String content = new String(Files.readAllBytes(Paths.get("/workspace/case.json")), StandardCharsets.UTF_8);
            JsonArray args = JsonParser.parseString(content).getAsJsonArray();
__PARAM_PREP__            Solution solution = new Solution();
            __RESULT_STMT__
            ok = true;
        } catch (Throwable throwable) {
            error = throwable.getClass().getSimpleName() + ": " + String.valueOf(throwable.getMessage());
            throwable.printStackTrace();
        }
        long runtimeMs = (System.nanoTime() - started) / 1_000_000L;
        long memoryKb = (Runtime.getRuntime().totalMemory() - Runtime.getRuntime().freeMemory()) / 1024L;
        System.out.flush();
        System.err.flush();
        System.setOut(originalOut);
        System.setErr(originalErr);
        writeResult(ok, actual, error, runtimeMs, memoryKb);
    }
}
"#;

const LIST_HELPERS: &str = r#"    static ListNode buildList(JsonArray values) {
        ListNode head = null;
        for (int index = values.size() - 1; index >= 0; index -= 1) {
            head = new ListNode(values.get(index).getAsInt(), head);
        }
        return head;
    }

    static int[] dumpList(ListNode head) {
        List<Integer> values = new ArrayList<>();
        while (head != null) {
            values.add(head.val);
            head = head.next;
        }
        int[] out = new int[values.size()];
        for (int index = 0; index < out.length; index += 1) {
            out[index] = values.get(index);
        }
        return out;
    }
"#;

const TREE_HELPERS: &str = r#"    static TreeNode buildTree(JsonArray values) {
        if (values == null || values.size() == 0 || values.get(0).isJsonNull()) {
            return null;
        }
        TreeNode root = new TreeNode(values.get(0).getAsInt());
        Deque<TreeNode> pending = new ArrayDeque<>();
        pending.add(root);
        int index = 1;
        while (!pending.isEmpty() && index < values.size()) {
            TreeNode node = pending.poll();
            if (index < values.size() && !values.get(index).isJsonNull()) {
                node.left = new TreeNode(values.get(index).getAsInt());
                pending.add(node.left);
            }
            index += 1;
            if (index < values.size() && !values.get(index).isJsonNull()) {
                node.right = new TreeNode(values.get(index).getAsInt());
                pending.add(node.right);
            }
            index += 1;
        }
        return root;
    }

    static List<Integer> dumpTree(TreeNode root) {
        List<Integer> values = new ArrayList<>();
        if (root == null) {
            return values;
        }
        Deque<TreeNode> pending = new LinkedList<>();
        pending.add(root);
        while (!pending.isEmpty()) {
            TreeNode node = pending.poll();
            if (node == null) {
                values.add(null);
                continue;
            }
            values.add(node.val);
            pending.add(node.left);
            pending.add(node.right);
        }
        while (!values.isEmpty() && values.get(values.size() - 1) == null) {
            values.remove(values.size() - 1);
        }
        return values;
    }
"#;

pub fn generate_main(
    code: &str,
    function_name: &str,
    param_types: &[String],
    return_type: &str,
) -> String {
    let mut prepared_params = String::new();
    for (index, param_type) in param_types.iter().enumerate() {
        prepared_params.push_str(&prepare_param(index, param_type));
    }
    let call_args = (0..param_types.len())
        .map(|index| format!("a{index}"))
        .collect::<Vec<_>>()
        .join(", ");
    let call = format!("solution.{function_name}({call_args})");
    let result_statement = match return_type {
        "ListNode" => format!("actual = GSON.toJsonTree(dumpList({call}));"),
        "TreeNode" => format!("actual = GSON.toJsonTree(dumpTree({call}));"),
        _ => format!("actual = GSON.toJsonTree({call});"),
    };

    let mut helpers = String::new();
    if uses_type(param_types, return_type, "ListNode") {
        helpers.push_str(LIST_HELPERS);
    }
    if uses_type(param_types, return_type, "TreeNode") {
        if !helpers.is_empty() {
            helpers.push('\n');
        }
        helpers.push_str(TREE_HELPERS);
    }

    JAVA_TEMPLATE
        .replace("__USER_CODE__", code)
        .replace("__HELPERS__", helpers.trim_end())
        .replace("__PARAM_PREP__", &prepared_params)
        .replace("__RESULT_STMT__", &result_statement)
}

fn prepare_param(index: usize, param_type: &str) -> String {
    match param_type {
        "ListNode" => format!(
            "            ListNode a{index} = buildList(args.get({index}).getAsJsonArray());\n"
        ),
        "TreeNode" => format!(
            "            TreeNode a{index} = buildTree(args.get({index}).getAsJsonArray());\n"
        ),
        _ => format!(
            "            {} a{index} = GSON.fromJson(args.get({index}), {}.class);\n",
            java_type(param_type),
            java_type(param_type)
        ),
    }
}

fn uses_type(param_types: &[String], return_type: &str, target: &str) -> bool {
    return_type == target || param_types.iter().any(|param_type| param_type == target)
}

#[cfg(test)]
mod tests {
    use super::generate_main;

    #[test]
    fn builds_main_with_user_code_and_call() {
        let source = generate_main(
            "class Solution { public int add(int a, int b) { return a + b; } }",
            "add",
            &["int".to_owned(), "int".to_owned()],
            "int",
        );
        assert!(source.contains("import com.google.gson.Gson;"));
        assert!(source.contains("solution.add(a0, a1)"));
        assert!(source.contains("int a0 = GSON.fromJson"));
        assert!(!source.contains("buildList"));
    }

    #[test]
    fn emits_node_helpers_for_trees() {
        let source = generate_main(
            "class Solution { public TreeNode invertTree(TreeNode root) { return root; } }",
            "invertTree",
            &["TreeNode".to_owned()],
            "TreeNode",
        );
        assert!(source.contains("buildTree"));
        assert!(source.contains("dumpTree"));
        assert!(source.contains("TreeNode a0 = buildTree"));
        assert!(!source.contains("__RESULT_STMT__"));
    }
}
