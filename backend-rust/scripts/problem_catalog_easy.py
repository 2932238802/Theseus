"""1116-1145：简单题（30 道）。"""

from __future__ import annotations

from problem_seed_common import Problem

# ── 参考解 ──────────────────────────────────────────────────────────


def plus_one(digits: list[int]) -> list[int]:
    number = digits[:]
    index = len(number) - 1
    while index >= 0 and number[index] == 9:
        number[index] = 0
        index -= 1
    if index < 0:
        return [1] + number
    number[index] += 1
    return number


def add_binary(a: str, b: str) -> str:
    return bin(int(a, 2) + int(b, 2))[2:]


def remove_element(nums: list[int], val: int) -> int:
    return sum(1 for value in nums if value != val)


def remove_duplicates(nums: list[int]) -> int:
    return len(set(nums))


def search_insert(nums: list[int], target: int) -> int:
    left, right = 0, len(nums)
    while left < right:
        middle = (left + right) // 2
        if nums[middle] < target:
            left = middle + 1
        else:
            right = middle
    return left


def count_and_say(n: int) -> str:
    current = "1"
    for _ in range(n - 1):
        parts: list[str] = []
        index = 0
        while index < len(current):
            end = index
            while end < len(current) and current[end] == current[index]:
                end += 1
            parts.append(f"{end - index}{current[index]}")
            index = end
        current = "".join(parts)
    return current


def find_max_consecutive_ones(nums: list[int]) -> int:
    best = current = 0
    for value in nums:
        if value == 1:
            current += 1
            best = max(best, current)
        else:
            current = 0
    return best


def third_max(nums: list[int]) -> int:
    values = sorted(set(nums), reverse=True)
    return values[2] if len(values) >= 3 else values[0]


def array_pair_sum(nums: list[int]) -> int:
    ordered = sorted(nums)
    return sum(ordered[::2])


def find_content_children(children: list[int], cookies: list[int]) -> int:
    children = sorted(children)
    cookies = sorted(cookies)
    child = cookie = 0
    while child < len(children) and cookie < len(cookies):
        if cookies[cookie] >= children[child]:
            child += 1
        cookie += 1
    return child


def is_subsequence(s: str, t: str) -> bool:
    iterator = iter(t)
    return all(character in iterator for character in s)


def is_isomorphic(s: str, t: str) -> bool:
    if len(s) != len(t):
        return False
    forward: dict[str, str] = {}
    backward: dict[str, str] = {}
    for left, right in zip(s, t):
        if forward.setdefault(left, right) != right:
            return False
        if backward.setdefault(right, left) != left:
            return False
    return True


def word_pattern(pattern: str, s: str) -> bool:
    words = s.split(" ")
    if len(pattern) != len(words):
        return False
    forward: dict[str, str] = {}
    backward: dict[str, str] = {}
    for character, word in zip(pattern, words):
        if forward.setdefault(character, word) != word:
            return False
        if backward.setdefault(word, character) != character:
            return False
    return True


def first_uniq_char(s: str) -> int:
    from collections import Counter

    counts = Counter(s)
    for index, character in enumerate(s):
        if counts[character] == 1:
            return index
    return -1


def is_anagram(s: str, t: str) -> bool:
    from collections import Counter

    return Counter(s) == Counter(t)


def can_construct(ransom_note: str, magazine: str) -> bool:
    from collections import Counter

    available = Counter(magazine)
    for character in ransom_note:
        if available[character] == 0:
            return False
        available[character] -= 1
    return True


def longest_palindrome(s: str) -> int:
    from collections import Counter

    counts = Counter(s)
    length = sum(count // 2 * 2 for count in counts.values())
    return length + 1 if length < len(s) else length


def fib(n: int) -> int:
    previous, current = 0, 1
    for _ in range(n):
        previous, current = current, previous + current
    return previous


def climb_stairs(n: int) -> int:
    previous, current = 1, 1
    for _ in range(n - 1):
        previous, current = current, previous + current
    return current


def min_cost_climbing_stairs(cost: list[int]) -> int:
    two_back, one_back = 0, 0
    for step in range(2, len(cost) + 1):
        two_back, one_back = one_back, min(one_back + cost[step - 1], two_back + cost[step - 2])
    return one_back


def max_profit(prices: list[int]) -> int:
    best, lowest = 0, None
    for price in prices:
        if lowest is None or price < lowest:
            lowest = price
        else:
            best = max(best, price - lowest)
    return best


def generate_pascal(num_rows: int) -> list[list[int]]:
    triangle: list[list[int]] = []
    for row in range(num_rows):
        current = [1] * (row + 1)
        for column in range(1, row):
            current[column] = triangle[row - 1][column - 1] + triangle[row - 1][column]
        triangle.append(current)
    return triangle


def diagonal_sum(mat: list[list[int]]) -> int:
    size = len(mat)
    total = 0
    for index in range(size):
        total += mat[index][index]
        if index != size - 1 - index:
            total += mat[index][size - 1 - index]
    return total


def transpose(matrix: list[list[int]]) -> list[list[int]]:
    return [list(row) for row in zip(*matrix)]


def matrix_reshape(mat: list[list[int]], rows: int, columns: int) -> list[list[int]]:
    flat = [value for row in mat for value in row]
    if rows * columns != len(flat):
        return mat
    return [flat[row * columns : (row + 1) * columns] for row in range(rows)]


def find_disappeared_numbers(nums: list[int]) -> list[int]:
    present = set(nums)
    return [value for value in range(1, len(nums) + 1) if value not in present]


def majority_element(nums: list[int]) -> int:
    candidate, count = None, 0
    for value in nums:
        if count == 0:
            candidate = value
            count = 1
        elif value == candidate:
            count += 1
        else:
            count -= 1
    return candidate


def is_monotonic(nums: list[int]) -> bool:
    increasing = decreasing = True
    for index in range(1, len(nums)):
        if nums[index] < nums[index - 1]:
            increasing = False
        if nums[index] > nums[index - 1]:
            decreasing = False
    return increasing or decreasing


def sorted_squares(nums: list[int]) -> list[int]:
    return sorted(value * value for value in nums)


def detect_capital_use(word: str) -> bool:
    return word.isupper() or word.islower() or word[:1].isupper() and word[1:].islower()


PROBLEMS = [
    Problem(
        pid=1116,
        title="加一",
        difficulty="easy",
        tags=["数组", "数学"],
        description="""给定一个由整数组成的非空数组 digits，表示一个非负整数（最高位在数组开头，不含前导零），将这个整数加一。
结果仍以数组形式返回，每个元素只包含一位数字。

提示：
- 1 <= digits.length <= 100
- 0 <= digits[i] <= 9
- 除数字 0 本身外，digits 不包含前导零""",
        function="plusOne",
        params=[("digits", "int[]")],
        returns="int[]",
        solver=plus_one,
        public=[[[1, 2, 3]], [[4, 3, 2, 1]], [[9]], [[9, 9, 9]]],
        expected_public=[[1, 2, 4], [4, 3, 2, 2], [1, 0], [1, 0, 0, 0]],
        hidden=[
            [[0]], [[1]], [[8]], [[9, 9]], [[1, 9]], [[2, 9, 9]],
            [[9, 8, 9]], [[1, 0, 0, 0]], [[5, 6, 7]], [[9] * 10],
            [[1, 2, 3, 4, 5]], [[9, 9, 9, 9, 9]], [[7, 2, 9]], [[3, 9]],
            [[1, 9, 9, 9]], [[2, 0, 4, 9]],
        ],
    ),
    Problem(
        pid=1117,
        title="二进制求和",
        difficulty="easy",
        tags=["字符串", "数学", "模拟"],
        description="""给定两个二进制字符串 a 和 b，以二进制字符串的形式返回它们的和。
字符串只包含字符 0 和 1，且不含前导零（数字 0 本身除外）。

提示：
- 1 <= a.length, b.length <= 10^4
- a 和 b 仅由 0 或 1 组成""",
        function="addBinary",
        params=[("a", "string"), ("b", "string")],
        returns="string",
        solver=add_binary,
        public=[["11", "1"], ["1010", "1011"], ["0", "0"], ["1", "1"]],
        expected_public=["100", "10101", "0", "10"],
        hidden=[
            ["0", "1"], ["1", "0"], ["1111", "1"], ["100", "110010"],
            ["101", "101"], ["1101", "1011"], ["1" * 20, "1"], ["1001", "100"],
            ["111", "111"], ["0", "1010"], ["1010101", "101"], ["11", "11"],
            ["10000", "10000"], ["1", "111111"], ["1000000000", "1"],
        ],
    ),
    Problem(
        pid=1118,
        title="移除元素",
        difficulty="easy",
        tags=["数组", "双指针"],
        description="""给定整数数组 nums 和整数 val，原地移除所有等于 val 的元素。
元素顺序可以改变，返回移除后数组的新长度。
不需要处理新长度之外的元素。

提示：
- 0 <= nums.length <= 100
- 0 <= nums[i], val <= 50""",
        function="removeElement",
        params=[("nums", "int[]"), ("val", "int")],
        returns="int",
        solver=remove_element,
        public=[
            [[3, 2, 2, 3], 3],
            [[0, 1, 2, 2, 3, 0, 4, 2], 2],
            [[1], 1],
            [[1], 2],
        ],
        expected_public=[2, 5, 0, 1],
        hidden=[
            [[], 0], [[1, 2, 3], 4], [[4, 4, 4], 4], [[-1, -1, 2], -1],
            [[2, 2, 2, 3], 2], [[0, 0], 1], [[5], 5], [[1, 2, 3, 4, 5], 3],
            [[-3, -2, -1], -2], [[7, 7, 7, 7], 8], [[1, 1, 2, 2, 3], 1],
            [[0, 1, 2, 3, 4], 0],
        ],
    ),
    Problem(
        pid=1119,
        title="删除有序数组中的重复项",
        difficulty="easy",
        tags=["数组", "双指针"],
        description="""给定一个升序排列的整数数组 nums，原地删除重复出现的元素，使每个元素只出现一次，返回删除后数组的新长度。
元素的相对顺序应保持一致。

提示：
- 0 <= nums.length <= 3 * 10^4
- -100 <= nums[i] <= 100
- nums 已按升序排列""",
        function="removeDuplicates",
        params=[("nums", "int[]")],
        returns="int",
        solver=remove_duplicates,
        public=[[[1, 1, 2]], [[0, 0, 1, 1, 1, 2, 2, 3, 3, 4]], [[1]], [[]]],
        expected_public=[2, 5, 1, 0],
        hidden=[
            [[1, 2, 3]], [[-1, -1, 0, 1, 1]], [[5, 5, 5]], [[-100, 0, 0, 100]],
            [[1, 1, 1, 2]], [[1, 2, 2, 3]], [[0]], [[-3, -2, -1]],
            [[1, 2, 3, 3, 3, 4, 5]], [[2, 2, 3, 3]],
        ],
    ),
    Problem(
        pid=1120,
        title="搜索插入位置",
        difficulty="easy",
        tags=["数组", "二分查找"],
        description="""给定一个升序排列且无重复元素的整数数组 nums 和一个目标值 target，在数组中找到目标值并返回其下标。
如果目标值不存在，返回它将会被按顺序插入的位置。

提示：
- 1 <= nums.length <= 10^4
- -10^4 <= nums[i], target <= 10^4
- nums 无重复元素并升序排列""",
        function="searchInsert",
        params=[("nums", "int[]"), ("target", "int")],
        returns="int",
        solver=search_insert,
        public=[
            [[1, 3, 5, 6], 5],
            [[1, 3, 5, 6], 2],
            [[1, 3, 5, 6], 7],
            [[1, 3, 5, 6], 0],
        ],
        expected_public=[2, 1, 4, 0],
        hidden=[
            [[], 5], [[1], 0], [[1], 1], [[1], 2], [[-5, -3, 0, 2], -4],
            [[10, 20, 30], 25], [[10, 20, 30], 10], [[10, 20, 30], 30],
            [[10, 20, 30], 31], [[1, 2, 4, 5, 6], 3], [[-10, -5, 0, 3, 9], -11],
        ],
    ),
    Problem(
        pid=1121,
        title="外观数列",
        difficulty="easy",
        tags=["字符串", "模拟"],
        description="""外观数列是一个整数序列，从数字 1 开始，序列中的每一项都是对前一项的描述。
前五项如下：
1.     1
2.     11
3.     21
4.     1211
5.     111221
给定正整数 n，返回外观数列的第 n 项。

提示：
- 1 <= n <= 30""",
        function="countAndSay",
        params=[("n", "int")],
        returns="string",
        solver=count_and_say,
        public=[[1], [4], [5], [6]],
        expected_public=["1", "1211", "111221", "312211"],
        hidden=[[2], [3], [7], [8], [9], [10], [11], [12],
                [13], [14], [15], [16], [17], [18], [20], [30]],
    ),
    Problem(
        pid=1122,
        title="最大连续 1 的个数",
        difficulty="easy",
        tags=["数组"],
        description="""给定一个二进制数组 nums，返回其中最大连续 1 的个数。

提示：
- 1 <= nums.length <= 10^5
- nums[i] 为 0 或 1""",
        function="findMaxConsecutiveOnes",
        params=[("nums", "int[]")],
        returns="int",
        solver=find_max_consecutive_ones,
        public=[[[1, 1, 0, 1, 1, 1]], [[1, 0, 1, 1, 0, 1]], [[0]], [[1]]],
        expected_public=[3, 2, 0, 1],
        hidden=[
            [[0, 0, 0]], [[1, 1, 1, 1]], [[0, 1, 1, 0, 1]], [[1] * 50],
            [[0, 1] * 20], [[1, 0, 0, 1]], [[1, 1, 0, 1, 1, 0, 1, 1, 1]],
            [[0, 0, 1, 0, 0]], [[1, 0, 1, 0, 1]], [[1, 1, 1, 0, 0, 0, 1, 1]],
            [[0, 1, 1, 1, 1, 0]], [[1, 0, 0, 0, 1, 1]], [[0, 1, 0, 1]],
        ],
    ),
    Problem(
        pid=1123,
        title="第三大的数",
        difficulty="easy",
        tags=["数组", "排序"],
        description="""给定一个非空整数数组 nums，返回其中第三大的数。
如果不存在第三大的数，返回最大的数。
要求答案中的数是去重后的第三大，而不是排序后数组的第 3 个元素。

提示：
- 1 <= nums.length <= 10^4
- -2^31 <= nums[i] <= 2^31 - 1""",
        function="thirdMax",
        params=[("nums", "int[]")],
        returns="int",
        solver=third_max,
        public=[[[3, 2, 1]], [[1, 2]], [[2, 2, 3, 1]], [[1, 1, 2]]],
        expected_public=[1, 2, 1, 2],
        hidden=[
            [[1]], [[1, 1, 1]], [[1, 2, 3]], [[3, 3, 2, 1]], [[-1, -2, -3]],
            [[1, 2, -2147483648]], [[5, 4, 3, 2, 1]], [[2, 2, 2, 1]],
            [[1, 2, 2, 3, 3]], [[10, 20, 30, 40]],
        ],
    ),
    Problem(
        pid=1124,
        title="数组拆分",
        difficulty="easy",
        tags=["数组", "排序", "贪心"],
        description="""给定长度为 2n 的整数数组 nums，将这些数分成 n 对，例如 (a1, b1), (a2, b2), ..., (an, bn)。
返回所有 min(ai, bi) 之和的最大值。

提示：
- 1 <= n <= 10^4
- nums.length == 2 * n
- -10^4 <= nums[i] <= 10^4""",
        function="arrayPairSum",
        params=[("nums", "int[]")],
        returns="int",
        solver=array_pair_sum,
        public=[[[1, 4, 3, 2]], [[6, 2, 6, 5, 1, 2]], [[1, 2]], [[0, 0]]],
        expected_public=[4, 9, 1, 0],
        hidden=[
            [[-1, -2]], [[1, 1, 1, 1]], [[-10000, 10000, 0, 0]],
            [[9, 8, 7, 6]], [[-5, -4, -3, -2]], [[3, 1, 4, 2]],
            [[10, 9, 8, 7, 6, 5]], [[0, 1, 2, 3]], [[-10, 10, -20, 20]],
            [[2, 3, 1, 4, 6, 5]],
        ],
    ),
    Problem(
        pid=1125,
        title="分发饼干",
        difficulty="easy",
        tags=["数组", "排序", "贪心", "双指针"],
        description="""假设你是一位家长，想给孩子们分发饼干。每个孩子 i 有一个胃口值 g[i]，每块饼干 j 有一个尺寸 s[j]。
如果 s[j] >= g[i]，可以满足第 i 个孩子。每个孩子最多只能拿一块饼干。
返回最多可以满足的孩子数量。

提示：
- 1 <= g.length <= 3 * 10^4
- 0 <= s.length <= 3 * 10^4
- 1 <= g[i], s[j] <= 2^31 - 1""",
        function="findContentChildren",
        params=[("g", "int[]"), ("s", "int[]")],
        returns="int",
        solver=find_content_children,
        public=[
            [[1, 2, 3], [1, 1]],
            [[1, 2], [1, 2, 3]],
            [[1, 2, 3], [3]],
            [[], [1, 2]],
        ],
        expected_public=[1, 2, 1, 0],
        hidden=[
            [[1], [1]], [[1], [0]], [[10, 9, 8, 7], [5, 6, 7, 8]],
            [[1, 1, 1], [1, 1]], [[1, 2, 3], [0, 0, 0]], [[2, 2, 2], [1, 2, 3]],
            [[5, 10, 2, 9, 15, 9], [6, 1, 20, 3, 8]], [[1, 2], [1]],
            [[1], [2]], [[3, 4, 5], [1, 2]], [[1, 1, 2, 2], [1, 2]],
            [[10, 9, 8], [10, 9, 8]], [[], []],
        ],
    ),
    Problem(
        pid=1126,
        title="判断子序列",
        difficulty="easy",
        tags=["字符串", "双指针", "动态规划"],
        description="""给定字符串 s 和 t，判断 s 是否为 t 的子序列。
子序列是原始字符串删除一些（也可以不删除）字符而不改变剩余字符相对位置形成的新字符串。

提示：
- 0 <= s.length <= 100
- 0 <= t.length <= 10^4
- 两个字符串都只由小写英文字母组成""",
        function="isSubsequence",
        params=[("s", "string"), ("t", "string")],
        returns="bool",
        solver=is_subsequence,
        public=[
            ["abc", "ahbgdc"],
            ["axc", "ahbgdc"],
            ["", ""],
            ["abc", ""],
        ],
        expected_public=[True, False, True, False],
        hidden=[
            ["", "ahbgdc"], ["a", "a"], ["b", "a"], ["aaaaaa", "bbaaaa"],
            ["aaaaaa", "aaa"], ["abc", "abc"], ["acb", "ahbgdc"], ["ab", "baab"],
            ["axc", "abc"], ["aec", "abcde"], ["leeeeetcode", "yyyyylyeeeeeeeeetcode"],
            ["abcdef", "abcdef"], ["z", "abc"],
        ],
    ),
    Problem(
        pid=1127,
        title="同构字符串",
        difficulty="easy",
        tags=["字符串", "哈希表"],
        description="""给定两个字符串 s 和 t，判断它们是否是同构的。
如果 s 中的字符可以按某种映射关系替换得到 t，那么两个字符串是同构的。
每个字符都应映射到另一个字符，且没有两个字符映射到同一个字符。

提示：
- 1 <= s.length <= 5 * 10^4
- t.length == s.length""",
        function="isIsomorphic",
        params=[("s", "string"), ("t", "string")],
        returns="bool",
        solver=is_isomorphic,
        public=[
            ["egg", "add"],
            ["foo", "bar"],
            ["paper", "title"],
            ["badc", "baba"],
        ],
        expected_public=[True, False, True, False],
        hidden=[
            ["a", "a"], ["ab", "aa"], ["aa", "ab"], ["abc", "xyz"],
            ["13", "42"], ["ab", "ca"], ["abcd", "abcc"], ["aba", "baa"],
            ["aabb", "ccdd"], ["xyz", "abc"], ["abcd", "wxyz"],
            ["abcdefghijklmnopqrstuvwxyz", "abcdefghijklmnopqrstuvwxyz"],
        ],
    ),
    Problem(
        pid=1128,
        title="单词规律",
        difficulty="easy",
        tags=["字符串", "哈希表"],
        description="""给定一种规律 pattern 和一个字符串 s，判断 s 是否遵循相同的规律。
这里的遵循指完全匹配：pattern 中的每个字母和字符串 s 中的每个非空单词之间存在双向对应关系。

提示：
- 1 <= pattern.length <= 300
- pattern 只包含小写英文字母
- 1 <= s.length <= 3000
- s 只包含小写英文字母和空格，单词之间用一个空格分隔""",
        function="wordPattern",
        params=[("pattern", "string"), ("s", "string")],
        returns="bool",
        solver=word_pattern,
        public=[
            ["abba", "dog cat cat dog"],
            ["abba", "dog cat cat fish"],
            ["aaaa", "dog cat cat dog"],
            ["abba", "dog dog dog dog"],
        ],
        expected_public=[True, False, False, False],
        hidden=[
            ["a", "dog"], ["ab", "dog"], ["abc", "b c a"], ["aaa", "aa aa aa"],
            ["abb", "dog cat cat"], ["abb", "dog cat fish"], ["abc", "dog dog dog"],
            ["ab", "dog dog"], ["abcd", "a b c d"], ["aaaaa", "a b c d e"],
            ["abab", "dog cat dog cat"], ["aba", "cat dog cat"],
        ],
    ),
    Problem(
        pid=1129,
        title="字符串中的第一个唯一字符",
        difficulty="easy",
        tags=["字符串", "哈希表", "队列"],
        description="""给定一个字符串 s，找到它的第一个不重复的字符，并返回它的索引。
如果不存在，返回 -1。

提示：
- 1 <= s.length <= 10^5
- s 只包含小写字母""",
        function="firstUniqChar",
        params=[("s", "string")],
        returns="int",
        solver=first_uniq_char,
        public=[["leetcode"], ["loveleetcode"], ["aabb"], ["z"]],
        expected_public=[0, 2, -1, 0],
        hidden=[
            [""], ["a"], ["aa"], ["abcabd"], ["abcabc"], ["aabbcc"],
            ["abacabad"], ["eee"], ["abcde"], ["aabbc"], ["thequickbrownfox"],
        ],
    ),
    Problem(
        pid=1130,
        title="有效的字母异位词",
        difficulty="easy",
        tags=["字符串", "哈希表", "排序"],
        description="""给定两个字符串 s 和 t，判断 t 是否是 s 的字母异位词。
字母异位词指两个字符串中每个字符出现的次数都相同。

提示：
- 1 <= s.length, t.length <= 5 * 10^4
- s 和 t 仅包含小写字母""",
        function="isAnagram",
        params=[("s", "string"), ("t", "string")],
        returns="bool",
        solver=is_anagram,
        public=[
            ["anagram", "nagaram"],
            ["rat", "car"],
            ["a", "a"],
            ["ab", "a"],
        ],
        expected_public=[True, False, True, False],
        hidden=[
            ["", ""], ["a", ""], ["abc", "cba"], ["aacc", "ccac"],
            ["listen", "silent"], ["你好", "好你"], ["abc", "ab"],
            ["aaab", "abaa"], ["abcde", "edcba"], ["aab", "abb"],
        ],
    ),
    Problem(
        pid=1131,
        title="赎金信",
        difficulty="easy",
        tags=["字符串", "哈希表", "计数"],
        description="""给定两个字符串 ransomNote 和 magazine，判断 ransomNote 能否由 magazine 中的字母构成。
magazine 中的每个字母只能在 ransomNote 中使用一次。

提示：
- 1 <= ransomNote.length, magazine.length <= 10^5
- 两个字符串均由小写英文字母组成""",
        function="canConstruct",
        params=[("ransomNote", "string"), ("magazine", "string")],
        returns="bool",
        solver=can_construct,
        public=[
            ["a", "b"],
            ["aa", "ab"],
            ["aa", "aab"],
            ["abc", "ab"],
        ],
        expected_public=[False, False, True, False],
        hidden=[
            ["", ""], ["", "a"], ["a", ""], ["aa", "aa"], ["aab", "baa"],
            ["abcdef", "fedcba"], ["aabb", "ababab"], ["helloworld", "hello"],
            ["xyz", "zyx"], ["aaa", "aaaa"], ["aa", "aaa"], ["abc", "abcabc"],
        ],
    ),
    Problem(
        pid=1132,
        title="最长回文串",
        difficulty="easy",
        tags=["字符串", "哈希表", "贪心"],
        description="""给定一个包含大写字母和小写字母的字符串 s，返回由这些字母能构成的最长回文串的长度。
字母区分大小写。

提示：
- 1 <= s.length <= 2000
- s 只包含大小写英文字母""",
        function="longestPalindrome",
        params=[("s", "string")],
        returns="int",
        solver=longest_palindrome,
        public=[["abccccdd"], ["a"], ["bb"], ["ab"]],
        expected_public=[7, 1, 2, 1],
        hidden=[
            [""], ["ccc"], ["AaA"], ["aaaa"], ["aabbcc"], ["abababab"],
            ["bananas"], ["racecar"], ["abcde"], ["aaabbbccc"],
        ],
    ),
    Problem(
        pid=1133,
        title="斐波那契数",
        difficulty="easy",
        tags=["数学", "动态规划", "递归"],
        description="""斐波那契数通常用 F(n) 表示，形成的数列满足 F(0) = 0，F(1) = 1，F(n) = F(n - 1) + F(n - 2)（n > 1）。
给定 n，计算 F(n)。

提示：
- 0 <= n <= 30""",
        function="fib",
        params=[("n", "int")],
        returns="int",
        solver=fib,
        public=[[2], [3], [4], [10]],
        expected_public=[1, 2, 3, 55],
        hidden=[[0], [1], [5], [6], [7], [8], [15], [20],
                [25], [30]],
    ),
    Problem(
        pid=1134,
        title="爬楼梯",
        difficulty="easy",
        tags=["数学", "动态规划", "记忆化搜索"],
        description="""假设你正在爬楼梯，需要 n 阶才能到达楼顶。
每次可以爬 1 或 2 个台阶，有多少种不同的方法可以爬到楼顶？

提示：
- 1 <= n <= 45""",
        function="climbStairs",
        params=[("n", "int")],
        returns="int",
        solver=climb_stairs,
        public=[[2], [3], [1], [5]],
        expected_public=[2, 3, 1, 8],
        hidden=[[4], [6], [10], [12], [15], [20], [25], [30],
                [40], [45]],
    ),
    Problem(
        pid=1135,
        title="使用最小花费爬楼梯",
        difficulty="easy",
        tags=["数组", "动态规划"],
        description="""给定一个整数数组 cost，其中 cost[i] 是从楼梯第 i 个台阶向上爬需要支付的费用。
一旦支付费用，就可以选择向上爬一个或两个台阶。
可以从下标 0 或下标 1 的台阶开始，返回达到楼梯顶部的最低花费。

提示：
- 2 <= cost.length <= 1000
- 0 <= cost[i] <= 999""",
        function="minCostClimbingStairs",
        params=[("cost", "int[]")],
        returns="int",
        solver=min_cost_climbing_stairs,
        public=[
            [[10, 15, 20]],
            [[1, 100, 1, 1, 1, 100, 1, 1, 100, 1]],
            [[0, 0]],
            [[10, 15, 20, 25]],
        ],
        expected_public=[15, 6, 0, 30],
        hidden=[
            [[1, 100]], [[0, 1]], [[1, 2, 3, 4]], [[5, 5]], [[0, 5, 0]],
            [[999, 0, 999]], [[1, 1, 1]], [[2, 3, 4, 5, 6]],
            [[10, 1, 10, 1, 10]], [[0, 0, 0, 0]],
        ],
    ),
    Problem(
        pid=1136,
        title="买卖股票的最佳时机",
        difficulty="easy",
        tags=["数组", "动态规划", "贪心"],
        description="""给定一个数组 prices，它的第 i 个元素表示第 i 天的股票价格。
只能选择某一天买入并在未来的某一天卖出，返回能获取的最大利润。
如果无法获取利润，返回 0。

提示：
- 1 <= prices.length <= 10^5
- 0 <= prices[i] <= 10^4""",
        function="maxProfit",
        params=[("prices", "int[]")],
        returns="int",
        solver=max_profit,
        public=[[[7, 1, 5, 3, 6, 4]], [[7, 6, 4, 3, 1]], [[1]], [[2, 4, 1]]],
        expected_public=[5, 0, 0, 2],
        hidden=[
            [[]], [[1, 2, 3, 4, 5]], [[5, 4, 3, 2, 1]], [[3, 3, 3]],
            [[2, 1, 2, 0, 1]], [[1, 2, 4, 2, 5, 7, 2, 4, 9, 0]],
            [[6, 1, 3, 2, 4, 7]], [[10, 9, 8, 7, 6, 5, 4, 3, 2, 1]],
            [[2, 4, 1, 7, 3, 8]],
        ],
    ),
    Problem(
        pid=1137,
        title="杨辉三角",
        difficulty="easy",
        tags=["数组", "动态规划"],
        description="""给定一个非负整数 numRows，生成杨辉三角的前 numRows 行。
每个数是它左上方和右上方的数之和，边界数字为 1。

提示：
- 1 <= numRows <= 30""",
        function="generate",
        params=[("numRows", "int")],
        returns="int[][]",
        solver=generate_pascal,
        public=[[5], [1], [3], [6]],
        expected_public=[
            [[1], [1, 1], [1, 2, 1], [1, 3, 3, 1], [1, 4, 6, 4, 1]],
            [[1]],
            [[1], [1, 1], [1, 2, 1]],
            [[1], [1, 1], [1, 2, 1], [1, 3, 3, 1], [1, 4, 6, 4, 1], [1, 5, 10, 10, 5, 1]],
        ],
        hidden=[[2], [4], [7], [8], [9], [10], [12], [15],
                [20], [25], [30]],
    ),
    Problem(
        pid=1138,
        title="矩阵对角线元素的和",
        difficulty="easy",
        tags=["数组", "矩阵"],
        description="""给定一个 n x n 的整数矩阵 mat，返回 mat 的主对角线和副对角线上的元素之和。
主对角线是从左上到右下，副对角线是从右上到左下。两条对角线相交的元素只计算一次。

提示：
- 1 <= mat.length <= 100
- mat[i].length == mat.length""",
        function="diagonalSum",
        params=[("mat", "int[][]")],
        returns="int",
        solver=diagonal_sum,
        public=[
            [[[1, 2, 3], [4, 5, 6], [7, 8, 9]]],
            [[[1, 1, 1, 1], [1, 1, 1, 1], [1, 1, 1, 1], [1, 1, 1, 1]]],
            [[[1]]],
            [[[5, 6], [7, 8]]],
        ],
        expected_public=[25, 8, 1, 26],
        hidden=[
            [[[1, 2], [3, 4]]],
            [[[1, 1, 1], [1, 1, 1], [1, 1, 1]]],
            [[[2, 0, 0, 0], [0, 3, 0, 0], [0, 0, 4, 0], [0, 0, 0, 5]]],
            [[[10, 20, 30, 40, 50], [1, 2, 3, 4, 5], [5, 4, 3, 2, 1],
              [9, 8, 7, 6, 5], [2, 4, 6, 8, 10]]],
            [[[0]]],
            [[[-1]]],
        ],
    ),
    Problem(
        pid=1139,
        title="转置矩阵",
        difficulty="easy",
        tags=["数组", "矩阵", "模拟"],
        description="""给定一个 m x n 的二维整数数组 matrix，返回它的转置矩阵。
转置矩阵是将原矩阵的行和列互换得到的矩阵。

提示：
- 1 <= m, n <= 1000
- 1 <= m * n <= 10^5""",
        function="transpose",
        params=[("matrix", "int[][]")],
        returns="int[][]",
        solver=transpose,
        public=[
            [[[1, 2, 3], [4, 5, 6]]],
            [[[1, 2], [3, 4]]],
            [[[1]]],
            [[[1, 2, 3]]],
        ],
        expected_public=[
            [[1, 4], [2, 5], [3, 6]],
            [[1, 3], [2, 4]],
            [[1]],
            [[1], [2], [3]],
        ],
        hidden=[
            [[[1], [2], [3]]],
            [[[-1, -2], [-3, -4], [-5, -6]]],
            [[[0, 1, 2, 3], [4, 5, 6, 7]]],
            [[[10, 20], [30, 40], [50, 60], [70, 80]]],
            [[[7]]],
            [[[1, 2], [3, 4], [5, 6]]],
        ],
    ),
    Problem(
        pid=1140,
        title="重塑矩阵",
        difficulty="easy",
        tags=["数组", "矩阵", "模拟"],
        description="""给定一个 m x n 的二维整数数组 mat 和两个整数 r、c，返回重塑后的 r x c 矩阵。
重塑后的矩阵需要以相同的行优先顺序包含原矩阵的所有元素。
如果重塑操作不可行，返回原矩阵。

提示：
- 1 <= m, n <= 100
- -1000 <= mat[i][j] <= 1000
- 1 <= r, c <= 300""",
        function="matrixReshape",
        params=[("mat", "int[][]"), ("r", "int"), ("c", "int")],
        returns="int[][]",
        solver=matrix_reshape,
        public=[
            [[[1, 2], [3, 4]], 1, 4],
            [[[1, 2], [3, 4]], 2, 4],
            [[[1, 2, 3, 4]], 2, 2],
            [[[1, 2], [3, 4]], 4, 1],
        ],
        expected_public=[
            [[1, 2, 3, 4]],
            [[1, 2], [3, 4]],
            [[1, 2], [3, 4]],
            [[1], [2], [3], [4]],
        ],
        hidden=[
            [[[1, 2, 3], [4, 5, 6]], 3, 2],
            [[[1]], 1, 1],
            [[[1, 2]], 1, 2],
            [[[1, 2], [3, 4]], 1, 3],
            [[[1, 2, 3, 4, 5, 6]], 2, 3],
            [[[1, 2, 3, 4, 5, 6]], 3, 2],
            [[[1, 2], [3, 4], [5, 6]], 1, 6],
            [[[1, 2], [3, 4], [5, 6]], 6, 1],
        ],
    ),
    Problem(
        pid=1141,
        title="找到所有数组中消失的数字",
        difficulty="easy",
        tags=["数组", "哈希表"],
        description="""给定一个长度为 n 的整数数组 nums，其中 nums[i] 在区间 [1, n] 内。
找出所有在 [1, n] 范围内但没有出现在 nums 中的数字，并以升序数组返回。

提示：
- n == nums.length
- 1 <= n <= 10^5
- 1 <= nums[i] <= n""",
        function="findDisappearedNumbers",
        params=[("nums", "int[]")],
        returns="int[]",
        solver=find_disappeared_numbers,
        public=[
            [[4, 3, 2, 7, 8, 2, 3, 1]],
            [[1, 1]],
            [[2, 2]],
            [[1, 2, 3]],
        ],
        expected_public=[[5, 6], [2], [1], []],
        hidden=[
            [[1]], [[1, 1, 1]], [[2, 3, 4, 1]], [[3, 3, 3, 3]],
            [[5, 4, 3, 2, 1]], [[1, 1, 2, 2]], [[6, 5, 4, 3, 2, 1]],
            [[1, 2, 4, 4]], [[2, 1, 2, 1]], [[4, 4, 4, 4]],
        ],
    ),
    Problem(
        pid=1142,
        title="多数元素",
        difficulty="easy",
        tags=["数组", "哈希表", "分治", "计数"],
        description="""给定一个大小为 n 的整数数组 nums，返回其中的多数元素。
多数元素是指在数组中出现次数大于 n / 2 的元素。
可以假设数组是非空的，并且给定的数组总是存在多数元素。

提示：
- n == nums.length
- 1 <= n <= 5 * 10^4
- -10^9 <= nums[i] <= 10^9""",
        function="majorityElement",
        params=[("nums", "int[]")],
        returns="int",
        solver=majority_element,
        public=[[[3, 2, 3]], [[2, 2, 1, 1, 1, 2, 2]], [[1]], [[1, 1, 2]]],
        expected_public=[3, 2, 1, 1],
        hidden=[
            [[1, 2, 1]], [[5, 5, 5, 1, 2]], [[-1, -1, 2]], [[1, 1, 1, 2, 2]],
            [[7, 7, 7, 7]], [[0, 0, 1]], [[2, 2, 1, 2, 1, 1, 2]],
            [[1, 2, 3, 1, 1]], [[9, 9, 1, 9, 2]],
        ],
    ),
    Problem(
        pid=1143,
        title="单调数列",
        difficulty="easy",
        tags=["数组"],
        description="""如果数组是单调递增或单调递减的，返回 true，否则返回 false。
单调递增指数组中每个相邻元素 nums[i] <= nums[i + 1]；单调递减指数组中每个相邻元素 nums[i] >= nums[i + 1]。

提示：
- 1 <= nums.length <= 5 * 10^4
- -10^5 <= nums[i] <= 10^5""",
        function="isMonotonic",
        params=[("nums", "int[]")],
        returns="bool",
        solver=is_monotonic,
        public=[[[1, 2, 2, 3]], [[6, 5, 4, 4]], [[1, 3, 2]], [[1, 1, 1]]],
        expected_public=[True, True, False, True],
        hidden=[
            [[1]], [[1, 2]], [[2, 1]], [[1, 2, 1]], [[3, 2, 2, 1]],
            [[1, 1, 2, 2, 3]], [[5, 5, 4, 5]], [[-1, -2, -3]],
            [[1, 2, 2, 1]], [[0, 0, 0, 1]], [[2, 1, 2]],
        ],
    ),
    Problem(
        pid=1144,
        title="有序数组的平方",
        difficulty="easy",
        tags=["数组", "双指针", "排序"],
        description="""给定一个按非递减顺序排序的整数数组 nums，返回每个数字的平方组成的新数组，要求也按非递减顺序排序。

提示：
- 1 <= nums.length <= 10^4
- -10^4 <= nums[i] <= 10^4
- nums 已按非递减顺序排序""",
        function="sortedSquares",
        params=[("nums", "int[]")],
        returns="int[]",
        solver=sorted_squares,
        public=[
            [[-4, -1, 0, 3, 10]],
            [[-7, -3, 2, 3, 11]],
            [[1]],
            [[-1]],
        ],
        expected_public=[
            [0, 1, 9, 16, 100],
            [4, 9, 9, 49, 121],
            [1],
            [1],
        ],
        hidden=[
            [[]], [[0]], [[-2, -1]], [[1, 2]], [[-5, 5]], [[-3, -2, -1, 0]],
            [[0, 1, 2, 3]], [[-10000, 10000]], [[-10, -5, 0, 5, 10]],
        ],
    ),
    Problem(
        pid=1145,
        title="检测大写字母",
        difficulty="easy",
        tags=["字符串"],
        description="""给定一个单词 word，判断其大写字母的用法是否正确。
以下情况为正确：
- 全部字母都是大写，如 "USA"
- 全部字母都是小写，如 "leetcode"
- 只有首字母大写，如 "Google"
否则返回 false。

提示：
- 1 <= word.length <= 100
- word 由英文字母组成""",
        function="detectCapitalUse",
        params=[("word", "string")],
        returns="bool",
        solver=detect_capital_use,
        public=[["USA"], ["FlaG"], ["Google"], ["leetcode"]],
        expected_public=[True, False, True, True],
        hidden=[
            ["A"], ["a"], ["Aa"], ["aA"], ["AA"], ["aa"], ["AaA"],
            ["googlE"], ["FFFFFFFFFFFFFFFFFFFFf"], ["AbCd"], ["zZ"],
        ],
    ),
]
