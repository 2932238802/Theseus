use serde_json::Value;

use crate::{
    common::error::AppError,
    models::run::{PublicCase, RunConfig},
};

pub const MAX_CODE_BYTES: usize = 64 * 1024;
pub const MAX_INPUT_BYTES: usize = 64 * 1024;
pub const MAX_PUBLIC_CASES: usize = 5;

const SCALAR_TYPES: [&str; 5] = ["int", "long", "double", "bool", "string"];

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

pub fn python_template(config: &RunConfig) -> String {
    let parameters = std::iter::once("self".to_owned())
        .chain(
            config
                .params
                .iter()
                .map(|param| format!("{}: {}", param.name, python_annotation(&param.param_type))),
        )
        .collect::<Vec<_>>()
        .join(", ");
    format!(
        "class Solution:\n    def {}({}) -> {}:\n        pass\n",
        config.function_name,
        parameters,
        python_annotation(&config.return_type)
    )
}

pub fn javascript_template(config: &RunConfig) -> String {
    let parameters = config
        .params
        .iter()
        .map(|param| param.name.clone())
        .collect::<Vec<_>>()
        .join(", ");
    format!(
        "var {} = function({}) {{\n}};\n",
        config.function_name, parameters
    )
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
        return Err(AppError::BadRequest(
            "run_config.public_cases.args 数量与 params 不一致".to_owned(),
        ));
    }
    for (param, value) in config.params.iter().zip(&public_case.args) {
        if !value_matches_type(&param.param_type, value) {
            return Err(AppError::BadRequest(format!(
                "run_config.public_cases.args 中 {} 的类型应为 {}",
                param.name, param.param_type
            )));
        }
    }
    Ok(())
}

fn validate_type(value: &str) -> Result<(), AppError> {
    if is_scalar_type(value) {
        return Ok(());
    }
    if let Some(element) = value.strip_suffix("[]")
        && is_scalar_type(element)
    {
        return Ok(());
    }
    Err(AppError::BadRequest(format!(
        "不支持的类型 {value}；P1 仅支持基础类型和一维数组"
    )))
}

fn is_scalar_type(value: &str) -> bool {
    SCALAR_TYPES.contains(&value)
}

pub fn value_matches_type(run_type: &str, value: &Value) -> bool {
    if is_scalar_type(run_type) {
        return scalar_matches(run_type, value);
    }
    let Some(element) = run_type.strip_suffix("[]") else {
        return false;
    };
    if !is_scalar_type(element) {
        return false;
    }
    value
        .as_array()
        .is_some_and(|items| items.iter().all(|item| scalar_matches(element, item)))
}

fn scalar_matches(run_type: &str, value: &Value) -> bool {
    match run_type {
        "int" => value
            .as_i64()
            .is_some_and(|number| i32::try_from(number).is_ok()),
        "long" => value.as_i64().is_some(),
        "double" => value.is_number(),
        "bool" => value.is_boolean(),
        "string" => value.is_string(),
        _ => false,
    }
}

fn python_annotation(run_type: &str) -> &'static str {
    match run_type {
        "int" | "long" => "int",
        "double" => "float",
        "bool" => "bool",
        "string" => "str",
        "int[]" => "list[int]",
        "long[]" => "list[int]",
        "double[]" => "list[float]",
        "bool[]" => "list[bool]",
        "string[]" => "list[str]",
        _ => "object",
    }
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

#[cfg(test)]
mod tests {
    use serde_json::json;

    use super::{javascript_template, python_template, validate_input, validate_run_config};

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

    #[test]
    fn accepts_basic_config_and_builds_template() {
        let parsed = validate_run_config(&config()).expect("config should be valid");
        let template = python_template(&parsed);
        assert!(template.contains("def twoSum(self, nums: list[int], target: int) -> list[int]:"));
        assert!(template.contains("pass"));
    }

    #[test]
    fn builds_javascript_template() {
        let parsed = validate_run_config(&config()).expect("config should be valid");
        let template = javascript_template(&parsed);
        assert_eq!(template, "var twoSum = function(nums, target) {\n};\n");
    }

    #[test]
    fn rejects_nested_arrays_and_linked_types() {
        for run_type in ["int[][]", "ListNode", "TreeNode"] {
            let mut value = config();
            value["params"][0]["type"] = json!(run_type);
            assert!(
                validate_run_config(&value).is_err(),
                "{run_type} should fail"
            );
        }
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
}
