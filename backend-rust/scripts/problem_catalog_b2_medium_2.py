"""1617-1659：批量第二批中等题（43 道）。"""

from __future__ import annotations

import heapq
from collections import Counter, defaultdict, deque
from functools import partial

from problem_seed_common import Node, make_problem, tree_from_list, tree_to_list

make = partial(make_problem, difficulty="medium")


# ── 树 ────────────────────────────────────────────────────────────


def construct_maximum_binary_tree(nums: list[int]) -> list[int | None]:
    def build(lo: int, hi: int) -> Node | None:
        if lo > hi:
            return None
        peak = max(range(lo, hi + 1), key=lambda index: nums[index])
        node = Node(nums[peak])
        node.left = build(lo, peak - 1)
        node.right = build(peak + 1, hi)
        return node

    return tree_to_list(build(0, len(nums) - 1))


def longest_univalue_path(root_values: list[int | None]) -> int:
    root = tree_from_list(root_values)
    best = 0

    def dfs(node: Node | None) -> int:
        nonlocal best
        if node is None:
            return 0
        left = dfs(node.left)
        right = dfs(node.right)
        left_length = left + 1 if node.left is not None and node.left.value == node.value else 0
        right_length = (
            right + 1 if node.right is not None and node.right.value == node.value else 0
        )
        best = max(best, left_length + right_length)
        return max(left_length, right_length)

    dfs(root)
    return best


def prune_tree(root_values: list[int | None]) -> list[int | None]:
    root = tree_from_list(root_values)

    def dfs(node: Node | None) -> Node | None:
        if node is None:
            return None
        node.left = dfs(node.left)
        node.right = dfs(node.right)
        if node.value == 0 and node.left is None and node.right is None:
            return None
        return node

    return tree_to_list(dfs(root))


def is_complete_tree(root_values: list[int | None]) -> bool:
    root = tree_from_list(root_values)
    if root is None:
        return True
    queue: deque[Node | None] = deque([root])
    seen_empty = False
    while queue:
        node = queue.popleft()
        if node is None:
            seen_empty = True
            continue
        if seen_empty:
            return False
        queue.append(node.left)
        queue.append(node.right)
    return True


def distribute_coins(root_values: list[int | None]) -> int:
    root = tree_from_list(root_values)
    moves = 0

    def dfs(node: Node | None) -> int:
        nonlocal moves
        if node is None:
            return 0
        left = dfs(node.left)
        right = dfs(node.right)
        moves += abs(left) + abs(right)
        return node.value - 1 + left + right

    dfs(root)
    return moves


def bst_from_preorder(preorder: list[int]) -> list[int | None]:
    index = 0

    def build(lower: float, upper: float) -> Node | None:
        nonlocal index
        if index >= len(preorder):
            return None
        value = preorder[index]
        if not lower < value < upper:
            return None
        index += 1
        node = Node(value)
        node.left = build(lower, value)
        node.right = build(value, upper)
        return node

    return tree_to_list(build(float("-inf"), float("inf")))


def max_level_sum(root_values: list[int | None]) -> int:
    root = tree_from_list(root_values)
    if root is None:
        return 0
    queue = deque([root])
    level = 0
    best_level = 0
    best_sum: int | None = None
    while queue:
        level += 1
        total = 0
        for _ in range(len(queue)):
            node = queue.popleft()
            total += node.value
            if node.left is not None:
                queue.append(node.left)
            if node.right is not None:
                queue.append(node.right)
        if best_sum is None or total > best_sum:
            best_sum = total
            best_level = level
    return best_level


def good_nodes(root_values: list[int | None]) -> int:
    root = tree_from_list(root_values)
    count = 0

    def dfs(node: Node | None, maximum: float) -> None:
        nonlocal count
        if node is None:
            return
        if node.value >= maximum:
            count += 1
            maximum = node.value
        dfs(node.left, maximum)
        dfs(node.right, maximum)

    dfs(root, float("-inf"))
    return count


# ── 图 ────────────────────────────────────────────────────────────


def all_paths_source_target(graph: list[list[int]]) -> list[list[int]]:
    target = len(graph) - 1
    result: list[list[int]] = []
    path = [0]

    def dfs(node: int) -> None:
        if node == target:
            result.append(path[:])
            return
        for nxt in graph[node]:
            path.append(nxt)
            dfs(nxt)
            path.pop()

    dfs(0)
    return sorted(result)


def can_visit_all_rooms(rooms: list[list[int]]) -> bool:
    seen = {0}
    stack = [0]
    while stack:
        room = stack.pop()
        for key in rooms[room]:
            if key not in seen:
                seen.add(key)
                stack.append(key)
    return len(seen) == len(rooms)


def loud_and_rich(richer: list[list[int]], quiet: list[int]) -> list[int]:
    n = len(quiet)
    richer_than = [[] for _ in range(n)]
    for rich, poor in richer:
        richer_than[poor].append(rich)

    memo = [-1] * n

    def dfs(person: int) -> int:
        if memo[person] != -1:
            return memo[person]
        best = person
        for candidate in richer_than[person]:
            winner = dfs(candidate)
            if quiet[winner] < quiet[best] or (
                quiet[winner] == quiet[best] and winner < best
            ):
                best = winner
        memo[person] = best
        return best

    return [dfs(person) for person in range(n)]


def garden_no_adj(n: int, paths: list[list[int]]) -> list[int]:
    graph = [[] for _ in range(n + 1)]
    for first, second in paths:
        graph[first].append(second)
        graph[second].append(first)
    colors = [0] * (n + 1)
    for garden in range(1, n + 1):
        used = {colors[neighbor] for neighbor in graph[garden]}
        for color in range(1, 5):
            if color not in used:
                colors[garden] = color
                break
    return colors[1:]


def shortest_alternating_paths(
    n: int, red_edges: list[list[int]], blue_edges: list[list[int]]
) -> list[int]:
    red = [[] for _ in range(n)]
    blue = [[] for _ in range(n)]
    for start, end in red_edges:
        red[start].append(end)
    for start, end in blue_edges:
        blue[start].append(end)

    infinity = float("inf")
    distance = [[infinity, infinity] for _ in range(n)]
    distance[0][0] = 0
    distance[0][1] = 0
    queue = deque([(0, 0), (0, 1)])
    while queue:
        node, color = queue.popleft()
        edges = blue[node] if color == 0 else red[node]
        next_color = 1 - color
        for nxt in edges:
            if distance[nxt][next_color] == infinity:
                distance[nxt][next_color] = distance[node][color] + 1
                queue.append((nxt, next_color))
    return [
        -1 if min(red_distance, blue_distance) == infinity
        else min(red_distance, blue_distance)
        for red_distance, blue_distance in distance
    ]


def can_reach(arr: list[int], start: int) -> bool:
    n = len(arr)
    seen = {start}
    stack = [start]
    while stack:
        index = stack.pop()
        if arr[index] == 0:
            return True
        for nxt in (index - arr[index], index + arr[index]):
            if 0 <= nxt < n and nxt not in seen:
                seen.add(nxt)
                stack.append(nxt)
    return False


def min_reorder(n: int, connections: list[list[int]]) -> int:
    graph: list[list[tuple[int, int]]] = [[] for _ in range(n)]
    for start, end in connections:
        graph[start].append((end, 1))
        graph[end].append((start, 0))
    seen = [False] * n
    seen[0] = True
    stack = [0]
    changes = 0
    while stack:
        node = stack.pop()
        for nxt, cost in graph[node]:
            if not seen[nxt]:
                seen[nxt] = True
                changes += cost
                stack.append(nxt)
    return changes


def has_valid_path(grid: list[list[int]]) -> bool:
    rows, columns = len(grid), len(grid[0])
    openings = {
        1: {2, 3},
        2: {0, 1},
        3: {2, 1},
        4: {3, 1},
        5: {2, 0},
        6: {3, 0},
    }
    opposite = {0: 1, 1: 0, 2: 3, 3: 2}
    deltas = {0: (-1, 0), 1: (1, 0), 2: (0, -1), 3: (0, 1)}
    seen = {(0, 0)}
    stack = [(0, 0)]
    while stack:
        row, column = stack.pop()
        if (row, column) == (rows - 1, columns - 1):
            return True
        for direction in openings[grid[row][column]]:
            delta_row, delta_column = deltas[direction]
            next_row, next_column = row + delta_row, column + delta_column
            if (
                0 <= next_row < rows
                and 0 <= next_column < columns
                and (next_row, next_column) not in seen
                and opposite[direction] in openings[grid[next_row][next_column]]
            ):
                seen.add((next_row, next_column))
                stack.append((next_row, next_column))
    return (rows, columns) == (1, 1)


# ── 并查集 ────────────────────────────────────────────────────────


def find_redundant_connection(edges: list[list[int]]) -> list[int]:
    parent = list(range(len(edges) + 1))

    def find(node: int) -> int:
        while parent[node] != node:
            parent[node] = parent[parent[node]]
            node = parent[node]
        return node

    for start, end in edges:
        root_start, root_end = find(start), find(end)
        if root_start == root_end:
            return [start, end]
        parent[root_start] = root_end
    return []


def accounts_merge(accounts: list[list[str]]) -> list[list[str]]:
    parent: list[int] = []
    email_id: dict[str, int] = {}

    def get_id(email: str) -> int:
        if email not in email_id:
            email_id[email] = len(parent)
            parent.append(len(parent))
        return email_id[email]

    def find(node: int) -> int:
        while parent[node] != node:
            parent[node] = parent[parent[node]]
            node = parent[node]
        return node

    def union(first: int, second: int) -> None:
        root_first, root_second = find(first), find(second)
        if root_first != root_second:
            parent[root_first] = root_second

    for account in accounts:
        first = get_id(account[1])
        for email in account[2:]:
            union(first, get_id(email))

    names: dict[int, str] = {}
    for account in accounts:
        names[find(get_id(account[1]))] = account[0]

    groups: dict[int, list[str]] = defaultdict(list)
    for email, index in email_id.items():
        groups[find(index)].append(email)

    result = [[names[root]] + sorted(emails) for root, emails in groups.items()]
    result.sort(key=lambda item: (item[0], item[1]))
    return result


def remove_stones(stones: list[list[int]]) -> int:
    n = len(stones)
    parent = list(range(n))

    def find(node: int) -> int:
        while parent[node] != node:
            parent[node] = parent[parent[node]]
            node = parent[node]
        return node

    def union(first: int, second: int) -> None:
        root_first, root_second = find(first), find(second)
        if root_first != root_second:
            parent[root_first] = root_second

    row_owner: dict[int, int] = {}
    column_owner: dict[int, int] = {}
    for index, (row, column) in enumerate(stones):
        if row in row_owner:
            union(index, row_owner[row])
        else:
            row_owner[row] = index
        if column in column_owner:
            union(index, column_owner[column])
        else:
            column_owner[column] = index

    components = len({find(index) for index in range(n)})
    return n - components


def smallest_string_with_swaps(s: str, pairs: list[list[int]]) -> str:
    n = len(s)
    parent = list(range(n))

    def find(node: int) -> int:
        while parent[node] != node:
            parent[node] = parent[parent[node]]
            node = parent[node]
        return node

    def union(first: int, second: int) -> None:
        root_first, root_second = find(first), find(second)
        if root_first != root_second:
            parent[root_first] = root_second

    for first, second in pairs:
        union(first, second)

    groups: dict[int, list[int]] = defaultdict(list)
    for index in range(n):
        groups[find(index)].append(index)

    result = list(s)
    for indices in groups.values():
        characters = sorted(s[index] for index in indices)
        for index, character in zip(sorted(indices), characters):
            result[index] = character
    return "".join(result)


def smallest_equivalent_string(s1: str, s2: str, base_str: str) -> str:
    parent = list(range(26))

    def find(node: int) -> int:
        while parent[node] != node:
            parent[node] = parent[parent[node]]
            node = parent[node]
        return node

    def union(first: int, second: int) -> None:
        root_first, root_second = find(first), find(second)
        if root_first != root_second:
            if root_first < root_second:
                parent[root_second] = root_first
            else:
                parent[root_first] = root_second

    for first, second in zip(s1, s2):
        union(ord(first) - 97, ord(second) - 97)

    smallest = [26] * 26
    for code in range(26):
        root = find(code)
        smallest[root] = min(smallest[root], code)
    return "".join(chr(97 + smallest[find(ord(character) - 97)]) for character in base_str)


# ── 动态规划 ──────────────────────────────────────────────────────


def num_rolls_to_target(n: int, k: int, target: int) -> int:
    modulo = 10**9 + 7
    dp = [0] * (target + 1)
    dp[0] = 1
    for _ in range(n):
        following = [0] * (target + 1)
        for total in range(1, target + 1):
            ways = 0
            for face in range(1, min(k, total) + 1):
                ways += dp[total - face]
            following[total] = ways % modulo
        dp = following
    return dp[target]


def delete_and_earn(nums: list[int]) -> int:
    if not nums:
        return 0
    counts = Counter(nums)
    largest = max(nums)
    dp = [0] * (largest + 2)
    for value in range(1, largest + 1):
        pick = value * counts.get(value, 0)
        if value >= 2:
            pick += dp[value - 2]
        dp[value] = max(dp[value - 1], pick)
    return dp[largest]


def mincost_tickets(days: list[int], costs: list[int]) -> int:
    last_day = days[-1]
    travel = set(days)
    dp = [0] * (last_day + 1)
    for day in range(1, last_day + 1):
        if day not in travel:
            dp[day] = dp[day - 1]
            continue
        dp[day] = min(
            dp[max(0, day - 1)] + costs[0],
            dp[max(0, day - 7)] + costs[1],
            dp[max(0, day - 30)] + costs[2],
        )
    return dp[last_day]


def max_sum_after_partitioning(arr: list[int], k: int) -> int:
    n = len(arr)
    dp = [0] * (n + 1)
    for end in range(1, n + 1):
        best = 0
        maximum = 0
        for start in range(end - 1, max(-1, end - k - 1), -1):
            maximum = max(maximum, arr[start])
            best = max(best, dp[start] + maximum * (end - start))
        dp[end] = best
    return dp[n]


def min_height_shelves(books: list[list[int]], shelf_width: int) -> int:
    n = len(books)
    dp = [0] + [float("inf")] * n
    for end in range(1, n + 1):
        width = 0
        height = 0
        for start in range(end - 1, -1, -1):
            width += books[start][0]
            if width > shelf_width:
                break
            height = max(height, books[start][1])
            dp[end] = min(dp[end], dp[start] + height)
    return int(dp[n])


def longest_str_chain(words: list[str]) -> int:
    word_set = set(words)
    memo: dict[str, int] = {}

    def chain(word: str) -> int:
        if word in memo:
            return memo[word]
        best = 1
        for index in range(len(word)):
            predecessor = word[:index] + word[index + 1:]
            if predecessor in word_set:
                best = max(best, 1 + chain(predecessor))
        memo[word] = best
        return best

    return max((chain(word) for word in words), default=0)


def min_falling_path_sum(matrix: list[list[int]]) -> int:
    columns = len(matrix[0])
    dp = matrix[0][:]
    for row in range(1, len(matrix)):
        following = [0] * columns
        for column in range(columns):
            best = dp[column]
            if column > 0:
                best = min(best, dp[column - 1])
            if column + 1 < columns:
                best = min(best, dp[column + 1])
            following[column] = best + matrix[row][column]
        dp = following
    return min(dp)


def min_score_triangulation(values: list[int]) -> int:
    n = len(values)
    dp = [[0] * n for _ in range(n)]
    for length in range(3, n + 1):
        for start in range(0, n - length + 1):
            end = start + length - 1
            dp[start][end] = min(
                dp[start][middle] + dp[middle][end]
                + values[start] * values[middle] * values[end]
                for middle in range(start + 1, end)
            )
    return dp[0][n - 1]


def stone_game_ii(piles: list[int]) -> int:
    n = len(piles)
    suffix = [0] * (n + 1)
    for index in range(n - 1, -1, -1):
        suffix[index] = suffix[index + 1] + piles[index]
    memo: dict[tuple[int, int], int] = {}

    def dp(index: int, m: int) -> int:
        if index >= n:
            return 0
        key = (index, m)
        if key in memo:
            return memo[key]
        best = 0
        for taken in range(1, 2 * m + 1):
            if index + taken > n:
                break
            best = max(best, suffix[index] - dp(index + taken, max(m, taken)))
        memo[key] = best
        return best

    return dp(0, 1)


# ── 回溯 ──────────────────────────────────────────────────────────


def num_tile_possibilities(tiles: str) -> int:
    counts = [0] * 26
    for character in tiles:
        counts[ord(character) - 65] += 1
    memo: dict[tuple[int, ...], int] = {}

    def dfs(state: tuple[int, ...]) -> int:
        if state in memo:
            return memo[state]
        total = 0
        for code in range(26):
            if state[code]:
                following = list(state)
                following[code] -= 1
                total += 1 + dfs(tuple(following))
        memo[state] = total
        return total

    return dfs(tuple(counts))


def get_maximum_gold(grid: list[list[int]]) -> int:
    rows, columns = len(grid), len(grid[0])

    def dfs(row: int, column: int) -> int:
        gold = grid[row][column]
        grid[row][column] = 0
        best_extra = 0
        for delta_row, delta_column in ((1, 0), (-1, 0), (0, 1), (0, -1)):
            next_row, next_column = row + delta_row, column + delta_column
            if (
                0 <= next_row < rows
                and 0 <= next_column < columns
                and grid[next_row][next_column] > 0
            ):
                best_extra = max(best_extra, dfs(next_row, next_column))
        grid[row][column] = gold
        return gold + best_extra

    answer = 0
    for row in range(rows):
        for column in range(columns):
            if grid[row][column] > 0:
                answer = max(answer, dfs(row, column))
    return answer


def max_length(arr: list[str]) -> int:
    words: list[tuple[int, int]] = []
    for word in arr:
        mask = 0
        valid = True
        for character in word:
            bit = 1 << (ord(character) - 97)
            if mask & bit:
                valid = False
                break
            mask |= bit
        if valid:
            words.append((mask, len(word)))

    memo: dict[tuple[int, int], int] = {}

    def dfs(index: int, used: int) -> int:
        if index == len(words):
            return 0
        key = (index, used)
        if key in memo:
            return memo[key]
        best = dfs(index + 1, used)
        word_mask, word_length = words[index]
        if not used & word_mask:
            best = max(best, word_length + dfs(index + 1, used | word_mask))
        memo[key] = best
        return best

    return dfs(0, 0)


def get_happy_string(n: int, k: int) -> str:
    count = 0
    answer = ""

    def build(prefix: str, last: str) -> bool:
        nonlocal count, answer
        if len(prefix) == n:
            count += 1
            if count == k:
                answer = prefix
            return count >= k
        for character in "abc":
            if character != last and build(prefix + character, character):
                return True
        return False

    build("", "")
    return answer


def nums_same_consec_diff(n: int, k: int) -> list[int]:
    result: list[int] = []

    def dfs(value: int, length: int) -> None:
        if length == n:
            result.append(value)
            return
        last = value % 10
        for digit in {last - k, last + k}:
            if 0 <= digit <= 9:
                dfs(value * 10 + digit, length + 1)

    for first in range(1, 10):
        dfs(first, 1)
    return sorted(result)


# ── 贪心 ──────────────────────────────────────────────────────────


def partition_labels(s: str) -> list[int]:
    last = {character: index for index, character in enumerate(s)}
    result: list[int] = []
    start = 0
    end = 0
    for index, character in enumerate(s):
        end = max(end, last[character])
        if index == end:
            result.append(end - start + 1)
            start = index + 1
    return result


def two_city_sched_cost(costs: list[list[int]]) -> int:
    costs = sorted(costs, key=lambda cost: cost[0] - cost[1])
    half = len(costs) // 2
    return sum(cost[0] for cost in costs[:half]) + sum(cost[1] for cost in costs[half:])


def num_rescue_boats(people: list[int], limit: int) -> int:
    people = sorted(people)
    left, right = 0, len(people) - 1
    boats = 0
    while left <= right:
        if people[left] + people[right] <= limit:
            left += 1
        right -= 1
        boats += 1
    return boats


def moves_to_make_zigzag(nums: list[int]) -> int:
    n = len(nums)
    if n == 1:
        return 0

    def cost(valley_parity: int) -> int:
        total = 0
        for index in range(valley_parity, n, 2):
            limit = float("inf")
            if index > 0:
                limit = min(limit, nums[index - 1] - 1)
            if index + 1 < n:
                limit = min(limit, nums[index + 1] - 1)
            if nums[index] > limit:
                total += nums[index] - limit
        return total

    return min(cost(0), cost(1))


def minimum_swap(s1: str, s2: str) -> int:
    first = 0
    second = 0
    for left, right in zip(s1, s2):
        if left == right:
            continue
        if left == "x":
            first += 1
        elif left == "y":
            second += 1
        else:
            return -1
    if (first + second) % 2:
        return -1
    return first // 2 + second // 2 + (first % 2) * 2


def remove_covered_intervals(intervals: list[list[int]]) -> int:
    intervals = sorted(intervals, key=lambda interval: (interval[0], -interval[1]))
    remaining = 0
    previous_end = -1
    for _, end in intervals:
        if end > previous_end:
            remaining += 1
            previous_end = end
    return remaining


def min_set_size(arr: list[int]) -> int:
    counts = sorted(Counter(arr).values(), reverse=True)
    half = len(arr) / 2
    removed = 0
    total = 0
    for count in counts:
        total += count
        removed += 1
        if total >= half:
            return removed
    return removed


def max_events(events: list[list[int]]) -> int:
    events.sort()
    heap: list[int] = []
    index = 0
    day = 0
    attended = 0
    n = len(events)
    while index < n or heap:
        if not heap:
            day = max(day, events[index][0])
        while index < n and events[index][0] <= day:
            heapq.heappush(heap, events[index][1])
            index += 1
        while heap and heap[0] < day:
            heapq.heappop(heap)
        if heap:
            heapq.heappop(heap)
            attended += 1
        day += 1
    return attended


PROBLEMS = [
    make(
        pid=1617,
        title="最大二叉树",
        tags=["树", "递归", "分治"],
        description="""给定一个不含重复元素的整数数组 nums
按以下规则递归构建二叉树：根节点为数组中的最大值，最大值左侧的子数组递归构建左子树，右侧的子数组递归构建右子树
返回构建出的二叉树，用层序序列表示，末尾多余的 null 省略""",
        function="constructMaximumBinaryTree",
        params=[("nums", "int[]")],
        returns="TreeNode",
        solver=construct_maximum_binary_tree,
        public=[[[3, 2, 1, 6, 0, 5]], [[3, 2, 1]], [[1]]],
        hidden=[[[2, 1, 3]], [[1, 2, 3, 4]], [[5, 4, 3, 2, 1]], [[3, 2, 1, 6, 0, 5, 7]]],
    ),
    make(
        pid=1618,
        title="最长同值路径",
        tags=["树", "深度优先搜索"],
        description="""给定二叉树的根节点 root，用层序列表表示，null 表示空节点
同值路径指路径上所有节点值相同，路径长度为经过的边数
路径不要求经过根节点，也不要求只向下延伸，可以在某个节点处连接左右两侧
返回最长的同值路径长度""",
        function="longestUnivaluePath",
        params=[("root", "TreeNode")],
        returns="int",
        solver=longest_univalue_path,
        public=[
            [[5, 4, 5, 1, 1, None, 5]],
            [[1, 4, 5, 4, 4, None, 5]],
            [[1]],
        ],
        hidden=[
            [[1, 1]],
            [[1, None, 1, 1, 1, 1, 1, None, 1]],
            [[4, 4, 4, 4, 4]],
            [[1, 2, 3]],
        ],
    ),
    make(
        pid=1619,
        title="二叉树剪枝",
        tags=["树", "深度优先搜索"],
        description="""给定二叉树的根节点 root，用层序列表表示，null 表示空节点
剪掉所有不包含 1 的子树，即删除所有节点值全为 0 的子树
返回剪枝后的二叉树，用层序序列表示""",
        function="pruneTree",
        params=[("root", "TreeNode")],
        returns="TreeNode",
        solver=prune_tree,
        public=[
            [[1, None, 0, 0, 1]],
            [[1, 0, 1, 0, 0, 0, 1]],
            [[1, 1, 0, 1, 1, 0, 1, 0]],
        ],
        hidden=[[[0]], [[1]], [[0, 0, 0]], [[1, 0, 0, None, 0, 0, None]]],
    ),
    make(
        pid=1620,
        title="二叉树的完全性检验",
        tags=["树", "广度优先搜索"],
        description="""给定二叉树的根节点 root，用层序列表表示，null 表示空节点
完全二叉树要求除最后一层外每一层都填满，且最后一层的节点都连续集中在最左边
判断该树是否为完全二叉树""",
        function="isCompleteTree",
        params=[("root", "TreeNode")],
        returns="bool",
        solver=is_complete_tree,
        public=[[[1, 2, 3, 4, 5, 6]], [[1, 2, 3, 4, 5, None, 7]], [[1]]],
        hidden=[[[1, 2, 3, 4, 5, 6, 7]], [[1, 2, None, 3]], [[1, 2, 3, 4]], [[1, None, 2, 3]]],
    ),
    make(
        pid=1621,
        title="在二叉树中分配硬币",
        tags=["树", "深度优先搜索"],
        description="""给定二叉树的根节点 root，节点值表示该节点上的硬币数，硬币总数为节点总数
每次操作可以把一枚硬币从某个节点移动到相邻的父节点或子节点
返回使每个节点恰好有一枚硬币所需的最少移动次数""",
        function="distributeCoins",
        params=[("root", "TreeNode")],
        returns="int",
        solver=distribute_coins,
        public=[[[3, 0, 0]], [[0, 3, 0]], [[1, 0, 2]]],
        hidden=[
            [[1, 0, 0, None, 3]],
            [[2, 1, 0]],
            [[2, 1, 2, 0, 0]],
            [[3, 1, 1, 0, 0, 0, 0]],
        ],
    ),
    make(
        pid=1622,
        title="前序遍历构造二叉搜索树",
        tags=["树", "二叉搜索树", "递归"],
        description="""给定一棵二叉搜索树的前序遍历结果 preorder，节点值互不相同
请根据该遍历结果重构二叉搜索树并返回
返回的树用层序序列表示，末尾多余的 null 省略""",
        function="bstFromPreorder",
        params=[("preorder", "int[]")],
        returns="TreeNode",
        solver=bst_from_preorder,
        public=[[[8, 5, 1, 7, 10, 12]], [[1, 3]], [[4, 2, 1, 3]]],
        hidden=[[[2, 1, 3]], [[1, 2, 3, 4, 5]], [[5, 3, 2, 4, 8, 7, 9]], [[10, 5, 1, 7, 40, 50]]],
    ),
    make(
        pid=1623,
        title="最大层内元素和",
        tags=["树", "广度优先搜索"],
        description="""给定二叉树的根节点 root，用层序列表表示，null 表示空节点
根节点所在层为第 1 层，返回元素和最大的层号
若有多层元素和并列最大，返回层号较小的那一层""",
        function="maxLevelSum",
        params=[("root", "TreeNode")],
        returns="int",
        solver=max_level_sum,
        public=[
            [[1, 7, 0, 7, -8, None, None]],
            [[989, None, 10250, 98693, -89388, None, None, None, -32127]],
            [[1, 2, None]],
        ],
        hidden=[
            [[1]],
            [[1, 2, 3]],
            [[-1, -2, -3, -4, -5]],
            [[5, 4, 8, 11, None, 13, 4, 7, 2, None, None, None, 1]],
        ],
    ),
    make(
        pid=1624,
        title="统计二叉树中好节点的数目",
        tags=["树", "深度优先搜索"],
        description="""给定二叉树的根节点 root，用层序列表表示，null 表示空节点
好节点定义为：从根节点到该节点路径上不存在值严格大于该节点值的节点
返回好节点的数目""",
        function="goodNodes",
        params=[("root", "TreeNode")],
        returns="int",
        solver=good_nodes,
        public=[
            [[3, 1, 4, 3, None, 1, 5]],
            [[3, 3, None, 4, 2]],
            [[1]],
        ],
        hidden=[
            [[2, None, 4, 10, 8, None, None, 4]],
            [[9, None, 3, 6]],
            [[1, 2, 3]],
            [[5, 4, 3, 2, 1]],
        ],
    ),
    make(
        pid=1625,
        title="所有可能的路径",
        tags=["图", "深度优先搜索", "回溯"],
        description="""给定一个有 n 个节点的有向无环图，节点编号为 0 到 n-1
graph[i] 是节点 i 的所有出边终点列表
返回所有从节点 0 到节点 n-1 的路径
每条路径按经过的节点顺序排列，所有路径按字典序升序排列""",
        function="allPathsSourceTarget",
        params=[("graph", "int[][]")],
        returns="int[][]",
        solver=all_paths_source_target,
        public=[
            [[[1, 2], [3], [3], []]],
            [[[4, 3, 1], [3, 2, 4], [3], [4], []]],
            [[[1], []]],
        ],
        hidden=[
            [[[1, 2, 3], [2], [3], []]],
            [[[1, 2], [2, 3], [3], []]],
            [[[1], [2], [3], []]],
            [[[1, 2, 3, 4], [2, 3, 4], [3, 4], [4], []]],
        ],
    ),
    make(
        pid=1626,
        title="钥匙和房间",
        tags=["图", "广度优先搜索"],
        description="""有 n 个房间，编号为 0 到 n-1，初始时你在 0 号房间，其余房间都锁着
rooms[i] 是进入房间 i 后能拿到的钥匙列表，每把钥匙可以打开对应编号的房间
判断是否能够进入所有房间""",
        function="canVisitAllRooms",
        params=[("rooms", "int[][]")],
        returns="bool",
        solver=can_visit_all_rooms,
        public=[
            [[[1], [2], [3], []]],
            [[[1, 3], [3, 0, 1], [2], [0]]],
            [[[0]]],
        ],
        hidden=[
            [[[1], [0]]],
            [[[1, 2], [2, 1], []]],
            [[[1], [2], [0]]],
            [[[2], [], [1]]],
        ],
    ),
    make(
        pid=1627,
        title="喧闹和富有",
        tags=["图", "深度优先搜索", "记忆化"],
        description="""有 n 个人，编号为 0 到 n-1
richer[i] = [a, b] 表示 a 比 b 更有钱，该关系可以传递
quiet[i] 表示第 i 个人的安静值，数值越小越安静
对每个人返回所有比他更有钱的人（包括他自己）中安静值最小的人的编号
若安静值相同，返回编号较小的人""",
        function="loudAndRich",
        params=[("richer", "int[][]"), ("quiet", "int[]")],
        returns="int[]",
        solver=loud_and_rich,
        public=[
            [
                [[1, 0], [2, 1], [3, 1], [3, 7], [4, 3], [5, 3], [6, 3]],
                [3, 2, 5, 4, 6, 1, 7, 0],
            ],
            [[], [3, 1, 2]],
            [[[0, 1]], [0, 1]],
        ],
        hidden=[
            [[[1, 0], [2, 1]], [2, 1, 3]],
            [[[1, 0], [2, 0], [3, 1], [3, 2]], [5, 4, 3, 2]],
            [[[2, 1], [3, 2], [4, 3]], [9, 8, 7, 6, 5]],
            [[[1, 0]], [0, 0]],
        ],
    ),
    make(
        pid=1628,
        title="不邻接植花",
        tags=["图", "贪心"],
        description="""有 n 个花园，编号为 1 到 n，另有若干条连接两个花园的小路
每个花园需要种一种花，花的种类编号为 1 到 4
任意一条小路连接的两个花园必须种不同种类的花，输入保证存在合法方案
按花园编号从小到大，每个花园选择不与已着色邻居冲突的最小编号花色
返回长度为 n 的数组，第 i 个元素为花园 i+1 的花色""",
        function="gardenNoAdj",
        params=[("n", "int"), ("paths", "int[][]")],
        returns="int[]",
        solver=garden_no_adj,
        public=[
            [3, [[1, 2], [2, 3], [3, 1]]],
            [4, [[1, 2], [3, 4]]],
            [4, [[1, 2], [2, 3], [3, 4], [4, 1], [1, 3], [2, 4]]],
        ],
        hidden=[
            [1, []],
            [2, [[1, 2]]],
            [5, [[1, 2], [2, 3], [3, 4], [4, 5]]],
            [4, [[1, 2], [1, 3], [1, 4]]],
        ],
    ),
    make(
        pid=1629,
        title="颜色交替的最短路径",
        tags=["图", "广度优先搜索"],
        description="""给定有 n 个节点的有向图，节点编号为 0 到 n-1
redEdges 和 blueEdges 分别描述红色和蓝色有向边，每条边为 [起点, 终点]
从节点 0 出发，路径上的边颜色必须红蓝交替
返回从节点 0 到每个节点的最短路径长度，无法到达的节点返回 -1""",
        function="shortestAlternatingPaths",
        params=[("n", "int"), ("redEdges", "int[][]"), ("blueEdges", "int[][]")],
        returns="int[]",
        solver=shortest_alternating_paths,
        public=[
            [3, [[0, 1], [1, 2]], []],
            [3, [[0, 1]], [[2, 1]]],
            [3, [[0, 1], [0, 2]], [[1, 0]]],
        ],
        hidden=[
            [3, [[0, 1]], [[1, 2]]],
            [2, [[0, 1]], [[0, 1]]],
            [4, [[0, 1], [2, 3]], [[1, 2], [3, 0]]],
            [1, [], []],
        ],
    ),
    make(
        pid=1630,
        title="跳跃游戏 III",
        tags=["图", "广度优先搜索", "深度优先搜索"],
        description="""给定非负整数数组 arr 和起始下标 start
从下标 i 出发，可以跳到 i - arr[i] 或 i + arr[i]，前提是目标下标在数组范围内
判断能否到达任意一个值为 0 的下标""",
        function="canReach",
        params=[("arr", "int[]"), ("start", "int")],
        returns="bool",
        solver=can_reach,
        public=[
            [[4, 2, 3, 0, 3, 1, 2], 5],
            [[4, 2, 3, 0, 3, 1, 2], 0],
            [[3, 0, 2, 1, 2], 2],
        ],
        hidden=[[[0], 0], [[1, 0], 1], [[2, 0, 1], 1], [[1, 1, 0], 0]],
    ),
    make(
        pid=1631,
        title="重新规划路线",
        tags=["图", "深度优先搜索"],
        description="""有 n 个城市，编号为 0 到 n-1，城市之间共有 n-1 条道路构成一棵树
connections[i] = [a, b] 表示存在一条从 a 到 b 的单向道路
为了让所有道路都能直接或间接通向 0 号城市，需要改变部分道路的方向
返回最少需要改变方向的道路数目""",
        function="minReorder",
        params=[("n", "int"), ("connections", "int[][]")],
        returns="int",
        solver=min_reorder,
        public=[
            [6, [[0, 1], [1, 3], [2, 3], [4, 0], [4, 5]]],
            [5, [[1, 0], [1, 2], [3, 2], [3, 4]]],
            [3, [[1, 0], [2, 0]]],
        ],
        hidden=[
            [2, [[1, 0]]],
            [4, [[0, 1], [2, 1], [3, 2]]],
            [5, [[0, 1], [1, 2], [2, 3], [3, 4]]],
            [4, [[1, 0], [2, 1], [3, 2]]],
        ],
    ),
    make(
        pid=1632,
        title="检查网格中是否存在有效路径",
        tags=["图", "广度优先搜索", "并查集"],
        description="""给定 m x n 的网格 grid，每个格子中的数字表示一种管道形状
1 表示连接左右，2 表示连接上下，3 表示连接左下，4 表示连接右下，5 表示连接左上，6 表示连接右上
管道之间只有在相邻格子的开口互相对接时才算连通
判断能否从左上角 (0, 0) 沿连通的管道走到右下角 (m-1, n-1)""",
        function="hasValidPath",
        params=[("grid", "int[][]")],
        returns="bool",
        solver=has_valid_path,
        public=[
            [[[2, 4, 3], [6, 5, 2]]],
            [[[1, 2, 1], [1, 2, 1]]],
            [[[1, 1, 2]]],
            [[[1, 1, 1, 1, 1, 1, 3]]],
        ],
        hidden=[
            [[[1]]],
            [[[2]]],
            [[[2], [2], [2]]],
            [[[4, 3], [5, 2]]],
        ],
    ),
    make(
        pid=1633,
        title="冗余连接",
        tags=["并查集", "图"],
        description="""给定一个由 n 个节点和 n 条边组成的无向图，节点编号为 1 到 n
该图由一棵树额外增加一条边得到，返回可以删除的那条边
如果有多条边都可以删除，返回在输入中最后出现的那一条
每条边以 [a, b] 形式给出，返回格式相同""",
        function="findRedundantConnection",
        params=[("edges", "int[][]")],
        returns="int[]",
        solver=find_redundant_connection,
        public=[
            [[[1, 2], [1, 3], [2, 3]]],
            [[[1, 2], [2, 3], [3, 4], [1, 4], [1, 5]]],
            [[[1, 2], [2, 3], [3, 1]]],
        ],
        hidden=[
            [[[1, 2], [2, 3], [1, 3]]],
            [[[1, 2], [2, 3], [3, 4], [4, 1]]],
            [[[1, 2], [1, 3], [1, 4], [2, 3]]],
            [[[1, 2], [2, 3], [3, 4], [4, 5], [2, 5]]],
        ],
    ),
    make(
        pid=1634,
        title="账户合并",
        tags=["并查集", "哈希表", "排序"],
        description="""给定账户列表 accounts，每个账户的第一个元素是姓名，其余元素是该账户的邮箱
只要两个账户拥有相同的邮箱，它们就属于同一个人，需要合并
合并后每个人的账户为姓名加上其所有邮箱
每组邮箱按字典序升序排列，最终结果按姓名升序排列，姓名相同则按第一个邮箱升序排列""",
        function="accountsMerge",
        params=[("accounts", "string[][]")],
        returns="string[][]",
        solver=accounts_merge,
        public=[
            [
                [
                    ["John", "johnsmith@mail.com", "john_newyork@mail.com"],
                    ["John", "johnsmith@mail.com", "john00@mail.com"],
                    ["Mary", "mary@mail.com"],
                    ["John", "johnnybravo@mail.com"],
                ]
            ],
            [
                [
                    ["Gabe", "Gabe0@m.co", "Gabe3@m.co", "Gabe1@m.co"],
                    ["Kevin", "Kevin3@m.co", "Kevin5@m.co", "Kevin0@m.co"],
                    ["Ethan", "Ethan5@m.co", "Ethan4@m.co", "Ethan0@m.co"],
                    ["Hanzo", "Hanzo3@m.co", "Hanzo1@m.co", "Hanzo0@m.co"],
                    ["Fern", "Fern5@m.co", "Fern1@m.co", "Fern0@m.co"],
                ]
            ],
            [
                [
                    ["David", "David0@m.co", "David1@m.co"],
                    ["David", "David3@m.co", "David4@m.co"],
                    ["David", "David4@m.co", "David5@m.co"],
                    ["David", "David2@m.co", "David3@m.co"],
                    ["David", "David1@m.co", "David2@m.co"],
                ]
            ],
        ],
        hidden=[
            [[["John", "a@b.c"]]],
            [[["A", "x@y.z", "p@q.r"], ["A", "p@q.r", "m@n.o"]]],
            [
                [
                    ["A", "a@b", "c@d"],
                    ["A", "c@d", "e@f"],
                    ["B", "g@h"],
                    ["B", "i@j", "g@h"],
                ]
            ],
            [[["Z", "z@z", "zz@z"], ["Y", "y@y"], ["Z", "z@z"]]],
        ],
    ),
    make(
        pid=1635,
        title="移除最多的同行或同列石头",
        tags=["并查集", "图"],
        description="""给定二维平面上的 n 块石头，stones[i] = [x, y] 表示第 i 块石头的坐标
如果两块石头在同一行或同一列，可以移除其中一块
每次移除后其余石头位置不变，同一位置不会有多块石头
返回最多可以移除的石头数目""",
        function="removeStones",
        params=[("stones", "int[][]")],
        returns="int",
        solver=remove_stones,
        public=[
            [[[0, 0], [0, 1], [1, 0], [1, 2], [2, 1], [2, 2]]],
            [[[0, 0], [0, 2], [1, 1], [2, 0], [2, 2]]],
            [[[0, 0]]],
        ],
        hidden=[
            [[[0, 0], [0, 1]]],
            [[[0, 0], [1, 1], [2, 2]]],
            [[[0, 0], [1, 0], [2, 0], [3, 0]]],
            [[[0, 0], [0, 1], [1, 1]]],
        ],
    ),
    make(
        pid=1636,
        title="交换字符串中的元素",
        tags=["并查集", "字符串", "排序"],
        description="""给定字符串 s 和下标对数组 pairs
pairs[i] = [a, b] 表示可以任意次交换 s[a] 和 s[b] 的字符
经过任意多次交换后，返回能够得到的字典序最小的字符串""",
        function="smallestStringWithSwaps",
        params=[("s", "string"), ("pairs", "int[][]")],
        returns="string",
        solver=smallest_string_with_swaps,
        public=[
            ["dcab", [[0, 3], [1, 2]]],
            ["dcab", [[0, 3], [1, 2], [0, 2]]],
            ["cba", [[0, 1], [1, 2]]],
        ],
        hidden=[
            ["a", []],
            ["ba", [[0, 1]]],
            ["abcd", []],
            ["dcba", [[0, 1], [1, 2], [2, 3]]],
        ],
    ),
    make(
        pid=1637,
        title="按字典序排列最小的等效字符串",
        tags=["并查集", "字符串"],
        description="""给定两个等长字符串 s1 和 s2，以及字符串 baseStr
s1[i] 与 s2[i] 属于同一等价类，等价关系具有传递性
把 baseStr 中每个字符替换成它所在等价类中字典序最小的字符
返回替换后的字符串""",
        function="smallestEquivalentString",
        params=[("s1", "string"), ("s2", "string"), ("baseStr", "string")],
        returns="string",
        solver=smallest_equivalent_string,
        public=[
            ["parker", "morris", "parser"],
            ["hello", "world", "hold"],
            ["leetcode", "programs", "sourcecode"],
        ],
        hidden=[
            ["a", "b", "c"],
            ["abc", "def", "ghi"],
            ["ab", "bc", "abc"],
            ["z", "y", "x"],
        ],
    ),
    make(
        pid=1638,
        title="掷骰子等于目标和的方法数",
        tags=["动态规划"],
        description="""有 n 个骰子，每个骰子有 k 个面，面上的数字为 1 到 k
同时掷出所有骰子，求点数之和恰好等于 target 的方案数
结果对 10^9 + 7 取模""",
        function="numRollsToTarget",
        params=[("n", "int"), ("k", "int"), ("target", "int")],
        returns="int",
        solver=num_rolls_to_target,
        public=[[1, 6, 3], [2, 6, 7], [30, 30, 500]],
        hidden=[[1, 6, 1], [2, 6, 2], [5, 3, 10], [10, 10, 100]],
    ),
    make(
        pid=1639,
        title="删除并获得点数",
        tags=["动态规划", "数组"],
        description="""给定整数数组 nums
选择任意一个数字 x 可以获得 x 分，随后必须删除数组中所有等于 x-1 和 x+1 的数字
可以重复该过程，返回能够获得的最大总分数""",
        function="deleteAndEarn",
        params=[("nums", "int[]")],
        returns="int",
        solver=delete_and_earn,
        public=[
            [[3, 4, 2]],
            [[2, 2, 3, 3, 3, 4]],
            [[1, 1, 1, 2, 4, 5, 5, 5, 6]],
        ],
        hidden=[[[1]], [[1, 2, 3, 4, 5]], [[2, 2, 2, 2]], [[1, 1, 2, 2, 3, 3, 4, 4]]],
    ),
    make(
        pid=1640,
        title="最低票价",
        tags=["动态规划", "数组"],
        description="""给定一个升序数组 days，表示未来一年中需要出行的日期
costs = [一天通行证价格, 七天通行证价格, 三十天通行证价格]
通行证在购买当天生效，可以覆盖连续的天数，返回覆盖所有出行日的最少花费""",
        function="mincostTickets",
        params=[("days", "int[]"), ("costs", "int[]")],
        returns="int",
        solver=mincost_tickets,
        public=[
            [[1, 4, 6, 7, 8, 20], [2, 7, 15]],
            [[1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 30, 31], [2, 7, 15]],
            [[1, 2, 3], [2, 7, 15]],
        ],
        hidden=[
            [[1], [2, 7, 15]],
            [[1, 365], [2, 7, 15]],
            [[1, 2, 4, 5, 6, 7, 8, 20], [2, 7, 15]],
            [[1, 4, 6, 7, 8, 20], [7, 2, 15]],
        ],
    ),
    make(
        pid=1641,
        title="分隔数组以得到最大和",
        tags=["动态规划", "数组"],
        description="""给定整数数组 arr 和整数 k
将数组分成若干个连续子数组，每个子数组的长度不超过 k
每个子数组的值等于该子数组的长度乘以子数组中的最大值
返回所有子数组值之和的最大值""",
        function="maxSumAfterPartitioning",
        params=[("arr", "int[]"), ("k", "int")],
        returns="int",
        solver=max_sum_after_partitioning,
        public=[
            [[1, 15, 7, 9, 2, 5, 10], 3],
            [[1, 4, 1, 5, 7, 3, 6, 1, 9, 3], 4],
            [[1], 1],
        ],
        hidden=[
            [[1, 2, 3], 1],
            [[1, 2, 3], 2],
            [[7, 9, 1], 3],
            [[2, 1, 4, 3], 2],
        ],
    ),
    make(
        pid=1642,
        title="填充书架",
        tags=["动态规划", "数组"],
        description="""给定二维数组 books，books[i] = [厚度, 高度]，以及书架宽度 shelfWidth
按给定顺序把书依次摆放到书架上，每层放的书总厚度不能超过 shelfWidth
每层的高度等于该层中最高的书，书架总高度为各层高度之和
返回摆放所有书的最小总高度""",
        function="minHeightShelves",
        params=[("books", "int[][]"), ("shelfWidth", "int")],
        returns="int",
        solver=min_height_shelves,
        public=[
            [[[1, 1], [2, 3], [2, 3], [1, 1], [1, 1], [1, 1], [1, 2]], 4],
            [[[1, 3], [2, 4], [3, 2]], 6],
            [[[1, 1], [2, 1], [3, 1]], 4],
        ],
        hidden=[
            [[[1, 1]], 1],
            [[[1, 4], [2, 1]], 5],
            [[[1, 2], [2, 2], [3, 2]], 4],
            [[[2, 3], [1, 1], [1, 1]], 4],
        ],
    ),
    make(
        pid=1643,
        title="最长字符串链",
        tags=["动态规划", "哈希表", "字符串"],
        description="""给定单词数组 words
如果单词 word2 可以由 word1 在任意位置插入一个字母得到，则称 word1 是 word2 的前身
字符串链是一系列单词，其中每个单词都是下一个单词的前身
返回最长的字符串链长度""",
        function="longestStrChain",
        params=[("words", "string[]")],
        returns="int",
        solver=longest_str_chain,
        public=[
            [["a", "b", "ba", "bca", "bda", "bdca"]],
            [["xbc", "pcxbcf", "xb", "cxbc", "pcxbc"]],
            [["abcd", "dbqca"]],
        ],
        hidden=[
            [["a"]],
            [["a", "b", "c"]],
            [["abc", "abd", "ab", "a"]],
            [["ksqvsyq", "ks", "kss", "czvh", "zczpzvdhx", "czpzvd", "czpzvdv"]],
        ],
    ),
    make(
        pid=1644,
        title="下降路径最小和",
        tags=["动态规划", "矩阵"],
        description="""给定 m x n 的整数矩阵 matrix
从第一行的任意元素出发，每次移动到下一行的同一列或相邻列
到达最后一行时，返回经过元素之和的最小值""",
        function="minFallingPathSum",
        params=[("matrix", "int[][]")],
        returns="int",
        solver=min_falling_path_sum,
        public=[
            [[[2, 1, 3], [6, 5, 4], [7, 8, 9]]],
            [[[-19, 57], [-40, -5]]],
            [[[-48]]],
        ],
        hidden=[
            [[[1, 2, 3]]],
            [[[1], [2], [3]]],
            [[[1, 2], [3, 4]]],
            [[[-1, -2, -3], [-4, -5, -6], [-7, -8, -9]]],
        ],
    ),
    make(
        pid=1645,
        title="多边形三角剖分的最低得分",
        tags=["动态规划", "区间动态规划"],
        description="""给定一个凸多边形，values[i] 是第 i 个顶点的值，顶点按顺序排列
用 n-3 条不相交的对角线把多边形剖分成 n-2 个三角形
每个三角形的得分等于三个顶点值的乘积，总得分为所有三角形得分之和
返回所有剖分方案中的最低得分""",
        function="minScoreTriangulation",
        params=[("values", "int[]")],
        returns="int",
        solver=min_score_triangulation,
        public=[[[1, 2, 3]], [[3, 7, 4, 5]], [[1, 3, 1, 4, 1, 5]]],
        hidden=[[[2, 3, 4]], [[1, 2, 3, 4]], [[4, 3, 2, 1]], [[1, 5, 2, 6, 3]]],
    ),
    make(
        pid=1646,
        title="石子游戏 II",
        tags=["动态规划", "博弈"],
        description="""有若干堆石子排成一行，piles[i] 表示第 i 堆的石子数
两名玩家轮流取石子，先手初始可取前 1 到 2M 堆，初始 M = 1
取走 k 堆后，下一个玩家的 M 更新为 max(M, k)
两人都采用最优策略，返回先手最多能拿到的石子总数""",
        function="stoneGameII",
        params=[("piles", "int[]")],
        returns="int",
        solver=stone_game_ii,
        public=[[[2, 7, 9, 4, 4]], [[1, 2, 3, 4, 5, 100]], [[1]]],
        hidden=[
            [[1, 1]],
            [[5, 4, 3, 2, 1]],
            [[1, 2, 3, 4, 5, 6, 7, 8, 9, 10]],
            [[10, 10, 10, 10, 10, 10, 10, 10, 10, 10]],
        ],
    ),
    make(
        pid=1647,
        title="活字印刷",
        tags=["回溯", "字符串"],
        description="""给定一个字符串 tiles，其中每个字符代表一块字母牌
可以任意选择若干块牌并按任意顺序排列，组成非空序列
返回能够组成的不同非空序列的数目""",
        function="numTilePossibilities",
        params=[("tiles", "string")],
        returns="int",
        solver=num_tile_possibilities,
        public=[["AAB"], ["AAABBC"], ["V"]],
        hidden=[["A"], ["AB"], ["AAAB"], ["ABCD"], ["AABBCC"]],
    ),
    make(
        pid=1648,
        title="黄金矿工",
        tags=["回溯", "矩阵"],
        description="""给定 m x n 的网格 grid，0 表示空地，正数表示该格子的金子数
可以从任意一个含金子的格子出发，每次上下左右移动到一个含金子的格子
已经采集过的格子不能再次进入，返回能够采集到的最大金子总数""",
        function="getMaximumGold",
        params=[("grid", "int[][]")],
        returns="int",
        solver=get_maximum_gold,
        public=[
            [[[0, 6, 0], [5, 8, 7], [0, 9, 0]]],
            [[[1, 0, 7], [2, 0, 6], [3, 4, 5], [0, 3, 0], [9, 0, 20]]],
            [[[2, 3, 4]]],
        ],
        hidden=[
            [[[1, 0]]],
            [[[0, 1]]],
            [[[1, 0, 1], [0, 1, 0]]],
            [[[1, 1], [1, 1]]],
        ],
    ),
    make(
        pid=1649,
        title="串联字符串的最大长度",
        tags=["回溯", "位运算", "字符串"],
        description="""给定字符串数组 arr
从中选择若干个字符串并按任意顺序拼接，要求拼接结果中每个字母最多出现一次
返回拼接后字符串的最大长度""",
        function="maxLength",
        params=[("arr", "string[]")],
        returns="int",
        solver=max_length,
        public=[
            [["un", "iq", "ue"]],
            [["cha", "r", "act", "ers"]],
            [["abcdefghijklmnopqrstuvwxyz"]],
        ],
        hidden=[[["a"]], [["aa", "bb"]], [["abc", "bcd", "cde"]], [["ab", "cd", "ef"]]],
    ),
    make(
        pid=1650,
        title="长度为 n 的开心字符串中字典序第 k 小的字符串",
        tags=["回溯", "字符串"],
        description="""开心字符串只包含字母 a、b、c，且相邻字符不能相同
给定长度 n 和整数 k，返回所有长度为 n 的开心字符串中字典序第 k 小的字符串
k 从 1 开始计数，如果开心字符串总数少于 k，返回空字符串""",
        function="getHappyString",
        params=[("n", "int"), ("k", "int")],
        returns="string",
        solver=get_happy_string,
        public=[[1, 3], [1, 4], [3, 9]],
        hidden=[[1, 1], [2, 1], [2, 3], [3, 1]],
    ),
    make(
        pid=1651,
        title="连续差相同的数字",
        tags=["回溯", "广度优先搜索"],
        description="""给定整数 n 和 k
返回所有长度为 n、相邻两位数字之差的绝对值恰好为 k 的整数
数字不能有前导零，n 至少为 2
结果按升序排列""",
        function="numsSameConsecDiff",
        params=[("n", "int"), ("k", "int")],
        returns="int[]",
        solver=nums_same_consec_diff,
        public=[[3, 7], [2, 1], [2, 0]],
        hidden=[[3, 0], [9, 1], [4, 9], [5, 2]],
    ),
    make(
        pid=1652,
        title="划分字母区间",
        tags=["贪心", "哈希表", "字符串"],
        description="""给定由小写字母组成的字符串 s
把字符串划分成尽可能多的片段，使每个字母最多出现在一个片段中
返回各片段的长度，按片段从左到右的顺序排列""",
        function="partitionLabels",
        params=[("s", "string")],
        returns="int[]",
        solver=partition_labels,
        public=[["ababcbacadefegdehijhklij"], ["eccbbbbdec"], ["abc"]],
        hidden=[["a"], ["aaaa"], ["abac"], ["caedbdedda"]],
    ),
    make(
        pid=1653,
        title="两地调度",
        tags=["贪心", "排序"],
        description="""有 2n 个人需要前往 A、B 两个城市，每个城市恰好安排 n 人
第 i 个人去 A 市的费用为 costs[i][0]，去 B 市的费用为 costs[i][1]
返回安排所有人所需的最小总费用""",
        function="twoCitySchedCost",
        params=[("costs", "int[][]")],
        returns="int",
        solver=two_city_sched_cost,
        public=[
            [[[10, 20], [30, 200], [400, 50], [30, 20]]],
            [[[259, 770], [448, 54], [926, 667], [184, 139], [840, 118], [577, 469]]],
            [[[0, 0], [0, 0]]],
        ],
        hidden=[
            [[[1, 2], [2, 1]]],
            [[[100, 1], [1, 100], [50, 50], [50, 50]]],
            [[[10, 10], [20, 20]]],
            [[[0, 100], [100, 0], [50, 60], [60, 50]]],
        ],
    ),
    make(
        pid=1654,
        title="救生艇",
        tags=["贪心", "双指针", "排序"],
        description="""给定每个人的体重数组 people 和每艘船的最大载重 limit
每艘船最多载两人，且两人体重之和不能超过 limit
返回运送所有人所需的最少船数""",
        function="numRescueBoats",
        params=[("people", "int[]"), ("limit", "int")],
        returns="int",
        solver=num_rescue_boats,
        public=[[[1, 2], 3], [[3, 2, 2, 1], 3], [[3, 5, 3, 4], 5]],
        hidden=[[[1], 1], [[1, 1], 2], [[3, 3, 3], 3], [[2, 2, 2, 2], 4]],
    ),
    make(
        pid=1655,
        title="递减元素使数组呈锯齿状",
        tags=["贪心", "数组"],
        description="""给定整数数组 nums，每次操作可以把任意一个元素减 1
锯齿状数组要求相邻元素的大小关系交替，即 nums[0] < nums[1] > nums[2] < ... 或 nums[0] > nums[1] < nums[2] > ...
返回使数组成为锯齿状数组所需的最少操作次数""",
        function="movesToMakeZigzag",
        params=[("nums", "int[]")],
        returns="int",
        solver=moves_to_make_zigzag,
        public=[[[1, 2, 3]], [[9, 6, 1, 6, 2]], [[1]]],
        hidden=[[[2, 1]], [[1, 2, 3, 4]], [[2, 1, 2, 3]], [[10, 5, 9, 2, 8]]],
    ),
    make(
        pid=1656,
        title="交换字符使得字符串相同",
        tags=["贪心", "字符串"],
        description="""给定两个等长字符串 s1 和 s2，它们只包含字符 x 和 y
每次操作可以交换 s1 中的一个字符与 s2 中的一个字符，两个字符的下标可以不同
返回使 s1 和 s2 相等的最少交换次数，无法做到则返回 -1""",
        function="minimumSwap",
        params=[("s1", "string"), ("s2", "string")],
        returns="int",
        solver=minimum_swap,
        public=[["xx", "yy"], ["xy", "yx"], ["xx", "xy"]],
        hidden=[["x", "x"], ["x", "y"], ["xx", "yx"], ["xxxx", "yyyy"]],
    ),
    make(
        pid=1657,
        title="删除被覆盖区间",
        tags=["贪心", "排序", "区间"],
        description="""给定区间数组 intervals，intervals[i] = [start, end]
如果区间 [a, b] 被区间 [c, d] 完全覆盖，即 c <= a 且 b <= d，则删除 [a, b]
两个相同的区间视为一个覆盖另一个
返回删除后剩余的区间数目""",
        function="removeCoveredIntervals",
        params=[("intervals", "int[][]")],
        returns="int",
        solver=remove_covered_intervals,
        public=[
            [[[1, 4], [3, 6], [2, 8]]],
            [[[1, 4], [2, 3]]],
            [[[0, 10], [5, 12]]],
        ],
        hidden=[
            [[[1, 2], [1, 4]]],
            [[[1, 4], [2, 3], [3, 4]]],
            [[[1, 4], [1, 4]]],
            [[[2, 3], [1, 2], [3, 4]]],
        ],
    ),
    make(
        pid=1658,
        title="数组大小减半",
        tags=["贪心", "哈希表", "排序"],
        description="""给定整数数组 arr
可以选择一组整数并从数组中删除它们的全部出现
返回使剩余元素数量不超过原数组长度一半所需删除的最少整数个数""",
        function="minSetSize",
        params=[("arr", "int[]")],
        returns="int",
        solver=min_set_size,
        public=[
            [[3, 3, 3, 3, 5, 5, 5, 2, 2, 7]],
            [[7, 7, 7, 7, 7, 7]],
            [[1, 2, 3, 4, 5, 6, 7, 8, 9, 10]],
        ],
        hidden=[
            [[1, 1]],
            [[1, 2, 3, 4]],
            [[1, 1, 2, 2, 3, 3]],
            [[9, 9, 9, 9, 9, 9, 9, 9, 9, 9]],
        ],
    ),
    make(
        pid=1659,
        title="最多可以参加的会议数目",
        tags=["贪心", "堆", "排序"],
        description="""给定会议数组 events，events[i] = [startDay, endDay]
表示第 i 个会议可以在 startDay 到 endDay 之间的任意一天参加
每天最多参加一个会议，同一个会议只能参加一次
返回最多可以参加的会议数目""",
        function="maxEvents",
        params=[("events", "int[][]")],
        returns="int",
        solver=max_events,
        public=[
            [[[1, 2], [2, 3], [3, 4]]],
            [[[1, 2], [2, 3], [3, 4], [1, 2]]],
            [[[1, 1], [1, 2], [1, 3]]],
        ],
        hidden=[
            [[[1, 1]]],
            [[[1, 3], [2, 3], [3, 3]]],
            [[[1, 2], [1, 2], [1, 2]]],
            [[[1, 5], [2, 3], [2, 3], [3, 4]]],
        ],
    ),
]
