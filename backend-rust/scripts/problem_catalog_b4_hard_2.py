"""2080-2099：批量第四批困难题（20 道）。"""

from __future__ import annotations

import heapq
import sys
from collections import deque
from fractions import Fraction
from functools import lru_cache, partial

from problem_seed_common import make_problem

make = partial(make_problem, difficulty="hard")


# ── 2080 直线上最多的点数 ──────────────────────────────────────────


def max_points_on_a_line(points: list[list[int]]) -> int:
    from math import gcd

    size = len(points)
    if size <= 2:
        return size
    best = 0
    for i in range(size):
        slopes: dict[tuple[int, int], int] = {}
        same = 1
        xi, yi = points[i]
        for j in range(i + 1, size):
            dx = points[j][0] - xi
            dy = points[j][1] - yi
            if dx == 0 and dy == 0:
                same += 1
                continue
            divisor = gcd(abs(dx), abs(dy))
            dx //= divisor
            dy //= divisor
            if dx < 0 or (dx == 0 and dy < 0):
                dx, dy = -dx, -dy
            slopes[(dx, dy)] = slopes.get((dx, dy), 0) + 1
        best = max(best, same + (max(slopes.values()) if slopes else 0))
    return best


# ── 2081 给表达式添加运算符 ────────────────────────────────────────


def add_operators(num: str, target: int) -> list[str]:
    results: list[str] = []

    def dfs(index: int, expression: str, value: int, last: int) -> None:
        if index == len(num):
            if value == target:
                results.append(expression)
            return
        for end in range(index, len(num)):
            if end > index and num[index] == "0":
                break
            piece = num[index : end + 1]
            current = int(piece)
            if index == 0:
                dfs(end + 1, piece, current, current)
            else:
                dfs(end + 1, f"{expression}+{piece}", value + current, current)
                dfs(end + 1, f"{expression}-{piece}", value - current, -current)
                dfs(
                    end + 1,
                    f"{expression}*{piece}",
                    value - last + last * current,
                    last * current,
                )

    dfs(0, "", 0, 0)
    return sorted(results)


# ── 2082 最小好进制 ────────────────────────────────────────────────


def smallest_good_base(n: str) -> str:
    value = int(n)
    max_length = value.bit_length()
    for length in range(max_length, 1, -1):
        low, high = 2, value - 1
        while low <= high:
            middle = (low + high) // 2
            total = 0
            power = 1
            for _ in range(length):
                total += power
                if total > value:
                    break
                power *= middle
            if total == value:
                return str(middle)
            if total < value:
                low = middle + 1
            else:
                high = middle - 1
    return str(value - 1)


# ── 2083 解码方法 II ──────────────────────────────────────────────


def num_decodings_two(s: str) -> int:
    mod = 10**9 + 7
    size = len(s)
    dp = [0] * (size + 1)
    dp[0] = 1
    for i in range(1, size + 1):
        current = s[i - 1]
        if current == "*":
            dp[i] = dp[i - 1] * 9
        elif current != "0":
            dp[i] = dp[i - 1]
        if i >= 2:
            pair = s[i - 2 : i]
            if pair == "**":
                ways = 15
            elif pair[0] == "*":
                ways = 2 if pair[1] <= "6" else 1
            elif pair[1] == "*":
                if pair[0] == "1":
                    ways = 9
                elif pair[0] == "2":
                    ways = 6
                else:
                    ways = 0
            else:
                ways = 1 if 10 <= int(pair) <= 26 else 0
            dp[i] += dp[i - 2] * ways
        dp[i] %= mod
    return dp[size]


# ── 2084 中心对称数 III ───────────────────────────────────────────


def strobogrammatic_in_range(low: str, high: str) -> int:
    pairs = (("0", "0"), ("1", "1"), ("6", "9"), ("8", "8"), ("9", "6"))

    @lru_cache(maxsize=None)
    def generate(length: int) -> tuple[str, ...]:
        if length == 0:
            return ("",)
        if length == 1:
            return ("0", "1", "8")
        result: list[str] = []
        for inner in generate(length - 2):
            for left, right in pairs:
                result.append(left + inner + right)
        return tuple(result)

    low_value, high_value = int(low), int(high)
    total = 0
    for length in range(len(low), len(high) + 1):
        for number in generate(length):
            if length > 1 and number[0] == "0":
                continue
            value = int(number)
            if low_value <= value <= high_value:
                total += 1
    return total


# ── 2085 冗余连接 II ──────────────────────────────────────────────


def redundant_connection_two(edges: list[list[int]]) -> list[int]:
    size = len(edges)
    first_parent: dict[int, list[int]] = {}
    second_edge: list[int] | None = None
    first_edge: list[int] | None = None
    for u, v in edges:
        if v in first_parent:
            first_edge = first_parent[v]
            second_edge = [u, v]
        else:
            first_parent[v] = [u, v]

    def build_and_check(skip: list[int] | None) -> list[int] | None:
        parent = list(range(size + 1))

        def find(node: int) -> int:
            while parent[node] != node:
                parent[node] = parent[parent[node]]
                node = parent[node]
            return node

        for u, v in edges:
            if skip is not None and u == skip[0] and v == skip[1]:
                continue
            root_u, root_v = find(u), find(v)
            if root_u == root_v:
                return [u, v]
            parent[root_u] = root_v
        return None

    if second_edge is not None:
        assert first_edge is not None
        if build_and_check(second_edge) is None:
            return second_edge
        return first_edge
    cycle_edge = build_and_check(None)
    assert cycle_edge is not None
    return cycle_edge


# ── 2086 贴纸拼词 ─────────────────────────────────────────────────


def stickers_to_spell_word(stickers: list[str], target: str) -> int:
    target_size = len(target)
    full_mask = (1 << target_size) - 1

    @lru_cache(maxsize=None)
    def dfs(mask: int) -> int:
        if mask == full_mask:
            return 0
        best = None
        for sticker in stickers:
            available: dict[str, int] = {}
            for character in sticker:
                available[character] = available.get(character, 0) + 1
            new_mask = mask
            used: dict[str, int] = {}
            for position in range(target_size):
                if (new_mask >> position) & 1:
                    continue
                character = target[position]
                if used.get(character, 0) < available.get(character, 0):
                    used[character] = used.get(character, 0) + 1
                    new_mask |= 1 << position
            if new_mask != mask:
                remainder = dfs(new_mask)
                if remainder != -1:
                    candidate = remainder + 1
                    if best is None or candidate < best:
                        best = candidate
        return -1 if best is None else best

    return dfs(0)


# ── 2087 找出第 K 小的数对距离 ────────────────────────────────────


def kth_smallest_pair_distance(nums: list[int], k: int) -> int:
    ordered = sorted(nums)
    size = len(ordered)

    def count_at_most(limit: int) -> int:
        count = 0
        right = 0
        for left in range(size):
            if right < left + 1:
                right = left + 1
            while right < size and ordered[right] - ordered[left] <= limit:
                right += 1
            count += right - left - 1
        return count

    low, high = 0, ordered[-1] - ordered[0]
    while low < high:
        middle = (low + high) // 2
        if count_at_most(middle) >= k:
            high = middle
        else:
            low = middle + 1
    return low


# ── 2088 查找集群内的关键连接 ────────────────────────────────────


def critical_connections(n: int, connections: list[list[int]]) -> list[list[int]]:
    sys.setrecursionlimit(10000)
    graph: list[list[int]] = [[] for _ in range(n)]
    for u, v in connections:
        graph[u].append(v)
        graph[v].append(u)

    discovery = [-1] * n
    low = [0] * n
    timer = 0
    bridges: list[list[int]] = []

    def dfs(node: int, parent: int) -> None:
        nonlocal timer
        discovery[node] = low[node] = timer
        timer += 1
        for neighbour in graph[node]:
            if neighbour == parent:
                continue
            if discovery[neighbour] == -1:
                dfs(neighbour, node)
                low[node] = min(low[node], low[neighbour])
                if low[neighbour] > discovery[node]:
                    bridges.append(sorted((node, neighbour)))
            else:
                low[node] = min(low[node], discovery[neighbour])

    for node in range(n):
        if discovery[node] == -1:
            dfs(node, -1)
    bridges.sort()
    return bridges


# ── 2089 滑动谜题 ─────────────────────────────────────────────────


def sliding_puzzle(board: list[list[int]]) -> int:
    start = tuple(board[0] + board[1])
    goal = (1, 2, 3, 4, 5, 0)
    if start == goal:
        return 0
    neighbours = {
        0: (1, 3),
        1: (0, 2, 4),
        2: (1, 5),
        3: (0, 4),
        4: (1, 3, 5),
        5: (2, 4),
    }
    queue = deque([(start, 0)])
    visited = {start}
    while queue:
        state, distance = queue.popleft()
        zero = state.index(0)
        for target_index in neighbours[zero]:
            values = list(state)
            values[zero], values[target_index] = values[target_index], values[zero]
            next_state = tuple(values)
            if next_state == goal:
                return distance + 1
            if next_state not in visited:
                visited.add(next_state)
                queue.append((next_state, distance + 1))
    return -1


# ── 2090 到达终点 ─────────────────────────────────────────────────


def reaching_points(sx: int, sy: int, tx: int, ty: int) -> bool:
    if sx > tx or sy > ty:
        return False
    while tx > sx and ty > sy:
        if tx > ty:
            tx %= ty
        else:
            ty %= tx
        if tx == 0 or ty == 0:
            return False
    if tx == sx and ty >= sy:
        return (ty - sy) % tx == 0
    if ty == sy and tx >= sx:
        return (tx - sx) % ty == 0
    return False


# ── 2091 第 K 个最小的素数分数 ────────────────────────────────────


def kth_smallest_prime_fraction(arr: list[int], k: int) -> list[int]:
    size = len(arr)
    heap = [
        (Fraction(arr[0], arr[j]), 0, j) for j in range(1, size)
    ]
    heapq.heapify(heap)
    for _ in range(k - 1):
        _, numerator_index, denominator_index = heapq.heappop(heap)
        if numerator_index + 1 < denominator_index:
            next_index = numerator_index + 1
            heapq.heappush(
                heap,
                (
                    Fraction(arr[next_index], arr[denominator_index]),
                    next_index,
                    denominator_index,
                ),
            )
    _, numerator_index, denominator_index = heapq.heappop(heap)
    return [arr[numerator_index], arr[denominator_index]]


# ── 2092 黑板异或游戏 ─────────────────────────────────────────────


def xor_game(nums: list[int]) -> bool:
    total = 0
    for value in nums:
        total ^= value
    return total == 0 or len(nums) % 2 == 0


# ── 2093 矩形面积 II ──────────────────────────────────────────────


def rectangle_area(rectangles: list[list[int]]) -> int:
    mod = 10**9 + 7
    x_coordinates = sorted(
        {rectangle[0] for rectangle in rectangles}
        | {rectangle[2] for rectangle in rectangles}
    )
    total = 0
    for index in range(len(x_coordinates) - 1):
        left_x = x_coordinates[index]
        right_x = x_coordinates[index + 1]
        middle_x = (left_x + right_x) / 2
        intervals: list[tuple[int, int]] = []
        for x1, y1, x2, y2 in rectangles:
            if x1 <= middle_x <= x2:
                intervals.append((y1, y2))
        if not intervals:
            continue
        intervals.sort()
        merged: list[list[int]] = []
        for start, end in intervals:
            if not merged or start > merged[-1][1]:
                merged.append([start, end])
            elif end > merged[-1][1]:
                merged[-1][1] = end
        height = sum(end - start for start, end in merged)
        total = (total + (right_x - left_x) * height) % mod
    return total


# ── 2094 在网格图中访问一个格子的最少时间 ─────────────────────────


def minimum_time_to_visit_cell(grid: list[list[int]]) -> int:
    rows, columns = len(grid), len(grid[0])
    if grid[0][0] != 0:
        return -1
    if rows == 1 and columns == 1:
        return 0
    can_start = False
    if columns > 1 and grid[0][1] <= 1:
        can_start = True
    if rows > 1 and grid[1][0] <= 1:
        can_start = True
    if not can_start:
        return -1
    infinity = float("inf")
    distance = [[infinity] * columns for _ in range(rows)]
    distance[0][0] = 0
    heap = [(0, 0, 0)]
    directions = ((1, 0), (-1, 0), (0, 1), (0, -1))
    while heap:
        time, row, column = heapq.heappop(heap)
        if time != distance[row][column]:
            continue
        if row == rows - 1 and column == columns - 1:
            return time
        for delta_row, delta_column in directions:
            next_row = row + delta_row
            next_column = column + delta_column
            if not (0 <= next_row < rows and 0 <= next_column < columns):
                continue
            arrival = time + 1
            required = grid[next_row][next_column]
            if arrival < required:
                arrival = required + (required - arrival) % 2
            if arrival < distance[next_row][next_column]:
                distance[next_row][next_column] = arrival
                heapq.heappush(heap, (arrival, next_row, next_column))
    return -1


# ── 2095 图中的最短环 ─────────────────────────────────────────────


def shortest_cycle(n: int, edges: list[list[int]]) -> int:
    graph: list[list[int]] = [[] for _ in range(n)]
    for u, v in edges:
        graph[u].append(v)
        graph[v].append(u)
    best = float("inf")
    for start in range(n):
        distance = [-1] * n
        parent = [-1] * n
        distance[start] = 0
        queue = deque([start])
        while queue:
            node = queue.popleft()
            for neighbour in graph[node]:
                if distance[neighbour] == -1:
                    distance[neighbour] = distance[node] + 1
                    parent[neighbour] = node
                    queue.append(neighbour)
                elif parent[node] != neighbour:
                    best = min(best, distance[node] + distance[neighbour] + 1)
    return -1 if best == float("inf") else best


# ── 2096 最大公约数遍历 ───────────────────────────────────────────


def can_traverse_all_pairs(nums: list[int]) -> bool:
    size = len(nums)
    if size == 1:
        return True
    maximum = max(nums)
    if maximum == 1:
        return False

    smallest_prime = list(range(maximum + 1))
    factor = 2
    while factor * factor <= maximum:
        if smallest_prime[factor] == factor:
            for multiple in range(factor * factor, maximum + 1, factor):
                if smallest_prime[multiple] == multiple:
                    smallest_prime[multiple] = factor
        factor += 1

    parent = list(range(size))

    def find(node: int) -> int:
        while parent[node] != node:
            parent[node] = parent[parent[node]]
            node = parent[node]
        return node

    def union(first: int, second: int) -> None:
        root_first, root_second = find(first), find(second)
        if root_first != root_second:
            parent[root_first] = root_second

    owners: dict[int, int] = {}
    for index, value in enumerate(nums):
        remaining = value
        while remaining > 1:
            prime = smallest_prime[remaining]
            while remaining % prime == 0:
                remaining //= prime
            if prime in owners:
                union(index, owners[prime])
            else:
                owners[prime] = index

    root = find(0)
    return all(find(index) == root for index in range(size))


# ── 2097 统计整数数目 ─────────────────────────────────────────────


def count_of_integers(
    num1: str, num2: str, min_sum: int, max_sum: int
) -> int:
    mod = 10**9 + 7

    def count_at_most(text: str) -> int:
        digits = [int(character) for character in text]
        length = len(digits)

        @lru_cache(maxsize=None)
        def dfs(position: int, total: int, tight: bool) -> int:
            if total > max_sum:
                return 0
            if position == length:
                return 1 if total >= min_sum else 0
            limit = digits[position] if tight else 9
            result = 0
            for digit in range(limit + 1):
                result += dfs(
                    position + 1,
                    total + digit,
                    tight and digit == limit,
                )
            return result % mod

        return dfs(0, 0, True)

    lower = str(int(num1) - 1)
    return (count_at_most(num2) - count_at_most(lower)) % mod


# ── 2098 收集树中金币 ─────────────────────────────────────────────


def collect_coins_in_tree(coins: list[int], edges: list[list[int]]) -> int:
    size = len(coins)
    if all(coin == 0 for coin in coins):
        return 0
    graph: list[list[int]] = [[] for _ in range(size)]
    degree = [0] * size
    for u, v in edges:
        graph[u].append(v)
        graph[v].append(u)
        degree[u] += 1
        degree[v] += 1
    removed = [False] * size

    # 先剪掉所有不含金币的叶子，得到包含全部金币的最小子树
    queue = deque(
        node
        for node in range(size)
        if degree[node] == 1 and coins[node] == 0
    )
    while queue:
        node = queue.popleft()
        if removed[node]:
            continue
        removed[node] = True
        for neighbour in graph[node]:
            if removed[neighbour]:
                continue
            degree[neighbour] -= 1
            if degree[neighbour] == 1 and coins[neighbour] == 0:
                queue.append(neighbour)

    # 距离 2 内即可收集，最外层两层不需要真正走入
    for _ in range(2):
        leaves = [
            node
            for node in range(size)
            if not removed[node] and degree[node] <= 1
        ]
        if not leaves:
            break
        for node in leaves:
            if removed[node]:
                continue
            removed[node] = True
            for neighbour in graph[node]:
                if not removed[neighbour]:
                    degree[neighbour] -= 1

    remaining_edges = sum(
        1 for u, v in edges if not removed[u] and not removed[v]
    )
    return 2 * remaining_edges


# ── 2099 长度可被 K 整除的最大子数组和 ───────────────────────────


def max_subarray_sum_divisible_by_k(nums: list[int], k: int) -> int:
    infinity = float("inf")
    best_prefix = [infinity] * k
    best_prefix[0] = 0
    prefix = 0
    answer = float("-inf")
    for index, value in enumerate(nums):
        prefix += value
        residue = (index + 1) % k
        if best_prefix[residue] != infinity:
            answer = max(answer, prefix - best_prefix[residue])
        if prefix < best_prefix[residue]:
            best_prefix[residue] = prefix
    return int(answer) if answer != float("-inf") else 0


PROBLEMS = [
    make(
        pid=2080,
        title="直线上最多的点数",
        tags=["几何", "哈希表", "数学"],
        description="""给定平面上的整数点数组 points，其中 points[i] = [xi, yi]
求最多有多少个点位于同一条直线上
所有点的坐标互不相同""",
        function="maxPoints",
        params=[("points", "int[][]")],
        returns="int",
        solver=max_points_on_a_line,
        public=[
            [[[1, 1], [2, 2], [3, 3]]],
            [[[1, 1], [3, 2], [5, 3], [4, 1], [2, 3], [1, 4]]],
            [[[0, 0]]],
            [[[0, 0], [1, 1]]],
        ],
        hidden=[
            [[[0, 0], [1, 1], [2, 2], [3, 3], [4, 4]]],
            [[[0, 0], [1, 1], [0, 1], [1, 0]]],
            [[[1, 1], [1, 2], [1, 3], [1, 4]]],
            [[[2, 3], [3, 3], [5, 3], [2, 1]]],
            [[[-1, -1], [0, 0], [1, 1], [2, 2], [3, 4]]],
            [[[0, 0], [1, 2], [2, 4], [3, 6], [4, 8], [5, 11]]],
        ],
    ),
    make(
        pid=2081,
        title="给表达式添加运算符",
        tags=["字符串", "回溯", "数学"],
        description="""给定只包含数字的字符串 num 和整数 target
在 num 的数字之间插入 +、- 或 *，也可以选择不插入，构造表达式
表达式按通常的运算优先级计算，乘号优先于加减
数字的顺序不能改变，且不能有前导零（数字 0 本身除外）
返回所有计算结果等于 target 的表达式，按字典序升序排列""",
        function="addOperators",
        params=[("num", "string"), ("target", "int")],
        returns="string[]",
        solver=add_operators,
        public=[
            ["123", 6],
            ["232", 8],
            ["105", 5],
            ["0", 0],
        ],
        hidden=[
            ["00", 0],
            ["345", 15],
            ["1234", 10],
            ["999", 81],
            ["2147483647", 2147483647],
            ["100", 100],
        ],
    ),
    make(
        pid=2082,
        title="最小好进制",
        tags=["数学", "二分查找"],
        description="""给定一个十进制正整数字符串 n
若整数 k（k >= 2）满足 n 在 k 进制下的表示全部由数字 1 组成，则称 k 是一个好进制
返回最小的好进制 k，以十进制字符串形式返回
保证答案存在""",
        function="smallestGoodBase",
        params=[("n", "string")],
        returns="string",
        solver=smallest_good_base,
        public=[
            ["13"],
            ["4681"],
            ["100"],
        ],
        hidden=[
            ["3"],
            ["7"],
            ["15"],
            ["31"],
            ["8191"],
            ["1000000000000000000"],
        ],
    ),
    make(
        pid=2083,
        title="解码方法 II",
        tags=["字符串", "动态规划"],
        description="""给定由数字和字符 * 组成的字符串 s，字符 * 可以代表 1 到 9 中的任意一个数字
将 s 解码为字母序列，编码规则为 A -> 1，B -> 2，……，Z -> 26
返回解码方法的总数，答案对 10^9 + 7 取模
数字 0 不能单独解码，也不能作为两位数的首位""",
        function="numDecodingsII",
        params=[("s", "string")],
        returns="int",
        solver=num_decodings_two,
        public=[
            ["*"],
            ["1*"],
            ["2*"],
            ["**"],
        ],
        hidden=[
            ["0"],
            ["1"],
            ["10"],
            ["*1"],
            ["06"],
            ["***"],
            ["1*1"],
        ],
    ),
    make(
        pid=2084,
        title="中心对称数 III",
        tags=["数学", "字符串", "回溯"],
        description="""中心对称数是指旋转 180 度后仍与自身相同的数
旋转后 6 变成 9，9 变成 6，0、1、8 保持不变
给定两个非负整数 low 和 high（以十进制字符串给出）
返回区间 [low, high] 内中心对称数的个数
多位数不能有前导零""",
        function="strobogrammaticInRange",
        params=[("low", "string"), ("high", "string")],
        returns="int",
        solver=strobogrammatic_in_range,
        public=[
            ["50", "100"],
            ["0", "0"],
            ["1", "100"],
        ],
        hidden=[
            ["0", "1000"],
            ["100", "10000"],
            ["69", "96"],
            ["1000", "10000"],
            ["0", "100000"],
            ["10000", "1000000"],
        ],
    ),
    make(
        pid=2085,
        title="冗余连接 II",
        tags=["图", "并查集"],
        description="""给定有向边数组 edges，表示一棵以某个节点为根的树，额外多加了一条有向边
先前的树中每个节点最多只有一个父节点，图中不存在自环
返回一条可以删除的边，使得剩余部分是一棵有根树
如果有多条边满足条件，返回在输入中最后出现的那条
返回值形如 [u, v]""",
        function="findRedundantDirectedConnection",
        params=[("edges", "int[][]")],
        returns="int[]",
        solver=redundant_connection_two,
        public=[
            [[[1, 2], [1, 3], [2, 3]]],
            [[[1, 2], [2, 3], [3, 4], [4, 1], [1, 5]]],
            [[[1, 2], [2, 3], [3, 1]]],
        ],
        hidden=[
            [[[2, 1], [3, 1], [2, 3]]],
            [[[1, 2], [2, 3], [3, 1], [1, 3]]],
            [[[4, 2], [2, 3], [3, 1], [1, 4], [1, 5]]],
            [[[1, 2], [2, 3], [3, 4], [4, 5], [5, 2]]],
            [[[3, 1], [1, 2], [2, 3], [3, 4]]],
            [[[1, 2], [1, 3], [3, 4], [4, 1]]],
        ],
    ),
    make(
        pid=2086,
        title="贴纸拼词",
        tags=["位运算", "动态规划", "记忆化搜索"],
        description="""给定字符串数组 stickers 和一个字符串 target
每次可以选择一张贴纸，剪下其中的若干字符拼到答案中，每种字符最多使用贴纸中出现的次数
每张贴纸可以重复使用无限次
返回拼出 target 所需的最少贴纸数量；无法拼出返回 -1""",
        function="minStickers",
        params=[("stickers", "string[]"), ("target", "string")],
        returns="int",
        solver=stickers_to_spell_word,
        public=[
            [["with", "example", "science"], "thehat"],
            [["notice", "possible"], "basicbasic"],
            [["a", "b", "c"], "abc"],
            [["a"], "aaa"],
        ],
        hidden=[
            [["ab", "bc", "cd"], "abcd"],
            [["a", "b"], "ab"],
            [["control", "heart", "interest", "stream", "sentence", "soil"], "ocean"],
            [["x"], "y"],
            [["these", "guess", "about", "random", "worst", "time"], "thequickbrownfox"],
            [["aa"], "aaa"],
        ],
    ),
    make(
        pid=2087,
        title="找出第 K 小的数对距离",
        tags=["数组", "二分查找", "双指针"],
        description="""给定整数数组 nums 和整数 k
数对距离定义为两个下标对应元素的绝对差
返回所有下标对 (i, j)（i < j）中第 k 小的数对距离
距离按非递减顺序计第 k 个""",
        function="smallestDistancePair",
        params=[("nums", "int[]"), ("k", "int")],
        returns="int",
        solver=kth_smallest_pair_distance,
        public=[
            [[1, 3, 1], 2],
            [[1, 1, 1], 2],
            [[1, 6, 1], 3],
        ],
        hidden=[
            [[1, 2, 3, 4], 1],
            [[1, 2, 3, 4], 6],
            [[1, 1000], 1],
            [[9, 8, 7, 6, 5], 4],
            [[1, 2, 3, 4, 5, 6], 10],
            [[2, 2, 2, 2], 3],
        ],
    ),
    make(
        pid=2088,
        title="查找集群内的关键连接",
        tags=["图", "深度优先搜索", "割边"],
        description="""给定 n 个节点和无向边数组 connections，节点编号为 0 到 n-1，图连通
若删除某条边会使图不再连通，则称该边为关键连接
返回所有关键连接，每条边用 [u, v] 表示且 u < v
结果按字典序升序排列""",
        function="criticalConnections",
        params=[("n", "int"), ("connections", "int[][]")],
        returns="int[][]",
        solver=critical_connections,
        public=[
            [4, [[0, 1], [1, 2], [2, 0], [1, 3]]],
            [2, [[0, 1]]],
            [3, [[0, 1], [1, 2]]],
        ],
        hidden=[
            [5, [[0, 1], [1, 2], [2, 0], [1, 3], [3, 4]]],
            [4, [[0, 1], [1, 2], [2, 3], [3, 0]]],
            [3, [[0, 1], [1, 2], [2, 0]]],
            [6, [[0, 1], [1, 2], [2, 3], [3, 4], [4, 5]]],
            [5, [[0, 1], [1, 2], [2, 3], [3, 0], [0, 4]]],
            [4, [[0, 1], [0, 2], [0, 3]]],
        ],
    ),
    make(
        pid=2089,
        title="滑动谜题",
        tags=["广度优先搜索", "数组", "矩阵"],
        description="""给定一个 2 x 3 的滑动拼图 board，包含 0 到 5 的一个排列，0 表示空格
每次操作可以将 0 与上下左右相邻的数字交换
返回将拼图还原为 [[1, 2, 3], [4, 5, 0]] 的最少操作次数；无法还原返回 -1""",
        function="slidingPuzzle",
        params=[("board", "int[][]")],
        returns="int",
        solver=sliding_puzzle,
        public=[
            [[[1, 2, 3], [4, 0, 5]]],
            [[[1, 2, 3], [5, 4, 0]]],
            [[[4, 1, 2], [5, 0, 3]]],
            [[[1, 2, 3], [4, 5, 0]]],
        ],
        hidden=[
            [[[3, 2, 4], [1, 5, 0]]],
            [[[0, 1, 2], [3, 4, 5]]],
            [[[2, 4, 3], [1, 0, 5]]],
            [[[5, 4, 3], [2, 1, 0]]],
            [[[1, 5, 2], [4, 0, 3]]],
            [[[0, 5, 4], [3, 2, 1]]],
        ],
    ),
    make(
        pid=2090,
        title="到达终点",
        tags=["数学", "欧几里得算法"],
        description="""给定四个正整数 sx、sy、tx、ty
从点 (sx, sy) 出发，每次操作可以把 (x, y) 变成 (x + y, y) 或 (x, y + x)
返回能否恰好到达点 (tx, ty)""",
        function="reachingPoints",
        params=[("sx", "int"), ("sy", "int"), ("tx", "int"), ("ty", "int")],
        returns="bool",
        solver=reaching_points,
        public=[
            [1, 1, 3, 5],
            [1, 1, 2, 2],
            [1, 1, 1, 1],
            [1, 1, 1, 1000000000],
        ],
        hidden=[
            [1, 1, 1000000000, 1],
            [1, 1, 3, 4],
            [1, 2, 3, 4],
            [2, 3, 5, 8],
            [35, 13, 455955547, 420098884],
            [1, 1, 6, 3],
        ],
    ),
    make(
        pid=2091,
        title="第 K 个最小的素数分数",
        tags=["数组", "堆", "数学"],
        description="""给定按升序排列且元素互不相同的正整数数组 arr，其中 arr[0] = 1，以及整数 k
考虑所有满足 0 <= i < j < len(arr) 的分数 arr[i] / arr[j]
返回第 k 小的分数，用 [arr[i], arr[j]] 表示
分数按数值升序排列；数值相同时按分子升序，再按分母升序""",
        function="kthSmallestPrimeFraction",
        params=[("arr", "int[]"), ("k", "int")],
        returns="int[]",
        solver=kth_smallest_prime_fraction,
        public=[
            [[1, 2, 3, 4], 1],
            [[1, 2, 3, 4], 3],
            [[1, 2, 3, 4], 4],
        ],
        hidden=[
            [[1, 2], 1],
            [[1, 7, 23], 2],
            [[1, 3, 5], 3],
            [[1, 2, 3, 4, 5], 7],
            [[1, 11, 13, 17], 6],
            [[1, 2, 3, 4, 5, 6], 10],
        ],
    ),
    make(
        pid=2092,
        title="黑板异或游戏",
        tags=["位运算", "数学", "博弈"],
        description="""给定整数数组 nums两名玩家轮流从黑板上擦去恰好一个数，先手为 Alice
若擦去一个数后，黑板上剩余所有数的异或和变为 0，则擦去该数的玩家立即失败
若某位玩家在回合开始时黑板上所有数的异或和为 0，则该玩家立即获胜
假设双方都采取最优策略，返回先手 Alice 是否必胜""",
        function="xorGame",
        params=[("nums", "int[]")],
        returns="bool",
        solver=xor_game,
        public=[
            [[1, 1, 2]],
            [[0, 1]],
            [[1, 2, 3]],
            [[1, 2]],
        ],
        hidden=[
            [[0]],
            [[1, 2, 4, 8]],
            [[3, 6, 5]],
            [[1, 1, 1, 1, 1]],
            [[7, 8, 9, 10]],
            [[0, 0, 1]],
        ],
    ),
    make(
        pid=2093,
        title="矩形面积 II",
        tags=["数组", "扫描线", "线段树"],
        description="""给定二维整数数组 rectangles
rectangles[i] = [x1, y1, x2, y2] 表示一个与坐标轴平行的矩形
返回这些矩形覆盖的总面积，重叠部分只计算一次
答案对 10^9 + 7 取模""",
        function="rectangleArea",
        params=[("rectangles", "int[][]")],
        returns="int",
        solver=rectangle_area,
        public=[
            [[[0, 0, 2, 2], [1, 0, 2, 3], [1, 0, 3, 1]]],
            [[[0, 0, 1000000000, 1000000000]]],
            [[[0, 0, 1, 1]]],
        ],
        hidden=[
            [[[0, 0, 2, 2], [1, 1, 3, 3]]],
            [[[0, 0, 2, 2], [2, 0, 3, 2]]],
            [[[0, 0, 1, 3], [0, 1, 1, 4], [0, 2, 1, 5]]],
            [[[0, 0, 3, 3], [1, 1, 2, 2]]],
            [[[0, 0, 1, 1], [1, 1, 2, 2], [2, 2, 3, 3]]],
            [[[0, 0, 5, 2], [1, 1, 4, 3], [2, 0, 3, 4]]],
        ],
    ),
    make(
        pid=2094,
        title="在网格图中访问一个格子的最少时间",
        tags=["图", "最短路", "堆", "矩阵"],
        description="""给定 m x n 的网格图 grid
从左上角 (0, 0) 出发，时间为 0，每秒必须移动到上下左右相邻的格子，不能停留
只有在时间大于等于 grid[r][c] 时才能进入格子 (r, c)
返回到达右下角 (m-1, n-1) 的最早时间；无法到达返回 -1
保证 grid[0][0] = 0""",
        function="minimumTime",
        params=[("grid", "int[][]")],
        returns="int",
        solver=minimum_time_to_visit_cell,
        public=[
            [[[0, 1, 3, 2], [5, 1, 2, 5], [4, 3, 8, 6]]],
            [[[0, 2, 4], [3, 2, 1], [1, 0, 4]]],
            [[[0, 1], [1, 2]]],
        ],
        hidden=[
            [[[0]]],
            [[[0, 3], [1, 4]]],
            [[[0, 1, 100], [1, 2, 3], [2, 3, 4]]],
            [[[0, 5], [5, 6]]],
            [[[0, 1, 2], [1, 2, 3], [2, 3, 4]]],
            [[[0, 10, 10], [10, 10, 10], [10, 10, 0]]],
        ],
    ),
    make(
        pid=2095,
        title="图中的最短环",
        tags=["图", "广度优先搜索"],
        description="""给定一个包含 n 个节点的无向图，节点编号为 0 到 n-1
边数组 edges 中 edges[i] = [u, v] 表示一条无向边，图中没有自环和重边
返回图中最短环的长度；如果不存在环，返回 -1
环是指起点和终点相同且至少包含 3 条边的路径""",
        function="findShortestCycle",
        params=[("n", "int"), ("edges", "int[][]")],
        returns="int",
        solver=shortest_cycle,
        public=[
            [3, [[0, 1], [1, 2], [2, 0]]],
            [3, [[0, 1], [1, 2]]],
            [5, [[0, 1], [0, 2], [1, 3], [2, 3], [3, 4]]],
        ],
        hidden=[
            [4, [[0, 1], [1, 2], [2, 3], [3, 0]]],
            [6, [[0, 1], [1, 2], [2, 0], [3, 4], [4, 5], [5, 3]]],
            [1, []],
            [2, [[0, 1]]],
            [7, [[0, 1], [1, 2], [2, 3], [3, 4], [4, 5], [5, 6], [6, 0]]],
            [5, [[0, 1], [1, 2], [2, 0], [3, 4]]],
        ],
    ),
    make(
        pid=2096,
        title="最大公约数遍历",
        tags=["数组", "数学", "并查集", "数论"],
        description="""给定整数数组 nums
节点 i 与节点 j 之间存在边当且仅当 gcd(nums[i], nums[j]) > 1
返回是否存在一条路径，可以从任意节点出发并经过所有节点
路径中可以多次访问节点""",
        function="canTraverseAllPairs",
        params=[("nums", "int[]")],
        returns="bool",
        solver=can_traverse_all_pairs,
        public=[
            [[2, 3, 6]],
            [[3, 9, 5]],
            [[4, 3, 12, 8]],
            [[2, 3, 5]],
        ],
        hidden=[
            [[1]],
            [[1, 1]],
            [[6, 10, 15]],
            [[2, 4, 8, 16]],
            [[7, 11, 13, 17]],
            [[6, 35, 10, 21]],
        ],
    ),
    make(
        pid=2097,
        title="统计整数数目",
        tags=["数学", "动态规划", "数位动态规划"],
        description="""给定两个正整数 num1 和 num2（以十进制字符串给出），以及整数 min_sum 和 max_sum
返回区间 [num1, num2] 内，各位数字之和位于 [min_sum, max_sum] 的整数个数
答案对 10^9 + 7 取模""",
        function="countOfIntegers",
        params=[
            ("num1", "string"),
            ("num2", "string"),
            ("min_sum", "int"),
            ("max_sum", "int"),
        ],
        returns="int",
        solver=count_of_integers,
        public=[
            ["1", "12", 1, 8],
            ["1", "5", 1, 5],
            ["10", "20", 2, 3],
            ["1", "100", 1, 8],
        ],
        hidden=[
            ["1", "1", 1, 1],
            ["1", "1", 2, 2],
            ["100", "200", 1, 5],
            ["1", "1000", 10, 12],
            ["999", "1001", 27, 27],
            ["1", "1000000", 1, 10],
        ],
    ),
    make(
        pid=2098,
        title="收集树中金币",
        tags=["树", "广度优先搜索", "拓扑排序"],
        description="""给定一棵包含 n 个节点的无向树，节点编号为 0 到 n-1
边数组为 edges，长度为 n-1
数组 coins 中 coins[i] 为 1 表示节点 i 有一枚金币，为 0 表示没有
初始时可以选择任意节点作为起点
每次操作可以收集距离当前节点不超过 2 的所有金币，或移动到相邻节点
返回收集完所有金币并回到起点所需经过的最少边数
同一条边每经过一次都计入答案""",
        function="collectCoinsInTree",
        params=[("coins", "int[]"), ("edges", "int[][]")],
        returns="int",
        solver=collect_coins_in_tree,
        public=[
            [[1, 0, 0, 0, 0, 1], [[0, 1], [1, 2], [2, 3], [3, 4], [4, 5]]],
            [
                [0, 0, 0, 1, 1, 0, 0, 1],
                [[0, 1], [0, 2], [1, 3], [1, 4], [2, 5], [5, 6], [5, 7]],
            ],
            [[1], []],
            [[0, 1], [[0, 1]]],
        ],
        hidden=[
            [[1, 0, 1], [[0, 1], [1, 2]]],
            [[1, 0, 0, 0, 1], [[0, 1], [1, 2], [2, 3], [3, 4]]],
            [
                [1, 0, 0, 0, 0, 0, 1],
                [[0, 1], [1, 2], [2, 3], [3, 4], [4, 5], [5, 6]],
            ],
            [[0, 0, 0, 1], [[0, 1], [0, 2], [0, 3]]],
            [[0, 0, 1, 0], [[0, 1], [1, 2], [2, 3]]],
            [
                [1, 0, 0, 0, 0, 0, 0, 0, 1],
                [[0, 1], [1, 2], [2, 3], [3, 4], [4, 5], [5, 6], [6, 7], [7, 8]],
            ],
        ],
    ),
    make(
        pid=2099,
        title="长度可被 K 整除的最大子数组和",
        tags=["数组", "前缀和", "动态规划"],
        description="""给定整数数组 nums 和正整数 k
求一个非空连续子数组的最大和，要求子数组长度能被 k 整除
保证至少存在一个长度能被 k 整除的子数组""",
        function="maxSubarraySumDivisibleByK",
        params=[("nums", "int[]"), ("k", "int")],
        returns="int",
        solver=max_subarray_sum_divisible_by_k,
        public=[
            [[1, 2], 1],
            [[-1, -2, -3, -4, -5], 4],
            [[5, -2, 3, 1], 2],
        ],
        hidden=[
            [[1, 2, 3, 4, 5], 5],
            [[-5, -3, -1], 2],
            [[2, -1, 2], 3],
            [[1, -2, 3, -4, 5, -6], 2],
            [[10, -10, 10, -10], 4],
            [[-1, -1, -1, -1], 3],
        ],
    ),
]
