"""1860-1879：批量第三批困难题（20 道）。"""

from __future__ import annotations

import bisect
import heapq
from collections import deque
from functools import partial

from problem_seed_common import Node, make_problem, tree_to_list

make = partial(make_problem, difficulty="hard")


# ── 动态规划 ──────────────────────────────────────────────────────


def merge_stones(stones: list[int], k: int) -> int:
    n = len(stones)
    if k == 1:
        return sum(stones)
    if (n - 1) % (k - 1) != 0:
        return -1
    prefix = [0] * (n + 1)
    for index, value in enumerate(stones):
        prefix[index + 1] = prefix[index] + value
    inf = 10**18
    dp = [[0] * n for _ in range(n)]
    for length in range(2, n + 1):
        for left in range(n - length + 1):
            right = left + length - 1
            best = inf
            middle = left
            while middle < right:
                best = min(best, dp[left][middle] + dp[middle + 1][right])
                middle += k - 1
            dp[left][right] = best
            if (length - 1) % (k - 1) == 0:
                dp[left][right] += prefix[right + 1] - prefix[left]
    return dp[0][n - 1]


def num_dup_digits_at_most_n(n: int) -> int:
    digits = [int(character) for character in str(n)]
    length = len(digits)
    # 统计 [1, n] 中各位数字互不相同的整数个数
    memo: dict[tuple[int, int, bool, bool], int] = {}

    def dfs(position: int, mask: int, tight: bool, started: bool) -> int:
        if position == length:
            return 1 if started else 0
        key = (position, mask, tight, started)
        if key in memo:
            return memo[key]
        limit = digits[position] if tight else 9
        total = 0
        for digit in range(limit + 1):
            next_tight = tight and digit == limit
            if not started and digit == 0:
                total += dfs(position + 1, mask, next_tight, False)
            elif mask >> digit & 1:
                continue
            else:
                total += dfs(position + 1, mask | (1 << digit), next_tight, True)
        memo[key] = total
        return total

    unique = dfs(0, 0, True, False)
    return n - unique


def is_valid_palindrome_iii(s: str, k: int) -> bool:
    n = len(s)
    dp = [[0] * n for _ in range(n)]
    for length in range(2, n + 1):
        for left in range(n - length + 1):
            right = left + length - 1
            if s[left] == s[right]:
                dp[left][right] = dp[left + 1][right - 1] if length > 2 else 0
            else:
                dp[left][right] = 1 + min(dp[left + 1][right], dp[left][right - 1])
    return (dp[0][n - 1] if n else 0) <= k


def die_simulator(n: int, roll_max: list[int]) -> int:
    mod = 10**9 + 7
    dp = [[0] * 16 for _ in range(6)]
    for face in range(6):
        dp[face][1] = 1
    for _ in range(2, n + 1):
        next_dp = [[0] * 16 for _ in range(6)]
        for face in range(6):
            for count in range(1, roll_max[face]):
                next_dp[face][count + 1] = dp[face][count]
            total = 0
            for other in range(6):
                if other == face:
                    continue
                for count in range(1, 16):
                    total += dp[other][count]
            next_dp[face][1] = total % mod
        dp = next_dp
    return sum(sum(row) for row in dp) % mod


def job_scheduling(start_time: list[int], end_time: list[int], profit: list[int]) -> int:
    jobs = sorted(zip(end_time, start_time, profit))
    ends = [job[0] for job in jobs]
    dp = [0] * (len(jobs) + 1)
    for index, (end, start, gain) in enumerate(jobs, start=1):
        previous = bisect.bisect_right(ends, start, 0, index - 1)
        dp[index] = max(dp[index - 1], dp[previous] + gain)
    return dp[-1]


def palindrome_partition_iii(s: str, k: int) -> int:
    n = len(s)
    cost = [[0] * n for _ in range(n)]
    for left in range(n - 1, -1, -1):
        for right in range(left + 1, n):
            cost[left][right] = cost[left + 1][right - 1] + (s[left] != s[right])
    inf = 10**9
    dp = [[inf] * (n + 1) for _ in range(k + 1)]
    dp[0][0] = 0
    for parts in range(1, k + 1):
        for end in range(1, n + 1):
            for start in range(parts - 1, end):
                dp[parts][end] = min(
                    dp[parts][end], dp[parts - 1][start] + cost[start][end - 1]
                )
    return dp[k][n]


def max_dot_product(nums1: list[int], nums2: list[int]) -> int:
    n, m = len(nums1), len(nums2)
    negative_inf = -(10**18)
    dp = [[negative_inf] * (m + 1) for _ in range(n + 1)]
    for i in range(1, n + 1):
        for j in range(1, m + 1):
            product = nums1[i - 1] * nums2[j - 1]
            best = product
            if dp[i - 1][j - 1] != negative_inf:
                best = max(best, dp[i - 1][j - 1] + product)
            best = max(best, dp[i - 1][j], dp[i][j - 1])
            dp[i][j] = best
    return dp[n][m]


def min_cost_cut_stick(n: int, cuts: list[int]) -> int:
    points = sorted([0] + cuts + [n])
    size = len(points)
    dp = [[0] * size for _ in range(size)]
    for length in range(2, size):
        for left in range(size - length):
            right = left + length
            dp[left][right] = min(
                dp[left][middle] + dp[middle][right] for middle in range(left + 1, right)
            ) + points[right] - points[left]
    return dp[0][size - 1]


def maximum_score_multipliers(nums: list[int], multipliers: list[int]) -> int:
    m = len(multipliers)
    negative_inf = -(10**30)
    dp = [negative_inf] * (m + 1)
    dp[0] = 0
    for step, multiplier in enumerate(multipliers):
        next_dp = [negative_inf] * (m + 1)
        for left_used in range(step + 1):
            if dp[left_used] == negative_inf:
                continue
            right_used = step - left_used
            next_dp[left_used + 1] = max(
                next_dp[left_used + 1], dp[left_used] + nums[left_used] * multiplier
            )
            next_dp[left_used] = max(
                next_dp[left_used],
                dp[left_used] + nums[-1 - right_used] * multiplier,
            )
        dp = next_dp
    return max(dp)


def count_special_subsequences(nums: list[int]) -> int:
    mod = 10**9 + 7
    zero = one = two = 0
    for value in nums:
        if value == 0:
            zero = (2 * zero + 1) % mod
        elif value == 1:
            one = (2 * one + zero) % mod
        else:
            two = (2 * two + one) % mod
    return two


def stone_game_iii(stone_value: list[int]) -> str:
    n = len(stone_value)
    suffix = [0] * (n + 1)
    for index in range(n - 1, -1, -1):
        suffix[index] = suffix[index + 1] + stone_value[index]
    negative_inf = -(10**18)
    dp = [0] * (n + 1)
    for index in range(n - 1, -1, -1):
        best = negative_inf
        for take in range(1, 4):
            if index + take <= n:
                best = max(
                    best,
                    suffix[index] - suffix[index + take] - dp[index + take],
                )
        dp[index] = best
    if dp[0] > 0:
        return "Alice"
    if dp[0] < 0:
        return "Bob"
    return "Tie"


# ── 栈与队列 ──────────────────────────────────────────────────────


def min_number_operations_target(target: list[int]) -> int:
    operations = 0
    previous = 0
    for value in target:
        if value > previous:
            operations += value - previous
        previous = value
    return operations


def find_max_value_equation(points: list[list[int]], k: int) -> int:
    queue: deque[tuple[int, int]] = deque()
    answer = -(10**30)
    for x, y in points:
        while queue and x - queue[0][0] > k:
            queue.popleft()
        if queue:
            answer = max(answer, queue[0][1] + y + x)
        value = y - x
        while queue and queue[-1][1] <= value:
            queue.pop()
        queue.append((x, value))
    return answer


def recover_from_preorder(traversal: str) -> list[int | None]:
    stack: list[Node] = []
    root: Node | None = None
    index = 0
    size = len(traversal)
    while index < size:
        depth = 0
        while index < size and traversal[index] == "-":
            depth += 1
            index += 1
        value = 0
        while index < size and traversal[index].isdigit():
            value = value * 10 + int(traversal[index])
            index += 1
        node = Node(value)
        if not stack:
            root = node
            stack.append(node)
            continue
        while len(stack) > depth:
            stack.pop()
        parent = stack[-1]
        if parent.left is None:
            parent.left = node
        else:
            parent.right = node
        stack.append(node)
    return tree_to_list(root)


# ── 堆 ────────────────────────────────────────────────────────────


def max_performance_team(
    n: int, speed: list[int], efficiency: list[int], k: int
) -> int:
    mod = 10**9 + 7
    engineers = sorted(zip(efficiency, speed), reverse=True)
    heap: list[int] = []
    total_speed = 0
    answer = 0
    for eff, spd in engineers:
        heapq.heappush(heap, spd)
        total_speed += spd
        if len(heap) > k:
            total_speed -= heapq.heappop(heap)
        answer = max(answer, total_speed * eff)
    return answer % mod


def busiest_servers(k: int, arrival: list[int], load: list[int]) -> list[int]:
    tree = [0] * (k + 1)

    def add(position: int, delta: int) -> None:
        while position <= k:
            tree[position] += delta
            position += position & -position

    def prefix(position: int) -> int:
        total = 0
        while position > 0:
            total += tree[position]
            position -= position & -position
        return total

    def kth(order: int) -> int:
        position = 0
        step = 1 << (k.bit_length() - 1)
        while step:
            candidate = position + step
            if candidate <= k and tree[candidate] < order:
                position = candidate
                order -= tree[candidate]
            step >>= 1
        return position + 1

    for server in range(1, k + 1):
        add(server, 1)
    free_count = k
    counts = [0] * k
    busy: list[tuple[int, int]] = []
    for request, time in enumerate(arrival):
        while busy and busy[0][0] <= time:
            _, server = heapq.heappop(busy)
            add(server + 1, 1)
            free_count += 1
        if free_count == 0:
            continue
        target = request % k
        before = prefix(target)
        if before == free_count:
            position = kth(1)
        else:
            position = kth(before + 1)
        server = position - 1
        counts[server] += 1
        add(position, -1)
        free_count -= 1
        heapq.heappush(busy, (time + load[request], server))
    best = max(counts)
    return [server for server, count in enumerate(counts) if count == best]


def smallest_range_queries(
    intervals: list[list[int]], queries: list[int]
) -> list[int]:
    ordered_intervals = sorted(intervals)
    order = sorted(range(len(queries)), key=lambda index: queries[index])
    answer = [-1] * len(queries)
    heap: list[tuple[int, int]] = []
    pointer = 0
    for query_index in order:
        query = queries[query_index]
        while pointer < len(ordered_intervals) and ordered_intervals[pointer][0] <= query:
            left, right = ordered_intervals[pointer]
            heapq.heappush(heap, (right - left + 1, right))
            pointer += 1
        while heap and heap[0][1] < query:
            heapq.heappop(heap)
        if heap:
            answer[query_index] = heap[0][0]
    return answer


# ── 图 ────────────────────────────────────────────────────────────


def shortest_path_grid(grid: list[list[int]], k: int) -> int:
    rows, columns = len(grid), len(grid[0])
    start_used = grid[0][0]
    if start_used > k:
        return -1
    visited = [[[False] * (k + 1) for _ in range(columns)] for _ in range(rows)]
    visited[0][0][start_used] = True
    queue = deque([(0, 0, start_used, 0)])
    directions = ((1, 0), (-1, 0), (0, 1), (0, -1))
    while queue:
        row, column, used, distance = queue.popleft()
        if row == rows - 1 and column == columns - 1:
            return distance
        for delta_row, delta_column in directions:
            next_row = row + delta_row
            next_column = column + delta_column
            if 0 <= next_row < rows and 0 <= next_column < columns:
                next_used = used + grid[next_row][next_column]
                if next_used <= k and not visited[next_row][next_column][next_used]:
                    visited[next_row][next_column][next_used] = True
                    queue.append((next_row, next_column, next_used, distance + 1))
    return -1


def min_cost_reach_destination(
    max_time: int, edges: list[list[int]], passing_fees: list[int]
) -> int:
    n = len(passing_fees)
    graph: list[list[tuple[int, int]]] = [[] for _ in range(n)]
    for u, v, duration in edges:
        graph[u].append((v, duration))
        graph[v].append((u, duration))
    inf = 10**18
    dist = [[inf] * (max_time + 1) for _ in range(n)]
    dist[0][0] = passing_fees[0]
    heap = [(passing_fees[0], 0, 0)]
    while heap:
        fee, node, time = heapq.heappop(heap)
        if fee != dist[node][time]:
            continue
        if node == n - 1:
            return fee
        for neighbour, duration in graph[node]:
            next_time = time + duration
            if next_time > max_time:
                continue
            next_fee = fee + passing_fees[neighbour]
            if next_fee < dist[neighbour][next_time]:
                dist[neighbour][next_time] = next_fee
                heapq.heappush(heap, (next_fee, neighbour, next_time))
    return -1


def find_critical_pseudo_critical_edges(n: int, edges: list[list[int]]) -> list[list[int]]:
    class DSU:
        def __init__(self, size: int) -> None:
            self.parent = list(range(size))
            self.rank = [0] * size

        def find(self, node: int) -> int:
            while self.parent[node] != node:
                self.parent[node] = self.parent[self.parent[node]]
                node = self.parent[node]
            return node

        def union(self, left: int, right: int) -> bool:
            root_left = self.find(left)
            root_right = self.find(right)
            if root_left == root_right:
                return False
            if self.rank[root_left] < self.rank[root_right]:
                root_left, root_right = root_right, root_left
            self.parent[root_right] = root_left
            if self.rank[root_left] == self.rank[root_right]:
                self.rank[root_left] += 1
            return True

    inf = 10**18

    def mst_weight(skip: int = -1, force: int = -1) -> int:
        dsu = DSU(n)
        total = 0
        used = 0
        if force != -1:
            u, v, weight = edges[force]
            dsu.union(u, v)
            total += weight
            used += 1
        for index in sorted(range(len(edges)), key=lambda i: edges[i][2]):
            if index == skip or index == force:
                continue
            u, v, weight = edges[index]
            if dsu.union(u, v):
                total += weight
                used += 1
        return total if used == n - 1 else inf

    base = mst_weight()
    critical: list[int] = []
    pseudo: list[int] = []
    for index in range(len(edges)):
        if mst_weight(skip=index) > base:
            critical.append(index)
        elif mst_weight(force=index) == base:
            pseudo.append(index)
    return [critical, pseudo]


PROBLEMS = [
    make(
        pid=1860,
        title="合并石头的最低成本",
        tags=["数组", "动态规划"],
        description="""有 n 堆石头排成一排，第 i 堆有 stones[i] 颗石头
每次操作必须将连续的 k 堆石头合并成一堆，成本为这 k 堆石头的总数
经过若干次操作后，把所有石头合并成一堆
返回最小总成本
如果无法合并成一堆，返回 -1""",
        function="mergeStones",
        params=[("stones", "int[]"), ("k", "int")],
        returns="int",
        solver=merge_stones,
        public=[
            [[3, 2, 4, 1], 2],
            [[3, 2, 4, 1], 3],
            [[1, 2, 3, 4, 5], 2],
            [[1], 2],
        ],
        hidden=[
            [[1, 2, 3], 2],
            [[1, 2, 3], 3],
            [[4, 1, 1, 1, 1], 3],
            [[1, 3, 5, 7, 9, 11], 3],
            [[5, 5, 5, 5], 2],
            [[2, 4, 6, 8], 2],
        ],
    ),
    make(
        pid=1861,
        title="至少有 1 位重复的数字",
        tags=["数学", "动态规划"],
        description="""给定正整数 n
返回范围 [1, n] 内至少存在一位重复数字的正整数个数""",
        function="numDupDigitsAtMostN",
        params=[("n", "int")],
        returns="int",
        solver=num_dup_digits_at_most_n,
        public=[[20], [100], [1000], [11]],
        hidden=[[1], [9], [10], [10000], [987654321], [1000000000]],
    ),
    make(
        pid=1862,
        title="验证回文串 III",
        tags=["字符串", "动态规划"],
        description="""给定字符串 s 和整数 k
每次可以删除一个字符，最多删除 k 次
判断能否使剩余字符串成为回文串""",
        function="isValidPalindromeIII",
        params=[("s", "string"), ("k", "int")],
        returns="bool",
        solver=is_valid_palindrome_iii,
        public=[
            ["abc", 2],
            ["abcdeca", 2],
            ["abc", 1],
            ["a", 1],
        ],
        hidden=[
            ["aa", 0],
            ["ab", 1],
            ["abcd", 1],
            ["abcdef", 3],
            ["abca", 1],
            ["abbababa", 1],
        ],
    ),
    make(
        pid=1863,
        title="掷骰子模拟",
        tags=["动态规划"],
        description="""掷一个六面骰子 n 次，点数从 1 到 6
第 i 面连续出现的次数不能超过 rollMax[i-1]
返回不同点数序列的总数，对 10^9+7 取模""",
        function="dieSimulator",
        params=[("n", "int"), ("rollMax", "int[]")],
        returns="int",
        solver=die_simulator,
        public=[
            [1, [1, 1, 2, 2, 2, 3]],
            [2, [1, 1, 2, 2, 2, 3]],
            [2, [1, 1, 1, 1, 1, 1]],
            [3, [1, 1, 1, 2, 2, 3]],
        ],
        hidden=[
            [1, [1, 1, 1, 1, 1, 1]],
            [10, [2, 2, 2, 2, 2, 2]],
            [50, [1, 2, 3, 1, 2, 3]],
            [500, [1, 1, 2, 2, 3, 3]],
            [5000, [1, 1, 2, 2, 2, 3]],
            [1000, [6, 6, 6, 6, 6, 6]],
        ],
    ),
    make(
        pid=1864,
        title="规划兼职工作",
        tags=["数组", "动态规划", "二分查找"],
        description="""给定 startTime、endTime、profit 三个等长数组
第 i 份工作从 startTime[i] 持续到 endTime[i]，报酬为 profit[i]
同一时间只能做一份工作，下一份工作的开始时间必须不早于上一份工作的结束时间
返回能获得的最大报酬""",
        function="jobScheduling",
        params=[
            ("startTime", "int[]"),
            ("endTime", "int[]"),
            ("profit", "int[]"),
        ],
        returns="int",
        solver=job_scheduling,
        public=[
            [[1, 2, 3, 3], [3, 4, 5, 6], [50, 10, 40, 70]],
            [[1, 2, 3, 4, 6], [3, 5, 10, 6, 9], [20, 20, 100, 70, 60]],
            [[1, 1, 1], [2, 3, 4], [5, 6, 7]],
            [[1], [2], [3]],
        ],
        hidden=[
            [[1, 2, 3, 4], [2, 3, 4, 5], [1, 2, 3, 4]],
            [[1, 1, 1], [2, 2, 2], [1, 2, 3]],
            [[4, 2, 4, 8, 2], [5, 5, 5, 10, 8], [1, 2, 3, 4, 5]],
            [[1, 2], [3, 4], [5, 6]],
            [[1, 2, 3], [3, 4, 5], [10, 20, 30]],
            [[1, 3, 5, 7], [2, 4, 6, 8], [5, 5, 5, 5]],
        ],
    ),
    make(
        pid=1865,
        title="分割回文串 III",
        tags=["字符串", "动态规划"],
        description="""给定字符串 s 和整数 k
把 s 分割成 k 个非空子串，并可以修改任意位置的字符
返回使每个子串都成为回文串所需的最少修改次数""",
        function="palindromePartitionIII",
        params=[("s", "string"), ("k", "int")],
        returns="int",
        solver=palindrome_partition_iii,
        public=[
            ["abc", 2],
            ["aabbc", 3],
            ["leetcode", 8],
            ["abcdef", 6],
        ],
        hidden=[
            ["abc", 1],
            ["abcdef", 1],
            ["aba", 1],
            ["abcba", 3],
            ["aaabbb", 2],
            ["abcde", 3],
        ],
    ),
    make(
        pid=1866,
        title="两个子序列的最大点积",
        tags=["数组", "动态规划"],
        description="""给定两个整数数组 nums1 和 nums2
从 nums1 中选出一个非空子序列，从 nums2 中选出一个非空子序列，两者长度相同
按顺序对应相乘后求和，返回可能的最大点积""",
        function="maxDotProduct",
        params=[("nums1", "int[]"), ("nums2", "int[]")],
        returns="int",
        solver=max_dot_product,
        public=[
            [[2, 1, -2, 5], [3, 0, -6]],
            [[3, -2], [2, 4]],
            [[-1, -1], [-1, -1]],
            [[1, 2, 3], [4, 5, 6]],
        ],
        hidden=[
            [[1, 1], [-1, -1]],
            [[-3, -2, -1], [-1, -2, -3]],
            [[5], [-2]],
            [[1, 2], [3, 4]],
            [[-5, -4], [-3, -2]],
            [[0, 1], [-1, 0]],
        ],
    ),
    make(
        pid=1867,
        title="切棍子的最小成本",
        tags=["数组", "动态规划"],
        description="""有一根长度为 n 的棍子，cuts 给出所有需要切割的位置
每次切割一根棍子时，成本为该棍子当前的长度
切割后得到两根更短的棍子，可以继续切割
返回完成所有切割的最小总成本""",
        function="minCostCutStick",
        params=[("n", "int"), ("cuts", "int[]")],
        returns="int",
        solver=min_cost_cut_stick,
        public=[
            [7, [1, 3, 4, 5]],
            [9, [5, 6, 1, 4, 2]],
            [7, []],
            [10, [2, 4, 7]],
        ],
        hidden=[
            [7, [1]],
            [100, [25, 50, 75]],
            [5, [1, 2, 3, 4]],
            [20, [1, 5, 9, 13, 17]],
            [30, [5, 10, 15, 20, 25]],
            [8, [3, 5]],
        ],
    ),
    make(
        pid=1868,
        title="执行乘法运算的最大分数",
        tags=["数组", "动态规划"],
        description="""给定数组 nums 和 multipliers
需要进行 multipliers.length 次操作
第 i 次操作取 nums 当前最左端或最右端的元素，与 multipliers[i] 相乘并累加
返回所有操作完成后的最大总分""",
        function="maximumScoreMultipliers",
        params=[("nums", "int[]"), ("multipliers", "int[]")],
        returns="int",
        solver=maximum_score_multipliers,
        public=[
            [[1, 2, 3], [3, 2, 1]],
            [[-5, -3, -3, -2, 7, 1], [-10, -5, 3, 4, 6]],
            [[1, 2], [1, 2]],
            [[1], [1]],
        ],
        hidden=[
            [[1, 2, 3], [1]],
            [[3, -1, -5, 2, 5], [-2, -5, 1, -4, 3]],
            [[1, 2, 3, 4, 5], [1, 2, 3]],
            [[5, 5, 5], [5, 5]],
            [[-1, -2, -3], [-1, -2, -3]],
            [[100, 200, 300], [1, 2, 3]],
        ],
    ),
    make(
        pid=1869,
        title="统计特殊子序列的数目",
        tags=["数组", "动态规划"],
        description="""特殊子序列由若干个 0、接着若干个 1、最后若干个 2 组成，三部分都非空
给定只含 0、1、2 的数组 nums
返回不同特殊子序列的数目，对 10^9+7 取模""",
        function="countSpecialSubsequences",
        params=[("nums", "int[]")],
        returns="int",
        solver=count_special_subsequences,
        public=[
            [[0, 1, 2, 2]],
            [[2, 2, 0, 0]],
            [[0, 1, 2]],
            [[0, 0, 1, 1, 2, 2]],
        ],
        hidden=[
            [[0]],
            [[1, 2]],
            [[0, 2]],
            [[0, 1, 1, 2]],
            [[0, 1, 2, 0, 1, 2, 2]],
            [[2, 0, 1]],
        ],
    ),
    make(
        pid=1870,
        title="石子游戏 III",
        tags=["数组", "动态规划", "博弈"],
        description="""Alice 和 Bob 轮流从一排石头中取石头，Alice 先手
每名玩家每次必须从当前剩余石头的最前面取走 1 到 3 堆，得分等于取走石头的总数
双方都采用最优策略，返回最终获胜者
得分相同返回 Tie，否则返回 Alice 或 Bob""",
        function="stoneGameIII",
        params=[("stoneValue", "int[]")],
        returns="string",
        solver=stone_game_iii,
        public=[
            [[1, 2, 3, 7]],
            [[1, 2, 3, -9]],
            [[1, 2, 3, 6]],
            [[5]],
        ],
        hidden=[
            [[1, 2, 3, -1, -2, -3, 7]],
            [[-1, -2, -3]],
            [[0]],
            [[1, 2]],
            [[10, -10, 10, -10]],
            [[1, 2, 3, 4, 5, 6]],
            [[-10, -10, -10]],
        ],
    ),
    make(
        pid=1871,
        title="形成目标数组的子数组最少增加次数",
        tags=["数组", "栈", "贪心"],
        description="""初始有一个长度与 target 相同的全零数组
每次操作可以选择一个子数组，并把其中每个元素都加一
给定目标数组 target，返回得到 target 所需的最少操作次数""",
        function="minNumberOperationsTarget",
        params=[("target", "int[]")],
        returns="int",
        solver=min_number_operations_target,
        public=[
            [[1, 2, 3, 2, 1]],
            [[3, 1, 1, 2]],
            [[3, 1, 5, 4, 2]],
            [[1]],
        ],
        hidden=[
            [[1, 1, 1]],
            [[5]],
            [[1, 3, 2, 4, 1]],
            [[1, 2, 1, 2, 1]],
            [[10, 9, 8, 7]],
            [[1, 10, 1, 10, 1]],
        ],
    ),
    make(
        pid=1872,
        title="满足不等式的最大值",
        tags=["数组", "队列", "滑动窗口"],
        description="""给定按 x 严格递增排列的点 points，其中 points[i] = [x_i, y_i]，以及整数 k
选择两个不同下标 i < j，满足 x_j - x_i <= k
返回 y_i + y_j + x_j - x_i 的最大值
题目保证至少存在一对满足条件的点""",
        function="findMaxValueEquation",
        params=[("points", "int[][]"), ("k", "int")],
        returns="int",
        solver=find_max_value_equation,
        public=[
            [[[1, 3], [2, 0], [5, 10], [6, -10]], 1],
            [[[0, 0], [3, 0], [9, 2]], 3],
            [[[0, 0], [1, 1], [2, 2]], 1],
            [[[-5, 2], [0, 3], [1, 0], [3, 4]], 2],
        ],
        hidden=[
            [[[0, 0], [1, 4], [2, -2]], 1],
            [[[0, -5], [2, 3], [4, 1]], 2],
            [[[-3, -3], [0, 1], [2, -1]], 2],
            [[[1, 0], [2, 10], [3, 1], [4, 2]], 2],
            [[[-10, 5], [-9, 3], [-8, 1]], 1],
            [[[0, 100], [1, 1], [2, 50]], 2],
        ],
    ),
    make(
        pid=1873,
        title="从先序遍历还原二叉树",
        tags=["栈", "树", "二叉树"],
        description="""给定二叉树先序遍历的字符串 traversal
数字表示节点值，若干个连续的 '-' 表示该节点的深度，根节点深度为 0
请根据字符串还原这棵二叉树，并按层序返回
空节点用 null 表示，末尾多余的 null 不输出""",
        function="recoverFromPreorder",
        params=[("traversal", "string")],
        returns="TreeNode",
        solver=recover_from_preorder,
        public=[
            ["1-2--3--4-5--6--7"],
            ["1-2--3---4----5"],
            ["1-401--349---90--88"],
            ["1"],
        ],
        hidden=[
            ["1-2--3"],
            ["1-2-3"],
            ["5"],
            ["1-2--3--4"],
            ["1-2--3---4"],
            ["1-2--3--4-5"],
            ["9-8--7-6--5--4"],
        ],
    ),
    make(
        pid=1874,
        title="最大的团队表现值",
        tags=["数组", "排序", "堆"],
        description="""给定 n 名工程师的速度 speed 和效率 efficiency，以及整数 k
选择至多 k 名工程师组成团队
团队表现值等于团队速度之和乘以团队中最小的效率
返回最大表现值，对 10^9+7 取模""",
        function="maxPerformanceTeam",
        params=[
            ("n", "int"),
            ("speed", "int[]"),
            ("efficiency", "int[]"),
            ("k", "int"),
        ],
        returns="int",
        solver=max_performance_team,
        public=[
            [6, [2, 10, 3, 1, 5, 8], [5, 4, 3, 9, 7, 2], 2],
            [6, [2, 10, 3, 1, 5, 8], [5, 4, 3, 9, 7, 2], 3],
            [6, [2, 10, 3, 1, 5, 8], [5, 4, 3, 9, 7, 2], 4],
            [1, [5], [7], 1],
        ],
        hidden=[
            [2, [1, 1], [1, 1], 2],
            [3, [10, 1, 1], [5, 5, 5], 2],
            [5, [1, 2, 3, 4, 5], [1, 2, 3, 4, 5], 1],
            [4, [4, 5, 6, 7], [8, 7, 6, 5], 2],
            [3, [100, 80, 60], [2, 3, 5], 3],
            [5, [1, 1, 1, 1, 1], [100, 90, 80, 70, 60], 3],
        ],
    ),
    make(
        pid=1875,
        title="找到处理最多请求的服务器",
        tags=["数组", "堆", "有序集合"],
        description="""有 k 个编号从 0 到 k-1 的服务器
第 i 个请求在 arrival[i] 到达，需要 load[i] 时间处理
服务器空闲时，必须选择编号不小于 i mod k 的最小空闲服务器
若不存在这样的服务器，则选择编号最小的空闲服务器
若仍没有空闲服务器，则丢弃该请求
返回处理请求数最多的服务器编号列表，按编号升序""",
        function="busiestServers",
        params=[
            ("k", "int"),
            ("arrival", "int[]"),
            ("load", "int[]"),
        ],
        returns="int[]",
        solver=busiest_servers,
        public=[
            [3, [1, 2, 3, 4, 5], [5, 2, 3, 3, 3]],
            [3, [1, 2, 3, 4], [1, 2, 1, 2]],
            [1, [1], [1]],
            [2, [1, 1, 1], [5, 2, 1]],
        ],
        hidden=[
            [3, [1, 2, 3, 4, 8, 9, 10], [5, 2, 2, 3, 1, 2, 2]],
            [2, [1, 2, 3], [3, 2, 1]],
            [4, [1, 2, 3, 4, 5, 6], [10, 10, 10, 10, 10, 10]],
            [1, [1, 2, 3], [1, 1, 1]],
            [2, [1, 2, 3, 4, 5], [1, 1, 1, 1, 1]],
            [3, [5, 5, 5, 5], [1, 2, 3, 4]],
        ],
    ),
    make(
        pid=1876,
        title="包含每个查询的最小区间",
        tags=["数组", "排序", "堆"],
        description="""给定若干闭区间 intervals 和查询数组 queries
对于每个查询 q，找出所有包含 q 的区间中长度最小的区间，返回该区间的长度
若没有区间包含 q，返回 -1
答案按 queries 中原有的顺序返回""",
        function="smallestRangeQueries",
        params=[("intervals", "int[][]"), ("queries", "int[]")],
        returns="int[]",
        solver=smallest_range_queries,
        public=[
            [[[1, 4], [2, 4], [3, 6], [4, 4]], [2, 3, 4, 5]],
            [[[2, 3], [2, 5], [1, 8], [20, 25]], [2, 19, 5, 22]],
            [[[1, 1]], [1]],
            [[[1, 5], [3, 7], [8, 9]], [4, 7, 10]],
        ],
        hidden=[
            [[[1, 2], [2, 3]], [1, 2, 3]],
            [[[1, 10]], [0, 11]],
            [[[5, 5]], [5]],
            [[[1, 3], [2, 2]], [2]],
            [[[1, 4], [2, 5], [3, 6]], [3, 4]],
            [[[10, 20], [15, 25], [5, 15]], [12, 18, 22]],
        ],
    ),
    make(
        pid=1877,
        title="网格中的最短路径",
        tags=["图", "广度优先搜索", "数组"],
        description="""给定 m 行 n 列的网格 grid，0 表示空地，1 表示障碍
从左上角出发，每次可以向上、下、左、右移动一步，最多可以消除 k 个障碍
返回到达右下角所需的最少步数
如果无法到达，返回 -1""",
        function="shortestPathGrid",
        params=[("grid", "int[][]"), ("k", "int")],
        returns="int",
        solver=shortest_path_grid,
        public=[
            [[[0, 0, 0], [1, 1, 0], [0, 0, 0], [0, 1, 1], [0, 0, 0]], 1],
            [[[0, 1, 1], [1, 1, 1], [1, 0, 0]], 1],
            [[[0, 0], [0, 0]], 0],
            [[[0, 1, 0, 1], [0, 1, 0, 0], [0, 0, 0, 0]], 1],
        ],
        hidden=[
            [[[0]], 0],
            [[[0, 0, 0], [0, 1, 0], [0, 0, 0]], 0],
            [[[0, 0, 0], [0, 1, 0], [0, 0, 0]], 1],
            [[[0, 1], [1, 0]], 1],
            [[[0, 0, 1, 0, 0, 0], [1, 1, 1, 1, 1, 0], [0, 0, 0, 0, 0, 0]], 1],
            [[[0, 1, 1], [0, 1, 1], [0, 0, 0]], 2],
        ],
    ),
    make(
        pid=1878,
        title="规定时间内到达终点的最小花费",
        tags=["图", "最短路", "动态规划"],
        description="""给定无向图，edges[i] = [u, v, time] 表示一条通行时间为 time 的边
passingFees[i] 表示经过节点 i 需要支付的费用，起点和终点也需要支付
从节点 0 出发，在不超过 maxTime 的时间内到达节点 n-1
返回最小总费用
如果无法按时到达，返回 -1""",
        function="minCostReachDestination",
        params=[
            ("maxTime", "int"),
            ("edges", "int[][]"),
            ("passingFees", "int[]"),
        ],
        returns="int",
        solver=min_cost_reach_destination,
        public=[
            [
                30,
                [[0, 1, 10], [1, 2, 10], [2, 5, 10], [0, 3, 1], [3, 4, 10], [4, 5, 10]],
                [5, 1, 2, 20, 20, 3],
            ],
            [
                29,
                [[0, 1, 10], [1, 2, 10], [2, 5, 10], [0, 3, 1], [3, 4, 10], [4, 5, 10]],
                [5, 1, 2, 20, 20, 3],
            ],
            [
                25,
                [[0, 1, 10], [1, 2, 10], [2, 5, 10], [0, 3, 1], [3, 4, 10], [4, 5, 10]],
                [5, 1, 2, 20, 20, 3],
            ],
            [2, [[0, 1, 1]], [2, 3]],
        ],
        hidden=[
            [1, [[0, 1, 1]], [1, 1]],
            [10, [[0, 1, 10], [1, 2, 10]], [1, 1, 1]],
            [4, [[0, 1, 2], [1, 2, 2], [0, 2, 5]], [1, 10, 1]],
            [5, [[0, 1, 2], [1, 2, 2], [0, 2, 5]], [1, 10, 1]],
            [10, [[0, 1, 1], [1, 2, 1], [2, 3, 1], [0, 3, 10]], [2, 1, 3, 1]],
            [
                6,
                [[0, 1, 1], [0, 2, 5], [1, 2, 1], [2, 3, 1]],
                [1, 10, 1, 1],
            ],
        ],
    ),
    make(
        pid=1879,
        title="找到最小生成树里的关键边和伪关键边",
        tags=["图", "并查集", "最小生成树"],
        description="""给定 n 个节点的无向连通图，edges[i] = [u, v, w]
关键边：从图中删除后会使命中最小生成树总权重增大或无法形成生成树的边
伪关键边：不是关键边，但存在于至少一棵最小生成树中的边
返回 [所有关键边编号, 所有伪关键边编号]
编号即 edges 的下标，两个列表都按编号升序排列""",
        function="findCriticalPseudoCriticalEdges",
        params=[("n", "int"), ("edges", "int[][]")],
        returns="int[][]",
        solver=find_critical_pseudo_critical_edges,
        public=[
            [
                5,
                [[0, 1, 1], [1, 2, 1], [2, 3, 2], [0, 3, 2], [0, 4, 3], [3, 4, 3], [1, 4, 6]],
            ],
            [4, [[0, 1, 1], [1, 2, 1], [2, 3, 1], [0, 3, 1]]],
            [2, [[0, 1, 1]]],
            [
                6,
                [[0, 1, 1], [1, 2, 1], [2, 3, 1], [3, 4, 1], [4, 5, 1], [0, 5, 2]],
            ],
        ],
        hidden=[
            [3, [[0, 1, 1], [1, 2, 1], [0, 2, 2]]],
            [
                5,
                [[0, 1, 2], [0, 2, 2], [1, 2, 2], [2, 3, 3], [3, 4, 3], [1, 4, 5]],
            ],
            [
                4,
                [[0, 1, 1], [1, 2, 2], [2, 3, 3], [0, 3, 6], [0, 2, 4], [1, 3, 5]],
            ],
            [
                6,
                [[0, 1, 4], [0, 2, 1], [1, 2, 2], [2, 3, 5], [3, 4, 1], [4, 5, 3], [2, 5, 6], [1, 5, 7]],
            ],
            [3, [[0, 1, 1], [0, 2, 1], [1, 2, 1]]],
            [
                4,
                [[0, 1, 1], [1, 2, 1], [2, 3, 1], [3, 0, 1], [0, 2, 1], [1, 3, 1]],
            ],
        ],
    ),
]
