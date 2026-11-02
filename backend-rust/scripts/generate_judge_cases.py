#!/usr/bin/env python3
"""重新生成 seed_problems_15.sql 中 15 道题的隐藏测试点。

用法：
    python3 scripts/generate_judge_cases.py            # 重写 seed 文件
    python3 scripts/generate_judge_cases.py --dry-run  # 只打印统计
    python3 scripts/generate_judge_cases.py --check    # 校验现有 seed 文件

为什么需要这个脚本：
    原先每题只有 5-6 条隐藏用例，判题区分度低，错误解法容易蒙混过关。
    用例由下面的参考解直接算出期望输出，随机部分使用固定种子，
    因此同一份脚本每次生成的结果完全一致，可以进版本库。

设计约束（与 backend-rust/src/judge/run_config.rs 保持一致）：
    - 隐藏用例 + 公开用例合计不超过 50 条
    - judge_cases 整个 JSON 不超过 256 KB
    - 参数个数、类型必须与 run_config 匹配
    - 不生成题目描述范围之外的输入
"""

from __future__ import annotations

import argparse
import json
import random
import re
import sys
from pathlib import Path

SEED_PATH = Path(__file__).resolve().parent / "seed_problems_15.sql"
MAX_TOTAL_CASES = 50
MAX_CASE_BYTES = 256 * 1024
# 单条用例的 args 由 runner 写入 case.json，超过 64 KB 会直接报错。
MAX_CASE_ARGS_BYTES = 64 * 1024
JSON_BLOCK = re.compile(r"\$json\$(.*?)\$json\$", re.S)
# 题目元组的开头。注意这里捕获的是整段分隔符：用它切分文本会丢掉分隔符，
# 所有替换都按「区间」处理，不要用 re.split 再拼回去。
PROBLEM_START = re.compile(r"\n\(\n\s+(\d{4}),\n\s+'")


# ── 参考解 ──────────────────────────────────────────────────────────


def solve_1101(x: int) -> bool:
    return x >= 0 and str(x) == str(x)[::-1]


def solve_1102(s: str) -> bool:
    pairs = {")": "(", "]": "[", "}": "{"}
    stack: list[str] = []
    for ch in s:
        if ch in "([{":
            stack.append(ch)
        elif not stack or stack.pop() != pairs[ch]:
            return False
    return not stack


def solve_1103(strs: list[str]) -> str:
    prefix = strs[0]
    for word in strs[1:]:
        while not word.startswith(prefix):
            prefix = prefix[:-1]
            if not prefix:
                return ""
    return prefix


def solve_1104(nums: list[int]) -> list[int]:
    non_zero = [value for value in nums if value != 0]
    return non_zero + [0] * (len(nums) - len(non_zero))


def solve_1105(nums: list[int]) -> int:
    result = 0
    for value in nums:
        result ^= value
    return result


def solve_1106(head: list[int]) -> list[int]:
    return list(reversed(head))


def solve_1107(nums: list[int]) -> int:
    best = current = nums[0]
    for value in nums[1:]:
        current = max(value, current + value)
        best = max(best, current)
    return best


def solve_1108(nums: list[int], k: int) -> list[int]:
    n = len(nums)
    k %= n
    if k == 0:
        return list(nums)
    return nums[n - k :] + nums[: n - k]


def solve_1109(nums: list[int], target: int) -> int:
    left, right = 0, len(nums) - 1
    while left <= right:
        middle = (left + right) // 2
        if nums[middle] == target:
            return middle
        if nums[left] <= nums[middle]:
            if nums[left] <= target < nums[middle]:
                right = middle - 1
            else:
                left = middle + 1
        else:
            if nums[middle] < target <= nums[right]:
                left = middle + 1
            else:
                right = middle - 1
    return -1


def solve_1110(intervals: list[list[int]]) -> list[list[int]]:
    merged: list[list[int]] = []
    for start, end in sorted(intervals):
        if merged and start <= merged[-1][1]:
            merged[-1][1] = max(merged[-1][1], end)
        else:
            merged.append([start, end])
    return merged


def solve_1111(matrix: list[list[int]]) -> list[int]:
    result: list[int] = []
    top, bottom = 0, len(matrix) - 1
    left, right = 0, len(matrix[0]) - 1
    while top <= bottom and left <= right:
        for column in range(left, right + 1):
            result.append(matrix[top][column])
        top += 1
        for row in range(top, bottom + 1):
            result.append(matrix[row][right])
        right -= 1
        if top <= bottom:
            for column in range(right, left - 1, -1):
                result.append(matrix[bottom][column])
            bottom -= 1
        if left <= right:
            for row in range(bottom, top - 1, -1):
                result.append(matrix[row][left])
            left += 1
    return result


def solve_1112(grid: list[list[int]]) -> int:
    rows, columns = len(grid), len(grid[0])
    seen = [[False] * columns for _ in range(rows)]
    count = 0
    for row in range(rows):
        for column in range(columns):
            if grid[row][column] == 0 or seen[row][column]:
                continue
            count += 1
            stack = [(row, column)]
            seen[row][column] = True
            while stack:
                current_row, current_column = stack.pop()
                for row_step, column_step in ((1, 0), (-1, 0), (0, 1), (0, -1)):
                    next_row = current_row + row_step
                    next_column = current_column + column_step
                    if (
                        0 <= next_row < rows
                        and 0 <= next_column < columns
                        and not seen[next_row][next_column]
                        and grid[next_row][next_column] == 1
                    ):
                        seen[next_row][next_column] = True
                        stack.append((next_row, next_column))
    return count


def solve_1113(height: list[int]) -> int:
    left, right = 0, len(height) - 1
    left_max = right_max = 0
    total = 0
    while left < right:
        if height[left] < height[right]:
            left_max = max(left_max, height[left])
            total += left_max - height[left]
            left += 1
        else:
            right_max = max(right_max, height[right])
            total += right_max - height[right]
            right -= 1
    return total


def solve_1114(word1: str, word2: str) -> int:
    previous = list(range(len(word2) + 1))
    for i, left_char in enumerate(word1, start=1):
        current = [i]
        for j, right_char in enumerate(word2, start=1):
            if left_char == right_char:
                current.append(previous[j - 1])
            else:
                current.append(1 + min(previous[j], current[j - 1], previous[j - 1]))
        previous = current
    return previous[-1]


def solve_1115(s: str) -> int:
    stack = [-1]
    best = 0
    for index, char in enumerate(s):
        if char == "(":
            stack.append(index)
            continue
        stack.pop()
        if not stack:
            stack.append(index)
        else:
            best = max(best, index - stack[-1])
    return best


SOLVERS = {
    1101: solve_1101,
    1102: solve_1102,
    1103: solve_1103,
    1104: solve_1104,
    1105: solve_1105,
    1106: solve_1106,
    1107: solve_1107,
    1108: solve_1108,
    1109: solve_1109,
    1110: solve_1110,
    1111: solve_1111,
    1112: solve_1112,
    1113: solve_1113,
    1114: solve_1114,
    1115: solve_1115,
}


# ── 用例生成 ────────────────────────────────────────────────────────


def generate_1101(rng: random.Random) -> list[list]:
    values = [
        0, 1, 9, 10, 11, 100, 101, 1001, 10001, 12321, 123321,
        -1, -121, -101, 2147483647, -2147483648, 2147447412,
        1234567899, 1000000001, 2147483646,
    ]
    for _ in range(12):
        half = str(rng.randint(1, 9999))
        even = int(half + half[::-1])
        odd = int(half + half[-2::-1]) if len(half) > 1 else int(half)
        values.append(rng.choice([even, odd]))
        broken = str(even)
        if len(broken) > 1:
            values.append(int(broken[:-1] + str((int(broken[-1]) + 1) % 10)))
    return [[value] for value in values]


def generate_1102(rng: random.Random) -> list[list]:
    strings = [
        "", "()", "(]", "([)]", "{[]}", "(", ")", "()[]{}", "((()))",
        "(()", "())", "[", "]", "{", "}", "(((((((((())))))))))",
        "()()()", ")(", "()" * 5000, "(" * 10000, "()" * 4999 + "(",
    ]
    alphabet = "()[]{}"
    for _ in range(20):
        strings.append("".join(rng.choice(alphabet) for _ in range(rng.randint(1, 24))))
    return [[value] for value in strings]


def generate_1103(rng: random.Random) -> list[list]:
    cases = [
        [["a"]], [[""]], [["", ""]], [["", "b"]],
        [["flower", "flow", "flight"]], [["dog", "racecar", "car"]],
        [["ab", "a"]], [["abc", "abc", "abc"]], [["aaa", "aa", "aaa"]],
        [["c", "c"]], [["abc"]], [["", "a", "ab"]],
        [["prefix", "prefixes", "pre"]], [["a" * 200, "a" * 199, "a" * 200]],
        [["abc", "abd"]], [["same", "same"]], [["z"]], [["z", "z", "z"]],
        [["ab", "ac"]], [["a", "ab", "abc"]],
    ]
    for _ in range(12):
        prefix = "".join(rng.choice("abc") for _ in range(rng.randint(0, 6)))
        words = []
        for _ in range(rng.randint(1, 6)):
            suffix = "".join(rng.choice("abcde") for _ in range(rng.randint(0, 6)))
            words.append(prefix + suffix)
        cases.append([words])
    return cases


def generate_1104(rng: random.Random) -> list[list]:
    cases = [
        [[1]], [[0]], [[0, 0]], [[1, 0]], [[0, 1]], [[1, 2, 3]],
        [[0, 1, 0, 3, 12]], [[0, 0, 1]], [[1, 0, 0]], [[-1, 0, -2]],
        [[1, 2, 0, 0, 3]], [[4, 2, 4, 0, 0, 3, 0, 5, 1, 0]], [[0] * 50],
        [list(range(1, 101))], [[0, *range(1, 101)]],
    ]
    for _ in range(6):
        size = rng.randint(1, 200)
        cases.append([
            [rng.choice([0, 0, 0, rng.randint(-1000, 1000)]) for _ in range(size)]
        ])
    cases.append([
        [rng.randint(-10000, 10000) if rng.random() < 0.5 else 0 for _ in range(5000)]
    ])
    return cases


def single_number_case(rng: random.Random, pair_count: int) -> list[int]:
    """生成「每个数字出现两次，只有一个出现一次」的合法输入。

    用 sample 一次取够互不相同的数字，避免随机碰撞导致某个数字出现四次。
    """
    pool = rng.sample(range(-30000, 30001), pair_count + 1)
    unique = pool[-1]
    values = [value for value in pool[:-1] for _ in range(2)] + [unique]
    rng.shuffle(values)
    return values


def generate_1105(rng: random.Random) -> list[list]:
    cases = [
        [[0]], [[1]], [[-1]], [[2, 2, 1]], [[4, 1, 2, 1, 2]],
        [[-3, -3, -2]], [[10000, 10000, 0]], [[-10000, -10000, 10000]],
        [[1, 1, 2, 2, 3]], [[0, 0, -1]], [[-30000, -30000, 30000]],
    ]
    for _ in range(7):
        cases.append([single_number_case(rng, rng.randint(1, 8))])
    cases.append([single_number_case(rng, 2500)])
    return cases


def generate_1106(rng: random.Random) -> list[list]:
    cases = [
        [[]], [[1]], [[1, 2]], [[1, 2, 3]], [[-5000]], [[0, 0, 0]],
        [[1, 2, 3, 4, 5, 6, 7, 8, 9, 10]], [[-1, 0, 1]], [[5, 1, 9, 3]],
        [[5000] * 20], [list(range(-10, 11))], [list(range(1000))],
    ]
    for _ in range(6):
        cases.append([[
            rng.randint(-5000, 5000) for _ in range(rng.randint(0, 40))
        ]])
    return cases


def generate_1107(rng: random.Random) -> list[list]:
    cases = [
        [[1]], [[-1]], [[-10000]], [[5, 4, -1, 7, 8]], [[-3, -1, -2]],
        [[-2, -1]], [[10000] * 500], [[1, -1, 1, -1]],
        [[-10000, -10000, -10000]], [[1, 2, 3, 4, 5]], [[5, -10, 5]],
        [[-1, 0, -2]], [[10000, -10000, 10000, -10000, 10000]],
    ]
    for _ in range(5):
        cases.append([[
            rng.randint(-10000, 10000) for _ in range(rng.randint(1, 60))
        ]])
    cases.append([[rng.randint(-10000, 10000) for _ in range(10000)]])
    return cases


def generate_1108(rng: random.Random) -> list[list]:
    cases = [
        [[1], 0], [[1], 1], [[1], 5], [[1, 2], 0], [[1, 2], 1],
        [[1, 2], 2], [[1, 2, 3], 3], [[1, 2, 3], 4], [[1, 2, 3], 1],
        [[1, 2, 3, 4, 5, 6, 7], 3], [[-1, -100, 3, 99], 2],
        [[1, 2], 100000], [[0, 0, 1], 2], [[1, 2, 3, 4], 6],
    ]
    for _ in range(5):
        cases.append([
            [rng.randint(-1000, 1000) for _ in range(rng.randint(1, 50))],
            rng.randint(0, 60),
        ])
    cases.append([[rng.randint(-1000, 1000) for _ in range(5000)], 12345])
    return cases


def generate_1109(rng: random.Random) -> list[list]:
    cases = [
        [[1], 0], [[1], 1], [[1, 2], 1], [[1, 2], 2], [[1, 2], 3],
        [[4, 5, 6, 7, 0, 1, 2], 0], [[4, 5, 6, 7, 0, 1, 2], 3],
        [[4, 5, 6, 7, 0, 1, 2], 7], [[4, 5, 6, 7, 0, 1, 2], 8],
        [[1, 3], 3], [[3, 1], 1], [[5, 1, 3], 5], [[5, 1, 3], 3],
        [[5, 1, 3], 2], [[-1, 0, 3, 5, 9, 12], 9], [[2, 3, 4, 5], 1],
    ]
    for _ in range(6):
        size = rng.randint(1, 60)
        values = rng.sample(range(-10000, 10001), size)
        values.sort()
        pivot = rng.randrange(size)
        rotated = values[pivot:] + values[:pivot]
        target = rng.choice(rotated + [rng.randint(-10000, 10000)])
        cases.append([rotated, target])
    base = list(range(0, 5000))
    rotated = base[1234:] + base[:1234]
    cases.append([rotated, 4321])
    cases.append([rotated, -1])
    return cases


def generate_1110(rng: random.Random) -> list[list]:
    cases = [
        [[[1, 3]]], [[[1, 4], [2, 3]]], [[[1, 2], [3, 4]]],
        [[[0, 0], [1, 1]]], [[[2, 3], [4, 5], [6, 7], [8, 9], [1, 10]]],
        [[[1, 4], [0, 2], [3, 5]]], [[[1, 2], [2, 3], [3, 4]]],
        [[[1, 10], [2, 3], [4, 5]]], [[[0, 10000]]],
        [[[0, 0], [0, 0], [0, 0]]], [[[1, 2], [1, 2], [1, 2]]],
        [[[i, i + 1] for i in range(0, 100, 2)]],
        [[[i, i] for i in range(0, 100)]],
    ]
    for _ in range(5):
        intervals = []
        for _ in range(rng.randint(1, 40)):
            start = rng.randint(0, 9900)
            end = rng.randint(start, min(10000, start + rng.randint(0, 500)))
            intervals.append([start, end])
        cases.append([intervals])
    cases.append([[[i, i + 100] for i in range(0, 500)]])
    return cases


def generate_1111(rng: random.Random) -> list[list]:
    cases = [
        [[[7]]], [[[1, 2, 3, 4, 5]]], [[[1], [2], [3], [4]]],
        [[[1, 2], [3, 4]]], [[[1, 2, 3], [4, 5, 6], [7, 8, 9]]],
        [[[1, 2, 3, 4], [5, 6, 7, 8], [9, 10, 11, 12]]],
        [[[1, 2, 3], [4, 5, 6], [7, 8, 9], [10, 11, 12]]],
        [[[-100, 100], [0, -50]]],
    ]
    for _ in range(7):
        rows, columns = rng.randint(1, 12), rng.randint(1, 12)
        cases.append([
            [[rng.randint(-100, 100) for _ in range(columns)] for _ in range(rows)]
        ])
    for rows, columns in ((10, 10), (3, 30), (30, 3), (30, 30)):
        cases.append([
            [[(row * 31 + column * 17) % 201 - 100 for column in range(columns)]
             for row in range(rows)]
        ])
    return cases


def generate_1112(rng: random.Random) -> list[list]:
    cases = [
        [[[0]]], [[[1]]], [[[1, 0, 1]]], [[[1], [0], [1]]],
        [[[1, 1], [1, 1]]], [[[0, 0], [0, 0]]],
        [[[1, 0, 1], [0, 0, 0], [1, 0, 1]]],
        [[[1, 0, 0], [0, 1, 0], [0, 0, 1]]],
        [[[1, 1, 1, 1, 0], [1, 1, 0, 1, 0], [1, 1, 0, 0, 0], [0, 0, 0, 0, 0]]],
        [[[0] * 50 for _ in range(50)]],
        [[[1] * 50 for _ in range(50)]],
    ]
    for _ in range(6):
        rows, columns = rng.randint(1, 15), rng.randint(1, 15)
        probability = rng.choice([0.2, 0.5, 0.8])
        cases.append([
            [[1 if rng.random() < probability else 0 for _ in range(columns)]
             for _ in range(rows)]
        ])
    cases.append([
        [[1 if rng.random() < 0.35 else 0 for _ in range(100)] for _ in range(100)]
    ])
    return cases


def generate_1113(rng: random.Random) -> list[list]:
    cases = [
        [[0]], [[1]], [[5, 4, 3, 2, 1]], [[1, 2, 3, 4, 5]],
        [[0, 1, 0, 2, 1, 0, 1, 3, 2, 1, 2, 1]], [[4, 2, 0, 3, 2, 5]],
        [[0, 0, 0, 0]], [[5, 5, 5, 5]], [[3, 0, 3]],
        [[0, 1, 0, 1, 0, 1, 0]],
    ]
    for _ in range(5):
        cases.append([[rng.randint(0, 100000) for _ in range(rng.randint(1, 60))]])
    cases.append([[0, 100000, 0]])
    cases.append([[rng.randint(0, 100000) for _ in range(10000)]])
    cases.append([[0] * 5000])
    return cases


def generate_1114(rng: random.Random) -> list[list]:
    cases = [
        ["", ""], ["a", ""], ["", "a"], ["a", "a"], ["abc", "abc"],
        ["abc", "def"], ["intention", "execution"], ["horse", "ros"],
        ["a" * 500, "b" * 500], ["a" * 500, "a" * 500], ["ab", "ba"],
        ["kitten", "sitting"], ["", "abc"], ["abc", ""],
        ["aaaa", "aa"], ["a", "b"], ["abcdef", "azced"],
    ]
    for _ in range(7):
        left = "".join(rng.choice("abcd") for _ in range(rng.randint(0, 40)))
        right = "".join(rng.choice("abcd") for _ in range(rng.randint(0, 40)))
        cases.append([left, right])
    return cases


def generate_1115(rng: random.Random) -> list[list]:
    cases = [
        [""], ["("], [")"], ["()"], ["(()"], [")()())"], ["()(()"],
        ["()(())"], ["(" * 1000], [")" * 1000],
        ["(" * 5000 + ")" * 5000], ["()" * 5000], [")("], ["()()"],
        ["(()))("], ["((()))()"], ["()" * 4999 + "("],
    ]
    for _ in range(8):
        cases.append([
            "".join(rng.choice("()") for _ in range(rng.randint(0, 40)))
        ])
    return cases


GENERATORS = {
    1101: generate_1101,
    1102: generate_1102,
    1103: generate_1103,
    1104: generate_1104,
    1105: generate_1105,
    1106: generate_1106,
    1107: generate_1107,
    1108: generate_1108,
    1109: generate_1109,
    1110: generate_1110,
    1111: generate_1111,
    1112: generate_1112,
    1113: generate_1113,
    1114: generate_1114,
    1115: generate_1115,
}


# ── 生成与校验 ──────────────────────────────────────────────────────


def unique_cases(problem_id: int, args_list: list[list], public_args: list[list]) -> list[list]:
    """去掉重复用例，并排除已经出现在公开用例里的输入。"""
    seen = {json.dumps(args, ensure_ascii=False, sort_keys=True) for args in public_args}
    cases = []
    for args in args_list:
        key = json.dumps(args, ensure_ascii=False, sort_keys=True)
        if key in seen:
            continue
        seen.add(key)
        cases.append(args)
    return cases


def build_cases(problem_id: int, public_args: list[list]) -> list[dict]:
    rng = random.Random(20261102 + problem_id)
    args_list = unique_cases(
        problem_id,
        GENERATORS[problem_id](rng),
        public_args,
    )
    cases = []
    for args in args_list:
        expected = SOLVERS[problem_id](*args)
        cases.append({"args": args, "expected": expected})
    return cases


def check_case_types(problem_id: int, cases: list[dict]) -> None:
    for index, case in enumerate(cases, start=1):
        expected = case["expected"]
        if problem_id in (1101, 1102):
            valid = isinstance(expected, bool)
        elif problem_id in (1103,):
            valid = isinstance(expected, str)
        elif problem_id in (1105, 1107, 1109, 1112, 1113, 1114, 1115):
            valid = isinstance(expected, int) and not isinstance(expected, bool)
        elif problem_id == 1106:
            valid = isinstance(expected, list) and all(
                isinstance(value, int) for value in expected
            )
        elif problem_id == 1110:
            valid = isinstance(expected, list) and all(
                isinstance(item, list)
                and all(isinstance(value, int) for value in item)
                for item in expected
            )
        elif problem_id == 1111:
            valid = isinstance(expected, list) and all(
                isinstance(value, int) for value in expected
            )
        else:
            valid = isinstance(expected, list)
        if not valid:
            raise SystemExit(
                f"题目 {problem_id} 第 {index} 条用例的 expected 类型不正确: {expected!r}"
            )


def matches_param_type(param_type: str, value) -> bool:
    """粗略对齐 run_config 的类型校验：标量、数组、二维数组、链表。"""
    if param_type == "int":
        return isinstance(value, int) and not isinstance(value, bool)
    if param_type == "bool":
        return isinstance(value, bool)
    if param_type in ("double",):
        return isinstance(value, (int, float)) and not isinstance(value, bool)
    if param_type == "string":
        return isinstance(value, str)
    if param_type == "int[]":
        return isinstance(value, list) and all(
            isinstance(item, int) and not isinstance(item, bool) for item in value
        )
    if param_type == "string[]":
        return isinstance(value, list) and all(isinstance(item, str) for item in value)
    if param_type == "int[][]":
        return isinstance(value, list) and all(
            isinstance(row, list)
            and all(isinstance(item, int) and not isinstance(item, bool) for item in row)
            for row in value
        )
    if param_type in ("ListNode", "TreeNode"):
        return isinstance(value, list) and all(
            item is None or (isinstance(item, int) and not isinstance(item, bool))
            for item in value
        )
    return True


def check_case_shapes(config: dict, cases: list[dict]) -> None:
    params = config.get("params", [])
    for index, case in enumerate(cases, start=1):
        if len(case["args"]) != len(params):
            raise SystemExit(
                f"第 {index} 条用例参数个数为 {len(case['args'])}，应为 {len(params)}"
            )
        for arg_index, (param, value) in enumerate(zip(params, case["args"]), start=1):
            if not matches_param_type(param["type"], value):
                raise SystemExit(
                    f"第 {index} 条用例第 {arg_index} 个参数 {param['name']} "
                    f"不是 {param['type']}: {value!r}"
                )


def check_case_sizes(problem_id: int, cases: list[dict]) -> None:
    """单条用例的参数序列化后不能超过 runner 的 64 KB 输入上限。"""
    for index, case in enumerate(cases, start=1):
        size = len(
            json.dumps(
                case["args"], ensure_ascii=False, separators=(",", ":")
            ).encode("utf-8")
        )
        if size > MAX_CASE_ARGS_BYTES:
            raise SystemExit(
                f"题目 {problem_id} 第 {index} 条参数 {size} 字节，"
                f"超过 {MAX_CASE_ARGS_BYTES} 字节上限"
            )


def extract_public_args(config: dict) -> list[list]:
    return [case["args"] for case in config.get("public_cases", [])]


def load_config(segment: str) -> dict:
    for match in JSON_BLOCK.finditer(segment):
        try:
            value = json.loads(match.group(1))
        except json.JSONDecodeError:
            continue
        if isinstance(value, dict) and "function_name" in value:
            return value
    raise SystemExit("未找到 run_config 块")


def problem_segments(text: str):
    """按题目元组切出区间，区间包含 `(` 到下一个题目之前。"""
    matches = list(PROBLEM_START.finditer(text))
    for index, match in enumerate(matches):
        end = matches[index + 1].start() if index + 1 < len(matches) else len(text)
        yield int(match.group(1)), match.start(), end


def format_cases(cases: list[dict]) -> str:
    """每条用例压成一行，避免 4 空格缩进把 SQL 文件撑到几万行。"""
    lines = [json.dumps(case, ensure_ascii=False) for case in cases]
    return "[\n" + ",\n".join(f"    {line}" for line in lines) + "\n]"


def rewrite(text: str, dry_run: bool) -> tuple[str, list[str]]:
    report: list[str] = []
    pieces: list[str] = []
    cursor = 0
    for problem_id, start, end in problem_segments(text):
        segment = text[start:end]
        pieces.append(text[cursor:start])
        cursor = end
        if problem_id not in GENERATORS:
            pieces.append(segment)
            continue

        config = load_config(segment)
        public_args = extract_public_args(config)
        cases = build_cases(problem_id, public_args)
        check_case_types(problem_id, cases)
        check_case_shapes(config, cases)
        check_case_sizes(problem_id, cases)

        total = len(cases) + len(public_args)
        if total > MAX_TOTAL_CASES:
            raise SystemExit(f"题目 {problem_id} 用例总数 {total} 超过 {MAX_TOTAL_CASES}")

        encoded = json.dumps(cases, ensure_ascii=False, separators=(",", ":"))
        if len(encoded.encode("utf-8")) > MAX_CASE_BYTES:
            raise SystemExit(
                f"题目 {problem_id} judge_cases 超过 {MAX_CASE_BYTES // 1024} KB"
            )

        blocks = list(JSON_BLOCK.finditer(segment))
        if not blocks:
            raise SystemExit(f"题目 {problem_id} 没有 JSON 块")
        last = blocks[-1]
        remainder = segment[last.end():]
        if not re.match(r"::jsonb,\s*'approved'", remainder):
            raise SystemExit(
                f"题目 {problem_id} 最后一段 JSON 不是 judge_cases（后接 {remainder[:40]!r}）"
            )

        formatted = format_cases(cases)
        if "$json$" in formatted:
            raise SystemExit(f"题目 {problem_id} 的用例包含 $json$ 定界符")
        if not dry_run:
            segment = segment[: last.start(1)] + formatted + segment[last.end(1):]
        pieces.append(segment)
        report.append(
            f"{problem_id}: hidden {len(cases)} + public {len(public_args)} = {total} 条，"
            f"{len(encoded.encode('utf-8')) / 1024:.1f} KB"
        )
    pieces.append(text[cursor:])
    return "".join(pieces), report


def check_existing(text: str) -> list[str]:
    """校验 seed 中已有的 judge_cases 能被参考解复现。"""
    report: list[str] = []
    for problem_id, start, end in problem_segments(text):
        segment = text[start:end]
        if problem_id not in SOLVERS:
            continue
        config = load_config(segment)
        blocks = list(JSON_BLOCK.finditer(segment))
        cases = json.loads(blocks[-1].group(1))
        check_case_shapes(config, cases)
        check_case_sizes(problem_id, cases)
        for case_index, case in enumerate(cases, start=1):
            actual = SOLVERS[problem_id](*case["args"])
            if actual != case["expected"]:
                raise SystemExit(
                    f"题目 {problem_id} 第 {case_index} 条期望值不一致："
                    f"文件为 {case['expected']!r}，参考解为 {actual!r}"
                )
        report.append(f"{problem_id}: {len(cases)} 条隐藏用例可被参考解复现")
    return report


def main() -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--dry-run", action="store_true", help="只统计，不写文件")
    parser.add_argument("--check", action="store_true", help="校验现有 seed 文件")
    args = parser.parse_args()

    text = SEED_PATH.read_text(encoding="utf-8")
    if args.check:
        report = check_existing(text)
        print("\n".join(report))
        return 0

    updated, report = rewrite(text, args.dry_run)
    if args.dry_run:
        print("\n".join(report))
        return 0

    SEED_PATH.write_text(updated, encoding="utf-8")
    print("\n".join(report))
    print(f"已写入 {SEED_PATH}")
    return 0


if __name__ == "__main__":
    sys.exit(main())
