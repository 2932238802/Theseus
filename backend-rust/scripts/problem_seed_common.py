"""题目种子的公共工具：数据结构、类型校验、模板生成与 SQL 输出。

`generate_problem_seed.py` / `generate_extra_problem_seed.py` 会读取各自的目录文件
（catalog），调用这里的校验与渲染逻辑，分别生成 `seed_problems_82.sql` 与
`seed_problems_100.sql`。

设计约束与 `backend-rust/src/judge/run_config.rs` 保持一致：
    - 支持 int / long / double / bool / string / ListNode / TreeNode 及一维、二维数组
    - public_cases 最多 5 条
    - public_cases + judge_cases 合计最多 50 条
    - judge_cases 整个 JSON 不超过 256 KB，单条 args 不超过 64 KB
"""

from __future__ import annotations

import json
from dataclasses import dataclass, field
from typing import Any, Callable

MAX_PUBLIC_CASES = 5
MAX_TOTAL_CASES = 50
MAX_CASE_BYTES = 256 * 1024
MAX_CASE_ARGS_BYTES = 64 * 1024
INT_MIN, INT_MAX = -(2**31), 2**31 - 1
LONG_MIN, LONG_MAX = -(2**63), 2**63 - 1

SCALAR_TYPES = {"int", "long", "double", "bool", "string"}
NODE_TYPES = {"ListNode", "TreeNode"}


@dataclass
class Problem:
    pid: int
    title: str
    difficulty: str
    tags: list[str]
    description: str
    function: str
    params: list[tuple[str, str]]
    returns: str
    solver: Callable[..., Any]
    public: list[list[Any]]
    expected_public: list[Any]
    hidden: list[list[Any]]
    compare: dict[str, Any] = field(default_factory=lambda: {"mode": "exact"})
    time_limit: int = 1000
    memory_limit: int = 256


# ── 树 / 链表工具（参考解使用） ────────────────────────────────────


class Node:
    def __init__(self, value: int, left: "Node | None" = None, right: "Node | None" = None):
        self.value = value
        self.left = left
        self.right = right


def tree_from_list(values: list[int | None]) -> Node | None:
    """按层序恢复二叉树，None 表示空位。"""
    if not values or values[0] is None:
        return None
    root = Node(values[0])
    queue = [root]
    index = 1
    while queue and index < len(values):
        node = queue.pop(0)
        if index < len(values) and values[index] is not None:
            node.left = Node(values[index])
            queue.append(node.left)
        index += 1
        if index < len(values) and values[index] is not None:
            node.right = Node(values[index])
            queue.append(node.right)
        index += 1
    return root


def tree_to_list(root: Node | None) -> list[int | None]:
    """层序序列化，去掉末尾多余的 None，与判题 harness 保持一致。"""
    if root is None:
        return []
    values: list[int | None] = []
    queue = [root]
    while queue:
        node = queue.pop(0)
        if node is None:
            values.append(None)
            continue
        values.append(node.value)
        queue.append(node.left)
        queue.append(node.right)
    while values and values[-1] is None:
        values.pop()
    return values


# ── 模板生成（与 run_config.rs 的输出保持一致） ─────────────────────

PYTHON_NODE_DEFINITIONS = '''class ListNode:
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


'''

JAVASCRIPT_NODE_DEFINITIONS = """function ListNode(val, next) {
  this.val = val === undefined ? 0 : val;
  this.next = next === undefined ? null : next;
}

function TreeNode(val, left, right) {
  this.val = val === undefined ? 0 : val;
  this.left = left === undefined ? null : left;
  this.right = right === undefined ? null : right;
}
"""

CPP_NODE_DEFINITIONS = """#ifndef THESEUS_LIST_NODE_DEFINED
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

"""

JAVA_NODE_DEFINITIONS = """class ListNode {
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
"""


def python_annotation(run_type: str) -> str:
    mapping = {"int": "int", "long": "int", "double": "float", "bool": "bool", "string": "str"}
    if run_type in mapping:
        return mapping[run_type]
    if run_type == "ListNode":
        return "ListNode | None"
    if run_type == "TreeNode":
        return "TreeNode | None"
    if run_type.endswith("[]"):
        return f"list[{python_annotation(run_type[:-2])}]"
    return "object"


def cpp_type(run_type: str) -> str:
    mapping = {
        "int": "int",
        "long": "long long",
        "double": "double",
        "bool": "bool",
        "string": "std::string",
        "ListNode": "ListNode*",
        "TreeNode": "TreeNode*",
    }
    if run_type in mapping:
        return mapping[run_type]
    if run_type.endswith("[]"):
        return f"std::vector<{cpp_type(run_type[:-2])}>"
    return "int"


def cpp_declaration(run_type: str, name: str) -> str:
    if run_type.endswith("[]"):
        return f"{cpp_type(run_type)}& {name}"
    return f"{cpp_type(run_type)} {name}"


def cpp_default_value(run_type: str) -> str:
    mapping = {
        "int": "0",
        "long": "0",
        "double": "0.0",
        "bool": "false",
        "string": '""',
        "ListNode": "nullptr",
        "TreeNode": "nullptr",
    }
    if run_type in mapping:
        return mapping[run_type]
    return "{}"


def java_type(run_type: str) -> str:
    mapping = {
        "int": "int",
        "long": "long",
        "double": "double",
        "bool": "boolean",
        "string": "String",
        "ListNode": "ListNode",
        "TreeNode": "TreeNode",
    }
    if run_type in mapping:
        return mapping[run_type]
    if run_type.endswith("[]"):
        return f"{java_type(run_type[:-2])}[]"
    return "int"


def java_default_value(run_type: str) -> str:
    mapping = {"int": "0", "long": "0L", "double": "0.0", "bool": "false", "string": '""'}
    if run_type in mapping:
        return mapping[run_type]
    if run_type in NODE_TYPES:
        return "null"
    if run_type.endswith("[]"):
        return f"new {java_type(run_type)}{{}}"
    return "0"


def uses_node_type(params: list[tuple[str, str]], returns: str) -> bool:
    return returns in NODE_TYPES or any(param_type in NODE_TYPES for _, param_type in params)


def build_templates(problem: Problem) -> dict[str, str]:
    params, returns = problem.params, problem.returns
    nodes = uses_node_type(params, returns)

    python = PYTHON_NODE_DEFINITIONS if nodes else ""
    arguments = ", ".join(
        ["self"] + [f"{name}: {python_annotation(param_type)}" for name, param_type in params]
    )
    python += (
        f"class Solution:\n    def {problem.function}({arguments})"
        f" -> {python_annotation(returns)}:\n        pass\n"
    )

    javascript = JAVASCRIPT_NODE_DEFINITIONS + "\n" if nodes else ""
    js_arguments = ", ".join(name for name, _ in params)
    javascript += f"var {problem.function} = function({js_arguments}) {{\n}};\n"

    cpp = "#include <bits/stdc++.h>\nusing namespace std;\n\n"
    if nodes:
        cpp += CPP_NODE_DEFINITIONS + "\n"
    cpp_parameters = ", ".join(cpp_declaration(t, n) for n, t in params)
    cpp += (
        f"class Solution {{\npublic:\n"
        f"    {cpp_type(returns)} {problem.function}({cpp_parameters}) {{\n"
        f"        return {cpp_default_value(returns)};\n    }}\n}};\n"
    )

    java = JAVA_NODE_DEFINITIONS + "\n" if nodes else ""
    java_parameters = ", ".join(f"{java_type(t)} {n}" for n, t in params)
    java += (
        f"class Solution {{\n    public {java_type(returns)} {problem.function}"
        f"({java_parameters}) {{\n        return {java_default_value(returns)};\n    }}\n}}\n"
    )

    return {"javascript": javascript, "python": python, "cpp": cpp, "java": java}


# ── 用例校验与格式化 ────────────────────────────────────────────────


def is_scalar(run_type: str, value: Any) -> bool:
    if run_type == "int":
        return isinstance(value, int) and not isinstance(value, bool) and INT_MIN <= value <= INT_MAX
    if run_type == "long":
        return isinstance(value, int) and not isinstance(value, bool) and LONG_MIN <= value <= LONG_MAX
    if run_type == "double":
        return isinstance(value, (int, float)) and not isinstance(value, bool)
    if run_type == "bool":
        return isinstance(value, bool)
    if run_type == "string":
        return isinstance(value, str)
    return False


def matches_type(run_type: str, value: Any) -> bool:
    if run_type in SCALAR_TYPES:
        return is_scalar(run_type, value)
    if run_type == "ListNode":
        return isinstance(value, list) and all(is_scalar("int", item) for item in value)
    if run_type == "TreeNode":
        return isinstance(value, list) and all(
            item is None or is_scalar("int", item) for item in value
        )
    if run_type.endswith("[][]"):
        element = run_type[:-4]
        return isinstance(value, list) and all(
            isinstance(row, list) and all(matches_type(element, item) for item in row)
            for row in value
        )
    if run_type.endswith("[]"):
        element = run_type[:-2]
        return isinstance(value, list) and all(matches_type(element, item) for item in value)
    return False


def validate_problem(problem: Problem) -> list[dict[str, Any]]:
    """校验题目定义并返回隐藏用例（含参考解算出的 expected）。"""
    if not 1 <= len(problem.public) <= MAX_PUBLIC_CASES:
        raise SystemExit(f"题目 {problem.pid} 的 public 用例数量必须在 1-{MAX_PUBLIC_CASES} 之间")
    if len(problem.public) != len(problem.expected_public):
        raise SystemExit(f"题目 {problem.pid} 的 expected_public 数量与 public 不一致")
    if len(problem.public) + len(problem.hidden) > MAX_TOTAL_CASES:
        raise SystemExit(f"题目 {problem.pid} 的用例总数超过 {MAX_TOTAL_CASES}")

    for label, cases in (("public", problem.public), ("hidden", problem.hidden)):
        for index, args in enumerate(cases):
            if len(args) != len(problem.params):
                raise SystemExit(
                    f"题目 {problem.pid} 的 {label} 第 {index + 1} 条参数个数与签名不一致"
                )
            for (name, param_type), value in zip(problem.params, args):
                if not matches_type(param_type, value):
                    raise SystemExit(
                        f"题目 {problem.pid} 的 {label} 第 {index + 1} 条参数 {name} "
                        f"不符合类型 {param_type}：{value!r}"
                    )
            if len(json.dumps(args, ensure_ascii=False).encode()) > MAX_CASE_ARGS_BYTES:
                raise SystemExit(f"题目 {problem.pid} 的 {label} 第 {index + 1} 条 args 超过 64 KB")

    for index, (args, expected) in enumerate(
        zip(problem.public, problem.expected_public), start=1
    ):
        actual = problem.solver(*args)
        if isinstance(expected, float) or isinstance(actual, float):
            if abs(float(actual) - float(expected)) > 1e-6:
                raise SystemExit(
                    f"题目 {problem.pid} 的 public 第 {index} 条参考解输出 {actual!r} "
                    f"与预期 {expected!r} 不符"
                )
        elif actual != expected:
            raise SystemExit(
                f"题目 {problem.pid} 的 public 第 {index} 条参考解输出 {actual!r} "
                f"与预期 {expected!r} 不符"
            )

    if not matches_type(problem.returns, problem.solver(*problem.public[0])):
        raise SystemExit(f"题目 {problem.pid} 的返回类型 {problem.returns} 与参考解输出不匹配")

    hidden: list[dict[str, Any]] = []
    for index, args in enumerate(problem.hidden, start=1):
        expected = problem.solver(*args)
        if not matches_type(problem.returns, expected):
            raise SystemExit(
                f"题目 {problem.pid} 的 hidden 第 {index} 条参考解输出 {expected!r} "
                f"不符合返回类型 {problem.returns}"
            )
        hidden.append({"args": args, "expected": expected})
    return hidden


def format_args(params: list[tuple[str, str]], args: list[Any]) -> str:
    return ", ".join(
        f"{name} = {json.dumps(value, ensure_ascii=False)}"
        for (name, _), value in zip(params, args)
    )


def format_value(value: Any) -> str:
    return json.dumps(value, ensure_ascii=False)


def build_run_config(problem: Problem) -> dict[str, Any]:
    return {
        "version": 1,
        "function_name": problem.function,
        "params": [{"name": name, "type": param_type} for name, param_type in problem.params],
        "return_type": problem.returns,
        "compare": problem.compare,
        "public_cases": [
            {"args": args, "expected": expected}
            for args, expected in zip(problem.public, problem.expected_public)
        ],
    }


def build_examples(problem: Problem) -> list[dict[str, str]]:
    return [
        {"input": format_args(problem.params, args), "output": format_value(expected)}
        for args, expected in zip(problem.public, problem.expected_public)
    ]


def build_public_test_cases(problem: Problem) -> list[dict[str, str]]:
    return [
        {"input": format_args(problem.params, args), "output": format_value(expected)}
        for args, expected in zip(problem.public, problem.expected_public)
    ]


# ── SQL 渲染 ────────────────────────────────────────────────────────


def sql_literal(value: str) -> str:
    return "'" + value.replace("'", "''") + "'"


def sql_json(value: Any) -> str:
    text = json.dumps(value, ensure_ascii=False, indent=2)
    if "$json$" in text:
        raise SystemExit("题目内容中不能出现 $json$ 分隔符")
    return f"$json${text}$json$::jsonb"


def render_sql(
    problems: list[Problem],
    *,
    related_seeds: str = (
        "与 seed_dev.sql（1001-1003）、seed_problems_15.sql（1101-1115）合计 100 题。"
    ),
) -> str:
    first_id = problems[0].pid
    last_id = problems[-1].pid
    lines = [
        "-- 仅用于本地/测试环境的题目种子数据。",
        f"-- 使用固定 ID {first_id}-{last_id}，便于通过 clean_dev.sql 安全清理。",
        f"-- {len(problems)} 道函数式题目（run_config + 公开用例 + 隐藏 judge_cases），",
        f"-- {related_seeds}",
        "",
        "INSERT INTO problems (",
        "    id, title, description, difficulty, time_limit, memory_limit, tags,",
        "    examples, test_cases, code_template, run_config, judge_cases, review_status",
        ") VALUES",
    ]

    entries: list[str] = []
    for problem in problems:
        hidden = validate_problem(problem)
        tags = ", ".join(sql_literal(tag) for tag in problem.tags)
        entries.append(
            "(\n"
            f"    {problem.pid},\n"
            f"    {sql_literal(problem.title)},\n"
            f"    {sql_literal(problem.description.strip())},\n"
            f"    {sql_literal(problem.difficulty)},\n"
            f"    {problem.time_limit},\n"
            f"    {problem.memory_limit},\n"
            f"    ARRAY[{tags}],\n"
            f"    {sql_json(build_examples(problem))},\n"
            f"    {sql_json(build_public_test_cases(problem))},\n"
            f"    {sql_json(build_templates(problem))},\n"
            f"    {sql_json(build_run_config(problem))},\n"
            f"    {sql_json(hidden)},\n"
            "    'approved'\n"
            ")"
        )

    lines.append(",\n".join(entries))
    lines.extend(
        [
            "ON CONFLICT (id) DO UPDATE SET",
            "    title = EXCLUDED.title,",
            "    description = EXCLUDED.description,",
            "    difficulty = EXCLUDED.difficulty,",
            "    time_limit = EXCLUDED.time_limit,",
            "    memory_limit = EXCLUDED.memory_limit,",
            "    tags = EXCLUDED.tags,",
            "    examples = EXCLUDED.examples,",
            "    test_cases = EXCLUDED.test_cases,",
            "    code_template = EXCLUDED.code_template,",
            "    run_config = EXCLUDED.run_config,",
            "    judge_cases = EXCLUDED.judge_cases,",
            "    review_status = EXCLUDED.review_status,",
            "    updated_at = CURRENT_TIMESTAMP;",
            "",
            "SELECT setval(",
            "    pg_get_serial_sequence('problems', 'id'),",
            f"    GREATEST((SELECT COALESCE(MAX(id), 1) FROM problems), {last_id})",
            ");",
            "",
        ]
    )
    return "\n".join(lines)
