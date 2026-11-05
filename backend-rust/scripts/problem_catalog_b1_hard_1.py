"""1460-1479：批量第一批困难题（20 道）。"""

from __future__ import annotations

import bisect
import heapq
from collections import Counter, deque
from functools import lru_cache, partial

from problem_seed_common import make_problem, tree_from_list

make = partial(make_problem, difficulty="hard")


def max_submatrix_sum(matrix: list[list[int]]) -> int:
    rows, columns = len(matrix), len(matrix[0])
    best = -10**9
    for top in range(rows):
        row_sum = [0] * columns
        for bottom in range(top, rows):
            for column in range(columns):
                row_sum[column] += matrix[bottom][column]
            current = best_here = row_sum[0]
            for value in row_sum[1:]:
                current = max(value, current + value)
                best_here = max(best_here, current)
            best = max(best, best_here)
    return best


def shortest_palindrome(s: str) -> str:
    if not s:
        return s
    combined = s + "#" + s[::-1]
    lps = [0] * len(combined)
    for index in range(1, len(combined)):
        border = lps[index - 1]
        while border and combined[index] != combined[border]:
            border = lps[border - 1]
        if combined[index] == combined[border]:
            border += 1
        lps[index] = border
    return s[lps[-1] :][::-1] + s


def can_cross(stones: list[int]) -> bool:
    index = {stone: position for position, stone in enumerate(stones)}

    @lru_cache(None)
    def dfs(position: int, jump: int) -> bool:
        if position == len(stones) - 1:
            return True
        for step in (jump - 1, jump, jump + 1):
            if step > 0 and stones[position] + step in index:
                if dfs(index[stones[position] + step], step):
                    return True
        return False

    return dfs(0, 0)


def median_sliding_window(nums: list[int], k: int) -> list[float]:
    window: list[int] = []
    result: list[float] = []
    for index, value in enumerate(nums):
        bisect.insort(window, value)
        if len(window) > k:
            window.pop(bisect.bisect_left(window, nums[index - k]))
        if len(window) == k:
            if k % 2:
                result.append(float(window[k // 2]))
            else:
                result.append((window[k // 2 - 1] + window[k // 2]) / 2.0)
    return result


def min_window_subsequence(s1: str, s2: str) -> int:
    positions: dict[str, list[int]] = {}
    for index, character in enumerate(s1):
        positions.setdefault(character, []).append(index)
    best = 10**9
    for start, character in enumerate(s1):
        if character != s2[0]:
            continue
        position = start
        for target in s2[1:]:
            candidates = positions.get(target, [])
            next_index = bisect.bisect_right(candidates, position)
            if next_index == len(candidates):
                position = -1
                break
            position = candidates[next_index]
        if position != -1:
            best = min(best, position - start + 1)
    return best if best < 10**9 else -1


def super_egg_drop(eggs: int, floors: int) -> int:
    dp = [[0] * (eggs + 1) for _ in range(floors + 1)]
    moves = 0
    while dp[moves][eggs] < floors:
        moves += 1
        for egg in range(1, eggs + 1):
            dp[moves][egg] = dp[moves - 1][egg - 1] + dp[moves - 1][egg] + 1
    return moves


def min_cut(s: str) -> int:
    size = len(s)
    if not size:
        return 0
    palindrome = [[False] * size for _ in range(size)]
    for right in range(size):
        for left in range(right + 1):
            if s[left] == s[right] and (right - left <= 2 or palindrome[left + 1][right - 1]):
                palindrome[left][right] = True
    dp = [0] * size
    for index in range(size):
        if palindrome[0][index]:
            dp[index] = 0
            continue
        dp[index] = index
        for split in range(index):
            if palindrome[split + 1][index]:
                dp[index] = min(dp[index], dp[split] + 1)
    return dp[size - 1]


def remove_invalid_parentheses(s: str) -> list[str]:
    def valid(text: str) -> bool:
        balance = 0
        for character in text:
            if character == "(":
                balance += 1
            elif character == ")":
                balance -= 1
                if balance < 0:
                    return False
        return balance == 0

    queue = deque([s])
    visited = {s}
    found = False
    result: set[str] = set()
    while queue:
        current = queue.popleft()
        if valid(current):
            found = True
            result.add(current)
        if found:
            continue
        for index in range(len(current)):
            if current[index] not in "()":
                continue
            next_text = current[:index] + current[index + 1 :]
            if next_text not in visited:
                visited.add(next_text)
                queue.append(next_text)
    return sorted(result)


def max_number(nums1: list[int], nums2: list[int], k: int) -> list[int]:
    def pick(nums: list[int], count: int) -> list[int]:
        drop = len(nums) - count
        stack: list[int] = []
        for value in nums:
            while drop and stack and stack[-1] < value:
                stack.pop()
                drop -= 1
            stack.append(value)
        return stack[:count]

    def merge(first: list[int], second: list[int]) -> list[int]:
        result: list[int] = []
        left = right = 0
        while left < len(first) or right < len(second):
            if right == len(second) or (
                left < len(first) and first[left:] > second[right:]
            ):
                result.append(first[left])
                left += 1
            else:
                result.append(second[right])
                right += 1
        return result

    best = [0] * k
    start = max(0, k - len(nums2))
    end = min(k, len(nums1))
    for take in range(start, end + 1):
        candidate = merge(pick(nums1, take), pick(nums2, k - take))
        if candidate > best:
            best = candidate
    return best


def check_valid_string(s: str) -> bool:
    low = high = 0
    for character in s:
        if character == "(":
            low += 1
            high += 1
        elif character == ")":
            low = max(low - 1, 0)
            high -= 1
        else:
            low = max(low - 1, 0)
            high += 1
        if high < 0:
            return False
    return low == 0


def longest_substring(s: str, k: int) -> int:
    if k <= 1:
        return len(s)

    def dfs(text: str) -> int:
        if len(text) < k:
            return 0
        counts = Counter(text)
        for character, count in counts.items():
            if count < k:
                return max(dfs(part) for part in text.split(character))
        return len(text)

    return dfs(s)


def longest_zigzag(root: list[int | None]) -> int:
    node = tree_from_list(root)
    best = 0

    def dfs(current, went_left: bool, length: int) -> None:
        nonlocal best
        if current is None:
            return
        best = max(best, length)
        if went_left:
            dfs(current.right, False, length + 1)
            dfs(current.left, True, 1)
        else:
            dfs(current.left, True, length + 1)
            dfs(current.right, False, 1)

    dfs(node, False, 0)
    return best


def find_words(board: list[list[str]], words: list[str]) -> list[str]:
    rows, columns = len(board), len(board[0])
    word_set = set(words)
    prefixes: set[str] = set()
    for word in words:
        for length in range(1, len(word) + 1):
            prefixes.add(word[:length])
    found: set[str] = set()

    def dfs(row: int, column: int, path: str, visited: set[tuple[int, int]]) -> None:
        if path not in prefixes:
            return
        if path in word_set:
            found.add(path)
        for delta_row, delta_column in ((1, 0), (-1, 0), (0, 1), (0, -1)):
            next_row = row + delta_row
            next_column = column + delta_column
            if (
                0 <= next_row < rows
                and 0 <= next_column < columns
                and (next_row, next_column) not in visited
            ):
                visited.add((next_row, next_column))
                dfs(next_row, next_column, path + board[next_row][next_column], visited)
                visited.remove((next_row, next_column))

    for row in range(rows):
        for column in range(columns):
            dfs(row, column, board[row][column], {(row, column)})
    return sorted(found)


def swim_in_water(grid: list[list[int]]) -> int:
    size = len(grid)
    infinity = 10**9
    distance = [[infinity] * size for _ in range(size)]
    distance[0][0] = grid[0][0]
    heap = [(grid[0][0], 0, 0)]
    while heap:
        time, row, column = heapq.heappop(heap)
        if time > distance[row][column]:
            continue
        if row == size - 1 and column == size - 1:
            return time
        for delta_row, delta_column in ((1, 0), (-1, 0), (0, 1), (0, -1)):
            next_row = row + delta_row
            next_column = column + delta_column
            if 0 <= next_row < size and 0 <= next_column < size:
                next_time = max(time, grid[next_row][next_column])
                if next_time < distance[next_row][next_column]:
                    distance[next_row][next_column] = next_time
                    heapq.heappush(heap, (next_time, next_row, next_column))
    return -1


def count_range_sum(nums: list[int], lower: int, upper: int) -> int:
    prefix = [0]
    for value in nums:
        prefix.append(prefix[-1] + value)
    total = 0

    def sort(values: list[int]) -> list[int]:
        nonlocal total
        if len(values) <= 1:
            return values
        middle = len(values) // 2
        left = sort(values[:middle])
        right = sort(values[middle:])
        low_index = high_index = 0
        for value in left:
            while low_index < len(right) and right[low_index] < value + lower:
                low_index += 1
            while high_index < len(right) and right[high_index] <= value + upper:
                high_index += 1
            total += high_index - low_index
        merged: list[int] = []
        left_index = right_index = 0
        while left_index < len(left) and right_index < len(right):
            if left[left_index] <= right[right_index]:
                merged.append(left[left_index])
                left_index += 1
            else:
                merged.append(right[right_index])
                right_index += 1
        merged.extend(left[left_index:])
        merged.extend(right[right_index:])
        return merged

    sort(prefix)
    return total


def palindrome_pairs(words: list[str]) -> list[list[int]]:
    index = {word: position for position, word in enumerate(words)}
    pairs: set[tuple[int, int]] = set()
    for position, word in enumerate(words):
        for cut in range(len(word) + 1):
            prefix, suffix = word[:cut], word[cut:]
            if prefix == prefix[::-1]:
                other = index.get(suffix[::-1])
                if other is not None and other != position:
                    pairs.add((other, position))
            if suffix == suffix[::-1]:
                other = index.get(prefix[::-1])
                if other is not None and other != position:
                    pairs.add((position, other))
    return [list(pair) for pair in sorted(pairs)]


def min_jumps_game_iv(arr: list[int]) -> int:
    size = len(arr)
    if size == 1:
        return 0
    groups: dict[int, list[int]] = {}
    for index, value in enumerate(arr):
        groups.setdefault(value, []).append(index)
    queue = deque([(0, 0)])
    visited = [False] * size
    visited[0] = True
    while queue:
        index, steps = queue.popleft()
        neighbors = []
        if index - 1 >= 0:
            neighbors.append(index - 1)
        if index + 1 < size:
            neighbors.append(index + 1)
        neighbors.extend(groups.get(arr[index], []))
        groups[arr[index]] = []
        for next_index in neighbors:
            if next_index == size - 1:
                return steps + 1
            if not visited[next_index]:
                visited[next_index] = True
                queue.append((next_index, steps + 1))
    return -1


def minimum_time(n: int, relations: list[list[int]], time: list[int]) -> int:
    graph: list[list[int]] = [[] for _ in range(n + 1)]
    indegree = [0] * (n + 1)
    for previous, course in relations:
        graph[previous].append(course)
        indegree[course] += 1
    distance = [0] * (n + 1)
    queue = deque()
    for course in range(1, n + 1):
        if indegree[course] == 0:
            distance[course] = time[course - 1]
            queue.append(course)
    while queue:
        course = queue.popleft()
        for next_course in graph[course]:
            distance[next_course] = max(
                distance[next_course], distance[course] + time[next_course - 1]
            )
            indegree[next_course] -= 1
            if indegree[next_course] == 0:
                queue.append(next_course)
    return max(distance)


def reverse_k_group(head: list[int], k: int) -> list[int]:
    result: list[int] = []
    for start in range(0, len(head), k):
        group = head[start : start + k]
        if len(group) == k:
            result.extend(group[::-1])
        else:
            result.extend(group)
    return result


def largest_multiple_of_three(digits: list[int]) -> str:
    counts = Counter(digits)
    total = sum(digits)

    def drop_one(order: tuple[int, ...]) -> bool:
        for digit in order:
            if counts[digit]:
                counts[digit] -= 1
                return True
        return False

    def drop_two(order: tuple[int, ...]) -> None:
        removed = 0
        for digit in order:
            while counts[digit] and removed < 2:
                counts[digit] -= 1
                removed += 1
            if removed == 2:
                return

    remainder = total % 3
    if remainder == 1:
        if not drop_one((1, 4, 7)):
            drop_two((2, 5, 8))
    elif remainder == 2:
        if not drop_one((2, 5, 8)):
            drop_two((1, 4, 7))
    result: list[str] = []
    for digit in range(9, -1, -1):
        result.extend([str(digit)] * counts[digit])
    text = "".join(result).lstrip("0")
    return text if text else "0"


PROBLEMS = [
    make(
        pid=1460,
        title="最大子矩阵",
        tags=["数组", "矩阵", "动态规划", "前缀和"],
        description="""给定一个整数矩阵 matrix，返回其中和最大的子矩阵的元素和。""",
        function="maxSubMatrixSum",
        params=[("matrix", "int[][]")],
        returns="int",
        solver=max_submatrix_sum,
        public=[
            [[[1, 2, -1], [-3, 4, 5], [1, -2, 3]]],
            [[[1, 2], [3, 4]]],
            [[[-1]]],
        ],
        hidden=[
            [[[1]]],
            [[[-1, -2], [-3, -4]]],
            [[[1, 2], [3, 4], [5, 6]]],
            [[[0, 0], [0, 0]]],
        ],
    ),
    make(
        pid=1461,
        title="最短回文串",
        tags=["字符串", "字符串匹配", "哈希函数"],
        description="""给定字符串 s，通过在 s 前面添加字符，将其变成回文串。返回能得到的最短回文串。""",
        function="shortestPalindrome",
        params=[("s", "string")],
        returns="string",
        solver=shortest_palindrome,
        public=[["aacecaaa"], ["abcd"], ["a"]],
        hidden=[[""], ["aa"], ["aba"], ["abab"]],
    ),
    make(
        pid=1462,
        title="青蛙过河",
        tags=["数组", "动态规划", "记忆化搜索"],
        description="""一条河被分成若干单元，石头位置由升序数组 stones 给出。
青蛙从第一块石头出发，每次跳跃的距离必须是上一次跳跃距离减一、不变或加一。判断能否到达最后一块石头。""",
        function="canCross",
        params=[("stones", "int[]")],
        returns="bool",
        solver=can_cross,
        public=[
            [[0, 1, 3, 5, 6, 8, 12, 17]],
            [[0, 1, 2, 3, 4, 8, 9, 11]],
            [[0, 2]],
        ],
        hidden=[[[0]], [[0, 1]], [[0, 1, 2, 3]], [[0, 1, 3, 6, 10, 15, 21]]],
    ),
    make(
        pid=1463,
        title="滑动窗口中位数",
        tags=["数组", "哈希表", "滑动窗口", "堆"],
        description="""给定整数数组 nums 和窗口大小 k，窗口从最左侧滑动到最右侧。
返回每个窗口的中位数组成的数组，答案与标准答案误差在 1e-6 以内即视为正确。""",
        function="medianSlidingWindow",
        params=[("nums", "int[]"), ("k", "int")],
        returns="double[]",
        solver=median_sliding_window,
        compare={"mode": "double"},
        public=[
            [[1, 3, -1, -3, 5, 3, 6, 7], 3],
            [[1, 2], 1],
            [[1, 2, 3, 4], 2],
        ],
        hidden=[[[1], 1], [[1, 2], 2], [[5, 2, 4], 3], [[1, 3, 2, 4, 5], 3]],
    ),
    make(
        pid=1464,
        title="最小窗口子序列",
        tags=["字符串", "动态规划", "滑动窗口"],
        description="""给定字符串 s1 和 s2，返回 s1 中最短的子串，使 s2 是这个子串的子序列。
不存在这样的子串返回 -1。""",
        function="minWindowSubsequence",
        params=[("s1", "string"), ("s2", "string")],
        returns="int",
        solver=min_window_subsequence,
        public=[
            ["abcdebdde", "bde"],
            ["jmeqksfrsdcmsiwvaovxtkwm", "k"],
            ["abc", "abc"],
        ],
        hidden=[["abc", "d"], ["ab", "a"], ["ab", "b"], ["aaaa", "aa"]],
    ),
    make(
        pid=1465,
        title="鸡蛋掉落",
        tags=["数学", "二分查找", "动态规划"],
        description="""有 k 枚相同的鸡蛋和一栋 n 层楼。已知存在楼层 f，从 f 及以下扔鸡蛋不会碎。
每次可以取一枚鸡蛋从任意楼层扔下，返回确定 f 所需的最少操作次数。""",
        function="superEggDrop",
        params=[("k", "int"), ("n", "int")],
        returns="int",
        solver=super_egg_drop,
        public=[[1, 2], [2, 6], [3, 14]],
        hidden=[[1, 1], [2, 1], [2, 10], [3, 100]],
    ),
    make(
        pid=1466,
        title="分割回文串 II",
        tags=["字符串", "动态规划"],
        description="""给定字符串 s，返回将 s 分割成若干回文子串所需的最少分割次数。""",
        function="minCut",
        params=[("s", "string")],
        returns="int",
        solver=min_cut,
        public=[["aab"], ["a"], ["ab"]],
        hidden=[[""], ["aa"], ["abc"], ["abba"]],
    ),
    make(
        pid=1467,
        title="删除无效的括号",
        tags=["广度优先搜索", "字符串", "回溯"],
        description="""给定只含字母和括号的字符串 s，删除最少数量的无效括号，使字符串有效。
返回所有可能的结果，按字典序升序排列。""",
        function="removeInvalidParentheses",
        params=[("s", "string")],
        returns="string[]",
        solver=remove_invalid_parentheses,
        public=[["()())()"], ["(a)())()"], [")("]],
        hidden=[[""], ["()"], ["(("], ["))"], ["(a)(b)"]],
    ),
    make(
        pid=1468,
        title="拼接最大数",
        tags=["栈", "贪心", "数组", "单调栈"],
        description="""给定两个整数数组 nums1 和 nums2，以及整数 k。
从两个数组中按原顺序共选出 k 个数字拼接，返回能得到的最大的数。""",
        function="maxNumber",
        params=[("nums1", "int[]"), ("nums2", "int[]"), ("k", "int")],
        returns="int[]",
        solver=max_number,
        public=[
            [[3, 4, 6, 5], [9, 1, 2, 5, 8, 3], 5],
            [[6, 7], [6, 0, 4], 5],
            [[3, 9], [8, 9], 3],
        ],
        hidden=[
            [[1], [2], 1],
            [[1], [2], 2],
            [[1, 2], [3, 4], 2],
            [[5, 6], [7, 8], 4],
        ],
    ),
    make(
        pid=1469,
        title="有效的括号字符串",
        tags=["栈", "字符串", "贪心", "动态规划"],
        description="""给定只含 '('、')' 和 '*' 的字符串 s，'*' 可以视为 '('、')' 或空字符。
判断 s 是否为有效括号字符串。""",
        function="checkValidString",
        params=[("s", "string")],
        returns="bool",
        solver=check_valid_string,
        public=[["()"], ["(*)"], ["(*))"]],
        hidden=[[""], ["*"], ["("], [")"], ["(*"]],
    ),
    make(
        pid=1470,
        title="至少有 K 个重复字符的最长子串",
        tags=["哈希表", "字符串", "分治", "滑动窗口"],
        description="""给定字符串 s 和整数 k，返回 s 中最长的子串长度，要求子串中每个字符出现次数都不少于 k。
不存在这样的子串返回 0。""",
        function="longestSubstringK",
        params=[("s", "string"), ("k", "int")],
        returns="int",
        solver=longest_substring,
        public=[["aaabb", 3], ["ababbc", 2], ["abc", 2]],
        hidden=[["a", 1], ["aa", 2], ["ab", 2], ["aaabbb", 3]],
    ),
    make(
        pid=1471,
        title="二叉树中的最长交错路径",
        tags=["树", "深度优先搜索", "动态规划", "二叉树"],
        description="""给定二叉树的根节点 root，返回树中最长交错路径的长度。
交错路径指从某节点出发，先向左再向右、再向左，如此交替的路径。长度按经过的边数计算。""",
        function="longestZigZag",
        params=[("root", "TreeNode")],
        returns="int",
        solver=longest_zigzag,
        public=[
            [[1, None, 1, 1, 1, None, None, 1, 1, None, 1, None, None, None, 1]],
            [[1, 1, 1]],
            [[1]],
        ],
        hidden=[
            [[1, None, 1]],
            [[1, 1, None, 1]],
            [[1, None, 1, None, 1]],
        ],
    ),
    make(
        pid=1472,
        title="单词搜索 II",
        tags=["字典树", "数组", "字符串", "回溯", "矩阵"],
        description="""给定 m x n 字符矩阵 board 和单词列表 words，返回所有同时在矩阵中的单词。
单词必须由相邻格子的字母按顺序连接，同一格子不能重复使用。结果按字典序升序排列。""",
        function="findWords",
        params=[("board", "string[][]"), ("words", "string[]")],
        returns="string[]",
        solver=find_words,
        public=[
            [
                [["o", "a", "a", "n"], ["e", "t", "a", "e"], ["i", "h", "k", "r"], ["i", "f", "l", "v"]],
                ["oath", "pea", "eat", "rain"],
            ],
            [[["a", "b"], ["c", "d"]], ["abcb"]],
        ],
        hidden=[
            [[["a"]], ["a"]],
            [[["a", "b"], ["c", "d"]], ["ab", "cd", "ac", "bd"]],
        ],
    ),
    make(
        pid=1473,
        title="水位上升的泳池中游泳",
        tags=["深度优先搜索", "广度优先搜索", "并查集", "堆", "矩阵"],
        description="""给定 n x n 的矩阵 grid，grid[i][j] 表示该位置的高度。
从左上角出发，当水位达到时间 t 时，可以移动到高度不超过 t 的相邻格子。返回到达右下角的最早时间。""",
        function="swimInWater",
        params=[("grid", "int[][]")],
        returns="int",
        solver=swim_in_water,
        public=[
            [[[0, 2], [1, 3]]],
            [
                [
                    [0, 1, 2, 3, 4],
                    [24, 23, 22, 21, 5],
                    [12, 13, 14, 15, 16],
                    [11, 17, 18, 19, 20],
                    [10, 9, 8, 7, 6],
                ]
            ],
            [[[0]]],
        ],
        hidden=[[[[0, 1], [2, 3]]], [[[5]]], [[[0, 1], [3, 2]]]],
    ),
    make(
        pid=1474,
        title="区间和的个数",
        tags=["数组", "二分查找", "分治", "归并排序", "树状数组"],
        description="""给定整数数组 nums、整数 lower 和 upper，返回和位于 [lower, upper] 之间的子数组个数。""",
        function="countRangeSum",
        params=[("nums", "int[]"), ("lower", "int"), ("upper", "int")],
        returns="int",
        solver=count_range_sum,
        public=[
            [[-2, 5, -1], -2, 2],
            [[0], 0, 0],
            [[1, 2, 3], 3, 6],
        ],
        hidden=[
            [[1], 0, 0],
            [[-1], -1, -1],
            [[1, -1], 0, 0],
            [[2, 1], 1, 3],
        ],
    ),
    make(
        pid=1475,
        title="回文对",
        tags=["字典树", "数组", "哈希表", "字符串"],
        description="""给定互不相同的字符串数组 words，返回所有下标对 (i, j)，使 words[i] + words[j] 是回文串。
结果按字典序升序排列。""",
        function="palindromePairs",
        params=[("words", "string[]")],
        returns="int[][]",
        solver=palindrome_pairs,
        public=[
            [["abcd", "dcba", "lls", "s", "sssll"]],
            [["bat", "tab", "cat"]],
            [["a", ""]],
        ],
        hidden=[[["a"]], [["", ""]], [["ab", "ba"]], [["abc", "cba", "bca"]]],
    ),
    make(
        pid=1476,
        title="跳跃游戏 IV",
        tags=["广度优先搜索", "数组", "哈希表"],
        description="""给定整数数组 arr，从下标 0 出发，每次可以移动到相邻下标，或跳到任意值与当前元素相同的位置。
返回到达最后一个下标的最少跳跃次数。""",
        function="minJumpsIV",
        params=[("arr", "int[]")],
        returns="int",
        solver=min_jumps_game_iv,
        public=[
            [[100, -23, -23, 404, 100, 23, 23, 23, 3, 404]],
            [[7]],
            [[7, 6, 9, 6, 9, 6, 9, 7]],
        ],
        hidden=[[[1, 2]], [[1, 1]], [[1, 2, 1]], [[1, 2, 3]]],
    ),
    make(
        pid=1477,
        title="并行课程 III",
        tags=["图", "拓扑排序", "动态规划"],
        description="""给定 n 门课程、先修关系 relations 和每门课程所需时间 time。
同一时间可以并行学习多门课程，返回完成所有课程的最短时间。""",
        function="minimumTime",
        params=[("n", "int"), ("relations", "int[][]"), ("time", "int[]")],
        returns="int",
        solver=minimum_time,
        public=[
            [3, [[1, 3], [2, 3]], [3, 2, 5]],
            [5, [[1, 5], [2, 5], [3, 5], [3, 4], [4, 5]], [1, 2, 3, 4, 5]],
            [1, [], [5]],
        ],
        hidden=[
            [2, [[1, 2]], [3, 4]],
            [2, [], [1, 2]],
            [3, [[1, 2], [2, 3]], [1, 2, 3]],
        ],
    ),
    make(
        pid=1478,
        title="K 个一组翻转链表",
        tags=["链表", "递归"],
        description="""给定链表头节点 head 和整数 k，每 k 个节点一组进行翻转。
如果最后剩余节点不足 k 个，则保持原顺序。返回翻转后的链表。""",
        function="reverseKGroup",
        params=[("head", "ListNode"), ("k", "int")],
        returns="ListNode",
        solver=reverse_k_group,
        public=[
            [[1, 2, 3, 4, 5], 2],
            [[1, 2, 3, 4, 5], 3],
            [[1], 1],
        ],
        hidden=[
            [[1, 2], 1],
            [[1, 2], 3],
            [[1, 2, 3], 1],
            [[1, 2, 3, 4], 2],
        ],
    ),
    make(
        pid=1479,
        title="形成三的最大倍数",
        tags=["贪心", "数组", "数学", "动态规划"],
        description="""给定整数数组 digits，重新排列其中的数字，组成 3 的倍数的最大整数。
结果以字符串形式返回；无法组成返回空字符串。""",
        function="largestMultipleOfThree",
        params=[("digits", "int[]")],
        returns="string",
        solver=largest_multiple_of_three,
        public=[
            [[8, 1, 9]],
            [[8, 6, 7, 1, 0]],
            [[1]],
        ],
        hidden=[
            [[0, 0, 0]],
            [[1, 1, 1]],
            [[1, 1, 1, 1]],
            [[9, 8, 7, 6, 5, 4, 3, 2, 1]],
        ],
    ),
]
