"""1180-1197：困难题（18 道）。"""

from __future__ import annotations

from bisect import bisect_left, insort
from collections import Counter, deque

from problem_seed_common import Problem

# ── 栈 / 队列 / 字符串 ──────────────────────────────────────────────


def largest_rectangle_area(heights: list[int]) -> int:
    stack: list[int] = []
    best = 0
    for index in range(len(heights) + 1):
        current = heights[index] if index < len(heights) else 0
        while stack and heights[stack[-1]] > current:
            height = heights[stack.pop()]
            width = index if not stack else index - stack[-1] - 1
            best = max(best, height * width)
        stack.append(index)
    return best


def max_sliding_window(nums: list[int], k: int) -> list[int]:
    candidates: deque[int] = deque()
    result: list[int] = []
    for index, value in enumerate(nums):
        while candidates and nums[candidates[-1]] <= value:
            candidates.pop()
        candidates.append(index)
        if candidates[0] <= index - k:
            candidates.popleft()
        if index >= k - 1:
            result.append(nums[candidates[0]])
    return result


def min_window(s: str, t: str) -> str:
    need = Counter(t)
    missing = len(t)
    left = 0
    best = (len(s) + 1, 0, 0)
    for right, character in enumerate(s):
        if need[character] > 0:
            missing -= 1
        need[character] -= 1
        if missing != 0:
            continue
        while need[s[left]] < 0:
            need[s[left]] += 1
            left += 1
        if right - left + 1 < best[0]:
            best = (right - left + 1, left, right + 1)
        need[s[left]] += 1
        missing += 1
        left += 1
    return s[best[1] : best[2]] if best[0] <= len(s) else ""


def is_match(s: str, p: str) -> bool:
    dp = [[False] * (len(p) + 1) for _ in range(len(s) + 1)]
    dp[0][0] = True
    for column in range(1, len(p) + 1):
        if p[column - 1] == "*":
            dp[0][column] = dp[0][column - 2]
    for row in range(1, len(s) + 1):
        for column in range(1, len(p) + 1):
            if p[column - 1] == "*":
                dp[row][column] = dp[row][column - 2] or (
                    dp[row - 1][column]
                    and (p[column - 2] == "." or p[column - 2] == s[row - 1])
                )
            elif p[column - 1] == "." or p[column - 1] == s[row - 1]:
                dp[row][column] = dp[row - 1][column - 1]
    return dp[-1][-1]


def is_wildcard_match(s: str, p: str) -> bool:
    dp = [[False] * (len(p) + 1) for _ in range(len(s) + 1)]
    dp[0][0] = True
    for column in range(1, len(p) + 1):
        if p[column - 1] == "*":
            dp[0][column] = dp[0][column - 1]
    for row in range(1, len(s) + 1):
        for column in range(1, len(p) + 1):
            if p[column - 1] == "*":
                dp[row][column] = dp[row - 1][column] or dp[row][column - 1]
            elif p[column - 1] == "?" or p[column - 1] == s[row - 1]:
                dp[row][column] = dp[row - 1][column - 1]
    return dp[-1][-1]


# ── 矩阵 / 图 ──────────────────────────────────────────────────────


def maximal_rectangle(matrix: list[list[int]]) -> int:
    columns = len(matrix[0])
    heights = [0] * columns
    best = 0
    for row in matrix:
        for index in range(columns):
            heights[index] = heights[index] + 1 if row[index] == 1 else 0
        best = max(best, largest_rectangle_area(heights))
    return best


def can_finish(num_courses: int, prerequisites: list[list[int]]) -> bool:
    graph: list[list[int]] = [[] for _ in range(num_courses)]
    indegree = [0] * num_courses
    for course, prerequisite in prerequisites:
        graph[prerequisite].append(course)
        indegree[course] += 1
    queue = deque(index for index in range(num_courses) if indegree[index] == 0)
    visited = 0
    while queue:
        current = queue.popleft()
        visited += 1
        for neighbor in graph[current]:
            indegree[neighbor] -= 1
            if indegree[neighbor] == 0:
                queue.append(neighbor)
    return visited == num_courses


def oranges_rotting(grid: list[list[int]]) -> int:
    grid = [row[:] for row in grid]
    rows, columns = len(grid), len(grid[0])
    queue: deque[tuple[int, int]] = deque()
    fresh = 0
    for row in range(rows):
        for column in range(columns):
            if grid[row][column] == 2:
                queue.append((row, column))
            elif grid[row][column] == 1:
                fresh += 1
    minutes = 0
    while queue and fresh:
        for _ in range(len(queue)):
            row, column = queue.popleft()
            for row_step, column_step in ((1, 0), (-1, 0), (0, 1), (0, -1)):
                next_row, next_column = row + row_step, column + column_step
                if (
                    0 <= next_row < rows
                    and 0 <= next_column < columns
                    and grid[next_row][next_column] == 1
                ):
                    grid[next_row][next_column] = 2
                    fresh -= 1
                    queue.append((next_row, next_column))
        minutes += 1
    return minutes if fresh == 0 else -1


def ladder_length(begin_word: str, end_word: str, word_list: list[str]) -> int:
    words = set(word_list)
    if end_word not in words:
        return 0
    patterns: dict[str, list[str]] = {}
    for word in words:
        for index in range(len(word)):
            patterns.setdefault(word[:index] + "*" + word[index + 1 :], []).append(word)
    queue = deque([(begin_word, 1)])
    visited = {begin_word}
    while queue:
        word, steps = queue.popleft()
        for index in range(len(word)):
            pattern = word[:index] + "*" + word[index + 1 :]
            for neighbor in patterns.get(pattern, []):
                if neighbor == end_word:
                    return steps + 1
                if neighbor not in visited:
                    visited.add(neighbor)
                    queue.append((neighbor, steps + 1))
    return 0


def max_coins(nums: list[int]) -> int:
    values = [1] + nums + [1]
    count = len(nums)
    dp = [[0] * (count + 2) for _ in range(count + 2)]
    for length in range(1, count + 1):
        for left in range(1, count - length + 2):
            right = left + length - 1
            for last in range(left, right + 1):
                dp[left][right] = max(
                    dp[left][right],
                    dp[left][last - 1]
                    + dp[last + 1][right]
                    + values[left - 1] * values[last] * values[right + 1],
                )
    return dp[1][count] if count else 0


def exist(board: list[list[str]], word: str) -> bool:
    rows, columns = len(board), len(board[0])

    def search(row: int, column: int, index: int) -> bool:
        if index == len(word):
            return True
        if not (0 <= row < rows and 0 <= column < columns) or board[row][column] != word[index]:
            return False
        saved = board[row][column]
        board[row][column] = "#"
        found = (
            search(row + 1, column, index + 1)
            or search(row - 1, column, index + 1)
            or search(row, column + 1, index + 1)
            or search(row, column - 1, index + 1)
        )
        board[row][column] = saved
        return found

    return any(
        search(row, column, 0) for row in range(rows) for column in range(columns)
    )


def total_n_queens(n: int) -> int:
    count = 0
    columns: set[int] = set()
    diagonal: set[int] = set()
    anti_diagonal: set[int] = set()

    def place(row: int) -> None:
        nonlocal count
        if row == n:
            count += 1
            return
        for column in range(n):
            if column in columns or row + column in diagonal or row - column in anti_diagonal:
                continue
            columns.add(column)
            diagonal.add(row + column)
            anti_diagonal.add(row - column)
            place(row + 1)
            columns.remove(column)
            diagonal.remove(row + column)
            anti_diagonal.remove(row - column)

    place(0)
    return count


# ── 动态规划 / 分治 ────────────────────────────────────────────────


def num_distinct(s: str, t: str) -> int:
    dp = [0] * (len(t) + 1)
    dp[0] = 1
    for character in s:
        for index in range(len(t), 0, -1):
            if t[index - 1] == character:
                dp[index] += dp[index - 1]
    return dp[-1]


def longest_palindrome_subseq(s: str) -> int:
    length = len(s)
    dp = [[0] * length for _ in range(length)]
    for index in range(length - 1, -1, -1):
        dp[index][index] = 1
        for end in range(index + 1, length):
            if s[index] == s[end]:
                dp[index][end] = dp[index + 1][end - 1] + 2
            else:
                dp[index][end] = max(dp[index + 1][end], dp[index][end - 1])
    return dp[0][length - 1] if length else 0


def count_smaller(nums: list[int]) -> list[int]:
    seen: list[int] = []
    result: list[int] = []
    for value in reversed(nums):
        position = bisect_left(seen, value)
        result.append(position)
        insort(seen, value)
    return result[::-1]


def reverse_pairs(nums: list[int]) -> int:
    def sort_count(values: list[int]) -> tuple[list[int], int]:
        if len(values) < 2:
            return values, 0
        middle = len(values) // 2
        left, left_count = sort_count(values[:middle])
        right, right_count = sort_count(values[middle:])
        count = left_count + right_count
        pointer = 0
        for value in left:
            while pointer < len(right) and value > 2 * right[pointer]:
                pointer += 1
            count += pointer
        return sorted(left + right), count

    return sort_count(nums)[1]


def longest_increasing_path(matrix: list[list[int]]) -> int:
    rows, columns = len(matrix), len(matrix[0])
    memo = [[0] * columns for _ in range(rows)]

    def walk(row: int, column: int) -> int:
        if memo[row][column]:
            return memo[row][column]
        best = 1
        for row_step, column_step in ((1, 0), (-1, 0), (0, 1), (0, -1)):
            next_row, next_column = row + row_step, column + column_step
            if (
                0 <= next_row < rows
                and 0 <= next_column < columns
                and matrix[next_row][next_column] > matrix[row][column]
            ):
                best = max(best, 1 + walk(next_row, next_column))
        memo[row][column] = best
        return best

    return max(walk(row, column) for row in range(rows) for column in range(columns))


def max_envelopes(envelopes: list[list[int]]) -> int:
    ordered = sorted(envelopes, key=lambda pair: (pair[0], -pair[1]))
    tails: list[int] = []
    for _, height in ordered:
        position = bisect_left(tails, height)
        if position == len(tails):
            tails.append(height)
        else:
            tails[position] = height
    return len(tails)


PROBLEMS = [
    Problem(
        pid=1180,
        title="柱状图中最大的矩形",
        difficulty="hard",
        tags=["栈", "数组", "单调栈"],
        description="""给定 n 个非负整数，用来表示柱状图中各个柱子的高度，每个柱子彼此相邻，且宽度为 1。
求在该柱状图中，能够勾勒出来的矩形的最大面积。

提示：
- 1 <= heights.length <= 10^5
- 0 <= heights[i] <= 10^4""",
        function="largestRectangleArea",
        params=[("heights", "int[]")],
        returns="int",
        solver=largest_rectangle_area,
        public=[[[2, 1, 5, 6, 2, 3]], [[2, 4]], [[1]], [[0]]],
        expected_public=[10, 4, 1, 0],
        hidden=[
            [[1, 1]], [[0, 1]], [[2, 1, 2]], [[3, 1, 3, 2, 2]],
            [[4, 2, 0, 3, 2, 5]], [[1, 2, 3, 4, 5]], [[5, 4, 3, 2, 1]],
        ],
    ),
    Problem(
        pid=1181,
        title="滑动窗口最大值",
        difficulty="hard",
        tags=["队列", "数组", "滑动窗口", "单调队列"],
        description="""给定一个整数数组 nums 和一个大小为 k 的滑动窗口，窗口从数组的最左侧移动到数组的最右侧。
窗口每次只向右移动一位，返回每个窗口中的最大值。

提示：
- 1 <= nums.length <= 10^5
- -10^4 <= nums[i] <= 10^4
- 1 <= k <= nums.length""",
        function="maxSlidingWindow",
        params=[("nums", "int[]"), ("k", "int")],
        returns="int[]",
        solver=max_sliding_window,
        public=[
            [[1, 3, -1, -3, 5, 3, 6, 7], 3],
            [[1], 1],
            [[1, -1], 1],
            [[4, 3, 2], 2],
        ],
        expected_public=[[3, 3, 5, 5, 6, 7], [1], [1, -1], [4, 3]],
        hidden=[
            [[1, 3, 1, 2, 0, 5], 3], [[9, 8, 7, 6, 5], 3], [[0, 0], 2],
            [[-1, -2, -3], 2], [[1, 2, 3, 4], 4], [[7, 2, 4], 2],
            [[5, 1, 2], 1],
        ],
    ),
    Problem(
        pid=1182,
        title="最小覆盖子串",
        difficulty="hard",
        tags=["字符串", "哈希表", "滑动窗口"],
        description="""给定两个字符串 s 和 t，返回 s 中涵盖 t 所有字符的最小子串。
如果 s 中不存在涵盖 t 所有字符的子串，返回空字符串 ""。
如果存在多个符合条件的子串，返回其中最靠左的一个。

提示：
- 1 <= s.length, t.length <= 10^5
- s 和 t 由英文字母组成""",
        function="minWindow",
        params=[("s", "string"), ("t", "string")],
        returns="string",
        solver=min_window,
        public=[
            ["ADOBECODEBANC", "ABC"],
            ["a", "a"],
            ["a", "aa"],
            ["aa", "aa"],
        ],
        expected_public=["BANC", "a", "", "aa"],
        hidden=[
            ["ab", "b"], ["abc", "c"], ["abc", "d"],
            ["aaflslflsldkalskaaa", "aaa"], ["cabwefgewcwaefgcf", "cae"],
            ["a", "b"], ["bba", "ab"], ["abcabc", "bc"],
        ],
    ),
    Problem(
        pid=1183,
        title="正则表达式匹配",
        difficulty="hard",
        tags=["字符串", "动态规划", "递归"],
        description="""给定一个字符串 s 和一个字符规律 p，实现支持 '.' 和 '*' 的正则表达式匹配。
'.' 匹配任意单个字符。
'*' 匹配零个或多个前面的那一个元素。
匹配必须覆盖整个字符串 s，而不是部分字符串。

提示：
- 1 <= s.length <= 20
- 1 <= p.length <= 20
- s 只包含小写英文字母
- p 只包含小写英文字母以及字符 '.' 和 '*'
- 保证每次出现字符 '*' 时，前面都匹配到有效的字符""",
        function="isMatch",
        params=[("s", "string"), ("p", "string")],
        returns="bool",
        solver=is_match,
        public=[
            ["aa", "a"],
            ["aa", "a*"],
            ["ab", ".*"],
            ["aab", "c*a*b"],
        ],
        expected_public=[False, True, True, True],
        hidden=[
            ["", ""], ["a", ""], ["", "a*"], ["", "c*"],
            ["mississippi", "mis*is*p*."], ["ab", ".*c"], ["aaa", "a*a"],
            ["aaa", "aaaa"], ["abc", ".*"], ["a", ".*.."],
        ],
    ),
    Problem(
        pid=1184,
        title="通配符匹配",
        difficulty="hard",
        tags=["字符串", "动态规划", "贪心", "递归"],
        description="""给定一个输入字符串 s 和一个字符模式 p，实现通配符匹配，支持 '?' 和 '*'：
- '?' 可以匹配任何单个字符
- '*' 可以匹配任意字符序列（包括空序列）
匹配必须覆盖整个字符串 s。

提示：
- 1 <= s.length, p.length <= 2000
- s 只包含小写英文字母
- p 只包含小写英文字母、'?' 或 '*'""",
        function="isWildcardMatch",
        params=[("s", "string"), ("p", "string")],
        returns="bool",
        solver=is_wildcard_match,
        public=[
            ["aa", "a"],
            ["aa", "*"],
            ["cb", "?a"],
            ["adceb", "*a*b"],
        ],
        expected_public=[False, True, False, True],
        hidden=[
            ["", ""], ["", "*"], ["", "?"], ["a", "?"], ["abc", "a*c"],
            ["acdcb", "a*c?b"], ["aab", "c*a*b"], ["abcabczzzde", "*abc???de*"],
            ["abc", "***"],
        ],
    ),
    Problem(
        pid=1185,
        title="最大矩形",
        difficulty="hard",
        tags=["栈", "数组", "动态规划", "矩阵", "单调栈"],
        description="""给定一个仅包含 0 和 1 的 rows x cols 二维二进制矩阵，找出只包含 1 的最大矩形，并返回其面积。

提示：
- rows == matrix.length
- cols == matrix[i].length
- 1 <= rows, cols <= 200
- matrix[i][j] 为 0 或 1""",
        function="maximalRectangle",
        params=[("matrix", "int[][]")],
        returns="int",
        solver=maximal_rectangle,
        public=[
            [[[1, 0, 1, 0, 0], [1, 0, 1, 1, 1], [1, 1, 1, 1, 1], [1, 0, 0, 1, 0]]],
            [[[0]]],
            [[[1]]],
            [[[1, 1], [1, 1]]],
        ],
        expected_public=[6, 0, 1, 4],
        hidden=[
            [[[1, 1, 0], [1, 1, 0]]],
            [[[1, 0, 1], [1, 1, 1], [1, 1, 1]]],
            [[[1, 1, 1], [1, 1, 1]]],
            [[[0, 0], [0, 0]]],
            [[[1, 0, 0, 1]]],
        ],
    ),
    Problem(
        pid=1186,
        title="课程表",
        difficulty="hard",
        tags=["深度优先搜索", "广度优先搜索", "图", "拓扑排序"],
        description="""你需要选修 numCourses 门课程，记为 0 到 numCourses - 1。
先修课程按数组 prerequisites 给出，其中 prerequisites[i] = [ai, bi] 表示如果要学习课程 ai，则必须先学习课程 bi。
判断是否可能完成所有课程的学习。

提示：
- 1 <= numCourses <= 2000
- 0 <= prerequisites.length <= 5000
- prerequisites[i].length == 2
- 0 <= ai, bi < numCourses
- 所有先修条件对互不相同""",
        function="canFinish",
        params=[("numCourses", "int"), ("prerequisites", "int[][]")],
        returns="bool",
        solver=can_finish,
        public=[
            [2, [[1, 0]]],
            [2, [[1, 0], [0, 1]]],
            [1, []],
            [3, [[0, 1], [1, 2]]],
        ],
        expected_public=[True, False, True, True],
        hidden=[
            [2, [[0, 1]]], [4, [[1, 0], [2, 1], [3, 2]]],
            [4, [[0, 1], [1, 2], [2, 0]]], [5, []],
            [3, [[0, 1], [0, 2], [1, 2]]], [2, []],
        ],
    ),
    Problem(
        pid=1187,
        title="腐烂的橘子",
        difficulty="hard",
        tags=["广度优先搜索", "数组", "矩阵"],
        description="""在给定的 m x n 网格 grid 中，每个单元格可以是：
- 0 表示空单元格
- 1 表示新鲜橘子
- 2 表示腐烂的橘子
每分钟，腐烂橘子会使其上下左右相邻的新鲜橘子腐烂。返回直到网格中没有新鲜橘子所需的最少分钟数。
如果不可能，返回 -1。

提示：
- m == grid.length
- n == grid[i].length
- 1 <= m, n <= 10
- grid[i][j] 为 0、1 或 2""",
        function="orangesRotting",
        params=[("grid", "int[][]")],
        returns="int",
        solver=oranges_rotting,
        public=[
            [[[2, 1, 1], [1, 1, 0], [0, 1, 1]]],
            [[[2, 1, 1], [0, 1, 1], [1, 0, 1]]],
            [[[0, 2]]],
            [[[0, 0]]],
        ],
        expected_public=[4, -1, 0, 0],
        hidden=[
            [[[1]]], [[[2]]], [[[0]]], [[[1, 0], [0, 1]]],
            [[[2, 1], [1, 1]]], [[[2, 0], [0, 1]]],
            [[[2, 1, 1], [1, 1, 1], [0, 1, 1]]],
        ],
    ),
    Problem(
        pid=1188,
        title="单词接龙",
        difficulty="hard",
        tags=["广度优先搜索", "哈希表", "字符串"],
        description="""给定两个单词 beginWord 和 endWord，以及一个单词列表 wordList。
一次转换只能改变一个字母，且转换后的单词必须存在于 wordList 中。
返回从 beginWord 到 endWord 的最短转换序列中的单词数目。如果不存在这样的转换序列，返回 0。

提示：
- 1 <= beginWord.length <= 10
- endWord.length == beginWord.length
- 1 <= wordList.length <= 5000
- wordList[i].length == beginWord.length
- beginWord、endWord 和 wordList[i] 仅由小写英文字母组成
- wordList 中的所有单词互不相同""",
        function="ladderLength",
        params=[
            ("beginWord", "string"),
            ("endWord", "string"),
            ("wordList", "string[]"),
        ],
        returns="int",
        solver=ladder_length,
        public=[
            ["hit", "cog", ["hot", "dot", "dog", "lot", "log", "cog"]],
            ["hit", "cog", ["hot", "dot", "dog", "lot", "log"]],
            ["a", "c", ["a", "b", "c"]],
            ["hit", "hot", ["hot"]],
        ],
        expected_public=[5, 0, 2, 2],
        hidden=[
            ["a", "c", ["b", "c"]], ["a", "c", ["c"]], ["a", "c", ["b"]],
            ["hot", "dog", ["hot", "dot", "dog"]],
            ["red", "tax", ["ted", "tex", "red", "tax", "tad", "den", "rex", "pee"]],
        ],
    ),
    Problem(
        pid=1189,
        title="戳气球",
        difficulty="hard",
        tags=["数组", "动态规划", "分治"],
        description="""有 n 个气球，编号为 0 到 n - 1，每个气球上标有一个数字，这些数字用数组 nums 表示。
现在要求戳破所有气球。戳破第 i 个气球可以获得 nums[i - 1] * nums[i] * nums[i + 1] 枚硬币。
这里的 i - 1 和 i + 1 表示和 i 相邻的气球的编号。如果 i - 1 或 i + 1 超出数组边界，则视为数字 1 的气球。
返回戳破所有气球能获得的最多硬币数。

提示：
- 1 <= nums.length <= 20
- 1 <= nums[i] <= 100""",
        function="maxCoins",
        params=[("nums", "int[]")],
        returns="int",
        solver=max_coins,
        public=[[[3, 1, 5, 8]], [[1, 5]], [[1]], [[1, 2, 3]]],
        expected_public=[167, 10, 1, 12],
        hidden=[
            [[2]], [[2, 3]], [[2, 3, 4]], [[1, 2, 3, 4]],
            [[5, 1, 2]], [[7, 9, 8]],
        ],
    ),
    Problem(
        pid=1190,
        title="单词搜索",
        difficulty="hard",
        tags=["数组", "回溯", "矩阵", "深度优先搜索"],
        description="""给定一个 m x n 的二维字符网格 board 和一个字符串单词 word，如果 word 存在于网格中，返回 true；否则返回 false。
单词必须按照字母顺序，通过相邻的单元格内的字母构成。相邻单元格是水平或垂直方向上的单元格。
同一个单元格内的字母不允许被重复使用。

提示：
- m == board.length
- n == board[i].length
- 1 <= m, n <= 6
- 1 <= word.length <= 15
- board 和 word 仅由大小写英文字母组成""",
        function="exist",
        params=[("board", "string[][]"), ("word", "string")],
        returns="bool",
        solver=exist,
        public=[
            [
                [["A", "B", "C", "E"], ["S", "F", "C", "S"], ["A", "D", "E", "E"]],
                "ABCCED",
            ],
            [
                [["A", "B", "C", "E"], ["S", "F", "C", "S"], ["A", "D", "E", "E"]],
                "SEE",
            ],
            [
                [["A", "B", "C", "E"], ["S", "F", "C", "S"], ["A", "D", "E", "E"]],
                "ABCB",
            ],
            [[["a"]], "a"],
        ],
        expected_public=[True, True, False, True],
        hidden=[
            [[["a"]], "b"], [[["a", "b"], ["c", "d"]], "abdc"],
            [[["a", "b"], ["c", "d"]], "abcd"], [[["a", "a"]], "aaa"],
            [[["C", "A", "A"], ["A", "A", "A"], ["B", "C", "D"]], "AAB"],
            [
                [["A", "B", "C", "E"], ["S", "F", "C", "S"], ["A", "D", "E", "E"]],
                "ABCCEE",
            ],
        ],
    ),
    Problem(
        pid=1191,
        title="N 皇后",
        difficulty="hard",
        tags=["数组", "回溯"],
        description="""n 皇后问题研究的是如何将 n 个皇后放置在 n x n 的棋盘上，并且使皇后彼此之间不能相互攻击。
给定一个整数 n，返回 n 皇后问题不同的解决方案的数量。

提示：
- 1 <= n <= 9""",
        function="totalNQueens",
        params=[("n", "int")],
        returns="int",
        solver=total_n_queens,
        public=[[4], [1], [8], [9]],
        expected_public=[2, 1, 92, 352],
        hidden=[[2], [3], [5], [6], [7], [10]],
    ),
    Problem(
        pid=1192,
        title="不同的子序列",
        difficulty="hard",
        tags=["字符串", "动态规划"],
        description="""给定一个字符串 s 和一个字符串 t，统计并返回在 s 的子序列中 t 出现的个数。
题目数据保证答案符合 32 位带符号整数范围。

提示：
- 1 <= s.length, t.length <= 1000
- s 和 t 由英文字母组成""",
        function="numDistinct",
        params=[("s", "string"), ("t", "string")],
        returns="int",
        solver=num_distinct,
        public=[
            ["rabbbit", "rabbit"],
            ["babgbag", "bag"],
            ["a", "a"],
            ["a", "b"],
        ],
        expected_public=[3, 5, 1, 0],
        hidden=[
            ["abc", ""], ["", "a"], ["aaa", "a"], ["aaa", "aa"],
            ["abcabc", "abc"], ["aabb", "ab"], ["abc", "abc"],
            ["aaaa", "aa"], ["abab", "ab"],
        ],
    ),
    Problem(
        pid=1193,
        title="最长回文子序列",
        difficulty="hard",
        tags=["字符串", "动态规划"],
        description="""给定一个字符串 s，找出其中最长的回文子序列，并返回该序列的长度。
子序列是从字符串中删除某些字符或不删除字符后得到的新字符串，不改变剩余字符的相对顺序。

提示：
- 1 <= s.length <= 1000
- s 仅由小写英文字母组成""",
        function="longestPalindromeSubseq",
        params=[("s", "string")],
        returns="int",
        solver=longest_palindrome_subseq,
        public=[["bbbab"], ["cbbd"], ["a"], [""]],
        expected_public=[4, 2, 1, 0],
        hidden=[
            ["aaaa"], ["abcde"], ["aabaa"], ["abacdfgdcaba"], ["racecar"],
            ["abbc"], ["leetcode"],
        ],
    ),
    Problem(
        pid=1194,
        title="计算右侧小于当前元素的个数",
        difficulty="hard",
        tags=["数组", "二分查找", "分治", "树状数组"],
        description="""给定一个整数数组 nums，按要求返回一个新数组 counts。
数组 counts 有该性质：counts[i] 的值是 nums[i] 右侧小于 nums[i] 的元素的数量。

提示：
- 1 <= nums.length <= 10^5
- -10^4 <= nums[i] <= 10^4""",
        function="countSmaller",
        params=[("nums", "int[]")],
        returns="int[]",
        solver=count_smaller,
        public=[
            [[5, 2, 6, 1]],
            [[2, 2, 2]],
            [[-1]],
            [[-1, -1]],
        ],
        expected_public=[[2, 1, 1, 0], [0, 0, 0], [0], [0, 0]],
        hidden=[
            [[1, 2, 3, 4]], [[4, 3, 2, 1]], [[1, 1, 1]], [[-1, -2]],
            [[3, 1, 2]], [[5, 4, 3, 2, 1, 0]], [[2, 0, 1]], [[1, 3, 2, 4, 0]],
        ],
    ),
    Problem(
        pid=1195,
        title="翻转对",
        difficulty="hard",
        tags=["数组", "分治", "归并排序", "树状数组"],
        description="""给定一个整数数组 nums，如果 i < j 且 nums[i] > 2 * nums[j]，则将 (i, j) 称为一个翻转对。
返回给定数组中翻转对的数量。

提示：
- 1 <= nums.length <= 5 * 10^4
- -2^31 <= nums[i] <= 2^31 - 1""",
        function="reversePairs",
        params=[("nums", "int[]")],
        returns="int",
        solver=reverse_pairs,
        public=[[[1, 3, 2, 3, 1]], [[2, 4, 3, 5, 1]], [[]], [[1]]],
        expected_public=[2, 3, 0, 0],
        hidden=[
            [[1, 2, 3, 4, 5]], [[5, 4, 3, 2, 1]], [[2, 2, 2]],
            [[-5, -5]], [[3, 2, 1]],
        ],
    ),
    Problem(
        pid=1196,
        title="矩阵中的最长递增路径",
        difficulty="hard",
        tags=["深度优先搜索", "广度优先搜索", "动态规划", "记忆化搜索", "矩阵"],
        description="""给定一个 m x n 的整数矩阵 matrix，找出其中最长递增路径的长度。
对于每个单元格，可以往上、下、左、右四个方向移动。不能沿对角线移动，也不能移动到矩阵边界外。
不能在一个递增路径中重复经过同一个单元格。

提示：
- m == matrix.length
- n == matrix[i].length
- 1 <= m, n <= 200
- 0 <= matrix[i][j] <= 2^31 - 1""",
        function="longestIncreasingPath",
        params=[("matrix", "int[][]")],
        returns="int",
        solver=longest_increasing_path,
        public=[
            [[[9, 9, 4], [6, 6, 8], [2, 1, 1]]],
            [[[3, 4, 5], [3, 2, 6], [2, 2, 1]]],
            [[[1]]],
            [[[1, 2], [4, 3]]],
        ],
        expected_public=[4, 4, 1, 4],
        hidden=[
            [[[1, 1], [1, 1]]], [[[1, 2], [3, 4]]],
            [[[1, 2, 3], [6, 5, 4], [7, 8, 9]]],
            [[[0, 1, 2], [3, 4, 5], [6, 7, 8]]],
        ],
    ),
    Problem(
        pid=1197,
        title="俄罗斯套娃信封问题",
        difficulty="hard",
        tags=["数组", "二分查找", "动态规划", "排序"],
        description="""给定一个二维整数数组 envelopes，其中 envelopes[i] = [wi, hi] 表示第 i 个信封的宽度和高度。
当另一个信封的宽度和高度都比这个信封大时，这个信封就可以放进另一个信封里。
请计算最多能组成多少个信封嵌套（不允许旋转信封）。

提示：
- 1 <= envelopes.length <= 5000
- envelopes[i].length == 2
- 1 <= wi, hi <= 10^4""",
        function="maxEnvelopes",
        params=[("envelopes", "int[][]")],
        returns="int",
        solver=max_envelopes,
        public=[
            [[[5, 4], [6, 4], [6, 7], [2, 3]]],
            [[[1, 1], [1, 1], [1, 1]]],
            [[[1, 2]]],
            [[[2, 3], [3, 4], [4, 5]]],
        ],
        expected_public=[3, 1, 1, 3],
        hidden=[
            [[[1, 2], [2, 3], [3, 4], [4, 5]]],
            [[[4, 5], [4, 6], [6, 7], [2, 3], [1, 1]]],
            [[[1, 1], [2, 2], [3, 3]]],
            [[[10, 8], [9, 9], [8, 10], [7, 11]]],
            [[[2, 100], [3, 200], [4, 300], [5, 400], [5, 500], [6, 600]]],
        ],
    ),
]
