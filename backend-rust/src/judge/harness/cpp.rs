use crate::judge::run_config::{CPP_NODE_DEFINITIONS, cpp_type};

const CPP_TEMPLATE: &str = r#"// 运行镜像里预编译了 bits/stdc++.h + json-c，命中时能省下
// 重复解析头文件的时间（gVisor 下读取大量 header 尤其慢）。
// 旧镜像没有这个预编译头时自动回退到逐个头文件 include。
#if __has_include("theseus_precompiled.hpp")
#include "theseus_precompiled.hpp"
#else
#include <bits/stdc++.h>
#include <sys/resource.h>
#endif
#include <json-c/json.h>
using namespace std;

__NODE_DEFS__
__USER_CODE__

__HELPERS__

namespace theseus_harness {

static json_object* read_case() {
    std::ifstream input("/workspace/case.json");
    if (!input) {
        throw std::runtime_error("无法打开 case.json");
    }
    std::string raw((std::istreambuf_iterator<char>(input)), std::istreambuf_iterator<char>());
    json_object* args = json_tokener_parse(raw.c_str());
    if (args == nullptr) {
        throw std::runtime_error("case.json 解析失败");
    }
    return args;
}

static void write_result(bool ok, json_object* actual, const std::string& error,
                         long long runtime_ms, long long memory_kb) {
    json_object* payload = json_object_new_object();
    json_object_object_add(payload, "ok", json_object_new_boolean(ok));
    json_object_object_add(payload, "actual",
                           actual != nullptr ? actual : json_object_new_null());
    json_object_object_add(payload, "error",
                           ok ? json_object_new_null() : json_object_new_string(error.c_str()));
    json_object_object_add(payload, "runtime_ms", json_object_new_int64(runtime_ms));
    json_object_object_add(payload, "memory_kb", json_object_new_int64(memory_kb));
    std::ofstream out("/workspace/result.json", std::ios::trunc);
    out << json_object_to_json_string(payload);
}

}  // namespace theseus_harness

int main() {
    std::freopen("/workspace/stdout.txt", "w", stdout);
    std::freopen("/workspace/stderr.txt", "w", stderr);
    const auto started = std::chrono::steady_clock::now();
    bool ok = false;
    json_object* actual = nullptr;
    std::string error;
    try {
        json_object* args = theseus_harness::read_case();
__PARAM_PREP__        Solution theseus_solution;
        actual = __RESULT_EXPR__;
        ok = true;
    } catch (const std::exception& exception) {
        error = std::string("std::exception: ") + exception.what();
    } catch (...) {
        error = "未知错误";
    }
    const auto elapsed = std::chrono::duration_cast<std::chrono::milliseconds>(
        std::chrono::steady_clock::now() - started).count();
    long long memory_kb = 0;
    struct rusage usage;
    if (getrusage(RUSAGE_SELF, &usage) == 0) {
        memory_kb = usage.ru_maxrss;
    }
    std::fflush(stdout);
    std::fflush(stderr);
    theseus_harness::write_result(ok, actual, error, static_cast<long long>(elapsed), memory_kb);
    return 0;
}
"#;

const VECTOR_HELPERS: &str = r#"static json_object* theseus_arg(json_object* args, std::size_t index) {
    return json_object_array_get_idx(args, index);
}

template <typename T>
struct TheseusScalar;

template <>
struct TheseusScalar<int> {
    static int get(json_object* value) { return json_object_get_int(value); }
};

template <>
struct TheseusScalar<long long> {
    static long long get(json_object* value) { return json_object_get_int64(value); }
};

template <>
struct TheseusScalar<double> {
    static double get(json_object* value) { return json_object_get_double(value); }
};

template <>
struct TheseusScalar<bool> {
    static bool get(json_object* value) { return json_object_get_boolean(value) != 0; }
};

template <>
struct TheseusScalar<std::string> {
    static std::string get(json_object* value) {
        const char* text = json_object_get_string(value);
        return text == nullptr ? std::string() : std::string(text);
    }
};

template <typename T>
static std::vector<T> theseus_to_vector(json_object* value) {
    std::vector<T> out;
    const std::size_t size = json_object_array_length(value);
    out.reserve(size);
    for (std::size_t index = 0; index < size; ++index) {
        out.push_back(TheseusScalar<T>::get(json_object_array_get_idx(value, index)));
    }
    return out;
}

template <typename T>
static std::vector<std::vector<T>> theseus_to_matrix(json_object* value) {
    std::vector<std::vector<T>> out;
    const std::size_t size = json_object_array_length(value);
    out.reserve(size);
    for (std::size_t index = 0; index < size; ++index) {
        out.push_back(theseus_to_vector<T>(json_object_array_get_idx(value, index)));
    }
    return out;
}

static json_object* theseus_to_json(int value) {
    return json_object_new_int(value);
}

static json_object* theseus_to_json(long long value) {
    return json_object_new_int64(value);
}

// 用户的函数可能直接写 long；在 LP64 上它与 int / long long 都是不同的类型，
// 没有这个重载时重载决议会在两者之间产生歧义。
static json_object* theseus_to_json(long value) {
    return json_object_new_int64(static_cast<long long>(value));
}

static json_object* theseus_to_json(double value) {
    return json_object_new_double(value);
}

static json_object* theseus_to_json(bool value) {
    return json_object_new_boolean(value);
}

static json_object* theseus_to_json(const std::string& value) {
    return json_object_new_string_len(value.data(), static_cast<int>(value.size()));
}

template <typename T>
static json_object* theseus_to_json(const std::vector<T>& values) {
    json_object* out = json_object_new_array();
    for (std::size_t index = 0; index < values.size(); ++index) {
        json_object_array_add(out, theseus_to_json(static_cast<T>(values[index])));
    }
    return out;
}

"#;

const LIST_HELPERS: &str = r#"static ListNode* theseus_build_list(const json_object* values) {
    ListNode* head = nullptr;
    for (std::size_t index = json_object_array_length(values); index > 0; --index) {
        head = new ListNode(json_object_get_int(json_object_array_get_idx(values, index - 1)), head);
    }
    return head;
}

static json_object* theseus_to_json(ListNode* head) {
    json_object* out = json_object_new_array();
    while (head != nullptr) {
        json_object_array_add(out, json_object_new_int(head->val));
        head = head->next;
    }
    return out;
}

"#;

const TREE_HELPERS: &str = r#"static TreeNode* theseus_build_tree(const json_object* values) {
    const std::size_t size = json_object_array_length(values);
    if (size == 0 || json_object_is_type(json_object_array_get_idx(values, 0), json_type_null)) {
        return nullptr;
    }
    TreeNode* root = new TreeNode(json_object_get_int(json_object_array_get_idx(values, 0)));
    std::queue<TreeNode*> pending;
    pending.push(root);
    std::size_t index = 1;
    while (!pending.empty() && index < size) {
        TreeNode* node = pending.front();
        pending.pop();
        if (index < size &&
            !json_object_is_type(json_object_array_get_idx(values, index), json_type_null)) {
            node->left = new TreeNode(json_object_get_int(json_object_array_get_idx(values, index)));
            pending.push(node->left);
        }
        ++index;
        if (index < size &&
            !json_object_is_type(json_object_array_get_idx(values, index), json_type_null)) {
            node->right =
                new TreeNode(json_object_get_int(json_object_array_get_idx(values, index)));
            pending.push(node->right);
        }
        ++index;
    }
    return root;
}

static json_object* theseus_to_json(TreeNode* root) {
    json_object* out = json_object_new_array();
    if (root == nullptr) {
        return out;
    }
    std::queue<TreeNode*> pending;
    pending.push(root);
    while (!pending.empty()) {
        TreeNode* node = pending.front();
        pending.pop();
        if (node == nullptr) {
            json_object_array_add(out, json_object_new_null());
            continue;
        }
        json_object_array_add(out, json_object_new_int(node->val));
        pending.push(node->left);
        pending.push(node->right);
    }
    while (json_object_array_length(out) > 0) {
        const std::size_t last = json_object_array_length(out) - 1;
        if (!json_object_is_type(json_object_array_get_idx(out, last), json_type_null)) {
            break;
        }
        json_object_array_del_idx(out, last, 1);
    }
    return out;
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
    let call = format!("theseus_solution.{function_name}({call_args})");
    let result_expr = result_expression(&call);

    let mut helpers = String::from(VECTOR_HELPERS);
    let mut node_defs = String::new();
    if uses_type(param_types, return_type, "ListNode") {
        node_defs.push_str(CPP_NODE_DEFINITIONS);
        helpers.push_str(LIST_HELPERS);
    }
    if uses_type(param_types, return_type, "TreeNode") {
        if node_defs.is_empty() {
            node_defs.push_str(CPP_NODE_DEFINITIONS);
        }
        helpers.push_str(TREE_HELPERS);
    }

    // NOTE:
    // __NODE_DEFS__ 是节点的定义 替换的 之后
    // __USER_CODE__ 用户提交的源码
    //
    CPP_TEMPLATE
        .replace("__NODE_DEFS__", node_defs.trim_end())
        .replace("__USER_CODE__", code)
        .replace("__HELPERS__", helpers.trim_end())
        .replace("__PARAM_PREP__", &prepared_params)
        .replace("__RESULT_EXPR__", &result_expr)
}

fn prepare_param(index: usize, param_type: &str) -> String {
    match param_type {
        "ListNode" => {
            format!(
                "        ListNode* a{index} = theseus_build_list(theseus_arg(args, {index}));\n"
            )
        }
        "TreeNode" => {
            format!(
                "        TreeNode* a{index} = theseus_build_tree(theseus_arg(args, {index}));\n"
            )
        }
        nested if nested.ends_with("[][]") => format!(
            "        auto a{index} = theseus_to_matrix<{}>(theseus_arg(args, {index}));\n",
            cpp_type(scalar_type(param_type))
        ),
        nested if nested.ends_with("[]") => format!(
            "        auto a{index} = theseus_to_vector<{}>(theseus_arg(args, {index}));\n",
            cpp_type(scalar_type(param_type))
        ),
        _ => format!(
            "        auto a{index} = TheseusScalar<{}>::get(theseus_arg(args, {index}));\n",
            cpp_type(param_type)
        ),
    }
}

fn result_expression(call: &str) -> String {
    format!("theseus_to_json({call})")
}

fn scalar_type(run_type: &str) -> &str {
    let mut scalar = run_type;
    while let Some(stripped) = scalar.strip_suffix("[]") {
        scalar = stripped;
    }
    scalar
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
            "class Solution { public: int add(int a, int b) { return a + b; } };",
            "add",
            &["int".to_owned(), "int".to_owned()],
            "int",
        );
        assert!(source.contains("#include <json-c/json.h>"));
        assert!(source.contains("theseus_solution.add(a0, a1)"));
        assert!(source.contains("TheseusScalar<int>::get(theseus_arg(args, 0))"));
        assert!(source.contains("json_object_to_json_string(payload)"));
        assert!(!source.contains("nlohmann"));
        assert!(!source.contains("theseus_build_list"));
    }

    #[test]
    fn emits_node_helpers_for_linked_types() {
        let source = generate_main(
            "class Solution { public: ListNode* reverseList(ListNode* head) { return head; } };",
            "reverseList",
            &["ListNode".to_owned()],
            "ListNode",
        );
        assert!(source.contains("theseus_build_list"));
        assert!(source.contains("theseus_to_json(ListNode* head)"));
        assert!(source.contains("theseus_to_json(theseus_solution.reverseList(a0))"));
        assert!(!source.contains("__PARAM_PREP__"));
    }

    #[test]
    fn builds_two_dimensional_vectors() {
        let source = generate_main(
            "class Solution { public: int f(vector<vector<int>>& grid) { return 0; } };",
            "f",
            &["int[][]".to_owned()],
            "int",
        );
        assert!(source.contains("theseus_to_matrix<int>(theseus_arg(args, 0))"));
        assert!(!source.contains("TheseusScalar<std::vector"));
        assert!(!source.contains("__PARAM_PREP__"));
    }

    #[test]
    fn builds_scalar_vectors_and_strings() {
        let source = generate_main(
            "class Solution { public: string join(vector<string>& words) { return words[0]; } };",
            "join",
            &["string[]".to_owned()],
            "string",
        );
        assert!(source.contains("theseus_to_vector<std::string>(theseus_arg(args, 0))"));
        assert!(source.contains("struct TheseusScalar<std::string>"));
    }
}
