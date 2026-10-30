//! 代码相似度的纯函数实现：词法归一化 + k-gram 指纹 + winnowing。
//!
//! 设计取舍：
//! - 不引入 tree-sitter/AST 依赖，按语言做轻量词法归一化：去掉注释与字符串内容，
//!   把标识符统一成 `ID`、数字统一成 `NUM`、字符串统一成 `STR`，保留关键字与标点；
//! - 对归一化后的 token 序列取 5-gram，再按窗口 4 做 winnowing 选指纹；
//! - 相似度用 containment（交集 / 较小指纹集合），对「复制后加料」更稳健；
//! - 只做同语言比对，跨语言结构比对留待后续。

use std::collections::{HashMap, HashSet};

use serde::Serialize;

/// 指纹算法标识，写入 `similarity_pairs.algorithm`。
pub const ALGORITHM: &str = "winnowing-token";

const K: usize = 5;
const W: usize = 4;
const FNV_OFFSET: u64 = 0xcbf2_9ce4_8422_2325;
const FNV_PRIME: u64 = 0x0000_0100_0000_01b3;

#[derive(Debug, Clone, PartialEq, Serialize)]
pub struct SimilarityScore {
    /// containment：匹配指纹数 / 较小指纹集合大小，取值 0..=1。
    pub score: f64,
    pub containment: f64,
    pub jaccard: f64,
    pub a_grams: usize,
    pub b_grams: usize,
    pub matched_grams: usize,
    pub fragments: Vec<MatchFragment>,
}

impl SimilarityScore {
    pub fn empty() -> Self {
        Self {
            score: 0.0,
            containment: 0.0,
            jaccard: 0.0,
            a_grams: 0,
            b_grams: 0,
            matched_grams: 0,
            fragments: Vec::new(),
        }
    }
}

#[derive(Debug, Clone, PartialEq, Eq, Serialize)]
pub struct MatchFragment {
    /// 归一化 token 下标，闭区间。
    pub a_start: usize,
    pub a_end: usize,
    pub b_start: usize,
    pub b_end: usize,
}

#[derive(Debug, Clone, Default)]
pub struct Fingerprint {
    pub token_count: usize,
    pub selected: Vec<(u64, usize)>,
}

impl Fingerprint {
    pub fn gram_count(&self) -> usize {
        self.selected.len()
    }

    pub fn is_empty(&self) -> bool {
        self.selected.is_empty()
    }
}

/// 归一化并生成 winnowing 指纹。调用方应先按 `min_tokens` 过滤过短的代码。
pub fn fingerprint(language: &str, code: &str) -> Fingerprint {
    let tokens = normalize_tokens(language, code);
    let token_count = tokens.len();
    let selected = select_grams(&tokens);
    Fingerprint {
        token_count,
        selected,
    }
}

/// 把源码归一化成 token 序列。语言不在支持列表时按 C 风格词法处理。
pub fn normalize_tokens(language: &str, code: &str) -> Vec<String> {
    let chars: Vec<char> = code.chars().collect();
    match language {
        "python" => normalize_python(&chars),
        _ => normalize_c_like(language, &chars),
    }
}

/// 比较两份指纹。`score` 使用 containment，便于识别“在原代码上做局部修改”。
pub fn compare(a: &Fingerprint, b: &Fingerprint) -> SimilarityScore {
    if a.selected.is_empty() || b.selected.is_empty() {
        return SimilarityScore::empty();
    }
    let set_a: HashSet<u64> = a.selected.iter().map(|(hash, _)| *hash).collect();
    let set_b: HashSet<u64> = b.selected.iter().map(|(hash, _)| *hash).collect();
    let matched: HashSet<u64> = set_a.intersection(&set_b).copied().collect();
    let intersection = matched.len();
    if intersection == 0 {
        return SimilarityScore {
            a_grams: set_a.len(),
            b_grams: set_b.len(),
            ..SimilarityScore::empty()
        };
    }
    let union = set_a.union(&set_b).count();
    let smaller = set_a.len().min(set_b.len());
    let containment = intersection as f64 / smaller as f64;
    let jaccard = intersection as f64 / union as f64;

    let fragments = fragments(&matched, &a.selected, &b.selected);

    SimilarityScore {
        // containment 与 jaccard 取较大值：短代码片段被整体复制时 jaccard 会被稀释。
        score: containment.max(jaccard),
        containment,
        jaccard,
        a_grams: set_a.len(),
        b_grams: set_b.len(),
        matched_grams: intersection,
        fragments,
    }
}

/// 阈值分级。低于 `record` 返回 `None`，表示连比对记录都不需要保留。
pub fn severity_for(
    score: f64,
    record_threshold: f64,
    report_threshold: f64,
    high_threshold: f64,
) -> Option<&'static str> {
    if score >= high_threshold {
        Some("high")
    } else if score >= report_threshold {
        Some("medium")
    } else if score >= record_threshold {
        Some("low")
    } else {
        None
    }
}

fn select_grams(tokens: &[String]) -> Vec<(u64, usize)> {
    if tokens.len() < K {
        return Vec::new();
    }
    let hashes: Vec<u64> = tokens.windows(K).map(hash_gram).collect();
    if hashes.len() < W {
        let (position, hash) = hashes
            .iter()
            .enumerate()
            .min_by_key(|(index, hash)| (**hash, *index))
            .expect("non-empty hashes");
        return vec![(*hash, position)];
    }
    let mut selected = Vec::new();
    let mut last_position = None;
    for (window_start, window) in hashes.windows(W).enumerate() {
        let (offset, hash) = window
            .iter()
            .enumerate()
            .min_by_key(|(index, hash)| (**hash, *index))
            .expect("non-empty window");
        let position = window_start + offset;
        if last_position != Some(position) {
            selected.push((*hash, position));
            last_position = Some(position);
        }
    }
    selected
}

fn hash_gram(tokens: &[String]) -> u64 {
    let mut hash = FNV_OFFSET;
    for token in tokens {
        for byte in token.as_bytes() {
            hash ^= u64::from(*byte);
            hash = hash.wrapping_mul(FNV_PRIME);
        }
        // token 之间加分隔符，避免 ("ab","c") 与 ("a","bc") 哈希相同。
        hash ^= 0xff;
        hash = hash.wrapping_mul(FNV_PRIME);
    }
    hash
}

fn fragments(
    matched: &HashSet<u64>,
    a_selected: &[(u64, usize)],
    b_selected: &[(u64, usize)],
) -> Vec<MatchFragment> {
    let b_positions: HashMap<u64, usize> = b_selected
        .iter()
        .map(|(hash, position)| (*hash, *position))
        .collect();
    let mut pairs: Vec<(usize, usize)> = a_selected
        .iter()
        .filter_map(|(hash, position)| {
            matched
                .contains(hash)
                .then(|| {
                    b_positions
                        .get(hash)
                        .map(|b_position| (*position, *b_position))
                })
                .flatten()
        })
        .collect();
    pairs.sort_unstable();
    pairs.dedup();

    let mut merged: Vec<MatchFragment> = Vec::new();
    for (a_position, b_position) in pairs {
        let a_end = a_position + K - 1;
        let b_end = b_position + K - 1;
        if let Some(last) = merged.last_mut()
            && a_position <= last.a_end + 1
        {
            last.a_end = last.a_end.max(a_end);
            last.b_start = last.b_start.min(b_position);
            last.b_end = last.b_end.max(b_end);
            continue;
        }
        merged.push(MatchFragment {
            a_start: a_position,
            a_end,
            b_start: b_position,
            b_end,
        });
        if merged.len() >= 40 {
            break;
        }
    }
    merged
}

fn normalize_python(chars: &[char]) -> Vec<String> {
    let mut tokens = Vec::new();
    let mut index = 0;
    while index < chars.len() {
        let current = chars[index];
        if current.is_whitespace() {
            index += 1;
            continue;
        }
        if current == '#' {
            index = skip_line(chars, index);
            continue;
        }
        if current == '"' || current == '\'' {
            let triple = index + 2 < chars.len()
                && chars[index + 1] == current
                && chars[index + 2] == current;
            index = if triple {
                skip_triple_string(chars, index, current)
            } else {
                skip_quoted(chars, index, current)
            };
            tokens.push("STR".to_owned());
            continue;
        }
        if is_identifier_start(current) {
            let (token, next) = read_identifier(chars, index);
            index = next;
            if is_python_keyword(&token) {
                tokens.push(token);
            } else {
                tokens.push("ID".to_owned());
            }
            continue;
        }
        if current.is_ascii_digit() {
            index = read_number(chars, index);
            tokens.push("NUM".to_owned());
            continue;
        }
        tokens.push(current.to_string());
        index += 1;
    }
    tokens
}

fn normalize_c_like(language: &str, chars: &[char]) -> Vec<String> {
    let allow_template = language == "javascript";
    let mut tokens = Vec::new();
    let mut index = 0;
    while index < chars.len() {
        let current = chars[index];
        if current.is_whitespace() {
            index += 1;
            continue;
        }
        if current == '/' && index + 1 < chars.len() && chars[index + 1] == '/' {
            index = skip_line(chars, index);
            continue;
        }
        if current == '/' && index + 1 < chars.len() && chars[index + 1] == '*' {
            index = skip_block_comment(chars, index);
            continue;
        }
        if current == '"' || current == '\'' || (allow_template && current == '`') {
            index = skip_quoted(chars, index, current);
            tokens.push("STR".to_owned());
            continue;
        }
        if is_identifier_start(current) {
            let (token, next) = read_identifier(chars, index);
            index = next;
            if is_c_like_keyword(language, &token) {
                tokens.push(token);
            } else {
                tokens.push("ID".to_owned());
            }
            continue;
        }
        if current.is_ascii_digit() {
            index = read_number(chars, index);
            tokens.push("NUM".to_owned());
            continue;
        }
        tokens.push(current.to_string());
        index += 1;
    }
    tokens
}

fn skip_line(chars: &[char], mut index: usize) -> usize {
    while index < chars.len() && chars[index] != '\n' {
        index += 1;
    }
    index
}

fn skip_block_comment(chars: &[char], mut index: usize) -> usize {
    index += 2;
    while index + 1 < chars.len() {
        if chars[index] == '*' && chars[index + 1] == '/' {
            return index + 2;
        }
        index += 1;
    }
    chars.len()
}

fn skip_quoted(chars: &[char], mut index: usize, quote: char) -> usize {
    index += 1;
    while index < chars.len() {
        if chars[index] == '\\' {
            index += 2;
            continue;
        }
        if chars[index] == quote {
            return index + 1;
        }
        index += 1;
    }
    chars.len()
}

fn skip_triple_string(chars: &[char], mut index: usize, quote: char) -> usize {
    index += 3;
    while index + 2 < chars.len() {
        if chars[index] == quote && chars[index + 1] == quote && chars[index + 2] == quote {
            return index + 3;
        }
        if chars[index] == '\\' {
            index += 2;
            continue;
        }
        index += 1;
    }
    chars.len()
}

fn is_identifier_start(current: char) -> bool {
    current == '_' || current.is_alphabetic()
}

fn read_identifier(chars: &[char], mut index: usize) -> (String, usize) {
    let start = index;
    while index < chars.len() && (chars[index] == '_' || chars[index].is_alphanumeric()) {
        index += 1;
    }
    (chars[start..index].iter().collect(), index)
}

fn read_number(chars: &[char], mut index: usize) -> usize {
    while index < chars.len()
        && (chars[index].is_ascii_alphanumeric() || chars[index] == '_' || chars[index] == '.')
    {
        index += 1;
    }
    index
}

fn is_python_keyword(ident: &str) -> bool {
    matches!(
        ident,
        "false"
            | "none"
            | "true"
            | "and"
            | "as"
            | "assert"
            | "async"
            | "await"
            | "break"
            | "class"
            | "continue"
            | "def"
            | "del"
            | "elif"
            | "else"
            | "except"
            | "finally"
            | "for"
            | "from"
            | "global"
            | "if"
            | "import"
            | "in"
            | "is"
            | "lambda"
            | "nonlocal"
            | "not"
            | "or"
            | "pass"
            | "raise"
            | "return"
            | "try"
            | "while"
            | "with"
            | "yield"
            | "match"
            | "case"
    )
}

fn is_c_like_keyword(language: &str, ident: &str) -> bool {
    match language {
        "javascript" => matches!(
            ident,
            "break"
                | "case"
                | "catch"
                | "class"
                | "const"
                | "continue"
                | "debugger"
                | "default"
                | "delete"
                | "do"
                | "else"
                | "export"
                | "extends"
                | "false"
                | "finally"
                | "for"
                | "function"
                | "if"
                | "import"
                | "in"
                | "instanceof"
                | "let"
                | "new"
                | "null"
                | "of"
                | "return"
                | "static"
                | "super"
                | "switch"
                | "this"
                | "throw"
                | "true"
                | "try"
                | "typeof"
                | "undefined"
                | "var"
                | "void"
                | "while"
                | "with"
                | "yield"
                | "async"
                | "await"
        ),
        "cpp" => matches!(
            ident,
            "alignas"
                | "alignof"
                | "auto"
                | "bool"
                | "break"
                | "case"
                | "catch"
                | "char"
                | "class"
                | "const"
                | "constexpr"
                | "continue"
                | "default"
                | "delete"
                | "do"
                | "double"
                | "else"
                | "enum"
                | "explicit"
                | "extern"
                | "false"
                | "float"
                | "for"
                | "friend"
                | "goto"
                | "if"
                | "inline"
                | "int"
                | "long"
                | "namespace"
                | "new"
                | "nullptr"
                | "operator"
                | "private"
                | "protected"
                | "public"
                | "return"
                | "short"
                | "signed"
                | "sizeof"
                | "static"
                | "struct"
                | "switch"
                | "template"
                | "this"
                | "throw"
                | "true"
                | "try"
                | "typedef"
                | "typename"
                | "union"
                | "unsigned"
                | "using"
                | "virtual"
                | "void"
                | "volatile"
                | "while"
                | "std"
                | "string"
                | "vector"
                | "cin"
                | "cout"
                | "endl"
        ),
        "java" => matches!(
            ident,
            "abstract"
                | "assert"
                | "boolean"
                | "break"
                | "byte"
                | "case"
                | "catch"
                | "char"
                | "class"
                | "const"
                | "continue"
                | "default"
                | "do"
                | "double"
                | "else"
                | "enum"
                | "extends"
                | "false"
                | "final"
                | "finally"
                | "float"
                | "for"
                | "if"
                | "implements"
                | "import"
                | "instanceof"
                | "int"
                | "interface"
                | "long"
                | "native"
                | "new"
                | "null"
                | "package"
                | "private"
                | "protected"
                | "public"
                | "return"
                | "sealed"
                | "short"
                | "static"
                | "strictfp"
                | "super"
                | "switch"
                | "synchronized"
                | "this"
                | "throw"
                | "throws"
                | "transient"
                | "true"
                | "try"
                | "var"
                | "void"
                | "volatile"
                | "while"
                | "yield"
                | "record"
                | "permits"
        ),
        _ => false,
    }
}

#[cfg(test)]
mod tests {
    use super::{ALGORITHM, compare, fingerprint, normalize_tokens, severity_for};

    #[test]
    fn algorithm_name_is_stable() {
        assert_eq!(ALGORITHM, "winnowing-token");
    }

    #[test]
    fn comments_and_strings_are_removed() {
        let code = r#"
            // comment with many many tokens tokens tokens
            def solve(a, b):
                """docstring mentioning an entirely different algorithm"""
                return a + b  # trailing comment
        "#;
        let tokens = normalize_tokens("python", code);
        assert!(!tokens.iter().any(|token| token == "comment"));
        assert!(!tokens.iter().any(|token| token == "docstring"));
        assert!(tokens.contains(&"return".to_owned()));
        assert!(tokens.contains(&"STR".to_owned()));
    }

    #[test]
    fn renamed_identifiers_remain_similar() {
        let original = r#"
            def solve(values):
                total = 0
                for value in values:
                    total = total + value
                return total
        "#;
        let renamed = r#"
            def calculate(items):
                result = 0
                for item in items:
                    result = result + item
                return result
        "#;
        let a = fingerprint("python", original);
        let b = fingerprint("python", renamed);
        let score = compare(&a, &b);
        assert!(score.score > 0.95, "score was {}", score.score);
    }

    #[test]
    fn identical_code_scores_one() {
        let code = r#"
            int main() {
                int n;
                std::cin >> n;
                for (int i = 0; i < n; ++i) {
                    std::cout << i << std::endl;
                }
                return 0;
            }
        "#;
        let a = fingerprint("cpp", code);
        let b = fingerprint("cpp", code);
        assert_eq!(compare(&a, &b).score, 1.0);
    }

    #[test]
    fn unrelated_code_scores_low() {
        let a = fingerprint("python", "def solve(n):\n    return n * n\n");
        let b = fingerprint(
            "python",
            "class Node:\n    def __init__(self, value):\n        self.value = value\n",
        );
        assert!(compare(&a, &b).score < 0.5);
    }

    #[test]
    fn severity_bands_follow_thresholds() {
        assert_eq!(severity_for(0.10, 0.6, 0.8, 0.92), None);
        assert_eq!(severity_for(0.60, 0.6, 0.8, 0.92), Some("low"));
        assert_eq!(severity_for(0.80, 0.6, 0.8, 0.92), Some("medium"));
        assert_eq!(severity_for(0.92, 0.6, 0.8, 0.92), Some("high"));
    }

    #[test]
    fn short_code_has_no_fingerprint() {
        let a = fingerprint("python", "x = 1");
        assert!(a.is_empty());
    }
}
