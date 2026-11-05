"""1417-1459：批量第一批中等题（43 道）。"""

from __future__ import annotations

import heapq
from collections import Counter, deque
from functools import partial
from itertools import combinations, permutations

from problem_seed_common import make_problem

make = partial(make_problem, difficulty="medium")


def find_diagonal_order(mat: list[list[int]]) -> list[int]:
    rows, columns = len(mat), len(mat[0])
    result: list[int] = []
    for diagonal in range(rows + columns - 1):
        if diagonal % 2 == 0:
            row = min(diagonal, rows - 1)
            column = diagonal - row
            while row >= 0 and column < columns:
                result.append(mat[row][column])
                row -= 1
                column += 1
        else:
            column = min(diagonal, columns - 1)
            row = diagonal - column
            while column >= 0 and row < rows:
                result.append(mat[row][column])
                row += 1
                column -= 1
    return result


def get_row(row_index: int) -> list[int]:
    row = [1]
    for index in range(1, row_index + 1):
        row = [1] + [row[j - 1] + row[j] for j in range(1, index)] + [1]
    return row


def convert(s: str, num_rows: int) -> str:
    if num_rows == 1:
        return s
    rows = [""] * num_rows
    current = 0
    direction = 1
    for character in s:
        rows[current] += character
        if current == 0:
            direction = 1
        elif current == num_rows - 1:
            direction = -1
        current += direction
    return "".join(rows)


def maximum_swap(num: int) -> int:
    digits = list(str(num))
    last = {int(digit): index for index, digit in enumerate(digits)}
    for index, digit in enumerate(digits):
        for candidate in range(9, int(digit), -1):
            if last.get(candidate, -1) > index:
                other = last[candidate]
                digits[index], digits[other] = digits[other], digits[index]
                return int("".join(digits))
    return num


def min_add_to_make_valid(s: str) -> int:
    balance = 0
    result = 0
    for character in s:
        if character == "(":
            balance += 1
        elif balance:
            balance -= 1
        else:
            result += 1
    return result + balance


def letter_case_permutation(s: str) -> list[str]:
    results = [""]
    for character in s:
        if character.isalpha():
            results = [
                prefix + variant
                for prefix in results
                for variant in {character.lower(), character.upper()}
            ]
        else:
            results = [prefix + character for prefix in results]
    return sorted(results)


def subsets(nums: list[int]) -> list[list[int]]:
    result = [list(combo) for size in range(len(nums) + 1) for combo in combinations(nums, size)]
    result.sort(key=lambda item: (len(item), item))
    return result


def subsets_with_dup(nums: list[int]) -> list[list[int]]:
    result = {
        tuple(combo)
        for size in range(len(nums) + 1)
        for combo in combinations(nums, size)
    }
    ordered = [list(item) for item in result]
    ordered.sort(key=lambda item: (len(item), item))
    return ordered


def permute_unique(nums: list[int]) -> list[list[int]]:
    return [list(item) for item in sorted(set(permutations(nums)))]


def combine(n: int, k: int) -> list[list[int]]:
    return [list(combo) for combo in combinations(range(1, n + 1), k)]


def combination_sum2(candidates: list[int], target: int) -> list[list[int]]:
    ordered = sorted(candidates)
    result: list[list[int]] = []

    def dfs(start: int, remaining: int, path: list[int]) -> None:
        if remaining == 0:
            result.append(path[:])
            return
        for index in range(start, len(ordered)):
            if index > start and ordered[index] == ordered[index - 1]:
                continue
            if ordered[index] > remaining:
                break
            path.append(ordered[index])
            dfs(index + 1, remaining - ordered[index], path)
            path.pop()

    dfs(0, target, [])
    return result


def combination_sum3(k: int, n: int) -> list[list[int]]:
    result: list[list[int]] = []

    def dfs(start: int, remaining: int, path: list[int]) -> None:
        if len(path) == k:
            if remaining == 0:
                result.append(path[:])
            return
        for value in range(start, 10):
            if value > remaining:
                break
            path.append(value)
            dfs(value + 1, remaining - value, path)
            path.pop()

    dfs(1, n, [])
    return result


def combination_sum4(nums: list[int], target: int) -> int:
    dp = [0] * (target + 1)
    dp[0] = 1
    for total in range(1, target + 1):
        for value in nums:
            if total >= value:
                dp[total] += dp[total - value]
    return dp[target]


def restore_ip_addresses(s: str) -> list[str]:
    result: list[str] = []

    def dfs(start: int, parts: list[str]) -> None:
        if len(parts) == 4:
            if start == len(s):
                result.append(".".join(parts))
            return
        for length in range(1, 4):
            if start + length > len(s):
                break
            part = s[start : start + length]
            if (len(part) > 1 and part[0] == "0") or int(part) > 255:
                continue
            parts.append(part)
            dfs(start + length, parts)
            parts.pop()

    dfs(0, [])
    return sorted(result)


def makesquare(matchsticks: list[int]) -> bool:
    total = sum(matchsticks)
    if total % 4:
        return False
    side = total // 4
    sticks = sorted(matchsticks, reverse=True)
    if sticks[0] > side:
        return False
    sides = [0] * 4

    def dfs(index: int) -> bool:
        if index == len(sticks):
            return True
        for side_index in range(4):
            if sides[side_index] + sticks[index] <= side:
                sides[side_index] += sticks[index]
                if dfs(index + 1):
                    return True
                sides[side_index] -= sticks[index]
            if sides[side_index] == 0:
                break
        return False

    return dfs(0)


def can_partition_k_subsets(nums: list[int], k: int) -> bool:
    total = sum(nums)
    if total % k:
        return False
    target = total // k
    ordered = sorted(nums, reverse=True)
    if ordered[0] > target:
        return False
    buckets = [0] * k

    def dfs(index: int) -> bool:
        if index == len(ordered):
            return True
        value = ordered[index]
        for bucket in range(k):
            if buckets[bucket] + value <= target:
                buckets[bucket] += value
                if dfs(index + 1):
                    return True
                buckets[bucket] -= value
            if buckets[bucket] == 0:
                break
        return False

    return dfs(0)


def total_n_queens(n: int) -> int:
    columns: set[int] = set()
    diagonal1: set[int] = set()
    diagonal2: set[int] = set()
    count = 0

    def dfs(row: int) -> None:
        nonlocal count
        if row == n:
            count += 1
            return
        for column in range(n):
            if column in columns or row - column in diagonal1 or row + column in diagonal2:
                continue
            columns.add(column)
            diagonal1.add(row - column)
            diagonal2.add(row + column)
            dfs(row + 1)
            columns.remove(column)
            diagonal1.remove(row - column)
            diagonal2.remove(row + column)

    dfs(0)
    return count


def read_binary_watch(turned_on: int) -> list[str]:
    return [
        f"{hour}:{minute:02d}"
        for hour in range(12)
        for minute in range(60)
        if hour.bit_count() + minute.bit_count() == turned_on
    ]


def max_product_words(words: list[str]) -> int:
    masks = []
    for word in words:
        mask = 0
        for character in word:
            mask |= 1 << (ord(character) - ord("a"))
        masks.append(mask)
    best = 0
    for left in range(len(words)):
        for right in range(left + 1, len(words)):
            if masks[left] & masks[right] == 0:
                best = max(best, len(words[left]) * len(words[right]))
    return best


def group_anagrams(strs: list[str]) -> list[list[str]]:
    groups: dict[tuple[str, ...], list[str]] = {}
    for word in strs:
        groups.setdefault(tuple(sorted(word)), []).append(word)
    result = [sorted(group) for group in groups.values()]
    result.sort(key=lambda group: group[0])
    return result


def top_k_frequent_words(words: list[str], k: int) -> list[str]:
    counts = Counter(words)
    ordered = sorted(counts.items(), key=lambda item: (-item[1], item[0]))
    return [word for word, _ in ordered[:k]]


def find_itinerary(tickets: list[list[str]]) -> list[str]:
    graph: dict[str, list[str]] = {}
    for source, destination in sorted(tickets):
        graph.setdefault(source, []).append(destination)
    itinerary: list[str] = []

    def dfs(airport: str) -> None:
        while graph.get(airport):
            dfs(graph[airport].pop(0))
        itinerary.append(airport)

    dfs("JFK")
    return itinerary[::-1]


def equations_possible(equations: list[str]) -> bool:
    parent = list(range(26))

    def find(value: int) -> int:
        while parent[value] != value:
            parent[value] = parent[parent[value]]
            value = parent[value]
        return value

    def union(left: int, right: int) -> None:
        root_left, root_right = find(left), find(right)
        if root_left != root_right:
            parent[root_right] = root_left

    for equation in equations:
        if equation[1] == "=":
            union(ord(equation[0]) - ord("a"), ord(equation[3]) - ord("a"))
    for equation in equations:
        if equation[1] == "!":
            if find(ord(equation[0]) - ord("a")) == find(ord(equation[3]) - ord("a")):
                return False
    return True


def min_cost_connect_points(points: list[list[int]]) -> int:
    size = len(points)
    visited = [False] * size
    distance = [10**9] * size
    distance[0] = 0
    total = 0
    for _ in range(size):
        current = -1
        for index in range(size):
            if not visited[index] and (current == -1 or distance[index] < distance[current]):
                current = index
        visited[current] = True
        total += distance[current]
        for index in range(size):
            if not visited[index]:
                candidate = abs(points[current][0] - points[index][0]) + abs(
                    points[current][1] - points[index][1]
                )
                if candidate < distance[index]:
                    distance[index] = candidate
    return total


def network_delay_time(times: list[list[int]], n: int, k: int) -> int:
    graph: dict[int, list[tuple[int, int]]] = {index: [] for index in range(1, n + 1)}
    for source, destination, weight in times:
        graph[source].append((destination, weight))
    distance = {index: 10**9 for index in range(1, n + 1)}
    distance[k] = 0
    heap = [(0, k)]
    while heap:
        current, node = heapq.heappop(heap)
        if current > distance[node]:
            continue
        for destination, weight in graph[node]:
            candidate = current + weight
            if candidate < distance[destination]:
                distance[destination] = candidate
                heapq.heappush(heap, (candidate, destination))
    answer = max(distance.values())
    return -1 if answer == 10**9 else answer


def find_cheapest_price(
    n: int, flights: list[list[int]], src: int, dst: int, k: int
) -> int:
    infinity = 10**9
    distance = [infinity] * n
    distance[src] = 0
    for _ in range(k + 1):
        next_distance = distance[:]
        for source, destination, price in flights:
            candidate = distance[source] + price
            if candidate < next_distance[destination]:
                next_distance[destination] = candidate
        distance = next_distance
    return -1 if distance[dst] == infinity else distance[dst]


def max_probability(
    n: int, edges: list[list[float]], start: int, end: int
) -> float:
    graph: list[list[tuple[int, float]]] = [[] for _ in range(n)]
    for left, right, probability in edges:
        graph[int(left)].append((int(right), probability))
        graph[int(right)].append((int(left), probability))
    best = [0.0] * n
    best[start] = 1.0
    heap = [(-1.0, start)]
    while heap:
        neg_probability, node = heapq.heappop(heap)
        probability = -neg_probability
        if probability < best[node]:
            continue
        if node == end:
            return probability
        for destination, edge_probability in graph[node]:
            candidate = probability * edge_probability
            if candidate > best[destination]:
                best[destination] = candidate
                heapq.heappush(heap, (-candidate, destination))
    return 0.0


def minimum_effort_path(heights: list[list[int]]) -> int:
    rows, columns = len(heights), len(heights[0])
    infinity = 10**9
    distance = [[infinity] * columns for _ in range(rows)]
    distance[0][0] = 0
    heap = [(0, 0, 0)]
    while heap:
        effort, row, column = heapq.heappop(heap)
        if effort > distance[row][column]:
            continue
        if row == rows - 1 and column == columns - 1:
            return effort
        for delta_row, delta_column in ((1, 0), (-1, 0), (0, 1), (0, -1)):
            next_row = row + delta_row
            next_column = column + delta_column
            if 0 <= next_row < rows and 0 <= next_column < columns:
                next_effort = max(
                    effort, abs(heights[row][column] - heights[next_row][next_column])
                )
                if next_effort < distance[next_row][next_column]:
                    distance[next_row][next_column] = next_effort
                    heapq.heappush(heap, (next_effort, next_row, next_column))
    return 0


def shortest_path_binary_matrix(grid: list[list[int]]) -> int:
    size = len(grid)
    if grid[0][0] or grid[size - 1][size - 1]:
        return -1
    if size == 1:
        return 1
    queue = deque([(0, 0, 1)])
    seen = {(0, 0)}
    while queue:
        row, column, length = queue.popleft()
        for delta_row in (-1, 0, 1):
            for delta_column in (-1, 0, 1):
                if delta_row == 0 and delta_column == 0:
                    continue
                next_row = row + delta_row
                next_column = column + delta_column
                if (
                    0 <= next_row < size
                    and 0 <= next_column < size
                    and grid[next_row][next_column] == 0
                    and (next_row, next_column) not in seen
                ):
                    if next_row == size - 1 and next_column == size - 1:
                        return length + 1
                    seen.add((next_row, next_column))
                    queue.append((next_row, next_column, length + 1))
    return -1


def count_squares(matrix: list[list[int]]) -> int:
    rows, columns = len(matrix), len(matrix[0])
    dp = [[0] * columns for _ in range(rows)]
    total = 0
    for row in range(rows):
        for column in range(columns):
            if matrix[row][column]:
                dp[row][column] = 1 + min(
                    dp[row - 1][column] if row else 0,
                    dp[row][column - 1] if column else 0,
                    dp[row - 1][column - 1] if row and column else 0,
                )
                total += dp[row][column]
    return total


def maximum_sum(arr: list[int]) -> int:
    not_deleted = arr[0]
    deleted = arr[0]
    best = arr[0]
    for value in arr[1:]:
        deleted = max(deleted + value, not_deleted)
        not_deleted = max(not_deleted + value, value)
        best = max(best, deleted, not_deleted)
    return best


def max_turbulence_size(arr: list[int]) -> int:
    if len(arr) < 2:
        return len(arr)
    up = down = 1
    best = 1
    for index in range(1, len(arr)):
        if arr[index] > arr[index - 1]:
            up, down = down + 1, 1
        elif arr[index] < arr[index - 1]:
            down, up = up + 1, 1
        else:
            up = down = 1
        best = max(best, up, down)
    return best


def number_of_arithmetic_slices(nums: list[int]) -> int:
    total = 0
    current = 0
    for index in range(2, len(nums)):
        if nums[index] - nums[index - 1] == nums[index - 1] - nums[index - 2]:
            current += 1
            total += current
        else:
            current = 0
    return total


def wiggle_max_length(nums: list[int]) -> int:
    if len(nums) < 2:
        return len(nums)
    up = down = 1
    for index in range(1, len(nums)):
        if nums[index] > nums[index - 1]:
            up = down + 1
        elif nums[index] < nums[index - 1]:
            down = up + 1
    return max(up, down)


def find_number_of_lis(nums: list[int]) -> int:
    size = len(nums)
    length = [1] * size
    count = [1] * size
    for index in range(size):
        for previous in range(index):
            if nums[previous] < nums[index]:
                candidate = length[previous] + 1
                if candidate > length[index]:
                    length[index] = candidate
                    count[index] = count[previous]
                elif candidate == length[index]:
                    count[index] += count[previous]
    best = max(length)
    return sum(count[index] for index in range(size) if length[index] == best)


def erase_overlap_intervals(intervals: list[list[int]]) -> int:
    if not intervals:
        return 0
    ordered = sorted(intervals, key=lambda item: item[1])
    end = ordered[0][1]
    removed = 0
    for start, finish in ordered[1:]:
        if start < end:
            removed += 1
        else:
            end = finish
    return removed


def find_min_arrow_shots(points: list[list[int]]) -> int:
    if not points:
        return 0
    ordered = sorted(points, key=lambda item: item[1])
    arrows = 1
    end = ordered[0][1]
    for start, finish in ordered[1:]:
        if start > end:
            arrows += 1
            end = finish
    return arrows


def reconstruct_queue(people: list[list[int]]) -> list[list[int]]:
    result: list[list[int]] = []
    for height, ahead in sorted(people, key=lambda item: (-item[0], item[1])):
        result.insert(ahead, [height, ahead])
    return result


def least_interval(tasks: list[str], n: int) -> int:
    counts = Counter(tasks)
    maximum = max(counts.values())
    ties = sum(1 for count in counts.values() if count == maximum)
    return max(len(tasks), (maximum - 1) * (n + 1) + ties)


def monotone_increasing_digits(n: int) -> int:
    digits = list(str(n))
    index = len(digits) - 1
    while index > 0:
        if digits[index] < digits[index - 1]:
            digits[index - 1] = str(int(digits[index - 1]) - 1)
            for position in range(index, len(digits)):
                digits[position] = "9"
        index -= 1
    return int("".join(digits))


def is_bipartite(graph: list[list[int]]) -> bool:
    color = [-1] * len(graph)
    for start in range(len(graph)):
        if color[start] != -1:
            continue
        color[start] = 0
        queue = deque([start])
        while queue:
            node = queue.popleft()
            for neighbor in graph[node]:
                if color[neighbor] == -1:
                    color[neighbor] = 1 - color[node]
                    queue.append(neighbor)
                elif color[neighbor] == color[node]:
                    return False
    return True


def eventual_safe_nodes(graph: list[list[int]]) -> list[int]:
    state = [0] * len(graph)

    def dfs(node: int) -> bool:
        if state[node] == 1:
            return False
        if state[node] == 2:
            return True
        state[node] = 1
        for neighbor in graph[node]:
            if not dfs(neighbor):
                return False
        state[node] = 2
        return True

    return [index for index in range(len(graph)) if dfs(index)]


def find_circle_num(is_connected: list[list[int]]) -> int:
    size = len(is_connected)
    visited = [False] * size
    provinces = 0
    for start in range(size):
        if visited[start]:
            continue
        provinces += 1
        stack = [start]
        visited[start] = True
        while stack:
            node = stack.pop()
            for neighbor in range(size):
                if is_connected[node][neighbor] and not visited[neighbor]:
                    visited[neighbor] = True
                    stack.append(neighbor)
    return provinces


PROBLEMS = [
    make(
        pid=1417,
        title="对角线遍历",
        tags=["数组", "矩阵", "模拟"],
        description="""给定 m x n 矩阵 mat，按对角线顺序遍历所有元素：
先向右上，再向左下，交替进行。返回遍历结果数组。""",
        function="findDiagonalOrder",
        params=[("mat", "int[][]")],
        returns="int[]",
        solver=find_diagonal_order,
        public=[
            [[[1, 2, 3], [4, 5, 6], [7, 8, 9]]],
            [[[1, 2], [3, 4]]],
        ],
        hidden=[
            [[[1]]],
            [[[1, 2, 3]]],
            [[[1], [2], [3]]],
            [[[1, 2], [3, 4], [5, 6]]],
        ],
    ),
    make(
        pid=1418,
        title="杨辉三角 II",
        tags=["数组", "动态规划"],
        description="""返回杨辉三角的第 rowIndex 行（行号从 0 开始）。""",
        function="getRow",
        params=[("rowIndex", "int")],
        returns="int[]",
        solver=get_row,
        public=[[3], [0], [1]],
        hidden=[[2], [4], [5]],
    ),
    make(
        pid=1419,
        title="Z 字形变换",
        tags=["字符串", "模拟"],
        description="""将字符串 s 按 Z 字形排列到 numRows 行后，逐行读取，返回结果字符串。""",
        function="convert",
        params=[("s", "string"), ("numRows", "int")],
        returns="string",
        solver=convert,
        public=[["PAYPALISHIRING", 3], ["PAYPALISHIRING", 4], ["A", 1]],
        hidden=[["AB", 1], ["ABC", 2], ["ABCD", 3], ["HELLO", 4]],
    ),
    make(
        pid=1420,
        title="最大交换",
        tags=["贪心", "数学"],
        description="""给定一个非负整数 num，最多交换其中两个数字一次，返回能得到的最大数字。""",
        function="maximumSwap",
        params=[("num", "int")],
        returns="int",
        solver=maximum_swap,
        public=[[2736], [9973], [1234]],
        hidden=[[0], [10], [98368], [1993]],
    ),
    make(
        pid=1421,
        title="使括号有效的最少添加",
        tags=["字符串", "栈", "贪心"],
        description="""给定只含 '(' 和 ')' 的字符串 s，返回使括号字符串有效所需添加的最少括号数。""",
        function="minAddToMakeValid",
        params=[("s", "string")],
        returns="int",
        solver=min_add_to_make_valid,
        public=[["())"], ["((("], ["()"], ["()))(("]],
        hidden=[[""], ["("], [")"], ["()()"], ["((())"]],
    ),
    make(
        pid=1422,
        title="字母大小写全排列",
        tags=["字符串", "回溯", "位运算"],
        description="""给定字符串 s，返回通过改变每个字母的大小写能得到的所有字符串，按字典序升序排列。
非字母字符保持不变。""",
        function="letterCasePermutation",
        params=[("s", "string")],
        returns="string[]",
        solver=letter_case_permutation,
        public=[["a1b2"], ["3z4"], ["C"]],
        hidden=[["a"], ["ab"], ["1"], ["A1"]],
    ),
    make(
        pid=1423,
        title="子集",
        tags=["数组", "回溯", "位运算"],
        description="""给定不含重复元素的整数数组 nums，返回所有子集。
按子集长度升序排列，长度相同按字典序升序排列。""",
        function="subsets",
        params=[("nums", "int[]")],
        returns="int[][]",
        solver=subsets,
        public=[[[1, 2, 3]], [[0]], [[1, 2]]],
        hidden=[[[1]], [[1, 2, 3, 4]]],
    ),
    make(
        pid=1424,
        title="子集 II",
        tags=["数组", "回溯", "位运算"],
        description="""给定可能包含重复元素的整数数组 nums，返回所有不重复的子集。
按子集长度升序排列，长度相同按字典序升序排列。""",
        function="subsetsWithDup",
        params=[("nums", "int[]")],
        returns="int[][]",
        solver=subsets_with_dup,
        public=[[[1, 2, 2]], [[0]], [[4, 4, 4, 1, 4]]],
        hidden=[[[1, 1]], [[1, 2, 2, 3]]],
    ),
    make(
        pid=1425,
        title="全排列 II",
        tags=["数组", "回溯"],
        description="""给定可能包含重复数字的数组 nums，按字典序升序返回所有不重复的全排列。""",
        function="permuteUnique",
        params=[("nums", "int[]")],
        returns="int[][]",
        solver=permute_unique,
        public=[[[1, 1, 2]], [[1, 2, 3]], [[1]]],
        hidden=[[[2, 2]], [[1, 2, 1]], [[3, 3, 1]]],
    ),
    make(
        pid=1426,
        title="组合",
        tags=["回溯"],
        description="""返回 1 到 n 中所有包含 k 个数的组合，按字典序升序排列。""",
        function="combine",
        params=[("n", "int"), ("k", "int")],
        returns="int[][]",
        solver=combine,
        public=[[4, 2], [1, 1], [3, 2]],
        hidden=[[3, 3], [5, 1], [5, 3]],
    ),
    make(
        pid=1427,
        title="组合总和 II",
        tags=["数组", "回溯"],
        description="""给定可能包含重复数字的候选数组 candidates 和目标数 target。
每个数字在每个组合中最多使用一次，返回所有和等于 target 的不重复组合。
组合内按非递减顺序排列，组合间按字典序升序排列。""",
        function="combinationSum2",
        params=[("candidates", "int[]"), ("target", "int")],
        returns="int[][]",
        solver=combination_sum2,
        public=[
            [[10, 1, 2, 7, 6, 1, 5], 8],
            [[2, 5, 2, 1, 2], 5],
            [[2], 1],
        ],
        hidden=[[[1, 1], 2], [[1, 2, 3], 3], [[1, 1, 1], 3]],
    ),
    make(
        pid=1428,
        title="组合总和 III",
        tags=["回溯"],
        description="""返回 1 到 9 中所有包含 k 个数且和为 n 的组合，按字典序升序排列。""",
        function="combinationSum3",
        params=[("k", "int"), ("n", "int")],
        returns="int[][]",
        solver=combination_sum3,
        public=[[3, 7], [3, 9], [4, 1]],
        hidden=[[1, 1], [2, 5], [9, 45]],
    ),
    make(
        pid=1429,
        title="组合总和 IV",
        tags=["数组", "动态规划"],
        description="""给定由不同正整数组成的数组 nums 和目标值 target，
返回和为 target 的元素组合个数。顺序不同视为不同组合。""",
        function="combinationSum4",
        params=[("nums", "int[]"), ("target", "int")],
        returns="int",
        solver=combination_sum4,
        public=[[[1, 2, 3], 4], [[9], 3], [[1, 2], 3]],
        hidden=[[[1], 0], [[1], 1], [[2, 3], 5], [[3, 4, 5], 7]],
    ),
    make(
        pid=1430,
        title="复原 IP 地址",
        tags=["字符串", "回溯"],
        description="""给定只含数字的字符串 s，返回所有可能的有效 IPv4 地址，按字典序升序排列。
每个地址由四个 0 到 255 的整数组成，且不能有前导零（单个 0 除外）。""",
        function="restoreIpAddresses",
        params=[("s", "string")],
        returns="string[]",
        solver=restore_ip_addresses,
        public=[["25525511135"], ["0000"], ["101023"]],
        hidden=[["1111"], ["010010"], ["1234567890123"]],
    ),
    make(
        pid=1431,
        title="火柴拼正方形",
        tags=["数组", "回溯", "位运算"],
        description="""给定火柴长度数组 matchsticks，判断能否用所有火柴拼成一个正方形。""",
        function="makesquare",
        params=[("matchsticks", "int[]")],
        returns="bool",
        solver=makesquare,
        public=[[[1, 1, 2, 2, 2]], [[3, 3, 3, 3, 4]], [[1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1]]],
        hidden=[[[1, 1, 1, 1]], [[5, 5, 5, 5]], [[2, 2, 2, 2, 2, 2]]],
    ),
    make(
        pid=1432,
        title="划分为 k 个相等的子集",
        tags=["数组", "回溯", "动态规划"],
        description="""给定整数数组 nums 和整数 k，判断能否将数组分成 k 个非空子集，
使每个子集的元素和相等。""",
        function="canPartitionKSubsets",
        params=[("nums", "int[]"), ("k", "int")],
        returns="bool",
        solver=can_partition_k_subsets,
        public=[
            [[4, 3, 2, 3, 5, 2, 1], 4],
            [[1, 2, 3, 4], 3],
            [[2, 2, 2, 2, 3, 4, 5], 4],
        ],
        hidden=[[[1], 1], [[1, 2], 2], [[1, 1, 1, 1], 2], [[2, 2, 2, 2, 2], 2]],
    ),
    make(
        pid=1433,
        title="N 皇后 II",
        tags=["回溯"],
        description="""返回 n 皇后问题不同解的数量。""",
        function="totalNQueens",
        params=[("n", "int")],
        returns="int",
        solver=total_n_queens,
        public=[[4], [1], [8]],
        hidden=[[2], [3], [5], [6]],
    ),
    make(
        pid=1434,
        title="二进制手表",
        tags=["位运算", "回溯"],
        description="""二进制手表用 4 个 LED 表示小时（0 到 11），6 个 LED 表示分钟（0 到 59）。
给定亮灯数 turnedOn，按时间升序返回所有可能的时间，格式为 "H:MM"。""",
        function="readBinaryWatch",
        params=[("turnedOn", "int")],
        returns="string[]",
        solver=read_binary_watch,
        public=[[1], [9], [0]],
        hidden=[[2], [3], [8], [10]],
    ),
    make(
        pid=1435,
        title="最大单词长度乘积",
        tags=["数组", "字符串", "位运算"],
        description="""给定字符串数组 words，返回两个不含公共字母的单词长度乘积的最大值。
不存在这样的两个单词返回 0。""",
        function="maxProduct",
        params=[("words", "string[]")],
        returns="int",
        solver=max_product_words,
        public=[
            [["abcw", "baz", "foo", "bar", "xtfn", "abcdef"]],
            [["a", "ab", "abc", "d", "cd", "bcd", "abcd"]],
            [["a", "aa", "aaa", "aaaa"]],
        ],
        hidden=[[["a"]], [["ab", "cd"]], [["abc", "def", "ghi"]]],
    ),
    make(
        pid=1436,
        title="字母异位词分组",
        tags=["数组", "字符串", "哈希表", "排序"],
        description="""给定字符串数组 strs，将字母异位词分组。
每组内按字典序升序排列，各组之间按组内第一个字符串的字典序升序排列。""",
        function="groupAnagrams",
        params=[("strs", "string[]")],
        returns="string[][]",
        solver=group_anagrams,
        public=[
            [["eat", "tea", "tan", "ate", "nat", "bat"]],
            [[""]],
            [["a"]],
        ],
        hidden=[[["ab", "ba", "abc", "cba", "bca"]], [["", ""]], [["abc"]]],
    ),
    make(
        pid=1437,
        title="前 K 个高频单词",
        tags=["数组", "字符串", "哈希表", "堆", "排序"],
        description="""返回出现频率最高的 k 个单词，按频率降序排列；频率相同按字典序升序排列。""",
        function="topKFrequent",
        params=[("words", "string[]"), ("k", "int")],
        returns="string[]",
        solver=top_k_frequent_words,
        public=[
            [["i", "love", "leetcode", "i", "love", "coding"], 2],
            [["the", "day", "is", "sunny", "the", "the", "the", "sunny", "is", "is"], 4],
        ],
        hidden=[[["a"], 1], [["a", "b", "a"], 1], [["a", "b", "b", "c", "c"], 2]],
    ),
    make(
        pid=1438,
        title="重新安排行程",
        tags=["图", "深度优先搜索", "欧拉路径"],
        description="""给定机票列表 tickets，每张票为 [from, to]。
从 "JFK" 出发，使用所有机票并返回字典序最小的行程。保证至少存在一种有效行程。""",
        function="findItinerary",
        params=[("tickets", "string[][]")],
        returns="string[]",
        solver=find_itinerary,
        public=[
            [[["MUC", "LHR"], ["JFK", "MUC"], ["SFO", "SJC"], ["LHR", "SFO"]]],
            [[["JFK", "SFO"], ["JFK", "ATL"], ["SFO", "ATL"], ["ATL", "JFK"], ["ATL", "SFO"]]],
        ],
        hidden=[
            [[["JFK", "A"], ["A", "JFK"]]],
            [[["JFK", "K"], ["JFK", "A"], ["A", "JFK"]]],
        ],
    ),
    make(
        pid=1439,
        title="等式方程的可满足性",
        tags=["并查集", "图", "数组"],
        description="""给定字符串数组 equations，每个元素形如 "a==b" 或 "a!=b"。
判断是否存在一组变量赋值使所有等式同时成立。变量为单个小写字母。""",
        function="equationsPossible",
        params=[("equations", "string[]")],
        returns="bool",
        solver=equations_possible,
        public=[
            [["a==b", "b!=a"]],
            [["b==a", "a==b"]],
            [["a==b", "b==c", "a==c"]],
            [["a==b", "b!=c", "c==a"]],
        ],
        hidden=[[["a!=a"]], [["a==a"]], [["a!=b"]], [["a==b", "b==c", "c!=a"]]],
    ),
    make(
        pid=1440,
        title="连接所有点的最小费用",
        tags=["图", "并查集", "最小生成树"],
        description="""给定二维平面上 n 个点的坐标 points，连接所有点的费用为两点间的曼哈顿距离。
返回连接所有点的最小总费用。""",
        function="minCostConnectPoints",
        params=[("points", "int[][]")],
        returns="int",
        solver=min_cost_connect_points,
        public=[
            [[[0, 0], [2, 2], [3, 10], [5, 2], [7, 0]]],
            [[[3, 12], [-2, 5], [-4, 1]]],
            [[[0, 0]]],
        ],
        hidden=[[[[0, 0], [1, 1]]], [[[0, 0], [1, 0], [0, 1]]], [[[0, 0], [10, 10]]]],
    ),
    make(
        pid=1441,
        title="网络延迟时间",
        tags=["图", "最短路", "堆"],
        description="""给定 n 个节点和有向边 times，times[i] = [u, v, w] 表示从 u 到 v 需要 w 时间。
从节点 k 发出信号，返回所有节点都收到信号的最短时间；无法到达全部节点返回 -1。""",
        function="networkDelayTime",
        params=[("times", "int[][]"), ("n", "int"), ("k", "int")],
        returns="int",
        solver=network_delay_time,
        public=[
            [[[2, 1, 1], [2, 3, 1], [3, 4, 1]], 4, 2],
            [[[1, 2, 1]], 2, 1],
            [[[1, 2, 1]], 2, 2],
        ],
        hidden=[[[], 1, 1], [[[1, 2, 1], [2, 3, 2], [1, 3, 4]], 3, 1]],
    ),
    make(
        pid=1442,
        title="K 站中转内最便宜的航班",
        tags=["图", "最短路", "动态规划"],
        description="""给定 n 个城市、航班数组 flights（每个元素为 [from, to, price]）、起点 src、终点 dst
和最多中转次数 k，返回最便宜的价格；无法到达返回 -1。""",
        function="findCheapestPrice",
        params=[
            ("n", "int"),
            ("flights", "int[][]"),
            ("src", "int"),
            ("dst", "int"),
            ("k", "int"),
        ],
        returns="int",
        solver=find_cheapest_price,
        public=[
            [3, [[0, 1, 100], [1, 2, 100], [0, 2, 500]], 0, 2, 1],
            [3, [[0, 1, 100], [1, 2, 100], [0, 2, 500]], 0, 2, 0],
            [4, [[0, 1, 1], [0, 2, 5], [1, 2, 1], [2, 3, 1]], 0, 3, 1],
        ],
        hidden=[
            [2, [], 0, 1, 1],
            [2, [[0, 1, 5]], 0, 1, 0],
            [3, [[0, 1, 2], [1, 2, 2]], 0, 2, 1],
        ],
    ),
    make(
        pid=1443,
        title="概率最大的路径",
        tags=["图", "最短路", "堆"],
        description="""给定无向图 n 个节点，边 edges[i] = [a, b, prob] 表示 a 与 b 之间成功的概率。
返回从 start 到 end 成功概率最大的路径的概率；不可达返回 0。""",
        function="maxProbability",
        params=[
            ("n", "int"),
            ("edges", "double[][]"),
            ("start", "int"),
            ("end", "int"),
        ],
        returns="double",
        solver=max_probability,
        compare={"mode": "double"},
        public=[
            [3, [[0, 1, 0.5], [1, 2, 0.5], [0, 2, 0.2]], 0, 2],
            [3, [[0, 1, 0.5], [1, 2, 0.5], [0, 2, 0.2]], 0, 1],
            [3, [[0, 1, 0.5], [1, 2, 0.5]], 0, 2],
        ],
        hidden=[[2, [], 0, 1], [2, [[0, 1, 1.0]], 0, 1], [4, [[0, 1, 0.9], [1, 3, 0.9], [0, 2, 0.1], [2, 3, 0.1]], 0, 3]],
    ),
    make(
        pid=1444,
        title="最小体力消耗路径",
        tags=["图", "二分查找", "堆", "矩阵"],
        description="""给定 heights 矩阵，从左上角走到右下角，每次可上下左右移动。
一条路径的体力消耗为相邻格高度差绝对值的最大值。返回最小体力消耗。""",
        function="minimumEffortPath",
        params=[("heights", "int[][]")],
        returns="int",
        solver=minimum_effort_path,
        public=[
            [[[1, 2, 2], [3, 8, 2], [5, 3, 5]]],
            [[[1, 2, 3], [3, 8, 4], [5, 3, 5]]],
            [[[1, 2], [2, 2]]],
        ],
        hidden=[
            [[[1]]],
            [[[1, 2], [3, 4]]],
            [[[5, 5], [5, 5]]],
        ],
    ),
    make(
        pid=1445,
        title="二进制矩阵中的最短路径",
        tags=["数组", "矩阵", "广度优先搜索"],
        description="""给定 n x n 的 0/1 矩阵 grid，0 可走，1 阻挡。
从 (0, 0) 到 (n-1, n-1) 可沿 8 个方向移动，返回最短路径长度（经过的格子数）；不可达返回 -1。""",
        function="shortestPathBinaryMatrix",
        params=[("grid", "int[][]")],
        returns="int",
        solver=shortest_path_binary_matrix,
        public=[
            [[[0, 1], [1, 0]]],
            [[[0, 0, 0], [1, 1, 0], [1, 1, 0]]],
            [[[1, 0, 0], [1, 1, 0], [1, 1, 0]]],
        ],
        hidden=[
            [[[0]]],
            [[[1]]],
            [[[0, 1], [1, 1]]],
            [[[0, 0], [0, 0]]],
        ],
    ),
    make(
        pid=1446,
        title="统计全为 1 的正方形子矩阵",
        tags=["数组", "矩阵", "动态规划"],
        description="""给定 m x n 的 0/1 矩阵 matrix，返回其中全为 1 的正方形子矩阵个数。""",
        function="countSquares",
        params=[("matrix", "int[][]")],
        returns="int",
        solver=count_squares,
        public=[
            [[[1, 0, 1], [1, 1, 0], [1, 1, 0]]],
            [[[0, 1, 1, 1], [1, 1, 1, 1], [0, 1, 1, 1]]],
            [[[1, 1], [1, 1]]],
        ],
        hidden=[
            [[[0]]],
            [[[1]]],
            [[[1, 0], [0, 1]]],
            [[[1, 1], [1, 1]]],
        ],
    ),
    make(
        pid=1447,
        title="删除一次得到子数组最大和",
        tags=["数组", "动态规划"],
        description="""给定整数数组 arr，可以删除至多一个元素，返回删除后能得到的非空子数组的最大和。""",
        function="maximumSum",
        params=[("arr", "int[]")],
        returns="int",
        solver=maximum_sum,
        public=[[[1, -2, 0, 3]], [[1, -2, -2, 3]], [[-1, -1, -1, -1]]],
        hidden=[[[1]], [[-1]], [[1, 2, 3]], [[-2, 1, -3, 4, -1, 2, 1, -5, 4]]],
    ),
    make(
        pid=1448,
        title="最长湍流子数组",
        tags=["数组", "动态规划", "滑动窗口"],
        description="""给定整数数组 arr，返回最长湍流子数组的长度。
湍流子数组指相邻元素的大小比较符号交替出现。""",
        function="maxTurbulenceSize",
        params=[("arr", "int[]")],
        returns="int",
        solver=max_turbulence_size,
        public=[[[9, 4, 2, 10, 7, 8, 8, 1, 9]], [[4, 8, 12, 16]], [[100]]],
        hidden=[[[1, 2]], [[2, 1]], [[1, 1]], [[3, 1, 2, 1, 3]]],
    ),
    make(
        pid=1449,
        title="等差数列划分",
        tags=["数组", "动态规划"],
        description="""返回数组 nums 中所有等差连续子数组的个数。等差连续子数组长度至少为 3。""",
        function="numberOfArithmeticSlices",
        params=[("nums", "int[]")],
        returns="int",
        solver=number_of_arithmetic_slices,
        public=[[[1, 2, 3, 4]], [[1]], [[1, 2, 3, 4, 5, 6]]],
        hidden=[[[1, 2, 3]], [[1, 3, 5, 7]], [[1, 2, 4]]],
    ),
    make(
        pid=1450,
        title="摆动序列",
        tags=["数组", "贪心", "动态规划"],
        description="""返回数组 nums 中最长摆动子序列的长度。
摆动子序列指相邻元素差值正负交替，长度至少为 1。""",
        function="wiggleMaxLength",
        params=[("nums", "int[]")],
        returns="int",
        solver=wiggle_max_length,
        public=[
            [[1, 7, 4, 9, 2, 5]],
            [[1, 17, 5, 10, 13, 15, 10, 5, 16, 8]],
            [[1, 2, 3, 4, 5, 6, 7, 8, 9]],
        ],
        hidden=[[[1]], [[2, 2]], [[1, 2]], [[2, 1]], [[3, 3, 3, 2, 5]]],
    ),
    make(
        pid=1451,
        title="最长递增子序列的个数",
        tags=["数组", "动态规划"],
        description="""给定未排序的整数数组 nums，返回最长严格递增子序列的个数。""",
        function="findNumberOfLIS",
        params=[("nums", "int[]")],
        returns="int",
        solver=find_number_of_lis,
        public=[[[1, 3, 5, 4, 7]], [[2, 2, 2, 2, 2]], [[1, 2, 3]]],
        hidden=[[[1]], [[1, 2, 1, 2]], [[1, 3, 2, 4]]],
    ),
    make(
        pid=1452,
        title="无重叠区间",
        tags=["数组", "贪心", "排序"],
        description="""给定区间数组 intervals，返回移除最少区间数，使剩余区间互不重叠。
端点相接不算重叠。""",
        function="eraseOverlapIntervals",
        params=[("intervals", "int[][]")],
        returns="int",
        solver=erase_overlap_intervals,
        public=[
            [[[1, 2], [2, 3], [3, 4], [1, 3]]],
            [[[1, 2], [1, 2], [1, 2]]],
            [[[1, 2], [2, 3]]],
        ],
        hidden=[
            [[[1, 2]]],
            [[[1, 2], [3, 4]]],
            [[[1, 10], [2, 3], [4, 5]]],
        ],
    ),
    make(
        pid=1453,
        title="用最少数量的箭引爆气球",
        tags=["数组", "贪心", "排序"],
        description="""气球区间 points[i] = [xstart, xend]。箭从 x 轴垂直射出，可引爆区间包含该点的气球。
返回引爆所有气球的最少箭数。""",
        function="findMinArrowShots",
        params=[("points", "int[][]")],
        returns="int",
        solver=find_min_arrow_shots,
        public=[
            [[[10, 16], [2, 8], [1, 6], [7, 12]]],
            [[[1, 2], [3, 4], [5, 6], [7, 8]]],
            [[[1, 2], [2, 3], [3, 4], [4, 5]]],
        ],
        hidden=[
            [[[1, 2]]],
            [[[1, 10]]],
            [[[1, 2], [3, 4]]],
        ],
    ),
    make(
        pid=1454,
        title="根据身高重建队列",
        tags=["数组", "贪心", "排序"],
        description="""给定数组 people，people[i] = [height, k] 表示第 i 人的身高和前面身高大于等于他的人数。
返回重建后的队列（保证唯一）。""",
        function="reconstructQueue",
        params=[("people", "int[][]")],
        returns="int[][]",
        solver=reconstruct_queue,
        public=[
            [[[7, 0], [4, 4], [7, 1], [5, 0], [6, 1], [5, 2]]],
            [[[6, 0], [5, 0], [4, 0], [3, 2], [2, 2], [1, 4]]],
        ],
        hidden=[
            [[[1, 0]]],
            [[[2, 0], [1, 0]]],
            [[[3, 0], [2, 0]]],
        ],
    ),
    make(
        pid=1455,
        title="任务调度器",
        tags=["数组", "贪心", "堆"],
        description="""给定字符数组 tasks 表示任务类型，相同任务之间至少间隔 n 个时间单位。
返回完成所有任务所需的最短时间。""",
        function="leastInterval",
        params=[("tasks", "string[]"), ("n", "int")],
        returns="int",
        solver=least_interval,
        public=[
            [["A", "A", "A", "B", "B", "B"], 2],
            [["A", "A", "A", "B", "B", "B"], 0],
            [["A", "A", "A", "A", "A", "A", "B", "C", "D", "E", "F", "G"], 2],
        ],
        hidden=[[["A"], 0], [["A", "A"], 2], [["A", "B"], 2], [["A", "A", "B", "B"], 1]],
    ),
    make(
        pid=1456,
        title="单调递增的数字",
        tags=["贪心", "数学"],
        description="""给定非负整数 n，返回小于等于 n 的最大单调递增整数。
单调递增整数指从左到右每位数字非递减。""",
        function="monotoneIncreasingDigits",
        params=[("n", "int")],
        returns="int",
        solver=monotone_increasing_digits,
        public=[[10], [1234], [332]],
        hidden=[[0], [9], [100], [999], [120]],
    ),
    make(
        pid=1457,
        title="判断二分图",
        tags=["图", "广度优先搜索", "深度优先搜索"],
        description="""给定无向图的邻接表 graph，判断该图是否为二分图。""",
        function="isBipartite",
        params=[("graph", "int[][]")],
        returns="bool",
        solver=is_bipartite,
        public=[
            [[[1, 2, 3], [0, 2], [0, 1, 3], [0, 2]]],
            [[[1, 3], [0, 2], [1, 3], [0, 2]]],
            [[[]]],
        ],
        hidden=[
            [[[1], [0]]],
            [[[1, 2], [0, 2], [0, 1]]],
            [[[]]],
        ],
    ),
    make(
        pid=1458,
        title="找到最终的安全状态",
        tags=["图", "深度优先搜索", "拓扑排序"],
        description="""有向图 graph[i] 是节点 i 的出边列表。安全节点指从该节点出发的所有路径都终止于终端节点。
返回所有安全节点，按升序排列。""",
        function="eventualSafeNodes",
        params=[("graph", "int[][]")],
        returns="int[]",
        solver=eventual_safe_nodes,
        public=[
            [[[1, 2], [2, 3], [5], [0], [5], [], []]],
            [[[1, 2, 3, 4], [1, 2], [3, 4], [0, 4], []]],
            [[[]]],
        ],
        hidden=[
            [[[1], [2], []]],
            [[[1, 2], [2, 3], [], [3]]],
        ],
    ),
    make(
        pid=1459,
        title="省份数量",
        tags=["图", "并查集", "深度优先搜索"],
        description="""给定 n x n 的邻接矩阵 isConnected，返回省份数量（连通分量数）。""",
        function="findCircleNum",
        params=[("isConnected", "int[][]")],
        returns="int",
        solver=find_circle_num,
        public=[
            [[[1, 1, 0], [1, 1, 0], [0, 0, 1]]],
            [[[1, 0, 0], [0, 1, 0], [0, 0, 1]]],
            [[[1, 0, 0, 1], [0, 1, 1, 0], [0, 1, 1, 0], [1, 0, 0, 1]]],
        ],
        hidden=[
            [[[1]]],
            [[[1, 1], [1, 1]]],
            [[[1, 0], [0, 1]]],
        ],
    ),
]
