"""1660-1679：批量第二批困难题（20 道）。"""

from __future__ import annotations

import bisect
import heapq
from collections import deque
from fractions import Fraction
from functools import partial

from problem_seed_common import make_problem

make = partial(make_problem, difficulty="hard")


def calculate_minimum_hp(dungeon: list[list[int]]) -> int:
    rows, columns = len(dungeon), len(dungeon[0])
    infinity = 10**18
    dp = [[infinity] * (columns + 1) for _ in range(rows + 1)]
    dp[rows][columns - 1] = 1
    dp[rows - 1][columns] = 1
    for row in range(rows - 1, -1, -1):
        for column in range(columns - 1, -1, -1):
            best = min(dp[row + 1][column], dp[row][column + 1])
            dp[row][column] = max(1, best - dungeon[row][column])
    return dp[0][0]


def min_patches(nums: list[int], n: int) -> int:
    missing = 1
    patches = 0
    index = 0
    while missing <= n:
        if index < len(nums) and nums[index] <= missing:
            missing += nums[index]
            index += 1
        else:
            missing += missing
            patches += 1
    return patches


def max_sum_submatrix(matrix: list[list[int]], k: int) -> int:
    rows, columns = len(matrix), len(matrix[0])
    best = -10**18
    for top in range(rows):
        column_sums = [0] * columns
        for bottom in range(top, rows):
            for column in range(columns):
                column_sums[column] += matrix[bottom][column]
            prefix = 0
            sorted_prefixes = [0]
            for value in column_sums:
                prefix += value
                position = bisect.bisect_left(sorted_prefixes, prefix - k)
                if position < len(sorted_prefixes):
                    best = max(best, prefix - sorted_prefixes[position])
                bisect.insort(sorted_prefixes, prefix)
    return best


def is_rectangle_cover(rectangles: list[list[int]]) -> bool:
    if not rectangles:
        return False
    area = 0
    min_x = min_y = 10**18
    max_x = max_y = -10**18
    corners: set[tuple[int, int]] = set()
    for x1, y1, x2, y2 in rectangles:
        area += (x2 - x1) * (y2 - y1)
        min_x = min(min_x, x1)
        min_y = min(min_y, y1)
        max_x = max(max_x, x2)
        max_y = max(max_y, y2)
        for point in ((x1, y1), (x1, y2), (x2, y1), (x2, y2)):
            if point in corners:
                corners.remove(point)
            else:
                corners.add(point)
    if area != (max_x - min_x) * (max_y - min_y):
        return False
    expected = {
        (min_x, min_y),
        (min_x, max_y),
        (max_x, min_y),
        (max_x, max_y),
    }
    return corners == expected


def poor_pigs(buckets: int, minutes_to_die: int, minutes_to_test: int) -> int:
    base = minutes_to_test // minutes_to_die + 1
    pigs = 0
    total = 1
    while total < buckets:
        total *= base
        pigs += 1
    return pigs


def find_all_concatenated_words(words: list[str]) -> list[str]:
    word_set = set(words)
    result: list[str] = []
    for word in words:
        size = len(word)
        reachable = [False] * (size + 1)
        reachable[0] = True
        for start in range(size):
            if not reachable[start]:
                continue
            for end in range(start + 1, size + 1):
                if end - start < size and word[start:end] in word_set:
                    reachable[end] = True
        if reachable[size]:
            result.append(word)
    return sorted(result)


def largest_palindrome_product(n: int) -> int:
    if n == 1:
        return 9
    upper = 10**n - 1
    lower = 10 ** (n - 1)
    for half in range(upper, lower - 1, -1):
        text = str(half)
        palindrome = int(text + text[::-1])
        factor = upper
        while factor * factor >= palindrome:
            if palindrome % factor == 0:
                other = palindrome // factor
                if lower <= other <= upper:
                    return palindrome
            factor -= 1
    return -1


def find_maximized_capital(
    k: int, w: int, profits: list[int], capital: list[int]
) -> int:
    projects = sorted(zip(capital, profits))
    available: list[int] = []
    index = 0
    for _ in range(k):
        while index < len(projects) and projects[index][0] <= w:
            heapq.heappush(available, -projects[index][1])
            index += 1
        if not available:
            break
        w += -heapq.heappop(available)
    return w


def find_rotate_steps(ring: str, key: str) -> int:
    positions: dict[str, list[int]] = {}
    for index, character in enumerate(ring):
        positions.setdefault(character, []).append(index)
    size = len(ring)
    cost = {position: min(position, size - position) + 1 for position in positions[key[0]]}
    for character in key[1:]:
        next_cost: dict[int, int] = {}
        for position in positions[character]:
            best = 10**18
            for previous, previous_cost in cost.items():
                distance = abs(position - previous)
                distance = min(distance, size - distance)
                best = min(best, previous_cost + distance + 1)
            next_cost[position] = best
        cost = next_cost
    return min(cost.values())


def find_min_moves(machines: list[int]) -> int:
    total = sum(machines)
    size = len(machines)
    if total % size:
        return -1
    average = total // size
    answer = 0
    balance = 0
    for value in machines:
        difference = value - average
        balance += difference
        answer = max(answer, abs(balance), difference)
    return answer


def smallest_range(nums: list[list[int]]) -> list[int]:
    heap: list[tuple[int, int, int]] = []
    current_max = -10**18
    for index, array in enumerate(nums):
        heapq.heappush(heap, (array[0], index, 0))
        current_max = max(current_max, array[0])
    best = [-10**18, 10**18]
    while True:
        value, index, position = heapq.heappop(heap)
        if current_max - value < best[1] - best[0]:
            best = [value, current_max]
        if position + 1 == len(nums[index]):
            break
        next_value = nums[index][position + 1]
        heapq.heappush(heap, (next_value, index, position + 1))
        current_max = max(current_max, next_value)
    return best


def judge_point24(cards: list[int]) -> bool:
    def search(values: list[Fraction]) -> bool:
        size = len(values)
        if size == 1:
            return values[0] == 24
        for first in range(size):
            for second in range(size):
                if first == second:
                    continue
                rest = [
                    values[index]
                    for index in range(size)
                    if index != first and index != second
                ]
                left, right = values[first], values[second]
                candidates = [left + right, left - right, left * right]
                if right != 0:
                    candidates.append(left / right)
                for candidate in candidates:
                    if search(rest + [candidate]):
                        return True
        return False

    return search([Fraction(card) for card in cards])


def max_sum_of_three_subarrays(nums: list[int], k: int) -> list[int]:
    size = len(nums)
    prefix = [0] * (size + 1)
    for index, value in enumerate(nums):
        prefix[index + 1] = prefix[index] + value

    left = [0] * size
    best_sum = -10**18
    best_index = 0
    for start in range(size - k + 1):
        total = prefix[start + k] - prefix[start]
        if total > best_sum:
            best_sum = total
            best_index = start
        left[start] = best_index

    right = [0] * size
    best_sum = -10**18
    best_index = size - k
    for start in range(size - k, -1, -1):
        total = prefix[start + k] - prefix[start]
        if total >= best_sum:
            best_sum = total
            best_index = start
        right[start] = best_index

    best_total = -10**18
    best_triple = (0, 0, 0)
    for middle in range(k, size - 2 * k + 1):
        first = left[middle - k]
        third = right[middle + k]
        total = (
            prefix[first + k]
            - prefix[first]
            + prefix[middle + k]
            - prefix[middle]
            + prefix[third + k]
            - prefix[third]
        )
        triple = (first, middle, third)
        if total > best_total or (total == best_total and triple < best_triple):
            best_total = total
            best_triple = triple
    return list(best_triple)


def cherry_pickup(grid: list[list[int]]) -> int:
    size = len(grid)
    if grid[0][0] == -1 or grid[size - 1][size - 1] == -1:
        return 0
    negative = -10**9
    dp = [[negative] * size for _ in range(size)]
    dp[0][0] = grid[0][0]
    for step in range(1, 2 * size - 1):
        next_dp = [[negative] * size for _ in range(size)]
        low = max(0, step - (size - 1))
        high = min(size - 1, step)
        for row1 in range(low, high + 1):
            column1 = step - row1
            if grid[row1][column1] == -1:
                continue
            for row2 in range(low, high + 1):
                column2 = step - row2
                if grid[row2][column2] == -1:
                    continue
                previous = dp[row1][row2]
                if row1 > 0:
                    previous = max(previous, dp[row1 - 1][row2])
                if row2 > 0:
                    previous = max(previous, dp[row1][row2 - 1])
                if row1 > 0 and row2 > 0:
                    previous = max(previous, dp[row1 - 1][row2 - 1])
                if previous == negative:
                    continue
                gain = grid[row1][column1]
                if row1 != row2 or column1 != column2:
                    gain += grid[row2][column2]
                next_dp[row1][row2] = previous + gain
        dp = next_dp
    return max(0, dp[size - 1][size - 1])


def intersection_size_two(intervals: list[list[int]]) -> int:
    ordered = sorted(intervals, key=lambda item: (item[1], item[0]))
    points: list[int] = []
    answer = 0
    for start, end in ordered:
        inside = [point for point in points if start <= point <= end]
        added = 0
        candidate = end
        while len(inside) + added < 2:
            if candidate not in points:
                points.append(candidate)
                answer += 1
                added += 1
            candidate -= 1
        points.sort()
        points = points[-2:]
    return answer


def min_swaps_couples(row: list[int]) -> int:
    couples = len(row) // 2
    parent = list(range(couples))

    def find(node: int) -> int:
        while parent[node] != node:
            parent[node] = parent[parent[node]]
            node = parent[node]
        return node

    for index in range(0, len(row), 2):
        first = find(row[index] // 2)
        second = find(row[index + 1] // 2)
        if first != second:
            parent[first] = second
    return couples - len({find(node) for node in range(couples)})


def max_chunks_to_sorted(arr: list[int]) -> int:
    size = len(arr)
    suffix_min = [0] * size
    suffix_min[-1] = arr[-1]
    for index in range(size - 2, -1, -1):
        suffix_min[index] = min(arr[index], suffix_min[index + 1])
    chunks = 0
    prefix_max = -10**18
    for index in range(size):
        prefix_max = max(prefix_max, arr[index])
        if index == size - 1 or prefix_max <= suffix_min[index + 1]:
            chunks += 1
    return chunks


def num_buses_to_destination(
    routes: list[list[int]], source: int, target: int
) -> int:
    if source == target:
        return 0
    stop_to_routes: dict[int, list[int]] = {}
    for index, route in enumerate(routes):
        for stop in route:
            stop_to_routes.setdefault(stop, []).append(index)
    visited_routes: set[int] = set()
    visited_stops = {source}
    queue = deque([(source, 0)])
    while queue:
        stop, buses = queue.popleft()
        if stop == target:
            return buses
        for route_index in stop_to_routes.get(stop, []):
            if route_index in visited_routes:
                continue
            visited_routes.add(route_index)
            for next_stop in routes[route_index]:
                if next_stop == target:
                    return buses + 1
                if next_stop not in visited_stops:
                    visited_stops.add(next_stop)
                    queue.append((next_stop, buses + 1))
    return -1


def largest_island(grid: list[list[int]]) -> int:
    size = len(grid)
    work = [row[:] for row in grid]
    sizes: dict[int, int] = {}
    label = 2
    directions = ((1, 0), (-1, 0), (0, 1), (0, -1))

    def explore(row: int, column: int) -> int:
        stack = [(row, column)]
        work[row][column] = label
        count = 0
        while stack:
            current_row, current_column = stack.pop()
            count += 1
            for delta_row, delta_column in directions:
                next_row = current_row + delta_row
                next_column = current_column + delta_column
                if (
                    0 <= next_row < size
                    and 0 <= next_column < size
                    and work[next_row][next_column] == 1
                ):
                    work[next_row][next_column] = label
                    stack.append((next_row, next_column))
        return count

    for row in range(size):
        for column in range(size):
            if work[row][column] == 1:
                sizes[label] = explore(row, column)
                label += 1

    has_zero = False
    best = 0
    for row in range(size):
        for column in range(size):
            if work[row][column] != 0:
                continue
            has_zero = True
            nearby: set[int] = set()
            for delta_row, delta_column in directions:
                next_row = row + delta_row
                next_column = column + delta_column
                if 0 <= next_row < size and 0 <= next_column < size:
                    value = work[next_row][next_column]
                    if value > 1:
                        nearby.add(value)
            best = max(best, 1 + sum(sizes[item] for item in nearby))
    if not has_zero:
        return size * size
    return best


def sum_of_distances_in_tree(n: int, edges: list[list[int]]) -> list[int]:
    graph: list[list[int]] = [[] for _ in range(n)]
    for first, second in edges:
        graph[first].append(second)
        graph[second].append(first)
    parent = [-1] * n
    parent[0] = -2
    order = [0]
    for node in order:
        for neighbor in graph[node]:
            if parent[neighbor] == -1:
                parent[neighbor] = node
                order.append(neighbor)
    depth = [0] * n
    for node in order:
        for neighbor in graph[node]:
            if parent[neighbor] == node:
                depth[neighbor] = depth[node] + 1
    subtree = [1] * n
    for node in reversed(order):
        for neighbor in graph[node]:
            if parent[neighbor] == node:
                subtree[node] += subtree[neighbor]
    answer = [0] * n
    answer[0] = sum(depth)
    for node in order:
        for neighbor in graph[node]:
            if parent[neighbor] == node:
                answer[neighbor] = answer[node] + n - 2 * subtree[neighbor]
    return answer


PROBLEMS = [
    make(
        pid=1660,
        title="地下城游戏",
        tags=["动态规划", "矩阵"],
        description="""给定一个 m x n 的整数矩阵 dungeon，表示地下城的房间。骑士从左上角 (0, 0) 出发，每次只能向右或向下移动，最终到达右下角 (m-1, n-1) 救出公主。
矩阵中的数值含义：负数表示进入该房间失去相应生命值，正数表示获得相应生命值，0 表示没有变化。骑士在任意时刻的生命值必须严格大于 0，否则立即死亡。
返回骑士能够完成旅程所需的最小初始生命值。""",
        function="calculateMinimumHP",
        params=[("dungeon", "int[][]")],
        returns="int",
        solver=calculate_minimum_hp,
        public=[
            [[[-2, -3, 3], [-5, -10, 1], [10, 30, -5]]],
            [[[0]]],
            [[[1, -3, 3], [-3, -3, -3], [3, -3, 0]]],
        ],
        hidden=[
            [[[-3]]],
            [[[2]]],
            [[[-1, -2], [-3, -4]]],
            [[[0, -1]]],
            [[[1, -2, 3], [2, -2, -2]]],
            [[[-2, -3], [-4, -5]]],
        ],
    ),
    make(
        pid=1661,
        title="按要求补齐数组",
        tags=["贪心", "数组"],
        description="""给定一个按升序排列的正整数数组 nums 和一个正整数 n。每个数组元素最多使用一次，可以任取子集求和。
如果 [1, n] 内的某些整数无法由当前数组表示，可以向数组中添加任意正整数。返回使 [1, n] 内所有整数都能被表示所需添加的最少元素个数。""",
        function="minPatches",
        params=[("nums", "int[]"), ("n", "int")],
        returns="int",
        solver=min_patches,
        public=[
            [[1, 3], 6],
            [[1, 5, 10], 20],
            [[1, 2, 2], 5],
        ],
        hidden=[
            [[1], 2],
            [[2], 3],
            [[1, 2, 4, 13, 43], 100],
            [[1, 2, 2], 7],
            [[100], 50],
            [[1, 2, 31, 33], 100],
        ],
    ),
    make(
        pid=1662,
        title="矩形区域不超过 K 的最大数值和",
        tags=["数组", "前缀和", "二分查找"],
        description="""给定一个 m x n 的整数矩阵 matrix 和一个整数 k。要求选出矩阵中一个至少包含一个元素的矩形区域，使其元素和不超过 k 且尽可能大。
返回这个最大元素和。数据保证至少存在一个元素和不超过 k 的矩形区域。""",
        function="maxSumSubmatrix",
        params=[("matrix", "int[][]"), ("k", "int")],
        returns="int",
        solver=max_sum_submatrix,
        public=[
            [[[1, 0, 1], [0, -2, 3]], 2],
            [[[2, 2, -1]], 3],
            [[[1]], 1],
        ],
        hidden=[
            [[[-2, -3]], 3],
            [[[2, 2, -1]], 0],
            [[[5, -4], [-3, 2]], 2],
            [[[1, 2], [-2, 3]], 2],
            [[[-1, -2], [-3, -4]], -3],
            [[[2, -2], [-2, 2]], 0],
        ],
    ),
    make(
        pid=1663,
        title="完美矩形",
        tags=["几何", "哈希表"],
        description="""给定整数数组 rectangles，其中 rectangles[i] = [x1, y1, x2, y2] 表示一个左下角为 (x1, y1)、右上角为 (x2, y2) 的矩形。
判断这些矩形能否恰好覆盖一个完整的矩形区域，要求区域内部既没有重叠也没有空隙。能恰好覆盖返回 true，否则返回 false。""",
        function="isRectangleCover",
        params=[("rectangles", "int[][]")],
        returns="bool",
        solver=is_rectangle_cover,
        public=[
            [[[0, 0, 1, 1], [1, 0, 2, 1], [0, 1, 1, 2], [1, 1, 2, 2]]],
            [[[0, 0, 3, 1], [0, 1, 3, 2], [0, 2, 3, 3]]],
            [[[0, 0, 1, 1], [1, 0, 2, 1], [0, 1, 1, 2]]],
            [[[0, 0, 2, 2], [0, 0, 1, 1], [1, 1, 2, 2]]],
        ],
        hidden=[
            [[[0, 0, 1, 1]]],
            [[[0, 0, 1, 1], [0, 0, 1, 1]]],
            [[[0, 0, 1, 2], [1, 0, 2, 2]]],
            [[[0, 0, 1, 1], [1, 0, 2, 1], [0, 1, 2, 2]]],
            [[[1, 1, 3, 3], [1, 1, 3, 3]]],
        ],
    ),
    make(
        pid=1664,
        title="可怜的小猪",
        tags=["数学", "思维"],
        description="""有 buckets 桶液体，其中恰好一桶有毒，其余无毒。你可以在 minutesToTest 分钟内进行若干轮测试，每轮测试中每只猪可以饮用任意多桶液体，也可以将多桶液体混合后饮用。
猪一旦饮下毒液，会在 minutesToDie 分钟后死亡。保证 minutesToTest 不小于 minutesToDie。
返回在限定时间内确定哪一桶有毒所需的最少猪的数量。""",
        function="poorPigs",
        params=[("buckets", "int"), ("minutesToDie", "int"), ("minutesToTest", "int")],
        returns="int",
        solver=poor_pigs,
        public=[
            [1000, 15, 60],
            [4, 15, 15],
            [4, 15, 30],
        ],
        hidden=[
            [1, 1, 1],
            [2, 1, 1],
            [125, 1, 4],
            [100, 1, 2],
            [10, 1, 10],
            [1000, 1, 1],
        ],
    ),
    make(
        pid=1665,
        title="连接词",
        tags=["字符串", "动态规划", "字典树"],
        description="""给定一个不含重复单词的字符串数组 words。若某个单词可以完全拆分成数组中另外两个或更多单词的连接，其中每个单词可以使用任意多次，则称它为连接词。
返回 words 中所有连接词，按字典序升序排列。""",
        function="findAllConcatenatedWords",
        params=[("words", "string[]")],
        returns="string[]",
        solver=find_all_concatenated_words,
        public=[
            [["cat", "cats", "catsdogcats", "dog", "dogcatsdog", "hippopotamuses", "rat", "ratcatdogcat"]],
            [["cat", "dog", "catdog"]],
            [["a", "b", "ab", "abc"]],
        ],
        hidden=[
            [["a"]],
            [["a", "aa", "aaa"]],
            [["a", "b", "c", "ab", "bc", "abc"]],
            [["x", "xy", "xyz"]],
            [["a", "aa", "aab"]],
            [["ab", "abc", "abcd", "a", "b", "c", "d"]],
        ],
    ),
    make(
        pid=1666,
        title="最大回文数乘积",
        tags=["数学", "枚举"],
        description="""给定整数 n，返回由两个 n 位正整数相乘能够得到的最大的回文整数。
结果返回精确值，不取模。n 的取值范围是 1 到 7。""",
        function="largestPalindromeProduct",
        params=[("n", "int")],
        returns="long",
        solver=largest_palindrome_product,
        public=[[1], [2], [3]],
        hidden=[[4], [5], [6], [7]],
    ),
    make(
        pid=1667,
        title="项目资本最大化",
        tags=["贪心", "堆", "排序"],
        description="""给定最多可选择的项目数 k、初始资本 w、每个项目的利润 profits[i] 和启动该项目所需的最低资本 capital[i]。
每完成一个项目，其利润会累加到当前资本中。项目可以按任意顺序选择，但每个项目最多完成一次，且选择时当前资本必须不少于该项目的启动资本。
返回最多完成 k 个项目后能获得的最大资本。""",
        function="findMaximizedCapital",
        params=[
            ("k", "int"),
            ("w", "int"),
            ("profits", "int[]"),
            ("capital", "int[]"),
        ],
        returns="int",
        solver=find_maximized_capital,
        public=[
            [2, 0, [1, 2, 3], [0, 1, 1]],
            [3, 0, [1, 2, 3], [0, 1, 2]],
            [2, 1, [3, 4], [1, 2]],
        ],
        hidden=[
            [1, 2, [5], [3]],
            [1, 0, [1], [2]],
            [2, 0, [1, 2], [0, 0]],
            [10, 5, [2, 3], [0, 0]],
            [3, 0, [1, 1, 1], [0, 1, 2]],
            [0, 5, [1, 2, 3], [0, 0, 0]],
        ],
    ),
    make(
        pid=1668,
        title="自由之路",
        tags=["字符串", "动态规划"],
        description="""圆环上按顺时针方向排列着字符串 ring 中的字符，第一个字符与最后一个字符相邻。指针初始指向 ring 的第一个字符。
每一步可以将圆环顺时针或逆时针旋转一格，或者按下按钮输入指针当前指向的字符。给定目标字符串 key，返回按顺序输入整个 key 所需的最少步数，按一次按钮计 1 步。""",
        function="findRotateSteps",
        params=[("ring", "string"), ("key", "string")],
        returns="int",
        solver=find_rotate_steps,
        public=[
            ["godding", "gd"],
            ["godding", "godding"],
            ["abc", "abc"],
        ],
        hidden=[
            ["a", "a"],
            ["abcde", "ade"],
            ["godding", "dog"],
            ["aaa", "aaaa"],
            ["abcabc", "abc"],
        ],
    ),
    make(
        pid=1669,
        title="超级洗衣机",
        tags=["贪心", "数组"],
        description="""有 n 台超级洗衣机排成一排，第 i 台初始有 machines[i] 件衣服。
每一步可以选择任意多台洗衣机，每台向其相邻的一台洗衣机传递一件衣服；同一台洗衣机在一步内最多送出一件衣服。
通过若干步使所有洗衣机的衣服数量相等，返回所需的最少步数。无法做到时返回 -1。""",
        function="findMinMoves",
        params=[("machines", "int[]")],
        returns="int",
        solver=find_min_moves,
        public=[
            [[1, 0, 5]],
            [[0, 3, 0]],
            [[0, 2, 0]],
        ],
        hidden=[
            [[4, 0, 0, 4]],
            [[1, 1, 1]],
            [[9, 1, 8, 8, 9]],
            [[0, 0, 3, 0, 0]],
            [[2, 2, 2, 2]],
            [[5, 5, 5]],
        ],
    ),
    make(
        pid=1670,
        title="最小区间",
        tags=["堆", "滑动窗口"],
        description="""给定 k 个按升序排列的整数数组 nums。找到一个最小区间 [a, b]，使得每个数组中都至少有一个整数落在该区间内。
区间长度定义为 b - a。若有多个长度相同的区间，返回起点 a 较小的那个。返回 [a, b]。""",
        function="smallestRange",
        params=[("nums", "int[][]")],
        returns="int[]",
        solver=smallest_range,
        public=[
            [[[4, 10, 15, 24, 26], [0, 9, 12, 20], [5, 18, 22, 30]]],
            [[[1, 2, 3], [1, 2, 3], [1, 2, 3]]],
            [[[10], [11]]],
        ],
        hidden=[
            [[[1, 4, 7], [2, 5, 8]]],
            [[[0, 10], [1, 2]]],
            [[[1, 5, 9], [2, 6, 10], [3, 7, 11]]],
            [[[1], [1], [1]]],
            [[[1, 2, 3], [4, 5, 6], [7, 8, 9]]],
        ],
    ),
    make(
        pid=1671,
        title="24 点游戏",
        tags=["回溯", "数学"],
        description="""给定 4 张写有整数的卡片，判断能否使用加、减、乘、除四种运算和括号，将 4 张卡片各使用恰好一次，计算出 24。
除法为实数除法，过程中不会出现除以 0 的情况。能得到 24 返回 true，否则返回 false。""",
        function="judgePoint24",
        params=[("cards", "int[]")],
        returns="bool",
        solver=judge_point24,
        public=[
            [[4, 1, 8, 7]],
            [[1, 2, 1, 2]],
            [[3, 3, 8, 8]],
        ],
        hidden=[
            [[1, 1, 1, 1]],
            [[6, 1, 3, 4]],
            [[5, 5, 5, 1]],
            [[2, 2, 2, 2]],
            [[8, 8, 8, 8]],
            [[8, 8, 3, 3]],
        ],
    ),
    make(
        pid=1672,
        title="三个无重叠子数组的最大和",
        tags=["动态规划", "数组"],
        description="""给定整数数组 nums 和整数 k。选择三个长度为 k、互不重叠的连续子数组，使它们的元素和最大。
返回三个子数组的起始下标 [i, j, l]，满足 i < j < l。若有多种方案得到相同的最大和，返回字典序最小的下标组合。""",
        function="maxSumOfThreeSubarrays",
        params=[("nums", "int[]"), ("k", "int")],
        returns="int[]",
        solver=max_sum_of_three_subarrays,
        public=[
            [[1, 2, 1, 2, 6, 7, 5, 1], 2],
            [[1, 2, 1, 2, 1, 2, 1, 2, 1], 2],
            [[4, 5, 6, 1, 2], 1],
        ],
        hidden=[
            [[1, 1, 1, 1, 1, 1], 1],
            [[1, 2, 3, 4, 5, 6], 2],
            [[7, 5, 3, 2, 1], 1],
            [[-1, -2, -3, -4, -5, -6], 2],
            [[2, 1, 3, 1, 2, 1, 3, 1, 2], 2],
        ],
    ),
    make(
        pid=1673,
        title="摘樱桃",
        tags=["动态规划", "矩阵"],
        description="""给定一个 n x n 的整数矩阵 grid，0 表示空地，1 表示有一个樱桃，-1 表示障碍。
你从左上角出发，每次向右或向下移动到达右下角；再从右下角出发，每次向左或向上移动回到左上角。经过有樱桃的格子时摘走樱桃，每个樱桃只能摘一次。
起点或终点有障碍时无法完成往返。返回最多能摘到的樱桃数量。""",
        function="cherryPickup",
        params=[("grid", "int[][]")],
        returns="int",
        solver=cherry_pickup,
        public=[
            [[[0, 1, -1], [1, 0, -1], [1, 1, 1]]],
            [[[1, 1, -1], [1, -1, 1], [-1, 1, 1]]],
            [[[1]]],
        ],
        hidden=[
            [[[0]]],
            [[[-1]]],
            [[[0, -1], [1, 0]]],
            [[[1, 0], [0, 1]]],
            [[[0, 1, 1], [1, 1, 1], [1, 1, 0]]],
            [[[1, 1], [1, 1]]],
        ],
    ),
    make(
        pid=1674,
        title="设置交集大小至少为二",
        tags=["贪心", "数组"],
        description="""给定二维整数数组 intervals，其中 intervals[i] = [start, end] 表示一个闭区间。
需要选择一个整数集合 S，使每个区间中至少有两个 S 中的元素。返回 S 的最小大小。
题目保证每个区间满足 start < end，因此一定存在可行解。""",
        function="intersectionSizeTwo",
        params=[("intervals", "int[][]")],
        returns="int",
        solver=intersection_size_two,
        public=[
            [[[1, 3], [3, 7], [8, 9]]],
            [[[1, 3], [1, 4], [2, 5], [3, 5]]],
            [[[1, 2], [2, 3], [3, 4]]],
        ],
        hidden=[
            [[[1, 2]]],
            [[[1, 4], [2, 3]]],
            [[[1, 5], [2, 6], [3, 7]]],
            [[[0, 2], [1, 3], [2, 4], [3, 5]]],
            [[[10, 20], [10, 20]]],
        ],
    ),
    make(
        pid=1675,
        title="情侣牵手",
        tags=["并查集", "数组"],
        description="""有 n 对情侣坐在一排共 2n 个座位上，座位编号从 0 到 2n-1。第 i 对情侣的两人编号分别为 2i 和 2i+1。
数组 row 按座位顺序给出每个人编号。每一步可以选择任意两个人交换座位。返回使每对情侣都相邻而坐所需的最少交换次数。""",
        function="minSwapsCouples",
        params=[("row", "int[]")],
        returns="int",
        solver=min_swaps_couples,
        public=[
            [[0, 2, 1, 3]],
            [[3, 2, 0, 1]],
            [[0, 2, 4, 1, 3, 5]],
        ],
        hidden=[
            [[0, 1]],
            [[1, 0]],
            [[0, 3, 1, 2]],
            [[0, 4, 1, 5, 2, 3]],
            [[5, 4, 2, 3, 1, 0]],
            [[0, 2, 1, 3, 4, 6, 5, 7]],
        ],
    ),
    make(
        pid=1676,
        title="最多能完成排序的块 II",
        tags=["栈", "数组", "排序"],
        description="""给定整数数组 arr。把数组切分成若干个连续块，对每个块单独排序后，按原顺序拼接，结果恰好等于整个数组升序排序后的结果。
返回最多可以切分成多少个块。""",
        function="maxChunksToSorted",
        params=[("arr", "int[]")],
        returns="int",
        solver=max_chunks_to_sorted,
        public=[
            [[5, 4, 3, 2, 1]],
            [[2, 1, 3, 4, 4]],
            [[1, 1, 0, 0, 1]],
        ],
        hidden=[
            [[1, 2, 3, 4]],
            [[4, 3, 2, 1]],
            [[1, 0, 2, 3, 4]],
            [[1, 1, 1, 1]],
            [[0, 0, 1, 1]],
            [[0, 2, 1, 3]],
        ],
    ),
    make(
        pid=1677,
        title="公交路线",
        tags=["广度优先搜索", "图"],
        description="""给定公交路线数组 routes，其中 routes[i] 是第 i 辆公交车循环经过的站点列表，同一辆公交车会沿该列表不断循环运行。
你从站点 source 出发，只能通过乘坐公交车移动，每乘坐一辆新的公交车计一次乘车。返回到达站点 target 所需的最少乘车次数；无法到达则返回 -1。起点与终点相同时乘车次数为 0。""",
        function="numBusesToDestination",
        params=[("routes", "int[][]"), ("source", "int"), ("target", "int")],
        returns="int",
        solver=num_buses_to_destination,
        public=[
            [[[1, 2, 7], [3, 6, 7]], 1, 6],
            [[[1, 2, 3], [3, 4, 5]], 1, 5],
            [[[1, 2, 3]], 1, 3],
        ],
        hidden=[
            [[[1, 2]], 1, 1],
            [[[1, 2]], 3, 1],
            [[[1, 2], [2, 3], [3, 4]], 1, 4],
            [[[1, 2, 3, 4]], 1, 4],
            [[[1], [2]], 1, 2],
            [[[1, 2], [3, 4]], 1, 4],
        ],
    ),
    make(
        pid=1678,
        title="最大人工岛",
        tags=["深度优先搜索", "并查集", "矩阵"],
        description="""给定一个 n x n 的二进制矩阵 grid，1 表示陆地，0 表示海洋。你最多可以将一个 0 变成 1，也可以不做任何改变。
返回操作后可能得到的最大岛屿面积。岛屿由上下左右四个方向相连的 1 组成。""",
        function="largestIsland",
        params=[("grid", "int[][]")],
        returns="int",
        solver=largest_island,
        public=[
            [[[1, 0], [0, 1]]],
            [[[1, 1], [1, 0]]],
            [[[1, 1], [1, 1]]],
        ],
        hidden=[
            [[[0]]],
            [[[1]]],
            [[[0, 0], [0, 0]]],
            [[[1, 0, 1], [0, 0, 0], [1, 0, 1]]],
            [[[1, 1, 0], [1, 0, 0], [0, 0, 0]]],
            [[[1, 1, 1], [1, 0, 1], [1, 1, 1]]],
        ],
    ),
    make(
        pid=1679,
        title="树中距离之和",
        tags=["树", "深度优先搜索", "动态规划"],
        description="""给定一棵有 n 个节点的无向树，节点编号从 0 到 n-1。edges[i] = [a, b] 表示节点 a 与节点 b 之间有一条边。
返回长度为 n 的数组 answer，其中 answer[i] 是节点 i 到其余所有节点的距离之和。节点 i 到节点 j 的距离定义为连接两点的最短路径上的边数。""",
        function="sumOfDistancesInTree",
        params=[("n", "int"), ("edges", "int[][]")],
        returns="int[]",
        solver=sum_of_distances_in_tree,
        public=[
            [6, [[0, 1], [0, 2], [2, 3], [2, 4], [2, 5]]],
            [1, []],
            [2, [[0, 1]]],
        ],
        hidden=[
            [3, [[0, 1], [1, 2]]],
            [4, [[0, 1], [0, 2], [0, 3]]],
            [5, [[0, 1], [1, 2], [2, 3], [3, 4]]],
            [7, [[0, 1], [1, 2], [2, 3], [3, 4], [4, 5], [5, 6]]],
        ],
    ),
]
