"""1500-1537：批量第二批简单题（38 道）。"""

from __future__ import annotations

import re
from collections import Counter
from functools import partial
from math import gcd, isqrt

from problem_seed_common import make_problem

make = partial(make_problem, difficulty="easy")


def implement_strstr(haystack: str, needle: str) -> int:
    return haystack.find(needle)


def length_of_last_word(s: str) -> int:
    return len(s.split()[-1])


def my_sqrt(x: int) -> int:
    return isqrt(x)


def contains_duplicate(nums: list[int]) -> bool:
    return len(set(nums)) != len(nums)


def count_primes(n: int) -> int:
    if n < 3:
        return 0
    sieve = [True] * n
    sieve[0] = sieve[1] = False
    for value in range(2, isqrt(n) + 1):
        if sieve[value]:
            sieve[value * value : n : value] = [False] * len(
                range(value * value, n, value)
            )
    return sum(sieve)


def can_win_nim(n: int) -> bool:
    return n % 4 != 0


def is_power_of_two(n: int) -> bool:
    return n > 0 and n & (n - 1) == 0


def valid_palindrome_ii(s: str) -> bool:
    def is_palindrome(left: int, right: int) -> bool:
        while left < right:
            if s[left] != s[right]:
                return False
            left += 1
            right -= 1
        return True

    left, right = 0, len(s) - 1
    while left < right:
        if s[left] != s[right]:
            return is_palindrome(left + 1, right) or is_palindrome(left, right - 1)
        left += 1
        right -= 1
    return True


def most_common_word(paragraph: str, banned: list[str]) -> str:
    banned_set = set(banned)
    words = re.findall(r"[a-zA-Z]+", paragraph.lower())
    counts = Counter(word for word in words if word not in banned_set)
    return max(counts, key=counts.get)


def count_segments(s: str) -> int:
    return len(s.split())


def sum_zero(n: int) -> list[int]:
    result = []
    for value in range(1, n // 2 + 1):
        result.extend([value, -value])
    if n % 2 == 1:
        result.append(0)
    return result


def find_words(words: list[str]) -> list[str]:
    rows = [set("qwertyuiop"), set("asdfghjkl"), set("zxcvbnm")]
    result = []
    for word in words:
        lowered = word.lower()
        if any(all(character in row for character in lowered) for row in rows):
            result.append(word)
    return result


def reverse_words_iii(s: str) -> str:
    return " ".join(word[::-1] for word in s.split(" "))


def find_restaurant(list1: list[str], list2: list[str]) -> list[str]:
    index2 = {name: index for index, name in enumerate(list2)}
    best = None
    result = []
    for index, name in enumerate(list1):
        if name in index2:
            total = index + index2[name]
            if best is None or total < best:
                best = total
                result = [name]
            elif total == best:
                result.append(name)
    return sorted(result)


def shortest_to_char(s: str, c: str) -> list[int]:
    length = len(s)
    result = [length] * length
    position = -length
    for index in range(length):
        if s[index] == c:
            position = index
        result[index] = index - position
    position = 2 * length
    for index in range(length - 1, -1, -1):
        if s[index] == c:
            position = index
        result[index] = min(result[index], position - index)
    return result


def dominant_index(nums: list[int]) -> int:
    largest = max(nums)
    index = nums.index(largest)
    for position, value in enumerate(nums):
        if position != index and value * 2 > largest:
            return -1
    return index


def find_lhs(nums: list[int]) -> int:
    counts = Counter(nums)
    best = 0
    for value, count in counts.items():
        if value + 1 in counts:
            best = max(best, count + counts[value + 1])
    return best


def binary_search(nums: list[int], target: int) -> int:
    left, right = 0, len(nums) - 1
    while left <= right:
        middle = (left + right) // 2
        if nums[middle] == target:
            return middle
        if nums[middle] < target:
            left = middle + 1
        else:
            right = middle - 1
    return -1


def number_of_lines(widths: list[int], s: str) -> list[int]:
    lines = 1
    current = 0
    for character in s:
        width = widths[ord(character) - ord("a")]
        if current + width > 100:
            lines += 1
            current = width
        else:
            current += width
    return [lines, current]


def flip_and_invert_image(image: list[list[int]]) -> list[list[int]]:
    return [[1 - value for value in reversed(row)] for row in image]


def smallest_range_i(nums: list[int], k: int) -> int:
    return max(0, max(nums) - min(nums) - 2 * k)


def di_string_match(s: str) -> list[int]:
    low, high = 0, len(s)
    result = []
    for character in s:
        if character == "I":
            result.append(low)
            low += 1
        else:
            result.append(high)
            high -= 1
    result.append(low)
    return result


def repeated_n_times(nums: list[int]) -> int:
    counts = Counter(nums)
    target = len(nums) // 2
    for value, count in counts.items():
        if count == target:
            return value
    return -1


def valid_mountain_array(nums: list[int]) -> bool:
    if len(nums) < 3:
        return False
    index = 0
    while index + 1 < len(nums) and nums[index] < nums[index + 1]:
        index += 1
    if index == 0 or index == len(nums) - 1:
        return False
    while index + 1 < len(nums) and nums[index] > nums[index + 1]:
        index += 1
    return index == len(nums) - 1


def gcd_of_strings(str1: str, str2: str) -> str:
    if str1 + str2 != str2 + str1:
        return ""
    return str1[: gcd(len(str1), len(str2))]


def num_rook_captures(board: list[list[str]]) -> int:
    rook_row = rook_col = -1
    for row in range(8):
        for column in range(8):
            if board[row][column] == "R":
                rook_row, rook_col = row, column
    count = 0
    for delta_row, delta_col in ((1, 0), (-1, 0), (0, 1), (0, -1)):
        row, column = rook_row + delta_row, rook_col + delta_col
        while 0 <= row < 8 and 0 <= column < 8:
            cell = board[row][column]
            if cell == "p":
                count += 1
                break
            if cell == "B":
                break
            row += delta_row
            column += delta_col
    return count


def peak_index_in_mountain_array(arr: list[int]) -> int:
    left, right = 0, len(arr) - 1
    while left < right:
        middle = (left + right) // 2
        if arr[middle] < arr[middle + 1]:
            left = middle + 1
        else:
            right = middle
    return left


def is_toeplitz_matrix(matrix: list[list[int]]) -> bool:
    for row in range(1, len(matrix)):
        for column in range(1, len(matrix[0])):
            if matrix[row][column] != matrix[row - 1][column - 1]:
                return False
    return True


def is_alien_sorted(words: list[str], order: str) -> bool:
    rank = {character: index for index, character in enumerate(order)}

    def in_order(first: str, second: str) -> bool:
        for left, right in zip(first, second):
            if left != right:
                return rank[left] < rank[right]
        return len(first) <= len(second)

    return all(in_order(words[i], words[i + 1]) for i in range(len(words) - 1))


def find_judge(n: int, trust: list[list[int]]) -> int:
    indegree = [0] * (n + 1)
    outdegree = [0] * (n + 1)
    for source, target in trust:
        outdegree[source] += 1
        indegree[target] += 1
    for person in range(1, n + 1):
        if indegree[person] == n - 1 and outdegree[person] == 0:
            return person
    return -1


def sort_sentence(s: str) -> str:
    words = s.split()
    ordered = [""] * len(words)
    for word in words:
        ordered[int(word[-1]) - 1] = word[:-1]
    return " ".join(ordered)


def count_good_triplets(arr: list[int], a: int, b: int, c: int) -> int:
    total = 0
    for i in range(len(arr)):
        for j in range(i + 1, len(arr)):
            if abs(arr[i] - arr[j]) > a:
                continue
            for k in range(j + 1, len(arr)):
                if abs(arr[j] - arr[k]) <= b and abs(arr[i] - arr[k]) <= c:
                    total += 1
    return total


def find_rotation(mat: list[list[int]], target: list[list[int]]) -> bool:
    current = [row[:] for row in mat]
    for _ in range(4):
        if current == target:
            return True
        current = [list(row) for row in zip(*current[::-1])]
    return False


def find_center(edges: list[list[int]]) -> int:
    if len(edges) == 1:
        return edges[0][0]
    first_a, first_b = edges[0]
    second_a, second_b = edges[1]
    if first_a == second_a or first_a == second_b:
        return first_a
    return first_b


def array_strings_are_equal(word1: list[str], word2: list[str]) -> bool:
    return "".join(word1) == "".join(word2)


def image_smoother(img: list[list[int]]) -> list[list[int]]:
    rows, columns = len(img), len(img[0])
    result = [[0] * columns for _ in range(rows)]
    for row in range(rows):
        for column in range(columns):
            total = 0
            count = 0
            for delta_row in (-1, 0, 1):
                for delta_column in (-1, 0, 1):
                    next_row = row + delta_row
                    next_column = column + delta_column
                    if 0 <= next_row < rows and 0 <= next_column < columns:
                        total += img[next_row][next_column]
                        count += 1
            result[row][column] = total // count
    return result


def truncate_sentence(s: str, k: int) -> str:
    return " ".join(s.split()[:k])


def construct_2d_array(original: list[int], m: int, n: int) -> list[list[int]]:
    if m * n != len(original):
        return []
    return [original[index * n : (index + 1) * n] for index in range(m)]


ROOK_BOARD_A = [
    [".", ".", ".", ".", ".", ".", ".", "."],
    [".", ".", ".", "p", ".", ".", ".", "."],
    [".", ".", ".", "R", ".", ".", ".", "p"],
    [".", ".", ".", ".", ".", ".", ".", "."],
    [".", ".", ".", ".", ".", ".", ".", "."],
    [".", ".", ".", "p", ".", ".", ".", "."],
    [".", ".", ".", ".", ".", ".", ".", "."],
    [".", ".", ".", ".", ".", ".", ".", "."],
]

ROOK_BOARD_B = [
    [".", ".", ".", ".", ".", ".", ".", "."],
    [".", ".", ".", "p", ".", ".", ".", "."],
    [".", ".", ".", "B", ".", ".", ".", "."],
    [".", ".", ".", "R", ".", "B", ".", "p"],
    [".", ".", ".", "p", ".", ".", ".", "."],
    [".", ".", ".", ".", ".", ".", ".", "."],
    [".", ".", ".", ".", ".", ".", ".", "."],
    [".", ".", ".", ".", ".", ".", ".", "."],
]

ROOK_BOARD_C = [
    [".", ".", ".", ".", "p", ".", ".", "."],
    [".", ".", ".", ".", ".", ".", ".", "."],
    [".", ".", ".", ".", ".", ".", ".", "."],
    [".", ".", ".", ".", ".", ".", ".", "."],
    [".", ".", ".", ".", "R", ".", ".", "."],
    [".", ".", ".", ".", ".", ".", ".", "."],
    [".", ".", ".", ".", ".", ".", ".", "."],
    [".", ".", ".", ".", "p", ".", ".", "."],
]

ROOK_BOARD_D = [
    [".", ".", ".", ".", ".", ".", ".", "."],
    [".", ".", ".", ".", ".", ".", ".", "."],
    [".", ".", ".", ".", ".", ".", ".", "."],
    [".", ".", ".", ".", ".", ".", ".", "."],
    [".", ".", ".", ".", "R", ".", ".", "."],
    [".", ".", ".", ".", ".", ".", ".", "."],
    [".", ".", ".", ".", ".", ".", ".", "."],
    [".", ".", ".", ".", ".", ".", ".", "."],
]

ROOK_BOARD_E = [
    [".", ".", ".", ".", ".", ".", ".", "."],
    [".", ".", ".", ".", ".", ".", ".", "."],
    [".", ".", ".", ".", "p", ".", ".", "."],
    [".", ".", ".", ".", "B", ".", ".", "."],
    [".", ".", "p", "B", "R", "B", "p", "."],
    [".", ".", ".", ".", "B", ".", ".", "."],
    [".", ".", ".", ".", "p", ".", ".", "."],
    [".", ".", ".", ".", ".", ".", ".", "."],
]

ROOK_BOARD_F = [
    [".", ".", ".", ".", ".", ".", ".", "."],
    [".", ".", ".", ".", ".", ".", ".", "."],
    [".", ".", ".", ".", ".", ".", ".", "."],
    [".", ".", ".", ".", "p", ".", ".", "."],
    [".", ".", ".", "p", "R", "p", ".", "."],
    [".", ".", ".", ".", "p", ".", ".", "."],
    [".", ".", ".", ".", ".", ".", ".", "."],
    [".", ".", ".", ".", ".", ".", ".", "."],
]

ROOK_BOARD_G = [
    ["R", "p", "p", ".", ".", ".", ".", "."],
    ["p", ".", ".", ".", ".", ".", ".", "."],
    [".", ".", ".", ".", ".", ".", ".", "."],
    [".", ".", ".", ".", ".", ".", ".", "."],
    [".", ".", ".", ".", ".", ".", ".", "."],
    [".", ".", ".", ".", ".", ".", ".", "."],
    [".", ".", ".", ".", ".", ".", ".", "."],
    [".", ".", ".", ".", ".", ".", ".", "."],
]


PROBLEMS = [
    make(
        pid=1500,
        title="实现 strStr()",
        tags=["字符串", "双指针"],
        description="""给定两个字符串 haystack 和 needle，在 haystack 中找出 needle 第一次出现的起始下标。
如果 needle 不是 haystack 的一部分，返回 -1。
1 <= needle.length <= haystack.length <= 10^4，两个字符串都只包含小写英文字母。""",
        function="implementStrStr",
        params=[("haystack", "string"), ("needle", "string")],
        returns="int",
        solver=implement_strstr,
        public=[
            ["hello", "ll"],
            ["aaaaa", "bba"],
            ["mississippi", "issip"],
        ],
        hidden=[
            ["a", "a"],
            ["abc", "c"],
            ["abc", "abc"],
            ["abc", "d"],
            ["sadbutsad", "sad"],
            ["leetcode", "leeto"],
        ],
    ),
    make(
        pid=1501,
        title="最后一个单词的长度",
        tags=["字符串"],
        description="""给定仅由英文字母和空格组成的字符串 s，返回其中最后一个单词的长度。
单词由连续的非空格字符组成，单词之间以及字符串两侧可能有多余空格。
1 <= s.length <= 10^4，s 至少包含一个单词。""",
        function="lengthOfLastWord",
        params=[("s", "string")],
        returns="int",
        solver=length_of_last_word,
        public=[["Hello World"], ["   fly me   to   the moon  "], ["luffy is still joyboy"]],
        hidden=[["a"], ["a "], ["Hello"], ["one"], ["two  three"], ["a b c"]],
    ),
    make(
        pid=1502,
        title="x 的平方根",
        tags=["数学", "二分查找"],
        description="""给定一个非负整数 x，返回 x 的算术平方根向下取整后的整数部分。
0 <= x <= 2^31 - 1。""",
        function="mySqrt",
        params=[("x", "int")],
        returns="int",
        solver=my_sqrt,
        public=[[4], [8], [0]],
        hidden=[[1], [2], [3], [2147395599], [2147483647], [100]],
    ),
    make(
        pid=1503,
        title="存在重复元素",
        tags=["数组", "哈希表", "排序"],
        description="""给定整数数组 nums，如果数组中存在至少出现两次的元素则返回 true，否则返回 false。
1 <= nums.length <= 10^5，-10^9 <= nums[i] <= 10^9。""",
        function="containsDuplicate",
        params=[("nums", "int[]")],
        returns="bool",
        solver=contains_duplicate,
        public=[
            [[1, 2, 3, 1]],
            [[1, 2, 3, 4]],
            [[1, 1, 1, 3, 3, 4, 3, 2, 4, 2]],
        ],
        hidden=[
            [[1]],
            [[1, 2]],
            [[-1, -1]],
            [[0, 0]],
            [[1, 2, 3, 4, 5, 6, 7, 8, 9, 10]],
            [[2, 14, 18, 22, 22]],
        ],
    ),
    make(
        pid=1504,
        title="计数质数",
        tags=["数学", "数组"],
        description="""给定整数 n，统计所有小于 n 的质数的数量。
0 <= n <= 5 * 10^6。""",
        function="countPrimes",
        params=[("n", "int")],
        returns="int",
        solver=count_primes,
        public=[[10], [0], [1]],
        hidden=[[2], [3], [4], [5], [100], [1000]],
    ),
    make(
        pid=1505,
        title="Nim 游戏",
        tags=["数学", "博弈"],
        description="""桌上有 n 枚石子，两名玩家轮流取走 1 到 3 枚石子，取走最后一枚石子的人获胜。
你作为先手，双方都采取最优策略，返回你能否获胜。
1 <= n <= 2^31 - 1。""",
        function="canWinNim",
        params=[("n", "int")],
        returns="bool",
        solver=can_win_nim,
        public=[[4], [1], [2]],
        hidden=[[3], [5], [8], [12], [100]],
    ),
    make(
        pid=1506,
        title="2 的幂",
        tags=["数学", "位运算"],
        description="""给定一个整数 n，判断它是否为 2 的整数次幂。
n 在 32 位有符号整数范围内。""",
        function="isPowerOfTwo",
        params=[("n", "int")],
        returns="bool",
        solver=is_power_of_two,
        public=[[1], [16], [3]],
        hidden=[[0], [2], [4], [6], [-16], [1024], [2147483647]],
    ),
    make(
        pid=1507,
        title="验证回文字符串 II",
        tags=["字符串", "双指针", "贪心"],
        description="""给定一个只含小写英文字母的字符串 s，最多允许删除一个字符。
判断能否通过至多删除一个字符使 s 变成回文串，可以则返回 true，否则返回 false。
1 <= s.length <= 10^5。""",
        function="validPalindromeII",
        params=[("s", "string")],
        returns="bool",
        solver=valid_palindrome_ii,
        public=[["aba"], ["abca"], ["abc"]],
        hidden=[["a"], ["ab"], ["abcba"], ["abcdef"], ["deeee"], ["racecar"]],
    ),
    make(
        pid=1508,
        title="最常见的单词",
        tags=["字符串", "哈希表"],
        description="""给定一个字符串 paragraph 和一个禁用单词列表 banned，返回 paragraph 中出现次数最多且不在 banned 中的单词。
单词由英文字母组成，比较时忽略大小写，结果全部小写；标点符号和空格用于分隔单词。
paragraph 至少包含一个非禁用单词，且出现次数最多的候选单词唯一。
1 <= paragraph.length <= 1000，0 <= banned.length <= 100，banned[i] 只含小写英文字母。""",
        function="mostCommonWord",
        params=[("paragraph", "string"), ("banned", "string[]")],
        returns="string",
        solver=most_common_word,
        public=[
            ["Bob hit a ball, the hit BALL flew far after it was hit.", ["hit"]],
            ["a.", []],
            ["Bob", []],
        ],
        hidden=[
            ["a, a, a, b,b,b,c", ["a"]],
            ["It's a test, isn't it?", []],
            ["a b c a b a", []],
            ["Hello hello world", ["world"]],
            ["a b c", ["a", "b"]],
        ],
    ),
    make(
        pid=1509,
        title="字符串中的单词数",
        tags=["字符串"],
        description="""给定字符串 s，统计其中单词的数量。
单词是连续的非空格字符段，单词之间可能有一个或多个空格，字符串首尾也可能有空格。空字符串或全空格字符串的单词数为 0。
0 <= s.length <= 10^4。""",
        function="countSegments",
        params=[("s", "string")],
        returns="int",
        solver=count_segments,
        public=[["Hello, my name is John"], [""], ["          "]],
        hidden=[["a"], ["a b"], ["  a  b  "], ["a, b, c"], ["x"]],
    ),
    make(
        pid=1510,
        title="和为零的 N 个不同整数",
        tags=["数组", "数学"],
        description="""给定整数 n，返回 n 个互不相同的整数，使它们的和为 0。
为保证输出唯一，请按如下顺序构造：依次输出 1、-1、2、-2、3、-3，直到凑够 n 个数；如果 n 为奇数，最后再输出一个 0。
1 <= n <= 1000。""",
        function="sumZero",
        params=[("n", "int")],
        returns="int[]",
        solver=sum_zero,
        public=[[5], [3], [1]],
        hidden=[[2], [4], [6], [7], [10], [99]],
    ),
    make(
        pid=1511,
        title="键盘行",
        tags=["数组", "字符串", "哈希表"],
        description="""给定字符串数组 words，返回其中能够只用美式键盘同一行字母打出的单词，保持它们在输入中的相对顺序。
键盘三行分别为 "qwertyuiop"、"asdfghjkl"、"zxcvbnm"，判断时忽略字母大小写，返回原字符串。
1 <= words.length <= 20，1 <= words[i].length <= 100，单词只含英文字母。""",
        function="findWords",
        params=[("words", "string[]")],
        returns="string[]",
        solver=find_words,
        public=[
            [["Hello", "Alaska", "Dad", "Peace"]],
            [["omk"]],
            [["adsdf", "sfd"]],
        ],
        hidden=[
            [["A", "B"]],
            [["qwerty", "asdfgh"]],
            [["zxc"]],
            [["a", "b", "c"]],
            [["QWERTY", "asdf", "ZXCV"]],
            [["hello", "world"]],
        ],
    ),
    make(
        pid=1512,
        title="反转字符串中的单词 III",
        tags=["字符串", "双指针"],
        description="""给定字符串 s，单词之间以单个空格分隔，单词只含英文字母。
反转每个单词内部的字符顺序，保持单词顺序和空格位置不变，返回结果。
1 <= s.length <= 10^4。""",
        function="reverseWordsIII",
        params=[("s", "string")],
        returns="string",
        solver=reverse_words_iii,
        public=[["Let's take LeetCode contest"], ["Mr Ding"], ["hello"]],
        hidden=[["a"], ["ab cd"], ["hello world"], ["I love coding"], ["a b c"]],
    ),
    make(
        pid=1513,
        title="两个列表的最小索引总和",
        tags=["数组", "字符串", "哈希表"],
        description="""给定两个餐厅名称数组 list1 和 list2，名称在各自数组中互不相同，且至少有一个名称同时出现在两个数组中。
对每个同时出现的餐厅，记它在 list1 中的下标为 i、在 list2 中的下标为 j，索引和为 i + j。
返回所有索引和最小的餐厅名称，按字典序升序排列。
1 <= list1.length, list2.length <= 1000，名称只含英文字母和空格。""",
        function="findRestaurant",
        params=[("list1", "string[]"), ("list2", "string[]")],
        returns="string[]",
        solver=find_restaurant,
        public=[
            [
                ["Shogun", "Tapioca Express", "Burger King", "KFC"],
                ["Piatti", "The Grill at Torrey Pines", "Hungry Hunter Steakhouse", "Shogun"],
            ],
            [
                ["Shogun", "Tapioca Express", "Burger King", "KFC"],
                ["KFC", "Shogun", "Burger King"],
            ],
            [
                ["Shogun", "Tapioca Express", "Burger King", "KFC"],
                ["KFC", "Burger King", "Tapioca Express", "Shogun"],
            ],
        ],
        hidden=[
            [["a", "b", "c"], ["c", "b", "a"]],
            [["a", "b"], ["a", "b"]],
            [["x", "y", "z"], ["y", "x"]],
            [["p", "q", "r"], ["r", "p"]],
            [["a", "b", "c", "d"], ["b", "a"]],
        ],
    ),
    make(
        pid=1514,
        title="字符的最短距离",
        tags=["字符串", "数组", "双指针"],
        description="""给定字符串 s 和字符 c（用长度为 1 的字符串表示），c 在 s 中至少出现一次。
返回一个整数数组 answer，其中 answer[i] 表示 s[i] 到 s 中最近的字符 c 的距离。
1 <= s.length <= 10^4，s 和 c 只含小写英文字母。""",
        function="shortestToChar",
        params=[("s", "string"), ("c", "string")],
        returns="int[]",
        solver=shortest_to_char,
        public=[
            ["loveleetcode", "e"],
            ["aaab", "b"],
            ["a", "a"],
        ],
        hidden=[
            ["abaa", "a"],
            ["baab", "a"],
            ["abcabc", "c"],
            ["cccc", "c"],
            ["ab", "b"],
        ],
    ),
    make(
        pid=1515,
        title="至少是其他数字两倍的最大数",
        tags=["数组", "排序"],
        description="""给定整数数组 nums，最大元素是唯一的。
如果最大元素至少是数组中其余每个元素的两倍，返回最大元素的下标；否则返回 -1。
1 <= nums.length <= 50，0 <= nums[i] <= 100。""",
        function="dominantIndex",
        params=[("nums", "int[]")],
        returns="int",
        solver=dominant_index,
        public=[[[3, 6, 1, 0]], [[1, 2, 3, 4]], [[1]]],
        hidden=[[[1, 0]], [[0, 0, 0, 1]], [[5, 3]], [[2, 3, 1]], [[0]]],
    ),
    make(
        pid=1516,
        title="最长和谐子序列",
        tags=["数组", "哈希表"],
        description="""和谐子序列是指一个子序列中最大值与最小值恰好相差 1。
给定整数数组 nums，返回其最长和谐子序列的长度；不存在这样的子序列时返回 0。
子序列不要求连续，但必须保持元素相对顺序。
1 <= nums.length <= 2 * 10^4，-10^9 <= nums[i] <= 10^9。""",
        function="findLHS",
        params=[("nums", "int[]")],
        returns="int",
        solver=find_lhs,
        public=[
            [[1, 3, 2, 2, 5, 2, 3, 7]],
            [[1, 2, 3, 4]],
            [[1, 1, 1, 1]],
        ],
        hidden=[
            [[1, 2]],
            [[1]],
            [[1, 1, 2, 2, 3, 3, 4]],
            [[2, 2, 1, 1, 5, 3, 3, 3]],
            [[1, 3, 5, 7]],
            [[1, 1, 1, 2, 2, 2, 2]],
        ],
    ),
    make(
        pid=1517,
        title="二分查找",
        tags=["数组", "二分查找"],
        description="""给定一个元素互不相同且按升序排列的整数数组 nums，以及目标值 target。
如果 target 存在，返回它的下标；否则返回 -1。
1 <= nums.length <= 10^4，-10^4 <= nums[i], target <= 10^4。""",
        function="binarySearch",
        params=[("nums", "int[]"), ("target", "int")],
        returns="int",
        solver=binary_search,
        public=[
            [[-1, 0, 3, 5, 9, 12], 9],
            [[-1, 0, 3, 5, 9, 12], 2],
            [[5], 5],
        ],
        hidden=[
            [[5], -5],
            [[1, 2, 3, 4, 5], 1],
            [[1, 2, 3, 4, 5], 5],
            [[1, 3, 5, 7, 9], 7],
            [[-10, -5, 0, 5, 10], -10],
        ],
    ),
    make(
        pid=1518,
        title="写字符串需要的行数",
        tags=["数组", "字符串", "模拟"],
        description="""给定长度为 26 的数组 widths，其中 widths[i] 表示字母表中第 i 个小写字母占用的宽度。
现在要把字符串 s 按字符顺序从左到右排版，每行总宽度不能超过 100，字符不能拆分到两行。
返回一个长度为 2 的数组 [行数, 最后一行已使用的宽度]。
1 <= s.length <= 1000，2 <= widths[i] <= 10，s 只含小写英文字母。""",
        function="numberOfLines",
        params=[("widths", "int[]"), ("s", "string")],
        returns="int[]",
        solver=number_of_lines,
        public=[
            [[10] * 26, "abcdefghijklmnopqrstuvwxyz"],
            [
                [4, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10],
                "bbbcccdddaaa",
            ],
            [[10] * 26, "a"],
        ],
        hidden=[
            [[10] * 26, "zzzzzzzzzz"],
            [[10] * 26, "zzzzzzzzzzz"],
            [[10] * 26, "abcde"],
            [
                [4, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10],
                "aaa",
            ],
            [
                [4, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10],
                "a" * 25,
            ],
            [
                [4, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10],
                "a" * 26,
            ],
        ],
    ),
    make(
        pid=1519,
        title="翻转图像",
        tags=["数组", "矩阵", "模拟"],
        description="""给定一个 n x n 的二进制矩阵 image。
对每一行，先将其水平翻转（左右颠倒），再把每个元素取反（0 变 1，1 变 0）。
返回处理后的矩阵。
1 <= n <= 20，image[i][j] 只会是 0 或 1。""",
        function="flipAndInvertImage",
        params=[("image", "int[][]")],
        returns="int[][]",
        solver=flip_and_invert_image,
        public=[
            [[[1, 1, 0], [1, 0, 1], [0, 0, 0]]],
            [[
                [1, 1, 0, 0],
                [1, 0, 0, 1],
                [0, 1, 1, 1],
                [1, 0, 1, 0],
            ]],
            [[[0]]],
        ],
        hidden=[
            [[[1]]],
            [[[1, 0], [0, 1]]],
            [[[0, 0, 1], [1, 1, 0], [1, 0, 0]]],
            [[[1, 1, 1], [0, 0, 0], [1, 0, 1]]],
            [[[0, 1]]],
        ],
    ),
    make(
        pid=1520,
        title="最小差值 I",
        tags=["数组", "数学"],
        description="""给定整数数组 nums 和非负整数 k。对数组中的每个元素 nums[i]，可以选择一个区间 [-k, k] 内的整数加到它上面，每个元素独立选择。
返回操作后数组最大值与最小值之差的最小可能值。
1 <= nums.length <= 10^4，0 <= k <= 10^4。""",
        function="smallestRangeI",
        params=[("nums", "int[]"), ("k", "int")],
        returns="int",
        solver=smallest_range_i,
        public=[
            [[1], 0],
            [[0, 10], 2],
            [[1, 3, 6], 3],
        ],
        hidden=[
            [[1, 5], 3],
            [[0, 0], 0],
            [[2, 7, 2], 1],
            [[-5, 5], 3],
            [[10, 1, 7], 5],
        ],
    ),
    make(
        pid=1521,
        title="增减字符串匹配",
        tags=["字符串", "数组", "贪心"],
        description="""给定只包含字符 'I'（表示增加）和 'D'（表示减少）的字符串 s，长度为 n，要求返回 [0, n] 的一个排列 perm，使得：
当 s[i] == 'I' 时 perm[i] < perm[i + 1]，当 s[i] == 'D' 时 perm[i] > perm[i + 1]。
为得到唯一确定的输出，请使用下述贪心构造：维护当前可用的最小值 low 和最大值 high，初始 low = 0、high = n。
依次遍历 s 的每个字符，遇到 'I' 时输出 low 并令 low 加一，遇到 'D' 时输出 high 并令 high 减一；遍历结束后再输出剩下的唯一数字。
1 <= s.length <= 10^5。""",
        function="diStringMatch",
        params=[("s", "string")],
        returns="int[]",
        solver=di_string_match,
        public=[["IDID"], ["III"], ["DDI"]],
        hidden=[["I"], ["D"], ["ID"], ["DID"], ["IIID"], ["DDDD"]],
    ),
    make(
        pid=1522,
        title="重复 N 次的元素",
        tags=["数组", "哈希表"],
        description="""给定长度为 2n 的整数数组 nums，其中恰好有 n + 1 个不同的元素，并且其中一个元素恰好重复 n 次。
返回重复了 n 次的元素。
4 <= nums.length <= 10^4，且 nums.length 为偶数。""",
        function="repeatedNTimes",
        params=[("nums", "int[]")],
        returns="int",
        solver=repeated_n_times,
        public=[
            [[1, 2, 3, 3]],
            [[2, 1, 2, 5, 3, 2]],
            [[5, 1, 5, 2, 5, 3, 5, 4]],
        ],
        hidden=[
            [[3, 1, 3, 2]],
            [[1, 2, 1, 3]],
            [[9, 9, 1, 2]],
            [[7, 2, 7, 1, 7, 3, 7, 4]],
            [[0, 4, 0, 3, 0, 2, 0, 1]],
        ],
    ),
    make(
        pid=1523,
        title="有效的山脉数组",
        tags=["数组", "双指针"],
        description="""给定整数数组 nums，如果它是有效的山脉数组则返回 true，否则返回 false。
有效山脉数组需满足：长度至少为 3；存在下标 i（0 < i < length - 1），使得从开头到 i 严格递增，从 i 到结尾严格递减。
1 <= nums.length <= 10^4。""",
        function="validMountainArray",
        params=[("nums", "int[]")],
        returns="bool",
        solver=valid_mountain_array,
        public=[
            [[2, 1]],
            [[3, 5, 5]],
            [[0, 3, 2, 1]],
        ],
        hidden=[
            [[0, 1, 2, 3, 4, 5, 6, 7, 8, 9]],
            [[9, 8, 7, 6, 5, 4, 3, 2, 1, 0]],
            [[1, 2, 3]],
            [[3, 2, 1]],
            [[1, 3, 2]],
            [[0, 1, 2, 1, 0]],
        ],
    ),
    make(
        pid=1524,
        title="字符串的最大公因子",
        tags=["字符串", "数学"],
        description="""给定两个字符串 str1 和 str2。如果存在字符串 X，使得 str1 和 str2 都可以由 X 重复若干次拼接而成，返回满足条件的最长字符串 X；否则返回空字符串。
1 <= str1.length, str2.length <= 1000，字符串只含大写英文字母。""",
        function="gcdOfStrings",
        params=[("str1", "string"), ("str2", "string")],
        returns="string",
        solver=gcd_of_strings,
        public=[
            ["ABCABC", "ABC"],
            ["ABABAB", "ABAB"],
            ["LEET", "CODE"],
        ],
        hidden=[
            ["ABC", "ABC"],
            ["ABAB", "AB"],
            ["A", "A"],
            ["ABCDEF", "ABC"],
            [
                "TAUXXTAUXXTAUXXTAUXXTAUXX",
                "TAUXXTAUXXTAUXXTAUXXTAUXXTAUXXTAUXXTAUXXTAUXX",
            ],
        ],
    ),
    make(
        pid=1525,
        title="可以被一步捕获的棋子数",
        tags=["数组", "模拟"],
        description="""给定一个 8 x 8 的棋盘 board，用字符串二维数组表示，每个格子是以下字符之一：
'.' 表示空格，'p' 表示可被捕获的黑色兵，'B' 表示会阻挡车的白色象，'R' 表示白色车（棋盘上恰好有一个）。
车的移动规则：选择上、下、左、右四个方向之一，沿该方向一直移动，直到遇到第一个非空格子。
如果第一个非空格子是 'p'，则捕获该兵并停止；如果是 'B'，则被挡住并停止；如果到达棋盘边缘也停止。
返回车在一步中能够捕获的兵的数量（每个方向最多捕获一个）。
board 固定为 8 行 8 列。""",
        function="numRookCaptures",
        params=[("board", "string[][]")],
        returns="int",
        solver=num_rook_captures,
        public=[[ROOK_BOARD_A], [ROOK_BOARD_B], [ROOK_BOARD_C]],
        hidden=[[ROOK_BOARD_D], [ROOK_BOARD_E], [ROOK_BOARD_F], [ROOK_BOARD_G]],
    ),
    make(
        pid=1526,
        title="山脉数组的峰顶索引",
        tags=["数组", "二分查找"],
        description="""给定一个山脉数组 arr：它先严格递增再严格递减，长度至少为 3，且相邻元素不相等。
返回峰顶元素的下标。
3 <= arr.length <= 10^4，0 <= arr[i] <= 10^6。""",
        function="peakIndexInMountainArray",
        params=[("arr", "int[]")],
        returns="int",
        solver=peak_index_in_mountain_array,
        public=[
            [[0, 1, 0]],
            [[0, 2, 1, 0]],
            [[24, 69, 100, 99, 79, 78, 67, 36, 26, 19]],
        ],
        hidden=[
            [[3, 4, 5, 1]],
            [[0, 10, 5, 2]],
            [[0, 1, 2, 3, 4, 5, 4, 3, 2, 1]],
            [[1, 2, 1]],
            [[3, 5, 4]],
            [[0, 4, 3, 2, 1]],
        ],
    ),
    make(
        pid=1527,
        title="托普利茨矩阵",
        tags=["数组", "矩阵"],
        description="""给定一个 m x n 的整数矩阵 matrix。
如果矩阵中每一条从左上到右下的对角线上的元素都相同，则称它是托普利茨矩阵。
判断 matrix 是否为托普利茨矩阵，是则返回 true，否则返回 false。
1 <= m, n <= 20，0 <= matrix[i][j] <= 99。""",
        function="isToeplitzMatrix",
        params=[("matrix", "int[][]")],
        returns="bool",
        solver=is_toeplitz_matrix,
        public=[
            [[[1, 2, 3, 4], [5, 1, 2, 3], [9, 5, 1, 2]]],
            [[[1, 2], [2, 2]]],
            [[[1]]],
        ],
        hidden=[
            [[[1, 2], [1, 2]]],
            [[[1, 2, 3], [4, 1, 2], [5, 4, 1]]],
            [[[1, 2], [3, 4]]],
            [[[1, 2, 3]]],
            [[[1], [2], [3]]],
            [[[1, 1, 1], [1, 1, 1]]],
        ],
    ),
    make(
        pid=1528,
        title="验证外星语词典",
        tags=["数组", "字符串", "哈希表"],
        description="""给定字符串数组 words 和一个字符串 order。order 是全部 26 个小写英文字母的一种排列，表示外星语言的字母表顺序。
如果 words 中的单词按照该外星语言的字典序从小到大排列，返回 true；否则返回 false。
字典序比较规则与常规字典序相同，只是字符大小由 order 中的位置决定。
1 <= words.length <= 100，1 <= words[i].length <= 20，words 中单词互不相同。""",
        function="isAlienSorted",
        params=[("words", "string[]"), ("order", "string")],
        returns="bool",
        solver=is_alien_sorted,
        public=[
            [["hello", "leetcode"], "hlabcdefgijkmnopqrstuvwxyz"],
            [["word", "world", "row"], "worldabcefghijkmnpqstuvxyz"],
            [["apple", "app"], "abcdefghijklmnopqrstuvwxyz"],
        ],
        hidden=[
            [["a", "b"], "ba"],
            [["b", "a"], "ba"],
            [["aa", "ab"], "ab"],
            [["ab", "aa"], "ab"],
            [["z", "x"], "zyx"],
        ],
    ),
    make(
        pid=1529,
        title="找到小镇的法官",
        tags=["数组", "哈希表", "图"],
        description="""小镇有 n 个人，编号从 1 到 n。给定信任关系数组 trust，其中 trust[i] = [a, b] 表示编号 a 的人信任编号 b 的人。
小镇法官满足两个条件：法官不信任任何人；除法官外所有人都信任法官。
如果存在法官，返回其编号；否则返回 -1。n = 1 且没有任何信任关系时，编号 1 就是法官。
1 <= n <= 1000，0 <= trust.length <= 10^4，trust[i] 中两个人不同。""",
        function="findJudge",
        params=[("n", "int"), ("trust", "int[][]")],
        returns="int",
        solver=find_judge,
        public=[
            [2, [[1, 2]]],
            [3, [[1, 3], [2, 3]]],
            [3, [[1, 3], [2, 3], [3, 1]]],
        ],
        hidden=[
            [3, [[1, 2], [2, 3]]],
            [4, [[1, 3], [1, 4], [2, 3], [2, 4], [4, 3]]],
            [1, []],
            [2, []],
            [3, [[1, 2], [2, 1]]],
            [4, [[1, 2], [3, 4]]],
        ],
    ),
    make(
        pid=1530,
        title="重新排列句子中的单词",
        tags=["字符串", "数组", "排序"],
        description="""给定字符串 s，其中每个单词末尾都附加了一个 1 到 9 的数字，表示该单词在句子中的实际位置。
单词之间用单个空格分隔，数字不会出现在单词的其他位置，且位置编号连续、不重复。
请去掉每个单词末尾的数字，按位置重新排列单词，返回用单个空格连接的新句子。
1 <= 单词数量 <= 9。""",
        function="sortSentence",
        params=[("s", "string")],
        returns="string",
        solver=sort_sentence,
        public=[
            ["is2 sentence4 This1 a3"],
            ["Myself2 Me1 I4 and3"],
            ["one1"],
        ],
        hidden=[
            ["a2 b1"],
            ["J3 b2 a1"],
            ["z2 a1"],
            ["b2 a1 c3"],
            ["c3 b2 a1"],
        ],
    ),
    make(
        pid=1531,
        title="统计好三元组",
        tags=["数组", "枚举"],
        description="""给定整数数组 arr 和三个整数 a、b、c，统计满足以下全部条件的三元组 (i, j, k) 的数量：
0 <= i < j < k < arr.length；
|arr[i] - arr[j]| <= a；
|arr[j] - arr[k]| <= b；
|arr[i] - arr[k]| <= c。
3 <= arr.length <= 100，0 <= arr[i] <= 1000，0 <= a, b, c <= 1000。""",
        function="countGoodTriplets",
        params=[("arr", "int[]"), ("a", "int"), ("b", "int"), ("c", "int")],
        returns="int",
        solver=count_good_triplets,
        public=[
            [[3, 0, 1, 1, 9, 7], 7, 2, 3],
            [[1, 1, 2, 2, 3], 0, 0, 1],
            [[0, 0, 0], 0, 0, 0],
        ],
        hidden=[
            [[1, 2, 3], 1, 1, 1],
            [[5], 0, 0, 0],
            [[1, 1, 1, 1], 0, 0, 0],
            [[2, 2, 2, 2], 1, 1, 1],
            [[0, 1, 2, 3], 1, 1, 1],
        ],
    ),
    make(
        pid=1532,
        title="判断矩阵经轮转后是否一致",
        tags=["数组", "矩阵", "模拟"],
        description="""给定两个 n x n 的整数矩阵 mat 和 target。
判断能否将 mat 顺时针旋转 90 度的 0 次、1 次、2 次或 3 次后得到 target，可以则返回 true，否则返回 false。
1 <= n <= 10。""",
        function="findRotation",
        params=[("mat", "int[][]"), ("target", "int[][]")],
        returns="bool",
        solver=find_rotation,
        public=[
            [[[0, 1], [1, 0]], [[1, 0], [0, 1]]],
            [[[0, 1], [1, 1]], [[1, 0], [0, 1]]],
            [[[0, 0, 0], [0, 1, 0], [1, 1, 1]], [[1, 1, 1], [0, 1, 0], [0, 0, 0]]],
        ],
        hidden=[
            [[[1]], [[1]]],
            [[[1]], [[0]]],
            [[[0, 0], [0, 1]], [[0, 0], [1, 0]]],
            [[[0, 1], [1, 0]], [[0, 1], [1, 0]]],
            [[[1, 2], [3, 4]], [[3, 1], [4, 2]]],
        ],
    ),
    make(
        pid=1533,
        title="找到星形图的中心节点",
        tags=["图", "数组"],
        description="""有一个无向星形图，包含 n + 1 个节点，编号从 1 到 n + 1。
图中有 n 条边，每条边都连接中心节点与一个叶子节点。
给定二维数组 edges，其中 edges[i] = [u, v] 表示节点 u 与 v 之间有一条边。
返回中心节点的编号。
1 <= edges.length <= 10^5，1 <= u, v <= n + 1，u != v。""",
        function="findCenter",
        params=[("edges", "int[][]")],
        returns="int",
        solver=find_center,
        public=[
            [[[1, 2], [2, 3], [4, 2]]],
            [[[1, 2], [5, 1], [1, 3], [1, 4]]],
            [[[1, 2]]],
        ],
        hidden=[
            [[[1, 2], [2, 3]]],
            [[[5, 1], [1, 2], [1, 3]]],
            [[[3, 4], [4, 5], [4, 6], [4, 7]]],
            [[[2, 1], [1, 3], [1, 4], [1, 5]]],
        ],
    ),
    make(
        pid=1534,
        title="检查两个字符串数组是否相等",
        tags=["数组", "字符串"],
        description="""给定两个字符串数组 word1 和 word2。
将 word1 中的所有字符串按顺序拼接成一个字符串，再用同样方式拼接 word2。
如果两个拼接结果相等，返回 true；否则返回 false。
1 <= word1.length, word2.length <= 10^3，1 <= word1[i].length, word2[i].length <= 10^3。""",
        function="arrayStringsAreEqual",
        params=[("word1", "string[]"), ("word2", "string[]")],
        returns="bool",
        solver=array_strings_are_equal,
        public=[
            [["ab", "c"], ["a", "bc"]],
            [["a", "cb"], ["ab", "c"]],
            [["abc", "d", "defg"], ["abcddefg"]],
        ],
        hidden=[
            [["a"], ["a"]],
            [["a"], ["b"]],
            [["ab", "cd"], ["abcd"]],
            [["", ""], [""]],
            [["a", "b", "c"], ["abc"]],
        ],
    ),
    make(
        pid=1535,
        title="图像平滑",
        tags=["数组", "矩阵", "模拟"],
        description="""给定一个 m x n 的整数矩阵 img，表示一张灰度图像。
对每个格子，取以它为中心的 3 x 3 邻域（包括该格子自身，越界部分忽略）内所有整数的平均值，并向下取整，作为新矩阵对应位置的值。
返回大小相同的新矩阵。
1 <= m, n <= 200，0 <= img[i][j] <= 255。""",
        function="imageSmoother",
        params=[("img", "int[][]")],
        returns="int[][]",
        solver=image_smoother,
        public=[
            [[[1, 1, 1], [1, 0, 1], [1, 1, 1]]],
            [[[100, 200, 100], [200, 50, 200], [100, 200, 100]]],
            [[[1]]],
        ],
        hidden=[
            [[[2, 3], [4, 5]]],
            [[[1, 2, 3]]],
            [[[1], [2], [3]]],
            [[[10, 20, 30], [40, 50, 60], [70, 80, 90]]],
            [[[5, 5], [5, 5]]],
        ],
    ),
    make(
        pid=1536,
        title="截断句子",
        tags=["字符串", "数组"],
        description="""给定一个由单个空格分隔单词组成的字符串 s，以及整数 k。
返回由 s 中前 k 个单词组成的句子，单词之间用单个空格分隔。
1 <= 单词数量 <= 500，1 <= k <= 单词数量，s 只含英文字母和空格。""",
        function="truncateSentence",
        params=[("s", "string"), ("k", "int")],
        returns="string",
        solver=truncate_sentence,
        public=[
            ["Hello how are you Contestant", 4],
            ["What is the solution to this problem", 4],
            ["chopper is not a tanuki", 5],
        ],
        hidden=[
            ["a", 1],
            ["a b c", 1],
            ["a b c", 3],
            ["hello world", 2],
            ["one two three four five", 2],
        ],
    ),
    make(
        pid=1537,
        title="将一维数组转变成二维数组",
        tags=["数组", "矩阵", "模拟"],
        description="""给定一维整数数组 original、整数 m 和 n。
如果 m * n == original.length，将 original 按行优先顺序填入一个 m 行 n 列的二维数组并返回；否则返回空数组。
1 <= original.length <= 5 * 10^4，1 <= m, n <= 10^4。""",
        function="construct2DArray",
        params=[("original", "int[]"), ("m", "int"), ("n", "int")],
        returns="int[][]",
        solver=construct_2d_array,
        public=[
            [[1, 2, 3, 4], 2, 2],
            [[1, 2, 3], 1, 3],
            [[1, 2], 2, 2],
        ],
        hidden=[
            [[1, 2, 3, 4, 5, 6], 2, 3],
            [[3], 1, 1],
            [[1, 2, 3], 3, 1],
            [[1, 2], 1, 2],
            [[1, 2, 3, 4], 4, 1],
            [[1, 2, 3, 4], 1, 4],
        ],
    ),
]
