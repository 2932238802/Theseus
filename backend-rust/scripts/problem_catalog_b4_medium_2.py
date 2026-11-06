"""2017-2059：批量第四批中等题（43 道）。"""

from __future__ import annotations

import heapq
from collections import defaultdict, deque
from functools import partial
from itertools import combinations
from math import inf, isqrt

from problem_seed_common import make_problem, tree_from_list, tree_to_list

make = partial(make_problem, difficulty="medium")


class _DSU:
    def __init__(self, n: int):
        self.parent = list(range(n))
        self.size = [1] * n

    def find(self, x: int) -> int:
        while self.parent[x] != x:
            self.parent[x] = self.parent[self.parent[x]]
            x = self.parent[x]
        return x

    def union(self, a: int, b: int) -> bool:
        ra, rb = self.find(a), self.find(b)
        if ra == rb:
            return False
        if self.size[ra] < self.size[rb]:
            ra, rb = rb, ra
        self.parent[rb] = ra
        self.size[ra] += self.size[rb]
        return True


# ── 图 / 最短路 ───────────────────────────────────────────────────


def network_becomes_idle(edges: list[list[int]], patience: list[int]) -> int:
    n = len(patience)
    graph = [[] for _ in range(n)]
    for a, b in edges:
        graph[a].append(b)
        graph[b].append(a)
    dist = [-1] * n
    dist[0] = 0
    queue = deque([0])
    while queue:
        node = queue.popleft()
        for nxt in graph[node]:
            if dist[nxt] == -1:
                dist[nxt] = dist[node] + 1
                queue.append(nxt)
    last = 0
    for node in range(1, n):
        round_trip = 2 * dist[node]
        p = patience[node]
        last = max(last, round_trip + ((round_trip - 1) // p) * p)
    return last + 1


def detonate_max_bombs(bombs: list[list[int]]) -> int:
    n = len(bombs)
    graph = [[] for _ in range(n)]
    for i in range(n):
        xi, yi, ri = bombs[i]
        for j in range(n):
            if i == j:
                continue
            xj, yj, _ = bombs[j]
            if (xi - xj) ** 2 + (yi - yj) ** 2 <= ri * ri:
                graph[i].append(j)
    best = 0
    for start in range(n):
        seen = [False] * n
        seen[start] = True
        stack = [start]
        count = 0
        while stack:
            node = stack.pop()
            count += 1
            for nxt in graph[node]:
                if not seen[nxt]:
                    seen[nxt] = True
                    stack.append(nxt)
        best = max(best, count)
    return best


def find_all_recipes(
    recipes: list[str], ingredients: list[list[str]], supplies: list[str]
) -> list[str]:
    available = set(supplies)
    remaining: dict[str, int] = {}
    dependents: dict[str, list[str]] = defaultdict(list)
    for recipe, items in zip(recipes, ingredients):
        need = set(items)
        remaining[recipe] = len(need)
        for item in need:
            dependents[item].append(recipe)
    queue = deque(supplies)
    result: set[str] = set()
    processed: set[str] = set()
    for recipe in recipes:
        if remaining[recipe] == 0:
            available.add(recipe)
            queue.append(recipe)
    while queue:
        item = queue.popleft()
        if item in processed:
            continue
        processed.add(item)
        for recipe in dependents.get(item, []):
            if remaining[recipe] == 0:
                continue
            remaining[recipe] -= 1
            if remaining[recipe] == 0:
                available.add(recipe)
                queue.append(recipe)
    for recipe in recipes:
        if recipe in available:
            result.add(recipe)
    return sorted(result)


def get_ancestors(n: int, edges: list[list[int]]) -> list[list[int]]:
    graph = [[] for _ in range(n)]
    indegree = [0] * n
    for u, v in edges:
        graph[u].append(v)
        indegree[v] += 1
    ancestors = [set() for _ in range(n)]
    queue = deque(node for node in range(n) if indegree[node] == 0)
    while queue:
        node = queue.popleft()
        for nxt in graph[node]:
            ancestors[nxt].add(node)
            ancestors[nxt].update(ancestors[node])
            indegree[nxt] -= 1
            if indegree[nxt] == 0:
                queue.append(nxt)
    return [sorted(items) for items in ancestors]


def paths_same_room(n: int, corridors: list[list[int]]) -> int:
    adjacency = [set() for _ in range(n + 1)]
    for a, b in corridors:
        adjacency[a].add(b)
        adjacency[b].add(a)
    counts: dict[tuple[int, int], int] = defaultdict(int)
    for middle in range(1, n + 1):
        neighbors = list(adjacency[middle])
        for i in range(len(neighbors)):
            for j in range(i + 1, len(neighbors)):
                u, v = neighbors[i], neighbors[j]
                if u > v:
                    u, v = v, u
                counts[(u, v)] += 1
    return sum(1 for value in counts.values() if value >= 2)


def closest_meeting_node(edges: list[int], node1: int, node2: int) -> int:
    def distances(start: int) -> dict[int, int]:
        result: dict[int, int] = {}
        time = 0
        node = start
        while node != -1 and node not in result:
            result[node] = time
            time += 1
            node = edges[node]
        return result

    dist1 = distances(node1)
    dist2 = distances(node2)
    best_node = -1
    best_max = inf
    for node in range(len(edges)):
        if node in dist1 and node in dist2:
            candidate = max(dist1[node], dist2[node])
            if candidate < best_max:
                best_max = candidate
                best_node = node
    return best_node


def reachable_nodes(n: int, edges: list[list[int]], restricted: list[int]) -> int:
    blocked = set(restricted)
    graph = [[] for _ in range(n)]
    for a, b in edges:
        graph[a].append(b)
        graph[b].append(a)
    if 0 in blocked:
        return 0
    seen = [False] * n
    seen[0] = True
    queue = deque([0])
    count = 1
    while queue:
        node = queue.popleft()
        for nxt in graph[node]:
            if not seen[nxt] and nxt not in blocked:
                seen[nxt] = True
                count += 1
                queue.append(nxt)
    return count


def most_profitable_path(edges: list[list[int]], bob: int, amount: list[int]) -> int:
    n = len(amount)
    graph = [[] for _ in range(n)]
    for a, b in edges:
        graph[a].append(b)
        graph[b].append(a)
    parent = [-2] * n
    parent[0] = -1
    order = [0]
    for node in order:
        for nxt in graph[node]:
            if parent[nxt] == -2:
                parent[nxt] = node
                order.append(nxt)
    bob_time: dict[int, int] = {}
    time = 0
    node = bob
    while node != -1:
        bob_time[node] = time
        time += 1
        node = parent[node]

    def gain_at(node: int, time: int) -> int:
        if node not in bob_time:
            return amount[node]
        bob_arrival = bob_time[node]
        if time < bob_arrival:
            return amount[node]
        if time == bob_arrival:
            return amount[node] // 2
        return 0

    best = -inf
    stack = [(0, -1, 0, 0)]
    while stack:
        node, previous, depth, accumulated = stack.pop()
        accumulated += gain_at(node, depth)
        is_leaf = (node != 0 and len(graph[node]) == 1) or (
            node == 0 and len(graph[node]) == 0
        )
        if is_leaf:
            best = max(best, accumulated)
            continue
        for nxt in graph[node]:
            if nxt != previous:
                stack.append((nxt, node, depth + 1, accumulated))
    return best


def minimum_fuel_cost(roads: list[list[int]], seats: int) -> int:
    n = len(roads) + 1
    graph = [[] for _ in range(n)]
    for a, b in roads:
        graph[a].append(b)
        graph[b].append(a)
    parent = [-1] * n
    parent[0] = -2
    order = [0]
    for node in order:
        for nxt in graph[node]:
            if parent[nxt] == -1:
                parent[nxt] = node
                order.append(nxt)
    sizes = [1] * n
    fuel = 0
    for node in reversed(order[1:]):
        fuel += (sizes[node] + seats - 1) // seats
        sizes[parent[node]] += sizes[node]
    return fuel


def min_score(n: int, roads: list[list[int]]) -> int:
    graph = [[] for _ in range(n + 1)]
    for a, b, weight in roads:
        graph[a].append((b, weight))
        graph[b].append((a, weight))
    seen = [False] * (n + 1)
    seen[1] = True
    queue = deque([1])
    best = inf
    while queue:
        node = queue.popleft()
        for nxt, weight in graph[node]:
            best = min(best, weight)
            if not seen[nxt]:
                seen[nxt] = True
                queue.append(nxt)
    return best


def max_star_sum(values: list[int], edges: list[list[int]], k: int) -> int:
    graph = [[] for _ in range(len(values))]
    for a, b in edges:
        graph[a].append(values[b])
        graph[b].append(values[a])
    best = -inf
    for node in range(len(values)):
        neighbors = sorted((value for value in graph[node] if value > 0), reverse=True)
        best = max(best, values[node] + sum(neighbors[:k]))
    return best


def count_unreachable_pairs(n: int, edges: list[list[int]]) -> int:
    dsu = _DSU(n)
    for a, b in edges:
        dsu.union(a, b)
    total = n * (n - 1) // 2
    for node in range(n):
        if dsu.find(node) == node:
            size = dsu.size[node]
            total -= size * (size - 1) // 2
    return total


def count_complete_components(n: int, edges: list[list[int]]) -> int:
    dsu = _DSU(n)
    for a, b in edges:
        dsu.union(a, b)
    edge_count = [0] * n
    for a, _ in edges:
        edge_count[dsu.find(a)] += 1
    result = 0
    for node in range(n):
        if dsu.find(node) == node:
            size = dsu.size[node]
            if edge_count[node] == size * (size - 1) // 2:
                result += 1
    return result


def find_champion(n: int, edges: list[list[int]]) -> int:
    indegree = [0] * n
    for _, loser in edges:
        indegree[loser] += 1
    candidates = [node for node in range(n) if indegree[node] == 0]
    return candidates[0] if len(candidates) == 1 else -1


def minimum_cost_convert(
    source: str,
    target: str,
    original: list[str],
    changed: list[str],
    cost: list[int],
) -> int:
    distance = [[inf] * 26 for _ in range(26)]
    for i in range(26):
        distance[i][i] = 0
    for a, b, weight in zip(original, changed, cost):
        u, v = ord(a) - 97, ord(b) - 97
        distance[u][v] = min(distance[u][v], weight)
    for mid in range(26):
        row_mid = distance[mid]
        for i in range(26):
            base = distance[i][mid]
            if base == inf:
                continue
            row = distance[i]
            for j in range(26):
                candidate = base + row_mid[j]
                if candidate < row[j]:
                    row[j] = candidate
    total = 0
    for a, b in zip(source, target):
        value = distance[ord(a) - 97][ord(b) - 97]
        if value == inf:
            return -1
        total += value
    return total


# ── 树 ────────────────────────────────────────────────────────────


def get_directions(root: list, start_value: int, dest_value: int) -> str:
    tree = tree_from_list(root)

    def find(node, target: int, path: str):
        if node is None:
            return None
        if node.value == target:
            return path
        left = find(node.left, target, path + "L")
        if left is not None:
            return left
        return find(node.right, target, path + "R")

    start_path = find(tree, start_value, "")
    dest_path = find(tree, dest_value, "")
    index = 0
    while (
        index < len(start_path)
        and index < len(dest_path)
        and start_path[index] == dest_path[index]
    ):
        index += 1
    return "U" * (len(start_path) - index) + dest_path[index:]


def create_binary_tree(descriptions: list[list[int]]) -> list:
    nodes: dict[int, object] = {}
    children: set[int] = set()

    def get_node(value: int):
        if value not in nodes:
            nodes[value] = tree_from_list([value])
        return nodes[value]

    for parent, child, is_left in descriptions:
        parent_node = get_node(parent)
        child_node = get_node(child)
        if is_left:
            parent_node.left = child_node
        else:
            parent_node.right = child_node
        children.add(child)
    root = None
    for value, node in nodes.items():
        if value not in children:
            root = node
    return tree_to_list(root)


def count_subtree_average_nodes(root: list) -> int:
    tree = tree_from_list(root)
    count = 0

    def visit(node):
        nonlocal count
        if node is None:
            return 0, 0
        left_sum, left_count = visit(node.left)
        right_sum, right_count = visit(node.right)
        total = left_sum + right_sum + node.value
        size = left_count + right_count + 1
        if node.value == total // size:
            count += 1
        return total, size

    visit(tree)
    return count


def amount_of_time(root: list, start: int) -> int:
    tree = tree_from_list(root)
    graph: dict[int, list[int]] = defaultdict(list)

    def build(node):
        if node is None:
            return
        for child in (node.left, node.right):
            if child is not None:
                graph[node.value].append(child.value)
                graph[child.value].append(node.value)
                build(child)

    build(tree)
    dist = {start: 0}
    queue = deque([start])
    while queue:
        node = queue.popleft()
        for nxt in graph[node]:
            if nxt not in dist:
                dist[nxt] = dist[node] + 1
                queue.append(nxt)
    return max(dist.values())


def reverse_odd_levels(root: list) -> list:
    tree = tree_from_list(root)
    level = [tree]
    depth = 0
    while level:
        if depth % 2 == 1:
            values = [node.value for node in level][::-1]
            for node, value in zip(level, values):
                node.value = value
        next_level = []
        for node in level:
            if node.left is not None:
                next_level.append(node.left)
            if node.right is not None:
                next_level.append(node.right)
        level = next_level
        depth += 1
    return tree_to_list(tree)


def minimum_level_sort_operations(root: list) -> int:
    tree = tree_from_list(root)
    total = 0
    level = [tree]
    while level:
        values = [node.value for node in level]
        ordered = sorted(values)
        positions: dict[int, list[int]] = defaultdict(list)
        for index, value in enumerate(ordered):
            positions[value].append(index)
        permutation = []
        for value in values:
            permutation.append(positions[value].pop(0))
        visited = [False] * len(values)
        for i in range(len(values)):
            if not visited[i]:
                cycle = 0
                j = i
                while not visited[j]:
                    visited[j] = True
                    j = permutation[j]
                    cycle += 1
                total += cycle - 1
        next_level = []
        for node in level:
            if node.left is not None:
                next_level.append(node.left)
            if node.right is not None:
                next_level.append(node.right)
        level = next_level
    return total


def replace_value_in_tree(root: list) -> list:
    tree = tree_from_list(root)
    tree.value = 0
    level = [tree]
    while level:
        next_level = []
        for node in level:
            if node.left is not None:
                next_level.append(node.left)
            if node.right is not None:
                next_level.append(node.right)
        if not next_level:
            break
        total = sum(node.value for node in next_level)
        for node in level:
            sibling_sum = 0
            if node.left is not None:
                sibling_sum += node.left.value
            if node.right is not None:
                sibling_sum += node.right.value
            if node.left is not None:
                node.left.value = total - sibling_sum
            if node.right is not None:
                node.right.value = total - sibling_sum
        level = next_level
    return tree_to_list(tree)


def min_increments(n: int, cost: list[int]) -> int:
    values = cost[:]
    answer = 0
    for index in range(n // 2 - 1, -1, -1):
        left, right = 2 * index + 1, 2 * index + 2
        answer += abs(values[left] - values[right])
        values[index] += max(values[left], values[right])
    return answer


# ── 动态规划 / 贪心 / 回溯 ────────────────────────────────────────


def max_two_events(events: list[list[int]]) -> int:
    ordered = sorted(events, key=lambda event: event[1])
    ends = [event[1] for event in ordered]
    prefix = []
    best = -1
    for event in ordered:
        best = max(best, event[2])
        prefix.append(best)
    answer = 0
    for start, _end, value in ordered:
        left, right = 0, len(ends)
        while left < right:
            mid = (left + right) // 2
            if ends[mid] < start:
                left = mid + 1
            else:
                right = mid
        answer = max(answer, value)
        if left > 0:
            answer = max(answer, value + prefix[left - 1])
    return answer


def most_points(questions: list[list[int]]) -> int:
    n = len(questions)
    dp = [0] * (n + 1)
    for index in range(n - 1, -1, -1):
        points, brainpower = questions[index]
        skip = index + brainpower + 1
        take = points + (dp[skip] if skip < n else 0)
        dp[index] = max(dp[index + 1], take)
    return dp[0]


def get_descent_periods(prices: list[int]) -> int:
    total = 0
    current = 0
    for index, price in enumerate(prices):
        if index > 0 and prices[index - 1] - price == 1:
            current += 1
        else:
            current = 1
        total += current
    return total


def maximum_importance(n: int, roads: list[list[int]]) -> int:
    degree = [0] * n
    for a, b in roads:
        degree[a] += 1
        degree[b] += 1
    degree.sort(reverse=True)
    return sum(value * (n - index) for index, value in enumerate(degree))


def partition_array(nums: list[int], k: int) -> int:
    values = sorted(nums)
    groups = 0
    index = 0
    while index < len(values):
        groups += 1
        limit = values[index] + k
        index += 1
        while index < len(values) and values[index] <= limit:
            index += 1
    return groups


def min_path_cost(grid: list[list[int]], move_cost: list[list[int]]) -> int:
    rows, cols = len(grid), len(grid[0])
    dp = grid[0][:]
    for row in range(rows - 1):
        next_dp = [inf] * cols
        for j in range(cols):
            value = grid[row][j]
            for k in range(cols):
                candidate = dp[j] + move_cost[value][k] + grid[row + 1][k]
                if candidate < next_dp[k]:
                    next_dp[k] = candidate
        dp = next_dp
    return min(dp)


def count_house_placements(n: int) -> int:
    mod = 10**9 + 7
    previous, current = 1, 2
    for _ in range(n - 1):
        previous, current = current, (previous + current) % mod
    return current * current % mod


def people_aware_of_secret(n: int, delay: int, forget: int) -> int:
    mod = 10**9 + 7
    dp = [0] * (n + 1)
    prefix = [0] * (n + 1)
    dp[1] = 1
    prefix[1] = 1
    for day in range(2, n + 1):
        low = max(1, day - forget + 1)
        high = day - delay
        if high >= low:
            dp[day] = (prefix[high] - prefix[low - 1]) % mod
        prefix[day] = (prefix[day - 1] + dp[day]) % mod
    low = max(1, n - forget + 1)
    return (prefix[n] - prefix[low - 1]) % mod


def longest_ideal_string(s: str, k: int) -> int:
    dp = [0] * 26
    for character in s:
        index = ord(character) - 97
        low = max(0, index - k)
        high = min(25, index + k)
        dp[index] = max(dp[low : high + 1]) + 1
    return max(dp)


def maximum_rows(matrix: list[list[int]], num_select: int) -> int:
    rows, cols = len(matrix), len(matrix[0])
    row_masks = []
    for row in matrix:
        mask = 0
        for index, value in enumerate(row):
            if value:
                mask |= 1 << index
        row_masks.append(mask)
    best = 0
    for chosen in combinations(range(cols), num_select):
        mask = 0
        for col in chosen:
            mask |= 1 << col
        covered = sum(1 for row_mask in row_masks if row_mask & ~mask == 0)
        best = max(best, covered)
    return best


def minimize_array_value(nums: list[int]) -> int:
    def feasible(limit: int) -> bool:
        excess = 0
        for index in range(len(nums) - 1, 0, -1):
            current = nums[index] + excess
            excess = max(0, current - limit)
        return nums[0] + excess <= limit

    low, high = 0, max(nums)
    while low < high:
        mid = (low + high) // 2
        if feasible(mid):
            high = mid
        else:
            low = mid + 1
    return low


def min_operations_to_zero(n: int) -> int:
    operations = 0
    while n:
        if n & (n - 1) == 0:
            operations += 1
            break
        low = n & -n
        if n & (low << 1):
            n += low
        else:
            n -= low
        operations += 1
    return operations


def longest_square_streak(nums: list[int]) -> int:
    dp: dict[int, int] = {}
    best = 0
    for value in sorted(set(nums)):
        root = isqrt(value)
        if root * root == value and root in dp:
            dp[value] = dp[root] + 1
        else:
            dp[value] = 1
        best = max(best, dp[value])
    return best if best >= 2 else -1


def beautiful_subsets(nums: list[int], k: int) -> int:
    mod = 10**9 + 7
    chosen: set[int] = set()

    def dfs(index: int) -> int:
        if index == len(nums):
            return 0
        total = dfs(index + 1)
        value = nums[index]
        if value - k not in chosen and value + k not in chosen:
            added = value not in chosen
            if added:
                chosen.add(value)
            total += 1 + dfs(index + 1)
            if added:
                chosen.remove(value)
        return total % mod

    return dfs(0)


def mice_and_cheese(reward1: list[int], reward2: list[int], k: int) -> int:
    order = sorted(
        range(len(reward1)), key=lambda index: reward1[index] - reward2[index], reverse=True
    )
    total = 0
    for position, index in enumerate(order):
        total += reward1[index] if position < k else reward2[index]
    return total


def max_moves(grid: list[list[int]]) -> int:
    rows, cols = len(grid), len(grid[0])
    dp = [[0] * cols for _ in range(rows)]
    best = 0
    for col in range(cols - 2, -1, -1):
        for row in range(rows):
            value = grid[row][col]
            moves = 0
            for delta in (-1, 0, 1):
                nxt = row + delta
                if 0 <= nxt < rows and grid[nxt][col + 1] > value:
                    moves = max(moves, 1 + dp[nxt][col + 1])
            dp[row][col] = moves
            if col == 0:
                best = max(best, moves)
    return best


def punishment_number(n: int) -> int:
    def can_split(text: str, target: int) -> bool:
        def dfs(index: int, current: int) -> bool:
            if index == len(text):
                return current == target
            value = 0
            for j in range(index, len(text)):
                value = value * 10 + int(text[j])
                if current + value > target:
                    break
                if dfs(j + 1, current + value):
                    return True
            return False

        return dfs(0, 0)

    total = 0
    for value in range(1, n + 1):
        square = value * value
        if can_split(str(square), value):
            total += square
    return total


def min_extra_char(s: str, dictionary: list[str]) -> int:
    n = len(s)
    words = set(dictionary)
    dp = [0] * (n + 1)
    for i in range(1, n + 1):
        dp[i] = dp[i - 1] + 1
        for word in words:
            length = len(word)
            if length <= i and s[i - length : i] == word:
                dp[i] = min(dp[i], dp[i - length])
    return dp[n]


def maximum_safeness_factor(grid: list[list[int]]) -> int:
    n = len(grid)
    distance = [[-1] * n for _ in range(n)]
    queue = deque()
    for row in range(n):
        for col in range(n):
            if grid[row][col] == 1:
                distance[row][col] = 0
                queue.append((row, col))
    directions = ((1, 0), (-1, 0), (0, 1), (0, -1))
    while queue:
        row, col = queue.popleft()
        for dr, dc in directions:
            nr, nc = row + dr, col + dc
            if 0 <= nr < n and 0 <= nc < n and distance[nr][nc] == -1:
                distance[nr][nc] = distance[row][col] + 1
                queue.append((nr, nc))
    best = [[-1] * n for _ in range(n)]
    best[0][0] = distance[0][0]
    heap = [(-distance[0][0], 0, 0)]
    while heap:
        neg, row, col = heapq.heappop(heap)
        current = -neg
        if current < best[row][col]:
            continue
        if row == n - 1 and col == n - 1:
            return current
        for dr, dc in directions:
            nr, nc = row + dr, col + dc
            if 0 <= nr < n and 0 <= nc < n:
                candidate = min(current, distance[nr][nc])
                if candidate > best[nr][nc]:
                    best[nr][nc] = candidate
                    heapq.heappush(heap, (-candidate, nr, nc))
    return best[n - 1][n - 1]


def minimum_added_coins(coins: list[int], target: int) -> int:
    values = sorted(coins)
    reachable = 1
    added = 0
    index = 0
    while reachable <= target:
        if index < len(values) and values[index] <= reachable:
            reachable += values[index]
            index += 1
        else:
            added += 1
            reachable += reachable
    return added


PROBLEMS = [
    make(
        pid=2017,
        title="网络空闲的时刻",
        tags=["图", "广度优先搜索", "最短路"],
        description="""给定无向连通图的边列表 edges 和每个节点重新发送消息的间隔 patience
节点编号为 0 到 n-1，其中 n 是 patience 的长度
节点 0 是主服务器，patience[0] 恒为 0，其余节点的 patience 均为正整数
每个节点在时刻 0 发送一条消息，之后每隔 patience[i] 秒重新发送一次
消息到达主服务器再原路返回共需 2 * 节点到节点 0 的最短距离秒
主服务器收到消息后立即回复
节点收到任意回复后就不再发送新消息
返回网络中没有消息在传输的最早时刻""",
        function="networkBecomesIdle",
        params=[("edges", "int[][]"), ("patience", "int[]")],
        returns="int",
        solver=network_becomes_idle,
        public=[
            [[[0, 1], [0, 2]], [0, 1, 1]],
            [[[0, 1], [1, 2]], [0, 1, 1]],
            [[[0, 1], [0, 2], [1, 3]], [0, 1, 1, 1]],
            [[[0, 1]], [0, 5]],
        ],
        hidden=[
            [[[0, 1], [1, 2], [2, 3]], [0, 2, 3, 4]],
            [[[0, 1], [0, 2], [0, 3], [0, 4]], [0, 1, 100, 1, 100]],
            [[[0, 1], [1, 2], [1, 3], [3, 4]], [0, 3, 3, 3, 3]],
            [[[0, 1]], [0, 10]],
            [[[0, 1], [1, 2]], [0, 1, 5]],
            [[[0, 1], [0, 2], [2, 3], [2, 4]], [0, 2, 2, 2, 2]],
        ],
    ),
    make(
        pid=2018,
        title="两个最好的不重叠活动",
        tags=["数组", "排序", "动态规划", "二分查找"],
        description="""给定活动列表 events，每项为 [开始时间, 结束时间, 价值]
选择至多两个互不重叠的活动，使价值之和最大
若两个活动满足前一个的结束时间严格小于后一个的开始时间，则它们不重叠
只选择一个活动也允许
返回能得到的最大价值之和""",
        function="maxTwoEvents",
        params=[("events", "int[][]")],
        returns="int",
        solver=max_two_events,
        public=[
            [[[1, 3, 2], [4, 5, 2], [2, 4, 3]]],
            [[[1, 3, 2], [4, 5, 2], [1, 5, 5]]],
            [[[1, 5, 3], [1, 5, 3], [1, 5, 3]]],
        ],
        hidden=[
            [[[1, 2, 4], [3, 4, 3], [2, 3, 1]]],
            [[[1, 2, 4]]],
            [[[1, 4, 2], [2, 3, 5], [5, 6, 1]]],
            [[[1, 2, 1], [2, 3, 2], [3, 4, 3], [4, 5, 4]]],
            [[[10, 20, 100], [1, 5, 1], [6, 9, 1]]],
            [[[1, 3, 5], [2, 4, 6], [3, 5, 7]]],
        ],
    ),
    make(
        pid=2019,
        title="访问相同房间的路径",
        tags=["图", "哈希表", "计数"],
        description="""给定无向图的房间数 n 和走廊列表 corridors
房间编号为 1 到 n
统计满足以下条件的房间对 (a, b)，其中 a 小于 b
从 a 到 b 恰好存在至少两条不同的长度为 2 的路径
两条长度为 2 的路径指分别经过两个不同的中间节点
返回这样的房间对数目""",
        function="pathsSameRoom",
        params=[("n", "int"), ("corridors", "int[][]")],
        returns="int",
        solver=paths_same_room,
        public=[
            [5, [[1, 2], [5, 2], [4, 1], [2, 4], [3, 1], [3, 4]]],
            [4, [[1, 2], [2, 3], [3, 1], [2, 4], [3, 4]]],
            [3, [[1, 2], [2, 3], [3, 1]]],
        ],
        hidden=[
            [2, [[1, 2]]],
            [6, [[1, 2], [2, 3], [3, 1], [3, 4], [4, 5], [5, 3]]],
            [5, [[1, 2], [2, 3], [3, 4], [4, 5], [5, 1]]],
            [4, []],
            [6, [[1, 2], [1, 3], [1, 4], [2, 3], [2, 4], [3, 4]]],
            [7, [[1, 2], [2, 3], [3, 1], [4, 5], [5, 6], [6, 4], [3, 4]]],
        ],
    ),
    make(
        pid=2020,
        title="从二叉树一个节点到另一个节点的步骤",
        tags=["树", "深度优先搜索", "字符串"],
        description="""给定二叉树 root，节点值互不相同
给定树中两个不同节点的值 startValue 和 destValue
返回从 startValue 节点走到 destValue 节点的最短路径方向字符串
每一步用 L 表示走向左孩子，R 表示走向右孩子，U 表示走向父节点
答案保证唯一""",
        function="getDirections",
        params=[("root", "TreeNode"), ("startValue", "int"), ("destValue", "int")],
        returns="string",
        solver=get_directions,
        public=[
            [[5, 1, 2, 3, None, 6, 4], 3, 6],
            [[2, 1], 2, 1],
            [[5, 1, 2, 3, None, 6, 4], 3, 4],
        ],
        hidden=[
            [[1], 1, 1],
            [[1, 2, 3, 4, 5], 4, 5],
            [[1, 2, None, 3], 3, 2],
            [[1, 2, 3], 2, 3],
            [[1, 2, 3, 4, 5, 6, 7], 6, 7],
            [[1, 2, None, 3, 4], 3, 4],
            [[1, 2, 3], 1, 3],
        ],
    ),
    make(
        pid=2021,
        title="引爆最多的炸弹",
        tags=["图", "深度优先搜索", "几何"],
        description="""给定炸弹列表 bombs，每项为 [横坐标, 纵坐标, 爆炸半径]
炸弹 i 爆炸时能直接引爆炸弹 j 的条件是
两个炸弹中心的欧氏距离不大于炸弹 i 的爆炸半径
被引爆的炸弹还会继续引爆其他炸弹
选择引爆炸弹列表中的一个炸弹
返回最多能引爆的炸弹数量""",
        function="detonateMaxBombs",
        params=[("bombs", "int[][]")],
        returns="int",
        solver=detonate_max_bombs,
        public=[
            [[[2, 1, 3], [6, 1, 4]]],
            [[[1, 1, 5], [10, 10, 5]]],
            [[[1, 2, 3], [2, 3, 1], [3, 4, 2], [4, 5, 3], [5, 6, 4]]],
        ],
        hidden=[
            [[[0, 0, 1]]],
            [[[0, 0, 2], [3, 0, 2], [6, 0, 2]]],
            [[[0, 0, 5], [4, 0, 1], [8, 0, 1]]],
            [[[0, 0, 10], [5, 0, 1], [9, 0, 1]]],
            [[[0, 0, 1], [1, 0, 100], [2, 0, 100]]],
            [[[0, 0, 1], [2, 0, 100], [4, 0, 100]]],
        ],
    ),
    make(
        pid=2022,
        title="从原材料到食物",
        tags=["图", "拓扑排序", "哈希表"],
        description="""给定可制作的食谱 recipes，每道食谱所需的原材料 ingredients
以及当前拥有的原材料 supplies
ingredients[i] 是制作 recipes[i] 所需的一组材料
一道食谱可以被制作，当且仅当它的所有原材料要么在 supplies 中
要么可以由其他可制作食谱得到
返回所有最终可以制作的食谱，按字典序升序排列""",
        function="findAllRecipes",
        params=[
            ("recipes", "string[]"),
            ("ingredients", "string[][]"),
            ("supplies", "string[]"),
        ],
        returns="string[]",
        solver=find_all_recipes,
        public=[
            [["bread"], [["yeast", "flour"]], ["yeast", "flour"]],
            [
                ["bread", "sandwich"],
                [["yeast", "flour"], ["bread", "meat"]],
                ["yeast", "flour", "meat"],
            ],
            [
                ["bread", "sandwich", "burger"],
                [["yeast", "flour"], ["bread", "meat"], ["sandwich", "meat", "tomato"]],
                ["yeast", "flour", "meat", "tomato"],
            ],
        ],
        hidden=[
            [["x"], [["a", "b"]], ["a"]],
            [["x"], [["a", "b"]], ["a", "b"]],
            [["x", "y"], [["a"], ["x"]], ["a"]],
            [["x", "y", "z"], [["a"], ["x"], ["y"]], ["a"]],
            [["x", "y"], [["y"], ["x"]], []],
            [["a", "b", "c"], [["m"], ["n"], ["a", "b"]], ["m", "n"]],
        ],
    ),
    make(
        pid=2023,
        title="平滑下降子数组的数目",
        tags=["数组", "动态规划"],
        description="""给定整数数组 prices
平滑下降子数组是连续子数组，且每对相邻元素都满足
前一个元素比后一个元素恰好大 1
返回数组中共有多少个平滑下降子数组""",
        function="getDescentPeriods",
        params=[("prices", "int[]")],
        returns="long",
        solver=get_descent_periods,
        public=[
            [[3, 2, 1, 4]],
            [[8, 6, 7, 4, 2]],
            [[1]],
        ],
        hidden=[
            [[5, 4, 3]],
            [[1, 2, 3]],
            [[3, 2, 3, 2, 1]],
            [[10, 9, 8, 7, 6, 5]],
            [[2, 2, 2]],
            [[4, 3, 2, 1, 0, -1]],
        ],
    ),
    make(
        pid=2024,
        title="有向无环图中一个节点的所有祖先",
        tags=["图", "拓扑排序", "深度优先搜索"],
        description="""给定有向无环图的节点数 n 和边列表 edges
第 i 个节点的编号为 i
返回长度为 n 的列表，第 i 项是节点 i 的所有祖先节点
祖先指存在一条从该节点到 i 的长度至少为 1 的路径
每项中的节点编号必须按升序排列""",
        function="getAncestors",
        params=[("n", "int"), ("edges", "int[][]")],
        returns="int[][]",
        solver=get_ancestors,
        public=[
            [
                8,
                [
                    [0, 1],
                    [0, 2],
                    [0, 3],
                    [0, 4],
                    [1, 2],
                    [1, 3],
                    [1, 4],
                    [2, 3],
                    [2, 4],
                    [3, 4],
                ],
            ],
            [5, [[0, 1], [0, 2], [0, 3], [1, 2], [1, 3], [2, 3]]],
            [3, []],
        ],
        hidden=[
            [4, [[0, 1], [1, 2], [2, 3]]],
            [6, [[0, 1], [0, 2], [1, 3], [2, 3], [3, 4], [2, 5]]],
            [2, [[0, 1]]],
            [7, [[0, 1], [1, 2], [2, 3], [3, 4], [4, 5], [5, 6]]],
            [4, [[0, 1], [0, 2], [0, 3]]],
            [5, [[0, 1], [2, 3], [1, 2]]],
        ],
    ),
    make(
        pid=2025,
        title="根据描述创建二叉树",
        tags=["树", "哈希表", "二叉树"],
        description="""给定二维数组 descriptions
每项为 [父节点值, 子节点值, 是否为左孩子]，其中 1 表示左孩子，0 表示右孩子
所有节点值互不相同，给出的描述刚好构成一棵二叉树
返回构造出的二叉树的根节点（按层序序列化输出）""",
        function="createBinaryTree",
        params=[("descriptions", "int[][]")],
        returns="TreeNode",
        solver=create_binary_tree,
        public=[
            [[[20, 15, 1], [20, 17, 0], [50, 20, 1], [50, 80, 0], [80, 19, 1]]],
            [[[1, 2, 1], [1, 3, 0], [2, 4, 1]]],
            [[[1, 2, 1]]],
        ],
        hidden=[
            [[[5, 6, 1]]],
            [[[1, 2, 0], [1, 3, 1], [2, 4, 1], [3, 5, 0]]],
            [[[2, 3, 1], [3, 4, 0]]],
            [[[10, 5, 1], [10, 7, 0], [5, 3, 1], [7, 9, 0]]],
            [[[1, 2, 1], [1, 3, 0], [2, 5, 0], [3, 6, 1]]],
            [[[8, 4, 1], [8, 12, 0], [4, 2, 0], [12, 10, 1]]],
        ],
    ),
    make(
        pid=2026,
        title="统计值等于子树平均值的节点数",
        tags=["树", "深度优先搜索", "二叉树"],
        description="""给定二叉树的根节点 root
某个节点的子树平均值定义为该节点子树中所有节点值之和除以节点个数并向下取整
返回值等于其子树平均值的节点数目""",
        function="countSubtreeAverageNodes",
        params=[("root", "TreeNode")],
        returns="int",
        solver=count_subtree_average_nodes,
        public=[
            [[4, 8, 5, 0, 1, None, 6]],
            [[1]],
            [[1, 2, 3]],
        ],
        hidden=[
            [[2, None, 3]],
            [[1, 2, 3, 4, 5, 6, 7]],
            [[10, 5, 15, 3, 7, None, 20]],
            [[0]],
            [[1, 2, None, 3]],
            [[6, 6, 6]],
        ],
    ),
    make(
        pid=2027,
        title="道路的最大总重要性",
        tags=["贪心", "图", "排序"],
        description="""给定城市数量 n 和道路列表 roads
第 i 个城市的编号为 i，每条道路连接两个城市
为每个城市分配一个 1 到 n 之间且互不相同的值
一条道路的重要性为它连接的两个城市的值之和
返回所有道路重要性之和的最大值""",
        function="maximumImportance",
        params=[("n", "int"), ("roads", "int[][]")],
        returns="long",
        solver=maximum_importance,
        public=[
            [5, [[0, 1], [1, 2], [2, 3], [0, 2], [1, 3], [2, 4]]],
            [5, [[0, 1], [0, 2], [0, 3], [0, 4]]],
            [2, [[0, 1]]],
        ],
        hidden=[
            [3, [[0, 1], [1, 2]]],
            [1, []],
            [4, [[0, 1], [0, 2], [0, 3], [1, 2]]],
            [6, [[0, 1], [1, 2], [2, 3], [3, 4], [4, 5], [5, 0]]],
            [5, [[0, 1], [0, 2], [0, 3], [0, 4], [1, 2]]],
            [4, [[0, 1], [1, 2], [2, 3]]],
        ],
    ),
    make(
        pid=2028,
        title="划分数组使最大差为 K",
        tags=["数组", "贪心", "排序"],
        description="""给定整数数组 nums 和整数 k
把 nums 划分成若干个不相交的子序列
要求同一子序列中任意两个元素之差的绝对值都不大于 k
返回最少需要的子序列数目""",
        function="partitionArray",
        params=[("nums", "int[]"), ("k", "int")],
        returns="int",
        solver=partition_array,
        public=[
            [[3, 6, 1, 2, 5], 2],
            [[1, 2, 3], 1],
            [[2, 2, 4, 5], 0],
        ],
        hidden=[
            [[1], 5],
            [[4, 1, 7, 3], 3],
            [[5, 5, 5], 2],
            [[10, 1, 2, 3, 4], 2],
            [[3, 6, 1, 2, 5], 10],
            [[1, 100, 101, 102], 1],
        ],
    ),
    make(
        pid=2029,
        title="网格中的最小路径代价",
        tags=["数组", "动态规划", "矩阵"],
        description="""给定 m 行 n 列的网格 grid 和代价矩阵 moveCost
从第一行的任意格子出发，每步移动到下一行的一个格子
从 grid[i][j] 移动到 grid[i+1][k] 的代价为
moveCost[grid[i][j]][k] 加上 grid[i+1][k]
路径总代价还包括起点格子的值
返回到达最后一行的最小总代价""",
        function="minPathCost",
        params=[("grid", "int[][]"), ("moveCost", "int[][]")],
        returns="int",
        solver=min_path_cost,
        public=[
            [[[5, 3], [4, 0], [2, 1]], [[9, 8], [1, 5], [10, 12], [18, 6], [2, 4], [14, 3]]],
            [[[1, 2], [3, 0]], [[0, 1], [1, 0], [2, 2], [3, 3]]],
            [[[1, 1], [1, 1]], [[0, 0], [0, 0], [0, 0], [0, 0]]],
        ],
        hidden=[
            [[[1]], [[0]]],
            [[[2, 3], [4, 5], [6, 7]], [[0, 1], [1, 0], [2, 3], [3, 2], [4, 0], [5, 0], [6, 0], [7, 0]]],
            [[[0, 0], [0, 0]], [[1, 2], [3, 4]]],
            [[[5, 1], [2, 8], [3, 4]], [[0, 0], [0, 0], [0, 0], [0, 0], [0, 0], [0, 0], [0, 0], [0, 0], [0, 0]]],
            [[[9, 2, 5], [1, 7, 3]], [[0, 1, 2], [3, 4, 5], [6, 7, 8], [9, 10, 11], [12, 13, 14], [15, 16, 17], [18, 19, 20], [21, 22, 23], [24, 25, 26], [27, 28, 29]]],
            [[[4, 4], [4, 4]], [[1, 1], [1, 1], [1, 1], [1, 1], [1, 1]]],
        ],
    ),
    make(
        pid=2030,
        title="统计无向图中无法互相到达点对数",
        tags=["并查集", "图"],
        description="""给定无向图的节点数 n 和边列表 edges
节点编号为 0 到 n-1
统计无法互相到达的不同节点对 (a, b) 的数量，其中 a 小于 b
两个节点无法互相到达指它们之间不存在路径""",
        function="countUnreachablePairs",
        params=[("n", "int"), ("edges", "int[][]")],
        returns="long",
        solver=count_unreachable_pairs,
        public=[
            [3, [[0, 1]]],
            [7, [[0, 2], [0, 5], [2, 4], [1, 6], [5, 4]]],
            [1, []],
        ],
        hidden=[
            [2, []],
            [4, [[0, 1], [2, 3]]],
            [5, [[0, 1], [1, 2], [3, 4]]],
            [6, []],
            [4, [[0, 1], [1, 2], [2, 3], [3, 0]]],
            [8, [[0, 1], [1, 2], [2, 3]]],
        ],
    ),
    make(
        pid=2031,
        title="统计放置房子的方式数",
        tags=["动态规划", "数学"],
        description="""一条街道的两侧各有 n 块地，每块地可以空着或建一栋房子
同一侧不能有相邻的两块地都建房子
两侧的放置方案相互独立
返回在街道两侧放置房子的总方案数，结果对 10^9 + 7 取模""",
        function="countHousePlacements",
        params=[("n", "int")],
        returns="int",
        solver=count_house_placements,
        public=[
            [1],
            [2],
            [3],
        ],
        hidden=[
            [4],
            [5],
            [10],
            [20],
            [100],
            [1000],
        ],
    ),
    make(
        pid=2032,
        title="知道秘密的人数",
        tags=["动态规划", "队列"],
        description="""从第 1 天起，第 0 个人知道一个秘密
每天开始时，每个已经知道秘密至少 delay 天的人会把这个秘密告诉一个新的人
每个知道秘密的人在知道后的第 forget 天开始时忘记秘密
返回第 n 天结束时知道秘密的人数，结果对 10^9 + 7 取模""",
        function="peopleAwareOfSecret",
        params=[("n", "int"), ("delay", "int"), ("forget", "int")],
        returns="int",
        solver=people_aware_of_secret,
        public=[
            [6, 2, 4],
            [4, 1, 3],
            [1, 1, 1],
        ],
        hidden=[
            [5, 1, 2],
            [6, 1, 3],
            [10, 2, 5],
            [7, 1, 4],
            [8, 3, 5],
            [20, 3, 7],
        ],
    ),
    make(
        pid=2033,
        title="找到离给定两个节点最近的节点",
        tags=["图", "深度优先搜索"],
        description="""给定有向图，节点 i 至多有一条出边，edges[i] 表示节点 i 的出边终点
若 edges[i] 等于 -1 则表示没有出边
给定两个起点 node1 和 node2
找到同时能从两个起点到达的节点中
到两个起点距离的较大值最小的节点
若存在多个这样的节点，返回编号最小的那个
若不存在同时可达的节点，返回 -1""",
        function="closestMeetingNode",
        params=[("edges", "int[]"), ("node1", "int"), ("node2", "int")],
        returns="int",
        solver=closest_meeting_node,
        public=[
            [[2, 2, 3, -1], 0, 1],
            [[1, 2, -1], 0, 2],
            [[2, -1, 3, -1], 0, 1],
        ],
        hidden=[
            [[1, 2, 3, -1], 0, 3],
            [[-1, -1], 0, 1],
            [[1, -1, 1, -1], 0, 2],
            [[3, 3, -1, 1], 0, 3],
            [[2, 3, -1, 2], 0, 1],
            [[1, 0], 0, 1],
        ],
    ),
    make(
        pid=2034,
        title="受限条件下可到达节点的数目",
        tags=["图", "广度优先搜索", "哈希表"],
        description="""给定无向图的节点数 n 和边列表 edges
节点编号为 0 到 n-1
给定受限节点列表 restricted，这些节点不能访问
从节点 0 出发，返回能够到达的不同节点数目（包括节点 0）
题目保证节点 0 不在 restricted 中""",
        function="reachableNodes",
        params=[("n", "int"), ("edges", "int[][]"), ("restricted", "int[]")],
        returns="int",
        solver=reachable_nodes,
        public=[
            [7, [[0, 1], [1, 2], [3, 1], [3, 4], [0, 5], [5, 6]], [4, 5]],
            [7, [[0, 1], [0, 2], [0, 5], [0, 4], [3, 2], [1, 3]], [3, 5]],
            [1, [], []],
        ],
        hidden=[
            [3, [[0, 1], [1, 2]], [1]],
            [5, [[0, 1], [0, 2], [1, 3], [2, 4]], []],
            [6, [[0, 1], [1, 2], [2, 3], [3, 4], [4, 5]], [2, 4]],
            [4, [], [1, 2, 3]],
            [8, [[0, 1], [0, 2], [2, 3], [2, 4], [4, 5], [5, 6], [6, 7]], [3, 6]],
            [5, [[0, 1], [1, 2], [2, 3], [3, 4]], [4]],
        ],
    ),
    make(
        pid=2035,
        title="最长理想子序列",
        tags=["字符串", "动态规划", "哈希表"],
        description="""给定由小写字母组成的字符串 s 和整数 k
理想字符串指相邻两个字符在字母表中的绝对差不超过 k
求 s 的最长理想子序列长度
子序列从 s 中删除若干字符得到，不改变剩余字符的相对顺序""",
        function="longestIdealString",
        params=[("s", "string"), ("k", "int")],
        returns="int",
        solver=longest_ideal_string,
        public=[
            ["acfgbd", 2],
            ["abcd", 3],
            ["a", 0],
        ],
        hidden=[
            ["ab", 1],
            ["az", 1],
            ["abcabc", 2],
            ["eduktdb", 15],
            ["zzzz", 0],
            ["ba", 0],
        ],
    ),
    make(
        pid=2036,
        title="感染二叉树需要的总时间",
        tags=["树", "深度优先搜索", "广度优先搜索"],
        description="""给定二叉树的根节点 root 和一个节点值 start
从值为 start 的节点开始，每一分钟感染会传播到相邻的节点
节点值互不相同
返回整棵树都被感染需要经过的分钟数""",
        function="amountOfTime",
        params=[("root", "TreeNode"), ("start", "int")],
        returns="int",
        solver=amount_of_time,
        public=[
            [[1, 5, 3, None, 4, 10, 6, 9, 2], 3],
            [[1], 1],
            [[1, 2, 3], 2],
        ],
        hidden=[
            [[1, 2], 2],
            [[1, 2, 3, 4, 5, None, 6], 4],
            [[1, 2, 3, 4, 5, 6, 7], 7],
            [[1, 2, None, 3, None, 4], 4],
            [[1, 2, 3], 1],
            [[1, None, 2, None, 3], 2],
        ],
    ),
    make(
        pid=2037,
        title="被列覆盖的最多行数",
        tags=["数组", "回溯", "位运算"],
        description="""给定 m 行 n 列的二进制矩阵 matrix 和整数 numSelect
选择恰好 numSelect 列
若某一行中所有值为 1 的格子所在的列都被选中，则该行被覆盖
返回最多能覆盖的行数""",
        function="maximumRows",
        params=[("matrix", "int[][]"), ("numSelect", "int")],
        returns="int",
        solver=maximum_rows,
        public=[
            [[[0, 0, 0], [1, 0, 1], [0, 1, 1], [0, 0, 1]], 2],
            [[[1], [0]], 1],
            [[[1, 0], [0, 1]], 1],
        ],
        hidden=[
            [[[1, 1], [1, 0], [0, 1]], 2],
            [[[0]], 0],
            [[[1, 1, 1]], 2],
            [[[0, 1, 0, 1], [1, 0, 1, 0]], 2],
            [[[1, 0, 0], [0, 1, 0], [0, 0, 1]], 1],
            [[[1, 1, 0], [1, 0, 1], [0, 1, 1], [1, 1, 1]], 2],
        ],
    ),
    make(
        pid=2038,
        title="反转二叉树的奇数层",
        tags=["树", "广度优先搜索", "二叉树"],
        description="""给定一棵二叉树的根节点 root
根节点位于第 0 层
对每个奇数层，反转该层所有节点的值
返回处理后的树（按层序序列化输出）""",
        function="reverseOddLevels",
        params=[("root", "TreeNode")],
        returns="TreeNode",
        solver=reverse_odd_levels,
        public=[
            [[2, 3, 5, 8, 13, 21, 34]],
            [[7, 13, 11]],
            [[1]],
        ],
        hidden=[
            [[1, 2, 3]],
            [[1, 2, 3, 4, 5, 6, 7]],
            [[0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14]],
            [[1, 2, None, 3]],
            [[1, 2, 3, None, 4]],
            [[5, 3, 8, 1, 4, 7, 9]],
        ],
    ),
    make(
        pid=2039,
        title="树上最大得分",
        tags=["树", "深度优先搜索", "动态规划"],
        description="""给定一棵以节点 0 为根的树，边列表为 edges，每个节点的得分为 amount
Alice 从节点 0 出发，沿树向下走到任意叶子节点
Bob 从节点 bob 出发，沿唯一路径走到节点 0
两人每个时间单位移动一条边
节点被 Alice 先到则 Alice 获得该节点得分
节点被 Bob 先到则 Alice 得不到该节点得分
两人同时到达则 Alice 获得该节点得分的一半并向下取整
返回 Alice 可能获得的最大总分""",
        function="mostProfitablePath",
        params=[("edges", "int[][]"), ("bob", "int"), ("amount", "int[]")],
        returns="int",
        solver=most_profitable_path,
        public=[
            [[[0, 1], [1, 2], [1, 3], [3, 4]], 3, [-2, 4, 2, -4, 6]],
            [[[0, 1]], 1, [-1, 2]],
            [[[0, 1], [1, 2]], 2, [-2, 1, 3]],
        ],
        hidden=[
            [[[0, 1]], 0, [5, 7]],
            [[[0, 1], [0, 2]], 1, [1, 2, 3]],
            [[[0, 1], [1, 2], [2, 3]], 3, [5, 5, 5, 5]],
            [[[0, 1], [0, 2], [2, 3], [2, 4]], 4, [3, 6, 2, 1, 5]],
            [[[0, 1]], 1, [10, 20]],
            [[[0, 1], [1, 2], [1, 3]], 1, [0, 0, 0, 0]],
        ],
    ),
    make(
        pid=2040,
        title="逐层排序二叉树所需的最少操作数目",
        tags=["树", "广度优先搜索", "排序"],
        description="""给定二叉树的根节点 root
每一层可以独立进行任意次交换任意两个节点值的操作
求使每一层的节点值都严格递增所需的最少交换次数之和""",
        function="minimumLevelSortOperations",
        params=[("root", "TreeNode")],
        returns="int",
        solver=minimum_level_sort_operations,
        public=[
            [[1, 3, 2, 7, 6, 5, 4]],
            [[1, 2, 3]],
            [[1]],
        ],
        hidden=[
            [[4, 3, 2, 1]],
            [[1, 2, 3, 4, 5, 6, 7]],
            [[7, 6, 5, 4, 3, 2, 1]],
            [[1, 2, 3, 5, 4]],
            [[2, 1, 3, 6, 5, 4, 7]],
            [[1, 4, 2, 3]],
        ],
    ),
    make(
        pid=2041,
        title="到达首都的最少油耗",
        tags=["树", "深度优先搜索", "贪心"],
        description="""给定一棵有 n 个节点的树，节点 0 是首都，roads 为边列表
每个节点住着一个人，所有人都要前往首都
每个城市有一辆车，可以容纳 seats 人，所有人可以任意拼车
每辆车每经过一条边消耗 1 升油
返回所有人到达首都所需的最少总油耗""",
        function="minimumFuelCost",
        params=[("roads", "int[][]"), ("seats", "int")],
        returns="long",
        solver=minimum_fuel_cost,
        public=[
            [[[0, 1], [0, 2], [0, 3]], 5],
            [[[3, 1], [3, 2], [1, 0], [0, 4], [0, 5], [4, 6]], 2],
            [[[0, 1]], 1],
        ],
        hidden=[
            [[[0, 1], [1, 2]], 1],
            [[[0, 1], [0, 2]], 3],
            [[[0, 1], [1, 2], [1, 3], [3, 4]], 2],
            [[[0, 1], [0, 2], [0, 3], [0, 4]], 2],
            [[[0, 1], [1, 2], [2, 3], [3, 4], [4, 5]], 3],
            [[[0, 1]], 100],
        ],
    ),
    make(
        pid=2042,
        title="两个城市间路径的最小分数",
        tags=["图", "并查集", "深度优先搜索"],
        description="""给定城市数量 n 和道路列表 roads
每项为 [城市 a, 城市 b, 道路分数]
一条路径的分数为路径上所有道路分数的最小值
路径可以重复经过城市和道路
题目保证城市 1 和城市 n 连通
返回城市 1 到城市 n 之间路径分数的最小可能值""",
        function="minScore",
        params=[("n", "int"), ("roads", "int[][]")],
        returns="int",
        solver=min_score,
        public=[
            [4, [[1, 2, 9], [2, 3, 6], [2, 4, 5], [1, 4, 7]]],
            [4, [[1, 2, 2], [1, 3, 4], [3, 4, 7]]],
            [2, [[1, 2, 5]]],
        ],
        hidden=[
            [5, [[1, 2, 3], [2, 3, 4], [3, 4, 5], [4, 5, 6]]],
            [3, [[1, 2, 1], [2, 3, 1]]],
            [6, [[1, 2, 10], [2, 3, 1], [3, 1, 5], [3, 4, 2], [4, 5, 3], [5, 6, 4]]],
            [4, [[1, 2, 8], [2, 3, 8], [3, 4, 8], [1, 4, 8]]],
            [5, [[1, 2, 100], [2, 3, 50], [3, 4, 25], [4, 5, 12], [1, 5, 200]]],
            [2, [[1, 2, 100000]]],
        ],
    ),
    make(
        pid=2043,
        title="图中最大星和",
        tags=["图", "贪心", "排序"],
        description="""给定无向图的节点权重 values 和边列表 edges
节点编号为 0 到 n-1
以某个节点为中心可以选取它和至多 k 个邻居组成星形子图
星形子图的值为所选所有节点的权重之和
返回所有可能的星形子图中的最大权重和""",
        function="maxStarSum",
        params=[("values", "int[]"), ("edges", "int[][]"), ("k", "int")],
        returns="int",
        solver=max_star_sum,
        public=[
            [[1, 2, 3, 4, 10, -10, -20], [[0, 1], [1, 2], [1, 3], [3, 4], [3, 5], [3, 6]], 2],
            [[-1], [], 0],
            [[1, 2, 3, 4], [[0, 1], [1, 2], [2, 3]], 1],
        ],
        hidden=[
            [[5, 1, 1], [[0, 1], [0, 2]], 2],
            [[1, 2, 3], [[0, 1], [1, 2]], 0],
            [[-5, -3, -1], [[0, 1], [1, 2]], 2],
            [[4, 5, 6], [[0, 1], [0, 2], [1, 2]], 1],
            [[0, 10, 20, 30], [[0, 1], [1, 2], [2, 3]], 2],
            [[5, -2, -3], [], 1],
        ],
    ),
    make(
        pid=2044,
        title="数组中最长的方波",
        tags=["数组", "哈希表", "动态规划"],
        description="""给定整数数组 nums
方波是数组的一个子序列，且除第一个元素外每个元素都等于前一个元素的平方
求 nums 中最长方波的长度
若最长方波长度小于 2，返回 -1""",
        function="longestSquareStreak",
        params=[("nums", "int[]")],
        returns="int",
        solver=longest_square_streak,
        public=[
            [[4, 3, 6, 16, 8, 2]],
            [[2, 3, 5]],
            [[2, 4]],
        ],
        hidden=[
            [[1]],
            [[1, 2, 4, 16]],
            [[3, 9, 81]],
            [[2, 4, 16, 256]],
            [[4, 16, 2]],
            [[9, 3, 81, 6561]],
        ],
    ),
    make(
        pid=2045,
        title="最小化数组中的最大值",
        tags=["数组", "二分查找", "贪心"],
        description="""给定下标从 0 开始的非负整数数组 nums
可以执行任意次以下操作
选择下标 i 大于 0，把 nums[i] 减 1，并把 nums[i-1] 加 1
返回操作后数组最大值的最小可能值""",
        function="minimizeArrayValue",
        params=[("nums", "int[]")],
        returns="int",
        solver=minimize_array_value,
        public=[
            [[3, 7, 1, 6]],
            [[1, 2, 3, 4]],
            [[1]],
        ],
        hidden=[
            [[1, 1, 1]],
            [[10, 1, 1]],
            [[5, 0, 0, 0]],
            [[3, 7, 1, 6, 8]],
            [[0, 5, 0]],
            [[7, 1, 1, 1, 1]],
        ],
    ),
    make(
        pid=2046,
        title="将整数减少到零需要的最少操作数",
        tags=["贪心", "位运算", "动态规划"],
        description="""给定正整数 n
每次操作可以选择一个 2 的幂，把它加到 n 上或从 n 中减去
返回把 n 变成 0 所需的最少操作次数""",
        function="minOperationsToZero",
        params=[("n", "int")],
        returns="int",
        solver=min_operations_to_zero,
        public=[
            [39],
            [54],
            [1],
        ],
        hidden=[
            [2],
            [3],
            [7],
            [13],
            [100],
            [1000],
        ],
    ),
    make(
        pid=2047,
        title="解决智力问题",
        tags=["数组", "动态规划"],
        description="""给定二维数组 questions，每项为 [得分, 跳过题数]
按顺序处理题目，选择第 i 题可以获得 questions[i][0] 分
但必须跳过接下来的 questions[i][1] 道题
也可以不选择第 i 题，直接处理下一题
返回能获得的最大总分""",
        function="mostPoints",
        params=[("questions", "int[][]")],
        returns="long",
        solver=most_points,
        public=[
            [[[3, 2], [4, 3], [4, 4], [2, 5]]],
            [[[1, 1], [2, 2], [3, 3], [4, 4], [5, 5]]],
            [[[1, 1]]],
        ],
        hidden=[
            [[[2, 0], [3, 0]]],
            [[[5, 10]]],
            [[[1, 2], [2, 1], [3, 2], [4, 0]]],
            [[[10, 1], [1, 1], [10, 1], [1, 1]]],
            [[[4, 0], [3, 0], [2, 0], [1, 0]]],
            [[[7, 3], [8, 0], [9, 0], [10, 0], [11, 0], [12, 0]]],
        ],
    ),
    make(
        pid=2048,
        title="美丽子集的数目",
        tags=["数组", "回溯", "动态规划"],
        description="""给定整数数组 nums 和正整数 k
数组的子集是美丽的，当且仅当子集中不存在两个元素的差的绝对值等于 k
相同数值出现在不同下标视为不同元素
返回非空美丽子集的数目，结果对 10^9 + 7 取模""",
        function="beautifulSubsets",
        params=[("nums", "int[]"), ("k", "int")],
        returns="int",
        solver=beautiful_subsets,
        public=[
            [[2, 4, 6], 2],
            [[1], 1],
            [[1, 2, 3, 4], 1],
        ],
        hidden=[
            [[1, 3], 1],
            [[1, 2], 1],
            [[2, 4, 6, 8], 2],
            [[1, 1, 1], 1],
            [[4, 2, 5], 1],
            [[1, 2, 3], 1],
        ],
    ),
    make(
        pid=2049,
        title="老鼠和奶酪",
        tags=["数组", "贪心", "排序"],
        description="""给定两个长度相同的数组 reward1 和 reward2，以及整数 k
第 i 块奶酪被第一只老鼠吃掉得到 reward1[i] 分
被第二只老鼠吃掉得到 reward2[i] 分
第一只老鼠必须吃恰好 k 块奶酪，第二只老鼠吃掉剩下的所有奶酪
每块奶酪只能被一只老鼠吃掉
返回能获得的最大总分数""",
        function="miceAndCheese",
        params=[("reward1", "int[]"), ("reward2", "int[]"), ("k", "int")],
        returns="int",
        solver=mice_and_cheese,
        public=[
            [[1, 1, 3, 4], [4, 4, 1, 1], 2],
            [[1, 1], [1, 1], 2],
            [[1, 1], [1, 1], 0],
        ],
        hidden=[
            [[2, 5], [3, 8], 1],
            [[3, 1, 4], [1, 5, 9], 2],
            [[10], [20], 0],
            [[10], [20], 1],
            [[1, 2, 3, 4], [4, 3, 2, 1], 2],
            [[5, 5, 5], [1, 2, 3], 3],
        ],
    ),
    make(
        pid=2050,
        title="二叉树的堂兄弟节点 II",
        tags=["树", "广度优先搜索", "二叉树"],
        description="""给定二叉树的根节点 root
两个节点互为堂兄弟，当且仅当它们深度相同但父节点不同
把每个节点的值替换为它的所有堂兄弟节点值之和
返回处理后的树（按层序序列化输出）""",
        function="replaceValueInTree",
        params=[("root", "TreeNode")],
        returns="TreeNode",
        solver=replace_value_in_tree,
        public=[
            [[5, 4, 9, 1, 10, None, 7]],
            [[3, 1, 2]],
            [[1]],
        ],
        hidden=[
            [[1, 2, 3, 4, 5, 6, 7]],
            [[1, 2, None, 3]],
            [[1, 2, 3, 4]],
            [[10, 5, 15]],
            [[1, 2, 3, None, 4, 5, 6]],
            [[0, 0, 0]],
        ],
    ),
    make(
        pid=2051,
        title="使二叉树所有路径值相等的最小代价",
        tags=["树", "深度优先搜索", "贪心"],
        description="""给定一棵包含 n 个节点的满二叉树，节点按层序编号
第 i 个节点的值为 cost[i]，根节点下标为 0
节点 i 的左孩子下标为 2*i+1，右孩子下标为 2*i+2
每次操作可以把任意一个节点的值增加 1
求使所有从根到叶子的路径值之和都相等所需的最少操作次数""",
        function="minIncrements",
        params=[("n", "int"), ("cost", "int[]")],
        returns="int",
        solver=min_increments,
        public=[
            [7, [1, 5, 2, 2, 3, 3, 1]],
            [3, [1, 2, 3]],
            [1, [5]],
        ],
        hidden=[
            [15, [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15]],
            [7, [0, 0, 0, 0, 0, 0, 0]],
            [3, [5, 1, 1]],
            [7, [10, 1, 1, 1, 1, 1, 1]],
            [7, [1, 2, 3, 4, 5, 6, 7]],
            [3, [0, 5, 2]],
        ],
    ),
    make(
        pid=2052,
        title="网格图中的最大移动次数",
        tags=["数组", "动态规划", "矩阵"],
        description="""给定 m 行 n 列的网格 grid
从第一列的任意格子出发
每一步可以移动到下一列的同一行、上一行或下一行
且目标格子的值必须严格大于当前格子的值
移动不能离开网格
返回最多可以移动的步数""",
        function="maxMoves",
        params=[("grid", "int[][]")],
        returns="int",
        solver=max_moves,
        public=[
            [[[2, 4, 3, 5], [5, 4, 9, 3], [3, 4, 2, 11], [10, 9, 13, 15]]],
            [[[3, 2, 4], [2, 1, 9], [1, 1, 7]]],
            [[[1, 1], [1, 1]]],
        ],
        hidden=[
            [[[1, 2, 3]]],
            [[[1], [2], [3]]],
            [[[1, 2, 3], [3, 2, 1]]],
            [[[9, 1, 1], [1, 1, 1], [1, 1, 10]]],
            [[[1, 2, 3, 4], [5, 6, 7, 8]]],
            [[[5, 4, 3, 2, 1]]],
        ],
    ),
    make(
        pid=2053,
        title="统计完全连通分量的数目",
        tags=["图", "并查集"],
        description="""给定无向图的节点数 n 和边列表 edges
节点编号为 0 到 n-1
连通分量是完全连通的，当且仅当分量内任意两个不同节点之间都有边
返回完全连通分量的数目
单个节点构成的连通分量视为完全连通""",
        function="countCompleteComponents",
        params=[("n", "int"), ("edges", "int[][]")],
        returns="int",
        solver=count_complete_components,
        public=[
            [6, [[0, 1], [0, 2], [1, 2], [3, 4]]],
            [6, [[0, 1], [0, 2], [1, 2], [3, 4], [3, 5]]],
            [1, []],
        ],
        hidden=[
            [3, [[0, 1], [1, 2]]],
            [4, [[0, 1], [1, 2], [2, 0], [3, 0]]],
            [4, [[0, 1], [0, 2], [0, 3], [1, 2], [1, 3], [2, 3]]],
            [5, [[0, 1], [1, 2], [2, 0], [3, 4]]],
            [7, []],
            [3, [[0, 1]]],
        ],
    ),
    make(
        pid=2054,
        title="求一个整数的惩罚数",
        tags=["数学", "回溯", "枚举"],
        description="""给定正整数 n
若整数 i 的平方的十进制表示可以被切分成若干连续部分
且这些部分表示的整数之和恰好等于 i，则称 i 是惩罚数
求 1 到 n 之间所有惩罚数的平方之和""",
        function="punishmentNumber",
        params=[("n", "int")],
        returns="int",
        solver=punishment_number,
        public=[
            [10],
            [1],
            [37],
        ],
        hidden=[
            [9],
            [100],
            [2],
            [3],
            [50],
            [1000],
        ],
    ),
    make(
        pid=2055,
        title="字符串中的额外字符",
        tags=["字符串", "动态规划", "哈希表"],
        description="""给定字符串 s 和一个字符串字典 dictionary
把 s 中若干互不重叠的连续子串标记为字典中的单词
返回 s 中未被标记的字符数量的最小值
注意同一个字典单词可以在标记中多次使用""",
        function="minExtraChar",
        params=[("s", "string"), ("dictionary", "string[]")],
        returns="int",
        solver=min_extra_char,
        public=[
            ["leetscode", ["leet", "code", "leetcode"]],
            ["sayhelloworld", ["hello", "world"]],
            ["abc", []],
        ],
        hidden=[
            ["abc", ["a", "b", "c"]],
            ["abcd", ["ab", "cd"]],
            ["abcd", ["abc"]],
            ["aaa", ["aa"]],
            [
                "dwmodizxvvbosxxw",
                [
                    "ox",
                    "lb",
                    "diz",
                    "gu",
                    "v",
                    "ksv",
                    "o",
                    "nuq",
                    "r",
                    "txhe",
                    "e",
                    "wmo",
                    "cehy",
                    "tskz",
                    "ds",
                    "kzbu",
                ],
            ],
            ["a", ["b"]],
            ["ab", ["a"]],
        ],
    ),
    make(
        pid=2056,
        title="找出最安全路径",
        tags=["数组", "广度优先搜索", "二分查找"],
        description="""给定 n 行 n 列的网格 grid，1 表示该格子有小偷，0 表示空格子
一个格子的安全系数等于它到最近小偷的曼哈顿距离
一条路径的安全系数等于路径上所有格子安全系数的最小值
从左上角走到右下角
返回所有路径中安全系数的最大值""",
        function="maximumSafenessFactor",
        params=[("grid", "int[][]")],
        returns="int",
        solver=maximum_safeness_factor,
        public=[
            [[[1, 0, 0], [0, 0, 0], [0, 0, 1]]],
            [[[0, 0, 1], [0, 0, 0], [0, 0, 0]]],
            [[[0, 0, 0], [0, 1, 0], [0, 0, 0]]],
        ],
        hidden=[
            [[[0, 1, 0], [0, 0, 0], [0, 0, 0]]],
            [[[0, 0, 0], [0, 0, 1], [0, 0, 0]]],
            [[[0, 0, 0, 0], [0, 0, 0, 0], [1, 0, 0, 0], [0, 0, 0, 0]]],
            [[[0, 0], [1, 0]]],
            [[[0, 1, 0, 0], [0, 0, 0, 0], [0, 0, 0, 0], [0, 0, 0, 0]]],
            [[[0, 0, 0], [0, 0, 0], [0, 0, 1]]],
        ],
    ),
    make(
        pid=2057,
        title="找到冠军 II",
        tags=["图", "数组"],
        description="""给定 n 支队伍和比赛结果 edges
每项 [winner, loser] 表示 winner 战胜了 loser
冠军定义为没有输给任何其他队伍的队伍
若冠军唯一则返回其编号，否则返回 -1""",
        function="findChampion",
        params=[("n", "int"), ("edges", "int[][]")],
        returns="int",
        solver=find_champion,
        public=[
            [3, [[0, 1], [1, 2]]],
            [4, [[0, 2], [1, 3], [1, 2]]],
            [2, [[0, 1]]],
        ],
        hidden=[
            [3, [[1, 0], [2, 0]]],
            [4, [[0, 1], [1, 2], [2, 3]]],
            [1, []],
            [5, [[0, 1], [0, 2], [0, 3], [0, 4]]],
            [5, [[1, 0], [2, 0], [3, 0], [4, 0], [1, 2]]],
            [6, [[0, 1], [1, 2], [2, 3], [3, 4], [4, 5], [0, 5]]],
        ],
    ),
    make(
        pid=2058,
        title="转换字符串的最小成本 I",
        tags=["图", "最短路", "数组"],
        description="""给定两个长度相同的字符串 source 和 target
给定若干字符转换规则，original[i] 可以转换为 changed[i]，成本为 cost[i]
转换规则可以连续使用，也可以不使用
把 source 的每个字符分别转换为 target 对应位置的字符
返回最小总成本，若无法完成转换则返回 -1""",
        function="minimumCostConvert",
        params=[
            ("source", "string"),
            ("target", "string"),
            ("original", "string[]"),
            ("changed", "string[]"),
            ("cost", "int[]"),
        ],
        returns="long",
        solver=minimum_cost_convert,
        public=[
            [
                "abcd",
                "acbe",
                ["a", "b", "c", "c", "e", "d"],
                ["b", "c", "b", "e", "b", "e"],
                [2, 5, 5, 1, 2, 20],
            ],
            ["aaaa", "bbbb", ["a", "c"], ["c", "b"], [1, 2]],
            ["abc", "def", ["a"], ["d"], [5]],
        ],
        hidden=[
            ["a", "a", [], [], []],
            ["ab", "ba", ["a", "b"], ["b", "a"], [2, 3]],
            ["x", "y", ["x"], ["y"], [10]],
            ["abc", "abc", ["a", "b"], ["b", "c"], [1, 1]],
            ["aaa", "bbb", ["a", "b"], ["b", "c"], [1, 1]],
            ["abc", "def", ["a", "b", "c"], ["b", "c", "d"], [1, 1, 100]],
        ],
    ),
    make(
        pid=2059,
        title="需要添加的硬币的最小数量",
        tags=["数组", "贪心", "排序"],
        description="""给定正整数数组 coins 和整数 target
可以往数组中加入任意面额的正整数硬币
要求加入硬币后，能够用数组中的部分硬币组成 1 到 target 之间的所有整数金额
返回最少需要添加的硬币数量""",
        function="minimumAddedCoins",
        params=[("coins", "int[]"), ("target", "int")],
        returns="int",
        solver=minimum_added_coins,
        public=[
            [[1, 4, 10], 19],
            [[1, 4, 10, 5, 9], 19],
            [[1, 1, 1], 20],
        ],
        hidden=[
            [[1], 1],
            [[2], 3],
            [[5, 10], 20],
            [[1, 2, 3, 4], 10],
            [[3, 7], 5],
            [[1, 5, 10], 20],
        ],
    ),
]
