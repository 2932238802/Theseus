"""1280-1299：新增困难题（20 道）。"""

from __future__ import annotations

import heapq
from collections import Counter
from functools import lru_cache

from problem_seed_common import Node, Problem, tree_from_list


def make(
    *,
    pid: int,
    title: str,
    tags: list[str],
    description: str,
    function: str,
    params: list[tuple[str, str]],
    returns: str,
    solver,
    public: list[list],
    hidden: list[list],
    compare: dict | None = None,
) -> Problem:
    return Problem(
        pid=pid,
        title=title,
        difficulty="hard",
        tags=tags,
        description=description,
        function=function,
        params=params,
        returns=returns,
        solver=solver,
        public=public,
        expected_public=[solver(*args) for args in public],
        hidden=hidden,
        compare=compare or {"mode": "exact"},
    )


def count_inverse_pairs(n: int, k: int) -> int:
    modulus = 10**9 + 7
    if k < 0:
        return 0
    dp = [0] * (k + 1)
    dp[0] = 1
    for length in range(2, n + 1):
        prefix = 0
        current = [0] * (k + 1)
        for inversions in range(k + 1):
            prefix = (prefix + dp[inversions]) % modulus
            if inversions >= length:
                prefix = (prefix - dp[inversions - length]) % modulus
            current[inversions] = prefix
        dp = current
    return dp[k] % modulus


def max_profit_iv(k: int, prices: list[int]) -> int:
    if not prices or k == 0:
        return 0
    k = min(k, len(prices) // 2)
    if k == 0:
        return 0
    buy = [-(10**18)] * (k + 1)
    sell = [0] * (k + 1)
    for price in prices:
        for transactions in range(1, k + 1):
            buy[transactions] = max(buy[transactions], sell[transactions - 1] - price)
            sell[transactions] = max(sell[transactions], buy[transactions] + price)
    return sell[k]


def shortest_common_supersequence_length(str1: str, str2: str) -> int:
    previous = [0] * (len(str2) + 1)
    for left in str1:
        current = [0] * (len(str2) + 1)
        for column, right in enumerate(str2, start=1):
            if left == right:
                current[column] = previous[column - 1] + 1
            else:
                current[column] = max(previous[column], current[column - 1])
        previous = current
    return len(str1) + len(str2) - previous[-1]


def full_justify(words: list[str], max_width: int) -> list[str]:
    def render(line: list[str], width: int, last: bool) -> str:
        if last or len(line) == 1:
            text = " ".join(line)
            return text + " " * (max_width - len(text))
        gaps = len(line) - 1
        spaces, extra = divmod(max_width - width, gaps)
        parts: list[str] = []
        for index, word in enumerate(line):
            parts.append(word)
            if index < gaps:
                parts.append(" " * spaces + (" " if index < extra else ""))
        return "".join(parts)

    result: list[str] = []
    line: list[str] = []
    width = 0
    for word in words:
        if line and width + len(word) + len(line) > max_width:
            result.append(render(line, width, False))
            line = []
            width = 0
        line.append(word)
        width += len(word)
    result.append(render(line, width, True))
    return result


def is_number(s: str) -> bool:
    state = "start"
    for character in s:
        if character.isdigit():
            if state in ("start", "sign"):
                state = "int"
            elif state in ("dot", "frac"):
                state = "frac"
            elif state in ("exp", "exp_sign"):
                state = "exp_int"
            elif state != "int" and state != "exp_int":
                return False
        elif character == ".":
            if state in ("start", "sign"):
                state = "dot"
            elif state == "int":
                state = "frac"
            else:
                return False
        elif character in "+-":
            if state == "start":
                state = "sign"
            elif state == "exp":
                state = "exp_sign"
            else:
                return False
        elif character in "eE":
            if state in ("int", "frac"):
                state = "exp"
            else:
                return False
        else:
            return False
    return state in ("int", "frac", "exp_int")


def first_missing_positive(nums: list[int]) -> int:
    values = set(nums)
    candidate = 1
    while candidate in values:
        candidate += 1
    return candidate


def trap_rain_water_ii(height_map: list[list[int]]) -> int:
    rows, columns = len(height_map), len(height_map[0]) if height_map else 0
    if rows < 3 or columns < 3:
        return 0
    visited = [[False] * columns for _ in range(rows)]
    heap: list[tuple[int, int, int]] = []
    for row in range(rows):
        for column in range(columns):
            if row in (0, rows - 1) or column in (0, columns - 1):
                visited[row][column] = True
                heapq.heappush(heap, (height_map[row][column], row, column))
    water = 0
    while heap:
        height, row, column = heapq.heappop(heap)
        for row_step, column_step in ((1, 0), (-1, 0), (0, 1), (0, -1)):
            next_row, next_column = row + row_step, column + column_step
            if not (0 <= next_row < rows and 0 <= next_column < columns):
                continue
            if visited[next_row][next_column]:
                continue
            visited[next_row][next_column] = True
            next_height = height_map[next_row][next_column]
            water += max(0, height - next_height)
            heapq.heappush(heap, (max(height, next_height), next_row, next_column))
    return water


def calculate(s: str) -> int:
    result = 0
    number = 0
    sign = 1
    stack: list[int] = []
    for character in s:
        if character.isdigit():
            number = number * 10 + int(character)
        elif character in "+-":
            result += sign * number
            number = 0
            sign = 1 if character == "+" else -1
        elif character == "(":
            stack.append(result)
            stack.append(sign)
            result = 0
            sign = 1
            number = 0
        elif character == ")":
            result += sign * number
            number = 0
            sign, previous = stack.pop(), stack.pop()
            result = result * sign + previous
            sign = 1
    return result + sign * number


def skyline(buildings: list[list[int]]) -> list[list[int]]:
    events: list[tuple[int, int]] = []
    for left, right, height in buildings:
        events.append((left, -height))
        events.append((right, height))
    events.sort()

    active: Counter[int] = Counter()
    heap: list[int] = []
    result: list[list[int]] = []
    previous_height = 0
    index = 0
    while index < len(events):
        x = events[index][0]
        while index < len(events) and events[index][0] == x:
            height = events[index][1]
            if height < 0:
                active[-height] += 1
                heapq.heappush(heap, height)
            else:
                active[height] -= 1
            index += 1
        while heap and active[-heap[0]] == 0:
            heapq.heappop(heap)
        current_height = -heap[0] if heap else 0
        if current_height != previous_height:
            result.append([x, current_height])
            previous_height = current_height
    return result


def merge_k_arrays(lists: list[list[int]]) -> list[int]:
    return list(heapq.merge(*lists))


def word_break_ii(s: str, word_dict: list[str]) -> list[str]:
    words = set(word_dict)
    memo: dict[int, list[str]] = {}

    def build(start: int) -> list[str]:
        if start in memo:
            return memo[start]
        if start == len(s):
            return [""]
        sentences: list[str] = []
        for end in range(start + 1, len(s) + 1):
            word = s[start:end]
            if word not in words:
                continue
            for suffix in build(end):
                sentences.append(word + (" " + suffix if suffix else ""))
        memo[start] = sentences
        return sentences

    return sorted(build(0))


def max_path_sum(root: list[int | None]) -> int:
    node = tree_from_list(root)
    best = -(10**9)

    def gain(current: Node | None) -> int:
        nonlocal best
        if current is None:
            return 0
        left = max(gain(current.left), 0)
        right = max(gain(current.right), 0)
        best = max(best, current.value + left + right)
        return current.value + max(left, right)

    gain(node)
    return best


def is_scramble(s1: str, s2: str) -> bool:
    @lru_cache(maxsize=None)
    def check(left1: int, right1: int, left2: int, right2: int) -> bool:
        if sorted(s1[left1:right1]) != sorted(s2[left2:right2]):
            return False
        if right1 - left1 <= 1:
            return s1[left1:right1] == s2[left2:right2]
        length = right1 - left1
        for split in range(1, length):
            if check(left1, left1 + split, left2, left2 + split) and check(
                left1 + split, right1, left2 + split, right2
            ):
                return True
            if check(left1, left1 + split, right2 - split, right2) and check(
                left1 + split, right1, left2, right2 - split
            ):
                return True
        return False

    return check(0, len(s1), 0, len(s2))


def maximum_gap(nums: list[int]) -> int:
    ordered = sorted(nums)
    return max(right - left for left, right in zip(ordered, ordered[1:]))


def max_profit_iii(prices: list[int]) -> int:
    buy_one = buy_two = -(10**9)
    sell_one = sell_two = 0
    for price in prices:
        buy_one = max(buy_one, -price)
        sell_one = max(sell_one, buy_one + price)
        buy_two = max(buy_two, sell_one - price)
        sell_two = max(sell_two, buy_two + price)
    return sell_two


def split_array(nums: list[int], k: int) -> int:
    left = max(nums)
    right = sum(nums)
    while left < right:
        middle = (left + right) // 2
        pieces = 1
        current = 0
        for value in nums:
            if current + value > middle:
                pieces += 1
                current = value
            else:
                current += value
        if pieces <= k:
            right = middle
        else:
            left = middle + 1
    return left


def count_digit_one(n: int) -> int:
    count = 0
    factor = 1
    while factor <= n:
        high, current, low = n // (factor * 10), (n // factor) % 10, n % factor
        if current == 0:
            count += high * factor
        elif current == 1:
            count += high * factor + low + 1
        else:
            count += (high + 1) * factor
        factor *= 10
    return count


def strange_printer(s: str) -> int:
    compressed = [s[0]] if s else []
    for character in s[1:]:
        if character != compressed[-1]:
            compressed.append(character)
    length = len(compressed)
    if not length:
        return 0
    dp = [[0] * length for _ in range(length)]
    for index in range(length):
        dp[index][index] = 1
    for span in range(2, length + 1):
        for start in range(length - span + 1):
            end = start + span - 1
            dp[start][end] = dp[start + 1][end] + 1
            for middle in range(start + 1, end + 1):
                if compressed[middle] == compressed[start]:
                    left = dp[start + 1][middle - 1] if middle > start + 1 else 0
                    dp[start][end] = min(dp[start][end], left + dp[middle][end])
    return dp[0][length - 1]


def check_record(n: int) -> int:
    modulus = 10**9 + 7
    dp = [[0] * 3 for _ in range(2)]
    dp[0][0] = 1
    for _ in range(n):
        nxt = [[0] * 3 for _ in range(2)]
        for absent in range(2):
            for late in range(3):
                value = dp[absent][late]
                if not value:
                    continue
                nxt[absent][0] = (nxt[absent][0] + value) % modulus
                if absent == 0:
                    nxt[1][0] = (nxt[1][0] + value) % modulus
                if late < 2:
                    nxt[absent][late + 1] = (nxt[absent][late + 1] + value) % modulus
        dp = nxt
    return sum(sum(row) for row in dp) % modulus


def count_palindromic_subsequences(s: str) -> int:
    modulus = 10**9 + 7

    @lru_cache(maxsize=None)
    def count(left: int, right: int) -> int:
        if left > right:
            return 0
        if left == right:
            return 1
        if s[left] != s[right]:
            return (
                count(left + 1, right)
                + count(left, right - 1)
                - count(left + 1, right - 1)
            ) % modulus
        inner_left, inner_right = left + 1, right - 1
        while inner_left <= inner_right and s[inner_left] != s[left]:
            inner_left += 1
        while inner_left <= inner_right and s[inner_right] != s[left]:
            inner_right -= 1
        if inner_left > inner_right:
            return (2 * count(left + 1, right - 1) + 2) % modulus
        if inner_left == inner_right:
            return (2 * count(left + 1, right - 1) + 1) % modulus
        return (
            2 * count(left + 1, right - 1) - count(inner_left + 1, inner_right - 1)
        ) % modulus

    return count(0, len(s) - 1)


PROBLEMS = [
    make(
        pid=1280,
        title="K 个逆序对数组",
        tags=["动态规划", "滑动窗口", "前缀和"],
        description="""给定整数 n 和 k，返回由 1 到 n 组成的排列中恰好含有 k 个逆序对的不同排列数量。
逆序对指满足 i < j 且 nums[i] > nums[j] 的一对下标。结果对 10^9 + 7 取模。

提示：
- 1 <= n <= 1000
- 0 <= k <= 1000""",
        function="kInversePairs",
        params=[("n", "int"), ("k", "int")],
        returns="int",
        solver=count_inverse_pairs,
        public=[[3, 0], [3, 1], [3, 2], [4, 2]],
        hidden=[[1, 0], [2, 0], [2, 1], [5, 3], [7, 10], [10, 20]],
    ),
    make(
        pid=1281,
        title="买卖股票的最佳时机 IV",
        tags=["数组", "动态规划"],
        description="""给定整数 k 和股票价格数组 prices，最多可以完成 k 笔交易，且不能同时参与多笔交易。
返回能获得的最大利润。一次买入和一次卖出构成一笔交易。

提示：
- 1 <= k <= 10^9
- 1 <= prices.length <= 10^5
- 0 <= prices[i] <= 10^5""",
        function="maxProfitIV",
        params=[("k", "int"), ("prices", "int[]")],
        returns="int",
        solver=max_profit_iv,
        public=[[2, [2, 4, 1]], [2, [3, 2, 6, 5, 0, 3]], [1, [1, 2, 3, 4, 5]], [2, [7, 6, 4, 3, 1]]],
        hidden=[[1, [2, 1, 4, 5, 2, 9]], [3, [1, 2, 4, 2, 5, 7, 2, 4, 9, 0]], [2, [1]], [1000000000, [3, 2, 6, 5, 0, 3]], [4, [2, 1, 4, 5, 2, 9, 7]]],
    ),
    make(
        pid=1282,
        title="最短公共超序列长度",
        tags=["字符串", "动态规划"],
        description="""给定两个字符串 str1 和 str2，返回同时以 str1 和 str2 为子序列的最短字符串长度。
字符串的子序列由删除任意字符且保持剩余字符顺序得到。

提示：
- 1 <= str1.length, str2.length <= 1000
- str1 和 str2 由小写英文字母组成""",
        function="shortestCommonSupersequenceLength",
        params=[("str1", "string"), ("str2", "string")],
        returns="int",
        solver=shortest_common_supersequence_length,
        public=[["abac", "cab"], ["geek", "eke"], ["abc", "def"], ["abc", "abc"]],
        hidden=[["a", "a"], ["a", "b"], ["ab", "ba"], ["abcd", "acbd"], ["sea", "eat"], ["teacher", "cheater"]],
    ),
    make(
        pid=1283,
        title="文本左右对齐",
        tags=["字符串", "模拟"],
        description="""给定一个单词数组 words 和一个宽度 maxWidth，重新排版单词，使其每行恰好有 maxWidth 个字符。
除最后一行左对齐外，单词之间应尽可能均匀分配空格；若空格不能均匀分配，左侧空格多于右侧。
最后一行单词之间只放一个空格，并在末尾补足空格。

提示：
- 1 <= words.length <= 300
- 1 <= words[i].length <= 20
- words[i] 由小写英文字母组成
- 1 <= maxWidth <= 100""",
        function="fullJustify",
        params=[("words", "string[]"), ("maxWidth", "int")],
        returns="string[]",
        solver=full_justify,
        public=[[["This", "is", "an", "example", "of", "text", "justification."], 16], [["What","must","be","acknowledgment","shall","be"], 16], [["Science","is","what","we","understand","well","enough","to","explain","to","a","computer.","Art","is","everything","else","we","do"], 20]],
        hidden=[[["a","b","c"], 3], [["hello"], 7], [["a","bb","ccc"], 6], [["one","two","three"], 10], [["listen","to","many","speak","to","few"], 6]],
    ),
    make(
        pid=1284,
        title="有效数字",
        tags=["字符串", "有限状态机"],
        description="""判断字符串 s 是否表示一个有效数字。
有效数字可以包含整数或小数部分、可选指数部分；指数部分必须是整数。正负号只能出现在开头或指数符号之后。

提示：
- 1 <= s.length <= 20
- s 由英文字母、数字、正负号和小数点组成""",
        function="isNumber",
        params=[("s", "string")],
        returns="bool",
        solver=is_number,
        public=[["0"], ["e"], ["."], ["2e10"]],
        hidden=[["-0.1"], ["+.5"], ["3."], ["1e"], ["1e+"], ["abc"], ["0e0"], ["6e-1"], ["99e2.5"]],
    ),
    make(
        pid=1285,
        title="缺失的第一个正数",
        tags=["数组", "哈希表"],
        description="""给定一个未排序的整数数组 nums，返回其中没有出现的最小正整数。
要求答案在 1 到 nums.length + 1 的范围内。

提示：
- 1 <= nums.length <= 10^5
- -2^31 <= nums[i] <= 2^31 - 1""",
        function="firstMissingPositive",
        params=[("nums", "int[]")],
        returns="int",
        solver=first_missing_positive,
        public=[[[1, 2, 0]], [[3, 4, -1, 1]], [[7, 8, 9, 11, 12]], [[1]]],
        hidden=[[[2]], [[0]], [[-1, -2]], [[1, 1]], [[1, 2, 3]], [[2, 3, 4]], [[-10, 1, 3]]],
    ),
    make(
        pid=1286,
        title="接雨水 II",
        tags=["数组", "广度优先搜索", "堆", "矩阵"],
        description="""给定一个 m × n 的二维高度图 heightMap，表示每个单元格的柱子高度。
下雨后，水会向四周低处流动，边界视为无法蓄水。返回整个地形最多能接住多少雨水。

提示：
- 1 <= m, n <= 200
- 0 <= heightMap[i][j] <= 2 * 10^4""",
        function="trapRainWaterII",
        params=[("heightMap", "int[][]")],
        returns="int",
        solver=trap_rain_water_ii,
        public=[
            [[[1, 4, 3, 1, 3, 2], [3, 2, 1, 3, 2, 4], [2, 3, 3, 2, 3, 1]]],
            [[[3, 3, 3, 3, 3], [3, 2, 2, 2, 3], [3, 2, 1, 2, 3], [3, 2, 2, 2, 3], [3, 3, 3, 3, 3]]],
            [[[1]]],
            [[[1, 2], [3, 4]]],
        ],
        hidden=[
            [[[5, 5, 5], [5, 1, 5], [5, 5, 5]]],
            [[[2, 2, 2], [2, 1, 2], [2, 2, 2]]],
            [[[1, 0, 1], [0, 2, 0], [1, 0, 1]]],
            [[[9, 9, 9, 9], [9, 1, 1, 9], [9, 9, 9, 9]]],
            [[[0, 0, 0], [0, 0, 0], [0, 0, 0]]],
        ],
    ),
    make(
        pid=1287,
        title="基本计算器",
        tags=["字符串", "栈", "数学"],
        description="""给定一个只包含非负整数、加号、减号、左括号、右括号和空格的字符串表达式 s，计算并返回表达式的值。
表达式中的减号也可以表示一元负号。

提示：
- 1 <= s.length <= 3 * 10^5
- s 由数字、'+'、'-'、'('、')' 和空格组成
- 表达式结果保证在 32 位整数范围内""",
        function="calculate",
        params=[("s", "string")],
        returns="int",
        solver=calculate,
        public=[["1 + 1"], [" 2-1 + 2 "], ["(1+(4+5+2)-3)+(6+8)"], ["1"]],
        hidden=[["1-(2+3)"], ["-2+1"], ["(1-2)-(3-4)"], ["10- ( 2 + 3 )"], ["1-(-2)"], ["(7)-(0)+(4)"]],
    ),
    make(
        pid=1288,
        title="天际线问题",
        tags=["数组", "扫描线", "堆", "排序"],
        description="""给定建筑物的位置和高度 buildings，其中 buildings[i] = [left, right, height]，返回由关键点组成的天际线。
关键点是水平线段的左端点，最后一个关键点高度为 0。

提示：
- 1 <= buildings.length <= 10^4
- 0 <= left < right <= 2^31 - 1
- 1 <= height <= 2^31 - 1""",
        function="skyline",
        params=[("buildings", "int[][]")],
        returns="int[][]",
        solver=skyline,
        public=[[[[2,9,10],[3,7,15],[5,12,12],[15,20,10],[19,24,8]]], [[[0,2,3],[2,5,3]]], [[[1,2,1]]]],
        hidden=[[[[1,3,2],[2,4,2]]], [[[1,5,3],[2,4,5]]], [[[0,10,1],[2,6,2],[4,8,3]]], [[[1,2,1],[1,2,2]]], [[[0,1,3],[1,2,1]]], [[[3,10,5],[5,8,7]]]],
    ),
    make(
        pid=1289,
        title="合并 K 个升序数组",
        tags=["数组", "堆", "分治"],
        description="""给定 k 个升序整数数组 lists，将所有元素合并到一个升序数组中并返回。

提示：
- 0 <= k <= 500
- 0 <= lists[i].length <= 500
- -10^4 <= lists[i][j] <= 10^4
- lists[i] 按升序排列""",
        function="mergeKArrays",
        params=[("lists", "int[][]")],
        returns="int[]",
        solver=merge_k_arrays,
        public=[
            [[[1, 4, 5], [1, 3, 4], [2, 6]]],
            [[[]]],
            [[]],
            [[[1], [2], [3]]],
        ],
        hidden=[
            [[[-5, -1], [], [0, 2]]],
            [[[1, 2], [1, 2]]],
            [[[0, 0, 1], [1, 2]]],
            [[[1], [], [0]]],
            [[[-10, -5, 0], [1, 3], [2]]],
        ],
    ),
    make(
        pid=1290,
        title="单词拆分 II",
        tags=["字符串", "动态规划", "回溯"],
        description="""给定字符串 s 和单词字典 wordDict，在 s 中增加空格构造所有可能的句子，使每个单词都在字典中。
返回所有句子，并按字典序排列。

提示：
- 1 <= s.length <= 20
- 1 <= wordDict.length <= 100
- 1 <= wordDict[i].length <= 10
- wordDict 中的单词互不相同""",
        function="wordBreakII",
        params=[("s", "string"), ("wordDict", "string[]")],
        returns="string[]",
        solver=word_break_ii,
        public=[
            ["catsanddog", ["cat", "cats", "and", "sand", "dog"]],
            ["pineapplepenapple", ["apple", "pen", "applepen", "pine", "pineapple"]],
            ["catsandog", ["cats", "dog", "sand", "and", "cat"]],
        ],
        hidden=[
            ["a", ["a"]],
            ["ab", ["a", "b"]],
            ["aaa", ["a", "aa"]],
            ["abcd", ["a", "b", "c", "d"]],
            ["catsandog", ["cat", "and", "dog"]],
        ],
    ),
    make(
        pid=1291,
        title="二叉树中的最大路径和",
        tags=["树", "深度优先搜索", "动态规划"],
        description="""给定一棵二叉树 root，返回任意节点路径的最大路径和。
路径可以从任意节点开始和结束，但必须沿父子连接连续，且同一节点最多出现一次。

提示：
- 1 <= 节点数 <= 3 * 10^4
- -1000 <= Node.val <= 1000""",
        function="maxPathSum",
        params=[("root", "TreeNode")],
        returns="int",
        solver=max_path_sum,
        public=[[[1,2,3]], [[-10,9,20,None,None,15,7]], [[-3]], [[2,-1]]],
        hidden=[[[-2,1]], [[1,-2,3]], [[-1,-2,-3]], [[5,4,8,11,None,13,4,7,2]], [[2,-1,-2]], [[-10,-20,-30]]],
    ),
    make(
        pid=1292,
        title="扰乱字符串",
        tags=["字符串", "动态规划", "记忆化搜索"],
        description="""给定两个长度相同的字符串 s1 和 s2，判断 s2 是否是 s1 的扰乱字符串。
扰乱字符串可以通过递归交换一个字符串的某个非空子串与其相邻的另一子串得到。

提示：
- 1 <= s1.length, s2.length <= 30
- s1 和 s2 由小写英文字母组成""",
        function="isScramble",
        params=[("s1", "string"), ("s2", "string")],
        returns="bool",
        solver=is_scramble,
        public=[["great","rgeat"], ["abcde","caebd"], ["a","a"], ["ab","ba"]],
        hidden=[["abb","bba"], ["abc","abc"], ["abcd","badc"], ["abcdef","fbcdea"], ["aab","aba"], ["abcd","cdab"]],
    ),
    make(
        pid=1293,
        title="最大间距",
        tags=["数组", "排序", "基数排序"],
        description="""给定一个无序整数数组 nums，返回数组在排序之后相邻元素之间的最大差值。
数组至少包含两个元素。

提示：
- 2 <= nums.length <= 10^5
- 0 <= nums[i] <= 10^9""",
        function="maximumGap",
        params=[("nums", "int[]")],
        returns="int",
        solver=maximum_gap,
        public=[[[3, 6, 9, 1]], [[10, 20]], [[1, 10000000]], [[1, 2, 3, 4]]],
        hidden=[[[1,3,100]], [[5,5,5,5]], [[100,3,2,1]], [[0,9,3,5]], [[1,2,4,8,16]], [[4,2,9,7]]],
    ),
    make(
        pid=1294,
        title="买卖股票的最佳时机 III",
        tags=["数组", "动态规划"],
        description="""给定一个数组 prices，其中 prices[i] 表示某支股票第 i 天的价格。
最多可以完成两笔交易，且不能同时参与多笔交易，返回能获得的最大利润。

提示：
- 1 <= prices.length <= 10^5
- 0 <= prices[i] <= 10^5""",
        function="maxProfitIII",
        params=[("prices", "int[]")],
        returns="int",
        solver=max_profit_iii,
        public=[[[3,3,5,0,0,3,1,4]], [[1,2,3,4,5]], [[7,6,4,3,1]], [[1]]],
        hidden=[[[2,1,4,5,2,9,7]], [[3,2,6,5,0,3]], [[1,2,4,2,5,7,2,4,9,0]], [[2,4,1]], [[6,1,3,2,4,7]]],
    ),
    make(
        pid=1295,
        title="分割数组的最大值",
        tags=["数组", "二分查找", "动态规划"],
        description="""给定一个非负整数数组 nums 和整数 k，将数组分成 k 个非空连续子数组，使这些子数组各自和的最大值最小。
返回这个最小的最大和。

提示：
- 1 <= nums.length <= 10^5
- 0 <= nums[i] <= 10^6
- 1 <= k <= nums.length""",
        function="splitArray",
        params=[("nums", "int[]"), ("k", "int")],
        returns="long",
        solver=split_array,
        public=[[[7,2,5,10,8], 2], [[1,2,3,4,5], 2], [[1,4,4], 3], [[1], 1]],
        hidden=[[[10,20,30], 2], [[0,0,0], 2], [[5,5,5,5], 4], [[2,3,1,2,4,3], 5], [[1,2,3,4,5,6], 3]],
    ),
    make(
        pid=1296,
        title="数字 1 的个数",
        tags=["数学", "动态规划"],
        description="""给定一个整数 n，计算所有小于等于 n 的非负整数中数字 1 出现的总次数。

提示：
- 0 <= n <= 2^31 - 1""",
        function="countDigitOne",
        params=[("n", "int")],
        returns="long",
        solver=count_digit_one,
        public=[[13], [0], [1], [20]],
        hidden=[[9], [99], [100], [1234], [1000000000], [2147483647], [10]],
    ),
    make(
        pid=1297,
        title="奇怪的打印机",
        tags=["字符串", "动态规划"],
        description="""有一台奇怪的打印机，每次可以打印一段连续相同字符，并且新打印的字符会覆盖原有字符。
给定字符串 s，返回打印出 s 所需的最少打印次数。

提示：
- 1 <= s.length <= 100
- s 由小写英文字母组成""",
        function="strangePrinter",
        params=[("s", "string")],
        returns="int",
        solver=strange_printer,
        public=[["aaabbb"], ["aba"], ["abc"], ["a"]],
        hidden=[["aab"], ["abba"], ["abcabc"], ["aaaa"], ["abab"], ["aaabbbccc"]],
    ),
    make(
        pid=1298,
        title="学生出勤记录 II",
        tags=["动态规划"],
        description="""可以用长度为 n 的字符串表示学生的出勤记录，每个字符为 A（缺勤）、L（迟到）或 P（到场）。
如果记录中 A 少于 2 个，且不存在连续 3 个或更多 L，则记录有效。
返回长度为 n 的有效记录数量，结果对 10^9 + 7 取模。

提示：
- 1 <= n <= 10^5""",
        function="checkRecord",
        params=[("n", "int")],
        returns="int",
        solver=check_record,
        public=[[1], [2], [3], [4]],
        hidden=[[5], [6], [10], [100], [1000], [100000]],
    ),
    make(
        pid=1299,
        title="统计不同回文子序列",
        tags=["字符串", "动态规划"],
        description="""给定一个字符串 s，返回 s 中不同的非空回文子序列数量，结果对 10^9 + 7 取模。
相同字符序列只计一次，即使它们由不同下标子序列形成。

提示：
- 1 <= s.length <= 100
- s 仅包含字符 'a'、'b'、'c'、'd'""",
        function="countPalindromicSubsequences",
        params=[("s", "string")],
        returns="int",
        solver=count_palindromic_subsequences,
        public=[["b"], ["abc"], ["aaa"], ["aba"]],
        hidden=[["aa"], ["abba"], ["abcd"], ["aab"], ["abcba"], ["aaaabbbbccccdddd"]],
    ),
]
