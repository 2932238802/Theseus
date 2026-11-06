"""1880-1899：批量第三批困难题（20 道）。"""

from __future__ import annotations

import bisect
from functools import partial
from itertools import product

from problem_seed_common import make_problem

make = partial(make_problem, difficulty="hard")

MOD = 10**9 + 7


# ── 1880 将子数组重新排序得到同一个二叉查找树的方案数 ───────────────


def bst_reorder_ways(nums: list[int]) -> int:
    size = len(nums)
    comb = [[0] * (size + 1) for _ in range(size + 1)]
    for total in range(size + 1):
        comb[total][0] = 1
        for chosen in range(1, total + 1):
            comb[total][chosen] = (
                comb[total - 1][chosen - 1] + comb[total - 1][chosen]
            ) % MOD

    def count(arr: list[int]) -> int:
        if len(arr) <= 2:
            return 1
        root = arr[0]
        left = [value for value in arr[1:] if value < root]
        right = [value for value in arr[1:] if value > root]
        return (
            comb[len(arr) - 1][len(left)]
            * count(left)
            % MOD
            * count(right)
            % MOD
        )

    return count(nums)


# ── 1881 连通两组点的最小成本 ───────────────────────────────────────


def connect_two_groups(cost: list[list[int]]) -> int:
    first_size = len(cost)
    second_size = len(cost[0])
    infinity = 10**9
    dp = [infinity] * (1 << second_size)
    dp[0] = 0
    for index in range(first_size):
        next_dp = [infinity] * (1 << second_size)
        row = cost[index]
        for mask in range(1 << second_size):
            current = dp[mask]
            if current == infinity:
                continue
            for second in range(second_size):
                next_mask = mask | 1 << second
                candidate = current + row[second]
                if candidate < next_dp[next_mask]:
                    next_dp[next_mask] = candidate
        dp = next_dp

    cheapest = [min(cost[index][second] for index in range(first_size))
                for second in range(second_size)]
    answer = infinity
    for mask in range(1 << second_size):
        if dp[mask] == infinity:
            continue
        extra = sum(
            cheapest[second]
            for second in range(second_size)
            if not (mask >> second & 1)
        )
        answer = min(answer, dp[mask] + extra)
    return answer


# ── 1882 第 K 条最小指令 ────────────────────────────────────────────


def kth_smallest_path(row: int, column: int, k: int) -> str:
    total = row + column
    comb = [[0] * (total + 1) for _ in range(total + 1)]
    for size in range(total + 1):
        comb[size][0] = 1
        for chosen in range(1, size + 1):
            comb[size][chosen] = comb[size - 1][chosen - 1] + comb[size - 1][chosen]

    answer: list[str] = []
    horizontal = column
    vertical = row
    while horizontal + vertical > 0:
        if horizontal == 0:
            answer.append("V")
            vertical -= 1
            continue
        if vertical == 0:
            answer.append("H")
            horizontal -= 1
            continue
        ways_with_h = comb[horizontal + vertical - 1][horizontal - 1]
        if k <= ways_with_h:
            answer.append("H")
            horizontal -= 1
        else:
            answer.append("V")
            vertical -= 1
            k -= ways_with_h
    return "".join(answer)


# ── 1883 得到山形数组的最少删除次数 ─────────────────────────────────


def minimum_mountain_removals(nums: list[int]) -> int:
    size = len(nums)
    increasing = [1] * size
    for right in range(size):
        for left in range(right):
            if nums[left] < nums[right]:
                increasing[right] = max(increasing[right], increasing[left] + 1)

    decreasing = [1] * size
    for left in range(size - 1, -1, -1):
        for right in range(left + 1, size):
            if nums[right] < nums[left]:
                decreasing[left] = max(decreasing[left], decreasing[right] + 1)

    best = 0
    for peak in range(size):
        if increasing[peak] >= 2 and decreasing[peak] >= 2:
            best = max(best, increasing[peak] + decreasing[peak] - 1)
    if best == 0:
        return -1
    return size - best


# ── 1884 堆叠长方体的最大高度 ───────────────────────────────────────


def max_cuboid_height(cuboids: list[list[int]]) -> int:
    boxes = sorted(sorted(cuboid) for cuboid in cuboids)
    boxes.sort()
    size = len(boxes)
    dp = [0] * size
    answer = 0
    for current in range(size):
        dp[current] = boxes[current][2]
        for previous in range(current):
            if all(boxes[previous][axis] <= boxes[current][axis] for axis in range(3)):
                dp[current] = max(dp[current], dp[previous] + boxes[current][2])
        answer = max(answer, dp[current])
    return answer


# ── 1885 生成乘积数组的方案数 ───────────────────────────────────────


def ways_to_make_product_array(queries: list[list[int]]) -> list[int]:
    max_k = max(k for _n, k in queries)
    limit = max_k + 64
    factorial = [1] * (limit + 1)
    for value in range(1, limit + 1):
        factorial[value] = factorial[value - 1] * value % MOD
    inverse = [1] * (limit + 1)
    inverse[limit] = pow(factorial[limit], MOD - 2, MOD)
    for value in range(limit, 0, -1):
        inverse[value - 1] = inverse[value] * value % MOD

    def choose(n: int, r: int) -> int:
        if r < 0 or r > n:
            return 0
        return factorial[n] * inverse[r] % MOD * inverse[n - r] % MOD

    answer: list[int] = []
    for target, length in queries:
        ways = 1
        remaining = target
        divisor = 2
        while divisor * divisor <= remaining:
            if remaining % divisor == 0:
                exponent = 0
                while remaining % divisor == 0:
                    remaining //= divisor
                    exponent += 1
                ways = ways * choose(exponent + length - 1, length - 1) % MOD
            divisor += 1
        if remaining > 1:
            ways = ways * choose(length, length - 1) % MOD
        answer.append(ways)
    return answer


# ── 1886 回文串分割 IV ──────────────────────────────────────────────


def can_split_into_three_palindromes(s: str) -> bool:
    size = len(s)
    palindrome = [[False] * size for _ in range(size)]
    for index in range(size):
        palindrome[index][index] = True
    for index in range(size - 1):
        palindrome[index][index + 1] = s[index] == s[index + 1]
    for length in range(3, size + 1):
        for left in range(size - length + 1):
            right = left + length - 1
            palindrome[left][right] = (
                s[left] == s[right] and palindrome[left + 1][right - 1]
            )

    for first_end in range(1, size - 1):
        if not palindrome[0][first_end - 1]:
            continue
        for second_end in range(first_end + 1, size):
            if (
                palindrome[first_end][second_end - 1]
                and palindrome[second_end][size - 1]
            ):
                return True
    return False


# ── 1887 由子序列构造的最长回文串的长度 ─────────────────────────────


def longest_palindrome_from_subsequences(word1: str, word2: str) -> int:
    boundary = len(word1)
    combined = word1 + word2
    size = len(combined)
    dp = [[0] * size for _ in range(size)]
    for index in range(size):
        dp[index][index] = 1
    for length in range(2, size + 1):
        for left in range(size - length + 1):
            right = left + length - 1
            if combined[left] == combined[right]:
                dp[left][right] = dp[left + 1][right - 1] + 2
            else:
                dp[left][right] = max(dp[left + 1][right], dp[left][right - 1])

    answer = 0
    for left in range(boundary):
        for right in range(boundary, size):
            if combined[left] == combined[right]:
                answer = max(answer, dp[left][right])
    return answer


# ── 1888 使所有区间的异或结果为零 ───────────────────────────────────


def minimum_changes_for_zero_xor(nums: list[int], k: int) -> int:
    size = len(nums)
    groups: list[tuple[dict[int, int], int]] = []
    for residue in range(k):
        counts: dict[int, int] = {}
        total = 0
        for index in range(residue, size, k):
            counts[nums[index]] = counts.get(nums[index], 0) + 1
            total += 1
        groups.append((counts, total))

    infinity = 10**9
    dp = [infinity] * 1024
    dp[0] = 0
    for counts, total in groups:
        next_dp = [infinity] * 1024
        best_previous = min(dp)
        full = len(counts) == 1024
        for target in range(1024):
            best = infinity if full else best_previous + total
            for value, frequency in counts.items():
                candidate = dp[target ^ value] + total - frequency
                if candidate < best:
                    best = candidate
            next_dp[target] = best
        dp = next_dp
    return dp[0]


# ── 1889 好子数组的最大分数 ─────────────────────────────────────────


def maximum_good_subarray_score(nums: list[int], k: int) -> int:
    size = len(nums)
    left = right = k
    current_min = nums[k]
    answer = nums[k]
    while left > 0 or right < size - 1:
        if left == 0:
            right += 1
        elif right == size - 1:
            left -= 1
        elif nums[left - 1] >= nums[right + 1]:
            left -= 1
        else:
            right += 1
        current_min = min(current_min, nums[left], nums[right])
        answer = max(answer, current_min * (right - left + 1))
    return answer


# ── 1890 统计异或值在范围内的数对有多少 ─────────────────────────────


class _TrieNode:
    __slots__ = ("children", "count")

    def __init__(self) -> None:
        self.children: list[_TrieNode | None] = [None, None]
        self.count = 0


def count_xor_pairs_in_range(nums: list[int], low: int, high: int) -> int:
    root = _TrieNode()
    bits = 31

    def insert(value: int) -> None:
        node = root
        for bit in range(bits - 1, -1, -1):
            branch = value >> bit & 1
            child = node.children[branch]
            if child is None:
                child = _TrieNode()
                node.children[branch] = child
            node = child
            node.count += 1

    def count_less(value: int, limit: int) -> int:
        if limit <= 0:
            return 0
        node: _TrieNode | None = root
        total = 0
        for bit in range(bits - 1, -1, -1):
            if node is None:
                break
            value_bit = value >> bit & 1
            limit_bit = limit >> bit & 1
            if limit_bit:
                same = node.children[value_bit]
                if same is not None:
                    total += same.count
                node = node.children[1 - value_bit]
            else:
                node = node.children[value_bit]
        return total

    answer = 0
    for value in nums:
        if high + 1 > 0:
            answer += count_less(value, high + 1) - count_less(value, low)
        insert(value)
    return answer


# ── 1891 用三种不同颜色为网格涂色 ───────────────────────────────────


def color_grid_three_colors(m: int, n: int) -> int:
    valid_rows = [
        row
        for row in product(range(3), repeat=m)
        if all(row[index] != row[index - 1] for index in range(1, m))
    ]
    count = len(valid_rows)
    compatible: list[list[int]] = [[] for _ in range(count)]
    for first in range(count):
        for second in range(count):
            if all(
                valid_rows[first][index] != valid_rows[second][index]
                for index in range(m)
            ):
                compatible[first].append(second)

    dp = [1] * count
    for _row in range(1, n):
        next_dp = [0] * count
        for current in range(count):
            next_dp[current] = sum(dp[previous] for previous in compatible[current]) % MOD
        dp = next_dp
    return sum(dp) % MOD


# ── 1892 好子集的数目 ───────────────────────────────────────────────


def number_of_good_subsets(nums: list[int]) -> int:
    primes = [2, 3, 5, 7, 11, 13, 17, 19, 23, 29]
    frequency = [0] * 31
    ones = 0
    for value in nums:
        if value == 1:
            ones += 1
        else:
            frequency[value] += 1

    dp = [0] * 1024
    dp[0] = 1
    for value in range(2, 31):
        if frequency[value] == 0:
            continue
        remaining = value
        mask = 0
        square_free = True
        for index, prime in enumerate(primes):
            if remaining % prime == 0:
                mask |= 1 << index
                remaining //= prime
                if remaining % prime == 0:
                    square_free = False
                    break
        if not square_free:
            continue
        ways_to_pick = frequency[value]
        for current in range(1023, -1, -1):
            if dp[current] and not (current & mask):
                target = current | mask
                dp[target] = (dp[target] + dp[current] * ways_to_pick) % MOD

    total = sum(dp[1:]) % MOD
    return total * pow(2, ones, MOD) % MOD


# ── 1893 数组的最大公因数排序 ───────────────────────────────────────


def gcd_sort_possible(nums: list[int]) -> bool:
    size = len(nums)
    parent = list(range(size))
    rank = [0] * size

    def find(value: int) -> int:
        while parent[value] != value:
            parent[value] = parent[parent[value]]
            value = parent[value]
        return value

    def union(left: int, right: int) -> None:
        root_left, root_right = find(left), find(right)
        if root_left == root_right:
            return
        if rank[root_left] < rank[root_right]:
            root_left, root_right = root_right, root_left
        parent[root_right] = root_left
        if rank[root_left] == rank[root_right]:
            rank[root_left] += 1

    first_index: dict[int, int] = {}
    for index, value in enumerate(nums):
        remaining = value
        divisor = 2
        while divisor * divisor <= remaining:
            if remaining % divisor == 0:
                if divisor in first_index:
                    union(index, first_index[divisor])
                else:
                    first_index[divisor] = index
                while remaining % divisor == 0:
                    remaining //= divisor
            divisor += 1
        if remaining > 1:
            if remaining in first_index:
                union(index, first_index[remaining])
            else:
                first_index[remaining] = index

    order = sorted(range(size), key=lambda index: nums[index])
    for position, original in enumerate(order):
        if find(position) != find(original):
            return False
    return True


# ── 1894 每棵子树内缺失的最小基因值 ─────────────────────────────────


def smallest_missing_genetic_values(
    parents: list[int], nums: list[int]
) -> list[int]:
    size = len(parents)
    children: list[list[int]] = [[] for _ in range(size)]
    root = 0
    for node, parent in enumerate(parents):
        if parent == -1:
            root = node
        else:
            children[parent].append(node)

    start = -1
    for node, value in enumerate(nums):
        if value == 0:
            start = node
            break
    answer = [0] * size
    if start == -1:
        return answer

    path: list[int] = []
    current = start
    while current != -1:
        path.append(current)
        current = parents[current]

    seen: set[int] = set()
    mex = 0

    def add_subtree(node: int) -> None:
        stack = [node]
        while stack:
            position = stack.pop()
            value = nums[position]
            if value <= size:
                seen.add(value)
            stack.extend(children[position])

    previous = -1
    for node in path:
        value = nums[node]
        if value <= size:
            seen.add(value)
        for child in children[node]:
            if child != previous:
                add_subtree(child)
        while mex in seen:
            mex += 1
        answer[node] = mex
        previous = node
    return answer


# ── 1895 使数组连续的最少操作数 ─────────────────────────────────────


def minimum_operations_to_make_continuous(nums: list[int]) -> int:
    size = len(nums)
    values = sorted(set(nums))
    best = 0
    left = 0
    for right in range(len(values)):
        while values[right] - values[left] > size - 1:
            left += 1
        best = max(best, right - left + 1)
    return size - best


# ── 1896 将数组分成两个数组并最小化数组和的差 ───────────────────────


def minimum_sum_difference_partition(nums: list[int]) -> int:
    size = len(nums)
    half = size // 2

    def sums_by_count(values: list[int]) -> list[list[int]]:
        length = len(values)
        groups: list[list[int]] = [[] for _ in range(length + 1)]
        for mask in range(1 << length):
            total = 0
            for index in range(length):
                if mask >> index & 1:
                    total += values[index]
            groups[mask.bit_count()].append(total)
        return groups

    left_groups = sums_by_count(nums[:half])
    right_groups = sums_by_count(nums[half:])
    total_sum = sum(nums)
    answer = total_sum

    for chosen_left in range(half + 1):
        chosen_right = half - chosen_left
        if chosen_left >= len(left_groups) or chosen_right >= len(right_groups):
            continue
        right_values = sorted(right_groups[chosen_right])
        for left_sum in left_groups[chosen_left]:
            target = total_sum / 2 - left_sum
            position = bisect.bisect_left(right_values, target)
            for candidate in (position - 1, position):
                if 0 <= candidate < len(right_values):
                    answer = min(
                        answer,
                        abs(total_sum - 2 * (left_sum + right_values[candidate])),
                    )
    return answer


# ── 1897 摘水果 ─────────────────────────────────────────────────────


def maximum_fruits_harvested(
    fruits: list[list[int]], start_pos: int, k: int
) -> int:
    fruits = sorted(fruits)
    positions = [fruit[0] for fruit in fruits]
    amounts = [fruit[1] for fruit in fruits]
    size = len(positions)
    prefix = [0]
    for amount in amounts:
        prefix.append(prefix[-1] + amount)

    best = 0
    left = 0
    for right in range(size):
        while left <= right and positions[right] - positions[left] > k:
            left += 1
        while left <= right:
            if start_pos < positions[left]:
                cost = positions[right] - start_pos
            elif start_pos > positions[right]:
                cost = start_pos - positions[left]
            else:
                cost = (
                    positions[right]
                    - positions[left]
                    + min(start_pos - positions[left], positions[right] - start_pos)
                )
            if cost <= k:
                break
            left += 1
        if left <= right:
            best = max(best, prefix[right + 1] - prefix[left])
    return best


# ── 1898 数组的最大与和 ─────────────────────────────────────────────


def maximum_and_sum(nums: list[int], num_slots: int) -> int:
    powers = [1]
    for _slot in range(num_slots):
        powers.append(powers[-1] * 3)
    state_count = powers[num_slots]
    dp = [-1] * state_count
    dp[0] = 0
    size = len(nums)

    for mask in range(state_count):
        current = dp[mask]
        if current < 0:
            continue
        used = 0
        remaining = mask
        for _slot in range(num_slots):
            used += remaining % 3
            remaining //= 3
        if used >= size:
            continue
        for slot in range(num_slots):
            if (mask // powers[slot]) % 3 < 2:
                next_mask = mask + powers[slot]
                candidate = current + (nums[used] & (slot + 1))
                if candidate > dp[next_mask]:
                    dp[next_mask] = candidate
    return max(dp)


# ── 1899 从栈中取出 K 个硬币的最大面值和 ────────────────────────────


def maximum_coins_from_piles(piles: list[list[int]], k: int) -> int:
    negative = -(10**18)
    dp = [negative] * (k + 1)
    dp[0] = 0
    for pile in piles:
        prefix = [0]
        for coin in pile:
            prefix.append(prefix[-1] + coin)
        max_take = min(len(pile), k)
        next_dp = [negative] * (k + 1)
        for taken in range(k + 1):
            if dp[taken] == negative:
                continue
            limit = min(max_take, k - taken)
            for extra in range(limit + 1):
                candidate = dp[taken] + prefix[extra]
                if candidate > next_dp[taken + extra]:
                    next_dp[taken + extra] = candidate
        dp = next_dp
    return dp[k]


PROBLEMS = [
    make(
        pid=1880,
        title="将子数组重新排序得到同一个二叉查找树的方案数",
        tags=["树", "二叉搜索树", "组合数学", "递归"],
        description="""给定一个由互不相同的整数组成的数组 nums。
把 nums 按给定顺序依次插入一棵初始为空的二叉查找树，可以得到一棵确定的树。
现在可以任意重排 nums，问有多少种重排结果插入后得到的二叉查找树与原数组顺序得到的树完全相同。
答案对 10^9 + 7 取模。
数组长度不超过 1000。""",
        function="bstReorderWays",
        params=[("nums", "int[]")],
        returns="int",
        solver=bst_reorder_ways,
        public=[
            [[2, 1, 3]],
            [[3, 4, 5, 1, 2]],
            [[1, 2, 3]],
            [[10, 20, 30, 40]],
        ],
        hidden=[
            [[1]],
            [[2, 1]],
            [[3, 1, 2]],
            [[4, 2, 1, 3]],
            [[5, 4, 3, 2, 1]],
            [[3, 1, 5, 2, 4]],
            [[2, 1, 4, 3]],
        ],
    ),
    make(
        pid=1881,
        title="连通两组点的最小成本",
        tags=["动态规划", "状态压缩", "图"],
        description="""给定 m x n 的整数矩阵 cost。
cost[i][j] 表示把第一组第 i 个点与第二组第 j 个点相连的代价。
需要让第一组的每个点至少与第二组中的某个点相连，同时第二组的每个点也至少与第一组中的某个点相连。
点对之间可以重复连接，求完成要求的最小总代价。
m 和 n 均不超过 12。""",
        function="connectTwoGroups",
        params=[("cost", "int[][]")],
        returns="int",
        solver=connect_two_groups,
        public=[
            [[[15, 96], [36, 2]]],
            [[[1, 3, 5], [4, 1, 1], [1, 5, 3]]],
            [[[2, 5, 1], [3, 4, 7], [8, 1, 2], [6, 2, 4], [3, 8, 9]]],
        ],
        hidden=[
            [[[1, 2], [3, 4]]],
            [[[1, 1], [1, 1]]],
            [[[1, 5, 3], [2, 4, 6]]],
            [[[5, 2], [3, 7], [9, 1]]],
            [[[1, 2, 3], [6, 5, 4], [7, 8, 9], [10, 11, 12]]],
        ],
    ),
    make(
        pid=1882,
        title="第 K 条最小指令",
        tags=["数学", "组合数学", "贪心"],
        description="""从坐标 (0, 0) 出发，目标是到达 (row, column)。
每次可以向右走一格，指令记为 H；或向上走一格，指令记为 V。
一条指令序列中恰好包含 column 个 H 和 row 个 V。
按字典序比较所有这样的指令序列，其中 H 排在 V 前面。
返回字典序第 k 小的指令序列，k 从 1 开始。
row、column 不超过 30。""",
        function="kthSmallestPath",
        params=[("row", "int"), ("column", "int"), ("k", "int")],
        returns="string",
        solver=kth_smallest_path,
        public=[
            [2, 3, 1],
            [2, 3, 2],
            [2, 3, 3],
            [1, 1, 1],
        ],
        hidden=[
            [0, 1, 1],
            [1, 0, 1],
            [3, 1, 2],
            [2, 2, 4],
            [3, 3, 1],
            [3, 3, 20],
            [0, 5, 1],
            [5, 0, 1],
        ],
    ),
    make(
        pid=1883,
        title="得到山形数组的最少删除次数",
        tags=["数组", "动态规划", "最长递增子序列"],
        description="""给定整数数组 nums。
山形数组要求存在一个峰值下标 i，满足 0 < i < 长度 - 1，
且 nums[0] < nums[1] < ... < nums[i] 严格递增，
nums[i] > nums[i + 1] > ... > nums[长度 - 1] 严格递减。
可以删除任意数量的元素，保留元素的相对顺序。
返回使剩余数组成为山形数组的最少删除次数；无法做到返回 -1。
数组长度不超过 1000。""",
        function="minimumMountainRemovals",
        params=[("nums", "int[]")],
        returns="int",
        solver=minimum_mountain_removals,
        public=[
            [[1, 3, 1]],
            [[2, 1, 1, 5, 6, 2, 3, 1]],
            [[1, 2, 3]],
            [[1, 2, 3, 4, 4, 3, 2, 1]],
        ],
        hidden=[
            [[1, 2, 3, 4, 5]],
            [[5, 4, 3, 2, 1]],
            [[1, 5, 3]],
            [[2, 3, 1]],
            [[1, 3, 2, 4, 3, 2, 1]],
            [[1, 2, 3, 2, 1]],
            [[3, 3, 3]],
            [[1, 2, 1, 2, 1]],
        ],
    ),
    make(
        pid=1884,
        title="堆叠长方体的最大高度",
        tags=["数组", "动态规划", "排序"],
        description="""给定若干个长方体，每个长方体用三条棱的长度 [a, b, c] 表示。
每个长方体可以任意旋转，旋转后把三条棱按从小到大排列，记作 (x, y, z)。
可以把长方体竖直堆叠，要求下方长方体的 x、y、z 分别不小于上方长方体的 x、y、z。
求堆叠后能达到的最大总高度，高度为最上方长方体的 z 值之和。
长方体数量不超过 100，棱长不超过 100。""",
        function="maxCuboidHeight",
        params=[("cuboids", "int[][]")],
        returns="int",
        solver=max_cuboid_height,
        public=[
            [[[50, 45, 20], [95, 37, 53], [45, 23, 12]]],
            [[[38, 25, 45], [76, 35, 3]]],
            [[[7, 11, 17], [7, 17, 11], [11, 17, 7], [17, 7, 11], [17, 11, 7], [11, 7, 17]]],
        ],
        hidden=[
            [[[1, 1, 1]]],
            [[[10, 10, 10], [10, 10, 10]]],
            [[[2, 3, 4], [1, 2, 3]]],
            [[[1, 100, 1], [2, 3, 4], [5, 6, 7]]],
            [[[6, 7, 8], [9, 10, 11], [1, 2, 3], [4, 5, 6]]],
        ],
    ),
    make(
        pid=1885,
        title="生成乘积数组的方案数",
        tags=["数组", "数学", "组合数学", "数论"],
        description="""给定若干查询，每个查询为 [n, k]。
对每个查询，统计长度为 k 的正整数数组的个数，使得所有元素的乘积恰好等于 n。
数组元素顺序不同视为不同方案。
返回一个数组，按输入查询的顺序给出每个查询的答案，答案对 10^9 + 7 取模。
n 不超过 10000，k 不超过 10000。""",
        function="waysToMakeProductArray",
        params=[("queries", "int[][]")],
        returns="int[]",
        solver=ways_to_make_product_array,
        public=[
            [[[2, 3]]],
            [[[5, 1]]],
            [[[4, 2]]],
            [[[2, 6], [5, 1], [73, 3]]],
            [[[1, 5]]],
        ],
        hidden=[
            [[[7, 2]]],
            [[[12, 3]]],
            [[[36, 2]]],
            [[[10000, 1]]],
            [[[1, 1]]],
            [[[8, 4]]],
            [[[2, 1], [3, 1], [4, 1]]],
        ],
    ),
    make(
        pid=1886,
        title="回文串分割 IV",
        tags=["字符串", "动态规划", "回文"],
        description="""给定字符串 s。
判断能否把 s 分割成恰好三个非空连续子串，并且这三个子串都是回文串。
可以返回 true 或 false。
字符串长度不超过 2000。""",
        function="canSplitIntoThreePalindromes",
        params=[("s", "string")],
        returns="bool",
        solver=can_split_into_three_palindromes,
        public=[
            ["abcbdd"],
            ["bcbddxy"],
            ["abc"],
            ["abacaba"],
        ],
        hidden=[
            ["a"],
            ["aa"],
            ["aaa"],
            ["aba"],
            ["abbab"],
            ["aabbaa"],
            ["abcbaabc"],
        ],
    ),
    make(
        pid=1887,
        title="由子序列构造的最长回文串的长度",
        tags=["字符串", "动态规划", "区间动态规划"],
        description="""给定两个字符串 word1 和 word2。
从 word1 中选出一个非空子序列，从 word2 中选出一个非空子序列，
把两个子序列按顺序拼接成一个新字符串。
要求新字符串是回文串，求其最大可能长度。
两个字符串长度均不超过 1000。""",
        function="longestPalindromeFromSubsequences",
        params=[("word1", "string"), ("word2", "string")],
        returns="int",
        solver=longest_palindrome_from_subsequences,
        public=[
            ["cacb", "cbba"],
            ["ab", "ab"],
            ["aa", "bb"],
            ["a", "a"],
        ],
        hidden=[
            ["abc", "def"],
            ["ab", "ba"],
            ["aaaa", "aa"],
            ["abcba", "abcba"],
            ["a", "bc"],
            ["ab", "cd"],
        ],
    ),
    make(
        pid=1888,
        title="使所有区间的异或结果为零",
        tags=["数组", "动态规划", "位运算"],
        description="""给定整数数组 nums 和整数 k，nums 中每个元素都在 0 到 1023 之间。
一次操作可以把任意元素修改为 0 到 1023 之间的任意整数。
要求修改后，所有长度为 k 的连续子数组的异或和都等于 0。
返回需要的最少修改次数。
数组长度不超过 2000，k 不超过数组长度。""",
        function="minimumChangesForZeroXor",
        params=[("nums", "int[]"), ("k", "int")],
        returns="int",
        solver=minimum_changes_for_zero_xor,
        public=[
            [[1, 2, 0, 3, 0], 1],
            [[3, 4, 5, 2, 1, 7, 3, 4, 7], 3],
            [[1, 2, 4, 1, 2, 5, 1, 2, 6], 3],
        ],
        hidden=[
            [[0], 1],
            [[5], 1],
            [[1, 1], 1],
            [[1, 2], 1],
            [[1, 1, 1, 1], 2],
            [[1, 2, 3, 4], 2],
            [[7, 7, 7, 7, 7, 7], 3],
            [[0, 1, 2, 3, 4, 5], 3],
        ],
    ),
    make(
        pid=1889,
        title="好子数组的最大分数",
        tags=["数组", "双指针", "单调栈"],
        description="""给定整数数组 nums 和下标 k。
子数组的分数定义为：子数组中的最小值乘以子数组的长度。
好子数组是包含下标 k 的连续子数组。
返回所有好子数组的分数最大值。
数组长度不超过 10^5，元素均为正整数。""",
        function="maximumGoodSubarrayScore",
        params=[("nums", "int[]"), ("k", "int")],
        returns="int",
        solver=maximum_good_subarray_score,
        public=[
            [[1, 4, 3, 7, 4, 5], 3],
            [[5, 5, 4, 5, 4, 1, 1, 1], 0],
            [[1, 1, 1, 1], 2],
        ],
        hidden=[
            [[1], 0],
            [[10], 0],
            [[2, 2, 2], 1],
            [[3, 1, 4, 1, 5], 2],
            [[1, 2, 3, 4, 5], 4],
            [[5, 4, 3, 2, 1], 0],
            [[2, 5, 2, 5, 2], 2],
        ],
    ),
    make(
        pid=1890,
        title="统计异或值在范围内的数对有多少",
        tags=["数组", "位运算", "字典树"],
        description="""给定整数数组 nums 以及整数 low 和 high。
统计满足 i < j 且 low <= (nums[i] 异或 nums[j]) <= high 的下标对数量。
nums 中元素、low、high 均为非负整数且小于 2^30。
数组长度不超过 2 * 10^4。""",
        function="countXorPairsInRange",
        params=[("nums", "int[]"), ("low", "int"), ("high", "int")],
        returns="int",
        solver=count_xor_pairs_in_range,
        public=[
            [[1, 4, 2, 7], 2, 6],
            [[1, 2, 3], 0, 3],
            [[5, 5, 5, 5], 0, 0],
        ],
        hidden=[
            [[1, 2], 0, 10],
            [[0], 0, 100],
            [[1, 2, 3, 4, 5], 3, 9],
            [[7, 7, 7], 0, 0],
            [[10, 20, 30], 10, 20],
            [[0, 1, 2, 3, 4], 0, 7],
        ],
    ),
    make(
        pid=1891,
        title="用三种不同颜色为网格涂色",
        tags=["动态规划", "状态压缩", "矩阵"],
        description="""给定 m 和 n，表示一个 m 行 n 列的网格。
用三种颜色给每个格子涂色，要求任意两个相邻格子（上下或左右）颜色不同。
返回合法的涂色方案数，答案对 10^9 + 7 取模。
1 <= m <= 5，1 <= n <= 1000。""",
        function="colorGridThreeColors",
        params=[("m", "int"), ("n", "int")],
        returns="int",
        solver=color_grid_three_colors,
        public=[
            [1, 1],
            [1, 2],
            [5, 5],
        ],
        hidden=[
            [1, 3],
            [2, 1],
            [2, 2],
            [3, 2],
            [4, 3],
            [2, 4],
        ],
    ),
    make(
        pid=1892,
        title="好子集的数目",
        tags=["数组", "动态规划", "状态压缩", "数学"],
        description="""给定整数数组 nums，其中每个元素在 1 到 30 之间。
如果一个非空子集的元素乘积可以表示为若干个互不相同的质数的乘积，
则称该子集是好的。
注意同一个数值出现在不同下标上视为不同的元素。
返回好子集的数量，答案对 10^9 + 7 取模。
数组长度不超过 10^5。""",
        function="numberOfGoodSubsets",
        params=[("nums", "int[]")],
        returns="int",
        solver=number_of_good_subsets,
        public=[
            [[1, 2, 3, 4]],
            [[4, 2, 3, 15]],
            [[1, 1, 1]],
            [[2, 3, 5]],
        ],
        hidden=[
            [[1]],
            [[2]],
            [[4]],
            [[1, 1, 2, 3, 3]],
            [[6, 10, 15]],
            [[2, 2, 3]],
            [[1, 1, 1, 1, 1, 1]],
            [[30, 30]],
        ],
    ),
    make(
        pid=1893,
        title="数组的最大公因数排序",
        tags=["数组", "并查集", "数论", "排序"],
        description="""给定整数数组 nums。
可以重复执行以下操作：选择两个下标 i 和 j，
如果 nums[i] 与 nums[j] 的最大公因数大于 1，就交换这两个元素。
判断能否通过若干次操作把数组变成非递减顺序。
数组长度不超过 10^5。""",
        function="gcdSortPossible",
        params=[("nums", "int[]")],
        returns="bool",
        solver=gcd_sort_possible,
        public=[
            [[7, 21, 3]],
            [[5, 2, 3, 1]],
            [[10, 5, 9, 3, 15]],
            [[2, 4, 6, 8]],
        ],
        hidden=[
            [[1]],
            [[2, 1]],
            [[2, 2]],
            [[3, 5, 7]],
            [[6, 2, 3]],
            [[12, 3, 4]],
            [[2, 3, 6, 9]],
        ],
    ),
    make(
        pid=1894,
        title="每棵子树内缺失的最小基因值",
        tags=["树", "深度优先搜索", "并查集"],
        description="""给定一棵有 n 个节点的树，根为节点 0。
parents[i] 表示节点 i 的父节点，parents[0] = -1。
nums[i] 是节点 i 的基因值，所有基因值互不相同，且都在 0 到 n-1 之间。
对每个节点 i，考虑以 i 为根的子树中所有节点的基因值，
求其中缺失的最小非负整数（即 mex）。
返回长度为 n 的数组 answer，answer[i] 是节点 i 对应子树的答案，按节点编号 0 到 n-1 排列。
节点数不超过 10^5。""",
        function="smallestMissingGeneticValues",
        params=[("parents", "int[]"), ("nums", "int[]")],
        returns="int[]",
        solver=smallest_missing_genetic_values,
        public=[
            [[-1, 0, 0], [0, 1, 2]],
            [[-1, 0, 0, 2], [0, 2, 1, 3]],
            [[-1, 0, 1, 2], [2, 1, 0, 3]],
        ],
        hidden=[
            [[-1], [0]],
            [[-1, 0], [1, 0]],
            [[-1, 0], [0, 1]],
            [[-1, 0, 1, 1, 2, 2, 3], [0, 1, 2, 3, 4, 5, 6]],
            [[-1, 0, 1, 2, 3], [3, 1, 0, 2, 4]],
            [[-1, 0, 0, 1, 1, 2, 2], [1, 0, 2, 3, 4, 5, 6]],
        ],
    ),
    make(
        pid=1895,
        title="使数组连续的最少操作数",
        tags=["数组", "排序", "滑动窗口"],
        description="""给定整数数组 nums。
一次操作可以把数组中任意一个元素替换成任意整数。
要求操作后数组中所有元素互不相同，并且排序后相邻元素之差都等于 1，
也就是这些元素恰好构成一段连续整数。
返回最少操作次数。
数组长度不超过 10^5。""",
        function="minimumOperationsToMakeContinuous",
        params=[("nums", "int[]")],
        returns="int",
        solver=minimum_operations_to_make_continuous,
        public=[
            [[4, 2, 5, 3]],
            [[1, 2, 3, 5, 6]],
            [[1, 10, 100, 1000]],
            [[1, 1, 1, 1]],
        ],
        hidden=[
            [[1]],
            [[2, 3, 4, 5, 6]],
            [[10, 1, 5, 7]],
            [[1, 2, 3, 4, 5, 6, 7, 8, 9, 10]],
            [[100, 1, 1, 1]],
            [[1, 1000000000]],
        ],
    ),
    make(
        pid=1896,
        title="将数组分成两个数组并最小化数组和的差",
        tags=["数组", "二分查找", "折半枚举"],
        description="""给定一个长度为偶数 2n 的整数数组 nums。
把数组中的每个元素分到两个长度均为 n 的数组之一，
求两个数组元素和的差的绝对值的最小值。
数组长度不超过 30。""",
        function="minimumSumDifferencePartition",
        params=[("nums", "int[]")],
        returns="int",
        solver=minimum_sum_difference_partition,
        public=[
            [[3, 9, 7, 3]],
            [[4, 3, 2, 1]],
            [[5, 2, 4, 6]],
            [[1, 2, 3, 4, 5, 6]],
        ],
        hidden=[
            [[2, 2]],
            [[1, 1, 1, 1]],
            [[10, 8, 7, 6, 5, 4]],
            [[1, 100, 2, 99]],
            [[3, 3, 3, 3, 3, 3]],
            [[100000, 1, 2, 3]],
        ],
    ),
    make(
        pid=1897,
        title="摘水果",
        tags=["数组", "二分查找", "滑动窗口"],
        description="""给定水果位置数组 fruits，其中 fruits[i] = [position_i, amount_i]，
表示位置 position_i 上有 amount_i 个水果，所有位置互不相同。
从 startPos 出发，最多走 k 步，每步移动一个单位距离。
经过某个位置时可以摘走该位置上的全部水果，求最多能摘到的水果数量。
fruits 长度不超过 10^5，位置、amount、k 均为非负整数。""",
        function="maximumFruitsHarvested",
        params=[("fruits", "int[][]"), ("startPos", "int"), ("k", "int")],
        returns="int",
        solver=maximum_fruits_harvested,
        public=[
            [[[2, 8], [6, 3], [8, 6]], 5, 4],
            [[[0, 9], [4, 1], [5, 7], [6, 2], [7, 4], [10, 9]], 5, 4],
            [[[1, 1], [2, 1]], 0, 3],
        ],
        hidden=[
            [[[0, 5]], 0, 0],
            [[[3, 2]], 0, 1],
            [[[1, 2], [3, 4], [5, 6]], 4, 2],
            [[[0, 1], [1, 1], [2, 1], [3, 1]], 2, 2],
            [[[0, 100], [10, 1]], 5, 4],
            [[[2, 3], [4, 1], [6, 4], [8, 2]], 5, 6],
        ],
    ),
    make(
        pid=1898,
        title="数组的最大与和",
        tags=["数组", "动态规划", "状态压缩", "位运算"],
        description="""给定长度为 n 的整数数组 nums 和整数 numSlots。
有 numSlots 个槽位，编号为 1 到 numSlots，每个槽位最多容纳 2 个数字。
需要把 nums 中的每个数字都放进某个槽位。
一个数字 x 放进编号为 j 的槽位会获得 x 与 j 按位与的分数。
求所有数字获得的分数总和的最大值。
n 不超过 2 * numSlots，numSlots 不超过 9。""",
        function="maximumAndSum",
        params=[("nums", "int[]"), ("numSlots", "int")],
        returns="int",
        solver=maximum_and_sum,
        public=[
            [[1, 2, 3, 4, 5, 6], 3],
            [[1, 3, 10, 4, 7, 1], 9],
            [[1, 1], 1],
        ],
        hidden=[
            [[1], 1],
            [[2], 1],
            [[1, 2], 1],
            [[10, 10, 10, 10], 2],
            [[3, 5, 7], 3],
            [[1, 2, 3, 4], 2],
            [[8, 7, 6, 5, 4, 3, 2, 1], 4],
        ],
    ),
    make(
        pid=1899,
        title="从栈中取出 K 个硬币的最大面值和",
        tags=["数组", "动态规划", "前缀和"],
        description="""给定 n 个栈，用二维数组 piles 表示，piles[i] 从栈顶到栈底列出第 i 个栈中的硬币面值。
每次可以从任意一个非空栈的栈顶取走一枚硬币。
一共恰好取走 k 枚硬币，求取走的硬币面值之和的最大值。
所有栈的硬币总数不少于 k，k 不超过 2000。""",
        function="maximumCoinsFromPiles",
        params=[("piles", "int[][]"), ("k", "int")],
        returns="int",
        solver=maximum_coins_from_piles,
        public=[
            [[[1, 100, 3], [7, 8, 9]], 2],
            [[[100], [100], [100], [100], [100], [100], [1, 1, 1, 1, 1, 1, 700]], 7],
            [[[1, 2], [3, 4]], 3],
        ],
        hidden=[
            [[[5]], 1],
            [[[1], [2], [3], [4]], 2],
            [[[10, 10, 10], [10, 10, 10]], 4],
            [[[1, 1000, 1], [2, 2, 2]], 2],
            [[[9, 8, 7], [6, 5, 4], [3, 2, 1]], 6],
            [[[1, 1, 1, 1, 1]], 3],
        ],
    ),
]
