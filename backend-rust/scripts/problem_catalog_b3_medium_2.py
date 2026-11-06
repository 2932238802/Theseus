"""1817-1859：批量第三批中等题（43 道）。"""

from __future__ import annotations

import heapq
from collections import Counter, deque
from functools import partial

from problem_seed_common import Node, make_problem, tree_from_list, tree_to_list

make = partial(make_problem, difficulty="medium")

MOD = 10**9 + 7


# ── 树 ────────────────────────────────────────────────────────────


def deepest_leaves_sum(root: list) -> int:
    node = tree_from_list(root)
    if node is None:
        return 0
    queue = [node]
    while queue:
        total = sum(item.value for item in queue)
        nxt = []
        for item in queue:
            if item.left:
                nxt.append(item.left)
            if item.right:
                nxt.append(item.right)
        if not nxt:
            return total
        queue = nxt
    return 0


def _inorder_values(node: Node | None, out: list[int]) -> None:
    if node is None:
        return
    _inorder_values(node.left, out)
    out.append(node.value)
    _inorder_values(node.right, out)


def get_all_elements(root1: list, root2: list) -> list[int]:
    first: list[int] = []
    second: list[int] = []
    _inorder_values(tree_from_list(root1), first)
    _inorder_values(tree_from_list(root2), second)
    merged: list[int] = []
    i = j = 0
    while i < len(first) and j < len(second):
        if first[i] <= second[j]:
            merged.append(first[i])
            i += 1
        else:
            merged.append(second[j])
            j += 1
    merged.extend(first[i:])
    merged.extend(second[j:])
    return merged


def sum_even_grandparent(root: list) -> int:
    def dfs(node: Node | None, parent: int | None, grand: int | None) -> int:
        if node is None:
            return 0
        total = node.value if grand is not None and grand % 2 == 0 else 0
        return (
            total
            + dfs(node.left, node.value, parent)
            + dfs(node.right, node.value, parent)
        )

    return dfs(tree_from_list(root), None, None)


def remove_leaf_nodes(root: list, target: int) -> list:
    def dfs(node: Node | None) -> Node | None:
        if node is None:
            return None
        node.left = dfs(node.left)
        node.right = dfs(node.right)
        if node.left is None and node.right is None and node.value == target:
            return None
        return node

    return tree_to_list(dfs(tree_from_list(root)))


def max_product(root: list) -> int:
    sums: list[int] = []

    def dfs(node: Node | None) -> int:
        if node is None:
            return 0
        current = node.value + dfs(node.left) + dfs(node.right)
        sums.append(current)
        return current

    total = dfs(tree_from_list(root))
    best = 0
    for value in sums:
        if value != total:
            best = max(best, value * (total - value))
    return best % MOD


def balance_bst(root: list) -> list:
    values: list[int] = []
    _inorder_values(tree_from_list(root), values)

    def build(lo: int, hi: int) -> Node | None:
        if lo > hi:
            return None
        mid = (lo + hi) // 2
        return Node(values[mid], build(lo, mid - 1), build(mid + 1, hi))

    return tree_to_list(build(0, len(values) - 1))


def pseudo_palindromic_paths(root: list) -> int:
    result = 0

    def dfs(node: Node | None, mask: int) -> None:
        nonlocal result
        if node is None:
            return
        mask ^= 1 << node.value
        if node.left is None and node.right is None:
            if mask & (mask - 1) == 0:
                result += 1
            return
        dfs(node.left, mask)
        dfs(node.right, mask)

    dfs(tree_from_list(root), 0)
    return result


def count_pairs(root: list, distance: int) -> int:
    result = 0

    def dfs(node: Node | None) -> list[int]:
        nonlocal result
        if node is None:
            return []
        if node.left is None and node.right is None:
            return [0]
        left = dfs(node.left)
        right = dfs(node.right)
        for a in left:
            for b in right:
                if a + b + 2 <= distance:
                    result += 1
        depths = [value + 1 for value in left + right]
        return [value for value in depths if value < distance]

    dfs(tree_from_list(root))
    return result


def is_even_odd_tree(root: list) -> bool:
    node = tree_from_list(root)
    if node is None:
        return True
    queue = [node]
    level = 0
    while queue:
        values = [item.value for item in queue]
        if level % 2 == 0:
            if any(value % 2 == 0 for value in values):
                return False
            if any(values[i] >= values[i + 1] for i in range(len(values) - 1)):
                return False
        else:
            if any(value % 2 == 1 for value in values):
                return False
            if any(values[i] <= values[i + 1] for i in range(len(values) - 1)):
                return False
        nxt = []
        for item in queue:
            if item.left:
                nxt.append(item.left)
            if item.right:
                nxt.append(item.right)
        queue = nxt
        level += 1
    return True


def find_distance(root: list, p: int, q: int) -> int:
    def path(node: Node | None, target: int, acc: list[int]) -> list[int] | None:
        if node is None:
            return None
        acc = acc + [node.value]
        if node.value == target:
            return acc
        found = path(node.left, target, acc)
        if found is not None:
            return found
        return path(node.right, target, acc)

    start = tree_from_list(root)
    first = path(start, p, [])
    second = path(start, q, [])
    if first is None or second is None:
        return -1
    i = 0
    while i < len(first) and i < len(second) and first[i] == second[i]:
        i += 1
    return len(first) + len(second) - 2 * i


# ── 图 ────────────────────────────────────────────────────────────


def find_the_city(n: int, edges: list[list[int]], distance_threshold: int) -> int:
    inf = float("inf")
    dist = [[inf] * n for _ in range(n)]
    for i in range(n):
        dist[i][i] = 0
    for u, v, w in edges:
        if w < dist[u][v]:
            dist[u][v] = dist[v][u] = w
    for k in range(n):
        dk = dist[k]
        for i in range(n):
            dik = dist[i][k]
            if dik == inf:
                continue
            di = dist[i]
            for j in range(n):
                candidate = dik + dk[j]
                if candidate < di[j]:
                    di[j] = candidate
    best_city = -1
    best_count = n + 1
    for city in range(n):
        count = sum(
            1
            for other in range(n)
            if other != city and dist[city][other] <= distance_threshold
        )
        if count <= best_count:
            best_count = count
            best_city = city
    return best_city


def check_if_prerequisite(
    num_courses: int, prerequisites: list[list[int]], queries: list[list[int]]
) -> list[int]:
    reach = [[False] * num_courses for _ in range(num_courses)]
    for before, after in prerequisites:
        reach[before][after] = True
    for k in range(num_courses):
        for i in range(num_courses):
            if not reach[i][k]:
                continue
            row = reach[i]
            row_k = reach[k]
            for j in range(num_courses):
                if row_k[j]:
                    row[j] = True
    return [1 if reach[before][after] else 0 for before, after in queries]


def count_paths(n: int, roads: list[list[int]]) -> int:
    graph: list[list[tuple[int, int]]] = [[] for _ in range(n)]
    for u, v, w in roads:
        graph[u].append((v, w))
        graph[v].append((u, w))
    inf = float("inf")
    dist = [inf] * n
    dist[0] = 0
    heap = [(0, 0)]
    while heap:
        current, node = heapq.heappop(heap)
        if current > dist[node]:
            continue
        for neighbor, weight in graph[node]:
            candidate = current + weight
            if candidate < dist[neighbor]:
                dist[neighbor] = candidate
                heapq.heappush(heap, (candidate, neighbor))
    order = sorted(range(n), key=lambda city: dist[city])
    ways = [0] * n
    ways[0] = 1
    for node in order:
        if dist[node] == inf:
            continue
        for neighbor, weight in graph[node]:
            if dist[node] + weight == dist[neighbor]:
                ways[neighbor] = (ways[neighbor] + ways[node]) % MOD
    return ways[n - 1] % MOD


def find_smallest_set_of_vertices(n: int, edges: list[list[int]]) -> list[int]:
    indegree = [0] * n
    for _, v in edges:
        indegree[v] += 1
    return [node for node in range(n) if indegree[node] == 0]


def maximal_network_rank(n: int, roads: list[list[int]]) -> int:
    degree = [0] * n
    existing: set[tuple[int, int]] = set()
    for u, v in roads:
        degree[u] += 1
        degree[v] += 1
        existing.add((u, v) if u < v else (v, u))
    best = 0
    for i in range(n):
        for j in range(i + 1, n):
            current = degree[i] + degree[j] - (1 if (i, j) in existing else 0)
            best = max(best, current)
    return best


def _make_dsu(n: int) -> tuple[list[int], callable]:
    parent = list(range(n))

    def find(x: int) -> int:
        while parent[x] != x:
            parent[x] = parent[parent[x]]
            x = parent[x]
        return x

    return parent, find


def valid_path(n: int, edges: list[list[int]], source: int, destination: int) -> bool:
    parent, find = _make_dsu(n)

    def union(a: int, b: int) -> None:
        ra, rb = find(a), find(b)
        if ra != rb:
            parent[ra] = rb

    for u, v in edges:
        union(u, v)
    return find(source) == find(destination)


def nearest_exit(maze: list[list[str]], entrance: list[int]) -> int:
    rows, cols = len(maze), len(maze[0])
    start_r, start_c = entrance
    queue = deque([(start_r, start_c, 0)])
    visited = {(start_r, start_c)}
    while queue:
        r, c, steps = queue.popleft()
        if steps > 0 and (r == 0 or r == rows - 1 or c == 0 or c == cols - 1):
            return steps
        for dr, dc in ((1, 0), (-1, 0), (0, 1), (0, -1)):
            nr, nc = r + dr, c + dc
            if (
                0 <= nr < rows
                and 0 <= nc < cols
                and maze[nr][nc] == "."
                and (nr, nc) not in visited
            ):
                visited.add((nr, nc))
                queue.append((nr, nc, steps + 1))
    return -1


def can_reach(s: str, min_jump: int, max_jump: int) -> bool:
    n = len(s)
    reachable = [False] * n
    reachable[0] = True
    next_unvisited = 1
    for i in range(n):
        if not reachable[i]:
            continue
        lo = i + min_jump
        hi = min(n - 1, i + max_jump)
        if lo > hi:
            continue
        if lo < next_unvisited:
            lo = next_unvisited
        for j in range(lo, hi + 1):
            if s[j] == "0":
                reachable[j] = True
        if hi + 1 > next_unvisited:
            next_unvisited = hi + 1
    return reachable[n - 1]


def count_sub_islands(grid1: list[list[int]], grid2: list[list[int]]) -> int:
    rows, cols = len(grid2), len(grid2[0])
    visited = [[False] * cols for _ in range(rows)]
    result = 0

    def dfs(r: int, c: int) -> bool:
        if r < 0 or r >= rows or c < 0 or c >= cols:
            return True
        if grid2[r][c] == 0 or visited[r][c]:
            return True
        visited[r][c] = True
        ok = grid1[r][c] == 1
        for dr, dc in ((1, 0), (-1, 0), (0, 1), (0, -1)):
            if not dfs(r + dr, c + dc):
                ok = False
        return ok

    for r in range(rows):
        for c in range(cols):
            if grid2[r][c] == 1 and not visited[r][c]:
                if dfs(r, c):
                    result += 1
    return result


def highest_peak(is_water: list[list[int]]) -> list[list[int]]:
    rows, cols = len(is_water), len(is_water[0])
    height = [[-1] * cols for _ in range(rows)]
    queue = deque()
    for r in range(rows):
        for c in range(cols):
            if is_water[r][c] == 1:
                height[r][c] = 0
                queue.append((r, c))
    while queue:
        r, c = queue.popleft()
        for dr, dc in ((1, 0), (-1, 0), (0, 1), (0, -1)):
            nr, nc = r + dr, c + dc
            if 0 <= nr < rows and 0 <= nc < cols and height[nr][nc] == -1:
                height[nr][nc] = height[r][c] + 1
                queue.append((nr, nc))
    return height


def find_farmland(land: list[list[int]]) -> list[list[int]]:
    rows, cols = len(land), len(land[0])
    grid = [row[:] for row in land]
    result: list[list[int]] = []
    for r in range(rows):
        for c in range(cols):
            if grid[r][c] != 1:
                continue
            c2 = c
            while c2 + 1 < cols and grid[r][c2 + 1] == 1:
                c2 += 1
            r2 = r
            while r2 + 1 < rows and all(
                grid[r2 + 1][k] == 1 for k in range(c, c2 + 1)
            ):
                r2 += 1
            for i in range(r, r2 + 1):
                for j in range(c, c2 + 1):
                    grid[i][j] = 0
            result.append([r, c, r2, c2])
    return result


# ── 并查集 ────────────────────────────────────────────────────────


def generate_sentences(synonyms: list[list[str]], text: str) -> list[str]:
    parent: dict[str, str] = {}

    def find(word: str) -> str:
        parent.setdefault(word, word)
        while parent[word] != word:
            parent[word] = parent[parent[word]]
            word = parent[word]
        return word

    def union(a: str, b: str) -> None:
        ra, rb = find(a), find(b)
        if ra != rb:
            parent[ra] = rb

    for a, b in synonyms:
        union(a, b)

    groups: dict[str, list[str]] = {}
    for word in parent:
        groups.setdefault(find(word), []).append(word)
    for values in groups.values():
        values.sort()

    words = text.split(" ")
    options = [groups[find(word)] if word in parent else [word] for word in words]
    result: list[str] = []

    def backtrack(index: int, current: list[str]) -> None:
        if index == len(options):
            result.append(" ".join(current))
            return
        for word in options[index]:
            current.append(word)
            backtrack(index + 1, current)
            current.pop()

    backtrack(0, [])
    result.sort()
    return result


def make_connected(n: int, connections: list[list[int]]) -> int:
    if len(connections) < n - 1:
        return -1
    parent, find = _make_dsu(n)

    def union(a: int, b: int) -> None:
        ra, rb = find(a), find(b)
        if ra != rb:
            parent[ra] = rb

    for u, v in connections:
        union(u, v)
    components = len({find(node) for node in range(n)})
    return components - 1


def find_latest_step(arr: list[int], m: int) -> int:
    n = len(arr)
    parent = list(range(n + 1))
    size = [1] * (n + 1)
    active = [False] * (n + 1)

    def find(x: int) -> int:
        while parent[x] != x:
            parent[x] = parent[parent[x]]
            x = parent[x]
        return x

    count_m = 0
    latest = -1
    for step, value in enumerate(arr, start=1):
        active[value] = True
        size[value] = 1
        if size[value] == m:
            count_m += 1
        for neighbor in (value - 1, value + 1):
            if 1 <= neighbor <= n and active[neighbor]:
                ra, rb = find(value), find(neighbor)
                if ra == rb:
                    continue
                if size[ra] == m:
                    count_m -= 1
                if size[rb] == m:
                    count_m -= 1
                if size[ra] < size[rb]:
                    ra, rb = rb, ra
                parent[rb] = ra
                size[ra] += size[rb]
                if size[ra] == m:
                    count_m += 1
        if count_m > 0:
            latest = step
    return latest


def minimum_hamming_distance(
    source: list[int], target: list[int], allowed_swaps: list[list[int]]
) -> int:
    n = len(source)
    parent, find = _make_dsu(n)

    def union(a: int, b: int) -> None:
        ra, rb = find(a), find(b)
        if ra != rb:
            parent[ra] = rb

    for u, v in allowed_swaps:
        union(u, v)

    groups: dict[int, list[int]] = {}
    for index in range(n):
        groups.setdefault(find(index), []).append(index)

    result = 0
    for indices in groups.values():
        source_count = Counter(source[i] for i in indices)
        target_count = Counter(target[i] for i in indices)
        for value, count in source_count.items():
            result += max(0, count - target_count.get(value, 0))
    return result


def are_connected(n: int, threshold: int, queries: list[list[int]]) -> list[int]:
    parent, find = _make_dsu(n + 1)

    def union(a: int, b: int) -> None:
        ra, rb = find(a), find(b)
        if ra != rb:
            parent[ra] = rb

    for divisor in range(threshold + 1, n + 1):
        multiple = divisor * 2
        while multiple <= n:
            union(divisor, multiple)
            multiple += divisor
    return [1 if find(u) == find(v) else 0 for u, v in queries]


# ── 动态规划 ──────────────────────────────────────────────────────


def longest_subsequence(arr: list[int], difference: int) -> int:
    dp: dict[int, int] = {}
    best = 0
    for value in arr:
        dp[value] = dp.get(value - difference, 0) + 1
        best = max(best, dp[value])
    return best


def max_sum_div_three(nums: list[int]) -> int:
    neg_inf = -10**18
    dp = [0, neg_inf, neg_inf]
    for value in nums:
        nxt = dp[:]
        for remainder in range(3):
            if dp[remainder] == neg_inf:
                continue
            new_remainder = (remainder + value) % 3
            candidate = dp[remainder] + value
            if candidate > nxt[new_remainder]:
                nxt[new_remainder] = candidate
        dp = nxt
    return dp[0]


def min_falling_path_sum(grid: list[list[int]]) -> int:
    n = len(grid)
    dp = grid[0][:]
    inf = float("inf")
    for r in range(1, n):
        first = second = inf
        first_index = -1
        for c, value in enumerate(dp):
            if value < first:
                second = first
                first = value
                first_index = c
            elif value < second:
                second = value
        nxt = []
        for c in range(n):
            best_previous = first if c != first_index else second
            if best_previous == inf:
                best_previous = first
            nxt.append(grid[r][c] + best_previous)
        dp = nxt
    return min(dp)


def num_teams(rating: list[int]) -> int:
    n = len(rating)
    result = 0
    for j in range(n):
        less_left = sum(1 for i in range(j) if rating[i] < rating[j])
        greater_left = sum(1 for i in range(j) if rating[i] > rating[j])
        less_right = sum(1 for k in range(j + 1, n) if rating[k] < rating[j])
        greater_right = sum(1 for k in range(j + 1, n) if rating[k] > rating[j])
        result += less_left * greater_right + greater_left * less_right
    return result


def max_score(card_points: list[int], k: int) -> int:
    n = len(card_points)
    window = n - k
    total = sum(card_points)
    if window == 0:
        return total
    current = sum(card_points[:window])
    minimum = current
    for i in range(window, n):
        current += card_points[i] - card_points[i - window]
        minimum = min(minimum, current)
    return total - minimum


def count_triplets(arr: list[int]) -> int:
    n = len(arr)
    prefix = [0] * (n + 1)
    for i, value in enumerate(arr):
        prefix[i + 1] = prefix[i] ^ value
    result = 0
    for i in range(n):
        for k in range(i + 1, n):
            if prefix[i] == prefix[k + 1]:
                result += k - i
    return result


def num_submat(mat: list[list[int]]) -> int:
    cols = len(mat[0])
    heights = [0] * cols
    total = 0
    for row in mat:
        for c in range(cols):
            heights[c] = heights[c] + 1 if row[c] == 1 else 0
        stack: list[tuple[int, int]] = []
        current = 0
        for height in heights:
            count = 1
            while stack and stack[-1][0] >= height:
                previous_height, previous_count = stack.pop()
                current -= previous_height * previous_count
                count += previous_count
            stack.append((height, count))
            current += height * count
            total += current
    return total


def get_max_len(nums: list[int]) -> int:
    positive = negative = 0
    best = 0
    for value in nums:
        if value > 0:
            positive += 1
            negative = negative + 1 if negative > 0 else 0
        elif value < 0:
            new_positive = negative + 1 if negative > 0 else 0
            new_negative = positive + 1
            positive, negative = new_positive, new_negative
        else:
            positive = negative = 0
        best = max(best, positive)
    return best


def best_team_score(scores: list[int], ages: list[int]) -> int:
    players = sorted(zip(ages, scores))
    n = len(players)
    dp = [0] * n
    best = 0
    for i in range(n):
        score = players[i][1]
        dp[i] = score
        for j in range(i):
            if players[j][1] <= score:
                dp[i] = max(dp[i], dp[j] + score)
        best = max(best, dp[i])
    return best


def min_subarray(nums: list[int], p: int) -> int:
    total_remainder = sum(nums) % p
    if total_remainder == 0:
        return 0
    last: dict[int, int] = {0: -1}
    current = 0
    n = len(nums)
    best = n
    for i, value in enumerate(nums):
        current = (current + value) % p
        need = (current - total_remainder) % p
        if need in last:
            best = min(best, i - last[need])
        last[current] = i
    return best if best < n else -1


def max_product_path(grid: list[list[int]]) -> int:
    rows, cols = len(grid), len(grid[0])
    maximum = [[0] * cols for _ in range(rows)]
    minimum = [[0] * cols for _ in range(rows)]
    maximum[0][0] = minimum[0][0] = grid[0][0]
    for r in range(rows):
        for c in range(cols):
            if r == 0 and c == 0:
                continue
            candidates: list[int] = []
            if r > 0:
                candidates.append(maximum[r - 1][c] * grid[r][c])
                candidates.append(minimum[r - 1][c] * grid[r][c])
            if c > 0:
                candidates.append(maximum[r][c - 1] * grid[r][c])
                candidates.append(minimum[r][c - 1] * grid[r][c])
            maximum[r][c] = max(candidates)
            minimum[r][c] = min(candidates)
    best = maximum[rows - 1][cols - 1]
    return -1 if best < 0 else best % MOD


def minimum_jumps(forbidden: list[int], a: int, b: int, x: int) -> int:
    blocked = set(forbidden)
    if x in blocked:
        return -1
    limit = max([x] + list(blocked)) + a + b
    queue = deque([(0, 0, 0)])
    visited = {(0, 0)}
    while queue:
        position, last_backward, steps = queue.popleft()
        if position == x:
            return steps
        forward = position + a
        if (
            forward <= limit
            and forward not in blocked
            and (forward, 0) not in visited
        ):
            visited.add((forward, 0))
            queue.append((forward, 0, steps + 1))
        if last_backward == 0:
            backward = position - b
            if backward >= 0 and backward not in blocked and (backward, 1) not in visited:
                visited.add((backward, 1))
                queue.append((backward, 1, steps + 1))
    return -1


def maximum_gain(s: str, x: int, y: int) -> int:
    def remove(text: str, first: str, second: str, score: int) -> tuple[str, int]:
        stack: list[str] = []
        total = 0
        for char in text:
            if stack and stack[-1] == first and char == second:
                stack.pop()
                total += score
            else:
                stack.append(char)
        return "".join(stack), total

    if x >= y:
        remaining, total = remove(s, "a", "b", x)
        _, extra = remove(remaining, "b", "a", y)
    else:
        remaining, total = remove(s, "b", "a", y)
        _, extra = remove(remaining, "a", "b", x)
    return total + extra


def closest_cost(
    base_costs: list[int], topping_costs: list[int], target: int
) -> int:
    best: int | None = None

    def consider(cost: int) -> None:
        nonlocal best
        if (
            best is None
            or abs(cost - target) < abs(best - target)
            or (abs(cost - target) == abs(best - target) and cost < best)
        ):
            best = cost

    n = len(topping_costs)

    def dfs(index: int, cost: int) -> None:
        consider(cost)
        if index == n or cost >= target:
            return
        topping = topping_costs[index]
        dfs(index + 1, cost)
        dfs(index + 1, cost + topping)
        dfs(index + 1, cost + 2 * topping)

    for base in base_costs:
        dfs(0, base)
    return best if best is not None else 0


def min_side_jumps(obstacles: list[int]) -> int:
    inf = 10**9
    dp = [1, 0, 1]
    if obstacles[0] != 0:
        dp[obstacles[0] - 1] = inf
    for position in range(1, len(obstacles)):
        blocked = obstacles[position] - 1 if obstacles[position] != 0 else -1
        free = [lane != blocked for lane in range(3)]
        nxt = [dp[lane] if free[lane] else inf for lane in range(3)]
        best = min(nxt)
        if best != inf:
            for lane in range(3):
                if free[lane]:
                    nxt[lane] = min(nxt[lane], best + 1)
        dp = nxt
    return min(dp)


def max_points(points: list[list[int]]) -> int:
    cols = len(points[0])
    previous = points[0][:]
    for row in points[1:]:
        left = [0] * cols
        right = [0] * cols
        left[0] = previous[0]
        for j in range(1, cols):
            left[j] = max(left[j - 1] - 1, previous[j])
        right[-1] = previous[-1]
        for j in range(cols - 2, -1, -1):
            right[j] = max(right[j + 1] - 1, previous[j])
        previous = [
            row[j] + max(left[j], right[j]) for j in range(cols)
        ]
    return max(previous)


def find_different_binary_string(nums: list[str]) -> str:
    result = []
    for i, value in enumerate(nums):
        result.append("1" if value[i] == "0" else "0")
    return "".join(result)


PROBLEMS = [
    make(
        pid=1817,
        title="层数最深叶子节点的和",
        tags=["树", "深度优先搜索", "广度优先搜索"],
        description="""给定一棵二叉树的根节点 root
返回所有最深叶子节点的值之和
叶子节点是没有子节点的节点
最深叶子节点是深度最大的叶子节点""",
        function="deepestLeavesSum",
        params=[("root", "TreeNode")],
        returns="int",
        solver=deepest_leaves_sum,
        public=[
            [[1, 2, 3, 4, 5, None, 6, 7, None, None, None, None, 8]],
            [[6, 7, 8, 2, 7, 1, 3, 9, None, 1, 4, None, None, None, 5]],
            [[1]],
            [[1, 2, 3]],
        ],
        hidden=[
            [[1, 2, 3, 4]],
            [[1, None, 2, None, 3]],
            [[1, 2, None, 3, None, 4]],
            [[5, 3, 8, 1, 4, 7, 9]],
            [[-1, -2, -3]],
        ],
    ),
    make(
        pid=1818,
        title="两棵二叉搜索树中的所有元素",
        tags=["树", "二叉搜索树", "归并排序"],
        description="""给定两棵二叉搜索树的根节点 root1 和 root2
返回一个升序数组，包含两棵树中的所有整数
结果按升序排列
树中可能没有节点，此时用空列表表示""",
        function="getAllElements",
        params=[("root1", "TreeNode"), ("root2", "TreeNode")],
        returns="int[]",
        solver=get_all_elements,
        public=[
            [[2, 1, 4], [1, 0, 3]],
            [[1, None, 8], [8, 1]],
            [[], []],
        ],
        hidden=[
            [[1], [2]],
            [[5, 3, 7], [2, 4, 6]],
            [[1, None, 2], [3]],
            [[2, None, 3], [1]],
            [[10, 5, 15], [1, 2, 3]],
        ],
    ),
    make(
        pid=1819,
        title="祖父节点值为偶数的节点和",
        tags=["树", "深度优先搜索"],
        description="""给定一棵二叉树的根节点 root
返回所有祖父节点值为偶数的节点值之和
节点 x 的祖父节点是 x 的父节点的父节点
若节点没有祖父节点则不计入""",
        function="sumEvenGrandparent",
        params=[("root", "TreeNode")],
        returns="int",
        solver=sum_even_grandparent,
        public=[
            [[6, 7, 8, 2, 7, 1, 3, 9, None, 1, 4, None, None, None, 5]],
            [[1]],
            [[2, 1, 3]],
            [[2, None, 4, 6, None, 8]],
        ],
        hidden=[
            [[4, 1, 2]],
            [[4, 2, None]],
            [[8, 4, 10, 2, 6, 9, 11]],
            [[2, 6, 8, 4, None, None, 10]],
            [[2, 4, 6, 8, 10, 12, 14]],
        ],
    ),
    make(
        pid=1820,
        title="删除给定值的叶子节点",
        tags=["树", "深度优先搜索"],
        description="""给定一棵二叉树的根节点 root 和一个整数 target
反复删除所有值为 target 的叶子节点
删除后其父节点可能变成新的叶子节点，也应继续删除
返回最终二叉树的层序表示，若为空树则返回空列表""",
        function="removeLeafNodes",
        params=[("root", "TreeNode"), ("target", "int")],
        returns="TreeNode",
        solver=remove_leaf_nodes,
        public=[
            [[1, 2, 3, 2, None, 2, 4], 2],
            [[1, 3, 3, 3, 2], 3],
            [[1, 2, None, 2, None, 2], 2],
            [[1, 1, 1], 1],
        ],
        hidden=[
            [[1, 2, 3], 1],
            [[2, 2, 2], 2],
            [[1, None, 2, None, 3], 3],
            [[1, 2, 2, None, None, 2, 2], 2],
            [[4, 2, 3, None, 2], 2],
        ],
    ),
    make(
        pid=1821,
        title="分裂二叉树的最大乘积",
        tags=["树", "深度优先搜索"],
        description="""给定一棵二叉树的根节点 root
删除一条边，将树分成两棵非空子树
两棵子树节点和之积为本次分裂的得分
返回所有分裂方式中的最大得分，结果对 1e9+7 取余
树至少有两个节点""",
        function="maxProduct",
        params=[("root", "TreeNode")],
        returns="int",
        solver=max_product,
        public=[
            [[1, 2, 3, 4, 5, 6]],
            [[1, None, 2, 3, 4, None, None, 5, 6]],
            [[1, 2]],
            [[2, 3, 9, 10, 7, 8, 6, 5, 4, 11, 1]],
        ],
        hidden=[
            [[1, 2, 3]],
            [[10, 5, 15]],
            [[1, 1]],
            [[1, 2, None]],
            [[3, 7, 5, 1, 9, 2]],
        ],
    ),
    make(
        pid=1822,
        title="将二叉搜索树变平衡",
        tags=["树", "二叉搜索树", "分治"],
        description="""给定一棵二叉搜索树的根节点 root
将其转换为平衡二叉搜索树并返回新树的层序表示
平衡指每个节点左右子树高度差不超过 1
新树的中序遍历必须与原树相同
若存在多种结果，按每次取有序数组中间位置作为根的方式构造""",
        function="balanceBST",
        params=[("root", "TreeNode")],
        returns="TreeNode",
        solver=balance_bst,
        public=[
            [[1, None, 2, None, 3, None, 4]],
            [[2, 1, 3]],
            [[1]],
            [[1, None, 2]],
        ],
        hidden=[
            [[1, 2, 3, 4]],
            [[5, 4, 6, 3, None, None, 7]],
            [[1, None, 2, None, 3, None, 4, None, 5]],
            [[3, 1, 4, None, 2]],
            [[2, 1, 3, None, None, None, 4]],
        ],
    ),
    make(
        pid=1823,
        title="二叉树中的伪回文路径",
        tags=["树", "深度优先搜索", "位运算"],
        description="""给定一棵二叉树的根节点 root，节点值在 1 到 9 之间
一条根到叶子的路径中，若节点值的多重集合可以重新排列成回文，则称为伪回文路径
返回伪回文路径的数量""",
        function="pseudoPalindromicPaths",
        params=[("root", "TreeNode")],
        returns="int",
        solver=pseudo_palindromic_paths,
        public=[
            [[2, 3, 1, 3, 1, None, 1]],
            [[2, 1, 1, 1, 3, None, None, None, None, None, 1]],
            [[9]],
            [[1, 1]],
        ],
        hidden=[
            [[1, 2]],
            [[1, 1, 1]],
            [[1, 2, 3, 4, 5, 6, 7]],
            [[3, 3, 3]],
            [[1, 2, None, 1, None, 2]],
        ],
    ),
    make(
        pid=1824,
        title="好叶子节点对的数量",
        tags=["树", "深度优先搜索"],
        description="""给定一棵二叉树的根节点 root 和一个整数 distance
两个叶子节点称为好叶子节点对，当且仅当它们之间的最短路径长度不超过 distance
返回好叶子节点对的数量
叶子节点是没有子节点的节点""",
        function="countPairs",
        params=[("root", "TreeNode"), ("distance", "int")],
        returns="int",
        solver=count_pairs,
        public=[
            [[1, 2, 3, None, 4], 3],
            [[1, 2, 3, 4, 5, 6, 7], 3],
            [[7, 1, 4, 6, None, 5, 3, None, None, None, None, None, 2], 3],
        ],
        hidden=[
            [[1, 2, 3, 4, 5, 6, 7], 2],
            [[1, 2, 3], 1],
            [[1, 2], 1],
            [[1, 2, 3, 4, 5], 3],
            [[1, 2, 3, 4, None, None, 5], 4],
        ],
    ),
    make(
        pid=1825,
        title="奇偶树",
        tags=["树", "广度优先搜索"],
        description="""给定一棵二叉树的根节点 root
若满足以下条件则称为奇偶树
根节点所在层为第 0 层，偶数层所有节点值为奇数且从左到右严格递增
奇数层所有节点值为偶数且从左到右严格递减
判断这棵树是否为奇偶树""",
        function="isEvenOddTree",
        params=[("root", "TreeNode")],
        returns="bool",
        solver=is_even_odd_tree,
        public=[
            [[1, 10, 4, 3, None, 7, 9, 12, 8, 6, None, None, 2]],
            [[5, 4, 2, 3, 3, 7]],
            [[5, 9, 1, 3, 5, 7]],
            [[1]],
        ],
        hidden=[
            [[1, 4, 2, 3]],
            [[1, 2, 3]],
            [[2]],
            [[1, 10, 4, 3, None, 7, 9]],
            [[1, 8, 6, 2, 4, 10, 12]],
        ],
    ),
    make(
        pid=1826,
        title="阈值距离内邻居最少的城市",
        tags=["图", "最短路"],
        description="""有 n 个城市，编号 0 到 n-1
edges 中每条边 [u, v, w] 表示城市 u 与 v 之间有一条距离为 w 的双向边
给定距离阈值 distanceThreshold
统计每个城市在距离不超过阈值时能到达的其他城市数量
返回邻居数量最少的城市，若有多个并列则返回编号最大的城市""",
        function="findTheCity",
        params=[
            ("n", "int"),
            ("edges", "int[][]"),
            ("distanceThreshold", "int"),
        ],
        returns="int",
        solver=find_the_city,
        public=[
            [4, [[0, 1, 3], [1, 2, 1], [1, 3, 4], [2, 3, 1]], 4],
            [
                5,
                [
                    [0, 1, 2],
                    [0, 4, 8],
                    [1, 2, 3],
                    [1, 4, 2],
                    [2, 3, 1],
                    [3, 4, 1],
                ],
                2,
            ],
            [2, [[0, 1, 1]], 1],
        ],
        hidden=[
            [3, [], 1],
            [3, [[0, 1, 1], [1, 2, 1]], 1],
            [4, [[0, 1, 1], [1, 2, 1], [2, 3, 1]], 2],
            [4, [[0, 1, 1], [1, 2, 1], [2, 3, 1]], 3],
            [1, [], 0],
        ],
    ),
    make(
        pid=1827,
        title="课程表 IV",
        tags=["图", "传递闭包"],
        description="""有 numCourses 门课程，编号 0 到 numCourses-1
prerequisites 中每项 [a, b] 表示课程 a 是课程 b 的直接先修课
queries 中每项 [u, v] 询问课程 u 是否为课程 v 的先修课，直接或间接均可
返回与 queries 等长的数组，第 i 个元素为 1 表示成立，为 0 表示不成立，顺序与查询一致""",
        function="checkIfPrerequisite",
        params=[
            ("numCourses", "int"),
            ("prerequisites", "int[][]"),
            ("queries", "int[][]"),
        ],
        returns="int[]",
        solver=check_if_prerequisite,
        public=[
            [2, [[1, 0]], [[0, 1], [1, 0]]],
            [3, [[1, 2], [1, 0], [2, 0]], [[1, 0], [1, 2]]],
            [2, [], [[0, 1]]],
        ],
        hidden=[
            [4, [[0, 1], [1, 2], [2, 3]], [[0, 3], [3, 0], [0, 2]]],
            [3, [], [[0, 1], [1, 2], [2, 0]]],
            [5, [[0, 1], [2, 3]], [[0, 3], [1, 2], [3, 2]]],
            [4, [[3, 0], [0, 2], [2, 1]], [[3, 1], [1, 3], [3, 2]]],
            [1, [], [[0, 0]]],
        ],
    ),
    make(
        pid=1828,
        title="到达目的地的方案数",
        tags=["图", "最短路", "动态规划"],
        description="""有 n 个城市，编号 0 到 n-1
roads 中每条边 [u, v, w] 表示城市 u 与 v 之间有一条耗时为 w 的双向道路
从城市 0 出发前往城市 n-1，只沿最短路径移动
返回不同最短路径的数量，结果对 1e9+7 取余""",
        function="countPaths",
        params=[("n", "int"), ("roads", "int[][]")],
        returns="int",
        solver=count_paths,
        public=[
            [
                7,
                [
                    [0, 6, 7],
                    [0, 1, 2],
                    [1, 2, 3],
                    [2, 3, 3],
                    [5, 6, 2],
                    [0, 4, 3],
                    [4, 5, 1],
                    [3, 4, 1],
                ],
            ],
            [2, [[1, 0, 1]]],
            [3, [[0, 1, 1], [1, 2, 1], [0, 2, 2]]],
            [4, [[0, 1, 1], [0, 2, 1], [1, 3, 1], [2, 3, 1]]],
        ],
        hidden=[
            [1, []],
            [3, [[0, 1, 1], [1, 2, 1]]],
            [4, [[0, 1, 1], [1, 2, 1], [2, 3, 1], [0, 3, 5]]],
            [3, [[0, 2, 2], [0, 1, 1], [1, 2, 1]]],
            [5, [[0, 1, 1], [0, 2, 2], [1, 3, 1], [2, 3, 1], [3, 4, 1]]],
        ],
    ),
    make(
        pid=1829,
        title="可以到达所有点的最少点数目",
        tags=["图", "入度"],
        description="""给定一个有 n 个节点的有向无环图，节点编号 0 到 n-1
edges 中每项 [from, to] 表示一条从 from 指向 to 的有向边
选择最少的起点集合，使得从这些点出发可以到达图中所有节点
返回该集合中的节点编号，按升序排列""",
        function="findSmallestSetOfVertices",
        params=[("n", "int"), ("edges", "int[][]")],
        returns="int[]",
        solver=find_smallest_set_of_vertices,
        public=[
            [6, [[0, 1], [0, 2], [2, 5], [3, 4], [4, 2]]],
            [5, [[0, 1], [2, 1], [3, 1], [1, 4], [2, 4]]],
            [1, []],
        ],
        hidden=[
            [3, []],
            [2, [[0, 1]]],
            [4, [[0, 1], [1, 2], [2, 0], [2, 3]]],
            [5, [[0, 1], [0, 2], [0, 3], [0, 4]]],
            [3, [[1, 0], [2, 0]]],
        ],
    ),
    make(
        pid=1830,
        title="最大网络秩",
        tags=["图"],
        description="""有 n 个城市，编号 0 到 n-1
roads 中每项 [u, v] 表示城市 u 与 v 之间有一条双向道路，道路互不相同
两个不同城市的网络秩定义为与这两个城市直接相连的道路总数
若这两个城市之间有一条道路，该道路只计算一次
返回任意两个不同城市网络秩的最大值""",
        function="maximalNetworkRank",
        params=[("n", "int"), ("roads", "int[][]")],
        returns="int",
        solver=maximal_network_rank,
        public=[
            [4, [[0, 1], [0, 3], [1, 2], [1, 3]]],
            [5, [[0, 1], [0, 3], [1, 2], [1, 3], [2, 3], [2, 4]]],
            [2, [[0, 1]]],
            [3, []],
        ],
        hidden=[
            [2, []],
            [3, [[0, 1], [1, 2]]],
            [4, [[0, 1], [0, 2], [0, 3]]],
            [5, [[0, 1], [1, 2], [2, 3], [3, 4], [4, 0]]],
            [6, [[0, 1], [0, 2], [1, 2], [3, 4], [3, 5], [4, 5]]],
        ],
    ),
    make(
        pid=1831,
        title="寻找图中是否存在路径",
        tags=["图", "并查集", "广度优先搜索"],
        description="""有一个 n 个节点的双向图，节点编号 0 到 n-1
edges 中每项 [u, v] 表示节点 u 与 v 之间有一条边
给定起点 source 和终点 destination
判断是否存在从 source 到 destination 的路径""",
        function="validPath",
        params=[
            ("n", "int"),
            ("edges", "int[][]"),
            ("source", "int"),
            ("destination", "int"),
        ],
        returns="bool",
        solver=valid_path,
        public=[
            [3, [[0, 1], [1, 2], [2, 0]], 0, 2],
            [6, [[0, 1], [0, 2], [3, 5], [5, 4], [4, 3]], 0, 5],
            [1, [], 0, 0],
            [4, [[0, 1], [2, 3]], 1, 3],
        ],
        hidden=[
            [2, [], 0, 1],
            [5, [[0, 1], [1, 2], [3, 4]], 2, 4],
            [5, [[0, 1], [1, 2], [3, 4], [2, 3]], 0, 4],
            [4, [[0, 1], [2, 3], [1, 2]], 0, 3],
            [3, [[1, 2]], 0, 0],
        ],
    ),
    make(
        pid=1832,
        title="迷宫中离入口最近的出口",
        tags=["图", "广度优先搜索", "矩阵"],
        description="""给定一个 m x n 的迷宫 maze，字符 . 表示空地，+ 表示墙
入口位置为 entrance
每一步可以移动到上下左右相邻的空地
出口是位于迷宫边界上的空地，但入口本身不算出口
返回到达最近出口的最少步数，若无法到达任何出口则返回 -1""",
        function="nearestExit",
        params=[("maze", "string[][]"), ("entrance", "int[]")],
        returns="int",
        solver=nearest_exit,
        public=[
            [
                [
                    ["+", "+", ".", "+"],
                    [".", ".", ".", "+"],
                    ["+", "+", "+", "."],
                ],
                [1, 2],
            ],
            [
                [["+", "+", "+"], [".", ".", "."], ["+", "+", "+"]],
                [1, 0],
            ],
            [[[".", "+"]], [0, 0]],
        ],
        hidden=[
            [[["."]], [0, 0]],
            [[["+", ".", "+"]], [0, 1]],
            [
                [
                    ["+", ".", "+"],
                    [".", ".", "."],
                    ["+", ".", "+"],
                ],
                [1, 1],
            ],
            [
                [
                    ["+", "+", ".", "+"],
                    [".", ".", ".", "+"],
                    ["+", "+", "+", "."],
                ],
                [1, 0],
            ],
            [
                [
                    ["+", ".", "+", "+"],
                    [".", ".", ".", "."],
                    ["+", "+", "+", "."],
                ],
                [0, 1],
            ],
        ],
    ),
    make(
        pid=1833,
        title="跳跃游戏 VII",
        tags=["动态规划", "滑动窗口"],
        description="""给定一个下标从 0 开始的二进制字符串 s 和两个整数 minJump、maxJump
从下标 0 出发，当前在下标 i 时，可以跳到 [i+minJump, i+maxJump] 范围内任意满足 s[j] = 0 的下标 j
判断能否到达下标 n-1，其中 n 为字符串长度
注意 s[0] = 0""",
        function="canReach",
        params=[("s", "string"), ("minJump", "int"), ("maxJump", "int")],
        returns="bool",
        solver=can_reach,
        public=[
            ["011010", 2, 3],
            ["01101110", 2, 3],
            ["0", 1, 1],
        ],
        hidden=[
            ["0000", 1, 1],
            ["0", 1, 2],
            ["01", 1, 1],
            ["001", 1, 1],
            ["0100", 1, 2],
        ],
    ),
    make(
        pid=1834,
        title="统计子岛屿",
        tags=["图", "深度优先搜索", "矩阵"],
        description="""给定两个 m x n 的二进制矩阵 grid1 和 grid2
1 表示陆地，0 表示水域，四方向相邻的 1 组成岛屿
若 grid2 中的一座岛屿完全位于 grid1 的陆地之上，则称为子岛屿
返回 grid2 中子岛屿的数量""",
        function="countSubIslands",
        params=[("grid1", "int[][]"), ("grid2", "int[][]")],
        returns="int",
        solver=count_sub_islands,
        public=[
            [
                [
                    [1, 1, 1, 0, 0],
                    [0, 1, 1, 1, 1],
                    [0, 0, 0, 0, 0],
                    [1, 0, 0, 0, 0],
                    [1, 1, 0, 1, 1],
                ],
                [
                    [1, 1, 1, 0, 0],
                    [0, 0, 1, 1, 1],
                    [0, 1, 0, 0, 0],
                    [1, 0, 1, 1, 0],
                    [0, 1, 0, 1, 0],
                ],
            ],
            [
                [
                    [1, 0, 1, 0, 1],
                    [1, 1, 1, 1, 1],
                    [0, 0, 0, 0, 0],
                    [1, 1, 1, 1, 1],
                    [1, 0, 1, 0, 1],
                ],
                [
                    [0, 0, 0, 0, 0],
                    [1, 1, 1, 1, 1],
                    [0, 1, 0, 1, 0],
                    [0, 1, 0, 1, 0],
                    [1, 0, 0, 0, 1],
                ],
            ],
            [[[1, 1], [1, 1]], [[1, 1], [1, 0]]],
        ],
        hidden=[
            [[[1, 0], [0, 1]], [[1, 0], [0, 1]]],
            [[[1, 1], [1, 1]], [[1, 1], [1, 1]]],
            [[[0, 0], [0, 0]], [[1, 1], [1, 1]]],
            [[[1, 0], [1, 0]], [[1, 0], [1, 0]]],
            [
                [[1, 1, 1], [1, 1, 1], [1, 1, 1]],
                [[1, 0, 1], [0, 1, 0], [1, 0, 1]],
            ],
        ],
    ),
    make(
        pid=1835,
        title="近义词句子",
        tags=["并查集", "回溯", "字符串"],
        description="""给定近义词对数组 synonyms 和句子 text
synonyms 中每项 [a, b] 表示单词 a 与 b 互为近义词，近义词关系具有传递性
text 是由空格分隔的单词组成的句子
将句子中的每个单词替换为其所在近义词集合中的任意单词，得到所有可能句子
结果按字典序升序排列
不在任何近义词对中的单词保持不变""",
        function="generateSentences",
        params=[("synonyms", "string[][]"), ("text", "string")],
        returns="string[]",
        solver=generate_sentences,
        public=[
            [
                [["happy", "joy"], ["sad", "sorrow"], ["joy", "cheerful"]],
                "I am happy today but was sad yesterday",
            ],
            [[["a", "b"], ["c", "d"]], "a c"],
            [[], "hello world"],
        ],
        hidden=[
            [[["a", "b"]], "b"],
            [[["x", "y"]], "x y"],
            [[["a", "b"], ["b", "c"]], "a c"],
            [[["hello", "hi"]], "hello"],
            [[["a", "b"], ["c", "d"]], "a c a"],
        ],
    ),
    make(
        pid=1836,
        title="连通网络的操作次数",
        tags=["图", "并查集"],
        description="""有 n 台计算机，编号 0 到 n-1
connections 中每项 [u, v] 表示计算机 u 与 v 之间有一条网线
可以拔下任意一条网线，再连接到任意两台尚未直接相连的计算机上
返回使所有计算机连通所需的最少操作次数，若无法做到则返回 -1""",
        function="makeConnected",
        params=[("n", "int"), ("connections", "int[][]")],
        returns="int",
        solver=make_connected,
        public=[
            [4, [[0, 1], [0, 2], [1, 2]]],
            [6, [[0, 1], [0, 2], [0, 3], [1, 2], [1, 3]]],
            [6, [[0, 1], [0, 2], [0, 3], [1, 2]]],
            [1, []],
        ],
        hidden=[
            [2, [[0, 1]]],
            [3, [[0, 1]]],
            [5, [[0, 1], [1, 2], [2, 3], [3, 4]]],
            [5, [[0, 1], [1, 2], [3, 4], [4, 0]]],
            [4, [[0, 1], [2, 3], [1, 2]]],
        ],
    ),
    make(
        pid=1837,
        title="查找大小为 M 的最新分组",
        tags=["数组", "并查集"],
        description="""给定一个由 1 到 n 的整数组成的排列 arr 和一个整数 m
第 i 步（i 从 1 开始）将 arr[i-1] 对应的位置标记为 1，其余位置为 0
求最后一次出现长度为 m 的连续 1 分组时的步数
若从未出现则返回 -1""",
        function="findLatestStep",
        params=[("arr", "int[]"), ("m", "int")],
        returns="int",
        solver=find_latest_step,
        public=[
            [[3, 5, 1, 2, 4], 1],
            [[3, 1, 5, 4, 2], 2],
            [[1], 1],
        ],
        hidden=[
            [[2, 1], 1],
            [[1, 2], 1],
            [[1, 2, 3], 1],
            [[1, 2, 3], 3],
            [[2, 1, 3], 2],
        ],
    ),
    make(
        pid=1838,
        title="执行交换操作后的最小汉明距离",
        tags=["并查集", "哈希表"],
        description="""给定两个长度为 n 的整数数组 source 和 target
allowedSwaps 中每项 [u, v] 表示可以任意次交换 source[u] 与 source[v]
同一连通分量内的下标可以任意重排
在最优交换后，返回 source 与 target 的汉明距离，即对应位置元素不相等的下标数量""",
        function="minimumHammingDistance",
        params=[
            ("source", "int[]"),
            ("target", "int[]"),
            ("allowedSwaps", "int[][]"),
        ],
        returns="int",
        solver=minimum_hamming_distance,
        public=[
            [[1, 2, 3, 4], [2, 1, 4, 5], [[0, 1], [2, 3]]],
            [[1, 2, 3, 4], [2, 1, 4, 5], []],
            [[1, 2, 3, 4], [2, 1, 3, 4], [[0, 1]]],
        ],
        hidden=[
            [[1, 2], [2, 1], []],
            [[1, 2, 3], [3, 2, 1], [[0, 1], [1, 2]]],
            [[1, 2, 3, 4], [4, 3, 2, 1], [[0, 1], [2, 3]]],
            [[5, 1, 2, 4, 3], [1, 5, 4, 2, 3], [[0, 1], [2, 3], [4, 0]]],
            [[1, 2, 3], [2, 3, 1], [[0, 1]]],
        ],
    ),
    make(
        pid=1839,
        title="带阈值的图连通性",
        tags=["并查集", "数学"],
        description="""有 n 个城市，编号 1 到 n
若两个城市编号的最大公约数严格大于 threshold，则它们之间存在一条双向道路
给定多个查询 [u, v]，判断城市 u 与 v 是否连通
返回与 queries 等长的数组，第 i 个元素为 1 表示连通，为 0 表示不连通，顺序与查询一致""",
        function="areConnected",
        params=[
            ("n", "int"),
            ("threshold", "int"),
            ("queries", "int[][]"),
        ],
        returns="int[]",
        solver=are_connected,
        public=[
            [6, 2, [[1, 4], [2, 5], [3, 6]]],
            [6, 0, [[1, 4]]],
            [4, 1, [[1, 2], [2, 3], [3, 4]]],
        ],
        hidden=[
            [3, 1, [[1, 3], [2, 3]]],
            [10, 3, [[1, 5], [2, 6], [4, 8]]],
            [2, 0, [[1, 2]]],
            [5, 5, [[1, 2]]],
            [9, 2, [[3, 6], [6, 9], [1, 8]]],
        ],
    ),
    make(
        pid=1840,
        title="最长定差子序列",
        tags=["动态规划", "哈希表"],
        description="""给定一个整数数组 arr 和一个整数 difference
找出 arr 中最长的子序列，使得相邻元素之差恰好为 difference
返回该子序列的长度
子序列不要求连续""",
        function="longestSubsequence",
        params=[("arr", "int[]"), ("difference", "int")],
        returns="int",
        solver=longest_subsequence,
        public=[
            [[1, 2, 3, 4], 1],
            [[1, 3, 5, 7], 1],
            [[1, 5, 7, 8, 5, 3, 4, 2, 1], -2],
        ],
        hidden=[
            [[3, 4, -3, -2, -4], -1],
            [[1, 2, 3, 4, 5], 2],
            [[7, 7, 7], 0],
            [[4, 12, 10, 6, 8, 2, 10], 2],
            [[1, 2, 3, 4], -1],
        ],
    ),
    make(
        pid=1841,
        title="可被三整除的最大和",
        tags=["动态规划", "数组"],
        description="""给定一个整数数组 nums
从中选出一个子序列，使其元素之和尽可能大，且能被 3 整除
返回该最大和，若只能选空子序列则返回 0""",
        function="maxSumDivThree",
        params=[("nums", "int[]")],
        returns="int",
        solver=max_sum_div_three,
        public=[
            [[3, 6, 5, 1, 8]],
            [[4]],
            [[1, 2, 3, 4, 4]],
        ],
        hidden=[
            [[2, 2, 2, 2]],
            [[1, 2, 3]],
            [[4, 4, 4]],
            [[1, 1, 1, 1, 1]],
            [[2, 3, 5, 7]],
        ],
    ),
    make(
        pid=1842,
        title="下降路径最小和 II",
        tags=["动态规划", "矩阵"],
        description="""给定一个 n x n 的整数矩阵 grid
从第一行任意位置出发，每次移动到下一行，且列下标不能与上一行相同
路径经过的元素之和为得分
返回从第一行到最后一行的最小得分""",
        function="minFallingPathSum",
        params=[("grid", "int[][]")],
        returns="int",
        solver=min_falling_path_sum,
        public=[
            [[[1, 2, 3], [4, 5, 6], [7, 8, 9]]],
            [[[7]]],
            [[[1, 2], [3, 4]]],
        ],
        hidden=[
            [[[2, 1], [3, 4]]],
            [[[-1, -2, -3], [-4, -5, -6], [-7, -8, -9]]],
            [[[1]]],
            [[[5, 3], [4, 1]]],
            [[[2, 2, 2], [2, 2, 2]]],
        ],
    ),
    make(
        pid=1843,
        title="统计作战单位数",
        tags=["数组", "动态规划"],
        description="""有 n 名士兵排成一列，rating[i] 表示第 i 名士兵的评分
一个作战单位由三名士兵组成，下标为 i < j < k
若评分严格递增 rating[i] < rating[j] < rating[k]，或严格递减 rating[i] > rating[j] > rating[k]，则构成一个作战单位
返回作战单位的数量""",
        function="numTeams",
        params=[("rating", "int[]")],
        returns="int",
        solver=num_teams,
        public=[
            [[2, 5, 3, 4, 1]],
            [[2, 1, 3]],
            [[1, 2, 3, 4]],
        ],
        hidden=[
            [[4, 3, 2, 1]],
            [[1, 3, 2]],
            [[1, 2, 3, 5]],
            [[5, 4, 3, 2]],
            [[1, 2, 3, 4, 5]],
        ],
    ),
    make(
        pid=1844,
        title="可获得的最大点数",
        tags=["数组", "滑动窗口"],
        description="""给定一个整数数组 cardPoints 和一个整数 k
每次可以从数组最左端或最右端取走一张牌，一共取 k 次
返回能够获得的最大点数之和""",
        function="maxPointsFromCards",
        params=[("cardPoints", "int[]"), ("k", "int")],
        returns="int",
        solver=max_score,
        public=[
            [[1, 2, 3, 4, 5, 6, 1], 3],
            [[2, 2, 2], 2],
            [[9, 7, 7, 9, 7, 7, 9], 7],
        ],
        hidden=[
            [[1, 1000, 1], 1],
            [[1, 2, 3, 4, 5], 5],
            [[1, 2, 3, 4, 5], 4],
            [[100, 40, 17, 9, 73, 75], 3],
            [[1, 1, 1, 1, 1, 1, 1, 1], 4],
        ],
    ),
    make(
        pid=1845,
        title="形成两个异或相等数组的三元组数目",
        tags=["数组", "前缀异或"],
        description="""给定一个整数数组 arr
三元组 (i, j, k) 满足 i < j <= k
令 a = arr[i] ^ arr[i+1] ^ ... ^ arr[j-1]
令 b = arr[j] ^ arr[j+1] ^ ... ^ arr[k]
若 a == b 则称该三元组有效，其中 ^ 表示按位异或
返回有效三元组的数量""",
        function="countTriplets",
        params=[("arr", "int[]")],
        returns="int",
        solver=count_triplets,
        public=[
            [[2, 3, 1, 6, 7]],
            [[1, 1, 1]],
            [[1, 2, 3]],
        ],
        hidden=[
            [[2, 3]],
            [[1, 1, 1, 1]],
            [[7, 7, 7]],
            [[1, 2, 3, 4]],
            [[0, 0, 0]],
        ],
    ),
    make(
        pid=1846,
        title="统计全 1 子矩形",
        tags=["矩阵", "单调栈", "动态规划"],
        description="""给定一个 m x n 的二进制矩阵 mat
统计其中所有元素均为 1 的子矩形的数量
子矩形由连续的行区间和连续的列区间确定""",
        function="numSubmat",
        params=[("mat", "int[][]")],
        returns="int",
        solver=num_submat,
        public=[
            [[[1, 0, 1], [1, 1, 0], [1, 1, 0]]],
            [[[1, 1], [1, 1]]],
            [[[1]]],
            [[[0]]],
        ],
        hidden=[
            [[[1, 1, 1], [1, 1, 1]]],
            [[[0, 1], [1, 0]]],
            [[[1, 0], [0, 1]]],
            [[[1, 1, 0], [1, 1, 1], [0, 1, 1]]],
            [[[1, 1, 1], [1, 0, 1], [1, 1, 1]]],
        ],
    ),
    make(
        pid=1847,
        title="乘积为正数的最长子数组长度",
        tags=["数组", "动态规划"],
        description="""给定一个整数数组 nums
找出乘积为正数的最长连续子数组的长度
若不存在乘积为正数的非空子数组则返回 0""",
        function="getMaxLen",
        params=[("nums", "int[]")],
        returns="int",
        solver=get_max_len,
        public=[
            [[1, -2, -3, 4]],
            [[0, 1, -2, -3, -4]],
            [[-1, -2, -3, 0, 1]],
        ],
        hidden=[
            [[-1, 2]],
            [[1, 2, 3]],
            [[-1]],
            [[-1, -2]],
            [[2, -1, -2, -3, 4]],
        ],
    ),
    make(
        pid=1848,
        title="无矛盾的最佳球队",
        tags=["数组", "动态规划", "排序"],
        description="""给定两个整数数组 scores 和 ages，第 i 名球员的得分为 scores[i]，年龄为 ages[i]
选出一些球员组成球队，若对于球队中任意两名球员，年龄较大者的得分不低于年龄较小者，则球队无矛盾
返回无矛盾球队中得分总和的最大值
年龄相同的球员之间不产生矛盾""",
        function="bestTeamScore",
        params=[("scores", "int[]"), ("ages", "int[]")],
        returns="int",
        solver=best_team_score,
        public=[
            [[1, 3, 5, 10, 15], [1, 2, 3, 4, 5]],
            [[4, 5, 6, 5], [2, 1, 2, 1]],
            [[1, 2, 3, 5], [8, 9, 10, 1]],
        ],
        hidden=[
            [[1], [1]],
            [[5, 5], [10, 10]],
            [[1, 2], [1, 2]],
            [[2, 3], [2, 1]],
            [[1, 1, 1], [3, 2, 1]],
        ],
    ),
    make(
        pid=1849,
        title="使数组和能被 P 整除",
        tags=["数组", "前缀和", "哈希表"],
        description="""给定一个正整数数组 nums 和一个正整数 p
删除一个连续子数组，使剩余元素之和能被 p 整除
返回需要删除的最短子数组长度，若无法做到则返回 -1
不能删除整个数组""",
        function="minSubarray",
        params=[("nums", "int[]"), ("p", "int")],
        returns="int",
        solver=min_subarray,
        public=[
            [[3, 1, 4, 2], 6],
            [[6, 3, 5, 2], 9],
            [[1, 2, 3], 3],
        ],
        hidden=[
            [[1, 2, 3], 7],
            [[1000000000, 1000000000, 1000000000], 3],
            [[4, 5, 6], 5],
            [[7, 3, 9, 4], 7],
            [[1, 2, 3, 4], 5],
        ],
    ),
    make(
        pid=1850,
        title="矩阵的最大非负积",
        tags=["矩阵", "动态规划"],
        description="""给定一个 m x n 的整数矩阵 grid
从左上角出发，每次只能向右或向下移动，到达右下角
路径上所有元素之积为路径积
返回所有路径积中的最大值，若最大值为负数则返回 -1
结果对 1e9+7 取余""",
        function="maxProductPath",
        params=[("grid", "int[][]")],
        returns="int",
        solver=max_product_path,
        public=[
            [[[-1, -2, -3], [-2, -3, -3], [-3, -3, -2]]],
            [[[1, -2, 1], [1, -2, 1], [3, -4, 1]]],
            [[[2, 3], [4, 5]]],
        ],
        hidden=[
            [[[1, -2, 3]]],
            [[[1, 2], [3, 4]]],
            [[[-1, 2], [-3, -4]]],
            [[[0, 2], [3, 4]]],
            [[[1, -1, 1], [1, -1, 1]]],
        ],
    ),
    make(
        pid=1851,
        title="到家的最少跳跃次数",
        tags=["图", "广度优先搜索"],
        description="""有一条数轴，从位置 0 出发，家在位置 x
每次可以向前跳 a 个单位，或向后跳 b 个单位
不能落在 forbidden 中的位置，也不能跳到负数位置
不能连续两次向后跳
返回到家的最少跳跃次数，若无法到家则返回 -1""",
        function="minimumJumps",
        params=[
            ("forbidden", "int[]"),
            ("a", "int"),
            ("b", "int"),
            ("x", "int"),
        ],
        returns="int",
        solver=minimum_jumps,
        public=[
            [[14, 4, 18, 1, 15], 3, 15, 9],
            [[8, 3, 16, 6, 12, 20], 15, 13, 11],
            [[1, 6, 2, 14, 5, 17, 4], 16, 9, 7],
        ],
        hidden=[
            [[1, 2, 3], 1, 1, 4],
            [[], 1, 1, 1],
            [[], 1, 1, 0],
            [[], 2, 1, 3],
            [[], 1, 2, 3],
        ],
    ),
    make(
        pid=1852,
        title="删除子字符串的最大得分",
        tags=["字符串", "贪心", "栈"],
        description="""给定一个只包含字符 a 和 b 的字符串 s，以及两个整数 x 和 y
删除一个子字符串 ab 可以获得 x 分
删除一个子字符串 ba 可以获得 y 分
可以任意顺序反复删除，返回能够获得的最大得分""",
        function="maximumGain",
        params=[("s", "string"), ("x", "int"), ("y", "int")],
        returns="int",
        solver=maximum_gain,
        public=[
            ["cdbcbbaaabab", 4, 5],
            ["aabbaaxybbaabb", 5, 4],
            ["ab", 2, 3],
        ],
        hidden=[
            ["ba", 2, 3],
            ["aabb", 3, 2],
            ["cd", 5, 5],
            ["abba", 1, 1],
            ["bbaa", 4, 3],
        ],
    ),
    make(
        pid=1853,
        title="地图中的最高点",
        tags=["图", "广度优先搜索", "矩阵"],
        description="""给定一个 m x n 的二进制矩阵 isWater
isWater[i][j] = 1 表示该位置是水域，必须高度为 0
isWater[i][j] = 0 表示该位置是陆地，高度必须为正整数
任意两个相邻格子的高度差不能超过 1
返回一个满足条件的最高高度分布矩阵，保证至少有一个水域""",
        function="highestPeak",
        params=[("isWater", "int[][]")],
        returns="int[][]",
        solver=highest_peak,
        public=[
            [[[0, 1], [0, 0]]],
            [[[0, 0, 1], [1, 0, 0], [0, 0, 0]]],
            [[[1]]],
        ],
        hidden=[
            [[[1, 1], [1, 1]]],
            [[[0, 1, 0]]],
            [[[1, 0], [0, 1]]],
            [[[0, 0, 1], [0, 0, 0], [0, 0, 0]]],
            [[[0, 0, 0], [0, 0, 0], [0, 0, 1]]],
        ],
    ),
    make(
        pid=1854,
        title="最接近目标价格的甜点成本",
        tags=["回溯", "数组"],
        description="""给定基料成本数组 baseCosts，配料成本数组 toppingCosts，以及目标价格 target
必须选择一种基料，每种配料最多选择两份
甜点成本为基料成本加上所选配料成本
返回最接近 target 的成本，若距离相同则返回成本较低者""",
        function="closestCost",
        params=[
            ("baseCosts", "int[]"),
            ("toppingCosts", "int[]"),
            ("target", "int"),
        ],
        returns="int",
        solver=closest_cost,
        public=[
            [[1, 7], [3, 4], 10],
            [[2, 3], [4, 5, 100], 18],
            [[3, 10], [2, 5], 9],
        ],
        hidden=[
            [[10], [1], 1],
            [[4, 5], [1, 2], 10],
            [[1], [1], 1],
            [[2, 3], [1], 5],
            [[5, 8], [3, 4], 10],
        ],
    ),
    make(
        pid=1855,
        title="找出不同的二进制字符串",
        tags=["字符串", "回溯"],
        description="""给定 n 个互不相同的长度为 n 的二进制字符串 nums
返回一个长度为 n 且不在 nums 中出现的二进制字符串
为保证结果唯一，按下述方式构造：结果第 i 个字符等于 nums[i] 第 i 个字符取反，i 从 0 开始""",
        function="findDifferentBinaryString",
        params=[("nums", "string[]")],
        returns="string",
        solver=find_different_binary_string,
        public=[
            [["01", "10"]],
            [["00", "01"]],
            [["111", "011", "001"]],
        ],
        hidden=[
            [["0"]],
            [["11", "10"]],
            [["000", "011", "101"]],
            [["0000", "0001", "0010", "0011"]],
            [["1"]],
        ],
    ),
    make(
        pid=1856,
        title="最少侧跳次数",
        tags=["动态规划", "数组"],
        description="""有一条长度为 n 的跑道，分为三条车道，编号 1 到 3
obstacles[i] 表示第 i 个位置被障碍物占据的车道，0 表示没有障碍物
从位置 0 的车道 2 出发，只能向前移动，遇到障碍物时可侧跳到其他车道
侧跳一次算作一步，不能跳到有障碍物的车道
返回到达最后一个位置的最少侧跳次数""",
        function="minSideJumps",
        params=[("obstacles", "int[]")],
        returns="int",
        solver=min_side_jumps,
        public=[
            [[0, 1, 2, 3, 0]],
            [[0, 1, 1, 3, 3, 0]],
            [[0, 2, 1, 0, 3, 0]],
        ],
        hidden=[
            [[0]],
            [[0, 2, 0]],
            [[0, 1, 0]],
            [[0, 2, 3, 1, 0]],
            [[0, 1, 1, 2, 2, 0]],
        ],
    ),
    make(
        pid=1857,
        title="扣分后的最大得分",
        tags=["动态规划", "矩阵"],
        description="""给定一个 m x n 的整数矩阵 points
从每一行恰好选择一个格子，第 r 行选择的列记为 c_r
得分为所有选中格子的值之和，减去相邻两行所选列下标之差的绝对值之和
返回能够获得的最大得分
数据保证结果在 64 位整数范围内""",
        function="maxPoints",
        params=[("points", "int[][]")],
        returns="long",
        solver=max_points,
        public=[
            [[[1, 2, 3], [1, 5, 1], [3, 1, 1]]],
            [[[1, 5], [2, 3], [4, 2]]],
            [[[1, 2], [3, 4]]],
        ],
        hidden=[
            [[[5]]],
            [[[1, 1], [1, 1]]],
            [[[0, 0], [0, 0]]],
            [[[1, 2, 3, 4]]],
            [[[4, 3, 2, 1], [1, 2, 3, 4]]],
        ],
    ),
    make(
        pid=1858,
        title="找到所有的农场组",
        tags=["图", "深度优先搜索", "矩阵"],
        description="""给定一个 m x n 的二进制矩阵 land
1 表示农田，0 表示荒地，农场组是由 1 组成的矩形区域，且不同农场组互不接触
返回所有农场组，每组表示为 [左上角行, 左上角列, 右下角行, 右下角列]
结果按左上角先行后列的顺序升序排列""",
        function="findFarmland",
        params=[("land", "int[][]")],
        returns="int[][]",
        solver=find_farmland,
        public=[
            [[[1, 0, 0], [0, 1, 1], [0, 1, 1]]],
            [[[1, 1], [1, 1]]],
            [[[0]]],
        ],
        hidden=[
            [[[1, 1, 0, 0], [0, 0, 1, 1]]],
            [[[0, 0], [0, 0]]],
            [[[1, 1, 0], [1, 1, 0], [0, 0, 1]]],
            [[[1, 0, 1], [1, 0, 1], [0, 0, 0]]],
            [[[1, 1], [1, 1], [1, 1]]],
        ],
    ),
    make(
        pid=1859,
        title="找到二叉树中的距离",
        tags=["树", "深度优先搜索"],
        description="""给定一棵二叉树的根节点 root，以及树中两个不同节点的值 p 和 q
返回值为 p 的节点与值为 q 的节点之间的最短路径边数
树中节点值互不相同，且 p、q 均存在""",
        function="findDistance",
        params=[("root", "TreeNode"), ("p", "int"), ("q", "int")],
        returns="int",
        solver=find_distance,
        public=[
            [
                [3, 5, 1, 6, 2, 0, 8, None, None, 7, 4],
                5,
                0,
            ],
            [
                [3, 5, 1, 6, 2, 0, 8, None, None, 7, 4],
                5,
                7,
            ],
            [
                [3, 5, 1, 6, 2, 0, 8, None, None, 7, 4],
                5,
                4,
            ],
        ],
        hidden=[
            [[1], 1, 1],
            [[1, 2], 1, 2],
            [[1, 2, 3], 2, 3],
            [[1, 2, 3, 4, 5], 4, 5],
            [[1, 2, 3, 4, 5], 4, 3],
        ],
    ),
]
