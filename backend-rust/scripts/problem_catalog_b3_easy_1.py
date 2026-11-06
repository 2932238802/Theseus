"""1700-1737：批量第三批简单题（38 道）。"""

from __future__ import annotations

import heapq
from collections import Counter
from datetime import date
from functools import partial

from problem_seed_common import make_problem

make = partial(make_problem, difficulty="easy")


# ── 数组 / 双指针 / 排序 / 模拟 ──────────────────────────────────────


def sort_array_by_parity_ii(nums: list[int]) -> list[int]:
    evens = [value for value in nums if value % 2 == 0]
    odds = [value for value in nums if value % 2 != 0]
    result = [0] * len(nums)
    result[0::2] = evens
    result[1::2] = odds
    return result


def is_long_pressed_name(name: str, typed: str) -> bool:
    left = right = 0
    while right < len(typed):
        if left < len(name) and name[left] == typed[right]:
            left += 1
            right += 1
        elif right > 0 and typed[right] == typed[right - 1]:
            right += 1
        else:
            return False
    return left == len(name)


def busy_student(start_time: list[int], end_time: list[int], query_time: int) -> int:
    return sum(
        1
        for start, end in zip(start_time, end_time)
        if start <= query_time <= end
    )


def reorder_log_files(logs: list[str]) -> list[str]:
    letter_logs: list[tuple[str, str, str]] = []
    digit_logs: list[str] = []
    for log in logs:
        identifier, body = log.split(" ", 1)
        if body[0].isdigit():
            digit_logs.append(log)
        else:
            letter_logs.append((body, identifier, log))
    letter_logs.sort(key=lambda item: (item[0], item[1]))
    return [item[2] for item in letter_logs] + digit_logs


def min_deletion_size(strs: list[str]) -> int:
    rows = len(strs)
    columns = len(strs[0])
    deleted = 0
    for column in range(columns):
        for row in range(rows - 1):
            if strs[row][column] > strs[row + 1][column]:
                deleted += 1
                break
    return deleted


def sum_even_after_queries(nums: list[int], queries: list[list[int]]) -> list[int]:
    current = nums[:]
    even_sum = sum(value for value in current if value % 2 == 0)
    result: list[int] = []
    for value, index in queries:
        old = current[index]
        if old % 2 == 0:
            even_sum -= old
        new = old + value
        if new % 2 == 0:
            even_sum += new
        current[index] = new
        result.append(even_sum)
    return result


def find_kth_positive(arr: list[int], k: int) -> int:
    target = k
    for value in arr:
        if value <= target:
            target += 1
        else:
            break
    return target


def divisor_game(n: int) -> bool:
    return n % 2 == 0


def all_cells_dist_order(rows: int, cols: int, r_center: int, c_center: int) -> list[list[int]]:
    cells = [[row, column] for row in range(rows) for column in range(cols)]
    cells.sort(key=lambda cell: (abs(cell[0] - r_center) + abs(cell[1] - c_center), cell[0], cell[1]))
    return cells


def last_stone_weight(stones: list[int]) -> int:
    heap = [-stone for stone in stones]
    heapq.heapify(heap)
    while len(heap) > 1:
        first = -heapq.heappop(heap)
        second = -heapq.heappop(heap)
        if first != second:
            heapq.heappush(heap, -(first - second))
    return -heap[0] if heap else 0


def find_ocurrences(text: str, first: str, second: str) -> list[str]:
    words = text.split()
    result: list[str] = []
    for index in range(len(words) - 2):
        if words[index] == first and words[index + 1] == second:
            result.append(words[index + 2])
    return result


def distribute_candies(candies: int, num_people: int) -> list[int]:
    result = [0] * num_people
    give = 1
    index = 0
    while candies > 0:
        amount = min(give, candies)
        result[index % num_people] += amount
        candies -= amount
        give += 1
        index += 1
    return result


def relative_sort_array(arr1: list[int], arr2: list[int]) -> list[int]:
    counts = Counter(arr1)
    listed = set(arr2)
    result: list[int] = []
    for value in arr2:
        result.extend([value] * counts[value])
    result.extend(sorted(value for value in arr1 if value not in listed))
    return result


def count_characters(words: list[str], chars: str) -> int:
    available = Counter(chars)
    total = 0
    for word in words:
        needed = Counter(word)
        if all(needed[character] <= available[character] for character in needed):
            total += len(word)
    return total


def _prime_count(limit: int) -> int:
    if limit < 2:
        return 0
    sieve = [True] * (limit + 1)
    sieve[0] = sieve[1] = False
    for value in range(2, int(limit**0.5) + 1):
        if sieve[value]:
            for multiple in range(value * value, limit + 1, value):
                sieve[multiple] = False
    return sum(sieve)


def num_prime_arrangements(n: int) -> int:
    mod = 10**9 + 7
    primes = _prime_count(n)
    composites = n - primes
    result = 1
    for value in range(2, primes + 1):
        result = result * value % mod
    for value in range(2, composites + 1):
        result = result * value % mod
    return result


def distance_between_bus_stops(distance: list[int], start: int, destination: int) -> int:
    if start > destination:
        start, destination = destination, start
    clockwise = sum(distance[start:destination])
    total = sum(distance)
    return min(clockwise, total - clockwise)


def day_of_the_week(day: int, month: int, year: int) -> str:
    names = [
        "Monday",
        "Tuesday",
        "Wednesday",
        "Thursday",
        "Friday",
        "Saturday",
        "Sunday",
    ]
    return names[date(year, month, day).weekday()]


def max_number_of_balloons(text: str) -> int:
    counts = Counter(text)
    return min(
        counts["b"],
        counts["a"],
        counts["l"] // 2,
        counts["o"] // 2,
        counts["n"],
    )


def odd_cells(m: int, n: int, indices: list[list[int]]) -> int:
    rows = [0] * m
    columns = [0] * n
    for row, column in indices:
        rows[row] += 1
        columns[column] += 1
    total = 0
    for row in range(m):
        for column in range(n):
            if (rows[row] + columns[column]) % 2 == 1:
                total += 1
    return total


def shift_grid(grid: list[list[int]], k: int) -> list[list[int]]:
    rows = len(grid)
    columns = len(grid[0])
    flat = [value for line in grid for value in line]
    shift = k % (rows * columns)
    if shift:
        flat = flat[-shift:] + flat[:-shift]
    return [flat[index * columns : (index + 1) * columns] for index in range(rows)]


def find_special_integer(arr: list[int]) -> int:
    step = len(arr) // 4
    for index in range(len(arr) - step):
        if arr[index] == arr[index + step]:
            return arr[index]
    return arr[-1]


def get_no_zero_integers(n: int) -> list[int]:
    for first in range(1, n // 2 + 1):
        second = n - first
        if "0" not in str(first) and "0" not in str(second):
            return [first, second]
    return []


def maximum69_number(num: int) -> int:
    text = str(num)
    index = text.find("6")
    if index == -1:
        return num
    return int(text[:index] + "9" + text[index + 1 :])


def remove_palindrome_sub(s: str) -> int:
    if not s:
        return 0
    return 1 if s == s[::-1] else 2


def days_between_dates(date1: str, date2: str) -> int:
    def parse(text: str) -> date:
        year, month, day = map(int, text.split("-"))
        return date(year, month, day)

    return abs((parse(date1) - parse(date2)).days)


def smaller_numbers_than_current(nums: list[int]) -> list[int]:
    ordered = sorted(nums)
    rank: dict[int, int] = {}
    for index, value in enumerate(ordered):
        rank.setdefault(value, index)
    return [rank[value] for value in nums]


def sort_string(s: str) -> str:
    counts = [0] * 26
    for character in s:
        counts[ord(character) - ord("a")] += 1
    result: list[str] = []
    remaining = len(s)
    while remaining > 0:
        for index in range(26):
            if counts[index] > 0:
                result.append(chr(ord("a") + index))
                counts[index] -= 1
                remaining -= 1
        for index in range(25, -1, -1):
            if counts[index] > 0:
                result.append(chr(ord("a") + index))
                counts[index] -= 1
                remaining -= 1
    return "".join(result)


def generate_the_string(n: int) -> str:
    if n % 2 == 1:
        return "a" * n
    return "a" * (n - 1) + "b"


def lucky_numbers(matrix: list[list[int]]) -> list[int]:
    row_mins = [min(row) for row in matrix]
    columns = len(matrix[0])
    col_max = [max(matrix[row][column] for row in range(len(matrix))) for column in range(columns)]
    result: list[int] = []
    for row in range(len(matrix)):
        for column in range(columns):
            value = matrix[row][column]
            if value == row_mins[row] and value == col_max[column]:
                result.append(value)
    return sorted(result)


def count_largest_group(n: int) -> int:
    counts = Counter(sum(int(digit) for digit in str(value)) for value in range(1, n + 1))
    largest = max(counts.values())
    return sum(1 for size in counts.values() if size == largest)


def min_subsequence(nums: list[int]) -> list[int]:
    total = sum(nums)
    result: list[int] = []
    running = 0
    for value in sorted(nums, reverse=True):
        result.append(value)
        running += value
        if running > total - running:
            break
    return result


def string_matching(words: list[str]) -> list[str]:
    result: list[str] = []
    for index, word in enumerate(words):
        if any(index != other_index and word in other for other_index, other in enumerate(words)):
            result.append(word)
    return sorted(result, key=lambda word: (len(word), word))


def min_start_value(nums: list[int]) -> int:
    prefix = 0
    minimum = 0
    for value in nums:
        prefix += value
        minimum = min(minimum, prefix)
    return 1 - minimum


def reformat(s: str) -> str:
    letters = [character for character in s if character.isalpha()]
    digits = [character for character in s if character.isdigit()]
    if abs(len(letters) - len(digits)) > 1:
        return ""
    if len(letters) >= len(digits):
        first, second = letters, digits
    else:
        first, second = digits, letters
    result: list[str] = []
    for index in range(len(first)):
        result.append(first[index])
        if index < len(second):
            result.append(second[index])
    return "".join(result)


def max_score(s: str) -> int:
    ones_right = s.count("1")
    zeros_left = 0
    best = 0
    for index in range(len(s) - 1):
        if s[index] == "0":
            zeros_left += 1
        else:
            ones_right -= 1
        best = max(best, zeros_left + ones_right)
    return best


def dest_city(paths: list[list[str]]) -> str:
    departures = {start for start, _ in paths}
    for _, destination in paths:
        if destination not in departures:
            return destination
    return ""


def average(salary: list[int]) -> float:
    return (sum(salary) - min(salary) - max(salary)) / (len(salary) - 2)


def is_path_crossing(path: str) -> bool:
    x = y = 0
    visited = {(0, 0)}
    moves = {"N": (0, 1), "S": (0, -1), "E": (1, 0), "W": (-1, 0)}
    for step in path:
        delta_x, delta_y = moves[step]
        x += delta_x
        y += delta_y
        if (x, y) in visited:
            return True
        visited.add((x, y))
    return False


PROBLEMS = [
    make(
        pid=1700,
        title="按奇偶排序数组 II",
        tags=["数组", "双指针", "排序"],
        description="""给定一个长度为偶数且恰好一半是偶数、一半是奇数的整数数组 nums。
重排数组，使所有偶数位于偶数下标，所有奇数位于奇数下标，下标从 0 开始。
偶数之间保持它们在原数组中出现的先后顺序，奇数之间也保持原出现顺序。
2 <= nums.length <= 2 * 10^4，-10^3 <= nums[i] <= 10^3。""",
        function="sortArrayByParityII",
        params=[("nums", "int[]")],
        returns="int[]",
        solver=sort_array_by_parity_ii,
        public=[
            [[4, 2, 5, 7]],
            [[2, 3]],
            [[2, 1, 4, 3]],
        ],
        hidden=[
            [[1, 2]],
            [[3, 4]],
            [[2, 1, 4, 3, 6, 5]],
            [[0, 1, 2, 3]],
            [[8, 7, 6, 5, 4, 3]],
            [[-2, -1]],
        ],
    ),
    make(
        pid=1701,
        title="长按键入",
        tags=["字符串", "双指针"],
        description="""你在键盘上输入名字 name，某些按键可能被长按，导致一个字符在 typed 中出现一次或多次。
给定字符串 name 和实际输入的字符串 typed，判断 typed 是否可能由输入 name 时长按某些按键得到。
长按只会在同一字符上产生连续的重复，不会产生新的字符。
1 <= name.length <= 1000，1 <= typed.length <= 1000，两个字符串都只包含小写英文字母。""",
        function="isLongPressedName",
        params=[("name", "string"), ("typed", "string")],
        returns="bool",
        solver=is_long_pressed_name,
        public=[
            ["alex", "aaleex"],
            ["saeed", "ssaaedd"],
            ["leelee", "lleeelee"],
        ],
        hidden=[
            ["a", "a"],
            ["a", "aa"],
            ["a", "ab"],
            ["ab", "a"],
            ["alex", "alexx"],
            ["kikcxmvzi", "kiikcxxmmvvzzii"],
        ],
    ),
    make(
        pid=1702,
        title="在既定时间做作业的学生人数",
        tags=["数组", "模拟"],
        description="""给定两个长度相同的整数数组 startTime 和 endTime，以及整数 queryTime。
第 i 个学生在 startTime[i] 时刻开始做作业，在 endTime[i] 时刻结束，时间区间两端都包含。
返回在 queryTime 时刻正在做作业的学生人数。
1 <= startTime.length == endTime.length <= 100，1 <= startTime[i] <= endTime[i] <= 1000，1 <= queryTime <= 1000。""",
        function="busyStudent",
        params=[
            ("startTime", "int[]"),
            ("endTime", "int[]"),
            ("queryTime", "int"),
        ],
        returns="int",
        solver=busy_student,
        public=[
            [[1, 2, 3], [3, 2, 7], 4],
            [[4], [4], 4],
            [[1, 1, 1, 1], [1, 3, 2, 4], 7],
        ],
        hidden=[
            [[9, 8, 7, 6, 5, 4, 3, 2, 1], [10, 10, 10, 10, 10, 10, 10, 10, 10], 5],
            [[1], [2], 3],
            [[1], [1], 1],
            [[1, 2], [2, 3], 2],
            [[5, 6], [5, 6], 5],
            [[1, 3, 5], [2, 4, 6], 4],
        ],
    ),
    make(
        pid=1703,
        title="重新排列日志文件",
        tags=["字符串", "排序"],
        description="""给定日志数组 logs，每条日志是 "标识符 内容" 的形式，标识符由字母和数字组成，内容中不含空格以外的空白。
日志分为两类：内容以数字开头的为数字日志，其余为字母日志。
按以下规则排序：字母日志排在数字日志之前；字母日志按内容字典序升序排列，内容相同时按标识符字典序升序排列；
数字日志保持它们在原数组中的相对顺序。返回排序后的日志数组。
1 <= logs.length <= 100，3 <= logs[i].length <= 100。""",
        function="reorderLogFiles",
        params=[("logs", "string[]")],
        returns="string[]",
        solver=reorder_log_files,
        public=[
            [
                [
                    "dig1 8 1 5 1",
                    "let1 art can",
                    "dig2 3 6",
                    "let2 own kit dig",
                    "let3 art zero",
                ]
            ],
            [
                [
                    "a1 9 2 3 1",
                    "g1 act car",
                    "zo4 4 7",
                    "ab1 off key dog",
                    "a8 act zoo",
                ]
            ],
            [["let1 art", "dig1 1 2"]],
        ],
        hidden=[
            [["a1 1 2", "a2 3 4"]],
            [["a1 z", "a2 y"]],
            [["b2 x y", "a1 x y"]],
            [["d1 0", "l1 hello world"]],
            [["l2 abc def", "l1 abc def", "d9 9 9"]],
            [["z9 1", "z8 2", "m1 a b"]],
        ],
    ),
    make(
        pid=1704,
        title="删列造序",
        tags=["字符串", "数组", "模拟"],
        description="""给定由 n 个长度相同的字符串组成的数组 strs，这些字符串按行排列成一个字符矩阵。
若某一列中的字符不是按字典序非递减排列的，则需要删除该列。
返回需要删除的列数。
n == strs.length，1 <= n <= 100，1 <= strs[i].length <= 1000，所有字符串长度相同，只包含小写英文字母。""",
        function="minDeletionSize",
        params=[("strs", "string[]")],
        returns="int",
        solver=min_deletion_size,
        public=[
            [["cba", "daf", "ghi"]],
            [["a", "b"]],
            [["zyx", "wvu", "tsr"]],
        ],
        hidden=[
            [["abc"]],
            [["a", "b", "c"]],
            [["ab", "ba"]],
            [["zzz", "aaa"]],
            [["abcdef", "bcdefg", "cdefgh"]],
            [["c", "b", "a"]],
        ],
    ),
    make(
        pid=1705,
        title="查询后的偶数和",
        tags=["数组", "模拟"],
        description="""给定整数数组 nums 和查询数组 queries，每个查询是 [value, index]。
依次处理每个查询：执行 nums[index] += value，然后计算当前 nums 中所有偶数元素之和，记录该和。
返回由每次查询后的偶数和组成的数组。
1 <= nums.length <= 10^4，1 <= queries.length <= 10^4，-10^4 <= value <= 10^4，0 <= index < nums.length。""",
        function="sumEvenAfterQueries",
        params=[("nums", "int[]"), ("queries", "int[][]")],
        returns="int[]",
        solver=sum_even_after_queries,
        public=[
            [[1, 2, 3, 4], [[1, 0], [-3, 1], [-4, 0], [2, 3]]],
            [[1], [[4, 0]]],
            [[2, 2], [[1, 0], [2, 1]]],
        ],
        hidden=[
            [[1, 2, 3, 4], [[1, 0]]],
            [[0], [[0, 0]]],
            [[-1, -1], [[1, 0], [1, 1]]],
            [[1, 1], [[1, 0]]],
            [[2, -2], [[-2, 0], [2, 1]]],
        ],
    ),
    make(
        pid=1706,
        title="第 k 个缺失的正整数",
        tags=["数组", "二分查找"],
        description="""给定一个严格递增的正整数数组 arr 和整数 k。请找出第 k 个缺失的正整数。
缺失的正整数指所有正整数中未出现在 arr 里的数。返回第 k 个缺失的正整数。
1 <= arr.length <= 1000，1 <= arr[i] <= 1000，1 <= k <= 1000，arr 严格递增。""",
        function="findKthPositive",
        params=[("arr", "int[]"), ("k", "int")],
        returns="int",
        solver=find_kth_positive,
        public=[
            [[2, 3, 4, 7, 11], 5],
            [[1, 2, 3, 4], 2],
            [[1, 2, 3, 4], 1],
        ],
        hidden=[
            [[1], 1],
            [[2], 1],
            [[3, 4], 2],
            [[5, 6, 7], 3],
            [[1, 3], 2],
            [[1, 2, 3, 4, 5, 6, 7, 8], 5],
        ],
    ),
    make(
        pid=1707,
        title="除数博弈",
        tags=["数学", "博弈"],
        description="""黑板上有一个数字 n。两名玩家轮流操作，每名玩家在自己的回合选择一个满足 1 <= x < n 且 n % x == 0 的 x，
把黑板上的数字 n 替换为 n - x。无法操作的玩家输掉游戏。
Alice 先手，双方都采取最优策略，返回 Alice 是否必胜。
1 <= n <= 1000。""",
        function="divisorGame",
        params=[("n", "int")],
        returns="bool",
        solver=divisor_game,
        public=[[2], [3], [4]],
        hidden=[[1], [5], [6], [7], [8], [100]],
    ),
    make(
        pid=1708,
        title="距离顺序排列矩阵单元格",
        tags=["数组", "排序", "矩阵"],
        description="""给定矩阵的行数 rows、列数 cols，以及一个中心坐标 (rCenter, cCenter)，单元格坐标为 (r, c)。
按每个单元格到中心单元格的曼哈顿距离 |r - rCenter| + |c - cCenter| 升序排列所有单元格。
距离相同时，按行坐标升序排列；行坐标也相同时，按列坐标升序排列。
返回排好序的单元格坐标数组，每个元素为 [r, c]。1 <= rows, cols <= 100，0 <= rCenter < rows，0 <= cCenter < cols。""",
        function="allCellsDistOrder",
        params=[
            ("rows", "int"),
            ("cols", "int"),
            ("rCenter", "int"),
            ("cCenter", "int"),
        ],
        returns="int[][]",
        solver=all_cells_dist_order,
        public=[
            [1, 2, 0, 0],
            [2, 2, 0, 1],
            [2, 3, 1, 2],
        ],
        hidden=[
            [1, 1, 0, 0],
            [2, 2, 1, 1],
            [3, 1, 1, 0],
            [1, 3, 0, 1],
            [2, 2, 0, 0],
        ],
    ),
    make(
        pid=1709,
        title="最后一块石头的重量",
        tags=["数组", "堆", "模拟"],
        description="""有一堆石头，每块石头的重量为正整数。每次选出最重的两块石头 x 和 y（x <= y）并让它们相撞：
如果 x == y，两块石头都碎掉；如果 x < y，重量为 x 的石头碎掉，剩下重量为 y - x 的石头。
重复该过程直到最多只剩一块石头。返回最后剩下的石头的重量；如果没有石头剩下则返回 0。
1 <= stones.length <= 30，1 <= stones[i] <= 1000。""",
        function="lastStoneWeight",
        params=[("stones", "int[]")],
        returns="int",
        solver=last_stone_weight,
        public=[
            [[2, 7, 4, 1, 8, 1]],
            [[1]],
            [[2, 2]],
        ],
        hidden=[
            [[1, 3]],
            [[10, 4, 2, 10]],
            [[3, 7, 2]],
            [[5, 5, 5]],
            [[1, 2, 3, 4]],
            [[9, 3, 2, 10]],
        ],
    ),
    make(
        pid=1710,
        title="Bigram 分词",
        tags=["字符串", "数组"],
        description="""给定字符串 text 和两个单词 first、second。把 text 按空格拆分成单词数组。
找出所有满足条件的单词：该单词紧跟在一个等于 first 的单词和紧接着一个等于 second 的单词之后，
即存在下标 i，使 words[i] == first、words[i+1] == second，则 words[i+2] 是答案。
返回按出现顺序排列的答案单词数组；没有答案时返回空数组。匹配区分大小写。
1 <= text.length <= 1000，text 由小写英文字母和空格组成，1 <= first.length, second.length <= 10。""",
        function="findOcurrences",
        params=[("text", "string"), ("first", "string"), ("second", "string")],
        returns="string[]",
        solver=find_ocurrences,
        public=[
            ["alice is a good girl she is a good student", "a", "good"],
            ["we will we will rock you", "we", "will"],
            ["we will we will rock you", "will", "we"],
        ],
        hidden=[
            ["a b c", "a", "b"],
            ["a a a", "a", "a"],
            ["a b", "a", "b"],
            ["x y z x y", "x", "y"],
            ["a b c a b c", "a", "b"],
            ["hello world", "hello", "world"],
        ],
    ),
    make(
        pid=1711,
        title="分糖果 II",
        tags=["数组", "模拟", "数学"],
        description="""有 candies 颗糖果，要分给 num_people 个人。第一个人拿 1 颗，第二个人拿 2 颗，依此类推，
直到每个人拿到一轮。然后回到第一个人，他拿 num_people + 1 颗，第二个人拿 num_people + 2 颗，继续递增。
当剩余糖果不足当前应拿的数量时，把剩余的全部给当前这个人。
返回长度为 num_people 的数组，表示每个人最终得到的糖果数。
0 <= candies <= 10^9，1 <= num_people <= 1000。""",
        function="distributeCandies",
        params=[("candies", "int"), ("num_people", "int")],
        returns="int[]",
        solver=distribute_candies,
        public=[
            [7, 4],
            [10, 3],
            [1, 1],
        ],
        hidden=[
            [2, 2],
            [3, 2],
            [4, 3],
            [6, 3],
            [0, 5],
            [11, 3],
        ],
    ),
    make(
        pid=1712,
        title="数组的相对排序",
        tags=["数组", "哈希表", "排序"],
        description="""给定两个数组 arr1 和 arr2。arr2 中的元素互不相同，且都出现在 arr1 中。
按以下规则对 arr1 的元素排序：arr2 中出现的元素按其首次出现的顺序排在前面（arr2 中每个元素对应的 arr1 元素全部排在一起），
arr1 中未出现在 arr2 中的元素按升序排在后面。返回排序后的数组。
1 <= arr1.length, arr2.length <= 1000，0 <= arr1[i], arr2[i] <= 1000。""",
        function="relativeSortArray",
        params=[("arr1", "int[]"), ("arr2", "int[]")],
        returns="int[]",
        solver=relative_sort_array,
        public=[
            [[2, 3, 1, 3, 2, 4, 6, 7, 9, 2, 19], [2, 1, 4, 3, 9, 6]],
            [[28, 6, 22, 8, 44, 17], [22, 28, 8, 6]],
            [[1, 2, 3], [3, 2, 1]],
        ],
        hidden=[
            [[5, 5, 5], [5]],
            [[1, 2], [2]],
            [[3, 1, 2], [1, 3]],
            [[7, 7, 8, 8], [8]],
            [[0, -1, 2], [2, 0]],
            [[4, 4], [4]],
        ],
    ),
    make(
        pid=1713,
        title="拼写单词",
        tags=["数组", "哈希表", "字符串"],
        description="""给定字符串数组 words 和一个字符串 chars（其中每类字符只能使用一次）。
如果拼写某个单词所需的字符都能从 chars 中取得（每个字符使用次数不能超过它在 chars 中出现的次数），
则该单词可以被拼写。返回所有可拼写单词的长度之和。
1 <= words.length <= 1000，1 <= words[i].length, chars.length <= 100，均为小写英文字母。""",
        function="countCharacters",
        params=[("words", "string[]"), ("chars", "string")],
        returns="int",
        solver=count_characters,
        public=[
            [["cat", "bt", "hat", "tree"], "atach"],
            [["hello", "world", "leetcode"], "welldonehoneyr"],
            [["a"], "a"],
        ],
        hidden=[
            [["ab"], "a"],
            [["ab"], "ab"],
            [["a", "b", "c"], "abc"],
            [["aa", "bb"], "ab"],
            [["xyz"], "zyx"],
            [["aabb"], "ab"],
        ],
    ),
    make(
        pid=1714,
        title="质数排列",
        tags=["数学", "排列组合"],
        description="""给定整数 n，构造 1 到 n 的一个排列。若排列中每个质数都位于质数下标（下标从 1 开始），
则称该排列为合法排列。返回合法排列的数目，答案对 10^9 + 7 取模。
1 <= n <= 100。""",
        function="numPrimeArrangements",
        params=[("n", "int")],
        returns="int",
        solver=num_prime_arrangements,
        public=[[5], [100], [1]],
        hidden=[[2], [3], [4], [10], [20], [50]],
    ),
    make(
        pid=1715,
        title="公交站间的距离",
        tags=["数组", "模拟"],
        description="""环形公交线路有 n 个站点，编号 0 到 n-1。distance[i] 表示站点 i 到站点 (i + 1) % n 的距离。
给定起点 start 和终点 destination，你可以顺时针或逆时针沿线路行驶，
返回从 start 到 destination 的最短距离。
1 <= distance.length <= 10^4，1 <= distance[i] <= 10^4，0 <= start, destination < n。""",
        function="distanceBetweenBusStops",
        params=[("distance", "int[]"), ("start", "int"), ("destination", "int")],
        returns="int",
        solver=distance_between_bus_stops,
        public=[
            [[1, 2, 3, 4], 0, 1],
            [[1, 2, 3, 4], 0, 2],
            [[1, 2, 3, 4], 0, 3],
        ],
        hidden=[
            [[7, 10, 1, 12, 11, 14, 5, 0], 7, 2],
            [[1, 2], 0, 1],
            [[1, 2], 1, 0],
            [[5, 1, 4], 2, 1],
            [[3, 6, 2], 0, 2],
            [[1, 1, 1, 1], 3, 0],
        ],
    ),
    make(
        pid=1716,
        title="一周中的第几天",
        tags=["数学", "日期"],
        description="""给定日期中的日 day、月 month、年 year，返回这一天是星期几。
返回值必须是以下英文名称之一："Monday"、"Tuesday"、"Wednesday"、"Thursday"、"Friday"、"Saturday"、"Sunday"。
输入日期是 1971 年到 2100 年之间的合法日期。""",
        function="dayOfTheWeek",
        params=[("day", "int"), ("month", "int"), ("year", "int")],
        returns="string",
        solver=day_of_the_week,
        public=[
            [31, 8, 2019],
            [18, 7, 1999],
            [15, 8, 1993],
            [1, 1, 1971],
        ],
        hidden=[
            [1, 1, 2000],
            [29, 2, 2020],
            [31, 12, 1999],
            [1, 3, 2024],
            [25, 12, 2025],
            [1, 1, 2100],
        ],
    ),
    make(
        pid=1717,
        title="“气球” 的最大数量",
        tags=["字符串", "哈希表", "计数"],
        description="""给定字符串 text，其中只包含小写英文字母。使用 text 中的字符（每个字符最多使用一次）拼出尽可能多的单词 "balloon"。
返回最多能拼出的 "balloon" 的个数。
1 <= text.length <= 10^4。""",
        function="maxNumberOfBalloons",
        params=[("text", "string")],
        returns="int",
        solver=max_number_of_balloons,
        public=[
            ["nlaebolko"],
            ["loonbalxballpoon"],
            ["leetcode"],
        ],
        hidden=[
            ["balloon"],
            ["balloonballoon"],
            ["balon"],
            ["b"],
            ["llooonnnbbaa"],
            ["Balloon"],
        ],
    ),
    make(
        pid=1718,
        title="奇数值单元格的数目",
        tags=["数组", "矩阵", "模拟"],
        description="""给定 m 行 n 列的矩阵，初始时所有单元格的值都是 0。另给一个二维索引数组 indices，
其中每个元素 [row, column] 表示对第 row 行的所有单元格加 1，并对第 column 列的所有单元格加 1。
依次执行所有操作后，返回矩阵中值为奇数的单元格数目。
1 <= m, n <= 50，0 <= indices.length <= 100，0 <= indices[i][0] < m，0 <= indices[i][1] < n。""",
        function="oddCells",
        params=[("m", "int"), ("n", "int"), ("indices", "int[][]")],
        returns="int",
        solver=odd_cells,
        public=[
            [2, 3, [[0, 1], [1, 1]]],
            [2, 2, [[1, 1], [0, 0]]],
            [1, 1, [[0, 0]]],
        ],
        hidden=[
            [1, 1, []],
            [2, 2, []],
            [3, 3, [[0, 0]]],
            [2, 3, [[0, 0], [0, 1], [1, 0]]],
            [1, 5, [[0, 2]]],
        ],
    ),
    make(
        pid=1719,
        title="二维网格迁移",
        tags=["数组", "矩阵", "模拟"],
        description="""给定 m 行 n 列的二维整数网格 grid 和整数 k。每次迁移操作把每个元素向右移动一个位置，
移出右边界的元素回到下一行的第一个位置，最后一行的最后一个元素回到第一行第一个位置。
返回恰好执行 k 次迁移后的网格。
1 <= m, n <= 50，0 <= k <= 10^9，-1000 <= grid[i][j] <= 1000。""",
        function="shiftGrid",
        params=[("grid", "int[][]"), ("k", "int")],
        returns="int[][]",
        solver=shift_grid,
        public=[
            [[[1, 2, 3], [4, 5, 6], [7, 8, 9]], 1],
            [[[3, 8, 1, 9], [19, 7, 2, 5], [4, 6, 11, 10], [12, 0, 21, 13]], 4],
            [[[1, 2], [3, 4]], 2],
        ],
        hidden=[
            [[[1]], 1],
            [[[1, 2], [3, 4]], 0],
            [[[1, 2, 3]], 1],
            [[[1], [2], [3]], 1],
            [[[1, 2, 3], [4, 5, 6]], 7],
            [[[1, 2], [3, 4]], 1000],
        ],
    ),
    make(
        pid=1720,
        title="有序数组中出现次数超过25%的元素",
        tags=["数组"],
        description="""给定一个按非递减顺序排列的整数数组 arr，已知恰好存在一个整数，它在数组中出现的次数严格超过数组长度的 25%。
返回该整数。
1 <= arr.length <= 10^4，0 <= arr[i] <= 10^5。""",
        function="findSpecialInteger",
        params=[("arr", "int[]")],
        returns="int",
        solver=find_special_integer,
        public=[
            [[1, 2, 2, 6, 6, 6, 6, 7, 10]],
            [[1, 1]],
            [[1, 2, 3, 3]],
        ],
        hidden=[
            [[1]],
            [[1, 1, 1, 2, 3, 4, 5, 6]],
            [[4, 4, 4, 4, 4, 5, 6, 7]],
            [[1, 1, 1, 2, 2, 3, 3, 4]],
            [[1, 1, 1, 1, 1, 2, 2, 2, 3, 3, 3, 4, 4, 4, 5, 5]],
            [[2, 2, 2, 2, 3, 4, 5, 6, 7, 8]],
        ],
    ),
    make(
        pid=1721,
        title="将整数转换为两个无零整数之和",
        tags=["数学"],
        description="""给定整数 n，返回两个整数 a 和 b，满足 a + b == n，且 a 和 b 的十进制表示中都不含数字 0。
要求 a <= b，并在所有满足条件的数对中选择 a 最小的那一对。返回数组 [a, b]。
2 <= n <= 10^4，题目保证至少存在一组解。""",
        function="getNoZeroIntegers",
        params=[("n", "int")],
        returns="int[]",
        solver=get_no_zero_integers,
        public=[
            [2],
            [11],
            [19],
            [10000],
        ],
        hidden=[
            [3],
            [8],
            [10],
            [69],
            [101],
            [9999],
        ],
    ),
    make(
        pid=1722,
        title="6 和 9 组成的最大数字",
        tags=["数学", "贪心"],
        description="""给定一个只由数字 6 和 9 组成的正整数 num，最多可以将其中一位数字从 6 翻转成 9（也可以不翻转）。
返回能得到的最大数字。
1 <= num <= 10^4。""",
        function="maximum69Number",
        params=[("num", "int")],
        returns="int",
        solver=maximum69_number,
        public=[
            [9669],
            [9996],
            [9999],
        ],
        hidden=[
            [6],
            [9],
            [66],
            [69],
            [966],
            [6969],
        ],
    ),
    make(
        pid=1723,
        title="删除回文子序列",
        tags=["字符串", "双指针"],
        description="""给定一个只包含字母 'a' 和 'b' 的字符串 s。每次操作可以删除 s 中的一个非空回文子序列。
返回删除整个字符串所需的最少操作次数。空字符串视为已删除。
1 <= s.length <= 1000。""",
        function="removePalindromeSub",
        params=[("s", "string")],
        returns="int",
        solver=remove_palindrome_sub,
        public=[
            ["ababa"],
            ["abb"],
            ["baabb"],
        ],
        hidden=[
            ["a"],
            ["ab"],
            ["aa"],
            ["aba"],
            ["abca"],
            ["abcba"],
        ],
    ),
    make(
        pid=1724,
        title="日期之间隔几天",
        tags=["数学", "日期"],
        description="""给定两个日期字符串 date1 和 date2，格式均为 "YYYY-MM-DD"。
返回这两个日期之间相差的天数（取绝对值）。
两个日期都是 1971 年到 2100 年之间的合法日期。""",
        function="daysBetweenDates",
        params=[("date1", "string"), ("date2", "string")],
        returns="int",
        solver=days_between_dates,
        public=[
            ["2019-06-29", "2019-06-30"],
            ["2020-01-15", "2019-12-31"],
            ["1971-01-01", "1971-01-01"],
        ],
        hidden=[
            ["2000-01-01", "2000-01-02"],
            ["2020-02-28", "2020-03-01"],
            ["2019-02-28", "2019-03-01"],
            ["1971-01-01", "2100-01-01"],
            ["2024-12-31", "2025-01-01"],
            ["2000-02-28", "2000-03-01"],
        ],
    ),
    make(
        pid=1725,
        title="有多少小于当前数字的数字",
        tags=["数组", "哈希表", "排序"],
        description="""给定数组 nums，对每个元素 nums[i]，统计数组中严格小于它的元素个数。
返回与 nums 等长的数组作为答案。
1 <= nums.length <= 500，0 <= nums[i] <= 100。""",
        function="smallerNumbersThanCurrent",
        params=[("nums", "int[]")],
        returns="int[]",
        solver=smaller_numbers_than_current,
        public=[
            [[8, 1, 2, 2, 3]],
            [[6, 5, 4, 8]],
            [[7, 7, 7, 7]],
        ],
        hidden=[
            [[1]],
            [[1, 2]],
            [[2, 1]],
            [[3, 3, 3]],
            [[5, 4, 3, 2, 1]],
            [[1, 1, 2]],
        ],
    ),
    make(
        pid=1726,
        title="上升下降字符串",
        tags=["字符串", "哈希表", "计数"],
        description="""给定字符串 s，按以下算法重新排列字符：
从剩余字符中选出最小字符并追加；然后不断选出比上一个追加字符大的最小剩余字符并追加，直到无法继续；
接着选出最大字符并追加，再不断选出比上一个追加字符小的最大剩余字符并追加，直到无法继续；
重复上述上升、下降过程，直到所有字符都被使用。返回重排后的字符串。
1 <= s.length <= 500，s 只包含小写英文字母。""",
        function="sortString",
        params=[("s", "string")],
        returns="string",
        solver=sort_string,
        public=[
            ["aaaabbbbcccc"],
            ["rat"],
            ["leetcode"],
        ],
        hidden=[
            ["a"],
            ["ab"],
            ["abc"],
            ["aab"],
            ["mississippi"],
            ["zzzzzz"],
        ],
    ),
    make(
        pid=1727,
        title="生成每种字符都是奇数个的字符串",
        tags=["字符串"],
        description="""给定整数 n，返回一个长度为 n 的字符串，使其中每种出现的字符都恰好出现奇数次。
要求：当 n 为奇数时返回 n 个 'a'；当 n 为偶数时返回 n-1 个 'a' 后接 1 个 'b'。
1 <= n <= 500。""",
        function="generateTheString",
        params=[("n", "int")],
        returns="string",
        solver=generate_the_string,
        public=[[1], [2], [3], [4]],
        hidden=[[5], [6], [7], [10], [11], [100]],
    ),
    make(
        pid=1728,
        title="矩阵中的幸运数",
        tags=["数组", "矩阵"],
        description="""给定一个 m 行 n 列的矩阵，矩阵中的数字互不相同。
如果一个元素同时是所在行的最小值且是所在列的最大值，则称它为幸运数。
按升序返回矩阵中所有幸运数组成的数组；没有幸运数时返回空数组。
1 <= m, n <= 50，1 <= matrix[i][j] <= 10^5，矩阵中所有元素互不相同。""",
        function="luckyNumbers",
        params=[("matrix", "int[][]")],
        returns="int[]",
        solver=lucky_numbers,
        public=[
            [[[3, 7, 8], [9, 11, 13], [15, 16, 17]]],
            [[[1, 10, 4, 2], [9, 3, 8, 7], [15, 16, 17, 12]]],
            [[[7, 8], [1, 2]]],
        ],
        hidden=[
            [[[1]]],
            [[[1, 2], [3, 4]]],
            [[[5, 6], [7, 8]]],
            [[[3, 6], [7, 9]]],
            [[[1, 2, 3], [4, 5, 6], [7, 8, 9]]],
            [[[9, 8], [7, 6]]],
        ],
    ),
    make(
        pid=1729,
        title="统计最大组的数目",
        tags=["哈希表", "数学"],
        description="""把 1 到 n 的每个整数按其十进制各位数字之和分组。
返回元素个数最多的那些组的组数（若多个组的元素个数并列最多，统计这些组的数量）。
1 <= n <= 10^4。""",
        function="countLargestGroup",
        params=[("n", "int")],
        returns="int",
        solver=count_largest_group,
        public=[[13], [2], [24]],
        hidden=[[1], [9], [10], [11], [100], [1000], [10000]],
    ),
    make(
        pid=1730,
        title="非递增顺序的最小子序列",
        tags=["数组", "贪心", "排序"],
        description="""给定数组 nums，从中选出一个子序列，使该子序列的元素之和严格大于剩余元素之和。
在所有满足条件的子序列中，选择长度最短的；若长度相同，选择和最大的。
返回该子序列，按非递增顺序排列。
1 <= nums.length <= 500，1 <= nums[i] <= 100。""",
        function="minSubsequence",
        params=[("nums", "int[]")],
        returns="int[]",
        solver=min_subsequence,
        public=[
            [[4, 3, 10, 9, 8]],
            [[4, 4, 7, 6, 7]],
            [[6]],
        ],
        hidden=[
            [[1, 2]],
            [[1, 2, 3, 4, 5]],
            [[2, 3, 4]],
            [[10, 1]],
            [[5, 4, 3]],
            [[1, 2, 3]],
        ],
    ),
    make(
        pid=1731,
        title="数组中的字符串匹配",
        tags=["字符串", "数组"],
        description="""给定字符串数组 words，其中所有字符串互不相同。若某个字符串是数组中另一个字符串的子串，
则称它为可匹配字符串。返回所有可匹配字符串，按长度升序排列，长度相同时按字典序升序排列。
1 <= words.length <= 100，1 <= words[i].length <= 30，words[i] 只包含小写英文字母且互不相同。""",
        function="stringMatching",
        params=[("words", "string[]")],
        returns="string[]",
        solver=string_matching,
        public=[
            [["mass", "as", "hero", "superhero"]],
            [["leetcode", "et", "code"]],
            [["blue", "green", "bu"]],
        ],
        hidden=[
            [["a", "ab", "abc"]],
            [["xyz", "xy", "x"]],
            [["a", "b", "c"]],
            [["mass", "as", "hero", "superhero", "super"]],
            [["aaa", "aa", "a"]],
            [["abc", "bc", "c", "abcd"]],
        ],
    ),
    make(
        pid=1732,
        title="逐步求和得到正数的最小值",
        tags=["数组", "前缀和"],
        description="""给定整数数组 nums。选择一个正数 startValue 作为初始值。
从左到右累加 nums 中的元素，要求任意时刻的累加和都大于等于 1。
返回满足条件的最小正整数 startValue。
1 <= nums.length <= 100，-100 <= nums[i] <= 100。""",
        function="minStartValue",
        params=[("nums", "int[]")],
        returns="int",
        solver=min_start_value,
        public=[
            [[-3, 2, -3, 4, 2]],
            [[1, 2]],
            [[1, -2, -3]],
        ],
        hidden=[
            [[-3]],
            [[2, 3]],
            [[0]],
            [[-1, -1]],
            [[5, -10, 4]],
            [[2, -1, 2]],
        ],
    ),
    make(
        pid=1733,
        title="重新格式化字符串",
        tags=["字符串", "双指针"],
        description="""给定一个由小写英文字母和数字组成的字符串 s（可能包含两者或只包含其中一种）。
重排字符，使任意两个相邻字符都不是同一类型（字母与数字交替）。
若无法做到则返回空字符串。可以做到时，按以下规则给出唯一结果：
字母数不少于数字数时以字母开头，否则以数字开头；同一类型内部保持字符在原字符串中的相对顺序。
1 <= s.length <= 500。""",
        function="reformat",
        params=[("s", "string")],
        returns="string",
        solver=reformat,
        public=[
            ["a0b1c2"],
            ["leetcode"],
            ["1229857369"],
            ["covid2019"],
        ],
        hidden=[
            ["ab123"],
            ["a1"],
            ["1a"],
            ["abc12"],
            ["a0"],
            ["aa00"],
        ],
    ),
    make(
        pid=1734,
        title="分割字符串的最大得分",
        tags=["字符串", "前缀和"],
        description="""给定一个由 '0' 和 '1' 组成的字符串 s，把 s 在下标 i 处分割成两个非空子串，
左子串为 s[0..i]，右子串为 s[i+1..n-1]。
得分为左子串中 '0' 的个数加上右子串中 '1' 的个数。返回所有分割方式中的最大得分。
2 <= s.length <= 500。""",
        function="maxScore",
        params=[("s", "string")],
        returns="int",
        solver=max_score,
        public=[
            ["011101"],
            ["00111"],
            ["1111"],
        ],
        hidden=[
            ["01"],
            ["10"],
            ["00"],
            ["0000"],
            ["0100"],
            ["101101"],
        ],
    ),
    make(
        pid=1735,
        title="旅行终点站",
        tags=["数组", "哈希表", "图"],
        description="""给定旅行路线数组 paths，其中每条路线是 [出发城市, 到达城市]。
所有城市用字符串表示，路线构成一条从某个起点城市出发、最终到达某个终点城市的链，不会形成环。
终点城市是只作为到达城市出现、从不作为出发城市出现的城市。返回终点城市。
1 <= paths.length <= 100，路径构成唯一的链。""",
        function="destCity",
        params=[("paths", "string[][]")],
        returns="string",
        solver=dest_city,
        public=[
            [
                [
                    ["London", "New York"],
                    ["New York", "Lima"],
                    ["Lima", "Sao Paulo"],
                ]
            ],
            [[["B", "C"], ["D", "B"], ["C", "A"]]],
            [[["A", "Z"]]],
        ],
        hidden=[
            [[["A", "B"], ["B", "C"], ["C", "D"]]],
            [[["X", "Y"]]],
            [[["P", "Q"], ["R", "P"], ["Q", "S"]]],
            [[["a", "b"], ["c", "d"], ["b", "c"]]],
            [[["A", "B"], ["C", "D"], ["B", "C"], ["E", "A"]]],
            [[["M", "N"]]],
        ],
    ),
    make(
        pid=1736,
        title="去掉最低工资和最高工资后的工资平均值",
        tags=["数组", "排序"],
        description="""给定整数数组 salary，其中每个元素表示一个人的工资。去掉一个最低工资和一个最高工资后，
计算剩余工资的平均值。返回该平均值，结果与标准答案的误差在 10^-5 以内均视为正确。
3 <= salary.length <= 100，1000 <= salary[i] <= 10^6，salary 中所有元素互不相同。""",
        function="average",
        params=[("salary", "int[]")],
        returns="double",
        solver=average,
        compare={"mode": "double"},
        public=[
            [[4000, 3000, 1000, 2000]],
            [[1000, 2000, 3000]],
            [[6000, 5000, 4000, 3000, 2000, 1000]],
            [[8000, 9000, 2000, 3000, 6000, 1000]],
        ],
        hidden=[
            [[1, 2, 3]],
            [[10, 20, 30, 40]],
            [[5, 4, 3, 2, 1]],
            [[1, 1000, 100000]],
            [[100, 200, 300, 400, 500]],
            [[2000, 4000, 6000, 8000, 10000]],
        ],
    ),
    make(
        pid=1737,
        title="判断路径是否相交",
        tags=["字符串", "哈希表", "模拟"],
        description="""从二维平面上的原点 (0, 0) 出发，按字符串 path 中的字符依次移动：
'N' 表示向北（y 加 1），'S' 表示向南（y 减 1），'E' 表示向东（x 加 1），'W' 表示向西（x 减 1）。
如果路径在任意时刻（包括经过原点）到达之前已经访问过的点，则返回 true，否则返回 false。
1 <= path.length <= 10^4，path 只包含 'N'、'S'、'E'、'W'。""",
        function="isPathCrossing",
        params=[("path", "string")],
        returns="bool",
        solver=is_path_crossing,
        public=[
            ["NES"],
            ["NESWW"],
            ["N"],
        ],
        hidden=[
            ["NNS"],
            ["NN"],
            ["SN"],
            ["ENWS"],
            ["SS"],
            ["NSEW"],
        ],
    ),
]
