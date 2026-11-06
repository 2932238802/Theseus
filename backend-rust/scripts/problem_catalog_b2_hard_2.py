"""1680-1699：批量第二批困难题（20 道）。"""

from __future__ import annotations

import bisect
import heapq
from collections import Counter, deque
from functools import partial
from math import gcd

from problem_seed_common import make_problem

make = partial(make_problem, difficulty="hard")


# ── 1680 石子游戏 IV ────────────────────────────────────────────────


def stone_game_iv(n: int) -> bool:
    win = [False] * (n + 1)
    for stones in range(1, n + 1):
        square = 1
        while square * square <= stones:
            if not win[stones - square * square]:
                win[stones] = True
                break
            square += 1
    return win[n]


# ── 1681 删除回文子数组 ─────────────────────────────────────────────


def remove_palindromic_subarrays(arr: list[int]) -> int:
    size = len(arr)
    if size <= 1:
        return size
    dp = [[0] * size for _ in range(size)]
    for index in range(size):
        dp[index][index] = 1
    for length in range(2, size + 1):
        for left in range(size - length + 1):
            right = left + length - 1
            if length == 2:
                dp[left][right] = 1 if arr[left] == arr[right] else 2
                continue
            best = dp[left + 1][right - 1] if arr[left] == arr[right] else size + 1
            for middle in range(left, right):
                candidate = dp[left][middle] + dp[middle + 1][right]
                if candidate < best:
                    best = candidate
            dp[left][right] = best
    return dp[0][size - 1]


# ── 1682 转化为全零矩阵的最少反转次数 ───────────────────────────────


def min_flips_zero_matrix(mat: list[list[int]]) -> int:
    rows, columns = len(mat), len(mat[0])
    start = 0
    for row in range(rows):
        for column in range(columns):
            if mat[row][column]:
                start |= 1 << (row * columns + column)
    if start == 0:
        return 0

    flip_masks: list[int] = []
    for row in range(rows):
        for column in range(columns):
            mask = 0
            for delta_row, delta_column in ((0, 0), (1, 0), (-1, 0), (0, 1), (0, -1)):
                next_row = row + delta_row
                next_column = column + delta_column
                if 0 <= next_row < rows and 0 <= next_column < columns:
                    mask |= 1 << (next_row * columns + next_column)
            flip_masks.append(mask)

    distance = {start: 0}
    queue = deque([start])
    while queue:
        state = queue.popleft()
        steps = distance[state]
        for mask in flip_masks:
            nxt = state ^ mask
            if nxt == 0:
                return steps + 1
            if nxt not in distance:
                distance[nxt] = steps + 1
                queue.append(nxt)
    return -1


# ── 1683 多次求和构造目标数组 ───────────────────────────────────────


def is_possible_target(target: list[int]) -> bool:
    total = sum(target)
    heap = [-value for value in target]
    heapq.heapify(heap)
    while heap:
        largest = -heapq.heappop(heap)
        if largest == 1:
            return True
        rest = total - largest
        if rest <= 0 or largest <= rest:
            return False
        largest = (largest - 1) % rest + 1
        total = rest + largest
        heapq.heappush(heap, -largest)
    return True


# ── 1684 使网格图至少有一条有效路径的最小代价 ───────────────────────


def min_cost_valid_path(grid: list[list[int]]) -> int:
    rows, columns = len(grid), len(grid[0])
    directions = {1: (0, 1), 2: (0, -1), 3: (1, 0), 4: (-1, 0)}
    infinity = 10**9
    distance = [[infinity] * columns for _ in range(rows)]
    distance[0][0] = 0
    queue = deque([(0, 0)])
    while queue:
        row, column = queue.popleft()
        cost = distance[row][column]
        for direction, (delta_row, delta_column) in directions.items():
            next_row = row + delta_row
            next_column = column + delta_column
            if not (0 <= next_row < rows and 0 <= next_column < columns):
                continue
            weight = 0 if grid[row][column] == direction else 1
            if cost + weight < distance[next_row][next_column]:
                distance[next_row][next_column] = cost + weight
                if weight == 0:
                    queue.appendleft((next_row, next_column))
                else:
                    queue.append((next_row, next_column))
    return distance[rows - 1][columns - 1]


# ── 1685 有序矩阵中的第 k 个最小数组和 ──────────────────────────────


def kth_smallest_matrix_sum(mat: list[list[int]], k: int) -> int:
    sums = [0]
    for row in mat:
        sums = sorted(a + b for a in sums for b in row)[:k]
    return sums[k - 1]


# ── 1686 切披萨的方案数 ─────────────────────────────────────────────


def ways_cut_pizza(pizza: list[str], k: int) -> int:
    modulo = 10**9 + 7
    rows, columns = len(pizza), len(pizza[0])
    apples = [[0] * (columns + 1) for _ in range(rows + 1)]
    for row in range(rows - 1, -1, -1):
        for column in range(columns - 1, -1, -1):
            apples[row][column] = (
                (1 if pizza[row][column] == "A" else 0)
                + apples[row + 1][column]
                + apples[row][column + 1]
                - apples[row + 1][column + 1]
            )

    def count_apples(top: int, left: int, bottom: int, right: int) -> int:
        return (
            apples[top][left]
            - apples[bottom][left]
            - apples[top][right]
            + apples[bottom][right]
        )

    dp = [[[0] * (k + 1) for _ in range(columns)] for _ in range(rows)]
    for row in range(rows):
        for column in range(columns):
            if count_apples(row, column, rows, columns) > 0:
                dp[row][column][1] = 1

    for pieces in range(2, k + 1):
        for row in range(rows - 1, -1, -1):
            for column in range(columns - 1, -1, -1):
                total = 0
                for next_row in range(row + 1, rows):
                    if count_apples(row, column, next_row, columns) > 0:
                        total += dp[next_row][column][pieces - 1]
                for next_column in range(column + 1, columns):
                    if count_apples(row, column, rows, next_column) > 0:
                        total += dp[row][next_column][pieces - 1]
                dp[row][column][pieces] = total % modulo
    return dp[0][0][k]


# ── 1687 摘樱桃 II ──────────────────────────────────────────────────


def cherry_pickup_ii(grid: list[list[int]]) -> int:
    rows, columns = len(grid), len(grid[0])
    negative = -10**9
    dp = [[negative] * columns for _ in range(columns)]
    dp[0][columns - 1] = grid[0][0] + (grid[0][columns - 1] if columns > 1 else 0)
    for row in range(1, rows):
        next_dp = [[negative] * columns for _ in range(columns)]
        for first in range(columns):
            for second in range(columns):
                value = dp[first][second]
                if value == negative:
                    continue
                for delta_first in (-1, 0, 1):
                    next_first = first + delta_first
                    if not 0 <= next_first < columns:
                        continue
                    for delta_second in (-1, 0, 1):
                        next_second = second + delta_second
                        if not 0 <= next_second < columns:
                            continue
                        gain = grid[row][next_first]
                        if next_second != next_first:
                            gain += grid[row][next_second]
                        candidate = value + gain
                        if candidate > next_dp[next_first][next_second]:
                            next_dp[next_first][next_second] = candidate
        dp = next_dp
    return max(max(row) for row in dp)


# ── 1688 保证图可完全遍历 ───────────────────────────────────────────


class _DSU:
    def __init__(self, size: int):
        self.parent = list(range(size + 1))
        self.rank = [0] * (size + 1)

    def find(self, value: int) -> int:
        while self.parent[value] != value:
            self.parent[value] = self.parent[self.parent[value]]
            value = self.parent[value]
        return value

    def union(self, left: int, right: int) -> bool:
        root_left, root_right = self.find(left), self.find(right)
        if root_left == root_right:
            return False
        if self.rank[root_left] < self.rank[root_right]:
            root_left, root_right = root_right, root_left
        self.parent[root_right] = root_left
        if self.rank[root_left] == self.rank[root_right]:
            self.rank[root_left] += 1
        return True


def max_num_edges_to_remove(n: int, edges: list[list[int]]) -> int:
    common = _DSU(n)
    kept_both: list[tuple[int, int]] = []
    used = 0
    for edge_type, left, right in edges:
        if edge_type == 3 and common.union(left, right):
            kept_both.append((left, right))
            used += 1

    alice = _DSU(n)
    bob = _DSU(n)
    for left, right in kept_both:
        alice.union(left, right)
        bob.union(left, right)

    for edge_type, left, right in edges:
        if edge_type == 1 and alice.union(left, right):
            used += 1
        elif edge_type == 2 and bob.union(left, right):
            used += 1

    if len({alice.find(node) for node in range(1, n + 1)}) > 1:
        return -1
    if len({bob.find(node) for node in range(1, n + 1)}) > 1:
        return -1
    return len(edges) - used


# ── 1689 最多可达成的换楼请求数目 ───────────────────────────────────


def maximum_requests(n: int, requests: list[list[int]]) -> int:
    total = len(requests)
    best = 0
    for mask in range(1 << total):
        count = mask.bit_count()
        if count <= best:
            continue
        balance = [0] * n
        for index, (source, destination) in enumerate(requests):
            if mask >> index & 1:
                balance[source] += 1
                balance[destination] -= 1
        if all(value == 0 for value in balance):
            best = count
    return best


# ── 1690 通过给定词典构造目标字符串的方案数 ─────────────────────────


def num_ways_to_form_target(words: list[str], target: str) -> int:
    modulo = 10**9 + 7
    columns = len(words[0])
    length = len(target)
    dp = [0] * (length + 1)
    dp[0] = 1
    for column in range(columns):
        counts = [0] * 26
        for word in words:
            counts[ord(word[column]) - ord("a")] += 1
        for position in range(length, 0, -1):
            ways = counts[ord(target[position - 1]) - ord("a")]
            if ways:
                dp[position] = (dp[position] + dp[position - 1] * ways) % modulo
    return dp[length]


# ── 1691 检查边长度限制的路径是否存在 ───────────────────────────────


def distance_limited_paths_exist(
    n: int, edge_list: list[list[int]], queries: list[list[int]]
) -> list[bool]:
    parent = list(range(n))
    size = [1] * n

    def find(value: int) -> int:
        while parent[value] != value:
            parent[value] = parent[parent[value]]
            value = parent[value]
        return value

    def union(left: int, right: int) -> None:
        root_left, root_right = find(left), find(right)
        if root_left == root_right:
            return
        if size[root_left] < size[root_right]:
            root_left, root_right = root_right, root_left
        parent[root_right] = root_left
        size[root_left] += size[root_right]

    ordered_edges = sorted(edge_list, key=lambda item: item[2])
    order = sorted(range(len(queries)), key=lambda index: queries[index][2])
    answer = [False] * len(queries)
    edge_index = 0
    for query_index in order:
        source, destination, limit = queries[query_index]
        while (
            edge_index < len(ordered_edges)
            and ordered_edges[edge_index][2] < limit
        ):
            union(ordered_edges[edge_index][0], ordered_edges[edge_index][1])
            edge_index += 1
        answer[query_index] = find(source) == find(destination)
    return answer


# ── 1692 完成所有工作的最短时间 ─────────────────────────────────────


def minimum_time_required(jobs: list[int], k: int) -> int:
    size = len(jobs)

    def feasible(limit: int) -> bool:
        infinity = (10**9, 10**9)
        dp = [infinity] * (1 << size)
        dp[0] = (1, 0)
        for mask in range(1 << size):
            workers, load = dp[mask]
            if workers > k:
                continue
            for index in range(size):
                if mask >> index & 1:
                    continue
                if load + jobs[index] <= limit:
                    candidate = (workers, load + jobs[index])
                else:
                    candidate = (workers + 1, jobs[index])
                next_mask = mask | 1 << index
                if candidate < dp[next_mask]:
                    dp[next_mask] = candidate
        return dp[-1][0] <= k

    low, high = max(jobs), sum(jobs)
    while low < high:
        middle = (low + high) // 2
        if feasible(middle):
            high = middle
        else:
            low = middle + 1
    return low


# ── 1693 最多可以参加的会议数目 II ──────────────────────────────────


def max_value_events(events: list[list[int]], k: int) -> int:
    ordered = sorted(events, key=lambda item: item[1])
    ends = [event[1] for event in ordered]
    count = len(ordered)
    dp = [[0] * (k + 1) for _ in range(count + 1)]
    for index in range(1, count + 1):
        start, _end, value = ordered[index - 1]
        previous = bisect.bisect_left(ends, start)
        for chosen in range(1, k + 1):
            dp[index][chosen] = max(
                dp[index - 1][chosen],
                value + dp[previous][chosen - 1],
            )
    return dp[count][k]


# ── 1694 N 次操作后的最大分数 ───────────────────────────────────────


def max_score_operations(nums: list[int]) -> int:
    size = len(nums)
    full = (1 << size) - 1
    dp = [-1] * (1 << size)
    dp[0] = 0
    for mask in range(1 << size):
        current = dp[mask]
        if current < 0:
            continue
        used = mask.bit_count()
        if used % 2:
            continue
        operation = used // 2 + 1
        for first in range(size):
            if mask >> first & 1:
                continue
            for second in range(first + 1, size):
                if mask >> second & 1:
                    continue
                next_mask = mask | 1 << first | 1 << second
                candidate = current + operation * gcd(nums[first], nums[second])
                if candidate > dp[next_mask]:
                    dp[next_mask] = candidate
    return dp[full]


# ── 1695 有向图中最大颜色值 ─────────────────────────────────────────


def largest_color_value(colors: str, edges: list[list[int]]) -> int:
    count = len(colors)
    adjacency = [[] for _ in range(count)]
    indegree = [0] * count
    for source, destination in edges:
        adjacency[source].append(destination)
        indegree[destination] += 1

    dp = [[0] * 26 for _ in range(count)]
    queue = deque(node for node in range(count) if indegree[node] == 0)
    processed = 0
    while queue:
        node = queue.popleft()
        processed += 1
        dp[node][ord(colors[node]) - ord("a")] += 1
        for neighbor in adjacency[node]:
            for color in range(26):
                if dp[node][color] > dp[neighbor][color]:
                    dp[neighbor][color] = dp[node][color]
            indegree[neighbor] -= 1
            if indegree[neighbor] == 0:
                queue.append(neighbor)

    if processed < count:
        return -1
    return max(max(values) for values in dp)


# ── 1696 从子集的和还原数组 ─────────────────────────────────────────


def find_array_from_sums(sums: list[int], n: int) -> list[int]:
    counts = Counter(sums)
    answer: list[int] = []
    for _ in range(n):
        value = next(
            (key for key in sorted(counts) if key > 0 and counts[key] > 0),
            None,
        )
        if value is None:
            answer.append(0)
            continue
        answer.append(value)
        remaining: Counter[int] = Counter()
        for key in sorted(counts):
            amount = counts[key] - remaining.get(key - value, 0)
            if amount > 0:
                remaining[key] = amount
        counts = remaining
    return sorted(answer)


# ── 1697 矩阵转换后的秩 ─────────────────────────────────────────────


def matrix_rank_transform(matrix: list[list[int]]) -> list[list[int]]:
    rows, columns = len(matrix), len(matrix[0])
    groups: dict[int, list[tuple[int, int]]] = {}
    for row in range(rows):
        for column in range(columns):
            groups.setdefault(matrix[row][column], []).append((row, column))

    row_max = [0] * rows
    column_max = [0] * columns
    answer = [[0] * columns for _ in range(rows)]
    for value in sorted(groups):
        updates: list[tuple[int, int, int]] = []
        for row, column in groups[value]:
            rank = max(row_max[row], column_max[column]) + 1
            updates.append((row, column, rank))
        for row, column, rank in updates:
            answer[row][column] = rank
            row_max[row] = max(row_max[row], rank)
            column_max[column] = max(column_max[column], rank)
    return answer


# ── 1698 恰有 K 根木棍可以看到的排列数目 ────────────────────────────


def k_sticks_visible(n: int, k: int) -> int:
    modulo = 10**9 + 7
    if k < 1 or k > n:
        return 0
    dp = [0] * (k + 1)
    dp[0] = 1
    for length in range(1, n + 1):
        next_dp = [0] * (k + 1)
        for visible in range(1, min(length, k) + 1):
            next_dp[visible] = (
                dp[visible - 1] + (length - 1) * dp[visible]
            ) % modulo
        dp = next_dp
    return dp[k]


# ── 1699 队列中可以看到的人数 ───────────────────────────────────────


def visible_people_count(heights: list[int]) -> int:
    size = len(heights)
    if size < 2:
        return 0

    next_greater = [size] * (size + 1)
    stack: list[int] = []
    for index in range(size - 1, -1, -1):
        while stack and heights[stack[-1]] <= heights[index]:
            stack.pop()
        next_greater[index] = stack[-1] if stack else size
        stack.append(index)

    levels = max(1, size.bit_length())
    jump = [next_greater]
    for _ in range(1, levels):
        previous = jump[-1]
        jump.append([previous[previous[index]] for index in range(size + 1)])

    total = 0
    for index in range(size):
        position = index + 1
        if position >= size:
            continue
        if heights[position] >= heights[index]:
            total += 1
            continue
        visible = 1
        current = position
        for level in range(levels - 1, -1, -1):
            candidate = jump[level][current]
            if candidate < size and heights[candidate] < heights[index]:
                visible += 1 << level
                current = candidate
        if jump[0][current] < size:
            visible += 1
        total += visible
    return total


PROBLEMS = [
    make(
        pid=1680,
        title="石子游戏 IV",
        tags=["数学", "动态规划", "博弈"],
        description="""给定 n 颗石子，两名玩家轮流取走若干颗。
每次只能取走完全平方数颗（1、4、9、16、……）。
取走最后一颗石子的玩家获胜。
返回先手是否必胜。""",
        function="stoneGameIV",
        params=[("n", "int")],
        returns="bool",
        solver=stone_game_iv,
        public=[[1], [2], [4], [7], [10]],
        hidden=[[3], [5], [6], [8], [9], [11], [15], [16]],
    ),
    make(
        pid=1681,
        title="删除回文子数组",
        tags=["数组", "动态规划", "区间动态规划"],
        description="""给定整数数组 arr。
一次操作可以删除一个连续的回文子数组，删除后剩余元素自动拼接。
返回删除整个数组所需的最少操作次数。""",
        function="removePalindromicSubarrays",
        params=[("arr", "int[]")],
        returns="int",
        solver=remove_palindromic_subarrays,
        public=[
            [[1, 2]],
            [[1, 3, 4, 1, 5]],
            [[1, 2, 1, 2]],
        ],
        hidden=[
            [[1]],
            [[1, 1]],
            [[1, 2, 3]],
            [[1, 2, 2, 1]],
            [[1, 2, 1]],
            [[1, 2, 1, 2, 1]],
            [[1, 3, 4, 1, 5, 3, 2]],
        ],
    ),
    make(
        pid=1682,
        title="转化为全零矩阵的最少反转次数",
        tags=["位运算", "广度优先搜索", "矩阵"],
        description="""给定 m x n 的 0/1 矩阵 mat。
每次操作选择一个格子，将该格子以及上下左右相邻格子的值翻转（0 变 1，1 变 0）。
返回使矩阵全为 0 的最少操作次数；无法做到返回 -1。""",
        function="minFlipsToZeroMatrix",
        params=[("mat", "int[][]")],
        returns="int",
        solver=min_flips_zero_matrix,
        public=[
            [[[0, 0], [0, 1]]],
            [[[0]]],
            [[[1]]],
        ],
        hidden=[
            [[[1, 1], [1, 0]]],
            [[[0, 1], [1, 0]]],
            [[[1, 0], [0, 1]]],
            [[[1, 1], [1, 1]]],
            [[[0, 1, 0], [1, 0, 1], [0, 1, 0]]],
            [[[1, 1, 1], [1, 1, 1], [1, 1, 1]]],
        ],
    ),
    make(
        pid=1683,
        title="多次求和构造目标数组",
        tags=["数组", "堆", "数学"],
        description="""初始时有一个长度为 n、元素全为 1 的数组。
每次操作可以选择一个下标，把它替换成当前数组所有元素之和。
给定目标数组 target，判断是否能从全 1 数组得到 target。""",
        function="isPossibleTarget",
        params=[("target", "int[]")],
        returns="bool",
        solver=is_possible_target,
        public=[
            [[9, 3, 5]],
            [[1, 1, 1]],
            [[1, 1, 1, 2]],
            [[8, 5]],
        ],
        hidden=[
            [[1]],
            [[2]],
            [[1, 1000000000]],
            [[2, 1]],
            [[1, 1, 2]],
            [[1, 1, 1, 1]],
            [[3, 7, 11]],
        ],
    ),
    make(
        pid=1684,
        title="使网格图至少有一条有效路径的最小代价",
        tags=["广度优先搜索", "图", "最短路"],
        description="""给定 m x n 网格 grid，grid[i][j] 表示该格子的箭头方向：
1 向右，2 向左，3 向下，4 向上。
从 (0,0) 出发，每一步必须沿当前格子的箭头移动。
如果希望移动到箭头以外的相邻格子，需要花费 1 的代价修改当前格子的箭头。
返回到达 (m-1,n-1) 的最小代价。""",
        function="minCostValidPath",
        params=[("grid", "int[][]")],
        returns="int",
        solver=min_cost_valid_path,
        public=[
            [[[1, 1, 1, 1], [2, 2, 2, 2], [1, 1, 1, 1], [2, 2, 2, 2]]],
            [[[1, 2], [4, 3]]],
            [[[2, 2], [2, 2]]],
        ],
        hidden=[
            [[[1]]],
            [[[2]]],
            [[[1, 2], [2, 1]]],
            [[[2, 1], [1, 2]]],
            [[[1, 2, 3, 4]]],
        ],
    ),
    make(
        pid=1685,
        title="有序矩阵中的第 k 个最小数组和",
        tags=["数组", "堆", "排序"],
        description="""给定 m 行矩阵 mat，每行都按非递减顺序排列。
从每一行恰好选一个数，得到一个长度为 m 的和。
返回所有可能的和中第 k 小的值（k 从 1 开始）。""",
        function="kthSmallestMatrixSum",
        params=[("mat", "int[][]"), ("k", "int")],
        returns="int",
        solver=kth_smallest_matrix_sum,
        public=[
            [[[1, 3, 11], [2, 4, 6]], 5],
            [[[1, 3, 11], [2, 4, 6]], 9],
            [[[1, 10, 10], [1, 4, 5], [2, 3, 6]], 7],
        ],
        hidden=[
            [[[1]], 1],
            [[[1, 2], [3, 4]], 2],
            [[[1, 2], [3, 4]], 4],
            [[[5, 9], [2, 7]], 3],
            [[[1, 1, 1], [1, 1, 1]], 5],
        ],
    ),
    make(
        pid=1686,
        title="切披萨的方案数",
        tags=["数组", "动态规划", "前缀和"],
        description="""给定字符串数组 pizza 表示披萨，'A' 表示苹果，'.' 表示空。
需要把披萨切成 k 块，每块至少含一个苹果。
每次切披萨必须沿整行或整列之间的直线切下，并把当前所有块一起切开。
返回切出 k 块的方案数，模 1e9+7。""",
        function="waysCutPizza",
        params=[("pizza", "string[]"), ("k", "int")],
        returns="int",
        solver=ways_cut_pizza,
        public=[
            [["A..", "AAA", "..."], 3],
            [["A..", "AA.", "..."], 3],
            [["A..", "A..", "..."], 1],
        ],
        hidden=[
            [["A"], 1],
            [["A"], 2],
            [["..", ".."], 2],
            [["AAA", "AAA", "AAA"], 3],
            [["A..", "...", "..."], 2],
        ],
    ),
    make(
        pid=1687,
        title="摘樱桃 II",
        tags=["数组", "动态规划", "矩阵"],
        description="""给定 rows x cols 的 grid，两个机器人分别从 (0,0) 和 (0,cols-1) 出发。
每轮两个机器人同时下移到下一行，列坐标可以分别变化 -1、0、1（不能越界）。
经过的格子中的樱桃会被收集，同一格子若两个机器人同时经过只计一次。
返回到达最后一行时能收集的最多樱桃数。""",
        function="cherryPickupII",
        params=[("grid", "int[][]")],
        returns="int",
        solver=cherry_pickup_ii,
        public=[
            [[[3, 1, 1], [2, 5, 1], [1, 5, 5], [2, 1, 1]]],
            [[[1, 2, 3]]],
            [[[1, 2], [3, 4]]],
        ],
        hidden=[
            [[[1]]],
            [[[1, 1], [1, 1]]],
            [[[5, 0, 5, 0, 5]]],
            [[[1, 0, 1], [1, 0, 1], [1, 0, 1]]],
            [[[10, 0, 0, 0, 10], [0, 0, 0, 0, 0], [10, 0, 0, 0, 10]]],
        ],
    ),
    make(
        pid=1688,
        title="保证图可完全遍历",
        tags=["并查集", "图"],
        description="""给定 n 个节点（编号 1 到 n）和边数组 edges，edges[i] = [type, u, v]。
type=1 表示只有 Alice 能走，type=2 表示只有 Bob 能走，type=3 表示两人都能走。
删除尽可能多的边，使得 Alice 和 Bob 都能从任意节点到达任意节点。
返回最多可删除的边数；无法做到返回 -1。""",
        function="maxNumEdgesToRemove",
        params=[("n", "int"), ("edges", "int[][]")],
        returns="int",
        solver=max_num_edges_to_remove,
        public=[
            [4, [[3, 1, 2], [3, 2, 3], [1, 1, 3], [1, 2, 4], [1, 1, 2], [2, 3, 4]]],
            [4, [[3, 1, 2], [3, 2, 3], [1, 1, 4], [2, 1, 4]]],
            [4, [[3, 2, 3], [1, 1, 2], [2, 3, 4]]],
        ],
        hidden=[
            [1, []],
            [2, [[3, 1, 2]]],
            [3, [[1, 1, 2], [2, 2, 3]]],
            [3, [[3, 1, 2], [3, 2, 3]]],
            [2, [[1, 1, 2], [2, 1, 2], [3, 1, 2]]],
        ],
    ),
    make(
        pid=1689,
        title="最多可达成的换楼请求数目",
        tags=["位运算", "数组", "回溯"],
        description="""给定 n 栋楼和换楼请求数组 requests，requests[i] = [from, to]。
选择尽可能多的请求同时满足：每栋楼的净流入人数等于净流出人数。
返回最多可满足的请求数。""",
        function="maximumRequests",
        params=[("n", "int"), ("requests", "int[][]")],
        returns="int",
        solver=maximum_requests,
        public=[
            [5, [[0, 1], [1, 0], [0, 1], [1, 2], [2, 0], [3, 4]]],
            [3, [[0, 0], [1, 2], [2, 1]]],
            [2, [[0, 1], [1, 0], [1, 1]]],
        ],
        hidden=[
            [1, []],
            [1, [[0, 0]]],
            [2, [[0, 1]]],
            [2, [[0, 1], [1, 0]]],
            [3, [[0, 1], [1, 2], [2, 0], [0, 0]]],
        ],
    ),
    make(
        pid=1690,
        title="通过给定词典构造目标字符串的方案数",
        tags=["数组", "字符串", "动态规划"],
        description="""给定长度相同的单词数组 words 和目标字符串 target。
按列构造字符串：第 i 个字符必须来自 words 中某个单词的第 i 个字符，
每一列可以选择不同的单词。
返回构造出 target 的方案数，模 1e9+7。""",
        function="numWaysToFormTarget",
        params=[("words", "string[]"), ("target", "string")],
        returns="int",
        solver=num_ways_to_form_target,
        public=[
            [["acca", "bbbb", "caca"], "aba"],
            [["abba", "baab"], "bab"],
            [["abcd"], "abcd"],
            [["abab", "baba", "abba", "baab"], "abba"],
        ],
        hidden=[
            [["a"], "a"],
            [["a"], "b"],
            [["ab", "ba"], "ab"],
            [["abc", "bca", "cab"], "abc"],
        ],
    ),
    make(
        pid=1691,
        title="检查边长度限制的路径是否存在",
        tags=["并查集", "图", "排序"],
        description="""给定 n 个节点（编号 0 到 n-1）、无向边数组 edgeList
（edgeList[i] = [u, v, distance]）和查询数组 queries（queries[i] = [p, q, limit]）。
对每个查询，判断是否存在一条从 p 到 q 的路径，
使路径上每条边的距离都严格小于 limit。
返回布尔数组，顺序与查询一致。""",
        function="distanceLimitedPathsExist",
        params=[("n", "int"), ("edgeList", "int[][]"), ("queries", "int[][]")],
        returns="bool[]",
        solver=distance_limited_paths_exist,
        public=[
            [3, [[0, 1, 2], [1, 2, 4], [2, 0, 8], [1, 0, 16]], [[0, 1, 2], [0, 2, 5]]],
            [5, [[0, 1, 10], [1, 2, 5], [2, 3, 9], [3, 4, 13]], [[0, 4, 14], [1, 4, 13]]],
            [3, [[0, 1, 1], [1, 2, 1]], [[0, 2, 1], [0, 2, 2]]],
        ],
        hidden=[
            [1, [], [[0, 0, 0]]],
            [2, [], [[0, 1, 1]]],
            [2, [[0, 1, 5]], [[0, 1, 5], [0, 1, 6]]],
            [4, [[0, 1, 1], [2, 3, 1]], [[0, 1, 2], [0, 3, 2], [2, 3, 1]]],
            [3, [[0, 1, 1], [0, 2, 2], [1, 2, 2]], [[0, 2, 2], [0, 2, 3]]],
        ],
    ),
    make(
        pid=1692,
        title="完成所有工作的最短时间",
        tags=["数组", "动态规划", "位运算", "二分查找"],
        description="""给定 n 个工作和 k 名工人，jobs[i] 表示第 i 个工作的耗时。
每个工作必须完整地分配给一名工人，每名工人同一时间只能做一个工作。
返回到完成所有工作的最短时间（即所有工人最大工作耗时的最小值）。""",
        function="minimumTimeRequired",
        params=[("jobs", "int[]"), ("k", "int")],
        returns="int",
        solver=minimum_time_required,
        public=[
            [[3, 2, 3], 3],
            [[1, 2, 4, 7, 8], 2],
            [[1, 2, 4, 7, 8], 3],
        ],
        hidden=[
            [[1], 1],
            [[5, 5], 2],
            [[1, 1, 1, 1], 2],
            [[10, 10, 10], 3],
            [[2, 7, 4, 1, 8, 1], 2],
            [[1, 2, 3, 4, 5], 3],
        ],
    ),
    make(
        pid=1693,
        title="最多可以参加的会议数目 II",
        tags=["数组", "二分查找", "动态规划", "排序"],
        description="""给定会议数组 events，events[i] = [startDay, endDay, value]。
最多参加 k 个会议，参加一个会议会占用从 startDay 到 endDay 的全部时间，
且任意两个参加的会议时间不能重叠（前一个会议的 endDay 必须严格小于后一个会议的 startDay）。
返回能获得的最大价值。""",
        function="maxValueEvents",
        params=[("events", "int[][]"), ("k", "int")],
        returns="long",
        solver=max_value_events,
        public=[
            [[[1, 2, 4], [3, 4, 3], [2, 3, 1]], 2],
            [[[1, 2, 4], [3, 4, 3], [2, 3, 10]], 2],
            [[[1, 1, 1], [2, 2, 2], [3, 3, 3], [4, 4, 4]], 3],
        ],
        hidden=[
            [[[1, 1, 1]], 1],
            [[[1, 2, 4], [1, 2, 5]], 1],
            [[[1, 2, 4], [3, 4, 3], [2, 3, 1]], 1],
            [[[1, 2, 4], [3, 4, 3], [2, 3, 1]], 3],
            [[[1, 1, 2], [1, 1, 3]], 1],
            [[[1, 2, 1], [2, 3, 1], [3, 4, 1]], 2],
        ],
    ),
    make(
        pid=1694,
        title="N 次操作后的最大分数",
        tags=["数组", "数学", "动态规划", "位运算"],
        description="""给定长度为 2n 的整数数组 nums。
进行 n 次操作：第 i 次操作（i 从 1 开始）选择两个尚未选择的元素，
获得 i 与这两个元素最大公约数的乘积的分数，并删除这两个元素。
返回能获得的最大总分数。""",
        function="maxScoreOperations",
        params=[("nums", "int[]")],
        returns="int",
        solver=max_score_operations,
        public=[
            [[1, 2]],
            [[3, 4, 6, 8]],
            [[1, 2, 3, 4, 5, 6]],
        ],
        hidden=[
            [[1, 1]],
            [[2, 4]],
            [[3, 6, 9, 12]],
            [[1, 2, 3, 4]],
            [[5, 5, 5, 5]],
            [[1, 2, 3, 4, 5, 6, 7, 8]],
        ],
    ),
    make(
        pid=1695,
        title="有向图中最大颜色值",
        tags=["图", "拓扑排序", "动态规划"],
        description="""给定有向图和每个节点的颜色（colors[i] 为小写字母）。
一条路径的颜色值定义为路径上出现次数最多的颜色出现次数。
返回所有路径中的最大颜色值；如果图中有环返回 -1。""",
        function="largestColorValue",
        params=[("colors", "string"), ("edges", "int[][]")],
        returns="int",
        solver=largest_color_value,
        public=[
            ["abaca", [[0, 1], [0, 2], [2, 3], [3, 4]]],
            ["a", []],
            ["abc", [[0, 1], [1, 2]]],
        ],
        hidden=[
            ["ab", [[0, 1], [1, 0]]],
            ["aa", [[0, 1]]],
            ["xyz", []],
            ["aab", [[0, 1], [1, 2]]],
            ["abcabc", [[0, 1], [1, 2], [2, 3], [3, 4], [4, 5]]],
        ],
    ),
    make(
        pid=1696,
        title="从子集的和还原数组",
        tags=["数组", "分治", "哈希表"],
        description="""给定数组 arr 的所有子集和（共 2^n 个，包含空子集的和 0），以及 arr 的长度 n。
arr 中的元素均为正整数。
还原任意一个满足条件的数组；返回按非递减顺序排列的结果。""",
        function="findArrayFromSums",
        params=[("sums", "int[]"), ("n", "int")],
        returns="int[]",
        solver=find_array_from_sums,
        public=[
            [[0, 1, 2, 3], 2],
            [[0, 1, 1, 2], 2],
            [[0, 1, 2, 3, 4, 5, 6, 7], 3],
        ],
        hidden=[
            [[0, 5], 1],
            [[0, 2, 4, 6], 2],
            [[0, 3, 5, 8], 2],
            [[0, 1, 1, 2, 2, 3, 3, 4], 3],
            [[0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15], 4],
        ],
    ),
    make(
        pid=1697,
        title="矩阵转换后的秩",
        tags=["数组", "并查集", "矩阵", "排序"],
        description="""给定 m x n 整数矩阵 matrix。
按以下规则把每个元素替换为它的秩：
秩从 1 开始；同一行或同一列中较大的元素秩严格更大；在满足条件的前提下尽量使用较小的秩。
返回替换后的矩阵。""",
        function="matrixRankTransform",
        params=[("matrix", "int[][]")],
        returns="int[][]",
        solver=matrix_rank_transform,
        public=[
            [[[1, 2], [3, 4]]],
            [[[7, 7], [7, 7]]],
            [[[20, -21, 14], [-19, 4, 19], [22, -47, 24], [-19, 4, 19]]],
        ],
        hidden=[
            [[[1]]],
            [[[1, 1], [1, 1]]],
            [[[1, 100], [100, 1]]],
            [[[5, 3, 5]]],
            [[[1, 2, 3], [4, 5, 6], [7, 8, 9]]],
        ],
    ),
    make(
        pid=1698,
        title="恰有 K 根木棍可以看到的排列数目",
        tags=["数学", "动态规划", "组合数学"],
        description="""将 1 到 n 的 n 根木棍按某个顺序排列。
从左边看，只有比之前所有木棍都高的木棍可见。
返回恰好能看到 k 根木棍的排列数目，模 1e9+7。""",
        function="kSticksVisible",
        params=[("n", "int"), ("k", "int")],
        returns="int",
        solver=k_sticks_visible,
        public=[
            [3, 2],
            [5, 5],
            [4, 2],
        ],
        hidden=[
            [1, 1],
            [2, 1],
            [2, 2],
            [5, 1],
            [6, 3],
            [10, 4],
        ],
    ),
    make(
        pid=1699,
        title="队列中可以看到的人数",
        tags=["数组", "栈", "单调栈"],
        description="""给定队列中每个人的身高 heights。
对于 i < j，如果 i 与 j 之间所有人的身高都严格小于 heights[i] 且严格小于 heights[j]，
则 i 能看到 j。返回队列中所有可见对的总数。""",
        function="visiblePeopleCount",
        params=[("heights", "int[]")],
        returns="int",
        solver=visible_people_count,
        public=[
            [[10, 6, 8, 5, 11, 9]],
            [[5, 1, 2, 3, 4]],
            [[1, 2, 3, 4, 5]],
        ],
        hidden=[
            [[1]],
            [[2, 2]],
            [[3, 3, 3]],
            [[5, 4, 3, 2, 1]],
            [[1, 3, 2, 4]],
            [[2, 1, 2, 1, 2]],
        ],
    ),
]
