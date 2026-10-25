use crate::judge::run_config::{CPP_NODE_DEFINITIONS, cpp_type};

const CPP_TEMPLATE: &str = r#"#include <bits/stdc++.h>
#include <sys/resource.h>
#include "json.hpp"
using namespace std;

__NODE_DEFS__
__USER_CODE__

__HELPERS__

namespace theseus_harness {

using nlohmann::json;

static void write_result(bool ok, const json& actual, const std::string& error,
                         long long runtime_ms, long long memory_kb) {
    json payload;
    payload["ok"] = ok;
    payload["actual"] = actual;
    payload["error"] = ok ? json(nullptr) : json(error);
    payload["runtime_ms"] = runtime_ms;
    payload["memory_kb"] = memory_kb;
    std::ofstream out("/workspace/result.json", std::ios::trunc);
    out << payload.dump();
}

}  // namespace theseus_harness

int main() {
    std::freopen("/workspace/stdout.txt", "w", stdout);
    std::freopen("/workspace/stderr.txt", "w", stderr);
    const auto started = std::chrono::steady_clock::now();
    bool ok = false;
    nlohmann::json actual = nullptr;
    std::string error;
    try {
        std::ifstream input("/workspace/case.json");
        nlohmann::json args;
        input >> args;
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

const VECTOR_HELPERS: &str = r#"template <typename T>
static nlohmann::json theseus_to_json_vector(const std::vector<T>& values) {
    nlohmann::json out = nlohmann::json::array();
    for (std::size_t index = 0; index < values.size(); ++index) {
        out.push_back(nlohmann::json(static_cast<T>(values[index])));
    }
    return out;
}

template <typename T>
static nlohmann::json theseus_to_json_matrix(const std::vector<std::vector<T>>& rows) {
    nlohmann::json out = nlohmann::json::array();
    for (std::size_t index = 0; index < rows.size(); ++index) {
        out.push_back(theseus_to_json_vector(rows[index]));
    }
    return out;
}

"#;

const LIST_HELPERS: &str = r#"static ListNode* theseus_build_list(const nlohmann::json& values) {
    ListNode* head = nullptr;
    for (auto it = values.rbegin(); it != values.rend(); ++it) {
        head = new ListNode(it->get<int>(), head);
    }
    return head;
}

static nlohmann::json theseus_dump_list(ListNode* head) {
    nlohmann::json out = nlohmann::json::array();
    while (head != nullptr) {
        out.push_back(head->val);
        head = head->next;
    }
    return out;
}

"#;

const TREE_HELPERS: &str = r#"static TreeNode* theseus_build_tree(const nlohmann::json& values) {
    if (!values.is_array() || values.empty() || values[0].is_null()) {
        return nullptr;
    }
    TreeNode* root = new TreeNode(values[0].get<int>());
    std::queue<TreeNode*> pending;
    pending.push(root);
    std::size_t index = 1;
    while (!pending.empty() && index < values.size()) {
        TreeNode* node = pending.front();
        pending.pop();
        if (index < values.size() && !values[index].is_null()) {
            node->left = new TreeNode(values[index].get<int>());
            pending.push(node->left);
        }
        ++index;
        if (index < values.size() && !values[index].is_null()) {
            node->right = new TreeNode(values[index].get<int>());
            pending.push(node->right);
        }
        ++index;
    }
    return root;
}

static nlohmann::json theseus_dump_tree(TreeNode* root) {
    nlohmann::json out = nlohmann::json::array();
    if (root == nullptr) {
        return out;
    }
    std::queue<TreeNode*> pending;
    pending.push(root);
    while (!pending.empty()) {
        TreeNode* node = pending.front();
        pending.pop();
        if (node == nullptr) {
            out.push_back(nullptr);
            continue;
        }
        out.push_back(node->val);
        pending.push(node->left);
        pending.push(node->right);
    }
    while (!out.empty() && out.back().is_null()) {
        out.erase(out.size() - 1);
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
    let result_expr = result_expression(&call, return_type);

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
            format!("        ListNode* a{index} = theseus_build_list(args.at({index}));\n")
        }
        "TreeNode" => {
            format!("        TreeNode* a{index} = theseus_build_tree(args.at({index}));\n")
        }
        _ => format!(
            "        auto a{index} = args.at({index}).get<{}>();\n",
            cpp_type(param_type)
        ),
    }
}

fn result_expression(call: &str, return_type: &str) -> String {
    match return_type {
        "ListNode" => format!("theseus_dump_list({call})"),
        "TreeNode" => format!("theseus_dump_tree({call})"),
        nested if nested.ends_with("[][]") => format!("theseus_to_json_matrix({call})"),
        nested if nested.ends_with("[]") => format!("theseus_to_json_vector({call})"),
        _ => format!("nlohmann::json({call})"),
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
            "class Solution { public: int add(int a, int b) { return a + b; } };",
            "add",
            &["int".to_owned(), "int".to_owned()],
            "int",
        );
        assert!(source.contains("#include \"json.hpp\""));
        assert!(source.contains("theseus_solution.add(a0, a1)"));
        assert!(source.contains("args.at(0).get<int>()"));
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
        assert!(source.contains("theseus_dump_list"));
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
        assert!(source.contains("std::vector<std::vector<int>>"));
        assert!(!source.contains("theseus_to_json_matrix(theseus_solution"));
    }
}
