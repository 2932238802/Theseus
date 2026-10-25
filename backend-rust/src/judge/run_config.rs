use serde_json::Value;

use crate::{
    common::error::AppError,
    models::run::{PublicCase, RunConfig},
};

pub const MAX_CODE_BYTES: usize = 64 * 1024;
pub const MAX_INPUT_BYTES: usize = 64 * 1024;
pub const MAX_PUBLIC_CASES: usize = 5;
pub const MAX_JUDGE_CASES: usize = 50;
pub const MAX_JUDGE_CASE_BYTES: usize = 256 * 1024;

const SCALAR_TYPES: [&str; 5] = ["int", "long", "double", "bool", "string"];
const NODE_TYPES: [&str; 2] = ["ListNode", "TreeNode"];

pub fn validate_run_config(value: &Value) -> Result<RunConfig, AppError> {
    let config: RunConfig = serde_json::from_value(value.clone())
        .map_err(|error| AppError::BadRequest(format!("run_config 格式无效: {error}")))?;
    if config.version != 1 {
        return Err(AppError::BadRequest(
            "run_config.version 仅支持 1".to_owned(),
        ));
    }
    if !is_identifier(&config.function_name) {
        return Err(AppError::BadRequest(
            "run_config.function_name 必须是合法的函数名".to_owned(),
        ));
    }
    let mut parameter_names = std::collections::HashSet::new();
    for param in &config.params {
        if param.name.trim().is_empty() || !is_identifier(&param.name) {
            return Err(AppError::BadRequest(
                "run_config.params 的参数名无效".to_owned(),
            ));
        }
        if !parameter_names.insert(param.name.as_str()) {
            return Err(AppError::BadRequest(
                "run_config.params 的参数名不能重复".to_owned(),
            ));
        }
        validate_type(&param.param_type)?;
    }
    validate_type(&config.return_type)?;
    if !matches!(config.compare.mode.as_str(), "exact" | "double") {
        return Err(AppError::BadRequest(
            "run_config.compare.mode 仅支持 exact 或 double".to_owned(),
        ));
    }
    if let Some(epsilon) = config.compare.epsilon
        && (!epsilon.is_finite() || epsilon <= 0.0)
    {
        return Err(AppError::BadRequest(
            "run_config.compare.epsilon 必须大于 0".to_owned(),
        ));
    }
    if config.public_cases.len() > MAX_PUBLIC_CASES {
        return Err(AppError::BadRequest(format!(
            "run_config.public_cases 最多 {MAX_PUBLIC_CASES} 条"
        )));
    }
    for public_case in &config.public_cases {
        validate_case_args(&config, public_case)?;
        if !value_matches_type(&config.return_type, &public_case.expected) {
            return Err(AppError::BadRequest(
                "run_config.public_cases.expected 与 return_type 不匹配".to_owned(),
            ));
        }
    }
    Ok(config)
}

/// Validates the hidden judging cases for a problem.
///
/// The shape mirrors `run_config.public_cases` (`args` / `expected`), but the
/// cases live in `problems.judge_cases` so they are never part of the
/// `run_config` payload returned to clients.
pub fn validate_judge_cases(
    config: &RunConfig,
    value: &Value,
) -> Result<Vec<PublicCase>, AppError> {
    if serde_json::to_vec(value).map_or(usize::MAX, |bytes| bytes.len()) > MAX_JUDGE_CASE_BYTES {
        return Err(AppError::BadRequest(format!(
            "judge_cases 不能超过 {} KB",
            MAX_JUDGE_CASE_BYTES / 1024
        )));
    }
    let items = value
        .as_array()
        .ok_or_else(|| AppError::BadRequest("judge_cases 必须是 JSON 数组".to_owned()))?;
    if items.len() + config.public_cases.len() > MAX_JUDGE_CASES {
        return Err(AppError::BadRequest(format!(
            "judge_cases 与 public_cases 合计最多 {MAX_JUDGE_CASES} 条"
        )));
    }
    let mut cases = Vec::with_capacity(items.len());
    for (index, item) in items.iter().enumerate() {
        let case: PublicCase = serde_json::from_value(item.clone()).map_err(|error| {
            AppError::BadRequest(format!(
                "judge_cases 第 {} 条格式无效（需要 args 与 expected）: {error}",
                index + 1
            ))
        })?;
        validate_case_args(config, &case).map_err(|error| match error {
            AppError::BadRequest(message) => {
                AppError::BadRequest(format!("judge_cases 第 {} 条：{message}", index + 1))
            }
            other => other,
        })?;
        if !value_matches_type(&config.return_type, &case.expected) {
            return Err(AppError::BadRequest(format!(
                "judge_cases 第 {} 条 expected 与 return_type 不匹配",
                index + 1
            )));
        }
        cases.push(case);
    }
    Ok(cases)
}

pub fn validate_input(config: &RunConfig, input: &Value) -> Result<Vec<Value>, AppError> {
    if serde_json::to_vec(input).map_or(usize::MAX, |bytes| bytes.len()) > MAX_INPUT_BYTES {
        return Err(AppError::BadRequest("自定义输入不能超过 64 KB".to_owned()));
    }
    let args = input
        .as_array()
        .ok_or_else(|| AppError::BadRequest("自定义输入必须是 JSON 数组".to_owned()))?;
    if args.len() != config.params.len() {
        return Err(AppError::BadRequest(format!(
            "参数个数不匹配：需要 {} 个，收到 {} 个",
            config.params.len(),
            args.len()
        )));
    }
    for (index, (param, value)) in config.params.iter().zip(args).enumerate() {
        if !value_matches_type(&param.param_type, value) {
            return Err(AppError::BadRequest(format!(
                "第 {} 个参数 {} 应为 {} 类型",
                index + 1,
                param.name,
                param.param_type
            )));
        }
    }
    Ok(args.clone())
}

/// 统一 TreeNode 的层序表示：去掉末尾多余的 null，便于与 harness 序列化结果比较。
pub fn normalize_for_compare(run_type: &str, value: &Value) -> Value {
    if run_type != "TreeNode" {
        return value.clone();
    }
    let Some(items) = value.as_array() else {
        return value.clone();
    };
    let mut items = items.clone();
    while items.last().is_some_and(Value::is_null) {
        items.pop();
    }
    Value::Array(items)
}

pub fn python_template(config: &RunConfig) -> String {
    let mut template = String::new();
    if uses_node_type(config) {
        template.push_str(PYTHON_NODE_DEFINITIONS);
    }
    let parameters = std::iter::once("self".to_owned())
        .chain(
            config
                .params
                .iter()
                .map(|param| format!("{}: {}", param.name, python_annotation(&param.param_type))),
        )
        .collect::<Vec<_>>()
        .join(", ");
    template.push_str(&format!(
        "class Solution:\n    def {}({}) -> {}:\n        pass\n",
        config.function_name,
        parameters,
        python_annotation(&config.return_type)
    ));
    template
}

pub fn javascript_template(config: &RunConfig) -> String {
    let mut template = String::new();
    if uses_node_type(config) {
        template.push_str(JAVASCRIPT_NODE_DEFINITIONS);
        template.push('\n');
    }
    let parameters = config
        .params
        .iter()
        .map(|param| param.name.clone())
        .collect::<Vec<_>>()
        .join(", ");
    template.push_str(&format!(
        "var {} = function({}) {{\n}};\n",
        config.function_name, parameters
    ));
    template
}

pub fn cpp_template(config: &RunConfig) -> String {
    let mut template = String::from("#include <bits/stdc++.h>\nusing namespace std;\n\n");
    if uses_node_type(config) {
        template.push_str(CPP_NODE_DEFINITIONS);
        template.push('\n');
    }
    let parameters = config
        .params
        .iter()
        .map(|param| cpp_declaration(&param.param_type, &param.name))
        .collect::<Vec<_>>()
        .join(", ");
    template.push_str(&format!(
        "class Solution {{\npublic:\n    {} {}({}) {{\n        return {};\n    }}\n}};\n",
        cpp_type(&config.return_type),
        config.function_name,
        parameters,
        cpp_default_value(&config.return_type)
    ));
    template
}

pub fn java_template(config: &RunConfig) -> String {
    let mut template = String::new();
    if uses_node_type(config) {
        template.push_str(JAVA_NODE_DEFINITIONS);
        template.push('\n');
    }
    let parameters = config
        .params
        .iter()
        .map(|param| format!("{} {}", java_type(&param.param_type), param.name))
        .collect::<Vec<_>>()
        .join(", ");
    template.push_str(&format!(
        "class Solution {{\n    public {} {}({}) {{\n        return {};\n    }}\n}}\n",
        java_type(&config.return_type),
        config.function_name,
        parameters,
        java_default_value(&config.return_type)
    ));
    template
}

pub fn signature_hint(config: &RunConfig) -> String {
    let parameters = config
        .params
        .iter()
        .map(|param| format!("{}: {}", param.name, param.param_type))
        .collect::<Vec<_>>()
        .join(", ");
    format!(
        "{}({}) -> {}",
        config.function_name, parameters, config.return_type
    )
}

fn validate_case_args(config: &RunConfig, public_case: &PublicCase) -> Result<(), AppError> {
    if public_case.args.len() != config.params.len() {
        return Err(AppError::BadRequest("args 数量与 params 不一致".to_owned()));
    }
    for (param, value) in config.params.iter().zip(&public_case.args) {
        if !value_matches_type(&param.param_type, value) {
            return Err(AppError::BadRequest(format!(
                "args 中 {} 的类型应为 {}",
                param.name, param.param_type
            )));
        }
    }
    Ok(())
}

fn validate_type(value: &str) -> Result<(), AppError> {
    if is_scalar_type(value) || is_node_type(value) {
        return Ok(());
    }
    if let Some(element) = value.strip_suffix("[]")
        && (is_scalar_type(element) || is_scalar_array_type(element))
    {
        return Ok(());
    }
    Err(AppError::BadRequest(format!(
        "不支持的类型 {value}；支持基础类型、一维/二维数组、ListNode、TreeNode"
    )))
}

fn is_scalar_type(value: &str) -> bool {
    SCALAR_TYPES.contains(&value)
}

fn is_node_type(value: &str) -> bool {
    NODE_TYPES.contains(&value)
}

fn is_scalar_array_type(value: &str) -> bool {
    value.strip_suffix("[]").is_some_and(is_scalar_type)
}

pub fn value_matches_type(run_type: &str, value: &Value) -> bool {
    match run_type {
        "ListNode" => value
            .as_array()
            .is_some_and(|items| items.iter().all(int_matches)),
        "TreeNode" => value
            .as_array()
            .is_some_and(|items| items.iter().all(|item| item.is_null() || int_matches(item))),
        _ => {
            if is_scalar_type(run_type) {
                return scalar_matches(run_type, value);
            }
            let Some(element) = run_type.strip_suffix("[]") else {
                return false;
            };
            if is_scalar_type(element) {
                return value
                    .as_array()
                    .is_some_and(|items| items.iter().all(|item| scalar_matches(element, item)));
            }
            if is_scalar_array_type(element) {
                let scalar = element.strip_suffix("[]").unwrap_or(element);
                return value.as_array().is_some_and(|rows| {
                    rows.iter().all(|row| {
                        row.as_array().is_some_and(|items| {
                            items.iter().all(|item| scalar_matches(scalar, item))
                        })
                    })
                });
            }
            false
        }
    }
}

fn scalar_matches(run_type: &str, value: &Value) -> bool {
    match run_type {
        "int" => int_matches(value),
        "long" => value.as_i64().is_some(),
        "double" => value.is_number(),
        "bool" => value.is_boolean(),
        "string" => value.is_string(),
        _ => false,
    }
}

fn int_matches(value: &Value) -> bool {
    value
        .as_i64()
        .is_some_and(|number| i32::try_from(number).is_ok())
}

fn python_annotation(run_type: &str) -> String {
    match run_type {
        "int" | "long" => "int".to_owned(),
        "double" => "float".to_owned(),
        "bool" => "bool".to_owned(),
        "string" => "str".to_owned(),
        "ListNode" => "ListNode | None".to_owned(),
        "TreeNode" => "TreeNode | None".to_owned(),
        nested if nested.ends_with("[]") => {
            let element = nested.strip_suffix("[]").unwrap_or(nested);
            format!("list[{}]", python_annotation(element))
        }
        _ => "object".to_owned(),
    }
}

pub(crate) fn cpp_type(run_type: &str) -> String {
    match run_type {
        "int" => "int".to_owned(),
        "long" => "long long".to_owned(),
        "double" => "double".to_owned(),
        "bool" => "bool".to_owned(),
        "string" => "std::string".to_owned(),
        "ListNode" => "ListNode*".to_owned(),
        "TreeNode" => "TreeNode*".to_owned(),
        nested if nested.ends_with("[]") => {
            let element = nested.strip_suffix("[]").unwrap_or(nested);
            format!("std::vector<{}>", cpp_type(element))
        }
        _ => "int".to_owned(),
    }
}

fn cpp_declaration(run_type: &str, name: &str) -> String {
    if run_type.ends_with("[]") {
        format!("{}& {}", cpp_type(run_type), name)
    } else {
        format!("{} {}", cpp_type(run_type), name)
    }
}

fn cpp_default_value(run_type: &str) -> &'static str {
    match run_type {
        "int" | "long" => "0",
        "double" => "0.0",
        "bool" => "false",
        "string" => "\"\"",
        "ListNode" | "TreeNode" => "nullptr",
        nested if nested.ends_with("[]") => "{}",
        _ => "{}",
    }
}

pub(crate) fn java_type(run_type: &str) -> String {
    match run_type {
        "int" => "int".to_owned(),
        "long" => "long".to_owned(),
        "double" => "double".to_owned(),
        "bool" => "boolean".to_owned(),
        "string" => "String".to_owned(),
        "ListNode" => "ListNode".to_owned(),
        "TreeNode" => "TreeNode".to_owned(),
        nested if nested.ends_with("[]") => {
            let element = nested.strip_suffix("[]").unwrap_or(nested);
            format!("{}[]", java_type(element))
        }
        _ => "int".to_owned(),
    }
}

fn java_default_value(run_type: &str) -> String {
    match run_type {
        "int" => "0".to_owned(),
        "long" => "0L".to_owned(),
        "double" => "0.0".to_owned(),
        "bool" => "false".to_owned(),
        "string" => "\"\"".to_owned(),
        "ListNode" | "TreeNode" => "null".to_owned(),
        nested if nested.ends_with("[]") => format!("new {}{{}}", java_type(nested)),
        _ => "0".to_owned(),
    }
}

fn uses_node_type(config: &RunConfig) -> bool {
    config
        .params
        .iter()
        .any(|param| is_node_type(&param.param_type))
        || is_node_type(&config.return_type)
}

fn is_identifier(value: &str) -> bool {
    let mut characters = value.chars();
    let Some(first) = characters.next() else {
        return false;
    };
    if !(first == '_' || first.is_ascii_alphabetic()) {
        return false;
    }
    characters.all(|character| character == '_' || character.is_ascii_alphanumeric())
}

const PYTHON_NODE_DEFINITIONS: &str = r#"class ListNode:
    def __init__(self, val: int = 0, next: "ListNode | None" = None):
        self.val = val
        self.next = next


class TreeNode:
    def __init__(
        self,
        val: int = 0,
        left: "TreeNode | None" = None,
        right: "TreeNode | None" = None,
    ):
        self.val = val
        self.left = left
        self.right = right


"#;

const JAVASCRIPT_NODE_DEFINITIONS: &str = r#"function ListNode(val, next) {
  this.val = val === undefined ? 0 : val;
  this.next = next === undefined ? null : next;
}

function TreeNode(val, left, right) {
  this.val = val === undefined ? 0 : val;
  this.left = left === undefined ? null : left;
  this.right = right === undefined ? null : right;
}
"#;

pub(crate) const CPP_NODE_DEFINITIONS: &str = r#"#ifndef THESEUS_LIST_NODE_DEFINED
#define THESEUS_LIST_NODE_DEFINED
struct ListNode {
    int val;
    ListNode* next;
    ListNode() : val(0), next(nullptr) {}
    explicit ListNode(int x) : val(x), next(nullptr) {}
    ListNode(int x, ListNode* next) : val(x), next(next) {}
};
#endif

#ifndef THESEUS_TREE_NODE_DEFINED
#define THESEUS_TREE_NODE_DEFINED
struct TreeNode {
    int val;
    TreeNode* left;
    TreeNode* right;
    TreeNode() : val(0), left(nullptr), right(nullptr) {}
    explicit TreeNode(int x) : val(x), left(nullptr), right(nullptr) {}
    TreeNode(int x, TreeNode* left, TreeNode* right) : val(x), left(left), right(right) {}
};
#endif

"#;

const JAVA_NODE_DEFINITIONS: &str = r#"class ListNode {
    int val;
    ListNode next;
    ListNode() {}
    ListNode(int val) { this.val = val; }
    ListNode(int val, ListNode next) { this.val = val; this.next = next; }
}

class TreeNode {
    int val;
    TreeNode left;
    TreeNode right;
    TreeNode() {}
    TreeNode(int val) { this.val = val; }
    TreeNode(int val, TreeNode left, TreeNode right) {
        this.val = val;
        this.left = left;
        this.right = right;
    }
}

"#;

#[cfg(test)]
mod tests {
    use serde_json::json;

    use super::{
        cpp_template, java_template, javascript_template, normalize_for_compare, python_template,
        validate_input, validate_judge_cases, validate_run_config,
    };

    fn config() -> serde_json::Value {
        json!({
            "version": 1,
            "function_name": "twoSum",
            "params": [
                { "name": "nums", "type": "int[]" },
                { "name": "target", "type": "int" }
            ],
            "return_type": "int[]",
            "compare": { "mode": "exact" },
            "public_cases": [
                { "args": [[2, 7, 11, 15], 9], "expected": [0, 1] }
            ]
        })
    }

    fn list_config() -> serde_json::Value {
        json!({
            "version": 1,
            "function_name": "reverseList",
            "params": [{ "name": "head", "type": "ListNode" }],
            "return_type": "ListNode",
            "compare": { "mode": "exact" },
            "public_cases": [
                { "args": [[1, 2, 3]], "expected": [3, 2, 1] }
            ]
        })
    }

    fn tree_config() -> serde_json::Value {
        json!({
            "version": 1,
            "function_name": "invertTree",
            "params": [{ "name": "root", "type": "TreeNode" }],
            "return_type": "TreeNode",
            "compare": { "mode": "exact" },
            "public_cases": [
                { "args": [[4, 2, 7, 1, 3, 6, 9]], "expected": [4, 7, 2, 9, 6, 3, 1] }
            ]
        })
    }

    #[test]
    fn accepts_basic_config_and_builds_templates() {
        let parsed = validate_run_config(&config()).expect("config should be valid");
        assert!(
            python_template(&parsed)
                .contains("def twoSum(self, nums: list[int], target: int) -> list[int]:")
        );
        assert_eq!(
            javascript_template(&parsed),
            "var twoSum = function(nums, target) {\n};\n"
        );
        assert!(cpp_template(&parsed).contains("vector<int>& nums, int target"));
        assert!(java_template(&parsed).contains("public int[] twoSum(int[] nums, int target)"));
    }

    #[test]
    fn accepts_nested_arrays_and_linked_types() {
        let mut nested = config();
        nested["params"][0]["type"] = json!("int[][]");
        nested["public_cases"][0]["args"][0] = json!([[1, 2], [3]]);
        nested["return_type"] = json!("int");
        nested["public_cases"][0]["expected"] = json!(1);
        let parsed = validate_run_config(&nested).expect("int[][] should be valid");
        assert!(python_template(&parsed).contains("list[list[int]]"));
        assert!(cpp_template(&parsed).contains("std::vector<std::vector<int>>&"));

        let listed = validate_run_config(&list_config()).expect("ListNode should be valid");
        assert!(python_template(&listed).contains("class ListNode"));
        assert!(java_template(&listed).contains("ListNode head"));
        assert!(cpp_template(&listed).contains("ListNode* head"));

        let tree = validate_run_config(&tree_config()).expect("TreeNode should be valid");
        assert!(javascript_template(&tree).contains("function TreeNode"));
    }

    #[test]
    fn rejects_unknown_types() {
        for run_type in ["void", "graph", "int[][][]"] {
            let mut value = config();
            value["params"][0]["type"] = json!(run_type);
            assert!(
                validate_run_config(&value).is_err(),
                "{run_type} should fail"
            );
        }
    }

    #[test]
    fn validates_node_inputs_and_normalizes_trees() {
        let list = validate_run_config(&list_config()).expect("ListNode should be valid");
        assert!(validate_input(&list, &json!([[1, 2, 3]])).is_ok());
        assert!(validate_input(&list, &json!([[1, "x"]])).is_err());

        let tree = validate_run_config(&tree_config()).expect("TreeNode should be valid");
        assert!(validate_input(&tree, &json!([[1, null, 2]])).is_ok());
        assert!(validate_input(&tree, &json!([[true]])).is_err());

        assert_eq!(
            normalize_for_compare("TreeNode", &json!([1, null, 2, null, null])),
            json!([1, null, 2])
        );
        assert_eq!(
            normalize_for_compare("int[]", &json!([1, null, 2])),
            json!([1, null, 2])
        );
    }

    #[test]
    fn rejects_bad_input_shape_and_types() {
        let parsed = validate_run_config(&config()).expect("config should be valid");
        assert!(validate_input(&parsed, &json!([[1, 2], 3])).is_ok());
        assert!(validate_input(&parsed, &json!({"nums": [1], "target": 2})).is_err());
        assert!(validate_input(&parsed, &json!([[1, 2]])).is_err());
        assert!(validate_input(&parsed, &json!([["1"], 2])).is_err());
    }

    #[test]
    fn rejects_mismatched_public_case_expected() {
        let mut value = config();
        value["public_cases"][0]["expected"] = json!("wrong");
        assert!(validate_run_config(&value).is_err());
    }

    #[test]
    fn validates_judge_cases_against_run_config() {
        let parsed = validate_run_config(&config()).expect("config should be valid");
        let cases = validate_judge_cases(
            &parsed,
            &json!([
                { "args": [[3, 2, 4], 6], "expected": [1, 2] },
                { "args": [[3, 3], 6], "expected": [0, 1] }
            ]),
        )
        .expect("judge cases should be valid");
        assert_eq!(cases.len(), 2);
    }

    #[test]
    fn rejects_invalid_judge_cases() {
        let parsed = validate_run_config(&config()).expect("config should be valid");
        assert!(validate_judge_cases(&parsed, &json!({"args": []})).is_err());
        assert!(
            validate_judge_cases(&parsed, &json!([{"args": [[1, 2]], "expected": [0]}])).is_err()
        );
        assert!(
            validate_judge_cases(
                &parsed,
                &json!([{ "args": [[1, 2], 3], "expected": "wrong" }])
            )
            .is_err()
        );
        let too_many: Vec<_> = (0..super::MAX_JUDGE_CASES)
            .map(|_| json!({ "args": [[1, 2], 3], "expected": [0, 1] }))
            .collect();
        assert!(validate_judge_cases(&parsed, &json!(too_many)).is_err());
    }
}
