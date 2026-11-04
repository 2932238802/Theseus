"""1200-1234：新增简单题（35 道）。"""

from __future__ import annotations

from collections import Counter
from functools import reduce
from math import gcd

from problem_seed_common import Problem


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
        difficulty="easy",
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


def two_sum_sorted(nums: list[int], target: int) -> list[int]:
    left, right = 0, len(nums) - 1
    while left < right:
        total = nums[left] + nums[right]
        if total == target:
            return [left + 1, right + 1]
        if total < target:
            left += 1
        else:
            right -= 1
    return []


def reverse_integer(x: int) -> int:
    sign = -1 if x < 0 else 1
    value = sign * int(str(abs(x))[::-1])
    if value < -(2**31) or value > 2**31 - 1:
        return 0
    return value


ROMAN = {"I": 1, "V": 5, "X": 10, "L": 50, "C": 100, "D": 500, "M": 1000}


def roman_to_int(s: str) -> int:
    total = 0
    for index, character in enumerate(s):
        value = ROMAN[character]
        if index + 1 < len(s) and ROMAN[s[index + 1]] > value:
            total -= value
        else:
            total += value
    return total


def longest_common_suffix(strs: list[str]) -> str:
    if not strs:
        return ""
    suffix = strs[0]
    for value in strs[1:]:
        while not value.endswith(suffix):
            suffix = suffix[1:]
            if not suffix:
                return ""
    return suffix


def merge_two_sorted(nums1: list[int], nums2: list[int]) -> list[int]:
    return sorted(nums1 + nums2)


def remove_duplicates_ii(nums: list[int]) -> list[int]:
    result: list[int] = []
    for value in nums:
        if result.count(value) < 2:
            result.append(value)
    return result


def remove_outer_parentheses(s: str) -> str:
    result: list[str] = []
    depth = 0
    for character in s:
        if character == "(":
            if depth > 0:
                result.append(character)
            depth += 1
        else:
            depth -= 1
            if depth > 0:
                result.append(character)
    return "".join(result)


def hamming_weight(n: int) -> int:
    return n.bit_count()


def single_number_ii(nums: list[int]) -> int:
    return next(value for value, count in Counter(nums).items() if count == 1)


def missing_number(nums: list[int]) -> int:
    return len(nums) * (len(nums) + 1) // 2 - sum(nums)


def trailing_zeroes(n: int) -> int:
    count = 0
    while n:
        n //= 5
        count += n
    return count


def excel_title(column_number: int) -> str:
    result = ""
    while column_number > 0:
        column_number -= 1
        result = chr(ord("A") + column_number % 26) + result
        column_number //= 26
    return result


def is_happy(n: int) -> bool:
    seen: set[int] = set()
    while n != 1 and n not in seen:
        seen.add(n)
        n = sum(int(digit) ** 2 for digit in str(n))
    return n == 1


def add_digits(num: int) -> int:
    return 0 if num == 0 else 1 + (num - 1) % 9


def find_the_difference(s: str, t: str) -> str:
    counts = Counter(t)
    counts.subtract(s)
    return next(character for character, count in counts.items() if count > 0)


def can_permute_palindrome(s: str) -> bool:
    return sum(value % 2 for value in Counter(s).values()) <= 1


def compress_string(s: str) -> str:
    if not s:
        return ""
    result: list[str] = []
    index = 0
    while index < len(s):
        end = index
        while end < len(s) and s[end] == s[index]:
            end += 1
        result.append(f"{s[index]}{end - index}")
        index = end
    return "".join(result)


def add_strings(num1: str, num2: str) -> str:
    return str(int(num1) + int(num2))


def is_palindrome_string(s: str) -> bool:
    cleaned = "".join(character.lower() for character in s if character.isalnum())
    return cleaned == cleaned[::-1]


def reverse_vowels(s: str) -> str:
    vowels = set("aeiouAEIOU")
    values = list(s)
    left, right = 0, len(values) - 1
    while left < right:
        while left < right and values[left] not in vowels:
            left += 1
        while left < right and values[right] not in vowels:
            right -= 1
        values[left], values[right] = values[right], values[left]
        left += 1
        right -= 1
    return "".join(values)


def reverse_str(s: str, k: int) -> str:
    values = list(s)
    for start in range(0, len(values), 2 * k):
        values[start : start + k] = reversed(values[start : start + k])
    return "".join(values)


def check_record(s: str) -> bool:
    return s.count("A") <= 1 and "LLL" not in s


def robot_returns_to_origin(moves: str) -> bool:
    return moves.count("U") == moves.count("D") and moves.count("L") == moves.count("R")


def to_lower_case(s: str) -> str:
    return s.lower()


def number_complement(num: int) -> int:
    bits = num.bit_length()
    return (1 << bits) - 1 - num


def has_alternating_bits(n: int) -> bool:
    bits = bin(n)[2:]
    return all(bits[index] != bits[index + 1] for index in range(len(bits) - 1))


def to_hex(num: int) -> str:
    return format(num, "x")


def intersection(nums1: list[int], nums2: list[int]) -> list[int]:
    return sorted(set(nums1) & set(nums2))


def intersection_ii(nums1: list[int], nums2: list[int]) -> list[int]:
    counts = Counter(nums1)
    result: list[int] = []
    for value in sorted(nums2):
        if counts[value] > 0:
            result.append(value)
            counts[value] -= 1
    return result


def is_boomerang(points: list[list[int]]) -> bool:
    (x1, y1), (x2, y2), (x3, y3) = points
    return (x2 - x1) * (y3 - y1) != (y2 - y1) * (x3 - x1)


def largest_perimeter(nums: list[int]) -> int:
    ordered = sorted(nums, reverse=True)
    for index in range(len(ordered) - 2):
        if ordered[index] < ordered[index + 1] + ordered[index + 2]:
            return ordered[index] + ordered[index + 1] + ordered[index + 2]
    return 0


def maximum_product(nums: list[int]) -> int:
    ordered = sorted(nums)
    return max(ordered[0] * ordered[1] * ordered[-1], ordered[-1] * ordered[-2] * ordered[-3])


def find_shortest_subarray(nums: list[int]) -> int:
    counts = Counter(nums)
    degree = max(counts.values())
    first: dict[int, int] = {}
    last: dict[int, int] = {}
    for index, value in enumerate(nums):
        first.setdefault(value, index)
        last[value] = index
    return min(last[value] - first[value] + 1 for value, count in counts.items() if count == degree)


def can_divide_into_groups(deck: list[int]) -> bool:
    return reduce(gcd, Counter(deck).values()) >= 2


MORSE = [
    ".-", "-...", "-.-.", "-..", ".", "..-.", "--.", "....", "..", ".---", "-.-", ".-..",
    "--", "-.", "---", ".--.", "--.-", ".-.", "...", "-", "..-", "...-", ".--", "-..-",
    "-.--", "--..",
]


def unique_morse_representations(words: list[str]) -> int:
    return len({"".join(MORSE[ord(character) - ord("a")] for character in word) for word in words})


PROBLEMS = [
    make(
        pid=1200,
        title="有序数组中的两数之和",
        tags=["数组", "双指针", "二分查找"],
        description="""给定一个按非递减顺序排列的整数数组 nums 和一个目标值 target，请找出和为目标值的两个整数。
返回它们的 1 基下标 [index1, index2]，要求 index1 < index2。可以假设每种输入恰好对应一个答案，且同一个元素不能重复使用。

提示：
- 2 <= nums.length <= 10^4
- -10^9 <= nums[i], target <= 10^9""",
        function="twoSumSorted",
        params=[("nums", "int[]"), ("target", "int")],
        returns="int[]",
        solver=two_sum_sorted,
        public=[[[2, 7, 11, 15], 9], [[2, 3, 4], 6], [[-1, 0, 1], 0], [[1, 2], 3]],
        hidden=[[[1, 2, 3, 4], 5], [[0, 0, 3, 4], 0], [[-5, -2, -1], -7], [[1, 3, 5, 8], 13], [[1, 5, 9], 10]],
    ),
    make(
        pid=1201,
        title="整数反转",
        tags=["数学", "字符串"],
        description="""给定一个 32 位有符号整数 x，返回将 x 中的数字部分反转后的结果。
如果反转后整数超出 32 位有符号整数范围 [-2^31, 2^31 - 1]，返回 0。负数反转后仍为负数。

提示：
- -2^31 <= x <= 2^31 - 1""",
        function="reverseInteger",
        params=[("x", "int")],
        returns="int",
        solver=reverse_integer,
        public=[[123], [-123], [120], [0]],
        hidden=[[1], [100], [-100], [1534236469], [-2147483648], [2147483647], [901000]],
    ),
    make(
        pid=1202,
        title="罗马数字转整数",
        tags=["字符串", "哈希表", "数学"],
        description="""给定一个罗马数字 s，将其转换成整数。
罗马数字包含字符 I、V、X、L、C、D、M；当较小数字位于较大数字左侧时表示减法。

提示：
- 1 <= s.length <= 15
- s 仅包含字符 I、V、X、L、C、D、M
- s 是有效的罗马数字""",
        function="romanToInt",
        params=[("s", "string")],
        returns="int",
        solver=roman_to_int,
        public=[["III"], ["IV"], ["IX"], ["MCMXCIV"]],
        hidden=[["I"], ["V"], ["XL"], ["XC"], ["LVIII"], ["CDXCIX"], ["MMMCMXCIX"]],
    ),
    make(
        pid=1203,
        title="最长公共后缀",
        tags=["字符串", "数组"],
        description="""给定一个字符串数组 strs，返回这些字符串的最长公共后缀。
如果不存在公共后缀，返回空字符串。

提示：
- 1 <= strs.length <= 200
- 0 <= strs[i].length <= 200""",
        function="longestCommonSuffix",
        params=[("strs", "string[]")],
        returns="string",
        solver=longest_common_suffix,
        public=[[["walking", "running", "swimming"]], [["computer", "developer", "teacher"]], [["abc", "abc"]], [["dog", "racecar", "car"]]],
        hidden=[[["a", "ba", "cba"]], [["end", "friend", "weekend"]], [["x", "y"]], [["function", "mountain"]], [["ab", "cab", "lab"]]],
    ),
    make(
        pid=1204,
        title="合并两个有序数组",
        tags=["数组", "排序"],
        description="""给定两个按非递减顺序排列的整数数组 nums1 和 nums2，返回合并后的非递减数组。

提示：
- 0 <= nums1.length, nums2.length <= 10^4
- -10^9 <= nums1[i], nums2[j] <= 10^9""",
        function="mergeTwoSorted",
        params=[("nums1", "int[]"), ("nums2", "int[]")],
        returns="int[]",
        solver=merge_two_sorted,
        public=[[[1, 2, 3], [2, 5, 6]], [[1], []], [[], [1]], [[4, 5], [1, 2]]],
        hidden=[[[], []], [[1, 1], [1]], [[-3, -1], [-2]], [[1, 4, 9], [2, 3]], [[5], [1, 2, 3, 4]]],
    ),
    make(
        pid=1205,
        title="删除有序数组中的重复项 II",
        tags=["数组", "双指针"],
        description="""给定一个非递减数组 nums，原地删除重复元素，使每个元素最多出现两次，并返回删除后的数组。
元素相对顺序保持不变。

提示：
- 1 <= nums.length <= 10^5
- -10^4 <= nums[i] <= 10^4""",
        function="removeDuplicatesII",
        params=[("nums", "int[]")],
        returns="int[]",
        solver=remove_duplicates_ii,
        public=[[[1, 1, 1, 2, 2, 3]], [[0, 0, 1, 1, 1, 1, 2, 3, 3]], [[1]], [[1, 2, 3]]],
        hidden=[[[1, 1]], [[1, 1, 1]], [[0, 0, 0, 0]], [[-1, -1, -1, 0, 0, 1]], [[1, 1, 2, 2, 2, 3, 3]]],
    ),
    make(
        pid=1206,
        title="删除最外层的括号",
        tags=["字符串", "栈"],
        description="""给定一个有效的括号字符串 s，删除每一个最外层括号，返回结果字符串。
例如 "(()())(())" 删除最外层后得到 "()()()"。

提示：
- 0 <= s.length <= 10^4
- s 是有效的括号字符串""",
        function="removeOuterParentheses",
        params=[("s", "string")],
        returns="string",
        solver=remove_outer_parentheses,
        public=[["(()())(())"], ["(()())(())(()(()))"], ["()()"], ["((()))"]],
        hidden=[["()"], ["(())"], ["(((())))"], ["(()(()))"], ["((()())())"]],
    ),
    make(
        pid=1207,
        title="二进制中 1 的个数",
        tags=["位运算"],
        description="""给定一个非负整数 n，返回其二进制表示中 1 的个数。

提示：
- 0 <= n <= 2^31 - 1""",
        function="hammingWeight",
        params=[("n", "int")],
        returns="int",
        solver=hamming_weight,
        public=[[11], [128], [0], [7]],
        hidden=[[1], [2], [3], [255], [1023], [2147483647], [1024]],
    ),
    make(
        pid=1208,
        title="只出现一次的数字 II",
        tags=["数组", "位运算", "哈希表"],
        description="""给定一个非空整数数组，除某个元素只出现一次外，其余元素都恰好出现三次。找出只出现一次的元素。

提示：
- 1 <= nums.length <= 3 * 10^4
- 除答案外，其他元素均出现三次""",
        function="singleNumberII",
        params=[("nums", "int[]")],
        returns="int",
        solver=single_number_ii,
        public=[[[2, 2, 3, 2]], [[0, 1, 0, 1, 0, 1, 99]], [[1, 1, 1, 2]], [[-2, -2, 1, -2]]],
        hidden=[[[5, 5, 5, 7]], [[1]], [[0, 0, 0, 4]], [[-1, -1, -1, 8]], [[3, 3, 2, 3, 2, 2, 9]]],
    ),
    make(
        pid=1209,
        title="缺失数字",
        tags=["数组", "数学"],
        description="""给定一个包含 n 个不同整数的数组 nums，数字范围为 [0, n]，找出其中缺失的那个数字。

提示：
- 1 <= nums.length <= 10^4
- 所有数字唯一""",
        function="missingNumber",
        params=[("nums", "int[]")],
        returns="int",
        solver=missing_number,
        public=[[[3, 0, 1]], [[0, 1]], [[9, 6, 4, 2, 3, 5, 7, 0, 1]], [[0]]],
        hidden=[[[1]], [[0, 2]], [[2, 0, 1]], [[0, 1, 3]], [[4, 3, 1, 0]], [[5, 4, 2, 1, 0]]],
    ),
    make(
        pid=1210,
        title="阶乘后的零",
        tags=["数学"],
        description="""给定整数 n，返回 n! 结果中尾随零的数量。

提示：
- 0 <= n <= 10^4""",
        function="trailingZeroes",
        params=[("n", "int")],
        returns="int",
        solver=trailing_zeroes,
        public=[[3], [5], [0], [25]],
        hidden=[[1], [10], [20], [50], [100], [1000], [10000]],
    ),
    make(
        pid=1211,
        title="Excel 表列名称",
        tags=["数学", "字符串"],
        description="""给定一个正整数 columnNumber，返回其在 Excel 表中的列名称。
列名称使用 A-Z 表示，1 对应 A，26 对应 Z，27 对应 AA。

提示：
- 1 <= columnNumber <= 2^31 - 1""",
        function="excelTitle",
        params=[("columnNumber", "int")],
        returns="string",
        solver=excel_title,
        public=[[1], [28], [701], [26]],
        hidden=[[2], [27], [52], [53], [702], [18278], [2147483647]],
    ),
    make(
        pid=1212,
        title="快乐数",
        tags=["数学", "哈希表"],
        description="""编写算法判断一个数 n 是否为快乐数。
快乐数的定义为：不断将数字替换为各位数字平方和，最终得到 1；若循环则不是快乐数。

提示：
- 1 <= n <= 2^31 - 1""",
        function="isHappy",
        params=[("n", "int")],
        returns="bool",
        solver=is_happy,
        public=[[19], [2], [7], [100]],
        hidden=[[1], [4], [10], [13], [23], [68], [1111111]],
    ),
    make(
        pid=1213,
        title="各位相加",
        tags=["数学", "模拟"],
        description="""给定一个非负整数 num，反复将各位数字相加，直到结果为一位数并返回。

提示：
- 0 <= num <= 2^31 - 1""",
        function="addDigits",
        params=[("num", "int")],
        returns="int",
        solver=add_digits,
        public=[[38], [0], [9], [123]],
        hidden=[[1], [10], [99], [100], [999], [456], [2147483647]],
    ),
    make(
        pid=1214,
        title="找不同",
        tags=["字符串", "哈希表", "位运算"],
        description="""字符串 t 由字符串 s 随机重排，并在随机位置添加一个字母构成。请找出被添加的字母。

提示：
- 0 <= s.length <= 10^4
- t.length == s.length + 1
- s 和 t 只包含小写英文字母""",
        function="findTheDifference",
        params=[("s", "string"), ("t", "string")],
        returns="string",
        solver=find_the_difference,
        public=[["abcd", "abcde"], ["", "y"], ["a", "aa"], ["ae", "aea"]],
        hidden=[["abc", "cbad"], ["x", "xy"], ["hello", "oellhh"], ["zz", "zzz"], ["abcd", "edcba"]],
    ),
    make(
        pid=1215,
        title="判断回文排列",
        tags=["字符串", "哈希表"],
        description="""给定一个字符串，判断其字符重排后能否形成回文串。

提示：
- 1 <= s.length <= 10^4
- s 只包含小写英文字母""",
        function="canPermutePalindrome",
        params=[("s", "string")],
        returns="bool",
        solver=can_permute_palindrome,
        public=[["code"], ["aab"], ["carerac"], ["abc"]],
        hidden=[["a"], ["aa"], ["aabb"], ["aabbc"], ["abcba"], ["abccba"], ["xyz"]],
    ),
    make(
        pid=1216,
        title="压缩字符串",
        tags=["字符串", "双指针"],
        description="""给定一个字符串 s，将连续重复字符压缩为“字符 + 次数”的形式并返回压缩结果。
即使长度为 1 也要写出次数。

提示：
- 0 <= s.length <= 10^4
- s 只包含小写英文字母""",
        function="compressString",
        params=[("s", "string")],
        returns="string",
        solver=compress_string,
        public=[["aabcccccaaa"], ["abc"], [""], ["aaaa"]],
        hidden=[["a"], ["abbcccddddeeeee"], ["zzzzzzzzzz"], ["ababab"], ["aaabba"]],
    ),
    make(
        pid=1217,
        title="字符串相加",
        tags=["字符串", "数学", "模拟"],
        description="""给定两个非负整数字符串 num1 和 num2，返回它们的和，结果也用字符串表示。
不能直接将输入转换为整数。

提示：
- 1 <= num1.length, num2.length <= 10^4
- 输入不含前导零，0 本身除外""",
        function="addStrings",
        params=[("num1", "string"), ("num2", "string")],
        returns="string",
        solver=add_strings,
        public=[["11", "123"], ["456", "77"], ["0", "0"], ["999", "1"]],
        hidden=[["1", "9"], ["99", "1"], ["123456789", "987654321"], ["0", "123"], ["58", "42"]],
    ),
    make(
        pid=1218,
        title="验证回文串",
        tags=["字符串", "双指针"],
        description="""给定一个字符串 s，只考虑字母和数字字符，忽略大小写，判断它是否为回文串。

提示：
- 1 <= s.length <= 2 * 10^5
- s 由 ASCII 字符组成""",
        function="isPalindromeString",
        params=[("s", "string")],
        returns="bool",
        solver=is_palindrome_string,
        public=[["A man, a plan, a canal: Panama"], ["race a car"], [" "], ["0P"]],
        hidden=[["a"], ["ab"], ["aba"], ["abba"], ["a."], ["No 'x' in Nixon"], ["12 21"]],
    ),
    make(
        pid=1219,
        title="反转字符串中的元音字母",
        tags=["字符串", "双指针"],
        description="""给定一个字符串 s，反转其中所有元音字母并返回结果。元音字母包括 a、e、i、o、u 及大写形式。

提示：
- 1 <= s.length <= 10^5
- s 由 ASCII 可打印字符组成""",
        function="reverseVowels",
        params=[("s", "string")],
        returns="string",
        solver=reverse_vowels,
        public=[["hello"], ["leetcode"], ["aA"], ["xyz"]],
        hidden=[["aeiou"], ["hEllO"], ["racecar"], ["bcdfg"], ["AaEeIiOoUu"]],
    ),
    make(
        pid=1220,
        title="反转字符串 II",
        tags=["字符串", "双指针"],
        description="""给定字符串 s 和整数 k，从字符串开头算起，每计数至 2k 个字符就反转前 k 个字符。
如果剩余字符少于 k 个，则反转所有剩余字符；如果剩余字符在 k 到 2k 之间，则反转前 k 个字符。

提示：
- 1 <= s.length <= 10^4
- 1 <= k <= 10^4""",
        function="reverseStr",
        params=[("s", "string"), ("k", "int")],
        returns="string",
        solver=reverse_str,
        public=[["abcdefg", 2], ["abcd", 2], ["abcdef", 3], ["a", 1]],
        hidden=[["abcdefgh", 3], ["hello", 4], ["abcdef", 1], ["123456789", 5], ["ab", 2]],
    ),
    make(
        pid=1221,
        title="学生出勤记录 I",
        tags=["字符串"],
        description="""给定一个字符串 s 表示学生出勤记录，判断该记录是否可被奖励。
如果记录中不存在连续三天或以上迟到（L），且缺勤（A）总次数少于 2，则可被奖励。

提示：
- 1 <= s.length <= 10^4
- s 只包含 A、L、P""",
        function="checkRecord",
        params=[("s", "string")],
        returns="bool",
        solver=check_record,
        public=[["PPALLP"], ["PPALLL"], ["P"], ["ALL"]],
        hidden=[["A"], ["AA"], ["LLL"], ["LL"], ["PAL"], ["PPPP"], ["LALL"]],
    ),
    make(
        pid=1222,
        title="机器人能否返回原点",
        tags=["字符串", "模拟"],
        description="""在二维平面上，机器人从原点 (0, 0) 出发，按移动序列 moves 移动。
U 向上，D 向下，L 向左，R 向右。判断机器人最终能否回到原点。

提示：
- 1 <= moves.length <= 2 * 10^4
- moves 只包含 U、D、L、R""",
        function="robotReturnsToOrigin",
        params=[("moves", "string")],
        returns="bool",
        solver=robot_returns_to_origin,
        public=[["UD"], ["LL"], ["RRDD"], ["UUDD"]],
        hidden=[["U"], ["D"], ["ULDR"], ["UUUDDD"], ["LRRL"], ["UUU"]],
    ),
    make(
        pid=1223,
        title="转换成小写字母",
        tags=["字符串"],
        description="""给定一个字符串 s，将其中的大写字母转换为小写字母并返回。

提示：
- 1 <= s.length <= 10^5
- s 由 ASCII 字符组成""",
        function="toLowerCase",
        params=[("s", "string")],
        returns="string",
        solver=to_lower_case,
        public=[["Hello"], ["here"], ["LOVELY"], ["123ABC"]],
        hidden=[["A"], ["Z"], ["AbC"], ["Hello World"], ["MiXeD123"]],
    ),
    make(
        pid=1224,
        title="数字的补数",
        tags=["位运算"],
        description="""给定一个正整数 num，输出它的补数。
补数是将二进制表示中每一位取反后的结果，前导零不参与取反。

提示：
- 1 <= num < 2^31""",
        function="numberComplement",
        params=[("num", "int")],
        returns="int",
        solver=number_complement,
        public=[[5], [1], [7], [10]],
        hidden=[[2], [3], [4], [8], [15], [16], [1000]],
    ),
    make(
        pid=1225,
        title="交替位二进制数",
        tags=["位运算"],
        description="""给定一个正整数 n，检查其二进制表示中相邻两位是否总是不同。

提示：
- 1 <= n <= 2^31 - 1""",
        function="hasAlternatingBits",
        params=[("n", "int")],
        returns="bool",
        solver=has_alternating_bits,
        public=[[5], [7], [11], [10]],
        hidden=[[1], [2], [3], [4], [15], [21], [22], [42]],
    ),
    make(
        pid=1226,
        title="数字转换为十六进制数",
        tags=["数学", "位运算", "字符串"],
        description="""给定一个非负整数 num，返回其十六进制表示字符串，字母使用小写形式。

提示：
- 0 <= num <= 2^31 - 1""",
        function="toHex",
        params=[("num", "int")],
        returns="string",
        solver=to_hex,
        public=[[26], [31], [0], [255]],
        hidden=[[1], [15], [16], [17], [4096], [123456], [2147483647]],
    ),
    make(
        pid=1227,
        title="两个数组的交集",
        tags=["数组", "哈希表", "排序"],
        description="""给定两个整数数组 nums1 和 nums2，返回它们的交集。结果中每个元素唯一，按升序排列。

提示：
- 1 <= nums1.length, nums2.length <= 10^4
- 0 <= nums1[i], nums2[i] <= 10^9""",
        function="intersection",
        params=[("nums1", "int[]"), ("nums2", "int[]")],
        returns="int[]",
        solver=intersection,
        public=[[[1, 2, 2, 1], [2, 2]], [[4, 9, 5], [9, 4, 9, 8, 4]], [[1], [2]], [[1, 2], [1, 2]]],
        hidden=[[[1, 1], [1]], [[3, 1, 2], [2, 3]], [[0], [0]], [[-1, 0, 1], [0, 1, 2]], [[5, 5, 5], [5]]],
    ),
    make(
        pid=1228,
        title="两个数组的交集 II",
        tags=["数组", "哈希表", "排序"],
        description="""给定两个整数数组 nums1 和 nums2，返回它们的交集。结果中每个元素出现次数应与两个数组中该元素出现次数的较小值一致。结果按升序排列。

提示：
- 1 <= nums1.length, nums2.length <= 10^4
- 0 <= nums1[i], nums2[i] <= 10^9""",
        function="intersectionII",
        params=[("nums1", "int[]"), ("nums2", "int[]")],
        returns="int[]",
        solver=intersection_ii,
        public=[[[1, 2, 2, 1], [2, 2]], [[4, 9, 5], [9, 4, 9, 8, 4]], [[1, 2], [1]], [[1, 1, 2], [1, 2, 2]]],
        hidden=[[[1], [1]], [[1, 2, 2], [2]], [[0, 0, 0], [0, 0]], [[-1, 1, 1], [1, -1]], [[5, 5, 3], [5, 3, 5]]],
    ),
    make(
        pid=1229,
        title="有效的回旋镖",
        tags=["数学", "几何"],
        description="""给定三个点 points，其中 points[i] = [xi, yi]，判断它们是否构成一个面积不为零的三角形。
也就是判断三个点是否不在同一直线上。

提示：
- points.length == 3
- -10^4 <= xi, yi <= 10^4""",
        function="isBoomerang",
        params=[("points", "int[][]")],
        returns="bool",
        solver=is_boomerang,
        public=[[[[0, 0], [1, 1], [1, 2]]], [[[1, 1], [2, 3], [3, 2]]], [[[0, 0], [1, 1], [2, 2]]], [[[0, 0], [0, 1], [1, 0]]]],
        hidden=[[[[0, 0], [0, 0], [1, 1]]], [[[1, 1], [2, 2], [3, 3]]], [[[-1, 0], [0, 0], [1, 0]]], [[[0, 0], [1, 0], [0, 1]]], [[[2, 3], [4, 6], [6, 9]]]],
    ),
    make(
        pid=1230,
        title="三角形的最大周长",
        tags=["数组", "排序", "贪心"],
        description="""给定一个正整数数组 nums，从中选出三个数组成三角形，返回能组成的最大三角形周长。
如果无法组成任何三角形，返回 0。

提示：
- 3 <= nums.length <= 10^4
- 1 <= nums[i] <= 10^6""",
        function="largestPerimeter",
        params=[("nums", "int[]")],
        returns="int",
        solver=largest_perimeter,
        public=[[[2, 1, 2]], [[1, 2, 1]], [[3, 6, 2, 3]], [[2, 3, 4]]],
        hidden=[[[1, 1, 1]], [[1, 2, 3]], [[3, 4, 5]], [[5, 5, 5]], [[10, 2, 5, 6, 7]], [[1, 1, 100]]],
    ),
    make(
        pid=1231,
        title="三个数的最大乘积",
        tags=["数组", "排序", "数学"],
        description="""给定一个整数数组 nums，返回其中三个数的最大乘积。

提示：
- 3 <= nums.length <= 10^4
- -10^3 <= nums[i] <= 10^3""",
        function="maximumProduct",
        params=[("nums", "int[]")],
        returns="int",
        solver=maximum_product,
        public=[[[1, 2, 3]], [[1, 2, 3, 4]], [[-1, -2, -3]], [[-10, -10, 1, 2]]],
        hidden=[[[0, 1, 2]], [[-1, 2, 3]], [[-5, -4, -3, -2]], [[1, 1, 1]], [[10, 9, 8, 1]], [[-100, -99, 2, 3]]],
    ),
    make(
        pid=1232,
        title="数组的度",
        tags=["数组", "哈希表"],
        description="""给定一个非空整数数组 nums，数组的度定义为任意元素出现频率的最大值。
返回与 nums 拥有相同度的最短连续子数组的长度。

提示：
- 1 <= nums.length <= 10^5
- -1000 <= nums[i] <= 1000""",
        function="findShortestSubArray",
        params=[("nums", "int[]")],
        returns="int",
        solver=find_shortest_subarray,
        public=[[[1, 2, 2, 3, 1]], [[1, 2, 2, 3, 1, 4, 2]], [[1]], [[1, 2, 3]]],
        hidden=[[[1, 1]], [[1, 2, 1, 3]], [[2, 1, 1, 2]], [[0, 0, 1, 1]], [[4, 4, 2, 2, 3]], [[1, 2, 2, 1, 3]]],
    ),
    make(
        pid=1233,
        title="卡牌分组",
        tags=["数组", "数学"],
        description="""给定一副牌，每张牌上有一个整数。判断是否可以将这副牌分成一组或多组，使得每组都有 X 张牌，且每组牌上的数字相同。
X 必须大于等于 2。

提示：
- 1 <= deck.length <= 10^4
- 0 <= deck[i] < 10^4""",
        function="canDivideIntoGroups",
        params=[("deck", "int[]")],
        returns="bool",
        solver=can_divide_into_groups,
        public=[[[1, 2, 3, 4, 4, 3, 2, 1]], [[1, 1, 1, 2, 2, 2, 3, 3]], [[1]], [[1, 1, 2, 2, 2, 2]]],
        hidden=[[[1, 1]], [[1, 1, 1, 1]], [[1, 1, 2, 2]], [[1, 1, 2, 2, 3, 3]], [[4, 4, 4, 4, 4]], [[1, 1, 1, 2, 2]]],
    ),
    make(
        pid=1234,
        title="唯一摩尔斯密码词",
        tags=["字符串", "哈希表"],
        description="""给定一个字符串数组 words，每个单词可以按照摩尔斯密码表转换成对应密码。
返回所有单词对应密码中不同表示的数量。

提示：
- 1 <= words.length <= 100
- 1 <= words[i].length <= 12
- words[i] 只包含小写英文字母""",
        function="uniqueMorseRepresentations",
        params=[("words", "string[]")],
        returns="int",
        solver=unique_morse_representations,
        public=[[["gin", "zen", "gig", "msg"]], [["a"]], [["abc", "abc"]], [["a", "b"]]],
        hidden=[[["a", "b", "c"]], [["aa", "bb"]], [["z"]], [["ab", "ba"]], [["hello", "world"]], [["same", "same", "same"]]],
    ),
]
