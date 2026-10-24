use serde_json::Value;

pub const DEFAULT_DOUBLE_EPSILON: f64 = 1e-6;

pub fn values_match(mode: &str, epsilon: Option<f64>, expected: &Value, actual: &Value) -> bool {
    if mode == "double" {
        let epsilon = epsilon
            .filter(|value| value.is_finite() && *value > 0.0)
            .unwrap_or(DEFAULT_DOUBLE_EPSILON);
        return double_match(expected, actual, epsilon);
    }
    expected == actual
}

fn double_match(expected: &Value, actual: &Value, epsilon: f64) -> bool {
    match (expected, actual) {
        (Value::Number(left), Value::Number(right)) => match (left.as_f64(), right.as_f64()) {
            (Some(left), Some(right)) => numbers_close(left, right, epsilon),
            _ => false,
        },
        (Value::Array(left), Value::Array(right)) => {
            left.len() == right.len()
                && left
                    .iter()
                    .zip(right)
                    .all(|(left, right)| double_match(left, right, epsilon))
        }
        _ => expected == actual,
    }
}

fn numbers_close(left: f64, right: f64, epsilon: f64) -> bool {
    if left == right {
        return true;
    }
    let difference = (left - right).abs();
    difference <= epsilon || difference <= epsilon * left.abs().max(right.abs())
}

#[cfg(test)]
mod tests {
    use serde_json::json;

    use super::{DEFAULT_DOUBLE_EPSILON, values_match};

    #[test]
    fn exact_matches_deep_equal_values() {
        assert!(values_match("exact", None, &json!([0, 1]), &json!([0, 1])));
        assert!(values_match(
            "exact",
            None,
            &json!({"a": [1, true, "x"]}),
            &json!({"a": [1, true, "x"]})
        ));
    }

    #[test]
    fn exact_is_order_sensitive_and_rejects_null_vs_empty_array() {
        assert!(!values_match("exact", None, &json!([1, 2]), &json!([2, 1])));
        assert!(!values_match("exact", None, &json!(null), &json!([])));
        assert!(!values_match("exact", None, &json!(1), &json!(1.0)));
    }

    #[test]
    fn double_mode_accepts_absolute_and_relative_tolerance() {
        assert!(values_match(
            "double",
            None,
            &json!(1.0),
            &json!(1.0 + 5e-7)
        ));
        assert!(values_match(
            "double",
            None,
            &json!(1_000_000.0),
            &json!(1_000_000.5)
        ));
        assert!(!values_match("double", None, &json!(1.0), &json!(1.01)));
        assert!(values_match("double", Some(0.1), &json!(1.0), &json!(1.05)));
    }

    #[test]
    fn double_mode_compares_arrays_elementwise() {
        assert!(values_match(
            "double",
            None,
            &json!([1.0, 2.0]),
            &json!([1.0000001, 2.0000001])
        ));
        assert!(!values_match(
            "double",
            None,
            &json!([1.0, 2.0]),
            &json!([1.0000001])
        ));
        assert!(!values_match(
            "double",
            None,
            &json!([1.0, 2.0]),
            &json!([1.0000001, 2.1])
        ));
    }

    #[test]
    fn default_epsilon_is_one_millionth() {
        assert_eq!(DEFAULT_DOUBLE_EPSILON, 1e-6);
    }
}
