"""1938-1974：批量第四批简单题（37 道）。"""

from __future__ import annotations

from collections import Counter
from functools import partial
from math import gcd, isqrt

from problem_seed_common import make_problem, tree_from_list

make = partial(make_problem, difficulty="easy")


# ── 链表 ──────────────────────────────────────────────────────────


def game_result(head: list[int]) -> str:
    even_sum = sum(value for index, value in enumerate(head) if index % 2 == 0)
    odd_sum = sum(value for index, value in enumerate(head) if index % 2 == 1)
    if even_sum > odd_sum:
        return "Even"
    if odd_sum > even_sum:
        return "Odd"
    return "Tie"


def delete_middle(head: list[int]) -> list[int]:
    middle = len(head) // 2
    return head[:middle] + head[middle + 1 :]


# ── 栈 / 队列 ─────────────────────────────────────────────────────


def min_length_after_removal(s: str) -> int:
    stack: list[str] = []
    for character in s:
        if stack and (
            (stack[-1] == "A" and character == "B")
            or (stack[-1] == "C" and character == "D")
        ):
            stack.pop()
        else:
            stack.append(character)
    return len(stack)


def build_array(target: list[int], n: int) -> list[str]:
    target_set = set(target)
    operations: list[str] = []
    for value in range(1, n + 1):
        operations.append("Push")
        if value not in target_set:
            operations.append("Pop")
        if value == target[-1]:
            break
    return operations


def remove_stars(s: str) -> str:
    stack: list[str] = []
    for character in s:
        if character == "*":
            if stack:
                stack.pop()
        else:
            stack.append(character)
    return "".join(stack)


def clear_digits(s: str) -> str:
    stack: list[str] = []
    for character in s:
        if character.isdigit():
            if stack:
                stack.pop()
        else:
            stack.append(character)
    return "".join(stack)


def recent_counter(pings: list[int]) -> list[int]:
    from collections import deque

    queue: deque[int] = deque()
    result: list[int] = []
    for ping in pings:
        queue.append(ping)
        while queue[0] < ping - 3000:
            queue.popleft()
        result.append(len(queue))
    return result


def find_the_winner(n: int, k: int) -> int:
    friends = list(range(1, n + 1))
    index = 0
    while len(friends) > 1:
        index = (index + k - 1) % len(friends)
        friends.pop(index)
    return friends[0]


# ── 二叉树 ────────────────────────────────────────────────────────


def find_target(root: list[int | None], k: int) -> bool:
    node = tree_from_list(root)
    seen: set[int] = set()

    def visit(current: object | None) -> bool:
        if current is None:
            return False
        if k - current.value in seen:
            return True
        seen.add(current.value)
        return visit(current.left) or visit(current.right)

    return visit(node)


def find_bottom_left_value(root: list[int | None]) -> int:
    from collections import deque

    node = tree_from_list(root)
    if node is None:
        return 0
    answer = node.value
    queue: deque[object] = deque([node])
    while queue:
        answer = queue[0].value
        for _ in range(len(queue)):
            current = queue.popleft()
            if current.left is not None:
                queue.append(current.left)
            if current.right is not None:
                queue.append(current.right)
    return answer


def kth_largest_level_sum(root: list[int | None], k: int) -> int:
    from collections import deque

    node = tree_from_list(root)
    if node is None:
        return -1
    sums: list[int] = []
    queue: deque[object] = deque([node])
    while queue:
        level_sum = 0
        for _ in range(len(queue)):
            current = queue.popleft()
            level_sum += current.value
            if current.left is not None:
                queue.append(current.left)
            if current.right is not None:
                queue.append(current.right)
        sums.append(level_sum)
    if k > len(sums):
        return -1
    sums.sort(reverse=True)
    return sums[k - 1]


# ── 数学 ──────────────────────────────────────────────────────────


def is_perfect_square(num: int) -> bool:
    root = isqrt(num)
    return root * root == num


def arrange_coins(n: int) -> int:
    low, high = 0, n
    while low < high:
        middle = (low + high + 1) // 2
        if middle * (middle + 1) // 2 <= n:
            low = middle
        else:
            high = middle - 1
    return low


def max_count(m: int, n: int, ops: list[list[int]]) -> int:
    if not ops:
        return m * n
    return min(row for row, _ in ops) * min(column for _, column in ops)


def difference_of_sum(nums: list[int]) -> int:
    element_sum = sum(nums)
    digit_sum = sum(int(digit) for value in nums for digit in str(value))
    return abs(element_sum - digit_sum)


def alternate_digit_sum(n: int) -> int:
    total = 0
    for index, digit in enumerate(str(n)):
        total += int(digit) if index % 2 == 0 else -int(digit)
    return total


def common_factors(a: int, b: int) -> int:
    common = gcd(a, b)
    count = 0
    for value in range(1, isqrt(common) + 1):
        if common % value == 0:
            count += 1 if value * value == common else 2
    return count


def sum_of_the_digits_of_harshad_number(x: int) -> int:
    digit_sum = sum(int(digit) for digit in str(x))
    return digit_sum if x % digit_sum == 0 else -1


def count_operations(num1: int, num2: int) -> int:
    operations = 0
    while num1 > 0 and num2 > 0:
        if num1 >= num2:
            num1 -= num2
        else:
            num2 -= num1
        operations += 1
    return operations


def pivot_integer(n: int) -> int:
    total = n * (n + 1) // 2
    value = isqrt(total)
    if value * value == total and 1 <= value <= n:
        return value
    return -1


def pass_the_pillow(n: int, time: int) -> int:
    if n == 1:
        return 1
    position = time % (2 * (n - 1))
    if position < n:
        return position + 1
    return 2 * n - 1 - position


def max_height_of_triangle(red: int, blue: int) -> int:
    def rows(first: int, second: int) -> int:
        height = 0
        while True:
            need = height + 1
            if height % 2 == 0:
                if first < need:
                    break
                first -= need
            else:
                if second < need:
                    break
                second -= need
            height += 1
        return height

    return max(rows(red, blue), rows(blue, red))


# ── 贪心 ──────────────────────────────────────────────────────────


def largest_sum_after_k_negations(nums: list[int], k: int) -> int:
    ordered = sorted(nums, key=abs, reverse=True)
    for index, value in enumerate(ordered):
        if k > 0 and value < 0:
            ordered[index] = -value
            k -= 1
    if k % 2 == 1:
        ordered[-1] = -ordered[-1]
    return sum(ordered)


def max_distance(colors: list[int]) -> int:
    answer = 0
    for left in range(len(colors)):
        for right in range(len(colors) - 1, left, -1):
            if colors[left] != colors[right]:
                answer = max(answer, right - left)
                break
    return answer


def minimum_moves(s: str) -> int:
    index = 0
    moves = 0
    while index < len(s):
        if s[index] == "X":
            moves += 1
            index += 3
        else:
            index += 1
    return moves


def min_number_of_hours(
    initial_energy: int,
    initial_experience: int,
    energy: list[int],
    experience: list[int],
) -> int:
    hours = max(0, sum(energy) + 1 - initial_energy)
    current_experience = initial_experience
    for need in experience:
        if current_experience <= need:
            hours += need + 1 - current_experience
            current_experience = need + 1
        current_experience += need
    return hours


def largest_odd_number(num: str) -> str:
    end = len(num) - 1
    while end >= 0 and int(num[end]) % 2 == 0:
        end -= 1
    return num[: end + 1]


def minimum_sum(num: int) -> int:
    digits = sorted(int(digit) for digit in str(num))
    return (digits[0] * 10 + digits[2]) + (digits[1] * 10 + digits[3])


def min_time_to_type(word: str) -> int:
    position = 0
    total = 0
    for character in word:
        target = ord(character) - ord("a")
        distance = abs(target - position)
        total += min(distance, 26 - distance) + 1
        position = target
    return total


def k_items_with_maximum_sum(
    num_ones: int, num_zeros: int, num_neg_ones: int, k: int
) -> int:
    return min(k, num_ones) - max(0, k - num_ones - num_zeros)


# ── 位运算 ────────────────────────────────────────────────────────


def even_odd_bit(n: int) -> list[int]:
    even = odd = 0
    index = 0
    while n:
        if n & 1:
            if index % 2 == 0:
                even += 1
            else:
                odd += 1
        n >>= 1
        index += 1
    return [even, odd]


def duplicate_numbers_xor(nums: list[int]) -> int:
    result = 0
    for value, count in Counter(nums).items():
        if count == 2:
            result ^= value
    return result


def min_changes(n: int, k: int) -> int:
    if n & k != k:
        return -1
    return (n & ~k).bit_count()


def smallest_number(n: int) -> int:
    return (1 << n.bit_length()) - 1


def find_k_or(nums: list[int], k: int) -> int:
    result = 0
    for bit in range(32):
        count = sum((value >> bit) & 1 for value in nums)
        if count >= k:
            result |= 1 << bit
    return result


def sum_indices_with_k_set_bits(nums: list[int], k: int) -> int:
    return sum(
        value for index, value in enumerate(nums) if index.bit_count() == k
    )


def maximum_odd_binary_number(s: str) -> str:
    ones = s.count("1")
    zeros = len(s) - ones
    return "1" * (ones - 1) + "0" * zeros + "1"


PROBLEMS = [
    make(
        pid=1938,
        title="链表游戏的获胜者",
        tags=["链表"],
        description="""给定一个节点个数为偶数的单链表，节点值均为正整数。
从 0 开始编号，将偶数下标节点的值之和记为 evenSum，奇数下标节点的值之和记为 oddSum。
若 evenSum 大于 oddSum，返回 "Even"，若 oddSum 大于 evenSum 返回 "Odd"，两者相等返回 "Tie"。""",
        function="gameResult",
        params=[("head", "ListNode")],
        returns="string",
        solver=game_result,
        public=[[[2, 1]], [[4, 5, 2, 1]], [[1, 2, 3, 4]]],
        hidden=[
            [[1, 1]],
            [[5, 2, 3, 4]],
            [[1, 2, 3, 4, 5, 6]],
            [[10, 1, 1, 10]],
            [[3, 9, 2, 8]],
        ],
    ),
    make(
        pid=1939,
        title="删除链表的中间节点",
        tags=["链表", "双指针"],
        description="""给定一个单链表，删除它的中间节点并返回新的头节点。
若有偶数个节点，中间节点为下标 n / 2 的节点（下标从 0 开始，向下取整）。
只有一个节点时，删除后返回空链表。""",
        function="deleteMiddle",
        params=[("head", "ListNode")],
        returns="ListNode",
        solver=delete_middle,
        public=[
            [[1, 3, 4, 7, 1, 2, 6]],
            [[1, 2, 3, 4]],
            [[2, 1]],
        ],
        hidden=[
            [[1]],
            [[1, 2]],
            [[1, 2, 3]],
            [[5, 4, 3, 2, 1]],
            [[1, 2, 3, 4, 5, 6]],
        ],
    ),
    make(
        pid=1940,
        title="删除子串后的字符串最小长度",
        tags=["字符串", "栈"],
        description="""给定只含大写字母的字符串 s。
重复执行操作：删除任意一个子串 "AB" 或 "CD"，直到无法继续删除。
返回最终字符串可能的最小长度。""",
        function="minLength",
        params=[("s", "string")],
        returns="int",
        solver=min_length_after_removal,
        public=[["ABFCACDB"], ["ACBBD"], ["AB"], ["CD"]],
        hidden=[["A"], ["ACB"], ["ABCD"], ["AABB"], ["CABD"], ["ABCABC"]],
    ),
    make(
        pid=1941,
        title="用栈操作构建数组",
        tags=["数组", "栈"],
        description="""给定严格递增的整数数组 target 和整数 n，target 中元素都在 1 到 n 之间。
从 1 到 n 依次处理每个数字：先执行一次 "Push"；若该数字不在 target 中，
紧接着执行一次 "Pop" 把它弹出；否则保留在栈中。
当 target 中最后一个数字已经保留在栈中时立即停止。
返回得到的操作序列，顺序与原操作顺序一致。""",
        function="buildArray",
        params=[("target", "int[]"), ("n", "int")],
        returns="string[]",
        solver=build_array,
        public=[[[1, 3], 3], [[1, 2, 3], 3], [[2, 3, 4], 4]],
        hidden=[[[1], 1], [[2], 2], [[1, 4], 4], [[3, 5], 5], [[2, 6], 6]],
    ),
    make(
        pid=1942,
        title="从字符串中移除星号",
        tags=["字符串", "栈"],
        description="""给定字符串 s，其中 '*' 表示删除操作：移除它左侧最近的一个非星号字符。
若当前 '*' 左侧没有可删除的字符，则该操作不产生额外影响。
返回执行完所有删除后的字符串。""",
        function="removeStars",
        params=[("s", "string")],
        returns="string",
        solver=remove_stars,
        public=[["leet**cod*e"], ["erase*****"], ["a*b*c*"]],
        hidden=[["*"], ["abc"], ["a**b"], ["ab*c*"], ["z*"]],
    ),
    make(
        pid=1943,
        title="清除数字",
        tags=["字符串", "栈"],
        description="""给定一个字符串 s，其中可能包含小写字母和数字。
每次删除一个数字字符以及它左侧最近的一个非数字字符，重复直到字符串中没有数字。
返回最终字符串。若某次删除时左侧没有非数字字符，则只删除该数字。""",
        function="clearDigits",
        params=[("s", "string")],
        returns="string",
        solver=clear_digits,
        public=[["cb34"], ["a1b2"], ["abc"]],
        hidden=[["1"], ["ab2c3"], ["a1b2c3"], ["xy9"], ["a1"]],
    ),
    make(
        pid=1944,
        title="最近的请求次数",
        tags=["队列", "设计"],
        description="""给定一个严格递增的整数数组 pings，每个元素表示一次请求发生的毫秒时间。
对每一次请求 t，统计闭区间 [t - 3000, t] 内发生的请求总数（包含当前请求）。
返回与 pings 等长的数组，第 i 个元素对应第 i 次请求时的统计结果。""",
        function="recentCounter",
        params=[("pings", "int[]")],
        returns="int[]",
        solver=recent_counter,
        public=[[[1, 100, 3001, 3002]], [[1, 2, 3, 4]], [[642, 1849, 4921, 5936, 5957]]],
        hidden=[
            [[1]],
            [[1, 3001]],
            [[5000, 5001, 5002]],
            [[1, 100, 200, 300, 4000]],
            [[0, 3000, 3001]],
        ],
    ),
    make(
        pid=1945,
        title="找出游戏的获胜者",
        tags=["队列", "数学", "模拟"],
        description="""n 个朋友围成一圈，编号从 1 到 n。从编号 1 开始报数，报到 k 的人出圈，
下一个人重新从 1 开始报数，如此重复，直到只剩一个人。
返回最后剩下的那个人的编号。""",
        function="findTheWinner",
        params=[("n", "int"), ("k", "int")],
        returns="int",
        solver=find_the_winner,
        public=[[5, 2], [6, 5], [1, 1]],
        hidden=[[2, 1], [3, 2], [5, 3], [10, 4], [7, 7]],
    ),
    make(
        pid=1946,
        title="两数之和 IV - 输入 BST",
        tags=["树", "二叉搜索树", "哈希表"],
        description="""给定一棵二叉搜索树的层序遍历序列 root（None 表示空位）和整数 k。
判断树中是否存在两个不同节点，它们的值之和恰好等于 k。""",
        function="findTarget",
        params=[("root", "TreeNode"), ("k", "int")],
        returns="bool",
        solver=find_target,
        public=[
            [[5, 3, 6, 2, 4, None, 7], 9],
            [[5, 3, 6, 2, 4, None, 7], 28],
            [[2, 1, 3], 4],
        ],
        hidden=[
            [[1], 2],
            [[2, 1, 3], 3],
            [[2, 1, 3], 5],
            [[5, 3, 6, 2, 4, None, 7], 10],
            [[1, None, 2], 3],
        ],
    ),
    make(
        pid=1947,
        title="找树左下角的值",
        tags=["树", "广度优先搜索"],
        description="""给定一棵二叉树的层序遍历序列 root（None 表示空位）。
返回该树最底层最左边节点的值。""",
        function="findBottomLeftValue",
        params=[("root", "TreeNode")],
        returns="int",
        solver=find_bottom_left_value,
        public=[
            [[2, 1, 3]],
            [[1, 2, 3, 4, None, 5, 6, None, None, 7]],
            [[1]],
        ],
        hidden=[
            [[1, 2]],
            [[1, None, 2]],
            [[0, None, 1]],
            [[3, 1, 5, 0, 2, 4, 6]],
            [[1, 2, 3, 4]],
        ],
    ),
    make(
        pid=1948,
        title="二叉树中的第 K 大层和",
        tags=["树", "广度优先搜索", "排序"],
        description="""给定一棵二叉树的层序遍历序列 root（None 表示空位）和整数 k。
每一层的层和是该层所有节点值之和。将所有层和按从大到小排序，
返回第 k 大的层和；若树的层数少于 k，返回 -1。""",
        function="kthLargestLevelSum",
        params=[("root", "TreeNode"), ("k", "int")],
        returns="long",
        solver=kth_largest_level_sum,
        public=[
            [[5, 8, 9, 2, 1, 3, 7, 4, 6], 2],
            [[1, 2, None, 3], 1],
            [[1], 1],
        ],
        hidden=[
            [[1, 2, 3], 3],
            [[1, 2, 3], 4],
            [[1, 2, None, 3], 2],
            [[2, 3, 4, 1, 5, 6, 7], 4],
            [[10, 5, 15], 2],
        ],
    ),
    make(
        pid=1949,
        title="有效的完全平方数",
        tags=["数学", "二分查找"],
        description="""给定正整数 num，判断它是否是完全平方数。
完全平方数是指可以写成某个整数平方的数。""",
        function="isPerfectSquare",
        params=[("num", "int")],
        returns="bool",
        solver=is_perfect_square,
        public=[[16], [14], [1]],
        hidden=[[2], [9], [100], [2147395600], [808201]],
    ),
    make(
        pid=1950,
        title="排列硬币",
        tags=["数学", "二分查找"],
        description="""有 n 枚硬币，按第 1 行 1 枚、第 2 行 2 枚、第 3 行 3 枚的方式排列。
每一行都必须放满硬币，最后一行可能不满。返回可以形成的完整行数。""",
        function="arrangeCoins",
        params=[("n", "int")],
        returns="int",
        solver=arrange_coins,
        public=[[5], [8], [1]],
        hidden=[[2], [3], [6], [10], [2147483647]],
    ),
    make(
        pid=1951,
        title="范围求和 II",
        tags=["数组", "数学"],
        description="""给定 m 行 n 列的矩阵，初始所有元素为 0。
依次执行操作 ops[i] = [a, b]：将前 a 行、前 b 列的所有元素加 1。
返回执行完所有操作后矩阵中最大元素的个数。""",
        function="maxCount",
        params=[("m", "int"), ("n", "int"), ("ops", "int[][]")],
        returns="int",
        solver=max_count,
        public=[
            [3, 3, [[2, 2], [3, 3]]],
            [3, 3, [[2, 2], [3, 3], [3, 3], [3, 3], [3, 3], [3, 3]]],
            [3, 3, []],
        ],
        hidden=[
            [1, 1, []],
            [2, 2, [[1, 1]]],
            [3, 4, [[2, 3]]],
            [5, 5, [[5, 5]]],
            [4, 3, [[4, 2], [2, 3]]],
        ],
    ),
    make(
        pid=1952,
        title="数组元素和与数字和的绝对差",
        tags=["数组", "数学"],
        description="""给定正整数数组 nums。
元素和是指数组中所有元素之和；数字和是指所有元素十进制表示中各位数字之和。
返回元素和与数字和的绝对差。""",
        function="differenceOfSum",
        params=[("nums", "int[]")],
        returns="int",
        solver=difference_of_sum,
        public=[[[1, 15, 6, 3]], [[1, 2, 3, 4]], [[5, 10, 20]]],
        hidden=[[[1]], [[10]], [[99]], [[100, 200]], [[12, 34]]],
    ),
    make(
        pid=1953,
        title="交替数字和",
        tags=["数学", "模拟"],
        description="""给定一个正整数 n。
从最高位开始，把各位数字按加、减、加、减的顺序交替求和（最高位取加号）。
返回最终的交替数字和。""",
        function="alternateDigitSum",
        params=[("n", "int")],
        returns="int",
        solver=alternate_digit_sum,
        public=[[521], [111], [886996]],
        hidden=[[1], [10], [99], [12345], [900000]],
    ),
    make(
        pid=1954,
        title="公因子的数目",
        tags=["数学", "数论"],
        description="""给定两个正整数 a 和 b。
返回同时整除 a 和 b 的正整数（即它们的公因子）的数目。""",
        function="commonFactors",
        params=[("a", "int"), ("b", "int")],
        returns="int",
        solver=common_factors,
        public=[[12, 6], [25, 30], [8, 8]],
        hidden=[[1, 1], [2, 3], [12, 18], [100, 75], [7, 13], [24, 36]],
    ),
    make(
        pid=1955,
        title="哈沙德数",
        tags=["数学"],
        description="""给定一个正整数 x。
若 x 能被它的各位数字之和整除，则称 x 是哈沙德数，返回它的各位数字之和；
否则返回 -1。""",
        function="sumOfTheDigitsOfHarshadNumber",
        params=[("x", "int")],
        returns="int",
        solver=sum_of_the_digits_of_harshad_number,
        public=[[18], [23], [1]],
        hidden=[[10], [12], [100], [99], [999]],
    ),
    make(
        pid=1956,
        title="得到 0 的操作数",
        tags=["数学", "模拟"],
        description="""给定两个非负整数 num1 和 num2。
每次操作从较大的数中减去较小的数；若两数相等，则任选一个减去另一个。
当其中一个数变为 0 时停止。返回执行的操作次数。""",
        function="countOperations",
        params=[("num1", "int"), ("num2", "int")],
        returns="int",
        solver=count_operations,
        public=[[2, 3], [10, 10], [0, 5]],
        hidden=[[1, 1], [0, 0], [5, 0], [7, 3], [12, 8], [9, 6]],
    ),
    make(
        pid=1957,
        title="找出中枢整数",
        tags=["数学", "前缀和"],
        description="""给定正整数 n，寻找一个整数 x（1 <= x <= n），使得
1 + 2 + ... + x 等于 x + (x + 1) + ... + n。
若存在这样的 x 则返回它，否则返回 -1。""",
        function="pivotInteger",
        params=[("n", "int")],
        returns="int",
        solver=pivot_integer,
        public=[[8], [1], [4]],
        hidden=[[2], [3], [49], [5], [1000]],
    ),
    make(
        pid=1958,
        title="递枕头",
        tags=["数学", "模拟"],
        description="""n 个人站成一排，编号从 1 到 n。枕头最初在编号 1 的人手中。
每一秒，持枕者把枕头传给相邻的人；传到两端后方向反转。
给定时间 time（秒），返回 time 秒后持有枕头的人的编号。""",
        function="passThePillow",
        params=[("n", "int"), ("time", "int")],
        returns="int",
        solver=pass_the_pillow,
        public=[[4, 5], [3, 2], [2, 1]],
        hidden=[[1, 0], [1, 1000], [2, 2], [3, 5], [5, 6]],
    ),
    make(
        pid=1959,
        title="三角形的最大高度",
        tags=["数学", "枚举"],
        description="""给定红色球 red 个、蓝色球 blue 个。
从第 1 行开始逐行堆叠三角形，第 i 行需要 i 个球，且相邻两行必须使用不同颜色。
可以选择第一行使用红色或蓝色。返回最多可以堆叠的行数。""",
        function="maxHeightOfTriangle",
        params=[("red", "int"), ("blue", "int")],
        returns="int",
        solver=max_height_of_triangle,
        public=[[2, 4], [2, 1], [1, 1], [10, 1]],
        hidden=[[1, 2], [1, 10], [4, 4], [5, 5], [7, 7], [3, 3]],
    ),
    make(
        pid=1960,
        title="K 次取反后最大化的数组和",
        tags=["数组", "贪心", "排序"],
        description="""给定整数数组 nums 和整数 k。
每次操作选择数组中的一个元素并将它取反（正变负、负变正），共执行恰好 k 次。
返回执行完所有操作后数组元素之和的最大值。""",
        function="largestSumAfterKNegations",
        params=[("nums", "int[]"), ("k", "int")],
        returns="int",
        solver=largest_sum_after_k_negations,
        public=[[[4, 2, 3], 1], [[3, -1, 0, 2], 3], [[2, -3, -1, 5, -4], 2]],
        hidden=[
            [[-1, -2, -3], 1],
            [[-1, -2, -3], 2],
            [[1], 1],
            [[1], 2],
            [[-5, 5], 1],
        ],
    ),
    make(
        pid=1961,
        title="两栋颜色不同且距离最远的房子",
        tags=["数组", "贪心"],
        description="""给定整数数组 colors，colors[i] 表示第 i 栋房子的颜色。
选择两栋颜色不同的房子 i 和 j（i < j），返回 j - i 的最大值。
若不存在颜色不同的两栋房子，返回 0。""",
        function="maxDistance",
        params=[("colors", "int[]")],
        returns="int",
        solver=max_distance,
        public=[[[1, 1, 1, 6, 1, 1, 1]], [[1, 8, 3, 8, 3]], [[0, 1]]],
        hidden=[[[1, 1]], [[1, 2, 1]], [[2, 2, 2, 3]], [[4, 4, 4, 4]], [[0, 1, 0, 1, 0]]],
    ),
    make(
        pid=1962,
        title="转换字符串的最少操作次数",
        tags=["字符串", "贪心"],
        description="""给定只含 'X' 和 'O' 的字符串 s。
每次操作选择一个 'X'，把它以及它右侧至多两个相邻字符都变成 'O'；
若右侧不足两个字符，则只转换剩余字符。
返回把所有 'X' 都变成 'O' 的最少操作次数。""",
        function="minimumMoves",
        params=[("s", "string")],
        returns="int",
        solver=minimum_moves,
        public=[["XXX"], ["XXOX"], ["OOOO"]],
        hidden=[["X"], ["OXOX"], ["XX"], ["XOX"], ["XXXX"], ["OXOXX"]],
    ),
    make(
        pid=1963,
        title="赢得比赛需要的最少训练时长",
        tags=["数组", "贪心", "模拟"],
        description="""给定初始精力 initialEnergy、初始经验 initialExperience，以及按顺序挑战的 n 个对手的精力数组 energy 和经验数组 experience。
挑战第 i 个对手要求当前精力严格大于 energy[i]、当前经验严格大于 experience[i]。
每训练 1 小时可以让精力或经验增加 1，训练可以在任意对手之前进行。
击败一个对手后，当前精力减少 energy[i]，当前经验增加 experience[i]。
返回击败所有对手所需的最少训练小时数。""",
        function="minNumberOfHours",
        params=[
            ("initialEnergy", "int"),
            ("initialExperience", "int"),
            ("energy", "int[]"),
            ("experience", "int[]"),
        ],
        returns="int",
        solver=min_number_of_hours,
        public=[
            [5, 3, [1, 4, 3, 2], [2, 6, 3, 1]],
            [2, 4, [1], [3]],
            [1, 1, [1, 1, 1, 1], [1, 1, 1, 1]],
        ],
        hidden=[
            [1, 1, [1], [1]],
            [10, 10, [5, 5], [5, 5]],
            [0, 0, [1], [1]],
            [100, 100, [50, 50, 50], [20, 40, 60]],
            [3, 2, [2, 2, 2], [1, 3, 1]],
        ],
    ),
    make(
        pid=1964,
        title="字符串中的最大奇数",
        tags=["字符串", "贪心", "数学"],
        description="""给定一个表示正整数的字符串 num。
返回 num 的一个非空子串，它表示最大的奇数；若不存在奇数则返回空字符串。
子串必须由 num 中连续的一段字符组成。""",
        function="largestOddNumber",
        params=[("num", "string")],
        returns="string",
        solver=largest_odd_number,
        public=[["52"], ["4206"], ["35427"]],
        hidden=[["1"], ["2"], ["101"], ["123456"], ["24680"], ["7"]],
    ),
    make(
        pid=1965,
        title="拆分数位后四位数字的最小和",
        tags=["数学", "排序", "贪心"],
        description="""给定一个四位整数 num。
把它的四个数字重新排列，组成两个新的两位数（允许有前导零），每个数字恰好使用一次。
返回这两个两位数之和的最小值。""",
        function="minimumSum",
        params=[("num", "int")],
        returns="int",
        solver=minimum_sum,
        public=[[2932], [4009], [1000]],
        hidden=[[1111], [9999], [1234], [5000], [2020], [9876]],
    ),
    make(
        pid=1966,
        title="使用特殊打字机键入单词的最少时间",
        tags=["字符串", "贪心", "数学"],
        description="""键盘是一个圆盘，26 个小写字母按顺序围成一圈，指针最初指向 'a'。
键入一个字符需要把指针移动到该字符（顺时针或逆时针，取较近方向）并按下，共耗时 1 秒。
移动一格耗时 1 秒。返回键入整个字符串 word 所需的最少秒数。""",
        function="minTimeToType",
        params=[("word", "string")],
        returns="int",
        solver=min_time_to_type,
        public=[["abc"], ["bza"], ["zjpc"]],
        hidden=[["a"], ["z"], ["az"], ["bad"], ["leetcode"]],
    ),
    make(
        pid=1967,
        title="K 件物品的最大和",
        tags=["数学", "贪心"],
        description="""有 numOnes 件价值为 1 的物品、numZeros 件价值为 0 的物品、
numNegOnes 件价值为 -1 的物品。
从中恰好选择 k 件物品，返回可以得到的最大价值和。""",
        function="kItemsWithMaximumSum",
        params=[
            ("numOnes", "int"),
            ("numZeros", "int"),
            ("numNegOnes", "int"),
            ("k", "int"),
        ],
        returns="int",
        solver=k_items_with_maximum_sum,
        public=[[3, 2, 0, 2], [3, 2, 0, 4], [3, 2, 1, 6]],
        hidden=[[1, 0, 0, 1], [0, 1, 0, 1], [0, 0, 5, 3], [5, 0, 5, 5], [10, 10, 10, 15]],
    ),
    make(
        pid=1968,
        title="奇偶位数",
        tags=["位运算"],
        description="""给定非负整数 n，统计其二进制表示中 1 的个数。
下标从最低位（第 0 位）开始计算。返回 [even, odd]，
其中 even 是偶数下标上的 1 的个数，odd 是奇数下标上的 1 的个数。""",
        function="evenOddBit",
        params=[("n", "int")],
        returns="int[]",
        solver=even_odd_bit,
        public=[[17], [2], [7]],
        hidden=[[0], [1], [3], [10], [2147483647]],
    ),
    make(
        pid=1969,
        title="求出出现两次数字的 XOR 值",
        tags=["数组", "位运算", "哈希表"],
        description="""给定整数数组 nums，其中每个元素恰好出现一次或两次。
将所有恰好出现两次的元素进行按位异或，返回异或结果；若没有这样的元素则返回 0。""",
        function="duplicateNumbersXOR",
        params=[("nums", "int[]")],
        returns="int",
        solver=duplicate_numbers_xor,
        public=[[[1, 2, 1, 3]], [[1, 2, 3]], [[1, 1]]],
        hidden=[[[2, 2, 3, 3]], [[5]], [[4, 4, 5]], [[7, 7, 8, 8, 9]], [[10, 10, 20, 20, 30, 30]]],
    ),
    make(
        pid=1970,
        title="使两个整数相等的位更改次数",
        tags=["位运算"],
        description="""给定两个非负整数 n 和 k。
每次操作可以把 n 的二进制表示中的某一位从 1 改为 0。
若无法通过若干次操作把 n 变成 k，返回 -1；否则返回所需的最少操作次数。""",
        function="minChanges",
        params=[("n", "int"), ("k", "int")],
        returns="int",
        solver=min_changes,
        public=[[13, 4], [21, 21], [14, 13]],
        hidden=[[1, 0], [0, 0], [0, 1], [7, 7], [7, 3], [10, 8]],
    ),
    make(
        pid=1971,
        title="仅含置位位的最小整数",
        tags=["位运算", "数学"],
        description="""给定正整数 n。
返回大于等于 n 的最小整数，它的二进制表示中每一位都是 1。
例如 5 的二进制是 101，大于等于它的最小全 1 二进制数是 111，即 7。""",
        function="smallestNumber",
        params=[("n", "int")],
        returns="int",
        solver=smallest_number,
        public=[[5], [10], [1]],
        hidden=[[2], [3], [7], [8], [100], [1000]],
    ),
    make(
        pid=1972,
        title="找出数组中的 K-or 值",
        tags=["数组", "位运算"],
        description="""给定整数数组 nums 和整数 k。
对每个二进制位，若数组中至少有 k 个元素的该位为 1，则结果的该位为 1，否则为 0。
返回所有满足条件的位组成的整数。""",
        function="findKOr",
        params=[("nums", "int[]"), ("k", "int")],
        returns="int",
        solver=find_k_or,
        public=[
            [[7, 12, 9, 8, 9, 15], 4],
            [[2, 3, 4], 2],
            [[1, 2, 3], 1],
        ],
        hidden=[
            [[1], 1],
            [[1], 2],
            [[1, 1], 1],
            [[15, 15, 15], 2],
            [[1, 2, 4, 8], 1],
            [[1, 2, 4, 8], 2],
        ],
    ),
    make(
        pid=1973,
        title="计算 K 置位下标对应元素的和",
        tags=["数组", "位运算"],
        description="""给定整数数组 nums 和整数 k。
下标 i 从 0 开始，若 i 的二进制表示中恰好有 k 个 1，则把 nums[i] 加入总和。
返回所有满足条件的下标对应元素之和。""",
        function="sumIndicesWithKSetBits",
        params=[("nums", "int[]"), ("k", "int")],
        returns="int",
        solver=sum_indices_with_k_set_bits,
        public=[[[5, 10, 1, 5, 2], 1], [[4, 3, 2, 1], 2], [[1, 2, 3], 0]],
        hidden=[
            [[1], 0],
            [[1], 1],
            [[1, 2], 1],
            [[7, 7, 7, 7, 7, 7, 7], 2],
            [[0, 0, 0], 1],
        ],
    ),
    make(
        pid=1974,
        title="最大二进制奇数",
        tags=["字符串", "贪心", "位运算"],
        description="""给定一个只含 '0' 和 '1' 的字符串 s，其中至少有一个 '1'。
重新排列 s 中的字符，得到一个没有前导零的二进制数，且该数必须是奇数。
返回可以得到的最大二进制数（以字符串表示）。""",
        function="maximumOddBinaryNumber",
        params=[("s", "string")],
        returns="string",
        solver=maximum_odd_binary_number,
        public=[["010"], ["0101"], ["1"]],
        hidden=[["11"], ["1010"], ["0001"], ["111"], ["1000"]],
    ),
]
