"""1375-1416：批量第一批中等题（42 道）。"""

from __future__ import annotations

from collections import Counter, deque
from functools import partial

from problem_seed_common import make_problem

make = partial(make_problem, difficulty="medium")

SUDOKU_VALID = [
    ["5", "3", ".", ".", "7", ".", ".", ".", "."],
    ["6", ".", ".", "1", "9", "5", ".", ".", "."],
    [".", "9", "8", ".", ".", ".", ".", "6", "."],
    ["8", ".", ".", ".", "6", ".", ".", ".", "3"],
    ["4", ".", ".", "8", ".", "3", ".", ".", "1"],
    ["7", ".", ".", ".", "2", ".", ".", ".", "6"],
    [".", "6", ".", ".", ".", ".", "2", "8", "."],
    [".", ".", ".", "4", "1", "9", ".", ".", "5"],
    [".", ".", ".", ".", "8", ".", ".", "7", "9"],
]

SUDOKU_BAD_ROW = [row[:] for row in SUDOKU_VALID]
SUDOKU_BAD_ROW[0][2] = "5"

SUDOKU_BAD_BOX = [row[:] for row in SUDOKU_VALID]
SUDOKU_BAD_BOX[2][0] = "6"


def longest_consecutive(nums: list[int]) -> int:
    values = set(nums)
    best = 0
    for value in values:
        if value - 1 not in values:
            current = value
            while current in values:
                current += 1
            best = max(best, current - value)
    return best


def set_zeroes(matrix: list[list[int]]) -> list[list[int]]:
    rows, columns = len(matrix), len(matrix[0])
    zero_rows = {index for index in range(rows) if 0 in matrix[index]}
    zero_columns = {index for index in range(columns) if any(matrix[row][index] == 0 for row in range(rows))}
    return [
        [0 if row in zero_rows or column in zero_columns else matrix[row][column]
         for column in range(columns)]
        for row in range(rows)
    ]


def game_of_life(board: list[list[int]]) -> list[list[int]]:
    rows, columns = len(board), len(board[0])
    result = [[0] * columns for _ in range(rows)]
    for row in range(rows):
        for column in range(columns):
            live = 0
            for delta_row in (-1, 0, 1):
                for delta_column in (-1, 0, 1):
                    if delta_row == 0 and delta_column == 0:
                        continue
                    next_row = row + delta_row
                    next_column = column + delta_column
                    if (
                        0 <= next_row < rows
                        and 0 <= next_column < columns
                        and board[next_row][next_column] == 1
                    ):
                        live += 1
            if board[row][column] == 1:
                result[row][column] = 1 if live in (2, 3) else 0
            else:
                result[row][column] = 1 if live == 3 else 0
    return result


def insert_interval(
    intervals: list[list[int]], new_interval: list[int]
) -> list[list[int]]:
    result = []
    index = 0
    while index < len(intervals) and intervals[index][1] < new_interval[0]:
        result.append(intervals[index])
        index += 1
    start, end = new_interval
    while index < len(intervals) and intervals[index][0] <= end:
        start = min(start, intervals[index][0])
        end = max(end, intervals[index][1])
        index += 1
    result.append([start, end])
    result.extend(intervals[index:])
    return result


def decode_string(s: str) -> str:
    stack: list[tuple[str, int]] = []
    current = ""
    number = 0
    for character in s:
        if character.isdigit():
            number = number * 10 + int(character)
        elif character == "[":
            stack.append((current, number))
            current, number = "", 0
        elif character == "]":
            previous, count = stack.pop()
            current = previous + current * count
        else:
            current += character
    return current


def daily_temperatures(temperatures: list[int]) -> list[int]:
    result = [0] * len(temperatures)
    stack: list[int] = []
    for index, temperature in enumerate(temperatures):
        while stack and temperatures[stack[-1]] < temperature:
            previous = stack.pop()
            result[previous] = index - previous
        stack.append(index)
    return result


def eval_rpn(tokens: list[str]) -> int:
    stack: list[int] = []
    for token in tokens:
        if token in {"+", "-", "*", "/"}:
            right = stack.pop()
            left = stack.pop()
            if token == "+":
                stack.append(left + right)
            elif token == "-":
                stack.append(left - right)
            elif token == "*":
                stack.append(left * right)
            else:
                stack.append(int(left / right))
        else:
            stack.append(int(token))
    return stack[0]


def simplify_path(path: str) -> str:
    stack: list[str] = []
    for part in path.split("/"):
        if part in {"", "."}:
            continue
        if part == "..":
            if stack:
                stack.pop()
        else:
            stack.append(part)
    return "/" + "/".join(stack)


def calculate_ii(s: str) -> int:
    stack: list[int] = []
    number = 0
    operator = "+"

    def apply(op: str, value: int) -> None:
        if op == "+":
            stack.append(value)
        elif op == "-":
            stack.append(-value)
        elif op == "*":
            stack[-1] *= value
        else:
            stack[-1] = int(stack[-1] / value)

    for character in s:
        if character.isdigit():
            number = number * 10 + int(character)
        elif character in "+-*/":
            apply(operator, number)
            operator = character
            number = 0
    apply(operator, number)
    return sum(stack)


def check_inclusion(s1: str, s2: str) -> bool:
    if len(s1) > len(s2):
        return False
    need = Counter(s1)
    window = Counter(s2[: len(s1)])
    if window == need:
        return True
    for index in range(len(s1), len(s2)):
        window[s2[index]] += 1
        left = s2[index - len(s1)]
        window[left] -= 1
        if window[left] == 0:
            del window[left]
        if window == need:
            return True
    return False


def find_anagrams(s: str, p: str) -> list[int]:
    if len(p) > len(s):
        return []
    need = Counter(p)
    window = Counter(s[: len(p)])
    result = []
    if window == need:
        result.append(0)
    for index in range(len(p), len(s)):
        window[s[index]] += 1
        left = s[index - len(p)]
        window[left] -= 1
        if window[left] == 0:
            del window[left]
        if window == need:
            result.append(index - len(p) + 1)
    return result


def min_sub_array_len(target: int, nums: list[int]) -> int:
    left = 0
    total = 0
    best = len(nums) + 1
    for right, value in enumerate(nums):
        total += value
        while total >= target:
            best = min(best, right - left + 1)
            total -= nums[left]
            left += 1
    return 0 if best == len(nums) + 1 else best


def longest_ones(nums: list[int], k: int) -> int:
    left = 0
    zeros = 0
    best = 0
    for right, value in enumerate(nums):
        if value == 0:
            zeros += 1
        while zeros > k:
            if nums[left] == 0:
                zeros -= 1
            left += 1
        best = max(best, right - left + 1)
    return best


def character_replacement(s: str, k: int) -> int:
    counts: Counter[str] = Counter()
    left = 0
    best = 0
    max_frequency = 0
    for right, character in enumerate(s):
        counts[character] += 1
        max_frequency = max(max_frequency, counts[character])
        while right - left + 1 - max_frequency > k:
            counts[s[left]] -= 1
            left += 1
        best = max(best, right - left + 1)
    return best


def total_fruit(fruits: list[int]) -> int:
    counts: Counter[int] = Counter()
    left = 0
    best = 0
    for right, fruit in enumerate(fruits):
        counts[fruit] += 1
        while len(counts) > 2:
            counts[fruits[left]] -= 1
            if counts[fruits[left]] == 0:
                del counts[fruits[left]]
            left += 1
        best = max(best, right - left + 1)
    return best


def subarray_sum(nums: list[int], k: int) -> int:
    counts = {0: 1}
    total = 0
    result = 0
    for value in nums:
        total += value
        result += counts.get(total - k, 0)
        counts[total] = counts.get(total, 0) + 1
    return result


def interval_intersection(
    first_list: list[list[int]], second_list: list[list[int]]
) -> list[list[int]]:
    left = right = 0
    result = []
    while left < len(first_list) and right < len(second_list):
        start = max(first_list[left][0], second_list[right][0])
        end = min(first_list[left][1], second_list[right][1])
        if start <= end:
            result.append([start, end])
        if first_list[left][1] < second_list[right][1]:
            left += 1
        else:
            right += 1
    return result


def find_min_ii(nums: list[int]) -> int:
    left, right = 0, len(nums) - 1
    while left < right:
        middle = (left + right) // 2
        if nums[middle] > nums[right]:
            left = middle + 1
        elif nums[middle] < nums[right]:
            right = middle
        else:
            right -= 1
    return nums[left]


def find_closest_elements(arr: list[int], k: int, x: int) -> list[int]:
    nearest = sorted(arr, key=lambda value: (abs(value - x), value))[:k]
    return sorted(nearest)


def kth_smallest_matrix(matrix: list[list[int]], k: int) -> int:
    return sorted(value for row in matrix for value in row)[k - 1]


def min_eating_speed(piles: list[int], h: int) -> int:
    def hours(speed: int) -> int:
        return sum((pile + speed - 1) // speed for pile in piles)

    left, right = 1, max(piles)
    while left < right:
        middle = (left + right) // 2
        if hours(middle) <= h:
            right = middle
        else:
            left = middle + 1
    return left


def find_kth_number(m: int, n: int, k: int) -> int:
    def count(middle: int) -> int:
        return sum(min(middle // row, n) for row in range(1, m + 1))

    left, right = 1, m * n
    while left < right:
        middle = (left + right) // 2
        if count(middle) >= k:
            right = middle
        else:
            left = middle + 1
    return left


def count_substrings(s: str) -> int:
    total = 0
    for center in range(2 * len(s) - 1):
        left = center // 2
        right = left + center % 2
        while left >= 0 and right < len(s) and s[left] == s[right]:
            total += 1
            left -= 1
            right += 1
    return total


def update_matrix(mat: list[list[int]]) -> list[list[int]]:
    rows, columns = len(mat), len(mat[0])
    distance = [[-1] * columns for _ in range(rows)]
    queue = deque()
    for row in range(rows):
        for column in range(columns):
            if mat[row][column] == 0:
                distance[row][column] = 0
                queue.append((row, column))
    while queue:
        row, column = queue.popleft()
        for delta_row, delta_column in ((1, 0), (-1, 0), (0, 1), (0, -1)):
            next_row = row + delta_row
            next_column = column + delta_column
            if (
                0 <= next_row < rows
                and 0 <= next_column < columns
                and distance[next_row][next_column] == -1
            ):
                distance[next_row][next_column] = distance[row][column] + 1
                queue.append((next_row, next_column))
    return distance


def flood_fill(
    image: list[list[int]], sr: int, sc: int, color: int
) -> list[list[int]]:
    rows, columns = len(image), len(image[0])
    original = image[sr][sc]
    result = [row[:] for row in image]
    if original == color:
        return result
    queue = deque([(sr, sc)])
    result[sr][sc] = color
    while queue:
        row, column = queue.popleft()
        for delta_row, delta_column in ((1, 0), (-1, 0), (0, 1), (0, -1)):
            next_row = row + delta_row
            next_column = column + delta_column
            if (
                0 <= next_row < rows
                and 0 <= next_column < columns
                and result[next_row][next_column] == original
            ):
                result[next_row][next_column] = color
                queue.append((next_row, next_column))
    return result


def closed_island(grid: list[list[int]]) -> int:
    rows, columns = len(grid), len(grid[0])
    board = [row[:] for row in grid]

    def flood(start_row: int, start_column: int) -> None:
        stack = [(start_row, start_column)]
        board[start_row][start_column] = 1
        while stack:
            row, column = stack.pop()
            for delta_row, delta_column in ((1, 0), (-1, 0), (0, 1), (0, -1)):
                next_row = row + delta_row
                next_column = column + delta_column
                if (
                    0 <= next_row < rows
                    and 0 <= next_column < columns
                    and board[next_row][next_column] == 0
                ):
                    board[next_row][next_column] = 1
                    stack.append((next_row, next_column))

    for row in range(rows):
        for column in range(columns):
            if row in (0, rows - 1) or column in (0, columns - 1):
                if board[row][column] == 0:
                    flood(row, column)
    result = 0
    for row in range(rows):
        for column in range(columns):
            if board[row][column] == 0:
                result += 1
                flood(row, column)
    return result


def num_enclaves(grid: list[list[int]]) -> int:
    rows, columns = len(grid), len(grid[0])
    board = [row[:] for row in grid]

    def flood(start_row: int, start_column: int) -> None:
        stack = [(start_row, start_column)]
        board[start_row][start_column] = 0
        while stack:
            row, column = stack.pop()
            for delta_row, delta_column in ((1, 0), (-1, 0), (0, 1), (0, -1)):
                next_row = row + delta_row
                next_column = column + delta_column
                if (
                    0 <= next_row < rows
                    and 0 <= next_column < columns
                    and board[next_row][next_column] == 1
                ):
                    board[next_row][next_column] = 0
                    stack.append((next_row, next_column))

    for row in range(rows):
        for column in range(columns):
            if row in (0, rows - 1) or column in (0, columns - 1):
                if board[row][column] == 1:
                    flood(row, column)
    return sum(value for row in board for value in row)


def max_distance(grid: list[list[int]]) -> int:
    rows, columns = len(grid), len(grid[0])
    distance = [[-1] * columns for _ in range(rows)]
    queue = deque()
    for row in range(rows):
        for column in range(columns):
            if grid[row][column] == 1:
                distance[row][column] = 0
                queue.append((row, column))
    if not queue or len(queue) == rows * columns:
        return -1
    best = -1
    while queue:
        row, column = queue.popleft()
        for delta_row, delta_column in ((1, 0), (-1, 0), (0, 1), (0, -1)):
            next_row = row + delta_row
            next_column = column + delta_column
            if (
                0 <= next_row < rows
                and 0 <= next_column < columns
                and distance[next_row][next_column] == -1
            ):
                distance[next_row][next_column] = distance[row][column] + 1
                best = max(best, distance[next_row][next_column])
                queue.append((next_row, next_column))
    return best


def open_lock(deadends: list[str], target: str) -> int:
    blocked = set(deadends)
    if "0000" in blocked:
        return -1
    if target == "0000":
        return 0
    queue = deque([("0000", 0)])
    seen = {"0000"}
    while queue:
        state, steps = queue.popleft()
        for index in range(4):
            digit = int(state[index])
            for delta in (1, -1):
                next_digit = (digit + delta) % 10
                next_state = state[:index] + str(next_digit) + state[index + 1 :]
                if next_state in seen or next_state in blocked:
                    continue
                if next_state == target:
                    return steps + 1
                seen.add(next_state)
                queue.append((next_state, steps + 1))
    return -1


def knapsack01(weights: list[int], values: list[int], capacity: int) -> int:
    dp = [0] * (capacity + 1)
    for weight, value in zip(weights, values):
        for current in range(capacity, weight - 1, -1):
            dp[current] = max(dp[current], dp[current - weight] + value)
    return dp[capacity]


def complete_knapsack(weights: list[int], values: list[int], capacity: int) -> int:
    dp = [0] * (capacity + 1)
    for weight, value in zip(weights, values):
        for current in range(weight, capacity + 1):
            dp[current] = max(dp[current], dp[current - weight] + value)
    return dp[capacity]


def find_target_sum_ways(nums: list[int], target: int) -> int:
    total = sum(nums)
    if total < abs(target) or (total + target) % 2:
        return 0
    goal = (total + target) // 2
    dp = [0] * (goal + 1)
    dp[0] = 1
    for value in nums:
        for current in range(goal, value - 1, -1):
            dp[current] += dp[current - value]
    return dp[goal]


def find_max_form(strs: list[str], m: int, n: int) -> int:
    dp = [[0] * (n + 1) for _ in range(m + 1)]
    for text in strs:
        zeros = text.count("0")
        ones = len(text) - zeros
        for zero_limit in range(m, zeros - 1, -1):
            for one_limit in range(n, ones - 1, -1):
                dp[zero_limit][one_limit] = max(
                    dp[zero_limit][one_limit],
                    dp[zero_limit - zeros][one_limit - ones] + 1,
                )
    return dp[m][n]


def last_stone_weight_ii(stones: list[int]) -> int:
    total = sum(stones)
    target = total // 2
    reachable = [False] * (target + 1)
    reachable[0] = True
    for stone in stones:
        for current in range(target, stone - 1, -1):
            reachable[current] = reachable[current] or reachable[current - stone]
    best = max(index for index, value in enumerate(reachable) if value)
    return total - 2 * best


def integer_break(n: int) -> int:
    dp = [0] * (n + 1)
    dp[1] = 1
    for value in range(2, n + 1):
        for part in range(1, value):
            dp[value] = max(dp[value], part * (value - part), part * dp[value - part])
    return dp[n]


def num_trees(n: int) -> int:
    dp = [0] * (n + 1)
    dp[0] = 1
    for value in range(1, n + 1):
        dp[value] = sum(dp[left] * dp[value - 1 - left] for left in range(value))
    return dp[n]


def nth_ugly_number(n: int) -> int:
    ugly = [1] * n
    index2 = index3 = index5 = 0
    for index in range(1, n):
        next_value = min(ugly[index2] * 2, ugly[index3] * 3, ugly[index5] * 5)
        ugly[index] = next_value
        if next_value == ugly[index2] * 2:
            index2 += 1
        if next_value == ugly[index3] * 3:
            index3 += 1
        if next_value == ugly[index5] * 5:
            index5 += 1
    return ugly[-1]


def nth_super_ugly_number(n: int, primes: list[int]) -> int:
    ugly = [1] * n
    indices = [0] * len(primes)
    for index in range(1, n):
        next_value = min(ugly[indices[j]] * primes[j] for j in range(len(primes)))
        ugly[index] = next_value
        for j in range(len(primes)):
            if ugly[indices[j]] * primes[j] == next_value:
                indices[j] += 1
    return ugly[-1]


def fraction_to_decimal(numerator: int, denominator: int) -> str:
    if numerator == 0:
        return "0"
    sign = "-" if (numerator < 0) != (denominator < 0) else ""
    numerator, denominator = abs(numerator), abs(denominator)
    integer = numerator // denominator
    remainder = numerator % denominator
    if remainder == 0:
        return f"{sign}{integer}"
    digits = []
    seen: dict[int, int] = {}
    while remainder and remainder not in seen:
        seen[remainder] = len(digits)
        remainder *= 10
        digits.append(str(remainder // denominator))
        remainder %= denominator
    if remainder == 0:
        return f"{sign}{integer}." + "".join(digits)
    position = seen[remainder]
    return (
        f"{sign}{integer}."
        + "".join(digits[:position])
        + "("
        + "".join(digits[position:])
        + ")"
    )


def divide(dividend: int, divisor: int) -> int:
    if dividend == -(2**31) and divisor == -1:
        return 2**31 - 1
    sign = -1 if (dividend < 0) != (divisor < 0) else 1
    return sign * (abs(dividend) // abs(divisor))


def is_valid_sudoku(board: list[list[str]]) -> bool:
    rows = [set() for _ in range(9)]
    columns = [set() for _ in range(9)]
    boxes = [set() for _ in range(9)]
    for row in range(9):
        for column in range(9):
            value = board[row][column]
            if value == ".":
                continue
            box = (row // 3) * 3 + column // 3
            if value in rows[row] or value in columns[column] or value in boxes[box]:
                return False
            rows[row].add(value)
            columns[column].add(value)
            boxes[box].add(value)
    return True


PROBLEMS = [
    make(
        pid=1375,
        title="最长连续序列",
        tags=["数组", "哈希表"],
        description="""给定未排序的整数数组 nums，返回其中最长的连续数字序列的长度。
要求算法时间复杂度为 O(n)。""",
        function="longestConsecutive",
        params=[("nums", "int[]")],
        returns="int",
        solver=longest_consecutive,
        public=[[[100, 4, 200, 1, 3, 2]], [[0, 3, 7, 2, 5, 8, 4, 6, 0, 1]], [[]]],
        hidden=[[[1]], [[1, 2, 3]], [[1, 1, 2, 2]], [[9, 1, 4, 7, 3, -1, 0, 5, 8, -1, 6]]],
    ),
    make(
        pid=1376,
        title="矩阵置零",
        tags=["数组", "矩阵", "哈希表"],
        description="""给定 m x n 矩阵 matrix。若 matrix[i][j] == 0，则将其所在行和列的所有元素置为 0。
返回处理后的矩阵。""",
        function="setZeroes",
        params=[("matrix", "int[][]")],
        returns="int[][]",
        solver=set_zeroes,
        public=[
            [[[1, 1, 1], [1, 0, 1], [1, 1, 1]]],
            [[[0, 1, 2, 0], [3, 4, 5, 2], [1, 3, 1, 5]]],
        ],
        hidden=[[[[0]]], [[[1, 1], [1, 0]]], [[[1, 2], [3, 4]]]],
    ),
    make(
        pid=1377,
        title="生命游戏",
        tags=["数组", "矩阵", "模拟"],
        description="""根据当前状态计算下一状态：活细胞邻居少于 2 个或多于 3 个则死亡，
邻居为 2 或 3 个则存活；死细胞恰好有 3 个活邻居则复活。返回下一状态矩阵。""",
        function="gameOfLife",
        params=[("board", "int[][]")],
        returns="int[][]",
        solver=game_of_life,
        public=[
            [[[0, 1, 0], [0, 0, 1], [1, 1, 1], [0, 0, 0]]],
            [[[1, 1], [1, 0]]],
        ],
        hidden=[[[[0]]], [[[1]]], [[[1, 0], [0, 1]]], [[[0, 0], [0, 0]]]],
    ),
    make(
        pid=1378,
        title="插入区间",
        tags=["数组", "区间"],
        description="""给定按起点升序排列且互不重叠的区间数组 intervals 和新区间 newInterval。
将 newInterval 插入并合并所有重叠区间，返回结果区间数组。""",
        function="insert",
        params=[("intervals", "int[][]"), ("newInterval", "int[]")],
        returns="int[][]",
        solver=insert_interval,
        public=[
            [[[1, 3], [6, 9]], [2, 5]],
            [[[1, 2], [3, 5], [6, 7], [8, 10], [12, 16]], [4, 8]],
            [[], [5, 7]],
        ],
        hidden=[
            [[[1, 5]], [2, 3]],
            [[[1, 5]], [6, 8]],
            [[[3, 5], [6, 9]], [1, 2]],
            [[[1, 2], [5, 7]], [3, 4]],
        ],
    ),
    make(
        pid=1379,
        title="字符串解码",
        tags=["字符串", "栈", "递归"],
        description="""编码规则 k[encoded] 表示方括号内的字符串重复 k 次。
给定编码字符串 s，返回解码后的字符串。输入保证合法。""",
        function="decodeString",
        params=[("s", "string")],
        returns="string",
        solver=decode_string,
        public=[["3[a]2[bc]"], ["3[a2[c]]"], ["2[abc]3[cd]ef"]],
        hidden=[["abc"], ["1[a]"], ["2[z]"], ["10[a]"], ["2[a2[b]c]"]],
    ),
    make(
        pid=1380,
        title="每日温度",
        tags=["数组", "单调栈"],
        description="""给定每日温度 temperatures，返回数组 answer。
answer[i] 表示从第 i 天起，下一个更高温度出现在几天后；不存在则为 0。""",
        function="dailyTemperatures",
        params=[("temperatures", "int[]")],
        returns="int[]",
        solver=daily_temperatures,
        public=[[[73, 74, 75, 71, 69, 72, 76, 73]], [[30, 40, 50, 60]], [[30, 60, 90]]],
        hidden=[[[50]], [[50, 40, 30]], [[30, 30, 30]], [[80, 70, 60, 50, 40]]],
    ),
    make(
        pid=1381,
        title="逆波兰表达式求值",
        tags=["数组", "栈", "数学"],
        description="""tokens 表示一个逆波兰表达式，包含 +、-、*、/ 和整数。
除法向零截断。返回表达式的值。""",
        function="evalRPN",
        params=[("tokens", "string[]")],
        returns="int",
        solver=eval_rpn,
        public=[
            [["2", "1", "+", "3", "*"]],
            [["4", "13", "5", "/", "+"]],
            [["10", "6", "9", "3", "+", "-11", "*", "/", "*", "17", "+", "5", "+"]],
        ],
        hidden=[[["3"]], [["1", "2", "+"]], [["5", "2", "/"]], [["-3", "2", "/"]], [["4", "-2", "/"]]],
    ),
    make(
        pid=1382,
        title="简化路径",
        tags=["字符串", "栈"],
        description="""将 Unix 风格绝对路径简化：去掉多余斜杠和 "."，处理 ".."。
结果以 "/" 开头，且除根路径外不以 "/" 结尾。""",
        function="simplifyPath",
        params=[("path", "string")],
        returns="string",
        solver=simplify_path,
        public=[["/home/"], ["/../"], ["/home//foo/"], ["/a/./b/../../c/"]],
        hidden=[["/"], ["/a"], ["/a/b/../c"], ["/..."]],
    ),
    make(
        pid=1383,
        title="基本计算器 II",
        tags=["字符串", "栈", "数学"],
        description="""给定包含非负整数、+、-、*、/ 和空格的表达式 s，按整数运算规则计算。
除法向零截断。返回结果。""",
        function="calculate",
        params=[("s", "string")],
        returns="int",
        solver=calculate_ii,
        public=[["3+2*2"], [" 3/2 "], [" 3+5 / 2 "]],
        hidden=[["1"], ["1+1"], ["2*3+4"], ["14-3/2"], ["1-1+1"]],
    ),
    make(
        pid=1384,
        title="字符串的排列",
        tags=["字符串", "哈希表", "滑动窗口"],
        description="""给定两个字符串 s1 和 s2，判断 s1 的某个排列是否是 s2 的子串。""",
        function="checkInclusion",
        params=[("s1", "string"), ("s2", "string")],
        returns="bool",
        solver=check_inclusion,
        public=[["ab", "eidbaooo"], ["ab", "eidboaoo"], ["adc", "dcda"]],
        hidden=[["a", "a"], ["a", "b"], ["abc", "bbbca"], ["hello", "ooolleoooleh"]],
    ),
    make(
        pid=1385,
        title="找到字符串中所有字母异位词",
        tags=["字符串", "哈希表", "滑动窗口"],
        description="""返回字符串 s 中所有 p 的字母异位词子串的起始下标，按升序排列。""",
        function="findAnagrams",
        params=[("s", "string"), ("p", "string")],
        returns="int[]",
        solver=find_anagrams,
        public=[["cbaebabacd", "abc"], ["abab", "ab"], ["a", "a"]],
        hidden=[["aa", "aa"], ["abc", "cba"], ["xyz", "abc"], ["baa", "aa"]],
    ),
    make(
        pid=1386,
        title="长度最小的子数组",
        tags=["数组", "滑动窗口"],
        description="""给定正整数数组 nums 和正整数 target，返回和大于等于 target 的最短连续子数组长度。
不存在这样的子数组返回 0。""",
        function="minSubArrayLen",
        params=[("target", "int"), ("nums", "int[]")],
        returns="int",
        solver=min_sub_array_len,
        public=[[7, [2, 3, 1, 2, 4, 3]], [4, [1, 4, 4]], [11, [1, 1, 1, 1, 1, 1, 1, 1]]],
        hidden=[[1, [1]], [3, [1, 1]], [5, [1, 2, 3]], [100, [1, 2, 3]]],
    ),
    make(
        pid=1387,
        title="最大连续 1 的个数 III",
        tags=["数组", "滑动窗口"],
        description="""给定二进制数组 nums 和整数 k，最多可以将 k 个 0 翻转为 1。
返回最长的全 1 子数组长度。""",
        function="longestOnes",
        params=[("nums", "int[]"), ("k", "int")],
        returns="int",
        solver=longest_ones,
        public=[
            [[1, 1, 1, 0, 0, 0, 1, 1, 1, 1, 0], 2],
            [[0, 0, 1, 1, 0, 0, 1, 1, 1, 0, 1, 1, 0, 0, 0, 1, 1, 1, 1], 3],
            [[1, 1, 1], 0],
        ],
        hidden=[[[0], 0], [[1], 0], [[0], 1], [[0, 0, 0], 2]],
    ),
    make(
        pid=1388,
        title="替换后的最长重复字符",
        tags=["字符串", "滑动窗口"],
        description="""给定字符串 s 和整数 k，最多可以将 k 个字符替换为任意字符。
返回替换后最长的相同字符连续子串长度。""",
        function="characterReplacement",
        params=[("s", "string"), ("k", "int")],
        returns="int",
        solver=character_replacement,
        public=[["ABAB", 2], ["AABABBA", 1], ["AAAA", 0]],
        hidden=[["A", 0], ["AB", 1], ["ABC", 2], ["AABBB", 0]],
    ),
    make(
        pid=1389,
        title="水果成篮",
        tags=["数组", "滑动窗口"],
        description="""给定水果类型数组 fruits，最多携带两种水果。
返回能摘到的最多水果数量（即最长只含两种元素的连续子数组长度）。""",
        function="totalFruit",
        params=[("fruits", "int[]")],
        returns="int",
        solver=total_fruit,
        public=[[[1, 2, 1]], [[0, 1, 2, 2]], [[1, 2, 3, 2, 2]]],
        hidden=[[[1]], [[1, 2]], [[1, 2, 1, 2, 3]], [[3, 3, 3, 1, 2, 1, 1, 2, 3, 3, 4]]],
    ),
    make(
        pid=1390,
        title="和为 K 的子数组",
        tags=["数组", "哈希表", "前缀和"],
        description="""返回数组 nums 中和恰好为 k 的连续子数组个数。""",
        function="subarraySum",
        params=[("nums", "int[]"), ("k", "int")],
        returns="int",
        solver=subarray_sum,
        public=[[[1, 1, 1], 2], [[1, 2, 3], 3], [[1, -1, 0], 0]],
        hidden=[[[1], 1], [[1], 2], [[0, 0, 0], 0], [[-1, -1, 1], 0]],
    ),
    make(
        pid=1391,
        title="区间列表的交集",
        tags=["数组", "双指针", "区间"],
        description="""给定两个闭区间列表 firstList 和 secondList，二者各自按起点升序且互不重叠。
返回它们的交集区间，按起点升序排列。""",
        function="intervalIntersection",
        params=[("firstList", "int[][]"), ("secondList", "int[][]")],
        returns="int[][]",
        solver=interval_intersection,
        public=[
            [[[0, 2], [5, 10], [13, 23], [24, 25]], [[1, 5], [8, 12], [15, 24], [25, 26]]],
            [[[1, 3], [5, 9]], []],
            [[], [[4, 8], [10, 12]]],
        ],
        hidden=[[[[1, 2]], [[2, 3]]], [[[1, 5]], [[2, 3]]], [[[1, 2]], [[3, 4]]]],
    ),
    make(
        pid=1392,
        title="寻找旋转排序数组中的最小值 II",
        tags=["数组", "二分查找"],
        description="""给定一个升序数组经过若干次旋转后的结果 nums，数组中可能包含重复元素。
返回数组中的最小元素。""",
        function="findMin",
        params=[("nums", "int[]")],
        returns="int",
        solver=find_min_ii,
        public=[[[1, 3, 5]], [[2, 2, 2, 0, 1]], [[3, 1, 3]]],
        hidden=[[[1]], [[1, 1]], [[2, 1]], [[1, 3, 3]]],
    ),
    make(
        pid=1393,
        title="搜索旋转排序数组 II",
        tags=["数组", "二分查找"],
        description="""给定可能存在重复元素的旋转排序数组 nums 和目标值 target，判断 target 是否在数组中。""",
        function="search",
        params=[("nums", "int[]"), ("target", "int")],
        returns="bool",
        solver=lambda nums, target: target in nums,
        public=[[[2, 5, 6, 0, 0, 1, 2], 0], [[2, 5, 6, 0, 0, 1, 2], 3], [[1, 0, 1, 1, 1], 0]],
        hidden=[[[1], 1], [[1], 0], [[1, 1], 1], [[3, 1, 3], 3]],
    ),
    make(
        pid=1394,
        title="找到 K 个最接近的元素",
        tags=["数组", "二分查找", "排序"],
        description="""给定升序数组 arr、整数 k 和 x，返回最接近 x 的 k 个元素，按升序排列。
若距离相同，优先选择较小的元素。""",
        function="findClosestElements",
        params=[("arr", "int[]"), ("k", "int"), ("x", "int")],
        returns="int[]",
        solver=find_closest_elements,
        public=[[[1, 2, 3, 4, 5], 4, 3], [[1, 2, 3, 4, 5], 4, -1], [[1, 2, 3, 4, 5], 4, 6]],
        hidden=[[[1], 1, 5], [[1, 2], 1, 1], [[1, 2, 3], 2, 2], [[1, 5, 9], 2, 6]],
    ),
    make(
        pid=1395,
        title="有序矩阵中第 K 小的元素",
        tags=["数组", "矩阵", "二分查找", "堆"],
        description="""给定 n x n 矩阵 matrix，每行每列均按升序排列。
返回矩阵中第 k 小的元素（重复元素分别计数）。""",
        function="kthSmallest",
        params=[("matrix", "int[][]"), ("k", "int")],
        returns="int",
        solver=kth_smallest_matrix,
        public=[
            [[[1, 5, 9], [10, 11, 13], [12, 13, 15]], 8],
            [[[-5]], 1],
        ],
        hidden=[
            [[[1, 2], [3, 4]], 2],
            [[[1, 1], [1, 1]], 4],
            [[[1, 3, 5], [6, 7, 12], [11, 14, 14]], 6],
        ],
    ),
    make(
        pid=1396,
        title="爱吃香蕉的珂珂",
        tags=["数组", "二分查找"],
        description="""有 piles 堆香蕉。珂珂每小时选择一堆，以速度 k 吃香蕉；若该堆不足 k 根则吃完并停止这一小时。
返回在 h 小时内吃完所有香蕉的最小速度 k。""",
        function="minEatingSpeed",
        params=[("piles", "int[]"), ("h", "int")],
        returns="int",
        solver=min_eating_speed,
        public=[[[3, 6, 7, 11], 8], [[30, 11, 23, 4, 20], 5], [[30, 11, 23, 4, 20], 6]],
        hidden=[[[1], 1], [[1], 2], [[1000000000], 2], [[1, 2, 3], 3]],
    ),
    make(
        pid=1397,
        title="乘法表中第 K 小的数",
        tags=["数学", "二分查找"],
        description="""m x n 乘法表的第 i 行第 j 列元素为 i * j（从 1 开始）。
返回表中第 k 小的数（重复元素分别计数）。""",
        function="findKthNumber",
        params=[("m", "int"), ("n", "int"), ("k", "int")],
        returns="int",
        solver=find_kth_number,
        public=[[3, 3, 5], [2, 3, 6], [1, 1, 1]],
        hidden=[[1, 2, 2], [2, 2, 4], [10, 10, 50]],
    ),
    make(
        pid=1398,
        title="回文子串",
        tags=["字符串", "动态规划", "中心扩展"],
        description="""返回字符串 s 中回文子串的个数。不同起止位置的回文子串分别计数。""",
        function="countSubstrings",
        params=[("s", "string")],
        returns="int",
        solver=count_substrings,
        public=[["abc"], ["aaa"], ["abba"]],
        hidden=[["a"], ["aa"], ["aba"], ["abcd"]],
    ),
    make(
        pid=1399,
        title="01 矩阵",
        tags=["数组", "矩阵", "广度优先搜索"],
        description="""给定只含 0 和 1 的矩阵 mat，返回每个元素到最近的 0 的距离。
相邻元素按上下左右四个方向计算。""",
        function="updateMatrix",
        params=[("mat", "int[][]")],
        returns="int[][]",
        solver=update_matrix,
        public=[
            [[[0, 0, 0], [0, 1, 0], [0, 0, 0]]],
            [[[0, 0, 0], [0, 1, 0], [1, 1, 1]]],
        ],
        hidden=[[[[0]]], [[[0, 1]]], [[[1, 0]]], [[[1, 1], [1, 0]]]],
    ),
    make(
        pid=1400,
        title="图像渲染",
        tags=["数组", "矩阵", "广度优先搜索"],
        description="""给定图像 image、起始像素 (sr, sc) 和新颜色 color，
将与起始像素颜色相同且四连通的区域全部染成新颜色。返回处理后的图像。""",
        function="floodFill",
        params=[("image", "int[][]"), ("sr", "int"), ("sc", "int"), ("color", "int")],
        returns="int[][]",
        solver=flood_fill,
        public=[
            [[[1, 1, 1], [1, 1, 0], [1, 0, 1]], 1, 1, 2],
            [[[0, 0, 0], [0, 0, 0]], 0, 0, 0],
            [[[0, 0, 0], [0, 1, 1]], 1, 1, 1],
        ],
        hidden=[
            [[[1]], 0, 0, 2],
            [[[1, 1], [1, 1]], 0, 0, 2],
            [[[1, 2], [3, 4]], 1, 1, 5],
        ],
    ),
    make(
        pid=1401,
        title="统计封闭岛屿的数目",
        tags=["数组", "矩阵", "深度优先搜索"],
        description="""0 表示陆地，1 表示水。封闭岛屿是完全被水包围、且不接触网格边界的陆地连通块。
返回封闭岛屿的数目。""",
        function="closedIsland",
        params=[("grid", "int[][]")],
        returns="int",
        solver=closed_island,
        public=[
            [[[1, 1, 1], [1, 0, 1], [1, 1, 1]]],
            [[[0, 0, 0], [0, 1, 0], [0, 0, 0]]],
            [[[1, 0, 1], [0, 1, 0], [1, 0, 1]]],
        ],
        hidden=[[[[1, 1], [1, 1]]], [[[0]]], [[[1]]], [[[0, 1], [1, 1]]]],
    ),
    make(
        pid=1402,
        title="飞地的数量",
        tags=["数组", "矩阵", "深度优先搜索"],
        description="""1 表示陆地，0 表示水。飞地指不能通过四连通陆地到达网格边界的陆地格。
返回飞地的数量。""",
        function="numEnclaves",
        params=[("grid", "int[][]")],
        returns="int",
        solver=num_enclaves,
        public=[
            [[[0, 0, 0, 0], [1, 0, 1, 0], [0, 1, 1, 0], [0, 0, 0, 0]]],
            [[[0, 1, 1, 0], [0, 0, 1, 0], [0, 0, 1, 0], [0, 0, 0, 0]]],
        ],
        hidden=[[[[0]]], [[[1]]], [[[0, 0], [0, 0]]], [[[1, 0], [0, 1]]], [[[0, 0, 0], [0, 1, 0], [0, 0, 0]]]],
    ),
    make(
        pid=1403,
        title="地图分析",
        tags=["数组", "矩阵", "广度优先搜索"],
        description="""网格中 0 表示海洋，1 表示陆地。返回每个海洋格到最近陆地的曼哈顿距离的最大值。
若网格中没有陆地或没有海洋，返回 -1。""",
        function="maxDistance",
        params=[("grid", "int[][]")],
        returns="int",
        solver=max_distance,
        public=[
            [[[1, 0, 1], [0, 0, 0], [1, 0, 1]]],
            [[[1, 0, 0], [0, 0, 0], [0, 0, 0]]],
            [[[0, 0], [0, 0]]],
        ],
        hidden=[[[[1]]], [[[0]]], [[[1, 1], [1, 1]]], [[[1, 0], [0, 0]]]],
    ),
    make(
        pid=1404,
        title="打开转盘锁",
        tags=["广度优先搜索", "字符串"],
        description="""转盘有 4 位数字，每次可将一位加 1 或减 1（9 加 1 变 0，0 减 1 变 9）。
从 "0000" 出发，避开 deadends，返回打开 target 的最少步数；无法打开返回 -1。""",
        function="openLock",
        params=[("deadends", "string[]"), ("target", "string")],
        returns="int",
        solver=open_lock,
        public=[
            [["0201", "0101", "0102", "1212", "2002"], "0202"],
            [["8888"], "0009"],
            [["8887", "8889", "8878", "8898", "8788", "8988", "7888", "9888"], "8888"],
        ],
        hidden=[[[], "0000"], [["0000"], "8888"], [["1111"], "2222"], [["9999"], "0001"]],
    ),
    make(
        pid=1405,
        title="01 背包",
        tags=["动态规划", "背包"],
        description="""给定 n 件物品的重量 weights、价值 values 和背包容量 capacity。
每件物品最多选择一次，返回能获得的最大价值。""",
        function="knapsack01",
        params=[("weights", "int[]"), ("values", "int[]"), ("capacity", "int")],
        returns="int",
        solver=knapsack01,
        public=[[[1, 3, 4], [15, 20, 30], 4], [[2, 2, 3], [3, 4, 5], 5], [[1], [1], 0]],
        hidden=[[[], [], 10], [[1], [5], 1], [[5], [10], 4], [[2, 3, 4], [3, 4, 5], 6]],
    ),
    make(
        pid=1406,
        title="完全背包",
        tags=["动态规划", "背包"],
        description="""给定物品重量 weights、价值 values 和背包容量 capacity。
每种物品可以选择任意多次，返回容量内能获得的最大价值。""",
        function="completeKnapsack",
        params=[("weights", "int[]"), ("values", "int[]"), ("capacity", "int")],
        returns="int",
        solver=complete_knapsack,
        public=[[[1, 3, 4], [15, 20, 30], 4], [[2, 3], [3, 5], 7], [[1], [2], 5]],
        hidden=[[[], [], 10], [[5], [10], 4], [[2], [3], 7], [[3, 4], [5, 6], 10]],
    ),
    make(
        pid=1407,
        title="目标和",
        tags=["数组", "动态规划", "回溯"],
        description="""给定整数数组 nums 和整数 target。给每个 nums[i] 前添加 '+' 或 '-'，
返回使表达式结果等于 target 的方案数。""",
        function="findTargetSumWays",
        params=[("nums", "int[]"), ("target", "int")],
        returns="int",
        solver=find_target_sum_ways,
        public=[[[1, 1, 1, 1, 1], 3], [[1], 1], [[1, 0], 1]],
        hidden=[[[0], 0], [[1, 1], 0], [[1, 2, 3], 0], [[2, 2], 0]],
    ),
    make(
        pid=1408,
        title="一和零",
        tags=["数组", "字符串", "动态规划"],
        description="""给定二进制字符串数组 strs 和整数 m、n。
返回最多包含 m 个 0 和 n 个 1 的最大子集大小。""",
        function="findMaxForm",
        params=[("strs", "string[]"), ("m", "int"), ("n", "int")],
        returns="int",
        solver=find_max_form,
        public=[
            [["10", "0001", "111001", "1", "0"], 5, 3],
            [["10", "0", "1"], 1, 1],
            [["0"], 1, 0],
        ],
        hidden=[[[], 0, 0], [["0"], 1, 0], [["1"], 0, 1], [["00", "11"], 2, 2]],
    ),
    make(
        pid=1409,
        title="最后一块石头的重量 II",
        tags=["数组", "动态规划"],
        description="""将石头分成两堆，返回两堆重量差的最小值。""",
        function="lastStoneWeightII",
        params=[("stones", "int[]")],
        returns="int",
        solver=last_stone_weight_ii,
        public=[[[2, 7, 4, 1, 8, 1]], [[31, 26, 33, 21, 40]], [[1, 2]]],
        hidden=[[[1]], [[1, 1]], [[1, 2, 3]], [[2, 2, 2, 2]]],
    ),
    make(
        pid=1410,
        title="整数拆分",
        tags=["数学", "动态规划"],
        description="""将正整数 n 拆分成至少两个正整数之和，返回这些整数乘积的最大值。
给定 2 <= n <= 58。""",
        function="integerBreak",
        params=[("n", "int")],
        returns="int",
        solver=integer_break,
        public=[[2], [10], [3]],
        hidden=[[4], [5], [8], [58]],
    ),
    make(
        pid=1411,
        title="不同的二叉搜索树",
        tags=["数学", "动态规划", "树"],
        description="""给定整数 n，返回由节点值 1 到 n 构成的结构不同的二叉搜索树数量。""",
        function="numTrees",
        params=[("n", "int")],
        returns="int",
        solver=num_trees,
        public=[[3], [1], [19]],
        hidden=[[2], [5], [10]],
    ),
    make(
        pid=1412,
        title="丑数 II",
        tags=["数学", "动态规划", "堆"],
        description="""丑数是只含质因子 2、3、5 的正整数。1 是第一个丑数。
返回第 n 个丑数。""",
        function="nthUglyNumber",
        params=[("n", "int")],
        returns="int",
        solver=nth_ugly_number,
        public=[[10], [1], [20]],
        hidden=[[2], [3], [7], [1690]],
    ),
    make(
        pid=1413,
        title="超级丑数",
        tags=["数学", "动态规划", "堆"],
        description="""超级丑数是所有质因子都在给定数组 primes 中的正整数。1 是第一个超级丑数。
返回第 n 个超级丑数。""",
        function="nthSuperUglyNumber",
        params=[("n", "int"), ("primes", "int[]")],
        returns="int",
        solver=nth_super_ugly_number,
        public=[[12, [2, 7, 13, 19]], [1, [2, 3, 5]], [5, [2, 3, 5]]],
        hidden=[[2, [2]], [3, [2, 3]], [10, [3, 5, 7]]],
    ),
    make(
        pid=1414,
        title="分数到小数",
        tags=["数学", "字符串", "哈希表"],
        description="""给定分子 numerator 和分母 denominator，返回小数字符串。
若小数部分循环，用括号括起循环部分。""",
        function="fractionToDecimal",
        params=[("numerator", "int"), ("denominator", "int")],
        returns="string",
        solver=fraction_to_decimal,
        public=[[1, 2], [2, 1], [4, 333]],
        hidden=[[1, 3], [-1, 2], [2, -3], [-50, 8], [7, 12]],
    ),
    make(
        pid=1415,
        title="两数相除",
        tags=["数学", "位运算"],
        description="""不使用乘法、除法和取模，计算两个整数相除，结果向零截断。
若结果超出 32 位有符号整数范围，返回 2^31 - 1。""",
        function="divide",
        params=[("dividend", "int"), ("divisor", "int")],
        returns="int",
        solver=divide,
        public=[[10, 3], [7, -3], [-2147483648, -1]],
        hidden=[[1, 1], [-1, 1], [0, 5], [-2147483648, 1], [2147483647, 2]],
    ),
    make(
        pid=1416,
        title="有效的数独",
        tags=["数组", "矩阵", "哈希表"],
        description="""判断 9 x 9 数独棋盘是否有效：每行、每列、每个 3 x 3 宫内，
数字 1 到 9 不能重复。空格用 '.' 表示。""",
        function="isValidSudoku",
        params=[("board", "string[][]")],
        returns="bool",
        solver=is_valid_sudoku,
        public=[[SUDOKU_VALID], [SUDOKU_BAD_ROW], [SUDOKU_BAD_BOX]],
        hidden=[[SUDOKU_VALID], [SUDOKU_BAD_ROW]],
    ),
]
