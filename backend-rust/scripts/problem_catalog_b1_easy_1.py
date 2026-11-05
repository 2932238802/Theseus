"""1300-1337：批量第一批简单题（38 道）。"""

from __future__ import annotations

from collections import Counter
from functools import partial

from problem_seed_common import make_problem

make = partial(make_problem, difficulty="easy")


def sort_array_by_parity(nums: list[int]) -> list[int]:
    return [value for value in nums if value % 2 == 0] + [
        value for value in nums if value % 2
    ]


def replace_elements(arr: list[int]) -> list[int]:
    result = [-1] * len(arr)
    best = -1
    for index in range(len(arr) - 1, -1, -1):
        result[index] = best
        best = max(best, arr[index])
    return result


def duplicate_zeros(arr: list[int]) -> list[int]:
    result: list[int] = []
    for value in arr:
        result.append(value)
        if value == 0:
            result.append(0)
        if len(result) >= len(arr):
            break
    return result[: len(arr)]


def check_if_exist(arr: list[int]) -> bool:
    for i, left in enumerate(arr):
        for j, right in enumerate(arr):
            if i != j and left == 2 * right:
                return True
    return False


def reverse_only_letters(s: str) -> str:
    chars = list(s)
    left, right = 0, len(s) - 1
    while left < right:
        if not chars[left].isalpha():
            left += 1
        elif not chars[right].isalpha():
            right -= 1
        else:
            chars[left], chars[right] = chars[right], chars[left]
            left += 1
            right -= 1
    return "".join(chars)


def max_product(nums: list[int]) -> int:
    ordered = sorted(nums)
    return (ordered[-1] - 1) * (ordered[-2] - 1)


def minimum_length(s: str) -> int:
    left, right = 0, len(s) - 1
    while left < right and s[left] == s[right]:
        character = s[left]
        while left <= right and s[left] == character:
            left += 1
        while left <= right and s[right] == character:
            right -= 1
    return max(0, right - left + 1)


def final_prices(prices: list[int]) -> list[int]:
    result = []
    for i, price in enumerate(prices):
        discount = 0
        for j in range(i + 1, len(prices)):
            if prices[j] <= price:
                discount = prices[j]
                break
        result.append(price - discount)
    return result


def balanced_string_split(s: str) -> int:
    balance = 0
    count = 0
    for character in s:
        balance += 1 if character == "L" else -1
        if balance == 0:
            count += 1
    return count


def backspace_compare(s: str, t: str) -> bool:
    def normalize(text: str) -> str:
        stack: list[str] = []
        for character in text:
            if character == "#":
                if stack:
                    stack.pop()
            else:
                stack.append(character)
        return "".join(stack)

    return normalize(s) == normalize(t)


def restore_string(s: str, indices: list[int]) -> str:
    result = [""] * len(s)
    for character, index in zip(s, indices):
        result[index] = character
    return "".join(result)


def xor_operation(n: int, start: int) -> int:
    result = 0
    for index in range(n):
        result ^= start + 2 * index
    return result


def min_operations_alternating(s: str) -> int:
    def flips(first: str) -> int:
        return sum(character != (first if index % 2 == 0 else str(1 - int(first)))
                   for index, character in enumerate(s))

    return min(flips("0"), flips("1"))


def pivot_index(nums: list[int]) -> int:
    total = sum(nums)
    left = 0
    for index, value in enumerate(nums):
        if left == total - left - value:
            return index
        left += value
    return -1


def largest_altitude(gain: list[int]) -> int:
    altitude = 0
    best = 0
    for delta in gain:
        altitude += delta
        best = max(best, altitude)
    return best


def exchange_bits(num: int) -> int:
    return ((num & 0x55555555) << 1) | ((num & 0xAAAAAAAA) >> 1)


def num_unique_emails(emails: list[str]) -> int:
    unique: set[str] = set()
    for email in emails:
        local, domain = email.split("@")
        local = local.split("+")[0].replace(".", "")
        unique.add(f"{local}@{domain}")
    return len(unique)


def to_goat_latin(sentence: str) -> str:
    vowels = set("aeiouAEIOU")
    result = []
    for index, word in enumerate(sentence.split(" "), start=1):
        if word[0] in vowels:
            translated = word + "ma"
        else:
            translated = word[1:] + word[0] + "ma"
        result.append(translated + "a" * index)
    return " ".join(result)


def check_straight_line(coordinates: list[list[int]]) -> bool:
    x0, y0 = coordinates[0]
    x1, y1 = coordinates[1]
    for x2, y2 in coordinates[2:]:
        if (x1 - x0) * (y2 - y0) != (x2 - x0) * (y1 - y0):
            return False
    return True


def check_rotated_sorted(nums: list[int]) -> bool:
    size = len(nums)
    drops = sum(1 for index in range(size) if nums[index] > nums[(index + 1) % size])
    return drops <= 1


def sum_base(n: int, k: int) -> int:
    total = 0
    while n:
        total += n % k
        n //= k
    return total


def array_rank_transform(arr: list[int]) -> list[int]:
    ranks = {value: index + 1 for index, value in enumerate(sorted(set(arr)))}
    return [ranks[value] for value in arr]


def count_k_difference(nums: list[int], k: int) -> int:
    counts = Counter(nums)
    if k == 0:
        return sum(count * (count - 1) // 2 for count in counts.values())
    return sum(count * counts.get(value + k, 0) for value, count in counts.items())


def tictactoe(moves: list[list[int]]) -> str:
    board = [[0] * 3 for _ in range(3)]

    def winner(player: int) -> bool:
        lines = [board[i] for i in range(3)]
        lines += [[board[i][j] for i in range(3)] for j in range(3)]
        lines.append([board[i][i] for i in range(3)])
        lines.append([board[i][2 - i] for i in range(3)])
        return any(all(cell == player for cell in line) for line in lines)

    for index, (row, column) in enumerate(moves):
        player = 1 if index % 2 == 0 else 2
        board[row][column] = player
        if winner(player):
            return "A" if player == 1 else "B"
    return "Pending" if len(moves) < 9 else "Draw"


def k_weakest_rows(mat: list[list[int]], k: int) -> list[int]:
    order = sorted(range(len(mat)), key=lambda row: (sum(mat[row]), row))
    return order[:k]


def create_target_array(nums: list[int], index: list[int]) -> list[int]:
    target: list[int] = []
    for value, position in zip(nums, index):
        target.insert(position, value)
    return target


def number_of_steps(num: int) -> int:
    steps = 0
    while num:
        num = num - 1 if num % 2 else num // 2
        steps += 1
    return steps


PROBLEMS = [
    make(
        pid=1300,
        title="按奇偶排序数组",
        tags=["数组", "双指针"],
        description="""给定一个整数数组 nums，将所有偶数移到数组前面、所有奇数移到数组后面。
要求保持偶数和奇数各自原有的相对顺序，返回处理后的数组。""",
        function="sortArrayByParity",
        params=[("nums", "int[]")],
        returns="int[]",
        solver=sort_array_by_parity,
        public=[[[3, 1, 2, 4]], [[0]], [[1, 3, 5]], [[2, 4, 6]]],
        hidden=[[[1, 2, 3, 4, 5, 6]], [[-2, -1, 0, 1]], [[0, 1]], [[7, 6, 5, 4, 3, 2, 1]], [[2, 1, 4, 3]]],
    ),
    make(
        pid=1301,
        title="高度检查器",
        tags=["数组", "排序"],
        description="""给定数组 heights，返回将其按非递减顺序排序后，与原数组对应位置元素不同的位置数量。""",
        function="heightChecker",
        params=[("heights", "int[]")],
        returns="int",
        solver=lambda heights: sum(
            left != right for left, right in zip(heights, sorted(heights))
        ),
        public=[[[1, 1, 4, 2, 1, 3]], [[5, 1, 2, 3, 4]], [[1, 2, 3, 4, 5]]],
        hidden=[[[1]], [[2, 1]], [[1, 2, 3]], [[3, 2, 1]], [[10, 6, 6, 10, 10, 9, 8, 8, 3, 3, 8, 2, 1, 5, 9, 10, 2, 4, 8, 4]]],
    ),
    make(
        pid=1302,
        title="将每个元素替换为右侧最大元素",
        tags=["数组"],
        description="""对数组 arr 的每个位置 i，返回 arr[i] 右侧所有元素中的最大值。
最后一个位置右侧没有元素，返回 -1。""",
        function="replaceElements",
        params=[("arr", "int[]")],
        returns="int[]",
        solver=replace_elements,
        public=[[[17, 18, 5, 4, 6, 1]], [[400]]],
        hidden=[[[1, 2, 3, 4, 5]], [[5, 4, 3, 2, 1]], [[1, 1, 1]], [[0, 0, 0, 0]]],
    ),
    make(
        pid=1303,
        title="复写零",
        tags=["数组", "双指针"],
        description="""对数组 arr 中的每个 0，在其后复写一个 0，并将后续元素整体右移。
超出原数组长度的元素会被丢弃。返回处理后的数组。""",
        function="duplicateZeros",
        params=[("arr", "int[]")],
        returns="int[]",
        solver=duplicate_zeros,
        public=[[[1, 0, 2, 3]], [[0, 0, 0]], [[1, 2, 3]]],
        hidden=[[[0]], [[1, 0, 0, 2]], [[0, 1, 0]], [[1, 2, 0, 3, 4]], [[9, 0, 8]]],
    ),
    make(
        pid=1304,
        title="检查整数及其两倍数是否存在",
        tags=["数组", "哈希表"],
        description="""给定整数数组 arr，判断是否存在两个不同的下标 i 和 j，使得 arr[i] == 2 * arr[j]。""",
        function="checkIfExist",
        params=[("arr", "int[]")],
        returns="bool",
        solver=check_if_exist,
        public=[[[10, 2, 5, 3]], [[3, 1, 7, 11]], [[7, 1, 14, 11]], [[0, 0]]],
        hidden=[[[0, 1]], [[1, 2]], [[-2, -4]], [[2, 4]], [[1, 1, 2]], [[0]]],
    ),
    make(
        pid=1305,
        title="仅仅反转字母",
        tags=["字符串", "双指针"],
        description="""给定字符串 s，反转其中所有字母的位置，非字母字符保持原位不变。返回处理后的字符串。""",
        function="reverseOnlyLetters",
        params=[("s", "string")],
        returns="string",
        solver=reverse_only_letters,
        public=[["ab-cd"], ["a-bC-dEf-ghIj"], ["Test1ng-Leet=code-Q!"]],
        hidden=[["-"], ["a1b2c"], ["!A?"], ["ab"], ["z"]],
    ),
    make(
        pid=1306,
        title="反转单词前缀",
        tags=["字符串", "双指针"],
        description="""给定字符串 s 和整数 k，其中 1 <= k <= s.length。
将 s 的前 k 个字符反转，其余部分保持不变，返回结果。""",
        function="reversePrefix",
        params=[("s", "string"), ("k", "int")],
        returns="string",
        solver=lambda s, k: s[:k][::-1] + s[k:],
        public=[["abcdefd", 4], ["xyxz", 2], ["abcd", 1]],
        hidden=[["a", 1], ["ab", 2], ["abcde", 5], ["hello", 3]],
    ),
    make(
        pid=1307,
        title="数组中两元素的最大乘积",
        tags=["数组", "排序"],
        description="""给定整数数组 nums，选择两个不同下标的元素，返回 (nums[i] - 1) * (nums[j] - 1) 的最大值。
所有元素均为正整数。""",
        function="maxProduct",
        params=[("nums", "int[]")],
        returns="int",
        solver=max_product,
        public=[[[3, 4, 5, 2]], [[1, 5, 4, 5]], [[3, 7]]],
        hidden=[[[1, 1]], [[10, 2, 3]], [[1, 2, 3]], [[9, 8, 7]]],
    ),
    make(
        pid=1308,
        title="删除字符串两端相同字符后的最短长度",
        tags=["字符串", "双指针"],
        description="""每次可以删除字符串两端相同字符组成的前缀一个字符和后缀一个字符，重复该过程。
返回最终可能得到的最短字符串长度。""",
        function="minimumLength",
        params=[("s", "string")],
        returns="int",
        solver=minimum_length,
        public=[["ca"], ["cabaabac"], ["aabccabba"]],
        hidden=[["a"], ["ab"], ["aa"], ["abba"], ["abcba"], ["aaaa"]],
    ),
    make(
        pid=1309,
        title="统计一致字符串的数目",
        tags=["字符串", "哈希表"],
        description="""给定只含小写字母的字符串 allowed 和字符串数组 words。
若 word 中的每个字符都在 allowed 中出现，则称 word 是一致的。返回一致字符串的数目。""",
        function="countConsistentStrings",
        params=[("allowed", "string"), ("words", "string[]")],
        returns="int",
        solver=lambda allowed, words: sum(
            all(character in set(allowed) for character in word) for word in words
        ),
        public=[
            ["ab", ["ad", "bd", "aaab", "baa", "badab"]],
            ["abc", ["a", "b", "c", "ab", "ac", "bc", "abc"]],
            ["cad", ["a", "b", "c", "ab", "ac", "bc", "abc"]],
        ],
        hidden=[["a", ["a", "aa", "b"]], ["xyz", ["x", "y", "z", "xy"]], ["abc", ["abcd", "ab", "c"]]],
    ),
    make(
        pid=1310,
        title="商品折扣后的最终价格",
        tags=["数组", "单调栈"],
        description="""对 prices 中的每个元素，找到它右侧第一个小于等于它的价格 prices[j]。
最终价格为 prices[i] - prices[j]；若不存在这样的 j，则不打折。返回最终价格数组。""",
        function="finalPrices",
        params=[("prices", "int[]")],
        returns="int[]",
        solver=final_prices,
        public=[[[8, 4, 6, 2, 3]], [[1, 2, 3, 4, 5]], [[10, 1, 1, 6]]],
        hidden=[[[5]], [[100, 1]], [[1, 100]], [[2, 2, 2]], [[5, 4, 3, 2, 1]]],
    ),
    make(
        pid=1311,
        title="分割平衡字符串",
        tags=["字符串", "贪心"],
        description="""平衡字符串中 'L' 和 'R' 的数量相等。给定只含 'L'、'R' 的字符串 s，
将其分割成尽可能多的平衡字符串，返回最大数量。""",
        function="balancedStringSplit",
        params=[("s", "string")],
        returns="int",
        solver=balanced_string_split,
        public=[["RLRRLLRLRL"], ["RLRRRLLRLL"], ["LLLLRRRR"]],
        hidden=[["LR"], ["RL"], ["LLRR"], ["LRLR"], ["RLRLRL"]],
    ),
    make(
        pid=1312,
        title="比较含退格的字符串",
        tags=["字符串", "栈"],
        description="""'#' 表示退格操作，会删除前一个字符。给定字符串 s 和 t，
判断两者处理所有退格后是否相等。""",
        function="backspaceCompare",
        params=[("s", "string"), ("t", "string")],
        returns="bool",
        solver=backspace_compare,
        public=[["ab#c", "ad#c"], ["ab##", "c#d#"], ["a#c", "b"]],
        hidden=[["a", "a"], ["a#", ""], ["###", "###"], ["a##b", "b"], ["abc#d", "abd"]],
    ),
    make(
        pid=1313,
        title="旋转字符串",
        tags=["字符串"],
        description="""给定字符串 s 和 goal，判断 goal 是否是 s 经过若干次循环移位得到的字符串。""",
        function="rotateString",
        params=[("s", "string"), ("goal", "string")],
        returns="bool",
        solver=lambda s, goal: len(s) == len(goal) and goal in (s + s),
        public=[["abcde", "cdeab"], ["abcde", "abced"], ["abc", "abc"]],
        hidden=[["a", "a"], ["a", "b"], ["ab", "ba"], ["abc", "cab"], ["abc", "acb"]],
    ),
    make(
        pid=1314,
        title="重新排列字符串",
        tags=["数组", "字符串"],
        description="""给定字符串 s 和长度相同的整数数组 indices，按 indices[i] 指定的位置重建字符串：
result[indices[i]] = s[i]。返回重建后的字符串。""",
        function="restoreString",
        params=[("s", "string"), ("indices", "int[]")],
        returns="string",
        solver=restore_string,
        public=[
            ["codeleet", [4, 5, 6, 7, 0, 2, 1, 3]],
            ["abc", [0, 1, 2]],
            ["aiohn", [3, 1, 4, 2, 0]],
        ],
        hidden=[["a", [0]], ["ab", [1, 0]], ["xyz", [2, 0, 1]]],
    ),
    make(
        pid=1315,
        title="拥有最多糖果的孩子",
        tags=["数组"],
        description="""给定 candies 和 extraCandies。对每个孩子，判断把至多 extraCandies 颗糖果全部给他后，
他是否拥有最多的糖果（可以与其他人并列）。返回布尔数组。""",
        function="kidsWithCandies",
        params=[("candies", "int[]"), ("extraCandies", "int")],
        returns="bool[]",
        solver=lambda candies, extra: [
            value + extra >= max(candies) for value in candies
        ],
        public=[[[2, 3, 5, 1, 3], 3], [[4, 2, 1, 1, 2], 1], [[12, 1, 12], 10]],
        hidden=[[[1], 0], [[1, 1], 0], [[1, 1], 1], [[5, 5, 5], 1]],
    ),
    make(
        pid=1316,
        title="数组异或操作",
        tags=["数组", "位运算"],
        description="""构造数组 nums，其中 nums[i] = start + 2 * i（0 <= i < n）。
返回 nums 中所有元素的按位异或结果。""",
        function="xorOperation",
        params=[("n", "int"), ("start", "int")],
        returns="int",
        solver=xor_operation,
        public=[[5, 0], [4, 3], [1, 7]],
        hidden=[[1, 0], [2, 1], [10, 5], [3, 8]],
    ),
    make(
        pid=1317,
        title="生成交替二进制字符串的最少操作数",
        tags=["字符串", "贪心"],
        description="""给定只含 '0' 和 '1' 的字符串 s。每次操作可以翻转一个字符，
返回使 s 成为交替字符串（相邻字符不同）的最少操作数。""",
        function="minOperations",
        params=[("s", "string")],
        returns="int",
        solver=min_operations_alternating,
        public=[["0100"], ["10"], ["1111"]],
        hidden=[["0"], ["1"], ["01"], ["00"], ["1010"], ["010101"]],
    ),
    make(
        pid=1318,
        title="最小操作次数使数组元素相等",
        tags=["数组", "数学"],
        description="""每次操作将数组中恰好 n - 1 个元素各加 1。
返回使所有元素相等所需的最少操作次数。""",
        function="minMoves",
        params=[("nums", "int[]")],
        returns="int",
        solver=lambda nums: sum(nums) - len(nums) * min(nums),
        public=[[[1, 2, 3]], [[1, 1, 1]], [[1, 2, 3, 4]]],
        hidden=[[[5]], [[1, 5]], [[2, 2, 2]], [[10, 1, 1, 1]]],
    ),
    make(
        pid=1319,
        title="寻找数组的中心下标",
        tags=["数组", "前缀和"],
        description="""中心下标 i 满足左侧所有元素之和等于右侧所有元素之和。
下标 0 的左侧和为 0，下标 n - 1 的右侧和为 0。返回最左边的中心下标；不存在返回 -1。""",
        function="pivotIndex",
        params=[("nums", "int[]")],
        returns="int",
        solver=pivot_index,
        public=[[[1, 7, 3, 6, 5, 6]], [[1, 2, 3]], [[2, 1, -1]]],
        hidden=[[[1]], [[0, 0]], [[1, 1]], [[-1, -1, -1]], [[2, 3, -5]]],
    ),
    make(
        pid=1320,
        title="找到最高海拔",
        tags=["数组", "前缀和"],
        description="""骑行者从海拔 0 出发，gain[i] 表示从第 i 个点到第 i + 1 个点的海拔净变化。
返回骑行过程中到达的最高海拔。""",
        function="largestAltitude",
        params=[("gain", "int[]")],
        returns="int",
        solver=largest_altitude,
        public=[[[-5, 1, 5, 0, -7]], [[-4, -3, -2, -1, 4, 3, 2]], [[0]]],
        hidden=[[[1]], [[-1]], [[5, -5]], [[1, 2, 3]], [[-5, -4, -3]]],
    ),
    make(
        pid=1321,
        title="唯一元素的和",
        tags=["数组", "哈希表"],
        description="""返回数组 nums 中所有只出现一次的元素之和。""",
        function="sumOfUnique",
        params=[("nums", "int[]")],
        returns="int",
        solver=lambda nums: sum(
            value for value, count in Counter(nums).items() if count == 1
        ),
        public=[[[1, 2, 3, 2]], [[1, 1, 1, 1, 1]], [[1, 2, 3, 4, 5]]],
        hidden=[[[1]], [[1, 1, 2]], [[-1, -1, -2, -3]], [[0, 0, 1]]],
    ),
    make(
        pid=1322,
        title="判定字符是否唯一",
        tags=["字符串", "位运算"],
        description="""给定只含小写字母的字符串 astr，判断其中是否有重复字符。""",
        function="isUnique",
        params=[("astr", "string")],
        returns="bool",
        solver=lambda astr: len(set(astr)) == len(astr),
        public=[["leetcode"], ["abc"], ["aab"]],
        hidden=[["a"], ["aa"], ["abcdefghijklmnopqrstuvwxyz"], ["zyx"]],
    ),
    make(
        pid=1323,
        title="配对交换",
        tags=["位运算"],
        description="""给定非负整数 num，交换其二进制表示中相邻的奇偶位：
第 0 位与第 1 位交换，第 2 位与第 3 位交换，依此类推。返回交换后的整数。""",
        function="exchangeBits",
        params=[("num", "int")],
        returns="int",
        solver=exchange_bits,
        public=[[2], [3], [1]],
        hidden=[[0], [5], [10], [7], [1073741823]],
    ),
    make(
        pid=1324,
        title="独特的电子邮件地址",
        tags=["字符串", "哈希表"],
        description="""每个邮箱由本地名和域名组成，用 '@' 分隔。
本地名中的 '.' 会被忽略，第一个 '+' 及其后的内容也会被忽略；域名保持不变。
返回不同实际收件地址的数量。""",
        function="numUniqueEmails",
        params=[("emails", "string[]")],
        returns="int",
        solver=num_unique_emails,
        public=[
            [["test.email+alex@leetcode.com", "test.e.mail+bob.cathy@leetcode.com", "testemail+david@lee.tcode.com"]],
            [["a@b.com"]],
            [["a+b@c.com", "a@c.com"]],
        ],
        hidden=[[["a.b@c.com", "ab@c.com"]], [["a+x@d.com", "a+y@d.com"]], [["a@x.com", "a@y.com"]]],
    ),
    make(
        pid=1325,
        title="山羊拉丁文",
        tags=["字符串"],
        description="""给定由空格分隔单词组成的句子。对第 i 个单词（从 1 开始）：
若以元音字母开头，在末尾加 "ma"；否则把首字母移到末尾再加 "ma"；
最后再加 i 个 'a'。返回转换后的句子。""",
        function="toGoatLatin",
        params=[("sentence", "string")],
        returns="string",
        solver=to_goat_latin,
        public=[["I speak Goat Latin"], ["The quick brown fox jumped over the lazy dog"]],
        hidden=[["a"], ["z"], ["apple orange"], ["Hello World"]],
    ),
    make(
        pid=1326,
        title="缀点成线",
        tags=["数组", "数学"],
        description="""给定按 x 坐标升序排列的点坐标数组 coordinates，判断所有点是否在同一条直线上。""",
        function="checkStraightLine",
        params=[("coordinates", "int[][]")],
        returns="bool",
        solver=check_straight_line,
        public=[
            [[[1, 1], [2, 2], [3, 3]]],
            [[[1, 1], [2, 2], [3, 4]]],
            [[[0, 0], [0, 1], [0, 5]]],
        ],
        hidden=[
            [[[1, 2], [2, 3], [3, 4], [4, 5]]],
            [[[0, 1], [1, 3], [2, 5]]],
            [[[1, 1], [1, 2]]],
            [[[-2, -1], [0, 0]]],
        ],
    ),
    make(
        pid=1327,
        title="检查数组是否经排序和轮转得到",
        tags=["数组"],
        description="""给定数组 nums，判断它是否能由非递减数组经过若干次循环右移得到。""",
        function="check",
        params=[("nums", "int[]")],
        returns="bool",
        solver=check_rotated_sorted,
        public=[[[3, 4, 5, 1, 2]], [[2, 1, 3, 4]], [[1, 2, 3]], [[1, 1, 1]]],
        hidden=[[[1]], [[2, 1]], [[1, 2]], [[2, 2, 1, 1]], [[3, 1, 2]], [[1, 3, 2]]],
    ),
    make(
        pid=1328,
        title="K 进制表示下的各位数字总和",
        tags=["数学"],
        description="""给定整数 n 和进制 k（2 <= k <= 10），返回 n 在 k 进制表示下各位数字之和。""",
        function="sumBase",
        params=[("n", "int"), ("k", "int")],
        returns="int",
        solver=sum_base,
        public=[[34, 6], [10, 10], [1, 2]],
        hidden=[[100, 10], [255, 2], [999, 9], [7, 3]],
    ),
    make(
        pid=1329,
        title="统计位数为偶数的数字",
        tags=["数组", "数学"],
        description="""返回数组 nums 中十进制位数为偶数的元素个数。所有元素均为正整数。""",
        function="findNumbers",
        params=[("nums", "int[]")],
        returns="int",
        solver=lambda nums: sum(len(str(value)) % 2 == 0 for value in nums),
        public=[[[12, 345, 2, 6, 7896]], [[555, 901, 482, 1771]], [[1, 2, 3]]],
        hidden=[[[10]], [[9]], [[10, 100, 1000, 10000]], [[99999, 100000]]],
    ),
    make(
        pid=1330,
        title="数组序号转换",
        tags=["数组", "排序", "哈希表"],
        description="""将 arr 中每个元素替换为它的排名。排名从 1 开始，按元素值升序分配，
相同元素排名相同。返回转换后的数组。""",
        function="arrayRankTransform",
        params=[("arr", "int[]")],
        returns="int[]",
        solver=array_rank_transform,
        public=[[[40, 10, 20, 30]], [[100, 100, 100]], [[37, 12, 28, 9, 100, 56, 80, 5, 12]]],
        hidden=[[[1]], [[2, 1]], [[5, 5, 1]], [[-1, 0, 1]]],
    ),
    make(
        pid=1331,
        title="差的绝对值为 K 的数对数目",
        tags=["数组", "哈希表"],
        description="""返回满足 i < j 且 |nums[i] - nums[j]| == k 的数对数目。""",
        function="countKDifference",
        params=[("nums", "int[]"), ("k", "int")],
        returns="int",
        solver=count_k_difference,
        public=[[[1, 2, 2, 1], 1], [[1, 3], 3], [[3, 2, 1, 5, 4], 2]],
        hidden=[[[1], 0], [[1, 1], 0], [[1, 2, 3], 1], [[-1, -2], 1], [[1, 1, 1], 0]],
    ),
    make(
        pid=1332,
        title="找出井字棋的获胜者",
        tags=["数组", "模拟"],
        description="""A 和 B 轮流在 3 x 3 棋盘上落子，A 先手。moves[i] = [row, col] 表示第 i 步的位置。
若有人获胜，返回 "A" 或 "B"；无人获胜且棋盘已满返回 "Draw"；否则返回 "Pending"。""",
        function="tictactoe",
        params=[("moves", "int[][]")],
        returns="string",
        solver=tictactoe,
        public=[
            [[[0, 0], [2, 0], [1, 1], [2, 1], [2, 2]]],
            [[[0, 0], [1, 1], [0, 1], [0, 2], [1, 0], [2, 0]]],
            [[[0, 0], [1, 1], [2, 0], [1, 0], [1, 2], [2, 1], [0, 1], [2, 2], [0, 2]]],
        ],
        hidden=[
            [[[0, 0], [1, 1]]],
            [[[0, 0], [0, 1], [0, 2]]],
            [[[0, 0], [1, 1], [2, 2]]],
        ],
    ),
    make(
        pid=1333,
        title="矩阵中战斗力最弱的 K 行",
        tags=["数组", "矩阵", "排序"],
        description="""矩阵 mat 中 1 表示士兵、0 表示平民，行的战斗力为士兵数量。
按战斗力升序返回最弱的 k 行的下标；战斗力相同按下标升序。""",
        function="kWeakestRows",
        params=[("mat", "int[][]"), ("k", "int")],
        returns="int[]",
        solver=k_weakest_rows,
        public=[[[[1, 1, 0, 0, 0], [1, 1, 1, 1, 0], [1, 0, 0, 0, 0], [1, 1, 0, 0, 0], [1, 1, 1, 1, 1]], 3]],
        hidden=[
            [[[1, 0, 0, 0], [1, 1, 1, 1], [1, 0, 0, 0], [1, 0, 0, 0]], 2],
            [[[1, 1], [1, 0], [0, 0]], 2],
        ],
    ),
    make(
        pid=1334,
        title="按既定顺序创建目标数组",
        tags=["数组", "模拟"],
        description="""初始目标数组为空。按顺序处理每个下标 i：将 nums[i] 插入到 index[i] 处。
返回最终的目标数组。""",
        function="createTargetArray",
        params=[("nums", "int[]"), ("index", "int[]")],
        returns="int[]",
        solver=create_target_array,
        public=[
            [[0, 1, 2, 3, 4], [0, 1, 2, 2, 1]],
            [[1, 2, 3, 4, 0], [0, 1, 2, 3, 0]],
            [[1], [0]],
        ],
        hidden=[[[1, 2], [0, 1]], [[1, 2, 3], [0, 0, 0]], [[5, 4, 3], [2, 1, 0]]],
    ),
    make(
        pid=1335,
        title="将数字变成 0 的操作次数",
        tags=["数学", "位运算"],
        description="""若 num 为偶数，将其除以 2；若为奇数，将其减 1。返回将 num 变成 0 所需的最少操作次数。
给定 0 <= num <= 10^6。""",
        function="numberOfSteps",
        params=[("num", "int")],
        returns="int",
        solver=number_of_steps,
        public=[[14], [8], [123]],
        hidden=[[0], [1], [2], [3], [1000000]],
    ),
    make(
        pid=1336,
        title="根据数字二进制下 1 的数目排序",
        tags=["数组", "位运算", "排序"],
        description="""按二进制表示中 1 的个数升序排序数组 arr；个数相同按数值升序。
返回排序后的数组。""",
        function="sortByBits",
        params=[("arr", "int[]")],
        returns="int[]",
        solver=lambda arr: sorted(arr, key=lambda value: (value.bit_count(), value)),
        public=[
            [[0, 1, 2, 3, 4, 5, 6, 7, 8]],
            [[1024, 512, 256, 128, 64, 32, 16, 8, 4, 2, 1]],
            [[10000, 10000]],
        ],
        hidden=[[[1]], [[2, 3]], [[7, 8]], [[0, 1, 2]]],
    ),
    make(
        pid=1337,
        title="最富有客户的资产总量",
        tags=["数组", "矩阵"],
        description="""accounts[i][j] 表示第 i 位客户在第 j 家银行的资产。
返回所有客户中资产总量最大的值。""",
        function="maximumWealth",
        params=[("accounts", "int[][]")],
        returns="int",
        solver=lambda accounts: max(sum(row) for row in accounts),
        public=[
            [[[1, 2, 3], [3, 2, 1]]],
            [[[1, 5], [7, 3], [3, 5]]],
            [[[2, 8, 7], [7, 1, 3], [1, 9, 5]]],
        ],
        hidden=[[[[0]]], [[[1, 2], [3, 4]]], [[[5, 5], [5, 5]]]],
    ),
]
