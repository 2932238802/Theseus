"""2060-2079：批量第四批困难题（20 道）。"""

from __future__ import annotations

import bisect
import heapq
from collections import deque
from functools import partial

from problem_seed_common import make_problem

make = partial(make_problem, difficulty="hard")


# ── 栈与贪心 ──────────────────────────────────────────────────────


def smallest_k_subsequence(s: str, k: int, letter: str, repetition: int) -> str:
    n = len(s)
    nxt = [[n] * 26 for _ in range(n + 1)]
    for i in range(n - 1, -1, -1):
        nxt[i] = nxt[i + 1][:]
        nxt[i][ord(s[i]) - 97] = i
    suffix_letter = [0] * (n + 1)
    for i in range(n - 1, -1, -1):
        suffix_letter[i] = suffix_letter[i + 1] + (1 if s[i] == letter else 0)
    result: list[str] = []
    start = 0
    need = repetition
    for position in range(k):
        slots_after = k - position - 1
        for code in range(26):
            index = nxt[start][code] if start <= n else n
            if index >= n:
                continue
            if n - 1 - index < slots_after:
                continue
            character = chr(ord("a") + code)
            remaining_need = need - (1 if character == letter else 0)
            if remaining_need < 0:
                remaining_need = 0
            if suffix_letter[index + 1] < remaining_need or remaining_need > slots_after:
                continue
            result.append(character)
            start = index + 1
            need = remaining_need
            break
    return "".join(result)


def total_strength_wizards(strength: list[int]) -> int:
    n = len(strength)
    left = [-1] * n
    stack: list[int] = []
    for i, value in enumerate(strength):
        while stack and strength[stack[-1]] >= value:
            stack.pop()
        left[i] = stack[-1] if stack else -1
        stack.append(i)
    right = [n] * n
    stack = []
    for i in range(n - 1, -1, -1):
        value = strength[i]
        while stack and strength[stack[-1]] > value:
            stack.pop()
        right[i] = stack[-1] if stack else n
        stack.append(i)
    prefix = [0] * (n + 1)
    for i, value in enumerate(strength):
        prefix[i + 1] = prefix[i] + value
    double_prefix = [0] * (n + 2)
    for i in range(1, n + 2):
        double_prefix[i] = double_prefix[i - 1] + prefix[i - 1]
    answer = 0
    MOD = 1_000_000_007
    for i, value in enumerate(strength):
        low = left[i]
        high = right[i]
        sum_right = double_prefix[high + 1] - double_prefix[i + 1]
        sum_left = double_prefix[i + 1] - double_prefix[low + 1]
        total = (i - low) * sum_right - (high - i) * sum_left
        answer = (answer + value % MOD * (total % MOD)) % MOD
    return answer


def total_steps_non_decreasing(nums: list[int]) -> int:
    stack: list[tuple[int, int]] = []
    answer = 0
    for value in nums:
        carried = 0
        while stack and stack[-1][0] < value:
            if stack[-1][1] > carried:
                carried = stack[-1][1]
            stack.pop()
        if not stack:
            rounds = 0
        elif stack[-1][0] > value:
            rounds = carried + 1
        else:
            rounds = 0 if stack[-1][1] == 0 else max(carried, stack[-1][1]) + 1
        stack.append((value, rounds))
        if rounds > answer:
            answer = rounds
    return answer


# ── 动态规划与字符串 ──────────────────────────────────────────────


def total_appeal(s: str) -> int:
    last = [-1] * 26
    n = len(s)
    answer = 0
    for i, character in enumerate(s):
        code = ord(character) - 97
        answer += (i - last[code]) * (n - i)
        last[code] = i
    return answer


def largest_variance_substring(s: str) -> int:
    characters = sorted(set(s))
    n = len(s)
    answer = 0
    for major in characters:
        for minor in characters:
            if major == minor:
                continue
            prefix = [0] * (n + 1)
            difference = 0
            for i, character in enumerate(s):
                if character == major:
                    difference += 1
                elif character == minor:
                    difference -= 1
                prefix[i + 1] = difference
            last_major = -1
            last_minor = -1
            minimum_prefix = 0
            added = 0
            for i, character in enumerate(s):
                if character == major:
                    last_major = i
                elif character == minor:
                    last_minor = i
                if last_major >= 0 and last_minor >= 0:
                    boundary = min(last_major, last_minor)
                    while added <= boundary:
                        if prefix[added] < minimum_prefix:
                            minimum_prefix = prefix[added]
                        added += 1
                    candidate = prefix[i + 1] - minimum_prefix
                    if candidate > answer:
                        answer = candidate
    return answer


def min_moves_to_palindrome(s: str) -> int:
    characters = list(s)
    left, right = 0, len(characters) - 1
    moves = 0
    while left < right:
        if characters[left] == characters[right]:
            left += 1
            right -= 1
        else:
            match = right
            while match > left and characters[match] != characters[left]:
                match -= 1
            if match == left:
                characters[left], characters[left + 1] = (
                    characters[left + 1],
                    characters[left],
                )
                moves += 1
            else:
                while match < right:
                    characters[match], characters[match + 1] = (
                        characters[match + 1],
                        characters[match],
                    )
                    match += 1
                    moves += 1
                left += 1
                right -= 1
    return moves


# ── 二分与堆 ──────────────────────────────────────────────────────


def k_increasing_min_ops(arr: list[int], k: int) -> int:
    n = len(arr)
    answer = 0
    for residue in range(k):
        tails: list[int] = []
        length = 0
        for index in range(residue, n, k):
            value = arr[index]
            length += 1
            position = bisect.bisect_right(tails, value)
            if position == len(tails):
                tails.append(value)
            else:
                tails[position] = value
        answer += length - len(tails)
    return answer


def max_tasks_assigned(
    tasks: list[int], workers: list[int], pills: int, strength: int
) -> int:
    tasks = sorted(tasks)
    workers = sorted(workers)

    def feasible(count: int) -> bool:
        if count == 0:
            return True
        available = workers[len(workers) - count :]
        remaining_pills = pills
        for task in reversed(tasks[:count]):
            if available[-1] >= task:
                available.pop()
            elif remaining_pills and available[-1] + strength >= task:
                index = bisect.bisect_left(available, task - strength)
                if index >= len(available):
                    return False
                available.pop(index)
                remaining_pills -= 1
            else:
                return False
        return True

    low, high = 0, min(len(tasks), len(workers))
    while low < high:
        middle = (low + high + 1) // 2
        if feasible(middle):
            low = middle
        else:
            high = middle - 1
    return low


def max_run_time(n: int, batteries: list[int]) -> int:
    low, high = 0, sum(batteries) // n
    while low < high:
        middle = (low + high + 1) // 2
        if sum(min(battery, middle) for battery in batteries) >= n * middle:
            low = middle
        else:
            high = middle - 1
    return low


def minimum_difference_after_removal(nums: list[int]) -> int:
    n = len(nums)
    part = n // 3
    prefix = [0] * (2 * part + 1)
    heap: list[int] = []
    total = 0
    for i in range(2 * part):
        heapq.heappush(heap, -nums[i])
        total += nums[i]
        if len(heap) > part:
            total += heapq.heappop(heap)
        if i >= part - 1:
            prefix[i + 1] = total
    suffix = [0] * (n + 1)
    heap = []
    total = 0
    for i in range(n - 1, part - 1, -1):
        heapq.heappush(heap, nums[i])
        total += nums[i]
        if len(heap) > part:
            total -= heapq.heappop(heap)
        if i <= 2 * part:
            suffix[i] = total
    answer = 10**30
    for split in range(part, 2 * part + 1):
        answer = min(answer, prefix[split] - suffix[split])
    return answer


# ── 图与树 ────────────────────────────────────────────────────────


def maximum_employees_invited(favorite: list[int]) -> int:
    n = len(favorite)
    indegree = [0] * n
    for target in favorite:
        indegree[target] += 1
    depth = [1] * n
    queue = deque(index for index in range(n) if indegree[index] == 0)
    while queue:
        node = queue.popleft()
        target = favorite[node]
        if depth[node] + 1 > depth[target]:
            depth[target] = depth[node] + 1
        indegree[target] -= 1
        if indegree[target] == 0:
            queue.append(target)
    visited = [False] * n
    best_cycle = 0
    pair_total = 0
    for start in range(n):
        if visited[start] or indegree[start] == 0:
            continue
        cycle: list[int] = []
        node = start
        while not visited[node]:
            visited[node] = True
            cycle.append(node)
            node = favorite[node]
        if len(cycle) == 2:
            pair_total += depth[cycle[0]] + depth[cycle[1]]
        else:
            best_cycle = max(best_cycle, len(cycle))
    return max(best_cycle, pair_total)


def minimum_weighted_subgraph(
    n: int,
    edges: list[list[int]],
    src1: int,
    src2: int,
    dest: int,
) -> int:
    adjacency: list[list[tuple[int, int]]] = [[] for _ in range(n)]
    reverse: list[list[tuple[int, int]]] = [[] for _ in range(n)]
    for u, v, weight in edges:
        adjacency[u].append((v, weight))
        reverse[v].append((u, weight))

    def dijkstra(source: int, graph: list[list[tuple[int, int]]]) -> list[float]:
        distance = [float("inf")] * n
        distance[source] = 0
        heap: list[tuple[int, int]] = [(0, source)]
        while heap:
            current, node = heapq.heappop(heap)
            if current != distance[node]:
                continue
            for neighbor, weight in graph[node]:
                candidate = current + weight
                if candidate < distance[neighbor]:
                    distance[neighbor] = candidate
                    heapq.heappush(heap, (candidate, neighbor))
        return distance

    from_first = dijkstra(src1, adjacency)
    from_second = dijkstra(src2, adjacency)
    to_dest = dijkstra(dest, reverse)
    answer = float("inf")
    for node in range(n):
        if (
            from_first[node] < float("inf")
            and from_second[node] < float("inf")
            and to_dest[node] < float("inf")
        ):
            candidate = from_first[node] + from_second[node] + to_dest[node]
            if candidate < answer:
                answer = candidate
    return -1 if answer == float("inf") else int(answer)


def longest_path_different_chars(parent: list[int], s: str) -> int:
    n = len(parent)
    children: list[list[int]] = [[] for _ in range(n)]
    for node in range(1, n):
        children[parent[node]].append(node)
    order: list[int] = []
    stack = [0]
    while stack:
        node = stack.pop()
        order.append(node)
        stack.extend(children[node])
    downward = [1] * n
    answer = 1
    for node in reversed(order):
        best = 0
        second = 0
        for child in children[node]:
            if s[child] != s[node]:
                value = downward[child]
                if value > best:
                    second = best
                    best = value
                elif value > second:
                    second = value
        downward[node] = 1 + best
        answer = max(answer, 1 + best + second)
    return answer


def minimum_obstacles(grid: list[list[int]]) -> int:
    rows = len(grid)
    columns = len(grid[0])
    infinity = 10**9
    distance = [[infinity] * columns for _ in range(rows)]
    distance[0][0] = 0
    queue = deque([(0, 0)])
    while queue:
        row, column = queue.popleft()
        for drow, dcolumn in ((1, 0), (-1, 0), (0, 1), (0, -1)):
            next_row = row + drow
            next_column = column + dcolumn
            if 0 <= next_row < rows and 0 <= next_column < columns:
                cost = grid[next_row][next_column]
                candidate = distance[row][column] + cost
                if candidate < distance[next_row][next_column]:
                    distance[next_row][next_column] = candidate
                    if cost == 0:
                        queue.appendleft((next_row, next_column))
                    else:
                        queue.append((next_row, next_column))
    return distance[rows - 1][columns - 1]


def max_points_from_grid_queries(
    grid: list[list[int]], queries: list[int]
) -> list[int]:
    rows = len(grid)
    columns = len(grid[0])
    order = sorted(range(len(queries)), key=lambda index: queries[index])
    answer = [0] * len(queries)
    visited = [[False] * columns for _ in range(rows)]
    visited[0][0] = True
    heap: list[tuple[int, int, int]] = [(grid[0][0], 0, 0)]
    collected = 0
    for query_index in order:
        limit = queries[query_index]
        while heap and heap[0][0] < limit:
            _, row, column = heapq.heappop(heap)
            collected += 1
            for drow, dcolumn in ((1, 0), (-1, 0), (0, 1), (0, -1)):
                next_row = row + drow
                next_column = column + dcolumn
                if (
                    0 <= next_row < rows
                    and 0 <= next_column < columns
                    and not visited[next_row][next_column]
                ):
                    visited[next_row][next_column] = True
                    heapq.heappush(
                        heap,
                        (grid[next_row][next_column], next_row, next_column),
                    )
        answer[query_index] = collected
    return answer


def maximum_segment_sum_after_removals(
    nums: list[int], remove_queries: list[int]
) -> list[int]:
    n = len(nums)
    parent = [-1] * n
    total = [0] * n
    active = [False] * n

    def find(node: int) -> int:
        while parent[node] != node:
            parent[node] = parent[parent[node]]
            node = parent[node]
        return node

    answer = [0] * n
    current_best = 0
    for step in range(n - 1, 0, -1):
        index = remove_queries[step]
        active[index] = True
        parent[index] = index
        total[index] = nums[index]
        current_best = max(current_best, nums[index])
        for neighbor in (index - 1, index + 1):
            if 0 <= neighbor < n and active[neighbor]:
                root_a = find(index)
                root_b = find(neighbor)
                if root_a != root_b:
                    parent[root_b] = root_a
                    total[root_a] += total[root_b]
                    current_best = max(current_best, total[root_a])
        answer[step - 1] = current_best
    return answer


def count_good_paths(vals: list[int], edges: list[list[int]]) -> int:
    n = len(vals)
    parent = list(range(n))
    rank = [0] * n

    def find(node: int) -> int:
        while parent[node] != node:
            parent[node] = parent[parent[node]]
            node = parent[node]
        return node

    def union(first: int, second: int) -> None:
        root_a = find(first)
        root_b = find(second)
        if root_a == root_b:
            return
        if rank[root_a] < rank[root_b]:
            root_a, root_b = root_b, root_a
        parent[root_b] = root_a
        if rank[root_a] == rank[root_b]:
            rank[root_a] += 1

    adjacency: list[list[int]] = [[] for _ in range(n)]
    for u, v in edges:
        adjacency[u].append(v)
        adjacency[v].append(u)
    order = sorted(range(n), key=lambda node: vals[node])
    answer = n
    index = 0
    while index < n:
        end = index
        value = vals[order[index]]
        while end < n and vals[order[end]] == value:
            end += 1
        group = order[index:end]
        for node in group:
            for neighbor in adjacency[node]:
                if vals[neighbor] <= value:
                    union(node, neighbor)
        counts: dict[int, int] = {}
        for node in group:
            root = find(node)
            counts[root] = counts.get(root, 0) + 1
        for count in counts.values():
            answer += count * (count - 1) // 2
        index = end
    return answer


# ── 哈希、线段树、字典树 ──────────────────────────────────────────


def distinct_company_names(ideas: list[str]) -> int:
    groups: dict[str, set[str]] = {}
    for word in ideas:
        groups.setdefault(word[0], set()).add(word[1:])
    letters = list(groups)
    answer = 0
    for i in range(len(letters)):
        for j in range(i + 1, len(letters)):
            first = groups[letters[i]]
            second = groups[letters[j]]
            answer += 2 * len(first - second) * len(second - first)
    return answer


def longest_increasing_subsequence_k(nums: list[int], k: int) -> int:
    if not nums:
        return 0
    maximum = max(nums)
    size = 1
    while size < maximum + 2:
        size *= 2
    tree = [0] * (2 * size)

    def update(position: int, value: int) -> None:
        position += size
        if value <= tree[position]:
            return
        tree[position] = value
        position //= 2
        while position:
            new_value = max(tree[2 * position], tree[2 * position + 1])
            if tree[position] == new_value:
                break
            tree[position] = new_value
            position //= 2

    def query(left: int, right: int) -> int:
        left += size
        right += size
        result = 0
        while left <= right:
            if left & 1:
                result = max(result, tree[left])
                left += 1
            if not (right & 1):
                result = max(result, tree[right])
                right -= 1
            left //= 2
            right //= 2
        return result

    answer = 1
    for value in nums:
        low = max(1, value - k)
        high = value - 1
        current = 1 if high < low else query(low, high) + 1
        update(value, current)
        answer = max(answer, current)
    return answer


def sum_prefix_scores(words: list[str]) -> list[int]:
    trie: dict = {}
    for word in words:
        node = trie
        for character in word:
            if character not in node:
                node[character] = {}
            node = node[character]
            node["#"] = node.get("#", 0) + 1
    answer: list[int] = []
    for word in words:
        node = trie
        total = 0
        for character in word:
            node = node[character]
            total += node["#"]
        answer.append(total)
    return answer


PROBLEMS = [
    make(
        pid=2060,
        title="含指定字母的字典序最小 K 长子序列",
        tags=["字符串", "栈", "贪心"],
        description="""给定字符串 s、整数 k、字符 letter 与整数 repetition
从 s 中选出一个长度为 k 的子序列
要求子序列中 letter 至少出现 repetition 次
返回满足条件的字典序最小的子序列
保证至少存在一个满足条件的子序列
子序列指从 s 中删除若干字符（也可以不删除）后保持相对顺序得到的字符串""",
        function="smallestKLengthSubsequence",
        params=[
            ("s", "string"),
            ("k", "int"),
            ("letter", "string"),
            ("repetition", "int"),
        ],
        returns="string",
        solver=smallest_k_subsequence,
        public=[
            ["leet", 3, "e", 1],
            ["leetcode", 4, "e", 2],
            ["aaabbbcccddd", 6, "d", 3],
            ["abc", 3, "a", 1],
        ],
        hidden=[
            ["zxcvbnm", 4, "z", 1],
            ["aaaa", 2, "a", 2],
            ["bbbb", 2, "b", 1],
            ["abcd", 1, "c", 1],
            ["bacab", 3, "a", 2],
            ["topcoder", 5, "o", 2],
        ],
    ),
    make(
        pid=2061,
        title="最多可以完成的任务数",
        tags=["数组", "二分查找", "贪心", "排序"],
        description="""有若干任务与若干工人
第 i 个任务需要 tasks[i] 点体力才能完成
第 j 个工人的体力为 workers[j]
每个工人最多完成一个任务，每个任务最多由一个工人完成
另有 pills 颗药丸，每颗药丸可以让一名工人在本次任务中增加 strength 点体力
每名工人最多使用一颗药丸
返回最多可以完成的任务数""",
        function="maxTasksAssigned",
        params=[
            ("tasks", "int[]"),
            ("workers", "int[]"),
            ("pills", "int"),
            ("strength", "int"),
        ],
        returns="int",
        solver=max_tasks_assigned,
        public=[
            [[3, 2, 1], [0, 3, 3], 1, 1],
            [[5, 4, 4], [4, 4, 4], 1, 5],
            [[10, 15, 30], [3, 7, 12], 1, 10],
            [[1, 2, 3], [1, 2, 3], 0, 1],
        ],
        hidden=[
            [[10, 10, 10], [5, 5, 5], 1, 5],
            [[1, 1, 1], [1, 1, 1], 1, 1],
            [[5, 9, 8, 7], [4, 8, 6], 2, 3],
            [[100], [1, 2, 3], 2, 99],
            [[2, 3, 4, 5], [1, 2, 3, 4], 2, 1],
            [[6, 6, 6, 6], [2, 2, 2, 6], 3, 4],
        ],
        time_limit=2000,
    ),
    make(
        pid=2062,
        title="使数组 K 递增的最少操作次数",
        tags=["数组", "二分查找", "最长递增子序列"],
        description="""给定整数数组 arr 与正整数 k
如果对每个满足 i + k < n 的下标 i 都有 arr[i] <= arr[i + k]
则称数组是 K 递增的
每次操作可以把任意一个元素替换成任意整数
返回使数组变为 K 递增所需的最少操作次数""",
        function="kIncreasingMinOperations",
        params=[("arr", "int[]"), ("k", "int")],
        returns="int",
        solver=k_increasing_min_ops,
        public=[
            [[5, 4, 3, 2, 1], 1],
            [[4, 1, 5, 2, 6, 3], 2],
            [[1, 2, 3, 4, 5], 3],
            [[2, 1, 2, 1, 2, 1], 3],
        ],
        hidden=[
            [[1], 1],
            [[10, 9, 8], 2],
            [[1, 3, 2, 4, 3, 5], 2],
            [[5, 5, 5, 5], 2],
            [[1, 2, 1, 2, 1, 2, 1], 3],
            [[100, 1, 100, 1, 100, 1], 1],
        ],
    ),
    make(
        pid=2063,
        title="参加会议的最多员工数",
        tags=["图", "深度优先搜索", "拓扑排序"],
        description="""公司有 n 名员工，编号 0 到 n-1
favorite[i] 表示员工 i 最喜欢的员工编号，且 favorite[i] != i
公司想安排一场会议
每名参会的员工都必须坐在自己最喜欢的员工旁边
每张圆桌至少坐两人，会议可以有多张圆桌
返回最多可以邀请的员工数""",
        function="maximumEmployeesInvited",
        params=[("favorite", "int[]")],
        returns="int",
        solver=maximum_employees_invited,
        public=[
            [[2, 2, 1, 2]],
            [[1, 2, 0]],
            [[3, 0, 1, 4, 1]],
            [[1, 0]],
        ],
        hidden=[
            [[2, 0, 1]],
            [[1, 0, 3, 2]],
            [[2, 3, 0, 1]],
            [[2, 0, 1, 2, 0]],
            [[3, 3, 0, 2]],
            [[1, 0, 4, 2, 3]],
        ],
    ),
    make(
        pid=2064,
        title="同时运行 N 台电脑的最长时间",
        tags=["数组", "二分查找", "贪心"],
        description="""有 n 台电脑和若干电池
第 i 块电池的电量为 batteries[i]
每台电脑同一时刻最多使用一块电池
每块电池同一时刻最多给一台电脑供电
可以随时更换电脑使用的电池，换电池不消耗电量
所有电脑同时开始运行
返回能让 n 台电脑同时运行的最长分钟数
分钟数必须为整数""",
        function="maxRunTime",
        params=[("n", "int"), ("batteries", "int[]")],
        returns="long",
        solver=max_run_time,
        public=[
            [2, [3, 3, 3]],
            [2, [1, 1, 1, 1]],
            [3, [10, 10, 10]],
            [1, [5, 7, 9]],
        ],
        hidden=[
            [2, [5, 5]],
            [3, [2, 2, 2, 2]],
            [1, [1]],
            [4, [1, 1, 1, 1, 1]],
            [2, [100, 1, 1]],
            [5, [9, 9, 9]],
        ],
    ),
    make(
        pid=2065,
        title="删除元素后和的最小差值",
        tags=["数组", "堆", "前缀和"],
        description="""给定长度为 3n 的整数数组 nums
先删除恰好 n 个元素
剩下 2n 个元素保持原顺序
前 n 个元素组成第一组，后 n 个元素组成第二组
第一组的和减去第二组的和记为差值
返回所有删除方案中可能的最小差值""",
        function="minimumDifferenceAfterRemoval",
        params=[("nums", "int[]")],
        returns="long",
        solver=minimum_difference_after_removal,
        public=[
            [[3, 1, 2]],
            [[7, 9, 5, 8, 1, 3]],
            [[1, 2, 3, 4, 5, 6, 7, 8, 9]],
            [[-1, -2, -3, -4, -5, -6]],
        ],
        hidden=[
            [[1, 1, 1]],
            [[10, 20, 30]],
            [[-5, 1, 2, 3, 4, 6]],
            [[100, 1, 1, 1, 1, 100]],
            [[2, 2, 2, 2, 2, 2]],
            [[9, 8, 7, 6, 5, 4, 3, 2, 1]],
        ],
    ),
    make(
        pid=2066,
        title="得到回文串的最少移动次数",
        tags=["字符串", "双指针", "贪心"],
        description="""给定一个由小写英文字母组成的字符串 s
每次操作可以交换相邻的两个字符
保证 s 能通过重新排列变成回文串
返回使 s 变成回文串所需的最少相邻交换次数""",
        function="minMovesToPalindrome",
        params=[("s", "string")],
        returns="int",
        solver=min_moves_to_palindrome,
        public=[
            ["aabb"],
            ["letelt"],
            ["mamad"],
            ["abcba"],
        ],
        hidden=[
            ["a"],
            ["aa"],
            ["abba"],
            ["abab"],
            ["aaabbbb"],
            ["aabbc"],
        ],
    ),
    make(
        pid=2067,
        title="包含指定路径的最小加权子图",
        tags=["图", "最短路", "堆"],
        description="""给定 n 个节点、编号 0 到 n-1 的有向带权图
edges[i] = [u, v, w] 表示一条从 u 到 v、权值为 w 的边
再给定起点 src1、src2 与终点 dest
选择一个边集，使得子图中同时存在从 src1 到 dest 与从 src2 到 dest 的路径
返回所选边集的最小总权值
如果无法同时形成两条路径，返回 -1""",
        function="minimumWeightedSubgraph",
        params=[
            ("n", "int"),
            ("edges", "int[][]"),
            ("src1", "int"),
            ("src2", "int"),
            ("dest", "int"),
        ],
        returns="long",
        solver=minimum_weighted_subgraph,
        public=[
            [
                6,
                [
                    [0, 2, 2],
                    [0, 5, 6],
                    [1, 0, 3],
                    [1, 4, 5],
                    [2, 1, 1],
                    [3, 0, 5],
                    [5, 3, 1],
                    [5, 4, 5],
                ],
                0,
                1,
                5,
            ],
            [4, [[0, 2, 1], [1, 2, 1], [1, 3, 1]], 0, 1, 3],
            [3, [[0, 1, 2], [1, 2, 3], [0, 2, 10]], 0, 0, 2],
        ],
        hidden=[
            [2, [[0, 1, 4]], 0, 0, 1],
            [3, [[0, 1, 1], [1, 2, 1], [0, 2, 5]], 0, 0, 2],
            [4, [[0, 1, 1], [2, 1, 1], [1, 3, 1]], 0, 2, 3],
            [3, [[0, 1, 2], [1, 2, 2]], 0, 1, 2],
            [2, [[0, 1, 1]], 0, 1, 1],
            [5, [[0, 4, 3], [4, 3, 2], [1, 4, 1], [3, 2, 1]], 0, 1, 2],
        ],
    ),
    make(
        pid=2068,
        title="相邻字符不同的最长路径",
        tags=["树", "深度优先搜索", "动态规划"],
        description="""给定一棵 n 个节点的树
parent[i] 表示节点 i 的父节点，其中 parent[0] = -1
s[i] 是节点 i 上的字符
路径是树中一条不重复经过节点的链
求最长的路径，使路径上任意两个相邻节点的字符都不相同
返回该路径包含的节点数""",
        function="longestPathDifferentChars",
        params=[("parent", "int[]"), ("s", "string")],
        returns="int",
        solver=longest_path_different_chars,
        public=[
            [[-1, 0, 0, 1, 1, 2], "abacbe"],
            [[-1, 0, 0, 0], "aabc"],
            [[-1, 0, 1, 2, 3, 4], "aaaaaa"],
            [[-1, 0, 0, 1, 1, 2], "abcdef"],
        ],
        hidden=[
            [[-1, 0], "ab"],
            [[-1, 0], "aa"],
            [[-1, 0, 1], "abc"],
            [[-1, 0, 0, 0, 0], "abcde"],
            [[-1, 0, 1, 1, 0, 4, 4], "abacdef"],
            [[-1, 0, 0, 1, 2, 3], "aabbbb"],
        ],
    ),
    make(
        pid=2069,
        title="字符串的总引力",
        tags=["字符串", "哈希表", "动态规划"],
        description="""给定字符串 s，仅包含小写英文字母
一个字符串的引力定义为其中不同字符的个数
求 s 所有子串的引力之和""",
        function="totalAppeal",
        params=[("s", "string")],
        returns="long",
        solver=total_appeal,
        public=[
            ["abc"],
            ["aab"],
            ["abbca"],
            ["aaaa"],
        ],
        hidden=[
            ["a"],
            ["ab"],
            ["aba"],
            ["abcde"],
            ["zzza"],
            ["abab"],
        ],
    ),
    make(
        pid=2070,
        title="最大波动的子字符串",
        tags=["字符串", "动态规划", "枚举"],
        description="""给定由小写英文字母组成的字符串 s
对于 s 的一个子串，若其中至少包含两种字符
定义波动值为子串中出现次数最多的字符的次数减去出现次数最少的字符的次数
求所有子串的最大波动值""",
        function="largestVarianceSubstring",
        params=[("s", "string")],
        returns="int",
        solver=largest_variance_substring,
        public=[
            ["aababbb"],
            ["abcde"],
            ["aaaaabbb"],
            ["abcc"],
        ],
        hidden=[
            ["a"],
            ["ab"],
            ["aab"],
            ["abbb"],
            ["abcabc"],
            ["zzzab"],
        ],
        time_limit=2000,
    ),
    make(
        pid=2071,
        title="巫师的总力量",
        tags=["数组", "单调栈", "前缀和"],
        description="""给定数组 strength 表示每名巫师的力量
一个连续子数组的总力量定义为该子数组中的最小力量乘以子数组元素之和
求所有连续子数组的总力量之和
结果对 1000000007 取模""",
        function="totalStrengthWizards",
        params=[("strength", "int[]")],
        returns="int",
        solver=total_strength_wizards,
        public=[
            [[1, 3, 1, 2]],
            [[5, 4, 6]],
            [[1, 2]],
            [[2, 2, 2]],
        ],
        hidden=[
            [[7]],
            [[1, 1]],
            [[3, 1, 2]],
            [[10, 1, 10]],
            [[2, 3, 4, 5]],
            [[1, 100, 1, 100, 1]],
        ],
    ),
    make(
        pid=2072,
        title="使数组非递减的最少步骤",
        tags=["数组", "单调栈"],
        description="""给定整数数组 nums
每一步同时删除所有满足 nums[i-1] > nums[i] 的元素 nums[i]，其中 i >= 1
所有判断都基于该步开始前的数组
当数组不再发生变化时停止
返回执行的总步数""",
        function="totalStepsNonDecreasing",
        params=[("nums", "int[]")],
        returns="int",
        solver=total_steps_non_decreasing,
        public=[
            [[5, 3, 4, 4, 7, 3, 6, 11, 8, 5, 11]],
            [[4, 5, 7, 7, 6]],
            [[7, 5, 6]],
            [[1, 2, 3]],
        ],
        hidden=[
            [[1]],
            [[3, 2, 1]],
            [[10, 4, 5, 5, 6]],
            [[1, 1, 1]],
            [[2, 1, 3, 2, 4, 3]],
            [[5, 4, 3, 2, 1]],
        ],
    ),
    make(
        pid=2073,
        title="移除障碍物到达角落的最少数量",
        tags=["图", "广度优先搜索", "最短路"],
        description="""给定 n 行 m 列的 0-1 网格 grid
0 表示空地，1 表示障碍物
从左上角 (0, 0) 出发，每次可以向上、下、左、右移动到相邻格子
进入障碍物格子需要移除该障碍物，计数加一
可以重复经过格子
左上角与右下角保证是空地
返回到达右下角 (n-1, m-1) 需要移除的最少障碍物数量""",
        function="minimumObstacles",
        params=[("grid", "int[][]")],
        returns="int",
        solver=minimum_obstacles,
        public=[
            [[[0, 1, 1], [1, 1, 0], [1, 1, 0]]],
            [[[0, 1, 0, 0, 0], [0, 1, 0, 1, 0], [0, 0, 0, 1, 0]]],
            [[[0, 1, 1, 1], [1, 0, 1, 1], [1, 1, 0, 1], [1, 1, 1, 0]]],
            [[[0, 0], [0, 0]]],
        ],
        hidden=[
            [[[0]]],
            [[[0, 1], [1, 1], [1, 0]]],
            [[[0, 1, 0]]],
            [[[0, 0, 0], [1, 1, 0], [1, 1, 0]]],
            [[[0, 1, 1, 1, 1], [0, 1, 1, 1, 0]]],
            [[[0, 0, 1], [0, 1, 0], [1, 0, 0]]],
        ],
    ),
    make(
        pid=2074,
        title="给公司命名",
        tags=["数组", "哈希表", "字符串"],
        description="""给定互不相同的字符串数组 ideas
每个字符串由一个小写字母后跟若干小写字母组成
选择两个不同的字符串 ideaA 与 ideaB
交换它们的首字母，得到两个新名字
若两个新名字都不在 ideas 中，则这对名字有效
两个选择顺序不同视为不同的公司名
返回有效公司名的数量""",
        function="distinctCompanyNames",
        params=[("ideas", "string[]")],
        returns="long",
        solver=distinct_company_names,
        public=[
            [["coffee", "donuts", "time", "toffee"]],
            [["lack", "back"]],
            [["abc", "bcd", "cde"]],
            [["a", "b"]],
        ],
        hidden=[
            [["aa", "ab", "ba", "bb"]],
            [["ab", "ac"]],
            [["ab", "ba"]],
            [["xyz", "abc"]],
            [["aab", "aba", "baa"]],
            [["abcd", "bcde", "cdef"]],
        ],
    ),
    make(
        pid=2075,
        title="删除操作后的最大子段和",
        tags=["数组", "并查集", "前缀和"],
        description="""给定整数数组 nums 与数组 removeQueries
removeQueries 是 0 到 n-1 的一个排列
按 removeQueries 的顺序依次删除对应下标的元素
删除后数组可能被分成若干连续段
每删除一个元素后，求所有连续段中和的最大值
空段的值为 0
返回长度为 n 的数组 answer
answer[i] 表示删除前 i+1 个元素后的结果""",
        function="maximumSegmentSumAfterRemovals",
        params=[("nums", "int[]"), ("removeQueries", "int[]")],
        returns="int[]",
        solver=maximum_segment_sum_after_removals,
        public=[
            [[1, 2, 3, 4, 5], [0, 1, 2, 3, 4]],
            [[2, 9, 4, 2, 3, 4, 9], [5, 3, 6, 0, 2, 1, 4]],
            [[1, 1, 1], [0, 1, 2]],
            [[5], [0]],
        ],
        hidden=[
            [[1, 2], [1, 0]],
            [[10, 2, 5], [1, 0, 2]],
            [[3, 3, 3, 3], [2, 0, 3, 1]],
            [[1, 2, 3], [2, 0, 1]],
            [[4, 1, 4], [1, 0, 2]],
            [[2, 1, 3, 1, 2], [2, 4, 0, 1, 3]],
        ],
    ),
    make(
        pid=2076,
        title="最长递增子序列 II",
        tags=["数组", "线段树", "动态规划"],
        description="""给定整数数组 nums 与正整数 k
求最长的子序列
满足对子序列中每一对相邻元素都有前一个元素小于后一个元素
且后一个元素减前一个元素不超过 k
返回该子序列的长度""",
        function="longestIncreasingSubsequenceK",
        params=[("nums", "int[]"), ("k", "int")],
        returns="int",
        solver=longest_increasing_subsequence_k,
        public=[
            [[4, 2, 1, 4, 3, 4, 5], 3],
            [[7, 4, 5, 1, 8, 12, 4, 7], 5],
            [[1, 2, 3, 4], 1],
            [[1, 5, 9], 3],
        ],
        hidden=[
            [[1], 1],
            [[5, 5, 5], 2],
            [[2, 1, 3], 2],
            [[10, 1, 2, 3, 4, 5], 2],
            [[3, 1, 2], 1],
            [[1, 100, 2, 101, 3, 102], 1],
        ],
    ),
    make(
        pid=2077,
        title="好路径的数目",
        tags=["树", "并查集", "深度优先搜索"],
        description="""给定一棵 n 个节点的树，节点编号 0 到 n-1
vals[i] 是节点 i 的值
edges 表示树中的边
称节点对 (a, b) 是好路径，如果：
a 与 b 的值相等
从 a 到 b 的路径上所有节点的值都不超过 vals[a]
路径包含单个节点也算，即允许 a = b
返回好路径的数量
节点对按无序对计，(a, b) 与 (b, a) 视为同一条路径""",
        function="countGoodPaths",
        params=[("vals", "int[]"), ("edges", "int[][]")],
        returns="int",
        solver=count_good_paths,
        public=[
            [[1, 3, 2, 1, 3], [[0, 1], [0, 2], [2, 3], [2, 4]]],
            [[1, 1, 1], [[0, 1], [1, 2]]],
            [[1, 2, 1], [[0, 2]]],
            [[1], []],
        ],
        hidden=[
            [[2, 2], [[0, 1]]],
            [[3, 1, 3], []],
            [[1, 2, 3], [[0, 1], [1, 2]]],
            [[2, 2, 2], [[0, 1]]],
            [[1, 2, 1, 1], [[0, 1], [1, 2], [2, 3]]],
            [[2, 1, 2, 1], [[0, 1], [1, 2], [1, 3]]],
        ],
    ),
    make(
        pid=2078,
        title="字符串的前缀分数和",
        tags=["字符串", "字典树", "数组"],
        description="""给定字符串数组 words
对于每个单词 word，它的前缀分数定义为：
对 word 的每一个非空前缀 p
统计 words 中以 p 为前缀的单词数量
再把这些数量相加
返回一个数组，第 i 个元素是 words[i] 的前缀分数""",
        function="sumPrefixScores",
        params=[("words", "string[]")],
        returns="int[]",
        solver=sum_prefix_scores,
        public=[
            [["abc", "ab", "bc", "bcd"]],
            [["a", "ab", "abc"]],
            [["abcd"]],
            [["ab", "ab"]],
        ],
        hidden=[
            [["x"]],
            [["aa", "aa", "aa"]],
            [["ab", "ba"]],
            [["abc", "abd", "abe"]],
            [["z", "zz", "zzz"]],
            [["a", "ba", "cba"]],
        ],
    ),
    make(
        pid=2079,
        title="网格查询的最大得分",
        tags=["图", "广度优先搜索", "堆", "排序"],
        description="""给定 n 行 m 列的整数网格 grid 与整数数组 queries
对每个查询 queries[i]，从左上角 (0, 0) 出发
可以移动到上下左右相邻的格子
但目标格子的值必须严格小于 queries[i]
起点也只有在值严格小于 queries[i] 时才会计分
每个格子最多计一分
返回长度为 len(queries) 的数组 answer
answer[i] 表示第 i 个查询可以到达并计分的格子数量""",
        function="maxPointsFromGridQueries",
        params=[("grid", "int[][]"), ("queries", "int[]")],
        returns="int[]",
        solver=max_points_from_grid_queries,
        public=[
            [[[1, 2, 3], [2, 5, 7], [3, 5, 1]], [5, 6, 2]],
            [[[1, 1], [1, 1]], [1, 2]],
            [[[5]], [4, 6]],
            [[[1, 2], [3, 4]], [2, 3, 5]],
        ],
        hidden=[
            [[[1]], [1]],
            [[[1]], [2]],
            [[[1, 1, 1]], [2]],
            [[[1, 2, 1]], [3]],
            [[[1, 5, 1], [5, 1, 5], [1, 5, 1]], [2, 6]],
            [[[1, 3, 1], [3, 1, 3], [1, 3, 1]], [2, 4]],
        ],
    ),
]
