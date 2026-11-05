"""1480-1499：批量第一批困难题（20 道）。"""

from __future__ import annotations

import heapq
from collections import deque
from functools import lru_cache, partial
from itertools import combinations
from math import gcd

from problem_seed_common import make_problem

make = partial(make_problem, difficulty="hard")


def shortest_path_all_nodes(graph: list[list[int]]) -> int:
    size = len(graph)
    full = (1 << size) - 1
    queue = deque((node, 1 << node, 0) for node in range(size))
    seen = {(node, 1 << node) for node in range(size)}
    while queue:
        node, mask, distance = queue.popleft()
        if mask == full:
            return distance
        for neighbor in graph[node]:
            next_mask = mask | (1 << neighbor)
            if (neighbor, next_mask) not in seen:
                seen.add((neighbor, next_mask))
                queue.append((neighbor, next_mask, distance + 1))
    return -1


def count_inversions(nums: list[int]) -> int:
    total = 0

    def sort(values: list[int]) -> list[int]:
        nonlocal total
        if len(values) <= 1:
            return values
        middle = len(values) // 2
        left = sort(values[:middle])
        right = sort(values[middle:])
        merged: list[int] = []
        left_index = right_index = 0
        while left_index < len(left) and right_index < len(right):
            if left[left_index] <= right[right_index]:
                merged.append(left[left_index])
                left_index += 1
            else:
                total += len(left) - left_index
                merged.append(right[right_index])
                right_index += 1
        merged.extend(left[left_index:])
        merged.extend(right[right_index:])
        return merged

    sort(nums)
    return total


def number_of_arithmetic_slices_ii(nums: list[int]) -> int:
    size = len(nums)
    dp: list[dict[int, int]] = [{} for _ in range(size)]
    total = 0
    for index in range(size):
        for previous in range(index):
            difference = nums[index] - nums[previous]
            dp[index][difference] = dp[index].get(difference, 0) + dp[previous].get(difference, 0) + 1
            total += dp[previous].get(difference, 0)
    return total


def race_car(target: int) -> int:
    heap = [(0, 0, 1)]
    seen: set[tuple[int, int]] = set()
    while heap:
        steps, position, speed = heapq.heappop(heap)
        if position == target:
            return steps
        if (position, speed) in seen:
            continue
        seen.add((position, speed))
        next_position = position + speed
        if 0 <= next_position <= target * 2:
            heapq.heappush(heap, (steps + 1, next_position, speed * 2))
        reverse_speed = -1 if speed > 0 else 1
        heapq.heappush(heap, (steps + 1, position, reverse_speed))
    return -1


def get_money_amount(n: int) -> int:
    dp = [[0] * (n + 2) for _ in range(n + 2)]
    for length in range(2, n + 1):
        for left in range(1, n - length + 2):
            right = left + length - 1
            best = 10**9
            for pivot in range(left, right + 1):
                cost = pivot + max(dp[left][pivot - 1], dp[pivot + 1][right])
                best = min(best, cost)
            dp[left][right] = best
    return dp[1][n] if n >= 1 else 0


def schedule_course(courses: list[list[int]]) -> int:
    ordered = sorted(courses, key=lambda item: item[1])
    total = 0
    heap: list[int] = []
    for duration, last_day in ordered:
        total += duration
        heapq.heappush(heap, -duration)
        if total > last_day:
            total += heapq.heappop(heap)
    return len(heap)


def constrained_subset_sum(nums: list[int], k: int) -> int:
    size = len(nums)
    dp = [0] * size
    best = nums[0]
    queue: deque[int] = deque()
    for index, value in enumerate(nums):
        while queue and queue[0] < index - k:
            queue.popleft()
        previous = dp[queue[0]] if queue else 0
        dp[index] = max(value, value + previous)
        while queue and dp[queue[-1]] <= dp[index]:
            queue.pop()
        queue.append(index)
        best = max(best, dp[index])
    return best


def hit_bricks(grid: list[list[int]], hits: list[list[int]]) -> list[int]:
    rows, columns = len(grid), len(grid[0])
    parent = list(range(rows * columns + 1))
    size = [1] * (rows * columns + 1)
    roof = rows * columns

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

    board = [row[:] for row in grid]
    for row, column in hits:
        if board[row][column] == 1:
            board[row][column] = -1

    for row in range(rows):
        for column in range(columns):
            if board[row][column] != 1:
                continue
            if row == 0:
                union(roof, row * columns + column)
            for delta_row, delta_column in ((1, 0), (0, 1)):
                next_row = row + delta_row
                next_column = column + delta_column
                if (
                    next_row < rows
                    and next_column < columns
                    and board[next_row][next_column] == 1
                ):
                    union(row * columns + column, next_row * columns + next_column)

    result: list[int] = []
    for row, column in reversed(hits):
        if board[row][column] != -1:
            result.append(0)
            continue
        board[row][column] = 1
        before = size[find(roof)]
        if row == 0:
            union(roof, row * columns + column)
        for delta_row, delta_column in ((1, 0), (-1, 0), (0, 1), (0, -1)):
            next_row = row + delta_row
            next_column = column + delta_column
            if (
                0 <= next_row < rows
                and 0 <= next_column < columns
                and board[next_row][next_column] == 1
            ):
                union(row * columns + column, next_row * columns + next_column)
        after = size[find(roof)]
        result.append(max(0, after - before - 1))
    return result[::-1]


def falling_squares(positions: list[list[int]]) -> list[int]:
    intervals: list[tuple[int, int, int]] = []
    result: list[int] = []
    for left, side in positions:
        right = left + side
        height = side
        for start, end, top in intervals:
            if start < right and left < end:
                height = max(height, top + side)
        intervals.append((left, right, height))
        result.append(max(top for _, _, top in intervals))
    return result


def longest_decomposition(text: str) -> int:
    def dfs(left: int, right: int) -> int:
        if left >= right:
            return 0
        for length in range(1, (right - left) // 2 + 1):
            if text[left : left + length] == text[right - length : right]:
                return 2 + dfs(left + length, right - length)
        return 1

    return dfs(0, len(text))


def num_of_arrays(n: int, m: int, k: int) -> int:
    mod = 10**9 + 7
    dp = [[[0] * (k + 1) for _ in range(m + 1)] for _ in range(n + 1)]
    for value in range(1, m + 1):
        dp[1][value][1] = 1
    for length in range(2, n + 1):
        for maximum in range(1, m + 1):
            for cost in range(1, k + 1):
                total = dp[length - 1][maximum][cost] * maximum
                for previous in range(1, maximum):
                    total += dp[length - 1][previous][cost - 1]
                dp[length][maximum][cost] = total % mod
    return sum(dp[n][value][k] for value in range(1, m + 1)) % mod


def remove_boxes(boxes: list[int]) -> int:
    @lru_cache(None)
    def dp(left: int, right: int, same: int) -> int:
        if left > right:
            return 0
        while left + 1 <= right and boxes[left + 1] == boxes[left]:
            left += 1
            same += 1
        best = (same + 1) ** 2 + dp(left + 1, right, 0)
        for middle in range(left + 1, right + 1):
            if boxes[middle] == boxes[left]:
                best = max(best, dp(left + 1, middle - 1, 0) + dp(middle, right, same + 1))
        return best

    return dp(0, len(boxes) - 1, 0)


def minimum_incompatibility(nums: list[int], k: int) -> int:
    size = len(nums)
    if k == 0 or size % k:
        return -1
    group_size = size // k
    if group_size == 0:
        return 0
    ordered = sorted(nums)
    full = (1 << size) - 1

    @lru_cache(None)
    def cost(mask: int) -> int:
        values = [ordered[index] for index in range(size) if mask >> index & 1]
        return values[-1] - values[0]

    @lru_cache(None)
    def dp(mask: int) -> int:
        if mask == full:
            return 0
        first = 0
        while mask >> first & 1:
            first += 1
        remaining = [index for index in range(first + 1, size) if not mask >> index & 1]
        best = 10**9
        for others in combinations(remaining, group_size - 1):
            group_mask = (1 << first) | sum(1 << index for index in others)
            best = min(best, cost(group_mask) + dp(mask | group_mask))
        return best

    answer = dp(0)
    return -1 if answer >= 10**9 else answer


def longest_prefix(s: str) -> str:
    if not s:
        return s
    size = len(s)
    lps = [0] * size
    for index in range(1, size):
        border = lps[index - 1]
        while border and s[index] != s[border]:
            border = lps[border - 1]
        if s[index] == s[border]:
            border += 1
        lps[index] = border
    return s[: lps[-1]]


def at_most_n_given_digit_set(digits: list[int], n: int) -> int:
    ordered = sorted(digits)
    text = str(n)
    length = len(text)
    count = 0
    for size in range(1, length):
        count += len(ordered) ** size
    for index, character in enumerate(text):
        current = int(character)
        smaller = sum(1 for digit in ordered if digit < current)
        count += smaller * len(ordered) ** (length - index - 1)
        if current not in ordered:
            return count
    return count + 1


def count_special_numbers(n: int) -> int:
    text = str(n)

    @lru_cache(None)
    def dfs(index: int, tight: bool, started: bool, mask: int) -> int:
        if index == len(text):
            return 1 if started else 0
        limit = int(text[index]) if tight else 9
        total = 0
        for digit in range(limit + 1):
            if started and mask >> digit & 1:
                continue
            next_started = started or digit != 0
            next_mask = (mask | 1 << digit) if next_started else 0
            total += dfs(index + 1, tight and digit == limit, next_started, next_mask)
        return total

    return dfs(0, True, False, 0)


def distinct_subseq_ii(s: str) -> int:
    mod = 10**9 + 7
    dp = [1]
    last: dict[str, int] = {}
    for index, character in enumerate(s):
        current = dp[-1] * 2
        if character in last:
            current -= dp[last[character]]
        last[character] = index
        dp.append(current % mod)
    return (dp[-1] - 1) % mod


def is_good_array(nums: list[int]) -> bool:
    common = 0
    for value in nums:
        common = gcd(common, value)
    return common == 1


def make_array_increasing(arr1: list[int], arr2: list[int]) -> int:
    candidates = sorted(set(arr2))
    infinity = 10**9
    if not arr1:
        return 0
    count = len(candidates)
    dp = [infinity] * (count + 1)
    dp[0] = 0
    for index, value in enumerate(arr1):
        next_dp = [infinity] * (count + 1)
        if index == 0:
            next_dp[0] = 0
        elif value > arr1[index - 1]:
            next_dp[0] = dp[0]
        for position in range(1, count + 1):
            if candidates[position - 1] < value:
                next_dp[0] = min(next_dp[0], dp[position])
        prefix = infinity
        for position in range(1, count + 1):
            best = prefix
            if index > 0 and candidates[position - 1] > arr1[index - 1]:
                best = min(best, dp[0])
            if best < infinity:
                next_dp[position] = best + 1
            prefix = min(prefix, dp[position])
        dp = next_dp
        if min(dp) >= infinity:
            return -1
    return min(dp)


def minimum_subarray_or_k(nums: list[int], k: int) -> int:
    best = len(nums) + 1
    previous: list[tuple[int, int]] = []
    for index, value in enumerate(nums):
        current = [(value, index)]
        for or_value, start in previous:
            merged = or_value | value
            if current[-1][0] == merged:
                continue
            current.append((merged, start))
        for or_value, start in current:
            if or_value >= k:
                best = min(best, index - start + 1)
        previous = current
    return best if best <= len(nums) else -1


PROBLEMS = [
    make(
        pid=1480,
        title="访问所有节点的最短路径",
        tags=["位运算", "广度优先搜索", "图", "动态规划"],
        description="""给定无向连通图 graph，节点编号为 0 到 n-1。
返回从任意节点出发、访问所有节点所需的最短路径长度，节点和边可以重复经过。""",
        function="shortestPathAllNodes",
        params=[("graph", "int[][]")],
        returns="int",
        solver=shortest_path_all_nodes,
        public=[
            [[[1, 2, 3], [0], [0], [0]]],
            [[[1], [0, 2], [1, 3], [2]]],
            [[[1], [0, 2, 4], [1, 3, 4], [2], [1, 2]]],
        ],
        hidden=[
            [[[0]]],
            [[[1], [0]]],
            [[[1, 2], [0], [0]]],
            [[[1], [0, 2], [1]]],
        ],
    ),
    make(
        pid=1481,
        title="数组中的逆序对",
        tags=["数组", "归并排序", "分治"],
        description="""给定整数数组 nums，返回数组中逆序对的总数。
逆序对指满足 i < j 且 nums[i] > nums[j] 的下标对。""",
        function="countInversions",
        params=[("nums", "int[]")],
        returns="int",
        solver=count_inversions,
        public=[[[7, 5, 6, 4]], [[1, 2, 3, 4, 5, 6, 7, 0]], [[1, 2, 3]]],
        hidden=[[[1]], [[2, 1]], [[3, 1, 2]], [[5, 4, 3, 2, 1]]],
    ),
    make(
        pid=1482,
        title="等差数列划分 II - 子序列",
        tags=["数组", "动态规划"],
        description="""给定整数数组 nums，返回所有等差子序列的个数。
等差子序列长度至少为 3，子序列按下标选择，不要求连续。""",
        function="numberOfArithmeticSlicesII",
        params=[("nums", "int[]")],
        returns="int",
        solver=number_of_arithmetic_slices_ii,
        public=[[[2, 4, 6, 8, 10]], [[7, 7, 7, 7, 7]], [[1, 2, 3]]],
        hidden=[[[1]], [[1, 3, 5]], [[1, 1, 1]], [[1, 2, 3, 4]]],
    ),
    make(
        pid=1483,
        title="赛车",
        tags=["动态规划", "最短路", "堆"],
        description="""赛车从位置 0、速度 1 出发，目标是到达位置 target。
指令 A：位置增加当前速度，速度翻倍；指令 R：速度变为相反方向。
返回到达目标位置的最少指令数。""",
        function="raceCar",
        params=[("target", "int")],
        returns="int",
        solver=race_car,
        public=[[3], [6], [5]],
        hidden=[[1], [2], [4], [10]],
    ),
    make(
        pid=1484,
        title="猜数字大小 II",
        tags=["数学", "动态规划", "博弈"],
        description="""在 1 到 n 之间选择一个数字，每次猜一个数字，会被告知偏大、偏小或正确。
无论答案是什么数字，返回确保获胜所需的最小现金数（每次猜测支付猜测数字的金额）。""",
        function="getMoneyAmount",
        params=[("n", "int")],
        returns="int",
        solver=get_money_amount,
        public=[[10], [1], [2]],
        hidden=[[3], [4], [5], [20]],
    ),
    make(
        pid=1485,
        title="课程表 III",
        tags=["贪心", "数组", "堆", "排序"],
        description="""给定课程数组 courses，courses[i] = [duration, lastDay]。
每门课需要连续学习 duration 天，且必须在 lastDay 当天或之前完成。返回最多可以修完的课程数。""",
        function="scheduleCourse",
        params=[("courses", "int[][]")],
        returns="int",
        solver=schedule_course,
        public=[
            [[[100, 200], [200, 1300], [1000, 1250], [2000, 3200]]],
            [[[1, 2]]],
            [[[3, 2], [4, 3]]],
        ],
        hidden=[
            [[[1, 2], [2, 3]]],
            [[[5, 5], [4, 6], [2, 2]]],
            [[[1, 1]]],
        ],
    ),
    make(
        pid=1486,
        title="带限制的子序列和",
        tags=["数组", "动态规划", "队列", "滑动窗口", "单调队列"],
        description="""给定整数数组 nums 和整数 k，返回非空子序列的最大和。
子序列中相邻元素的下标差不能超过 k。""",
        function="constrainedSubsetSum",
        params=[("nums", "int[]"), ("k", "int")],
        returns="int",
        solver=constrained_subset_sum,
        public=[
            [[10, 2, -10, 5, 20], 2],
            [[-1, -2, -3], 1],
            [[10, -2, -10, -5, 20], 2],
        ],
        hidden=[
            [[1], 1],
            [[-1], 1],
            [[1, 2, 3], 2],
            [[-2, 1, -3, 4, -1, 2, 1, -5, 4], 2],
        ],
    ),
    make(
        pid=1487,
        title="打砖块",
        tags=["并查集", "数组", "矩阵"],
        description="""给定 m x n 的 0/1 矩阵 grid 和打击位置数组 hits。
每次打击会移除命中位置的砖块，若某砖块与顶部不再连通则掉落。
返回每次打击后掉落的砖块数（不含被打击的砖块）。""",
        function="hitBricks",
        params=[("grid", "int[][]"), ("hits", "int[][]")],
        returns="int[]",
        solver=hit_bricks,
        public=[
            [[[1, 0, 0, 0], [1, 1, 1, 0]], [[1, 0]]],
            [[[1, 0, 0, 0], [1, 1, 0, 0]], [[1, 1], [1, 0]]],
            [[[1, 0, 0, 0], [1, 1, 1, 0]], [[1, 0], [0, 1]]],
        ],
        hidden=[
            [[[1]], [[0, 0]]],
            [[[0]], [[0, 0]]],
            [[[1, 1], [1, 1]], [[0, 0]]],
        ],
    ),
    make(
        pid=1488,
        title="掉落的方块",
        tags=["数组", "线段树", "有序集合"],
        description="""在二维平面中依次掉落正方形方块 positions[i] = [left, sideLength]。
方块从高处垂直落下，落在已有方块或地面上。返回每次掉落后最高的方块顶部高度。""",
        function="fallingSquares",
        params=[("positions", "int[][]")],
        returns="int[]",
        solver=falling_squares,
        public=[
            [[[1, 2], [2, 3], [6, 1]]],
            [[[100, 100], [200, 100]]],
            [[[1, 2], [1, 2]]],
        ],
        hidden=[
            [[[1, 1]]],
            [[[1, 1], [2, 1]]],
            [[[1, 3], [3, 3], [2, 1]]],
        ],
    ),
    make(
        pid=1489,
        title="段式回文",
        tags=["贪心", "双指针", "字符串", "动态规划"],
        description="""给定字符串 text，将其分解成若干段，使第一段与最后一段相同、第二段与倒数第二段相同，依此类推。
返回能分解出的最大段数。""",
        function="longestDecomposition",
        params=[("text", "string")],
        returns="int",
        solver=longest_decomposition,
        public=[["ghiabcdefhelloadamhelloabcdefghi"], ["merchant"], ["antaprezatepzapreanta"]],
        hidden=[["a"], ["aa"], ["ab"], ["aba"], ["aaaa"]],
    ),
    make(
        pid=1490,
        title="生成数组",
        tags=["动态规划", "前缀和"],
        description="""生成一个长度为 n 的数组，每个元素在 1 到 m 之间。
定义搜索代价为从左到右记录严格最大值的次数（最大值变化时加一）。
返回搜索代价恰好为 k 的不同数组个数，模 1e9+7。""",
        function="numOfArrays",
        params=[("n", "int"), ("m", "int"), ("k", "int")],
        returns="int",
        solver=num_of_arrays,
        public=[[2, 3, 1], [3, 3, 2], [2, 3, 2]],
        hidden=[[1, 1, 1], [1, 5, 1], [3, 2, 1], [3, 3, 1]],
    ),
    make(
        pid=1491,
        title="移除盒子",
        tags=["数组", "动态规划", "记忆化搜索"],
        description="""给定整数数组 boxes，每次可以移除连续且颜色相同的 k 个盒子，获得 k * k 分。
返回能获得的最大积分。""",
        function="removeBoxes",
        params=[("boxes", "int[]")],
        returns="int",
        solver=remove_boxes,
        public=[[[1, 3, 2, 2, 2, 3, 4, 3, 1]], [[1, 1, 1]], [[1]]],
        hidden=[[[1, 2]], [[1, 2, 1]], [[2, 2, 2, 2]]],
    ),
    make(
        pid=1492,
        title="最小不兼容性",
        tags=["数组", "动态规划", "位运算"],
        description="""给定整数数组 nums 和整数 k，将 nums 分成 k 个大小相同的子集。
一个子集的不兼容性为子集内最大值与最小值的差。
返回所有子集不兼容性之和的最小值；无法分割返回 -1。""",
        function="minimumIncompatibility",
        params=[("nums", "int[]"), ("k", "int")],
        returns="int",
        solver=minimum_incompatibility,
        public=[
            [[1, 2, 1, 4], 2],
            [[6, 3, 8, 1, 3, 1, 2, 2], 4],
            [[5, 3, 3, 6, 3, 3], 3],
        ],
        hidden=[[[1], 1], [[1, 2], 2], [[1, 2, 3, 4], 2], [[1, 1, 2, 2], 2]],
    ),
    make(
        pid=1493,
        title="最长快乐前缀",
        tags=["字符串", "字符串匹配", "哈希函数"],
        description="""「快乐前缀」指既是原字符串的某个真前缀、又是某个真后缀的字符串。
返回字符串 s 的最长快乐前缀；不存在返回空字符串。""",
        function="longestPrefix",
        params=[("s", "string")],
        returns="string",
        solver=longest_prefix,
        public=[["level"], ["ababab"], ["leetcodeleet"]],
        hidden=[["a"], ["aa"], ["ab"], ["abcabc"], ["aaaa"]],
    ),
    make(
        pid=1494,
        title="最大为 N 的数字组合",
        tags=["数组", "数学", "二分查找", "动态规划"],
        description="""给定非递减的数字数组 digits（元素为 0 到 9 且互不相同），返回用这些数字组成的小于等于 n 的正整数个数。
数字可以重复使用。""",
        function="atMostNGivenDigitSet",
        params=[("digits", "int[]"), ("n", "int")],
        returns="int",
        solver=at_most_n_given_digit_set,
        public=[[[1, 3, 5, 7], 100], [[1, 4, 9], 1000000000], [[7], 8]],
        hidden=[[[1], 1], [[1], 9], [[9], 10], [[1, 2], 20]],
    ),
    make(
        pid=1495,
        title="统计特殊整数",
        tags=["数学", "动态规划", "位运算"],
        description="""如果一个正整数的每个数位都互不相同，则称为特殊整数。
给定 n，返回区间 [1, n] 内特殊整数的个数。""",
        function="countSpecialNumbers",
        params=[("n", "int")],
        returns="int",
        solver=count_special_numbers,
        public=[[20], [5], [135]],
        hidden=[[1], [9], [10], [100], [999]],
    ),
    make(
        pid=1496,
        title="不同的子序列 II",
        tags=["字符串", "动态规划"],
        description="""给定字符串 s，返回 s 的不同非空子序列的个数，模 1e9+7。
子序列由删除部分字符（可以不删除）得到。""",
        function="distinctSubseqII",
        params=[("s", "string")],
        returns="int",
        solver=distinct_subseq_ii,
        public=[["abc"], ["aba"], ["aaa"]],
        hidden=[["a"], ["ab"], ["aa"], ["abab"]],
    ),
    make(
        pid=1497,
        title="检查「好数组」",
        tags=["数组", "数学", "数论"],
        description="""给定正整数数组 nums，如果存在一个非空子集，其元素的最大公约数为 1，则该数组是「好数组」。
返回 nums 是否为好数组。""",
        function="isGoodArray",
        params=[("nums", "int[]")],
        returns="bool",
        solver=is_good_array,
        public=[[[12, 5, 7, 23]], [[29, 6, 10]], [[3, 6]]],
        hidden=[[[1]], [[2]], [[2, 4]], [[6, 10, 15]]],
    ),
    make(
        pid=1498,
        title="使数组严格递增",
        tags=["数组", "二分查找", "动态规划", "排序"],
        description="""给定整数数组 arr1 和 arr2，可以将 arr1 中的任意元素替换为 arr2 中的任意元素。
每次替换计一次操作。返回使 arr1 严格递增的最少操作数；无法做到返回 -1。""",
        function="makeArrayIncreasing",
        params=[("arr1", "int[]"), ("arr2", "int[]")],
        returns="int",
        solver=make_array_increasing,
        public=[
            [[1, 5, 3, 6, 7], [1, 3, 2, 4]],
            [[1, 5, 3, 6, 7], [4, 3, 1]],
            [[1, 5, 3, 6, 7], [1, 6, 3, 3]],
        ],
        hidden=[
            [[1], [1]],
            [[2, 1], [1, 2]],
            [[5, 4, 3], [1, 2, 3]],
            [[1, 2, 3], []],
        ],
    ),
    make(
        pid=1499,
        title="或值至少为 K 的最短子数组 II",
        tags=["数组", "位运算", "滑动窗口"],
        description="""给定整数数组 nums 和整数 k，返回按位或值至少为 k 的最短非空子数组长度。
不存在这样的子数组返回 -1。""",
        function="minimumSubarrayOR",
        params=[("nums", "int[]"), ("k", "int")],
        returns="int",
        solver=minimum_subarray_or_k,
        public=[[[1, 2, 3], 2], [[2, 1, 8], 10], [[1, 2], 0]],
        hidden=[[[1], 1], [[1], 2], [[2, 2, 2], 2], [[3, 1, 2], 4]],
    ),
]
